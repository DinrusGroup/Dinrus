﻿/*******************************************************************************

        copyright:      Copyright (c) 2007 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: Oct 2007

        author:         Kris

*******************************************************************************/

module io.stream.Digester;

private import io.device.Conduit;

private import util.digest.Digest;
import util.digest.Crc32 : Crc32;

/*******************************************************************************

        Inject a дайджест фильтр преобр_в an ввод поток, updating the дайджест
        as information flows through it

*******************************************************************************/

class ДайджестВвод : ФильтрВвода, ФильтрВвода.Переключатель
{
        private Дайджест фильтр;
        
        /***********************************************************************

                Accepts any ввод поток, and any дайджест derivation

        ***********************************************************************/

        this (ИПотокВвода поток, Дайджест дайджест)
        {
                super (поток);
                фильтр = дайджест;
        }
		
		this (ИПотокВвода поток, Crc32 дайджест)
        {
                super (поток);
                фильтр = cast(Дайджест) дайджест;
        }

        /***********************************************************************

                Чтен из_ провод преобр_в a мишень Массив. The provопрed приёмн 
                will be populated with контент из_ the провод. 

                Returns the число of байты читай, which may be less than
                requested in приёмн (or IOПоток.Кф for конец-of-flow)

        ***********************************************************************/

        final override т_мера читай (проц[] приёмн)
        {
                auto длин = источник.читай (приёмн);
                if (длин != Кф)
                    фильтр.обнови (приёмн [0 .. длин]);
                return длин;
        }

        /***********************************************************************

                Slurp remaining поток контент and return this
                
        ***********************************************************************/

        final ДайджестВвод slurp (проц[] приёмн = пусто)
        {
                if (приёмн.length is 0)
                    приёмн.length = провод.размерБуфера;
                
                while (читай(приёмн) != Кф) {}
                return this;
        }

        /********************************************************************
             
                Return the Дайджест экземпляр we were создан with. Use this
                в_ access the resultant binary or hex дайджест значение

        *********************************************************************/
    
        final Дайджест дайджест()
        {
                return фильтр;
        }
}


/*******************************************************************************
        
        Inject a дайджест фильтр преобр_в an вывод поток, updating the дайджест
        as information flows through it. Here's an example where we calculate
        an MD5 дайджест as a sопрe-effect of copying a файл:
        ---
        auto вывод = new ДайджестВывод(new ФайлВывод("вывод"), new Md5);
        вывод.копируй (new ФайлВвод("ввод"));

        Стдвыв.форматнс ("hex дайджест: {}", вывод.дайджест.гексДайджест);
        ---

*******************************************************************************/

class ДайджестВывод : ФильтрВывода, ФильтрВвода.Переключатель
{
        private Дайджест фильтр;

        /***********************************************************************

                Accepts any вывод поток, and any дайджест derivation

        ***********************************************************************/

        this (ИПотокВывода поток, Дайджест дайджест)
        {
                super (поток);
                фильтр = дайджест;
        }

        /***********************************************************************
        
                Write в_ провод из_ a источник Массив. The provопрed ист
                контент will be записано в_ the провод.

                Returns the число of байты записано из_ ист, which may
                be less than the quantity provопрed

        ***********************************************************************/

        final override т_мера пиши (проц[] ист)
        {
                auto длин = сток.пиши (ист);
                if (длин != Кф)
                    фильтр.обнови (ист[0 .. длин]);
                return длин;
        }

        /********************************************************************
             
                Return the Дайджест экземпляр we were создан with. Use this
                в_ access the resultant binary or hex дайджест значение

        *********************************************************************/
    
        final Дайджест дайджест()
        {
                return фильтр;
        }
}


/*******************************************************************************
        
*******************************************************************************/
        
debug (DigestПоток)
{
        import io.Stdout;
        import io.device.Array;
        import util.digest.Md5;
        import io.stream.FileПоток;

        проц main()
        {
                auto вывод = new ДайджестВывод(new Массив(1024, 1024), new Md5);
                вывод.копируй (new ФайлВвод("Digester.d"));

                Стдвыв.форматнс ("hex дайджест:{}", вывод.дайджест.гексДайджест);
        }
}
