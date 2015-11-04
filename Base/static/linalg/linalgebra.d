/*
Redistribution и use in source и binary forms, with or without
modification, are permitted provided that the following conditions
are met:

    Redistributions of source код must retain the above copyright
    notice, this list of conditions и the following disclaimer.

    Redistributions in binary form must reproduce the above
    copyright notice, this list of conditions и the following
    disclaimer in the documentation и/or друг materials provided
    with the ни в каком дистрибутиве.

    Neither имя of Victor Nakoryakov nor the names of
    its contributors may be использован to endorse or promote products
    derived from this software without specific приор written
    permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
OF THE POSSIBILITY OF SUCH DAMAGE.

Copyright (C) 2006. Victor Nakoryakov.
*/
/**
Модуль содержит основные математические объекты, нацеленные для работы с 3D
графикой.

Это 2,3,4-D векторы, кватернион, матрицы 3x3 и 4x4. На случай специализации
под 3D-графику, имеются всегда некоторые средства и производные
из классической математики. Вот сводка по подобным средствам линейной алгебры helix:
$(UL
    $(LI В helix используется парадигма колончатого вектора (column-вектор). Умножение матрицы на
         вектор имеет смысл, а умножение вектора на матрицу не имеет.
         Этот подход придерживается правил, принятых в классической математике, и совпадает 
         с правилами OpenGL. Но противоречит парадигме Direct3D, где вектор является
         рядом (ряд). Так, в helix, для комбинирования последовательности переносов, заданных
		матрицами A, B, C в порядке A, затем B, затем C, нужно умножить их в обратном порядке
         (сзади к переду): M=C*B*A. )

    $(LI При работе с углами euler приняты следующие определения.
         Yaw представляет вращение вокруг Y, Pitch - вращение вокруг X, Roll - вращение вокруг Z.
         Вращения всегда применяются в порядке: Roll, затем Pitch, затем Yaw. )

    $(LI Под матрицы Helix используется column-major memory layout. Т.е. матрица
        $(MAT33
            $(MAT33_ROW a, b, c)
            $(MAT33_ROW d, e, f)
            $(MAT33_ROW g, h, i)
        )
        в памяти выглядит как: a, d, g, b, e, h, c, f, i. Порядок этот аналогичен порядку в
        OpenGL API, но притивоположен Direct3D API. Но, как уже упоминалось, Direct3D
        использует векторно-рядовую парадигму, противоречащую классической математике, 
		поэтому D3D требуется транспонированная матрица, в отличие от классики, чтобы
		получить необходимую трансформацию (перенос). В итоге не требуется транспонировать
		матрицу helix при передаче в API, даже в случае с Direct3D.
		Как правило, помнить о разметке памяти необязательно, просто ею пользуются как в
		классической математике, это имеет значение только в процедурах, оперирующих над
		указателями на данные и над плоскими представлениями массивов.
		В документации на такие методы есть напоминания. )
)

Авторы:
    Виктор Накоряков, nail-mail[at]mail.ru
    
Macros:
    MAT33     = <таблица стиль="border-left: дво 3px #666666; border-right: дво 3px #666666;
                 margin-left: 3em;">$0</таблица>
    MAT33_ROW = <tr><td>$1</td><td>$2</td><td>$3</td></tr>
*/
module math.Linalgebra;

import stdrus;
import linalg.basic,
       linalg.config;

/** Определяет названия ортов, обычно применяемых в качестве индексов. */
enum Орт
{
    X, ///
    Y, /// описано
    Z, /// описано
    W  /// описано
}

