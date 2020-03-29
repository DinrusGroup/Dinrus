﻿/*******************************************************************************
     copyright:      Copyright (c) 2007-2008 Dinrus. Все права защищены

     license:        BSD стиль: $(LICENSE)

     version:        August 2008: Initial version

     author:         Lester L. Martin II
*******************************************************************************/

module io.vfs.FtpFolder;

private
{
    import net.ftp.FtpClient;
    import io.vfs.model;
    import io.vfs.FileFolder;
    import io.device.Conduit;
    import text.Util;
    import time.Time;
}

private ткст фиксируйИмя(ткст toFix)
{
    if (естьОбразец(toFix, "/"))
        toFix = toFix[(местоположениеПеред(toFix, '/') + 1) .. length];
    return toFix;
}

private ткст проверьПерв(ткст toFix)
{
    for(; toFix.length>0 && toFix[$-1] == '/';)
        toFix = toFix[0 .. ($-1)];
    return toFix;
}

private ткст проверьПоследн(ткст toFix)
{
    for(; toFix.length>1 &&  toFix[0] == '/' && toFix[1] == '/' ;)
        toFix = toFix[1 .. $];
    if(toFix.length && toFix[0] != '/')
        toFix = '/' ~ toFix;
    return toFix;
}

private ткст проверьКат(ткст первый, ткст последний)
{
    return проверьПерв(первый) ~ проверьПоследн(последний);
}

private ИнфОФайлеФтп[] дайЗаписи(СоединениеФтп ftp, ткст путь = "")
{
    ИнфОФайлеФтп[] orig = ftp.ls(путь);
    ИнфОФайлеФтп[] temp2;
    ИнфОФайлеФтп[] use;
    ИнфОФайлеФтп[] temp;
    foreach(ИнфОФайлеФтп inf; orig)
    {
        if(inf.тип == ПТипФайлаФтп.Дрдир)
        {
            temp ~= inf;
        }
    }
    foreach(ИнфОФайлеФтп inf; temp)
    {
        temp2 ~= дайЗаписи((ftp.cd(inf.имя), ftp));
        //wasn't here at the beginning
        foreach(inf2; temp2)
        {
            inf2.имя = проверьКат(inf.имя, inf2.имя);
            use ~= inf2;
        }
        orig ~= use;
        //конец wasn't here at the beginning
        ftp.cdup();
    }
    return orig;
}

private ИнфОФайлеФтп[] дайФайлы(СоединениеФтп ftp, ткст путь = "")
{
    ИнфОФайлеФтп[] infos = дайЗаписи(ftp, путь);
    ИнфОФайлеФтп[] return_;
    foreach(ИнфОФайлеФтп инфо; infos)
    {
        if(инфо.тип == ПТипФайлаФтп.Файл || инфо.тип == ПТипФайлаФтп.Другой || инфо.тип == ПТипФайлаФтп.Неизвестен)
            return_ ~= инфо;
    }
    return return_;
}

private ИнфОФайлеФтп[] дайПапки(СоединениеФтп ftp, ткст путь = "")
{
    ИнфОФайлеФтп[] infos = дайЗаписи(ftp, путь);
    ИнфОФайлеФтп[] return_;
    foreach(ИнфОФайлеФтп инфо; infos)
    {
        if(инфо.тип == ПТипФайлаФтп.Дрдир || инфо.тип == ПТипФайлаФтп.Текдир || инфо.тип == ПТипФайлаФтп.Предокдир)
            return_ ~= инфо;
    }
    return return_;
}

/******************************************************************************
    Defines a папка over FTP that имеется yet в_ be opened, may not exist, и
      may be создан.
******************************************************************************/

class ЗаписьПапкиФтп: ЗаписьПапкиВфс
{

    ткст вТкст_, имя_, имяПользователя_, пароль_;
    бцел порт_;

