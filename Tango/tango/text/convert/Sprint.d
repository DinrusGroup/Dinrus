/*******************************************************************************

        copyright:      Copyright (c) 2005 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)
        
        version:        Nov 2005: Initial release

        author:         Kris

*******************************************************************************/

module text.convert.Sprint;

private import text.convert.Layout;

/******************************************************************************

        Constructs sprintf-стиль вывод. This is a replacement for the 
        vsprintf() семейство of functions, and writes its вывод преобр_в a 
        lookasопрe буфер:
        ---
        // создай a Sprint экземпляр
        auto sprint = new Sprint!(сим);

        // пиши formatted текст в_ a logger
        лог.инфо (sprint ("{} green bottles, sitting on a wall\n", 10));
        ---

        Sprint can be handy when you wish в_ форматируй текст for a Логгер
        or similar, since it avoопрs куча activity during conversion by
        hosting a fixed размер conversion буфер. This is important when
        debugging since куча activity can be responsible for behavioral 
        changes. One would создай a Sprint экземпляр ahead of время, and
        utilize it in conjunction with the logging package.
               
        Please note that the class itself is stateful, and therefore a 
        single экземпляр is not shareable across multИПle threads. The
        returned контент is not .dup'd either, so do that yourself if
        you require a persistent копируй.
        
        Note also that Sprint is templated, and can be instantiated for
        wide chars through a Sprint!(дим) or Sprint!(шим). The wide
        versions differ in that Всё the вывод and the форматируй-ткст
        are of the мишень тип. Variadic текст аргументы are transcoded 
        appropriately.

        See also: text.convert.Layout

******************************************************************************/

class Sprint(T)
{
        protected T[]           буфер;
        Выкладка!(T)              выкладка;

        alias форматируй            opCall;
       
        /**********************************************************************

                Create new Sprint instances with a буфер of the specified
                размер
                
                Deprecated - use Стдвыв.выкладка.sprint() instead

        **********************************************************************/

        deprecated this (цел размер = 256)
        {
                this (размер, Выкладка!(T).экземпляр);
        }
        
        /**********************************************************************

                Create new Sprint instances with a буфер of the specified
                размер, and the provопрed форматёр. The сукунда аргумент can be
                used в_ apply cultural specifics (I18N) в_ Sprint
                
        **********************************************************************/

        this (цел размер, Выкладка!(T) форматёр)
        {
                буфер = new T[размер];
                this.выкладка = форматёр;
        }

        /**********************************************************************

                Выкладка a установи of аргументы
                
        **********************************************************************/

        T[] форматируй (T[] фмт, ...)
        {
                return выкладка.vprint (буфер, фмт, _arguments, _argptr);
        }

        /**********************************************************************

                Выкладка a установи of аргументы
                
        **********************************************************************/

        T[] форматируй (T[] фмт, ИнфОТипе[] аргументы, АргСписок argptr)
        {
                return выкладка.vprint (буфер, фмт, аргументы, argptr);
        }
}

