﻿module tpl.stream;
import dinrus, sys.WinIfaces, sys.WinConsts, cidrus;

protected бул пробел(сим c) {
  return c == ' ' || c == '\t' || c == '\r' || c == '\n';
}

protected бул цифра(сим c) {
  return c >= '0' && c <= '9';
}

protected бул цифра8(сим c) {
  return c >= '0' && c <= '7';
}

protected бул цифра16(сим c) {
  return цифра(c) || (c >= 'A' && c <= 'F') || (c >= 'a' && c <= 'f');
}


extern (D) abstract class Поток :  sys.WinIfaces.ПотокВвода, sys.WinIfaces.ПотокВывода
 {
 
	extern (C) extern
	{
      шим[] возврат;
	  бул читаем;	
	  бул записываем;
	  бул сканируем;
	  бул открыт;	
	  бул читайдоКФ;
	  бул предВкар;
	}
 
	  бул читаемый();
	  бул записываемый();
	  бул сканируемый();	  
	  проц читаемый(бул б);
	  проц записываемый(бул б);
	  проц сканируемый(бул б);	  
	  проц открытый(бул б);
	  бул открытый();
	   проц читатьдоКФ(бул б);
	  бул читатьдоКФ();	  
	  проц возвратКаретки(бул б);
	  бул возвратКаретки();
	  static this() {}
	  this();
	  ~this();	  
	  т_мера читайБлок(ук буфер, т_мера размер);
	  проц читайРовно(ук буфер, т_мера размер);
	  т_мера читай(ббайт[] буфер);
	  проц читай(out байт x) ;
	  проц читай(out ббайт x) ;
	  проц читай(out крат x) ;
	  проц читай(out бкрат x) ;
	  проц читай(out цел x) ;
	  проц читай(out бцел x) ;
	  проц читай(out дол x) ;
	  проц читай(out бдол x) ;
	  проц читай(out плав x) ;
	  проц читай(out дво x) ;
	  проц читай(out реал x) ;
	  проц читай(out вплав x) ;
	  проц читай(out вдво x) ;
	  проц читай(out вреал x) ;
	  проц читай(out кплав x) ;
	  проц читай(out кдво x) ;
	  проц читай(out креал x) ;
	  проц читай(out сим x) ;
	  проц читай(out шим x) ;
	  проц читай(out дим x) ;
	  проц читай(out ткст s) ;
	  проц читай(out шим[] s) ;
	  ткст читайСтр();
	  ткст читайСтр(ткст результат);
	  шим[] читайСтрШ();
	  шим[] читайСтрШ(шим[] результат) ;
	  цел opApply(цел delegate(inout ткст строка) дг) ;
	  цел opApply(цел delegate(inout бдол n, inout ткст строка) дг) ;
	  цел opApply(цел delegate(inout шим[] строка) дг) ;
	  цел opApply(цел delegate(inout бдол n, inout шим[] строка) дг);
	  ткст читайТкст(т_мера length);
	  шим[] читайТкстШ(т_мера length);
	   бул верниЧтоЕсть();
	  сим берис() ;
	  шим бериш();
	  сим отдайс(сим c);
	  шим отдайш(шим c);
	  цел вчитайф(ИнфОТипе[] arguments, ук args);
	  цел читайф(...) ;
	  т_мера доступно();
	  abstract т_мера пишиБлок(ук буфер, т_мера размер);
	  проц пишиРовно(ук буфер, т_мера размер);
	  т_мера пиши(ббайт[] буфер) ;
	  проц пиши(байт x) ;
	  проц пиши(ббайт x) ;
	  проц пиши(крат x) ;
	  проц пиши(бкрат x) ;
	  проц пиши(цел x) ;
	  проц пиши(бцел x) ;
	  проц пиши(дол x) ;
	  проц пиши(бдол x) ;
	  проц пиши(плав x) ;
	  проц пиши(дво x) ;
	  проц пиши(реал x) ;
	  проц пиши(вплав x) ;
	  проц пиши(вдво x) ;
	  проц пиши(вреал x) ;
	  проц пиши(кплав x) ;
	  проц пиши(кдво x) ;
	  проц пиши(креал x) ;
	  проц пиши(сим x) ;
	  проц пиши(шим x) ;
	  проц пиши(дим x) ;
	  проц пишиТкст(ткст s);
	  проц пишиТкстШ(шткст s) ;
	  проц пиши(ткст s) ;
	  проц пиши(шткст s);
	  проц пишиСтр(ткст s);
	  проц пишиСтрШ(шим[] s);
	  т_мера ввыводф(ткст format, спис_ва args);
	  т_мера выводф(ткст format, ...);
	  проц doFormatCallback(дим c);
	  ПотокВывода пишиф(...) ;
	  ПотокВывода пишифнс(...) ;
	  ПотокВывода пишификс(ИнфОТипе[] arguments, ук argptr, цел newline=0);
	  проц копируй_из(Поток s);
	  проц копируй_из(Поток s, бдол count);
	  abstract бдол сместись(дол offset, ППозКурсора whence);
	  бдол измпозУст(дол offset);
	  бдол измпозТек(дол offset) ;
	  бдол измпозКон(дол offset) ;
	  проц позиция(бдол pos);
	  бдол позиция() ;
	  бдол размер() ;
	  бул кф() ;
	  бул открыт_ли();
	  проц слей();
	  проц закрой() ;
	 проц удали (ткст имяф);
	  //override ткст toString() ;
	ткст вТкст();
	 // override т_мера toHash();
	т_мера вХэш();
	  бул проверьЧитаемость(ткст имяПотока = ткст.init,ткст файл = ткст.init, дол  строка = дол.init) ;
	  бул проверьЗаписываемость(ткст имяПотока = ткст.init,ткст файл = ткст.init, дол  строка = дол.init) ;
	  бул проверьСканируемость(ткст имяПотока = ткст.init,ткст файл = ткст.init, дол  строка = дол.init) ;
	}

	