    public this(ткст сервер, ткст путь, ткст ник = "",
                ткст пароль = "", бцел порт = 21)
    in
    {
        assert(сервер.length > 0);
    }
    body
    {
        вТкст_ = проверьПерв(сервер);
        имя_ = проверьПоследн(путь);
        имяПользователя_ = ник;
        пароль_ = пароль;
        порт_ = порт;
    }

    /***********************************************************************
     Открыть a папка
     ***********************************************************************/

    final ПапкаВфс открой()
    {
        return new ПапкаФтп(вТкст_, имя_, имяПользователя_, пароль_, порт_);
    }

    /***********************************************************************
     Созд a new папка
     ***********************************************************************/

    final ПапкаВфс создай()
    {
        СоединениеФтп связь;

        scope(failure)
        {
            if(связь !is пусто)
                связь.закрой();
        }

        scope(exit)
        {
            if(связь !is пусто)
                связь.закрой();
        }

        связь = new СоединениеФтп(вТкст_, имяПользователя_, пароль_, порт_);
        связь.mkdir(имя_);

        return new ПапкаФтп(вТкст_, имя_, имяПользователя_, пароль_, порт_);
    }

    /***********************************************************************
     Проверка существования папки
     ***********************************************************************/

    final бул есть_ли()
    {
        СоединениеФтп связь;



        scope(exit)
        {
            if(связь !is пусто)
                связь.закрой();
        }

        бул return_;
        if(имя_ == "")
        {
            try
            {
                связь = new СоединениеФтп(вТкст_, имяПользователя_, пароль_, порт_);
                return_ = да;
            }
            catch(Исключение e)
            {
                return нет;
            }
        }
        else
        {
            try
            {
                связь = new СоединениеФтп(вТкст_, имяПользователя_, пароль_, порт_);
                try
                {
                    связь.cd(имя_);
                    return_ = да;
                }
                catch(Исключение e)
                {
                    if(связь.exist(имя_) == 2)
                        return_ = да;
                    else
                        return_ = нет;
                }
            }
            catch(Исключение e)
            {
                return_ = нет;
            }
        }

        return return_;
    }
}

/******************************************************************************
     Represents a FTP Folder in full, allowing one в_ адрес
     specific папки of an FTP Файл system.
******************************************************************************/

class ПапкаФтп: ПапкаВфс
{

    ткст вТкст_, имя_, имяПользователя_, пароль_;
    бцел порт_;

    public this(ткст сервер, ткст путь, ткст ник = "",
                ткст пароль = "", бцел порт = 21)
    in
    {
        assert(сервер.length > 0);
    }
    body
    {
        вТкст_ = проверьПерв(сервер);
        имя_ = проверьПоследн(путь);
        имяПользователя_ = ник;
        пароль_ = пароль;
        порт_ = порт;
    }

    /***********************************************************************
     Return a крат имя
     ***********************************************************************/

    final ткст имя()
    {
        return фиксируйИмя(имя_);
    }

    /***********************************************************************
     Return a дол имя
     ***********************************************************************/

    final ткст вТкст()
    {
        return проверьКат(вТкст_, имя_);
    }

    /***********************************************************************
     Return a contained файл representation
     ***********************************************************************/

    final ФайлВфс файл(ткст путь)
    {
        return new ФайлФтп(вТкст_, проверьПоследн(проверьКат(имя_, путь)), имяПользователя_, пароль_,
                                  порт_);
    }

    /***********************************************************************
     Return a contained папка representation
     ***********************************************************************/

    final ЗаписьПапкиВфс папка(ткст путь)
    {
        return new ЗаписьПапкиФтп(вТкст_, проверьПоследн(проверьКат(имя_, путь)), имяПользователя_,
                                                пароль_, порт_);
    }

    /***********************************************************************
     Returns a папка установи containing only this one. Statistics
     are включительно of записи внутри this папка only
     ***********************************************************************/

