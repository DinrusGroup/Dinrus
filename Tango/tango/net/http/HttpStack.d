/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)
        
        version:        Initial release: April 2004      
        
        author:         Kris, John Reimer

*******************************************************************************/

module net.http.HttpStack;

private import  exception;

/******************************************************************************

        Unix doesn't appear в_ have a memicmp() ... JJR notes that the
        strncasecmp() is available instead.

******************************************************************************/

version (Win32)
        {
        extern (C) цел memicmp (сим *, сим *, бцел);
        }

version (Posix) 
        {
        extern (C) цел strncasecmp (сим *, сим*, бцел);
        }

extern (C) ук  memmove (ук  приёмн, ук  ист, цел n);


/******************************************************************************

        Internal representation of a token

******************************************************************************/

class Токен
{
        private ткст значение;

        Токен установи (ткст значение)
        {
                this.значение = значение;
                return this;
        }

        ткст вТкст ()
        {
                return значение;
        }
}

/******************************************************************************

        A stack of Tokens, used for capturing http заголовки. The семы
        themselves are typically mapped onto the контент of a Буфер, 
        or some другой external контент, so there's minimal allocation 
        involved (typically zero).

******************************************************************************/

class HttpStack
{
        private цел     depth;
        private Токен[] семы;

        private static const цел MaxHttpStackSize = 256;

        /**********************************************************************

                Construct a HttpStack with the specified начальное размер. 
                The stack will later be resized as necessary.

        **********************************************************************/

        this (цел размер = 10)
        {
                семы = new Токен[0];
                resize (семы, размер);
        }

        /**********************************************************************

                Clone this stack of семы

        **********************************************************************/

        HttpStack clone ()
        {
                // установи a new HttpStack of the same depth
                HttpStack clone = new HttpStack(depth);
                
                clone.depth = depth;

                // duplicate the контент of each original token
                for (цел i=0; i < depth; ++i)
                     clone.семы[i].установи (семы[i].вТкст().dup);

                return clone;
        }

        /**********************************************************************

                Iterate over все семы in stack

        **********************************************************************/

        цел opApply (цел delegate(ref Токен) дг)
        {
                цел результат = 0;

                for (цел i=0; i < depth; ++i)
                     if ((результат = дг (семы[i])) != 0)
                          break;
                return результат;
        }

        /**********************************************************************

                Pop the stack все the way back в_ zero

        **********************************************************************/

        final проц сбрось ()
        {
                depth = 0;
        }

        /**********************************************************************

                Scan the семы looking for the first one with a matching
                имя. Returns the matching Токен, or пусто if there is no
                such match.

        **********************************************************************/

        final Токен найдиТокен (ткст match)
        {
                Токен tok;

                for (цел i=0; i < depth; ++i)
                    {
                    tok = семы[i];
                    if (совпадает (tok, match))
                        return tok;
                    }
                return пусто;
        }

        /**********************************************************************

                Scan the семы looking for the first one with a matching
                имя, and удали it. Returns да if a match was найдено, or
                нет if not.

        **********************************************************************/

        final бул удалиТокен (ткст match)
        {
                for (цел i=0; i < depth; ++i)
                     if (совпадает (семы[i], match))
                        {
                        семы[i].значение = пусто;
                        return да;
                        }
                return нет;
        }

        /**********************************************************************

                Return the current stack depth

        **********************************************************************/

        final цел размер ()
        {       
                return depth;
        }

        /**********************************************************************

                Push a new token onto the stack, and установи it контент в_ 
                that provопрed. Returns the new Токен.

        **********************************************************************/

        final Токен сунь (ткст контент)
        {
                return сунь().установи (контент);  
        }

        /**********************************************************************

                Push a new token onto the stack, and установи it контент в_ 
                be that of the specified token. Returns the new Токен.

        **********************************************************************/

        final Токен push (ref Токен token)
        {
                return push (token.вТкст());  
        }

        /**********************************************************************

                Push a new token onto the stack, and return it.

        **********************************************************************/

        final Токен push ()
        {
                if (depth == семы.length)
                    resize (семы, depth * 2);
                return семы[depth++];
        }

        /**********************************************************************

                Pop the stack by one.

        **********************************************************************/

        final проц вынь ()
        {
                if (depth)
                    --depth;
                else
                   throw new ВВИскл ("illegal attempt в_ вынь Токен stack");
        }

        /**********************************************************************

                See if the given token matches the specified текст. The 
                two must match the minimal протяженность exactly.

        **********************************************************************/

        final static бул совпадает (ref Токен token, ткст match)
        {
                ткст мишень = token.вТкст();

                цел length = мишень.length;
                if (length > match.length)
                    length = match.length;

                if (length is 0)
                    return нет;

                version (Win32)
                         return memicmp (мишень.ptr, match.ptr, length) is 0;
                version (Posix)
                         return strncasecmp (мишень.ptr, match.ptr, length) is 0;
        }
        
        /**********************************************************************

                Resize this stack by extending the Массив.

        **********************************************************************/

        final static проц resize (ref Токен[] семы, цел размер)
        {
                цел i = семы.length;

                // this should *never* realistically happen 
                if (размер > MaxHttpStackSize)
                    throw new ВВИскл ("Токен stack exceeds maximum depth");

                for (семы.length=размер; i < семы.length; ++i)
                     семы[i] = new Токен();
        }
}
