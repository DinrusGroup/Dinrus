/*******************************************************************************

        copyright:      Copyright (c) 2007 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: Nov 2007

        author:         Kris

        UTF conversion Потокs, supporting cross-translation of сим, шим 
        and дим variants. For supporting эндиан variations, конфигурируй the
        appropriate EndianПоток upПоток of this one (closer в_ the источник)

*******************************************************************************/

module io.stream.Utf;

private import io.device.Conduit;

private import io.stream.Buffered;

private import Utf = text.convert.Utf;

/*******************************************************************************

        Потокing UTF converter. Тип T is the мишень or destination тип, 
        while S is the источник тип. Всё типы are either сим/шим/дим.

*******************************************************************************/

class ЮВвод(T, S) : ФильтрВвода, ФильтрВвода.Переключатель
{       
        static if (!is (S == сим) && !is (S == шим) && !is (S == дим)) 
                    pragma (msg, "Исходный тип должен быть сим, шим или дим");

        static if (!is (T == сим) && !is (T == шим) && !is (T == дим)) 
                    pragma (msg, "Целевой тип должен быть сим, шим или дим");

        private БуферВвода буфер;

        /***********************************************************************

                Create a buffered utf ввод converter

        ***********************************************************************/

        this (ИПотокВвода поток)
        {
                super (буфер = Бввод.создай (поток));
        }
        
        /***********************************************************************

                Consume ввод of тип T, and return the число of Массив 
                elements comsumed. 

                Returns Кф upon конец-of-flow

        ***********************************************************************/

        final т_мера используй (T[] приёмн)
        {
                auto x = читай (приёмн);
                if (x != Кф)
                    x /= T.sizeof;
                return x;
        }

        /***********************************************************************

        ***********************************************************************/

        final override т_мера читай (проц[] приёмн)
        {
                static if (is (S == T))
                           return super.читай (приёмн);
                else
                   {
                   бцел   consumed,
                          produced;

                   т_мера читатель (проц[] ист)
                   {
                        if (ист.length < S.sizeof)
                            return Кф;

                        auto вывод = Бввод.преобразуй!(T)(приёмн);
                        auto ввод  = Бввод.преобразуй!(S)(ист);

                        static if (is (T == сим))
                                   produced = Utf.вТкст(ввод, вывод, &consumed).length;

                        static if (is (T == шим))
                                   produced = Utf.вТкст16(ввод, вывод, &consumed).length;

                        static if (is (T == дим))
                                   produced = Utf.toString32(ввод, вывод, &consumed).length;

                        // используй буфер контент
                        return consumed * S.sizeof;
                   }

                   // must have some пространство available for converting
                   if (приёмн.length < T.sizeof)
                       провод.ошибка ("UtfПоток.читай :: целевой Массив слишком мал");

                   // преобразуй следщ chunk of ввод
                   if (буфер.следщ(&читатель) is нет)
                       return Кф;

                   return produced * T.sizeof;
                   }
        }
}


/*******************************************************************************
        
        Потокing UTF converter. Тип T is the мишень or destination тип, 
        while S is the источник тип. Всё типы are either сим/шим/дим.

        Note that the аргументы are reversed из_ those of ЮВвод

*******************************************************************************/

class ЮВывод (S, T) : ФильтрВывода, ФильтрВывода.Переключатель
{       
        static if (!is (S == сим) && !is (S == шим) && !is (S == дим)) 
                    pragma (msg, "Исходный тип должен быть сим, шим или дим");

        static if (!is (T == сим) && !is (T == шим) && !is (T == дим)) 
                    pragma (msg, "Целевой тип должен быть сим, шим или дим");


        private БуферВывода буфер;

        /***********************************************************************

                Create a buffered utf вывод converter

        ***********************************************************************/

        this (ИПотокВывода поток)
        {
                super (буфер = Бвыв.создай (поток));
        }

        /***********************************************************************

                Consume ввод of тип T, and return the число of Массив 
                elements consumed. 

                Returns Кф upon конец-of-flow

        ***********************************************************************/

        final т_мера используй (S[] приёмн)
        {
                auto x = пиши (приёмн);
                if (x != Кф)
                    x /= S.sizeof;
                return x;
        }

        /***********************************************************************
        
                Write в_ the вывод поток из_ a источник Массив. The provопрed 
                ист контент is преобразованый as necessary. Note that an attached
                вывод буфер must be at least four байты wide в_ accommodate
                a conversion.

                Returns the число of байты consumed из_ ист, which may be
                less than the quantity provопрed

        ***********************************************************************/

        final override т_мера пиши (проц[] ист)
        {
                static if (is (S == T))
                           return super.пиши (ист);
                else
                   {
                   бцел   consumed,
                          produced;

                   т_мера писатель (проц[] приёмн)
                   {
                        // буфер must be at least 4 байты wide 
                        // в_ contain a generic conversion
                        if (приёмн.length < 4)
                            return Кф;

                        auto ввод = Бвыв.преобразуй!(S)(ист);
                        auto вывод = Бвыв.преобразуй!(T)(приёмн);

                        static if (is (T == сим))
                                   produced = Utf.вТкст(ввод, вывод, &consumed).length;

                        static if (is (T == шим))
                                   produced = Utf.вТкст16(ввод, вывод, &consumed).length;

                        static if (is (T == дим))
                                   produced = Utf.toString32(ввод, вывод, &consumed).length;

                        return produced * T.sizeof;
                   }
                    
                   // пиши directly преобр_в buffered контент and
                   // слей when the вывод is full
                   if (буфер.писатель(&писатель) is Кф)
                      {
                      буфер.слей;
                      if (буфер.писатель(&писатель) is Кф)
                          return Кф;
                      }
                   return consumed * S.sizeof;
                   }
        }
}


/*******************************************************************************
        
*******************************************************************************/
        
debug (Utf)
{
        import io.Stdout;
        import io.device.Array;

        проц main()
        {
                auto inp = new ЮВвод!(дим, сим)(new Массив("hello world"));
                auto oot = new ЮВывод!(дим, сим)(new Массив(20));
                oot.копируй(inp);
                assert (oot.буфер.срез == "hello world");
        }
}
