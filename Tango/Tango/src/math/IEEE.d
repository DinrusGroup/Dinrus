/**
 * Низкоуровневые Математические Функции, пользующиеся преимуществами IEEE754 ABI.
 *
 * Copyright: Portions Copyright (C) 2001-2005 Digital Mars.
 * License:   BSD стиль: $(LICENSE), Digital Mars.
 * Authors:   Don Clugston, Walter Bright, Sean Kelly
 */
/*
 * Author:
 *  Walter Bright
 * Copyright:
 *  Copyright (c) 2001-2005 by Digital Mars,
 *  все Rights Reserved,
 *  www.digitalmars.com
 * License:
 * Данное программное обеспечение предоставляется "как есть",
 * без какой-либо явной или косвенной гарантии. 
 * Авторы ни в коем случае не несут ответственность за ущерб,
 * причинённый от использования данного ПО.
 *
 *  Любому даётся разрешение использовать из_ ПО в любых целях,
 *  включая коммерческое применение, его изменение и свободное распространение,
 *  за исключением следующих ограничений:
 *
 *  <ul>
 *  <li> Нельзя искажать источник данного программного обеспечения; либо
 *       утверждать, что вами написано оригинальное ПО. Если данное ПО используется
 *       Вами в проекте, признательность в документации к продукту будет
 *       оценена достойно, но не является обязательной.
 *  </li>
 *  <li> Измененные версии исходников должны быть отмечены как таковые, и не быть
 *       неверно представлены, как оригинальное ПО.
 *  </li>
 *  <li> Данное сообщение нельзя удалять или изменять
 *       ни в каком дистрибутиве.
 *  </li>
 *  </ul>
 */
/**
 * Macros:
 *
 *  TABLE_SV = <table border=1 cellpadding=4 cellspacing=0>
 *      <caption>Особые Значения</caption>
 *      $0</table>
 *  SVH = $(TR $(TH $1) $(TH $2))
 *  SV  = $(TR $(TD $1) $(TD $2))
 *  SVH3 = $(TR $(TH $1) $(TH $2) $(TH $3))
 *  SV3  = $(TR $(TD $1) $(TD $2) $(TD $3))
 *  NAN = $(RED NAN)
 *  PLUSMN = &plusmn;
 *  INFIN = &infin;
 *  PLUSMNINF = &plusmn;&infin;
 *  ПИ = &pi;
 *  LT = &lt;
 *  GT = &gt;
 *  SQRT = &корень;
 *  HALF = &frac12;
 */
module math.IEEE;

version(D_InlineAsm_X86) {
    version = Naked_D_InlineAsm_X86;
}

version (X86){
    version = X86_Any;
}

version (X86_64){
    version = X86_Any;
}

version (Naked_D_InlineAsm_X86) {
    import cidrus;
}


version(Windows) { 
    version(DigitalMars) { 
 	    version = DMDWindows; 
    } 
	version = ЛитлЭндиан;
}
 	
// Стандартные НЧ payloads.
// Три младших бита указывают причину НЧ:
// 0 = ошибка, иная чем указанные ниже:
// 1 = ошибка домена
// 2 = сингулярность
// 3 = диапазон
// 4-7 = резерв.
enum ДИНРУС_НЧ {
    // Общие ошибки
    ОШИБКА_ДОМЕНА = 0x0101,
    СИНГУЛЯРНОСТЬ  = 0x0102,
    ОШИБКА_ДИАПАЗОНА  = 0x0103,
    // НЧ, создаваемые функциями из базовой библиотеки
    ТАН_ДОМЕН   = 0x1001,
    СТЕПЕНЬ_ДОМЕН   = 0x1021,
    ГАММА_ДОМЕН = 0x1101,
    ГАММА_ПОЛЮС   = 0x1102,
    ЗНГАММА     = 0x1112,
    БЕТА_ДОМЕН  = 0x1131,
    // NaNs из_ статические функции
    NORMALDISTRIBUTION_INV_DOMAIN = 0x2001,
    STUDENTSDDISTRIBUTION_DOMAIN  = 0x2011
}

private:
/* Большинство функций зависимо от формата наибольшего типа с плавающей запятой IEEE.
 * Этот код отличается в зависимости от того, равен ли 'реал' 64, 80 или 128 битам,
 * и архитектуры биг-эндиан или литл-эндиан.
 * Сейчас поддерживается лишь пять ABI 'реал':
 * 64-битный биг-эндиан  'дво' (напр., PowerPC)
 * 128-битный биг-эндиан 'квадрупл' (напр., SPARC)
 * 64-битный литл-эндиан 'дво' (напр., x86-SSE2)
 * 80-битный литл-эндиан, с битом 'real80' (напр., x87, Itanium).
 * 128-битный литл-эндиан 'квадрупл' (не реализован ни на одном из известных процессоров!)
 *
 * Есть также неподдерживаемый ABI, не следующий IEEE; несколько его функций
 *  при использовании генерируют ошибки времени выполнения.
 * 128-битный биг-эндиан 'дводво' (использован GDC <= 0.23 для PowerPC)
 */


// Константы используются для удаления из представления компонентов.
// Они обеспечиваются работой встроенных свойств плавающей запятой.
template плавТрэтсИ3Е(T) {
 // МАСКА_ЭКСП - бкрат маска для выделения экспонентной части (без знака)
 // МАСКА_ЗНАКА - бкрат маска для выделения значного бита.
 // БКРАТ_ПОЗ_ЭКСП - индекс экспоненты, представленной как бкрат Массив.
 // ББАЙТ_ПОЗ_ЗНАКА - индекс знака, представленного как ббайт Массив.
 // РЕЦИП_ЭПСИЛОН - значение, когда (smallest_denormal) * РЕЦИП_ЭПСИЛОН == T.min
 const T РЕЦИП_ЭПСИЛОН = (1/T.epsilon);

 static if (T.mant_dig == 24) { // плав
    enum : бкрат {
        МАСКА_ЭКСП = 0x7F80,
        МАСКА_ЗНАКА = 0x8000,
        ЭКСПБИАС = 0x3F00
    }
    const бцел МАСКА_ЭКСП_INT = 0x7F80_0000;
    const бцел MANTISSAMASK_INT = 0x007F_FFFF;
    version(ЛитлЭндиан) {        
      const БКРАТ_ПОЗ_ЭКСП = 1;
    } else {
      const БКРАТ_ПОЗ_ЭКСП = 0;
    }
 } else static if (T.mant_dig==53) { // дво, or реал==дво
     enum : бкрат {
         МАСКА_ЭКСП = 0x7FF0,
         МАСКА_ЗНАКА = 0x8000,
         ЭКСПБИАС = 0x3FE0
    }
    const бцел МАСКА_ЭКСП_INT = 0x7FF0_0000;
    const бцел MANTISSAMASK_INT = 0x000F_FFFF; // for the MSB only
    version(ЛитлЭндиан) {
      const БКРАТ_ПОЗ_ЭКСП = 3;
      const ББАЙТ_ПОЗ_ЗНАКА = 7;
    } else {
      const БКРАТ_ПОЗ_ЭКСП = 0;
      const ББАЙТ_ПОЗ_ЗНАКА = 0;
    }
 } else static if (T.mant_dig==64) { // real80
     enum : бкрат {
         МАСКА_ЭКСП = 0x7FFF,
         МАСКА_ЗНАКА = 0x8000,
         ЭКСПБИАС = 0x3FFE
     }
//    const бдол QUIETNANMASK = 0xC000_0000_0000_0000; // Преобразует сигнализирующмй НЧ в тихий НЧ.
    version(ЛитлЭндиан) {
      const БКРАТ_ПОЗ_ЭКСП = 4;
      const ББАЙТ_ПОЗ_ЗНАКА = 9;
    } else {
      const БКРАТ_ПОЗ_ЭКСП = 0;
      const ББАЙТ_ПОЗ_ЗНАКА = 0;
    }
 } else static if (реал.mant_dig==113){ // квадрупл
     enum : бкрат {
         МАСКА_ЭКСП = 0x7FFF,
         МАСКА_ЗНАКА = 0x8000,
         ЭКСПБИАС = 0x3FFE
     }
    version(ЛитлЭндиан) {
      const БКРАТ_ПОЗ_ЭКСП = 7;
      const ББАЙТ_ПОЗ_ЗНАКА = 15;
    } else {
      const БКРАТ_ПОЗ_ЭКСП = 0;
      const ББАЙТ_ПОЗ_ЗНАКА = 0;
    }
 } else static if (реал.mant_dig==106) { // дводво
     enum : бкрат {
         МАСКА_ЭКСП = 0x7FF0,
         МАСКА_ЗНАКА = 0x8000
//         ЭКСПБИАС = 0x3FE0
     }
    // байт экспоненты не уникален
    version(ЛитлЭндиан) {
      const БКРАТ_ПОЗ_ЭКСП = 7; // 3 также эксп крат
      const ББАЙТ_ПОЗ_ЗНАКА = 15;
    } else {
      const БКРАТ_ПОЗ_ЭКСП = 0; // 4 также эксп крат
      const ББАЙТ_ПОЗ_ЗНАКА = 0;
    }
 }
}

// относятся к типам с плавающей точкой
version(ЛитлЭндиан) {
    const МАНТИССА_ЛСБ = 0;
    const МАНТИССА_МСБ = 1;    
} else {
    const МАНТИССА_ЛСБ = 1;
    const МАНТИССА_МСБ = 0;
}

public:

/** Флаги исключительного состояния IEEE

 Эти флаги указывают на случай исключительного условия плавающей запятой.
 Указывают, что было сгенерировано НЧ (не-число) или бесконечность, что результат
 неточен, либо, что был получен сигнал НЧ.
 Возвратные значения этих свойств нужно расценивать как булевы, хотя
 каждое из них возвращается ка цел, для скорости.

 Пример:
 ----
    реал a=3.5;
    // Установить все флаги в ноль
    сбросьИ3еФлаги();
    assert(!и3еФлаги.делНаНоль);
    // Выполнить деление на ноль.
    a/=0.0L;
    assert(a==реал.infinity);
    assert(и3еФлаги.делНаНоль);
    // Создать НЧ
    a*=0.0L;
    assert(и3еФлаги.не_годится);
    assert(нч_ли(a));

    // Проверить, что вызывающая func() не влияет на
    // флаги состояния.
    И3еФлаги f = и3еФлаги;
    func();
    assert(и3еФлаги == f);

 ----
 */
struct И3еФлаги
{
private:
    // The x87 FPU статус регистрируй is 16 биты.
    // The Pentium SSE2 статус регистрируй is 32 биты.
    цел м_флаги;
    version (X86_Any) {
        // Applies в_ Всё x87 статус word (16 биты) и SSE2 статус word(32 биты).
        enum : цел {
            МАСКА_НЕТОЧН   = 0x20,
            МАСКА_НЕДОБОРА = 0x10,
            МАСКА_ПЕРЕБОРА  = 0x08,
            МАСКА_ДЕЛНАНОЛЬ = 0x04,
            МАСКА_НЕВЕРН   = 0x01
        }
        // Don't Всёer about denormals, they are not supported on most CPUs.
        //  DENORMAL_MASK = 0x02;
    } else version (PPC) {
        // PowerPC FPSCR is a 32-битные регистрируй.
        enum : цел {
            МАСКА_НЕТОЧН   = 0x600,
            МАСКА_НЕДОБОРА = 0x010,
            МАСКА_ПЕРЕБОРА  = 0x008,
            МАСКА_ДЕЛНАНОЛЬ = 0x020,
            МАСКА_НЕВЕРН   = 0xF80
        }
    } else { // SPARC FSR is a 32bit регистрируй
             //(64 биты for Sparc 7 & 8, but high 32 биты are uninteresting).
        enum : цел {
            МАСКА_НЕТОЧН   = 0x020,
            МАСКА_НЕДОБОРА = 0x080,
            МАСКА_ПЕРЕБОРА  = 0x100,
            МАСКА_ДЕЛНАНОЛЬ = 0x040,
            МАСКА_НЕВЕРН   = 0x200
        }
    }
private:
    static И3еФлаги дайИ3еФлаги()
    {
        // This is a highly время-critical operation, и
        // should really be an intrinsic.
        version(D_InlineAsm_X86) {
            version(DMDWindows) {
             // In this case, we
             // возьми advantage of the fact that for DMD-Windows
             // a struct containing only a цел is returned in EAX.
             asm {
                 fstsw AX;
                 // NOTE: If compiler supports SSE2, need в_ OR the результат with
                 // the SSE2 статус регистрируй.
                 // Clear все irrelevant биты
                 and EAX, 0x03D;
             }
           }
           else {
             И3еФлаги tmp1;
             asm {
                 fstsw AX;
                 // NOTE: If compiler supports SSE2, need в_ OR the результат with
                 // the SSE2 статус регистрируй.
                 // Clear все irrelevant биты
                 and EAX, 0x03D;
                 mov tmp1, EAX;
             }
             return tmp1;
           }
       } else version (PPC) {
           assert(0, "Пока ещё не поддерживается");
       } else {
           /*   SPARC:
               цел retval;
               asm { st %fsr, retval; }
               return retval;
            */
           assert(0, "Пока ещё не поддерживается");
       }
    }
    static проц сбросьИ3еФлаги()
    {
       version(D_InlineAsm_X86) {
            asm {
                fnclex;
            }
        } else {
            /* SPARC:
              цел tmpval;
              asm { st %fsr, tmpval; }
              tmpval &=0xFFFF_FC00;
              asm { ld tmpval, %fsr; }
            */
           assert(0, "Пока ещё не поддерживается");
        }
    }
public:
    /// The результат cannot be represented exactly, so rounding occured.
    /// (example: x = син(0.1); }
    цел неточно() { return м_флаги & МАСКА_НЕТОЧН; }
    /// A zero was generated by недобор (example: x = реал.min*реал.epsilon/2;)
    цел недобор() { return м_флаги & МАСКА_НЕДОБОРА; }
    /// An infinity was generated by перебор (example: x = реал.max*2;)
    цел перебор() { return м_флаги & МАСКА_ПЕРЕБОРА; }
    /// An infinity was generated by division by zero (example: x = 3/0.0; )
    цел делНаНоль() { return м_флаги & МАСКА_ДЕЛНАНОЛЬ; }
    /// A machine НЧ was generated. (example: x = реал.infinity * 0.0; )
    цел не_годится() { return м_флаги & МАСКА_НЕВЕРН; }
}

/// Возвращает снимок of the текущ состояние of the floating-точка статус флаги.
И3еФлаги и3еФлаги() { return И3еФлаги.дайИ3еФлаги(); }

/// Набор все of the floating-точка статус флаги в_ нет.
проц сбросьИ3еФлаги() { И3еФлаги.сбросьИ3еФлаги; }

/** IEEE rounding modes.
 * The default режим is НАИБЛИЖАЙШИЙ.
 */
enum РежимОкругления : крат {
    НАИБЛИЖАЙШИЙ = 0x0000,
    ВВЕРХ      = 0x0400,
    ВНИЗ        = 0x0800,
    К_НУЛЮ    = 0x0C00
};

/** Change the rounding режим использован for все floating-точка operations.
 *
 * Returns the old rounding режим.
 *
 * When changing the rounding режим, it is almost always necessary в_ restore it
 * at the конец of the function. Typical usage:
---
    auto oldrounding = установиИ3еОкругление(РежимОкругления.ВВЕРХ);
    scope (exit) установиИ3еОкругление(oldrounding);
---
 */
РежимОкругления установиИ3еОкругление(РежимОкругления режокрукгл) {
   version(D_InlineAsm_X86) {
        // TODO: For SSE/SSE2, do we also need в_ установи the SSE rounding режим?
        крат cont;
        asm {
            fstcw cont;
            mov CX, cont;
            mov AX, cont;
            and EAX, 0x0C00; // Form the return значение
            and CX, 0xF3FF;
            or CX, режокрукгл;
            mov cont, CX;
            fldcw cont;
        }
    } else {
           assert(0, "Пока ещё не поддерживается");
    }
}

/** Get the IEEE rounding режим which is in use.
 *
 */
РежимОкругления дайИ3еОкругление() {
   version(D_InlineAsm_X86) {
        // TODO: For SSE/SSE2, do we also need в_ проверь the SSE rounding режим?
        крат cont;
        asm {
            mov EAX, 0x0C00;
            fstcw cont;
            and AX, cont;
        }
    } else {
           assert(0, "Пока ещё не поддерживается");
    }
}

debug(UnitTest) {
   version(D_InlineAsm_X86) { // Won't work for anything else yet
unittest {
    реал a = 3.5;
    сбросьИ3еФлаги();
    assert(!и3еФлаги.делНаНоль);
    a /= 0.0L;
    assert(и3еФлаги.делНаНоль);
    assert(a == реал.infinity);
    a *= 0.0L;
    assert(и3еФлаги.не_годится);
    assert(нч_ли(a));
    a = реал.max;
    a *= 2;
    assert(и3еФлаги.перебор);
    a = реал.min * реал.epsilon;
    a /= 99;
    assert(и3еФлаги.недобор);
    assert(и3еФлаги.неточно);

    цел r = дайИ3еОкругление;
    assert(r == РежимОкругления.НАИБЛИЖАЙШИЙ);
}
}
}

// Note: Itanium supports ещё точность опции than this. SSE/SSE2 does not support any.
enum КонтрольТочности : крат {
    ТОЧНОСТЬ80 = 0x300,
    ТОЧНОСТЬ64 = 0x200,
    ТОЧНОСТЬ32 = 0x000
};

/** Набор the число of биты of точность использован by 'реал'.
 *
 * Возвращает: the old точность.
 * This is not supported on все platforms.
 */
КонтрольТочности передайТочностьРеала(КонтрольТочности прец) {
   version(D_InlineAsm_X86) {
        крат cont;
        asm {
            fstcw cont;
            mov CX, cont;
            mov AX, cont;
            and EAX, 0x0300; // Form the return значение
            and CX,  0xFCFF;
            or  CX,  прец;
            mov cont, CX;
            fldcw cont;
        }
    } else {
           assert(0, "Пока ещё не поддерживается");
    }
}

/*********************************************************************
 * Separate floating точка значение преобр_в significand и exponent.
 *
 * Возвращает:
 *      Calculate и return $(I x) и $(I эксп) such that
 *      значение =$(I x)*2$(SUP эксп) и
 *      .5 $(LT)= |$(I x)| $(LT) 1.0
 *      
 *      $(I x) имеется same знак as значение.
 *
 *      $(TABLE_SV
 *      $(TR $(TH значение)           $(TH returns)         $(TH эксп))
 *      $(TR $(TD $(PLUSMN)0.0)    $(TD $(PLUSMN)0.0)    $(TD 0))
 *      $(TR $(TD +$(INFIN))       $(TD +$(INFIN))       $(TD цел.max))
 *      $(TR $(TD -$(INFIN))       $(TD -$(INFIN))       $(TD цел.min))
 *      $(TR $(TD $(PLUSMN)$(NAN)) $(TD $(PLUSMN)$(NAN)) $(TD цел.min))
 *      )
 */