/**
Шаблон-обмотчик, предоставляющий возможность использования
в реализуемых структурах и процедурах разных типов с
плавающей запятой.
*/
private template ЛинейнаяАлгебра(т_плав)
{
    private alias linalg.basic.равны          равны;
    
    alias .ЛинейнаяАлгебра!(плав).Вектор2     Вектор2п;
    alias .ЛинейнаяАлгебра!(плав).Вектор3     Вектор3п;
    alias .ЛинейнаяАлгебра!(плав).Вектор4     Вектор4п;
    alias .ЛинейнаяАлгебра!(плав).Кватернион  Кватернионп;
    alias .ЛинейнаяАлгебра!(плав).Матрица22    Матрица22п;
    alias .ЛинейнаяАлгебра!(плав).Матрица33    Матрица33п;
    alias .ЛинейнаяАлгебра!(плав).Матрица44    Матрица44п;
    
    alias .ЛинейнаяАлгебра!(дво).Вектор2    Вектор2д;
    alias .ЛинейнаяАлгебра!(дво).Вектор3    Вектор3д;
    alias .ЛинейнаяАлгебра!(дво).Вектор4    Вектор4д;
    alias .ЛинейнаяАлгебра!(дво).Кватернион Кватернионд;
    alias .ЛинейнаяАлгебра!(дво).Матрица22   Матрица22д;
    alias .ЛинейнаяАлгебра!(дво).Матрица33   Матрица33д;
    alias .ЛинейнаяАлгебра!(дво).Матрица44   Матрица44д;
    
    alias .ЛинейнаяАлгебра!(реал).Вектор2      Вектор2р;
    alias .ЛинейнаяАлгебра!(реал).Вектор3      Вектор3р;
    alias .ЛинейнаяАлгебра!(реал).Вектор4      Вектор4р;
    alias .ЛинейнаяАлгебра!(реал).Кватернион   Кватернионр;
    alias .ЛинейнаяАлгебра!(реал).Матрица22     Матрица22р;
    alias .ЛинейнаяАлгебра!(реал).Матрица33     Матрица33р;
    alias .ЛинейнаяАлгебра!(реал).Матрица44     Матрица44р;

    /************************************************************************************
    Двухмерный вектор.

    Формальное определение вектора, значение возможных операций и связанная с этим
    информация приведена на стр. $(LINK http://en.wikipedia.org/wiki/Vector_(spatial)).
    *************************************************************************************/
    struct Вектор2
    {
        enum { длина = 2u }

        align(1)
        {
            т_плав x; /// Компоненты вектора.
            т_плав y; /// описано
        }
        
        static Вектор2 нч = { т_плав.nan, т_плав.nan }; /// Вектор, у которого обе компоненты установлены в NaN.
        static Вектор2 ноль = { 0, 0 };                    /// Нулевой вектор 

        static Вектор2 едИкс = { 1, 0 };                   /// Unit вектор codirectional with corresponding ось.
        static Вектор2 едИгрек = { 0, 1 };                   /// описано
        
        
        /**
        Метод для построения вектора в стиле синтаксиса Си.

        Пример:
        ------------
        Вектор2 myVector = Вектор2(1, 2);
        ------------
        */
        static Вектор2 opCall(т_плав x, т_плав y)
        {
            Вектор2 v;
            v.установи(x, y);
            return v;
        }
        
        /** Метод для построения из массива. */
        static Вектор2 opCall(т_плав[2] p)
        {
            Вектор2 v;
            v.установи(p);
            return v;
        }
        
        /** Устанавливает значения компонент на передаваемые значения. */
        проц установи(т_плав x, т_плав y)
        {
            this.x = x;
            this.y = y;
        }
        
        /** Устанавливает значения компонент на передаваемые значения. */
        проц установи(т_плав[2] p)
        {
            this.x = p[0];
            this.y = p[1];
        }
        
        /** Возвращает: Нормаль (также известную как длину, величину) вектора. */
        реал нормаль()
        {
            return гипот(x, y);
        }
    
        /**
        Возвращает: Квадрат нормали вектора.
        
        Поскольку данный метод не требует вычисления квадратного корня, лучше
        использовать его, а не нормаль(). Например, если нужно просто узнать,
        который из 2-х векторов длинее, то лучше всего сравнить квадраты их нормалей,
        а не сами нормали.
        */
        реал квадратНорм()
        {
            return x*x + y*y;
        }
    
        /** Нормализует данный вектор. Возвращает: исходную длину. */
        реал нормализуй()
        {
            реал длин = нормаль();
            *this /= длин;
            return длин;
        }
    
        /** Возвращает: Нормализованную копию данного вектора. */
        Вектор2 нормализованный()
        {
            реал n = нормаль;
            return Вектор2(x / n, y / n);
        }
    
        /**
        Возвращает: Является ли данный вектор единицей (unit).
        Параметры:
            отнпрец, абспрец = Параметры, передаваемые функции равны при сравнении
                               квадрата нормали и 1. Имеет то же значение, что и в функции равны.
        */
        бул единица_ли(цел отнпрец = дефотнпрец, цел абспрец = дефабспрец)
        {
            return равны( квадратНорм(), 1, отнпрец, абспрец );
        }
    
        /** Возвращает: Ось, для которой проекция данного вектора будет самой длинной. */
        Орт доминирующаяОсь()
        {
            return (x > y) ? Орт.X : Орт.Y;
        }
    
        /** Возвращает: Являются ли все компоненты нормализованными числами. */
        бул нормален_ли()
        {
            return stdrus.нормален_ли(x) && stdrus.нормален_ли(y);
        }
    
        /** Возвращает: т_плав указатель на компоненту x данного вектора. Подобен методу _ptr для массивов. */
        т_плав* укз()
        {
            return cast(т_плав*)this;
        }
    
        /** Возвращает: Компоненту, соответствующую переданному индексу. */
        т_плав opIndex(т_мера орт)
        in { assert(орт <= Орт.Y); }
        body
        {
            return укз[cast(цел)орт];
        }
    
        /** Присваивает компоненте новое значение (_value), соответствующее переданному индексу. */
        проц opIndexAssign(т_плав значение, т_мера орт)
        in { assert(орт <= Орт.Y); }
        body
        {
            укз[cast(цел)орт] = значение;
        }
    
        /**
        Стандартные операторы, значения которых понятны интуитивно. Аналогичны классической математике.
        
        Внимание: операторы деления не выполняют проверок значения k, поэтому в случае деления на
        0 результирующий вектор будет иметь компоненты с бесконечностью. Это можно проверить с помощью
	    метода нормален_ли().
        */
        бул opEquals(Вектор2 v)
        {
            return x == v.x && y == v.y;
        }
    
        /** описано */
        Вектор2 opNeg()
        {
            return Вектор2(-x, -y);
        }
    
        /** описано */
        Вектор2 opAdd(Вектор2 v)
        {
            return Вектор2(x + v.x, y + v.y);
        }
    
        /** описано */
        проц opAddAssign(Вектор2 v)
        {
            x += v.x;
            y += v.y;
        }
    
        /** описано */
        Вектор2 opSub(Вектор2 v)
        {
            return Вектор2(x - v.x, y - v.y);
        }
    
        /** описано */
        проц opSubAssign(Вектор2 v)
        {
            x -= v.x;
            y -= v.y;
        }
    
        /** описано */
        Вектор2 opMul(реал k)
        {
            return Вектор2(x * k, y * k);
        }
    
        /** описано */
        проц opMulAssign(реал k)
        {
            x *= k;
            y *= k;
        }
    
        /** описано */
        Вектор2 opMul_r(реал k)
        {
            return Вектор2(x * k, y * k);
        }
    
        /** описано */
        Вектор2 opDiv(реал k)
        {
            return Вектор2(x / k, y / k);
        }
    
        /** описано */
        проц opDivAssign(реал k)
        {
            x /= k;
            y /= k;
        }
    
        /** Возвращает: Вектор, перепендикулярный к данному */
        Вектор2 перпендикуляр() 
        {
            return Вектор2(-y,x);
        }

        /** Возвращает: Копию данного вектора с компонентами типа плав */
        Вектор2п вВектор2п()
        {
            return Вектор2п(cast(плав)x, cast(плав)y);
        }
        
        /** Возвращает: Копию данного вектора с компонентами типа дво */
        Вектор2д вВектор2д()
        {
            return Вектор2д(cast(дво)x, cast(дво)y);
        }
        
        /** Возвращает: Копию данного вектора с компонентами типа реал */
        Вектор2р вВектор2р()
        {
            return Вектор2р(cast(реал)x, cast(реал)y);
        }
    
        /**
        Процедуры, известные как swizzling.
        Возвращает:
            Новый вектор, построенный из данного. Значения его компонент
            соответствуют названию метода.
        */
        Вектор3 xy0()    { return Вектор3(x, y, 0); }
        Вектор3 x0y()    { return Вектор3(x, 0, y); } /// описано

        ткст вТкст() { return фм("[",x,", ",y,"]"); }
    }
    
    public {
    /** Возвращает: Производную точки между переданными векторами. */
    реал точка(Вектор2 a, Вектор2 b)
    {
        return a.x * b.x + a.y * b.y;
    }
        
    /** Возвращает: Внешнюю производную между переданными векторами. */
    Матрица22 внешн(Вектор2 a, Вектор2 b)
    {
        return Матрица22( a.x * b.x, a.x * b.y,
                         a.y * b.x, a.y * b.y);
    }
        
    /**
    Возвращает: Производную пересечения между заданными векторами. Результатом является скаляр c,
    при этом [a.x a.y 0], [b.x b.y 0], [0,0,c] образуют правую тройку (right-hand tripple).
    */
    реал кросс(Вектор2 a, Вектор2 b)
    {
        return a.x * b.y - b.x * a.y;
    }


    alias РавенствоПоНорм!(Вектор2).равны равны; /// Представляет функцию приближенного равенства для Вектор2.
    alias Лининтерп!(Вектор2).лининтерп лининтерп;             /// Представляет функцию линейной интерполяции для Вектор2.
    } // end public
    
    /************************************************************************************
    Трёхмерный вектор.

    Формальное определение вектора, значение возможных операций и связанную с этим
    информацию можно найти на странице $(LINK http://en.wikipedia.org/wiki/Vector_(spatial)).
    *************************************************************************************/
    struct Вектор3
    {
        enum { длина = 3u }

        align(1)
        {
            т_плав x; /// Компоненты вектора.
            т_плав y; /// описано
            т_плав z; /// описано
        }
        
        static Вектор3 нч = { т_плав.nan, т_плав.nan, т_плав.nan }; /// Вектор, у которого все компоненты установлены в NaN.
        static Вектор3 ноль = {0,0,0};    // The ноль вектор
        static Вектор3 едИкс = { 1, 0, 0 };  /// Unit вектор, сонаправленный с определенной осью.
        static Вектор3 едИгрек = { 0, 1, 0 };  /// описано
        static Вектор3 едД = { 0, 0, 1 };  /// описано
        
        /**
        Метод для построения вектора в стиле Си.

        Примеры:
        ------------
        Вектор3 myVector = Вектор3(1, 2, 3);
        ------------
        */
        static Вектор3 opCall(т_плав x, т_плав y, т_плав z)
        {
            Вектор3 v;
            v.установи(x, y, z);
            return v;
        }
        
        /** Метод для построения из массива */
        static Вектор3 opCall(т_плав[3] p)
        {
            Вектор3 v;
            v.установи(p);
            return v;
        }
        
        /** Устанавливает значения компонент на передаваемые значения. */
        проц установи(т_плав x, т_плав y, т_плав z)
        {
            this.x = x;
            this.y = y;
            this.z = z;
        }
    
        
        /** Устанавливает значения компонент на передаваемые значения. */
        проц установи(т_плав[3] p)
        {
            this.x = p[0];
            this.y = p[1];
            this.z = p[2];
        }
    
        
        /** Возвращает: Norm (also known as длина, magnitude) of вектор. */
        реал нормаль()
        {
            return квкор(x*x + y*y + z*z);
        }
    
        /**
        Возвращает: Квадрат нормали вектора.
        
        Поскольку этот метод не нуждается в вычислениии квадратного корня, то по возможности
        лучше использовать его вместо нормаль(). Например, если нужно просто узнать
        который из 2-х веторов длиннее - сравнить вместо их нормалей квадраты этих нормалей.
        */
        реал квадратНорм()
        {
            return x*x + y*y + z*z;
        }
    
        /** Normalizes this вектор. Возвращает: the original длина */
        реал нормализуй()
        {
            реал длин = нормаль();
            *this /= длин;
            return длин;
        }
    
        /** Возвращает: Normalized копируй of this вектор. */
        Вектор3 нормализованный()
        {
            реал n = нормаль;
            return Вектор3(x / n, y / n, z / n);
        }
    
        /**
        Возвращает: Whether this вектор is unit.
        Params:
            отнпрец, абспрец = Parameters passed to равны function while comparison of
                               нормаль square и 1. Have the same meaning as in равны function.
        */
        бул единица_ли(цел отнпрец = дефотнпрец, цел абспрец = дефабспрец)
        {
            return равны( квадратНорм(), 1, отнпрец, абспрец );
        }
    
        /** Возвращает: Axis for which projection of this вектор on it will be longest. */
        Орт доминирующаяОсь()
        {
            if (x > y)
                return (x > z) ? Орт.X : Орт.Z;
            else
                return (y > z) ? Орт.Y : Орт.Z;
        }
    
        /** Возвращает: Whether all components are нормализованный numbers. */
        бул нормален_ли()
        {
            return stdrus.нормален_ли(x) && stdrus.нормален_ли(y) && stdrus.нормален_ли(z);
        }
    
        /** Возвращает: т_плав pointer to x component of this вектор. It's like a _ptr method for arrays. */
        т_плав* укз()
        {
            return cast(т_плав*)(&x);
        }
    
        /** Возвращает: Component corresponded to passed index. */
        т_плав opIndex(т_мера орт)
        in { assert(орт <= Орт.Z); }
        body
        {
            return укз[cast(цел)орт];
        }
    
        /** Assigns new _value to component corresponded to passed index. */
        проц opIndexAssign(т_плав значение, т_мера орт)
        in { assert(орт <= Орт.Z); }
        body
        {
            укз[cast(цел)орт] = значение;
        }
    
        /**
        Standard operators that have intuitive meaning, same as in classical math.
        
        Note that division operators do no cheks of значение of k, so in case of division
        by 0 result вектор will have infinity components. You can проверь this with нормален_ли()
        method.
        */
        бул opEquals(Вектор3 v)
        {
            return x == v.x && y == v.y && z == v.z;
        }
    
        /** описано */
        Вектор3 opNeg()
        {
            return Вектор3(-x, -y, -z);
        }
    
        /** описано */
        Вектор3 opAdd(Вектор3 v)
        {
            return Вектор3(x + v.x, y + v.y, z + v.z);
        }
    
        /** описано */
        проц opAddAssign(Вектор3 v)
        {
            x += v.x;
            y += v.y;
            z += v.z;
        }
    
        /** описано */
        Вектор3 opSub(Вектор3 v)
        {
            return Вектор3(x - v.x, y - v.y, z - v.z);
        }
    
        /** описано */
        проц opSubAssign(Вектор3 v)
        {
            x -= v.x;
            y -= v.y;
            z -= v.z;
        }
    
        /** описано */
        Вектор3 opMul(реал k)
        {
            return Вектор3(x * k, y * k, z * k);
        }
    
        /** описано */
        проц opMulAssign(реал k)
        {
            x *= k;
            y *= k;
            z *= k;
        }
    
        /** описано */
        Вектор3 opMul_r(реал k)
        {
            return Вектор3(x * k, y * k, z * k);
        }
    
        /** описано */
        Вектор3 opDiv(реал k)
        {
            return Вектор3(x / k, y / k, z / k);
        }
    
        /** описано */
        проц opDivAssign(реал k)
        {
            x /= k;
            y /= k;
            z /= k;
        }
        
        /** Возвращает: Copy of this вектор with плав type components */
        Вектор3п вВектор3п()
        {
            return Вектор3п(cast(плав)x, cast(плав)y, cast(плав)z);
        }
        
        /** Возвращает: Copy of this вектор with дво type components */
        Вектор3д вВектор3д()
        {
            return Вектор3д(cast(дво)x, cast(дво)y, cast(дво)z);
        }

        /** Возвращает: Copy of this вектор with реал type components */
        Вектор3р вВектор3р()
        {
            return Вектор3р(cast(реал)x, cast(реал)y, cast(реал)z);
        }

    
        /**
        Routines known as swizzling.
        Возвращает:
            Нов вектор constructed from this one и having component значения
            that correspond to method имя.
        */
        Вектор4 xyz0()        { return Вектор4(x,y,z,0); }
        Вектор4 xyz1()        { return Вектор4(x,y,z,1); } /// описано
        Вектор2 xy()          { return Вектор2(x, y); }    /// описано
        Вектор2 xz()          { return Вектор2(x, z); }    /// описано
        
        /**
        Routines known as swizzling.
        Assigns new значения to some components corresponding to method имя.
        */
        проц xy(Вектор2 v)    { x = v.x; y = v.y; }
        проц xz(Вектор2 v)    { x = v.x; z = v.y; }        /// описано

        ткст вТкст() { return фм("[",x,", ",y,", ", z, "]"); }
    }
    
    public {

    /** Возвращает: Dot product between passed vectors. */
    реал точка(Вектор3 a, Вектор3 b)
    {
        return a.x * b.x + a.y * b.y + a.z * b.z;
    }
    
    /** Возвращает: Outer product between passed vectors. */
    Матрица33 внешн(Вектор3 a, Вектор3 b)
    {
        return Матрица33( a.x * b.x,  a.x * b.y,  a.x * b.z,
                         a.y * b.x,  a.y * b.y,  a.y * b.z,
                         a.z * b.x,  a.z * b.y,  a.z * b.z);
    }
        

    /**
    Возвращает: Cross product between passed vectors. Result is вектор c
    so that a, b, c forms right-hand tripple.
    */
    Вектор3 кросс(Вектор3 a, Вектор3 b)
    {
        return Вектор3(
            a.y * b.z - b.y * a.z,
            a.z * b.x - b.z * a.x,
            a.x * b.y - b.x * a.y  );
    }
    
    /**
    Возвращает: Является ли переданное основание ортогональным.
    Params:
        r, s, t =          Векторы, образующие основание.
        отнпрец, абспрец = Параметры, передаваемые функции сравнения при вычислениях.
                           Имею то же значение, что и в функции равны.
    Ссылки:
        $(LINK http://en.wikipedia.org/wiki/Orthogonal_basis)
    */
    бул ортогонально_лиОснование(Вектор3 r, Вектор3 s, Вектор3 t, цел отнпрец = дефотнпрец, цел абспрец = дефабспрец)
    {
        return равны( кросс(r, кросс(s, t)).квадратНорм, 0, отнпрец, абспрец );
    }
    
    /**
    Возвращает: Является ли переданное основание ортонормальным.
    Params:
        r, s, t =   Векторы, образующие основание.
        отнпрец, абспрец = Параметры, передаваемые функции сравнения при вычислениях.
                           Имею то же значение, что и в функции равны.
    Ссылки:
        $(LINK http://en.wikipedia.org/wiki/Orthonormal_basis)
    */
    бул ортонормально_лиОснование(Вектор3 r, Вектор3 s, Вектор3 t, цел отнпрец = дефотнпрец, цел абспрец = дефабспрец)
    {
        return ортогонально_лиОснование(r, s, t, отнпрец, абспрец) &&
            r.единица_ли(отнпрец, абспрец) &&
            s.единица_ли(отнпрец, абспрец) &&
            t.единица_ли(отнпрец, абспрец);
    }
    
    alias РавенствоПоНорм!(Вектор3).равны равны; /// Introduces approximate equality function for Вектор3.
    alias Лининтерп!(Вектор3).лининтерп лининтерп;             /// Introduces linear interpolation function for Вектор3.
    
    } // end public
    
    /************************************************************************************
    4D вектор.

    For formal definition of вектор, meaning of possible operations и related
    information see $(LINK http://en.wikipedia.org/wiki/Vector_(spatial)),
    $(LINK http://en.wikipedia.org/wiki/Homogeneous_coordinates).
    *************************************************************************************/
    struct Вектор4
    {
        enum { длина = 4u }

        align(1)
        {
            т_плав x; /// Components of вектор.
            т_плав y; /// описано
            т_плав z; /// описано
            т_плав w; /// описано
        }
        
        /// Вектор with all components установи to NaN.
        static Вектор4 нч = { т_плав.nan, т_плав.nan, т_плав.nan, т_плав.nan };
        static Вектор4 ноль = { 0,0,0,0 };
        static Вектор4 едИкс = { 1, 0, 0, 0 }; /// Unit вектор codirectional with corresponding ось.
        static Вектор4 едИгрек = { 0, 1, 0, 0 }; /// описано
        static Вектор4 едД = { 0, 0, 1, 0 }; /// описано
        static Вектор4 едШ = { 0, 0, 0, 1 }; /// описано
        
        /**
        Methods to construct вектор in C-like syntax.

        Примеры:
        ------------
        Вектор4 myVector = Вектор4(1, 2, 3, 1);
        Вектор4 myVector = Вектор4(Вектор3(1, 2, 3), 0);
        Вектор4 myVector = Вектор4([1,2,3,1]);
        ------------
        */
        static Вектор4 opCall(т_плав x, т_плав y, т_плав z, т_плав w)
        {
            Вектор4 v;
            v.установи(x, y, z, w);
            return v;
        }
        
        /** описано */
        static Вектор4 opCall(Вектор3 xyz, т_плав w)
        {
            Вектор4 v;
            v.установи(xyz, w);
            return v;
        }
    
        /** описано */
        static Вектор4 opCall(т_плав[4] p)
        {
            Вектор4 v;
            v.установи(p);
            return v;
        }
    
        /** Sets значения of components to passed значения. */
        проц установи(т_плав x, т_плав y, т_плав z, т_плав w)
        {
            this.x = x;
            this.y = y;
            this.z = z;
            this.w = w;
        }
    
        /** описано */
        проц установи(Вектор3 xyz, т_плав w)
        {
            this.x = xyz.x;
            this.y = xyz.y;
            this.z = xyz.z;
            this.w = w;
        }
    
        /** описано */
        проц установи(т_плав[4] p)
        {
            this.x = p[0];
            this.y = p[1];
            this.z = p[2];
            this.w = p[3];
        }
    
        

        /**
        Возвращает: Norm (also known as длина, magnitude) of вектор.
        
        W-component is taken into account.
        */
        реал нормаль()
        {
            return квкор(x*x + y*y + z*z + w*w);
        }
    
        /**
        Возвращает: Square of вектор's нормаль.

        W-component is taken into account.
        
        Since this method doesn't need calculation of square корень it is better
        to use it instead of нормаль() when you can. For example, if you want just
        to know which of 2 vectors is longer it's better to сравни their нормаль
        squares instead of their нормаль.
        */
        реал квадратНорм()
        {
            return x*x + y*y + z*z + w*w;
        }
    
        /** Normalizes this вектор. Возвращает: the original длина. */
        реал нормализуй()
        {
            реал длин = нормаль();
            *this /= длин;
            return длин;
        }
    
        /** Возвращает: Normalized копируй of this вектор. */
        Вектор4 нормализованный()
        {
            реал n = нормаль;
            return Вектор4(x / n, y / n, z / n, w / n);
        }
    
        /**
        Возвращает: Whether this вектор is unit.
        Params:
            отнпрец, абспрец = Parameters passed to равны function while comparison of
                               нормаль square и 1. Have the same meaning as in равны function.
        */
        бул единица_ли(цел отнпрец = дефотнпрец, цел абспрец = дефабспрец)
        {
            return равны( квадратНорм, 1, отнпрец, абспрец );
        }
    
        /**
        Возвращает: Axis for which projection of this вектор on it will be longest.
        
        W-component is taken into account.
        */
        Орт доминирующаяОсь()
        {
            if (x > y)
            {
                if (x > z)
                    return (x > w) ? Орт.X : Орт.W;
                else
                    return (z > w) ? Орт.Z : Орт.W;
            }
            else
            {
                if (y > z)
                    return (y > w) ? Орт.Y : Орт.W;
                else
                    return (z > w) ? Орт.Z : Орт.W;
            }
        }
    
        /** Возвращает: Whether all components are нормализованный numbers. */
        бул нормален_ли()
        {
            return stdrus.нормален_ли(x) && stdrus.нормален_ли(y) && stdrus.нормален_ли(z) && stdrus.нормален_ли(w);
        }
    
        /** Возвращает: т_плав pointer to x component of this вектор. It's like a _ptr method for arrays. */
        т_плав* укз()
        {
            return cast(т_плав*)(&x);
        }
        
        /** Возвращает: Component corresponded to passed index. */
        т_плав opIndex(т_мера орт)
        in { assert(орт <= Орт.W); }
        body
        {
            return укз[cast(цел)орт];
        }
    
        /** Assigns new значение to component corresponded to passed index. */
        проц opIndexAssign(т_плав значение, т_мера орт)
        in { assert(орт <= Орт.W); }
        body
        {
            укз[cast(цел)орт] = значение;
        }
    
        /**
        Standard operators that have intuitive meaning, same as in classical math.
        
        Note that division operators do no cheks of значение of k, so in case of division
        by 0 result вектор will have infinity components. You can проверь this with нормален_ли()
        method.
        */
        бул opEquals(Вектор4 v)
        {
            return x == v.x && y == v.y && z == v.z && w == v.w;
        }
    
        /** описано */
        Вектор4 opNeg()
        {
            return Вектор4(-x, -y, -z, -w);
        }
    
        /** описано */
        Вектор4 opAdd(Вектор4 v)
        {
            return Вектор4(x + v.x, y + v.y, z + v.z, w + v.w);
        }
    
        /** описано */
        проц opAddAssign(Вектор4 v)
        {
            x += v.x;
            y += v.y;
            z += v.z;
            w += v.w;
        }
    
        /** описано */
        Вектор4 opSub(Вектор4 v)
        {
            return Вектор4(x - v.x, y - v.y, z - v.z, w - v.w);
        }
    
        /** описано */
        проц opSubAssign(Вектор4 v)
        {
            x -= v.x;
            y -= v.y;
            z -= v.z;
            w -= v.w;
        }
    
        /** описано */
        Вектор4 opMul(реал k)
        {
            return Вектор4(x * k, y * k, z * k, w * k);
        }
    
        /** описано */
        проц opMulAssign(реал k)
        {
            x *= k;
            y *= k;
            z *= k;
            w *= k;
        }
    
        /** описано */
        Вектор4 opMul_r(реал k)
        {
            return Вектор4(x * k, y * k, z * k, w * k);
        }
    
        /** описано */
        Вектор4 opDiv(реал k)
        {
            return Вектор4(x / k, y / k, z / k, w / k);
        }
    
        /** описано */
        проц opDivAssign(реал k)
        {
            x /= k;
            y /= k;
            z /= k;
            w /= k;
        }
    
        /** Возвращает: Copy of this вектор with плав type components */
        Вектор4п вВектор4п()
        {
            return Вектор4п(cast(плав)x, cast(плав)y, cast(плав)z, cast(плав)w);
        }
        
        /** Возвращает: Copy of this вектор with дво type components */
        Вектор4д вВектор4д()
        {
            return Вектор4д(cast(дво)x, cast(дво)y, cast(дво)z, cast(дво)w);
        }
        
        /** Возвращает: Copy of this вектор with реал type components */
        Вектор4р вВектор4р()
        {
            return Вектор4р(cast(реал)x, cast(реал)y, cast(реал)z, cast(реал)w);
        }
    
        /**
        Routine known as swizzling.
        Возвращает:
            Вектор3 that имеется the same x, y, z components значения.
        */
        Вектор3 xyz()   { return Вектор3(x,y,z); }    
        
        /**
        Routine known as swizzling.
        Assigns new значения to x, y, z components corresponding to аргумент's components значения.
        */
        проц xyz(Вектор3 v)    { x = v.x; y = v.y; z = v.z; }        

        ткст вТкст() { return фм("[",x,", ",y,", ", z, ", ", w, "]"); }

    }
    
    public {

    /** Возвращает: Dot product between passed vectors. */
    реал точка(Вектор4 a, Вектор4 b)
    {
        return a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w;
    }
    
    /** Возвращает: Outer product between passed vectors. */
    Матрица44 внешн(Вектор4 a, Вектор4 b)
    {
        return Матрица44( a.x * b.x,  a.x * b.y,  a.x * b.z, a.x * b.w,
                         a.y * b.x,  a.y * b.y,  a.y * b.z, a.y * b.w,
                         a.z * b.x,  a.z * b.y,  a.z * b.z, a.z * b.w,
                         a.w * b.x,  a.w * b.y,  a.w * b.z, a.w * b.w);
    }

    alias РавенствоПоНорм!(Вектор4).равны равны; /// Introduces approximate equality function for Вектор4.
    alias Лининтерп!(Вектор4).лининтерп лининтерп;             /// Introduces linear interpolation function for Вектор4.
    
    } // end public
    
    /************************************************************************************
    _Quaternion.

    For formal definition of quaternion, meaning of possible operations и related
    information see $(LINK http://en.wikipedia.org/wiki/_Quaternion),
    $(LINK http://en.wikipedia.org/wiki/Quaternions_and_spatial_rotation).
    *************************************************************************************/
    struct Кватернион
    {
        align(1)
        {
            union
            {
                struct
                {
                    т_плав x; /// Components of quaternion.
                    т_плав y; /// описано
                    т_плав z; /// описано
                }
                
                Вектор3 вектор; /// Вектор part. Can be использован instead of явный members x, y и z.
            }
    
            union
            {
                т_плав w;      /// Скаляр part.
                т_плав скаляр; /// Another имя for _scalar part.
            }
        }
        
        /// Identity quaternion.
        static Кватернион подобие;
        /// Кватернион with all components установи to NaN.
        static Кватернион нч = { x: т_плав.nan, y: т_плав.nan, z: т_плав.nan, w: т_плав.nan };
    
        /**
        Methods to construct quaternion in C-like syntax.

        Примеры:
        ------------
        Кватернион q1 = Кватернион(0, 0, 0, 1);
        Кватернион q2 = Кватернион(Вектор3(0, 0, 0), 1);
        Кватернион q3 = Кватернион(Матрица33.вращИгрек(ПИ / 6), 1);
        ------------
        */
        static Кватернион opCall(т_плав x, т_плав y, т_плав z, т_плав w)
        {
            Кватернион q;
            q.установи(x, y, z, w);
            return q;
        }
    
        /** описано */
        static Кватернион opCall(Вектор3 вектор, т_плав скаляр)
        {
            Кватернион q;
            q.установи(вектор, скаляр);
            return q;
        }
        
        /** описано */
        static Кватернион opCall(Матрица33 мат)
        {
            Кватернион q;
            q.установи(мат);
            return q;
        }
        
        /** Sets значения of components according to passed значения. */
        проц установи(т_плав x, т_плав y, т_плав z, т_плав w)
        {
            this.x = x;
            this.y = y;
            this.z = z;
            this.w = w;
        }
    
        /** описано */
        проц установи(Вектор3 вектор, т_плав скаляр)
        {
            this.вектор = вектор;
            this.скаляр = скаляр;
        }
        
        /**
        Sets quaternion, so that, it will represent same вращение as in мат matrix аргумент.
        Params:
            мат = Matrix to выкинь вращение from. Should be pure вращение matrix.
        Throws:
            AssertError if мат is not pure вращение matrix и module was compiled with
            contract проверьings are enabled.
        */
        // NOTE: refactor to use мат.ptr instead of [] operator if
        // perforance will be unsatisfactory.
        проц установи(Матрица33 мат)
        in { assert(мат.вращение_ли()); }
        body
        {
            // Algorithm stolen from OGRE (http://ogre.sourceforge.net)
            реал след = мат[0, 0] + мат[1, 1] + мат[2, 2];
            реал корень;
        
            if ( след > 0 )
            {
                // |w| > 1/2, may as well choose w > 1/2
                корень = квкор(след + 1);  // 2w
                w = 0.5 * корень;
                корень = 0.5 / корень;  // 1/(4w)
                x = (мат[2, 1] - мат[1, 2]) * корень;
                y = (мат[0, 2] - мат[2, 0]) * корень;
                z = (мат[1, 0] - мат[0, 1]) * корень;
            }
            else
            {
                // |w| <= 1/2
                static цел[3] следщ = [ 1, 2, 0 ];
                цел i = 0;
                if ( мат[1, 1] > мат[0, 0] )
                    i = 1;
                if ( мат[2, 2] > мат[i, i] )
                    i = 2;
                цел j = следщ[i];
                цел k = следщ[j];
                
                корень = квкор(мат[i, i] - мат[j, j] - мат[k, k] + 1);
                *(&x + i) = 0.5 * корень;
                корень = 0.5 / корень;
                /+
                 // User "Helmut Duregger reports this sometimes 
                 // causes mirroring of rotations, и that Ogre
                 // actually uses the uncommented version below.

                 w = (мат[j, k] - мат[k, j]) * корень;
                 *(&x + j) = (мат[i, j] + мат[j, i]) * корень;
                 *(&x + k) = (мат[i, k] + мат[k, i]) * корень;
                +/
                w = (мат[k, j] - мат[j, k]) * корень;
                *(&x + j) = (мат[j, i] + мат[i, j]) * корень;
                *(&x + k) = (мат[k, i] + мат[i, k]) * корень;

            }
        }
        
        /** Construct quaternion that represents вращение around corresponding ось. */
        static Кватернион вращИкс(т_плав радианы)
        {
            Кватернион q;
            
            т_плав s = син(радианы * 0.5f);
            т_плав c = кос(радианы * 0.5f);
            q.x = s;
            q.y = 0;
            q.z = 0;
            q.w = c;
            
            return q;
        }
    
        /** описано */
        static Кватернион вращИгрек(т_плав радианы)
        {
            Кватернион q;
            
            т_плав s = син(радианы * 0.5f);
            т_плав c = кос(радианы * 0.5f);
            q.x = 0;
            q.y = s;
            q.z = 0;
            q.w = c;
            
            return q;
        }
    
        /** описано */
        static Кватернион вращЗэт(т_плав радианы)
        {
            Кватернион q;
            
            т_плав s = син(радианы * 0.5f);
            т_плав c = кос(радианы * 0.5f);
            q.x = 0;
            q.y = 0;
            q.z = s;
            q.w = c;
            
            return q;
        }
    
        /**
        Constructs quaternion that represents _rotation specified by euler angles passed as аргументы.
        Order of _rotation application is: roll (Z ось), pitch (X ось), yaw (Y ось).
        */
        static Кватернион вращение(т_плав yaw, т_плав pitch, т_плав roll)
        {
            return Кватернион.вращИгрек(yaw) * Кватернион.вращИкс(pitch) * Кватернион.вращЗэт(roll);
        }
    
        /**
        Constructs quaternion that represents _rotation around 'ось' _axis by 'радианы' angle.
        */
        static Кватернион вращение(Вектор3 ось, т_плав радианы)
        {
            Кватернион q;
            
            т_плав s = син(радианы * 0.5f);
            т_плав c = кос(радианы * 0.5f);
            q.x = ось.x * s;
            q.y = ось.y * s;
            q.z = ось.z * s;
            q.w = c;
            
            return q;
        }
    
        /** Возвращает: Norm (also known as длина, magnitude) of quaternion. */
        реал нормаль()
        {
            return квкор(x*x + y*y + z*z + w*w);
        }
    
        /**
        Возвращает: Square of вектор's нормаль.
        
        Method doesn't need calculation of square корень.
        */
        реал квадратНорм()
        {
            return x*x + y*y + z*z + w*w;
        }
    
        /** Normalizes this quaternion. Возвращает: the original длина. */
        реал нормализуй()
        {
            т_плав n = нормаль();
            assert( больше(n, 0) );
            *this /= n;
            return n;
        }
    
        /** Возвращает: Normalized копируй of this quaternion. */
        Кватернион нормализованный()
        {
            т_плав n = нормаль();
            assert( больше(n, 0) );
            return Кватернион(x / n, y / n, z / n, w / n);
        }
    
        /**
        Возвращает: Whether this quaternion is unit.
        Params:
            отнпрец, абспрец = Parameters passed to равны function while comparison of
                               нормаль square и 1. Have the same meaning as in равны function.
        */
        бул единица_ли(цел отнпрец = дефотнпрец, цел абспрец = дефабспрец)
        {
            return равны( квадратНорм(), 1, отнпрец, абспрец );
        }
    
        /** Возвращает: Conjugate quaternion. */
        Кватернион конъюнк()
        {
            return Кватернион(-вектор, скаляр);
        }
    
        /** Invert this quaternion. */
        проц инвертируй()
        {
            т_плав n = нормаль();
            assert( больше(n, 0) );
            вектор = -вектор / n;
            скаляр =  скаляр / n;
        }
    
        /** Возвращает: Inverse копируй of this quaternion. */
        Кватернион инверсия()
        {
            т_плав n = нормаль();
            assert( больше(n, 0) );
            return конъюнк / n;
        }
        
        /**
        Возвращает: Extracted euler angle with the assumption that вращение is applied in order:
        _roll (Z ось), _pitch (X ось), _yaw (Y ось).
        */
        реал yaw()
        {
            return атан2(2 * (w*y + x*z), w*w - x*x - y*y + z*z);
        }
    
        /** описано */
        реал pitch()
        {
            return асин(2 * (w*x - y*z));
        }
        
        /** описано */
        реал roll()
        {
            return атан2(2 * (w*z + x*y), w*w - x*x + y*y - z*z);
        }
        
        /** Возвращает: Whether all components are нормализованный. */
        бул нормален_ли()
        {
            return stdrus.нормален_ли(x) && stdrus.нормален_ли(y) && stdrus.нормален_ли(z) && stdrus.нормален_ли(w);
        }
    
        /** Возвращает: т_плав pointer to x component of this вектор. It's like a _ptr method for arrays. */
        т_плав* укз()
        {
            return cast(т_плав*)(&x);
        }
    
        /** Возвращает: Component corresponded to passed index. */
        т_плав opIndex(т_мера орт)
        in { assert(орт <= Орт.W); }
        body
        {
            return (cast(т_плав*)this)[cast(цел)орт];
        }
    
        /** Assigns new _value to component corresponded to passed index. */
        проц opIndexAssign(т_плав значение, т_мера орт)
        in { assert(орт <= Орт.W); }
        body
        {
            (cast(т_плав*)this)[cast(цел)орт] = значение;
        }
    
        /**
        Standard operators that have meaning exactly the same as for Вектор4.
        
        Note that division operators do no cheks of значение of k, so in case of division
        by 0 result вектор will have infinity components. You can проверь this with нормален_ли()
        method.
        */
        бул opEquals(Кватернион q)
        {
            return x == q.x && y == q.y && z == q.z && w == q.w;
        }
    
        /** описано */
        Кватернион opNeg()
        {
            return Кватернион(-x, -y, -z, -w);
        }
    
        /** описано */
        Кватернион opAdd(Кватернион q)
        {
            return Кватернион(x + q.x, y + q.y, z + q.z, w + q.w);
        }
    
        /** описано */
        проц opAddAssign(Кватернион q)
        {
            x += q.x;
            y += q.y;
            z += q.z;
            w += q.w;
        }
    
        /** описано */
        Кватернион opSub(Кватернион q)
        {
            return Кватернион(x - q.x, y - q.y, z - q.z, w - q.w);
        }
    
        /** описано */
        проц opSubAssign(Кватернион q)
        {
            x -= q.x;
            y -= q.y;
            z -= q.z;
            w -= q.w;
        }
    
        /** описано */
        Кватернион opMul(т_плав k)
        {
            return Кватернион(x * k, y * k, z * k, w * k);
        }

        /** описано */
        Кватернион opMul_r(т_плав k)
        {
            return Кватернион(x * k, y * k, z * k, w * k);
        }
    
        /** описано */
        Кватернион opDiv(т_плав k)
        {
            return Кватернион(x / k, y / k, z / k, w / k);
        }
    
        /** описано */
        проц opDivAssign(т_плав k)
        {
            x /= k;
            y /= k;
            z /= k;
            w /= k;
        }
    
        /**
        Кватернион multiplication operators. Result of Q1*Q2 is quaternion that represents
        вращение which имеется meaning of application Q2's вращение и the Q1's вращение.
        */
        Кватернион opMul(Кватернион q)
        {
            return Кватернион(
                w * q.x + x * q.w + y * q.z - z * q.y,
                w * q.y + y * q.w + z * q.x - x * q.z,
                w * q.z + z * q.w + x * q.y - y * q.x,
                w * q.w - x * q.x - y * q.y - z * q.z );
        }
        
        /** описано */
        проц opMulAssign(Кватернион q)
        {
            установи(w * q.x + x * q.w + y * q.z - z * q.y,
                w * q.y + y * q.w + z * q.x - x * q.z,
                w * q.z + z * q.w + x * q.y - y * q.x,
                w * q.w - x * q.x - y * q.y - z * q.z );
        }
    
        /** Возвращает: Copy of this quaternion with плав type components. */
        Кватернионп вКватернионп()
        {
            return Кватернионп(cast(плав)x, cast(плав)y, cast(плав)z, cast(плав)w);
        }
        
        /** Возвращает: Copy of this вектор with дво type components. */
        Кватернионд вКватернионд()
        {
            return Кватернионд(cast(дво)x, cast(дво)y, cast(дво)z, cast(дво)w);
        }
        
        /** Возвращает: Copy of this вектор with реал type components. */
        Кватернионр вКватернионр()
        {
            return Кватернионр(cast(реал)x, cast(реал)y, cast(реал)z, cast(реал)w);
        }

        ткст вТкст() { return фм("[",x,", ",y,", ", z, ", ", w, "]"); }
    }    
    
    alias РавенствоПоНорм!(Кватернион).равны равны;  /// Introduces approximate equality function for Кватернион.
    alias Лининтерп!(Кватернион).лининтерп лининтерп;              /// Introduces linear interpolation function for Кватернион.
    
    /**
    Возвращает:
        Product of spherical linear interpolation between q0 и q1 with parameter t.
    Ссылки:
        $(LINK http://en.wikipedia.org/wiki/Slerp).
    */
    Кватернион сфлининтерп(Кватернион q0, Кватернион q1, реал t)
    {
        реал cosTheta = q0.x * q1.x + q0.y * q1.y + q0.z * q1.z + q0.w * q1.w;
        реал theta = акос(cosTheta);
    
        if ( равны(фабс(theta), 0) )
            return лининтерп(q0, q1, t);
    
        реал sinTheta = син(theta);
        реал coeff0 = син((1 - t) * theta) / sinTheta;
        реал coeff1 = син(t * theta) / sinTheta;
        
        // Invert вращение if necessary
        if (cosTheta < 0.0f)
        {
            coeff0 = -coeff0;
            // taking the complement требует renormalisation
            Кватернион возвр = coeff0 * q0 + coeff1 * q1;
            return возвр.нормализованный();
        }
        
        return coeff0 * q0 + coeff1 * q1;    
    }
    
    /************************************************************************************
    2x2 Matrix.

    $(LINK http://en.wikipedia.org/wiki/Transformation_matrix).
    *************************************************************************************/
    struct Матрица22
    {
        align(1) union
        {
            struct
            {
                т_плав m00, m10;
                т_плав m01, m11;
            }
    
            т_плав[2][2] m;
            Вектор2[2]    v;
            т_плав[4]    a;
        }
    
        /// Identity matrix.
        static Матрица22 подобие = {
            1, 0,
            0, 1 };
        /// Matrix with all элементы установи to NaN.
        static Матрица22 нч = {
            т_плав.nan, т_плав.nan,
            т_плав.nan, т_плав.nan, };
        /// Matrix with all элементы установи to 0.
        static Матрица22 ноль = {
            0, 0,
            0, 0 };
    
        /**
        Methods to construct matrix in C-like syntax.

        In case with массив remember about column-major matrix memory layout,
        note последний line with assert in example.

        Примеры:
        ------------
        Матрица22 mat1 = Матрица22(1,2,3,4);
        static плав[9] a = [1,2,3,4];
        Матрица22 mat2 = Матрица22(a);

        assert(mat1 == mat2.транспонированный);
        ------------
        */
        static Матрица22 opCall(т_плав m00, т_плав m01,
                               т_плав m10, т_плав m11)
        {
            Матрица22 мат;
            мат.m00 = m00;        мат.m01 = m01;
            мат.m10 = m10;        мат.m11 = m11;
            return мат;
        }
        
        /** описано */
        static Матрица22 opCall(т_плав[4] a)
        {
            Матрица22 мат;
            мат.a[0..4] = a[0..4].dup;
            return мат;
        }
        
        /**
        Method to construct matrix in C-like syntax. Sets columns to passed вектор
        аргументы.
        */
        static Матрица22 opCall(Вектор2 basisX, Вектор2 basisY)
        {
            Матрица22 мат;
            мат.v[0] = basisX;
            мат.v[1] = basisY;
            return мат;
        }
    
        /** Sets элементы to passed значения. */
        проц установи(т_плав m00, т_плав m01,
                 т_плав m10, т_плав m11)
        {
            this.m00 = m00;        this.m01 = m01;
            this.m10 = m10;        this.m11 = m11;
        }
        
        /** Sets элементы as _a копируй of a contents. Remember about column-major matrix memory layout. */
        проц установи(т_плав[4] a)
        {
            this.a[0..4] = a[0..4].dup;
        }
        
        /** Sets columns to passed basis vectors. */
        проц установи(Вектор2 basisX, Вектор2 basisY)
        {
            v[0] = basisX;
            v[1] = basisY;
        }
        
        /** Возвращает: Whether all components are нормализованный numbers. */
        бул нормален_ли()
        {
            return
                stdrus.нормален_ли(m00) && stdrus.нормален_ли(m01) &&
                stdrus.нормален_ли(m10) && stdrus.нормален_ли(m11);
        }
        
        /**
        Возвращает: Whether this matrix is подобие.
        Params:
            отнпрец, абспрец = Parameters passed to равны function while calculations.
                               Have the same meaning as in равны function.
        */
        бул подобен_ли(цел отнпрец = дефотнпрец, цел абспрец = дефабспрец)
        {
            return равны(*this, подобие, отнпрец, абспрец);
        }
        
        /**
        Возвращает: Whether this matrix is ноль.
        Params:
            отнпрец, абспрец = Parameters passed to равны function while calculations.
                               Have the same meaning as in равны function.
        */
        бул ноль_ли(цел отнпрец = дефотнпрец, цел абспрец = дефабспрец)
        {
            return равны(квадратНорм(), 0, отнпрец, абспрец);
        }
        
        /**
        Возвращает: Whether this matrix is orthogonal.
        Params:
            отнпрец, абспрец = Parameters passed to равны function while calculations.
                               Have the same meaning as in равны function.
        Ссылки:
            $(LINK http://en.wikipedia.org/wiki/Orthogonal_matrix).
        */
        бул ортогонален_ли(цел отнпрец = дефотнпрец, цел абспрец = дефабспрец)
        {
            return равны(абс(кросс(v[0],v[1])),1.0, отнпрец, абспрец);
        }
        
        /**
        Возвращает: Whether this matrix represents pure вращение. I.e. hasn't масштабируй admixture.
        Params:
            отнпрец, абспрец = Parameters passed to равны function while calculations.
                               Have the same meaning as in равны function.
        */
        бул вращение_ли(цел отнпрец = дефотнпрец, цел абспрец = дефабспрец)
        {
            return ортогонален_ли(отнпрец, абспрец);
        }
    
        /** Constructs _scale matrix with _scale coefficients specified as аргументы. */
        static Матрица22 масштабируй(т_плав x, т_плав y)
        {
            Матрица22 мат = подобие;
            with (мат)
            {
                m00 = x;
                m11 = y;
            }
    
            return мат;
        }
    
        /** Constructs _scale matrix with _scale coefficients specified as v's components. */
        static Матрица22 масштабируй(Вектор2 v)
        {
            return масштабируй(v.x, v.y);
        }
    
        /** Construct matrix that represents вращение. */
        static Матрица22 вращение(т_плав радианы)
        {
            Матрица22 мат = подобие;
            т_плав c = кос(радианы);
            т_плав s = син(радианы);
            with (мат)
            {
                m00 = m11 = c;
                m10 = s;
                m01 = -s;
            }
    
            return мат;
        }
    
    
        /**
        Constructs matrix that represents _rotation same as in passed in complex number q.
        Method works with assumption that q is unit.
        Throws:
            AssertError on non-unit quaternion call attempt if you compile with
            contract проверьs enabled.
        */
/*
        static Матрица22 вращение(complex q)
        in { assert( q.единица_ли() ); }
        body
        {
            т_плав tx  = 2.f * q.x;
            т_плав ty  = 2.f * q.y;
            т_плав tz  = 2.f * q.z;
            т_плав twx = tx * q.w;
            т_плав twy = ty * q.w;
            т_плав twz = tz * q.w;
            т_плав txx = tx * q.x;
            т_плав txy = ty * q.x;
            т_плав txz = tz * q.x;
            т_плав tyy = ty * q.y;
            т_плав tyz = tz * q.y;
            т_плав tzz = tz * q.z;
            
            Матрица22 мат;
            with (мат)
            {
                m00 = 1.f - (tyy + tzz);    m01 = txy + twz;            m02 = txz - twy;        
                m10 = txy - twz;            m11 = 1.f - (txx + tzz);    m12 = tyz + twx;        
                m20 = txz + twy;            m21 = tyz - twx;            m22 = 1.f - (txx + tyy);
            }
            
            return мат;
        }
*/        
        /**
        Возвращает: Inverse копируй of this matrix.
        
        In case if this matrix is singular (i.e. детерминанта = 0) result matrix will имеется
        infinity элементы. You can проверь this with нормален_ли() method.
        */
        Матрица22 инверсия()
        {
            Матрица22 мат;
            
            мат.m00 =  m11;
            мат.m01 = -m01;
            мат.m10 = -m10;
            мат.m11 =  m00;

            реал det = m00 * m11 - m01 * m10;
            
            for (цел i = 4; i--; )
                мат.a[i] /= det;
    
            return мат;
        }
        
        /**
        Inverts this matrix.
        
        In case if matrix is singular (i.e. детерминанта = 0) result matrix will имеется
        infinity элементы. You can проверь this with нормален_ли() method.
        */
        проц инвертируй()
        {
            реал idet = 1.0/(m00 * m11 - m01 * m10);
            переставь(m00,m11);
            m10 = -m10;
            m01 = -m01;
            (*this) *= idet;
        }
        
        /** Возвращает: Determinant */
        реал детерминанта()
        {
            return m00 * m11 - m10 * m01;
        }
        
        /**
        Возвращает: Frobenius _norm of matrix. I.e. square корень from sum of all элементы' squares.
        Ссылки:
            $(LINK http://en.wikipedia.org/wiki/Frobenius_norm#Frobenius_norm).
        */
        реал нормаль()
        {
            return квкор( квадратНорм );
        }
        
        /**
        Возвращает: Square of Frobenius _norm of matrix. I.e. sum of all элементы' squares.

        Method doesn't need calculation of square корень.

        Ссылки:
            $(LINK http://en.wikipedia.org/wiki/Frobenius_norm#Frobenius_norm).
        */
        реал квадратНорм()
        {
            реал возвр = 0;
            for (цел i = 4; i--; )
            {
                реал x = a[i];
                возвр += x * x;
            }
            
            return возвр;
        }
        
        /** Transposes this matrix. */
        проц транспонируй()
        {
            /*           */        переставь(m01, m10);
            /*           */        /*           */
        }
        
        /** Возвращает: Transposed копируй of this matrix. */
        Матрица22 транспонированный()
        {
            return Матрица22(
                m00, m10,
                m01, m11 );
        }
        
        /**
        Makes polar decomposition of this matrix. Denote this matrix with 'M', in
        that case M=Q*S.
        
        Method is useful to decompose your matrix into вращение 'Q' и масштабируй+shear 'S'. If you
        didn't use shear transform matrix S will be diagonal, i.e. represent масштабируй. This can
        have many applications, particulary you can use method for suppressing errors in pure
        вращение matrices after дол multiplication chain.
        
        Params:
            Q = Output matrix, will be orthogonal after decomposition.
                Аргумент shouldn't be пусто.
            S = Output matrix, will be symmetric non-negative definite after
                decomposition. Аргумент shouldn't be пусто.

        Примеры:
        --------
        Матрица22 Q, S;
        Матрица22 rot = Матрица22.вращЗэт(ПИ / 7);
        Матрица22 масштабируй = Матрица22.масштабируй(-1, 2, 3);
        Матрица22 composition = rot * масштабируй;
        composition.polarDecomposition(Q, S);    
        assert( равны(Q * S, composition) );
        --------

        Ссылки:
            $(LINK http://www.cs.wisc.edu/graphics/Courses/cs-838-2002/Papers/polar-decomp.pdf)
        */
        проц polarDecomposition(out Матрица22 Q, out Матрица22 S)
            out { assert(Q.вращение_ли(), 
                         "(postcondition) Q not a вращение:\n" ~ Q.вТкст); }
        body
        {
            // TODO: Optimize, we need only знак of детерминанта, not значение
            if (детерминанта < 0)
                Q = (*this) * (-подобие);
            else
                Q = *this;
                
            // use scaled Newton method to orthonormalize Q
            цел максОбходов = 100; // avoid deadlock
            Матрица22 Qp = Q;
            Q = 0.5f * (Q + Q.транспонированный.инверсия);
            while (!(Q - Qp).ноль_ли && максОбходов--)
            {
                Матрица22 Qinv = Q.инверсия;
                реал гамма = квкор( Qinv.нормаль / Q.нормаль );
                Qp = Q;
                Q = 0.5f * (гамма * Q + (1 / гамма) * Qinv.транспонированный);
            }
            
            assert( максОбходов != -1 );
            
            S = Q.транспонированный * (*this);
        }
    
        /**
        Standard operators that have intuitive meaning, same as in classical math.
        
        Note that division operators do no cheks of значение of k, so in case of division
        by 0 result matrix will have infinity components. You can проверь this with нормален_ли()
        method.
        */
        Матрица22 opNeg()
        {
            return Матрица22(-m00, -m01,
                            -m10, -m11);
        }
    
        /** описано */
        Матрица22 opAdd(Матрица22 мат)
        {
            return Матрица22(m00 + мат.m00, m01 + мат.m01,
                            m10 + мат.m10, m11 + мат.m11);
        }
    
        /** описано */
        проц opAddAssign(Матрица22 мат)
        {
            m00 += мат.m00; m01 += мат.m01;
            m10 += мат.m10; m11 += мат.m11;
        }
    
        /** описано */
        Матрица22 opSub(Матрица22 мат)
        {
            return Матрица22(m00 - мат.m00, m01 - мат.m01,
                            m10 - мат.m10, m11 - мат.m11);
        }
    
        /** описано */
        проц opSubAssign(Матрица22 мат)
        {
            m00 -= мат.m00; m01 -= мат.m01;
            m10 -= мат.m10; m11 -= мат.m11;
        }
    
        /** описано */
        Матрица22 opMul(т_плав k)
        {
            return Матрица22(m00 * k, m01 * k,
                            m10 * k, m11 * k);
        }
    
        /** описано */
        проц opMulAssign(т_плав k)
        {
            m00 *= k; m01 *= k;
            m10 *= k; m11 *= k;
        }
    
        /** описано */
        Матрица22 opMul_r(т_плав k)
        {
            return Матрица22(m00 * k, m01 * k,
                            m10 * k, m11 * k);
        }
    
        /** описано */
        Матрица22 opDiv(т_плав k)
        {
            return Матрица22(m00 / k, m01 / k,
                            m10 / k, m11 / k);
        }
    
        /** описано */
        проц opDivAssign(т_плав k)
        {
            m00 /= k; m01 /= k;
            m10 /= k; m11 /= k;
        }
    
        /** описано */
        бул opEquals(Матрица22 мат)
        {
            return m00 == мат.m00 && m01 == мат.m01 &&
                   m10 == мат.m10 && m11 == мат.m11;
        }

        /** описано */
        Матрица22 opMul(Матрица22 мат)
        {
            return Матрица22(
                m00 * мат.m00 + m01 * мат.m10,   m00 * мат.m01 + m01 * мат.m11,
                m10 * мат.m00 + m11 * мат.m10,   m10 * мат.m01 + m11 * мат.m11 );
        }
    
        /** описано */
        проц opMulAssign(Матрица22 мат)
        {
            *this = *this * мат;
        }
    
        /** описано */
        Вектор2 opMul(Вектор2 v)
        {
            return Вектор2(v.x * m00 + v.y * m01,
                           v.x * m10 + v.y * m11 );
        }
    
        /** Возвращает: Элемент at ряд'th _row и столб'th column. */
        т_плав opIndex(бцел ряд, бцел столб)
        in { assert( ряд < 2 && столб < 2 ); }
        body
        {
            return m[столб][ряд];
        }
    
        /** Assigns значение f to элемент at ряд'th _row и столб'th column. */
        проц opIndexAssign(т_плав f, бцел ряд, бцел столб)
        in { assert( ряд < 2 && столб < 2 ); }
        body
        {
            m[столб][ряд] = f;
        }
        
        /** Возвращает: Вектор representing столб'th column. */
        Вектор2 opIndex(бцел столб)
        in { assert( столб < 2 ); }
        body
        {
            return v[столб];
        }
        
        /** Replaces элементы in столб'th column with v's значения. */
        проц opIndexAssign(Вектор2 v, бцел столб)
        in { assert( столб < 2 ); }
        body
        {
            return this.v[столб] = v;
        }
    
        /**
        Возвращает: т_плав pointer to [0,0] элемент of this matrix. It's like a _ptr method for arrays.
        
        Remember about column-major matrix memory layout.
        */
        т_плав* укз()
        {
            return a.ptr;
        }
        
        /** Возвращает: Copy of this matrix with плав type элементы. */
        Матрица22п вМатрицу22п()
        {
            return Матрица22п(
                cast(плав)m00, cast(плав)m01,
                cast(плав)m10, cast(плав)m11 );
        }
        
        /** Возвращает: Copy of this matrix with дво type элементы. */
        Матрица22д вМатрицу22д()
        {
            return Матрица22д(
                cast(дво)m00, cast(дво)m01,
                cast(дво)m10, cast(дво)m11 );
        }
        
        /** Возвращает: Copy of this matrix with реал type элементы. */
        Матрица22р вМатрицу22р()
        {
            return Матрица22р(
                cast(реал)m00, cast(реал)m01,
                cast(реал)m10, cast(реал)m11     );
        }

        ткст вТкст() { 
            return фм("[" ,m00, ", " ,m01, ",\n",
                          " " ,m10, ", " ,m11, "]");
        }
    }
    
    
    alias РавенствоПоНорм!(Матрица22).равны равны; /// Introduces approximate equality function for Матрица22.
    alias Лининтерп!(Матрица22).лининтерп лининтерп;             /// Introduces linear interpolation function for Матрица22.

    /************************************************************************************
    3x3 Matrix.

    For formal definition of quaternion, meaning of possible operations и related
    information see $(LINK http://en.wikipedia.org/wiki/Matrix(mathematics)),
    $(LINK http://en.wikipedia.org/wiki/Transformation_matrix).
    *************************************************************************************/
    struct Матрица33
    {
        align(1) union
        {
            struct
            {
                т_плав m00, m10, m20;
                т_плав m01, m11, m21;
                т_плав m02, m12, m22;
            }
    
            т_плав[3][3] m;
            Вектор3[3]    v;
            т_плав[9]    a;
        }
    
        /// Identity matrix.
        static Матрица33 подобие = {
            1, 0, 0,
            0, 1, 0,
            0, 0, 1 };
        /// Matrix with all элементы установи to NaN.
        static Матрица33 нч = {
            т_плав.nan, т_плав.nan, т_плав.nan,
            т_плав.nan, т_плав.nan, т_плав.nan,
            т_плав.nan, т_плав.nan, т_плав.nan };
        /// Matrix with all элементы установи to 0.
        static Матрица33 ноль = {
            0, 0, 0,
            0, 0, 0,
            0, 0, 0 };
    
        /**
        Methods to construct matrix in C-like syntax.

        In case with массив remember about column-major matrix memory layout,
        note последний line with assert in example.

        Примеры:
        ------------
        Матрица33 mat1 = Матрица33(1,2,3,4,5,6,7,8,9);
        static плав[9] a = [1,2,3,4,5,6,7,8,9];
        Матрица33 mat2 = Матрица33(a);

        assert(mat1 == mat2.транспонированный);
        ------------
        */
        static Матрица33 opCall(т_плав m00, т_плав m01, т_плав m02,
                               т_плав m10, т_плав m11, т_плав m12,
                               т_плав m20, т_плав m21, т_плав m22)
        {
            Матрица33 мат;
            мат.m00 = m00;        мат.m01 = m01;        мат.m02 = m02;
            мат.m10 = m10;        мат.m11 = m11;        мат.m12 = m12;
            мат.m20 = m20;        мат.m21 = m21;        мат.m22 = m22;
            return мат;
        }
        
        /** описано */
        static Матрица33 opCall(т_плав[9] a)
        {
            Матрица33 мат;
            мат.a[0..9] = a[0..9].dup;
            return мат;
        }
        
        /**
        Method to construct matrix in C-like syntax. Sets columns to passed вектор
        аргументы.
        */
        static Матрица33 opCall(Вектор3 basisX, Вектор3 basisY, Вектор3 basisZ)
        {
            Матрица33 мат;
            мат.v[0] = basisX;
            мат.v[1] = basisY;
            мат.v[2] = basisZ;
            return мат;
        }
    
        /** Sets элементы to passed значения. */
        проц установи(т_плав m00, т_плав m01, т_плав m02,
                 т_плав m10, т_плав m11, т_плав m12,
                 т_плав m20, т_плав m21, т_плав m22)
        {
            this.m00 = m00;        this.m01 = m01;        this.m02 = m02;
            this.m10 = m10;        this.m11 = m11;        this.m12 = m12;
            this.m20 = m20;        this.m21 = m21;        this.m22 = m22;
        }
        
        /** Sets элементы as _a копируй of a contents. Remember about column-major matrix memory layout. */
        проц установи(т_плав[9] a)
        {
            this.a[0..9] = a[0..9].dup;
        }
        
        /** Sets columns to passed basis vectors. */
        проц установи(Вектор3 basisX, Вектор3 basisY, Вектор3 basisZ)
        {
            v[0] = basisX;
            v[1] = basisY;
            v[2] = basisZ;
        }
        
        /** Возвращает: Whether all components are нормализованный numbers. */
        бул нормален_ли()
        {
            return
                stdrus.нормален_ли(m00) && stdrus.нормален_ли(m01) && stdrus.нормален_ли(m02) &&
                stdrus.нормален_ли(m10) && stdrus.нормален_ли(m11) && stdrus.нормален_ли(m12) &&
                stdrus.нормален_ли(m20) && stdrus.нормален_ли(m21) && stdrus.нормален_ли(m22);
        }
        
        /**
        Возвращает: Whether this matrix is подобие.
        Params:
            отнпрец, абспрец = Parameters passed to равны function while calculations.
                               Have the same meaning as in равны function.
        */
        бул подобен_ли(цел отнпрец = дефотнпрец, цел абспрец = дефабспрец)
        {
            return равны(*this, подобие, отнпрец, абспрец);
        }
        
        /**
        Возвращает: Whether this matrix is ноль.
        Params:
            отнпрец, абспрец = Parameters passed to равны function while calculations.
                               Have the same meaning as in равны function.
        */
        бул ноль_ли(цел отнпрец = дефотнпрец, цел абспрец = дефабспрец)
        {
            return равны(квадратНорм(), 0, отнпрец, абспрец);
        }
        
        /**
        Возвращает: Whether this matrix is orthogonal.
        Params:
            отнпрец, абспрец = Parameters passed to равны function while calculations.
                               Have the same meaning as in равны function.
        Ссылки:
            $(LINK http://en.wikipedia.org/wiki/Orthogonal_matrix).
        */
        бул ортогонален_ли(цел отнпрец = дефотнпрец, цел абспрец = дефабспрец)
        {
            return ортонормально_лиОснование(v[0], v[1], v[2], отнпрец, абспрец);
        }
        
        /**
        Возвращает: Whether this matrix represents pure вращение. I.e. hasn't масштабируй admixture.
        Params:
            отнпрец, абспрец = Parameters passed to равны function while calculations.
                               Have the same meaning as in равны function.
        */
        бул вращение_ли(цел отнпрец = дефотнпрец, цел абспрец = дефабспрец)
        {
            return ортогонален_ли(отнпрец, абспрец) && равны(v[2], кросс(v[0], v[1]), отнпрец, абспрец);
        }
    
        /** Constructs _scale matrix with _scale coefficients specified as аргументы. */
        static Матрица33 масштабируй(т_плав x, т_плав y, т_плав z)
        {
            Матрица33 мат = подобие;
            with (мат)
            {
                m00 = x;
                m11 = y;
                m22 = z;
            }
    
            return мат;
        }
    
        /** Constructs _scale matrix with _scale coefficients specified as v's components. */
        static Матрица33 масштабируй(Вектор3 v)
        {
            return масштабируй(v.x, v.y, v.z);
        }
    
        /** Construct matrix that represents вращение around corresponding ось. */
        static Матрица33 вращИкс(т_плав радианы)
        {
            Матрица33 мат = подобие;
            т_плав c = кос(радианы);
            т_плав s = син(радианы);
            with (мат)
            {
                m11 = m22 = c;
                m21 = s;
                m12 = -s;            
            }
    
            return мат;
        }
    
        /** описано */
        static Матрица33 вращИгрек(т_плав радианы)
        {
            Матрица33 мат = подобие;
            т_плав c = кос(радианы);
            т_плав s = син(радианы);
            with (мат)
            {
                m00 = m22 = c;
                m20 = -s;
                m02 = s;            
            }
    
            return мат;
        }
    
        /** описано */
        static Матрица33 вращЗэт(т_плав радианы)
        {
            Матрица33 мат = подобие;
            т_плав c = кос(радианы);
            т_плав s = син(радианы);
            with (мат)
            {
                m00 = m11 = c;
                m10 = s;
                m01 = -s;            
            }
    
            return мат;
        }
    
        /**
        Constructs matrix that represents _rotation specified by euler angles passed as аргументы.
        Order of _rotation application is: roll (Z ось), pitch (X ось), yaw (Y ось).
        */
        static Матрица33 вращение(т_плав yaw, т_плав pitch, т_плав roll)
        {
            return Матрица33.вращИгрек(yaw) * Матрица33.вращИкс(pitch) * Матрица33.вращЗэт(roll);
        }
    
        /**
        Constructs matrix that represents _rotation specified by ось и angle.
        Method works with assumption that ось is unit вектор.        
        Throws:
            AssertError on non-unit ось call attempt if module was compiled with
            contract проверьs enabled.
        */
        static Матрица33 вращение(Вектор3 ось, т_плав радианы)
        in { assert( ось.единица_ли() ); }
        body
        {
            реал c = кос(радианы);
            реал s = син(радианы);
            реал cc = 1.0 - c;
            реал x2 = ось.x * ось.x;
            реал y2 = ось.y * ось.y;
            реал z2 = ось.z * ось.z;
            реал xycc = ось.x * ось.y * cc;
            реал xzcc = ось.x * ось.z * cc;
            реал yzcc = ось.y * ось.z * cc;
            реал xs = ось.x * s;
            реал ys = ось.y * s;
            реал zs = ось.z * s;
    
            Матрица33 мат;
            with (мат)
            {
                m00 = x2 * cc + c;      m01 = xycc - zs;        m02 = xzcc + ys;
                m10 = xycc + zs;        m11 = y2 * cc + c;      m12 = yzcc - xs;
                m20 = xzcc - ys;        m21 = yzcc + xs;        m22 = z2 * cc + c;
            }
    
            return мат;
        }
        
        /**
        Constructs matrix that represents _rotation same as in passed quaternion q.
        Method works with assumption that q is unit.
        Throws:
            AssertError on non-unit quaternion call attempt if you compile with
            contract проверьs enabled.
        */
        static Матрица33 вращение(Кватернион q)
        in { assert( q.единица_ли() ); }
        body
        {
            т_плав tx  = 2.f * q.x;
            т_плав ty  = 2.f * q.y;
            т_плав tz  = 2.f * q.z;
            т_плав twx = tx * q.w;
            т_плав twy = ty * q.w;
            т_плав twz = tz * q.w;
            т_плав txx = tx * q.x;
            т_плав txy = ty * q.x;
            т_плав txz = tz * q.x;
            т_плав tyy = ty * q.y;
            т_плав tyz = tz * q.y;
            т_плав tzz = tz * q.z;
            
            Матрица33 мат;
            with (мат)
            {
                m00 = 1.f - (tyy + tzz);    m01 = txy - twz;            m02 = txz + twy;
                m10 = txy + twz;            m11 = 1.f - (txx + tzz);    m12 = tyz - twx;
                m20 = txz - twy;            m21 = tyz + twx;            m22 = 1.f - (txx + tyy);
            }
            
            return мат;
        }
        
        /**
        Возвращает: Inverse копируй of this matrix.
        
        In case if this matrix is singular (i.e. детерминанта = 0) result matrix will имеется
        infinity элементы. You can проверь this with нормален_ли() method.
        */
        Матрица33 инверсия()
        {
            Матрица33 мат;
            
            мат.m00 = m11 * m22 - m12 * m21;
            мат.m01 = m02 * m21 - m01 * m22;
            мат.m02 = m01 * m12 - m02 * m11;
            мат.m10 = m12 * m20 - m10 * m22;
            мат.m11 = m00 * m22 - m02 * m20;
            мат.m12 = m02 * m10 - m00 * m12;
            мат.m20 = m10 * m21 - m11 * m20;
            мат.m21 = m01 * m20 - m00 * m21;
            мат.m22 = m00 * m11 - m01 * m10;
            
            реал det = m00 * мат.m00 + m01 * мат.m10 + m02 * мат.m20;
            
            for (цел i = 9; i--; )
                мат.a[i] /= det;
    
            return мат;
        }
        
        /**
        Inverts this matrix.
        
        In case if matrix is singular (i.e. детерминанта = 0) result matrix will имеется
        infinity элементы. You can проверь this with нормален_ли() method.
        */
        проц инвертируй()
        {
            *this = инверсия();
        }
        
        /** Возвращает: Determinant */
        реал детерминанта()
        {
            реал cofactor00 = m11 * m22 - m12 * m21;
            реал cofactor10 = m12 * m20 - m10 * m22;
            реал cofactor20 = m10 * m21 - m11 * m20;
            
            return m00 * cofactor00 + m01 * cofactor10 + m02 * cofactor20;;
        }
        
        /**
        Возвращает: Frobenius _norm of matrix. I.e. square корень from sum of all элементы' squares.
        Ссылки:
            $(LINK http://en.wikipedia.org/wiki/Frobenius_norm#Frobenius_norm).
        */
        реал нормаль()
        {
            return квкор( квадратНорм );
        }
        
        /**
        Возвращает: Square of Frobenius _norm of matrix. I.e. sum of all элементы' squares.

        Method doesn't need calculation of square корень.

        Ссылки:
            $(LINK http://en.wikipedia.org/wiki/Frobenius_norm#Frobenius_norm).
        */
        реал квадратНорм()
        {
            реал возвр = 0;
            for (цел i = 9; i--; )
            {
                реал x = a[i];
                возвр += x * x;
            }
            
            return возвр;
        }
        
        /** Transposes this matrix. */
        проц транспонируй()
        {
            /*           */        переставь(m01, m10);        переставь(m02, m20);
            /*           */        /*           */        переставь(m12, m21);
            /*           */        /*           */        /*           */
        }
        
        /** Возвращает: Transposed копируй of this matrix. */
        Матрица33 транспонированный()
        {
            return Матрица33(
                m00, m10, m20,
                m01, m11, m21,
                m02, m12, m22 );
        }
        
        /**
        Makes polar decomposition of this matrix. Denote this matrix with 'M', in
        that case M=Q*S.
        
        Method is useful to decompose your matrix into вращение 'Q' и масштабируй+shear 'S'. If you
        didn't use shear transform matrix S will be diagonal, i.e. represent масштабируй. This can
        have many applications, particulary you can use method for suppressing errors in pure
        вращение matrices after дол multiplication chain.
        
        Params:
            Q = Output matrix, will be orthogonal after decomposition.
                Аргумент shouldn't be пусто.
            S = Output matrix, will be symmetric non-negative definite after
                decomposition. Аргумент shouldn't be пусто.

        Примеры:
        --------
        Матрица33 Q, S;
        Матрица33 rot = Матрица33.вращЗэт(ПИ / 7);
        Матрица33 масштабируй = Матрица33.масштабируй(-1, 2, 3);
        Матрица33 composition = rot * масштабируй;
        composition.polarDecomposition(Q, S);    
        assert( равны(Q * S, composition) );
        --------

        Ссылки:
            $(LINK http://www.cs.wisc.edu/graphics/Courses/cs-838-2002/Papers/polar-decomp.pdf)
        */
        проц polarDecomposition(out Матрица33 Q, out Матрица33 S)
        out { assert(Q.вращение_ли()); }
        body
        {
            // TODO: Optimize, we need only знак of детерминанта, not значение
            if (детерминанта < 0)
                Q = (*this) * (-подобие);
            else
                Q = *this;
                
            // use scaled Newton method to orthonormalize Q
            цел максОбходов = 100; // avoid deadlock
            Матрица33 Qp = Q;
            Q = 0.5f * (Q + Q.транспонированный.инверсия);
            while (!(Q - Qp).ноль_ли && максОбходов--)
            {
                Матрица33 Qinv = Q.инверсия;
                реал гамма = квкор( Qinv.нормаль / Q.нормаль );
                Qp = Q;
                Q = 0.5f * (гамма * Q + (1 / гамма) * Qinv.транспонированный);
            }
            
            assert( максОбходов != -1 );
            
            S = Q.транспонированный * (*this);
        }
    
        /**
        Standard operators that have intuitive meaning, same as in classical math.
        
        Note that division operators do no cheks of значение of k, so in case of division
        by 0 result matrix will have infinity components. You can проверь this with нормален_ли()
        method.
        */
        Матрица33 opNeg()
        {
            return Матрица33(-m00, -m01, -m02,
                            -m10, -m11, -m12,
                            -m20, -m21, -m22);
        }
    
        /** описано */
        Матрица33 opAdd(Матрица33 мат)
        {
            return Матрица33(m00 + мат.m00, m01 + мат.m01, m02 + мат.m02,
                            m10 + мат.m10, m11 + мат.m11, m12 + мат.m12,
                            m20 + мат.m20, m21 + мат.m21, m22 + мат.m22);
        }
    
        /** описано */
        проц opAddAssign(Матрица33 мат)
        {
            m00 += мат.m00; m01 += мат.m01; m02 += мат.m02;
            m10 += мат.m10; m11 += мат.m11; m12 += мат.m12;
            m20 += мат.m20; m21 += мат.m21; m22 += мат.m22;
        }
    
        /** описано */
        Матрица33 opSub(Матрица33 мат)
        {
            return Матрица33(m00 - мат.m00, m01 - мат.m01, m02 - мат.m02,
                            m10 - мат.m10, m11 - мат.m11, m12 - мат.m12,
                            m20 - мат.m20, m21 - мат.m21, m22 - мат.m22);
        }
    
        /** описано */
        проц opSubAssign(Матрица33 мат)
        {
            m00 -= мат.m00; m01 -= мат.m01; m02 -= мат.m02;
            m10 -= мат.m10; m11 -= мат.m11; m12 -= мат.m12;
            m20 -= мат.m20; m21 -= мат.m21; m22 -= мат.m22;        
        }
    
        /** описано */
        Матрица33 opMul(т_плав k)
        {
            return Матрица33(m00 * k, m01 * k, m02 * k,
                            m10 * k, m11 * k, m12 * k,
                            m20 * k, m21 * k, m22 * k);
        }
    
        /** описано */
        проц opMulAssign(т_плав k)
        {
            m00 *= k; m01 *= k; m02 *= k;
            m10 *= k; m11 *= k; m12 *= k;
            m20 *= k; m21 *= k; m22 *= k;
        }
    
        /** описано */
        Матрица33 opMul_r(т_плав k)
        {
            return Матрица33(m00 * k, m01 * k, m02 * k,
                            m10 * k, m11 * k, m12 * k,
                            m20 * k, m21 * k, m22 * k);
        }
    
        /** описано */
        Матрица33 opDiv(т_плав k)
        {
            
            return Матрица33(m00 / k, m01 / k, m02 / k,
                            m10 / k, m11 / k, m12 / k,
                            m20 / k, m21 / k, m22 / k);
        }
    
        /** описано */
        проц opDivAssign(т_плав k)
        {
            m00 /= k; m01 /= k; m02 /= k;
            m10 /= k; m11 /= k; m12 /= k;
            m20 /= k; m21 /= k; m22 /= k;
        }
    
        /** описано */
        бул opEquals(Матрица33 мат)
        {
            return m00 == мат.m00 && m01 == мат.m01 && m02 == мат.m02 &&
                   m10 == мат.m10 && m11 == мат.m11 && m12 == мат.m12 &&
                   m20 == мат.m20 && m21 == мат.m21 && m22 == мат.m22;
        }

        /** описано */
        Матрица33 opMul(Матрица33 мат)
        {
            return Матрица33(m00 * мат.m00 + m01 * мат.m10 + m02 * мат.m20,
                            m00 * мат.m01 + m01 * мат.m11 + m02 * мат.m21,
                            m00 * мат.m02 + m01 * мат.m12 + m02 * мат.m22,
                            m10 * мат.m00 + m11 * мат.m10 + m12 * мат.m20,
                            m10 * мат.m01 + m11 * мат.m11 + m12 * мат.m21,
                            m10 * мат.m02 + m11 * мат.m12 + m12 * мат.m22,
                            m20 * мат.m00 + m21 * мат.m10 + m22 * мат.m20,
                            m20 * мат.m01 + m21 * мат.m11 + m22 * мат.m21,
                            m20 * мат.m02 + m21 * мат.m12 + m22 * мат.m22 );
        }
    
        /** описано */
        проц opMulAssign(Матрица33 мат)
        {
            *this = *this * мат;
        }
    
        /** описано */
        Вектор3 opMul(Вектор3 v)
        {
            return Вектор3(v.x * m00 + v.y * m01 + v.z * m02,
                           v.x * m10 + v.y * m11 + v.z * m12,
                           v.x * m20 + v.y * m21 + v.z * m22 );
        }
    
        /** Возвращает: Элемент at ряд'th _row и столб'th column. */
        т_плав opIndex(бцел ряд, бцел столб)
        in { assert( ряд < 3 && столб < 3 ); }
        body
        {
            return m[столб][ряд];
        }
    
        /** Assigns значение f to элемент at ряд'th _row и столб'th column. */
        проц opIndexAssign(т_плав f, бцел ряд, бцел столб)
        in { assert( ряд < 3 && столб < 3 ); }
        body
        {
            m[столб][ряд] = f;
        }
        
        /** Возвращает: Вектор representing столб'th column. */
        Вектор3 opIndex(бцел столб)
        in { assert( столб < 3 ); }
        body
        {
            return v[столб];
        }
        
        /** Replaces элементы in столб'th column with v's значения. */
        проц opIndexAssign(Вектор3 v, бцел столб)
        in { assert( столб < 3 ); }
        body
        {
            return this.v[столб] = v;
        }
    
        /**
        Возвращает: т_плав pointer to [0,0] элемент of this matrix. It's like a _ptr method for arrays.
        
        Remember about column-major matrix memory layout.
        */
        т_плав* укз()
        {
            return a.ptr;
        }
        
        /** Возвращает: Copy of this matrix with плав type элементы. */
        Матрица33п вМатрицу33п()
        {
            return Матрица33п(
                cast(плав)m00, cast(плав)m01, cast(плав)m02,
                cast(плав)m10, cast(плав)m11, cast(плав)m12,
                cast(плав)m20, cast(плав)m21, cast(плав)m22 );
        }
        
        /** Возвращает: Copy of this matrix with дво type элементы. */
        Матрица33д вМатрицу33д()
        {
            return Матрица33д(
                cast(дво)m00, cast(дво)m01, cast(дво)m02,
                cast(дво)m10, cast(дво)m11, cast(дво)m12,
                cast(дво)m20, cast(дво)m21, cast(дво)m22 );
        }
        
        /** Возвращает: Copy of this matrix with реал type элементы. */
        Матрица33р вМатрицу33р()
        {
            return Матрица33р(
                cast(реал)m00, cast(реал)m01, cast(реал)m02,
                cast(реал)m10, cast(реал)m11, cast(реал)m12,
                cast(реал)m20, cast(реал)m21, cast(реал)m22 );
        }

        ткст вТкст() { 
            return фм("[" ,m00, ", " ,m01, ", " ,m02, ",\n",
                          " " ,m10, ", " ,m11, ", " ,m12, ",\n",
                          " " ,m20, ", " ,m21, ", " ,m22, "]");
        }
    }
    
    
    alias РавенствоПоНорм!(Матрица33).равны равны; /// Introduces approximate equality function for Матрица33.
    alias Лининтерп!(Матрица33).лининтерп лининтерп;             /// Introduces linear interpolation function for Матрица33.
    
    /************************************************************************************
    4x4 Matrix.

    Helix matrices uses column-major memory layout.
    *************************************************************************************/
    struct Матрица44
    {
        align (1) union
        {
            struct
            {
                т_плав m00, m10, m20, m30;
                т_плав m01, m11, m21, m31;
                т_плав m02, m12, m22, m32;
                т_плав m03, m13, m23, m33;
            }
    
            т_плав[4][4] m;
            т_плав[16]   a;
            Вектор4[4]    v;
        }
    
        /// Identity matrix.
        static Матрица44 подобие = {
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, 0, 0, 1 };
        /// Matrix with all элементы установи to NaN.
        static Матрица44 нч = {
            т_плав.nan, т_плав.nan, т_плав.nan, т_плав.nan,
            т_плав.nan, т_плав.nan, т_плав.nan, т_плав.nan,
            т_плав.nan, т_плав.nan, т_плав.nan, т_плав.nan,
            т_плав.nan, т_плав.nan, т_плав.nan, т_плав.nan };
        /// Matrix with all элементы установи to 0.
        static Матрица44 ноль = {
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0 };
    
        /**
        Methods to construct matrix in C-like syntax.

        In case with массив remember about column-major matrix memory layout,
        note последний line with assert in example - it'll be passed.

        Примеры:
        ------------
        Матрица33 mat1 = Матрица33(
             1,  2,  3,  4,
             5,  6,  7,  8,
             9, 10, 11, 12,
            13, 14, 15, 16 );
            
        static плав[16] a = [
             1,  2,  3,  4,
             5,  6,  7,  8,
             9, 10, 11, 12,
            13, 14, 15, 16 ];
        Матрица33 mat2 = Матрица33(a);

        assert(mat1 == mat2.транспонированный);
        ------------
        */
        static Матрица44 opCall(т_плав m00, т_плав m01, т_плав m02, т_плав m03,
                               т_плав m10, т_плав m11, т_плав m12, т_плав m13,
                               т_плав m20, т_плав m21, т_плав m22, т_плав m23,
                               т_плав m30, т_плав m31, т_плав m32, т_плав m33)
        {
            Матрица44 мат;
            мат.m00 = m00;        мат.m01 = m01;        мат.m02 = m02;        мат.m03 = m03;
            мат.m10 = m10;        мат.m11 = m11;        мат.m12 = m12;        мат.m13 = m13;
            мат.m20 = m20;        мат.m21 = m21;        мат.m22 = m22;        мат.m23 = m23;
            мат.m30 = m30;        мат.m31 = m31;        мат.m32 = m32;        мат.m33 = m33;
            return мат;
        }
        
        /** описано */
        static Матрица44 opCall(т_плав[16] a)
        {
            Матрица44 мат;
            мат.a[0..16] = a[0..16].dup;
            return мат;
        }
        
        /**
        Method to construct matrix in C-like syntax. Sets columns to passed вектор
        аргументы.
        */
        static Матрица44 opCall(Вектор4 basisX, Вектор4 basisY, Вектор4 basisZ,
                               Вектор4 basisW = Вектор4(0, 0, 0, 1))
        {
            Матрица44 мат;
            мат.v[0] = basisX;
            мат.v[1] = basisY;
            мат.v[2] = basisZ;
            мат.v[3] = basisW;
            return мат;
        }
        
        /**
        Method to construct matrix in C-like syntax. Constructs affine transform
        matrix based on passed вектор аргументы.
        Ссылки:
            $(LINK http://en.wikipedia.org/wiki/Affine_transformation).
        */
        static Матрица44 opCall(Вектор3 basisX, Вектор3 basisY, Вектор3 basisZ,
                               Вектор3 перенос = Вектор3(0, 0, 0))
        {
            return opCall(Вектор4(basisX, 0), Вектор4(basisX, 0), Вектор4(basisX, 0), Вектор4(перенос, 1));
        }
    
        /** Sets элементы to passed значения. */
        проц установи(т_плав m00, т_плав m01, т_плав m02, т_плав m03,
                 т_плав m10, т_плав m11, т_плав m12, т_плав m13,
                 т_плав m20, т_плав m21, т_плав m22, т_плав m23,
                 т_плав m30, т_плав m31, т_плав m32, т_плав m33)
        {
            this.m00 = m00;        this.m01 = m01;        this.m02 = m02;        this.m03 = m03;
            this.m10 = m10;        this.m11 = m11;        this.m12 = m12;        this.m13 = m13;
            this.m20 = m20;        this.m21 = m21;        this.m22 = m22;        this.m23 = m23;
            this.m30 = m30;        this.m31 = m31;        this.m32 = m32;        this.m33 = m33;    
        }
        
        /** Sets элементы as _a копируй of a contents. Remember about column-major matrix memory layout. */
        проц установи(т_плав[16] a)
        {
            this.a[0..16] = a[0..16].dup;
        }
    
        /** Sets columns to passed basis vectors. */
        проц установи(Вектор4 basisX, Вектор4 basisY, Вектор4 basisZ,
                 Вектор4 basisW = Вектор4(0, 0, 0, 1))
        {
            v[0] = basisX;
            v[1] = basisY;
            v[2] = basisZ;
            v[3] = basisW;
        }

        /** Возвращает: Whether all components are нормализованный numbers. */
        бул нормален_ли()
        {
            return
                stdrus.нормален_ли(m00) && stdrus.нормален_ли(m01) && stdrus.нормален_ли(m02) && stdrus.нормален_ли(m03) &&
                stdrus.нормален_ли(m10) && stdrus.нормален_ли(m11) && stdrus.нормален_ли(m12) && stdrus.нормален_ли(m13) &&
                stdrus.нормален_ли(m20) && stdrus.нормален_ли(m21) && stdrus.нормален_ли(m22) && stdrus.нормален_ли(m23) &&
                stdrus.нормален_ли(m30) && stdrus.нормален_ли(m31) && stdrus.нормален_ли(m32) && stdrus.нормален_ли(m33);
        }

        /**
        Возвращает: Whether this matrix is подобие.
        Params:
            отнпрец, абспрец = Parameters passed to равны function while calculations.
                               Have the same meaning as in равны function.
        */
        бул подобен_ли(цел отнпрец = дефотнпрец, цел абспрец = дефабспрец)
        {
            return равны(*this, подобие, отнпрец, абспрец);
        }
        
        /**
        Возвращает: Whether this matrix is ноль.
        Params:
            отнпрец, абспрец = Parameters passed to равны function while calculations.
                        Has the same meaning as in равны function.
        */
        бул ноль_ли(цел отнпрец = дефотнпрец, цел абспрец = дефабспрец)
        {
            return равны(квадратНорм(), 0, отнпрец, абспрец);
        }
        
        /**
        Resets this matrix to affine transform matrix based on passed
        вектор аргументы.
        */
        проц установи(Вектор3 basisX, Вектор3 basisY, Вектор3 basisZ,
                 Вектор3 перенос = Вектор3(0, 0, 0))
        {
            v[0] = Вектор4(basisX, 0);
            v[1] = Вектор4(basisY, 0);
            v[2] = Вектор4(basisZ, 0);
            v[3] = Вектор4(перенос, 1);
        }
    
        /** Constructs _scale matrix with _scale coefficients specified as аргументы. */
        static Матрица44 масштабируй(т_плав x, т_плав y, т_плав z)
        {
            Матрица44 мат = подобие;
            with (мат)
            {
                m00 = x;
                m11 = y;
                m22 = z;            
            }
    
            return мат;
        }
    
        /** Constructs _scale matrix with _scale coefficients specified as v's components. */
        static Матрица44 масштабируй(Вектор3 v)
        {
            return масштабируй(v.x, v.y, v.z);
        }
    
        /** Construct matrix that represents вращение around corresponding ось. */
        static Матрица44 вращИкс(т_плав радианы)
        {
            Матрица44 мат = подобие;
            т_плав c = кос(радианы);
            т_плав s = син(радианы);
            with (мат)
            {
                m11 = m22 = c;
                m21 = s;
                m12 = -s;            
            }
    
            return мат;
        }
    
        /** описано */
        static Матрица44 вращИгрек(т_плав радианы)
        {
            Матрица44 мат = подобие;
            т_плав c = кос(радианы);
            т_плав s = син(радианы);
            with (мат)
            {
                m00 = m22 = c;
                m20 = -s;
                m02 = s;            
            }
    
            return мат;
        }
    
        /** описано */
        static Матрица44 вращЗэт(т_плав радианы)
        {
            Матрица44 мат = подобие;
            т_плав c = кос(радианы);
            т_плав s = син(радианы);
            with (мат)
            {
                m00 = m11 = c;
                m10 = s;
                m01 = -s;            
            }
    
            return мат;
        }
    
        /**
        Constructs matrix that represents _rotation specified by euler angles passed as аргументы.
        Order of _rotation application is: roll (Z ось), pitch (X ось), yaw (Y ось).
        */
        static Матрица44 вращение(т_плав yaw, т_плав pitch, т_плав roll)
        {
            return Матрица44.вращИгрек(yaw) * Матрица44.вращИкс(pitch) * Матрица44.вращЗэт(roll);
        }
    
        /**
        Constructs matrix that represents _rotation specified by ось и angle.
        Method works with assumption that ось is unit вектор.        
        Throws:
            AssertError on non-unit ось call attempt if module was compiled with
            contract проверьs enabled.
        */
        static Матрица44 вращение(Вектор3 ось, т_плав радианы)
        in { assert( ось.единица_ли() ); }
        body
        {
            реал c = кос(радианы);
            реал s = син(радианы);
            реал cc = 1.0 - c;
            реал x2 = ось.x * ось.x;
            реал y2 = ось.y * ось.y;
            реал z2 = ось.z * ось.z;
            реал xycc = ось.x * ось.y * cc;
            реал xzcc = ось.x * ось.z * cc;
            реал yzcc = ось.y * ось.z * cc;
            реал xs = ось.x * s;
            реал ys = ось.y * s;
            реал zs = ось.z * s;
    
            Матрица44 мат = подобие;
            with (мат)
            {
                m00 = x2 * cc + c;      m01 = xycc - zs;        m02 = xzcc + ys;
                m10 = xycc + zs;        m11 = y2 * cc + c;      m12 = yzcc - xs;
                m20 = xzcc - ys;        m21 = yzcc + xs;        m22 = z2 * cc + c;
            }
    
            return мат;
        }
        
        /**
        Constructs matrix that represents _rotation specified by quaternion.
        Method works with assumption that quaternion is unit.        
        Throws:
            AssertError on non-unit quaternion call attempt if module was compiled with
            contract проверьs enabled.
        */
        static Матрица44 вращение(Кватернион q)
        in { assert( q.единица_ли() ); }
        body
        {
            т_плав tx  = 2.f * q.x;
            т_плав ty  = 2.f * q.y;
            т_плав tz  = 2.f * q.z;
            т_плав twx = tx * q.w;
            т_плав twy = ty * q.w;
            т_плав twz = tz * q.w;
            т_плав txx = tx * q.x;
            т_плав txy = ty * q.x;
            т_плав txz = tz * q.x;
            т_плав tyy = ty * q.y;
            т_плав tyz = tz * q.y;
            т_плав tzz = tz * q.z;
            
            Матрица44 мат = подобие;
            with (мат)
            {
                m00 = 1.f - (tyy + tzz); m01 = txy - twz;           m02 = txz + twy;
                m10 = txy + twz;         m11 = 1.f - (txx + tzz);   m12 = tyz - twx;
                m20 = txz - twy;         m21 = tyz + twx;           m22 = 1.f - (txx + tyy);
            }
            
            return мат;
        }
    
        /** Constructs _translation matrix with смещение значения specified as аргументы. */
        static Матрица44 перенос(т_плав x, т_плав y, т_плав z)
        {
            return Матрица44(1, 0, 0, x,
                            0, 1, 0, y,
                            0, 0, 1, z,
                            0, 0, 0, 1);
        }
    
        /** Constructs _translation matrix with смещение значения specified as v's components. */
        static Матрица44 перенос(Вектор3 v)
        {
            return перенос(v.x, v.y, v.z);
        }
        
        /**
        Constructs one-point perspecive projection matrix.
        Params:
            fov =       Field of view in vertical plane in радианы.
            aspect =    Frustum's width / height coefficient. It shouldn't be 0.
            near =      Distance to near plane.
            near =      Distance to far plane.
        */
        static Матрица44 перспектива(т_плав fov, т_плав aspect, т_плав near, т_плав far)
        in
        {
            assert( fov < 2*ПИ );
            assert( !равны(aspect, 0) );
            assert( near > 0 );
            assert( far > near );
        }
        body
        {
            реал cot = 1. / тан(fov / 2.);
                    
            return Матрица44(cot / aspect,    0,                            0,                                  0,
                            0,             cot,                            0,                                  0,
                            0,               0,  (near + far) / (near - far),  2.f * (near * far) / (near - far),
                            0,               0,                           -1,                                  0);
        }
        
        /**
        Constructs view matrix.
        Params:
            eye =       Viewer's eye позиция.
            target =    View target.
            up =        View up вектор.
        
        Аргументы should not be complanar, elsewise matrix will contain infinity
        элементы. You can проверь this with нормален_ли() method.
        */
        static Матрица44 видНа(Вектор3 eye, Вектор3 target, Вектор3 up)
        {
            Вектор3 z = (eye - target).нормализованный();
            alias up y;
            Вектор3 x = кросс(y, z);
            y = кросс(z, x);
            x.нормализуй();
            y.нормализуй();
                    
            Матрица44 мат = подобие;
            мат.v[0].xyz = Вектор3(x.x, y.x, z.x);
            мат.v[1].xyz = Вектор3(x.y, y.y, z.y);
            мат.v[2].xyz = Вектор3(x.z, y.z, z.z);
                    
            мат.m03 = -точка(eye, x);
            мат.m13 = -точка(eye, y);
            мат.m23 = -точка(eye, z);
                    
            return мат;    
        }
        
        /**
        Возвращает: Inverse копируй of this matrix.
        
        In case if this matrix is singular (i.e. детерминанта = 0) result matrix will имеется
        infinity элементы. You can проверь this with нормален_ли() method.
        */
        Матрица44 инверсия()
        {
            реал det = детерминанта();
            //if (равны(det, 0))
            //{
            //    return нч;
            //}
            
            реал rdet = 1/det;
            return Матрица44(
                rdet * (m11 * (m22 * m33 - m23 * m32) + m12 * (m23 * m31 - m21 * m33) + m13 * (m21 * m32 - m22 * m31)),
                rdet * (m21 * (m02 * m33 - m03 * m32) + m22 * (m03 * m31 - m01 * m33) + m23 * (m01 * m32 - m02 * m31)),
                rdet * (m31 * (m02 * m13 - m03 * m12) + m32 * (m03 * m11 - m01 * m13) + m33 * (m01 * m12 - m02 * m11)),
                rdet * (m01 * (m13 * m22 - m12 * m23) + m02 * (m11 * m23 - m13 * m21) + m03 * (m12 * m21 - m11 * m22)),
                rdet * (m12 * (m20 * m33 - m23 * m30) + m13 * (m22 * m30 - m20 * m32) + m10 * (m23 * m32 - m22 * m33)),
                rdet * (m22 * (m00 * m33 - m03 * m30) + m23 * (m02 * m30 - m00 * m32) + m20 * (m03 * m32 - m02 * m33)),
                rdet * (m32 * (m00 * m13 - m03 * m10) + m33 * (m02 * m10 - m00 * m12) + m30 * (m03 * m12 - m02 * m13)),
                rdet * (m02 * (m13 * m20 - m10 * m23) + m03 * (m10 * m22 - m12 * m20) + m00 * (m12 * m23 - m13 * m22)),
                rdet * (m13 * (m20 * m31 - m21 * m30) + m10 * (m21 * m33 - m23 * m31) + m11 * (m23 * m30 - m20 * m33)),
                rdet * (m23 * (m00 * m31 - m01 * m30) + m20 * (m01 * m33 - m03 * m31) + m21 * (m03 * m30 - m00 * m33)),
                rdet * (m33 * (m00 * m11 - m01 * m10) + m30 * (m01 * m13 - m03 * m11) + m31 * (m03 * m10 - m00 * m13)),
                rdet * (m03 * (m11 * m20 - m10 * m21) + m00 * (m13 * m21 - m11 * m23) + m01 * (m10 * m23 - m13 * m20)),
                rdet * (m10 * (m22 * m31 - m21 * m32) + m11 * (m20 * m32 - m22 * m30) + m12 * (m21 * m30 - m20 * m31)),
                rdet * (m20 * (m02 * m31 - m01 * m32) + m21 * (m00 * m32 - m02 * m30) + m22 * (m01 * m30 - m00 * m31)),
                rdet * (m30 * (m02 * m11 - m01 * m12) + m31 * (m00 * m12 - m02 * m10) + m32 * (m01 * m10 - m00 * m11)),
                rdet * (m00 * (m11 * m22 - m12 * m21) + m01 * (m12 * m20 - m10 * m22) + m02 * (m10 * m21 - m11 * m20)));
        }
        
        /**
        Inverts this matrix.
        
        In case if matrix is singular (i.e. детерминанта = 0) result matrix will имеется
        infinity элементы. You can проверь this with нормален_ли() method.
        */
        проц инвертируй()
        {
            реал det = детерминанта();
            //if (равны(det, 0))
            //{
            //    *this = нч;
            //    return;
            //}
            
            реал rdet = 1/det;
            установи(rdet * (m11 * (m22 * m33 - m23 * m32) + m12 * (m23 * m31 - m21 * m33) + m13 * (m21 * m32 - m22 * m31)),
                rdet * (m21 * (m02 * m33 - m03 * m32) + m22 * (m03 * m31 - m01 * m33) + m23 * (m01 * m32 - m02 * m31)),
                rdet * (m31 * (m02 * m13 - m03 * m12) + m32 * (m03 * m11 - m01 * m13) + m33 * (m01 * m12 - m02 * m11)),
                rdet * (m01 * (m13 * m22 - m12 * m23) + m02 * (m11 * m23 - m13 * m21) + m03 * (m12 * m21 - m11 * m22)),
                rdet * (m12 * (m20 * m33 - m23 * m30) + m13 * (m22 * m30 - m20 * m32) + m10 * (m23 * m32 - m22 * m33)),
                rdet * (m22 * (m00 * m33 - m03 * m30) + m23 * (m02 * m30 - m00 * m32) + m20 * (m03 * m32 - m02 * m33)),
                rdet * (m32 * (m00 * m13 - m03 * m10) + m33 * (m02 * m10 - m00 * m12) + m30 * (m03 * m12 - m02 * m13)),
                rdet * (m02 * (m13 * m20 - m10 * m23) + m03 * (m10 * m22 - m12 * m20) + m00 * (m12 * m23 - m13 * m22)),
                rdet * (m13 * (m20 * m31 - m21 * m30) + m10 * (m21 * m33 - m23 * m31) + m11 * (m23 * m30 - m20 * m33)),
                rdet * (m23 * (m00 * m31 - m01 * m30) + m20 * (m01 * m33 - m03 * m31) + m21 * (m03 * m30 - m00 * m33)),
                rdet * (m33 * (m00 * m11 - m01 * m10) + m30 * (m01 * m13 - m03 * m11) + m31 * (m03 * m10 - m00 * m13)),
                rdet * (m03 * (m11 * m20 - m10 * m21) + m00 * (m13 * m21 - m11 * m23) + m01 * (m10 * m23 - m13 * m20)),
                rdet * (m10 * (m22 * m31 - m21 * m32) + m11 * (m20 * m32 - m22 * m30) + m12 * (m21 * m30 - m20 * m31)),
                rdet * (m20 * (m02 * m31 - m01 * m32) + m21 * (m00 * m32 - m02 * m30) + m22 * (m01 * m30 - m00 * m31)),
                rdet * (m30 * (m02 * m11 - m01 * m12) + m31 * (m00 * m12 - m02 * m10) + m32 * (m01 * m10 - m00 * m11)),
                rdet * (m00 * (m11 * m22 - m12 * m21) + m01 * (m12 * m20 - m10 * m22) + m02 * (m10 * m21 - m11 * m20)));
        }
        
        /** Возвращает: Determinant */
        реал детерминанта()
        {
            return
                + (m00 * m11 - m01 * m10) * (m22 * m33 - m23 * m32)
                - (m00 * m12 - m02 * m10) * (m21 * m33 - m23 * m31)
                + (m00 * m13 - m03 * m10) * (m21 * m32 - m22 * m31)
                + (m01 * m12 - m02 * m11) * (m20 * m33 - m23 * m30)
                - (m01 * m13 - m03 * m11) * (m20 * m32 - m22 * m30)
                + (m02 * m13 - m03 * m12) * (m20 * m31 - m21 * m30);
        }
        
        /**
        Возвращает: Frobenius _norm of matrix.
        Ссылки:
            $(LINK http://en.wikipedia.org/wiki/Frobenius_norm#Frobenius_norm).        
        */
        реал нормаль()
        {
            return квкор( квадратНорм );
        }
        
        /**
        Возвращает: Square of Frobenius нормаль of matrix.

        Method doesn't need calculation of square корень.

        Ссылки:
            $(LINK http://en.wikipedia.org/wiki/Frobenius_norm#Frobenius_norm).
        */
        реал квадратНорм()
        {
            реал возвр = 0;
            for (цел i = 16; i--; )
            {
                реал x = a[i];
                возвр += x * x;
            }
            
            return возвр;
        }
        
        /** 
        Возвращает: Whether this matrix represents affine transformation.
        Ссылки:
            $(LINK http://en.wikipedia.org/wiki/Affine_transformation).
        */
        бул isAffine()
        {
            return равны(m30, 0) && равны(m31, 0) && равны(m32, 0) && равны(m33, 1);
        }
        
        /** Transposes this matrix. */
        проц транспонируй()
        {
            /*           */        переставь(m01, m10);        переставь(m02, m20);        переставь(m03, m30);
            /*           */        /*           */        переставь(m12, m21);        переставь(m13, m31);
            /*           */        /*           */        /*           */        переставь(m23, m32);
            /*           */        /*           */        /*           */        /*           */
        }
        
        /** Возвращает: Transposed копируй of this matrix. */
        Матрица44 транспонированный()
        {
            return Матрица44(
                m00, m10, m20, m30,
                m01, m11, m21, m31,
                m02, m12, m22, m32,
                m03, m13, m23, m33 );
        }
        
        /** R/W property. Corner 3x3 minor. */
        Матрица33 углМинор()
        {
            return Матрица33(m00, m01, m02,
                            m10, m11, m12,
                            m20, m21, m22);
        }
        
        /** описано */
        проц углМинор(Матрица33 мат)
        {
            m00 = мат.m00;        m01 = мат.m01;        m02 = мат.m02;
            m10 = мат.m10;        m11 = мат.m11;        m12 = мат.m12;
            m20 = мат.m20;        m21 = мат.m21;        m22 = мат.m22;
        }
        
        /**
        Standard operators that have intuitive meaning, same as in classical math. Exception
        is multiplication with Vecto3 that doesn't make sense for classical math, in that case
        Вектор3 is implicitl expanded to Вектор4 with w=1.
        
        Note that division operators do no cheks of значение of k, so in case of division
        by 0 result matrix will have infinity components. You can проверь this with нормален_ли()
        method.
        */
        Матрица44 opNeg()
        {
            return Матрица44(-m00, -m01, -m02, -m03,
                            -m10, -m11, -m12, -m13,
                            -m20, -m21, -m22, -m23,
                            -m30, -m31, -m32, -m33);
        }
    
        /** описано */
        Матрица44 opAdd(Матрица44 мат)
        {
            return Матрица44(m00 + мат.m00, m01 + мат.m01, m02 + мат.m02, m03 + мат.m03,
                            m10 + мат.m10, m11 + мат.m11, m12 + мат.m12, m13 + мат.m13,
                            m20 + мат.m20, m21 + мат.m21, m22 + мат.m22, m23 + мат.m23,
                            m30 + мат.m30, m31 + мат.m31, m32 + мат.m32, m33 + мат.m33);
        }
    
        /** описано */
        проц opAddAssign(Матрица44 мат)
        {
            m00 += мат.m00; m01 += мат.m01; m02 += мат.m02; m03 += мат.m03;
            m10 += мат.m10; m11 += мат.m11; m12 += мат.m12; m13 += мат.m13;
            m20 += мат.m20; m21 += мат.m21; m22 += мат.m22; m23 += мат.m23;
            m30 += мат.m30; m31 += мат.m31; m32 += мат.m32; m33 += мат.m33;
        }
    
        /** описано */
        Матрица44 opSub(Матрица44 мат)
        {
            return Матрица44(m00 - мат.m00, m01 - мат.m01, m02 - мат.m02, m03 - мат.m03,
                            m10 - мат.m10, m11 - мат.m11, m12 - мат.m12, m13 - мат.m13,
                            m20 - мат.m20, m21 - мат.m21, m22 - мат.m22, m23 - мат.m23,
                            m30 - мат.m30, m31 - мат.m31, m32 - мат.m32, m33 - мат.m33);
        }
    
        /** описано */
        проц opSubAssign(Матрица44 мат)
        {
            m00 -= мат.m00; m01 -= мат.m01; m02 -= мат.m02; m03 -= мат.m03;
            m10 -= мат.m10; m11 -= мат.m11; m12 -= мат.m12; m13 -= мат.m13;
            m20 -= мат.m20; m21 -= мат.m21; m22 -= мат.m22; m23 -= мат.m23;        
            m30 -= мат.m30; m31 -= мат.m31; m32 -= мат.m32; m33 -= мат.m33;        
        }
    
        /** описано */
        Матрица44 opMul(т_плав k)
        {
            return Матрица44(m00 * k, m01 * k, m02 * k, m03 * k,
                            m10 * k, m11 * k, m12 * k, m13 * k,
                            m20 * k, m21 * k, m22 * k, m23 * k,
                            m30 * k, m31 * k, m32 * k, m33 * k);
        }
    
        /** описано */
        проц opMulAssign(т_плав k)
        {
            m00 *= k; m01 *= k; m02 *= k; m03 *= k;
            m10 *= k; m11 *= k; m12 *= k; m13 *= k;
            m20 *= k; m21 *= k; m22 *= k; m23 *= k;
            m30 *= k; m31 *= k; m32 *= k; m33 *= k;
        }
    
        /** описано */
        Матрица44 opMul_r(т_плав k)
        {
            return Матрица44(m00 * k, m01 * k, m02 * k, m03 * k,
                            m10 * k, m11 * k, m12 * k, m13 * k,
                            m20 * k, m21 * k, m22 * k, m23 * k,
                            m30 * k, m31 * k, m32 * k, m33 * k);
        }
    
        /** описано */
        Матрица44 opDiv(т_плав k)
        {
            
            return Матрица44(m00 / k, m01 / k, m02 / k, m03 / k,
                            m10 / k, m11 / k, m12 / k, m13 / k,
                            m20 / k, m21 / k, m22 / k, m23 / k,
                            m30 / k, m31 / k, m32 / k, m33 / k);
        }
    
        /** описано */
        проц opDivAssign(т_плав k)
        {
            m00 /= k; m01 /= k; m02 /= k; m03 /= k;
            m10 /= k; m11 /= k; m12 /= k; m13 /= k;
            m20 /= k; m21 /= k; m22 /= k; m23 /= k;
            m30 /= k; m31 /= k; m32 /= k; m33 /= k;
        }
    
        /** описано */
        бул opEquals(Матрица44 мат)
        {
            return m00 == мат.m00 && m01 == мат.m01 && m02 == мат.m02 && m03 == мат.m03 &&
                   m10 == мат.m10 && m11 == мат.m11 && m12 == мат.m12 && m13 == мат.m13 &&
                   m20 == мат.m20 && m21 == мат.m21 && m22 == мат.m22 && m23 == мат.m23 &&
                   m30 == мат.m30 && m31 == мат.m31 && m32 == мат.m32 && m33 == мат.m33;
        }

        /** описано */
        Матрица44 opMul(Матрица44 мат)
        {
            return Матрица44(m00 * мат.m00 + m01 * мат.m10 + m02 * мат.m20 + m03 * мат.m30,
                            m00 * мат.m01 + m01 * мат.m11 + m02 * мат.m21 + m03 * мат.m31,
                            m00 * мат.m02 + m01 * мат.m12 + m02 * мат.m22 + m03 * мат.m32,
                            m00 * мат.m03 + m01 * мат.m13 + m02 * мат.m23 + m03 * мат.m33,
    
                            m10 * мат.m00 + m11 * мат.m10 + m12 * мат.m20 + m13 * мат.m30,
                            m10 * мат.m01 + m11 * мат.m11 + m12 * мат.m21 + m13 * мат.m31,
                            m10 * мат.m02 + m11 * мат.m12 + m12 * мат.m22 + m13 * мат.m32,
                            m10 * мат.m03 + m11 * мат.m13 + m12 * мат.m23 + m13 * мат.m33,
    
                            m20 * мат.m00 + m21 * мат.m10 + m22 * мат.m20 + m23 * мат.m30,
                            m20 * мат.m01 + m21 * мат.m11 + m22 * мат.m21 + m23 * мат.m31,
                            m20 * мат.m02 + m21 * мат.m12 + m22 * мат.m22 + m23 * мат.m32,
                            m20 * мат.m03 + m21 * мат.m13 + m22 * мат.m23 + m23 * мат.m33,
    
                            m30 * мат.m00 + m31 * мат.m10 + m32 * мат.m20 + m33 * мат.m30,
                            m30 * мат.m01 + m31 * мат.m11 + m32 * мат.m21 + m33 * мат.m31,
                            m30 * мат.m02 + m31 * мат.m12 + m32 * мат.m22 + m33 * мат.m32,
                            m30 * мат.m03 + m31 * мат.m13 + m32 * мат.m23 + m33 * мат.m33);
        }
    
        /** описано */
        проц opMulAssign(Матрица44 мат)
        {
            *this = *this * мат;
        }
    
        /** описано */
        Вектор3 opMul(Вектор3 v)
        {
            return Вектор3(v.x * m00 + v.y * m01 + v.z * m02 + m03,
                           v.x * m10 + v.y * m11 + v.z * m12 + m13,
                           v.x * m20 + v.y * m21 + v.z * m22 + m23 );
        }
    
        /** описано */
        Вектор4 opMul(Вектор4 v)
        {
            return Вектор4(v.x * m00 + v.y * m01 + v.z * m02 + v.w * m03,
                           v.x * m10 + v.y * m11 + v.z * m12 + v.w * m13,
                           v.x * m20 + v.y * m21 + v.z * m22 + v.w * m23,
                           v.x * m30 + v.y * m31 + v.z * m32 + v.w * m33);
        }
    
        /** Возвращает: Элемент at ряд'th _row и столб'th column. */
        т_плав opIndex(бцел ряд, бцел столб)
        in { assert( столб < 4 && ряд < 4 ); }
        body
        {
            return m[столб][ряд];
        }
    
        /** Assigns значение f to элемент at ряд'th _row и столб'th column. */
        проц opIndexAssign(т_плав f, бцел ряд, бцел столб)
        in { assert( столб < 4 && ряд < 4 ); }
        body
        {
            m[столб][ряд] = f;
        }
        
        /** Возвращает: Вектор representing столб'th column. */
        Вектор4 opIndex(бцел столб)
        in { assert( столб < 4 ); }
        body
        {
            return v[столб];
        }
    
        /** Replaces элементы in столб'th column with v's значения. */
        проц opIndexAssign(Вектор4 v, бцел столб)
        in { assert( столб < 4 ); }
        body
        {
            this.v[столб] = v;
        }
    
        /**
        Возвращает: т_плав pointer to [0,0] элемент of this matrix. It's like a _ptr method for arrays.
        
        Remember about column-major matrix memory layout.
        */
        т_плав* укз()
        {
            return a.ptr;
        }
        
        /** Возвращает: Copy of this matrix with плав type элементы. */
        Матрица44п вМатрицу44п()
        {
            return Матрица44п(
                cast(плав)m00, cast(плав)m01, cast(плав)m02, cast(плав)m03,
                cast(плав)m10, cast(плав)m11, cast(плав)m12, cast(плав)m13,
                cast(плав)m20, cast(плав)m21, cast(плав)m22, cast(плав)m23,
                cast(плав)m30, cast(плав)m31, cast(плав)m32, cast(плав)m33 );
        }
        
        /** Возвращает: Copy of this matrix with дво type элементы. */
        Матрица44д вМатрицу44д()
        {
            return Матрица44д(
                cast(дво)m00, cast(дво)m01, cast(дво)m02, cast(дво)m03,
                cast(дво)m10, cast(дво)m11, cast(дво)m12, cast(дво)m13,
                cast(дво)m20, cast(дво)m21, cast(дво)m22, cast(дво)m23,
                cast(дво)m30, cast(дво)m31, cast(дво)m32, cast(дво)m33 );
        }
        
        /** Возвращает: Copy of this matrix with реал type элементы. */
        Матрица44р вМатрицу44р()
        {
            return Матрица44р(
                cast(реал)m00, cast(реал)m01, cast(реал)m02, cast(реал)m03,
                cast(реал)m10, cast(реал)m11, cast(реал)m12, cast(реал)m13,
                cast(реал)m20, cast(реал)m21, cast(реал)m22, cast(реал)m23,
                cast(реал)m30, cast(реал)m31, cast(реал)m32, cast(реал)m33 );
        }

        ткст вТкст() { 
            return фм("[" ,m00, ", " ,m01, ", " ,m02, ", " ,m03, ",\n",
                          " " ,m10, ", " ,m11, ", " ,m12, ", " ,m13, ",\n",
                          " " ,m20, ", " ,m21, ", " ,m22, ", " ,m23, ",\n",
                          " " ,m30, ", " ,m31, ", " ,m32, ", " ,m33, "]");
        }

    }
    
    alias РавенствоПоНорм!(Матрица44).равны равны; /// Introduces approximate equality function for Матрица44.
    alias Лининтерп!(Матрица44).лининтерп лининтерп;             /// Introduces linear interpolation function for Матрица44.    
}

