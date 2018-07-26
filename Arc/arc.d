
module lib.arc;

import arc.window, std.string, std.math, derelict.sdl.sdl;
import arc.font, arc.templates.array, arc.texture,arc.draw.color,arc.internals.input.constants;
import derelict.opengl.gl, derelict.opengl.glu;
import arc.xml.xml,arc.xml.misc;
import std.regexp, std.file, os.windows;


import derelict.openal.al;

import 	
	derelict.ogg.vorbis, 
	derelict.ogg.ogg,
	derelict.util.exception;

import 	
	std.mmfile, std.string,
	rt.core.c; //std.gc;


import std.string, std.utf, std.format, std.file, crc32, os.windows, std.c;
//import runtime: консоль;
alias wchar[] шткст;
alias va_arg ва_арг;
alias vsnprintf вснвыводф;
alias alloca разместа;
alias isfile естьФайл;
alias toUTF16 вЮ16;
alias toUTF32 вЮ32;
alias toUTF8 вЮ8;
alias init_crc32 иницЦПИ32;
alias update_crc32 обновиЦПИ32;
alias void *спис_ва;

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

бул УдалиФайл(in шткст фимя)
	{
	ткст ф = toUTF8(фимя);
	return cast(бул) DeleteFileW(toUTF16z(ф));
	}
	

enum ППозКурсора {
  Уст,
  Тек,
  Кон,   
}

interface ПотокВвода{  

  проц читайРовно(ук буфер, т_мера размер);
  т_мера читай(ббайт[] буфер);
  проц читай(out байт x);
  проц читай(out ббайт x);	
  проц читай(out крат x);	
  проц читай(out бкрат x);	
  проц читай(out цел x);		
  проц читай(out бцел x);	
  проц читай(out дол x);	
  проц читай(out бдол x);	
  проц читай(out плав x);	
  проц читай(out дво x);	
  проц читай(out реал x);	
  проц читай(out вплав x);	
  проц читай(out вдво x);	
  проц читай(out вреал x);	
  проц читай(out кплав x);	
  проц читай(out кдво x);	
  проц читай(out креал x);	
  проц читай(out сим x);	
  проц читай(out шим x);	
  проц читай(out дим x);	
  проц читай(out ткст s);	
  проц читай(out шим[] s);	
  ткст читайСтр();
  ткст читайСтр(ткст результат);	
  шим[] читайСтрШ();			
  шим[] читайСтрШ(шим[] результат);	
  цел opApply(цел delegate(inout ткст строка) дг);
  цел opApply(цел delegate(inout бдол n, inout ткст строка) дг);  
  цел opApply(цел delegate(inout шим[] строка) дг);		   
  цел opApply(цел delegate(inout бдол n, inout шим[] строка) дг); 
  ткст читайТкст(т_мера length);
  шим[]читайТкстШ(т_мера length);
  сим берис();
  шим бериш(); 
  сим отдайс(сим c);
  шим отдайш(шим c);
  цел вчитайф(ИнфОТипе[] arguments, ук арги);
  цел читайф(...); 
  т_мера доступно();
  бул кф();
  бул открыт_ли();
}

interface ПотокВывода {

проц пишиРовно(ук буфер, т_мера размер);
  т_мера пиши(ббайт[] буфер);
  проц пиши(байт x);
  проц пиши(ббайт x);		
  проц пиши(крат x);		
  проц пиши(бкрат x);		
  проц пиши(цел x);		
  проц пиши(бцел x);		
  проц пиши(дол x);		
  проц пиши(бдол x);		
  проц пиши(плав x);		
  проц пиши(дво x);		
  проц пиши(реал x);		
  проц пиши(вплав x);		
  проц пиши(вдво x);	
  проц пиши(вреал x);		
  проц пиши(кплав x);		
  проц пиши(кдво x);	
  проц пиши(креал x);		
  проц пиши(сим x);		
  проц пиши(шим x);		
  проц пиши(дим x);		
  проц пиши(ткст s);
  проц пиши(шим[] s);	
  проц пишиСтр(ткст s);
  проц пишиСтрШ(шим[] s);
  проц пишиТкст(ткст s);
  проц пишиТкстШ(шим[] s);
  т_мера ввыводф(ткст format, спис_ва арги);
  т_мера выводф(ткст format, ...);	
  ПотокВывода пишиф(...);
  ПотокВывода пишифнс(...); 
  ПотокВывода пишификс(ИнфОТипе[] arguments, ук аргук, цел newline = 0);  

  проц слей();	
  проц закрой(); 
  бул открыт_ли(); 
}