extern (D) class ТПотокМассив(Буфер): Поток {

  Буфер буф; // текущие данные
  бдол длин;  // текущие данные длина
  бдол тек;  // текущие файл позиция

  /// Create the stream for the the буфер буф. Non-copying.
  this(Буфер бф) {
    super ();
	this.буф = бф;
    this.длин = бф.length;
    читаемый(да); записываемый(да); сканируемый(да);
	читаемый();
  }

  // ensure подстclasses don't violate this
 // invariant() {
   // assert(длин <= буф.length);
   // assert(тек <= длин);
 // }

  т_мера читайБлок(ук буфер, т_мера размер) {
    проверьЧитаемость();
    ббайт* cbuf = cast(ббайт*) буфер;
    if (длин - тек < размер)
      размер = cast(т_мера)(длин - тек);
    ббайт[] ubuf = cast(ббайт[])буф[cast(т_мера)тек .. cast(т_мера)(тек + размер)];
    cbuf[0 .. размер] = ubuf[];
    тек += размер;
    return размер;
  }

  т_мера пишиБлок(ук буфер, т_мера размер) {
    проверьЗаписываемость();
    ббайт* cbuf = cast(ббайт*) буфер;
    бдол blen = буф.length;
    if (тек + размер > blen)
      размер = cast(т_мера)(blen - тек);
    ббайт[] ubuf = cast(ббайт[])буф[cast(т_мера)тек .. cast(т_мера)(тек + размер)];
    ubuf[] = cbuf[0 .. размер];
    тек += размер;
    if (тек > длин)
      длин = тек;
    return размер;
  }

   бдол сместись(дол смещение, ППозКурсора rel) {
    проверьСканируемость();
    дол scur; // signed to saturate to 0 properly

    switch (rel) {
    case ППозКурсора.Уст: scur = смещение; break;
    case ППозКурсора.Тек: scur = cast(дол)(тек + смещение); break;
    case ППозКурсора.Кон: scur = cast(дол)(длин + смещение); break;
    default:
	assert(0);
    }

    if (scur < 0)
      тек = 0;
    else if (scur > длин)
      тек = длин;
    else
      тек = cast(бдол)scur;

    return тек;
  }

 override т_мера доступно () { return cast(т_мера)(длин - тек); }

  /// Get the текущие memory данные in total.
  ббайт[] данные() { 
    if (длин > т_мера.max)
      throw new Исключение("ТПотокМассив.данные: поток слишком длинный!");
    проц[] res = буф[0 .. cast(т_мера)длин];
    return cast(ббайт[])res;
  }

  override ткст вТкст() {
    return cast(сим[]) данные ();
  }
  
  ~this(){}
}