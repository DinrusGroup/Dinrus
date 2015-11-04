/*******************************************************************************

        copyright:      Copyright (c) 2009 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        May 2009: Initial release

        since:          0.99.9

        author:         Kris

*******************************************************************************/

module text.Search;

private import Util = text.Util;

/******************************************************************************

        Returns a lightweight образец matcher, good for крат образцы 
        and/or крат в_ medium length контент. Brute-force approach with
        fast multi-байт comparisons

******************************************************************************/

FindFruct!(T) найди(T) (T[] what)
{
        return FindFruct!(T) (what);
}

/******************************************************************************

        Returns a welterweight образец matcher, good for дол образцы 
        and/or extensive контент. Based on the QS algorithm which is a
        Boyer-Moore variant. Does not размести память for the alphabet.

        Generally becomes faster as the match-length grows

******************************************************************************/

SearchFruct!(T) search(T) (T[] what)
{
        return SearchFruct!(T) (what);
}

/******************************************************************************

        Convenient bundle of lightweight найди utilities, without the
        hassle of IFTI problems. Create one of these using the найди() 
        function:
        ---
        auto match = найди ("foo");
        auto контент = "wumpus foo bar"

        // search in the forward direction
        auto индекс = match.forward (контент);
        assert (индекс is 7);

        // search again - returns length when no match найдено
        assert (match.forward(контент, индекс+1) is контент.length);
        ---

        Searching operates Всё forward and backward, with an optional
        старт смещение (can be ещё convenient than slicing the контент).
        There are methods в_ замени matches within given контент, and 
        другие which return foreach() iterators for traversing контент.

        SearchFruct is a ещё sophisticated variant, which operates ещё
        efficiently on longer matches and/or ещё extensive контент.

******************************************************************************/

private struct FindFruct(T)
{       
        private T[] what;

        /***********************************************************************

                Search forward in the given контент, starting at the 
                optional индекс.

                Returns the индекс of a match, or контент.length where
                no match was located.

        ***********************************************************************/

        т_мера forward (T[] контент, т_мера ofs = 0)
        {
                return Util.индекс (контент, what, ofs);
        }

        /***********************************************************************

                Search backward in the given контент, starting at the 
                optional индекс.

                Returns the индекс of a match, or контент.length where
                no match was located.

        ***********************************************************************/

        т_мера реверс (T[] контент, т_мера ofs = т_мера.max)
        {       
                return Util.rindex (контент, what, ofs);
        }

        /***********************************************************************

                Return the match текст

        ***********************************************************************/

        T[] match ()
        {
                return what;
        }

        /***********************************************************************

                Reset the текст в_ match

        ***********************************************************************/

        проц match (T[] what)
        {
                this.what = what;
        }

        /***********************************************************************

                Returns да if there is a match within the given контент

        ***********************************************************************/

        бул within (T[] контент)
        {       
                return forward(контент) != контент.length;
        }

        /***********************************************************************
                
                Returns число of matches within the given контент

        ***********************************************************************/

        т_мера счёт (T[] контент)
        {       
                т_мера mark, счёт;

                while ((mark = Util.индекс (контент, what, mark)) != контент.length)
                        ++счёт, ++mark;
                return счёт;
        }

        /***********************************************************************

                Замени все matches with the given character. Use метод
                семы() instead в_ avoопр куча activity.

                Returns a копируй of the контент with replacements made

        ***********************************************************************/

        T[] замени (T[] контент, T chr)
        {     
                return замени (контент, (&chr)[0..1]);  
        }

        /***********************************************************************

                Замени все matches with the given substitution. Use 
                метод семы() instead в_ avoопр куча activity.

                Returns a копируй of the контент with replacements made

        ***********************************************************************/

        T[] замени (T[] контент, T[] sub = пусто)
        {  
                T[] вывод;

                foreach (s; семы (контент, sub))
                         вывод ~= s;
                return вывод;
        }

        /***********************************************************************

                Returns a foreach() iterator which exposes текст segments
                between все matches within the given контент. Substitution
                текст is also injected in place of each match, and пусто can
                be used в_ indicate removal instead:
                ---
                ткст результат;

                auto match = найди ("foo");
                foreach (token; match.семы ("$foo&&foo*", "bar"))
                         результат ~= token;
                assert (результат == "$bar&&bar*");
                ---
                
                This mechanism avoопрs internal куча activity.                

        ***********************************************************************/

        Util.PatternFruct!(T) семы (T[] контент, T[] sub = пусто)
        {
                return Util.образцы (контент, what, sub);
        }
        
        /***********************************************************************

                Returns a foreach() iterator which exposes the indices of
                все matches within the given контент:
                ---
                цел счёт;

                auto f = найди ("foo");
                foreach (индекс; f.indices("$foo&&foo*"))
                         ++счёт;
                assert (счёт is 2);
                ---

        ***********************************************************************/

        Indices indices (T[] контент)
        {
                return Indices (what, контент);
        }
 
        /***********************************************************************

                Simple foreach() iterator

        ***********************************************************************/

        private struct Indices
        {
                T[]     what,
                        контент;

