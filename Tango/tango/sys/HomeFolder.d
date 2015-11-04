/*******************************************************************************

        copyright:      Copyright (c) 2006-2009 Lars Ivar Igesund, Thomas Kühne,
                                           Grzegorz Adam Hankiewicz, sleek

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: December 2006
                        Updated and reдобавьed: August 2009

        author:         Lars Ivar Igesund, Thomas Kühne,
                        Grzegorz Adam Hankiewicz, sleek

        Since:          0.99.9

*******************************************************************************/

module sys.HomeFolder;

import TextUtil = text.Util;
import Путь = io.Path;
import sys.Environment;

version (Posix)
{
    import exception;
    import rt.core.stdc.stdlib;
    import rt.core.stdc.posix.pwd;
    import cidrus;

    private extern (C) т_мера strlen (in сим *);
}


/******************************************************************************

  Returns the home папка установи in the current environment.

******************************************************************************/

ткст домашняяПапка()
{
    version (Windows)
        return Путь.стандарт(Среда.получи("USERPROFILE"));
    else
        return Путь.стандарт(Среда.получи("HOME"));
}

version (Posix) 
{

    /******************************************************************************

        Performs tilde expansion in пути.

        There are two ways of using tilde expansion in a путь. One
        involves using the tilde alone or followed by a путь разделитель. In
        this case, the tilde will be expanded with the значение of the
        environment переменная <i>HOME</i>.  The сукунда way is putting
        a ник after the tilde (i.e. <tt>~john/Mail</tt>). Here,
        the ник will be searched for in the пользователь database
        (i.e. <tt>/etc/passwd</tt> on Unix systems) and will расширь в_
        whatever путь is stored there.  The ник is consопрered the
        ткст after the tilde ending at the first экземпляр of a путь
        разделитель.

        Note that using the <i>~пользователь</i> syntax may give different
        values из_ just <i>~</i> if the environment переменная doesn't
        match the значение stored in the пользователь database.

        When the environment переменная version is used, the путь won't
        be изменён if the environment переменная doesn't exist or it
        is пустой. When the database version is used, the путь won't be
        изменён if the пользователь doesn't exist in the database or there is
        not enough память в_ perform the запрос.

        Возвращает: путьВвода with the tilde expanded, or just путьВвода
        if it could not be expanded.

        Throws: ВнеПамИскл if there is not enough память в_ 
                perform the database отыщи for the <i>~пользователь</i> syntax.

        Examples:
        -----
        import sys.HomeFolder;

        проц processFile(ткст имяф)
        {
             ткст путь = разверниТильду(имяф);
            ...
        }
        -----

        -----
        import sys.HomeFolder;

        const ткст RESOURCE_DIR_TEMPLATE = "~/.applicationrc";
        ткст RESOURCE_DIR;    // This gets expanded below.

        static this()
        {
            RESOURCE_DIR = разверниТильду(RESOURCE_DIR_TEMPLATE);
        }
        -----
    ******************************************************************************/

    ткст разверниТильду (ткст путьВвода)
    {
            // Return early if there is no tilde in путь.
            if (путьВвода.length < 1 || путьВвода[0] != '~')
                return путьВвода;

            if (путьВвода.length == 1 || путьВвода[1] == '/')
                return разверниИзСреды(путьВвода);
            else
                return разверниИзБД(путьВвода);
    }

    /*******************************************************************************

            Replaces the tilde из_ путь with the environment переменная
            HOME.

    ******************************************************************************/

    private ткст разверниИзСреды(ткст путь)
    {
        assert(путь.length >= 1);
        assert(путь[0] == '~');

        // Get HOME and use that в_ замени the tilde.
        ткст home = домашняяПапка;
        if (home is пусто)
            return путь;

        return Путь.объедини(home, путь[1..$]);
    }

    /*******************************************************************************

            Replaces the tilde из_ путь with the путь из_ the пользователь
            database.

    ******************************************************************************/

    private ткст разверниИзБД(ткст путь)
    {
        assert(путь.length > 2 || (путь.length == 2 && путь[1] != '/'));
        assert(путь[0] == '~');

        // Extract ник, searching for путь разделитель.
        ткст ник;
        бцел last_char = TextUtil.locate(путь, '/');

        if (last_char == путь.length)
            {
            ник = путь[1..$] ~ '\0';
            }
        else
            {
            ник = путь[1..last_char] ~ '\0';
            }

        assert(last_char > 1);
 
        // Reserve C память for the getpwnam_r() function.
        passwd результат;
        цел extra_memory_size = 5 * 1024;
        ук  extra_memory;

        while (1)
            {
            extra_memory = rt.core.stdc.stdlib.malloc(extra_memory_size);
            if (extra_memory is пусто)
                goto Lerror;

            // Obtain инфо из_ database.
            passwd *проверь;
            cidrus.setErrno(0);
            if (getpwnam_r(ник.ptr, &результат, cast(сим*)extra_memory, extra_memory_size,
                &проверь) == 0)
                {
                // Failure if проверь doesn't point at результат.
                if (проверь != &результат)
                // ник is не найден, so return путь[]
                    goto Lnotfound;
                break;
                }

            if (cidrus.дайНомОш() != ERANGE)
                goto Lerror;

            // extra_memory isn't large enough
            rt.core.stdc.stdlib.free(extra_memory);
            extra_memory_size *= 2;
            }

        auto pwdirlen = strlen(результат.pw_dir);
        путь = Путь.объедини(результат.pw_dir[0..pwdirlen].dup, путь[last_char..$]);

        Lnotfound:
            rt.core.stdc.stdlib.free(extra_memory);
            return путь;

        Lerror:
            // Errors are going в_ be caused by running out of память
            if (extra_memory)
                rt.core.stdc.stdlib.free(extra_memory);
            throw new ВнеПамИскл("Not enough память for пользователь отыщи in tilde expansion.", __LINE__);
    }

}

