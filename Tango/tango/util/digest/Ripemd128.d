﻿/*******************************************************************************

        copyright:      Copyright (c) 2009 Dinrus. все rights reserved

        license:        BSD стиль: see doc/license.txt for details

        version:        Initial release: Sep 2009

        author:         Kai Nacke

        This module реализует the Ripemd128 algorithm by Hans Dobbertin, 
        Antoon Bosselaers and Bart Preneel.

        See http://homes.esat.kuleuven.be/~bosselae/rИПemd160.html for ещё
        information.
        
        The implementation is based on:        
        RИПEMD-160 software записано by Antoon Bosselaers, 
 		available at http://www.esat.kuleuven.ac.be/~cosicart/ps/AB-9601/

*******************************************************************************/

module util.digest.Ripemd128;

private import util.digest.MerkleDamgard;

public  import util.digest.Digest;

/*******************************************************************************

*******************************************************************************/

final class Ripemd128 : MerkleDamgard
{
        private бцел[4]        контекст;
        private const бцел     padChar = 0x80;

        /***********************************************************************

        ***********************************************************************/

        private static const бцел[4] начальное =
        [
  				0x67452301,
  				0xefcdab89,
  				0x98badcfe,
  				0x10325476
        ];
        
        /***********************************************************************

        	Construct a Ripemd128

         ***********************************************************************/

        this() { }

        /***********************************************************************

        	The размер of a Ripemd128 дайджест is 16 байты
        
         ***********************************************************************/

        override бцел digestSize() {return 16;}


        /***********************************************************************

        	Initialize the cИПher

        	Remarks:
        		Returns the cИПher состояние в_ it's начальное значение

         ***********************************************************************/

        override проц сбрось()
        {
        	super.сбрось();
        	контекст[] = начальное[];
        }

        /***********************************************************************

        	Obtain the дайджест

        	Возвращает:
        		the дайджест

        	Remarks:
        		Returns a дайджест of the current cИПher состояние, this may be the
        		final дайджест, or a дайджест of the состояние between calls в_ обнови()

         ***********************************************************************/

        override проц создайДайджест(ббайт[] буф)
        {
            version (БигЭндиан)
            	ПерестановкаБайт.своп32 (контекст.ptr, контекст.length * бцел.sizeof);

        	буф[] = cast(ббайт[]) контекст;
        }


        /***********************************************************************

         	block размер

        	Возвращает:
        	the block размер

        	Remarks:
        	Specifies the размер (in байты) of the block of данные в_ пароль в_
        	each вызов в_ трансформируй(). For Ripemd128 the размерБлока is 64.

         ***********************************************************************/

        protected override бцел размерБлока() { return 64; }

        /***********************************************************************

        	Length паддинг размер

        	Возвращает:
        	the length паддинг размер

        	Remarks:
        	Specifies the размер (in байты) of the паддинг which uses the
        	length of the данные which есть been cИПhered, this паддинг is
        	carried out by the padLength метод. For Ripemd128 the добавьSize is 8.

         ***********************************************************************/

        protected бцел добавьSize()   { return 8;  }

        /***********************************************************************

        	Pads the cИПher данные

        	Параметры:
        	данные = a срез of the cИПher буфер в_ заполни with паддинг

        	Remarks:
        	Fills the passed буфер срез with the appropriate паддинг for
        	the final вызов в_ трансформируй(). This паддинг will заполни the cИПher
        	буфер up в_ размерБлока()-добавьSize().

         ***********************************************************************/

        protected override проц padMessage(ббайт[] at)
        {
        	at[0] = padChar;
        	at[1..at.length] = 0;
        }

        /***********************************************************************

        	Performs the length паддинг

        	Параметры:
        	данные   = the срез of the cИПher буфер в_ заполни with паддинг
        	length = the length of the данные which есть been cИПhered

        	Remarks:
        	Fills the passed буфер срез with добавьSize() байты of паддинг
        	based on the length in байты of the ввод данные which есть been
        	cИПhered.

         ***********************************************************************/

        protected override проц padLength(ббайт[] at, бдол length)
        {
        	length <<= 3;
        	littleEndian64((cast(ббайт*)&length)[0..8],cast(бдол[]) at); 
        }

        /***********************************************************************

        	Performs the cИПher on a block of данные

        	Параметры:
        	данные = the block of данные в_ cИПher

        	Remarks:
        	The actual cИПher algorithm is carried out by this метод on
        	the passed block of данные. This метод is called for every
        	размерБлока() байты of ввод данные and once ещё with the remaining
        	данные псеп_в_конце в_ размерБлока().

         ***********************************************************************/

