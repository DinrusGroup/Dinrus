/*******************************************************************************

        copyright:      Copyright (c) 2005 John Chapman. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Mопр 2005: Initial release
                        Apr 2007: reshaped                        

        author:         John Chapman, Kris, schveiguy

******************************************************************************/

module time.chrono.Gregorian;

private import time.chrono.Calendar;

private import exception;

/**
 * $(ANCHOR _Gregorian)
 * Represents the Грегориан Календарь.
 *
 * Note that this is the Proleptic Грегориан Календарь.  Most Календарьs assume
 * that dates before 9/14/1752 were Julian Dates.  Julian differs из_
 * Грегориан in that leap годы occur every 4 годы, even on 100 год
 * increments.  The Proleptic Грегориан Календарь applies the Грегориан leap
 * год rules в_ dates before 9/14/1752, making the calculation of dates much
 * easier.
 */
class Грегориан : Календарь 
{
        // import baseclass воВремя()
        alias Календарь.воВремя воВремя;

        /// static shared экземпляр
        public static Грегориан генерный;

        enum Тип 
        {
                Локализованный = 1,               /// Refers в_ the localized version of the Грегориан Календарь.
                АнглСША = 2,               /// Refers в_ the US English version of the Грегориан Календарь.
                СреднеВостФранц = 9,        /// Refers в_ the Mопрdle East French version of the Грегориан Календарь.
                Арабский = 10,                 /// Refers в_ the _Arabic version of the Грегориан Календарь.
                ТранслитерАнгл = 11,  /// Refers в_ the transliterated English version of the Грегориан Календарь.
                ТранслитерФранц = 12    /// Refers в_ the transliterated French version of the Грегориан Календарь.
        }

        private Тип type_;                 

        /**
        * Represents the текущ эра.
        */
        enum {AD_ERA = 1, BC_ERA = 2, MAX_YEAR = 9999};

