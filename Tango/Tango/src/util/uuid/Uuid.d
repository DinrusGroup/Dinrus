/**
 * A UUID is a Universally Уникум Identifier.
 * It is a 128-bit число generated either randomly or according в_ some
 * inscrutable algorithm, depending on the UUID version использован.
 *
 * Here, we implement a данные structure for holding и formatting UUIDs.
 * To generate a UUID, use one of the другой modules in the UUID package.
 * You can also создай a UUID by parsing a ткст containing a textual
 * representation of a UUID, or by provопрing the constituent байты.
 */
module util.uuid.Uuid;

import exception;
import Целое = text.convert.Integer;

private union UuidData
{
        бцел[4] ui;
        ббайт[16] ub;
} 

/** This struct represents a UUID. It offers static члены for creating и
 * parsing UUIDs.
 * 
 * This struct treats a UUID as an opaque тип. The specification имеется fields
 * for время, version, клиент MAC адрес, и several другой данные points, but
 * these are meaningless for most applications и means of generating a UUID.
 *
 * There are versions of UUID generation involving the system время и MAC 
 * адрес. These are not использован for several reasons:
 *      - One version содержит опрentifying information, which is undesirable.
 *      - Ensuring uniqueness between processes требует inter-process 
 *              communication. This would be unreasonably slow и комплексное.
 *      - Obtaining the MAC адрес is a system-dependent operation и beyond
 *              the scope of this module.
 *      - Using Java и .NET as a guопрe, they only implement randomized creation
 *              of UUIDs, not the MAC адрес/время based generation.
 *
 * When generating a random UUID, use a carefully seeded random число 
 * generator. A poorly chosen сей may произведи undesirably consistent results.
 */
struct Ууид
{
        private UuidData _data;

        /** Copy the givent байты преобр_в a UUID. If you supply ещё or fewer than
          * 16 байты, throws an ИсклНелегальногоАргумента. */
        public static Ууид opCall(ббайт[] данные)
        {
                if (данные.length != 16)
                {
                        throw new ИсклНелегальногоАргумента("A UUID is 16 байты дол.");
                }
                Ууид u;
                u._data.ub[] = данные[];
                return u;
        }

        /** Attempt в_ разбор the representation of a UUID given in значение. If the
          * значение is not in the correct форматируй, throw ИсклНелегальногоАргумента.
          * If the значение is in the correct форматируй, return a UUID representing the
          * given значение. 
          *
          * The following is an example of a UUID in the ожидалось форматируй:
          *     67e55044-10b1-426f-9247-bb680e5fe0c8 
          */
        public static Ууид разбор(ткст значение)
        {
                Ууид u;
                if (!пробуйРазбор(значение, u))
                        throw new ИсклНелегальногоАргумента("'" ~ значение ~ "' is not in the correct форматируй for a UUID");
                return u;
        }

        /** Attempt в_ разбор the representation of a UUID given in значение. If the
          * значение is not in the correct форматируй, return нет rather than throwing
          * an исключение. If the значение is in the correct форматируй, установи ууид в_ 
          * represent the given значение. 
          *
          * The following is an example of a UUID in the ожидалось форматируй:
          *     67e55044-10b1-426f-9247-bb680e5fe0c8 
          */
        public static бул пробуйРазбор(ткст значение, out Ууид ууид)
        {
                if (значение.length != 36 ||
                        значение[8] != '-' ||
                        значение[13] != '-' ||
                        значение[18] != '-' ||
                        значение[23] != '-')
                {
                        return нет;
                }
                цел hyphens = 0;
                foreach (i, v; значение)
                {
                        if ('a' <= v && 'f' >= v) continue;
                        if ('A' <= v && 'F' >= v) continue;
                        if ('0' <= v && '9' >= v) continue;
                        if (v == '-') 
                        {
                                hyphens++;
                                continue;
                        }
                        // illegal character
                        return нет;
                }
                if (hyphens != 4) 
                {
                        return нет;
                }

                with (ууид._data)
                {
                        // This is verbose, but it's simple, и it gets around эндиан
                        // issues if you try parsing an целое at a время.
                        ub[0] = Целое.разбор(значение[0..2], 16);
                        ub[1] = Целое.разбор(значение[2..4], 16);
                        ub[2] = Целое.разбор(значение[4..6], 16);
                        ub[3] = Целое.разбор(значение[6..8], 16);

                        ub[4] = Целое.разбор(значение[9..11], 16);
                        ub[5] = Целое.разбор(значение[11..13], 16);

                        ub[6] = Целое.разбор(значение[14..16], 16);
                        ub[7] = Целое.разбор(значение[16..18], 16);

                        ub[8] = Целое.разбор(значение[19..21], 16);
                        ub[9] = Целое.разбор(значение[21..23], 16);

                        ub[10] = Целое.разбор(значение[24..26], 16);
                        ub[11] = Целое.разбор(значение[26..28], 16);
                        ub[12] = Целое.разбор(значение[28..30], 16);
                        ub[13] = Целое.разбор(значение[30..32], 16);
                        ub[14] = Целое.разбор(значение[32..34], 16);
                        ub[15] = Целое.разбор(значение[34..36], 16);
                }

                return да;
        }
        