export extern(D) abstract class Поток :  ПотокВвода, ПотокВывода
 {

 
export extern (C) extern
{
      шим[] возврат;
	  бул читаем;	
	  бул записываем;
	  бул сканируем;
	  бул открыт;	
	  бул читайдоКФ;
	  бул предВкар;
	  }
	 export:
	 
	  бул читаемый(){return this.читаем;}
	  бул записываемый(){return this.записываем;}
	  бул сканируемый(){return this.сканируем;}
	  
	  проц читаемый(бул б){this.читаем = б;}
	  проц записываемый(бул б){this.записываем = б;}
	  проц сканируемый(бул б){this.сканируем = б;}
	  
	  проц открытый(бул б){this.открыт = б;}
	  бул открытый(){return открыт;}
	  
	   проц читатьдоКФ(бул б){this.читайдоКФ = б;}
	  бул читатьдоКФ(){return  this.читайдоКФ;}
	  
	  проц возвратКаретки(бул б){this.предВкар = б;}
	  бул возвратКаретки(){return  this.предВкар;} 
	  

	  //protected static this() {}

	  this() 
	  {
	  this.читаем = false;	
	  this.записываем = false;
	  this.сканируем = false;
	  this.открыт = true;	
	  this.читайдоКФ = false;
	  this.предВкар = false;
	  }
	  ~this(){}
	  
	  т_мера читайБлок(ук буфер, т_мера размер){return 0;}

	  проц читайРовно(ук буфер, т_мера размер) {
		for(;;) {
		  if (!размер) return;
		  т_мера readsize = читайБлок(буфер, размер); // return 0 on кф
		  if (readsize == 0) break;
		  буфер += readsize;
		  размер -= readsize;
		}
		if (размер != 0)
		  throw new Exception("Поток.читайБлок: Недостаточно данных в потоке",__FILE__,__LINE__);
	  }

	  // считывает блок данных, достаточный для заполнения
	  // заданного массива, возвращает чило действительно считанных байтов
	  т_мера читай(ббайт[] буфер) {
		return читайБлок(буфер.ptr, буфер.length);
	  }

	  // читай a single значение of desired type,
	  // throw ИсключениеЧтения on error
	  проц читай(out байт x) { читайРовно(&x, x.sizeof); }
	  проц читай(out ббайт x) { читайРовно(&x, x.sizeof); }
	  проц читай(out крат x) { читайРовно(&x, x.sizeof); }
	  проц читай(out бкрат x) { читайРовно(&x, x.sizeof); }
	  проц читай(out цел x) { читайРовно(&x, x.sizeof); }
	  проц читай(out бцел x) { читайРовно(&x, x.sizeof); }
	  проц читай(out дол x) { читайРовно(&x, x.sizeof); }
	  проц читай(out бдол x) { читайРовно(&x, x.sizeof); }
	  проц читай(out плав x) { читайРовно(&x, x.sizeof); }
	  проц читай(out дво x) { читайРовно(&x, x.sizeof); }
	  проц читай(out реал x) { читайРовно(&x, x.sizeof); }
	  проц читай(out вплав x) { читайРовно(&x, x.sizeof); }
	  проц читай(out вдво x) { читайРовно(&x, x.sizeof); }
	  проц читай(out вреал x) { читайРовно(&x, x.sizeof); }
	  проц читай(out кплав x) { читайРовно(&x, x.sizeof); }
	  проц читай(out кдво x) { читайРовно(&x, x.sizeof); }
	  проц читай(out креал x) { читайРовно(&x, x.sizeof); }
	  проц читай(out сим x) { читайРовно(&x, x.sizeof); }
	  проц читай(out шим x) { читайРовно(&x, x.sizeof); }
	  проц читай(out дим x) { читайРовно(&x, x.sizeof); }

	  // reads a ткст, written earlier by пиши()
	  проц читай(out ткст s) {
		т_мера длин;
		читай(длин);
		s = читайТкст(длин);
	  }

	  // reads a Unicode ткст, written earlier by пиши()
	  проц читай(out шим[] s) {
		т_мера длин;
		читай(длин);
		s = читайТкстШ(длин);
	  }

	  // reads a строка, terminated by either CR, LF, CR/LF, or EOF
	  ткст читайСтр() {
		return читайСтр(null);
	  }

	  // reads a строка, terminated by either CR, LF, CR/LF, or EOF
	  // reusing the memory in буфер if результат will fit and otherwise
	  // allocates a new ткст
	  ткст читайСтр(ткст результат) {
		т_мера strlen = 0;
		сим ch = берис();
		while (читаем) {
		  switch (ch) {
		  case '\r':
		if (сканируем) {
		  ch = берис();
		  if (ch != '\n')
			отдайс(ch);
		} else {
		  предВкар = true;
		}
		  case '\n':
		  case сим.init:
		результат.length = strlen;
		return результат;

		  default:
		if (strlen < результат.length) {
		  результат[strlen] = ch;
		} else {
		  результат ~= ch;
		}
		strlen++;
		  }
		  ch = берис();
		}
		результат.length = strlen;
		return результат;
	  }

	  // reads a Unicode строка, terminated by either CR, LF, CR/LF,
	  // or EOF; pretty much the same as the above, working with
	  // шимs rather than симs
	  шим[] читайСтрШ() {
		return читайСтрШ(null);
	  }

	  // reads a Unicode строка, terminated by either CR, LF, CR/LF,
	  // or EOF;
	  // fills supplied буфер if строка fits and otherwise allocates a new ткст.
	  шим[] читайСтрШ(шим[] результат) {
		т_мера strlen = 0;
		шим c = бериш();
		while (читаем) {
		  switch (c) {
		  case '\r':
		if (сканируем) {
		  c = бериш();
		  if (c != '\n')
			отдайш(c);
		} else {
		  предВкар = true;
		}
		  case '\n':
		  case шим.init:
		результат.length = strlen;
		return результат;

		  default:
		if (strlen < результат.length) {
		  результат[strlen] = c;
		} else {
		  результат ~= c;
		}
		strlen++;
		  }
		  c = бериш();
		}
		результат.length = strlen;
		return результат;
	  }

	  // iterate through the stream строка-by-строка - due to Regan Heath
	  цел opApply(цел delegate(inout ткст строка) дг) {
		цел res = 0;
		сим[128] буф;
		while (!кф()) {
		  ткст строка = читайСтр(буф);
		  res = дг(строка);
		  if (res) break;
		}
		return res;
	  }

	  // iterate through the stream строка-by-строка with строка count and ткст
	  цел opApply(цел delegate(inout бдол n, inout ткст строка) дг) {
		цел res = 0;
		бдол n = 1;
		сим[128] буф;
		while (!кф()) {
		  auto строка = читайСтр(буф);
		  res = дг(n,строка);
		  if (res) break;
		  n++;
		}
		return res;
	  }

	  // iterate through the stream строка-by-строка with шим[]
	  цел opApply(цел delegate(inout шим[] строка) дг) {
		цел res = 0;
		шим[128] буф;
		while (!кф()) {
		  auto строка = читайСтрШ(буф);
		  res = дг(строка);
		  if (res) break;
		}
		return res;
	  }

	  // iterate through the stream строка-by-строка with строка count and шим[]
	  цел opApply(цел delegate(inout бдол n, inout шим[] строка) дг) {
		цел res = 0;
		бдол n = 1;
		шим[128] буф;
		while (!кф()) {
		  auto строка = читайСтрШ(буф);
		  res = дг(n,строка);
		  if (res) break;
		  n++;
		}
		return res;
	  }

	  // reads a ткст of given length, throws
	  // ИсключениеЧтения on error
	  ткст читайТкст(т_мера length) {
		ткст результат = new сим[length];
		читайРовно(результат.ptr, length);
		return результат;
	  }

	  // reads a Unicode ткст of given length, throws
	  // ИсключениеЧтения on error
	  шим[] читайТкстШ(т_мера length) {
		auto результат = new шим[length];
		читайРовно(результат.ptr, результат.length * шим.sizeof);
		return результат;
	  }

	  // отдай буфер
	  
	   бул верниЧтоЕсть() { return возврат.length > 1; }

	  // reads and returns следщ симacter from the stream,
	  // handles симacters pushed back by отдайс()
	  // returns сим.init on кф.
	  сим берис() {
		сим c;
		if (предВкар) {
		  предВкар = false;
		  c = берис();
		  if (c != '\n') 
		  return c;
		}
		if (возврат.length > 1) {
		  c = cast(сим) возврат[возврат.length - 1];
		  возврат.length = возврат.length - 1;
		} else {
		
		   читайБлок(&c,1);
		}
		//скажинс("берис2");
		//скажинс(форматируй(c));
		return c;
	  }

	  // reads and returns следщ Unicode симacter from the
	  // stream, handles симacters pushed back by отдайс()
	  // returns шим.init on кф.
	  шим бериш() {
		шим c;
		if (предВкар) {
		  предВкар = false;
		  c = бериш();
		  if (c != '\n') 
		return c;
		}
		if (возврат.length > 1) {
		  c = возврат[возврат.length - 1];
		  возврат.length = возврат.length - 1;
		} else {
		  ук буф = &c;
		  т_мера n = читайБлок(буф,2);
		  if (n == 1 && читайБлок(буф+1,1) == 0)
			  throw new Exception("Поток.бериш: Недостаточно данных в потоке",__FILE__,__LINE__);
		}
		return c;
	  }

	  // pushes back симacter c целo the stream; only has
	  // effect on further calls to берис() and бериш()
	  сим отдайс(сим c) {
		  if (c == c.init) return c;
		// first байт is a dummy so that we never установи length to 0
		if (возврат.length == 0)
		  возврат.length = 1;
		возврат ~= c;
		return c;
	  }

	  // pushes back Unicode симacter c целo the stream; only
	  // has effect on further calls to берис() and бериш()
	  шим отдайш(шим c) {
		if (c == c.init) return c;
		// first байт is a dummy so that we never установи length to 0
		if (возврат.length == 0)
		  возврат.length = 1;
		возврат ~= c;
		return c;
	  }

	  цел вчитайф(ИнфОТипе[] arguments, ук args) {
		ткст fmt;
		цел j = 0;
		цел count = 0, i = 0;
		сим c = берис();
		while ((j < arguments.length || i < fmt.length) && !кф()) {
		  if (fmt.length == 0 || i == fmt.length) {
		i = 0;
		if (arguments[j] is typeid(сим[])) {
		  fmt = ва_арг!(ткст)(args);
		  j++;
		  continue;
		} else if (arguments[j] is typeid(цел*) ||
			   arguments[j] is typeid(байт*) ||
			   arguments[j] is typeid(крат*) ||
			   arguments[j] is typeid(дол*)) {
		  fmt = "%d";
		} else if (arguments[j] is typeid(бцел*) ||
			   arguments[j] is typeid(ббайт*) ||
			   arguments[j] is typeid(бкрат*) ||
			   arguments[j] is typeid(бдол*)) {
		  fmt = "%d";
		} else if (arguments[j] is typeid(плав*) ||
			   arguments[j] is typeid(дво*) ||
			   arguments[j] is typeid(реал*)) {
		  fmt = "%f";
		} else if (arguments[j] is typeid(сим[]*) ||
			   arguments[j] is typeid(шим[]*) ||
			   arguments[j] is typeid(дим[]*)) {
		  fmt = "%s";
		} else if (arguments[j] is typeid(сим*)) {
		  fmt = "%c";
		}
		  }
		  if (fmt[i] == '%') {	// a field
		i++;
		бул suppress = false;
		if (fmt[i] == '*') {	// suppress assignment
		  suppress = true;
		  i++;
		}
		// читай field width
		цел width = 0;
		while (цифра(fmt[i])) {
		  width = width * 10 + (fmt[i] - '0');
		  i++;
		}
		if (width == 0)
		  width = -1;
		// skip any modifier if present
		if (fmt[i] == 'h' || fmt[i] == 'l' || fmt[i] == 'L')
		  i++;
		// check the typeсим and act accordingly
		switch (fmt[i]) {
		case 'd':	// decimal/hexadecimal/octal целeger
		case 'D':
		case 'u':
		case 'U':
		case 'o':
		case 'O':
		case 'x':
		case 'X':
		case 'i':
		case 'I':
		  {
			while (пробел(c)) {
			  c = берис();
			  count++;
			}
			бул neg = false;
			if (c == '-') {
			  neg = true;
			  c = берис();
			  count++;
			} else if (c == '+') {
			  c = берис();
			  count++;
			}
			сим ifmt = cast(сим)(fmt[i] | 0x20);
			if (ifmt == 'i')	{ // undetermined base
			  if (c == '0')	{ // octal or hex
			c = берис();
			count++;
			if (c == 'x' || c == 'X')	{ // hex
			  ifmt = 'x';
			  c = берис();
			  count++;
			} else {	// octal
			  ifmt = 'o';
			}
			  }
			  else	// decimal
			ifmt = 'd';
			}
			дол n = 0;
			switch (ifmt)
			{
			case 'd':	// decimal
			case 'u': {
			  while (цифра(c) && width) {
				n = n * 10 + (c - '0');
				width--;
				c = берис();
				count++;
			  }
			} break;

			case 'o': {	// octal
			  while (цифра8(c) && width) {
				n = n * 010 + (c - '0');
				width--;
				c = берис();
				count++;
			  }
			} break;

			case 'x': {	// hexadecimal
			  while (цифра16(c) && width) {
				n *= 0x10;
				if (цифра(c))
				  n += c - '0';
				else
				  n += 0xA + (c | 0x20) - 'a';
				width--;
				c = берис();
				count++;
			  }
			} break;

			default:
				assert(0);
			}
			if (neg)
			  n = -n;
			if (arguments[j] is typeid(цел*)) {
			  цел* p = ва_арг!(цел*)(args);
			  *p = cast(цел)n;
			} else if (arguments[j] is typeid(крат*)) {
			  крат* p = ва_арг!(крат*)(args);
			  *p = cast(крат)n;
			} else if (arguments[j] is typeid(байт*)) {
			  байт* p = ва_арг!(байт*)(args);
			  *p = cast(байт)n;
			} else if (arguments[j] is typeid(дол*)) {
			  дол* p = ва_арг!(дол*)(args);
			  *p = n;
			} else if (arguments[j] is typeid(бцел*)) {
			  бцел* p = ва_арг!(бцел*)(args);
			  *p = cast(бцел)n;
			} else if (arguments[j] is typeid(бкрат*)) {
			  бкрат* p = ва_арг!(бкрат*)(args);
			  *p = cast(бкрат)n;
			} else if (arguments[j] is typeid(ббайт*)) {
			  ббайт* p = ва_арг!(ббайт*)(args);
			  *p = cast(ббайт)n;
			} else if (arguments[j] is typeid(бдол*)) {
			  бдол* p = ва_арг!(бдол*)(args);
			  *p = cast(бдол)n;
			}
			j++;
			i++;
		  } break;

		case 'f':	// плав
		case 'F':
		case 'e':
		case 'E':
		case 'g':
		case 'G':
		  {
			while (пробел(c)) {
			  c = берис();
			  count++;
			}
			бул neg = false;
			if (c == '-') {
			  neg = true;
			  c = берис();
			  count++;
			} else if (c == '+') {
			  c = берис();
			  count++;
			}
			реал n = 0;
			while (цифра(c) && width) {
			  n = n * 10 + (c - '0');
			  width--;
			  c = берис();
			  count++;
			}
			if (width && c == '.') {
			  width--;
			  c = берис();
			  count++;
			  дво frac = 1;
			  while (цифра(c) && width) {
			n = n * 10 + (c - '0');
			frac *= 10;
			width--;
			c = берис();
			count++;
			  }
			  n /= frac;
			}
			if (width && (c == 'e' || c == 'E')) {
			  width--;
			  c = берис();
			  count++;
			  if (width) {
			бул expneg = false;
			if (c == '-') {
			  expneg = true;
			  width--;
			  c = берис();
			  count++;
			} else if (c == '+') {
			  width--;
			  c = берис();
			  count++;
			}
			реал exp = 0;
			while (цифра(c) && width) {
			  exp = exp * 10 + (c - '0');
			  width--;
			  c = берис();
			  count++;
			}
			if (expneg) {
			  while (exp--)
				n /= 10;
			} else {
			  while (exp--)
				n *= 10;
			}
			  }
			}
			if (neg)
			  n = -n;
			if (arguments[j] is typeid(плав*)) {
			  плав* p = ва_арг!(плав*)(args);
			  *p = n;
			} else if (arguments[j] is typeid(дво*)) {
			  дво* p = ва_арг!(дво*)(args);
			  *p = n;
			} else if (arguments[j] is typeid(реал*)) {
			  реал* p = ва_арг!(реал*)(args);
			  *p = n;
			}
			j++;
			i++;
		  } break;

		case 's': {	// ткст
		  while (пробел(c)) {
			c = берис();
			count++;
		  }
		  ткст s;
		  сим[]* p;
		  т_мера strlen;
		  if (arguments[j] is typeid(сим[]*)) {
			p = ва_арг!(сим[]*)(args);
			s = *p;
		  }
		  while (!пробел(c) && c != сим.init) {
			if (strlen < s.length) {
			  s[strlen] = c;
			} else {
			  s ~= c;
			}
			strlen++;
			c = берис();
			count++;
		  }
		  s = s[0 .. strlen];
		  if (arguments[j] is typeid(сим[]*)) {
			*p = s;
		  } else if (arguments[j] is typeid(сим*)) {
			s ~= 0;
			auto q = ва_арг!(сим*)(args);
			q[0 .. s.length] = s[];
		  } else if (arguments[j] is typeid(шим[]*)) {
			auto q = ва_арг!(шим[]*)(args);
			*q = вЮ16(s);
		  } else if (arguments[j] is typeid(дим[]*)) {
			auto q = ва_арг!(дим[]*)(args);
			*q = вЮ32(s);
		  }
		  j++;
		  i++;
		} break;

		case 'c': {	// симacter(s)
		  сим* s = ва_арг!(сим*)(args);
		  if (width < 0)
			width = 1;
		  else
			while (пробел(c)) {
			c = берис();
			count++;
		  }
		  while (width-- && !кф()) {
			*(s++) = c;
			c = берис();
			count++;
		  }
		  j++;
		  i++;
		} break;

		case 'n': {	// number of симs читай so far
		  цел* p = ва_арг!(цел*)(args);
		  *p = count;
		  j++;
		  i++;
		} break;

		default:	// читай симacter as is
		  goto nws;
		}
		  } else if (пробел(fmt[i])) {	// skip whitespace
		while (пробел(c))
		  c = берис();
		i++;
		  } else {	// читай симacter as is
		  nws:
		if (fmt[i] != c)
		  break;
		c = берис();
		i++;
		  }
		}
		отдайс(c);
		return count;
	  }

	  цел читайф(...) {
		return вчитайф(_arguments, _argptr);
	  }

	  т_мера доступно() { return 0; }

	  abstract т_мера пишиБлок(ук буфер, т_мера размер);

	  проц пишиРовно(ук буфер, т_мера размер) {
	// debug скажинс(std.string.format("вход в пишиРовно: буфер=%s; размер=%s", буфер, размер));
		for(;;) {
		  if (!размер) return;
		  т_мера writesize = пишиБлок(буфер, размер);
		  if (writesize == 0) break;
		  буфер += writesize;
		  размер -= writesize;
		}
		if (размер != 0)
		  throw new Exception("Поток.пишиРовно: Запись в поток невозможна",__FILE__,__LINE__);
	  }

	  // writes the given массив of bytes, returns
	  // actual number of bytes written
	  т_мера пиши(ббайт[] буфер) {
		return пишиБлок(буфер.ptr, буфер.length);
	  }

	  // пиши a single значение of desired type,
	  // throw ИсключениеЗаписи on error
	  проц пиши(байт x) { пишиРовно(&x, x.sizeof); }
	  проц пиши(ббайт x) { пишиРовно(&x, x.sizeof); }
	  проц пиши(крат x) { пишиРовно(&x, x.sizeof); }
	  проц пиши(бкрат x) { пишиРовно(&x, x.sizeof); }
	  проц пиши(цел x) { пишиРовно(&x, x.sizeof); }
	  проц пиши(бцел x) { пишиРовно(&x, x.sizeof); }
	  проц пиши(дол x) { пишиРовно(&x, x.sizeof); }
	  проц пиши(бдол x) { пишиРовно(&x, x.sizeof); }
	  проц пиши(плав x) { пишиРовно(&x, x.sizeof); }
	  проц пиши(дво x) { пишиРовно(&x, x.sizeof); }
	  проц пиши(реал x) { пишиРовно(&x, x.sizeof); }
	  проц пиши(вплав x) { пишиРовно(&x, x.sizeof); }
	  проц пиши(вдво x) { пишиРовно(&x, x.sizeof); }
	  проц пиши(вреал x) { пишиРовно(&x, x.sizeof); }
	  проц пиши(кплав x) { пишиРовно(&x, x.sizeof); }
	  проц пиши(кдво x) { пишиРовно(&x, x.sizeof); }
	  проц пиши(креал x) { пишиРовно(&x, x.sizeof); }
	  проц пиши(сим x) { пишиРовно(&x, x.sizeof); }
	  проц пиши(шим x) { пишиРовно(&x, x.sizeof); }
	  проц пиши(дим x) { пишиРовно(&x, x.sizeof); }

		// writes a ткст, throws ИсключениеЗаписи on error
	  проц пишиТкст(ткст s) {
	  
	 // скажинс(форматируй("направление в пишиРовно из пишиТкст: текст =%s", s));
		пишиРовно(s.ptr, s.length);
	  }

	  // writes a Unicode ткст, throws ИсключениеЗаписи on error
	  проц пишиТкстШ(шткст s) {
		пишиРовно(s.ptr, s.length * шим.sizeof);
	  }
	  
	  // writes a ткст, together with its length
	  проц пиши(ткст s) {
		пиши(s.length);
		пишиТкст(s);
	  }

	  // writes a Unicode ткст, together with its length
	  проц пиши(шткст s) {
		пиши(s.length);
		пишиТкстШ(s);
	  }

	  // writes a строка, throws ИсключениеЗаписи on error
	  проц пишиСтр(ткст s) {
		   пишиТкст(s~"\r\n");
		   //пишиТкст("\n");
	  }

	  // writes a Unicode строка, throws ИсключениеЗаписи on error
	  проц пишиСтрШ(шим[] s) {
		пишиТкстШ(s~"\r\n");
		   //пишиТкстШ("\n");
	  }


	  // writes данные to stream using ввыводф() syntax,
	  // returns number of bytes written
	  т_мера ввыводф(ткст format, спис_ва args) {
		// shamelessly stolen from OutBuffer,
		// by Walter's permission
		сим[1024] буфер;
		сим* p = буфер.ptr;
		auto f = format;
		т_мера psize = буфер.length;
		т_мера count;
		while (true) {
		  version (Win32) {
		count = вснвыводф(p, psize, std.string.toStringz(f), args);
		if (count != -1)
		  break;
		psize *= 2;
		p = cast(сим*) разместа(psize);
		  } else version (Posix) {
		count = вснвыводф(p, psize, f, args);
		if (count == -1)
		  psize *= 2;
		else if (count >= psize)
		  psize = count + 1;
		else
		  break;
		p = cast(сим*) разместа(psize);
		  } else
		  throw new Exception("Неподдерживаемая платформа",__FILE__,__LINE__);
		}
		пишиТкст(p[0 .. count]);
		return count;
	  }

	  // writes данные to stream using выводф() syntax,
	  // returns number of bytes written
	  т_мера выводф(ткст format, ...) {
		спис_ва ap;
		ap = cast(спис_ва) &format;
		ap += format.sizeof;
		return ввыводф(format, ap);
	  }

	  проц doFormatCallback(дим c) { 
		сим[4] буф;
		auto b = вЮ8(буф, c);
		пишиТкст(b);
	  }

	  // writes данные to stream using пишиф() syntax,
	  ПотокВывода пишиф(...) {
		return пишификс(_arguments,_argptr,0);
	  }

	  // writes данные with trailing newline
	  ПотокВывода пишифнс(...) {
		return пишификс(_arguments,_argptr,1);
	  }

	  // writes данные with optional trailing newline
	  ПотокВывода пишификс(ИнфОТипе[] arguments, ук argptr, цел newline=0) {
		doFormat(&doFormatCallback,arguments,argptr);
		if (newline) 
		  пишиСтр("");
		return this;
	  }

	  /***
	   * Copies all данные from s целo this stream.
	   * This may throw ИсключениеЧтения or ИсключениеЗаписи on failure.
	   * This restores the файл позиция of s so that it is unchanged.
	   */
	  проц копируй_из(Поток s) {
		if (сканируем) {
		  бдол pos = s.позиция();
		  s.позиция(0);
		  копируй_из(s, s.размер());
		  s.позиция(pos);
		} else {
		  ббайт[128] буф;
		  while (!s.кф()) {
		т_мера m = s.читайБлок(буф.ptr, буф.length);
		пишиРовно(буф.ptr, m);
		  }
		}
	  }

	  /***
	   * Copy a specified number of bytes from the given stream целo this one.
	   * This may throw ИсключениеЧтения or ИсключениеЗаписи on failure.
	   * Unlike the previous form, this doesn't restore the файл позиция of s.
	   */
	  проц копируй_из(Поток s, бдол count) {
		ббайт[128] буф;
		while (count > 0) {
		  т_мера n = cast(т_мера)(count<буф.length ? count : буф.length);
		  s.читайРовно(буф.ptr, n);
		  пишиРовно(буф.ptr, n);
		  count -= n;
		}
	  }

	  /***
	   * Change the current позиция of the stream. whence is either ППозКурсора.Уст, in
	   which case the offset is an absolute index from the beginning of the stream,
	   ППозКурсора.Тек, in which case the offset is a delta from the current
	   позиция, or ППозКурсора.Кон, in which case the offset is a delta from the end of
	   the stream (negative or zero offsets only make sense in that case). This
	   returns the new файл позиция.
	   */
	  abstract бдол сместись(дол offset, ППозКурсора whence);

	  /***
	   * Aliases for their normal сместись counterparts.
	   */
	  бдол измпозУст(дол offset) { return сместись (offset, ППозКурсора.Уст); }
	  бдол измпозТек(дол offset) { return сместись (offset, ППозКурсора.Тек); }	/// описано ранее
	  бдол измпозКон(дол offset) { return сместись (offset, ППозКурсора.Кон); }	/// описано ранее

	  /***
	   * Sets файл позиция. Эквивалентно to calling сместись(pos, ППозКурсора.Уст).
	   */
	  проц позиция(бдол pos) { сместись(cast(дол)pos, ППозКурсора.Уст); }

	  /***
	   * Returns current файл позиция. Эквивалентно to сместись(0, ППозКурсора.Тек).
	   */
	  бдол позиция() { return сместись(0, ППозКурсора.Тек); }

	  /***
	   * Retrieve the размер of the stream in bytes.
	   * The stream must be сканируем or a ИсключениеПеремещения is thrown.
	   */
	  бдол размер() {
		проверьСканируемость();
		бдол pos = позиция(), результат = сместись(0, ППозКурсора.Кон);
		позиция(pos);
		return результат;
	  }

	  // returns true if end of stream is reached, false otherwise
	  бул кф() { 
		// for unсканируемый streams we only know the end when we читай it
		if (читайдоКФ && !верниЧтоЕсть())
		  return true;
		else if (сканируем)
		  return позиция() == размер(); 
		else
		  return false;
	  }

	  // returns true if the stream is open
	  бул открыт_ли() { return открыт; }

	  // слей the буфер if записываем
	  проц слей() {
		if (возврат.length > 1)
		  возврат.length = 1; // keep at least 1 so that данные ptr stays
	  }

	  // закрой the stream somehow; the default just flushes the буфер
	  проц закрой() {
		if (открыт)
		  слей();
		читатьдоКФ(false); возвратКаретки(false);открытый(false);читаемый(false);
		записываемый(false);сканируемый(false);
	  }

	 проц удали (ткст имяф)
	  {if(открытый())закрой();
	  if(!естьФайл(имяф))
		{
		консоль(std.string.format("\n\tИНФО:  Файл %s удалён ранее или вовсе не существовал", имяф)); return ;
		}
	  else if(!УдалиФайл(вЮ16(имяф)))
	  консоль(std.string.format("\n\tИНФО:  Файл %s остался не удалёным", имяф));
	  консоль(std.string.format("\n\tИНФО:  Файл %s успешно удалён", имяф));}
	   
	   
	  override ткст toString() {
		return вТкст();
	  }
	  
	ткст вТкст()
	{
	if (!читаемый())
		  return super.toString();
		т_мера pos;
		т_мера rdlen;
		т_мера blockSize;
		ткст результат;
		if (сканируемый()) {
		  бдол orig_pos = позиция();
		  позиция(0);
		  blockSize = cast(т_мера)размер();
		  результат = new сим[blockSize];
		  while (blockSize > 0) {
		rdlen = читайБлок(&результат[pos], blockSize);
		pos += rdlen;
		blockSize -= rdlen;
		  }
		  позиция(orig_pos);
		} else {
		  blockSize = 4096;
		  результат = new сим[blockSize];
		  while ((rdlen = читайБлок(&результат[pos], blockSize)) > 0) {
		pos += rdlen;
		blockSize += rdlen;
		результат.length = результат.length + blockSize;
		  }
		}
		return результат[0 .. pos];
	  }

	  /***
	   * Get a hash of the stream by reading each байт and using it in a CRC-32
	   * checksum.
	   */
	  override т_мера toHash()
	  {
	  return  вХэш();
	  }    
	  
	т_мера вХэш()
	{
	if (!читаем || !сканируем)
		  return super.toHash();
		бдол pos = позиция();
		бцел crc = иницЦПИ32();
		позиция(0);
		бдол длин = размер();
		for (бдол i = 0; i < длин; i++) {
		  ббайт c;
		  читай(c);
		  crc = обновиЦПИ32(c, crc);
		}
		позиция(pos);
		return crc;
	  }

	  // helper for checking that the stream is читаем
	  бул проверьЧитаемость(ткст имяПотока = ткст.init,ткст файл = ткст.init, дол  строка = дол.init) {
		if (!читаем){
		  throw new Exception(имяПотока~" : поток не читаем!",файл, строка);}
		  return true;
	  }
	  // helper for checking that the stream is записываем
	  бул проверьЗаписываемость(ткст имяПотока = ткст.init,ткст файл = ткст.init, дол  строка = дол.init) {
		if (!записываем){
		  throw new Exception(имяПотока~": поток не записываем!",файл,строка);}
		  return true;
	  }
	  // helper for checking that the stream is сканируем
	  бул проверьСканируемость(ткст имяПотока = ткст.init,ткст файл = ткст.init, дол  строка = дол.init) {
		if (!сканируем){
		  throw new Exception(имяПотока~": поток не сканируем",файл,строка);}
		  return true;
	  }
	}

