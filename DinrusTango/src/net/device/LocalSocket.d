﻿/*******************************************************************************

        copyright:      Copyright (c) 2009 Dinrus. Все права защищены

        license:        BSD стиль: $(LICENSE)

        version:        Nov 2009: Initial release

        author:         Lukas Pinkowski, Kris

*******************************************************************************/

module net.device.LocalSocket;

private import net.device.Socket;
private import stdrus: вЮ16;
/*******************************************************************************


*******************************************************************************/

version (Windows)
{
    pragma(msg, "ЛокальныйСокет для Windows пока не реализован");
}

/*******************************************************************************

        A wrapper around the Беркли API в_ implement the ИПровод
        abstraction и добавь поток-specific functionality.

*******************************************************************************/

class ЛокальныйСокет : Сокет
{
    /***********************************************************************

            Созд a Потокing local сокет

    ***********************************************************************/

    private this ()
    {
        super (ПСемействоАдресов.ЮНИКС, ПТипСок.Поток, ППротокол.ИП);
    }

    /***********************************************************************

            Созд a Потокing local сокет

    ***********************************************************************/

    this (ткст путь)
    {
        this (new ЛокальныйАдрес (путь));
    }

    /***********************************************************************

            Созд a Потокing local сокет

    ***********************************************************************/

    this (ЛокальныйАдрес адр)
    {
        this();
        super.подключись (адр);
    }

    /***********************************************************************

            Return the имя of this устройство

    ***********************************************************************/

    override ткст вТкст()
    {
        return "<локальныйСокет>";
    }
}

/*******************************************************************************


*******************************************************************************/

class СокетЛокальногоСервера : ЛокальныйСокет
{
    /***********************************************************************

    ***********************************************************************/

    this (ткст путь, цел backlog=32, бул reuse=нет)
    {
        auto адр = new ЛокальныйАдрес (путь);
        исконный.повторнИспАдреса(reuse).вяжи(адр).слушай(backlog);
    }

    /***********************************************************************

            Return the имя of this устройство

    ***********************************************************************/

    override ткст вТкст()
    {
        return "<локальныйприём>";
    }

    /***********************************************************************

    ***********************************************************************/

    Сокет прими (Сокет реципиент = пусто)
    {
        if (реципиент is пусто)
            реципиент = new ЛокальныйСокет;

        исконный.прими (*реципиент.исконный);
        реципиент.таймаут = таймаут;
        return реципиент;
    }
}

/*******************************************************************************

*******************************************************************************/

class ЛокальныйАдрес : Адрес
{
    align(1) struct sockAddr_un
    {
        бкрат sun_family = ПСемействоАдресов.ЮНИКС;
        сим[108] sun_path;
    }

    protected
    {
        sockAddr_un sun;
        ткст _path;
        цел _pathLength;
    }

    /***********************************************************************

        -путь- путь в_ a unix домен сокет (which is a имяф)

    ***********************************************************************/

    this (ткст путь)
    {
        assert (путь.length < 108);

        sun.sun_path [0 .. путь.length] = путь;
        sun.sun_path [путь.length .. $] = 0;

        _pathLength = путь.length;
        _path = sun.sun_path [0 .. путь.length];
    }

    /***********************************************************************

    ***********************************************************************/

    final адрессок* имя ()
    {
        return cast(адрессок*) &sun;
    }

    /***********************************************************************

    ***********************************************************************/

    final цел длинаИмени ()
    {
        return _pathLength + бкрат.sizeof;
    }

    /***********************************************************************

    ***********************************************************************/

    final ПСемействоАдресов семействоАдресов ()
    {
        return ПСемействоАдресов.ЮНИКС;
    }

    /***********************************************************************

    ***********************************************************************/

    final ткст вТкст ()
    {
        if (абстрактен_ли)
            return "unix:абстрактен=" ~ _path[1..$];
        else
            return "unix:путь=" ~ _path;
    }

    /***********************************************************************

    ***********************************************************************/

    final ткст путь ()
    {
        return _path;
    }

    /***********************************************************************

    ***********************************************************************/

    final бул абстрактен_ли ()
    {
        return _path[0] == 0;
    }
}

/******************************************************************************

******************************************************************************/

debug (ЛокальныйСокет)
{
    import io.Stdout;

    проц main()
    {
        auto y = new ЛокальныйСокет ("foo");
        auto x = new СокетЛокальногоСервера ("foo");
    }
}
