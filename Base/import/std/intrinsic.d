module std.intrinsic;
pragma(lib, "DinrusStd.lib");

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
 * import std.stdio;
 * import std.intrinsic;
 *
 * int main()
 * {   
 *     uint v;
 *     int x;
 *
 *     v = 0x21;
 *     x = bsf(v);
 *     пишифнс("bsf(x%x) = %d", v, x);
 *     x = bsr(v);
 *     пишифнс("bsr(x%x) = %d", v, x);
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
 * Params:
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

    пишифнс("btc(array, 35) = %d", <b>btc</b>(array, 35));
    пишифнс("array = [0]:x%x, [1]:x%x", array[0], array[1]);

    пишифнс("btc(array, 35) = %d", <b>btc</b>(array, 35));
    пишифнс("array = [0]:x%x, [1]:x%x", array[0], array[1]);

    пишифнс("bts(array, 35) = %d", <b>bts</b>(array, 35));
    пишифнс("array = [0]:x%x, [1]:x%x", array[0], array[1]);

    пишифнс("btr(array, 35) = %d", <b>btr</b>(array, 35));
    пишифнс("array = [0]:x%x, [1]:x%x", array[0], array[1]);

    пишифнс("bt(array, 1) = %d", <b>bt</b>(array, 1));
    пишифнс("array = [0]:x%x, [1]:x%x", array[0], array[1]);

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

///////////////////////

extern(D):

    цел пуб(бцел х);//Поиск первого установленного бита (узнаёт его номер)
    цел пубр(бцел х);//Поиск первого установленного бита (от старшего к младшему)
    цел тб(in бцел *х, бцел номбит);//Тест бит
    цел тбз(бцел *х, бцел номбит);// тест и заполнение
    цел тбп(бцел *х, бцел номбит);// тест и переустановка
    цел тбу(бцел *х, бцел номбит);// тест и установка
    бцел развербит(бцел б);//Развернуть биты в байте
    ббайт чипортБб(бцел адр_порта);//читает порт ввода с указанным адресом
    бкрат чипортБк(бцел адр_порта);
    бцел чипортБц(бцел адр_порта);
    ббайт пипортБб(бцел адр_порта, ббайт зап);//пишет в порт вывода с указанным адресом
    бкрат пипортБк(бцел адр_порта, бкрат зап);
    бцел пипортБц(бцел адр_порта, бцел зап);

    цел члоустбит32( бцел x );
    бцел битсвоп( бцел x );



struct ПерестановкаБайт
{

        final static проц своп16 (проц[] приёмн);
        final static проц своп32 (проц[] приёмн);
        final static проц своп64 (проц[] приёмн);
        final static проц своп80 (проц[] приёмн);
        final static проц своп16 (проц *приёмн, бцел байты);
        final static проц своп32 (проц *приёмн, бцел байты);
        final static проц своп64 (проц *приёмн, бцел байты);
        final static проц своп80 (проц *приёмн, бцел байты);
}