private 
{
	// список уже загруженных звуковых файлов
	ЗвукоФайл[ткст] списокЗвукоФайлов;
	
	// включен ли звук
	бул звукВкл = true;
	
	// был ли правильно инициализован звук
	бул звукИнициализован = false;
	
	// Аудио
	ALCdevice	*устройство_ал;
	ALCcontext	*контекст_ал;
	
	// список всех звуков
	Звук[] аудиоСписок;
	
bool обработайНедостающийОпенАЛ(char[] libname, char[] procName)
    {
       /// OpenAL stuff not required by arclib
       if(procName.cmp("aluF2L") == 0)
          return true; 

       if(procName.cmp("aluF2S") == 0)
          return true; 

       if(procName.cmp("aluCrossproduct") == 0)
          return true; 

       if(procName.cmp("aluDotproduct") == 0)
          return true; 

       if(procName.cmp("aluNormalize") == 0)
          return true; 

       if(procName.cmp("aluMatrixVector") == 0)
          return true; 

       if(procName.cmp("aluCalculateSourceParameters") == 0)
          return true; 

       if(procName.cmp("aluMixData") == 0)
          return true; 

       if(procName.cmp("aluSetReverb") == 0)
          return true; 

       if(procName.cmp("aluReverb") == 0)
          return true; 
    }
	
void выгрузиDerelict()
    {
		DerelictAL.unload(); 
		//DerelictALU.unload();
		DerelictOgg.unload(); 
		DerelictVorbis.unload(); 
		DerelictVorbisFile.unload();
    }
}

alias SDL_Surface Поверхность;
alias arc.internals.input.constants.KeyStatus СостояниеКлавиши;
alias плав Радианы;
alias плав Градусы;
const плав ДВАПИ = PI*2;


export extern (D) class УзелРЯР
{

	ткст _имя;
    ткст[ткст] _атры;
    УзелРЯР[]      _ветви;
    static RegExp  _атрРв;
    static RegExp  _атрСплитРв;
	
export:

    static this()
	{
	_атрРв = new RegExp("([a-z0-9]+)\\s*=\\s*\"([^\"^<^>^%]+)\"\\s*", "gim");
    _атрСплитРв = new RegExp("\"|=\"", "");   
	}

	this() {}
	
    this(ткст имя)
	{
	_имя = имя;
    }
 
    ткст дайИмя()
    {
        return _имя;
    }

    проц устИмя(ткст новИмя)
    {
        _имя = новИмя;
    }

    бул естьАтрибут(ткст имя)
    {
        return  (имя in _атры)!is null;
    }
 
    ткст получиАтрибут(ткст имя)
    {
        if (имя in _атры)
            return _атры[имя];
        else
            return null;
    }

    ткст[ткст] получиАттрибуты()
    {	
	return  _атры;
    }

    УзелРЯР устАтрибут(ткст имя, ткст знач)
    {
        _атры[имя] = знач;
        return this;
    }
 
    УзелРЯР устАтрибут(ткст имя, цел знач)
    {
        return устАтрибут(имя, std.string.toString(знач));
    }

    УзелРЯР[] дайВетви()
    {
        return _ветви; 
    }

    УзелРЯР добавьВетвь(УзелРЯР новУзел)
    {
       _ветви ~= новУзел;
        return this;
    }

    УзелРЯР добавьСДанные(ткст сданн)
    {
         добавьВетвь(new СДанные(сданн));
        return this;
    }

    бул сДанн_ли(){return false; }
 
	ткст дайСДанные(){return ""; }

    бул лист_ли(){return _ветви.length == 0; }

    проц пиши(Поток приём)
    {
        пиши(приём, 0);
    }

    проц читай(Поток исток)
    {        
        ПотокРЯР xmlпоток = new ПотокРЯР(исток);
        читай(xmlпоток);
        delete xmlпоток;      
    }
	
private:
    ткст ОткрытымТегом()
    {
        ткст s = "<" ~ _имя;

        if (_атры.length > 0)
        {
            ткст[] k = _атры.keys;
            ткст[] v = _атры.values;

            for (int i = 0; i < _атры.length; i++)
            {
                s ~= " " ~ k[i] ~ "=\"" ~ v[i] ~ "\"";
            }
        }

        if (_ветви.length == 0)
            s ~= " /"; // We want <blah /> if the node has no children.
        s ~= ">";

        return s;
    }

    ткст ЗакрытымТегом()
    {
        if (_ветви.length != 0)
            return "</" ~ _имя ~ ">";
        else
            return ""; // don't need it.  Leaves close themselves via the <blah /> syntax.
    }

protected:
	/// write
    void пиши(Поток приём, цел урИндент)
    {
        ткст pad = new сим[урИндент];
        pad[] = ' ';
        приём.пишиТкст(pad);
        приём.пишиСтр(ОткрытымТегом());

        if (_ветви.length)
        {
            for (цел i = 0; i < _ветви.length; i++)
            {
                _ветви[i].пиши(приём, урИндент + 4); // TODO: make the indentation level configurable.
            }
            приём.пишиТкст(pad);
            приём.пишиСтр(ЗакрытымТегом());
        }
    }

	/// parse node
    static УзелРЯР parseNode(УзелРЯР parent, ткст tok, ПотокРЯР src)
    {
        ткст[] parseAttributes(ткст tag)
        {
            ткст[] result;

            цел pos = std.string.find(tag, cast(char)' ');
            if (pos == -1) return result;

            char[][] matches = _атрРв.сверь(tag[pos..tag.length]);
            for (цел i = 0; i < matches.length; i++)
            {
                // cheap hack.
                ткст[] blah = _атрСплитРв.разбей(matches[i]);
                result ~= blah[0];
                result ~= blah[1];
            }

            return result;
        }

        УзелРЯР newNode = null;

        цел pos = 2;
        while (pos < tok.length && tok[pos] != ' ' && tok[pos] != '/' && tok[pos] != '>')
            pos++;   // stop at a space, a slash, or the end bracket.

        if (isLetter(tok[1]))
        {
            newNode = new УзелРЯР(tok[1 .. pos]); // new node
            if (parent !is null)
                parent.добавьВетвь(newNode);

            // parse attributes
            char[][] attribs = parseAttributes(tok);

            for (цел i = 0; i < attribs.length; i += 2)
                newNode.устАтрибут(attribs[i], attribs[i + 1]);

            if (tok[tok.length - 2] != '/')     // matched tag
                newNode.читай(src);
        }
        else
            // Invalid tag имя
            throw new ОшибкаРЯР(src.номерСтроки(), "Tags cannot start with " ~ tok);

        return newNode;
    }

	/// read 
    проц читай(ПотокРЯР src)
    {
        while (true)
        {
            ткст tok = src.читайУзел();

            if (tok[0] == '<')
            {
                if (tok[1] != '/')
                    parseNode(this, tok, src);
                else
                {
                    if (tok[2 .. _имя.length + 2] != _имя)
                        throw new ОшибкаРЯР(src.номерСтроки(), "</" ~ _имя ~ "> or opening tag expected.  Got " ~ tok);
                    else
                    {
                        break;
                    }
                }

            }
            else
            {
                добавьСДанные(std.string.strip(tok));
            }
        }
    }

}