    final ПапкиВфс сам()
    {
        СоединениеФтп связь;



        scope(exit)
        {
            if(связь !is пусто)
                связь.закрой();
        }

        ткст подключись = вТкст_;

        if(подключись[$ - 1] == '/')
        {
            подключись = подключись[0 .. ($ - 1)];
        }

        связь = new СоединениеФтп(подключись, имяПользователя_, пароль_, порт_);

        if(имя_ != "")
            связь.cd(имя_);

        return new ПапкиФтп(вТкст_, имя_, имяПользователя_, пароль_, порт_,
                                    дайФайлы(связь), да);
    }

    /***********************************************************************
     Returns a subtree of папки. Statistics are включительно of
     файлы внутри this папка и все другие внутри the дерево
     ***********************************************************************/

    final ПапкиВфс дерево()
    {
        СоединениеФтп связь;



        scope(exit)
        {
            if(связь !is пусто)
                связь.закрой();
        }

        ткст подключись = вТкст_;

        if(подключись[$ - 1] == '/')
        {
            подключись = подключись[0 .. ($ - 1)];
        }

        связь = new СоединениеФтп(подключись, имяПользователя_, пароль_, порт_);

        if(имя_ != "")
            связь.cd(имя_);

        return new ПапкиФтп(вТкст_, имя_, имяПользователя_, пароль_, порт_,
                                    дайЗаписи(связь), нет);
    }

    /***********************************************************************
     Iterate over the установи of immediate ветвь папки. This is
     useful for reflecting the иерархия
     ***********************************************************************/

    final цел opApply(цел delegate(ref ПапкаВфс) дг)
    {
        СоединениеФтп связь;



        scope(exit)
        {
            if(связь !is пусто)
                связь.закрой();
        }

        ткст подключись = вТкст_;

        if(подключись[$ - 1] == '/')
        {
            подключись = подключись[0 .. ($ - 1)];
        }

        связь = new СоединениеФтп(подключись, имяПользователя_, пароль_, порт_);

        if(имя_ != "")
            связь.cd(имя_);

        ИнфОФайлеФтп[] инфо = дайПапки(связь);

        цел результат;

        foreach(ИнфОФайлеФтп fi; инфо)
        {
            ПапкаВфс x = new ПапкаФтп(вТкст_, проверьПоследн(проверьКат(имя_, fi.имя)), имяПользователя_,
                    пароль_, порт_);
            if((результат = дг(x)) != 0)
                break;
        }

        return результат;
    }

    /***********************************************************************
     Clear все контент из_ this папка и subordinates
     ***********************************************************************/

    final ПапкаВфс очисть()
    {
        СоединениеФтп связь;

        scope(exit)
        {
            if(связь !is пусто)
                связь.закрой();
        }

        ткст подключись = вТкст_;

        if(подключись[$ - 1] == '/')
        {
            подключись = подключись[0 .. ($ - 1)];
        }

        связь = new СоединениеФтп(подключись, имяПользователя_, пароль_, порт_);

        if(имя_ != "")
            связь.cd(имя_);

        связь = new СоединениеФтп(подключись, имяПользователя_, пароль_, порт_);

        связь.cd(имя_);

        ИнфОФайлеФтп[] реверс(ИнфОФайлеФтп[] infos)
        {
            ИнфОФайлеФтп[] reversed;
            for(цел i = infos.length - 1; i >= 0; i--)
            {
                reversed ~= infos[i];
            }
            return reversed;
        }

        foreach(ПапкаВфс f; дерево.поднабор(пусто))
        связь.rm(f.имя);

        foreach(ИнфОФайлеФтп записи; дайЗаписи(связь))
        связь.del(записи.имя);

        //foreach(ПапкаВфс f; дерево.поднабор(пусто))
        //    связь.rm(f.имя);

        return this;
    }

    /***********************************************************************
     Is папка записываемый?
     ***********************************************************************/

    final бул записываемый()
    {
        try
        {
            СоединениеФтп связь;

            scope(failure)
            {
                if(связь !is пусто)
                    связь.закрой();
            }

            scope(exit)
            {
                if(связь !is пусто)
                    связь.закрой();
            }

            ткст подключись = вТкст_;

            if(подключись[$ - 1] == '/')
            {
                подключись = подключись[0 .. ($ - 1)];
            }

            связь = new СоединениеФтп(подключись, имяПользователя_, пароль_, порт_);

            if(имя_ != "")
                связь.cd(имя_);

            связь.mkdir("ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890");
            связь.rm("ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890");
            return да;

        }
        catch(Исключение e)
        {
            return нет;
        }
    }