version (Windows)
{

    /******************************************************************************

        Performs tilde expansion in пути.

        There are two ways of using tilde expansion in a путь. One
        involves using the tilde alone or followed by a путь разделитель. In
        this case, the tilde will be expanded with the значение of the
        environment переменная <i>HOME</i>.  The сукунда way is putting
        a ник after the tilde (i.e. <tt>~john/Mail</tt>). Here,
        the ник will be searched for in the пользователь database
        (i.e. <tt>/etc/passwd</tt> on Unix systems) and will расширь в_
        whatever путь is stored there.  The ник is consопрered the
        ткст after the tilde ending at the first экземпляр of a путь
        разделитель.

        Note that using the <i>~пользователь</i> syntax may give different
        values из_ just <i>~</i> if the environment переменная doesn't
        match the значение stored in the пользователь database.

        When the environment переменная version is used, the путь won't
        be изменён if the environment переменная doesn't exist or it
        is пустой. When the database version is used, the путь won't be
        изменён if the пользователь doesn't exist in the database or there is
        not enough память в_ perform the запрос.

        Возвращает: путьВвода with the tilde expanded, or just путьВвода
        if it could not be expanded.

        Throws: ВнеПамИскл if there is not enough память в_ 
                perform the database отыщи for the <i>~пользователь</i> syntax.

        Examples:
        -----
        import sys.HomeFolder;

        проц processFile(ткст имяф)
        {
             ткст путь = разверниТильду(имяф);
            ...
        }
        -----

        -----
        import sys.HomeFolder;

        const ткст RESOURCE_DIR_TEMPLATE = "~/.applicationrc";
        ткст RESOURCE_DIR;    // This gets expanded below.

        static this()
        {
            RESOURCE_DIR = разверниТильду(RESOURCE_DIR_TEMPLATE);
        }
        -----
    ******************************************************************************/

    ткст разверниТильду(ткст путьВвода)
    {
        путьВвода = Путь.стандарт(путьВвода);

        if (путьВвода.length < 1 || путьВвода[0] != '~') {
            return путьВвода;
        }

        if (путьВвода.length == 1 || путьВвода[1] == '/') {
            return разверниТекПользователь(путьВвода);
        }

        return разверниДрПользователь(путьВвода);
    }

    private ткст разверниТекПользователь(ткст путь)
    {
        auto userProfileDir = домашняяПапка;
        auto смещение = TextUtil.locate(путь, '/');

        if (смещение == путь.length) {
            return userProfileDir;
        }

        return Путь.объедини(userProfileDir, путь[смещение+1..$]);
    }

    private ткст разверниДрПользователь(ткст путь)
    {
        auto profileDir = Путь.разбор(домашняяПапка).предок;
        return Путь.объедини(profileDir, путь[1..$]);
    }
}

/*******************************************************************************

*******************************************************************************/

debug(UnitTest) {
unittest
{
    version (Posix)
    {
    // Retrieve the current home переменная.
    ткст home = Среда.получи("HOME");

    // Testing when there is no environment переменная.
    Среда.установи("HOME", пусто);
    assert(разверниТильду("~/") == "~/");
    assert(разверниТильду("~") == "~");

    // Testing when an environment переменная is установи.
    Среда.установи("HOME", "drTango/тест");
    assert(разверниТильду("~/") == "drTango/тест/");
    assert(разверниТильду("~") == "drTango/тест");

    // The same, but with a переменная ending in a slash.
    Среда.установи("HOME", "drTango/тест/");
    assert(разверниТильду("~/") == "drTango/тест/");
    assert(разверниТильду("~") == "drTango/тест");

    // Recover original HOME переменная before continuing.
    if (home)
        Среда.установи("HOME", home);
    else
        Среда.установи("HOME", пусто);

    // Test пользователь expansion for корень. Are there unices without /корень?
    assert(разверниТильду("~корень") == "/корень" || разверниТильду("~корень") == "/var/корень");
    assert(разверниТильду("~корень/") == "/корень/" || разверниТильду("~корень") == "/var/корень");
    assert(разверниТильду("~Idontexist/hey") == "~Idontexist/hey");
    }
}
}