export extern (D) class СДанные : УзелРЯР
{
   ткст _сданн;
   
export:
	this(ткст сданн)
	{
		_сданн = decodeSpecialChars(сданн);
	}

	бит сданн_ли(){return true; }
	ткст дайСДанные(){return _сданн; }

	override проц пиши(Поток приём, цел уровИндент)
	{
		ткст pad = new сим[уровИндент];
		pad[] = ' ';
		приём.пишиТкст(pad);
		приём.пишиСтр(encodeSpecialChars(_сданн));
	}
}

export extern (D) class ПотокРЯР
{
    Поток _поток;
    цел _curLine;

export:
	/// init
	this(Поток s)
	{
		_поток = s;
		_curLine = 0;
	}

	/// getchar
	сим берис()
	{
		сим c = _поток.берис();
		if (c == '\n') _curLine++;
		return c;
	}

	/// unget сим
	сим отдайс(сим c)
	{
		if (c == '\n') _curLine--;
		_поток.отдайс(c);
		return c;
	}

	/// read string
	сим[] читайСтр(бцел count)
	{
		сим[] result = new сим[count];
		цел i;
		try
		{
			for (i = 0; i < count; i++)
				result[i] = берис();
			return result;
		}
		catch
		{
			return result[0 .. i];
		}
	}

	/// unread string
	проц отдайСтр(ткст str)
	{
		for (цел i = str.length - 1; i >= 0; i--)
			отдайс(str[i]);
	}

	/// eat white space
	проц съешьПробел()
	{
		сим ch = берис();
		while (std.string.find(whitespace, ch) != -1)
			ch = берис();
		отдайс(ch);

		// Now to eat comments. (may as well make it as transparent as possible)
		ткст str = читайСтр(4);
		if (str == "<!--")
		{
			ткст last = "   ";
			do
			{
				сим c = берис();
				last = last[1..3];
				last ~= c;
				if (_поток.кф())
					throw new ОшибкаРЯР(номерСтроки(), "Unexpected end of file while parsing comment.");
			} while (last != "-->");

			съешьПробел();
		}
		else
		{
			отдайСтр(str);
		}
	}

	private ткст получиСлово()
	{
		ткст token;

		try
		{
			съешьПробел();
			сим ch = берис();
			if (isTokenChar(ch))
			{
				while (isTokenChar(ch)) // grab all alphanumeric characters until we hit nonalphanumeric
				{
					token ~= ch;
					ch = берис();
				}
				отдайс(ch);
			}
			else
				token ~= ch;

			return token;
		}
		catch
		{
			throw new ОшибкаРЯР(номерСтроки(), "Unexpected end of file");
		}
	}

	/// expect
	проц предполагай(ткст слово)
	{
		съешьПробел();
		ткст s;
		for (цел i = 0; i < слово.length; i++)
		{
			сим ch = берис();
			s ~= ch;
			if (ch != слово[i])
				throw new ОшибкаРЯР(номерСтроки(), "Expected: \"" ~ слово ~ "\".  Got: \"" ~ s ~ "\"");
		}
	}

	/// read until
	ткст читай_до(сим конец)
	{
		ткст s;
		сим ch = берис();
		while (ch != конец)
		{
			s ~= ch;
			ch = берис();
			if (_поток.кф())
				throw new ОшибкаРЯР(номерСтроки(), "Unexpected конец of file");
		}
		отдайс(ch); // put it back

		return s;
	}

	/// read node
	ткст читайУзел()
	{
		съешьПробел();
		сим ch = берис();

		if (ch == '<')                                 // data node
		{
			ткст nodeName = получиСлово();
			if (nodeName == "/")                        // closing tag
			{
				nodeName = получиСлово();
				предполагай(">");
				return "</" ~ nodeName ~ ">";
			}
			else
			{
				ткст attribs = strip(читай_до('>'));
				предполагай(">");
				return "<" ~ nodeName ~ " " ~ attribs ~ ">";
			}
		}
		else                                            // cdata
		{
			отдайс(ch);
			return читай_до('<');
		}
	}

	/// line number 
	цел номерСтроки() { return _curLine; }
}

export extern (D) class ОшибкаРЯР : Исключение
{
export:
    this(бцел номСтр, ткст что)
    {
        super("(" ~ std.string.toString(номСтр) ~ ")" ~ что);
    }
}

export УзелРЯР новУзел(ткст  имя)
{	return new УзелРЯР(имя);
}

export УзелРЯР читайДокумент(Поток истк)
{
	ПотокРЯР поток = new ПотокРЯР(истк);


	ткст слово = поток.читайУзел();
	if (слово.length >= 9 && слово[0 .. 9] == "<!DOCTYPE")
	{
		// TODO: actually do something with the DOCTYPE
		слово = поток.читайУзел();
	}

	УзелРЯР node = УзелРЯР.parseNode(null, слово, поток);

	delete поток;
	return node;
}


export extern (D) class Мигун 
{
  export:
   bool   вкл = false;
   double последнееВремя = 0, текВремя = 0;
   double всегосек = 0.0f; 
   
   this()
   {
      последнееВремя = SDL_GetTicks();
      текВремя = SDL_GetTicks()+.01; // make sure current starts out bigger than последнееВремя
   }

   static Мигун opCall(){return new Мигун();}
	/// blinker is on every # of seconds
   проц обработай(плав секунды)
   {
      последнееВремя = текВремя; // last время equals what curr время was
      текВремя = SDL_GetTicks(); // update curr время to the current время
   
      плав seconds = текВремя - последнееВремя;
      seconds /= 1000;
      
      всегосек += seconds; 
      
      вкл = false; 
      
      if(всегосек > секунды ) // if всегосек has elapsed since the last время
      {
         вкл = true; 
         всегосек = 0; 
      }
   }
}

export extern (D) struct Цвет
{
export:
	static Цвет opCall(T)(T к, T з, T с, T а = ЗначениеЦветаПоУмолчанию!(T))
	{
		Цвет ц;
		
		static if(is(T : ббайт))
		{
			ц.к = к / 255.;
			ц.з = з / 255.;
			ц.с = с / 255.;
			ц.а = а / 255.;
		}
		else static if(is(T : плав))
		{
			ц.к = к;
			ц.з = з;
			ц.с = с;
			ц.а = а;
		}
		else
			static assert(false, "Colors can only be constructed from values implicitly convertible to ubyte or float.");
		
		return ц;
	}
	
	/// predefined white color
	const static Цвет Белый = {1.,1.,1.};
	/// predefined black color
	const static Цвет Чёрный = {0.,0.,0.};
	/// predefined red color
	const static Цвет Красный = {1.,0.,0.};
	/// predefined green color
	const static Цвет Зелёный = {0.,1.,0.};
	/// predefined blue color
	const static Цвет Синий = {0.,0.,1.};
	/// predefined yellow color
	const static Цвет Жёлтый = {1.,1.,0.};

	/// дай Red value
	плав дайК() {return к;}
	
	/// дай Green value
	плав дайЗ() {return з;}
	
	/// дай Blue value 
	плав дайС() {return с;}
	
	/// установи Alpha value
	плав дайА() {return а;}
	
	arc.draw.color.Color изЦвета()
		{
		Color col;
		col.setR(this.дайК);
		col.setG(this.дайЗ);
		col.setB(this.дайС);
		col.setA(this.дайА);
		
		return col;
		}
		

	/// установи Red value
	проц устК(плав аргЗн) {к = аргЗн;}
	
	/// установи Green value
	проц устЗ(плав аргЗн) {з = аргЗн;}
	
	/// установи Blue value 
	проц устС(плав аргЗн) {с = аргЗн;}
	
	/// установи Alpha value
	проц устА(плав аргЗн) {а = аргЗн;}
	
	/// performs the OpenGL вызови required to установи а color
	проц установиЦвет()
	{
		glColor4f(к, з, с, а);
	}
	
	плав ячейка(цел индекс)
	{
		switch(индекс)
		{
			case 0:
				return к;
				break; 
			case 1:
				return з;
				break; 
			case 2:
				return с;
				break; 
			case 3:
				return а;
				break; 
			default:
				assert(false, "Error: parameter of Color.cell must be in 0..3, but was " ~ .toString(индекс)); 
		}
	}
	
	плав к=1.0, з=1.0, с=1.0, а=1.0;
	
private:
	// see the constructor for details
	template ЗначениеЦветаПоУмолчанию(T)
	{
		static if(is(T : ббайт))
			const T ЗначениеЦветаПоУмолчанию = 255;
		else static if(is(T : плав))
			const T ЗначениеЦветаПоУмолчанию = 1.;
		else
			const T ЗначениеЦветаПоУмолчанию = T.init;
	}
	
}

export extern (D)
{
	проц увеличьСчётТекстур(бцел ув){arc.texture.incrementTextureCount(ув);}
	бцел присвойИдТекстуре(){return arc.texture.assignTextureID();}
	Текстура загрузи_текстуру(ткст имяф){return  new Текстура(имяф);}
	
	проц активируйТекстуринг(Текстура текс)
		{
		glEnable(GL_TEXTURE_2D);
		glBindTexture(GL_TEXTURE_2D, текс.дайИд);
		}
		
	проц обнови_текстуру(inout Текстура текс, Точка начКоорд, Размер размер, ббайт[] данные) 
	{
	glEnable(GL_TEXTURE_2D);
	glBindTexture(GL_TEXTURE_2D, текс.дайИд);
	
	const цел уровень = 0;
	glTexSubImage2D(GL_TEXTURE_2D, уровень, cast(цел)начКоорд.x, cast(цел)начКоорд.y, cast(цел)размер.w, cast(цел)размер.h, GL_RGBA, GL_UNSIGNED_BYTE, данные.ptr);
	
	glDisable(GL_TEXTURE_2D);
	}

}

export extern (D) class Текстура
{
export:
Texture tex_;

	this(ткст имяфтекст)
		{
		this.tex_ = arc.texture.Texture(имяфтекст);
		}
	
	this(Размер размер, Цвет цв)
		{
		this.tex_ = arc.texture.Texture(изРазмера(размер),  цв.изЦвета());
		}
		
	this()
		{
		this.tex_ = arc.texture.Texture();
		}
		
	Размер дайРазмер(){return вРазмер(this.tex_.getSize());}
	
	Размер дайРазмерТекстуры(){return вРазмер(this.tex_.getTextureSize());}
	
	бцел дайИд(){return this.tex_.getID();}
	ткст дайФайл(){return  this.tex_.getFile();}
	Texture изТекстуры(){return this.tex_;}

}

export extern (D) struct Литера
{
export:
	Точка[2] тексКоордд;
	Текстура текстура;
	Размер размер;
	Точка смещение;
	Точка шаг;
	бцел индексШ;
}


enum  FontAntialiasing
{
None,
Grayscale,
LCD_RGB,
LCD_BGR,
Нет = None,
Серое = Grayscale,
ЖКМ_КЗС = LCD_RGB,
ЖКМ_СЗК = LCD_BGR
}
alias FontAntialiasing СглаживаниеШрифта;

enum  BlendingMode
{
Alpha,
Subpixel,
None,
Альфа = Alpha,
Подпиксельное = Subpixel,
Нет = None
}
alias BlendingMode РежимСмешивания;

enum  LCDFilter
{
Standard,
Crisp,
None,
Стандартный = Standard,	// this is standard FreeType's subpixel filter. Basically, а triangular kernel
Крисп = Crisp,		// this one is а compromise between the default lcd filter, no filter and non-lcd aliased renderings
Нет =None		// doesn't do any subpixel filtering, will result in massive color fringes
}
alias LCDFilter ЖКМФильтр;

import arc.text.format: fm = formatString;
export extern (D) class Шрифт
{
export:
private arc.font.Font font_;

	this(ткст путькШ, цел размер)
		{
		this.font_= new Font(cast(char[]) путькШ, размер);
		}
		
	static Шрифт opCall(ткст путькШ, цел размер){return new Шрифт(путькШ, размер);}
		
	плав дайШиринуПоследнейСтроки(сим[] ткт)
		{		
		return this.font_.getWidthLastLine(ткт);
		}
	
	плав дайШирину(сим[] ткт){	return this.font_.getWidth(ткт);}
	
	проц рисуй(ткст[] строки, Точка положение, Цвет цвет)
		{
		this.font_.draw(строки, изТочки(положение), цвет.изЦвета);
		}
		
	проц рисуй(шим[][] строки, Точка положение, Цвет цвет)
		{
		this.font_.draw(cast(dchar[][]) строки, изТочки(положение), цвет.изЦвета);
		}
	
	проц рисуй(сим[] ткт, Точка положение, Цвет цвет)
		{
		this.font_.draw(ткт, изТочки(положение), цвет.изЦвета);
		}
		
	проц рисуй(дим[] стр, Точка положение, Цвет цвет)
		{
		this.font_.draw(cast(dchar[]) стр, изТочки(положение), цвет.изЦвета);
		}
		
	цел дайВысоту(){return this.font_.getHeight();}
	
	цел дайПропускСтрок(){return this.font_.getLineSkip();}
	
	проц устЗазорСтроки(плав фракц){ this.font_.setLineGap(фракц);}
	
	бул жкмФильтр(ЖКМФильтр f){return this.font_.lcdFilter(cast(arc.font.LCDFilter) f);}
	
	цел вычислиИндекс(сим[] ткт, Точка позткта, Точка позмыши)
		{
		//ткст ткт = cast(char[]) fm(_arguments, _argptr);
		return this.font_.calculateIndex( ткт, изТочки(позткта), изТочки(позмыши));}
		
	цел ищиИндекс(сим[] ткт, цел мышьШ, цел позШ, цел лево, цел право)
		{
		//ткст ткт = cast(char[]) fm(_arguments, _argptr);
		return this.font_.searchIndex( ткт, мышьШ, позШ, лево, право);
		}

}