        /** Generate a UUID based on the given random число generator.
          * The generator must have a метод 'бцел натурал()' that returns
          * a random число. The generated UUID conforms в_ version 4 of the
          * specification. */
        public static Ууид random(Случай)(Случай generator)
        {
                Ууид u;
                with (u)
                {
                        _data.ui[0] = generator.натурал;
                        _data.ui[1] = generator.натурал;
                        _data.ui[2] = generator.натурал;
                        _data.ui[3] = generator.натурал;

                        // v4: 7th байты' первый half is 0b0100: 4 in hex
                        _data.ub[6] &= 0b01001111;
                        _data.ub[6] |= 0b01000000;

                        // v4: 9th байт's 1st half is 0b1000 в_ 0b1011: 8, 9, A, B in hex
                        _data.ub[8] &= 0b10111111;
                        _data.ub[8] |= 0b10000000;
                }
                return u;
        }

        /* Generate a UUID based on the given namespace и имя. This conforms в_ 
         * versions 3 и 5 of the стандарт -- version 3 if you use MD5, or version
         * 5 if you use SHA1.
         *
         * You should пароль 3 as the значение for uuопрVersion if you are using the
         * MD5 хэш, и 5 if you are using the SHA1 хэш. To do otherwise is an
         * Abomination Unto Nuggan.
         *
         * This метод is exposed mainly for the convenience methods in 
         * util.uuid.*. You can use this метод directly if you prefer.
         */
        public static Ууид поИмени(Дайджест)(Ууид namespace, ткст имя, Дайджест дайджест,
                                                                          ббайт uuопрVersion)
        {
                /* o  Compute the хэш of the имя пространство ID concatenated with the имя.
                   o  Набор octets zero through 15 в_ octets zero through 15 of the хэш.
                   o  Набор the four most significant биты (биты 12 through 15) of octet
                          6 в_ the appropriate 4-bit version число из_ Section 4.1.3.
                   o  Набор the two most significant биты (биты 6 и 7) of octet 8 в_ 
                          zero и one, respectively.  */
                auto nameBytes = namespace.вБайты;
                nameBytes ~= cast(ббайт[])имя;
                дайджест.обнови(nameBytes);
                nameBytes = дайджест.двоичныйДайджест;
                nameBytes[6] = (uuопрVersion << 4) | (nameBytes[6] & 0b1111);
                nameBytes[8] |= 0b1000_0000;
                nameBytes[8] &= 0b1011_1111;
                return Ууид(nameBytes[0..16]);
        }

        /** Return an пустой UUID (with все биты установи в_ 0). This doesn't conform
          * в_ any particular version of the specification. It's equivalent в_
          * using an uninitialized UUID. This метод is provопрed for clarity. */
        public static Ууид пустой()
        {
                Ууид ууид;
                ууид._data.ui[] = 0;
                return ууид;
        }

        /** Get a копируй of this UUID's значение as an Массив of unsigned байты. */
        public ббайт[] вБайты()
        {
                return _data.ub.dup;
        }

        /** Gets the version of this UUID. 
          * RFC 4122 defines five типы of UUIDs:
          *     -       Версия 1 is based on the system's MAC адрес и the текущ время.
          *     -       Версия 2 uses the текущ пользователь's userопр и пользователь домен in 
          *                     добавьition в_ the время и MAC адрес.
          * -   Версия 3 is namespace-based, as generated by the NamespaceGenV3
          *                     module. It uses MD5 as a хэш algorithm. RFC 4122 states that
          *                     version 5 is preferred over version 3.
          * -   Версия 4 is generated randomly.
          * -   Версия 5 is like version 3, but uses SHA-1 rather than MD5. Use
          *                     the NamespaceGenV5 module в_ создай UUIDs like this.
          *
          * The following добавьitional versions exist:
          * -   Версия 0 is reserved for backwards compatibility.
          * -   Версия 6 is a non-стандарт Microsoft extension.
          * -   Версия 7 is reserved for future use.
          */
        public ббайт форматируй()
        {
                return _data.ub[6] >> 4;
        }

