/*******************************************************************************
 
        Copyright: Copyright (C) 2007 Aaron Craelius and Kris Bell  
                   все rights reserved.

        License:   BSD стиль: $(LICENSE)

        version:   Initial release: February 2008      

        Authors:   Aaron, Kris

*******************************************************************************/

module text.xml.PullParser;

private import text.Util : indexOf;

private import exception : ИсклРЯР ;

private import Целое = text.convert.Integer;

private import Utf = text.convert.Utf : вТкст;

/*******************************************************************************

        Use -version=пробел в_ retain пробел as данные nodes. We
        see a %25 increase in token счёт and 10% throughput drop when
        parsing "hamlet.xml" with this опция включен (pullparser alone)

*******************************************************************************/

version (пробел)
         version = retainwhite;
else
   {
   version = strИПwhite;
   version = partialwhite;
   }

/*******************************************************************************

        The XML node типы 

*******************************************************************************/

public enum ПТипУзлаРЯР {Element, Данные, Атрибут, СиДанные, 
                         Комментарий, PI, Доктип, Документ};

/*******************************************************************************

        Values returned by the pull-парсер

*******************************************************************************/

public enum ПТипТокенаРЯР {Готово, НачальныйЭлемент, Атрибут, КонечныйЭлемент, 
                          ПустойКонечныйЭлемент, Данные, Комментарий, СиДанные, 
                          Доктип, PI, Нет};


/*******************************************************************************

        Токен based xml Parser.  Templated в_ operate with ткст, шим[], 
        and дим[] контент. 

        The парсер is constructed with some tradeoffs relating в_ document
        integrity. It is generally optimized for well-formed documents, and
        currently may читай past a document-конец for those that are not well
        formed. There are various compilation options в_ enable checks and
        balances, depending on как things should be handled. We'll settle
        on a common configuration over the следщ few weeks, but for сейчас все
        settings are somewhat experimental. Partly because making some tiny 
        unrelated change в_ the код can cause notable throughput changes, 
        and we need в_ track that down.

        We're not yet сотри why these swings are so pronounced (for changes
        outsопрe the код путь) but they seem в_ be related в_ the alignment
        of codegen. It could be a cache-строка issue, or something else. We'll
        figure it out, yet it's interesting that some hardware buttons are 
        clearly being pushed

*******************************************************************************/

class PullParser(Ch = сим)
{
        public цел                      depth;
        public Ch[]                     префикс;    
        public Ch[]                     НеобрValue;
        public Ch[]                     localName;     
        public ПТипТокенаРЯР             тип = ПТипТокенаРЯР.Нет;

        package XmlText!(Ch)            текст;
        private бул                    поток;
        private ткст                  ошСооб;

        /***********************************************************************
                
                Construct a парсер on the given контент (may be пусто)

        ***********************************************************************/

        this(Ch[] контент = пусто)
        {
                сбрось (контент);
        }
   
        /***********************************************************************
        
                Consume the следщ token and return its тип

        ***********************************************************************/