    /***********************************************************************
     Close и/or synchronize changes made в_ this папка. Each
     driver should возьми advantage of this as appropriate, perhaps
     combining multИПle файлы together, or possibly copying в_ a
     remote location
     ***********************************************************************/

    ПапкаВфс закрой(бул подай = да)
    {
        return this;
    }

    /***********************************************************************
     A папка is being добавьed or removed из_ the иерархия. Use
     this в_ тест for validity (or whatever) и throw exceptions
     as necessary
     ***********************************************************************/

    проц проверь(ПапкаВфс папка, бул mounting)
    {
        return;
    }
}

/******************************************************************************
     A установи of папки внутри an FTP файл system as was selected by the
     Adapter or as was selected at initialization.
******************************************************************************/

class ПапкиФтп: ПапкиВфс
{

    ткст вТкст_, имя_, имяПользователя_, пароль_;
    бцел порт_;
    бул flat_;
    ИнфОФайлеФтп[] infos_;

    package this(ткст сервер, ткст путь, ткст ник = "",
                 ткст пароль = "", бцел порт = 21, ИнфОФайлеФтп[] infos = пусто,
                 бул flat = нет)
    in
    {
        assert(сервер.length > 0);
    }
    body
    {
        вТкст_ = проверьПерв(сервер);
        имя_ = проверьПоследн(путь);
        имяПользователя_ = ник;
        пароль_ = пароль;
        порт_ = порт;
        infos_ = infos;
        flat_ = flat;
    }

    public this(ткст сервер, ткст путь, ткст ник = "",
                ткст пароль = "", бцел порт = 21, бул flat = нет)
    in
    {
        assert(сервер.length > 0);
    }
    body
    {
        вТкст_ = проверьПерв(сервер);
        имя_ = проверьПоследн(путь);
        имяПользователя_ = ник;
        пароль_ = пароль;
        порт_ = порт;
        flat_ = flat;

        СоединениеФтп связь;



        scope(exit)
        {
            if(связь !is пусто)
                связь.закрой();
        }

        ткст подключись = вТкст_;

        if(подключись[$ - 1] == '/')
        {
            подключись = подключись[0 .. ($ - 1)];
        }

        связь = new СоединениеФтп(подключись, имяПользователя_, пароль_, порт_);

        if(имя_ != "")
            связь.cd(имя_);

        if(!flat_)
            infos_ = дайЗаписи(связь);
        else
            infos_ = дайФайлы(связь);
    }

    /***********************************************************************
     Iterate over the установи of contained ПапкаВфс экземпляры
     ***********************************************************************/

    final цел opApply(цел delegate(ref ПапкаВфс) дг)
    {
        СоединениеФтп связь;



        scope(exit)
        {
            if(связь !is пусто)
                связь.закрой();
        }

        ткст подключись = вТкст_;

        if(подключись[$ - 1] == '/')
        {
            подключись = подключись[0 .. ($ - 1)];
        }

        связь = new СоединениеФтп(подключись, имяПользователя_, пароль_, порт_);

        if(имя_ != "")
            связь.cd(имя_);

        ИнфОФайлеФтп[] инфо = дайПапки(связь);

        цел результат;

        foreach(ИнфОФайлеФтп fi; инфо)
        {
            ПапкаВфс x = new ПапкаФтп(вТкст_, проверьПоследн(проверьКат(имя_, fi.имя)),
                    имяПользователя_, пароль_, порт_);

            // was
            // ПапкаВфс x = new ПапкаФтп(вТкст_ ~ "/" ~ имя_, fi.имя,
            // имяПользователя_, пароль_, порт_);
            if((результат = дг(x)) != 0)
                break;
        }

        return результат;
    }