реал фрэксп(реал значение, out цел эксп)
{
    бкрат* vu = cast(бкрат*)&значение;
    дол* vl = cast(дол*)&значение;
    бцел ex;
    alias плавТрэтсИ3Е!(реал) F;

    ex = vu[F.БКРАТ_ПОЗ_ЭКСП] & F.МАСКА_ЭКСП;
  static if (реал.mant_dig == 64) { // real80
    if (ex) { // If exponent is non-zero
        if (ex == F.МАСКА_ЭКСП) {   // infinity or НЧ
            if (*vl &  0x7FFF_FFFF_FFFF_FFFF) {  // НЧ
                *vl |= 0xC000_0000_0000_0000;  // преобразуй $(NAN)S в_ $(NAN)Q
                эксп = цел.min;
            } else if (vu[F.БКРАТ_ПОЗ_ЭКСП] & 0x8000) {   // негатив infinity
                эксп = цел.min;
            } else {   // positive infinity
                эксп = цел.max;
            }
        } else {
            эксп = ex - F.ЭКСПБИАС;
            vu[F.БКРАТ_ПОЗ_ЭКСП] = cast(бкрат)((0x8000 & vu[F.БКРАТ_ПОЗ_ЭКСП]) | 0x3FFE);
        }
    } else if (!*vl) {
        // значение is +-0.0
        эксп = 0;
    } else {
        // denormal
        значение *= F.РЕЦИП_ЭПСИЛОН;
        ex = vu[F.БКРАТ_ПОЗ_ЭКСП] & F.МАСКА_ЭКСП;
        эксп = ex - F.ЭКСПБИАС - 63;
        vu[F.БКРАТ_ПОЗ_ЭКСП] = cast(бкрат)((0x8000 & vu[F.БКРАТ_ПОЗ_ЭКСП]) | 0x3FFE);
    }
    return значение;
  } else static if (реал.mant_dig == 113) { // квадрупл      
        if (ex) { // If exponent is non-zero
            if (ex == F.МАСКА_ЭКСП) {   // infinity or НЧ
                if (vl[МАНТИССА_ЛСБ] |( vl[МАНТИССА_МСБ]&0x0000_FFFF_FFFF_FFFF)) {  // НЧ
                    vl[МАНТИССА_МСБ] |= 0x0000_8000_0000_0000;  // преобразуй $(NAN)S в_ $(NAN)Q
                    эксп = цел.min;
                } else if (vu[F.БКРАТ_ПОЗ_ЭКСП] & 0x8000) {   // негатив infinity
                    эксп = цел.min;
                } else {   // positive infinity
                    эксп = цел.max;
                }
            } else {
                эксп = ex - F.ЭКСПБИАС;
                vu[F.БКРАТ_ПОЗ_ЭКСП] = cast(бкрат)((0x8000 & vu[F.БКРАТ_ПОЗ_ЭКСП]) | 0x3FFE);
            }
        } else if ((vl[МАНТИССА_ЛСБ] |(vl[МАНТИССА_МСБ]&0x0000_FFFF_FFFF_FFFF))==0) {
            // значение is +-0.0
            эксп = 0;
    } else {
        // denormal
        значение *= F.РЕЦИП_ЭПСИЛОН;
        ex = vu[F.БКРАТ_ПОЗ_ЭКСП] & F.МАСКА_ЭКСП;
        эксп = ex - F.ЭКСПБИАС - 113;
        vu[F.БКРАТ_ПОЗ_ЭКСП] = cast(бкрат)((0x8000 & vu[F.БКРАТ_ПОЗ_ЭКСП]) | 0x3FFE);
    }
    return значение;
  } else static if (реал.mant_dig==53) { // реал is дво
    if (ex) { // If exponent is non-zero
        if (ex == F.МАСКА_ЭКСП) {   // infinity or НЧ
            if (*vl==0x7FF0_0000_0000_0000) {  // positive infinity
                эксп = цел.max;
            } else if (*vl==0xFFF0_0000_0000_0000) { // негатив infinity
                эксп = цел.min;
            } else { // НЧ
                *vl |= 0x0008_0000_0000_0000;  // преобразуй $(NAN)S в_ $(NAN)Q
                эксп = цел.min;
            }
        } else {
            эксп = (ex - F.ЭКСПБИАС) >>> 4;
            vu[F.БКРАТ_ПОЗ_ЭКСП] = (0x8000 & vu[F.БКРАТ_ПОЗ_ЭКСП]) | 0x3FE0;
        }
    } else if (!(*vl & 0x7FFF_FFFF_FFFF_FFFF)) {
        // значение is +-0.0
        эксп = 0;
    } else {
        // denormal
        бкрат sgn;
        sgn = (0x8000 & vu[F.БКРАТ_ПОЗ_ЭКСП])| 0x3FE0;
        *vl &= 0x7FFF_FFFF_FFFF_FFFF;

        цел i = -0x3FD+11;
        do {
            i--;
            *vl <<= 1;
        } while (*vl > 0);
        эксп = i;
        vu[F.БКРАТ_ПОЗ_ЭКСП] = sgn;
    }
    return значение;
  }else { //static if(реал.mant_dig==106) // дводво
        assert(0, "Unsupported");
  }
}

debug(UnitTest) {

unittest
{
    static реал vals[][3] = // x,фрэксп,эксп
    [
        [0.0,   0.0,    0],
        [-0.0,  -0.0,   0],
        [1.0,   .5, 1],
        [-1.0,  -.5,    1],
        [2.0,   .5, 2],
        [дво.min/2.0, .5, -1022],
        [реал.infinity,реал.infinity,цел.max],
        [-реал.infinity,-реал.infinity,цел.min],
    ];   
    
    цел i;
    цел eptr;
    реал v = фрэксп(НЧ(0xABC), eptr);
    assert(идентичен_ли(НЧ(0xABC), v));
    assert(eptr ==цел.min);
    v = фрэксп(-НЧ(0xABC), eptr);
    assert(идентичен_ли(-НЧ(0xABC), v));
    assert(eptr ==цел.min);

    for (i = 0; i < vals.length; i++) {
        реал x = vals[i][0];
        реал e = vals[i][1];
        цел эксп = cast(цел)vals[i][2];
        v = фрэксп(x, eptr);
//        printf("фрэксп(%La) = %La, should be %La, eptr = %d, should be %d\n", x, v, e, eptr, эксп);
        assert(идентичен_ли(e, v));
        assert(эксп == eptr);

    }
   static if (реал.mant_dig == 64) {
     static реал extendedvals[][3] = [ // x,фрэксп,эксп
        [0x1.a5f1c2eb3fe4efp+73L, 0x1.A5F1C2EB3FE4EFp-1L,   74],    // нормаль
        [0x1.fa01712e8f0471ap-1064L,  0x1.fa01712e8f0471ap-1L,     -1063],
        [реал.min,  .5,     -16381],
        [реал.min/2.0L, .5,     -16382]    // denormal
     ];

    for (i = 0; i < extendedvals.length; i++) {
        реал x = extendedvals[i][0];
        реал e = extendedvals[i][1];
        цел эксп = cast(цел)extendedvals[i][2];
        v = фрэксп(x, eptr);
        assert(идентичен_ли(e, v));
        assert(эксп == eptr);

    }
  }
}
}

/**
 * Compute n * 2$(SUP эксп)
 * References: фрэксп
 */
реал лдэксп(реал n, цел эксп) /* intrinsic */
{
    version(Naked_D_InlineAsm_X86)
    {
        asm {
            fild эксп;
            fld n;
            fscale;
            fstp ST(1), ST(0);
        }
    }
    else
    {
        return cidrus.ldexpl(n, эксп);
    }
}

/******************************************
 * Extracts the exponent of x as a signed integral значение.
 *
 * If x is not a special значение, the результат is the same as
 * $(D cast(цел)логб(x)).
 * 
 * Remarks: This function is consistent with IEEE754R, but it
 * differs из_ the C function of the same имя
 * in the return значение of infinity. (in C, илогб(реал.infinity)== цел.max).
 * Note that the special return значения may все be equal.
 *
 *      $(TABLE_SV
 *      $(TR $(TH x)                $(TH илогб(x))     $(TH Неверный?))
 *      $(TR $(TD 0)                 $(TD FP_ILOGB0)   $(TD да))
 *      $(TR $(TD $(PLUSMN)$(INFIN)) $(TD FP_ILOGBINFINITY) $(TD да))
 *      $(TR $(TD $(NAN))            $(TD FP_ILOGBNAN) $(TD да))
 *      )
 */
цел илогб(реал x)
{
        version(Naked_D_InlineAsm_X86)
        {
            цел y;
            asm {
                fld x;
                fxtract;
                fstp ST(0); // drop significand
                fistp y; // и return the exponent
            }
            return y;
        } else static if (реал.mant_dig==64) { // 80-битные reals
            alias плавТрэтсИ3Е!(реал) F;
            крат e = cast(крат)((cast(крат *)&x)[F.БКРАТ_ПОЗ_ЭКСП] & F.МАСКА_ЭКСП);
            if (e == F.МАСКА_ЭКСП) {
                // BUG: should also установи the не_годится исключение
                бдол s = *cast(бдол *)&x;
                if (s == 0x8000_0000_0000_0000) {
                    return FP_ILOGBINFINITY;
                }
                else return FP_ILOGBNAN;
            }
            if (e==0) {
                бдол s = *cast(бдол *)&x;
                if (s == 0x0000_0000_0000_0000) {
                    // BUG: should also установи the не_годится исключение
                    return FP_ILOGB0;
                }
                // Denormals
                x *= F.РЕЦИП_ЭПСИЛОН;
                крат f = (cast(крат *)&x)[F.БКРАТ_ПОЗ_ЭКСП];
                return -0x3FFF - (63-f);
            }
            return e - 0x3FFF;
        } else {
        return cidrus.ilogbl(x);
    }
}