export extern (D) struct Прямоуг
{
export:

	Точка левВерх;
	Размер размер;
	
	/// 'constructor'
	static Прямоуг opCall(плав x, плав y, плав w, плав h)
	{
		Прямоуг к;
		к.левВерх = Точка(x,y);
		к.размер = Размер(w, h);
		return к;
	}
	
	/// 'constructor'
	static Прямоуг opCall(Точка левВерх_, Размер размер_)
	{
		Прямоуг к;
		к.левВерх = левВерх_;
		к.размер = размер_;
		return к;
	}
	
	/// 'constructor'
	static Прямоуг opCall(Размер размер_)
	{
		Прямоуг к;
		к.размер = размер_;
		return к;
	}
	
	/// 'constructor'
	static Прямоуг opCall(плав w, плав h)
	{
		Прямоуг к;
		к.размер = Размер(w, h);
		return к;
	}
	
	/// bottom right getter
	Точка дайПравыйНиз()
	{
		return левВерх + размер;
	}

	/// top getter	
	плав дайВерх()
	{
		return левВерх.y;
	}
	
	/// left getter
	плав дайЛевый()
	{
		return левВерх.x;
	}
	
	/// bottom
	плав дайНиз()
	{
		return левВерх.y + размер.h;
	}
	
	/// right
	плав дайПравый()
	{
		return левВерх.x + размер.w;
	}
	
	///
	Точка дайПозицию() { return левВерх; }
	
	///
	Размер дайРазмер() { return размер; } 
	
	/// moves Прямоуг without altering размер
	Прямоуг перемести(inout Точка by)
	{
		левВерх += by;
		return *this;
	}
	
	/***
		tests if а point is contained in Прямоуг.
		the Прямоуг is considered closed.
	*/
	бул содержит(inout Точка p)
	{
		return (p.x >= левВерх.x && p.y >= левВерх.y && p.x < левВерх.x + размер.w && p.y < левВерх.y + размер.h);
	}
	
	/// tests if two Прямоугs целersect. both are closed
	бул пересекается_с(inout Прямоуг к)
	{
		if(к.левВерх.x >= левВерх.x + размер.w)
			return false;
		if(к.левВерх.y >= левВерх.y + размер.h)
			return false;
		if(к.левВерх.x + к.размер.w <= левВерх.x)
			return false;
		if(к.левВерх.y + к.размер.h <= левВерх.y)
			return false;
		
		return true;
	}
}


export extern (D) struct Матрица
{
export:
	/*** constructs а rotation Матрица
	   (i.e. p = A*p will be rotated by angle counterclockwise)
	*/
	static Матрица opCall(Радианы угол)
	{
		Матрица m; 
		
		плав ц = std.math.cos(угол), s = std.math.sin(угол);
		m.col1.x = ц; m.col2.x = -s;
		m.col1.y = s; m.col2.y = ц;

		return m; 
	}

	/// construct Матрица from column vectors
	static Матрица opCall(Точка col1, Точка col2)
	{
		Матрица m; 
		
		m.col1 = col1; 
		m.col2 = col2; 

		return m; 
	}
	
	/// convert Матрица to а string
	сим[] вТкст()
	{
		return "(" ~ std.string.toString(col1.x) ~ ", " ~ std.string.toString(col2.x)
				~ "\n" ~ std.string.toString(col1.y) ~ ", " ~ std.string.toString(col2.y) ~ ")";
	}
	
	/// compute determinant
	плав детерминанта()
	{
		return col1.x * col2.y - col1.y * col2.x;
	}

	/// Матрица transpose in-place
	Матрица перенос()
	{
		переставь(col1.y, col2.x);
		
		return *this;
	}
	
	/// Матрица transpose copy
	Матрица переносКопии()
	{
		return Матрица(Точка(col1.x, col2.x), Точка(col1.y, col2.y));
	}

	/// Матрица invert in-place
	Матрица инвертируй()
	{
		плав det = детерминанта();
		assert(det != 0.0f, std.string.format("Не удаётся инвертировать Матрицу с детерминантой = 0"));		
		det = 1.0f / det;
		
		переставь(col1.x, col2.y);
		col1.x *= det;
		col2.y *= det;
		col2.x *= -det;
		col1.y *= -det;
		
		return *this;
	}
	
	/// Матрица invert copy
	Матрица инвертируйКопию()
	{
		Матрица B = *this;
		return B.инвертируй();
	}
	
	/// make abs component wise
	Матрица абс()
	{
		col1.абс();
		col2.абс();
		return *this;
	}

	/// abs copy
	Матрица абсКопии()
	{
		Матрица ret = *this;
		ret.абс();
		return ret;
	}
	
	/// Матрица-Матрица addition
	Матрица opAdd(inout Матрица B)
	{
		return Матрица(col1 + B.col1, col2 + B.col2);
	}

	/// Матрица-Матрица product
	Матрица opMul(inout Матрица M)
	{
		Матрица T;

		T.col1.x = col1.x * M.col1.x + col2.x * M.col1.y;
		T.col1.y = col1.y * M.col1.x + col2.y * M.col1.y;

		T.col2.x = col1.x * M.col2.x + col2.x * M.col2.y;
		T.col2.y = col1.y * M.col2.x + col2.y * M.col2.y;
		
		return T;
	}
	
	/// Матрица-vector product
	Точка opMul(inout Точка p)
	{
		Точка result = Точка(col1.x * p.x + col2.x * p.y, col1.y * p.x + col2.y * p.y);
		return result;
	}

	Точка col1, col2;
}

///////////////////////////////////конец
export extern (D) struct Точка
{
export:
	static Точка NanNan = {плав.nan, плав.nan};
	
	плав x=0;
	плав y=0;

	/// Точка 'constructor' from carthesian coordinates
	static Точка opCall(плав Ix, плав Iy)
	{
		Точка v;
		v.x = Ix;
		v.y = Iy;
		return v;
	}

	/*** unfortunately, making this an opCall makes Точка(1,1) ambigious...
	     Точка 'constructor' from polar coordinates
	*/
	static Точка изПоляра(плав длина, Радианы угол)
	{
		Точка v;
		v.x = длина * std.math.cos(угол);
		v.y = длина * std.math.sin(угол);
		return v;
	}
	
	/// construct а vector that's rotated by 90 deg ccw
	static Точка перепендикулярно(inout Точка p)
	{
		Точка v;
		v.y = p.x;
		v.x = - p.y;
		return v;
	}
	
	/// convenient setter
	проц уст(плав x_, плав y_) { x = x_; y = y_; }
	
	/// getter for угол (Радианы) in polar coordinates
	Радианы угол() { return cast(Радианы) std.math.atan2(y, x); }
	
	/// returns длина of vector
	плав длина() { return cast(плав) std.math.sqrt(x*x + y*y); }
	
	/// convert point to string value
	сим[] вТкст()
	{
		return "X - " ~ std.string.toString(x) ~ ", Y - " ~ std.string.toString(y);
	}

	/// returns largest component
	плав максСоставляющая()
	{
		if (x > y)
			return x;
		return y;
	}

	/// returns smallest component
	плав минСоставляющая()
	{
		if (x < y)
			return x;
		return y;
	}

	// Размер operators 
	// add размер to point 
	Точка opAdd(Размер размер) 
	{
		return Точка(x + размер.w, y + размер.h); 
	}
	
	// subtract размер from point, return point
	Точка opSub(Размер размер) 
	{
		return Точка(x - размер.w, y - размер.h); 
	}
	
	// scalar addition
	Точка opAdd(плав V) { return Точка(x+V, y+V); }
	Точка opSub(плав V) { return Точка(x-V, y-V); }
	Точка opAddAssign(плав V) { x += V; y += V; return *this; }
	Точка opSubAssign(плав V) { x -= V; y -= V; return *this; }
	
	// scalar multiplication
	Точка opMulAssign(плав s) { x *= s; y *= s; return *this; }
	Точка opMul(плав s) { return Точка(x*s, y*s); }
	Точка opDivAssign(плав s) { x /= s; y /= s; return *this; }
	Точка opDiv(плав s) { return Точка(x/s, y/s); }

	// vector addition
	Точка opAddAssign(inout Точка Другой) { x += Другой.x; y += Другой.y; return *this; }
	Точка opAdd(inout Точка V) { return Точка(x+V.x, y+V.y); }
	Точка opSubAssign(inout Точка Другой) { x -= Другой.x;	y -= Другой.y; return *this; }
	Точка opSub(inout Точка V) { return Точка(x-V.x, y-V.y); }

	/// negation
	Точка opNeg() { return Точка(-x, -y); }

	/// cross product
	плав кросс(inout Точка V) { return (x * V.y) - (y * V.x); }

	/// dot product
	плав тчк(inout Точка V) { return (x*V.x) + (y*V.y); }
	
	/// scaling product
	Точка масштаб(плав by) { *this *= by; return *this; }
	Точка масштаб(inout Точка by) { x *= by.x; y *= by.y; return *this; }
	
	/// apply Матрица from left side without а copy
	Точка применить(inout Матрица M)
	{
		плав tx = x;
		x = M.col1.x * x + M.col2.x * y;
		y = M.col1.y * tx + M.col2.y * y;
		
		return *this;
	}

	/// return the длина squared
	плав квадратДлины()
	{
		return x*x + y*y;
	}
	
	/// normalises and returns original длина
	плав нормализуй()
	{
		плав fдлина = длина();
		
		if(fдлина == 0.0f)
			return 0.0f;
		
		(*this) *= (1.0f / fдлина);
	
		return fдлина;
	}

	/// return normalised copy of this
	Точка нормализуйКопию()
	{
		Точка p = *this;
		p.нормализуй();
		return p;
	}

	/// угол to Другой vector
	Радианы угол(inout Точка xE)
	{
		плав dot = (*this).тчк(xE);
		плав cross = (*this).кросс(xE);
		
		// угол between segments
		return cast(Радианы) std.math.atan2(cross, dot);
	}

	/// rotates vector by угол
	Точка поверни(Радианы уголRad)
	{
		плав tx = x;
		
		x = x*std.math.cos(уголRad) - y*std.math.sin(уголRad);
		y = tx*std.math.sin(уголRad) + y*std.math.cos(уголRad);
		
		return *this;
	}

	/// rotate the vector around а center point
	Точка поверни(inout Точка центр, Радианы уголRad)
	{
		Точка D = *this - центр;
		D.поверни(уголRad);
		*this = центр + D;

		return *this;
	}

	/// make components positive
	Точка абс()
	{
		x = std.math.fabs(x);
		y = std.math.fabs(y);
		return *this;
	}
	
	/// абс copy
	Точка абсКопии()
	{
		Точка ret = *this;
		ret.абс();
		return ret;
	}
	
	/// clamp а vector to min and max values
	проц прикрепи(inout Точка мин, inout Точка макс)
	{
		x = (x < мин.x)? мин.x : ((x > макс.x)? макс.x : x);
		y = (y < мин.y)? мин.y : ((y > макс.y)? макс.y : y);
	}

	/// random vector размер between given ranges
	проц случайно(Точка xмин, Точка xмакс)
	{
		//TODO: this cast(цел) looks odd
		x = случайныйДиапазон(cast(цел)xмин.x, cast(цел)xмакс.x);
		y = случайныйДиапазон(cast(цел)xмин.y, cast(цел)xмакс.y);
	}

	/// distance to point
	плав расстояние(inout Точка Другая)
	{
		return cast(плав) std.math.sqrt(std.math.pow(Другая.x-x, 2.0) + std.math.pow(Другая.y-y, 2.0));
	}
	
	/// squared distance to Другой point
	плав квадратРасстояния(inout Точка Другая)
	{
		return cast(плав) std.math.pow(Другая.x-x, 2.0) + std.math.pow(Другая.y-y, 2.0);
	}

	/// point is serializable
	проц опиши(T)(T s)
	{
		assert(s !is null);
		s.опиши(x);
		s.опиши(y);
	}


	deprecated // use cross product
	{
		/// perp product
		плав перпПроизводная(Точка V) { return (x*V.y) - (y*V.x); }
	}

	deprecated // use normaliseCopy
	{
		/// diПрямоугion of the vector, i.e. normalised vector
		Точка направление() 
		{
			Точка Temp = *this;
	
			Temp.нормализуй();
	
			return Temp;
		}
	}

	/// rotate 
	Точка поверниКопию(Радианы угол)
	{
		return Точка(x*std.math.cos(угол)-y*std.math.sin(угол),
						x*std.math.sin(угол)+y*std.math.cos(угол));
	}
	
	/// rotate around pivot point 
	Точка поверниКопию(Точка центр, Радианы угол)
	{
		Точка v = Точка(x,y) + центр;
		v.поверни(угол); 
		return v; 
	}	

	/// дай x value
	final плав дайШ() { return x; }
	
	/// дай y value
	final плав дайВ() { return y; }

	/// установи x
	final проц устШ(плав argW) { x = argW; }

	/// установи y
	final проц устВ(плав argH) { y = argH; }

	/// add amount to X
	final проц добавьШ(плав аргЗн) { x += аргЗн; }

	/// add amount to Y
	final проц добавьВ(плав аргЗн) { y += аргЗн; }

	deprecated // storing polar coordinates in the x,y members is discouraged
	{
		/// assuминg point is given polar coordinates, this will convert to Прямоугangular coordinates
		проц полярВПрям() 
		{
			y = градусыВРадианы(y); // convert degrees to radian
		
			плав x_save = x;
		
			x = x_save * std.math.cos(y); // i know, polar->y is used too much, but i'd like to eliминate the need
			y = x_save * std.math.std.math.sin(y); // for too many variables
		}
	}

	/// return true if this point is above the Другой
	бул над_ли(Точка Другая)
	{
		if (y < Другая.y)
			return true;

		return false; 
	}
	
	/// return point below Другая
	бул под_ли(Точка Другая)
	{
		if (y > Другая.y)
			return true;
		return false; 
	}
	
	/// return point is to the right of Другая
	бул справа_ли(Точка Другая)
	{
		if (x > Другая.x)
			return true;
		return false; 
	}
	
	/// point is to the left of Другая 
	бул слева_ли(Точка Другая)
	{
		if (x < Другая.x)
			return true;
		return false; 
	}
}

