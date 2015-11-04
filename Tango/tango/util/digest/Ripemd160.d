﻿/*******************************************************************************

        copyright:      Copyright (c) 2009 Dinrus. все rights reserved

        license:        BSD стиль: see doc/license.txt for details

        version:        Initial release: Sep 2009

        author:         Kai Nacke

        This module реализует the Ripemd160 algorithm by Hans Dobbertin, 
        Antoon Bosselaers and Bart Preneel.
        
        See http://homes.esat.kuleuven.be/~bosselae/rИПemd160.html for ещё
        information.

        The implementation is based on:        
        RИПEMD-160 software записано by Antoon Bosselaers, 
 		available at http://www.esat.kuleuven.ac.be/~cosicart/ps/AB-9601/

*******************************************************************************/

module util.digest.Ripemd160;

private import util.digest.MerkleDamgard;

public  import util.digest.Digest;

/*******************************************************************************

*******************************************************************************/

final class Ripemd160 : MerkleDamgard
{
        private бцел[5]        контекст;
        private const бцел     padChar = 0x80;

        /***********************************************************************

        ***********************************************************************/

        private static const бцел[5] начальное =
        [
				0x67452301,
				0xefcdab89,
				0x98badcfe,
				0x10325476,
				0xc3d2e1f0
        ];
        
        /***********************************************************************

        	Construct a Ripemd160

         ***********************************************************************/

        this() { }

        /***********************************************************************

        	The размер of a Ripemd160 дайджест is 20 байты
        
         ***********************************************************************/

        override бцел digestSize() {return 20;}


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
        	each вызов в_ трансформируй(). For Ripemd160 the размерБлока is 64.

         ***********************************************************************/

        protected override бцел размерБлока() { return 64; }

