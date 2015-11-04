/*******************************************************************************
     copyright:      Copyright (c) 2007-2008 Dinrus. все rights reserved

     license:        BSD стиль: $(LICENSE)

     version:        August 2008: Initial version

     author:         Lester L. Martin II
*******************************************************************************/

module io.vfs.FtpFolder;

private {
    import net.ftp.FtpClient;
    import io.vfs.model;
    import io.vfs.FileFolder;
    import io.device.Conduit;
    import text.Util;
    import time.Time;
}

private ткст фиксируйИмя(ткст toFix) {
    if (containsPattern(toFix, "/"))
        toFix = toFix[(locatePrior(toFix, '/') + 1) .. length];
    return toFix;
}

private ткст checkFirst(ткст toFix) {
    for(; toFix.length>0 && toFix[$-1] == '/';)
        toFix = toFix[0 .. ($-1)];
    return toFix;
}

private ткст checkLast(ткст toFix) {
for(;toFix.length>1 &&  toFix[0] == '/' && toFix[1] == '/' ;)
        toFix = toFix[1 .. $];
    if(toFix.length && toFix[0] != '/')
        toFix = '/' ~ toFix;
    return toFix;
}

private ткст checkCat(ткст first, ткст последний) {
    return checkFirst(first) ~ checkLast(последний);
}

private ИнфОФайлеФтп[] дайЗаписи(СоединениеФтп ftp, ткст путь = "") {
    ИнфОФайлеФтп[] orig = ftp.ls(путь);
    ИнфОФайлеФтп[] temp2;
    ИнфОФайлеФтп[] use;
    ИнфОФайлеФтп[] temp;
    foreach(ИнфОФайлеФтп inf; orig) {
        if(inf.тип == ПТипФайлаФтп.пап) {
            temp ~= inf;
        }
    }
    foreach(ИнфОФайлеФтп inf; temp) {
        temp2 ~= дайЗаписи((ftp.cd(inf.имя) , ftp));
        //wasn't here at the beginning
        foreach(inf2; temp2) {
            inf2.имя = checkCat(inf.имя, inf2.имя);
            use ~= inf2;
        }
        orig ~= use;
        //конец wasn't here at the beginning
        ftp.cdup();
    }
    return orig;
}

private ИнфОФайлеФтп[] дайФайлы(СоединениеФтп ftp, ткст путь = "") {
    ИнфОФайлеФтп[] infos = дайЗаписи(ftp, путь);
    ИнфОФайлеФтп[] return_;
    foreach(ИнфОФайлеФтп инфо; infos) {
        if(инфо.тип == ПТипФайлаФтп.файл || инфо.тип == ПТипФайлаФтп.другой || инфо.тип == ПТипФайлаФтп.неизвестное)
            return_ ~= инфо;
    }
    return return_;
}

private ИнфОФайлеФтп[] дайПапки(СоединениеФтп ftp, ткст путь = "") {
    ИнфОФайлеФтп[] infos = дайЗаписи(ftp, путь);
    ИнфОФайлеФтп[] return_;
    foreach(ИнфОФайлеФтп инфо; infos) {
        if(инфо.тип == ПТипФайлаФтп.пап || инфо.тип == ПТипФайлаФтп.тдир || инфо.тип == ПТипФайлаФтп.пдир)
            return_ ~= инфо;
    }
    return return_;
}

/******************************************************************************
    Defines a папка over FTP that есть yet в_ be opened, may not exist, and
      may be создан.
******************************************************************************/

class ЗаписьПапкиФтп: ЗаписьПапкиВфс {

    ткст toString_, name_, username_, password_;
    бцел port_;

    public this(ткст сервер, ткст путь, ткст ник = "",
                ткст пароль = "", бцел порт = 21)
    in {
        assert(сервер.length > 0);
    }
    body {
        toString_ = checkFirst(сервер);
        name_ = checkLast(путь);
        username_ = ник;
        password_ = пароль;
        port_ = порт;
    }

    /***********************************************************************
     Open a папка
     ***********************************************************************/

    final ПапкаВфс открой() {
        return new ПапкаФтп(toString_, name_, username_, password_, port_);
    }

