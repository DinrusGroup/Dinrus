/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: October 2004

        version:        Feb 20th 2005 - Asm version removed by Aleksey Bobnev

        author:         Kris, Aleksey Bobnev

*******************************************************************************/

module core.ByteSwap;

import core.BitManip;

/*******************************************************************************

        Реверсни байт order for specific datum sizes. Note that the
        байт-своп approach avoопрs alignment issues, so is probably
        faster overall than a traditional 'shift' implementation.
        ---
        ббайт[] x = [0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08];

        auto a = x.dup;
        ПерестановкаБайт.своп16(a);
        assert(a == [cast(ббайт) 0x02, 0x01, 0x04, 0x03, 0x06, 0x05, 0x08, 0x07]);

        auto b = x.dup;
        ПерестановкаБайт.своп32(b);
        assert(b == [cast(ббайт) 0x04, 0x03, 0x02, 0x01, 0x08, 0x07, 0x06, 0x05]);
	
        auto c = x.dup;
        ПерестановкаБайт.своп64(c);
        assert(c == [cast(ббайт) 0x08, 0x07, 0x06, 0x05, 0x04, 0x03, 0x02, 0x01]);
        ---

*******************************************************************************/

struct ПерестановкаБайт
{
        /***********************************************************************

                Reverses two-байт sequences. Parameter приёмн imples the 
                число of байты, which should be a multИПle of 2

        ***********************************************************************/

        final static проц своп16 (проц[] приёмн)
        {
                своп16 (приёмн.ptr, приёмн.length);
        }

        /***********************************************************************

                Reverses four-байт sequences. Parameter приёмн implies the  
                число of байты, which should be a multИПle of 4

        ***********************************************************************/

        final static проц своп32 (проц[] приёмн)
        {
                своп32 (приёмн.ptr, приёмн.length);
        }

        /***********************************************************************

                Реверсни eight-байт sequences. Parameter приёмн implies the 
                число of байты, which should be a multИПle of 8

        ***********************************************************************/

        final static проц своп64 (проц[] приёмн)
        {
                своп64 (приёмн.ptr, приёмн.length);
        }

        /***********************************************************************

                Реверсни ten-байт sequences. Parameter приёмн implies the 
                число of байты, which should be a multИПle of 10

        ***********************************************************************/

        final static проц своп80 (проц[] приёмн)
        {
                своп80 (приёмн.ptr, приёмн.length);
        }

        /***********************************************************************

                Reverses two-байт sequences. Parameter байты specifies the 
                число of байты, which should be a multИПle of 2

        ***********************************************************************/

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

        /***********************************************************************

                Reverses four-байт sequences. Parameter байты specifies the  
                число of байты, which should be a multИПle of 4

        ***********************************************************************/

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

        /***********************************************************************

                Реверсни eight-байт sequences. Parameter байты specifies the 
                число of байты, which should be a multИПle of 8

        ***********************************************************************/

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

        /***********************************************************************

                Реверсни ten-байт sequences. Parameter байты specifies the 
                число of байты, which should be a multИПle of 10

        ***********************************************************************/

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
}