alias ЛинейнаяАлгебра!(плав).Вектор2             Вектор2п;
alias ЛинейнаяАлгебра!(плав).Вектор3             Вектор3п;
alias ЛинейнаяАлгебра!(плав).Вектор4             Вектор4п;
alias ЛинейнаяАлгебра!(плав).Кватернион          Кватернионп;
alias ЛинейнаяАлгебра!(плав).Матрица22            Матрица22п;
alias ЛинейнаяАлгебра!(плав).Матрица33            Матрица33п;
alias ЛинейнаяАлгебра!(плав).Матрица44            Матрица44п;
alias ЛинейнаяАлгебра!(плав).равны               равны;
alias ЛинейнаяАлгебра!(плав).точка                 точка;
public alias ЛинейнаяАлгебра!(плав).внешн        внешн;
alias ЛинейнаяАлгебра!(плав).кросс               кросс;
alias ЛинейнаяАлгебра!(плав).ортогонально_лиОснование   ортогонально_лиОснование;
alias ЛинейнаяАлгебра!(плав).ортонормально_лиОснование  ортонормально_лиОснование;
alias ЛинейнаяАлгебра!(плав).лининтерп                лининтерп;
alias ЛинейнаяАлгебра!(плав).сфлининтерп               сфлининтерп;

