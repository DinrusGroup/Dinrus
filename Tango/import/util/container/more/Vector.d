﻿/*******************************************************************************

        copyright:      Copyright (c) 2008 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)
        
        version:        Initial release: April 2008      
        
        author:         Kris

        Since:          0.99.7

*******************************************************************************/

module util.container.more.Vector;

private import exception : ArrayBoundsException;
private import cidrus : memmove;

/******************************************************************************

        A вектор of the given значение-тип V, with maximum глубина Размер. Note
        that this does no память allocation of its own when Размер != 0, и
        does куча allocation when Размер == 0. Thus you can have a fixed-размер
        low-overhead экземпляр, or a куча oriented экземпляр.

******************************************************************************/

struct Вектор (V, цел Размер = 0) 
{
        alias добавь       сунь;
        alias срез     opSlice;
        alias сунь      opCatAssign;

        static if (Размер == 0)
                  {
                  private бцел глубина;
                  private V[]  вектор;
                  }
               else
                  {
                  private бцел     глубина;
                  private V[Размер]  вектор;
                  }

        /***********************************************************************

                Clear the вектор

        ***********************************************************************/

        Вектор* очисть ()
        {
                глубина = 0;
                return this;
        }

        /***********************************************************************
                
                Return глубина of the вектор

        ***********************************************************************/

        бцел размер ()
        {
                return глубина;
        }

        /***********************************************************************
                
                Return остаток неиспользовано slots

        ***********************************************************************/

        бцел неиспользовано ()
        {
                return вектор.length - глубина;
        }

        /***********************************************************************
                
                Returns a (shallow) клонируй of this вектор

        ***********************************************************************/

        Вектор клонируй ()
        {       
                Вектор v;
                static if (Размер == 0)
                           v.вектор.length = вектор.length;
                
                v.вектор[0..глубина] = вектор[0..глубина];
                v.глубина = глубина;
                return v;
        }

        /**********************************************************************

                Добавь a значение в_ the вектор.

                Throws an исключение when the вектор is full

        **********************************************************************/

        V* добавь (V значение)
        {
                static if (Размер == 0)
                          {
                          if (глубина >= вектор.length)
                              вектор.length = вектор.length + 64;
                          вектор[глубина++] = значение;
                          }
                       else
                          {                         
                          if (глубина < вектор.length)
                              вектор[глубина++] = значение;
                          else
                             ошибка (__LINE__);
                          }
                return &вектор[глубина-1];
        }

        /**********************************************************************

                Добавь a значение в_ the вектор.

                Throws an исключение when the вектор is full

        **********************************************************************/

        V* добавь ()
        {
                static if (Размер == 0)
                          {
                          if (глубина >= вектор.length)
                              вектор.length = вектор.length + 64;
                          }
                       else
                          if (глубина >= вектор.length)
                              ошибка (__LINE__);

                auto p = &вектор[глубина++];
                *p = V.init;
                return p;
        }

        /**********************************************************************

                Добавь a series of значения в_ the вектор.

                Throws an исключение when the вектор is full

        **********************************************************************/

        Вектор* добавь (V[] значение...)
        {
                foreach (v; значение)
                         добавь (v);
                return this;
        }

        /**********************************************************************

                Удали и return the most recent добавьition в_ the вектор.

                Throws an исключение when the вектор is пустой

        **********************************************************************/

        V удали ()
        {
                if (глубина)
                    return вектор[--глубина];

                return ошибка (__LINE__);
        }

        /**********************************************************************

                Index вектор записи, where a zero индекс represents the
                oldest вектор Запись.

                Throws an исключение when the given индекс is out of range

        **********************************************************************/

        V удали (бцел i)
        {
                if (i < глубина)
                   {
                   if (i is глубина-1)
                       return удали;
                   --глубина;
                   auto v = вектор [i];
                   memmove (вектор.ptr+i, вектор.ptr+i+1, V.sizeof * глубина-i);
                   return v;
                   }

                return ошибка (__LINE__);
        }

        /**********************************************************************

                Index вектор записи, as though it were an Массив

                Throws an исключение when the given индекс is out of range

        **********************************************************************/

        V opIndex (бцел i)
        {
                if (i < глубина)
                    return вектор [i];

                return ошибка (__LINE__);
        }

        /**********************************************************************

                Assign вектор записи as though it were an Массив.

                Throws an исключение when the given индекс is out of range

        **********************************************************************/

        V opIndexAssign (V значение, бцел i)
        {
                if (i < глубина)
                   {
                   вектор[i] = значение;
                   return значение;
                   }

                return ошибка (__LINE__);
        }

        /**********************************************************************

                Return the вектор as an Массив of значения, where the первый
                Массив Запись represents the oldest значение. 
                
                Doing a foreach() on the returned Массив will traverse in
                the opposite direction of foreach() upon a вектор
                 
        **********************************************************************/

        V[] срез ()
        {
                return вектор [0 .. глубина];
        }

        /**********************************************************************

                Throw an исключение

        **********************************************************************/

        private V ошибка (т_мера строка)
        {
                throw new ArrayBoundsException (__FILE__, строка);
        }

        /***********************************************************************

                Iterate из_ the most recent в_ the oldest вектор записи

        ***********************************************************************/

        цел opApply (цел delegate(ref V значение) дг)
        {
                        цел результат;

                        for (цел i=глубина; i-- && результат is 0;)
                             результат = дг (вектор [i]);
                        return результат;
        }

        /***********************************************************************

                Iterate из_ the most recent в_ the oldest вектор записи

        ***********************************************************************/

        цел opApply (цел delegate(ref V значение, ref бул затуши) дг)
        {
                        цел результат;

                        for (цел i=глубина; i-- && результат is 0;)
                            {
                            auto затуши = нет;
                            результат = дг (вектор[i], затуши);
                            if (затуши)
                                удали (i);
                            }
                        return результат;
        }
}


/*******************************************************************************

*******************************************************************************/

debug (Вектор)
{
        import io.Stdout;

        проц main()
        {
                Вектор!(цел, 0) v;
                v.добавь (1);
                
                Вектор!(цел, 10) s;

                Стдвыв.форматнс ("добавь four");
                s.добавь (1);
                s.добавь (2);
                s.добавь (3);
                s.добавь (4);
                foreach (v; s)
                         Стдвыв.форматнс ("{}", v);

                s = s.клонируй;
                Стдвыв.форматнс ("pop one: {}", s.удали);
                foreach (v; s)
                         Стдвыв.форматнс ("{}", v);

                Стдвыв.форматнс ("удали[1]: {}", s.удали(1));
                foreach (v; s)
                         Стдвыв.форматнс ("{}", v);

                Стдвыв.форматнс ("удали two");
                s.удали;
                s.удали;
                foreach (v; s)
                         Стдвыв.форматнс ("> {}", v);

                s.добавь (1);
                s.добавь (2);
                s.добавь (3);
                s.добавь (4);
                foreach (v, ref k; s)
                         k = да;
                Стдвыв.форматнс ("размер {}", s.размер);
        }
}
        