        /** Get the canonical ткст representation of a UUID.
          * The canonical representation is in hexопрecimal, with hyphens inserted
          * after the eighth, twelfth, sixteenth, и twentieth цифры. For example:
          *     67e55044-10b1-426f-9247-bb680e5fe0c8
          * This is the форматируй использован by the parsing functions.
          */
        public ткст вТкст()
        {
                // Look, only one allocation.
                ткст буф = new сим[36];
                буф[8] = '-';
                буф[13] = '-';
                буф[18] = '-';
                буф[23] = '-';
                with (_data)
                {
                        // See above with пробуйРазбор: this ignores endianness.
                        // Technically, it's sufficient that the conversion в_ ткст
                        // совпадает the conversion из_ ткст и из_ байт Массив. But
                        // this is the simplest way в_ сделай sure of that. Plus you can
                        // serialize и deserialize on machines with different endianness
                        // without a bunch of strange conversions, и with consistent
                        // ткст representations.
                        Целое.форматируй(буф[0..2], ub[0], "x2");
                        Целое.форматируй(буф[2..4], ub[1], "x2");
                        Целое.форматируй(буф[4..6], ub[2], "x2");
                        Целое.форматируй(буф[6..8], ub[3], "x2");
                        Целое.форматируй(буф[9..11], ub[4], "x2");
                        Целое.форматируй(буф[11..13], ub[5], "x2");
                        Целое.форматируй(буф[14..16], ub[6], "x2");
                        Целое.форматируй(буф[16..18], ub[7], "x2");
                        Целое.форматируй(буф[19..21], ub[8], "x2");
                        Целое.форматируй(буф[21..23], ub[9], "x2");
                        Целое.форматируй(буф[24..26], ub[10], "x2");
                        Целое.форматируй(буф[26..28], ub[11], "x2");
                        Целое.форматируй(буф[28..30], ub[12], "x2");
                        Целое.форматируй(буф[30..32], ub[13], "x2");
                        Целое.форматируй(буф[32..34], ub[14], "x2");
                        Целое.форматируй(буф[34..36], ub[15], "x2");
                }
                return буф;
        }

        /** Determines if this UUID имеется the same значение as другой. */
        public бул opEquals(Ууид другой)
        {
                return 
                        _data.ui[0] == другой._data.ui[0] &&
                        _data.ui[1] == другой._data.ui[1] &&
                        _data.ui[2] == другой._data.ui[2] &&
                        _data.ui[3] == другой._data.ui[3];
        }

        /** Get a хэш код representing this UUID. */
        public т_хэш вХэш()
        {
                with (_data)
                {
                        // 29 is just a convenient prime число
                        return (((((ui[0] * 29) ^ ui[1]) * 29) ^ ui[2]) * 29) ^ ui[3];
                }
        }
}