alias ЛинейнаяАлгебра!(дво).Вектор2            Вектор2д;
alias ЛинейнаяАлгебра!(дво).Вектор3            Вектор3д;
alias ЛинейнаяАлгебра!(дво).Вектор4            Вектор4д;
alias ЛинейнаяАлгебра!(дво).Кватернион         Кватернионд;
alias ЛинейнаяАлгебра!(дво).Матрица22           Матрица22д;
alias ЛинейнаяАлгебра!(дво).Матрица33           Матрица33д;
alias ЛинейнаяАлгебра!(дво).Матрица44           Матрица44д;
alias ЛинейнаяАлгебра!(дво).равны              равны;
alias ЛинейнаяАлгебра!(дво).точка                точка;
//alias ЛинейнаяАлгебра!(дво).внешн              внешн;
alias ЛинейнаяАлгебра!(дво).кросс              кросс;
alias ЛинейнаяАлгебра!(дво).ортогонально_лиОснование  ортогонально_лиОснование;
alias ЛинейнаяАлгебра!(дво).ортонормально_лиОснование ортонормально_лиОснование;
alias ЛинейнаяАлгебра!(дво).лининтерп               лининтерп;
alias ЛинейнаяАлгебра!(дво).сфлининтерп              сфлининтерп;

alias ЛинейнаяАлгебра!(реал).Вектор2              Вектор2р;
alias ЛинейнаяАлгебра!(реал).Вектор3              Вектор3р;
alias ЛинейнаяАлгебра!(реал).Вектор4              Вектор4р;
alias ЛинейнаяАлгебра!(реал).Кватернион           Кватернионр;
alias ЛинейнаяАлгебра!(реал).Матрица22             Матрица22р;
alias ЛинейнаяАлгебра!(реал).Матрица33             Матрица33р;
alias ЛинейнаяАлгебра!(реал).Матрица44             Матрица44р;
alias ЛинейнаяАлгебра!(реал).равны                равны;
alias ЛинейнаяАлгебра!(реал).точка                  точка;
//alias ЛинейнаяАлгебра!(реал).внешн                внешн;
alias ЛинейнаяАлгебра!(реал).кросс                кросс;
alias ЛинейнаяАлгебра!(реал).ортогонально_лиОснование    ортогонально_лиОснование;
alias ЛинейнаяАлгебра!(реал).ортонормально_лиОснование   ортонормально_лиОснование;
alias ЛинейнаяАлгебра!(реал).лининтерп                 лининтерп;
alias ЛинейнаяАлгебра!(реал).сфлининтерп                сфлининтерп;

