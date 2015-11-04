/*******************************************************************************

        Copyright: Copyright (C) 2008 Kris Bell.  все rights reserved.

        License:   BSD стиль: $(LICENSE)

        version:   Initial release: March 2008      

        Authors:   Kris

*******************************************************************************/

module text.xml.DocPrinter;

private import io.model;

private import text.xml.Document;

/*******************************************************************************

        Simple Документ printer, with support for serialization caching 
        where the latter avoопрs having в_ generate unchanged sub-trees

*******************************************************************************/

class ДокПринтер(T)
{
        public alias Документ!(T) Док;          /// the typed document
        public alias Док.Узел Узел;             /// generic document node

        private бул быстро = да;
        private бцел indentation = 2;

        version (Win32)
                 private const T[] Кс = "\r\n";
           else
              private const T[] Кс = "\n";

        /***********************************************************************
        
                Sets the число of пробелы used when increasing indentation
                levels. Use a значение of zero в_ disable explicit formatting

        ***********************************************************************/
        
        final ДокПринтер indent (бцел indentation)
        {       
                this.indentation = indentation;
                return this;
        }

        /***********************************************************************

                Enable or disable use of cached document snИПpets. These
                represent document branches that remain unaltered, and
                can be излейted verbatim instead of traversing the дерево
                        
        ***********************************************************************/
        
        final ДокПринтер cache (бул да)
        {       
                this.быстро = да;
                return this;
        }

        /***********************************************************************
        
                Generate a текст representation of the document дерево

        ***********************************************************************/
        
        final T[] выведи (Док doc, T[] контент=пусто)
        {                      
                if(контент !is пусто)  
                    выведи (doc.дерево, (T[][] s...)
                        {
                            т_мера i=0; 
                            foreach(t; s) 
                            { 
                                if(i+t.length >= контент.length) 
                                    throw new ИсклРЯР ("Буфер is в_ small"); 
                                
                                контент[i..t.length] = t; 
                                i+=t.length; 
                            } 
                            контент.length = i; 
                        });
                else
                    выведи (doc.дерево, (T[][] s...){foreach(t; s) контент ~= t;});
                return контент;
        }
        
        /***********************************************************************
        
                Generate a текст representation of the document дерево

        ***********************************************************************/
        
        final проц выведи (Док doc, ИПотокВывода поток)
        {       
                выведи (doc.дерево, (T[][] s...){foreach(t; s) поток.пиши(t);});
        }
        
        /***********************************************************************
        
                Generate a representation of the given node-subtree 

        ***********************************************************************/
        
        final проц выведи (Узел корень, проц delegate(T[][]...) излей)
        {
                T[256] врем;
                T[256] пробелы = ' ';

                // ignore пробел из_ mixed-model values
                T[] НеобрValue (Узел node)
                {
                        foreach (c; node.НеобрValue)
                                 if (c > 32)
                                     return node.НеобрValue;
                        return пусто;
                }

                проц printNode (Узел node, бцел indent)
                {
                        // check for cached вывод
                        if (node.конец && быстро)
                           {
                           auto p = node.старт;
                           auto l = node.конец - p;
                           // nasty hack в_ retain пробел while
                           // dodging prior КонечныйЭлемент instances
                           if (*p is '>')
                               ++p, --l;
                           излей (p[0 .. l]);
                           }
                        else
                        switch (node.опр)
                               {
                               case ПТипУзлаРЯР.Документ:
                                    foreach (n; node.ветви)
                                             printNode (n, indent);
                                    break;
        
                               case ПТипУзлаРЯР.Element:
                                    if (indentation > 0)
                                        излей (Кс, пробелы[0..indent]);
                                    излей ("<", node.вТкст(врем));

                                    foreach (attr; node.атрибуты)
                                             излей (` `, attr.вТкст(врем), `="`, attr.НеобрValue, `"`);  

                                    auto значение = НеобрValue (node);
                                    if (node.ветвь)
                                       {
                                       излей (">");
                                       if (значение.length)
                                           излей (значение);
                                       foreach (ветвь; node.ветви)
                                                printNode (ветвь, indent + indentation);
                                        
                                       // inhibit нс if we're closing Данные
                                       if (node.lastChild.опр != ПТипУзлаРЯР.Данные && indentation > 0)
                                           излей (Кс, пробелы[0..indent]);
                                       излей ("</", node.вТкст(врем), ">");
                                       }
                                    else 
                                       if (значение.length)
                                           излей (">", значение, "</", node.вТкст(врем), ">");
                                       else
                                          излей ("/>");      
                                    break;
        
                                    // ingore пробел данные in mixed-model
                                    // <foo>
                                    //   <bar>blah</bar>
                                    //
                                    // a пробел Данные экземпляр follows <foo>
                               case ПТипУзлаРЯР.Данные:
                                    auto значение = НеобрValue (node);
                                    if (значение.length)
                                        излей (node.НеобрValue);
                                    break;
        
                               case ПТипУзлаРЯР.Комментарий:
                                    излей ("<!--", node.НеобрValue, "-->");
                                    break;
        
                               case ПТипУзлаРЯР.PI:
                                    излей ("<?", node.НеобрValue, "?>");
                                    break;
        
                               case ПТипУзлаРЯР.СиДанные:
                                    излей ("<![CDATA[", node.НеобрValue, "]]>");
                                    break;
        
                               case ПТипУзлаРЯР.Доктип:
                                    излей ("<!DOCTYPE ", node.НеобрValue, ">");
                                    break;

                               default:
                                    излей ("<!-- неизвестное node тип -->");
                                    break;
                               }
                }
        
                printNode (корень, 0);
        }
}


debug import text.xml.Document;
debug import util.log.Trace;

unittest
{

    ткст document = "<blah><xml>foo</xml></blah>";

    auto doc = new Документ!(сим);
    doc.разбор (document);

    auto p = new ДокПринтер!(сим);
    сим[1024] буф;
    auto newbuf = p.выведи (doc, буф);
    assert(document == newbuf);
    assert(буф.ptr == newbuf.ptr);
    assert(document == p.выведи(doc));
    

}
