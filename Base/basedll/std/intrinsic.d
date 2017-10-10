// Written in the D programming language
/** Эти функции встроенные в компилятор DMD "интринсики".
 *
	Интринсвные функции - функции, которые встроены в компилятор,
	обычно для получения преимуществ от каких-либо средств CPU,
	с которыми работа через внешние функции менее эффективна.
	Отпимизатор компилятора и генератор кода полностью
	интегрированы через интринсивные функции, что даёт им
	полноту мощи.
	Это приводит в удивительным ускорениям.
 *
 * Copyright: Public Domain
 * License:   Public Domain
 * Authors:   Walter Bright
 * Macros:
 *	WIKI=Phobos/StdIntrinsic
 */

module std.intrinsic;

/**
 * Scans the bits in v starting with bit 0, looking
 * for the first set bit.
 * Returns:
 *	The bit number of the first bit set.
 *	The return value is undefined if v is zero.
 */
int bsf(uint v);

/**
 * Scans the bits in v from the most significant bit
 * to the least significant bit, looking
 * for the first set bit.
 * Returns:
 *	The bit number of the first bit set.
 *	The return value is undefined if v is zero.
 * Example:
 * ---
 * import std.io;
 * import std.intrinsic;
 *
 * int main()
 * {
 *     uint v;
 *     int x;
 *
 *     v = 0x21;
 *     x = bsf(v);
 *     writefln("bsf(x%x) = %d", v, x);
 *     x = bsr(v);
 *     writefln("bsr(x%x) = %d", v, x);
 *     return 0;
 * }
 * ---
 * Output:
 *  bsf(x21) = 0<br>
 *  bsr(x21) = 5
 */
int bsr(uint v);

/**
 * Tests the bit.
 */
int bt(in uint *p, uint bitnum);

/**
 * Tests and complements the bit.
 */
int btc(uint *p, uint bitnum);

/**
 * Tests and resets (sets to 0) the bit.
 */
int btr(uint *p, uint bitnum);

/**
 * Tests and sets the bit.
 * Параметры:
 * p = a non-NULL pointer to an array of uints.
 * index = a bit number, starting with bit 0 of p[0],
 * and progressing. It addresses bits like the expression:
---
p[index / (uint.sizeof*8)] & (1 << (index & ((uint.sizeof*8) - 1)))
---
 * Returns:
 * 	A non-zero value if the bit was set, and a zero
 *	if it was clear.
 *
 * Example:
 * ---
import std.io;
import std.intrinsic;

int main()
{
    uint array[2];

    array[0] = 2;
    array[1] = 0x100;

    writefln("btc(array, 35) = %d", <b>btc</b>(array, 35));
    writefln("array = [0]:x%x, [1]:x%x", array[0], array[1]);

    writefln("btc(array, 35) = %d", <b>btc</b>(array, 35));
    writefln("array = [0]:x%x, [1]:x%x", array[0], array[1]);

    writefln("bts(array, 35) = %d", <b>bts</b>(array, 35));
    writefln("array = [0]:x%x, [1]:x%x", array[0], array[1]);

    writefln("btr(array, 35) = %d", <b>btr</b>(array, 35));
    writefln("array = [0]:x%x, [1]:x%x", array[0], array[1]);

    writefln("bt(array, 1) = %d", <b>bt</b>(array, 1));
    writefln("array = [0]:x%x, [1]:x%x", array[0], array[1]);

    return 0;
}
 * ---
 * Output:
<pre>
btc(array, 35) = 0
array = [0]:x2, [1]:x108
btc(array, 35) = -1
array = [0]:x2, [1]:x100
bts(array, 35) = 0
array = [0]:x2, [1]:x108
btr(array, 35) = -1
array = [0]:x2, [1]:x100
bt(array, 1) = -1
array = [0]:x2, [1]:x100
</pre>
 */
int bts(uint *p, uint bitnum);


/**
 * Swaps bytes in a 4 byte uint end-to-end, i.e. byte 0 becomes
*	byte 3, byte 1 becomes byte 2, byte 2 becomes byte 1, byte 3
*	becomes byte 0.
 */
uint bswap(uint v);


/**
 * Reads I/O port at port_address.
 */
ubyte  inp(uint port_address);

/**
 * ditto
 */
ushort inpw(uint port_address);

/**
 * ditto
 */
uint   inpl(uint port_address);


/**
 * Writes and returns value to I/O port at port_address.
 */
ubyte  outp(uint port_address, ubyte value);

/**
 * ditto
 */
ushort outpw(uint port_address, ushort value);

/**
 * ditto
 */
uint   outpl(uint port_address, uint value);


export extern(D):

	цел пуб(бцел х){return bsf(х);}//Поиск первого установленного бита (узнаёт его номер)
	цел пубр(бцел х){return bsr(х);}//Поиск первого установленного бита (от старшего к младшему)
	цел тб(in бцел *х, бцел номбит){return bt(х, номбит);}//Тест бит
	цел тбз(бцел *х, бцел номбит){return btc(х, номбит);}// тест и заполнение
	цел тбп(бцел *х, бцел номбит){return btr(х, номбит);}// тест и переустановка
	цел тбу(бцел *х, бцел номбит){return bts(х, номбит);}// тест и установка
	бцел развербит(бцел б){return bswap(б);}//Развернуть биты в байте
	ббайт чипортБб(бцел адр_порта){return inp(адр_порта);}//читает порт ввода с указанным адресом
	бкрат чипортБк(бцел адр_порта){return inpw(адр_порта);}
	бцел чипортБц(бцел адр_порта){return inpl(адр_порта);}
	ббайт пипортБб(бцел адр_порта, ббайт зап){return outp(адр_порта, зап);}//пишет в порт вывода с указанным адресом
	бкрат пипортБк(бцел адр_порта, бкрат зап){return outpw(адр_порта, зап);}
	бцел пипортБц(бцел адр_порта, бцел зап){return outpl(адр_порта, зап);}

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



struct ПерестановкаБайт
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
}///конец структуры