alias ЛинейнаяАлгебра!(linalg.config.т_плав).Вектор2     Вектор2;
alias ЛинейнаяАлгебра!(linalg.config.т_плав).Вектор3     Вектор3;
alias ЛинейнаяАлгебра!(linalg.config.т_плав).Вектор4     Вектор4;
alias ЛинейнаяАлгебра!(linalg.config.т_плав).Кватернион  Кватернион;
alias ЛинейнаяАлгебра!(linalg.config.т_плав).Матрица22    Матрица22;
alias ЛинейнаяАлгебра!(linalg.config.т_плав).Матрица33    Матрица33;
alias ЛинейнаяАлгебра!(linalg.config.т_плав).Матрица44    Матрица44;

unittest
{
    assert( Вектор2(1, 2).нормализованный().единица_ли() );
    assert( Вектор3(1, 2, 3).нормализованный().единица_ли() );
    assert( Вектор4(1, 2, 3, 4).нормализованный().единица_ли() );

    assert( Вектор2(1, 2).доминирующаяОсь() == Орт.Y );
    assert( Вектор3(1, 2, 3).доминирующаяОсь() == Орт.Z );
    assert( Вектор4(1, 2, 3, 4).доминирующаяОсь() == Орт.W );

    Вектор4 v;
    v.установи(1, 2, 3, 4);
    assert( v.нормален_ли() );
    v /= 0;
    assert( !v.нормален_ли() );

    v.установи(1, 2, 3, 4);
    v[Орт.Y] = v[Орт.X];
    assert( v == Вектор4(1, 1, 3, 4) );

    Вектор4 t = Вектор4(100, 200, 300, 400);
    Вектор4 s;
    v.установи(1, 2, 3, 4);
    s = v;
    v += t;
    v -= t;
    v = (v + t) - t;
    v *= 100;
    v /= 100;
    v = (10 * v * 10) / 100;
    assert( равны(v, s) );

    assert( точка( кросс( Вектор3(1, 0, 2), Вектор3(4, 0, 5) ), Вектор3(3, 0, -2) )  == 0 );
}