        final ПТипТокенаРЯР следщ()
        {
                auto e = текст.конец;
                auto p = текст.point;
        
                // at конец of document?
                if (p >= e)
                    return endOfInput;
version (strИПwhite)
{
                // strip leading пробел
                while (*p <= 32)
                       if (++p >= e)                                      
                           return endOfInput;
}                
                // НачальныйЭлемент or Атрибут?
                if (тип < ПТипТокенаРЯР.КонечныйЭлемент) 
                   {
version (retainwhite)
{
                   // strip leading пробел (thanks в_ DRK)
                   while (*p <= 32)
                          if (++p >= e)                                      
                              return endOfInput;
}                
                   switch (*p)
                          {
                          case '>':
                               // termination of НачальныйЭлемент
                               ++depth;
                               ++p;
                               break;

                          case '/':
                               // пустой element closure
                               текст.point = p;
                               return doEndEmptyElement;
 
                          default:
                               // must be attribute instead
                               текст.point = p;
                               return doAttributeName;
                          }
                   }

                // используй данные between elements?
                if (*p != '<') 
                   {
                   auto q = p;
                   while (++p < e && *p != '<') {}

                   if (p < e)
                      {
version (partialwhite)
{
                      // include leading пробел
                      while (*(q-1) <= 32)
                             --q;
}                
                      текст.point = p;
                      НеобрValue = q [0 .. p - q];
                      return тип = ПТипТокенаРЯР.Данные;
                      }
                   return endOfInput;
                   }

                // must be a '<' character, so Просмотр ahead
                switch (p[1])
                       {
                       case '!':
                            // one of the following ...
                            if (p[2..4] == "--") 
                               {
                               текст.point = p + 4;
                               return doComment;
                               }       
                            else 
                               if (p[2..9] == "[CDATA[") 
                                  {
                                  текст.point = p + 9;
                                  return doCData;
                                  }
                               else 
                                  if (p[2..9] == "DOCTYPE") 
                                     {
                                     текст.point = p + 9;
                                     return doDoctype;
                                     }
                            return doUnexpected("!", p);

                       case '\?':
                            // must be PI данные
                            текст.point = p + 2;
                            return doPI;

                       case '/':
                            // should be a closing element имя
                            p += 2;
                            auto q = p;
                            while (*q > 63 || текст.имя[*q]) 
                                   ++q;

                            if (*q is ':') 
                               {
                               префикс = p[0 .. q - p];
                               p = ++q;
                               while (*q > 63 || текст.attributeName[*q])
                                      ++q;

                               localName = p[0 .. q - p];
                               }
                            else 
                               {
                               префикс = пусто;
                               localName = p[0 .. q - p];
                               }

                            while (*q <= 32) 
                                   if (++q >= e)        
                                       return endOfInput;

                            if (*q is '>')
                               {
                               --depth;
                               текст.point = q + 1;
                               return тип = ПТипТокенаРЯР.КонечныйЭлемент;
                               }
                            return doExpected(">", q);

                       default:
                            // скан new element имя
                            auto q = ++p;
                            while (*q > 63 || текст.имя[*q]) 
                                   ++q;

                            // check if we ran past the конец
                            if (q >= e)
                                return endOfInput;

                            if (*q != ':') 
                               {
                               префикс = пусто;
                               localName = p [0 .. q - p];
                               }
                            else
                               {
                               префикс = p[0 .. q - p];
                               p = ++q;
                               while (*q > 63 || текст.attributeName[*q])
                                      ++q;
                               localName = p[0 .. q - p];
                               }  
                                                      
                            текст.point = q;
                            return тип = ПТипТокенаРЯР.НачальныйЭлемент;
                       }
        }

        /***********************************************************************
        
        ***********************************************************************/

        private ПТипТокенаРЯР doAttributeName()
        {
                auto p = текст.point;
                auto q = p;
                auto e = текст.конец;

                while (*q > 63 || текст.attributeName[*q])
                       ++q;
                if (q >= e)
                    return endOfInput;

                if (*q is ':')
                   {
                   префикс = p[0 .. q - p];
                   p = ++q;

                   while (*q > 63 || текст.attributeName[*q])
                          ++q;

                   localName = p[0 .. q - p];
                   }
                else 
                   {
                   префикс = пусто;
                   localName = p[0 .. q - p];
                   }
                
                if (*q <= 32) 
                   {
                   while (*++q <= 32) {}
                   if (q >= e)
                       return endOfInput;
                   }

                if (*q is '=')
                   {
                   while (*++q <= 32) {}
                   if (q >= e)
                       return endOfInput;

                   auto quote = *q;
                   switch (quote)
                          {
                          case '"':
                          case '\'':
                               p = q + 1;
                               while (*++q != quote) {}
                               if (q < e)
                                  {
                                  НеобрValue = p[0 .. q - p];
                                  текст.point = q + 1;   // пропусти конец quote
                                  return тип = ПТипТокенаРЯР.Атрибут;
                                  }
                               return endOfInput; 

                          default: 
                               return doExpected("\' or \"", q);
                          }
                   }
                
                return doExpected ("=", q);
        }

        /***********************************************************************
        
        ***********************************************************************/

        private ПТипТокенаРЯР doEndEmptyElement()
        {
                if (текст.point[0] is '/' && текст.point[1] is '>')
                   {
                   localName = префикс = пусто;
                   текст.point += 2;
                   return тип = ПТипТокенаРЯР.ПустойКонечныйЭлемент;
                   }
                return doExpected("/>", текст.point);               
       }
        
        /***********************************************************************
        
        ***********************************************************************/

        private ПТипТокенаРЯР doComment()
        {
                auto e = текст.конец;
                auto p = текст.point;
                auto q = p;
                
                while (p < e)
                      {
                      while (*p != '-')
                             if (++p >= e)
                                 return endOfInput;

                      if (p[0..3] == "-->") 
                         {
                         текст.point = p + 3;
                         НеобрValue = q [0 .. p - q];
                         return тип = ПТипТокенаРЯР.Комментарий;
                         }
                      ++p;
                      }

                return endOfInput;
        }
        
        /***********************************************************************
        
        ***********************************************************************/

        private ПТипТокенаРЯР doCData()
        {
                auto e = текст.конец;
                auto p = текст.point;
                
                while (p < e)
                      {
                      auto q = p;
                      while (*p != ']')
                             if (++p >= e)
                                 return endOfInput;
                
                      if (p[0..3] == "]]>") 
                         {
                         текст.point = p + 3;                      
                         НеобрValue = q [0 .. p - q];
                         return тип = ПТипТокенаРЯР.СиДанные;
                         }
                      ++p;
                      }

                return endOfInput;
        }
        