version (X86)
{
    const цел FP_ILOGB0        = -цел.max-1;
    const цел FP_ILOGBNAN      = -цел.max-1;
    const цел FP_ILOGBINFINITY = -цел.max-1;
} else {
    alias cidrus.FP_ILOGB0   FP_ILOGB0;
    alias cidrus.FP_ILOGBNAN FP_ILOGBNAN;
    const цел FP_ILOGBINFINITY = цел.max;
}

debug(UnitTest) {
unittest {
    assert(илогб(1.0) == 0);
    assert(илогб(65536) == 16);
    assert(илогб(-65536) == 16);
    assert(илогб(1.0 / 65536) == -16);
    assert(илогб(реал.nan) == FP_ILOGBNAN);
    assert(илогб(0.0) == FP_ILOGB0);
    assert(илогб(-0.0) == FP_ILOGB0);
    // denormal
    assert(илогб(0.125 * реал.min) == реал.min_exp - 4);
    assert(илогб(реал.infinity) == FP_ILOGBINFINITY);
}
}

/*****************************************
 * Extracts the exponent of x as a signed integral значение.
 *
 * If x is subnormal, it is treated as if it were normalized.
 * For a positive, finite x:
 *
 * 1 $(LT)= $(I x) * FLT_RADIX$(SUP -логб(x)) $(LT) FLT_RADIX
 *
 *      $(TABLE_SV
 *      $(TR $(TH x)                 $(TH логб(x))   $(TH divопрe by 0?) )
 *      $(TR $(TD $(PLUSMN)$(INFIN)) $(TD +$(INFIN)) $(TD no))
 *      $(TR $(TD $(PLUSMN)0.0)      $(TD -$(INFIN)) $(TD да) )
 *      )
 */
реал логб(реал x)
{
    version(Naked_D_InlineAsm_X86)
    {
        asm {
            fld x;
            fxtract;
            fstp ST(0), ST; // drop significand
        }
    } else {
        return cidrus.logbl(x);
    }
}

debug(UnitTest) {
unittest {
    assert(логб(реал.infinity)== реал.infinity);
    assert(идентичен_ли(логб(НЧ(0xFCD)), НЧ(0xFCD)));
    assert(логб(1.0)== 0.0);
    assert(логб(-65536) == 16);
    assert(логб(0.0)== -реал.infinity);
    assert(илогб(0.125*реал.min) == реал.min_exp-4);
}
}

/*************************************
 * Efficiently calculates x * 2$(SUP n).
 *
 * скалбн handles недобор и перебор in
 * the same fashion as the basic arithmetic operators.
 *
 *  $(TABLE_SV
 *      $(TR $(TH x)                 $(TH scalb(x)))
 *      $(TR $(TD $(PLUSMNINF))      $(TD $(PLUSMNINF)) )
 *      $(TR $(TD $(PLUSMN)0.0)      $(TD $(PLUSMN)0.0) )
 *  )
 */
реал скалбн(реал x, цел n)
{
    version(Naked_D_InlineAsm_X86)
    {
        asm {
            fild n;
            fld x;
            fscale;
            fstp ST(1), ST;
        }
    } else {
        // NOTE: Not implemented in DMD
        return cidrus.scalbnl(x, n);
    }
}

debug(UnitTest) {
unittest {
    assert(скалбн(-реал.infinity, 5) == -реал.infinity);
    assert(идентичен_ли(скалбн(НЧ(0xABC),7), НЧ(0xABC)));
}
}

/**
 * Возвращает положительную разницу между x и y.
 *
 * Если либо x, либо y равно $(NAN), то возвращается не-число.
 * Возвращает:
 * $(TABLE_SV
 *  $(SVH Аргументы, фдим(x, y))
 *  $(SV x $(GT) y, x - y)
 *  $(SV x $(LT)= y, +0.0)
 * )
 */
реал фдим(реал x, реал y)
{
    return (x !<= y) ? x - y : +0.0;
}

debug(UnitTest) {
unittest {
    assert(идентичен_ли(фдим(НЧ(0xABC), 58.2), НЧ(0xABC)));
}
}

/*******************************
 * Returns |x|
 *
 *      $(TABLE_SV
 *      $(TR $(TH x)                 $(TH фабс(x)))
 *      $(TR $(TD $(PLUSMN)0.0)      $(TD +0.0) )
 *      $(TR $(TD $(PLUSMN)$(INFIN)) $(TD +$(INFIN)) )
 *      )
 */
реал фабс(реал x) /* intrinsic */
{
    version(D_InlineAsm_X86)
    {
        asm {
            fld x;
            fabs;
        }
    }
    else
    {
        return cidrus.fabsl(x);
    }
}

unittest {
    assert(идентичен_ли(фабс(НЧ(0xABC)), НЧ(0xABC)));
}

/**
 * Возвращает (x * y) + z, округлённое один раз в соответствии с
 * текущим режимом округления.
 *
 * BUGS: Пока н ереализовано - округляет дважды.
 */
реал фма(плав x, плав y, плав z)
{
    return (x * y) + z;
}

/**
 * Calculate кос(y) + i син(y).
 *
 * On x86 CPUs, this is a very efficient operation;
 * almost twice as fast as calculating син(y) и кос(y)
 * seperately, и is the preferred метод when Всё are требуется.
 */
креал экспи(реал y)
{
    version(Naked_D_InlineAsm_X86)
    {
        asm {            
            fld y;
            fsincos;
            fxch ST(1), ST(0);
        }
    }
    else
    {
        return cidrus.cosl(y) + cidrus.sinl(y)*1i;
    }
}

debug(UnitTest) {
unittest
{
    assert(экспи(1.3e5L) == cidrus.cosl(1.3e5L) + cidrus.sinl(1.3e5L) * 1i);
    assert(экспи(0.0L) == 1L + 0.0Li);
}
}

/*********************************
 * Returns !=0 if e is a НЧ.
 */

цел нч_ли(реал x)
{
  alias плавТрэтсИ3Е!(реал) F;
  static if (реал.mant_dig==53) { // дво
        бдол*  p = cast(бдол *)&x;
        return (*p & 0x7FF0_0000_0000_0000 == 0x7FF0_0000_0000_0000) && *p & 0x000F_FFFF_FFFF_FFFF;
  } else static if (реал.mant_dig==64) {     // real80
        бкрат e = F.МАСКА_ЭКСП & (cast(бкрат *)&x)[F.БКРАТ_ПОЗ_ЭКСП];
        бдол*  ps = cast(бдол *)&x;
        return e == F.МАСКА_ЭКСП &&
            *ps & 0x7FFF_FFFF_FFFF_FFFF; // not infinity
  } else static if (реал.mant_dig==113) {  // квадрупл
        бкрат e = F.МАСКА_ЭКСП & (cast(бкрат *)&x)[F.БКРАТ_ПОЗ_ЭКСП];
        бдол*  ps = cast(бдол *)&x;
        return e == F.МАСКА_ЭКСП &&
           (ps[МАНТИССА_ЛСБ] | (ps[МАНТИССА_МСБ]& 0x0000_FFFF_FFFF_FFFF))!=0;
  } else {
      return x!=x;
  }
}


debug(UnitTest) {
unittest
{
    assert(нч_ли(плав.nan));
    assert(нч_ли(-дво.nan));
    assert(нч_ли(реал.nan));

    assert(!нч_ли(53.6));
    assert(!нч_ли(плав.infinity));
}
}

/**
 * Returns !=0 if x is normalized.
 *
 * (Need one for each форматируй because subnormal
 *  floats might be преобразованый в_ нормаль reals)
 */
цел норм_ли(X)(X x)
{
    alias плавТрэтсИ3Е!(X) F;
    
    static if(реал.mant_dig==106) { // дводво
    // дводво is нормаль if the least significant часть is нормаль.
        return норм_ли((cast(дво*)&x)[МАНТИССА_ЛСБ]);
    } else {
        бкрат e = F.МАСКА_ЭКСП & (cast(бкрат *)&x)[F.БКРАТ_ПОЗ_ЭКСП];
        return (e != F.МАСКА_ЭКСП && e!=0);
    }
}

debug(UnitTest) {
unittest
{
    плав f = 3;
    дво d = 500;
    реал e = 10e+48;

    assert(норм_ли(f));
    assert(норм_ли(d));
    assert(норм_ли(e));
    f=d=e=0;
    assert(!норм_ли(f));
    assert(!норм_ли(d));
    assert(!норм_ли(e));
    assert(!норм_ли(реал.infinity));
    assert(норм_ли(-реал.max));
    assert(!норм_ли(реал.min/4));
    
}
}

/*********************************
 * Is the binary representation of x опрentical в_ y?
 *
 * Same as ==, except that positive и негатив zero are not опрentical,
 * и two $(NAN)s are опрentical if they have the same 'payload'.
 */

бул идентичен_ли(реал x, реал y)
{
    // We're doing a bitwise сравнение so the endianness is irrelevant.
    дол*   pxs = cast(дол *)&x;
    дол*   pys = cast(дол *)&y;
  static if (реал.mant_dig == 53){ //дво
    return pxs[0] == pys[0];
  } else static if (реал.mant_dig == 113 || реал.mant_dig==106) {
      // квадрупл or дводво
    return pxs[0] == pys[0] && pxs[1] == pys[1];
  } else { // real80
    бкрат* pxe = cast(бкрат *)&x;
    бкрат* pye = cast(бкрат *)&y;
    return pxe[4] == pye[4] && pxs[0] == pys[0];
  }
}

/** ditto */
бул идентичен_ли(вреал x, вреал y) {
    return идентичен_ли(x.im, y.im);
}

/** ditto */
бул идентичен_ли(креал x, креал y) {
    return идентичен_ли(x.re, y.re) && идентичен_ли(x.im, y.im);
}