    /***********************************************************************
     Create a new папка
     ***********************************************************************/

    final ПапкаВфс создай() {
        СоединениеФтп conn;

        scope(failure) {
            if(conn !is пусто)
                conn.закрой();
        }

        scope(exit) {
            if(conn !is пусто)
                conn.закрой();
        }

        conn = new СоединениеФтп(toString_, username_, password_, port_);
        conn.mkdir(name_);

        return new ПапкаФтп(toString_, name_, username_, password_, port_);
    }

    /***********************************************************************
     Test в_ see if a папка есть_ли
     ***********************************************************************/

    final бул есть_ли() {
        СоединениеФтп conn;

    

        scope(exit) {
            if(conn !is пусто)
                conn.закрой();
        }

        бул return_;
        if(name_ == "") {
            try {
                conn = new СоединениеФтп(toString_, username_, password_, port_);
                return_ = да;
            } catch(Исключение e) {
                return нет;
            }
        } else {
            try {
                conn = new СоединениеФтп(toString_, username_, password_, port_);
                try {
                    conn.cd(name_);
                    return_ = да;
                } catch(Исключение e) {
                    if(conn.exist(name_) == 2)
                        return_ = да;
                    else
                        return_ = нет;
                }
            } catch(Исключение e) {
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

class ПапкаФтп: ПапкаВфс {

    ткст toString_, name_, username_, password_;
    бцел port_;

    public this(ткст сервер, ткст путь, ткст ник = "",
                ткст пароль = "", бцел порт = 21)
    in {
        assert(сервер.length > 0);
    }
    body {
        toString_ = checkFirst(сервер);
        name_ = checkLast(путь);
        username_ = ник;
        password_ = пароль;
        port_ = порт;
    }

    /***********************************************************************
     Return a крат имя
     ***********************************************************************/

    final ткст имя() {
        return фиксируйИмя(name_);
    }

    /***********************************************************************
     Return a дол имя
     ***********************************************************************/

    final ткст вТкст() {
        return checkCat(toString_, name_);
    }

    /***********************************************************************
     Return a contained файл representation
     ***********************************************************************/

    final ФайлВфс файл(ткст путь) {
        return new ФайлФтп(toString_, checkLast(checkCat(name_, путь)), username_, password_,
            port_);
    }

    /***********************************************************************
     Return a contained папка representation
     ***********************************************************************/

    final ЗаписьПапкиВфс папка(ткст путь) {
        return new ЗаписьПапкиФтп(toString_, checkLast(checkCat(name_, путь)), username_,
            password_, port_);
    }

    /***********************************************************************
     Returns a папка установи containing only this one. Statistics
     are включительно of записи within this папка only
     ***********************************************************************/

    final ПапкиВфс сам() {
        СоединениеФтп conn;

    

        scope(exit) {
            if(conn !is пусто)
                conn.закрой();
        }

        ткст подключись = toString_;

        if(подключись[$ - 1] == '/') {
            подключись = подключись[0 .. ($ - 1)];
        }

        conn = new СоединениеФтп(подключись, username_, password_, port_);

        if(name_ != "")
            conn.cd(name_);

        return new ПапкиФтп(toString_, name_, username_, password_, port_,
            дайФайлы(conn), да);
    }

    /***********************************************************************
     Returns a subtree of папки. Statistics are включительно of
     файлы within this папка and все другие within the дерево
     ***********************************************************************/

    final ПапкиВфс дерево() {
        СоединениеФтп conn;

    

        scope(exit) {
            if(conn !is пусто)
                conn.закрой();
        }

        ткст подключись = toString_;

        if(подключись[$ - 1] == '/') {
            подключись = подключись[0 .. ($ - 1)];
        }

        conn = new СоединениеФтп(подключись, username_, password_, port_);

        if(name_ != "")
            conn.cd(name_);

        return new ПапкиФтп(toString_, name_, username_, password_, port_,
            дайЗаписи(conn), нет);
    }

    /***********************************************************************
     Iterate over the установи of immediate ветвь папки. This is
     useful for reflecting the иерархия
     ***********************************************************************/

    final цел opApply(цел delegate(ref ПапкаВфс) дг) {
        СоединениеФтп conn;

    

        scope(exit) {
            if(conn !is пусто)
                conn.закрой();
        }

        ткст подключись = toString_;

        if(подключись[$ - 1] == '/') {
            подключись = подключись[0 .. ($ - 1)];
        }

        conn = new СоединениеФтп(подключись, username_, password_, port_);

        if(name_ != "")
            conn.cd(name_);

        ИнфОФайлеФтп[] инфо = дайПапки(conn);

        цел результат;

        foreach(ИнфОФайлеФтп fi; инфо) {
            ПапкаВфс x = new ПапкаФтп(toString_, checkLast(checkCat(name_, fi.имя)), username_,
                password_, port_);
            if((результат = дг(x)) != 0)
                break;
        }

        return результат;
    }

    /***********************************************************************
     Clear все контент из_ this папка and subordinates
     ***********************************************************************/

    final ПапкаВфс сотри() {
        СоединениеФтп conn;

        scope(exit) {
            if(conn !is пусто)
                conn.закрой();
        }

        ткст подключись = toString_;

        if(подключись[$ - 1] == '/') {
            подключись = подключись[0 .. ($ - 1)];
        }

        conn = new СоединениеФтп(подключись, username_, password_, port_);

        if(name_ != "")
            conn.cd(name_);

        conn = new СоединениеФтп(подключись, username_, password_, port_);

        conn.cd(name_);

        ИнфОФайлеФтп[] реверс(ИнфОФайлеФтп[] infos) {
            ИнфОФайлеФтп[] reversed;
            for(цел i = infos.length - 1; i >= 0; i--) {
                reversed ~= infos[i];
            }
            return reversed;
        }

        foreach(ПапкаВфс f; дерево.поднабор(пусто))
        conn.rm(f.имя);

        foreach(ИнфОФайлеФтп записи; дайЗаписи(conn))
        conn.del(записи.имя);

        //foreach(ПапкаВфс f; дерево.поднабор(пусто))
        //    conn.rm(f.имя);

        return this;
    }

    /***********************************************************************
     Is папка записываемый?
     ***********************************************************************/

    final бул записываемый() {
        try {
            СоединениеФтп conn;

            scope(failure) {
                if(conn !is пусто)
                    conn.закрой();
            }

            scope(exit) {
                if(conn !is пусто)
                    conn.закрой();
            }

            ткст подключись = toString_;

            if(подключись[$ - 1] == '/') {
                подключись = подключись[0 .. ($ - 1)];
            }

            conn = new СоединениеФтп(подключись, username_, password_, port_);

            if(name_ != "")
                conn.cd(name_);

            conn.mkdir("ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890");
            conn.rm("ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890");
            return да;

        } catch(Исключение e) {
            return нет;
        }
    }

    /***********************************************************************
     Close and/or synchronize changes made в_ this папка. Each
     driver should take advantage of this as appropriate, perhaps
     combining multИПle файлы together, or possibly copying в_ a
     remote location
     ***********************************************************************/

    ПапкаВфс закрой(бул подай = да) {
        return this;
    }

    /***********************************************************************
     A папка is being добавьed or removed из_ the иерархия. Use
     this в_ тест for validity (or whatever) and throw exceptions
     as necessary
     ***********************************************************************/

    проц проверь(ПапкаВфс папка, бул mounting) {
        return;
    }
}

/******************************************************************************
     A установи of папки within an FTP файл system as was selected by the
     Adapter or as was selected at initialization.
******************************************************************************/

class ПапкиФтп: ПапкиВфс {

    ткст toString_, name_, username_, password_;
    бцел port_;
    бул flat_;
    ИнфОФайлеФтп[] infos_;

    package this(ткст сервер, ткст путь, ткст ник = "",
                 ткст пароль = "", бцел порт = 21, ИнфОФайлеФтп[] infos = пусто,
                 бул flat = нет)
    in {
        assert(сервер.length > 0);
    }
    body {
        toString_ = checkFirst(сервер);
        name_ = checkLast(путь);
        username_ = ник;
        password_ = пароль;
        port_ = порт;
        infos_ = infos;
        flat_ = flat;
    }

    public this(ткст сервер, ткст путь, ткст ник = "",
                ткст пароль = "", бцел порт = 21, бул flat = нет)
    in {
        assert(сервер.length > 0);
    }
    body {
        toString_ = checkFirst(сервер);
        name_ = checkLast(путь);
        username_ = ник;
        password_ = пароль;
        port_ = порт;
        flat_ = flat;

        СоединениеФтп conn;

    

        scope(exit) {
            if(conn !is пусто)
                conn.закрой();
        }

        ткст подключись = toString_;

        if(подключись[$ - 1] == '/') {
            подключись = подключись[0 .. ($ - 1)];
        }

        conn = new СоединениеФтп(подключись, username_, password_, port_);

        if(name_ != "")
            conn.cd(name_);

        if(!flat_)
            infos_ = дайЗаписи(conn);
        else
            infos_ = дайФайлы(conn);
    }

    /***********************************************************************
     Iterate over the установи of contained ПапкаВфс instances
     ***********************************************************************/

    final цел opApply(цел delegate(ref ПапкаВфс) дг) {
        СоединениеФтп conn;

    

        scope(exit) {
            if(conn !is пусто)
                conn.закрой();
        }

        ткст подключись = toString_;

        if(подключись[$ - 1] == '/') {
            подключись = подключись[0 .. ($ - 1)];
        }

        conn = new СоединениеФтп(подключись, username_, password_, port_);

        if(name_ != "")
            conn.cd(name_);

        ИнфОФайлеФтп[] инфо = дайПапки(conn);

        цел результат;

        foreach(ИнфОФайлеФтп fi; инфо) {
            ПапкаВфс x = new ПапкаФтп(toString_, checkLast(checkCat(name_, fi.имя)),
                username_, password_, port_);
    
            // was
            // ПапкаВфс x = new ПапкаФтп(toString_ ~ "/" ~ name_, fi.имя,
            // username_, password_, port_);
            if((результат = дг(x)) != 0)
                break;
        }

        return результат;
    }

    /***********************************************************************
     Return the число of файлы
     ***********************************************************************/

    final бцел файлы() {
        СоединениеФтп conn;

    

        scope(exit) {
            if(conn !is пусто)
                conn.закрой();
        }

        ткст подключись = toString_;

        if(подключись[$ - 1] == '/') {
            подключись = подключись[0 .. ($ - 1)];
        }

        conn = new СоединениеФтп(подключись, username_, password_, port_);

        if(name_ != "")
            conn.cd(name_);

        return дайФайлы(conn).length;
    }

    /***********************************************************************
     Return the число of папки
     ***********************************************************************/

    final бцел папки() {
        СоединениеФтп conn;

    

        scope(exit) {
            if(conn !is пусто)
                conn.закрой();
        }

        ткст подключись = toString_;

        if(подключись[$ - 1] == '/') {
            подключись = подключись[0 .. ($ - 1)];
        }

        conn = new СоединениеФтп(подключись, username_, password_, port_);

        if(name_ != "")
            conn.cd(name_);

        return дайПапки(conn).length;
    }

    /***********************************************************************
     Return the total число of записи (файлы + папки)
     ***********************************************************************/

    final бцел записи() {
        СоединениеФтп conn;

    

        scope(exit) {
            if(conn !is пусто)
                conn.закрой();
        }

        ткст подключись = toString_;

        if(подключись[$ - 1] == '/') {
            подключись = подключись[0 .. ($ - 1)];
        }

        conn = new СоединениеФтп(подключись, username_, password_, port_);

        if(name_ != "")
            conn.cd(name_);

        return дайЗаписи(conn).length;
    }

    /***********************************************************************
     Return the total размер of contained файлы
     ***********************************************************************/

    final бдол байты() {
        СоединениеФтп conn;

    

        scope(exit) {
            if(conn !is пусто)
                conn.закрой();
        }

        ткст подключись = toString_;

        if(подключись[$ - 1] == '/') {
            подключись = подключись[0 .. ($ - 1)];
        }

        conn = new СоединениеФтп(подключись, username_, password_, port_);

        if(name_ != "")
            conn.cd(name_);

        бдол return_;

        foreach(ИнфОФайлеФтп inf; дайЗаписи(conn)) {
            return_ += inf.размер;
        }

        return return_;
    }

    /***********************************************************************
     Return a поднабор of папки matching the given образец
     ***********************************************************************/

    final ПапкиВфс поднабор(ткст образец) {
        СоединениеФтп conn;

    

        scope(exit) {
            if(conn !is пусто)
                conn.закрой();
        }

        ткст подключись = toString_;

        if(подключись[$ - 1] == '/') {
            подключись = подключись[0 .. ($ - 1)];
        }

        conn = new СоединениеФтп(подключись, username_, password_, port_);

        if(name_ != "")
            conn.cd(name_);

        ИнфОФайлеФтп[] return__;

        if(образец !is пусто)
            foreach(ИнфОФайлеФтп inf; дайПапки(conn)) {
            if(containsPattern(inf.имя, образец))
                return__ ~= inf;
        }
        else
            return__ = дайПапки(conn);

        return new ПапкиФтп(toString_, name_, username_, password_, port_,
            return__);
    }

    /***********************************************************************
     Return a установи of файлы matching the given образец
     ***********************************************************************/

    final ФайлыВфс каталог(ткст образец) {
        СоединениеФтп conn;

    

        scope(exit) {
            if(conn !is пусто)
                conn.закрой();
        }

        ткст подключись = toString_;

        if(подключись[$ - 1] == '/') {
            подключись = подключись[0 .. ($ - 1)];
        }

        conn = new СоединениеФтп(подключись, username_, password_, port_);

        if(name_ != "")
            conn.cd(name_);

        ИнфОФайлеФтп[] return__;

        if(образец !is пусто) {
            foreach(ИнфОФайлеФтп inf; дайФайлы(conn)) {
                if(containsPattern(inf.имя, образец)) {
                    return__ ~= inf;
                }
            }
        } else {
            return__ = дайФайлы(conn);
        }

        return new ФайлыФтп(toString_, name_, username_, password_, port_,
            return__);
    }

    /***********************************************************************
     Return a установи of файлы matching the given фильтр
     ***********************************************************************/

    final ФайлыВфс каталог(ФильтрВфс фильтр = пусто) {
        СоединениеФтп conn;

    

        scope(exit) {
            if(conn !is пусто)
                conn.закрой();
        }

        ткст подключись = toString_;

        if(подключись[$ - 1] == '/') {
            подключись = подключись[0 .. ($ - 1)];
        }

        conn = new СоединениеФтп(подключись, username_, password_, port_);

        if(name_ != "")
            conn.cd(name_);

        ИнфОФайлеФтп[] return__;

        if(фильтр !is пусто)
            foreach(ИнфОФайлеФтп inf; дайФайлы(conn)) {
            ИнфОФильтреВфс vinf;
            vinf.байты = inf.размер;
            vinf.имя = inf.имя;
            vinf.папка = нет;
            vinf.путь = checkCat(checkFirst(toString_), checkCat(name_ ,inf.имя));
            if(фильтр(&vinf))
                return__ ~= inf;
        }
        else
            return__ = дайФайлы(conn);

        return new ФайлыФтп(toString_, name_, username_, password_, port_,
            return__);
    }
}

/*******************************************************************************
     Represents a файл over a FTP файл system.
*******************************************************************************/

class ФайлФтп: ФайлВфс {

    ткст toString_, name_, username_, password_;
    бцел port_;
    бул conOpen;
    СоединениеФтп conn;

    public this(ткст сервер, ткст путь, ткст ник = "",
                ткст пароль = "", бцел порт = 21)
    in {
        assert(сервер.length > 0);
    }
    body {
        toString_ = checkFirst(сервер);
        name_ = checkLast(путь);
        username_ = ник;
        password_ = пароль;
        port_ = порт;
    }

    /***********************************************************************
     Return a крат имя
     ***********************************************************************/

    final ткст имя() {
        return фиксируйИмя(name_);
    }

    /***********************************************************************
     Return a дол имя
     ***********************************************************************/

    final ткст вТкст() {
        return checkCat(toString_, name_);
    }

    /***********************************************************************
     Does this файл exist?
     ***********************************************************************/

    final бул есть_ли() {
        scope(failure) {
            if(!conOpen)
                if(conn !is пусто)
                    conn.закрой();
        }

        scope(exit) {
            if(!conOpen)
                if(conn !is пусто)
                    conn.закрой();
        }

        бул return_;

        ткст подключись = toString_;

        if(подключись[$ - 1] == '/') {
            подключись = подключись[0 .. ($ - 1)];
        }

        if(!conOpen) {
            conn = new СоединениеФтп(подключись, username_, password_, port_);
        }

        if(conn.exist(name_) == 1) {
            return_ = да;
        } else {
            return_ = нет;
        }

        return return_;
    }

    /***********************************************************************
     Return the файл размер
     ***********************************************************************/

    final бдол размер() {
        scope(failure) {
            if(!conOpen)
                if(conn !is пусто)
                    conn.закрой();
        }

        scope(exit) {
            if(!conOpen)
                if(conn !is пусто)
                    conn.закрой();
        }

        ткст подключись = toString_;

        if(подключись[$ - 1] == '/') {
            подключись = подключись[0 .. ($ - 1)];
        }

        if(!conOpen) {
            conn = new СоединениеФтп(подключись, username_, password_, port_);
        }

        return conn.размер(name_);
    }

    /***********************************************************************
     Create and копируй the given источник
     ***********************************************************************/

    final ФайлВфс копируй(ФайлВфс источник) {
        вывод.копируй(источник.ввод);
        return this;
    }

    /***********************************************************************
     Create and копируй the given источник, and удали the источник
     ***********************************************************************/

    final ФайлВфс перемести(ФайлВфс источник) {
        копируй(источник);
        источник.удали;
        return this;
    }

    /***********************************************************************
     Create a new файл экземпляр
     ***********************************************************************/

    final ФайлВфс создай() {
        сим[1] a = "0";
        вывод.пиши(a);
        return this;
    }

    /***********************************************************************
     Create a new файл экземпляр and наполни with поток
     ***********************************************************************/

    final ФайлВфс создай(ИПотокВвода поток) {
        вывод.копируй(поток);
        return this;
    }

    /***********************************************************************
     Удали this файл
     ***********************************************************************/

    final ФайлВфс удали() {

        conn.закрой();

        conOpen = нет;

        scope(failure) {
            if(!conOpen)
                if(conn !is пусто)
                    conn.закрой();
        }

        scope(exit) {
            if(!conOpen)
                if(conn !is пусто)
                    conn.закрой();
        }

        ткст подключись = toString_;

        if(подключись[$ - 1] == '/') {
            подключись = подключись[0 .. ($ - 1)];
        }

        if(!conOpen) {
            conn = new СоединениеФтп(подключись, username_, password_, port_);
        }

        conn.del(name_);

        return this;
    }

    /***********************************************************************
     Return the ввод поток. Don't forget в_ закрой it
     ***********************************************************************/

    final ИПотокВвода ввод() {

        scope(failure) {
            if(!conOpen)
                if(conn !is пусто)
                    conn.закрой();
        }

        ткст подключись = toString_;

        if(подключись[$ - 1] == '/') {
            подключись = подключись[0 .. ($ - 1)];
        }

        if(!conOpen) {
            conn = new СоединениеФтп(подключись, username_, password_, port_);
        }

        conOpen = да;

        return conn.ввод(name_);
    }

    /***********************************************************************
     Return the вывод поток. Don't forget в_ закрой it
     ***********************************************************************/

    final ИПотокВывода вывод() {

        scope(failure) {
            if(!conOpen)
                if(conn !is пусто)
                    conn.закрой();
        }

        ткст подключись = toString_;

        if(подключись[$ - 1] == '/') {
            подключись = подключись[0 .. ($ - 1)];
        }

        if(!conOpen) {
            conn = new СоединениеФтп(подключись, username_, password_, port_);
        }

        conOpen = да;

        return conn.вывод(name_);
    }

    /***********************************************************************
     Duplicate this Запись
     ***********************************************************************/

    final ФайлВфс dup() {
        return new ФайлФтп(toString_, name_, username_, password_, port_);
    }

    /***********************************************************************
     Время изменён
     ***********************************************************************/

    final Время измвремя() {
        conn.закрой();

        conOpen = нет;

        scope(failure) {
            if(!conOpen)
                if(conn !is пусто)
                    conn.закрой();
        }

        scope(exit) {
            if(!conOpen)
                if(conn !is пусто)
                    conn.закрой();
        }

        ткст подключись = toString_;

        if(подключись[$ - 1] == '/') {
            подключись = подключись[0 .. ($ - 1)];
        }

        if(!conOpen) {
            conn = new СоединениеФтп(подключись, username_, password_, port_);
        }

        return conn.дайИнфОФайле(name_).modify;
    }

    /***********************************************************************
     Время создан
     ***********************************************************************/

    final Время создвремя() {
        conn.закрой();

        conOpen = нет;

        scope(failure) {
            if(!conOpen)
                if(conn !is пусто)
                    conn.закрой();
        }

        scope(exit) {
            if(!conOpen)
                if(conn !is пусто)
                    conn.закрой();
        }

        ткст подключись = toString_;

        if(подключись[$ - 1] == '/') {
            подключись = подключись[0 .. ($ - 1)];
        }

        if(!conOpen) {
            conn = new СоединениеФтп(подключись, username_, password_, port_);
        }

        return conn.дайИнфОФайле(name_).создай;
    }

    final Время доствремя() {
        conn.закрой();

        conOpen = нет;

        scope(failure) {
            if(!conOpen)
                if(conn !is пусто)
                    conn.закрой();
        }

        scope(exit) {
            if(!conOpen)
                if(conn !is пусто)
                    conn.закрой();
        }

        ткст подключись = toString_;

        if(подключись[$ - 1] == '/') {
            подключись = подключись[0 .. ($ - 1)];
        }

        if(!conOpen) {
            conn = new СоединениеФтп(подключись, username_, password_, port_);
        }

        return conn.дайИнфОФайле(name_).modify;
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
  Represents a selection of Files.
******************************************************************************/

class ФайлыФтп: ФайлыВфс {

    ткст toString_, name_, username_, password_;
    бцел port_;
    ИнфОФайлеФтп[] infos_;

    public this(ткст сервер, ткст путь, ткст ник = "",
                ткст пароль = "", бцел порт = 21, ИнфОФайлеФтп[] infos = пусто)
    in {
        assert(сервер.length > 0);
    }
    body {
        toString_ = checkFirst(сервер);
        name_ = checkLast(путь);
        username_ = ник;
        password_ = пароль;
        port_ = порт;
        if(infos !is пусто)
            infos_ = infos;
        else
            заполниИнфы();
    }

    final проц заполниИнфы() {

        СоединениеФтп conn;

    

        scope(exit) {
            if(conn !is пусто)
                conn.закрой();
        }

        ткст подключись = toString_;

        if(подключись[$ - 1] == '/') {
            подключись = подключись[0 .. ($ - 1)];
        }

        conn = new СоединениеФтп(подключись, username_, password_, port_);

        if(name_ != "")
            conn.cd(name_);

        infos_ = дайФайлы(conn);
    }

    /***********************************************************************
     Iterate over the установи of contained ФайлВфс instances
     ***********************************************************************/

    final цел opApply(цел delegate(ref ФайлВфс) дг) {
        цел результат = 0;

        foreach(ИнфОФайлеФтп inf; infos_) {
            ФайлВфс x = new ФайлФтп(toString_, checkLast(checkCat(name_, inf.имя)),
                username_, password_, port_);
            if((результат = дг(x)) != 0)
                break;
        }

        return результат;
    }

    /***********************************************************************
     Return the total число of записи
     ***********************************************************************/

    final бцел файлы() {
        return infos_.length;
    }

    /***********************************************************************
     Return the total размер of все файлы
     ***********************************************************************/

    final бдол байты() {
        бдол return_;

        foreach(ИнфОФайлеФтп inf; infos_) {
            return_ += inf.размер;
        }

        return return_;
    }
}

