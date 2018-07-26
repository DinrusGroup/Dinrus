module stdrus;

template ва_старт( T )
	{
		проц ва_старт( out спис_ва ap, inout T parmn )
		{
			ap = cast(спис_ва) ( cast(проц*) &parmn + ( ( T.sizeof + цел.sizeof - 1 ) & ~( цел.sizeof - 1 ) ) );
		}
	}

	template ва_арг( T )
	{
		T ва_арг( inout спис_ва ap )
		{
			T арг = *cast(T*) ap;
			ap = cast(спис_ва) ( cast(проц*) ap + ( ( T.sizeof + цел.sizeof - 1 ) & ~( цел.sizeof - 1 ) ) );
			return арг;
		}
	}

	проц ва_стоп( спис_ва ap )
	{

	}

	проц ва_копируй( out спис_ва куда, спис_ва откуда )
	{
		куда = откуда;
	}
alias ва_старт va_start;
alias ва_арг va_arg;
alias ва_стоп va_end;
alias ва_копируй va_copy;

extern (C) template va_arg_d(T)
{
    T va_arg(inout va_list _argptr)
    {
	T арг = *cast(T*)_argptr;
	_argptr = _argptr + ((T.sizeof + int.sizeof - 1) & ~(int.sizeof - 1));
	return арг;
    }
}

import std.base64, std.bitarray, std.path, std.string /*rt.console*/, std.io;

	import std.md5;

	проц суммаМД5(ббайт[16] дайджест, проц[] данные){std.md5.sum(дайджест, данные);}
	проц выведиМД5Дайджест(ббайт дайджест[16]){std.md5.printDigest(дайджест);}
	ткст дайджестМД5вТкст(ббайт[16] дайджест){return std.md5.digestToString(дайджест);}

	import std.loader;

	цел иницМодуль(){return std.loader.ExeModule_Init();}
	проц деиницМодуль(){return std.loader.ExeModule_Uninit();}
	ук загрузиМодуль(in ткст имямод){return cast(ук) std.loader.ExeModule_Load(имямод);}
	ук добавьСсылНаМодуль(ук умодуль){return cast(ук) std.loader.ExeModule_AddRef(cast(HXModule) умодуль);}
	проц отпустиМодуль(inout ук умодуль){return std.loader.ExeModule_Release(cast(HXModule) умодуль);}
	ук дайСимволИМодуля(inout ук умодуль, in ткст имяСимвола){return std.loader.ExeModule_GetSymbol(cast(HXModule) умодуль, имяСимвола);}
	ткст ошибкаИМодуля(){return std.loader.ExeModule_Error();}	


	import std.intrinsic;

	цел пуб(бцел х){return std.intrinsic.bsf(х);}//Поиск первого установленного бита (узнаёт его номер)
	цел пубр(бцел х){return std.intrinsic.bsr(х);}//Поиск первого установленного бита (от старшего к младшему)
	цел тб(in бцел *х, бцел номбит){return std.intrinsic.bt(х, номбит);}//Тест бит
	цел тбз(бцел *х, бцел номбит){return std.intrinsic.btc(х, номбит);}// тест и заполнение
	цел тбп(бцел *х, бцел номбит){return std.intrinsic.btr(х, номбит);}// тест и переустановка
	цел тбу(бцел *х, бцел номбит){return std.intrinsic.bts(х, номбит);}// тест и установка
	бцел развербит(бцел б){return std.intrinsic.bswap(б);}//Развернуть биты в байте
	ббайт чипортБб(бцел адр_порта){return std.intrinsic.inp(адр_порта);}//читает порт ввода с указанным адресом
	бкрат чипортБк(бцел адр_порта){return std.intrinsic.inpw(адр_порта);}
	бцел чипортБц(бцел адр_порта){return std.intrinsic.inpl(адр_порта);}
	ббайт пипортБб(бцел адр_порта, ббайт зап){return std.intrinsic.outp(адр_порта, зап);}//пишет в порт вывода с указанным адресом
	бкрат пипортБк(бцел адр_порта, бкрат зап){return std.intrinsic.outpw(адр_порта, зап);}
	бцел пипортБц(бцел адр_порта, бцел зап){return std.intrinsic.outpl(адр_порта, зап);}
	цел члоустбит32( бцел x )
	{
		x = x - ((x>>1) & 0x5555_5555);
		x = ((x&0xCCCC_CCCC)>>2) + (x&0x3333_3333);
		x += (x>>4);
		x &= 0x0F0F_0F0F;
		x += (x>>8);
		x &= 0x00FF_00FF;
		x += (x>>16);
		x &= 0xFFFF;
		return x;
	}

	бцел битсвоп( бцел x )
	{

		version( D_InlineAsm_X86 )
		{
			asm
			{
				// Author: Tiago Gasiba.
				mov EDX, EAX;
				shr EAX, 1;
				and EDX, 0x5555_5555;
				and EAX, 0x5555_5555;
				shl EDX, 1;
				or  EAX, EDX;
				mov EDX, EAX;
				shr EAX, 2;
				and EDX, 0x3333_3333;
				and EAX, 0x3333_3333;
				shl EDX, 2;
				or  EAX, EDX;
				mov EDX, EAX;
				shr EAX, 4;
				and EDX, 0x0f0f_0f0f;
				and EAX, 0x0f0f_0f0f;
				shl EDX, 4;
				or  EAX, EDX;
				bswap EAX;
			}
		}
		else
		{
			x = ((x >> 1) & 0x5555_5555) | ((x & 0x5555_5555) << 1);
			x = ((x >> 2) & 0x3333_3333) | ((x & 0x3333_3333) << 2);
			x = ((x >> 4) & 0x0F0F_0F0F) | ((x & 0x0F0F_0F0F) << 4);
			x = ((x >> 8) & 0x00FF_00FF) | ((x & 0x00FF_00FF) << 8);
			x = ( x >> 16              ) | ( x               << 16);
			return x;

		}
	}



export extern(D) struct ПерестановкаБайт
{
export:

        final static проц своп16 (проц[] приёмн)
        {
                своп16 (приёмн.ptr, приёмн.length);
        }


        final static проц своп32 (проц[] приёмн)
        {
                своп32 (приёмн.ptr, приёмн.length);
        }


        final static проц своп64 (проц[] приёмн)
        {
                своп64 (приёмн.ptr, приёмн.length);
        }


        final static проц своп80 (проц[] приёмн)
        {
                своп80 (приёмн.ptr, приёмн.length);
        }


        final static проц своп16 (проц *приёмн, бцел байты)
        {
                assert ((байты & 0x01) is 0);

                auto p = cast(ббайт*) приёмн;
                while (байты)
                      {
                      ббайт b = p[0];
                      p[0] = p[1];
                      p[1] = b;

                      p += крат.sizeof;
                      байты -= крат.sizeof;
                      }
        }


        final static проц своп32 (проц *приёмн, бцел байты)
        {
                assert ((байты & 0x03) is 0);

                auto p = cast(бцел*) приёмн;
                while (байты)
                      {
                      *p = bswap(*p);
                      ++p;
                      байты -= цел.sizeof;
                      }
        }


        final static проц своп64 (проц *приёмн, бцел байты)
        {
                assert ((байты & 0x07) is 0);

                auto p = cast(бцел*) приёмн;
                while (байты)
                      {
                      бцел i = p[0];
                      p[0] = bswap(p[1]);
                      p[1] = bswap(i);

                      p += (дол.sizeof / цел.sizeof);
                      байты -= дол.sizeof;
                      }
        }


        final static проц своп80 (проц *приёмн, бцел байты)
        {
                assert ((байты % 10) is 0);
               
                auto p = cast(ббайт*) приёмн;
                while (байты)
                      {
                      ббайт b = p[0];
                      p[0] = p[9];
                      p[9] = b;

                      b = p[1];
                      p[1] = p[8];
                      p[8] = b;

                      b = p[2];
                      p[2] = p[7];
                      p[7] = b;

                      b = p[3];
                      p[3] = p[6];
                      p[6] = b;

                      b = p[4];
                      p[4] = p[5];
                      p[5] = b;

                      p += 10;
                      байты -= 10;
                      }
        }
}///end of struct

export extern(D)
{	

	бул вОбразце(дим с, ткст образец){return cast(бул) std.string.inPattern(с, образец);}
	бул вОбразце(дим с, ткст[] образец){return cast(бул) std.string.inPattern(с, образец);}
	
	ткст фм(...)//////
	{
	auto args = _arguments;
    auto argptr = _argptr;
   // ткст fmt = null;
    //разборСпискаАргументов(args, argptr, fmt);
	
    ткст т;

    проц putc(дим c)
    {
	std.utf.encode(т, c);
    }

		форматДелай(&putc, args, argptr);
		return т;
	}
alias фм форматируй;
		
}/////extern D
///////////////////////////////////////////////////
export extern(D)
{
	import std.demangle;

	ткст разманглируй(ткст имя){return std.demangle.demangle(имя);}

	бцел кодируйДлину64(бцел сдлин)
		{
		return cast(бцел) std.base64.encodeLength(cast(бцел) сдлин);
		}
	ткст кодируй64(ткст стр, ткст буф = ткст.init)
		{
		if(буф)	return cast(ткст) std.base64.encode(cast(сим[]) стр, cast(сим[]) буф);
		else return cast(ткст) std.base64.encode(cast(сим[])стр);
		}

	бцел раскодируйДлину64(бцел кдлин)
		{
		return cast(бцел) std.base64.decodeLength(cast(бцел) кдлин);
		}
	ткст раскодируй64(ткст кстр, ткст буф = ткст.init)
		{
		if(буф) return cast(ткст) std.base64.decode(cast(сим[]) кстр, cast(сим[]) буф);
		else return cast(ткст) std.base64.decode(cast(сим[]) кстр);
		}

	
	import std.ctype;

	цел числобукв_ли(дим б){return std.ctype.isalnum(б);}
	цел буква_ли(дим б){return  std.ctype.isalpha(б);}
	цел управ_ли(дим б){return std.ctype.iscntrl(б);}
	цел цифра_ли(дим б){return std.ctype.isdigit(б);}
	цел проп_ли(дим б){return std.ctype.islower(б);}
	цел пунктзнак_ли(дим б){return  std.ctype.ispunct(б);}
	цел межбукв_ли(дим б){return std.ctype.isspace(б);}
	цел заг_ли(дим б){return std.ctype.isupper(б);}
	цел цифраикс_ли(дим б){return std.ctype.isxdigit(б);}
	цел граф_ли(дим б){return  std.ctype.isgraph(б);}
	цел печат_ли(дим б) {return  std.ctype.isprint(б);}
	цел аски_ли(дим б){return  std.ctype.isascii(б);}
	дим впроп(дим б){return  std.ctype.tolower(б);}
	дим взаг(дим б){return std.ctype.toupper(б);}
}//////////// extern C
///////////////////////////////////////
export extern(D) struct МассивБит
{
    т_мера длин;
    бцел* укз;
	
	alias  укз ptr;

	export т_мера разм()
	{
	return cast(т_мера) dim();
	}
	
    т_мера dim()
    {
	return (длин + 31) / 32;
    }
	
	export т_мера длина()
	{
	return cast(т_мера) length();
	}
	
    т_мера length()
    {
	return длин;
    }

	export проц длина(т_мера новдлин)
	{
	return length(новдлин);
	}
	
    проц length(т_мера newlen)
    {
	if (newlen != длин)
	{
	    т_мера olddim = dim();
	    т_мера newdim = (newlen + 31) / 32;

	    if (newdim != olddim)
	    {
		// Create a fake array so we can use D'т realloc machinery
		бцел[] b = ptr[0 .. olddim];
		b.length = newdim;		// realloc
		ptr = b.ptr;
		if (newdim & 31)
		{   // Уст any pad bits to 0
		    ptr[newdim - 1] &= ~(~0 << (newdim & 31));
		}
	    }

	    длин = newlen;
	}
    }

  export  бул opIndex(т_мера i)
    in
    {
	assert(i < длин);
    }
    body
    {
	return cast(бул)bt(ptr, i);
    }

    /** ditto */
   export бул opIndexAssign(бул b, т_мера i)
    in
    {
	assert(i < длин);
    }
    body
    {
	if (b)
	    bts(ptr, i);
	else
	    btr(ptr, i);
	return b;
    }

   
	export МассивБит дубль()
	 {
	 return dup();
	 }
	 
    МассивБит dup()
    {
	МассивБит ba;

	бцел[] b = ptr[0 .. dim].dup;
	ba.длин = длин;
	ba.ptr = b.ptr;
	return ba;
    }

   export цел opApply(цел delegate(inout бул) дг)
    {
	цел результат;

	for (т_мера i = 0; i < длин; i++)
	{   бул b = opIndex(i);
	    результат = дг(b);
	    (*this)[i] = b;
	    if (результат)
		break;
	}
	return результат;
    }

  
   export цел opApply(цел delegate(inout т_мера, inout бул) дг)
    {
	цел результат;

	for (т_мера i = 0; i < длин; i++)
	{   бул b = opIndex(i);
	    результат = дг(i, b);
	    (*this)[i] = b;
	    if (результат)
		break;
	}
	return результат;
    }

	export МассивБит реверсни()
	{
	return  reverse();
	}
	
    МассивБит reverse()
	out (результат)
	{
	    assert(результат == *this);
	}
	body
	{
	    if (длин >= 2)
	    {
		бул t;
		т_мера lo, hi;

		lo = 0;
		hi = длин - 1;
		for (; lo < hi; lo++, hi--)
		{
		    t = (*this)[lo];
		    (*this)[lo] = (*this)[hi];
		    (*this)[hi] = t;
		}
	    }
	    return *this;
	}

  
	export МассивБит сортируй()
	{
	return sort();
	}
	
    МассивБит sort()
	out (результат)
	{
	    assert(результат == *this);
	}
	body
	{
	    if (длин >= 2)
	    {
		т_мера lo, hi;

		lo = 0;
		hi = длин - 1;
		while (1)
		{
		    while (1)
		    {
			if (lo >= hi)
			    goto Ldone;
			if ((*this)[lo] == да)
			    break;
			lo++;
		    }

		    while (1)
		    {
			if (lo >= hi)
			    goto Ldone;
			if ((*this)[hi] == нет)
			    break;
			hi--;
		    }

		    (*this)[lo] = нет;
		    (*this)[hi] = да;

		    lo++;
		    hi--;
		}
	    Ldone:
		;
	    }
	    return *this;
	}

    export цел opEquals(МассивБит a2)
    {   цел i;

	if (this.length != a2.length)
	    return 0;		// not equal
	байт *p1 = cast(байт*)this.ptr;
	байт *p2 = cast(байт*)a2.ptr;
	бцел n = this.length / 8;
	for (i = 0; i < n; i++)
	{
	    if (p1[i] != p2[i])
		return 0;		// not equal
	}

	ббайт маска;

	n = this.length & 7;
	маска = cast(ббайт)((1 << n) - 1);
	//prцелf("i = %d, n = %d, маска = %x, %x, %x\n", i, n, маска, p1[i], p2[i]);
	return (маска == 0) || (p1[i] & маска) == (p2[i] & маска);
    }

   export цел opCmp(МассивБит a2)
    {
	бцел длин;
	бцел i;

	длин = this.length;
	if (a2.length < длин)
	    длин = a2.length;
	ббайт* p1 = cast(ббайт*)this.ptr;
	ббайт* p2 = cast(ббайт*)a2.ptr;
	бцел n = длин / 8;
	for (i = 0; i < n; i++)
	{
	    if (p1[i] != p2[i])
		break;		// not equal
	}
	for (бцел j = i * 8; j < длин; j++)
	{   ббайт маска = cast(ббайт)(1 << j);
	    цел c;

	    c = cast(цел)(p1[i] & маска) - cast(цел)(p2[i] & маска);
	    if (c)
		return c;
	}
	return cast(цел)this.длин - cast(цел)a2.length;
    }

	export проц иниц(бул[] бм)
	{
	init(cast(бул[]) бм);
	}
	
    проц init(бул[] ba)
    {
	length = ba.length;
	foreach (i, b; ba)
	{
	    (*this)[i] = b;
	}
    }

	export проц иниц(проц[] в, т_мера члобит)
	{
	init(cast(проц[]) в, cast(т_мера) члобит);
	}
	
    проц init(проц[] v, т_мера numbits)
    in
    {
	assert(numbits <= v.length * 8);
	assert((v.length & 3) == 0);
    }
    body
    {
	ptr = cast(бцел*)v.ptr;
	длин = numbits;
    }

  export  проц[] opCast()
    {
	return cast(проц[])ptr[0 .. dim];
    }

    
  export  МассивБит opCom()
    {
	auto dim = this.dim();

	МассивБит результат;

	результат.length = длин;
	for (т_мера i = 0; i < dim; i++)
	    результат.ptr[i] = ~this.ptr[i];
	if (длин & 31)
	    результат.ptr[dim - 1] &= ~(~0 << (длин & 31));
	return результат;
    }

  export  МассивБит opAnd(МассивБит e2)
    in
    {
	assert(длин == e2.length);
    }
    body
    {
	auto dim = this.dim();

	МассивБит результат;

	результат.length = длин;
	for (т_мера i = 0; i < dim; i++)
	    результат.ptr[i] = this.ptr[i] & e2.ptr[i];
	return результат;
    }

    export МассивБит opOr(МассивБит e2)
    in
    {
	assert(длин == e2.length);
    }
    body
    {
	auto dim = this.dim();

	МассивБит результат;

	результат.length = длин;
	for (т_мера i = 0; i < dim; i++)
	    результат.ptr[i] = this.ptr[i] | e2.ptr[i];
	return результат;
    }

   export МассивБит opXor(МассивБит e2)
    in
    {
	assert(длин == e2.length);
    }
    body
    {
	auto dim = this.dim();

	МассивБит результат;

	результат.length = длин;
	for (т_мера i = 0; i < dim; i++)
	    результат.ptr[i] = this.ptr[i] ^ e2.ptr[i];
	return результат;
    }

  export  МассивБит opSub(МассивБит e2)
    in
    {
	assert(длин == e2.length);
    }
    body
    {
	auto dim = this.dim();

	МассивБит результат;

	результат.length = длин;
	for (т_мера i = 0; i < dim; i++)
	    результат.ptr[i] = this.ptr[i] & ~e2.ptr[i];
	return результат;
    }

   export МассивБит opAndAssign(МассивБит e2)
    in
    {
	assert(длин == e2.length);
    }
    body
    {
	auto dim = this.dim();

	for (т_мера i = 0; i < dim; i++)
	    ptr[i] &= e2.ptr[i];
	return *this;
    }

   export МассивБит opOrAssign(МассивБит e2)
    in
    {
	assert(длин == e2.length);
    }
    body
    {
	auto dim = this.dim();

	for (т_мера i = 0; i < dim; i++)
	    ptr[i] |= e2.ptr[i];
	return *this;
    }

   export МассивБит opXorAssign(МассивБит e2)
    in
    {
	assert(длин == e2.length);
    }
    body
    {
	auto dim = this.dim();

	for (т_мера i = 0; i < dim; i++)
	    ptr[i] ^= e2.ptr[i];
	return *this;
    }

   export МассивБит opSubAssign(МассивБит e2)
    in
    {
	assert(длин == e2.length);
    }
    body
    {
	auto dim = this.dim();

	for (т_мера i = 0; i < dim; i++)
	    ptr[i] &= ~e2.ptr[i];
	return *this;
    }

    export МассивБит opCatAssign(бул b)
    {
	length = длин + 1;
	(*this)[длин - 1] = b;
	return *this;
    }

   export МассивБит opCatAssign(МассивБит b)
    {
	auto istart = длин;
	length = длин + b.length;
	for (auto i = istart; i < длин; i++)
	    (*this)[i] = b[i - istart];
	return *this;
    }

   export МассивБит opCat(бул b)
    {
	МассивБит r;

	r = this.dup;
	r.length = длин + 1;
	r[длин] = b;
	return r;
    }

   export МассивБит opCat_r(бул b)
    {
	МассивБит r;

	r.length = длин + 1;
	r[0] = b;
	for (т_мера i = 0; i < длин; i++)
	    r[1 + i] = (*this)[i];
	return r;
    }

  export  МассивБит opCat(МассивБит b)
    {
	МассивБит r;

	r = this.dup();
	r ~= b;
	return r;
    }

}/////end of class