    /***********************************************************************
     Return the число of файлы
     ***********************************************************************/

    final бцел файлы()
    {
        СоединениеФтп связь;



        scope(exit)
        {
            if(связь !is пусто)
                связь.закрой();
        }

        ткст подключись = вТкст_;

        if(подключись[$ - 1] == '/')
        {
            подключись = подключись[0 .. ($ - 1)];
        }

        связь = new СоединениеФтп(подключись, имяПользователя_, пароль_, порт_);

        if(имя_ != "")
            связь.cd(имя_);

        return дайФайлы(связь).length;
    }

    /***********************************************************************
     Return the число of папк
     ***********************************************************************/

    final бцел папки()
    {
        СоединениеФтп связь;



        scope(exit)
        {
            if(связь !is пусто)
                связь.закрой();
        }

        ткст подключись = вТкст_;

        if(подключись[$ - 1] == '/')
        {
            подключись = подключись[0 .. ($ - 1)];
        }

        связь = new СоединениеФтп(подключись, имяПользователя_, пароль_, порт_);

        if(имя_ != "")
            связь.cd(имя_);

        return дайПапки(связь).length;
    }

    /***********************************************************************
     Return the total число of записи (файлы + папки)
     ***********************************************************************/

    final бцел записи()
    {
        СоединениеФтп связь;



        scope(exit)
        {
            if(связь !is пусто)
                связь.закрой();
        }

        ткст подключись = вТкст_;

        if(подключись[$ - 1] == '/')
        {
            подключись = подключись[0 .. ($ - 1)];
        }

        связь = new СоединениеФтп(подключись, имяПользователя_, пароль_, порт_);

        if(имя_ != "")
            связь.cd(имя_);

        return дайЗаписи(связь).length;
    }

    /***********************************************************************
     Return the total размер of contained файлы
     ***********************************************************************/

    final бдол байты()
    {
        СоединениеФтп связь;



        scope(exit)
        {
            if(связь !is пусто)
                связь.закрой();
        }

        ткст подключись = вТкст_;

        if(подключись[$ - 1] == '/')
        {
            подключись = подключись[0 .. ($ - 1)];
        }

        связь = new СоединениеФтп(подключись, имяПользователя_, пароль_, порт_);

        if(имя_ != "")
            связь.cd(имя_);

        бдол return_;

        foreach(ИнфОФайлеФтп inf; дайЗаписи(связь))
        {
            return_ += inf.размер;
        }

        return return_;
    }

    /***********************************************************************
     Return a поднабор of папки совпадают the given образец
     ***********************************************************************/

    final ПапкиВфс поднабор(ткст образец)
    {
        СоединениеФтп связь;



        scope(exit)
        {
            if(связь !is пусто)
                связь.закрой();
        }

        ткст подключись = вТкст_;

        if(подключись[$ - 1] == '/')
        {
            подключись = подключись[0 .. ($ - 1)];
        }

        связь = new СоединениеФтп(подключись, имяПользователя_, пароль_, порт_);

        if(имя_ != "")
            связь.cd(имя_);

        ИнфОФайлеФтп[] return__;

        if(образец !is пусто)
            foreach(ИнфОФайлеФтп inf; дайПапки(связь))
        {
            if(естьОбразец(inf.имя, образец))
                return__ ~= inf;
        }
        else
            return__ = дайПапки(связь);

        return new ПапкиФтп(вТкст_, имя_, имяПользователя_, пароль_, порт_,
                                    return__);
    }

    /***********************************************************************
     Return a установи of файлы совпадают the given образец
     ***********************************************************************/