        protected override проц трансформируй(ббайт[] ввод)
        {
        	бцел al, bl, cl, dl;
        	бцел ar, br, cr, dr;
            бцел[16] x;
            
            littleEndian32(ввод,x);

            al = ar = контекст[0];
            bl = br = контекст[1];
            cl = cr = контекст[2];
            dl = dr = контекст[3];

            // Round 1 and parallel округли 1
            al = rotateLeft(al + (bl ^ cl ^ dl) + x[0], 11);
            ar = rotateLeft(ar + ((br & dr) | (cr & ~(dr))) + x[5] + 0x50a28be6, 8);
            dl = rotateLeft(dl + (al ^ bl ^ cl) + x[1], 14);
            dr = rotateLeft(dr + ((ar & cr) | (br & ~(cr))) + x[14] + 0x50a28be6, 9);
            cl = rotateLeft(cl + (dl ^ al ^ bl) + x[2], 15);
            cr = rotateLeft(cr + ((dr & br) | (ar & ~(br))) + x[7] + 0x50a28be6, 9);
            bl = rotateLeft(bl + (cl ^ dl ^ al) + x[3], 12);
            br = rotateLeft(br + ((cr & ar) | (dr & ~(ar))) + x[0] + 0x50a28be6, 11);
            al = rotateLeft(al + (bl ^ cl ^ dl) + x[4], 5);
            ar = rotateLeft(ar + ((br & dr) | (cr & ~(dr))) + x[9] + 0x50a28be6, 13);
            dl = rotateLeft(dl + (al ^ bl ^ cl) + x[5], 8);
            dr = rotateLeft(dr + ((ar & cr) | (br & ~(cr))) + x[2] + 0x50a28be6, 15);
            cl = rotateLeft(cl + (dl ^ al ^ bl) + x[6], 7);
            cr = rotateLeft(cr + ((dr & br) | (ar & ~(br))) + x[11] + 0x50a28be6, 15);
            bl = rotateLeft(bl + (cl ^ dl ^ al) + x[7], 9);
            br = rotateLeft(br + ((cr & ar) | (dr & ~(ar))) + x[4] + 0x50a28be6, 5);
            al = rotateLeft(al + (bl ^ cl ^ dl) + x[8], 11);
            ar = rotateLeft(ar + ((br & dr) | (cr & ~(dr))) + x[13] + 0x50a28be6, 7);
            dl = rotateLeft(dl + (al ^ bl ^ cl) + x[9], 13);
            dr = rotateLeft(dr + ((ar & cr) | (br & ~(cr))) + x[6] + 0x50a28be6, 7);
            cl = rotateLeft(cl + (dl ^ al ^ bl) + x[10], 14);
            cr = rotateLeft(cr + ((dr & br) | (ar & ~(br))) + x[15] + 0x50a28be6, 8);
            bl = rotateLeft(bl + (cl ^ dl ^ al) + x[11], 15);
            br = rotateLeft(br + ((cr & ar) | (dr & ~(ar))) + x[8] + 0x50a28be6, 11);
            al = rotateLeft(al + (bl ^ cl ^ dl) + x[12], 6);
            ar = rotateLeft(ar + ((br & dr) | (cr & ~(dr))) + x[1] + 0x50a28be6, 14);
            dl = rotateLeft(dl + (al ^ bl ^ cl) + x[13], 7);
            dr = rotateLeft(dr + ((ar & cr) | (br & ~(cr))) + x[10] + 0x50a28be6, 14);
            cl = rotateLeft(cl + (dl ^ al ^ bl) + x[14], 9);
            cr = rotateLeft(cr + ((dr & br) | (ar & ~(br))) + x[3] + 0x50a28be6, 12);
            bl = rotateLeft(bl + (cl ^ dl ^ al) + x[15], 8);
            br = rotateLeft(br + ((cr & ar) | (dr & ~(ar))) + x[12] + 0x50a28be6, 6);
            
            // Round 2 and parallel округли 2
            al = rotateLeft(al + (((cl ^ dl) & bl) ^ dl) + x[7] + 0x5a827999, 7);
            ar = rotateLeft(ar + ((br | ~(cr)) ^ dr) + x[6] + 0x5c4dd124, 9);
            dl = rotateLeft(dl + (((bl ^ cl) & al) ^ cl) + x[4] + 0x5a827999, 6);
            dr = rotateLeft(dr + ((ar | ~(br)) ^ cr) + x[11] + 0x5c4dd124, 13);
            cl = rotateLeft(cl + (((al ^ bl) & dl) ^ bl) + x[13] + 0x5a827999, 8);
            cr = rotateLeft(cr + ((dr | ~(ar)) ^ br) + x[3] + 0x5c4dd124, 15);
            bl = rotateLeft(bl + (((dl ^ al) & cl) ^ al) + x[1] + 0x5a827999, 13);
            br = rotateLeft(br + ((cr | ~(dr)) ^ ar) + x[7] + 0x5c4dd124, 7);
            al = rotateLeft(al + (((cl ^ dl) & bl) ^ dl) + x[10] + 0x5a827999, 11);
            ar = rotateLeft(ar + ((br | ~(cr)) ^ dr) + x[0] + 0x5c4dd124, 12);
            dl = rotateLeft(dl + (((bl ^ cl) & al) ^ cl) + x[6] + 0x5a827999, 9);
            dr = rotateLeft(dr + ((ar | ~(br)) ^ cr) + x[13] + 0x5c4dd124, 8);
            cl = rotateLeft(cl + (((al ^ bl) & dl) ^ bl) + x[15] + 0x5a827999, 7);
            cr = rotateLeft(cr + ((dr | ~(ar)) ^ br) + x[5] + 0x5c4dd124, 9);
            bl = rotateLeft(bl + (((dl ^ al) & cl) ^ al) + x[3] + 0x5a827999, 15);
            br = rotateLeft(br + ((cr | ~(dr)) ^ ar) + x[10] + 0x5c4dd124, 11);
            al = rotateLeft(al + (((cl ^ dl) & bl) ^ dl) + x[12] + 0x5a827999, 7);
            ar = rotateLeft(ar + ((br | ~(cr)) ^ dr) + x[14] + 0x5c4dd124, 7);
            dl = rotateLeft(dl + (((bl ^ cl) & al) ^ cl) + x[0] + 0x5a827999, 12);
            dr = rotateLeft(dr + ((ar | ~(br)) ^ cr) + x[15] + 0x5c4dd124, 7);
            cl = rotateLeft(cl + (((al ^ bl) & dl) ^ bl) + x[9] + 0x5a827999, 15);
            cr = rotateLeft(cr + ((dr | ~(ar)) ^ br) + x[8] + 0x5c4dd124, 12);
            bl = rotateLeft(bl + (((dl ^ al) & cl) ^ al) + x[5] + 0x5a827999, 9);
            br = rotateLeft(br + ((cr | ~(dr)) ^ ar) + x[12] + 0x5c4dd124, 7);
            al = rotateLeft(al + (((cl ^ dl) & bl) ^ dl) + x[2] + 0x5a827999, 11);
            ar = rotateLeft(ar + ((br | ~(cr)) ^ dr) + x[4] + 0x5c4dd124, 6);
            dl = rotateLeft(dl + (((bl ^ cl) & al) ^ cl) + x[14] + 0x5a827999, 7);
            dr = rotateLeft(dr + ((ar | ~(br)) ^ cr) + x[9] + 0x5c4dd124, 15);
            cl = rotateLeft(cl + (((al ^ bl) & dl) ^ bl) + x[11] + 0x5a827999, 13);
            cr = rotateLeft(cr + ((dr | ~(ar)) ^ br) + x[1] + 0x5c4dd124, 13);
            bl = rotateLeft(bl + (((dl ^ al) & cl) ^ al) + x[8] + 0x5a827999, 12);
            br = rotateLeft(br + ((cr | ~(dr)) ^ ar) + x[2] + 0x5c4dd124, 11);
            
            // Round 3 and parallel округли 3
            al = rotateLeft(al + ((bl | ~(cl)) ^ dl) + x[3] + 0x6ed9eba1, 11);
            ar = rotateLeft(ar + (((cr ^ dr) & br) ^ dr) + x[15] + 0x6d703ef3, 9);
            dl = rotateLeft(dl + ((al | ~(bl)) ^ cl) + x[10] + 0x6ed9eba1, 13);
            dr = rotateLeft(dr + (((br ^ cr) & ar) ^ cr) + x[5] + 0x6d703ef3, 7);
            cl = rotateLeft(cl + ((dl | ~(al)) ^ bl) + x[14] + 0x6ed9eba1, 6);
            cr = rotateLeft(cr + (((ar ^ br) & dr) ^ br) + x[1] + 0x6d703ef3, 15);
            bl = rotateLeft(bl + ((cl | ~(dl)) ^ al) + x[4] + 0x6ed9eba1, 7);
            br = rotateLeft(br + (((dr ^ ar) & cr) ^ ar) + x[3] + 0x6d703ef3, 11);
            al = rotateLeft(al + ((bl | ~(cl)) ^ dl) + x[9] + 0x6ed9eba1, 14);
            ar = rotateLeft(ar + (((cr ^ dr) & br) ^ dr) + x[7] + 0x6d703ef3, 8);
            dl = rotateLeft(dl + ((al | ~(bl)) ^ cl) + x[15] + 0x6ed9eba1, 9);
            dr = rotateLeft(dr + (((br ^ cr) & ar) ^ cr) + x[14] + 0x6d703ef3, 6);
            cl = rotateLeft(cl + ((dl | ~(al)) ^ bl) + x[8] + 0x6ed9eba1, 13);
            cr = rotateLeft(cr + (((ar ^ br) & dr) ^ br) + x[6] + 0x6d703ef3, 6);
            bl = rotateLeft(bl + ((cl | ~(dl)) ^ al) + x[1] + 0x6ed9eba1, 15);
            br = rotateLeft(br + (((dr ^ ar) & cr) ^ ar) + x[9] + 0x6d703ef3, 14);
            al = rotateLeft(al + ((bl | ~(cl)) ^ dl) + x[2] + 0x6ed9eba1, 14);
            ar = rotateLeft(ar + (((cr ^ dr) & br) ^ dr) + x[11] + 0x6d703ef3, 12);
            dl = rotateLeft(dl + ((al | ~(bl)) ^ cl) + x[7] + 0x6ed9eba1, 8);
            dr = rotateLeft(dr + (((br ^ cr) & ar) ^ cr) + x[8] + 0x6d703ef3, 13);
            cl = rotateLeft(cl + ((dl | ~(al)) ^ bl) + x[0] + 0x6ed9eba1, 13);
            cr = rotateLeft(cr + (((ar ^ br) & dr) ^ br) + x[12] + 0x6d703ef3, 5);
            bl = rotateLeft(bl + ((cl | ~(dl)) ^ al) + x[6] + 0x6ed9eba1, 6);
            br = rotateLeft(br + (((dr ^ ar) & cr) ^ ar) + x[2] + 0x6d703ef3, 14);
            al = rotateLeft(al + ((bl | ~(cl)) ^ dl) + x[13] + 0x6ed9eba1, 5);
            ar = rotateLeft(ar + (((cr ^ dr) & br) ^ dr) + x[10] + 0x6d703ef3, 13);
            dl = rotateLeft(dl + ((al | ~(bl)) ^ cl) + x[11] + 0x6ed9eba1, 12);
            dr = rotateLeft(dr + (((br ^ cr) & ar) ^ cr) + x[0] + 0x6d703ef3, 13);
            cl = rotateLeft(cl + ((dl | ~(al)) ^ bl) + x[5] + 0x6ed9eba1, 7);
            cr = rotateLeft(cr + (((ar ^ br) & dr) ^ br) + x[4] + 0x6d703ef3, 7);
            bl = rotateLeft(bl + ((cl | ~(dl)) ^ al) + x[12] + 0x6ed9eba1, 5);
            br = rotateLeft(br + (((dr ^ ar) & cr) ^ ar) + x[13] + 0x6d703ef3, 5);
            
            // Round 4 and parallel округли 4
            al = rotateLeft(al + ((bl & dl) | (cl & ~(dl))) + x[1] + 0x8f1bbcdc, 11);
            ar = rotateLeft(ar + (br ^ cr ^ dr) + x[8], 15);
            dl = rotateLeft(dl + ((al & cl) | (bl & ~(cl))) + x[9] + 0x8f1bbcdc, 12);
            dr = rotateLeft(dr + (ar ^ br ^ cr) + x[6], 5);
            cl = rotateLeft(cl + ((dl & bl) | (al & ~(bl))) + x[11] + 0x8f1bbcdc, 14);
            cr = rotateLeft(cr + (dr ^ ar ^ br) + x[4], 8);
            bl = rotateLeft(bl + ((cl & al) | (dl & ~(al))) + x[10] + 0x8f1bbcdc, 15);
            br = rotateLeft(br + (cr ^ dr ^ ar) + x[1], 11);
            al = rotateLeft(al + ((bl & dl) | (cl & ~(dl))) + x[0] + 0x8f1bbcdc, 14);
            ar = rotateLeft(ar + (br ^ cr ^ dr) + x[3], 14);
            dl = rotateLeft(dl + ((al & cl) | (bl & ~(cl))) + x[8] + 0x8f1bbcdc, 15);
            dr = rotateLeft(dr + (ar ^ br ^ cr) + x[11], 14);
            cl = rotateLeft(cl + ((dl & bl) | (al & ~(bl))) + x[12] + 0x8f1bbcdc, 9);
            cr = rotateLeft(cr + (dr ^ ar ^ br) + x[15], 6);
            bl = rotateLeft(bl + ((cl & al) | (dl & ~(al))) + x[4] + 0x8f1bbcdc, 8);
            br = rotateLeft(br + (cr ^ dr ^ ar) + x[0], 14);
            al = rotateLeft(al + ((bl & dl) | (cl & ~(dl))) + x[13] + 0x8f1bbcdc, 9);
            ar = rotateLeft(ar + (br ^ cr ^ dr) + x[5], 6);
            dl = rotateLeft(dl + ((al & cl) | (bl & ~(cl))) + x[3] + 0x8f1bbcdc, 14);
            dr = rotateLeft(dr + (ar ^ br ^ cr) + x[12], 9);
            cl = rotateLeft(cl + ((dl & bl) | (al & ~(bl))) + x[7] + 0x8f1bbcdc, 5);
            cr = rotateLeft(cr + (dr ^ ar ^ br) + x[2], 12);
            bl = rotateLeft(bl + ((cl & al) | (dl & ~(al))) + x[15] + 0x8f1bbcdc, 6);
            br = rotateLeft(br + (cr ^ dr ^ ar) + x[13], 9);
            al = rotateLeft(al + ((bl & dl) | (cl & ~(dl))) + x[14] + 0x8f1bbcdc, 8);
            ar = rotateLeft(ar + (br ^ cr ^ dr) + x[9], 12);
            dl = rotateLeft(dl + ((al & cl) | (bl & ~(cl))) + x[5] + 0x8f1bbcdc, 6);
            dr = rotateLeft(dr + (ar ^ br ^ cr) + x[7], 5);
            cl = rotateLeft(cl + ((dl & bl) | (al & ~(bl))) + x[6] + 0x8f1bbcdc, 5);
            cr = rotateLeft(cr + (dr ^ ar ^ br) + x[10], 15);
            bl = rotateLeft(bl + ((cl & al) | (dl & ~(al))) + x[2] + 0x8f1bbcdc, 12);
            br = rotateLeft(br + (cr ^ dr ^ ar) + x[14], 8);
            
            бцел t = контекст[1] + cl + dr;
            контекст[1] = контекст[2] + dl + ar;
            контекст[2] = контекст[3] + al + br;
            контекст[3] = контекст[0] + bl + cr;
            контекст[0] = t;

            x[] = 0;
        }

}

