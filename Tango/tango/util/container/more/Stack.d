/*******************************************************************************

        copyright:      Copyright (c) 2008 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)
        
        version:        Initial release: April 2008      
        
        author:         Kris

        Since:          0.99.7

*******************************************************************************/

module util.container.more.Stack;

private import exception : ArrayBoundsException;

/******************************************************************************

        A stack of the given значение-тип V, with maximum depth Size. Note
        that this does no память allocation of its own when Size != 0, and
        does куча allocation when Size == 0. Thus you can have a fixed-размер
        low-overhead экземпляр, or a куча oriented экземпляр.

******************************************************************************/

struct Stack (V, цел Size = 0) 
{
        alias nth              opIndex;
        alias срез            opSlice;
        alias rotateRight      opShrAssign;
        alias rotateLeft       opShlAssign;
        alias push             opCatAssign;
          
        
        static if (Size == 0)
                  {
                  private бцел depth;
                  private V[]  stack;
                  }
               else
                  {
                  private бцел     depth;
                  private V[Size]  stack;
                  }

        /***********************************************************************

                Clear the stack

        ***********************************************************************/

        Stack* сотри ()
        {
                depth = 0;
                return this;
        }

        /***********************************************************************
                
                Return depth of the stack

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
                return stack.length - depth;
        }

        /***********************************************************************
                
                Returns a (shallow) clone of this stack, on the stack

        ***********************************************************************/

        Stack clone ()
        {       
                Stack s =void;
                static if (Size == 0)
                           s.stack.length = stack.length;
                s.stack[] = stack;
                s.depth = depth;
                return s;
        }

        /***********************************************************************
                
                Push and return a (shallow) копируй of the topmost element

        ***********************************************************************/

        V dup ()
        {
                auto v = top;
                push (v);       
                return v;
        }

        /**********************************************************************

                Push a значение onto the stack.

                Throws an исключение when the stack is full

        **********************************************************************/

        Stack* push (V значение)
        {
                static if (Size == 0)
                          {
                          if (depth >= stack.length)
                              stack.length = stack.length + 64;
                          stack[depth++] = значение;
                          }
                       else
                          {                         
                          if (depth < stack.length)
                              stack[depth++] = значение;
                          else
                             ошибка (__LINE__);
                          }
                return this;
        }

        /**********************************************************************

                Push a series of values onto the stack.

                Throws an исключение when the stack is full

        **********************************************************************/

        Stack* добавь (V[] значение...)
        {
                foreach (v; значение)
                         push (v);
                return this;
        }

        /**********************************************************************

                Удали and return the most recent добавьition в_ the stack.

                Throws an исключение when the stack is пустой

        **********************************************************************/

        V вынь ()
        {
                if (depth)
                    return stack[--depth];

                return ошибка (__LINE__);
        }

        /**********************************************************************

                Return the most recent добавьition в_ the stack.

                Throws an исключение when the stack is пустой

        **********************************************************************/

        V top ()
        {
                if (depth)
                    return stack[depth-1];

                return ошибка (__LINE__);
        }

        /**********************************************************************

                Swaps the top two записи, and return the top

                Throws an исключение when the stack есть insufficient записи

        **********************************************************************/

        V своп ()
        {
                auto p = stack.ptr + depth;
                if ((p -= 2) >= stack.ptr)
                   {
                   auto v = p[0];
                   p[0] = p[1];
                   return p[1] = v; 
                   }

                return ошибка (__LINE__);                
        }

        /**********************************************************************

                Index stack записи, where a zero индекс represents the
                newest stack Запись (the top).

                Throws an исключение when the given индекс is out of range

        **********************************************************************/

        V nth (бцел i)
        {
                if (i < depth)
                    return stack [depth-i-1];

                return ошибка (__LINE__);
        }

        /**********************************************************************

                Rotate the given число of stack записи 

                Throws an исключение when the число is out of range

        **********************************************************************/

        Stack* rotateLeft (бцел d)
        {
                if (d <= depth)
                   {
                   auto p = &stack[depth-d];
                   auto t = *p;
                   while (--d)
                          *p++ = *(p+1);
                   *p = t;
                   }
                else
                   ошибка (__LINE__);
                return this;
        }

        /**********************************************************************

                Rotate the given число of stack записи 

                Throws an исключение when the число is out of range

        **********************************************************************/

        Stack* rotateRight (бцел d)
        {
                if (d <= depth)
                   {
                   auto p = &stack[depth-1];
                   auto t = *p;
                   while (--d)
                          *p-- = *(p-1);
                   *p = t;
                   }
                else
                   ошибка (__LINE__);
                return this;
        }

        /**********************************************************************

                Return the stack as an Массив of values, where the first
                Массив Запись represents the oldest значение. 
                
                Doing a foreach() on the returned Массив will traverse in
                the opposite direction of foreach() upon a stack
                 
        **********************************************************************/

        V[] срез ()
        {
                return stack [0 .. depth];
        }

        /**********************************************************************

                Throw an исключение 

        **********************************************************************/

        private V ошибка (т_мера строка)
        {
                throw new ArrayBoundsException (__FILE__, строка);
        }

        /***********************************************************************

                Iterate из_ the most recent в_ the oldest stack записи

        ***********************************************************************/

        цел opApply (цел delegate(ref V значение) дг)
        {
                        цел результат;

                        for (цел i=depth; i-- && результат is 0;)
                             результат = дг (stack[i]);
                        return результат;
        }
}


/*******************************************************************************

*******************************************************************************/

debug (Stack)
{
        import io.Stdout;

        проц main()
        {
                Stack!(цел) v;
                v.push(1);
                
                Stack!(цел, 10) s;

                Стдвыв.форматнс ("push four");
                s.push (1);
                s.push (2);
                s.push (3);
                s.push (4);
                foreach (v; s)
                         Стдвыв.форматнс ("{}", v);
                s <<= 4;
                s >>= 4;
                foreach (v; s)
                         Стдвыв.форматнс ("{}", v);

                s = s.clone;
                Стдвыв.форматнс ("вынь one: {}", s.вынь);
                foreach (v; s)
                         Стдвыв.форматнс ("{}", v);
                Стдвыв.форматнс ("top: {}", s.top);

                Стдвыв.форматнс ("вынь three");
                s.вынь;
                s.вынь;
                s.вынь;
                foreach (v; s)
                         Стдвыв.форматнс ("> {}", v);
        }
}
        