                цел opApply (цел delegate (ref т_мера индекс) дг)
                {
                        цел    ret;
                        т_мера mark;

                        while ((mark = Util.индекс(контент, what, mark)) != контент.length)                        
                                if ((ret = дг(mark)) is 0)                                
                                     ++mark;       
                                else
                                   break;                        
                        return ret;   
                }     
        } 
}


/******************************************************************************

        Convenient bundle of welterweight search utilities, without the
        hassle of IFTI problems. Create one of these using the search() 
        function:
        ---
        auto match = search ("foo");
        auto контент = "wumpus foo bar"

        // search in the forward direction
        auto индекс = match.forward (контент);
        assert (индекс is 7);

        // search again - returns length when no match найдено
        assert (match.forward(контент, индекс+1) is контент.length);
        ---

        Searching operates Всё forward and backward, with an optional
        старт смещение (can be ещё convenient than slicing the контент).
        There are methods в_ замени matches within given контент, and 
        другие which return foreach() iterators for traversing контент.

        FindFruct is a simpler variant, which can operate efficiently on 
        крат matches and/or крат контент (employs brute-force strategy)

******************************************************************************/

private struct SearchFruct(T)
{
        private T[]             what;
        private бул            fore;
        private цел[256]        offsets =void;

        /***********************************************************************

                Construct the fruct

        ***********************************************************************/

        static SearchFruct opCall (T[] what) 
        {
                SearchFruct найди =void;
                найди.match = what;
                return найди;
        }
        
        /***********************************************************************

                Return the match текст

        ***********************************************************************/

        T[] match ()
        {
                return what;
        }

        /***********************************************************************

                Reset the текст в_ match

        ***********************************************************************/

        проц match (T[] what)
        {
                offsets[] = what.length + 1;
                this.fore = да;
                this.what = what;
                сбрось;
        }

        /***********************************************************************

                Search forward in the given контент, starting at the 
                optional индекс.

                Returns the индекс of a match, or контент.length where
                no match was located.

        ***********************************************************************/

        т_мера forward (T[] контент, т_мера ofs = 0) 
        {
                if (! fore)
                      флип;

                if (ofs > контент.length)
                    ofs = контент.length;

                return найди (cast(сим*) what.ptr, what.length * T.sizeof, 
                             cast(сим*) контент.ptr, контент.length * T.sizeof, 
                             ofs * T.sizeof) / T.sizeof;
        }

        /***********************************************************************

                Search backward in the given контент, starting at the 
                optional индекс.

                Returns the индекс of a match, or контент.length where
                no match was located.

        ***********************************************************************/

        т_мера реверс (T[] контент, т_мера ofs = т_мера.max) 
        {
                if (fore)
                    флип;

                if (ofs > контент.length)
                    ofs = контент.length;

                return найдрек (cast(сим*) what.ptr, what.length * T.sizeof, 
                              cast(сим*) контент.ptr, контент.length * T.sizeof, 
                              ofs * T.sizeof) / T.sizeof;
        }

        /***********************************************************************

                Returns да if there is a match within the given контент

        ***********************************************************************/

        бул within (T[] контент)
        {       
                return forward(контент) != контент.length;
        }

        /***********************************************************************
                
                Returns число of matches within the given контент

        ***********************************************************************/

        т_мера счёт (T[] контент)
        {       
                т_мера mark, счёт;

                while ((mark = forward (контент, mark)) != контент.length)
                        ++счёт, ++mark;
                return счёт;
        }

        /***********************************************************************

                Замени все matches with the given character. Use метод
                семы() instead в_ avoопр куча activity.

                Returns a копируй of the контент with replacements made

        ***********************************************************************/

        T[] замени (T[] контент, T chr)
        {     
                return замени (контент, (&chr)[0..1]);  
        }

        /***********************************************************************

                Замени все matches with the given substitution. Use 
                метод семы() instead в_ avoопр куча activity.

                Returns a копируй of the контент with replacements made

        ***********************************************************************/

        T[] замени (T[] контент, T[] sub = пусто)
        {  
                T[] вывод;

                foreach (s; семы (контент, sub))
                         вывод ~= s;
                return вывод;
        }

        /***********************************************************************

                Returns a foreach() iterator which exposes текст segments
                between все matches within the given контент. Substitution
                текст is also injected in place of each match, and пусто can
                be used в_ indicate removal instead:
                ---
                ткст результат;

                auto match = search ("foo");
                foreach (token; match.семы("$foo&&foo*", "bar"))
                         результат ~= token;
                assert (результат == "$bar&&bar*");
                ---
                
                This mechanism avoопрs internal куча activity             

        ***********************************************************************/

        Substitute семы (T[] контент, T[] sub = пусто)
        {
                return Substitute (sub, what, контент, &forward);
        }
        
        /***********************************************************************

                Returns a foreach() iterator which exposes the indices of
                все matches within the given контент:
                ---
                цел счёт;

                auto match = search ("foo");
                foreach (индекс; match.indices("$foo&&foo*"))
                         ++счёт;
                assert (счёт is 2);
                ---

        ***********************************************************************/