        private static final бцел[] ДниВМесОбщ = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365];

        private static final бцел[] ДниВМесВисокос   = [0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366];

        /**
        * создай a генерный экземпляр of this Календарь
        */
        static this()
        {       
                генерный = new Грегориан;
        }

        /**
        * Initializes an экземпляр of the Грегориан class using the specified GregorianTypes значение. If no значение is 
        * specified, the default is Грегориан.Types.Локализованный.
        */
        this (Тип тип = Тип.Локализованный) 
        {
                type_ = тип;
        }

        /**
        * Overrопрden. Returns a Время значение установи в_ the specified дата и время in the specified _era.
        * Параметры:
        *   год = An целое representing the _year.
        *   месяц = An целое representing the _month.
        *   день = An целое representing the _day.
        *   час = An целое representing the _hour.
        *   минута = An целое representing the _minute.
        *   секунда = An целое representing the _second.
        *   миллисекунда = An целое representing the _millisecond.
        *   эра = An целое representing the _era.
        * Возвращает: A Время установи в_ the specified дата и время.
        */
        override Время воВремя (бцел год, бцел месяц, бцел день, бцел час, бцел минута, бцел секунда, бцел миллисекунда, бцел эра)
        {
                return Время (дайТикиДаты(год, месяц, день, эра) + дайТикиВремени(час, минута, секунда)) + ИнтервалВремени.изМиллисек(миллисекунда);
        }

        /**
        * Overrопрden. Returns the день of the week in the specified Время.
        * Параметры: время = A Время значение.
        * Возвращает: A ДеньНедели значение representing the день of the week of время.
        */
        override ДеньНедели дайДеньНедели(Время время) 
        {
                auto тики = время.тики;
                цел смещение = 1;
                if (тики < 0)
                {
                    ++тики;
                    смещение = 0;
                }
       
                auto деньнед = cast(цел) ((тики / ИнтервалВремени.ТиковВДень + смещение) % 7);
                if (деньнед < 0)
                    деньнед += 7;
                return cast(ДеньНедели) деньнед;
        }

        /**
        * Overrопрden. Returns the день of the месяц in the specified Время.
        * Параметры: время = A Время значение.
        * Возвращает: An целое representing the день of the месяц of время.
        */
        override бцел дайДеньМесяца(Время время) 
        {
                return откиньЧасть(время.тики, ЧастьДаты.День);
        }

        /**
        * Overrопрden. Returns the день of the год in the specified Время.
        * Параметры: время = A Время значение.
        * Возвращает: An целое representing the день of the год of время.
        */
        override бцел дайДеньГода(Время время) 
        {
                return откиньЧасть(время.тики, ЧастьДаты.ДеньГода);
        }

        /**
        * Overrопрden. Returns the месяц in the specified Время.
        * Параметры: время = A Время значение.
        * Возвращает: An целое representing the месяц in время.
        */
        override бцел дайМесяц(Время время) 
        {
                return откиньЧасть(время.тики, ЧастьДаты.Месяц);
        }

        /**
        * Overrопрden. Returns the год in the specified Время.
        * Параметры: время = A Время значение.
        * Возвращает: An целое representing the год in время.
        */
        override бцел дайГод(Время время) 
        {
                return откиньЧасть(время.тики, ЧастьДаты.Год);
        }

        /**
        * Overrопрden. Returns the эра in the specified Время.
        * Параметры: время = A Время значение.
        * Возвращает: An целое representing the эра in время.
        */
        override бцел дайЭру(Время время) 
        {
                if(время < время.эпоха)
                        return BC_ERA;
                else
                        return AD_ERA;
        }

        /**
        * Overrопрden. Returns the число of дни in the specified _year и _month of the specified _era.
        * Параметры:
        *   год = An целое representing the _year.
        *   месяц = An целое representing the _month.
        *   эра = An целое representing the _era.
        * Возвращает: The число of дни in the specified _year и _month of the specified _era.
        */
        override бцел дайДниМесяца(бцел год, бцел месяц, бцел эра) 
        {
                //
                // проверь арги.  високосен_ли verifies the год is действителен.
                //
                if(месяц < 1 || месяц > 12)
                        ошАрга("месяцы out of range");
                auto monthDays = високосен_ли(год, эра) ? ДниВМесВисокос : ДниВМесОбщ;
                return monthDays[месяц] - monthDays[месяц - 1];
        }

        /**
        * Overrопрden. Returns the число of дни in the specified _year of the specified _era.
        * Параметры:
        *   год = An целое representing the _year.
        *   эра = An целое representing the _era.
        * Возвращает: The число of дни in the specified _year in the specified _era.
        */
        override бцел дайДниГода(бцел год, бцел эра) 
        {
                return високосен_ли(год, эра) ? 366 : 365;
        }

        /**
        * Overrопрden. Returns the число of месяцы in the specified _year of the specified _era.
        * Параметры:
        *   год = An целое representing the _year.
        *   эра = An целое representing the _era.
        * Возвращает: The число of месяцы in the specified _year in the specified _era.
        */
        override бцел дайМесяцыГода(бцел год, бцел эра) 
        {
                return 12;
        }

        /**
        * Overrопрden. Indicates whether the specified _year in the specified _era is a leap _year.
        * Параметры: год = An целое representing the _year.
        * Параметры: эра = An целое representing the _era.
        * Возвращает: да is the specified _year is a leap _year; otherwise, нет.
        */
        override бул високосен_ли(бцел год, бцел эра) 
        {
                return статВисокосен_ли(год, эра);
        }

        /**
        * $(I Property.) Retrieves the GregorianTypes значение indicating the language version of the Грегориан.
        * Возвращает: The Грегориан.Тип значение indicating the language version of the Грегориан.
        */
        Тип типКалендаря() 
        {
                return type_;
        }

        /**
        * $(I Property.) Overrопрden. Retrieves the список of эры in the текущ Календарь.
        * Возвращает: An целое Массив representing the эры in the текущ Календарь.
        */
        override бцел[] эры() 
        {       
                бцел[] врем = [AD_ERA, BC_ERA];
                return врем.dup;
        }

        /**
        * $(I Property.) Overrопрden. Retrieves the определитель associated with the текущ Календарь.
        * Возвращает: An целое representing the определитель of the текущ Календарь.
        */
        override бцел опр() 
        {
                return cast(цел) type_;
        }

        /**
         * Overrопрden.  Get the components of a Время structure using the rules
         * of the Календарь.  This is useful if you want ещё than one of the
         * given components.  Note that this doesn't укз the время of день,
         * as that is calculated directly из_ the Время struct.
         */
        override проц разбей(Время время, ref бцел год, ref бцел месяц, ref бцел день, ref бцел деньгода, ref бцел деньнед, ref бцел эра)
        {
            разбейДату(время.тики, год, месяц, день, деньгода, эра);
            деньнед = дайДеньНедели(время);
        }

        /**
         * Overrопрden. Returns a new Время with the specified число of месяцы
         * добавьed.  If the месяцы are негатив, the месяцы are subtracted.
         *
         * If the мишень месяц does not support the день component of the ввод
         * время, then an ошибка will be thrown, unless truncateDay is установи в_
         * да.  If truncateDay is установи в_ да, then the день is reduced в_
         * the maximum день of that месяц.
         *
         * For example, добавим one месяц в_ 1/31/2000 with truncateDay установи в_
         * да results in 2/28/2000.
         *
         * Параметры: t = A время в_ добавь the месяцы в_
         * Параметры: члоМес = The число of месяцы в_ добавь.  This can be
         * негатив.
         * Параметры: truncateDay = Round the день down в_ the maximum день of the
         * мишень месяц if necessary.
         *
         * Возвращает: A Время that represents the provопрed время with the число
         * of месяцы добавьed.
         */
        override Время добавьМесяцы(Время t, цел члоМес, бул truncateDay=нет)
        {
                //
                // We know все годы are 12 месяцы, so use the в_/из_ дата
                // methods в_ сделай the calculation an O(1) operation
                //
                auto дата = вДату(t);
                члоМес += дата.месяц - 1;
                цел члоЛет = члоМес / 12;
                члоМес %= 12;
                if(члоМес < 0)
                {
                        члоЛет--;
                        члоМес += 12;
                }
                цел realYear = дата.год;
                if(дата.эра == BC_ERA)
                        realYear = -realYear + 1;
                realYear += члоЛет;
                if(realYear < 1)
                {
                        дата.год = -realYear + 1;
                        дата.эра = BC_ERA;
                }
                else
                {
                        дата.год = realYear;
                        дата.эра = AD_ERA;
                }
                дата.месяц = члоМес + 1;
                //
                // упрости the день if necessary
                //
                if(truncateDay)
                {
                    бцел maxday = дайДниМесяца(дата.год, дата.месяц, дата.эра);
                    if(дата.день > maxday)
                        дата.день = maxday;
                }
                auto tod = t.тики % ИнтервалВремени.ТиковВДень;
                if(tod < 0)
                        tod += ИнтервалВремени.ТиковВДень;
                return воВремя(дата) + ИнтервалВремени(tod);
        }

        /**
         * Overrопрden.  Добавь the specified число of годы в_ the given Время.
         *
         * Note that the Грегориан Календарь takes преобр_в account that BC время
         * is негатив, и supports crossing из_ BC в_ AD.
         *
         * Параметры: t = A время в_ добавь the годы в_
         * Параметры: члоЛет = The число of годы в_ добавь.  This can be негатив.
         *
         * Возвращает: A Время that represents the provопрed время with the число
         * of годы добавьed.
         */
        override Время добавьГоды(Время t, цел члоЛет)
        {
                return добавьМесяцы(t, члоЛет * 12);
        }

        package static проц разбейДату (дол тики, ref бцел год, ref бцел месяц, ref бцел день, ref бцел dayOfYear, ref бцел эра) 
        {
                цел numDays;

                проц calculateYear()
                {
                        auto whole400Years = numDays / cast(цел) ИнтервалВремени.ДнейНа400Лет;
                        numDays -= whole400Years * cast(цел) ИнтервалВремени.ДнейНа400Лет;
                        auto whole100Years = numDays / cast(цел) ИнтервалВремени.ДнейНа100Лет;
                        if (whole100Years == 4)
                                whole100Years = 3;

                        numDays -= whole100Years * cast(цел) ИнтервалВремени.ДнейНа100Лет;
                        auto whole4Years = numDays / cast(цел) ИнтервалВремени.ДнейНа4Года;
                        numDays -= whole4Years * cast(цел) ИнтервалВремени.ДнейНа4Года;
                        auto wholeYears = numDays / cast(цел) ИнтервалВремени.ДнейВГоду;
                        if (wholeYears == 4)
                                wholeYears = 3;

                        год = whole400Years * 400 + whole100Years * 100 + whole4Years * 4 + wholeYears + эра;
                        numDays -= wholeYears * ИнтервалВремени.ДнейВГоду;
                }

                if(тики < 0)
                {
                        // in the BC эра
                        эра = BC_ERA;
                        //
                        // установи up numDays в_ be like AD.  AD дни старт at
                        // год 1.  However, in BC, год 1 is like AD год 0,
                        // so we must вычти one год.
                        //
                        numDays = cast(цел)((-тики - 1) / ИнтервалВремени.ТиковВДень);
                        if(numDays < 366)
                        {
                                // in the год 1 B.C.  This is a special case
                                // leap год
                                год = 1;
                        }
                        else
                        {
                                numDays -= 366;
                                calculateYear;
                        }
                        //
                        // numDays is the число of дни back из_ the конец of
                        // the год, because the original тики were негатив
                        //
                        numDays = (статВисокосен_ли(год, эра) ? 366 : 365) - numDays - 1;
                }
                else
                {
                        эра = AD_ERA;
                        numDays = cast(цел)(тики / ИнтервалВремени.ТиковВДень);
                        calculateYear;
                }
                dayOfYear = numDays + 1;

                auto monthDays = статВисокосен_ли(год, эра) ? ДниВМесВисокос : ДниВМесОбщ;
                месяц = numDays >> 5 + 1;
                while (numDays >= monthDays[месяц])
                       месяц++;

                день = numDays - monthDays[месяц - 1] + 1;
        }

        package static бцел откиньЧасть (дол тики, ЧастьДаты часть) 
        {
                бцел год, месяц, день, dayOfYear, эра;

                разбейДату(тики, год, месяц, день, dayOfYear, эра);

                if (часть is ЧастьДаты.Год)
                    return год;

                if (часть is ЧастьДаты.Месяц)
                    return месяц;

                if (часть is ЧастьДаты.ДеньГода)
                    return dayOfYear;

                return день;
        }

        package static дол дайТикиДаты (бцел год, бцел месяц, бцел день, бцел эра) 
        {
                //
                // проверь аргументы, дайДниМесяца verifies the год и
                // месяц is действителен.
                //
                if(день < 1 || день > генерный.дайДниМесяца(год, месяц, эра))
                        ошАрга("дни превышают допустимый диапазон");

                auto monthDays = статВисокосен_ли(год, эра) ? ДниВМесВисокос : ДниВМесОбщ;
                if(эра == BC_ERA)
                {
                        год += 2;
                        return -cast(дол)( (год - 3) * 365 + год / 4 - год / 100 + год / 400 + monthDays[12] - (monthDays[месяц - 1] + день - 1)) * ИнтервалВремени.ТиковВДень;
                }
                else
                {
                        год--;
                        return (год * 365 + год / 4 - год / 100 + год / 400 + monthDays[месяц - 1] + день - 1) * ИнтервалВремени.ТиковВДень;
                }
        }

        package static бул статВисокосен_ли(бцел год, бцел эра)
        {
                if(год < 1)
                        ошАрга("год не может быть равен 0");
                if(эра == BC_ERA)
                {
                        if(год == 1)
                                return да;
                        return статВисокосен_ли(год - 1, AD_ERA);
                }
                if(эра == AD_ERA || эра == ТЕКУЩАЯ_ЭРА)
                        return (год % 4 == 0 && (год % 100 != 0 || год % 400 == 0));
                return нет;
        }

        package static проц ошАрга(ткст стр)
        {
                throw new ИсклНелегальногоАргумента(стр);
        }
}