debug(UnitTest) {
unittest {
    assert(идентичен_ли(0.0, 0.0));
    assert(!идентичен_ли(0.0, -0.0));
    assert(идентичен_ли(НЧ(0xABC), НЧ(0xABC)));
    assert(!идентичен_ли(НЧ(0xABC), НЧ(218)));
    assert(идентичен_ли(1.234e56, 1.234e56));
    assert(нч_ли(НЧ(0x12345)));
    assert(идентичен_ли(3.1 + НЧ(0xDEF) * 1i, 3.1 + НЧ(0xDEF)*1i));
    assert(!идентичен_ли(3.1+0.0i, 3.1-0i));
    assert(!идентичен_ли(0.0i, 2.5e58i));
}
}

/*********************************
 * Is число subnormal? (Also called "denormal".)
 * Subnormals have a 0 exponent и a 0 most significant significand bit,
 * but are non-zero.
 */

/* Need one for each форматируй because subnormal floats might
 * be преобразованый в_ нормаль reals.
 */

цел субнорм_ли(плав f)
{
    бцел *p = cast(бцел *)&f;
    return (*p & 0x7F80_0000) == 0 && *p & 0x007F_FFFF;
}

debug(UnitTest) {
unittest
{
    плав f = -плав.min;
    assert(!субнорм_ли(f));
    f/=4;
    assert(субнорм_ли(f));
}
}

/// ditto

цел субнорм_ли(дво d)
{
    бцел *p = cast(бцел *)&d;
    return (p[МАНТИССА_МСБ] & 0x7FF0_0000) == 0 && (p[МАНТИССА_ЛСБ] || p[МАНТИССА_МСБ] & 0x000F_FFFF);
}

debug(UnitTest) {
unittest
{
    дво f;

    for (f = 1; !субнорм_ли(f); f /= 2)
    assert(f != 0);
}
}

/// ditto

цел субнорм_ли(реал x)
{
    alias плавТрэтсИ3Е!(реал) F;
    static if (реал.mant_dig == 53) { // дво
        return субнорм_ли(cast(дво)x);
    } else static if (реал.mant_dig == 113) { // квадрупл        
        бкрат e = F.МАСКА_ЭКСП & (cast(бкрат *)&x)[F.БКРАТ_ПОЗ_ЭКСП];
        дол*   ps = cast(дол *)&x;
        return (e == 0 && (((ps[МАНТИССА_ЛСБ]|(ps[МАНТИССА_МСБ]& 0x0000_FFFF_FFFF_FFFF))) !=0));
    } else static if (реал.mant_dig==64) { // real80
        бкрат* pe = cast(бкрат *)&x;
        дол*   ps = cast(дол *)&x;

        return (pe[F.БКРАТ_ПОЗ_ЭКСП] & F.МАСКА_ЭКСП) == 0 && *ps > 0;
    } else { // дво дво
        return субнорм_ли((cast(дво*)&x)[МАНТИССА_МСБ]);
    }
}

debug(UnitTest) {
unittest
{
    реал f;

    for (f = 1; !субнорм_ли(f); f /= 2)
    assert(f != 0);
}
}

/*********************************
 * Return !=0 if x is $(PLUSMN)0.
 *
 * Does not affect any floating-точка флаги
 */
цел ноль_ли(реал x)
{
    alias плавТрэтсИ3Е!(реал) F;
    static if (реал.mant_dig == 53) { // дво
        return ((*cast(бдол *)&x) & 0x7FFF_FFFF_FFFF_FFFF) == 0;
    } else static if (реал.mant_dig == 113) { // квадрупл   
        дол*   ps = cast(дол *)&x;
        return (ps[МАНТИССА_ЛСБ] | (ps[МАНТИССА_МСБ]& 0x7FFF_FFFF_FFFF_FFFF)) == 0;
    } else { // real80
        бкрат* pe = cast(бкрат *)&x;
        бдол*  ps = cast(бдол  *)&x;
        return (pe[F.БКРАТ_ПОЗ_ЭКСП] & F.МАСКА_ЭКСП) == 0 && *ps == 0;
    }
}

debug(UnitTest) {
unittest
{
    assert(ноль_ли(0.0));
    assert(ноль_ли(-0.0));
    assert(!ноль_ли(2.5));
    assert(!ноль_ли(реал.min / 1000));
}
}

/*********************************
 * Return !=0 if e is $(PLUSMNINF);.
 */

цел беск_ли(реал x)
{
    alias плавТрэтсИ3Е!(реал) F;
    static if (реал.mant_dig == 53) { // дво
        return ((*cast(бдол *)&x) & 0x7FFF_FFFF_FFFF_FFFF) == 0x7FF8_0000_0000_0000;
    } else static if(реал.mant_dig == 106) { //дводво
        return (((cast(бдол *)&x)[МАНТИССА_МСБ]) & 0x7FFF_FFFF_FFFF_FFFF) == 0x7FF8_0000_0000_0000;   
    } else static if (реал.mant_dig == 113) { // квадрупл   
        дол*   ps = cast(дол *)&x;
        return (ps[МАНТИССА_ЛСБ] == 0) 
         && (ps[МАНТИССА_МСБ] & 0x7FFF_FFFF_FFFF_FFFF) == 0x7FFF_0000_0000_0000;
    } else { // real80
        бкрат e = cast(бкрат)(F.МАСКА_ЭКСП & (cast(бкрат *)&x)[F.БКРАТ_ПОЗ_ЭКСП]);
        бдол*  ps = cast(бдол *)&x;

        return e == F.МАСКА_ЭКСП && *ps == 0x8000_0000_0000_0000;
   }
}

debug(UnitTest) {
unittest
{
    assert(беск_ли(плав.infinity));
    assert(!беск_ли(плав.nan));
    assert(беск_ли(дво.infinity));
    assert(беск_ли(-реал.infinity));

    assert(беск_ли(-1.0 / 0.0));
}
}

/**
 * Calculate the следщ largest floating точка значение after x.
 *
 * Return the least число greater than x that is representable as a реал;
 * thus, it gives the следщ точка on the IEEE число строка.
 *
 *  $(TABLE_SV
 *    $(SVH x,            следщВыше(x)   )
 *    $(SV  -$(INFIN),    -реал.max   )
 *    $(SV  $(PLUSMN)0.0, реал.min*реал.epsilon )
 *    $(SV  реал.max,     $(INFIN) )
 *    $(SV  $(INFIN),     $(INFIN) )
 *    $(SV  $(NAN),       $(NAN)   )
 * )
 *
 * Remarks:
 * This function is included in the IEEE 754-2008 стандарт.
 * 
 * следщДвоВыше и следщПлавВыше are the corresponding functions for
 * the IEEE дво и IEEE плав число строки.
 */
реал следщВыше(реал x)
{
    alias плавТрэтсИ3Е!(реал) F;
    static if (реал.mant_dig == 53) { // дво
        return следщДвоВыше(x);
    } else static if(реал.mant_dig==113) {  // квадрупл
        бкрат e = F.МАСКА_ЭКСП & (cast(бкрат *)&x)[F.БКРАТ_ПОЗ_ЭКСП];
        if (e == F.МАСКА_ЭКСП) { // НЧ or Infinity
             if (x == -реал.infinity) return -реал.max;
             return x; // +Inf и НЧ are unchanged.
        }     
        бдол*   ps = cast(бдол *)&e;
        if (ps[МАНТИССА_ЛСБ] & 0x8000_0000_0000_0000)  { // Negative число
            if (ps[МАНТИССА_ЛСБ]==0 && ps[МАНТИССА_МСБ] == 0x8000_0000_0000_0000) { // it was негатив zero
                ps[МАНТИССА_ЛСБ] = 0x0000_0000_0000_0001; // change в_ smallest subnormal
                ps[МАНТИССА_МСБ] = 0;
                return x;
            }
            --*ps;
            if (ps[МАНТИССА_ЛСБ]==0) --ps[МАНТИССА_МСБ];
        } else { // Positive число
            ++ps[МАНТИССА_ЛСБ];
            if (ps[МАНТИССА_ЛСБ]==0) ++ps[МАНТИССА_МСБ];
        }
        return x;
          
    } else static if(реал.mant_dig==64){ // real80
        // For 80-битные reals, the "implied bit" is a nuisance...
        бкрат *pe = cast(бкрат *)&x;
        бдол  *ps = cast(бдол  *)&x;

        if ((pe[F.БКРАТ_ПОЗ_ЭКСП] & F.МАСКА_ЭКСП) == F.МАСКА_ЭКСП) {
            // First, deal with NANs и infinity
            if (x == -реал.infinity) return -реал.max;
            return x; // +Inf и НЧ are unchanged.
        }
        if (pe[F.БКРАТ_ПОЗ_ЭКСП] & 0x8000)  { // Negative число -- need в_ decrease the significand
            --*ps;
            // Need в_ маска with 0x7FFF... so subnormals are treated correctly.
            if ((*ps & 0x7FFF_FFFF_FFFF_FFFF) == 0x7FFF_FFFF_FFFF_FFFF) {
                if (pe[F.БКРАТ_ПОЗ_ЭКСП] == 0x8000) { // it was негатив zero
                    *ps = 1;
                    pe[F.БКРАТ_ПОЗ_ЭКСП] = 0; // smallest subnormal.
                    return x;
                }
                --pe[F.БКРАТ_ПОЗ_ЭКСП];
                if (pe[F.БКРАТ_ПОЗ_ЭКСП] == 0x8000) {
                    return x; // it's become a subnormal, implied bit stays low.
                }
                *ps = 0xFFFF_FFFF_FFFF_FFFF; // установи the implied bit
                return x;
            }
            return x;
        } else {
            // Positive число -- need в_ increase the significand.
            // Works automatically for positive zero.
            ++*ps;
            if ((*ps & 0x7FFF_FFFF_FFFF_FFFF) == 0) {
                // change in exponent
                ++pe[F.БКРАТ_ПОЗ_ЭКСП];
                *ps = 0x8000_0000_0000_0000; // установи the high bit
            }
        }
        return x;
    } else { // дводво
        assert(0, "Not implemented");
    }
}