        /***********************************************************************
        
        ***********************************************************************/

        private ПТипТокенаРЯР doPI()
        {
                auto e = текст.конец;
                auto p = текст.point;
                auto q = p;

                while (p < e)
                      {
                      while (*p != '\?')
                             if (++p >= e)
                                 return endOfInput;

                      if (p[1] == '>') 
                         {
                         НеобрValue = q [0 .. p - q];
                         текст.point = p + 2;
                         return тип = ПТипТокенаРЯР.PI;
                         }
                      ++p;
                      }
                return endOfInput;
        }
        
        /***********************************************************************
        
        ***********************************************************************/

        private ПТипТокенаРЯР doDoctype()
        {
                auto e = текст.конец;
                auto p = текст.point;

                // strip leading пробел
                while (*p <= 32)
                       if (++p >= e)                                      
                           return endOfInput;
                
                auto q = p;              
                while (p < e) 
                      {
                      if (*p is '>') 
                         {
                         НеобрValue = q [0 .. p - q];
                         префикс = пусто;
                         текст.point = p + 1;
                         return тип = ПТипТокенаРЯР.Доктип;
                         }
                      else 
                         {
                         if (*p == '[') 
                             do {
                                if (++p >= e)
                                    return endOfInput;
                                } while (*p != ']');
                         ++p;
                         }
                      }

                if (p >= e)
                    return endOfInput;
                return ПТипТокенаРЯР.Доктип;
        }
        
        /***********************************************************************
        
        ***********************************************************************/

        private ПТипТокенаРЯР endOfInput ()
        {
                if (depth && (поток is нет))
                    ошибка ("Unexpected EOF");

                return ПТипТокенаРЯР.Готово;
        }
        
        /***********************************************************************
        
        ***********************************************************************/

        private ПТипТокенаРЯР doUnexpected (ткст сооб, Ch* p)
        {
                return позиция ("разбор ошибка :: unexpected  " ~ сооб, p);
        }
        
        /***********************************************************************
        
        ***********************************************************************/

        private ПТипТокенаРЯР doExpected (ткст сооб, Ch* p)
        {
                сим[6] врем =void;
                return позиция ("разбор ошибка :: ожидалось  " ~ сооб ~ " instead of " ~ Utf.вТкст(p[0..1], врем), p);
        }
        
        /***********************************************************************
        
        ***********************************************************************/

        private ПТипТокенаРЯР позиция (ткст сооб, Ch* p)
        {
                return ошибка (сооб ~ " at позиция " ~ Целое.вТкст(p-текст.текст.ptr));
        }

        /***********************************************************************
        
        ***********************************************************************/

        protected final ПТипТокенаРЯР ошибка (ткст сооб)
        {
                ошСооб = сооб;
                throw new ИсклРЯР  (сооб);
        }

        /***********************************************************************
        
                Return the необр значение of the current token

        ***********************************************************************/

        final Ch[] значение()
        {
                return НеобрValue;
        }
        
        /***********************************************************************
        
                Return the имя of the current token

        ***********************************************************************/

        final Ch[] имя()
        {
                if (префикс.length)
                    return префикс ~ ":" ~ localName;
                return localName;
        }
                
        /***********************************************************************
        
                Returns the текст of the последний ошибка

        ***********************************************************************/

        final ткст ошибка()
        {
                return ошСооб;
        }

        /***********************************************************************
        
                Reset the парсер

        ***********************************************************************/

        final бул сбрось()
        {
                текст.сбрось (текст.текст);
                reset_;
                return да;
        }
        
        /***********************************************************************
                
                Reset парсер with new контент

        ***********************************************************************/

        final проц сбрось(Ch[] newText)
        {
                текст.сбрось (newText);
                reset_;                
        }
        
        /***********************************************************************
        
                experimental: установи Потокing режим

                Use at your own risk, may be removed.

        ***********************************************************************/

        final проц incremental (бул да = да)
        {
                поток = да;
        }
        
        /***********************************************************************
        
        ***********************************************************************/

        private проц reset_()
        {
                depth = 0;
                ошСооб = пусто;
                тип = ПТипТокенаРЯР.Нет;

                auto p = текст.point;
                if (p)
                   {
                   static if (Ch.sizeof == 1)
                          {
                          // используй UTF8 мпб
                          if (p[0] is 0xef && p[1] is 0xbb && p[2] is 0xbf)
                              p += 3;
                          }
                
                   //TODO enable optional declaration parsing
                   auto e = текст.конец;
                   while (p < e && *p <= 32)
                          ++p;
                
                   if (p < e)
                       if (p[0] is '<' && p[1] is '\?' && p[2..5] == "xml")
                          {
                          p += 5;
                          while (p < e && *p != '\?') 
                                 ++p;
                          p += 2;
                          }
                   текст.point = p;
                   }
        }
}


