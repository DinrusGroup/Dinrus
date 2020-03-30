 import cidrus, io.Console, sys.Environment;


    проц main(ткст[] арги)
    {
        const ткст VAR = "TESTENVVAR";
        const ткст VAL1 = "VAL1";
        const ткст VAL2 = "VAL2";

        assert(Среда.получи(VAR) is пусто);

        Среда.установи(VAR, VAL1);
        assert(Среда.получи(VAR) == VAL1);

        Среда.установи(VAR, VAL2);
        assert(Среда.получи(VAR) == VAL2);

        Среда.установи(VAR, пусто);
        assert(Среда.получи(VAR) is пусто);

        Среда.установи(VAR, VAL1);
        Среда.установи(VAR, "");

        assert(Среда.получи(VAR) is пусто);

        foreach (ключ, значение; Среда.получи)
        Квывод (ключ) ("=") (значение).нс;

        if (арги.length > 0)
        {
            auto p = Среда.путьКЭкзэ (арги[0]);
            Квывод (p).нс;
        }

        if (арги.length > 1)
        {
            if (auto p = Среда.путьКЭкзэ (арги[1]))
                Квывод (p).нс;
        }
		scope(exit) cidrus.выход(0);
    }