    final ФайлыВфс каталог(ткст образец)
    {
        СоединениеФтп связь;



        scope(exit)
        {
            if(связь !is пусто)
                связь.закрой();
        }

        ткст подключись = вТкст_;

        if(подключись[$ - 1] == '/')
        {
            подключись = подключись[0 .. ($ - 1)];
        }

        связь = new СоединениеФтп(подключись, имяПользователя_, пароль_, порт_);

        if(имя_ != "")
            связь.cd(имя_);

        ИнфОФайлеФтп[] return__;

        if(образец !is пусто)
        {
            foreach(ИнфОФайлеФтп inf; дайФайлы(связь))
            {
                if(естьОбразец(inf.имя, образец))
                {
                    return__ ~= inf;
                }
            }
        }
        else
        {
            return__ = дайФайлы(связь);
        }

        return new ФайлыФтп(вТкст_, имя_, имяПользователя_, пароль_, порт_,
                                    return__);
    }

    /***********************************************************************
     Return a установи of файлы совпадают the given фильтр
     ***********************************************************************/

    final ФайлыВфс каталог(ФильтрВфс фильтр = пусто)
    {
        СоединениеФтп связь;



        scope(exit)
        {
            if(связь !is пусто)
                связь.закрой();
        }

        ткст подключись = вТкст_;

        if(подключись[$ - 1] == '/')
        {
            подключись = подключись[0 .. ($ - 1)];
        }

        связь = new СоединениеФтп(подключись, имяПользователя_, пароль_, порт_);

        if(имя_ != "")
            связь.cd(имя_);

        ИнфОФайлеФтп[] return__;

        if(фильтр !is пусто)
            foreach(ИнфОФайлеФтп inf; дайФайлы(связь))
        {
            ИнфОФильтреВфс vinf;
            vinf.байты = inf.размер;
            vinf.имя = inf.имя;
            vinf.папка = нет;
            vinf.путь = проверьКат(проверьПерв(вТкст_), проверьКат(имя_,inf.имя));
            if(фильтр(&vinf))
                return__ ~= inf;
        }
        else
            return__ = дайФайлы(связь);

        return new ФайлыФтп(вТкст_, имя_, имяПользователя_, пароль_, порт_,
                                    return__);
    }
}

/*******************************************************************************
     Represents a файл over a FTP файл system.
*******************************************************************************/

class ФайлФтп: ФайлВфс
{

    ткст вТкст_, имя_, имяПользователя_, пароль_;
    бцел порт_;
    бул conOpen;
    СоединениеФтп связь;

    public this(ткст сервер, ткст путь, ткст ник = "",
                ткст пароль = "", бцел порт = 21)
    in
    {
        assert(сервер.length > 0);
    }
    body
    {
        вТкст_ = проверьПерв(сервер);
        имя_ = проверьПоследн(путь);
        имяПользователя_ = ник;
        пароль_ = пароль;
        порт_ = порт;
    }

    /***********************************************************************
     Return a крат имя
     ***********************************************************************/

    final ткст имя()
    {
        return фиксируйИмя(имя_);
    }

    /***********************************************************************
     Return a дол имя
     ***********************************************************************/

    final ткст вТкст()
    {
        return проверьКат(вТкст_, имя_);
    }

    /***********************************************************************
     Does this файл exist?
     ***********************************************************************/

    final бул есть_ли()
    {
        scope(failure)
        {
            if(!conOpen)
                if(связь !is пусто)
                    связь.закрой();
        }

        scope(exit)
        {
            if(!conOpen)
                if(связь !is пусто)
                    связь.закрой();
        }

        бул return_;

        ткст подключись = вТкст_;

        if(подключись[$ - 1] == '/')
        {
            подключись = подключись[0 .. ($ - 1)];
        }

        if(!conOpen)
        {
            связь = new СоединениеФтп(подключись, имяПользователя_, пароль_, порт_);
        }

        if(связь.exist(имя_) == 1)
        {
            return_ = да;
        }
        else
        {
            return_ = нет;
        }

        return return_;
    }

    /***********************************************************************
     Return the файл размер
     ***********************************************************************/