МассивБит вМасБит(std.bitarray.BitArray ба)
	{
	МассивБит рез;
	рез.длин = ба.длин;
	рез.укз = ба.ptr;
	return  рез;
	}
	
BitArray изМасБита(МассивБит мб)
	{
	std.bitarray.BitArray рез;
	рез.длин = мб.длин;
	рез.ptr = мб.укз;
	return  рез;
	}

/*************************/
////////////////////////////////////////////
import std.string, std.utf;

export extern(D)
{	/////////////////////////////////
	бул пробел_ли(дим т)
	{
	return cast(бул)(std.string.iswhite(cast(дим) т));
	}
	/////////////////////////////
	дол ткствцел(ткст т)
	{
	return cast(дол)(std.string.atoi(cast(сим[]) т));
	}
	/////////////////////////////////
	реал ткствдробь(ткст т)
	{
	return cast(реал)(std.string.atof(cast(сим[]) т));
	}
	/////////////////////////////////////
	цел сравни(ткст s1, ткст s2)
	{
	return cast(цел)(std.string.cmp(cast(сим[]) s1, cast(сим[]) s2));
	}
	///////////////////////////////////////
	цел сравнлюб(ткст s1, ткст s2)
	{
	return cast(цел)(std.string.icmp(cast(сим[]) s1, cast(сим[]) s2));
	}
	/////////////////////////////////////////////
	сим* вТкст0(ткст т)
	{
	return cast(сим*)(std.string.toStringz(cast(сим[]) т));
	}
	/////////////////////////////////////////////
	цел найди(ткст т, дим c)
	{
	return cast(цел)(std.string.find(cast(сим[]) т, cast(дим) c));
	}
	/////////////////////////////////////////////////
	цел найдлюб(ткст т, дим c)
	{
	return cast(цел)(std.string.ifind(cast(сим[]) т, cast(дим) c));
	}
	////////////////////////////////////////////////
	цел найдрек(ткст т, дим c)
	{
	return cast(цел)(std.string.rfind(cast(сим[]) т, cast(дим) c));
	}
	///////////////////////////////////////////////
	цел найдлюбрек(ткст т, дим c)
	{
	return cast(цел)(std.string.irfind(cast(сим[]) т, cast(дим) c));
	}
	/////////////////////////////////////////////////
	цел найди(ткст т, ткст тзам)
	{
	return cast(цел)(std.string.find(cast(сим[]) т, cast(сим[]) тзам));
	}
	/////////////////////////////////////////////////
	цел найдлюб(ткст т, ткст тзам)
	{
	return  cast(цел)(std.string.ifind(cast(сим[]) т, cast(сим[]) тзам));
	}
	/////////////////////////////////////////////////
	цел найдрек(ткст т, ткст тзам)
	{
	return  cast(цел)(std.string.rfind(cast(сим[]) т, cast(сим[]) тзам));
	}
	///////////////////////////////////////////////
	цел найдлюбрек(ткст т, ткст тзам)
	{
	return  cast(цел)(std.string.irfind(cast(сим[]) т, cast(сим[]) тзам));
	}
	//////////////////////////////////////////////
	ткст впроп(ткст т)
	{
	return cast(ткст)(std.string.tolower(cast(ткст) т));
	}
	//////////////////////////////////////////////////
	ткст взаг(ткст т)
	{
	return cast(ткст)(std.string.toupper(cast(ткст) т));
	}
	////////////////////////////////////////////////////
	ткст озаг(ткст т){return std.string.capitalize(т);}
	////////////////////////////////////////////////////
	ткст озагслова(ткст т){return std.string.capwords(т);}
	/////////////////////////////////////////////
	ткст повтори(ткст т, т_мера м){return std.string.repeat(т, м);}
	///////////////////////////////////////////
	ткст объедини(ткст[] слова, ткст разд){return  std.string.join(слова, разд);}
	///////////////////////////////////////
	ткст[] разбей(ткст т){ткст м_т = т; return std.string.split(м_т);}
	ткст[] разбейдоп(ткст т, ткст разделитель){ткст м_т = т; ткст м_разделитель = разделитель; return std.string.split(м_т, м_разделитель);}
	//////////////////////////////
	ткст[] разбейнастр(ткст т){return std.string.splitlines(т);}
	////////////////////////
	ткст уберислева(ткст т){return  std.string.stripl(т);}
	ткст уберисправа(ткст т){return  std.string.stripr(т);}
	ткст убери(ткст т){return  std.string.strip(т);}
	///////////////////////////
	ткст убериразгр(ткст т){return  std.string.chomp(т);}
	ткст уберигран(ткст т){return  std.string.chop(т);}
	/////////////////
	ткст полев(ткст т, цел ширина){return  ljustify(т, ширина);}
	ткст поправ(ткст т, цел ширина){return  rjustify(т, ширина);}
	ткст вцентр(ткст т, цел ширина){return  center(т, ширина);}
	ткст занули(ткст т, цел ширина){return  zfill(т, ширина);}
	
	ткст замени(ткст т, ткст с, ткст на){ ткст м_т = т.dup; ткст м_с = т.dup; ткст м_на = т.dup; return  std.string.replace(м_т, м_с, м_на);}
	ткст заменисрез(ткст т, ткст срез, ткст замена){ткст м_т = т; ткст м_срез = срез; ткст м_замена = замена; return  std.string.replaceSlice(м_т, м_срез, м_замена);}
	ткст вставь(ткст т, т_мера индекс, ткст подст){ return  std.string.insert(т, индекс, подст);}
	т_мера счесть(ткст т, ткст подст){return  std.string.count(т, подст);}


	ткст заменитабнапбел(ткст стр, цел размтаб=8){return std.string.expandtabs(стр, размтаб);}
	ткст заменипбелнатаб(ткст стр, цел размтаб=8){return std.string.entab(стр, размтаб);}
	ткст постройтранстаб(ткст из, ткст в){return maketrans(из, в);}
	ткст транслируй(ткст т, ткст табтранс, ткст удсим){return translate(т, табтранс, удсим);}
		

	т_мера посчитайсимв(ткст т, ткст образец){return  std.string.countchars(т, образец);}
	ткст удалисимв(ткст т, ткст образец){return  std.string.removechars(т, образец);}
	ткст сквиз(ткст т, ткст образец= null){return  std.string.squeeze(cast(сим[]) т, cast(сим[]) образец);}
	ткст следщ(ткст т){return std.string.succ(т);}
	
	ткст тз(ткст ткт, ткст из, ткст в, ткст модифф = null){return std.string.tr(ткт, из, в, модифф);}
	бул чис_ли(in ткст т, in бул раздВкл = false){return cast(бул) std.string.isNumeric(т, раздВкл);}
	т_мера колном(ткст ткт, цел размтаб=8){return std.string.column(ткт, размтаб);}
	ткст параграф(ткст т, цел колонки = 80, ткст первотступ = null, ткст отступ = null, цел размтаб = 8){return std.string.wrap(т, колонки, первотступ, отступ, размтаб);}
	ткст эладр_ли(ткст т){return  std.string.isEmail(т);}
	ткст урл_ли(ткст т){return  std.string.isURL(т);}
	ткст целВЮ8(ткст врем, бцел знач){return std.string.intToUtf8(врем, знач);}
	ткст бдолВЮ8(ткст врем, бцел знач){return std.string.ulongToUtf8(врем, знач);}

import std.conv;

	цел вЦел(ткст т){return std.conv.toInt(т);}
	бцел вБцел(ткст т){return std.conv.toUint(т);}
	дол вДол(ткст т){return std.conv.toLong(т);}
	бдол вБдол(ткст т){return std.conv.toUlong(т);}
	крат вКрат(ткст т){return std.conv.toShort(т);}
	бкрат вБкрат(ткст т){return std.conv.toUshort(т);}  
	байт вБайт(ткст т){return std.conv.toByte(т);}
	ббайт вБбайт(ткст т){return std.conv.toUbyte(т);} 
	плав вПлав(ткст т){return std.conv.toFloat(т);}   
	дво вДво(ткст т){return std.conv.toDouble(т);} 
	реал вРеал(ткст т){return std.conv.toReal(т);}

}///extern C
////////////////////////////

enum ПМангл : сим
{
    Тпроц     = 'v',
    Тбул     = 'b',
    Тбайт     = 'g',
    Тббайт    = 'h',
    Ткрат    = 's',
    Тбкрат   = 't',
    Тцел      = 'i',
    Тбцел     = 'k',
    Тдол     = 'l',
    Тбдол    = 'm',
    Тплав    = 'f',
    Тдво   = 'd',
    Треал     = 'e',

    Твплав   = 'o',
    Твдво  = 'p',
    Твреал    = 'j',
    Ткплав   = 'q',
    Ткдво  = 'r',
    Ткреал    = 'c',

    Тсим     = 'a',
    Тшим    = 'u',
    Тдим    = 'w',

    Тмассив    = 'A',
    Тсмассив   = 'G',
    Тамассив   = 'H',
    Туказатель  = 'P',
    Тфункция = 'F',
    Тидент    = 'I',
    Ткласс    = 'C',
    Тструкт   = 'S',
    Тперечень     = 'E',
    Ттипдеф  = 'T',
    Тделегат = 'D',

    Тконст    = 'x',
    Тинвариант = 'y',
}

/**
 * The exception thrown when the format of an argument does not meet the parameter specifications of the invoked method.
 */
export extern (D) class ФорматИскл : Исключение {

  private static const E_FORMAT = "Значение в неправильном формате.";
export:
  this() {
    super(E_FORMAT);
  }

  this(ткст сооб) {
    super("Несовпадение формата с заданным аргументом: "~сооб);
  }

}

export extern(D) ИнфОТипе простаяИнфОТипе(ПМангл м) 
{
  ИнфОТипе ti;

  switch (м)
    {
    case ПМангл.Тпроц:
      ti = typeid(проц);break;
    case ПМангл.Тбул:
      ti = typeid(бул);break;
    case ПМангл.Тбайт:
      ti = typeid(байт);break;
    case ПМангл.Тббайт:
      ti = typeid(ббайт);break;
    case ПМангл.Ткрат:
      ti = typeid(крат);break;
    case ПМангл.Тбкрат:
      ti = typeid(бкрат);break;
    case ПМангл.Тцел:
      ti = typeid(цел);break;
    case ПМангл.Тбцел:
      ti = typeid(бцел);break;
    case ПМангл.Тдол:
      ti = typeid(дол);break;
    case ПМангл.Тбдол:
      ti = typeid(бдол);break;
    case ПМангл.Тплав:
      ti = typeid(плав);break;
    case ПМангл.Тдво:
      ti = typeid(дво);break;
    case ПМангл.Треал:
      ti = typeid(реал);break;
    case ПМангл.Твплав:
      ti = typeid(вплав);break;
    case ПМангл.Твдво:
      ti = typeid(вдво);break;
    case ПМангл.Твреал:
      ti = typeid(вреал);break;
    case ПМангл.Ткплав:
      ti = typeid(кплав);break;
    case ПМангл.Ткдво:
      ti = typeid(кдво);break;
    case ПМангл.Ткреал:
      ti = typeid(креал);break;
    case ПМангл.Тсим:
      ti = typeid(сим);break;
    case ПМангл.Тшим:
      ti = typeid(шим);break;
    case ПМангл.Тдим:
      ti = typeid(дим);break;
    default:
      ti = null;
    }
  return ti;
}

version (Windows)
{
    version (DigitalMars)
    {
	version = DigitalMarsC;
    }
}

version (DigitalMarsC)
{
    // This is DMC'т internal floating poцел formatting function
    extern  (C)
    {
	extern  сим* function(цел c, цел флаги, цел точность, реал* pdзнач,
	    сим* буф, цел* psl, цел width) __pfloatfmt;
    }
}
else
{
    // Use C99 snprцелf
    extern  (C) цел snprintf(сим* т, т_мера n, сим* format, ...);
}

