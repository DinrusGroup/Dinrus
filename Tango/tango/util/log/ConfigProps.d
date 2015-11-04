﻿/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)
      
        version:        Nov 2005: разбей из_ Configurator.d
        verison:        Feb 2007: removed default console configuration
         
        author:         Kris

*******************************************************************************/

module util.log.ConfigProps;

private import  util.log.Log;

private import  io.stream.Map,
                io.device.File;

/*******************************************************************************

        A utility class for initializing the basic behaviour of the 
        default logging иерархия.

        Св_ваКонф parses a much simplified version of the property файл. 
        Dinrus.лог only supports the settings of Логгер levels at this время,
        and установи of Appenders and Layouts are currently готово "in the код"

*******************************************************************************/

struct Св_ваКонф
{
        /***********************************************************************
        
                Добавь a default StdioAppender, with a SimpleTimerLayout, в_ 
                the корень node. The activity levels of все nodes are установи
                via a property файл with имя=значение pairs specified in the
                following форматируй:

                    имя: the actual logger имя, in dot notation
                          форматируй. The имя "корень" is reserved в_
                          match the корень logger node.

                   значение: one of TRACE, INFO, WARN, ERROR, FATAL
                          or Неук (or the lowercase equivalents).

                For example, the declaration

                ---
                unittest = INFO
                myApp.СОКЕТActivity = TRACE
                ---
                
                sets the уровень of the loggers called unittest and
                myApp.СОКЕТActivity

        ***********************************************************************/

        static проц opCall (ткст путь)
        {
                auto ввод = new КартВвод!(сим)(new Файл(путь));
                scope (exit)
                       ввод.закрой;

                // читай and разбор свойства из_ файл
                foreach (имя, значение; ввод)
                        {
                        auto лог = (имя == "корень") ? Журнал.корень
                                                    : Журнал.отыщи (имя);
                        if (лог)
                            лог.уровень (Журнал.преобразуй (значение));
                        }
        }
}

