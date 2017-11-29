﻿module io.stream.Snoop;

private import  io.Console,
        io.device.Conduit;

private alias проц delegate(ткст) Снуп;

class СнупВвод : ИПотокВвода
{
    private ИПотокВвода     хост;
    private Снуп           snoop;

    this (ИПотокВвода хост, Снуп snoop = пусто);
    ИПотокВвода ввод ();
    final ИПровод провод ();
    final т_мера читай (проц[] приёмн);
    проц[] загрузи (т_мера max=-1);
    final ИПотокВвода слей ();
    final проц закрой ();
    final дол сместись (дол смещение, Якорь якорь = Якорь.Нач);
    private проц снупер (ткст x);
    private проц след (ткст формат, ...);
}

class СнупВывод : ИПотокВывода
{
    private ИПотокВывода    хост;
    private Снуп           snoop;


    this (ИПотокВывода хост, Снуп snoop = пусто);
    ИПотокВывода вывод ();
    final т_мера пиши (проц[] ист);
    final ИПровод провод ();
    final ИПотокВывода слей ();
    final проц закрой ();
    final ИПотокВывода копируй (ИПотокВвода ист, т_мера max=-1);
    final дол сместись (дол смещение, Якорь якорь = Якорь.Нач);
    private проц снупер (ткст x);
    private проц след (ткст формат, ...);
}