    final бдол размер()
    {
        scope(failure)
        {
            if(!conOpen)
                if(связь !is пусто)
                    связь.закрой();
        }

        scope(exit)
        {
            if(!conOpen)
                if(связь !is пусто)
                    связь.закрой();
        }

        ткст подключись = вТкст_;

        if(подключись[$ - 1] == '/')
        {
            подключись = подключись[0 .. ($ - 1)];
        }

        if(!conOpen)
        {
            связь = new СоединениеФтп(подключись, имяПользователя_, пароль_, порт_);
        }

        return связь.размер(имя_);
    }

    /***********************************************************************
     Созд и копируй the given источник
     ***********************************************************************/

    final ФайлВфс копируй(ФайлВфс источник)
    {
        вывод.копируй(источник.ввод);
        return this;
    }

    /***********************************************************************
     Созд и копируй the given источник, и удали the источник
     ***********************************************************************/

    final ФайлВфс перемести(ФайлВфс источник)
    {
        копируй(источник);
        источник.удали;
        return this;
    }

    /***********************************************************************
     Созд a new файл экземпляр
     ***********************************************************************/

    final ФайлВфс создай()
    {
        сим[1] a = "0";
        вывод.пиши(a);
        return this;
    }

    /***********************************************************************
     Созд a new файл экземпляр и наполни with поток
     ***********************************************************************/

    final ФайлВфс создай(ИПотокВвода поток)
    {
        вывод.копируй(поток);
        return this;
    }

    /***********************************************************************
     Удали this файл
     ***********************************************************************/

    final ФайлВфс удали()
    {

        связь.закрой();

        conOpen = нет;

        scope(failure)
        {
            if(!conOpen)
                if(связь !is пусто)
                    связь.закрой();
        }

        scope(exit)
        {
            if(!conOpen)
                if(связь !is пусто)
                    связь.закрой();
        }

        ткст подключись = вТкст_;

        if(подключись[$ - 1] == '/')
        {
            подключись = подключись[0 .. ($ - 1)];
        }

        if(!conOpen)
        {
            связь = new СоединениеФтп(подключись, имяПользователя_, пароль_, порт_);
        }

        связь.del(имя_);

        return this;
    }

    /***********************************************************************
     Return the ввод поток. Don't forget в_ закрой it
     ***********************************************************************/

    final ИПотокВвода ввод()
    {

        scope(failure)
        {
            if(!conOpen)
                if(связь !is пусто)
                    связь.закрой();
        }

        ткст подключись = вТкст_;

        if(подключись[$ - 1] == '/')
        {
            подключись = подключись[0 .. ($ - 1)];
        }

        if(!conOpen)
        {
            связь = new СоединениеФтп(подключись, имяПользователя_, пароль_, порт_);
        }

        conOpen = да;

        return связь.ввод(имя_);
    }

    /***********************************************************************
     Return the вывод поток. Don't forget в_ закрой it
     ***********************************************************************/

    final ИПотокВывода вывод()
    {

        scope(failure)
        {
            if(!conOpen)
                if(связь !is пусто)
                    связь.закрой();
        }

        ткст подключись = вТкст_;

        if(подключись[$ - 1] == '/')
        {
            подключись = подключись[0 .. ($ - 1)];
        }

        if(!conOpen)
        {
            связь = new СоединениеФтп(подключись, имяПользователя_, пароль_, порт_);
        }

        conOpen = да;

        return связь.вывод(имя_);
    }

    /***********************************************************************
     Duplicate this Запись
     ***********************************************************************/

    final ФайлВфс dup()
    {
        return new ФайлФтп(вТкст_, имя_, имяПользователя_, пароль_, порт_);
    }

    /***********************************************************************
     Время изменён
     ***********************************************************************/

    final Время измвремя()
    {
        связь.закрой();

        conOpen = нет;

        scope(failure)
        {
            if(!conOpen)
                if(связь !is пусто)
                    связь.закрой();
        }

        scope(exit)
        {
            if(!conOpen)
                if(связь !is пусто)
                    связь.закрой();
        }

        ткст подключись = вТкст_;

        if(подключись[$ - 1] == '/')
        {
            подключись = подключись[0 .. ($ - 1)];
        }

        if(!conOpen)
        {
            связь = new СоединениеФтп(подключись, имяПользователя_, пароль_, порт_);
        }

        return связь.дайИнфОФайле(имя_).изменён;
    }