/** ditto */
дво следщДвоВыше(дво x)
{
    бдол *ps = cast(бдол *)&x;

    if ((*ps & 0x7FF0_0000_0000_0000) == 0x7FF0_0000_0000_0000) {
        // First, deal with NANs и infinity
        if (x == -x.infinity) return -x.max;
        return x; // +INF и NAN are unchanged.
    }
    if (*ps & 0x8000_0000_0000_0000)  { // Negative число
        if (*ps == 0x8000_0000_0000_0000) { // it was негатив zero
            *ps = 0x0000_0000_0000_0001; // change в_ smallest subnormal
            return x;
        }
        --*ps;
    } else { // Positive число
        ++*ps;
    }
    return x;
}

/** ditto */
плав следщПлавВыше(плав x)
{
    бцел *ps = cast(бцел *)&x;

    if ((*ps & 0x7F80_0000) == 0x7F80_0000) {
        // First, deal with NANs и infinity
        if (x == -x.infinity) return -x.max;
        return x; // +INF и NAN are unchanged.
    }
    if (*ps & 0x8000_0000)  { // Negative число
        if (*ps == 0x8000_0000) { // it was негатив zero
            *ps = 0x0000_0001; // change в_ smallest subnormal
            return x;
        }
        --*ps;
    } else { // Positive число
        ++*ps;
    }
    return x;
}

debug(UnitTest) {
unittest {
 static if (реал.mant_dig == 64) {

  // Tests for 80-битные reals

    assert(идентичен_ли(следщВыше(НЧ(0xABC)), НЧ(0xABC)));
    // негатив numbers
    assert( следщВыше(-реал.infinity) == -реал.max );
    assert( следщВыше(-1-реал.epsilon) == -1.0 );
    assert( следщВыше(-2) == -2.0 + реал.epsilon);
    // denormals и zero
    assert( следщВыше(-реал.min) == -реал.min*(1-реал.epsilon) );
    assert( следщВыше(-реал.min*(1-реал.epsilon) == -реал.min*(1-2*реал.epsilon)) );
    assert( идентичен_ли(-0.0L, следщВыше(-реал.min*реал.epsilon)) );
    assert( следщВыше(-0.0) == реал.min*реал.epsilon );
    assert( следщВыше(0.0) == реал.min*реал.epsilon );
    assert( следщВыше(реал.min*(1-реал.epsilon)) == реал.min );
    assert( следщВыше(реал.min) == реал.min*(1+реал.epsilon) );
    // positive numbers
    assert( следщВыше(1) == 1.0 + реал.epsilon );
    assert( следщВыше(2.0-реал.epsilon) == 2.0 );
    assert( следщВыше(реал.max) == реал.infinity );
    assert( следщВыше(реал.infinity)==реал.infinity );
 }

    assert(идентичен_ли(следщДвоВыше(НЧ(0xABC)), НЧ(0xABC)));
    // негатив numbers
    assert( следщДвоВыше(-дво.infinity) == -дво.max );
    assert( следщДвоВыше(-1-дво.epsilon) == -1.0 );
    assert( следщДвоВыше(-2) == -2.0 + дво.epsilon);
    // denormals и zero

    assert( следщДвоВыше(-дво.min) == -дво.min*(1-дво.epsilon) );
    assert( следщДвоВыше(-дво.min*(1-дво.epsilon) == -дво.min*(1-2*дво.epsilon)) );
    assert( идентичен_ли(-0.0, следщДвоВыше(-дво.min*дво.epsilon)) );
    assert( следщДвоВыше(0.0) == дво.min*дво.epsilon );
    assert( следщДвоВыше(-0.0) == дво.min*дво.epsilon );
    assert( следщДвоВыше(дво.min*(1-дво.epsilon)) == дво.min );
    assert( следщДвоВыше(дво.min) == дво.min*(1+дво.epsilon) );
    // positive numbers
    assert( следщДвоВыше(1) == 1.0 + дво.epsilon );
    assert( следщДвоВыше(2.0-дво.epsilon) == 2.0 );
    assert( следщДвоВыше(дво.max) == дво.infinity );

    assert(идентичен_ли(следщПлавВыше(НЧ(0xABC)), НЧ(0xABC)));
    assert( следщПлавВыше(-плав.min) == -плав.min*(1-плав.epsilon) );
    assert( следщПлавВыше(1.0) == 1.0+плав.epsilon );
    assert( следщПлавВыше(-0.0) == плав.min*плав.epsilon);
    assert( следщПлавВыше(плав.infinity)==плав.infinity );

    assert(следщНиже(1.0+реал.epsilon)==1.0);
    assert(следщДвоНиже(1.0+дво.epsilon)==1.0);
    assert(следщПлавНиже(1.0+плав.epsilon)==1.0);
    assert(следщза(1.0+реал.epsilon, -реал.infinity)==1.0);
}
}

package {
/** Reduces the magnitude of x, so the биты in the lower half of its significand
 * are все zero. Returns the amount which needs в_ be добавьed в_ x в_ restore its
 * начальное значение; this amount will also have zeros in все биты in the lower half
 * of its significand.
 */
X разбейЗначимое(X)(ref X x)
{
    if (фабс(x) !< X.infinity) return 0; // don't change НЧ or infinity
    X y = x; // копируй the original значение
    static if (X.mant_dig == плав.mant_dig) {
        бцел *ps = cast(бцел *)&x;
        (*ps) &= 0xFFFF_FC00;
    } else static if (X.mant_dig == 53) {
        бдол *ps = cast(бдол *)&x;
        (*ps) &= 0xFFFF_FFFF_FC00_0000L;
    } else static if (X.mant_dig == 64){ // 80-битные реал
        // An x87 real80 имеется 63 биты, because the 'implied' bit is stored explicitly.
        // This is annoying, because it means the significand cannot be
        // precisely halved. Instead, we разбей it преобр_в 31+32 биты.
        бдол *ps = cast(бдол *)&x;
        (*ps) &= 0xFFFF_FFFF_0000_0000L;
    } else static if (X.mant_dig==113) { // квадрупл
        бдол *ps = cast(бдол *)&x;
        ps[МАНТИССА_ЛСБ] &= 0xFF00_0000_0000_0000L;
    }
    //else static assert(0, "Unsupported размер");

    return y - x;
}

unittest {
    дво x = -0x1.234_567A_AAAA_AAp+250;
    дво y = разбейЗначимое(x);
    assert(x == -0x1.234_5678p+250);
    assert(y == -0x0.000_000A_AAAA_A8p+248);
    assert(x + y == -0x1.234_567A_AAAA_AAp+250);
}
}

/**
 * Calculate the следщ smallest floating точка значение before x.
 *
 * Return the greatest число less than x that is representable as a реал;
 * thus, it gives the previous точка on the IEEE число строка.
 *
 *  $(TABLE_SV
 *    $(SVH x,            следщНиже(x)   )
 *    $(SV  $(INFIN),     реал.max  )
 *    $(SV  $(PLUSMN)0.0, -реал.min*реал.epsilon )
 *    $(SV  -реал.max,    -$(INFIN) )
 *    $(SV  -$(INFIN),    -$(INFIN) )
 *    $(SV  $(NAN),       $(NAN)    )
 * )
 *
 * Remarks:
 * This function is included in the IEEE 754-2008 стандарт.
 * 
 * следщДвоНиже и следщПлавНиже are the corresponding functions for
 * the IEEE дво и IEEE плав число строки.
 */
реал следщНиже(реал x)
{
    return -следщВыше(-x);
}

/** ditto */
дво следщДвоНиже(дво x)
{
    return -следщДвоВыше(-x);
}

/** ditto */
плав следщПлавНиже(плав x)
{
    return -следщПлавВыше(-x);
}

debug(UnitTest) {
unittest {
    assert( следщНиже(1.0 + реал.epsilon) == 1.0);
}
}

/**
 * Calculates the следщ representable значение after x in the direction of y.
 *
 * If y > x, the результат will be the следщ largest floating-точка значение;
 * if y < x, the результат will be the следщ smallest значение.
 * If x == y, the результат is y.
 *
 * Remarks:
 * This function is not generally very useful; it's almost always better в_ use
 * the faster functions следщВыше() or следщНиже() instead.
 *
 * IEEE 754 requirements не реализован:
 * The FE_INEXACT и FE_OVERFLOW exceptions will be raised if x is finite и
 * the function результат is infinite. The FE_INEXACT и FE_UNDERFLOW
 * exceptions will be raised if the function значение is subnormal, и x is
 * not equal в_ y.
 */
реал следщза(реал x, реал y)
{
    if (x==y) return y;
    return (y>x) ? следщВыше(x) : следщНиже(x);
}

/**************************************
 * To что точность is x equal в_ y?
 *
 * Возвращает: the число of significand биты which are equal in x и y.
 * eg, 0x1.F8p+60 и 0x1.F1p+60 are equal в_ 5 биты of точность.
 *
 *  $(TABLE_SV
 *    $(SVH3 x,      y,         отнравх(x, y)  )
 *    $(SV3  x,      x,         typeof(x).mant_dig )
 *    $(SV3  x,      $(GT)= 2*x, 0 )
 *    $(SV3  x,      $(LE)= x/2, 0 )
 *    $(SV3  $(NAN), any,       0 )
 *    $(SV3  any,    $(NAN),    0 )
 *  )
 *
 * Remarks:
 * This is a very fast operation, suitable for use in скорость-critical код.
 */
