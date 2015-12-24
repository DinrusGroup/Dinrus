﻿/*******************************************************************************

        copyright:      Copyright (c) 2006 Dinrus. все rights reserved

        license:        BSD стиль: see doc/license.txt for details

        version:        Initial release: Feb 2006

        author:         Regan Heath, Oskar Linde

        This module реализует the SHA-512 Algorithm described by Secure
        Hash Standard, FИПS PUB 180-2

*******************************************************************************/

module util.digest.Sha512;

private import ByteSwap;

private import util.digest.MerkleDamgard;

public  import util.digest.Digest;

/*******************************************************************************

*******************************************************************************/

final class Sha512 : MerkleDamgard
{
        private бдол[8]        контекст;
        private const бцел      padChar = 0x80;

        /***********************************************************************

                Construct a Sha512 hash algorithm контекст

        ***********************************************************************/

        this() { }

        /***********************************************************************

        ***********************************************************************/

        protected override проц создайДайджест(ббайт[] буф)
        {
                version (LittleEndian)
                         ПерестановкаБайт.своп64(контекст.ptr, контекст.length * бдол.sizeof);

                буф[] = cast(ббайт[]) контекст[];
        }

        /***********************************************************************

                The дайджест размер of Sha-512 is 64 байты

        ***********************************************************************/

        override бцел digestSize() {return 64;}

        /***********************************************************************

                Initialize the cИПher

                Remarks:
                Returns the cИПher состояние в_ it's начальное значение

        ***********************************************************************/

        protected override проц сбрось()
        {
                super.сбрось();
                контекст[] = начальное[];
        }

        /***********************************************************************

                Шифр block размер

                Возвращает:
                the block размер

                Remarks:
                Specifies the размер (in байты) of the block of данные в_ пароль в_
                each вызов в_ трансформируй(). For SHA512 the размерБлока is 128.

        ***********************************************************************/

        protected override бцел размерБлока() { return 128; }

        /***********************************************************************

                Length паддинг размер

                Возвращает:
                the length паддинг размер

                Remarks:
                Specifies the размер (in байты) of the паддинг which uses the
                length of the данные which есть been cИПhered, this паддинг is
                carried out by the padLength метод. For SHA512 the добавьSize is 16.

        ***********************************************************************/

        protected override бцел добавьSize()   { return 16;  }

        /***********************************************************************

                Pads the cИПher данные

                Параметры:
                данные = a срез of the cИПher буфер в_ заполни with паддинг

                Remarks:
                Fills the passed буфер срез with the appropriate паддинг for
                the final вызов в_ трансформируй(). This паддинг will заполни the cИПher
                буфер up в_ размерБлока()-добавьSize().

        ***********************************************************************/