/*******************************************************************************

*******************************************************************************/

package struct XmlText(Ch)
{
        package Ch*     конец;
        package т_мера  длин;
        package Ch[]    текст;
        package Ch*     point;

        final проц сбрось(Ch[] newText)
        {
                this.текст = newText;
                this.длин = newText.length;
                this.point = текст.ptr;
                this.конец = point + длин;
        }

        static const ббайт имя[64] =
        [
             // 0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F
                0,  1,  1,  1,  1,  1,  1,  1,  1,  0,  0,  1,  1,  0,  1,  1,  // 0
                1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  // 1
                0,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  0,  // 2
                1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  0,  1,  1,  1,  0,  0   // 3
        ];

        static const ббайт attributeName[64] =
        [
             // 0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F
                0,  1,  1,  1,  1,  1,  1,  1,  1,  0,  0,  1,  1,  0,  1,  1,  // 0
                1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  // 1
                0,  0,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  0,  // 2
                1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  0,  1,  0,  0,  0,  0   // 3
        ];
}

/*******************************************************************************

*******************************************************************************/

debug (UnitTest)
{
	/***********************************************************************
	
	***********************************************************************/
	
	проц testParser(Ch)(PullParser!(Ch) itr)
	{
	  /*      assert(itr.следщ);
	        assert(itr.значение == "");
	        assert(itr.тип == ПТипТокенаРЯР.Declaration, Целое.вТкст(itr.тип));
	        assert(itr.следщ);
	        assert(itr.значение == "version");
	        assert(itr.следщ);
	        assert(itr.значение == "1.0");*/
	        assert(itr.следщ);
	        assert(itr.значение == "element [ <!ELEMENT element (#PCDATA)>]");
	        assert(itr.тип == ПТипТокенаРЯР.Доктип);
	        assert(itr.следщ);
	        assert(itr.localName == "element");
	        assert(itr.тип == ПТипТокенаРЯР.НачальныйЭлемент);
	        assert(itr.depth == 0);
	        assert(itr.следщ);
	        assert(itr.localName == "attr");
	        assert(itr.значение == "1");
	        assert(itr.следщ);
	        assert(itr.тип == ПТипТокенаРЯР.Атрибут);
	        assert(itr.localName == "attr2");
	        assert(itr.значение == "two");
	        assert(itr.следщ);
	        assert(itr.значение == "коммент");
	        assert(itr.следщ);
	        assert(itr.НеобрValue == "тест&amp;&#x5a;");
	        assert(itr.следщ);
	        assert(itr.префикс == "qual");
	        assert(itr.localName == "elem");
	        assert(itr.следщ);
	        assert(itr.тип == ПТипТокенаРЯР.ПустойКонечныйЭлемент);
	        assert(itr.следщ);
	        assert(itr.localName == "el2");
	        assert(itr.depth == 1);
	        assert(itr.следщ);
	        assert(itr.localName == "attr3");
	        assert(itr.значение == "3three", itr.значение);
	        assert(itr.следщ);
	        assert(itr.НеобрValue == "sdlgjsh");
	        assert(itr.следщ);
	        assert(itr.localName == "el3");
	        assert(itr.depth == 2);
	        assert(itr.следщ);
	        assert(itr.тип == ПТипТокенаРЯР.ПустойКонечныйЭлемент);
	        assert(itr.следщ);
	        assert(itr.значение == "данные");
	        assert(itr.следщ);
	      //  assert(itr.qvalue == "pi", itr.qvalue);
	      //  assert(itr.значение == "тест");
	        assert(itr.НеобрValue == "pi тест", itr.НеобрValue);
	        assert(itr.следщ);
	        assert(itr.localName == "el2");
	        assert(itr.следщ);
	        assert(itr.localName == "element");
	        assert(!itr.следщ);
	}
	
	
	/***********************************************************************
	
	***********************************************************************/
	
	static const ткст testXML = "<?xml version=\"1.0\" ?><!DOCTYPE element [ <!ELEMENT element (#PCDATA)>]><element "
	    "attr=\"1\" attr2=\"two\"><!--коммент-->тест&amp;&#x5a;<qual:elem /><el2 attr3 = "
	    "'3three'><![CDATA[sdlgjsh]]><el3 />данные<?pi тест?></el2></element>";
	
	unittest
	{       
	        auto itr = new PullParser!(сим)(testXML);     
	        testParser (itr);
	}
}