цел отнравх(X)(X x, X y)
{
    /* Public Domain. Author: Don Clugston, 18 Aug 2005.
     */
  static assert(is(X==реал) || is(X==дво) || is(X==плав), "Only плав, дво, и реал are supported by отнравх");
  
  static if (X.mant_dig == 106) { // дводво.
     цел a = отнравх(cast(дво*)(&x)[МАНТИССА_МСБ], cast(дво*)(&y)[МАНТИССА_МСБ]);
     if (a != дво.mant_dig) return a;
     return дво.mant_dig + отнравх(cast(дво*)(&x)[МАНТИССА_ЛСБ], cast(дво*)(&y)[МАНТИССА_ЛСБ]);     
  } else static if (X.mant_dig==64 || X.mant_dig==113 
                 || X.mant_dig==53 || X.mant_dig == 24) {
    if (x == y) return X.mant_dig; // ensure diff!=0, cope with INF.

    X diff = фабс(x - y);

    бкрат *pa = cast(бкрат *)(&x);
    бкрат *pb = cast(бкрат *)(&y);
    бкрат *pd = cast(бкрат *)(&diff);

    alias плавТрэтсИ3Е!(X) F;

    // The difference in абс(exponent) between x or y и абс(x-y)
    // is equal в_ the число of significand биты of x which are
    // equal в_ y. If негатив, x и y have different exponents.
    // If positive, x и y are equal в_ 'bitsdiff' биты.
    // AND with 0x7FFF в_ form the абсолютный значение.
    // To avoопр out-by-1 ошибки, we вычти 1 so it rounds down
    // if the exponents were different. This means 'bitsdiff' is
    // always 1 lower than we want, except that if bitsdiff==0,
    // they could have 0 or 1 биты in common.

 static if (X.mant_dig==64 || X.mant_dig==113) { // real80 or квадрупл
    цел bitsdiff = ( ((pa[F.БКРАТ_ПОЗ_ЭКСП] & F.МАСКА_ЭКСП) 
                     + (pb[F.БКРАТ_ПОЗ_ЭКСП]& F.МАСКА_ЭКСП)
                     - (0x8000-F.МАСКА_ЭКСП))>>1) 
                - pd[F.БКРАТ_ПОЗ_ЭКСП];
 } else static if (X.mant_dig==53) { // дво
    цел bitsdiff = (( ((pa[F.БКРАТ_ПОЗ_ЭКСП] & F.МАСКА_ЭКСП)
                     + (pb[F.БКРАТ_ПОЗ_ЭКСП] & F.МАСКА_ЭКСП)
                     - (0x8000-F.МАСКА_ЭКСП))>>1) 
                 - (pd[F.БКРАТ_ПОЗ_ЭКСП] & F.МАСКА_ЭКСП))>>4;
 } else static if (X.mant_dig == 24) { // плав
     цел bitsdiff = (( ((pa[F.БКРАТ_ПОЗ_ЭКСП] & F.МАСКА_ЭКСП)
                      + (pb[F.БКРАТ_ПОЗ_ЭКСП] & F.МАСКА_ЭКСП)
                      - (0x8000-F.МАСКА_ЭКСП))>>1) 
             - (pd[F.БКРАТ_ПОЗ_ЭКСП] & F.МАСКА_ЭКСП))>>7;     
 }
    if (pd[F.БКРАТ_ПОЗ_ЭКСП] == 0)
    {   // Difference is denormal
        // For denormals, we need в_ добавь the число of zeros that
        // lie at the старт of diff's significand.
        // We do this by multИПlying by 2^реал.mant_dig
        diff *= F.РЕЦИП_ЭПСИЛОН;
        return bitsdiff + X.mant_dig - pd[F.БКРАТ_ПОЗ_ЭКСП];
    }

    if (bitsdiff > 0)
        return bitsdiff + 1; // добавь the 1 we subtracted before
        
    // Avoопр out-by-1 ошибки when factor is almost 2.    
     static if (X.mant_dig==64 || X.mant_dig==113) { // real80 or квадрупл    
        return (bitsdiff == 0) ? (pa[F.БКРАТ_ПОЗ_ЭКСП] == pb[F.БКРАТ_ПОЗ_ЭКСП]) : 0;
     } else static if (X.mant_dig == 53 || X.mant_dig == 24) { // дво or плав
        return (bitsdiff == 0 && !((pa[F.БКРАТ_ПОЗ_ЭКСП] ^ pb[F.БКРАТ_ПОЗ_ЭКСП])& F.МАСКА_ЭКСП)) ? 1 : 0;
     }
 } else {
    assert(0, "Не поддерживается");
 }
}

debug(UnitTest) {
unittest
{
   // Exact equality
   assert(отнравх(реал.max,реал.max)==реал.mant_dig);
   assert(отнравх(0.0L,0.0L)==реал.mant_dig);
   assert(отнравх(7.1824L,7.1824L)==реал.mant_dig);
   assert(отнравх(реал.infinity,реал.infinity)==реал.mant_dig);

   // a few биты away из_ exact equality
   реал w=1;
   for (цел i=1; i<реал.mant_dig-1; ++i) {
      assert(отнравх(1+w*реал.epsilon,1.0L)==реал.mant_dig-i);
      assert(отнравх(1-w*реал.epsilon,1.0L)==реал.mant_dig-i);
      assert(отнравх(1.0L,1+(w-1)*реал.epsilon)==реал.mant_dig-i+1);
      w*=2;
   }
   assert(отнравх(1.5+реал.epsilon,1.5L)==реал.mant_dig-1);
   assert(отнравх(1.5-реал.epsilon,1.5L)==реал.mant_dig-1);
   assert(отнравх(1.5-реал.epsilon,1.5+реал.epsilon)==реал.mant_dig-2);
   
   assert(отнравх(реал.min/8,реал.min/17)==3);;
   
   // Numbers that are закрой
   assert(отнравх(0x1.Bp+84, 0x1.B8p+84)==5);
   assert(отнравх(0x1.8p+10, 0x1.Cp+10)==2);
   assert(отнравх(1.5*(1-реал.epsilon), 1.0L)==2);
   assert(отнравх(1.5, 1.0)==1);
   assert(отнравх(2*(1-реал.epsilon), 1.0L)==1);

   // Factors of 2
   assert(отнравх(реал.max,реал.infinity)==0);
   assert(отнравх(2*(1-реал.epsilon), 1.0L)==1);
   assert(отнравх(1.0, 2.0)==0);
   assert(отнравх(4.0, 1.0)==0);

   // Extreme inequality
   assert(отнравх(реал.nan,реал.nan)==0);
   assert(отнравх(0.0L,-реал.nan)==0);
   assert(отнравх(реал.nan,реал.infinity)==0);
   assert(отнравх(реал.infinity,-реал.infinity)==0);
   assert(отнравх(-реал.max,реал.infinity)==0);
   assert(отнравх(реал.max,-реал.max)==0);
   
   // floats
   assert(отнравх(2.1f, 2.1f)==плав.mant_dig);
   assert(отнравх(1.5f, 1.0f)==1);
}
}

/*********************************
 * Return 1 if знак bit of e is установи, 0 if not.
 */

цел битзнака(реал x)
{
    return ((cast(ббайт *)&x)[плавТрэтсИ3Е!(реал).ББАЙТ_ПОЗ_ЗНАКА] & 0x80) != 0;
}

debug(UnitTest) {
unittest
{
    assert(!битзнака(плав.nan));
    assert(битзнака(-плав.nan));
    assert(!битзнака(168.1234));
    assert(битзнака(-168.1234));
    assert(!битзнака(0.0));
    assert(битзнака(-0.0));
}
}


/*********************************
 * Return a значение composed of в_ with из_'s знак bit.
 */

реал копируйзнак(реал в_, реал из_)
{
    ббайт* pto   = cast(ббайт *)&в_;
    ббайт* pfrom = cast(ббайт *)&из_;
    
    alias плавТрэтсИ3Е!(реал) F;
    pto[F.ББАЙТ_ПОЗ_ЗНАКА] &= 0x7F;
    pto[F.ББАЙТ_ПОЗ_ЗНАКА] |= pfrom[F.ББАЙТ_ПОЗ_ЗНАКА] & 0x80;
    return в_;
}

debug(UnitTest) {
unittest
{
    реал e;

    e = копируйзнак(21, 23.8);
    assert(e == 21);

    e = копируйзнак(-21, 23.8);
    assert(e == 21);

    e = копируйзнак(21, -23.8);
    assert(e == -21);

    e = копируйзнак(-21, -23.8);
    assert(e == -21);

    e = копируйзнак(реал.nan, -23.8);
    assert(нч_ли(e) && битзнака(e));
}
}

/** Return the значение that lies halfway between x и y on the IEEE число строка.
 *
 * Formally, the результат is the arithmetic mean of the binary significands of x
 * и y, multИПlied by the geometric mean of the binary exponents of x и y.
 * x и y must have the same знак, и must not be НЧ.
 * Note: this function is useful for ensuring O(лог n) behaviour in algorithms
 * involving a 'binary chop'.
 *
 * Special cases:
 * If x и y are внутри a factor of 2, (ie, отнравх(x, y) > 0), the return значение
 * is the arithmetic mean (x + y) / 2.
 * If x и y are even powers of 2, the return значение is the geometric mean,
 *   и3еСреднее(x, y) = квкор(x * y).
 *
 */