        protected override проц padMessage(ббайт[] данные)
        {
                данные[0] = padChar;
                данные[1..$] = 0;
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

        protected override проц padLength(ббайт[] данные, бдол length)
        {
                length <<= 3;
                for(цел j = данные.length-1; j >= 0; j--) {
                        данные[данные.length-j-1] = cast(ббайт) (length >> j*8);
                }
                данные[0..8] = 0;
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
                бдол[80] W;
                бдол a,b,c,d,e,f,g,h;
                бдол t1,t2;
                бцел j;

                a = контекст[0];
                b = контекст[1];
                c = контекст[2];
                d = контекст[3];
                e = контекст[4];
                f = контекст[5];
                g = контекст[6];
                h = контекст[7];

                bigEndian64(ввод,W[0..16]);
                for(j = 16; j < 80; j++) {
                        W[j] = mix1(W[j-2]) + W[j-7] + mix0(W[j-15]) + W[j-16];
                }

                for(j = 0; j < 80; j++) {
                        t1 = h + sum1(e) + Ch(e,f,g) + K[j] + W[j];
                        t2 = sum0(a) + Maj(a,b,c);
                        h = g;
                        g = f;
                        f = e;
                        e = d + t1;
                        d = c;
                        c = b;
                        b = a;
                        a = t1 + t2;
                }

                контекст[0] += a;
                контекст[1] += b;
                контекст[2] += c;
                контекст[3] += d;
                контекст[4] += e;
                контекст[5] += f;
                контекст[6] += g;
                контекст[7] += h;
        }

        /***********************************************************************

        ***********************************************************************/

        private static бдол Ch(бдол x, бдол y, бдол z)
        {
                return (x&y)^(~x&z);
        }

        /***********************************************************************

        ***********************************************************************/

        private static бдол Maj(бдол x, бдол y, бдол z)
        {
                return (x&y)^(x&z)^(y&z);
        }

        /***********************************************************************

        ***********************************************************************/

        private static бдол sum0(бдол x)
        {
                return rotateRight(x,28)^rotateRight(x,34)^rotateRight(x,39);
        }

        /***********************************************************************

        ***********************************************************************/

        private static бдол sum1(бдол x)
        {
                return rotateRight(x,14)^rotateRight(x,18)^rotateRight(x,41);
        }

        /***********************************************************************

        ***********************************************************************/

        private static бдол mix0(бдол x)
        {
                return rotateRight(x,1)^rotateRight(x,8)^shiftRight(x,7);
        }

        /***********************************************************************

        ***********************************************************************/

        private static бдол mix1(бдол x)
        {
                return rotateRight(x,19)^rotateRight(x,61)^shiftRight(x,6);
        }

        /***********************************************************************

        ***********************************************************************/

        private static бдол rotateRight(бдол x, бцел n)
        {
                return (x >> n) | (x << (64-n));
        }

        /***********************************************************************

        ***********************************************************************/

        private static бдол shiftRight(бдол x, бцел n)
        {
                return x >> n;
        }

}

/*******************************************************************************

*******************************************************************************/

private static const бдол[] K =
[
        0x428a2f98d728ae22, 0x7137449123ef65cd, 0xb5c0fbcfec4d3b2f, 0xe9b5dba58189dbbc,
        0x3956c25bf348b538, 0x59f111f1b605d019, 0x923f82a4af194f9b, 0xab1c5ed5da6d8118,
        0xd807aa98a3030242, 0x12835b0145706fbe, 0x243185be4ee4b28c, 0x550c7dc3d5ffb4e2,
        0x72be5d74f27b896f, 0x80deb1fe3b1696b1, 0x9bdc06a725c71235, 0xc19bf174cf692694,
        0xe49b69c19ef14ad2, 0xefbe4786384f25e3, 0x0fc19dc68b8cd5b5, 0x240ca1cc77ac9c65,
        0x2de92c6f592b0275, 0x4a7484aa6ea6e483, 0x5cb0a9dcbd41fbd4, 0x76f988da831153b5,
        0x983e5152ee66dfab, 0xa831c66d2db43210, 0xb00327c898fb213f, 0xbf597fc7beef0ee4,
        0xc6e00bf33da88fc2, 0xd5a79147930aa725, 0x06ca6351e003826f, 0x142929670a0e6e70,
        0x27b70a8546d22ffc, 0x2e1b21385c26c926, 0x4d2c6dfc5ac42aed, 0x53380d139d95b3df,
        0x650a73548baf63de, 0x766a0abb3c77b2a8, 0x81c2c92e47edaee6, 0x92722c851482353b,
        0xa2bfe8a14cf10364, 0xa81a664bbc423001, 0xc24b8b70d0f89791, 0xc76c51a30654be30,
        0xd192e819d6ef5218, 0xd69906245565a910, 0xf40e35855771202a, 0x106aa07032bbd1b8,
        0x19a4c116b8d2d0c8, 0x1e376c085141ab53, 0x2748774cdf8eeb99, 0x34b0bcb5e19b48a8,
        0x391c0cb3c5c95a63, 0x4ed8aa4ae3418acb, 0x5b9cca4f7763e373, 0x682e6ff3d6b2b8a3,
        0x748f82ee5defb2fc, 0x78a5636f43172f60, 0x84c87814a1f0ab72, 0x8cc702081a6439ec,
        0x90befffa23631e28, 0xa4506cebde82bde9, 0xbef9a3f7b2c67915, 0xc67178f2e372532b,
        0xca273eceea26619c, 0xd186b8c721c0c207, 0xeada7dd6cde0eb1e, 0xf57d4f7fee6ed178,
        0x06f067aa72176fba, 0x0a637dc5a2c898a6, 0x113f9804bef90dae, 0x1b710b35131c471b,
        0x28db77f523047d84, 0x32caab7b40c72493, 0x3c9ebe0a15c9bebc, 0x431d67c49c100d4c,
        0x4cc5d4becb3e42b6, 0x597f299cfc657e2a, 0x5fcb6fab3ad6faec, 0x6c44198c4a475817
];

/*******************************************************************************

*******************************************************************************/

private static const бдол[8] начальное =
[
        0x6a09e667f3bcc908,
        0xbb67ae8584caa73b,
        0x3c6ef372fe94f82b,
        0xa54ff53a5f1d36f1,
        0x510e527fade682d1,
        0x9b05688c2b3e6c1f,
        0x1f83d9abfb41bd6b,
        0x5be0cd19137e2179
];


/*******************************************************************************

*******************************************************************************/

debug(UnitTest)
{
        unittest
        {
        static ткст[] strings =
        [
                "",
                "abc",
                "abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu"
        ];

        static ткст[] results =
        [
                "cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e",
                "ddaf35a193617abacc417349ae20413112e6fa4e89a97ea20a9eeee64b55d39a2192992a274fc1a836ba3c23a3feebbd454d4423643ce80e2a9ac94fa54ca49f",
                "8e959b75dae313da8cf4f72814fc143f8f7779c6eb9f7fa17299aeadb6889018501d289e4900f7e4331b99dec4b5433ac7d329eeb6dd26545e96e55b874be909"
        ];

        Sha512 h = new Sha512;

        foreach (цел i, ткст s; strings)
                {
                h.обнови(cast(ббайт[])s);
                ткст d = h.гексДайджест();
                assert(d == results[i],"DigestTransform:("~s~")("~d~")!=("~results[i]~")");
                }
        }
}