export extern (D) struct Размер
{
export:

	static Размер NanNan = {плав.nan, плав.nan};
	
	плав w=0;
	плав h=0;

	/// Размер 'constructor' from carthesian coordinates
	static Размер opCall(плав Iw, плав Ih)
	{
		Размер v;
		v.w = Iw;
		v.h = Ih;
		return v;
	}
	
	/// Translate размер целo point 
	static Точка вТчк(inout Размер s)
	{
		Точка v;
		v.x = s.w;
		v.y = s.h;
		return v;
	}

	/// convenient setter
	проц уст(плав w_, плав h_) { w = w_; h = h_; }
	
	/// convert размер to string value
	сим[] вТкст()	{	return "W - " ~ std.string.toString(w) ~ ", H - " ~ std.string.toString(h); }

	/// returns largest component
	плав максСоставляющая()
	{
		if (w > h)
			return w;
		return h;
	}

	/// returns smallest component
	плав минСоставляющая()
	{
		if (w < h)
			return w;
		return h;
	}
	
	// Точка ops 
	Размер масштаб(inout Точка bh) { w *= bh.x; h *= bh.y; return *this; } 
	Размер opSub(inout Точка p) { return Размер(w - p.x, h - p.y); }
	Размер opAdd(inout Точка p) { return Размер(w + p.x, h + p.y); }
	
	// scalar addition
	Размер opAdd(плав V) { return Размер(w+V, h+V); }
	Размер opSub(плав V) { return Размер(w-V, h-V); }
	Размер opAddAssign(плав V) { w += V; h += V; return *this; }
	Размер opSubAssign(плав V) { w -= V; h -= V; return *this; }
	
	// scalar multiplication
	Размер opMulAssign(плав s) { w *= s; h *= s; return *this; }
	Размер opMul(плав s) { return Размер(w*s, h*s); }
	Размер opDivAssign(плав s) { w /= s; h /= s; return *this; }
	Размер opDiv(плав s) { return Размер(w/s, h/s); }

	// vector addition
	Размер opAddAssign(inout Размер Другой) { w += Другой.w; h += Другой.h; return *this; }
	Размер opAdd(inout Размер V) { return Размер(w+V.w, h+V.h); }
	Размер opSubAssign(inout Размер Другой) { w -= Другой.w;	h -= Другой.h; return *this; }
	Размер opSub(inout Размер V) { return Размер(w-V.w, h-V.h); }

	/// negation
	Размер opNeg() { return Размер(-w, -h); }

	/// scaling product
	Размер масштаб(плав bh) { *this *= bh; return *this; }
	Размер масштаб(inout Размер bh) { w *= bh.w; h *= bh.h; return *this; }
	
	/// make components positive
	Размер абс()
	{
		w = std.math.fabs(w);
		h = std.math.fabs(h);
		return *this;
	}
	
	/// абс copy
	Размер абсКопии()
	{
		Размер ret = *this;
		ret.абс();
		return ret;
	}
	
	/// clamp а vector to мин and макс values
	проц прикрепи(inout Размер мин, inout Размер макс)
	{
		w = (w < мин.w)? мин.w : ((w > макс.w)? макс.w : w);
		h = (h < мин.h)? мин.h : ((h > макс.h)? макс.h : h);
	}

	/// random vector размер between given ranges
	проц случайно(Размер wмин, Размер wмакс)
	{
		//TODO: this cast(цел) looks odd
		w = случайныйДиапазон(cast(цел)wмин.w, cast(цел)wмакс.w);
		h = случайныйДиапазон(cast(цел)wмин.h, cast(цел)wмакс.h);
	}

	/// размер is serializable
	проц опиши(T)(T s)
	{
		assert(s !is null);
		s.опиши(w);
		s.опиши(h);
	}

	/// returns w
	final плав дайШирину() { return w; }

	/// returns h
	final плав дайВысоту() { return h; }

	/// установи width
	final проц устШирину(плав argW) { w = argW; }

	/// установи height
	final проц устВысоту(плав argH) { h = argH; }

	/// add amount to X
	final проц добавьШ(плав аргЗн) { w += аргЗн; }

	/// add amount to Y
	final проц добавьВ(плав аргЗн) { h += аргЗн; }
}
///////////////////////////

export extern (D) struct Координаты
{
private arc.window.coordinates coords;

	static проц устРазмер(Размер разм){coords.setSize(изРазмера(разм));}	
	static проц устНачКоорд(Точка начкоорд)	{return coords.setOrigin(изТочки(начкоорд));}	
	static Размер дайРазмер(){return вРазмер(coords.getSize());}
	static плав дайШирину(){return cast(плав) coords.getWidth();}
	static плав дайВысоту(){return  cast(плав) coords.getHeight();}
	static Точка дайНачКоорд(){return вТочку(coords.getOrigin());}
	
}

export extern (D) class Звук
{
export:
	protected:

	бцел		источник_ал;		// OpenAL index of this Sound Resource
	ЗвукоФайл		звук;			// The Sound Resource (файл) itself.

	плав		питч = 1.0;
	плав		радиус = 256;	// The радиус of the Sound that plays.
	плав		громкость = 1.0;
	плав 	гейн   = 1.0; 
	бул		повторяется = false;
	бул		на_паузе  = false;	// true if на_паузе or stopped

	цел			размер;			// число of buffers that we use at one время
	бул		в_очередь = true;	// Keep в_очередь'ing more buffers, false if no loop and at end of track.
	бцел		старт_буфер;	// the первый буфер in the array of currently в_очередь'd buffers
	бцел		финиш_буфер;		// the последний буфер in the array of currently в_очередь'd buffers
	бцел		к_обработке;		// the число of buffers to queue next время.

	export:
	/// open with звук файл 
	this(ЗвукоФайл зфайл)
	{
		if(звукИнициализован)
		{		
			alGenSources(1, &источник_ал); 
			устЗвук(зфайл); 
	
			наПаузу(на_паузе);
			устПитч(питч);
			устГейн(гейн); 
			повторить(повторяется); 
			устГромкость(громкость); 
			устРадиус(радиус);
		}
	}
	
	static Звук opCall(ЗвукоФайл зфайл){return new Звук(зфайл);}
	
	/// Destructor
	~this()
	{
		if (звукИнициализован)
		{
			if(контекст_ал != null)
			{ // Error if this is destructed after Device de-init.
				стоп();
				alDeleteSources(1, &источник_ал);
			}
		}
	}
	
	/// Return the Sound Resource that this SoundNode plays.
	ЗвукоФайл дайЗвук() 
	{
		if(!звукИнициализован)
			return null;
			
		return звук;  
	}

	/// Set the Sound Resource that this SoundNode will play.
	проц устЗвук(ЗвукоФайл _sound)
	{	
		if(!звукИнициализован)
			return;
			
		бул tpaused = на_паузе;
		стоп();
		звук = _sound;

		// Ensure that our число of buffers isn't more than what exists in the звук файл
		цел len = звук.длинаБуферов();
		цел sec = звук.члоБуферовВСек();
		размер = len < sec ? len : sec;
	}

	/// установи гейн of звук 
	проц устГейн(плав argGain)
	{
		if(!звукИнициализован)
			return;
		
		alSourcef (источник_ал, AL_GAIN,     1.0f     );
	}

	/// установи position of звук 
	проц устПозицию(Точка pos)
	{
		if(!звукИнициализован)
			return;
		
		alSource3f(источник_ал, AL_POSITION, pos.x, pos.y, 0); 
	}

	/// установи velocity of звук
	проц устСкорость(Точка vel)
	{
		if(!звукИнициализован)
			return;
		
		alSource3f(источник_ал, AL_VELOCITY, vel.x, vel.y, 0); 
	}

	/// Set the питч of the SoundNode.
	плав дайПитч(){	return питч;	}

	/** Set the питч of the SoundNode.
	 *  This has nothing to do with the частота of the loaded Sound Resource.
	 *  \param питч Less than 1.0 is deeper, greater than 1.0 is higher. */
	проц устПитч(плав _pitch)
	{	
		if(!звукИнициализован)
			return;
			
		питч = _pitch;
		alSourcef(источник_ал, AL_PITCH, питч);
	}

	/// Get the радиус of the SoundNode
	плав дайРадиус() {	return радиус; }

	/** Set the радиус of the SoundNode.  The громкость of the звук falls off at a rate of
	 *  inverse distance squared.  The default радиус is 256.
	 *	\param The звук will be 1/2 its громкость at this distance.
	 *  The accuracy of this код should probably be checked. */
	проц устРадиус(плав _radius)
	{	
		if(!звукИнициализован)
			return;
			
		радиус = _radius;
		alSourcef(источник_ал, AL_ROLLOFF_FACTOR, 1.0/радиус);
	}

	/// Get the громкость (гейн) of the SoundNode
	плав дайГромкость() {	return громкость; }

	/** Set the громкость (гейн) of the SoundNode.
	 *  \param громкость 1.0 is the default. */
	проц устГромкость(плав _volume)
	{	
		if(!звукИнициализован)
			return;
			
		громкость = _volume;
		alSourcef(источник_ал, AL_GAIN, громкость);
	}

	/// Does the Sound loop when playback is finished?
	бул повторяется_ли() {	return повторяется;	}

	/// Set whether the playback of the SoundNode loops when playback is finished.
	проц повторить(бул _looping=true) { повторяется = _looping; }

	/// Is the звук currently на_паузе (or stopped?)
	бул наПаузе_ли() { return на_паузе; }

	/// Set whether the playback of the SoundNode is на_паузе.
	проц наПаузу(бул _paused = true)
	{	
		if(!звукИнициализован)
			return;
		
		// exit function if звук is turned off
		if (!звукВкл)
			return;
        
        // Only do something if changing states
		if (на_паузе != _paused)
		{	на_паузе = _paused;
			if (на_паузе)
				alSourcePause(источник_ал);
			else
			{	if (звук is null)
					throw new Исключение("Нельзя воспроизводить или снимать с паузы SoundNode без предварительного вызова устЗвук().");
				alSourcePlay(источник_ал);
				в_очередь = true;
		}	}
	}

	/// Alias of setPaused(false);
	проц играй() { наПаузу(false);	}

	/// Alias of наПаузу(true);
	проц пауза(){ наПаузу(true); }

	/** Seek to the position in the track.  Seek has a precision of .05 secs.
	 *  сместись() throws an exception if the value is outside the range of the Sound */
	проц перейди(double секунды)
	{	
		if(!звукИнициализован)
			return;
	
        if (звук is null)
			throw new Исключение("Нельзя переходить в SoundNode без предварительного вызова устЗвук().");
		бцел secs = cast(бцел)(секунды*размер);
		if (secs>звук.длинаБуферов())
			throw new Исключение("SoundNode.сместись("~.toString(секунды)~") is invalid for '"~звук.источник()~"'");
		бул tpaused = на_паузе;
		стоп();
		старт_буфер = финиш_буфер = secs;
		наПаузу(tpaused);
	}

	/// Tell how many секунды we've played of the файл
	double отчёт()
	{	
		if(!звукИнициализован)
			return 0;
			
		цел обработанные;
		double res;
		alGetSourcei(источник_ал, AL_BUFFERS_PROCESSED, &обработанные);
		try{
		double nn = cast(double)звук.члоБуферовВСек();
		res =(((старт_буфер+обработанные) % звук.длинаБуферов())/nn);
		if(nn == 0){ printf("%d", nn); throw new Исключение("Деление на ноль в Звук.отчёт...");}
		}
		catch(Исключение e){e.выведи();}
		return res;
	}

	/// Stop the SoundNode from playing and rewind it to the beginning.
	проц стоп()
	{	
		if(!звукИнициализован)
			return;
		
		alSourceStop(источник_ал);
		на_паузе		= true;
		в_очередь		= false;

		// Delete any unused buffers
		цел обработанные;
		alGetSourcei(источник_ал, AL_BUFFERS_PROCESSED, &обработанные);
		if (обработанные>0)
		{	//printf("Unqueuing buffers[%d..%d]\n", старт_буфер, старт_буфер+обработанные);
			alSourceUnqueueBuffers(источник_ал, обработанные, звук.дайБуферы(старт_буфер, старт_буфер+обработанные).ptr);
			звук.освободиБуферы(старт_буфер, обработанные);
		}
		старт_буфер = финиш_буфер = 0;
	}

	/** Enqueue new buffers for this SoundNode to play
	 *  Takes into account pausing, повторяется and all kinds of other things. */
	проц обновиБуферы()
	{
		if(!звукИнициализован)
			return;
		
		if (в_очередь)
		{	// Count buffers обработанные since последний время we queue'd more
		//скажи("Вариант 1"); нс;
			цел обработанные;
			alGetSourcei(источник_ал, AL_BUFFERS_PROCESSED, &обработанные);
			к_обработке = max(обработанные, cast(цел)(размер-(финиш_буфер-старт_буфер)));

			// Update the buffers for this source
			if (к_обработке > размер/32)
			{
			//скажи("Вариант 2"); нс;
				// If повторяется and our буфер has reached the end of the track
				цел blength = звук.длинаБуферов();
				if (!повторяется && финиш_буфер+к_обработке >= blength)
					к_обработке = blength - финиш_буфер;

				// Unqueue old buffers
				if (обработанные > 0)	// new, ensure no bugs
				{
				//скажи("Вариант 3"); нс;
				//writefln("Unqueuing buffers[%d..%d]", старт_буфер, старт_буфер+обработанные);
				
					alSourceUnqueueBuffers(источник_ал, обработанные, звук.дайБуферы(старт_буфер, старт_буфер+обработанные).ptr);
					звук.освободиБуферы(старт_буфер, обработанные);
				}

				// Enqueue as many buffers as what are available
				//скажи("Вариант 4"); нс;
				//writefln("Enqueuing buffers[%d..%d]", финиш_буфер, финиш_буфер+к_обработке);
				звук.разместиБуферы(финиш_буфер, к_обработке);
				//скажи("Размещение буферов под обновление"); нс;
				alSourceQueueBuffers(источник_ал, к_обработке, звук.дайБуферы(финиш_буфер, финиш_буфер+к_обработке).ptr);

				старт_буфер+= обработанные;
				финиш_буфер	+= к_обработке;
			}
		}

		// If not playing
		цел temp;
		alGetSourcei(источник_ал, AL_SOURCE_STATE, &temp);
		if (temp==AL_STOPPED || temp==AL_INITIAL)
		{	// but it should be, resume playback
			if (!на_паузе && в_очередь)
				alSourcePlay(источник_ал);
			else // we've reached the end of the track
			{	бул tpaused = на_паузе;
				стоп();
				if (повторяется && !tpaused)
					играй();
			}
		}

		// This must be here for tracks with their total число of buffers equal to размер.
		if (в_очередь)
			// If not повторяется and our буфер has reached the end of the track
			if (!повторяется && финиш_буфер+1 >= звук.длинаБуферов())
				в_очередь = false;	
	}

	/// Update overridden to update buffers.
	проц обработай()
	{
		if(!звукИнициализован)
			return;
		
		if (звук !is null)
		//скажи("Пошло обновление буферов.\n");
			обновиБуферы();	// where should this be called from?
	}
}