    /***********************************************************************
     Время создан
     ***********************************************************************/

    final Время создвремя()
    {
        связь.закрой();

        conOpen = нет;

        scope(failure)
        {
            if(!conOpen)
                if(связь !is пусто)
                    связь.закрой();
        }

        scope(exit)
        {
            if(!conOpen)
                if(связь !is пусто)
                    связь.закрой();
        }

        ткст подключись = вТкст_;

        if(подключись[$ - 1] == '/')
        {
            подключись = подключись[0 .. ($ - 1)];
        }

        if(!conOpen)
        {
            связь = new СоединениеФтп(подключись, имяПользователя_, пароль_, порт_);
        }

        return связь.дайИнфОФайле(имя_).создан;
    }

    final Время доствремя()
    {
        связь.закрой();

        conOpen = нет;

        scope(failure)
        {
            if(!conOpen)
                if(связь !is пусто)
                    связь.закрой();
        }

        scope(exit)
        {
            if(!conOpen)
                if(связь !is пусто)
                    связь.закрой();
        }

        ткст подключись = вТкст_;

        if(подключись[$ - 1] == '/')
        {
            подключись = подключись[0 .. ($ - 1)];
        }

        if(!conOpen)
        {
            связь = new СоединениеФтп(подключись, имяПользователя_, пароль_, порт_);
        }

        return связь.дайИнфОФайле(имя_).изменён;
    }

    /***********************************************************************

            Modified время of the файл

    ***********************************************************************/

    final Время изменён ()
    {
        return измвремя ();
    }
}

/******************************************************************************
  Represents a выделение of Files.
******************************************************************************/

class ФайлыФтп: ФайлыВфс
{

    ткст вТкст_, имя_, имяПользователя_, пароль_;
    бцел порт_;
    ИнфОФайлеФтп[] infos_;

    public this(ткст сервер, ткст путь, ткст ник = "",
                ткст пароль = "", бцел порт = 21, ИнфОФайлеФтп[] infos = пусто)
    in
    {
        assert(сервер.length > 0);
    }
    body
    {
        вТкст_ = проверьПерв(сервер);
        имя_ = проверьПоследн(путь);
        имяПользователя_ = ник;
        пароль_ = пароль;
        порт_ = порт;
        if(infos !is пусто)
            infos_ = infos;
        else
            заполниИнфы();
    }

    final проц заполниИнфы()
    {

        СоединениеФтп связь;



        scope(exit)
        {
            if(связь !is пусто)
                связь.закрой();
        }

        ткст подключись = вТкст_;

        if(подключись[$ - 1] == '/')
        {
            подключись = подключись[0 .. ($ - 1)];
        }

        связь = new СоединениеФтп(подключись, имяПользователя_, пароль_, порт_);

        if(имя_ != "")
            связь.cd(имя_);

        infos_ = дайФайлы(связь);
    }

    /***********************************************************************
     Iterate over the установи of contained ФайлВфс экземпляры
     ***********************************************************************/

    final цел opApply(цел delegate(ref ФайлВфс) дг)
    {
        цел результат = 0;

        foreach(ИнфОФайлеФтп inf; infos_)
        {
            ФайлВфс x = new ФайлФтп(вТкст_, проверьПоследн(проверьКат(имя_, inf.имя)),
                                                  имяПользователя_, пароль_, порт_);
            if((результат = дг(x)) != 0)
                break;
        }

        return результат;
    }

    /***********************************************************************
     Return the total число of записи
     ***********************************************************************/

    final бцел файлы()
    {
        return infos_.length;
    }

    /***********************************************************************
     Return the total размер of все файлы
     ***********************************************************************/

    final бдол байты()
    {
        бдол return_;

        foreach(ИнфОФайлеФтп inf; infos_)
        {
            return_ += inf.размер;
        }

        return return_;
    }
}

