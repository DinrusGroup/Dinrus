/*******************************************************************************

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

        A vector of the given значение-тип V, with maximum depth Size. Note
        that this does no память allocation of its own when Size != 0, and
        does куча allocation when Size == 0. Thus you can have a fixed-размер
        low-overhead экземпляр, or a куча oriented экземпляр.

******************************************************************************/

struct Vector (V, цел Size = 0) 
{
        alias добавь       push;
        alias срез     opSlice;
        alias push      opCatAssign;

        static if (Size == 0)
                  {
                  private бцел depth;
                  private V[]  vector;
                  }
               else
                  {
                  private бцел     depth;
                  private V[Size]  vector;
                  }

        /***********************************************************************

                Clear the vector

        ***********************************************************************/

        Vector* сотри ()
        {
                depth = 0;
                return this;
        }

        /***********************************************************************
                
                Return depth of the vector

        ***********************************************************************/

        бцел размер ()
        {
                return depth;
        }

        /***********************************************************************
                
                Return remaining unused slots

        ***********************************************************************/

        бцел unused ()
        {
                return vector.length - depth;
        }

        /***********************************************************************
                
                Returns a (shallow) clone of this vector

        ***********************************************************************/

        Vector clone ()
        {       
                Vector v;
                static if (Size == 0)
                           v.vector.length = vector.length;
                
                v.vector[0..depth] = vector[0..depth];
                v.depth = depth;
                return v;
        }

        /**********************************************************************

                Добавь a значение в_ the vector.

                Throws an исключение when the vector is full

        **********************************************************************/

        V* добавь (V значение)
        {
                static if (Size == 0)
                          {
                          if (depth >= vector.length)
                              vector.length = vector.length + 64;
                          vector[depth++] = значение;
                          }
                       else
                          {                         
                          if (depth < vector.length)
                              vector[depth++] = значение;
                          else
                             ошибка (__LINE__);
                          }
                return &vector[depth-1];
        }

        /**********************************************************************

                Добавь a значение в_ the vector.

                Throws an исключение when the vector is full

        **********************************************************************/

        V* добавь ()
        {
                static if (Size == 0)
                          {
                          if (depth >= vector.length)
                              vector.length = vector.length + 64;
                          }
                       else
                          if (depth >= vector.length)
                              ошибка (__LINE__);

                auto p = &vector[depth++];
                *p = V.init;
                return p;
        }

        /**********************************************************************

                Добавь a series of values в_ the vector.

                Throws an исключение when the vector is full

        **********************************************************************/

        Vector* добавь (V[] значение...)
        {
                foreach (v; значение)
                         добавь (v);
                return this;
        }

        /**********************************************************************

                Удали and return the most recent добавьition в_ the vector.

                Throws an исключение when the vector is пустой

        **********************************************************************/

        V удали ()
        {
                if (depth)
                    return vector[--depth];

                return ошибка (__LINE__);
        }

        /**********************************************************************

                Index vector записи, where a zero индекс represents the
                oldest vector Запись.

                Throws an исключение when the given индекс is out of range

        **********************************************************************/

        V удали (бцел i)
        {
                if (i < depth)
                   {
                   if (i is depth-1)
                       return удали;
                   --depth;
                   auto v = vector [i];
                   memmove (vector.ptr+i, vector.ptr+i+1, V.sizeof * depth-i);
                   return v;
                   }

                return ошибка (__LINE__);
        }

        /**********************************************************************

                Index vector записи, as though it were an Массив

                Throws an исключение when the given индекс is out of range

        **********************************************************************/

        V opIndex (бцел i)
        {
                if (i < depth)
                    return vector [i];

                return ошибка (__LINE__);
        }

        /**********************************************************************

                Assign vector записи as though it were an Массив.

                Throws an исключение when the given индекс is out of range

        **********************************************************************/

        V opIndexAssign (V значение, бцел i)
        {
                if (i < depth)
                   {
                   vector[i] = значение;
                   return значение;
                   }

                return ошибка (__LINE__);
        }

        /**********************************************************************

                Return the vector as an Массив of values, where the first
                Массив Запись represents the oldest значение. 
                
                Doing a foreach() on the returned Массив will traverse in
                the opposite direction of foreach() upon a vector
                 
        **********************************************************************/

        V[] срез ()
        {
                return vector [0 .. depth];
        }

        /**********************************************************************

                Throw an исключение

        **********************************************************************/

        private V ошибка (т_мера строка)
        {
                throw new ArrayBoundsException (__FILE__, строка);
        }

        /***********************************************************************

                Iterate из_ the most recent в_ the oldest vector записи

        ***********************************************************************/

        цел opApply (цел delegate(ref V значение) дг)
        {
                        цел результат;

                        for (цел i=depth; i-- && результат is 0;)
                             результат = дг (vector [i]);
                        return результат;
        }

        /***********************************************************************

                Iterate из_ the most recent в_ the oldest vector записи

        ***********************************************************************/

        цел opApply (цел delegate(ref V значение, ref бул затуши) дг)
        {
                        цел результат;

                        for (цел i=depth; i-- && результат is 0;)
                            {
                            auto затуши = нет;
                            результат = дг (vector[i], затуши);
                            if (затуши)
                                удали (i);
                            }
                        return результат;
        }
}


/*******************************************************************************

*******************************************************************************/

debug (Vector)
{
        import io.Stdout;

        проц main()
        {
                Vector!(цел, 0) v;
                v.добавь (1);
                
                Vector!(цел, 10) s;

                Стдвыв.форматнс ("добавь four");
                s.добавь (1);
                s.добавь (2);
                s.добавь (3);
                s.добавь (4);
                foreach (v; s)
                         Стдвыв.форматнс ("{}", v);

                s = s.clone;
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
        
