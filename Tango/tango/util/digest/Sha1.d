/*******************************************************************************

        copyright:      Copyright (c) 2006 Dinrus. все rights reserved

        license:        BSD стиль: see doc/license.txt for details

        version:        Initial release: Feb 2006

        author:         Regan Heath, Oskar Linde

        This module реализует the SHA-1 Algorithm described by Secure Hash
        Standard, FИПS PUB 180-1, and RFC 3174 US Secure Hash Algorithm 1
        (SHA1). D. Eastlake 3rd, P. Jones. September 2001.

*******************************************************************************/

module util.digest.Sha1;

private import util.digest.Sha01;

public  import util.digest.Digest;

/*******************************************************************************

*******************************************************************************/

final class Sha1 : Sha01
{
        /***********************************************************************

                Construct a Sha1 hash algorithm контекст

        ***********************************************************************/
        
        this() { }

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

        final protected override проц трансформируй(ббайт[] ввод)
        {
                бцел A,B,C,D,E,TEMP;
                бцел[16] W;
                бцел s;

                bigEndian32(ввод,W);
                A = контекст[0];
                B = контекст[1];
                C = контекст[2];
                D = контекст[3];
                E = контекст[4];

                for(бцел t = 0; t < 80; t++) {
                        s = t & маска;
                        if (t >= 16)
                                расширь(W,s);
                        TEMP = rotateLeft(A,5) + f(t,B,C,D) + E + W[s] + K[t/20];
                        E = D; D = C; C = rotateLeft(B,30); B = A; A = TEMP;
                }

                контекст[0] += A;
                контекст[1] += B;
                контекст[2] += C;
                контекст[3] += D;
                контекст[4] += E;
        }

        /***********************************************************************

        ***********************************************************************/
        
        final static проц расширь (бцел[] W, бцел s)
        {
                W[s] = rotateLeft(W[(s+13)&маска] ^ W[(s+8)&маска] ^ W[(s+2)&маска] ^ W[s],1);
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
                "abc",
                "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq",
                "a",
                "0123456701234567012345670123456701234567012345670123456701234567"
        ];

        static ткст[] results = 
        [
                "a9993e364706816aba3e25717850c26c9cd0d89d",
                "84983e441c3bd26ebaae4aa1f95129e5e54670f1",
                "34aa973cd4c4daa4f61eeb2bdbad27316534016f",
                "dea356a2cddd90c7a7ecedc5ebb563934f460452"
        ];

        static цел[] repeat = 
        [
                1,
                1,
                1000000,
                10
        ];

        Sha1 h = new Sha1();
        
        foreach (цел i, ткст s; strings) 
                {
                for(цел r = 0; r < repeat[i]; r++)
                        h.обнови(s);
                
                ткст d = h.гексДайджест();
                assert(d == results[i],":("~s~")("~d~")!=("~results[i]~")");
                }
        }
}