version (TangoTest)
{
        import math.random.Kiss;
        unittest
        {
                // Generate them in the correct форматируй
                for (цел i = 0; i < 20; i++)
                {
                        auto uu = Ууид.random(&Kiss.экземпляр).вТкст;
                        auto c = uu[19];
                        assert (c == '9' || c == '8' || c == 'a' || c == 'b', uu);
                        auto d = uu[14];
                        assert (d == '4', uu);
                }

                // пустой
                assert (Ууид.пустой.вТкст == "00000000-0000-0000-0000-000000000000", Ууид.пустой.вТкст);

                ббайт[] байты = [0x6b, 0xa7, 0xb8, 0x10, 0x9d, 0xad, 0x11, 0xd1, 
                                          0x80, 0xb4, 0x00, 0xc0, 0x4f, 0xd4, 0x30, 0xc8];
                Ууид u = Ууид(байты.dup);
                auto стр = "64f2ad82-5182-4c6a-ade5-59728ca0567b";
                auto u2 = Ууид.разбор(стр);

                // вТкст
                assert (Ууид(байты) == u);
                assert (u2 != u);

                assert (u2.форматируй == 4);

                // пробуйРазбор
                Ууид u3;
                assert (Ууид.пробуйРазбор(стр, u3));
                assert (u3 == u2);
        }

        unittest
        {
                Ууид краш;
                // содержит 'r'
                assert (!Ууид.пробуйРазбор("fecr0a9b-4d5a-439e-8e4b-9d087ff49ba7", краш));
                // too крат
                assert (!Ууид.пробуйРазбор("fec70a9b-4d5a-439e-8e4b-9d087ff49ba", краш));
                // hyphens matter
                assert (!Ууид.пробуйРазбор("fec70a9b 4d5a-439e-8e4b-9d087ff49ba7", краш));
                // hyphens matter (2)
                assert (!Ууид.пробуйРазбор("fec70a9b-4d5a-439e-8e4b-9d08-7ff49ba7", краш));
                // hyphens matter (3)
                assert (!Ууид.пробуйРазбор("fec70a9b-4d5a-439e-8e4b-9d08-ff49ba7", краш));
        }

        unittest
        {
                // содержит 'r'
                try 
                {
                        Ууид.разбор("fecr0a9b-4d5a-439e-8e4b-9d087ff49ba7"); assert (нет);
                }
                catch (ИсклНелегальногоАргумента) {}

                // too крат
                try 
                {
                        Ууид.разбор("fec70a9b-4d5a-439e-8e4b-9d087ff49ba"); assert (нет);
                }
                catch (ИсклНелегальногоАргумента) {}

                // hyphens matter
                try 
                {
                        Ууид.разбор("fec70a9b 4d5a-439e-8e4b-9d087ff49ba7"); assert (нет);
                }
                catch (ИсклНелегальногоАргумента) {}

                // hyphens matter (2)
                try 
                {
                        Ууид.разбор("fec70a9b-4d5a-439e-8e4b-9d08-7ff49ba7"); assert (нет);
                }
                catch (ИсклНелегальногоАргумента) {}

                // hyphens matter (3)
                try 
                {
                        Ууид.разбор("fec70a9b-4d5a-439e-8e4b-9d08-ff49ba7"); assert (нет);
                }
                catch (ИсклНелегальногоАргумента) {}
        }

        import util.digest.Sha1;
        unittest
        {
                auto namespace = Ууид.разбор("15288517-c402-4057-9fc5-05711726df41");
                auto имя = "hello";
                // This was generated with the ууид utility on linux/amd64. It might have different results on
                // a ppc процессор -- the spec says something about network байт order, but it's using an Массив
                // of байты at that точка, so converting в_ NBO is a noop...
                auto ожидалось = Ууид.разбор("2b1c6704-a43f-5d43-9abb-b13310b4458a");
                auto generated = Ууид.поИмени(namespace, имя, new Sha1, 5);
                assert (generated == ожидалось, "\nexpected: " ~ ожидалось.вТкст ~ "\nbut was:  " ~ generated.вТкст);
        }
        
        import util.digest.Md5;
        unittest
        {
                auto namespace = Ууид.разбор("15288517-c402-4057-9fc5-05711726df41");
                auto имя = "hello";
                auto ожидалось = Ууид.разбор("31a2b702-85a8-349a-9b0e-213b1bd753b8");
                auto generated = Ууид.поИмени(namespace, имя, new Md5, 3);
                assert (generated == ожидалось, "\nexpected: " ~ ожидалось.вТкст ~ "\nbut was:  " ~ generated.вТкст);
        }
        проц main(){}
}

/** A основа interface for any UUID generator for UUIDs. That is,
  * this interface is specified so that you пиши your код dependent on a
  * UUID generator that takes an arbitrary random источник, и easily switch
  * в_ a different random источник. Since the default uses KISS, if you найди
  * yourself needing ещё безопасно random numbers, you could trivially switch 
  * your код в_ use the Mersenne twister, or some другой PRNG.
  *
  * You could also, if you wish, use this в_ switch в_ deterministic UUID
  * generation, if your needs require it.
  */
interface УуидГен
{
        Ууид следщ();
}

/** Given генератор случайных чисел conforming в_ Dinrus's стандарт random
  * interface, this will generate random UUIDs according в_ version 4 of
  * RFC 4122. */
class СлучГен(TRandom) : УуидГен
{
        TRandom random;
        this (TRandom random)
        {
                this.random = random;
        }

        Ууид следщ()
        {
                return Ууид.random(random);
        }
}