debug(Грегориан)
{
        import io.Stdout;

        проц вывод(Время t)
        {
                Дата d = Грегориан.генерный.вДату(t);
                ВремяДня tod = t.время;
                Стдвыв.форматируй("{}/{}/{:d4} {} {}:{:d2}:{:d2}.{:d3} деньнед:{}",
                                d.месяц, d.день, d.год, d.эра == Грегориан.AD_ERA ? "AD" : "BC",
                                tod.часы, tod.минуты, tod.сек, tod.миллисек, d.деньнед).нс;
        }

        проц main()
        {
                Время t = Время(365 * ИнтервалВремени.ТиковВДень);
                вывод(t);
                for(цел i = 0; i < 366 + 365; i++)
                {
                        t -= ИнтервалВремени.изДней(1);
                        вывод(t);
                }
        }
}

debug(UnitTest)
{
        unittest
        {
                //
                // проверь Грегориан дата handles positive время.
                //
                Время t = Время.эпоха + ИнтервалВремени.изДней(365);
                Дата d = Грегориан.генерный.вДату(t);
                assert(d.год == 2);
                assert(d.месяц == 1);
                assert(d.день == 1);
                assert(d.эра == Грегориан.AD_ERA);
                assert(d.деньгода == 1);
                //
                // note that this is in disagreement with the Julian Календарь
                //
                assert(d.деньнед == Грегориан.ДеньНедели.Вторник);

                //
                // проверь that it handles негатив время
                //
                t = Время.эпоха - ИнтервалВремени.изДней(366);
                d = Грегориан.генерный.вДату(t);
                assert(d.год == 1);
                assert(d.месяц == 1);
                assert(d.день == 1);
                assert(d.эра == Грегориан.BC_ERA);
                assert(d.деньгода == 1);
                assert(d.деньнед == Грегориан.ДеньНедели.Суббота);

                //
                // проверь that добавьМесяцы works properly, добавь 15 месяцы в_
                // 2/3/2004, 04:05:06.007008, then вычти 15 месяцы again.
                //
                t = Грегориан.генерный.воВремя(2004, 2, 3, 4, 5, 6, 7) + ИнтервалВремени.изМикросек(8);
                d = Грегориан.генерный.вДату(t);
                assert(d.год == 2004);
                assert(d.месяц == 2);
                assert(d.день == 3);
                assert(d.эра == Грегориан.AD_ERA);
                assert(d.деньгода == 34);
                assert(d.деньнед == Грегориан.ДеньНедели.Вторник);

                auto t2 = Грегориан.генерный.добавьМесяцы(t, 15);
                d = Грегориан.генерный.вДату(t2);
                assert(d.год == 2005);
                assert(d.месяц == 5);
                assert(d.день == 3);
                assert(d.эра == Грегориан.AD_ERA);
                assert(d.деньгода == 123);
                assert(d.деньнед == Грегориан.ДеньНедели.Вторник);

                t2 = Грегориан.генерный.добавьМесяцы(t2, -15);
                d = Грегориан.генерный.вДату(t2);
                assert(d.год == 2004);
                assert(d.месяц == 2);
                assert(d.день == 3);
                assert(d.эра == Грегориан.AD_ERA);
                assert(d.деньгода == 34);
                assert(d.деньнед == Грегориан.ДеньНедели.Вторник);

                assert(t == t2);

                //
                // проверь that illegal аргумент exceptions occur
                //
                try
                {
                        t = Грегориан.генерный.воВремя (0, 1, 1, 0, 0, 0, 0, Грегориан.AD_ERA);
                        assert(нет, "Dопр not throw illegal аргумент исключение");
                }
                catch(Исключение iae)
                {
                }
                try
                {
                        t = Грегориан.генерный.воВремя (1, 0, 1, 0, 0, 0, 0, Грегориан.AD_ERA);
                        assert(нет, "Dопр not throw illegal аргумент исключение");
                }
                catch(ИсклНелегальногоАргумента iae)
                {
                }
                try
                {
                        t = Грегориан.генерный.воВремя (1, 1, 0, 0, 0, 0, 0, Грегориан.BC_ERA);
                        assert(нет, "Dопр not throw illegal аргумент исключение");
                }
                catch(ИсклНелегальногоАргумента iae)
                {
                }

                try
                {
                    t = Грегориан.генерный.воВремя(2000, 1, 31, 0, 0, 0, 0);
                    t = Грегориан.генерный.добавьМесяцы(t, 1);
                    assert(нет, "Dопр not throw illegal аргумент исключение");
                }
                catch(ИсклНелегальногоАргумента iae)
                {
                }

                try
                {
                    t = Грегориан.генерный.воВремя(2000, 1, 31, 0, 0, 0, 0);
                    t = Грегориан.генерный.добавьМесяцы(t, 1, да);
                    assert(Грегориан.генерный.дайДеньМесяца(t) == 29);
                }
                catch(ИсклНелегальногоАргумента iae)
                {
                    assert(нет, "Should not throw illegal аргумент исключение");
                }



        }
}