        /***********************************************************************

        	Length паддинг размер

        	Возвращает:
        	the length паддинг размер

        	Remarks:
        	Specifies the размер (in байты) of the паддинг which uses the
        	length of the данные which есть been cИПhered, this паддинг is
        	carried out by the padLength метод. For Ripemd160 the добавьSize is 8.

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
        	бцел al, bl, cl, dl, el;
        	бцел ar, br, cr, dr, er;
            бцел[16] x;
            
            littleEndian32(ввод,x);

            al = ar = контекст[0];
            bl = br = контекст[1];
            cl = cr = контекст[2];
            dl = dr = контекст[3];
            el = er = контекст[4];

            // Round 1 and parallel округли 1
            al = rotateLeft(al + (bl ^ cl ^ dl) + x[0], 11) + el;
            ar = rotateLeft(ar + (br ^ (cr | ~dr)) + x[5] + 0x50a28be6, 8) + er;
            cl = rotateLeft(cl, 10);
            cr = rotateLeft(cr, 10);
            el = rotateLeft(el + (al ^ bl ^ cl) + x[1], 14) + dl;
            er = rotateLeft(er + (ar ^ (br | ~cr)) + x[14] + 0x50a28be6, 9) + dr;
            bl = rotateLeft(bl, 10);
            br = rotateLeft(br, 10);
            dl = rotateLeft(dl + (el ^ al ^ bl) + x[2], 15) + cl;
            dr = rotateLeft(dr + (er ^ (ar | ~br)) + x[7] + 0x50a28be6, 9) + cr;
            al = rotateLeft(al, 10);
            ar = rotateLeft(ar, 10);
            cl = rotateLeft(cl + (dl ^ el ^ al) + x[3], 12) + bl;
            cr = rotateLeft(cr + (dr ^ (er | ~ar)) + x[0] + 0x50a28be6, 11) + br;
            el = rotateLeft(el, 10);
            er = rotateLeft(er, 10);
            bl = rotateLeft(bl + (cl ^ dl ^ el) + x[4], 5) + al;
            br = rotateLeft(br + (cr ^ (dr | ~er)) + x[9] + 0x50a28be6, 13) + ar;
            dl = rotateLeft(dl, 10);
            dr = rotateLeft(dr, 10);
            al = rotateLeft(al + (bl ^ cl ^ dl) + x[5], 8) + el;
            ar = rotateLeft(ar + (br ^ (cr | ~dr)) + x[2] + 0x50a28be6, 15) + er;
            cl = rotateLeft(cl, 10);
            cr = rotateLeft(cr, 10);
            el = rotateLeft(el + (al ^ bl ^ cl) + x[6], 7) + dl;
            er = rotateLeft(er + (ar ^ (br | ~cr)) + x[11] + 0x50a28be6, 15) + dr;
            bl = rotateLeft(bl, 10);
            br = rotateLeft(br, 10);
            dl = rotateLeft(dl + (el ^ al ^ bl) + x[7], 9) + cl;
            dr = rotateLeft(dr + (er ^ (ar | ~br)) + x[4] + 0x50a28be6, 5) + cr;
            al = rotateLeft(al, 10);
            ar = rotateLeft(ar, 10);
            cl = rotateLeft(cl + (dl ^ el ^ al) + x[8], 11) + bl;
            cr = rotateLeft(cr + (dr ^ (er | ~ar)) + x[13] + 0x50a28be6, 7) + br;
            el = rotateLeft(el, 10);
            er = rotateLeft(er, 10);
            bl = rotateLeft(bl + (cl ^ dl ^ el) + x[9], 13) + al;
            br = rotateLeft(br + (cr ^ (dr | ~er)) + x[6] + 0x50a28be6, 7) + ar;
            dl = rotateLeft(dl, 10);
            dr = rotateLeft(dr, 10);
            al = rotateLeft(al + (bl ^ cl ^ dl) + x[10], 14) + el;
            ar = rotateLeft(ar + (br ^ (cr | ~dr)) + x[15] + 0x50a28be6, 8) + er;
            cl = rotateLeft(cl, 10);
            cr = rotateLeft(cr, 10);
            el = rotateLeft(el + (al ^ bl ^ cl) + x[11], 15) + dl;
            er = rotateLeft(er + (ar ^ (br | ~cr)) + x[8] + 0x50a28be6, 11) + dr;
            bl = rotateLeft(bl, 10);
            br = rotateLeft(br, 10);
            dl = rotateLeft(dl + (el ^ al ^ bl) + x[12], 6) + cl;
            dr = rotateLeft(dr + (er ^ (ar | ~br)) + x[1] + 0x50a28be6, 14) + cr;
            al = rotateLeft(al, 10);
            ar = rotateLeft(ar, 10);
            cl = rotateLeft(cl + (dl ^ el ^ al) + x[13], 7) + bl;
            cr = rotateLeft(cr + (dr ^ (er | ~ar)) + x[10] + 0x50a28be6, 14) + br;
            el = rotateLeft(el, 10);
            er = rotateLeft(er, 10);
            bl = rotateLeft(bl + (cl ^ dl ^ el) + x[14], 9) + al;
            br = rotateLeft(br + (cr ^ (dr | ~er)) + x[3] + 0x50a28be6, 12) + ar;
            dl = rotateLeft(dl, 10);
            dr = rotateLeft(dr, 10);
            al = rotateLeft(al + (bl ^ cl ^ dl) + x[15], 8) + el;
            ar = rotateLeft(ar + (br ^ (cr | ~dr)) + x[12] + 0x50a28be6, 6) + er;
            cl = rotateLeft(cl, 10);
            cr = rotateLeft(cr, 10);
            
            // Round 2 and parallel округли 2
            el = rotateLeft(el + (((bl ^ cl) & al) ^ cl) + x[7] + 0x5a827999, 7) + dl;
            er = rotateLeft(er + ((ar & cr) | (br & ~cr)) + x[6] + 0x5c4dd124, 9) + dr;
            bl = rotateLeft(bl, 10);
            br = rotateLeft(br, 10);
            dl = rotateLeft(dl + (((al ^ bl) & el) ^ bl) + x[4] + 0x5a827999, 6) + cl;
            dr = rotateLeft(dr + ((er & br) | (ar & ~br)) + x[11] + 0x5c4dd124, 13) + cr;
            al = rotateLeft(al, 10);
            ar = rotateLeft(ar, 10);
            cl = rotateLeft(cl + (((el ^ al) & dl) ^ al) + x[13] + 0x5a827999, 8) + bl;
            cr = rotateLeft(cr + ((dr & ar) | (er & ~ar)) + x[3] + 0x5c4dd124, 15) + br;
            el = rotateLeft(el, 10);
            er = rotateLeft(er, 10);
            bl = rotateLeft(bl + (((dl ^ el) & cl) ^ el) + x[1] + 0x5a827999, 13) + al;
            br = rotateLeft(br + ((cr & er) | (dr & ~er)) + x[7] + 0x5c4dd124, 7) + ar;
            dl = rotateLeft(dl, 10);
            dr = rotateLeft(dr, 10);
            al = rotateLeft(al + (((cl ^ dl) & bl) ^ dl) + x[10] + 0x5a827999, 11) + el;
            ar = rotateLeft(ar + ((br & dr) | (cr & ~dr)) + x[0] + 0x5c4dd124, 12) + er;
            cl = rotateLeft(cl, 10);
            cr = rotateLeft(cr, 10);
            el = rotateLeft(el + (((bl ^ cl) & al) ^ cl) + x[6] + 0x5a827999, 9) + dl;
            er = rotateLeft(er + ((ar & cr) | (br & ~cr)) + x[13] + 0x5c4dd124, 8) + dr;
            bl = rotateLeft(bl, 10);
            br = rotateLeft(br, 10);
            dl = rotateLeft(dl + (((al ^ bl) & el) ^ bl) + x[15] + 0x5a827999, 7) + cl;
            dr = rotateLeft(dr + ((er & br) | (ar & ~br)) + x[5] + 0x5c4dd124, 9) + cr;
            al = rotateLeft(al, 10);
            ar = rotateLeft(ar, 10);
            cl = rotateLeft(cl + (((el ^ al) & dl) ^ al) + x[3] + 0x5a827999, 15) + bl;
            cr = rotateLeft(cr + ((dr & ar) | (er & ~ar)) + x[10] + 0x5c4dd124, 11) + br;
            el = rotateLeft(el, 10);
            er = rotateLeft(er, 10);
            bl = rotateLeft(bl + (((dl ^ el) & cl) ^ el) + x[12] + 0x5a827999, 7) + al;
            br = rotateLeft(br + ((cr & er) | (dr & ~er)) + x[14] + 0x5c4dd124, 7) + ar;
            dl = rotateLeft(dl, 10);
            dr = rotateLeft(dr, 10);
            al = rotateLeft(al + (((cl ^ dl) & bl) ^ dl) + x[0] + 0x5a827999, 12) + el;
            ar = rotateLeft(ar + ((br & dr) | (cr & ~dr)) + x[15] + 0x5c4dd124, 7) + er;
            cl = rotateLeft(cl, 10);
            cr = rotateLeft(cr, 10);
            el = rotateLeft(el + (((bl ^ cl) & al) ^ cl) + x[9] + 0x5a827999, 15) + dl;
            er = rotateLeft(er + ((ar & cr) | (br & ~cr)) + x[8] + 0x5c4dd124, 12) + dr;
            bl = rotateLeft(bl, 10);
            br = rotateLeft(br, 10);
            dl = rotateLeft(dl + (((al ^ bl) & el) ^ bl) + x[5] + 0x5a827999, 9) + cl;
            dr = rotateLeft(dr + ((er & br) | (ar & ~br)) + x[12] + 0x5c4dd124, 7) + cr;
            al = rotateLeft(al, 10);
            ar = rotateLeft(ar, 10);
            cl = rotateLeft(cl + (((el ^ al) & dl) ^ al) + x[2] + 0x5a827999, 11) + bl;
            cr = rotateLeft(cr + ((dr & ar) | (er & ~ar)) + x[4] + 0x5c4dd124, 6) + br;
            el = rotateLeft(el, 10);
            er = rotateLeft(er, 10);
            bl = rotateLeft(bl + (((dl ^ el) & cl) ^ el) + x[14] + 0x5a827999, 7) + al;
            br = rotateLeft(br + ((cr & er) | (dr & ~er)) + x[9] + 0x5c4dd124, 15) + ar;
            dl = rotateLeft(dl, 10);
            dr = rotateLeft(dr, 10);
            al = rotateLeft(al + (((cl ^ dl) & bl) ^ dl) + x[11] + 0x5a827999, 13) + el;
            ar = rotateLeft(ar + ((br & dr) | (cr & ~dr)) + x[1] + 0x5c4dd124, 13) + er;
            cl = rotateLeft(cl, 10);
            cr = rotateLeft(cr, 10);
            el = rotateLeft(el + (((bl ^ cl) & al) ^ cl) + x[8] + 0x5a827999, 12) + dl;
            er = rotateLeft(er + ((ar & cr) | (br & ~cr)) + x[2] + 0x5c4dd124, 11) + dr;
            bl = rotateLeft(bl, 10);
            br = rotateLeft(br, 10);
            
            // Round 3 and parallel округли 3
            dl = rotateLeft(dl + ((el | ~al) ^ bl) + x[3] + 0x6ed9eba1, 11) + cl;
            dr = rotateLeft(dr + ((er | ~ar) ^ br) + x[15] + 0x6d703ef3, 9) + cr;
            al = rotateLeft(al, 10);
            ar = rotateLeft(ar, 10);
            cl = rotateLeft(cl + ((dl | ~el) ^ al) + x[10] + 0x6ed9eba1, 13) + bl;
            cr = rotateLeft(cr + ((dr | ~er) ^ ar) + x[5] + 0x6d703ef3, 7) + br;
            el = rotateLeft(el, 10);
            er = rotateLeft(er, 10);
            bl = rotateLeft(bl + ((cl | ~dl) ^ el) + x[14] + 0x6ed9eba1, 6) + al;
            br = rotateLeft(br + ((cr | ~dr) ^ er) + x[1] + 0x6d703ef3, 15) + ar;
            dl = rotateLeft(dl, 10);
            dr = rotateLeft(dr, 10);
            al = rotateLeft(al + ((bl | ~cl) ^ dl) + x[4] + 0x6ed9eba1, 7) + el;
            ar = rotateLeft(ar + ((br | ~cr) ^ dr) + x[3] + 0x6d703ef3, 11) + er;
            cl = rotateLeft(cl, 10);
            cr = rotateLeft(cr, 10);
            el = rotateLeft(el + ((al | ~bl) ^ cl) + x[9] + 0x6ed9eba1, 14) + dl;
            er = rotateLeft(er + ((ar | ~br) ^ cr) + x[7] + 0x6d703ef3, 8) + dr;
            bl = rotateLeft(bl, 10);
            br = rotateLeft(br, 10);
            dl = rotateLeft(dl + ((el | ~al) ^ bl) + x[15] + 0x6ed9eba1, 9) + cl;
            dr = rotateLeft(dr + ((er | ~ar) ^ br) + x[14] + 0x6d703ef3, 6) + cr;
            al = rotateLeft(al, 10);
            ar = rotateLeft(ar, 10);
            cl = rotateLeft(cl + ((dl | ~el) ^ al) + x[8] + 0x6ed9eba1, 13) + bl;
            cr = rotateLeft(cr + ((dr | ~er) ^ ar) + x[6] + 0x6d703ef3, 6) + br;
            el = rotateLeft(el, 10);
            er = rotateLeft(er, 10);
            bl = rotateLeft(bl + ((cl | ~dl) ^ el) + x[1] + 0x6ed9eba1, 15) + al;
            br = rotateLeft(br + ((cr | ~dr) ^ er) + x[9] + 0x6d703ef3, 14) + ar;
            dl = rotateLeft(dl, 10);
            dr = rotateLeft(dr, 10);
            al = rotateLeft(al + ((bl | ~cl) ^ dl) + x[2] + 0x6ed9eba1, 14) + el;
            ar = rotateLeft(ar + ((br | ~cr) ^ dr) + x[11] + 0x6d703ef3, 12) + er;
            cl = rotateLeft(cl, 10);
            cr = rotateLeft(cr, 10);
            el = rotateLeft(el + ((al | ~bl) ^ cl) + x[7] + 0x6ed9eba1, 8) + dl;
            er = rotateLeft(er + ((ar | ~br) ^ cr) + x[8] + 0x6d703ef3, 13) + dr;
            bl = rotateLeft(bl, 10);
            br = rotateLeft(br, 10);
            dl = rotateLeft(dl + ((el | ~al) ^ bl) + x[0] + 0x6ed9eba1, 13) + cl;
            dr = rotateLeft(dr + ((er | ~ar) ^ br) + x[12] + 0x6d703ef3, 5) + cr;
            al = rotateLeft(al, 10);
            ar = rotateLeft(ar, 10);
            cl = rotateLeft(cl + ((dl | ~el) ^ al) + x[6] + 0x6ed9eba1, 6) + bl;
            cr = rotateLeft(cr + ((dr | ~er) ^ ar) + x[2] + 0x6d703ef3, 14) + br;
            el = rotateLeft(el, 10);
            er = rotateLeft(er, 10);
            bl = rotateLeft(bl + ((cl | ~dl) ^ el) + x[13] + 0x6ed9eba1, 5) + al;
            br = rotateLeft(br + ((cr | ~dr) ^ er) + x[10] + 0x6d703ef3, 13) + ar;
            dl = rotateLeft(dl, 10);
            dr = rotateLeft(dr, 10);
            al = rotateLeft(al + ((bl | ~cl) ^ dl) + x[11] + 0x6ed9eba1, 12) + el;
            ar = rotateLeft(ar + ((br | ~cr) ^ dr) + x[0] + 0x6d703ef3, 13) + er;
            cl = rotateLeft(cl, 10);
            cr = rotateLeft(cr, 10);
            el = rotateLeft(el + ((al | ~bl) ^ cl) + x[5] + 0x6ed9eba1, 7) + dl;
            er = rotateLeft(er + ((ar | ~br) ^ cr) + x[4] + 0x6d703ef3, 7) + dr;
            bl = rotateLeft(bl, 10);
            br = rotateLeft(br, 10);
            dl = rotateLeft(dl + ((el | ~al) ^ bl) + x[12] + 0x6ed9eba1, 5) + cl;
            dr = rotateLeft(dr + ((er | ~ar) ^ br) + x[13] + 0x6d703ef3, 5) + cr;
            al = rotateLeft(al, 10);
            ar = rotateLeft(ar, 10);
            
            // Round 4 and parallel округли 4
            cl = rotateLeft(cl + ((dl & al) | (el & ~al)) + x[1] + 0x8f1bbcdc, 11) + bl;
            cr = rotateLeft(cr + (((er ^ ar) & dr) ^ ar) + x[8] + 0x7a6d76e9, 15) + br;
            el = rotateLeft(el, 10);
            er = rotateLeft(er, 10);
            bl = rotateLeft(bl + ((cl & el) | (dl & ~el)) + x[9] + 0x8f1bbcdc, 12) + al;
            br = rotateLeft(br + (((dr ^ er) & cr) ^ er) + x[6] + 0x7a6d76e9, 5) + ar;
            dl = rotateLeft(dl, 10);
            dr = rotateLeft(dr, 10);
            al = rotateLeft(al + ((bl & dl) | (cl & ~dl)) + x[11] + 0x8f1bbcdc, 14) + el;
            ar = rotateLeft(ar + (((cr ^ dr) & br) ^ dr) + x[4] + 0x7a6d76e9, 8) + er;
            cl = rotateLeft(cl, 10);
            cr = rotateLeft(cr, 10);
            el = rotateLeft(el + ((al & cl) | (bl & ~cl)) + x[10] + 0x8f1bbcdc, 15) + dl;
            er = rotateLeft(er + (((br ^ cr) & ar) ^ cr) + x[1] + 0x7a6d76e9, 11) + dr;
            bl = rotateLeft(bl, 10);
            br = rotateLeft(br, 10);
            dl = rotateLeft(dl + ((el & bl) | (al & ~bl)) + x[0] + 0x8f1bbcdc, 14) + cl;
            dr = rotateLeft(dr + (((ar ^ br) & er) ^ br) + x[3] + 0x7a6d76e9, 14) + cr;
            al = rotateLeft(al, 10);
            ar = rotateLeft(ar, 10);
            cl = rotateLeft(cl + ((dl & al) | (el & ~al)) + x[8] + 0x8f1bbcdc, 15) + bl;
            cr = rotateLeft(cr + (((er ^ ar) & dr) ^ ar) + x[11] + 0x7a6d76e9, 14) + br;
            el = rotateLeft(el, 10);
            er = rotateLeft(er, 10);
            bl = rotateLeft(bl + ((cl & el) | (dl & ~el)) + x[12] + 0x8f1bbcdc, 9) + al;
            br = rotateLeft(br + (((dr ^ er) & cr) ^ er) + x[15] + 0x7a6d76e9, 6) + ar;
            dl = rotateLeft(dl, 10);
            dr = rotateLeft(dr, 10);
            al = rotateLeft(al + ((bl & dl) | (cl & ~dl)) + x[4] + 0x8f1bbcdc, 8) + el;
            ar = rotateLeft(ar + (((cr ^ dr) & br) ^ dr) + x[0] + 0x7a6d76e9, 14) + er;
            cl = rotateLeft(cl, 10);
            cr = rotateLeft(cr, 10);
            el = rotateLeft(el + ((al & cl) | (bl & ~cl)) + x[13] + 0x8f1bbcdc, 9) + dl;
            er = rotateLeft(er + (((br ^ cr) & ar) ^ cr) + x[5] + 0x7a6d76e9, 6) + dr;
            bl = rotateLeft(bl, 10);
            br = rotateLeft(br, 10);
            dl = rotateLeft(dl + ((el & bl) | (al & ~bl)) + x[3] + 0x8f1bbcdc, 14) + cl;
            dr = rotateLeft(dr + (((ar ^ br) & er) ^ br) + x[12] + 0x7a6d76e9, 9) + cr;
            al = rotateLeft(al, 10);
            ar = rotateLeft(ar, 10);
            cl = rotateLeft(cl + ((dl & al) | (el & ~al)) + x[7] + 0x8f1bbcdc, 5) + bl;
            cr = rotateLeft(cr + (((er ^ ar) & dr) ^ ar) + x[2] + 0x7a6d76e9, 12) + br;
            el = rotateLeft(el, 10);
            er = rotateLeft(er, 10);
            bl = rotateLeft(bl + ((cl & el) | (dl & ~el)) + x[15] + 0x8f1bbcdc, 6) + al;
            br = rotateLeft(br + (((dr ^ er) & cr) ^ er) + x[13] + 0x7a6d76e9, 9) + ar;
            dl = rotateLeft(dl, 10);
            dr = rotateLeft(dr, 10);
            al = rotateLeft(al + ((bl & dl) | (cl & ~dl)) + x[14] + 0x8f1bbcdc, 8) + el;
            ar = rotateLeft(ar + (((cr ^ dr) & br) ^ dr) + x[9] + 0x7a6d76e9, 12) + er;
            cl = rotateLeft(cl, 10);
            cr = rotateLeft(cr, 10);
            el = rotateLeft(el + ((al & cl) | (bl & ~cl)) + x[5] + 0x8f1bbcdc, 6) + dl;
            er = rotateLeft(er + (((br ^ cr) & ar) ^ cr) + x[7] + 0x7a6d76e9, 5) + dr;
            bl = rotateLeft(bl, 10);
            br = rotateLeft(br, 10);
            dl = rotateLeft(dl + ((el & bl) | (al & ~bl)) + x[6] + 0x8f1bbcdc, 5) + cl;
            dr = rotateLeft(dr + (((ar ^ br) & er) ^ br) + x[10] + 0x7a6d76e9, 15) + cr;
            al = rotateLeft(al, 10);
            ar = rotateLeft(ar, 10);
            cl = rotateLeft(cl + ((dl & al) | (el & ~al)) + x[2] + 0x8f1bbcdc, 12) + bl;
            cr = rotateLeft(cr + (((er ^ ar) & dr) ^ ar) + x[14] + 0x7a6d76e9, 8) + br;
            el = rotateLeft(el, 10);
            er = rotateLeft(er, 10);
            
            // Round 5 and parallel округли 5
            bl = rotateLeft(bl + (cl ^ (dl | ~el)) + x[4] + 0xa953fd4e, 9) + al;
            br = rotateLeft(br + (cr ^ dr ^ er) + x[12], 8) + ar;
            dl = rotateLeft(dl, 10);
            dr = rotateLeft(dr, 10);
            al = rotateLeft(al + (bl ^ (cl | ~dl)) + x[0] + 0xa953fd4e, 15) + el;
            ar = rotateLeft(ar + (br ^ cr ^ dr) + x[15], 5) + er;
            cl = rotateLeft(cl, 10);
            cr = rotateLeft(cr, 10);
            el = rotateLeft(el + (al ^ (bl | ~cl)) + x[5] + 0xa953fd4e, 5) + dl;
            er = rotateLeft(er + (ar ^ br ^ cr) + x[10], 12) + dr;
            bl = rotateLeft(bl, 10);
            br = rotateLeft(br, 10);
            dl = rotateLeft(dl + (el ^ (al | ~bl)) + x[9] + 0xa953fd4e, 11) + cl;
            dr = rotateLeft(dr + (er ^ ar ^ br) + x[4], 9) + cr;
            al = rotateLeft(al, 10);
            ar = rotateLeft(ar, 10);
            cl = rotateLeft(cl + (dl ^ (el | ~al)) + x[7] + 0xa953fd4e, 6) + bl;
            cr = rotateLeft(cr + (dr ^ er ^ ar) + x[1], 12) + br;
            el = rotateLeft(el, 10);
            er = rotateLeft(er, 10);
            bl = rotateLeft(bl + (cl ^ (dl | ~el)) + x[12] + 0xa953fd4e, 8) + al;
            br = rotateLeft(br + (cr ^ dr ^ er) + x[5], 5) + ar;
            dl = rotateLeft(dl, 10);
            dr = rotateLeft(dr, 10);
            al = rotateLeft(al + (bl ^ (cl | ~dl)) + x[2] + 0xa953fd4e, 13) + el;
            ar = rotateLeft(ar + (br ^ cr ^ dr) + x[8], 14) + er;
            cl = rotateLeft(cl, 10);
            cr = rotateLeft(cr, 10);
            el = rotateLeft(el + (al ^ (bl | ~cl)) + x[10] + 0xa953fd4e, 12) + dl;
            er = rotateLeft(er + (ar ^ br ^ cr) + x[7], 6) + dr;
            bl = rotateLeft(bl, 10);
            br = rotateLeft(br, 10);
            dl = rotateLeft(dl + (el ^ (al | ~bl)) + x[14] + 0xa953fd4e, 5) + cl;
            dr = rotateLeft(dr + (er ^ ar ^ br) + x[6], 8) + cr;
            al = rotateLeft(al, 10);
            ar = rotateLeft(ar, 10);
            cl = rotateLeft(cl + (dl ^ (el | ~al)) + x[1] + 0xa953fd4e, 12) + bl;
            cr = rotateLeft(cr + (dr ^ er ^ ar) + x[2], 13) + br;
            el = rotateLeft(el, 10);
            er = rotateLeft(er, 10);
            bl = rotateLeft(bl + (cl ^ (dl | ~el)) + x[3] + 0xa953fd4e, 13) + al;
            br = rotateLeft(br + (cr ^ dr ^ er) + x[13], 6) + ar;
            dl = rotateLeft(dl, 10);
            dr = rotateLeft(dr, 10);
            al = rotateLeft(al + (bl ^ (cl | ~dl)) + x[8] + 0xa953fd4e, 14) + el;
            ar = rotateLeft(ar + (br ^ cr ^ dr) + x[14], 5) + er;
            cl = rotateLeft(cl, 10);
            cr = rotateLeft(cr, 10);
            el = rotateLeft(el + (al ^ (bl | ~cl)) + x[11] + 0xa953fd4e, 11) + dl;
            er = rotateLeft(er + (ar ^ br ^ cr) + x[0], 15) + dr;
            bl = rotateLeft(bl, 10);
            br = rotateLeft(br, 10);
            dl = rotateLeft(dl + (el ^ (al | ~bl)) + x[6] + 0xa953fd4e, 8) + cl;
            dr = rotateLeft(dr + (er ^ ar ^ br) + x[3], 13) + cr;
            al = rotateLeft(al, 10);
            ar = rotateLeft(ar, 10);
            cl = rotateLeft(cl + (dl ^ (el | ~al)) + x[15] + 0xa953fd4e, 5) + bl;
            cr = rotateLeft(cr + (dr ^ er ^ ar) + x[9], 11) + br;
            el = rotateLeft(el, 10);
            er = rotateLeft(er, 10);
            bl = rotateLeft(bl + (cl ^ (dl | ~el)) + x[13] + 0xa953fd4e, 6) + al;
            br = rotateLeft(br + (cr ^ dr ^ er) + x[11], 11) + ar;
            dl = rotateLeft(dl, 10);
            dr = rotateLeft(dr, 10);

            бцел t = контекст[1] + cl + dr;
            контекст[1] = контекст[2] + dl + er;
            контекст[2] = контекст[3] + el + ar;
            контекст[3] = контекст[4] + al + br;
            контекст[4] = контекст[0] + bl + cr;
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
            "9c1185a5c5e9fc54612808977ee8f548b2258d31",
            "0bdc9d2d256b3ee9daae347be6f4dc835a467ffe",
            "8eb208f7e05d987a9b044a8e98c6b087f15a0bfc",
            "5d0689ef49d2fae572b881b123a85ffa21595f36",
            "f71c27109c692c1b56bbdceb5b9d2865b3708dbc",
            "12a053384a9c0c88e405a06c27dcf49ada62eb2b",
            "b0e20b6e3116640286ed3a87a5713079b21f5189",
            "9b752e45573d4b39f4dbd3323cab82bf63326bfb"
    ];

    Ripemd160 h = new Ripemd160();

    foreach (цел i, ткст s; strings)
            {
            h.обнови(cast(ббайт[]) s);
            ткст d = h.гексДайджест;

            assert(d == results[i],":("~s~")("~d~")!=("~results[i]~")");
            }

    
    ткст s = new сим[1000000];
    for (auto i = 0; i < s.length; i++) s[i] = 'a';
    ткст результат = "52783243c1697bdbe16d37f97f68f08325dc1528";
    h.обнови(cast(ббайт[]) s);
    ткст d = h.гексДайджест;

    assert(d == результат,":(1 million times \"a\")("~d~")!=("~результат~")");
    }
	
}