export extern(D)
{
	ткст вТкст(бул с){return std.string.toString(с);}
	ткст вТкст(сим с)
	{
		ткст результат = new сим[2];
		результат[0] = с;
		результат[1] = 0;
		return результат[0 .. 1];
	}
	ткст вТкст(ббайт с){return std.string.toString(с);}
	ткст вТкст(бкрат с){return std.string.toString(с);}
	ткст вТкст(бцел с){return std.string.toString(с);}
	ткст вТкст(бдол с){return std.string.toString(с);}
	ткст вТкст(байт с){return std.string.toString(с);}
	ткст вТкст(крат с){return std.string.toString(с);}
	ткст вТкст(цел с){return std.string.toString(с);}
	ткст вТкст(дол с){return std.string.toString(с);}
	ткст вТкст(плав с){return std.string.toString(с);}
	ткст вТкст(дво с){return std.string.toString(с);}
	ткст вТкст(реал с){return std.string.toString(с);}
	ткст вТкст(вплав с){return std.string.toString(с);}
	ткст вТкст(вдво с){return std.string.toString(с);}
	ткст вТкст(вреал с){return std.string.toString(с);}
	ткст вТкст(кплав с){return std.string.toString(с);}
	ткст вТкст(кдво с){return std.string.toString(с);}
	ткст вТкст(креал с){return std.string.toString(с);}
	ткст вТкст(дол знач, бцел корень){return std.string.toString(знач, корень);}
	ткст вТкст(бдол знач, бцел корень){return std.string.toString(знач, корень);}
	ткст вТкст(сим *с){return std.string.toString(с);}
	

проц форматДелай(проц delegate(дим) putc, ИнфОТипе[] arguments, спис_ва argptr)
	{
	цел j;
    ИнфОТипе ti;
    ПМангл m;
    бцел флаги;
    цел ширина_поля;
    цел точность;

    enum : бцел
    {
	FLdash = 1,
	FLplus = 2,
	FLspace = 4,
	FLhash = 8,
	FLlngdbl = 0x20,
	FL0pad = 0x40,
	FLprecision = 0x80,
    }
    
    static ИнфОТипе skipCI(ИнфОТипе типзнач)
    {
      while (1)
      {
	if (типзнач.classinfo.name.length == 18 &&  типзнач.classinfo.name[9..18] == "Invariant")
	    типзнач =	(cast(TypeInfo_Invariant)типзнач).следщ;
	else if (типзнач.classinfo.name.length == 14 && типзнач.classinfo.name[9..14] == "Const")
	    типзнач =	(cast(TypeInfo_Const)типзнач).следщ;
	else
	    break;
      }
      return типзнач;
    }

    проц formatArg(сим fc)
    {
	бул vbit;
	бдол vnumber;
	сим vchar;
	дим vdchar;
	Объект vobject;
	реал vreal;
	креал vcreal;
	ПМангл m2;
	цел signed = 0;
	бцел base = 10;
	цел uc;
	сим[бдол.sizeof * 8] tmpbuf;	// дол enough to print дол in binary
	сим* prefix = "";
	ткст т;

	проц putstr(ткст т)
	{
	    //эхо("флаги = x%x\n", флаги);
		//win.скажинс(т);
	    цел prepad = 0;
	    цел postpad = 0;
		цел padding = ширина_поля - (std.c.strlen(prefix) + т.length);//toUCSindex(т, т.length));
	    if (padding > 0)
	    {
		if (флаги & FLdash)
		    postpad = padding;
		else
		    prepad = padding;
	    }

	    if (флаги & FL0pad)
	    {
		while (*prefix)
		    putc(*prefix++);
		while (prepad--)
		    putc('0');
	    }
	    else
	    {
		while (prepad--)
		    putc(' ');
		while (*prefix)
		    putc(*prefix++);
	    }

	    foreach (дим c; т)
		putc(c);

	    while (postpad--)
		putc(' ');
	}

	проц putreal(реал v)
	{
	    //эхо("putreal %Lg\n", vreal);

	    switch (fc)
	    {
		case 's':
		    fc = 'g';
		    break;

		case 'f', 'F', 'e', 'E', 'g', 'G', 'a', 'A':
		    break;

		default:
		    //эхо("fc = '%c'\n", fc);
		Lerror:
		    throw new Exception("плавающая запятая");
	    }
	    version (DigitalMarsC)
	    {
		цел sl;
		ткст fbuf = tmpbuf;
		if (!(флаги & FLprecision))
		    точность = 6;
		while (1)
		{
		    sl = fbuf.length;
		    prefix = (*__pfloatfmt)(fc, флаги | FLlngdbl,
			    точность, &v, cast(сим*)fbuf, &sl, ширина_поля);
		    if (sl != -1)
			break;
		    sl = fbuf.length * 2;
		    fbuf = (cast(сим*)std.c.alloca(sl * сим.sizeof))[0 .. sl];
		}
		debug(PutStr) win.скажинс("путстр1");
		putstr(fbuf[0 .. sl]);
	    }
	    else
	    {
		цел sl;
		ткст fbuf = tmpbuf;
		сим[12] format;
		format[0] = '%';
		цел i = 1;
		if (флаги & FLdash)
		    format[i++] = '-';
		if (флаги & FLplus)
		    format[i++] = '+';
		if (флаги & FLspace)
		    format[i++] = ' ';
		if (флаги & FLhash)
		    format[i++] = '#';
		if (флаги & FL0pad)
		    format[i++] = '0';
		format[i + 0] = '*';
		format[i + 1] = '.';
		format[i + 2] = '*';
		format[i + 3] = 'L';
		format[i + 4] = fc;
		format[i + 5] = 0;
		if (!(флаги & FLprecision))
		    точность = -1;
		while (1)
		{   цел n;

		    sl = fbuf.length;
		    n = snprintf(fbuf.ptr, sl, format.ptr, ширина_поля, точность, v);
		    //эхо("format = '%s', n = %d\n", cast(сим*)format, n);
		    if (n >= 0 && n < sl)
		    {	sl = n;
			break;
		    }
		    if (n < 0)
			sl = sl * 2;
		    else
			sl = n + 1;
		    fbuf = (cast(сим*)std.c.разместа(sl * сим.sizeof))[0 .. sl];
		}
		debug(PutStr) win.скажинс("путстр2");
		putstr(fbuf[0 .. sl]);
	    }
	    return;
	}

	static ПМангл getMan(ИнфОТипе ti)
	{
	  auto m = cast(ПМангл)ti.classinfo.name[9];
	  if (ti.classinfo.name.length == 20 &&
	      ti.classinfo.name[9..20] == "StaticArray")
		m = cast(ПМангл)'G';
	  return m;
	}

	проц putArray(ук p, т_мера длин, ИнфОТипе типзнач)
	{
	  //эхо("\nputArray(длин = %u), tsize = %u\n", длин, типзнач.tsize());
	  putc('[');
	  типзнач = skipCI(типзнач);
	  т_мера tsize = типзнач.tsize();
	  auto argptrSave = argptr;
	  auto tiSave = ti;
	  auto mSave = m;
	  ti = типзнач;
	  //эхо("\n%.*т\n", типзнач.classinfo.name);
	  m = getMan(типзнач);
	  while (длин--)
	  {
	    //doFormat(putc, (&типзнач)[0 .. 1], p);
	    argptr = p;
	    formatArg('s');

	    p += tsize;
	    if (длин > 0) putc(',');
	  }
	  m = mSave;
	  ti = tiSave;
	  argptr = argptrSave;
	  putc(']');
	}

	проц putAArray(ббайт[дол] vaa, ИнфОТипе типзнач, ИнфОТипе keyti)
	{
	  putc('[');
	  бул comma=нет;
	  auto argptrSave = argptr;
	  auto tiSave = ti;
	  auto mSave = m;
	  типзнач = skipCI(типзнач);
	  keyti = skipCI(keyti);
	  foreach(inout fakevalue; vaa)
	  {
	    if (comma) putc(',');
	    comma = да;
	    // the key comes before the значение
	    ббайт* key = &fakevalue - дол.sizeof;

	    //doFormat(putc, (&keyti)[0..1], key);
	    argptr = key;
	    ti = keyti;
	    m = getMan(keyti);
	    formatArg('s');

	    putc(':');
	    auto keysize = keyti.tsize;
	    keysize = (keysize + 3) & ~3;
	    ббайт* значение = key + keysize;
	    //doFormat(putc, (&типзнач)[0..1], значение);
	    argptr = значение;
	    ti = типзнач;
	    m = getMan(типзнач);
	    formatArg('s');
	  }
	  m = mSave;
	  ti = tiSave;
	  argptr = argptrSave;
	  putc(']');
	}

	alias va_arg ва_арг;
	//эхо("formatArg(fc = '%c', m = '%c')\n", fc, m);
	switch (m)
	{
	    case ПМангл.Тбул:
		vbit = ва_арг!(бул)(argptr);
		if (fc != 's')
		{   vnumber = vbit;
		    goto Lnumber;
		}
		debug(PutStr) win.скажинс("путстр3");
		putstr(vbit ? "да" : "нет");
		return;


	    case ПМангл.Тсим:
		vchar = ва_арг!(сим)(argptr);
		if (fc != 's')
		{   vnumber = vchar;
		    goto Lnumber;
		}
	    L2:
		debug(PutStr) win.скажинс("путстр4");
		putstr((&vchar)[0 .. 1]);
		return;

	    case ПМангл.Тшим:
		vdchar = ва_арг!(шим)(argptr);
		goto L1;

	    case ПМангл.Тдим:
		vdchar = ва_арг!(дим)(argptr);
	    L1:
		if (fc != 's')
		{   vnumber = vdchar;
		    goto Lnumber;
		}
		if (vdchar <= 0x7F)
		{   vchar = cast(сим)vdchar;
		    goto L2;
		}
		else
		{   if (!isValidDchar(vdchar))
			throw new Исключение("Неверный дим в формате",__FILE__, __LINE__);
		    сим[4] vbuf;
			debug(PutStr) win.скажинс("путстр5");
		    putstr(toUTF8(vbuf, vdchar));
		}
		return;


	    case ПМангл.Тбайт:
		signed = 1;
		vnumber = ва_арг!(байт)(argptr);
		goto Lnumber;

	    case ПМангл.Тббайт:
		vnumber = ва_арг!(ббайт)(argptr);
		goto Lnumber;

	    case ПМангл.Ткрат:
		signed = 1;
		vnumber = ва_арг!(крат)(argptr);
		goto Lnumber;

	    case ПМангл.Тбкрат:
		vnumber = ва_арг!(бкрат)(argptr);
		goto Lnumber;

	    case ПМангл.Тцел:
		signed = 1;
		vnumber = ва_арг!(цел)(argptr);
		goto Lnumber;

	    case ПМангл.Тбцел:
	    Luцел:
		vnumber = ва_арг!(бцел)(argptr);
		goto Lnumber;

	    case ПМангл.Тдол:
		signed = 1;
		vnumber = cast(бдол)ва_арг!(дол)(argptr);
		goto Lnumber;

	    case ПМангл.Тбдол:
	    Lбдол:
		vnumber = ва_арг!(бдол)(argptr);
		goto Lnumber;

	    case ПМангл.Ткласс:
		vobject = ва_арг!(Объект)(argptr);
		if (vobject is null)
		    т = "null";
		else
		    т = vobject.toString();
		goto Lputstr;

	    case ПМангл.Туказатель:
		vnumber = cast(бдол)ва_арг!(проц*)(argptr);
		if (fc != 'x' && fc != 'X')		uc = 1;
		флаги |= FL0pad;
		if (!(флаги & FLprecision))
		{   флаги |= FLprecision;
		    точность = (проц*).sizeof;
		}
		base = 16;
		goto Lnumber;


	    case ПМангл.Тплав:
	    case ПМангл.Твплав:
		if (fc == 'x' || fc == 'X')
		    goto Luцел;
		vreal = ва_арг!(плав)(argptr);
		goto Lreal;

	    case ПМангл.Тдво:
	    case ПМангл.Твдво:
		if (fc == 'x' || fc == 'X')
		    goto Lбдол;
		vreal = ва_арг!(дво)(argptr);
		goto Lreal;

	    case ПМангл.Треал:
	    case ПМангл.Твреал:
		vreal = ва_арг!(реал)(argptr);
		goto Lreal;


	    case ПМангл.Ткплав:
		vcreal = ва_арг!(кплав)(argptr);
		goto Lcomplex;

	    case ПМангл.Ткдво:
		vcreal = ва_арг!(кдво)(argptr);
		goto Lcomplex;

	    case ПМангл.Ткреал:
		vcreal = ва_арг!(креал)(argptr);
		goto Lcomplex;

	    case ПМангл.Тсмассив:
		putArray(argptr, (cast(TypeInfo_StaticArray)ti).длин, (cast(TypeInfo_StaticArray)ti).следщ);
		return;

	    case ПМангл.Тмассив:
		цел mi = 10;
	        if (ti.classinfo.name.length == 14 &&
		    ti.classinfo.name[9..14] == "Array") 
		{ // array of non-primitive types
		  ИнфОТипе tn = (cast(TypeInfo_Array)ti).следщ;
		  tn = skipCI(tn);
		  switch (cast(ПМангл)tn.classinfo.name[9])
		  {
		    case ПМангл.Тсим:  goto LarrayChar;
		    case ПМангл.Тшим: goto LarrayWchar;
		    case ПМангл.Тдим: goto LarrayDchar;
		    default:
			break;
		  }
		  проц[] va = ва_арг!(проц[])(argptr);
		  putArray(va.ptr, va.length, tn);
		  return;
		}
		if (ti.classinfo.name.length == 25 &&
		    ti.classinfo.name[9..25] == "AssociativeArray") 
		{ // associative array
		  ббайт[дол] vaa = ва_арг!(ббайт[дол])(argptr);
		  putAArray(vaa,
			(cast(TypeInfo_AssociativeArray)ti).следщ,
			(cast(TypeInfo_AssociativeArray)ti).key);
		  return;
		}

		while (1)
		{
		    m2 = cast(ПМангл)ti.classinfo.name[mi];
		    switch (m2)
		    {
			case ПМангл.Тсим:
			LarrayChar:
			    т = ва_арг!(ткст)(argptr);
			    goto Lputstr;

			case ПМангл.Тшим:
			LarrayWchar:
			    шим[] sw = ва_арг!(wstring)(argptr);
			    т = toUTF8(sw);
			    goto Lputstr;

			case ПМангл.Тдим:
			LarrayDchar:
			    дим[] sd = ва_арг!(dstring)(argptr);
			    т = toUTF8(sd);
			Lputstr:
			    if (fc != 's')
				{
				throw new ФорматИскл("ткст");
				}
			    if (флаги & FLprecision && точность < т.length)
				т = т[0 .. точность];
				debug(PutStr) win.скажинс("путстр6");
			    putstr(т);
			    break;

			case ПМангл.Тконст:
			case ПМангл.Тинвариант:
			    mi++;
			    continue;

			default:
			    ИнфОТипе ti2 = простаяИнфОТипе(m2);
			    if (!ti2)
			      goto Lerror;
			    проц[] va = ва_арг!(проц[])(argptr);
			    putArray(va.ptr, va.length, ti2);
		    }
		    return;
		}

	    case ПМангл.Ттипдеф:
		ti = (cast(TypeInfo_Typedef)ti).base;
		m = cast(ПМангл)ti.classinfo.name[9];
		formatArg(fc);
		return;

	    case ПМангл.Тперечень:
		ti = (cast(TypeInfo_Enum)ti).base;
		m = cast(ПМангл)ti.classinfo.name[9];
		formatArg(fc);
		return;

	    case ПМангл.Тструкт:
	    {	TypeInfo_Struct tis = cast(TypeInfo_Struct)ti;
		if (tis.xtoString is null)
		    throw new ФорматИскл("Не удаётся преобразовать " ~ tis.toString() ~ " в ткст: функция \"ткст вТкст()\" не определена");
		т = tis.xtoString(argptr);
		argptr += (tis.tsize() + 3) & ~3;
		goto Lputstr;
	    }

	    default:
		goto Lerror;
	}

    Lnumber:
	switch (fc)
	{
	    case 's':
	    case 'd':
		if (signed)
		{   if (cast(дол)vnumber < 0)
		    {	prefix = "-";
			vnumber = -vnumber;
		    }
		    else if (флаги & FLplus)
			prefix = "+";
		    else if (флаги & FLspace)
			prefix = " ";
		}
		break;

	    case 'b':
		signed = 0;
		base = 2;
		break;

	    case 'o':
		signed = 0;
		base = 8;
		break;

	    case 'X':
		uc = 1;
		if (флаги & FLhash && vnumber)
		    prefix = "0X";
		signed = 0;
		base = 16;
		break;

	    case 'x':
		if (флаги & FLhash && vnumber)
		    prefix = "0x";
		signed = 0;
		base = 16;
		break;

	    default:
		goto Lerror;
	}

	if (!signed)
	{
	    switch (m)
	    {
		case ПМангл.Тбайт:
		    vnumber &= 0xFF;
		    break;

		case ПМангл.Ткрат:
		    vnumber &= 0xFFFF;
		    break;

		case ПМангл.Тцел:
		    vnumber &= 0xFFFFFFFF;
		    break;

		default:
		    break;
	    }
	}

	if (флаги & FLprecision && fc != 'p')
	    флаги &= ~FL0pad;

	if (vnumber < base)
	{
	    if (vnumber == 0 && точность == 0 && флаги & FLprecision &&
		!(fc == 'o' && флаги & FLhash))
	    {
		debug(PutStr) win.скажинс("путстр7");
		putstr(null);
		return;
	    }
	    if (точность == 0 || !(флаги & FLprecision))
	    {	vchar = cast(сим)('0' + vnumber);
		if (vnumber < 10)
		    vchar = cast(сим)('0' + vnumber);
		else
		    vchar = cast(сим)((uc ? 'A' - 10 : 'a' - 10) + vnumber);
		goto L2;
	    }
	}

	цел n = tmpbuf.length;
	сим c;
	цел hexсмещение = uc ? ('A' - ('9' + 1)) : ('a' - ('9' + 1));

	while (vnumber)
	{
	    c = cast(сим)((vnumber % base) + '0');
	    if (c > '9')
		c += hexсмещение;
	    vnumber /= base;
	    tmpbuf[--n] = c;
	}
	if (tmpbuf.length - n < точность && точность < tmpbuf.length)
	{
	    цел m = tmpbuf.length - точность;
	    tmpbuf[m .. n] = '0';
	    n = m;
	}
	else if (флаги & FLhash && fc == 'o')
	    prefix = "0";
		debug(PutStr) win.скажинс("путстр8");
	putstr(tmpbuf[n .. tmpbuf.length]);
	return;

    Lreal:
	putreal(vreal);
	return;

    Lcomplex:
	putreal(vcreal.re);
	putc('+');
	putreal(vcreal.im);
	putc('i');
	return;

    Lerror:
	throw new ФорматИскл("\n\tформат аргумента неправильно указан");
    }


    for (j = 0; j < arguments.length; )
    {	ti = arguments[j++];
	//эхо("test1: '%.*т' %d\n", ti.classinfo.name, ti.classinfo.name.length);
	//ti.print();

	флаги = 0;
	точность = 0;
	ширина_поля = 0;

	ti = skipCI(ti);
	цел mi = 9;
	do
	{
	    if (ti.classinfo.name.length <= mi)
		goto Lerror;
	    m = cast(ПМангл)ti.classinfo.name[mi++];
	} while (m == ПМангл.Тконст || m == ПМангл.Тинвариант);

	if (m == ПМангл.Тмассив)
	{
	    if (ti.classinfo.name.length == 14 &&
		ti.classinfo.name[9..14] == "Array") 
	    {
	      ИнфОТипе tn = (cast(TypeInfo_Array)ti).следщ;
	      tn = skipCI(tn);
	      switch (cast(ПМангл)tn.classinfo.name[9])
	      {
		case ПМангл.Тсим:
		case ПМангл.Тшим:
		case ПМангл.Тдим:
		    ti = tn;
		    mi = 9;
		    break;
		default:
		    break;
	      }
	    }
	L1:
	    ПМангл m2 = cast(ПМангл)ti.classinfo.name[mi];
	    ткст  fmt;			// format ткст
	    wstring wfmt;
	    dstring dfmt;

	    /* For performance причины, this код takes advantage of the
	     * fact that most format strings will be ASCII, and that the
	     * format specifiers are always ASCII. This means we only need
	     * to deal with UTF in a couple of isolated spots.
	     */

	    switch (m2)
	    {
		case ПМангл.Тсим:
		    fmt = ва_арг!(ткст)(argptr);
		    break;

		case ПМангл.Тшим:
		    wfmt = ва_арг!(wstring)(argptr);
		    fmt = toUTF8(wfmt);
		    break;

		case ПМангл.Тдим:
		    dfmt = ва_арг!(dstring)(argptr);
		    fmt = toUTF8(dfmt);
		    break;

		case ПМангл.Тконст:
		case ПМангл.Тинвариант:
		    mi++;
		    goto L1;

		default:
		    formatArg('s');
		    continue;
	    }

	    for (т_мера i = 0; i < fmt.length; )
	    {	дим c = fmt[i++];

		дим getFmtChar()
		{   // Valid format specifier символs will never be UTF
		    if (i == fmt.length)
			throw new ФорматИскл("Неверный спецификатор");
		    return fmt[i++];
		}

		цел getFmtInt()
		{   цел n;

		    while (1)
		    {
			n = n * 10 + (c - '0');
			if (n < 0)	// overflow
			    throw new ФорматИскл("Превышение размера цел");
			c = getFmtChar();
			if (c < '0' || c > '9')
			    break;
		    }
		    return n;
		}

		цел getFmtStar()
		{   ПМангл m;
		    ИнфОТипе ti;

		    if (j == arguments.length)
			throw new ФорматИскл("Недостаточно аргументов");
		    ti = arguments[j++];
		    m = cast(ПМангл)ti.classinfo.name[9];
		    if (m != ПМангл.Тцел)
			throw new ФорматИскл("Ожидался аргумент типа цел");
		    return ва_арг!(цел)(argptr);
		}

		if (c != '%')
		{
		    if (c > 0x7F)	// if UTF sequence
		    {
			i--;		// back up and decode UTF sequence
			c = std.utf.decode(fmt, i);
		    }
		Lputc:
		    putc(c);
		    continue;
		}

		// Get флаги {-+ #}
		флаги = 0;
		while (1)
		{
		    c = getFmtChar();
		    switch (c)
		    {
			case '-':	флаги |= FLdash;	continue;
			case '+':	флаги |= FLplus;	continue;
			case ' ':	флаги |= FLspace;	continue;
			case '#':	флаги |= FLhash;	continue;
			case '0':	флаги |= FL0pad;	continue;

			case '%':	if (флаги == 0)
					    goto Lputc;
			default:	break;
		    }
		    break;
		}

		// Get field width
		ширина_поля = 0;
		if (c == '*')
		{
		    ширина_поля = getFmtStar();
		    if (ширина_поля < 0)
		    {   флаги |= FLdash;
			ширина_поля = -ширина_поля;
		    }

		    c = getFmtChar();
		}
		else if (c >= '0' && c <= '9')
		    ширина_поля = getFmtInt();

		if (флаги & FLplus)
		    флаги &= ~FLspace;
		if (флаги & FLdash)
		    флаги &= ~FL0pad;

		// Get точность
		точность = 0;
		if (c == '.')
		{   флаги |= FLprecision;
		    //флаги &= ~FL0pad;

		    c = getFmtChar();
		    if (c == '*')
		    {
			точность = getFmtStar();
			if (точность < 0)
			{   точность = 0;
			    флаги &= ~FLprecision;
			}

			c = getFmtChar();
		    }
		    else if (c >= '0' && c <= '9')
			точность = getFmtInt();
		}

		if (j == arguments.length)
		    goto Lerror;
		ti = arguments[j++];
		ti = skipCI(ti);
		mi = 9;
		do
		{
		    m = cast(ПМангл)ti.classinfo.name[mi++];
		} while (m == ПМангл.Тконст || m == ПМангл.Тинвариант);

		if (c > 0x7F)		// if UTF sequence
		    goto Lerror;	// format specifiers can't be UTF
		formatArg(cast(сим)c);
	    }
	}
	else
	{
	    formatArg('s');
	}
    }
    return;

Lerror:
    throw new ФорматИскл();
}
	
}//end of extern D
//////////////////////////////////

