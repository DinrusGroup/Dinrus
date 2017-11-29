﻿module sys.SharedLib;


final class Длл {

    enum ПРежимЗагрузки {
        Сейчас = 0b1,
        Отложенный = 0b10,
        Глобальный = 0b100,
        Локальный = 0b1000
    }

    static Длл загрузи(ткст путь, ПРежимЗагрузки режим = ПРежимЗагрузки.Сейчас | ПРежимЗагрузки.Глобальный);
    static Длл загрузиБезИскл(ткст путь, ПРежимЗагрузки режим = ПРежимЗагрузки.Сейчас | ПРежимЗагрузки.Глобальный);
    проц выгрузи() ;
    проц выгрузиБезИскл() ;
    ткст путь() ;
    ук  дайСимвол(сим* имя) ;
    ук  дайСимволБезИскл(сим* имя);
    static бцел члоЗагруженыхБибл() ;
    бул загружен() ;
    this(ткст путь) ;

}


class ИсклДлл : Исключение {
    this (ткст сооб);
}