export extern(D) class ЗвукоФормат
{
export:
	ббайт	каналы;
	цел		частота;	// 22050hz, 44100hz?
	цел		биты;		// 8bit, 16bit?
	цел		размер;		// in bytes
	ткст	источник;
	ткст[] комменты;	// Header info from audio файл (not used yet)
	ткст формат_звука;

private
{
	OggVorbis_File вф;		// struct for our open ov файл.
	цел текущая_секция;	// used interally by ogg vorbis
	FILE *файл;
	ббайт[] буфер;
	
	MmFile	ппфайл;	
	
}
	/// Load the given файл and parse its headers
	this(ткст фимя)
	{	
	источник = фимя;
	
	ппфайл = new MmFile(фимя);
		
		if ((ппфайл[0..4]=="RIFF") ||(ппфайл[8..12] == "WAVE"))
		{					
		формат_звука ="wav";
		каналы 	= (cast(ushort[])файл[22..24])[0];
		частота	= (cast(uint[])файл[24..28])[0];		
		биты		= (cast(ushort[])файл[34..36])[0];		
		размер		= (cast(uint[])файл[40..44])[0];
					
		}
		else if (ппфайл[0..4]=="OggS")
		{		
		файл = fopen(toStringz(фимя), "rb");
		if(ov_open(файл, &вф, null, 0) < 0)
			throw new Исключение("'"~фимя~"' не является Ogg Vorbis файлом.\n");
		vorbis_info *vi = ov_info(&вф, -1);
		каналы = vi.channels;
		частота = vi.rate;
		биты = 16;
		размер = ov_pcm_total(&вф, -1)*(биты/8)*каналы;		
		формат_звука ="ogg";
					
		}
		else throw new Исключение(std.string.format("Нераспознанный звуковой формат %s для файла %s.", файл[0..4], фимя));
		
		
		
	}
	
	~this()
	{	
	if(формат_звука == "ogg")
		{
		ov_clear(&вф);
		fclose(файл);
		}
	delete ппфайл;
	}

	/** Return a буфер of uncompressed sound data.
	 *  Both parameters are measured in bytes. */
	ббайт[] дайБуфер(цел смещение, цел _размер)
	{
	if(формат_звука == "wav")
		{
		if (смещение+_размер > размер)
				return null;
			return cast(ббайт[])ппфайл[(44+смещение)..(44+смещение+_размер)];	
		}
	if(формат_звука == "ogg")
		{
		//скажи("Вход в ВорбисФайл.дайБуфер");нс;
		if (смещение+_размер > размер)
			return null;
			//скажи("Вызов ов_псм_сик");нс;
		ov_pcm_seek(&вф, смещение/(биты/8)/каналы);
		буфер.length = _размер;
		//скажи("Присвоение буферу размера");нс;
		long ret = 0;
		//скажи("Вход в цикл считывания ов_рид");нс;		
		while (ret<_размер)	// because it may take several requests to fill our буфер
			ret += ov_read(&вф, cast(byte*)буфер[ret..length], _размер-ret, 0, 2, 1, &текущая_секция);
			//скажи("Выход из Ворбис....дайбуфер");нс;
		return буфер;
		}
	else return null;
	}

	/// Print useful information about the loaded sound файл.
	void выведи()
	{	say(format("Звук: %s\n", источник));
		say(format("Каналы: %d\n", каналы));
		say(format("Частота семплов: %d гц\n", частота));
		say(format("Битов в семпле: %d\n", биты));
		say(format("Длина семпла: %d байт\n", размер));
		say(format("Длина семпла: %f сек\n", (8.0*размер)/(биты*частота*каналы)));
	}
}

export extern (D) class ЗвукоФайл
{	
export:
    
	//ббайт		формат;  		// wav, ogg, etc.
	ЗвукоФормат	файл_звука;
	бцел		формат_ал;		// Number of каналы and uncompressed bit-rate.

	бцел[]		буферы;		// holds the OpenAL id имя of each буфер for the song
	бцел[]		ссылка_на_буф;	// counts how many SoundNodes are using each буфер
	бцел		чло_буф;		// total число of буферы
	бцел		разм_буф;	// размер of each буфер in bytes, always a multiple of 4.
	бцел		буф_в_сек = 25;// ideal is between 5 and 500.  Higher values give more сместись precision.
						// but limit the число of sounds that can be playing concurrently.


	this(ткст фимя)
	{
	if (звукИнициализован)
		{	
			if (!(std.file.exists(фимя)))
			{
				say(format("Звуковой Файл %s не существует!", фимя)); 
			} 
	
			if (!(фимя in списокЗвукоФайлов))
			{
					
						файл_звука = new ЗвукоФормат(фимя);				
	
				// Determine OpenAL format
				if (файл_звука.каналы==1 && файл_звука.биты==8)  		формат_ал = AL_FORMAT_MONO8;
				else if (файл_звука.каналы==1 && файл_звука.биты==16) формат_ал = AL_FORMAT_MONO16;
				else if (файл_звука.каналы==2 && файл_звука.биты==8)  формат_ал = AL_FORMAT_STEREO8;
				else if (файл_звука.каналы==2 && файл_звука.биты==16) формат_ал = AL_FORMAT_STEREO16;
				else throw new Исключение("Звук должен быть в формате 8 или 16 бит, моно или стерео.");
				
	            //say(фм("Подошли к первой проверке"));нс;
				// Calculate the parameters for our буферы
				буф_в_сек =25;
				плав секунды;
				цел байт_в_сек = (файл_звука.биты/8)*файл_звука.частота*файл_звука.каналы;
				try
				{
				double nn =cast(double)байт_в_сек;
				секунды = cast(плав) файл_звука.размер/nn;
				if(nn == 0) throw new Исключение("Деление на ноль ЗвукоФайл.this1...");
				}
				catch(Исключение e){e.выведи();}
				
				чло_буф = cast(цел)(секунды*буф_в_сек);

				try
				{
				uint nn = буф_в_сек;
				//скажи(фм("%d", nn)); нс;
				разм_буф = байт_в_сек/nn;
				if(nn == 0) throw new Error("Деление на ноль в ЗвукоФайл.this2...");
				}
				catch(Исключение e){e.выведи();}
				
				//say(фм("Прошли проверки"));нс;
				цел размер_семпла = файл_звука.каналы*файл_звука.биты/8;
				разм_буф = (разм_буф/размер_семпла)*размер_семпла;	// ensure a multiple of our sample размер
				буферы.length = ссылка_на_буф.length = чло_буф;	// allocate empty буферы
				
				списокЗвукоФайлов[фимя] = this; 
				списокЗвукоФайлов.rehash; 
			}
			else
			{
				// установи to one already loaded 
				this = списокЗвукоФайлов[фимя]; 
				
			}
		}
	}
	
	static ЗвукоФайл opCall(ткст фимя){return new ЗвукоФайл(фимя);}

	/// Tell OpenAL to release the звук, close the файл
	~this()
	{	
		if (звукИнициализован)
		{
			освободиБуферы(0, чло_буф);	// ensure every буфер is released
		}
	}

	/// Get the частота of the звук (usually 22050 or 44100)
	бцел частота()	{	return файл_звука.частота; }

	/** Get a pointer to the array of OpenAL буфер id's used for this звук.
	 *  разместиБуферы() and освободиБуферы() are used to assign and release буферы from the звук источник.*/
	бцел[] члоБуферов()
	{	return буферы;
	}

	/// Get the число of буферы this звук was divided into
	бцел длинаБуферов()
	{	return буферы.length;
	}

	/// Get the число of буферы created for each second of this звук
	бцел члоБуферовВСек()
	{	return буф_в_сек;
	}

	/// Get the length of the звук in секунды
	double длина()
	{	return (8.0*файл_звука.размер)/(файл_звука.биты*файл_звука.частота*файл_звука.каналы);
	}

	/// Return the размер of the uncompressed звук data, in bytes.
	бцел размер()
	{	return файл_звука.размер;
	}

	/// Get the фимя this Sound was loaded from.
	ткст источник()
	{	return файл_звука.источник;
	}

	/// дай буферы 
	бцел[] дайБуферы(цел первый, цел последний)
	{	первый = первый % буферы.length;
		последний = последний % буферы.length;

		// If we're wrapping around
		if (первый > последний)
			return буферы[первый..length]~буферы[0..последний];
		else
			return буферы[первый..последний];
	}

	проц разместиБуферы(цел первый, цел число)
	{	
		if(!звукИнициализован)
			return;
			//скажи("Размещение буферов"); нс;
		// Loop through each of the буферы that will be returned
		for (цел j=первый; j<первый+число; j++)
		{	// Allow inputs that are out of range to loop around
			цел i = j % буферы.length;

			// If this буфер hasn't yet been bound
			if (ссылка_на_буф[i]==0)
			{	
			//скажи("Размещение буферов:Генерация буфера"); нс;
			// Generate a буфер
				alGenBuffers(1, &буферы[i]);
				ббайт[] данные = файл_звука.дайБуфер(i*разм_буф, разм_буф);				
				//скажи("Размещение буферов: данные"); нс;
				alBufferData(буферы[i], формат_ал, &данные[0], cast(ALsizei)данные.length, частота());
				//скажи("Размещение буферов: алБуферДата"); нс;
			}
			// Increment reference count
			ссылка_на_буф[i]++;
			//скажи("Размещение буферов: инкремент счётчика ссылок "); нс;
		}
	}

	/** Mark the range of буферы for freeing.
	 *  This will decrement the reference count for each of the буферы
	 *  and will release it once it's at zero. */
	проц освободиБуферы(цел первый, цел число)
	{	
		if(!звукИнициализован)
			return;
			
		for (цел j=первый; j<первый+число; j++)
		{	// Allow inputs that are out of range to loop around
			цел i = j % буферы.length;

			// Decrement reference count
			if (ссылка_на_буф[i]==0)
				continue;
			ссылка_на_буф[i]--;

			// If this буфер has no references to it, delete it
			if (ссылка_на_буф[i]==0)
			{	alDeleteBuffers(1, &буферы[i]);
				if (alIsBuffer(буферы[i]))
					throw new Исключение("Буфер "~.toString(i)~" звука '"~файл_звука.источник~
										"' не удаётся удалить; вероятно он используется.\n");
		}	}
	}

	/// Print useful information about the loaded звук файл.
	проц выведи()
	{	файл_звука.выведи();
		say(format("Размер буфера: %d байт\n", разм_буф));
		say(format("Число буферов: %d шт\n", чло_буф));
		say(format("Буферов в секунду: %d шт/сек\n", буф_в_сек));
	}
}

private:
alias плав arcfl;

import arc.math.point: Point;
import arc.math.size: Size;

Точка вТочку(arc.math.point.Point тчк)
	{
	Точка рез;
	рез.x = cast(плав) тчк.x;
	рез.y = cast(плав) тчк.y;
	return  рез;
	}
	
Point изТочки(Точка тчк)
	{
	arc.math.point.Point рез;
	рез.x = cast(плав) тчк.x;
	рез.y = cast(плав) тчк.y;
	return  рез;
	}
	
Point[] изМассиваТочек(Точка[] тт){
 Point[] x;
foreach(Точка т; тт){
x~= изТочки(т);
}
return x;
}
	
Размер вРазмер(arc.math.size.Size sz)
	{
	Размер ок;
	ок.w = cast(плав) sz.w;
	ок.h = cast(плав) sz.h;
	return ок;
	}
	
Size изРазмера(Размер sz)
	{
	Size ок;
	ок.w = cast(плав) sz.w;
	ок.h = cast(плав) sz.h;
	return ок;
	}
	
	
export extern (D):

import arc.time;

бцел дайВремя(){return arc.time.getTime();}
проц открой_время(){arc.time.open();}
проц закрой_время(){arc.time.close();}
проц обработай_время(){arc.time. process();}
проц спи(бцел мсек){arc.time.sleep(мсек);}
бцел прошлоМсек(){return arc.time.elapsedMilliseconds();}
реал прошлоСек(){return arc.time.elapsedSeconds();}
бцел кадров_в_сек(){return arc.time.fps();}
проц ограничьКВС(бцел максКвс){return arc.time.limitFPS(максКвс);}


	
проц открой_окно(ткст титул, цел шир, цел выс, бул полнэкр){arc.window.open(титул, шир, выс, полнэкр);}
проц закрой_окно(){arc.window.close();}
цел дайШирину_окна(){return arc.window.getWidth();}
цел дайВысоту_окна(){return arc.window.getHeight();}
Размер дайРазмер_окна()
	{
	auto sz = вРазмер(arc.window.getSize());
	return cast(Размер) sz;
	}
Поверхность* дайЭкран(){return cast(Поверхность*) arc.window.getScreen();}
проц новРазмер_окна(цел шир, цел выс){return arc.window.resize(шир, выс);}
проц полный_экран(){arc.window.toggleFullScreen();}
проц очисти_окно(){arc.window.clear();}
проц снимок_окна(ткст имя){arc.window.screenshot(имя);}
проц отобрази(){arc.window.swap();}//переставь_буфыЭкрана
проц буфменЧист(){arc.window.swapClear();}


