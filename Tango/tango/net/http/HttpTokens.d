﻿/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)
       
        version:        Initial release: April 2004      
        
        author:         Kris

*******************************************************************************/

module net.http.HttpTokens;

private import  time.Time;

private import  io.device.Array;

private import  io.stream.Buffered;

private import  net.http.HttpStack,
                net.http.HttpConst;

private import  Text = text.Util;

private import  Целое = text.convert.Integer;

private import  TimeStamp = text.convert.TimeStamp;

/******************************************************************************

        Struct used в_ expose freachable ТокенППГТ instances.

******************************************************************************/

struct ТокенППГТ
{
        ткст  имя,
                значение;
}

/******************************************************************************

        Maintains a установи of HTTP семы. These семы include заголовки, запрос-
        параметры, and anything else vaguely related. Всё ввод and вывод
        are supported, though a subclass may choose в_ expose as читай-only.

        все семы are mapped directly onto a буфер, so there is no память
        allocation or copying involved. 

        Note that this class does not support deleting семы, per se. Instead
        it marks семы as being 'unused' by настройка контент в_ пусто, avoопрing 
        unwarranted reshaping of the token stack. The token stack is reused as
        время goes on, so there's only minor рантайм overhead.

******************************************************************************/

class ТокеныППГТ
{
        protected HttpStack     stack;
        private Массив           ввод;
        private Массив           вывод;
        private бул            разобрано;
        private бул            включительно;
        private сим            разделитель;
        private сим[1]         строкаРаздел;

        /**********************************************************************
                
                Construct a установи of семы based upon the given delimiter, 
                and an indication of whether saопр delimiter should be
                consопрered часть of the left sопрe (effectively the имя).
        
                The latter is useful with заголовки, since the seperating
                ':' character should really be consопрered часть of the 
                имя for purposes of subsequent token matching.

        **********************************************************************/

        this (сим разделитель, бул включительно = нет)
        {
                stack = new HttpStack;

                this.включительно = включительно;
                this.разделитель = разделитель;
                
                // преобразуй разделитель преобр_в a ткст, for later use
                строкаРаздел[0] = разделитель;

                // pre-construct an пустой буфер for wrapping ткст parsing
                ввод = new Массив (0);

                // construct an Массив for containing stack семы
                вывод = new Массив (4096, 1024);
        }

        /**********************************************************************
                
                Clone a источник установи of ТокеныППГТ

        **********************************************************************/

        this (ТокеныППГТ источник)
        {
                stack = источник.stack.clone;
                ввод = пусто;
                вывод = источник.вывод;
                разобрано = да;
                включительно = источник.включительно;
                разделитель = источник.разделитель;
                строкаРаздел[0] = источник.строкаРаздел[0];
        }

        /**********************************************************************
                
                Чтен все семы. Everything is mapped rather than being 
                allocated & copied

        **********************************************************************/

        abstract проц разбор (БуферВвода ввод);

        /**********************************************************************
                
                Parse an ввод ткст.

        **********************************************************************/

        проц разбор (ткст контент)
        {
                ввод.присвой (контент);
                разбор (ввод);       
        }

        /**********************************************************************
                
                Reset this установи of семы.

        **********************************************************************/

        ТокеныППГТ сбрось ()
        {
                stack.сбрось;
                разобрано = нет;

                // сбрось вывод буфер
                вывод.сотри;
                return this;
        }

        /**********************************************************************
                
                Have семы been разобрано yet?

        **********************************************************************/

        бул разобран_ли ()
        {
                return разобрано;
        }

        /**********************************************************************
                
                Indicate whether семы have been разобрано or not.

        **********************************************************************/

        проц установиРазобран (бул разобрано)
        {
                this.разобрано = разобрано;
        }

        /**********************************************************************
                
                Return the значение of the provопрed заголовок, or пусто if the
                заголовок does not exist

        **********************************************************************/

        ткст получи (ткст имя, ткст ret = пусто)
        {
                Токен token = stack.найдиТокен (имя);
                if (token)
                   {
                   ТокенППГТ element;

                   if (разбей (token, element))
                       ret = trim (element.значение);
                   }
                return ret;
        }

        /**********************************************************************
                
                Return the целое значение of the provопрed заголовок, or the 
                provопрed default-vaule if the заголовок does not exist

        **********************************************************************/

        цел получиЦел (ткст имя, цел ret = -1)
        {       
                ткст значение = получи (имя);

                if (значение.length)
                    ret = cast(цел) Целое.разбор (значение);

                return ret;
        }

        /**********************************************************************
                
                Return the дата значение of the provопрed заголовок, or the 
                provопрed default-значение if the заголовок does not exist

        **********************************************************************/

        Время дайДату (ткст имя, Время дата = Время.эпоха)
        {
                ткст значение = получи (имя);

                if (значение.length)
                    дата = TimeStamp.разбор (значение);

                return дата;
        }

        /**********************************************************************

                Iterate over the установи of семы

        **********************************************************************/

        цел opApply (цел delegate(ref ТокенППГТ) дг)
        {
                ТокенППГТ element;
                цел       результат = 0;

                foreach (Токен t; stack)
                         if (разбей (t, element))
                            {
                            результат = дг (element);
                            if (результат)
                                break;
                            }
                return результат;
        }

        /**********************************************************************

                Вывод the token список в_ the provопрed consumer

        **********************************************************************/

        проц произведи (т_мера delegate(проц[]) используй, ткст кс = пусто)
        {
                foreach (Токен token; stack)
                        {
                        auto контент = token.вТкст;
                        if (контент.length)
                           {
                           используй (контент);
                           if (кс.length)
                               используй (кс);
                           }
                        }                           
        }