/*******************************************************************************

*******************************************************************************/

debug(UnitTest)
{
    unittest
    {
    static ткст[] strings =
    [
            "",
            "a",
            "abc",
            "сообщение дайджест",
            "abcdefghijklmnopqrstuvwxyz",
            "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq",
            "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789",
            "12345678901234567890123456789012345678901234567890123456789012345678901234567890"
    ];

    static ткст[] results =
    [
            "cdf26213a150dc3ecb610f18f6b38b46",
            "86be7afa339d0fc7cfc785e72f578d33",
            "c14a12199c66e4ba84636b0f69144c77",
            "9e327b3d6e523062afc1132d7df9d1b8",
            "fd2aa607f71dc8f510714922b371834e",
            "a1aa0689d0fafa2ddc22e88b49133a06",
            "d1e959eb179c911faea4624c60c5c702",
            "3f45ef194732c2dbb2c4a2c769795fa3"
    ];

    Ripemd128 h = new Ripemd128();

    foreach (цел i, ткст s; strings)
            {
            h.обнови(cast(ббайт[]) s);
            ткст d = h.гексДайджест;

            assert(d == results[i],":("~s~")("~d~")!=("~results[i]~")");
            }

    ткст s = new сим[1000000];
    for (auto i = 0; i < s.length; i++) s[i] = 'a';
    ткст результат = "4a7f5723f954eba1216c9d8f6320431f";
    h.обнови(cast(ббайт[]) s);
    ткст d = h.гексДайджест;

    assert(d == результат,":(1 million times \"a\")("~d~")!=("~результат~")");
    }
	
}