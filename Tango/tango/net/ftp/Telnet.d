﻿/*******************************************************************************
                                                                                
        copyright:      Copyright (c) 2006 UWB. все rights reserved             
                                                                                
        license:        BSD стиль: $(LICENSE)                                   
                                                                                
        version:        Initial release: June 2006                              
                        Dinrus Mods by Lester L Martin: August 2008
                                                                                
        author:         UWB                                                     
                                                                                
*******************************************************************************/

module net.ftp.Telnet;

private 
{
        import exception;
        import io.stream.Lines;
        import net.device.Socket;
}

class Telnet 
{
        /// The Сокет that is used в_ шли commands.
        Сокет сокет_;
        Строки!(сим) iterator;

        abstract проц исключение(ткст сообщение);

        /// Отправка a строка over the Сокет Провод.
        ///
        /// буф = the байты в_ шли
        проц отправьСтроку(проц[] буф) 
        {
                отправьДанные(буф);
                отправьДанные("\r\n");
        }

        /// Отправка a строка over the Сокет Провод.
        ///
        /// буф = the байты в_ шли
        проц отправьДанные(проц[] буф) 
        {
                сокет_.пиши(буф);
        }

        /// Чтен a CRLF terminated строка из_ the сокет.
        ///
        /// Возвращает: the строка читай
        ткст читайСтроку() 
        {
                ткст to_return; 
                iterator.читайнс(to_return); 
                return to_return; 
        }

        /************************************************************************
         * Find a сервер which is listening on the specified порт.
         *
         *      Параметры:
         *          имя_хоста = the имя_хоста в_ отыщи and подключись в_
         *          порт = the порт в_ подключись on
         *      Возвращает:
                the Сокет экземпляр used
         *      Since: 0.99.8
         */
        Сокет найдиДоступныйСервер(ткст имя_хоста, цел порт) 
        {
                сокет_ = new Сокет;
                сокет_.подключись(имя_хоста, порт);
                iterator = new Строки!(сим)(сокет_); 
                return сокет_;
        }

}
