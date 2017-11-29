/*******************************************************************************

        copyright:      Copyright (c) 2006 James Pelcis. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: August 2006

        author:         James Pelcis

*******************************************************************************/

module util.digest.Crc32;

public import util.digest.Digest;


/** This class реализует the CRC-32 проверьsum algorithm.
    The дайджест returned is a little-эндиан 4 байт ткст. */
final class Crc32 : Дайджест
{
        private бцел[256] таблица;
        private бцел результат = 0xffffffff;

        /**
         * Созд a cloned CRC32
         */
        this (Crc32 crc32)
        {
                this.таблица[] = crc32.таблица[];
                this.результат = crc32.результат;
        }

        /**
         * Prepare Crc32 в_ проверьsum the данные with a given polynomial.
         *
         * Параметры:
         *      polynomial = The magic CRC число в_ основа calculations on.  The
         *      default compatible with ZIP, PNG, ethernet и другие. Note: This
         *      default значение имеется poor ошибка correcting свойства.
         */
        this (бцел polynomial = 0xEDB88320U)
        {
                for (цел i = 0; i < 256; i++)
                {
                        бцел значение = i;
                        for (цел j = 8; j > 0; j--)
                        {
                                version (Gim)
                                {
                                if (значение & 1) 
                                   {
                                   значение >>>= 1;
                                   значение ^= polynomial;
                                   }
                                else
                                   значение >>>= 1;
                                }
                                else
                                {
                                if (значение & 1) {
                                        значение &= 0xFFFFFFFE;
                                        значение /= 2;
                                        значение &= 0x7FFFFFFF;
                                        значение ^= polynomial;
                                }
                                else
                                {
                                        значение &= 0xFFFFFFFE;
                                        значение /= 2;
                                        значение &= 0x7FFFFFFF;
                                }
                                }
                        }
                        таблица[i] = значение;
                }
        }

        /** */
        override Crc32 обнови (проц[] ввод)
        {
                бцел r = результат; // DMD optimization
                foreach (ббайт значение; cast(ббайт[]) ввод)
                {
                        auto i = cast(ббайт) r;// & 0xff;
                        i ^= значение;
                        version (Gim)
                        {
                        r >>>= 8;
                        }
                        else
                        {
                        r &= 0xFFFFFF00;
                        r /= 0x100;
                        r &= 16777215;
                        }
                        r ^= таблица[i];
                }
                результат = r;
                return this;
        }

        /** The Crc32 размерДайджеста is 4 */
        override бцел размерДайджеста ()
        {
                return 4;
        }

        /** */
        override ббайт[] двоичныйДайджест(ббайт[] буф = пусто) {
                if (буф.length < 4)
                        буф.length = 4;
                бцел v = ~результат;
                буф[3] = cast(ббайт) (v >> 24);
                буф[2] = cast(ббайт) (v >> 16);
                буф[1] = cast(ббайт) (v >> 8);
                буф[0] = cast(ббайт) (v);
                результат = 0xffffffff;
                return буф;
        }

        /** Returns the Crc32 дайджест as a бцел */
        бцел crc32Digest() {
                бцел возвр = ~результат;
                результат = 0xffffffff;
                return возвр;
        }
}

debug(UnitTest)
{
        unittest 
        {
        scope c = new Crc32();
        static ббайт[] данные = [1,2,3,4,5,6,7,8,9,10];
        c.обнови(данные);
        assert(c.двоичныйДайджест() == cast(ббайт[]) x"7b572025");
        c.обнови(данные);
        assert(c.crc32Digest == 0x2520577b);
        c.обнови(данные);
        assert(c.гексДайджест() == "7b572025");
        }
}