export extern(D)
{

import std.random;

	проц случсей(бцел семя, бцел индекс){std.random.rand_seed(cast(бцел) семя, cast(бцел) индекс);}
	бцел случайно(){return cast(бцел) std.random.rand();}
	бцел случген(бцел семя, бцел индекс, реал члоциклов)
		{
		return cast(бцел) std.random.randomGen(cast(бцел) семя, cast(бцел) индекс, cast(бцел) члоциклов);
		}

import std.file;

	проц[] читайФайл(ткст имяф){return std.file.read(имяф);}
	проц пишиФайл(ткст имяф, проц[] буф){std.file.write(имяф, буф);}
	проц допишиФайл(ткст имяф, проц[] буф){std.file.append(имяф, буф);}
	проц переименуйФайл(ткст из, ткст в){std.file.rename(из, в);}
	проц удалиФайл(ткст имяф){std.file.remove(имяф);}
	бдол дайРазмерФайла(ткст имяф){return std.file.getSize(имяф);}
	//проц дайВременаФайла(ткст имяф, out т_время фтц, out т_время фта, out т_время фтм){std.file.getTimes(имяф, фтц, фта, фтм);}
	бул естьФайл(ткст имяф){return cast(бул) std.file.exists(имяф);}
	бцел дайАтрибутыФайла(ткст имяф){return std.file.getAttributes(имяф);}
	бул файл_ли(ткст имяф){return cast(бул) std.file.isfile(имяф);}
	бул папка_ли(ткст имяп){return cast(бул) std.file.isdir(имяп);}
	проц сменипап(ткст имяп){std.file.chdir(имяп);}
	проц сделайпап(ткст имяп){std.file.mkdir(имяп);}
	проц удалипап(ткст имяп){std.file.rmdir(имяп);}
	ткст дайтекпап(){return std.file.getcwd();}
	ткст[] списпап(ткст имяп){return std.file.listdir(имяп);}
	ткст[] списпап(ткст имяп, ткст образец){return std.file.listdir(имяп, образец);}
	
}

export extern(D)
{	

	import std.utf;
	
alias wchar[] шткст;
alias dchar[] юткст;

	т_мера доИндексаУНС(ткст т, т_мера и){return std.utf.toUCSindex(т, и);}
	т_мера доИндексаУНС(шткст т, т_мера и){return std.utf.toUCSindex(т, и);}
	т_мера доИндексаУНС(юткст т, т_мера и){return std.utf.toUCSindex(т, и);}
	т_мера вИндексЮ(ткст т, т_мера и){return std.utf.toUCSindex(т, и);}
	т_мера вИндексЮ(шткст т, т_мера и){return std.utf.toUCSindex(т, и);}
	т_мера вИндексЮ(юткст т, т_мера и){return std.utf.toUCSindex(т, и);}
	дим раскодируйЮ(ткст т, inout т_мера инд){return std.utf.decode(т, инд);}
	дим раскодируйЮ(шткст т, inout т_мера инд){return std.utf.decode(т, инд);}
	дим раскодируйЮ(юткст т, inout т_мера инд){return std.utf.decode(т, инд);}
	проц кодируйЮ(inout ткст т, дим с){std.utf.encode(т, с);}
	проц кодируйЮ(inout шткст т, дим с){std.utf.encode(т, с);}
	проц кодируйЮ(inout юткст т, дим с){std.utf.encode(т, с);}
	проц оцениЮ(ткст т){std.utf.validate(т);}
	проц оцениЮ(шткст т){std.utf.validate(т);}
	проц оцениЮ(юткст т){std.utf.validate(т);}
	ткст вЮ8(сим[4] буф, дим с){return std.utf.toUTF8(буф, с);}
	ткст вЮ8(ткст т){return std.utf.toUTF8(т);}
	ткст вЮ8(шткст т){return std.utf.toUTF8(т);}
	ткст вЮ8(юткст т){return std.utf.toUTF8(т);}
	шткст вЮ16(шим[2] буф, дим с){return std.utf.toUTF16(буф, с);}
	шткст вЮ16(ткст т){return std.utf.toUTF16(т);}
	шим* вЮ16н(ткст т){return std.utf.toUTF16z(т);}
	шткст вЮ16(шткст т){return std.utf.toUTF16(т);}
	шткст вЮ16(юткст т){return std.utf.toUTF16(т);}
	юткст вЮ32(ткст т){return std.utf.toUTF32(т);}
	юткст вЮ32(шткст т){return std.utf.toUTF32(т);}
	юткст вЮ32(юткст т){return std.utf.toUTF32(т);}
	
	

креал син(креал x){return std.math.sin(x);}
вреал син(вреал x){return std.math.sin(x);} 
реал абс(креал x){return std.math.abs(x);}
реал абс(вреал x){return std.math.abs(x);}
креал квкор(креал x){return std.math.sqrt(x);}
креал кос(креал x){return std.math.cos(x);}
креал конъюнк(креал y){return std.math.conj(y);}
вреал конъюнк(вреал y){return std.math.conj(y);}
реал кос(вреал x){return std.math.cos(x);}
реал степень(реал а, бцел н){return std.math.pow(а, н);}

цел квадрат(цел а){return std.math2.sqr(а);}
дол квадрат(цел а){return std.math2.sqr(а);}
цел сумма(цел[] ч){return std.math2.sum(ч);}
дол сумма(дол[] ч){return std.math2.sum(ч);}
цел меньш_из(цел[] ч){return std.math2.min(ч);}
дол меньш_из(дол[] ч){return std.math2.min(ч);}
цел меньш_из(цел а, цел б){return std.math2.min(а, б);}
дол меньш_из(дол а, дол б){return std.math2.min(а, б);}
цел больш_из(цел[] ч){return std.math2.max(ч);}
дол больш_из(дол[] ч){return std.math2.max(ч);}
цел больш_из(цел а, цел б){return std.math2.max(а, б);}
дол больш_из(дол а, дол б){return std.math2.max(а, б);}
}//end of extern D

export extern(D)
{
проц копируйФайл(ткст из, ткст в){copy(из, в);}

сим* вМБТ_0(ткст т){return toMBSz(т);}


	
import std.date;

alias d_time т_время;

проц  вГодНедИСО8601(т_время t, out цел год, out цел неделя){ std.date.toISO8601YearWeek(t, год, неделя);}
	
цел День(т_время t)	{return cast(цел)std.date.floor(t, 86400000);	}

цел високосныйГод(цел y)
	{
		return ((y & 3) == 0 &&
			(y % 100 || (y % 400) == 0));
	}

цел днейВГоду(цел y)	{		return 365 + std.date.LeapYear(y);	}

цел деньИзГода(цел y)	{		return std.date.DayFromYear(y);	}

т_время времяИзГода(цел y)	{		return cast(т_время) (msPerDay * std.date.DayFromYear(y));	}

цел годИзВрем(т_время t)	{return std.date.YearFromTime(cast(d_time) t);}	
	
бул високосный_ли(т_время t)
	{
		if(std.date.LeapYear(std.date.YearFromTime(cast(d_time) t)) != 0)
		return да;
		else return нет;
	}

цел месИзВрем(т_время t)	{return std.date.MonthFromTime(cast(d_time) t);	}

цел датаИзВрем(т_время t)	{return std.date.DateFromTime(cast(d_time) t);	}

т_время нокругли(т_время d, цел делитель)	{	return cast(т_время) std.date.floor(cast(d_time) d, делитель);		}
	
цел дмод(т_время n, т_время d)	{   return std.date.dmod(n,d);	}

цел часИзВрем(т_время t)	{		return std.date.dmod(std.date.floor(t, msPerHour), HoursPerDay);	}
	
цел минИзВрем(т_время t)	{		return std.date.dmod(std.date.floor(t, msPerMinute), MinutesPerHour);	}
	
цел секИзВрем(т_время t)	{		return std.date.dmod(std.date.floor(t, TicksPerSecond), 60);	}
	
цел мсекИзВрем(т_время t)	{		return std.date.dmod(t / (TicksPerSecond / 1000), 1000);	}
	
цел времениВДне(т_время t)	{		return std.date.dmod(t, msPerDay);	}
	
цел ДеньНедели(т_время вр){return std.date.WeekDay(вр);}
т_время МВ8Местное(т_время вр){return cast(т_время) std.date.UTCtoLocalTime(вр);}
т_время местное8МВ(т_время вр){return cast(т_время) std.date.LocalTimetoUTC(вр);}
т_время сделайВремя(т_время час, т_время мин, т_время сек, т_время мс){return cast(т_время) std.date.MakeTime(час, мин, сек, мс);}
т_время сделайДень(т_время год, т_время месяц, т_время дата){return cast(т_время) std.date.MakeDay(год, месяц, дата);}
т_время сделайДату(т_время день, т_время вр){return cast(т_время) std.date.MakeDate(день, вр);}
//d_time TimeClip(d_time время)
цел датаОтДняНеделиМесяца(цел год, цел месяц, цел день_недели, цел ч){return  std.date.DateFromNthWeekdayOfMonth(год, месяц, день_недели, ч);}
цел днейВМесяце(цел год, цел месяц){return std.date.DaysInMonth(год, месяц);}
//ткст вТкст(т_время время){return std.date.toString(время);}
ткст вТкстМВ(т_время время){return std.date.toUTCString(время);}
ткст вТкстДаты(т_время время){return std.date.toDateString(время);}
ткст вТкстВремени(т_время время){return std.date.toTimeString(время);}
т_время разборВремени(ткст т){return cast(т_время) std.date.parse(т);}
т_время дайВремяМВ(){return cast(т_время) std.date.getUTCtime();}
//т_время ФВРЕМЯ8т_время(ФВРЕМЯ *фв){return cast(т_время) std.date.FILETIME2d_time(фв);}
//т_время СИСТВРЕМЯ8т_время(СИСТВРЕМЯ *св, т_время вр){return cast(т_время) std.date.SYSTEMTIME2d_time(св,cast(дол) вр);}
т_время дайМестнуюЗЧП(){return cast(т_время) std.date.getLocalTZA();}
цел дневноеСохранениеЧО(т_время вр){return std.date.DaylightSavingTA(вр);}
//т_время вДвремя(ФВремяДос вр){return cast(т_время) std.date.toDtime(cast(DosFileTime) вр);}
//ФВремяДос вФВремяДос(т_время вр){return cast(ФВремяДос) std.date.toDosFileTime(вр);}

import std.cpuid:mmx,fxsr,sse,sse2,sse3,ssse3,amd3dnow,amd3dnowExt,amdMmx,ia64,amd64,hyperThreading, vendor, processor,family,model,stepping,threadsPerCPU,coresPerCPU;

export extern(D) struct Процессор
{
	export:

	ткст производитель()	{return std.cpuid.vendor();}
	ткст название()			{return std.cpuid.processor();}
	бул поддержкаММЭкс()	{return std.cpuid.mmx();}
	бул поддержкаФЭксСР()	{return std.cpuid.fxsr();}
	бул поддержкаССЕ()		{return std.cpuid.sse();}
	бул поддержкаССЕ2()		{return std.cpuid.sse2();}
	бул поддержкаССЕ3()		{return std.cpuid.sse3();}
	бул поддержкаСССЕ3()	{return std.cpuid.ssse3();}
	бул поддержкаАМД3ДНау()	{return std.cpuid.amd3dnow();}
	бул поддержкаАМД3ДНауЭкст(){return std.cpuid.amd3dnowExt();}
	бул поддержкаАМДММЭкс()	{return std.cpuid.amdMmx();}
	бул являетсяИА64()		{return std.cpuid.ia64();}
	бул являетсяАМД64()		{return std.cpuid.amd64();}
	бул поддержкаГиперПоточности(){return std.cpuid.hyperThreading();}
	бцел потоковНаЦПБ()		{return std.cpuid.threadsPerCPU();}
	бцел ядерНаЦПБ()		{return std.cpuid.coresPerCPU();}
	бул являетсяИнтел()		{return std.cpuid.intel();}
	бул являетсяАМД()		{return std.cpuid.amd();}
	бцел поколение()		{return std.cpuid.stepping();}
	бцел модель()			{return std.cpuid.model();}
	бцел семейство()		{return std.cpuid.family();}
	ткст вТкст()			{return о_ЦПУ();}
}

ткст о_ЦПУ(){

	ткст feats;
	if (mmx)			feats ~= "MMX ";
	if (fxsr)			feats ~= "FXSR ";
	if (sse)			feats ~= "SSE ";
	if (sse2)			feats ~= "SSE2 ";
	if (sse3)			feats ~= "SSE3 ";
	if (ssse3)			feats ~= "SSSE3 ";
	if (amd3dnow)			feats ~= "3DNow! ";
	if (amd3dnowExt)		feats ~= "3DNow!+ ";
	if (amdMmx)			feats ~= "MMX+ ";
	if (ia64)			feats ~= "IA-64 ";
	if (amd64)			feats ~= "AMD64 ";
	if (hyperThreading)		feats ~= "HTT";

	ткст цпу = фм(
		"\t\tИНФОРМАЦИЯ О ЦПУ ДАННОГО КОМПЬЮТЕРА\n\t**************************************************************\n\t"~
		" Производитель   \t|   %s                                 \n\t"~"--------------------------------------------------------------\n\t", vendor(),
		" Процессор       \t|   %s                                 \n\t"~"--------------------------------------------------------------\n\t", processor(),
		" Сигнатура     \t| Семейство %d | Модель %d | Поколение %d \n\t"~"--------------------------------------------------------------\n\t", family(), model(), stepping(),
		" Функции         \t|   %s                                 \n\t"~"--------------------------------------------------------------\n\t", feats,
		" Многопоточность \t|  %d-поточный / %d-ядерный            \n\t"~"**************************************************************", threadsPerCPU(), coresPerCPU());
	return цпу;

    }

import std.path;

ткст извлекиРасш(ткст полнимя){return std.path.getExt(полнимя);}
//getExt(r"d:\путь\foo.bat") // "bat"     getExt(r"d:\путь.two\bar") // null
ткст дайИмяПути(ткст полнимя){return std.path.getName(полнимя);}
//getName(r"d:\путь\foo.bat") => "d:\путь\foo"     getName(r"d:\путь.two\bar") => null
ткст извлекиИмяПути(ткст пимя){return std.path.getBaseName(пимя);}//getBaseName(r"d:\путь\foo.bat") => "foo.bat"
ткст извлекиПапку(ткст пимя){return std.path.getDirName(пимя);}
//getDirName(r"d:\путь\foo.bat") => "d:\путь"     getDirName(getDirName(r"d:\путь\foo.bat")) => r"d:\"
ткст извлекиМеткуДиска(ткст пимя){return std.path.getDrive(пимя);}
ткст устДефРасш(ткст пимя, ткст расш){return std.path.defaultExt(пимя, расш);}
ткст добРасш(ткст фимя, ткст расш){return std.path.addExt(фимя, расш);}
бул абсПуть_ли(ткст путь){return cast(бул) std.path.isabs(путь);}
ткст слейПути(ткст п1, ткст п2){return std.path.join(п1, п2);}
бул сравниПути(дим п1, дим п2){return cast(бул) std.path.fncharmatch(п1, п2);}
бул сравниПутьОбразец(ткст фимя, ткст образец){return cast(бул) std.path.fnmatch(фимя, образец);}
ткст разверниТильду(ткст путь){return std.path.expandTilde(путь);}

бул выведиФайл(ткст имяф){ скажи(cast(ткст) читайФайл(имяф)); return да;}


}///end of extern C


import std.math;

реал абс(реал x){return std.math.abs(x);}
дол абс(дол x){return std.math.abs(x);}
цел абс(цел x){return std.math.abs(x);}
реал кос(реал x){return std.math.cos(x);}
реал син(реал x){return std.math.sin(x);}
реал тан(реал x){return std.math.tan(x);}
реал акос(реал x){return std.math.acos(x);}
реал асин(реал x){return std.math.asin(x);}
реал атан(реал x){return std.math.atan(x);}
реал атан2(реал y, реал x){return std.math.atan2(x, y);}
реал гкос(реал x){return std.math.cosh(x);}
реал гсин(реал x){return std.math.sinh(x);}
реал гтан(реал x){return std.math.tanh(x);}
реал гакос(реал x){return std.math.acosh(x);}
реал гасин(реал x){return std.math.asinh(x);}
реал гатан(реал x){return std.math.atanh(x);}
дол округливдол(реал x){return std.math.rndtol(x);}
реал округливближдол(реал x){return std.math.rndtonl(x);}
плав квкор(плав x){return std.math.sqrt(x);}
дво квкор(дво x){return std.math.sqrt(x);}
реал квкор(реал x){return std.math.sqrt(x);}
реал эксп(реал x){return std.math.exp(x);}
реал экспм1(реал x){return std.math.expm1(x);}
реал эксп2(реал x){return std.math.exp2(x);}
креал экспи(реал x){return std.math.expi(x);}
реал прэксп(реал знач, out цел эксп){return std.math.frexp(знач, эксп);}
цел илогб(реал x){return std.math.ilogb(x);}
реал лдэксп(реал н, цел эксп){return std.math.ldexp(н, эксп);}
реал лог(реал x){return std.math.log(x);}
реал лог10(реал x){return std.math.log10(x);}
реал лог1п(реал x){return std.math.log1p(x);}
реал лог2(реал x){return std.math.log2(x);}
реал логб(реал x){return std.math.logb(x);}
реал модф(реал x, inout реал y){return std.math.modf(x, y);}
реал скалбн(реал x, цел н){return std.math.scalbn(x,н);}
реал кубкор(реал x){return std.math.cbrt(x);}
реал фабс(реал x){return std.math.fabs(x);}
реал гипот(реал x, реал y){return std.math.hypot(x, y);}
реал фцош(реал x){return std.math.erf(x);}
реал лгамма(реал x){return std.math.lgamma(x);}
реал тгамма(реал x){return std.math.tgamma(x);}
реал потолок(реал x){return std.math.ceil(x);}
реал пол(реал x){return std.math.floor(x);}
реал ближцел(реал x){return std.math.nearbyint(x);}

цел окрвцел(реал x)
{
    //version(Naked_D_InlineAsm_X86)
   // {
        цел n;
        asm
        {
            fld x;
            fistp n;
        }
        return n;
  //  }
  //  else
  //  {
   //     return std.c.lrintl(x);
   // }
}
реал окрвреал(реал x){return std.math.rint(x);}
дол окрвдол(реал x){return std.math.lrint(x);}
реал округли(реал x){return std.math.round(x);}
дол докругли(реал x){return std.math.lround(x);}
реал упрости(реал x){return std.math.trunc(x);}
реал остаток(реал x, реал y){return std.math.remainder(x, y);}
бул нч_ли(реал x){return cast(бул) std.math.isnan(x);}
бул конечен_ли(реал р){return cast(бул) std.math.isfinite(р);}

бул субнорм_ли(плав п){return cast(бул) std.math.issubnormal(п);}
бул субнорм_ли(дво п){return cast(бул) std.math.issubnormal(п);}
бул субнорм_ли(реал п){return cast(бул) std.math.issubnormal(п);}
бул беск_ли(реал р){return cast(бул) std.math.isinf(р);}
бул идентичен_ли(реал р, реал д){return std.math.isIdentical(р, д);}
бул битзнака(реал р){ if(1 == std.math.signbit(р)){return да;} return нет;}
реал копируйзнак(реал кому, реал у_кого){return std.math.copysign(кому, у_кого);}
реал нч(ткст тэгп){return std.math.nan(тэгп);}
реал следщБольш(реал р){return std.math.nextUp(р);}
дво следщБольш(дво р){return std.math.nextUp(р);}
плав следщБольш(плав р){return std.math.nextUp(р);}
реал следщМеньш(реал р){return std.math.nextUp(р);}
дво следщМеньш(дво р){return std.math.nextUp(р);}
плав следщМеньш(плав р){return std.math.nextUp(р);}
реал следщза(реал а, реал б){return std.math.nextafter(а, б);}
плав следщза(плав а, плав б){return std.math.nextafter(а, б);}
дво следщза(дво а, дво б){return std.math.nextafter(а, б);}
реал пдельта(реал а, реал б){return std.math.fdim(а, б);}
реал пбольш_из(реал а, реал б){return std.math.fmax(а, б);}
реал пменьш_из(реал а, реал б){return std.math.fmin(а, б);}