T и3еСреднее(T)(T x, T y)
in {
    // Всё x и y must have the same знак, и must not be НЧ.
    assert(битзнака(x) == битзнака(y)); 
    assert(x<>=0 && y<>=0);
}
body {
    // Runtime behaviour for contract violation:
    // If signs are opposite, or one is a НЧ, return 0.
    if (!((x>=0 && y>=0) || (x<=0 && y<=0))) return 0.0;

    // The implementation is simple: cast x и y в_ целыйs,
    // average them (avoопрing перебор), и cast the результат back в_ a floating-точка число.

    alias плавТрэтсИ3Е!(реал) F;
    T u;
    static if (T.mant_dig==64) { // real80
        // There's slight добавьitional complexity because they are actually
        // 79-битные reals...
        бкрат *ue = cast(бкрат *)&u;
        бдол *ul = cast(бдол *)&u;
        бкрат *xe = cast(бкрат *)&x;
        бдол *xl = cast(бдол *)&x;
        бкрат *ye = cast(бкрат *)&y;
        бдол *yl = cast(бдол *)&y;
        // Ignore the useless implicit bit. (Bonus: this prevents overflows)
        бдол m = ((*xl) & 0x7FFF_FFFF_FFFF_FFFFL) + ((*yl) & 0x7FFF_FFFF_FFFF_FFFFL);

        бкрат e = cast(бкрат)((xe[F.БКРАТ_ПОЗ_ЭКСП] & 0x7FFF) + (ye[F.БКРАТ_ПОЗ_ЭКСП] & 0x7FFF));
        if (m & 0x8000_0000_0000_0000L) {
            ++e;
            m &= 0x7FFF_FFFF_FFFF_FFFFL;
        }
        // Сейчас do a multi-байт right shift
        бцел c = e & 1; // carry
        e >>= 1;
        m >>>= 1;
        if (c) m |= 0x4000_0000_0000_0000L; // shift carry преобр_в significand
        if (e) *ul = m | 0x8000_0000_0000_0000L; // установи implicit bit...
        else *ul = m; // ... unless exponent is 0 (denormal or zero).
        ue[4]=  e | (xe[F.БКРАТ_ПОЗ_ЭКСП]& F.МАСКА_ЗНАКА); // restore знак bit
    } else static if(T.mant_dig == 113) { //квадрупл
        // This would be trivial if 'ucent' were implemented...
        бдол *ul = cast(бдол *)&u;
        бдол *xl = cast(бдол *)&x;
        бдол *yl = cast(бдол *)&y;
        // Multi-байт добавь, then multi-байт right shift.        
        бдол mh = ((xl[МАНТИССА_МСБ] & 0x7FFF_FFFF_FFFF_FFFFL) 
                  + (yl[МАНТИССА_МСБ] & 0x7FFF_FFFF_FFFF_FFFFL));
        // Discard the lowest bit (в_ avoопр перебор)
        бдол ml = (xl[МАНТИССА_ЛСБ]>>>1) + (yl[МАНТИССА_ЛСБ]>>>1);
        // добавь the lowest bit back in, if necessary.
        if (xl[МАНТИССА_ЛСБ] & yl[МАНТИССА_ЛСБ] & 1) {
            ++ml;
            if (ml==0) ++mh;
        }
        mh >>>=1;
        ul[МАНТИССА_МСБ] = mh | (xl[МАНТИССА_МСБ] & 0x8000_0000_0000_0000);
        ul[МАНТИССА_ЛСБ] = ml;
    } else static if (T.mant_dig == дво.mant_dig) {
        бдол *ul = cast(бдол *)&u;
        бдол *xl = cast(бдол *)&x;
        бдол *yl = cast(бдол *)&y;
        бдол m = (((*xl) & 0x7FFF_FFFF_FFFF_FFFFL) + ((*yl) & 0x7FFF_FFFF_FFFF_FFFFL)) >>> 1;
        m |= ((*xl) & 0x8000_0000_0000_0000L);
        *ul = m;
    } else static if (T.mant_dig == плав.mant_dig) {
        бцел *ul = cast(бцел *)&u;
        бцел *xl = cast(бцел *)&x;
        бцел *yl = cast(бцел *)&y;
        бцел m = (((*xl) & 0x7FFF_FFFF) + ((*yl) & 0x7FFF_FFFF)) >>> 1;
        m |= ((*xl) & 0x8000_0000);
        *ul = m;
    } else {
        assert(0, "Не реализовано");
    }
    return u;
}

debug(UnitTest) {
unittest {
    assert(и3еСреднее(-0.0,-1e-20)<0);
    assert(и3еСреднее(0.0,1e-20)>0);

    assert(и3еСреднее(1.0L,4.0L)==2L);
    assert(и3еСреднее(2.0*1.013,8.0*1.013)==4*1.013);
    assert(и3еСреднее(-1.0L,-4.0L)==-2L);
    assert(и3еСреднее(-1.0,-4.0)==-2);
    assert(и3еСреднее(-1.0f,-4.0f)==-2f);
    assert(и3еСреднее(-1.0,-2.0)==-1.5);
    assert(и3еСреднее(-1*(1+8*реал.epsilon),-2*(1+8*реал.epsilon))==-1.5*(1+5*реал.epsilon));
    assert(и3еСреднее(0x1p60,0x1p-10)==0x1p25);
    static if (реал.mant_dig==64) { // x87, 80-битные reals
      assert(и3еСреднее(1.0L,реал.infinity)==0x1p8192L);
      assert(и3еСреднее(0.0L,реал.infinity)==1.5);
    }
    assert(и3еСреднее(0.5*реал.min*(1-4*реал.epsilon),0.5*реал.min)==0.5*реал.min*(1-2*реал.epsilon));
}
}

// Functions for НЧ payloads
/*
 * A 'payload' can be stored in the significand of a $(NAN). One bit is требуется
 * в_ distinguish between a quiet и a signalling $(NAN). This leaves 22 биты
 * of payload for a плав; 51 биты for a дво; 62 биты for an 80-битные реал;
 * и 111 биты for a 128-битные quad.
*/
/**
 * Созд a $(NAN), storing an целое insопрe the payload.
 *
 * For 80-битные or 128-битные reals, the largest possible payload is 0x3FFF_FFFF_FFFF_FFFF.
 * For doubles, it is 0x3_FFFF_FFFF_FFFF.
 * For floats, it is 0x3F_FFFF.
 */
реал НЧ(бдол payload)
{
    static if (реал.mant_dig == 64) { //real80
      бдол v = 3; // implied bit = 1, quiet bit = 1
    } else {
      бдол v = 2; // no implied bit. quiet bit = 1
    }

    бдол a = payload;

    // 22 Float биты
    бдол w = a & 0x3F_FFFF;
    a -= w;

    v <<=22;
    v |= w;
    a >>=22;

    // 29 Double биты
    v <<=29;
    w = a & 0xFFF_FFFF;
    v |= w;
    a -= w;
    a >>=29;

    static if (реал.mant_dig == 53) { // дво
        v |=0x7FF0_0000_0000_0000;
        реал x;
        * cast(бдол *)(&x) = v;
        return x;
    } else {
        v <<=11;
        a &= 0x7FF;
        v |= a;
        реал x = реал.nan;
        // Extended реал биты
        static if (реал.mant_dig==113) { //квадрупл
          v<<=1; // there's no implicit bit
          version(ЛитлЭндиан) {
            *cast(бдол*)(6+cast(ббайт*)(&x)) = v;
          } else {
            *cast(бдол*)(2+cast(ббайт*)(&x)) = v;
          }        
        } else { // real80
            * cast(бдол *)(&x) = v;
        }
        return x;
    }
}

/**
 * Extract an integral payload из_ a $(NAN).
 *
 * Возвращает:
 * the целое payload as a бдол.
 *
 * For 80-битные or 128-битные reals, the largest possible payload is 0x3FFF_FFFF_FFFF_FFFF.
 * For doubles, it is 0x3_FFFF_FFFF_FFFF.
 * For floats, it is 0x3F_FFFF.
 */
бдол getNaNPayload(реал x)
{
    assert(нч_ли(x));
    static if (реал.mant_dig == 53) {
        бдол m = *cast(бдол *)(&x);
        // Make it look like an 80-битные significand.
        // SkИП exponent, и quiet bit
        m &= 0x0007_FFFF_FFFF_FFFF;
        m <<= 10;
    } else static if (реал.mant_dig==113) { // квадрупл
        version(ЛитлЭндиан) {
            бдол m = *cast(бдол*)(6+cast(ббайт*)(&x));
        } else {
            бдол m = *cast(бдол*)(2+cast(ббайт*)(&x));
        }
        m>>=1; // there's no implicit bit
    } else {
        бдол m = *cast(бдол *)(&x);
    }
    // ignore implicit bit и quiet bit
    бдол f = m & 0x3FFF_FF00_0000_0000L;
    бдол w = f >>> 40;
    w |= (m & 0x00FF_FFFF_F800L) << (22 - 11);
    w |= (m & 0x7FF) << 51;
    return w;
}

debug(UnitTest) {
unittest {
  реал nan4 = НЧ(0x789_ABCD_EF12_3456);
  static if (реал.mant_dig == 64 || реал.mant_dig==113) {
      assert (getNaNPayload(nan4) == 0x789_ABCD_EF12_3456);
  } else {
      assert (getNaNPayload(nan4) == 0x1_ABCD_EF12_3456);
  }
  дво nan5 = nan4;
  assert (getNaNPayload(nan5) == 0x1_ABCD_EF12_3456);
  плав nan6 = nan4;
  assert (getNaNPayload(nan6) == 0x12_3456);
  nan4 = НЧ(0xFABCD);
  assert (getNaNPayload(nan4) == 0xFABCD);
  nan6 = nan4;
  assert (getNaNPayload(nan6) == 0xFABCD);
  nan5 = НЧ(0x100_0000_0000_3456);
  assert(getNaNPayload(nan5) == 0x0000_0000_3456);
}
}

