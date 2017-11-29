﻿module io.protocol.Reader;

private import  io.Buffer;
public  import  io.model;
public  import  io.protocol.model;


class Читатель : ИЧитатель
{

    this (ИПотокВвода поток);
    this (ИПротокол протокол);
    this (ИРазместитель разместитель);
    final ИБуфер буфер ();
    final ИРазместитель разместитель ();
    final ИЧитатель получи (ИЧитатель.Клозура дг) ;
    final ИЧитатель получи (ИЧитаемое x) ;
    final ИЧитатель получи (inout бул x);
    final ИЧитатель получи (inout ббайт x) ;
    final ИЧитатель получи (inout байт x);
    final ИЧитатель получи (inout бкрат x);
    final ИЧитатель получи (inout крат x);
    final ИЧитатель получи (inout бцел x);
    final ИЧитатель получи (inout цел x);
    final ИЧитатель получи (inout бдол x);
    final ИЧитатель получи (inout дол x);
    final ИЧитатель получи (inout плав x);
    final ИЧитатель получи (inout дво x);
    final ИЧитатель получи (inout реал x);
    final ИЧитатель получи (inout сим x);
    final ИЧитатель получи (inout шим x);
    final ИЧитатель получи (inout дим x);
    final ИЧитатель получи (inout бул[] x) ;
    final ИЧитатель получи (inout ббайт[] x) ;
    final ИЧитатель получи (inout байт[] x);
    final ИЧитатель получи (inout бкрат[] x);
    final ИЧитатель получи (inout крат[] x);
    final ИЧитатель получи (inout бцел[] x);
    final ИЧитатель получи (inout цел[] x);
    final ИЧитатель получи (inout бдол[] x);
    final ИЧитатель получи (inout дол[] x);
    final ИЧитатель получи (inout плав[] x);
    final ИЧитатель получи (inout дво[] x);
    final ИЧитатель получи (inout реал[] x);
    final ИЧитатель получи (inout ткст x);
    final ИЧитатель получи (inout шим[] x);
    final ИЧитатель получи (inout дим[] x);
    private ИЧитатель загрузиМассив (проц[]* x, бцел width, ИПротокол.Тип тип);
    private проц[] размести (ИПротокол.Читатель читатель, бцел байты, ИПротокол.Тип тип);
    private проц[] читайЭлемент (ук приёмн, бцел байты, ИПротокол.Тип тип);
    private проц[] читайМассив (ук приёмн, бцел байты, ИПротокол.Тип тип, ИПротокол.Разместитель размести);
}