реал степень(реал а, цел н){return std.math.pow(а, н);}
реал степень(реал а, реал н){return std.math.pow(а, н);}

import std.math2;

бул правны(реал а, реал б){return std.math2.feq(а, б);}
бул правны(реал а, реал б, реал эпс){return std.math2.feq(а, б, эпс);}

реал квадрат(цел а){return std.math2.sqr(а);}
реал дробь(реал а){return std.math2.frac(а);}
цел знак(цел а){return std.math2.sign(а);}
цел знак(дол а){return std.math2.sign(а);}
цел знак(реал а){return std.math2.sign(а);}
реал цикл8градус(реал ц){return std.math2.cycle2deg(ц);}
реал цикл8радиан(реал ц){return std.math2.cycle2rad(ц);}
реал цикл8градиент(реал ц){return std.math2.cycle2grad(ц);}
реал градус8цикл(реал г){return std.math2.deg2cycle(г);}
реал градус8радиан(реал г){return std.math2.deg2rad(г);}
реал градус8градиент(реал г){return std.math2.deg2grad(г);}
реал радиан8градус(реал р){return std.math2.rad2deg(р);}
реал радиан8цикл(реал р){return std.math2.rad2cycle(р);}
реал радиан8градиент(реал р){return std.math2.rad2grad(р);}
реал градиент8градус(реал г){return std.math2.grad2deg(г);}
реал градиент8цикл(реал г){return std.math2.grad2cycle(г);}
реал градиент8радиан(реал г){return std.math2.grad2rad(г);}
реал сариф(реал[] ч){return std.math2.avg(ч);}
реал сумма(реал[] ч){return std.math2.sum(ч);}
реал меньш_из(реал[] ч){return std.math2.min(ч);}
реал меньш_из(реал а, реал б){return std.math2.min(а, б);}
реал больш_из(реал[] ч){return std.math2.max(ч);}
реал больш_из(реал а, реал б){return std.math2.max(а, б);}
реал акот(реал р){return std.math2.acot(р);}
реал асек(реал р){return std.math2.asec(р);}
реал акосек(реал р){return std.math2.acosec(р);}
реал кот(реал р){return std.math2.cot(р);}
реал сек(реал р){return std.math2.sec(р);}
реал косек(реал р){return std.math2.cosec(р);}
реал гкот(реал р){return std.math2.coth(р);}
реал гсек(реал р){return std.math2.sech(р);}
реал гкосек(реал р){return std.math2.cosech(р);}
реал гакот(реал р){return std.math2.acoth(р);}
реал гасек(реал р){return std.math2.asech(р);}
реал гакосек(реал р){return std.math2.acosech(р);}
реал ткст8реал(ткст т){return std.math2.atof(т);} 


import std.regexp;


ткст подставь(ткст текст, ткст образец, ткст формат, ткст атрибуты = null)
	{
	return std.regexp.sub(текст, образец, формат, атрибуты);
	}


export extern(D) ткст подставь(ткст текст, ткст образец, ткст delegate(РегВыр) дг, ткст атрибуты = null)
	{
	  auto r = РегВыр(образец, атрибуты);
    рсим[] результат;
    цел последниндкс;
    цел смещение;

    результат = текст;
    последниндкс = 0;
    смещение = 0;
    while (r.проверь(текст, последниндкс))
    {
	цел so = r.псовп[0].рснач;
	цел eo = r.псовп[0].рскон;

	рсим[] замена = дг(r);

	// Optimize by using std.string.replace if possible - Dave Fladebo
	рсим[] срез = результат[смещение + so .. смещение + eo];
	if (r.атрибуты & РегВыр.РВА.глоб &&		// глоб, so replace all
	    !(r.атрибуты & РегВыр.РВА.любрег) &&	// not ignoring case
	    !(r.атрибуты & РегВыр.РВА.многострок) &&	// not многострок
	    образец == срез)				// simple образец (exact match, no special символs) 
	{
	    debug(РегВыр)
		win.скажинс(фм("образец: %s, срез: %s, замена: %s\n", образец, результат[смещение + so .. смещение + eo],замена));
	    результат = замени(результат,срез,замена);
	    break;
	}

	результат = replaceSlice(результат, результат[смещение + so .. смещение + eo], замена);

	if (r.атрибуты & РегВыр.РВА.глоб)
	{
	    смещение += замена.length - (eo - so);

	    if (последниндкс == eo)
		последниндкс++;		// always consume some source
	    else
		последниндкс = eo;
	}
	else
	    break;
    }
    delete r;

    return результат;

	}
	
export extern(D) РегВыр ищи(ткст текст, ткст образец, ткст атрибуты = null)
	{
	auto r = РегВыр(образец, атрибуты);

    if (r.проверь(текст))
		{
		}
		else
		{	delete r;
		r = null;
		}
    return r;
	}