проц открой_шрифт(){arc.font.open();}
проц закрой_шрифт(){arc.font.close();}

import arc.math.routines;

бул вПределах(реал чис, реал цель, реал диапазон){return arc.math.routines.withinRange(чис, цель, диапазон);}
реал расстояние(реал ш1, реал в1, реал ш2, реал в2){return  arc.math.routines.distance(ш1, в1,ш2,в2);}
цел следщСтепеньДва(цел ч){return arc.math.routines.nextPowerOfTwo(ч);}
цел случайныйДиапазон(реал а, реал б){return  arc.math.routines.randomRange(а, б);}
бул найтиКорни(плав а, плав б, плав в, inout плав т0, inout плав т1){return arc.math.routines.findRoots(а, б, в, т0, т1);}
плав площадь(Точка[] контур)
	{
	цел n = контур.length;

	  плав A=0.0f;

	  for(цел p=n-1,q=0; q<n; p=q++)
	  {
		A+= контур[p].x*контур[q].y - контур[q].x*контур[p].y;
	  }

	  return A*0.5f;
	  }
плав максРасстояние(Точка дано, Точка[] набор)
	{
	плав max = 0; 
		плав tmp = 0; 

		foreach(Точка p; набор)
		{
			// measure distance 
			tmp = дано.расстояние(p); 

			// if greater than current max point, then make this distance the maximum 
			if (tmp > max)
				max = tmp; 
		}

		return max; 
		}
проц переставьпл(inout плав а, inout плав б){return arc.math.routines.swapf(а, б);}
плав прикрепипл(плав ш, плав мин, плав макс){return cast(плав) arc.math.routines.clampf(ш, мин, макс);}
плав обернипл(плав ш, плав мин, плав макс){return cast(плав) arc.math.routines.wrapf(ш, мин, макс);}
плав знак(плав ш){return cast(плав) arc.math.routines.sign(ш);}
плав припкрепи(плав а, плав низ, плав верх){return cast(плав) arc.math.routines.clamp(а, низ, верх);}
плав случайно(){return cast(плав) arc.math.routines.random();}
плав случайно(плав н, плав в){return cast(плав) arc.math.routines.random(н, в);}
проц переставь(T) (inout T а, inout T б){arc.math.routines.swap(а, б);}
T макс(T)(T а, T с) {return  arc.math.routines.max(а, б);}
T мин(T)(T а, T с) {return  arc.math.routines.max(а, б);}

import arc.math.angle;

Радианы градусыВРадианы(Градусы град){return cast(Радианы) arc.math.angle.degreesToRadians(град);}
Градусы радианыВГрадусы(Радианы рад){return cast(Градусы) arc.math.angle.radiansToDegrees(рад);}
Градусы ограничьГрад(Градусы град){return cast(Градусы) arc.math.angle.restrictDeg(град);}
Радианы ограничьРад(Радианы рад){return cast(Радианы) arc.math.angle.restrictRad(рад);}

import arc.math.collision;

бул столкнулись2Кв(Точка поз1, Размер разм1, Точка поз2, Размер разм2){return arc.math.collision.boxBoxCollision(
изТочки(поз1), изРазмера(разм1), изТочки(поз2), изРазмера(разм2));}

бул столкнулисьКвКруг(Точка квПоз, Размер квРазм, Точка кругПоз, плав радиус){return arc.math.collision.boxCircleCollision(изТочки(квПоз), изРазмера(квРазм), изТочки(кругПоз), cast(arcfl) радиус);}

бул столкнулисьКвШВ(Точка тчк, Точка квПоз, Размер квРазм){return arc.math.collision.boxXYCollision(изТочки(тчк), изТочки(квПоз), изРазмера(квРазм));}

бул столкнулисьКругКруг(Точка с1, плав рад1, Точка с2, плав рад2){return arc.math.collision.circleCircleCollision(изТочки(с1), cast(arcfl) рад1, изТочки(с2), cast(arcfl) рад2);}

бул столкнулисьКругШВ(Точка тчк, Точка с, плав рад){return arc.math.collision.circleXYCollision(изТочки(тчк), изТочки(с), cast(arcfl) рад);}

цел столкнулисьЛинЛин(Точка с1т0, Точка с1т1, Точка с2т0, Точка с2т1, inout Точка и0)
	{
	return arc.math.collision.lineLineCollision(изТочки(с1т0), изТочки(с1т1), изТочки(с2т0), изТочки(с2т1), изТочки(и0));
	}

бул вОтрезке(Точка т, Точка о0, Точка о1){return arc.math.collision.inSegment(изТочки(т), изТочки(о0), изТочки(о1));}

бул столкнулисьМногоугШВ(Точка т, Точка[] тт){return arc.math.collision.polygonXYCollision(изТочки(т),   изМассиваТочек(тт));}
 
import arc.draw.image;

проц рисуй(Текстура текстура, Точка поз, Размер разм = Размер(плав.nan,плав.nan),
	Точка стержень = Точка(0,0),Радианы угол = 0, Цвет цв = Цвет.Белый)
	{
	return arc.draw.image.drawImage(текстура.изТекстуры(), изТочки(поз), изРазмера(разм),изТочки(стержень),cast(Radians) угол, цв.изЦвета());
	}

проц рисуйвЛВУ(Текстура текстура, Точка поз, Размер разм = Размер(плав.nan,плав.nan), Цвет цв = Цвет.Белый)
	{
	return arc.draw.image.drawImageTopLeft(текстура.изТекстуры(), изТочки(поз), изРазмера(разм), цв.изЦвета());
	}
проц рисуйПодсекцию(Текстура текстура, Точка лв, Точка пн, Цвет цв = Цвет.Белый)
	{
	return arc.draw.image.drawImageSubsection(текстура.изТекстуры, изТочки(лв), изТочки(пн), цв.изЦвета);
	}
	
import arc.draw.shape;

проц рисуйПиксель(Точка поз, Цвет цв){return arc.draw.shape.drawPixel(изТочки(поз), цв.изЦвета);}

проц рисуйЛинию(Точка поз1, Точка поз2, Цвет цв){return arc.draw.shape.drawLine(изТочки(поз1), изТочки(поз2), цв.изЦвета);}

проц рисуйКруг(Точка поз, плав радиус, цел деталь, Цвет цв, бул залить_ли){return arc.draw.shape.drawCircle(изТочки(поз), cast(arcfl) радиус, деталь, цв.изЦвета, залить_ли);}

проц рисуйПрямоуг(Точка поз, Размер разм, Цвет цв, бул залить_ли){return arc.draw.shape.drawRectangle(изТочки(поз), изРазмера(разм), цв.изЦвета, залить_ли);}

проц рисуйМногоуг(Точка[] многоуг, Цвет цв, бул залить_ли){return arc.draw.shape.drawPolygon(изМассиваТочек(многоуг), цв.изЦвета, залить_ли);}

import arc.input;

проц открой_ввод(){return arc.input.open();}
проц устПовторКлавиатуры(бул данет){return arc.input.setKeyboardRepeat(данет);}
СостояниеКлавиши состояниеКлавиши(цел номКл){return  arc.input.keyStatus(номКл);}
бул нажатаКлавиша(цел номКл){return arc.input.keyPressed(номКл);}
бул отпущенаКлавиша(цел номКл){return arc.input.keyReleased(номКл);}
бул клавишаВнизу(цел номКл){return arc.input.keyDown(номКл);}
бул клавишаВверху(цел номКл){return arc.input.keyUp(номКл);}
бул симвнаж(){return arc.input.charHit();}
ткст последнСимвв(){return arc.input.lastChars();}
СостояниеКлавиши состКнМыши(цел номКл){return arc.input.mouseButtonStatus(номКл);}
бул нажатаКнМыши(цел номКл){return arc.input.mouseButtonPressed(номКл);}
бул отпущенаКнМыши(цел номКл){return arc.input.mouseButtonReleased(номКл);}
бул кнМышиВнизу(цел номКл){return arc.input.mouseButtonDown(номКл);}
бул кнМышиВверху(цел номКл){return arc.input.mouseButtonUp(номКл);}
плав мышьШ(){return cast(плав) arc.input.mouseX();}
плав мышьВ(){return cast(плав) arc.input.mouseY();}
Точка позМыши(){return вТочку(arc.input.mousePos());}
плав мышьШ_до(){return cast(плав) arc.input.mouseOldX();}
плав мышьВ_до(){return cast(плав) arc.input.mouseOldY();}
Точка позМыши_до(){return вТочку(arc.input.mouseOldPos());}
бул двигаетсяМышь(){return arc.input.mouseMotion();}
проц виденДефолтныйКурсор(бул арг){return arc.input.defaultCursorVisible(арг);}
бул колесоВверх(){return arc.input.wheelUp();}
бул колесоВниз(){return arc.input.wheelDown();}
ббайт члоДжойстов(){return arc.input.numJoysticks();}
цел откройДжойсты(цел индекс = -1){return arc.input.openJoysticks(индекс);}
проц закройДжойсты(цел индекс = -1){arc.input.closeJoysticks(индекс);}
бул потерянФокус(){return arc.input.lostFocus();}
проц покинь(){arc.input.quit();}
бул покинут_ли() {return arc.input.isQuit();}
проц обработай_ввод(){arc.input.process();}
/*
бул joyButtonDown(ббайт index, ббайт button);
бул joyButtonUp(ббайт index, ббайт button);
бул joyButtonPressed(ббайт index, ббайт button);
бул joyButtonReleased(ббайт index, ббайт button);
плав joyAxisMoved(ббайт index, ббайт axis);
Joysticks.Joystick.ButtonIterator joyButtonsDown(ббайт index);
Joysticks.Joystick.ButtonIterator joyButtonsUp(ббайт index);
Joysticks.Joystick.ButtonIterator joyButtonsPressed(ббайт index);
Joysticks.Joystick.ButtonIterator joyButtonsReleased(ббайт index);
цел delegate(цел delegate(inout ббайт axis, inout плав)) joyAxesMoved(ббайт index);
ббайт numJoystickButtons(ббайт index);
ббайт numJoystickAxes(ббайт index);
ткст joystickName(ббайт index);
бул isJoystickOpen(ббайт index);
проц setAxisThreshold(плав threshold);
*/

import arc.log; 


проц логТекст(ткст имяф){arc.log.toTXT(имяф);}
проц логРЯР(ткст имяф){return  arc.log.toXML(имяф);}
проц пиши_лог(ткст имяф, ткст имяфнк, ткст урОш, ...)
	{
	ткст ткт = cast(char[]) fm(_arguments, _argptr);
	arc.log.write(имяф, имяфнк, урОш, ткт);
	}

проц выведи_лог(){arc.log.print();}
проц открой_лог(){arc.log.open();}
проц закрой_лог(){arc.log.close();}
 

проц открой_звук()
{
try {
			Derelict_SetMissingProcCallback(&обработайНедостающийОпенАЛ);
			DerelictAL.load(); 
			//DerelictALU.load();
			DerelictOgg.load(); 
			DerelictVorbis.load(); 
			DerelictVorbisFile.load();
		} // try

		// h
		catch (Исключение e) {
			e.выведи();
			exit(0);
		}        
        
		// Initialize OpenAL audio
		устройство_ал = alcOpenDevice(null);
		контекст_ал = alcCreateContext(устройство_ал, null);
		alcMakeContextCurrent(контекст_ал);

		if (alGetError() != 0 || устройство_ал == null || контекст_ал == null)
		{
			звукИнициализован = false; 
			throw new Исключение("Ошибка при инициализации OpenAL.");
		}
		else
		{
			звукИнициализован = true;
		}
		
		// default initial values for listener 
		установиПозициюСлушателя(Точка(0,0));
		установиСкоростьСлушателя(Точка(0,0));
		установиОриентациюСлушателя(Точка(0,0));
    
		// make sure звук is 'on'
		включи_звук();
}
проц закрой_звук()
{
if(!звукИнициализован)
			return;
		
		alcDestroyContext(контекст_ал);
		alcCloseDevice(устройство_ал);
		контекст_ал = устройство_ал = null;
		
		выгрузиDerelict();
}
проц обработай_звук()
{
foreach(звук; аудиоСписок)
		{
			if(!звук.на_паузе)
				звук.обработай();
		}
}
проц включи_звук()
{
{
		if(звукИнициализован)
			звукВкл = true; 
		else
			звукВкл = false; 
	}
}
проц выключи_звук(){звукВкл = false;}
бул звук_включен(){return звукВкл;}
бул звук_инициализирован(){return  звукИнициализован;}
проц установиПозициюСлушателя(Точка поз)
{
if(!звукИнициализован)
			return;
			
		alListener3f(AL_POSITION, поз.x, поз.y, 0);
}
проц установиСкоростьСлушателя(Точка скор)
{
if(!звукИнициализован)
			return;
			
		alListener3f(AL_VELOCITY, скор.x, скор.y, 0);
}
проц установиОриентациюСлушателя(Точка ори)
{
if(!звукИнициализован)
			return;
			
		alListener3f(AL_ORIENTATION, ори.x, ори.y, 1); 
}
Точка дайПозициюСлуш()
{
if(!звукИнициализован)
			return Точка(0,0);
		
		плав x, y;
		alGetListener3f(AL_POSITION, &x, &y, null); 
		return Точка(x,y);
}
Точка дайСкоростьСлуш()
{
if(!звукИнициализован)
			return Точка(0,0);
		
		float x, y; 
		alGetListener3f(AL_VELOCITY, &x, &y, null); 
		return Точка(x,y);
}
Точка дайОриентациюСлуш()
{
if(!звукИнициализован)
			return Точка(0,0);
		
		float x, y; 
		alGetListener3f(AL_ORIENTATION, &x, &y, null); 
		return Точка(x,y);
}
проц регистрируйАвтоОбработку(Звук з){аудиоСписок ~= з;}
проц отрегистрируйАвтоОбработку(Звук з){arc.templates.array.remove(аудиоСписок, з);}