unittest
{
    реал yaw = ПИ / 8;
    реал pitch = ПИ / 3;
    реал roll = ПИ / 4;
    
    Кватернион q = Кватернион( Матрица33.вращение(yaw, pitch, roll) );
    assert( равны(q.yaw, yaw) );
    assert( равны(q.pitch, pitch) );
    assert( равны(q.roll, roll) );
}

unittest
{
    Матрица33 mat1 = Матрица33(1,2,3,4,5,6,7,8,9);
    static плав[9] a = [1,2,3,4,5,6,7,8,9];
    Матрица33 mat2 = Матрица33(a);

    assert(mat1 == mat2.транспонированный);
}

/*
unittest
{
    Матрица33 a;
    
    a.m01 = 2;
    a.a[1] = 3;
    a.v[0].z = 4;
    assert(a[0, 1] == 2);
    assert(a[1, 0] == 3);
    assert(a[2, 0] == 4);
}
*/
unittest
{
    Матрица33 a = Матрица33.вращение( Вектор3(1, 2, 3).нормализованный, ПИ / 7.f );
    Матрица33 b = a.инверсия;
    b.инвертируй();
    assert( равны(a, b) );
    assert( равны(a.транспонированный.инверсия, a.инверсия.транспонированный) );
}

unittest
{
    Матрица33 Q, S;
    Матрица33 rot = Матрица33.вращЗэт(ПИ / 7);
    Матрица33 масштабируй = Матрица33.масштабируй(-1, 2, 3);
    Матрица33 composition = rot * масштабируй;
    composition.polarDecomposition(Q, S);    
    assert( равны(Q * S, composition) );
}