export extern (D)
{

alias сим рсим;
alias ткст рткст;

	цел найди(рткст текст, ткст образец, ткст атрибуты = null)//Возврат -1=совпадений нет, иначе=индекс совпадения
		{
		
	//debug win.скажинс("РегВыр.найди");
	//debug win.скажинс(текст);
		    int i = -1;

    auto r = new РегВыр(образец, атрибуты);
    if (r.проверь(текст))
    {
	i = r.псовп[0].рснач;
    }
    delete r;
    return i;

		//return std.regexp.find(текст, образец, атрибуты);
		}

	цел найдирек(рткст текст, ткст образец, ткст атрибуты = null)
		{
		return std.regexp.rfind(текст, образец, атрибуты);
		}

	ткст[] разбей(ткст текст, ткст образец, ткст атрибуты = null)
		{
	//debug win.скажинс(текст);
	auto r = new РегВыр(образец, атрибуты);
    auto результат = r.разбей(текст);
    delete r;
    return результат;

		//return std.regexp.split(текст, образец, атрибуты);
		}

import std.uni;

бул юпроп_ли(дим с){return cast(бул) std.uni.isUniLower(с);}
бул юзаг_ли(дим с){return cast(бул) std.uni.isUniUpper(с);}
дим в_юпроп(дим с){return std.uni.toUniLower(с);}
дим в_юзаг(дим с){return std.uni.toUniUpper(с);}
бул юцб_ли(дим с){return cast(бул) std.uni.isUniAlpha(с);}

import std.uri;

бцел аски8гекс(дим с){return std.uri.ascii2hex(с);}
ткст раскодируйУИР(ткст кодирУИР){return std.uri.decode(кодирУИР);}
ткст раскодируйКомпонентУИР(ткст кодирКомпонУИР){return std.uri.decodeComponent(кодирКомпонУИР);}
ткст кодируйУИР(ткст уир){return std.uri.encode(уир);}
ткст кодируйКомпонентУИР(ткст уирКомпон){return std.uri.encodeComponent(уирКомпон);}

import std.zlib;

бцел адлер32(бцел адлер, проц[] буф){return std.zlib.adler32(адлер, буф);}
бцел цпи32(бцел кс, проц[] буф){return std.zlib.crc32(кс, буф);}

проц[] сожмиЗлиб(проц[] истбуф, цел ур = цел.init)
	{
	if(ур) return std.zlib.compress(истбуф, ур);
	else return std.zlib.compress(истбуф);
	}

проц[] разожмиЗлиб(проц[] истбуф, бцел итдлин = 0u, цел винбиты = 15){return std.zlib.uncompress(истбуф, итдлин, винбиты);}

	

export extern(D) class СжатиеЗлиб
{
private std.zlib.Compress zc;

export:
	enum
	{
		БЕЗ_СЛИВА      = 0,
		СИНХ_СЛИВ    = 2,
		ПОЛН_СЛИВ    = 3,
		ФИНИШ       = 4,
	}

	this(цел ур){zc = new std.zlib.Compress(ур);}
	this(){zc = new std.zlib.Compress();}
	~this(){delete zc;}
	проц[] сжать(проц[] буф){return  zc.compress(буф);}
	проц[] слей(цел режим = ФИНИШ){return  zc.flush(режим);}
}

export extern(D) class РасжатиеЗлиб
{
private std.zlib.UnCompress zc;

export:
	
	this(бцел размБуфЦели){zc = new std.zlib.UnCompress(размБуфЦели);}
	this(){zc = new std.zlib.UnCompress;}
	~this(){delete zc;}
	проц[] расжать(проц[] буф){return  zc.uncompress(буф);}
	проц[] слей(){return  zc.flush();}
}



export extern(D) class ИсключениеРегВыр : Исключение
{
export:
    this(ткст сооб)
    {
	super("Неудачная операция с регулярным выражением: "~сооб,__FILE__,__LINE__);
	}
}

import std.outbuffer;

export extern (D) class БуферВывода
{



ббайт данные[];
бцел смещение;

invariant
    {
	//say(format("this = %p, смещение = %x, данные.length = %u\n", this, смещение, данные.length));
	assert(смещение <= данные.length);
	assert(данные.length <= std.gc.gc_capacity(данные.ptr));
    }
	
	export this()
    {
	//say("in OutBuffer constructor\n");
	}
	
export	ббайт[] вБайты() { return данные[0 .. смещение]; }
	
export	проц резервируй(бцел члобайт)
	in
	{
	    assert(смещение + члобайт >= смещение);
	}
	out
	{
	    assert(смещение + члобайт <= данные.length);
	    assert(данные.length <= std.gc.gc_capacity(данные.ptr));
	}
	body
	{
	    if (данные.length < смещение + члобайт)
	    {
		данные.length = (смещение + члобайт) * 2;
		std.gc.setTypeInfo(null, данные.ptr);
	    }
	}

 export   проц пиши(ббайт[] байты)
	{
	    резервируй(байты.length);
	    данные[смещение .. смещение + байты.length] = байты;
	    смещение += байты.length;
	}

  export  проц пиши(ббайт b)		/// ditto
	{
	    резервируй(ббайт.sizeof);
	    this.данные[смещение] = b;
	    смещение += ббайт.sizeof;
	}

  export  проц пиши(байт b) { пиши(cast(ббайт)b); }		/// ditto
 export   проц пиши(сим c) { пиши(cast(ббайт)c); }		/// ditto

 export   проц пиши(бкрат w)		/// ditto
    {
	резервируй(бкрат.sizeof);
	*cast(бкрат *)&данные[смещение] = w;
	смещение += бкрат.sizeof;
    }

  export  проц пиши(крат т) { пиши(cast(бкрат)т); }		/// ditto

  export  проц пиши(шим c)		/// ditto
    {
	резервируй(шим.sizeof);
	*cast(шим *)&данные[смещение] = c;
	смещение += шим.sizeof;
    }

  export  проц пиши(бцел w)		/// ditto
    {
	резервируй(бцел.sizeof);
	*cast(бцел *)&данные[смещение] = w;
	смещение += бцел.sizeof;
    }

  export  проц пиши(цел i) { пиши(cast(бцел)i); }		/// ditto

  export  проц пиши(бдол l)		/// ditto
    {
	резервируй(бдол.sizeof);
	*cast(бдол *)&данные[смещение] = l;
	смещение += бдол.sizeof;
    }

  export  проц пиши(дол l) { пиши(cast(бдол)l); }		/// ditto

   export проц пиши(плав f)		/// ditto
    {
	резервируй(плав.sizeof);
	*cast(плав *)&данные[смещение] = f;
	смещение += плав.sizeof;
    }

   export проц пиши(дво f)		/// ditto
    {
	резервируй(дво.sizeof);
	*cast(дво *)&данные[смещение] = f;
	смещение += дво.sizeof;
    }

  export  проц пиши(реал f)		/// ditto
    {
	резервируй(реал.sizeof);
	*cast(реал *)&данные[смещение] = f;
	смещение += реал.sizeof;
    }

   export проц пиши(ткст т)		/// ditto
    {
	пиши(cast(ббайт[])т);
    }

   export проц пиши(БуферВывода буф)		/// ditto
    {
	пиши(буф.вБайты());
    }

    /****************************************
     * Добавка члобайт of 0 to the internal буфер.
     */

  export  проц занули(бцел члобайт)
    {
	резервируй(члобайт);
	данные[смещение .. смещение + члобайт] = 0;
	смещение += члобайт;
    }

    /**********************************
     * 0-fill to align on power of 2 boundary.
     */

  export  проц расклад(бцел мера)
    in
    {
	assert(мера && (мера & (мера - 1)) == 0);
    }
    out
    {
	assert((смещение & (мера - 1)) == 0);
    }
    body
    {   бцел члобайт;

	члобайт = смещение & (мера - 1);
	if (члобайт)
	    занули(мера - члобайт);
    }

    /****************************************
     * Optimize common special case расклад(2)
     */

  export  проц расклад2()
    {
	if (смещение & 1)
	    пиши(cast(байт)0);
    }

    /****************************************
     * Optimize common special case расклад(4)
     */

   export проц расклад4()
    {
	if (смещение & 3)
	{   бцел члобайт = (4 - смещение) & 3;
	    занули(члобайт);
	}
    }

    /**************************************
     * Convert internal буфер to array of симs.
     */

   export ткст вТкст()
    {
	//эхо("БуферВывода.вТкст()\n");
	return cast(сим[])данные[0 .. смещение];
    }

    /*****************************************
     * Добавка output of C'т vprintf() to internal буфер.
     */

  export  проц ввыводф(ткст формат, спис_ва арги)
    {
	сим[128] буфер;
	сим* p;
	бцел psize;
	цел count;

	auto f = вТкст0(формат);
	p = буфер.ptr;
	psize = буфер.length;
	for (;;)
		{
			count = std.c._vsnprintf(p,psize,f,арги);
			if (count != -1)
				break;
			psize *= 2;
			p = cast(сим *) std.c.alloca(psize);	// буфер too small, try again with larger размер
		}
	пиши(p[0 .. count]);
    }

    /*****************************************
     * Добавка output of C'т эхо() to internal буфер.
     */

  export  проц выводф(ткст формат, ...)
    {
	спис_ва ap;
	ap = cast(спис_ва)&формат;
	ap += формат.sizeof;
	ввыводф(формат, ap);
    }

    /*****************************************
     * At смещение index целo буфер, создай члобайт of space by shifting upwards
     * all данные past index.
     */

  export  проц простели(бцел индекс, бцел члобайт)
	in
	{
	    assert(индекс <= смещение);
	}
	body
	{
	    резервируй(члобайт);

	    // This is an overlapping copy - should use memmove()
	    for (бцел i = смещение; i > индекс; )
	    {
		--i;
		данные[i + члобайт] = данные[i];
	    }
	    смещение += члобайт;
	}
	
	export ~this(){}
}



export extern (D) class РегВыр
{

   export ~this(){};

    export this(рсим[] образец, рсим[] атрибуты = null)
    {
	псовп = (&гсовп)[0 .. 1];
	компилируй(образец, атрибуты);
    }

    export static РегВыр opCall(рсим[] образец, рсим[] атрибуты = null)
    {
	return new РегВыр(образец, атрибуты);
    }

    export РегВыр ищи(рсим[] текст)
    {
	ввод = текст;
	псовп[0].рскон = 0;
	return this;
    }

    /** ditto */
   export  цел opApply(цел delegate(inout РегВыр) дг)
    {
	цел результат;
	РегВыр r = this;

	while (проверь())
	{
	    результат = дг(r);
	    if (результат)
		break;
	}

	return результат;
    }

   export  ткст сверь(т_мера n)
    {
	if (n >= псовп.length)
	    return null;
	else
	{   т_мера рснач, рскон;
	    рснач = псовп[n].рснач;
	    рскон = псовп[n].рскон;
	    if (рснач == рскон)
		return null;
	    return ввод[рснач .. рскон];
	}
    }

   export  ткст перед()
    {
	return ввод[0 .. псовп[0].рснач];
    }

   export  ткст после()
    {
	return ввод[псовп[0].рскон .. $];
    }

    бцел члоподстр;		// number of parenthesized subexpression matches
    т_регсвер[] псовп;	// array [члоподстр + 1]

    рсим[] ввод;		// the текст to ищи

    // per instance:

    рсим[] образец;		// source text of the regular expression

    рсим[] флаги;		// source text of the атрибуты parameter

    цел ошибки;

    бцел атрибуты;

    enum РВА
    {
	глоб		= 1,	// has the g attribute
	любрег	= 2,	// has the i attribute
	многострок	= 4,	// if treat as multiple lines separated
				// by newlines, or as a single строка
	тчксовплф	= 8,	// if . matches \n
    }


private{
    т_мера истк;			// current source index in ввод[]
    т_мера старт_истк;		// starting index for сверь in ввод[]
    т_мера p;			// позиция of parser in образец[]
    т_регсвер гсовп;		// сверь for the entire regular expression
				// (serves as storage for псовп[0])

    ббайт[] программа;		// образец[] compiled целo regular expression программа
    БуферВывода буф;
	}

// Opcodes

enum : ббайт
{
    РВконец,		// end of программа
    РВсим,		// single символ
    РВлсим,		// single символ, case insensitive
    РВдим,		// single UCS символ
    РВлдим,		// single wide символ, case insensitive
    РВлюбсим,		// any символ
    РВлюбзвезда,		// ".*"
    РВткст,		// текст of символs
    РВлткст,		// текст of символs, case insensitive
    РВтестбит,		// any in bitmap, non-consuming
    РВбит,		// any in the bit map
    РВнебит,		// any not in the bit map
    РВдиапазон,		// any in the текст
    РВнедиапазон,		// any not in the текст
    РВили,		// a | b
    РВплюс,		// 1 or more
    РВзвезда,		// 0 or more
    РВвопрос,		// 0 or 1
    РВнм,		// n..m
    РВнмкю,		// n..m, non-greedy version
    РВначстр,		// beginning of строка
    РВконстр,		// end of строка
    РВвскоб,		// parenthesized subexpression
    РВгоуту,		// goto смещение

    РВгранслова,
    РВнегранслова,
    РВцифра,
    РВнецифра,
    РВпространство,
    РВнепространство,
    РВслово,
    РВнеслово,
    РВобрссыл,
};

// BUG: should this include '$'?
private цел слово_ли(дим c) { return числобукв_ли(c) || c == '_'; }

private бцел бескн = ~0u;

/* ********************************
 * Throws ИсключениеРегВыр on error
 */

export проц компилируй(рсим[] образец, рсим[] атрибуты)
{
   debug(РегВыр) скажи(фм("РегВыр.компилируй('%s', '%s')\n", образец, атрибуты));

    this.атрибуты = 0;
    foreach (рсим c; атрибуты)
    {   РВА att;

	switch (c)
	{
	    case 'g': att = РВА.глоб;		break;
	    case 'i': att = РВА.любрег;	break;
	    case 'm': att = РВА.многострок;	break;
	    default:
		error("нераспознанный атрибут");
		return;
	}
	if (this.атрибуты & att)
	{   error("повторяющийся атрибут");
	    return;
	}
	this.атрибуты |= att;
    }

    ввод = null;

    this.образец = образец;
    this.флаги = атрибуты;

    бцел oldre_nsub = члоподстр;
    члоподстр = 0;
    ошибки = 0;

    буф = new БуферВывода();
    буф.резервируй(образец.length * 8);
    p = 0;
    разборРегвыр();
    if (p < образец.length)
    {	error("несовпадение ')'");
    }
    оптимизируй();
    программа = буф.данные;
    буф.данные = null;
   // delete буф;//Вызывает ошибку!)))

    if (члоподстр > oldre_nsub)
    {
	if (псовп.ptr is &гсовп)
	    псовп = null;
	псовп.length = члоподстр + 1;
    }
    псовп[0].рснач = 0;
    псовп[0].рскон = 0;
}


 export рсим[][] разбей(рсим[] текст)
{
    debug(РегВыр) скажи("РегВыр.разбей()\n");

    рсим[][] результат;

    if (текст.length)
    {
	цел p = 0;
	цел q;
	for (q = p; q != текст.length;)
	{
	    if (проверь(текст, q))
	    {	цел e;

		q = псовп[0].рснач;
		e = псовп[0].рскон;
		if (e != p)
		{
		    результат ~= текст[p .. q];
		    for (цел i = 1; i < псовп.length; i++)
		    {
			цел so = псовп[i].рснач;
			цел eo = псовп[i].рскон;
			if (so == eo)
			{   so = 0;	// -1 gives array bounds error
			    eo = 0;
			}
			результат ~= текст[so .. eo];
		    }
		    q = p = e;
		    continue;
		}
	    }
	    q++;
	}
	результат ~= текст[p .. текст.length];
    }
    else if (!проверь(текст))
	результат ~= текст;
    return результат;
}

 export цел найди(рсим[] текст)
{
    цел i;

    i = проверь(текст);
    if (i)
	i = псовп[0].рснач;
    else
	i = -1;			// no сверь
    return i;
}

 export рсим[][] сверь(рсим[] текст)
{
    рсим[][] результат;

    if (атрибуты & РВА.глоб)
    {
	цел последниндкс = 0;

	while (проверь(текст, последниндкс))
	{   цел eo = псовп[0].рскон;

	    результат ~= ввод[псовп[0].рснач .. eo];
	    if (последниндкс == eo)
		последниндкс++;		// always consume some source
	    else
		последниндкс = eo;
	}
    }
    else
    {
	результат = выполни(текст);
    }
    return результат;
}

 export рсим[] замени(рсим[] текст, рсим[] формат)
{
    рсим[] результат;
    цел последниндкс;
    цел смещение;

    результат = текст;
    последниндкс = 0;
    смещение = 0;
    for (;;)
    {
	if (!проверь(текст, последниндкс))
	    break;

	цел so = псовп[0].рснач;
	цел eo = псовп[0].рскон;

	рсим[] замена = замени(формат);

	// Optimize by using std.текст.замени if possible - Dave Fladebo
	рсим[] срез = результат[смещение + so .. смещение + eo];
	if (атрибуты & РВА.глоб &&		// глоб, so замени all
	   !(атрибуты & РВА.любрег) &&	// not ignoring case
	   !(атрибуты & РВА.многострок) &&	// not многострок
	   образец == срез &&			// simple образец (exact сверь, no special символs) 
	   формат == замена)		// simple формат, not $ formats
	{
	    debug(РегВыр)
		скажифнс("образец: %s срез: %s, формат: %s, замена: %s\n" ,образец,результат[смещение + so .. смещение + eo],формат, замена);
	    результат = std.string.replace(результат,срез,замена);
	    break;
	}

	результат = replaceSlice(результат, результат[смещение + so .. смещение + eo], замена);

	if (атрибуты & РВА.глоб)
	{
	    смещение += замена.length - (eo - so);

	    if (последниндкс == eo)
		последниндкс++;		// always consume some source
	    else
		последниндкс = eo;
	}
	else
	    break;
    }

    return результат;
}

 export рсим[][] выполни(рсим[] текст)
{
    debug(РегВыр) win.скажи(фм("РегВыр.выполни(текст = '%s')\n", текст));
    ввод = текст;
    псовп[0].рснач = 0;
    псовп[0].рскон = 0;
    return выполни();
}

 export рсим[][] выполни()
{
    if (!проверь())
	return null;

    auto результат = new рсим[][псовп.length];
    for (цел i = 0; i < псовп.length; i++)
    {
	if (псовп[i].рснач == псовп[i].рскон)
	    результат[i] = null;
	else
	    результат[i] = ввод[псовп[i].рснач .. псовп[i].рскон];
    }

    return результат;
}

 export цел проверь(рсим[] текст)
{
    return проверь(текст, 0 /*псовп[0].рскон*/);
}

export цел проверь()
{
    return проверь(ввод, псовп[0].рскон);
}

export цел проверь(ткст текст, цел стартиндекс)
{
    сим firstc;
    бцел ит;

    ввод = текст;
    debug (РегВыр) win.скажи(фм("РегВыр.проверь(ввод[] = '%s', стартиндекс = %d)\n", ввод, стартиндекс));
    псовп[0].рснач = 0;
    псовп[0].рскон = 0;
    if (стартиндекс < 0 || стартиндекс > ввод.length)
    {
	return 0;			// fail
    }
    debug(РегВыр) выведиПрограмму(программа);

    // First символ optimization
    firstc = 0;
    if (программа[0] == РВсим)
    {
	firstc = программа[1];
	if (атрибуты & РВА.любрег && буква_ли(firstc))
	    firstc = 0;
    }

    for (ит = стартиндекс; ; ит++)
    {
	if (firstc)
	{
	    if (ит == ввод.length)
		break;			// no сверь
	    if (ввод[ит] != firstc)
	    {
		ит++;
		if (!чр(ит, firstc))	// if first символ not found
		    break;		// no сверь
	    }
	}
	for (цел i = 0; i < члоподстр + 1; i++)
	{
	    псовп[i].рснач = -1;
	    псовп[i].рскон = -1;
	}
	старт_истк = истк = ит;
	if (пробнсвер(0, программа.length))
	{
	    псовп[0].рснач = ит;
	    псовп[0].рскон = истк;
	    //debug(РегВыр) эхо("старт = %d, end = %d\n", гсовп.рснач, гсовп.рскон);
	    return 1;
	}
	// If possible сверь must старт at beginning, we are done
	if (программа[0] == РВначстр || программа[0] == РВлюбзвезда)
	{
	    if (атрибуты & РВА.многострок)
	    {
		// Scan for the следщ \n
		if (!чр(ит, '\n'))
		    break;		// no сверь if '\n' not found
	    }
	    else
		break;
	}
	if (ит == ввод.length)
	    break;
	//debug(РегВыр) эхо("Starting new try: '%.*т'\n", ввод[ит + 1 .. ввод.length]);
    }
    return 0;		// no сверь
}

export цел чр(inout бцел ит, рсим c)
{
    for (; ит < ввод.length; ит++)
    {
	if (ввод[ит] == c)
	    return 1;
    }
    return 0;
}


export проц выведиПрограмму(ббайт[] прог)
{
  
    бцел pc;
    бцел длин;
    бцел n;
    бцел m;
    бкрат *pu;
    бцел *pбцел;

    debug(РегВыр) win.скажи("Вывод Программы()\n");
    for (pc = 0; pc < прог.length; )
    {
	debug(РегВыр) скажифнс("прог[pc] = %d, РВсим = %d, РВнмкю = %d\n", прог[pc], РВсим, РВнмкю);
	switch (прог[pc])
	{
	    case РВсим:
		debug(РегВыр) win.скажи(фм("\tРВсим '%c'\n", прог[pc + 1]));
		pc += 1 + сим.sizeof;
		break;

	    case РВлсим:
		debug(РегВыр) скажифнс("\tРВлсим '%c'\n", прог[pc + 1]);
		pc += 1 + сим.sizeof;
		break;

	    case РВдим:
		debug(РегВыр) скажифнс("\tРВдим '%c'\n", *cast(дим *)&прог[pc + 1]);
		pc += 1 + дим.sizeof;
		break;

	    case РВлдим:
		debug(РегВыр) скажифнс("\tРВлдим '%c'\n", *cast(дим *)&прог[pc + 1]);
		pc += 1 + дим.sizeof;
		break;

	    case РВлюбсим:
		debug(РегВыр) win.скажи("\tРВлюбсим\n");
		pc++;
		break;

	    case РВткст:
		длин = *cast(бцел *)&прог[pc + 1];
		debug(РегВыр) скажифнс("\tРВткст x%x, '%s'\n", длин,
			(&прог[pc + 1 + бцел.sizeof])[0 .. длин]);
		pc += 1 + бцел.sizeof + длин * рсим.sizeof;
		break;

	    case РВлткст:
		длин = *cast(бцел *)&прог[pc + 1];
		debug(РегВыр) скажифнс("\tРВлткст x%x, '%s'\n", длин,
			(&прог[pc + 1 + бцел.sizeof])[0 .. длин]);
		pc += 1 + бцел.sizeof + длин * рсим.sizeof;
		break;

	    case РВтестбит:
		pu = cast(бкрат *)&прог[pc + 1];
		debug(РегВыр) скажифнс("\tРВтестбит %d, %d\n", pu[0], pu[1]);
		длин = pu[1];
		pc += 1 + 2 * бкрат.sizeof + длин;
		break;

	    case РВбит:
		pu = cast(бкрат *)&прог[pc + 1];
		длин = pu[1];
		debug(РегВыр) скажифнс("\tРВбит cmax=%x, длин=%d:", pu[0], длин);
		for (n = 0; n < длин; n++)
		  debug(РегВыр)  скажифнс(" %x", прог[pc + 1 + 2 * бкрат.sizeof + n]);
		debug(РегВыр)скажифнс("\n");
		pc += 1 + 2 * бкрат.sizeof + длин;
		break;

	    case РВнебит:
		pu = cast(бкрат *)&прог[pc + 1];
		debug(РегВыр) скажифнс("\tРВнебит %d, %d\n", pu[0], pu[1]);
		длин = pu[1];
		pc += 1 + 2 * бкрат.sizeof + длин;
		break;

	    case РВдиапазон:
		длин = *cast(бцел *)&прог[pc + 1];
		debug(РегВыр) скажифнс("\tРВдиапазон %d\n", длин);
		// BUG: REAignoreCase?
		pc += 1 + бцел.sizeof + длин;
		break;

	    case РВнедиапазон:
		длин = *cast(бцел *)&прог[pc + 1];
		debug(РегВыр) скажифнс("\tРВнедиапазон %d\n", длин);
		// BUG: REAignoreCase?
		pc += 1 + бцел.sizeof + длин;
		break;

	    case РВначстр:
		debug(РегВыр) win.скажи("\tРВначстр\n");
		pc++;
		break;

	    case РВконстр:
		debug(РегВыр) win.скажи("\tРВконстр\n");
		pc++;
		break;

	    case РВили:
		длин = *cast(бцел *)&прог[pc + 1];
		debug(РегВыр) скажифнс("\tРВили %d, pc=>%d\n", длин, pc + 1 + бцел.sizeof + длин);
		pc += 1 + бцел.sizeof;
		break;

	    case РВгоуту:
		длин = *cast(бцел *)&прог[pc + 1];
		debug(РегВыр) скажифнс("\tРВгоуту %d, pc=>%d\n", длин, pc + 1 + бцел.sizeof + длин);
		pc += 1 + бцел.sizeof;
		break;

	    case РВлюбзвезда:
		debug(РегВыр) win.скажи("\tРВлюбзвезда\n");
		pc++;
		break;

	    case РВнм:
	    case РВнмкю:
		// длин, n, m, ()
		pбцел = cast(бцел *)&прог[pc + 1];
		длин = pбцел[0];
		n = pбцел[1];
		m = pбцел[2];
		debug(РегВыр) скажифнс("\tРВнм = %s длин=%d, n=%u, m=%u, pc=>%d\n", (прог[pc] == РВнмкю) ? "q" : " ",   длин, n, m, pc + 1 + бцел.sizeof * 3 + длин);
		pc += 1 + бцел.sizeof * 3;
		break;

	    case РВвскоб:
		// длин, n, ()
		pбцел = cast(бцел *)&прог[pc + 1];
		длин = pбцел[0];
		n = pбцел[1];
		debug(РегВыр) скажифнс("\tРВвскоб длин=%d n=%d, pc=>%d\n", длин, n, pc + 1 + бцел.sizeof * 2 + длин);
		pc += 1 + бцел.sizeof * 2;
		break;

	    case РВконец:
		debug(РегВыр) win.скажи("\tРВконец\n");
		return;

	    case РВгранслова:
		debug(РегВыр) win.скажи("\tРВгранслова\n");
		pc++;
		break;

	    case РВнегранслова:
		debug(РегВыр) win.скажи("\tРВнегранслова\n");
		pc++;
		break;

	    case РВцифра:
		debug(РегВыр) win.скажи("\tРВцифра\n");
		pc++;
		break;

	    case РВнецифра:
		debug(РегВыр) win.скажи("\tРВнецифра\n");
		pc++;
		break;

	    case РВпространство:
		debug(РегВыр) win.скажи("\tРВпространство\n");
		pc++;
		break;

	    case РВнепространство:
		debug(РегВыр) win.скажи("\tРВнепространство\n");
		pc++;
		break;

	    case РВслово:
		debug(РегВыр) win.скажи("\tРВслово\n");
		pc++;
		break;

	    case РВнеслово:
		debug(РегВыр) win.скажи("\tРВнеслово\n");
		pc++;
		break;

	    case РВобрссыл:
		debug(РегВыр) скажифнс("\tРВобрссыл %d\n", прог[1]);
		pc += 2;
		break;

	    default:
		assert(0);
	}
  }
  //}
}

struct т_регсвер
{
    цел рснач;			// индекс начала совпадения
    цел рскон;			// индекс по завершению совпадения
}

export цел пробнсвер(цел pc, цел pcend)
{   цел srcsave;
    бцел длин;
    бцел n;
    бцел m;
    бцел count;
    бцел pop;
    бцел ss;
    т_регсвер *psave;
    бцел c1;
    бцел c2;
    бкрат* pu;
    бцел* pбцел;

    debug(РегВыр)	win.скажи(фм("РегВыр.пробнсвер(pc = %d, истк = '%s', pcend = %d)\n",
	    pc, ввод[истк .. ввод.length], pcend));
    srcsave = истк;
    psave = null;
    for (;;)
    {
	if (pc == pcend)		// if done matching
	{   debug(РегВыр) win.скажи("\tконецпрог\n");
	    return 1;
	}

	//эхо("\top = %d\n", программа[pc]);
	switch (программа[pc])
	{
	    case РВсим:
		if (истк == ввод.length)
		    goto Lnomatch;
		debug(РегВыр) win.скажи(фм("\tРВсим '%i', истк = '%i'\n", программа[pc + 1], ввод[истк]));
		if (программа[pc + 1] != ввод[истк])
		    goto Lnomatch;
		истк++;
		pc += 1 + сим.sizeof;
		break;

	    case РВлсим:
		if (истк == ввод.length)
		    goto Lnomatch;
		debug(РегВыр) win.скажи(фм("\tРВлсим '%i', истк = '%i'\n", программа[pc + 1], ввод[истк]));
		c1 = программа[pc + 1];
		c2 = ввод[истк];
		if (c1 != c2)
		{
		    if (проп_ли(cast(рсим)c2))
			c2 = std.ctype.toupper(cast(рсим)c2);
		    else
			goto Lnomatch;
		    if (c1 != c2)
			goto Lnomatch;
		}
		истк++;
		pc += 1 + сим.sizeof;
		break;

	    case РВдим:
		debug(РегВыр) win.скажи(фм("\tРВдим '%i', истк = '%i'\n", *(cast(дим *)&программа[pc + 1]), ввод[истк]));
		if (истк == ввод.length)
		    goto Lnomatch;
		if (*(cast(дим *)&программа[pc + 1]) != ввод[истк])
		    goto Lnomatch;
		истк++;
		pc += 1 + дим.sizeof;
		break;

	    case РВлдим:
		debug(РегВыр) win.скажи(фм("\tРВлдим '%i', истк = '%i'\n", *(cast(дим *)&программа[pc + 1]), ввод[истк]));
		if (истк == ввод.length)
		    goto Lnomatch;
		c1 = *(cast(дим *)&программа[pc + 1]);
		c2 = ввод[истк];
		if (c1 != c2)
		{
		    if (проп_ли(cast(рсим)c2))
			c2 = std.ctype.toupper(cast(рсим)c2);
		    else
			goto Lnomatch;
		    if (c1 != c2)
			goto Lnomatch;
		}
		истк++;
		pc += 1 + дим.sizeof;
		break;

	    case РВлюбсим:
		debug(РегВыр) win.скажи("\tРВлюбсим\n");
		if (истк == ввод.length)
		    goto Lnomatch;
		if (!(атрибуты & РВА.тчксовплф) && ввод[истк] == cast(рсим)'\n')
		    goto Lnomatch;
		истк += std.utf.stride(ввод, истк);
		//истк++;
		pc++;
		break;

	    case РВткст:
		длин = *cast(бцел *)&программа[pc + 1];

		if (истк + длин > ввод.length)
		    goto Lnomatch;
		if (std.c.memcmp(&программа[pc + 1 + бцел.sizeof], &ввод[истк], длин * рсим.sizeof))
		    goto Lnomatch;
		истк += длин;
		pc += 1 + бцел.sizeof + длин * рсим.sizeof;
		break;

	    case РВлткст:
		длин = *cast(бцел *)&программа[pc + 1];

		if (истк + длин > ввод.length)
		    goto Lnomatch;
		version (Win32)
		{
		    if (std.c.memicmp(cast(сим*)&программа[pc + 1 + бцел.sizeof], &ввод[истк], длин * рсим.sizeof))
			goto Lnomatch;
		}
		else
		{
		    if (icmp((cast(сим*)&программа[pc + 1 + бцел.sizeof])[0..длин],
			     ввод[истк .. истк + длин]))
			goto Lnomatch;
		}
		истк += длин;
		pc += 1 + бцел.sizeof + длин * рсим.sizeof;
		break;

	    case РВтестбит:
		pu = (cast(бкрат *)&программа[pc + 1]);

		if (истк == ввод.length)
		    goto Lnomatch;
		длин = pu[1];
		c1 = ввод[истк];
		//эхо("[x%02x]=x%02x, x%02x\n", c1 >> 3, ((&программа[pc + 1 + 4])[c1 >> 3] ), (1 << (c1 & 7)));
		if (c1 <= pu[0] &&
		    !((&(программа[pc + 1 + 4]))[c1 >> 3] & (1 << (c1 & 7))))
		    goto Lnomatch;
		pc += 1 + 2 * бкрат.sizeof + длин;
		break;

	    case РВбит:
		pu = (cast(бкрат *)&программа[pc + 1]);

		if (истк == ввод.length)
		    goto Lnomatch;
		длин = pu[1];
		c1 = ввод[истк];
		if (c1 > pu[0])
		    goto Lnomatch;
		if (!((&программа[pc + 1 + 4])[c1 >> 3] & (1 << (c1 & 7))))
		    goto Lnomatch;
		истк++;
		pc += 1 + 2 * бкрат.sizeof + длин;
		break;

	    case РВнебит:
		pu = (cast(бкрат *)&программа[pc + 1]);

		if (истк == ввод.length)
		    goto Lnomatch;
		длин = pu[1];
		c1 = ввод[истк];
		if (c1 <= pu[0] &&
		    ((&программа[pc + 1 + 4])[c1 >> 3] & (1 << (c1 & 7))))
		    goto Lnomatch;
		истк++;
		pc += 1 + 2 * бкрат.sizeof + длин;
		break;

	    case РВдиапазон:
		длин = *cast(бцел *)&программа[pc + 1];

		if (истк == ввод.length)
		    goto Lnomatch;
		// BUG: РВА.любрег?
		if (std.c.memchr(cast(сим*)&программа[pc + 1 + бцел.sizeof], ввод[истк], длин) == null)
		    goto Lnomatch;
		истк++;
		pc += 1 + бцел.sizeof + длин;
		break;

	    case РВнедиапазон:
		длин = *cast(бцел *)&программа[pc + 1];

		if (истк == ввод.length)
		    goto Lnomatch;
		// BUG: РВА.любрег?
		if (std.c.memchr(cast(сим*)&программа[pc + 1 + бцел.sizeof], ввод[истк], длин) != null)
		    goto Lnomatch;
		истк++;
		pc += 1 + бцел.sizeof + длин;
		break;

	    case РВначстр:

		if (истк == 0)
		{
		}
		else if (атрибуты & РВА.многострок)
		{
		    if (ввод[истк - 1] != '\n')
			goto Lnomatch;
		}
		else
		    goto Lnomatch;
		pc++;
		break;

	    case РВконстр:

		if (истк == ввод.length)
		{
		}
		else if (атрибуты & РВА.многострок && ввод[истк] == '\n')
		    истк++;
		else
		    goto Lnomatch;
		pc++;
		break;

	    case РВили:
		длин = (cast(бцел *)&программа[pc + 1])[0];

		pop = pc + 1 + бцел.sizeof;
		ss = истк;
		if (пробнсвер(pop, pcend))
		{
		    if (pcend != программа.length)
		    {	цел т;

			т = истк;
			if (пробнсвер(pcend, программа.length))
			{ 
			    истк = т;
			    return 1;
			}
			else
			{
			    // If second branch doesn't сверь to end, take first anyway
			    истк = ss;
			    if (!пробнсвер(pop + длин, программа.length))
			    {
		
				истк = т;
				return 1;
			    }
			}
			истк = ss;
		    }
		    else
		    {	
			return 1;
		    }
		}
		pc = pop + длин;		// proceed with 2nd branch
		break;

	    case РВгоуту:

		длин = (cast(бцел *)&программа[pc + 1])[0];
		pc += 1 + бцел.sizeof + длин;
		break;

	    case РВлюбзвезда:
		
		pc++;
		for (;;)
		{   цел s1;
		    цел s2;

		    s1 = истк;
		    if (истк == ввод.length)
			break;
		    if (!(атрибуты & РВА.тчксовплф) && ввод[истк] == '\n')
			break;
		    истк++;
		    s2 = истк;

		    // If no сверь after consumption, but it
		    // did сверь before, then no сверь
		    if (!пробнсвер(pc, программа.length))
		    {
			истк = s1;
			// BUG: should we save/restore псовп[]?
			if (пробнсвер(pc, программа.length))
			{
			    истк = s1;		// no сверь
			    break;
			}
		    }
		    истк = s2;
		}
		break;

	    case РВнм:
	    case РВнмкю:
		// длин, n, m, ()
		pбцел = cast(бцел *)&программа[pc + 1];
		длин = pбцел[0];
		n = pбцел[1];
		m = pбцел[2];
		
		pop = pc + 1 + бцел.sizeof * 3;
		for (count = 0; count < n; count++)
		{
		    if (!пробнсвер(pop, pop + длин))
			goto Lnomatch;
		}
		if (!psave && count < m)
		{
		    //version (Win32)
			psave = cast(т_регсвер *)std.c.alloca((члоподстр + 1) * т_регсвер.sizeof);
		    //else
			//psave = new т_регсвер[члоподстр + 1];
		}
		if (программа[pc] == РВнмкю)	// if minimal munch
		{
		    for (; count < m; count++)
		    {   цел s1;

			std.c.memcpy(psave, псовп.ptr, (члоподстр + 1) * т_регсвер.sizeof);
			s1 = истк;

			if (пробнсвер(pop + длин, программа.length))
			{
			    истк = s1;
			    std.c.memcpy(псовп.ptr, psave, (члоподстр + 1) * т_регсвер.sizeof);
			    break;
			}

			if (!пробнсвер(pop, pop + длин))
			{  
			    break;
			}

			// If source is not consumed, don't
			// infinite loop on the сверь
			if (s1 == истк)
			{   
			    break;
			}
		    }
		}
		else	// maximal munch
		{
		    for (; count < m; count++)
		    {   цел s1;
			цел s2;

			std.c.memcpy(psave, псовп.ptr, (члоподстр + 1) * т_регсвер.sizeof);
			s1 = истк;
			if (!пробнсвер(pop, pop + длин))
			{   
			    break;
			}
			s2 = истк;

			// If source is not consumed, don't
			// infinite loop on the сверь
			if (s1 == s2)
			{  
			    break;
			}

			// If no сверь after consumption, but it
			// did сверь before, then no сверь
			if (!пробнсвер(pop + длин, программа.length))
			{
			    истк = s1;
			    if (пробнсвер(pop + длин, программа.length))
			    {
				истк = s1;		// no сверь
				std.c.memcpy(псовп.ptr, psave, (члоподстр + 1) * т_регсвер.sizeof);
				break;
			    }
			}
			истк = s2;
		    }
		}
		
		pc = pop + длин;
		break;

	    case РВвскоб:
		// длин, ()
		
		pбцел = cast(бцел *)&программа[pc + 1];
		длин = pбцел[0];
		n = pбцел[1];
		pop = pc + 1 + бцел.sizeof * 2;
		ss = истк;
		if (!пробнсвер(pop, pop + длин))
		    goto Lnomatch;
		псовп[n + 1].рснач = ss;
		псовп[n + 1].рскон = истк;
		pc = pop + длин;
		break;

	    case РВконец:
		
		return 1;		// successful сверь

	    case РВгранслова:
		
		if (истк > 0 && истк < ввод.length)
		{
		    c1 = ввод[истк - 1];
		    c2 = ввод[истк];
		    if (!(
			  (слово_ли(cast(рсим)c1) && !слово_ли(cast(рсим)c2)) ||
			  (!слово_ли(cast(рсим)c1) && слово_ли(cast(рсим)c2))
			 )
		       )
			goto Lnomatch;
		}
		pc++;
		break;

	    case РВнегранслова:
		
		if (истк == 0 || истк == ввод.length)
		    goto Lnomatch;
		c1 = ввод[истк - 1];
		c2 = ввод[истк];
		if (
		    (слово_ли(cast(рсим)c1) && !слово_ли(cast(рсим)c2)) ||
		    (!слово_ли(cast(рсим)c1) && слово_ли(cast(рсим)c2))
		   )
		    goto Lnomatch;
		pc++;
		break;

	    case РВцифра:
		
		if (истк == ввод.length)
		    goto Lnomatch;
		if (!std.ctype.isdigit(ввод[истк]))
		    goto Lnomatch;
		истк++;
		pc++;
		break;

	    case РВнецифра:
		
		if (истк == ввод.length)
		    goto Lnomatch;
		if (std.ctype.isdigit(ввод[истк]))
		    goto Lnomatch;
		истк++;
		pc++;
		break;

	    case РВпространство:
		
		if (истк == ввод.length)
		    goto Lnomatch;
		if (!межбукв_ли(ввод[истк]))
		    goto Lnomatch;
		истк++;
		pc++;
		break;

	    case РВнепространство:
		
		if (истк == ввод.length)
		    goto Lnomatch;
		if (межбукв_ли(ввод[истк]))
		    goto Lnomatch;
		истк++;
		pc++;
		break;

	    case РВслово:
		
		if (истк == ввод.length)
		    goto Lnomatch;
		if (!слово_ли(ввод[истк]))
		    goto Lnomatch;
		истк++;
		pc++;
		break;

	    case РВнеслово:
		
		if (истк == ввод.length)
		    goto Lnomatch;
		if (слово_ли(ввод[истк]))
		    goto Lnomatch;
		истк++;
		pc++;
		break;

	    case РВобрссыл:
	    {
		n = программа[pc + 1];
		

		цел so = псовп[n + 1].рснач;
		цел eo = псовп[n + 1].рскон;
		длин = eo - so;
		if (истк + длин > ввод.length)
		    goto Lnomatch;
		else if (атрибуты & РВА.любрег)
		{
		    if (icmp(ввод[истк .. истк + длин], ввод[so .. eo]))
			goto Lnomatch;
		}
		else if (std.c.memcmp(&ввод[истк], &ввод[so], длин * рсим.sizeof))
		    goto Lnomatch;
		истк += длин;
		pc += 2;
		break;
	    }

	    default:
		assert(0);
	}
    }

Lnomatch:
   
    истк = srcsave;
    return 0;
}

/* =================== Compiler ================== */

export цел разборРегвыр()
{   бцел смещение;
    бцел переходКсмещению;
    бцел len1;
    бцел len2;

   
    смещение = буф.смещение;
    for (;;)
    {
	assert(p <= образец.length);
	if (p == образец.length)
	{   буф.пиши(РВконец);
	    return 1;
	}
	switch (образец[p])
	{
	    case ')':
		return 1;

	    case '|':
		p++;
		переходКсмещению = буф.смещение;
		буф.пиши(РВгоуту);
		буф.пиши(cast(бцел)0);
		len1 = буф.смещение - смещение;
		буф.простели(смещение, 1 + бцел.sizeof);
		переходКсмещению += 1 + бцел.sizeof;
		разборРегвыр();
		len2 = буф.смещение - (переходКсмещению + 1 + бцел.sizeof);
		буф.данные[смещение] = РВили;
		(cast(бцел *)&буф.данные[смещение + 1])[0] = len1;
		(cast(бцел *)&буф.данные[переходКсмещению + 1])[0] = len2;
		break;

	    default:
		разборКуска();
		break;
	}
    }
}

export цел разборКуска()
{   бцел смещение;
    бцел длин;
    бцел n;
    бцел m;
    ббайт op;
    цел plength = образец.length;

    debug(РегВыр)  скажифнс("разборКуска() '%s'\n", образец[p .. образец.length]);
    смещение = буф.смещение;
    разборАтома();
    if (p == plength)
	return 1;
    switch (образец[p])
    {
	case '*':
	    // Special optimization: замени .* with РВлюбзвезда
	    if (буф.смещение - смещение == 1 &&
		буф.данные[смещение] == РВлюбсим &&
		p + 1 < plength &&
		образец[p + 1] != '?')
	    {
		буф.данные[смещение] = РВлюбзвезда;
		p++;
		break;
	    }

	    n = 0;
	    m = бескн;
	    goto Lnm;

	case '+':
	    n = 1;
	    m = бескн;
	    goto Lnm;

	case '?':
	    n = 0;
	    m = 1;
	    goto Lnm;

	case '{':	// {n} {n,} {n,m}
	    p++;
	    if (p == plength || !std.ctype.isdigit(образец[p]))
		goto Lerr;
	    n = 0;
	    do
	    {
		// BUG: хэндл overflow
		n = n * 10 + образец[p] - '0';
		p++;
		if (p == plength)
		    goto Lerr;
	    } while (std.ctype.isdigit(образец[p]));
	    if (образец[p] == '}')		// {n}
	    {	m = n;
		goto Lnm;
	    }
	    if (образец[p] != ',')
		goto Lerr;
	    p++;
	    if (p == plength)
		goto Lerr;
	    if (образец[p] == /*{*/ '}')	// {n,}
	    {	m = бескн;
		goto Lnm;
	    }
	    if (!std.ctype.isdigit(образец[p]))
		goto Lerr;
	    m = 0;			// {n,m}
	    do
	    {
		// BUG: хэндл overflow
		m = m * 10 + образец[p] - '0';
		p++;
		if (p == plength)
		    goto Lerr;
	    } while (std.ctype.isdigit(образец[p]));
	    if (образец[p] != /*{*/ '}')
		goto Lerr;
	    goto Lnm;

	Lnm:
	    p++;
	    op = РВнм;
	    if (p < plength && образец[p] == '?')
	    {	op = РВнмкю;	// minimal munch version
		p++;
	    }
	    длин = буф.смещение - смещение;
	    буф.простели(смещение, 1 + бцел.sizeof * 3);
	    буф.данные[смещение] = op;
	    бцел* pбцел = cast(бцел *)&буф.данные[смещение + 1];
	    pбцел[0] = длин;
	    pбцел[1] = n;
	    pбцел[2] = m;
	    break;

	default:
	    break;
    }
    return 1;

Lerr:
    error("неверно оформленные {n,m}");
    assert(0);
}

export цел разборАтома()
{   ббайт op;
    бцел смещение;
    рсим c;

    debug(РегВыр) скажифнс("разборАтома() '%s'\n", образец[p .. образец.length]);
    if (p < образец.length)
    {
	c = образец[p];
	switch (c)
	{
	    case '*':
	    case '+':
	    case '?':
		error("*+? недопустимо в атоме");
		p++;
		return 0;

	    case '(':
		p++;
		буф.пиши(РВвскоб);
		смещение = буф.смещение;
		буф.пиши(cast(бцел)0);		// резервируй space for length
		буф.пиши(члоподстр);
		члоподстр++;
		разборРегвыр();
		*cast(бцел *)&буф.данные[смещение] =
		    буф.смещение - (смещение + бцел.sizeof * 2);
		if (p == образец.length || образец[p] != ')')
		{
		    error("')' ожидалось");
		    return 0;
		}
		p++;
		break;

	    case '[':
		if (!parseRange())
		    return 0;
		break;

	    case '.':
		p++;
		буф.пиши(РВлюбсим);
		break;

	    case '^':
		p++;
		буф.пиши(РВначстр);
		break;

	    case '$':
		p++;
		буф.пиши(РВконстр);
		break;

	    case '\\':
		p++;
		if (p == образец.length)
		{ 
		error("отсутствие символов после '\\'");
		    return 0;
		}
		c = образец[p];
		switch (c)
		{
		    case 'b':    op = РВгранслова;	 goto Lop;
		    case 'B':    op = РВнегранслова; goto Lop;
		    case 'd':    op = РВцифра;		 goto Lop;
		    case 'D':    op = РВнецифра;	 goto Lop;
		    case 's':    op = РВпространство;		 goto Lop;
		    case 'S':    op = РВнепространство;	 goto Lop;
		    case 'w':    op = РВслово;		 goto Lop;
		    case 'W':    op = РВнеслово;	 goto Lop;

		    Lop:
			буф.пиши(op);
			p++;
			break;

		    case 'f':
		    case 'n':
		    case 'r':
		    case 't':
		    case 'v':
		    case 'c':
		    case 'x':
		    case 'u':
		    case '0':
			c = cast(сим)escape();
			goto Lbyte;

		    case '1': case '2': case '3':
		    case '4': case '5': case '6':
		    case '7': case '8': case '9':
			c -= '1';
			if (c < члоподстр)
			{   буф.пиши(РВобрссыл);
			    буф.пиши(cast(ббайт)c);
			}
			else
			{   error("нет соответствующей обратной ссылки");
			    return 0;
			}
			p++;
			break;

		    default:
			p++;
			goto Lbyte;
		}
		break;

	    default:
		p++;
	    Lbyte:
		op = РВсим;
		if (атрибуты & РВА.любрег)
		{
		    if (буква_ли(c))
		    {
			op = РВлсим;
			c = cast(сим)std.ctype.toupper(c);
		    }
		}
		if (op == РВсим && c <= 0xFF)
		{
		    // Look ahead and see if we can make this целo
		    // an РВткст
		    цел q;
		    цел длин;

		    for (q = p; q < образец.length; ++q)
		    {	рсим qc = образец[q];

			switch (qc)
			{
			    case '{':
			    case '*':
			    case '+':
			    case '?':
				if (q == p)
				    goto Lсим;
				q--;
				break;

			    case '(':	case ')':
			    case '|':
			    case '[':	case ']':
			    case '.':	case '^':
			    case '$':	case '\\':
			    case '}':
				break;

			    default:
				continue;
			}
			break;
		    }
		    длин = q - p;
		    if (длин > 0)
		    {
			debug(РегВыр) скажифнс("записывается текст длин %d, c = '%c', образец[p] = '%c'\n", длин+1, c, образец[p]);
			буф.резервируй(5 + (1 + длин) * рсим.sizeof);
			буф.пиши((атрибуты & РВА.любрег) ? РВлткст : РВткст);
			буф.пиши(длин + 1);
			буф.пиши(c);
			буф.пиши(образец[p .. p + длин]);
			p = q;
			break;
		    }
		}
		if (c >= 0x80)
		{
		    // Convert to дим opcode
		    op = (op == РВсим) ? РВдим : РВлдим;
		    буф.пиши(op);
		    буф.пиши(c);
		}
		else
		{
		 Lсим:
		    debug(РегВыр) скажифнс(" РВсим '%c'\n", c);
		    буф.пиши(op);
		    буф.пиши(cast(сим)c);
		}
		break;
	}
    }
    return 1;
}


class Range
{
    бцел maxc;
    бцел maxb;
    БуферВывода буф;
    ббайт* base;
    BitArray bits;

    this(БуферВывода буф)
    {
	this.буф = буф;
	if (буф.данные.length)
	    this.base = &буф.данные[буф.смещение];
    }

    проц setbitmax(бцел u)
    {   бцел b;

	//эхо("setbitmax(x%x), maxc = x%x\n", u, maxc);
	if (u > maxc)
	{
	    maxc = u;
	    b = u / 8;
	    if (b >= maxb)
	    {	бцел u2;

		u2 = base ? base - &буф.данные[0] : 0;
		буф.занули(b - maxb + 1);
		base = &буф.данные[u2];
		maxb = b + 1;
		//bits = (cast(bit*)this.base)[0 .. maxc + 1];
		bits.ptr = cast(бцел*)this.base;
	    }
	    bits.длин = maxc + 1;
	}
    }

    проц setbit2(бцел u)
    {
	setbitmax(u + 1);
	//эхо("setbit2 [x%02x] |= x%02x\n", u >> 3, 1 << (u & 7));
	bits[u] = 1;
    }

};

цел parseRange()
{   ббайт op;
    цел c;
    цел c2;
    бцел i;
    бцел cmax;
    бцел смещение;

    cmax = 0x7F;
    p++;
    op = РВбит;
    if (p == образец.length)
	goto Lerr;
    if (образец[p] == '^')
    {   p++;
	op = РВнебит;
	if (p == образец.length)
	    goto Lerr;
    }
    буф.пиши(op);
    смещение = буф.смещение;
    буф.пиши(cast(бцел)0);		// резервируй space for length
    буф.резервируй(128 / 8);
    auto r = new Range(буф);
    if (op == РВнебит)
	r.setbit2(0);
    switch (образец[p])
    {
	case ']':
	case '-':
	    c = образец[p];
	    p++;
	    r.setbit2(c);
	    break;

	default:
	    break;
    }

    enum RS { старт, rliteral, dash };
    RS rs;

    rs = RS.старт;
    for (;;)
    {
	if (p == образец.length)
	    goto Lerr;
	switch (образец[p])
	{
	    case ']':
		switch (rs)
		{   case RS.dash:
			r.setbit2('-');
		    case RS.rliteral:
			r.setbit2(c);
			break;
		    case RS.старт:
			break;
		    default:
			assert(0);
		}
		p++;
		break;

	    case '\\':
		p++;
		r.setbitmax(cmax);
		if (p == образец.length)
		    goto Lerr;
		switch (образец[p])
		{
		    case 'd':
			for (i = '0'; i <= '9'; i++)
			    r.bits[i] = 1;
			goto Lrs;

		    case 'D':
			for (i = 1; i < '0'; i++)
			    r.bits[i] = 1;
			for (i = '9' + 1; i <= cmax; i++)
			    r.bits[i] = 1;
			goto Lrs;

		    case 's':
			for (i = 0; i <= cmax; i++)
			    if (межбукв_ли(i))
				r.bits[i] = 1;
			goto Lrs;

		    case 'S':
			for (i = 1; i <= cmax; i++)
			    if (!межбукв_ли(i))
				r.bits[i] = 1;
			goto Lrs;

		    case 'w':
			for (i = 0; i <= cmax; i++)
			    if (слово_ли(cast(рсим)i))
				r.bits[i] = 1;
			goto Lrs;

		    case 'W':
			for (i = 1; i <= cmax; i++)
			    if (!слово_ли(cast(рсим)i))
				r.bits[i] = 1;
			goto Lrs;

		    Lrs:
			switch (rs)
			{   case RS.dash:
				r.setbit2('-');
			    case RS.rliteral:
				r.setbit2(c);
				break;
			    default:
				break;
			}
			rs = RS.старт;
			continue;

		    default:
			break;
		}
		c2 = escape();
		goto Lrange;

	    case '-':
		p++;
		if (rs == RS.старт)
		    goto Lrange;
		else if (rs == RS.rliteral)
		    rs = RS.dash;
		else if (rs == RS.dash)
		{
		    r.setbit2(c);
		    r.setbit2('-');
		    rs = RS.старт;
		}
		continue;

	    default:
		c2 = образец[p];
		p++;
	    Lrange:
		switch (rs)
		{   case RS.rliteral:
			r.setbit2(c);
		    case RS.старт:
			c = c2;
			rs = RS.rliteral;
			break;

		    case RS.dash:
			if (c > c2)
			{   error("инвертированный диапазон в классе символов");
			    return 0;
			}
			r.setbitmax(c2);
			//эхо("c = %x, c2 = %x\n",c,c2);
			for (; c <= c2; c++)
			    r.bits[c] = 1;
			rs = RS.старт;
			break;

		    default:
			assert(0);
		}
		continue;
	}
	break;
    }
    if (атрибуты & РВА.любрег)
    {
	// BUG: what about дим?
	r.setbitmax(0x7F);
	for (c = 'a'; c <= 'z'; c++)
	{
	    if (r.bits[c])
		r.bits[c + 'A' - 'a'] = 1;
	    else if (r.bits[c + 'A' - 'a'])
		r.bits[c] = 1;
	}
    }
    //эхо("maxc = %d, maxb = %d\n",r.maxc,r.maxb);
    (cast(бкрат *)&буф.данные[смещение])[0] = cast(бкрат)r.maxc;
    (cast(бкрат *)&буф.данные[смещение])[1] = cast(бкрат)r.maxb;
    return 1;

Lerr:
    error("неверный диапазон");
    return 0;
}

проц error(ткст msg)
{
    ошибки++;
    debug(РегВыр) скажифнс("ошибка: %s\n", msg);
//assert(0);
//*(сим*)0=0;
    throw new ИсключениеРегВыр(msg);
}

// p is following the \ сим
цел escape()
in
{
    assert(p < образец.length);
}
body
{   цел c;
    цел i;
    рсим tc;

    c = образец[p];		// none of the cases are multibyte
    switch (c)
    {
	case 'b':    c = '\b';	break;
	case 'f':    c = '\f';	break;
	case 'n':    c = '\n';	break;
	case 'r':    c = '\r';	break;
	case 't':    c = '\t';	break;
	case 'v':    c = '\v';	break;

	// BUG: Perl does \a and \e too, should we?

	case 'c':
	    ++p;
	    if (p == образец.length)
		goto Lretc;
	    c = образец[p];
	    // Note: we are deliberately not allowing дим letters
	    if (!(('a' <= c && c <= 'z') || ('A' <= c && c <= 'Z')))
	    {
	     Lcerr:
		error("ожидалась буква после \\c");
		return 0;
	    }
	    c &= 0x1F;
	    break;

	case '0':
	case '1':
	case '2':
	case '3':
	case '4':
	case '5':
	case '6':
	case '7':
	    c -= '0';
	    for (i = 0; i < 2; i++)
	    {
		p++;
		if (p == образец.length)
		    goto Lretc;
		tc = образец[p];
		if ('0' <= tc && tc <= '7')
		{   c = c * 8 + (tc - '0');
		    // Treat overflow as if last
		    // digit was not an octal digit
		    if (c >= 0xFF)
		    {	c >>= 3;
			return c;
		    }
		}
		else
		    return c;
	    }
	    break;

	case 'x':
	    c = 0;
	    for (i = 0; i < 2; i++)
	    {
		p++;
		if (p == образец.length)
		    goto Lretc;
		tc = образец[p];
		if ('0' <= tc && tc <= '9')
		    c = c * 16 + (tc - '0');
		else if ('a' <= tc && tc <= 'f')
		    c = c * 16 + (tc - 'a' + 10);
		else if ('A' <= tc && tc <= 'F')
		    c = c * 16 + (tc - 'A' + 10);
		else if (i == 0)	// if no hex digits after \x
		{
		    // Not a значid \xXX sequence
		    return 'x';
		}
		else
		    return c;
	    }
	    break;

	case 'u':
	    c = 0;
	    for (i = 0; i < 4; i++)
	    {
		p++;
		if (p == образец.length)
		    goto Lretc;
		tc = образец[p];
		if ('0' <= tc && tc <= '9')
		    c = c * 16 + (tc - '0');
		else if ('a' <= tc && tc <= 'f')
		    c = c * 16 + (tc - 'a' + 10);
		else if ('A' <= tc && tc <= 'F')
		    c = c * 16 + (tc - 'A' + 10);
		else
		{
		    // Not a значid \uXXXX sequence
		    p -= i;
		    return 'u';
		}
	    }
	    break;

	default:
	    break;
    }
    p++;
Lretc:
    return c;
}

/* ==================== optimizer ======================= */

export проц оптимизируй()
{   ббайт[] прог;

    debug(РегВыр) win.скажи("РегВыр.оптимизируй()\n");
    прог = буф.вБайты();
    for (т_мера i = 0; 1;)
    {
	//эхо("\tprog[%d] = %d, %d\n", i, прог[i], РВткст);
	switch (прог[i])
	{
	    case РВконец:
	    case РВлюбсим:
	    case РВлюбзвезда:
	    case РВобрссыл:
	    case РВконстр:
	    case РВсим:
	    case РВлсим:
	    case РВдим:
	    case РВлдим:
	    case РВткст:
	    case РВлткст:
	    case РВтестбит:
	    case РВбит:
	    case РВнебит:
	    case РВдиапазон:
	    case РВнедиапазон:
	    case РВгранслова:
	    case РВнегранслова:
	    case РВцифра:
	    case РВнецифра:
	    case РВпространство:
	    case РВнепространство:
	    case РВслово:
	    case РВнеслово:
		return;

	    case РВначстр:
		i++;
		continue;

	    case РВили:
	    case РВнм:
	    case РВнмкю:
	    case РВвскоб:
	    case РВгоуту:
	    {
		auto bitbuf = new БуферВывода;
		auto r = new Range(bitbuf);
		бцел смещение;

		смещение = i;
		if (starrchars(r, прог[i .. прог.length]))
		{
		    debug(РегВыр) эхо("\tfilter built\n");
		    буф.простели(смещение, 1 + 4 + r.maxb);
		    буф.данные[смещение] = РВтестбит;
		    (cast(бкрат *)&буф.данные[смещение + 1])[0] = cast(бкрат)r.maxc;
		    (cast(бкрат *)&буф.данные[смещение + 1])[1] = cast(бкрат)r.maxb;
		    i = смещение + 1 + 4;
		    буф.данные[i .. i + r.maxb] = r.base[0 .. r.maxb];
		}
		return;
	    }
	    default:
		assert(0);
	}
    }
}

/////////////////////////////////////////
// OR the leading символ bits целo r.
// Limit the символ range from 0..7F,
// пробнсвер() will allow through anything over maxc.
// Return 1 if success, 0 if we can't build a filter or
// if there is no poцел to one.

export цел starrchars(Range r, ббайт[] прог)
{   рсим c;
    бцел maxc;
    бцел maxb;
    бцел длин;
    бцел b;
    бцел n;
    бцел m;
    ббайт* pop;

  //  debug(РегВыр) скажифнс("РегВыр.starrchars(прог = %p, progend = %p)\n", прог, progend);
    for (т_мера i = 0; i < прог.length;)
    {
	switch (прог[i])
	{
	    case РВсим:
		c = прог[i + 1];
		if (c <= 0x7F)
		    r.setbit2(c);
		return 1;

	    case РВлсим:
		c = прог[i + 1];
		if (c <= 0x7F)
		{   r.setbit2(c);
		    r.setbit2(std.ctype.tolower(cast(рсим)c));
		}
		return 1;

	    case РВдим:
	    case РВлдим:
		return 1;

	    case РВлюбсим:
		return 0;		// no poцел

	    case РВткст:
		длин = *cast(бцел *)&прог[i + 1];
		assert(длин);
		c = *cast(рсим *)&прог[i + 1 + бцел.sizeof];
		debug(РегВыр) скажифнс("\tРВткст %d, '%c'\n", длин, c);
		if (c <= 0x7F)
		    r.setbit2(c);
		return 1;

	    case РВлткст:
		длин = *cast(бцел *)&прог[i + 1];
		assert(длин);
		c = *cast(рсим *)&прог[i + 1 + бцел.sizeof];
		debug(РегВыр) скажифнс("\tРВлткст %d, '%c'\n", длин, c);
		if (c <= 0x7F)
		{   r.setbit2(std.ctype.toupper(cast(рсим)c));
		    r.setbit2(std.ctype.tolower(cast(рсим)c));
		}
		return 1;

	    case РВтестбит:
	    case РВбит:
		maxc = (cast(бкрат *)&прог[i + 1])[0];
		maxb = (cast(бкрат *)&прог[i + 1])[1];
		if (maxc <= 0x7F)
		    r.setbitmax(maxc);
		else
		    maxb = r.maxb;
		for (b = 0; b < maxb; b++)
		    r.base[b] |= прог[i + 1 + 4 + b];
		return 1;

	    case РВнебит:
		maxc = (cast(бкрат *)&прог[i + 1])[0];
		maxb = (cast(бкрат *)&прог[i + 1])[1];
		if (maxc <= 0x7F)
		    r.setbitmax(maxc);
		else
		    maxb = r.maxb;
		for (b = 0; b < maxb; b++)
		    r.base[b] |= ~прог[i + 1 + 4 + b];
		return 1;

	    case РВначстр:
	    case РВконстр:
		return 0;

	    case РВили:
		длин = (cast(бцел *)&прог[i + 1])[0];
		return starrchars(r, прог[i + 1 + бцел.sizeof .. прог.length]) &&
		       starrchars(r, прог[i + 1 + бцел.sizeof + длин .. прог.length]);

	    case РВгоуту:
		длин = (cast(бцел *)&прог[i + 1])[0];
		i += 1 + бцел.sizeof + длин;
		break;

	    case РВлюбзвезда:
		return 0;

	    case РВнм:
	    case РВнмкю:
		// длин, n, m, ()
		длин = (cast(бцел *)&прог[i + 1])[0];
		n   = (cast(бцел *)&прог[i + 1])[1];
		m   = (cast(бцел *)&прог[i + 1])[2];
		pop = &прог[i + 1 + бцел.sizeof * 3];
		if (!starrchars(r, pop[0 .. длин]))
		    return 0;
		if (n)
		    return 1;
		i += 1 + бцел.sizeof * 3 + длин;
		break;

	    case РВвскоб:
		// длин, ()
		длин = (cast(бцел *)&прог[i + 1])[0];
		n   = (cast(бцел *)&прог[i + 1])[1];
		pop = &прог[0] + i + 1 + бцел.sizeof * 2;
		return starrchars(r, pop[0 .. длин]);

	    case РВконец:
		return 0;

	    case РВгранслова:
	    case РВнегранслова:
		return 0;

	    case РВцифра:
		r.setbitmax('9');
		for (c = '0'; c <= '9'; c++)
		    r.bits[c] = 1;
		return 1;

	    case РВнецифра:
		r.setbitmax(0x7F);
		for (c = 0; c <= '0'; c++)
		    r.bits[c] = 1;
		for (c = '9' + 1; c <= r.maxc; c++)
		    r.bits[c] = 1;
		return 1;

	    case РВпространство:
		r.setbitmax(0x7F);
		for (c = 0; c <= r.maxc; c++)
		    if (межбукв_ли(c))
			r.bits[c] = 1;
		return 1;

	    case РВнепространство:
		r.setbitmax(0x7F);
		for (c = 0; c <= r.maxc; c++)
		    if (!межбукв_ли(c))
			r.bits[c] = 1;
		return 1;

	    case РВслово:
		r.setbitmax(0x7F);
		for (c = 0; c <= r.maxc; c++)
		    if (слово_ли(cast(рсим)c))
			r.bits[c] = 1;
		return 1;

	    case РВнеслово:
		r.setbitmax(0x7F);
		for (c = 0; c <= r.maxc; c++)
		    if (!слово_ли(cast(рсим)c))
			r.bits[c] = 1;
		return 1;

	    case РВобрссыл:
		return 0;

	    default:
		assert(0);
	}
    }
    return 1;
}


 export рсим[] замени(рсим[] формат)
{
    return замени3(формат, ввод, псовп[0 .. члоподстр + 1]);
}

// Static version that doesn't require a РегВыр объект to be created

 export static рсим[] замени3(рсим[] формат, рсим[] ввод, т_регсвер[] псовп)
{
    рсим[] результат;
    бцел c2;
    цел рснач;
    цел рскон;
    цел i;
   debug(РегВыр) скажифнс("замени3(формат = '%s', ввод = '%s')\n", формат, ввод);
    результат.length = формат.length;
    результат.length = 0;
    for (т_мера f = 0; f < формат.length; f++)
    {
	auto c = формат[f];
      L1:
	if (c != '$')
	{
	    результат ~= c;
	    continue;
	}
	++f;
	if (f == формат.length)
	{
	    результат ~= '$';
	    break;
	}
	c = формат[f];
	switch (c)
	{
	    case '&':
		рснач = псовп[0].рснач;
		рскон = псовп[0].рскон;
		goto Lstring;

	    case '`':
		рснач = 0;
		рскон = псовп[0].рснач;
		goto Lstring;

	    case '\'':
		рснач = псовп[0].рскон;
		рскон = ввод.length;
		goto Lstring;

	    case '0': case '1': case '2': case '3': case '4':
	    case '5': case '6': case '7': case '8': case '9':
		i = c - '0';
		if (f + 1 == формат.length)
		{
		    if (i == 0)
		    {
			результат ~= '$';
			результат ~= c;
			continue;
		    }
		}
		else
		{
		    c2 = формат[f + 1];
		    if (c2 >= '0' && c2 <= '9')
		    {   i = (c - '0') * 10 + (c2 - '0');
			f++;
		    }
		    if (i == 0)
		    {
			результат ~= '$';
			результат ~= c;
			c = cast(сим)c2;
			goto L1;
		    }
		}

		if (i < псовп.length)
		{   рснач = псовп[i].рснач;
		    рскон = псовп[i].рскон;
		    goto Lstring;
		}
		break;

	    Lstring:
		if (рснач != рскон)
		    результат ~= ввод[рснач .. рскон];
		break;

	    default:
		результат ~= '$';
		результат ~= c;
		break;
	}
    }
    return результат;
}

 export рсим[] замениСтарый(рсим[] формат)
{
    рсим[] результат;

//debug(РегВыр)  скажифнс("замени: this = %p so = %d, eo = %d\n", this, псовп[0].рснач, псовп[0].рскон);
//эхо("3input = '%.*т'\n", ввод);
    результат.length = формат.length;
    результат.length = 0;
    for (т_мера i; i < формат.length; i++)
    {
	auto c = формат[i];
	switch (c)
	{
	    case '&':
//эхо("сверь = '%.*т'\n", ввод[псовп[0].рснач .. псовп[0].рскон]);
		результат ~= ввод[псовп[0].рснач .. псовп[0].рскон];
		break;

	    case '\\':
		if (i + 1 < формат.length)
		{
		    c = формат[++i];
		    if (c >= '1' && c <= '9')
		    {   бцел j;

			j = c - '0';
			if (j <= члоподстр && псовп[j].рснач != псовп[j].рскон)
			    результат ~= ввод[псовп[j].рснач .. псовп[j].рскон];
			break;
		    }
		}
		результат ~= c;
		break;

	    default:
		результат ~= c;
		break;
	}
    }
    return результат;
}

}



	import std.process;

	цел система (ткст команда)
	{
	return cast(цел) std.process.system(cast(ткст) команда);
	}

	цел пауза(){система("pause"); return 0;}
	
	цел пускпрог(цел режим, ткст путь, ткст[] арги)
	{
	return cast(цел) std.process.spawnvp(cast(цел) режим, cast(ткст) путь, cast(ткст[]) арги);
	}

	цел выппрог(ткст путь, ткст[] арги)
	{
	return cast(цел)  std.process.execv(cast(ткст) путь, cast(ткст[]) арги);
	}

	цел выппрог(ткст путь, ткст[] арги, ткст[] перемср)
	{
	return cast(цел) std.process.execve(cast(ткст) путь, cast(ткст[]) арги, cast(ткст[]) перемср);
	}

	цел выппрогcp(ткст путь, ткст[] арги)
	{
	return cast(цел) std.process.execvp(cast(ткст) путь, cast(ткст[]) арги);
	}

	цел выппрогср(ткст путь, ткст[] арги, ткст[] перемср)
	{
	return cast(цел) std.process.execve(cast(ткст) путь, cast(ткст[]) арги, cast(ткст[]) перемср);
	}
}
/////////////////////////////////////