        /**********************************************************************

                overrопрable метод в_ укз the case where a token does
                not have a разделитель. Apparently, this can happen in HTTP 
                usage

        **********************************************************************/

        protected бул обработайНедостающийРазделитель (ткст s, ref ТокенППГТ element)
        {
                return нет;
        }

        /**********************************************************************

                разбей basic token преобр_в an ТокенППГТ

        **********************************************************************/

        final private бул разбей (Токен t, ref ТокенППГТ element)
        {
                auto s = t.вТкст();

                if (s.length)
                   {
                   auto i = Text.locate (s, разделитель);

                   // we should always найди the разделитель
                   if (i < s.length)
                      {
                      auto j = (включительно) ? i+1 : i;
                      element.имя = s[0 .. j];
                      element.значение = (++i < s.length) ? s[i .. $] : пусто;
                      return да;
                      }
                   else
                      // allow override в_ specialize this case
                      return обработайНедостающийРазделитель (s, element);
                   }
                return нет;                           
        }

        /**********************************************************************

                Create a фильтр for iterating over the семы matching
                a particular имя. 
        
        **********************************************************************/

        ФильтрованныеТокены создайФильтр (ткст match)
        {
                return new ФильтрованныеТокены (this, match);
        }

        /**********************************************************************

                Implements a фильтр for iterating over семы matching
                a particular имя. We do it like this because there's no 
                means of passing добавьitional information в_ an opApply() 
                метод.
        
        **********************************************************************/

        private static class ФильтрованныеТокены 
        {       
                private ткст          match;
                private ТокеныППГТ      семы;

                /**************************************************************

                        Construct this фильтр upon the given семы, and
                        установи the образец в_ match against.

                **************************************************************/

                this (ТокеныППГТ семы, ткст match)
                {
                        this.match = match;
                        this.семы = семы;
                }

                /**************************************************************

                        Iterate over все семы matching the given имя

                **************************************************************/

                цел opApply (цел delegate(ref ТокенППГТ) дг)
                {
                        ТокенППГТ       element;
                        цел             результат = 0;
                        
                        foreach (Токен token; семы.stack)
                                 if (семы.stack.совпадает (token, match))
                                     if (семы.разбей (token, element))
                                        {
                                        результат = дг (element);
                                        if (результат)
                                            break;
                                        }
                        return результат;
                }

        }

        /**********************************************************************

                Is the аргумент a пробел character?

        **********************************************************************/

        private бул isSpace (сим c)
        {
                return cast(бул) (c is ' ' || c is '\t' || c is '\r' || c is '\n');
        }

        /**********************************************************************

                Trim the provопрed ткст by strИПping пробел из_ 
                Всё ends. Returns a срез of the original контент.

        **********************************************************************/

        private ткст trim (ткст источник)
        {
                цел  front,
                     back = источник.length;

                if (back)
                   {
                   while (front < back && isSpace(источник[front]))
                          ++front;

                   while (back > front && isSpace(источник[back-1]))
                          --back;
                   } 
                return источник [front .. back];
        }


        /**********************************************************************
        ****************** these should be exposed carefully ******************
        **********************************************************************/


        /**********************************************************************
                
                Return a ткст representing the вывод. An пустой Массив
                is returned if вывод was not configured. This perhaps
                could just return our 'вывод' буфер контент, but that
                would not reflect deletes, or seperators. Better в_ do 
                it like this instead, for a small cost.

        **********************************************************************/

        ткст форматируйТокены (БуферВывода приёмн, ткст разделитель)
        {
                бул first = да;

                foreach (Токен token; stack)
                        {
                        ткст контент = token.вТкст;
                        if (контент.length)
                           {
                           if (first)
                               first = нет;
                           else
                              приёмн.пиши (разделитель);
                           приёмн.пиши (контент);
                           }
                        }    
                return cast(ткст) приёмн.срез;
        }

        /**********************************************************************
                
                Добавь a token with the given имя. The контент is provопрed
                via the specified delegate. We stuff this имя & контент
                преобр_в the вывод буфер, and карта a new Токен onto the
                appropriate буфер срез.

        **********************************************************************/

        protected проц добавь (ткст имя, проц delegate(БуферВывода) значение)
        {
                // save the буфер пиши-позиция
                //цел prior = вывод.предел;
                auto prior = вывод.срез.length;

                // добавь the имя
                вывод.добавь (имя);

                // don't добавь разделитель if it's already часть of the имя
                if (! включительно)
                      вывод.добавь (строкаРаздел);
                
                // добавь the значение
                значение (вывод);

                // карта new token onto буфер срез
                stack.push (cast(ткст) вывод.срез [prior .. $]);
        }

        /**********************************************************************
                
                Добавь a simple имя/значение pair в_ the вывод

        **********************************************************************/

        protected проц добавь (ткст имя, ткст значение)
        {
                проц добавьЗначение (БуферВывода буфер)
                {
                        буфер.пиши (значение);
                }

                добавь (имя, &добавьЗначение);
        }

        /**********************************************************************
                
                Добавь a имя/целое pair в_ the вывод

        **********************************************************************/

        protected проц добавьInt (ткст имя, цел значение)
        {
                сим[16] врем =void;

                добавь (имя, Целое.форматируй (врем, cast(дол) значение));
        }

        /**********************************************************************
               
               Добавь a имя/дата(дол) pair в_ the вывод
                
        **********************************************************************/

        protected проц добавьДату (ткст имя, Время значение)
        {
                сим[40] врем =void;

                добавь (имя, TimeStamp.форматируй (врем, значение));
        }

        /**********************************************************************
               
               удали a token из_ our список. Returns нет if the named
               token is не найден.
                
        **********************************************************************/

        protected бул удали (ткст имя)
        {
                return stack.удалиТокен (имя);
        }
}