        Indices indices (T[] контент)
        {
                return Indices (контент, &forward);
        }
        
        /***********************************************************************

        ***********************************************************************/

        private т_мера найди (сим* what, т_мера wlen, сим* контент, т_мера длин, т_мера ofs) 
        {
                auto s = контент;
                контент += ofs;
                auto e = s + длин - wlen;
                while (контент <= e)
                       if (*what is *контент && matches(what, контент, wlen))
                           return контент - s;
                       else
                          контент += offsets [контент[wlen]];
                return длин;
        }

        /***********************************************************************

        ***********************************************************************/

        private т_мера найдрек (сим* what, т_мера wlen, сим* контент, т_мера длин, т_мера ofs) 
        {
                auto s = контент;
                auto e = s + ofs - wlen;
                while (e >= контент)
                       if (*what is *e && matches(what, e, wlen))
                           return e - s;
                       else
                          e -= offsets [*(e-1)];
                return длин;
        }

        /***********************************************************************

        ***********************************************************************/

        private static бул matches (сим* a, сим* b, т_мера length)
        {
                while (length > т_мера.sizeof)
                       if (*cast(т_мера*) a is *cast(т_мера*) b)
                            a += т_мера.sizeof, b += т_мера.sizeof, length -= т_мера.sizeof;
                       else
                          return нет;

                while (length--)
                       if (*a++ != *b++) 
                           return нет;
                return да;
        }

        /***********************************************************************

                Construct отыщи table. We force the alphabet в_ be ткст
                always, and consопрer wопрer characters в_ be longer образцы
                instead

        ***********************************************************************/

        private проц сбрось ()
        {
                auto what = cast(ткст) this.what;
                if (fore)   
                    for (цел i=0; i < what.length; ++i)
                         offsets[what[i]] = what.length - i;
                else
                   for (цел i=what.length; i--;)
                        offsets[what[i]] = i+1;
        }

        /***********************************************************************

                Реверсни отыщи-table direction

        ***********************************************************************/

        private проц флип ()
        {
                fore ^= да;
                сбрось;
        }

        /***********************************************************************

                Simple foreach() iterator

        ***********************************************************************/

        private struct Indices
        {
                T[]    контент;
                т_мера delegate(T[], т_мера) вызов;

                цел opApply (цел delegate (ref т_мера индекс) дг)
                {
                        цел     ret;
                        т_мера  mark;

                        while ((mark = вызов(контент, mark)) != контент.length)
                                if ((ret = дг(mark)) is 0)
                                     ++mark;
                                else
                                   break;
                        return ret;   
                }     
        } 

        /***********************************************************************

                Substitution foreach() iterator

        ***********************************************************************/

        private struct Substitute
        {
                private T[] sub, 
                            what,
                            контент;
                т_мера      delegate(T[], т_мера) вызов;

                цел opApply (цел delegate (ref T[] token) дг)
                {
                        бцел    ret,
                                поз,
                                mark;
                        T[]     token;

                        while ((поз = вызов (контент, mark)) < контент.length)
                              {
                              token = контент [mark .. поз];
                              if ((ret = дг(token)) != 0)
                                   return ret;
                              if (sub.ptr && (ret = дг(sub)) != 0)
                                  return ret;
                              mark = поз + what.length;
                              }

                        token = контент [mark .. $];
                        if (mark <= контент.length)
                            ret = дг (token);
                        return ret;
                }
        }
}




/******************************************************************************

******************************************************************************/

debug (Search)
{
        import io.Stdout;
        import time.StopWatch;

        auto x = import("Search.d");
        
        проц main()
        {
                Секундомер elapsed;
        
                auto match = search("foo");
                auto индекс = match.реверс ("foo foo");
                assert (индекс is 4);
                индекс = match.реверс ("foo foo", индекс);
                assert (индекс is 0);
                индекс = match.реверс ("foo foo", 1);
                assert (индекс is 7);

                foreach (индекс; найди("delegate").indices(x))
                         Стдвыв.форматнс ("< {}", индекс);

                foreach (индекс; search("delegate").indices(x))
                         Стдвыв.форматнс ("> {}", индекс);

                elapsed.старт;
                for (auto i=5000; i--;)
                     Util.не_совпадают (x.ptr, x.ptr, x.length);
                Стдвыв.форматнс ("не_совпадают {}", elapsed.stop);

                elapsed.старт;
                for (auto i=5000; i--;)
                     Util.indexOf (x.ptr, '@', cast(бцел) x.length);
                Стдвыв.форматнс ("indexOf {}", elapsed.stop);

                elapsed.старт;
                for (auto i=5000; i--;)
                     Util.locatePattern (x, "indexOf {}");
                Стдвыв.форматнс ("образец {}", elapsed.stop);

                elapsed.старт;
                auto f = найди ("indexOf {}");
                for (auto i=5000; i--;)
                     f.forward(x);
                Стдвыв.форматнс ("найди {}", elapsed.stop);

                elapsed.старт;
                auto s = search ("indexOf {}");
                for (auto i=5000; i--;)
                     s.forward(x);
                Стдвыв.форматнс ("search {}", elapsed.stop);
        }
}

