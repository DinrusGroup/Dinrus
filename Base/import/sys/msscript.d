module sys.msscript;

private import stdrus, sys.activex, sys.WinIfaces;
pragma(lib,"DRwin32.lib");

class СкриптДвижок
{

    this(ткст движок);
    ~this();
    public проц пуск();
    public проц выполни(ткст команда);
    public проц стоп();
    public проц сброс();

}

class ВБСкриптДвижок: СкриптДвижок
{
    this();
}

class ДжейСкриптДвижок: СкриптДвижок
{
    this();
}

class СкриптКонтроль
{

    this(ткст имя, ткст имяКласса);
    this(ткст имя, ткст имяКласса, бит первичный);
    this(ткст имя, ткст имяКласса, бит первичный, ткст движок);
    ~this() ;
    public проц установи(ткст свойство);
    public проц установи(ткст свойство, ткст знач);
}


class ВБСкриптКонтроль: СкриптКонтроль
{
    this(ткст имя, ткст имяКласса) ;
    this(ткст имя, ткст имяКласса, бит первичный) ;
    ~this();
}


class ДжейСкриптКонтроль: СкриптКонтроль
{
    this(ткст имя, ткст имяКласса) ;
    this(ткст имя, ткст имяКласса, бит первичный);
    ~this();
}


проц вбс(ткст инстр);
проц вбкон();
проц вбОбъ(ткст имя, ткст объ);
проц вбУст(ткст имя, ткст объ);

проц джейс(ткст инстр);
проц джейкон();

version (build)
{
    debug
    {
        pragma(link, "DRwin32");
    } else
    {
        pragma(link, "DRwin32");
    }
}
