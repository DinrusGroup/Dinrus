/*******************************************************************************

        Copyright: Copyright (C) 2007 Aaron Craelius and Kris Bell  
                   все rights reserved.

        License:   BSD стиль: $(LICENSE)

        version:   Initial release: February 2008      

        Authors:   Aaron, Kris

*******************************************************************************/

module text.xml.Document;

package import text.xml.PullParser;

version(Clear)
        extern (C) ук  memset(ук  s, цел c, т_мера n);

version=discrete;

/*******************************************************************************

        Implements a DOM atop the XML парсер, supporting document 
        parsing, дерево traversal and ad-hoc дерево manИПulation.

        The DOM API is non-conformant, yet simple and functional in 
        стиль - locate a дерево node of interest and operate upon or 
        around it. In все cases you will need a document экземпляр в_ 
        begin, whereupon it may be populated either by parsing an 
        existing document or via API manИПulation.

        This particular DOM employs a simple free-список в_ размести
        each of the дерево nodes, making it quite efficient at parsing
        XML documents. The tradeoff with such a scheme is that copying
        nodes из_ one document в_ другой requires a little ещё care
        than otherwise. We felt this was a reasonable tradeoff, given
        the throughput gains vs the relative infrequency of grafting
        operations. For grafting within or across documents, please
        use the перемести() and копируй() methods.

        другой simplification is related в_ сущность transcoding. This
        is not performed internally, and becomes the responsibility
        of the клиент. That is, the клиент should perform appropriate
        сущность transcoding as necessary. Paying the (high) transcoding 
        cost for все documents doesn't seem appropriate.

        Parse example
        ---
        auto doc = new Документ!(сим);
        doc.разбор (контент);

        auto выведи = new ДокПринтер!(сим);
        Стдвыв(выведи(doc)).нс;
        ---

        API example
        ---
        auto doc = new Документ!(сим);

        // прикрепи an xml заголовок
        doc.заголовок;

        // прикрепи an element with some атрибуты, plus 
        // a ветвь element with an attached данные значение
        doc.дерево.element   (пусто, "element")
                .attribute (пусто, "attrib1", "значение")
                .attribute (пусто, "attrib2")
                .element   (пусто, "ветвь", "значение");

        auto выведи = new ДокПринтер!(сим);
        Стдвыв(выведи(doc)).нс;
        ---

        Note that the document дерево() включает все nodes in the дерево,
        and not just elements. Use doc.elements в_ адрес the topmost
        element instead. For example, добавьing an interior sibling в_
        the prior illustration
        ---
        doc.elements.element (пусто, "sibling");
        ---

        Printing the имя of the topmost (корень) element:
        ---
        Стдвыв.форматнс ("first element is '{}'", doc.elements.имя);
        ---
        
        XPath examples:
        ---
        auto doc = new Документ!(сим);

        // прикрепи an element with some атрибуты, plus 
        // a ветвь element with an attached данные значение
        doc.дерево.element   (пусто, "element")
                .attribute (пусто, "attrib1", "значение")
                .attribute (пусто, "attrib2")
                .element   (пусто, "ветвь", "значение");

        // выбери named-elements
        auto установи = doc.запрос["element"]["ветвь"];

        // выбери все атрибуты named "attrib1"
        установи = doc.запрос.descendant.attribute("attrib1");

        // выбери elements with one предок and a matching текст значение
        установи = doc.запрос[].фильтр((doc.Узел n) {return n.ветви.hasData("значение");});
        ---

        Note that путь queries are temporal - they do not retain контент
        across mulitple queries. That is, the lifetime of a запрос результат
        is limited unless you explicitly копируй it. For example, this will 
        краш
        ---
        auto elements = doc.запрос["element"];
        auto ветви = elements["ветвь"];
        ---

        The above will lose elements because the associated document reuses 
        node пространство for subsequent queries. In order в_ retain results, do this
        ---
        auto elements = doc.запрос["element"].dup;
        auto ветви = elements["ветвь"];
        ---

        The above .dup is generally very small (a установи of pointers only). On
        the другой hand, recursive queries are fully supported
        ---
        установи = doc.запрос[].фильтр((doc.Узел n) {return n.запрос[].счёт > 1;});
        ---

        Typical usage tends в_ follow the following образец, Where each запрос 
        результат is processed before другой is initiated
        ---
        foreach (node; doc.запрос.ветвь("element"))
                {
                // do something with each node
                }
        ---

        Note that the парсер is templated for сим, шим or дим.
            
*******************************************************************************/

class Документ(T) : package PullParser!(T)
{
        public alias NodeImpl*  Узел;

        private Узел            корень; 
        private NodeImpl[]      список;
        private NodeImpl[][]    lists;
        private цел             индекс,
                                chunks,
                                freelists;
        private ПутьРЯР!(T)     xpath;

        /***********************************************************************
        
                Construct a DOM экземпляр. The optional parameter indicates
                the начальное число of nodes assigned в_ the freelist

        ***********************************************************************/

        this (бцел nodes = 1000)
        {
                assert (nodes > 50);
                super (пусто);
                xpath = new ПутьРЯР!(T);

                chunks = nodes;
                newlist;
                корень = размести;
                корень.опр = ПТипУзлаРЯР.Документ;
        }

        /***********************************************************************
        
                Return an xpath укз в_ запрос this document. This starts
                at the document корень.

                See also Узел.запрос

        ***********************************************************************/
        
        final ПутьРЯР!(T).NodeSet запрос ()
        {
                return xpath.старт (корень);
        }

        /***********************************************************************
        
                Return the корень document node, из_ which все другой nodes
                are descended. 

                Returns пусто where there are no nodes in the document

        ***********************************************************************/
        
        final Узел дерево ()
        {
                return корень;
        }

        /***********************************************************************
        
                Return the topmost element node, which is generally the
                корень of the element дерево.

                Returns пусто where there are no top-уровень element nodes

        ***********************************************************************/
        
        final Узел elements ()
        {
                if (корень)
                   {
                   auto node = корень.lastChild;
                   while (node)
                          if (node.опр is ПТипУзлаРЯР.Element)
                              return node;
                          else
                             node = node.prev;
                   }
                return пусто;
        }

        /***********************************************************************
        
                Reset the freelist. Subsequent allocation of document nodes 
                will overwrite prior instances.

        ***********************************************************************/
        
        final Документ сбрось ()
        {
                корень.lastChild = корень.firstChild = пусто;
version(Clear)
{
                while (freelists)
                      {
                      auto список = lists[--freelists];
                      memset (список.ptr, 0, NodeImpl.sizeof * список.length);
                      }
}
else
{
                freelists = 0;
}
                newlist;
                индекс = 1;
version(d)
{
                freelists = 0;          // needed в_ align the codegen!
}
                return this;
        }

        /***********************************************************************
        
               Prepend an XML заголовок в_ the document дерево

        ***********************************************************************/
        
        final Документ заголовок (T[] кодировка = пусто)
        {
                if (кодировка.length)
                    кодировка = `xml version="1.0" кодировка="`~кодировка~`"`;
                else
                   кодировка = `xml version="1.0" кодировка="UTF-8"`;

                корень.приставь (корень.создай(ПТипУзлаРЯР.PI, кодировка));
                return this;
        }

        /***********************************************************************
        
                Parse the given xml контент, which will reuse any existing 
                node within this document. The resultant дерево is retrieved
                via the document 'дерево' attribute

        ***********************************************************************/
        
        final проц разбор(T[] xml)
        {       
                assert (xml);
                сбрось;
                super.сбрось (xml);
                auto тек = корень;
                бцел defNamespace;

                while (да) 
                      {
                      auto p = текст.point;
                      switch (super.следщ) 
                             {
                             case ПТипТокенаРЯР.КонечныйЭлемент:
                             case ПТипТокенаРЯР.ПустойКонечныйЭлемент:
                                  assert (тек.хост);
                                  тек.конец = текст.point;
                                  тек = тек.хост;                      
                                  break;
        
                             case ПТипТокенаРЯР.Данные:
version (discrete)
{
                                  auto node = размести;
                                  node.НеобрValue = super.НеобрValue;
                                  node.опр = ПТипУзлаРЯР.Данные;
                                  тек.добавь (node);
}
else
{
                                  if (тек.НеобрValue.length is 0)
                                      тек.НеобрValue = super.НеобрValue;
                                  else
                                     // multИПle данные sections
                                     тек.данные (super.НеобрValue);
}
                                  break;
        
                             case ПТипТокенаРЯР.НачальныйЭлемент:
                                  auto node = размести;
                                  node.хост = тек;
                                  node.псеп_в_начале = super.префикс;
                                  node.опр = ПТипУзлаРЯР.Element;
                                  node.localName = super.localName;
                                  node.старт = p;
                                
                                  // inline добавь
                                  if (тек.lastChild) 
                                     {
                                     тек.lastChild.nextSibling = node;
                                     node.prevSibling = тек.lastChild;
                                     тек.lastChild = node;
                                     }
                                  else 
                                     {
                                     тек.firstChild = node;
                                     тек.lastChild = node;
                                     }
                                  тек = node;
                                  break;
        
                             case ПТипТокенаРЯР.Атрибут:
                                  auto attr = размести;
                                  attr.псеп_в_начале = super.префикс;
                                  attr.НеобрValue = super.НеобрValue;
                                  attr.localName = super.localName;
                                  attr.опр = ПТипУзлаРЯР.Атрибут;
                                  тек.attrib (attr);
                                  break;
        
                             case ПТипТокенаРЯР.PI:
                                  тек.pi_ (super.НеобрValue, p[0..текст.point-p]);
                                  break;
        
                             case ПТипТокенаРЯР.Комментарий:
                                  тек.comment_ (super.НеобрValue);
                                  break;
        
                             case ПТипТокенаРЯР.СиДанные:
                                  тек.cdata_ (super.НеобрValue);
                                  break;
        
                             case ПТипТокенаРЯР.Доктип:
                                  тек.doctype_ (super.НеобрValue);
                                  break;
        
                             case ПТипТокенаРЯР.Готово:
                                  return;

                             default:
                                  break;
                             }
                      }
        }
        
        /***********************************************************************
        
                размести a node из_ the freelist

        ***********************************************************************/

        private final Узел размести ()
        {
                if (индекс >= список.length)
                    newlist;

                auto p = &список[индекс++];
                p.doc = this;
version(Clear){}
else
{
                p.старт = p.конец = пусто;
                p.хост =
                p.prevSibling = 
                p.nextSibling = 
                p.firstChild =
                p.lastChild = 
                p.firstAttr =
                p.lastAttr = пусто;
                p.НеобрValue = 
                p.localName = 
                p.псеп_в_начале = пусто;
}
                return p;
        }

        /***********************************************************************
        
                размести a node из_ the freelist

        ***********************************************************************/

        private final проц newlist ()
        {
                индекс = 0;
                if (freelists >= lists.length)
                   {
                   lists.length = lists.length + 1;
                   lists[$-1] = new NodeImpl [chunks];
                   }
                список = lists[freelists++];
        }

        /***********************************************************************
        
                foreach support for visiting and selecting nodes. 
                
                A fruct is a low-overhead mechanism for capturing контекст 
                relating в_ an opApply, and we use it here в_ смети nodes
                when testing for various relationshИПs.

                See Узел.атрибуты and Узел.ветви

        ***********************************************************************/
        
        private struct Visitor
        {
                private Узел node;
        
                public alias значение      данные;
                public alias hasValue   hasData;

                /***************************************************************
                
                        Is there anything в_ visit here?

                        Время complexity: O(1)

                ***************************************************************/
        
                бул exist ()
                {
                        return node != пусто;
                }

                /***************************************************************
                
                        traverse sibling nodes

                ***************************************************************/
        
                цел opApply (цел delegate(ref Узел) дг)
                {
                        цел ret;

                        for (auto n=node; n; n = n.nextSibling)
                             if ((ret = дг(n)) != 0) 
                                  break;
                        return ret;
                }

                /***************************************************************
                
                        Locate a node with a matching имя and/or префикс, 
                        and which проходки an optional фильтр. Each of the
                        аргументы will be ignored where they are пусто.

                        Время complexity: O(n)

                ***************************************************************/

                Узел имя (T[] префикс, T[] local, бул delegate(Узел) дг=пусто)
                {
                        for (auto n=node; n; n = n.nextSibling)
                            {
                            if (local.ptr && local != n.localName)
                                continue;

                            if (префикс.ptr && префикс != n.псеп_в_начале)
                                continue;

                            if (дг.ptr && дг(n) is нет)
                                continue;

                            return n;
                            }
                        return пусто;
                }

                /***************************************************************
                
                        Scan nodes for a matching имя and/or префикс. Each 
                        of the аргументы will be ignored where they are пусто.

                        Время complexity: O(n)

                ***************************************************************/
        
                бул hasName (T[] префикс, T[] local)
                {
                        return имя (префикс, local) != пусто;
                }

                /***************************************************************
                
                        Locate a node with a matching имя and/or префикс, 
                        and which matches a specified значение. Each of the
                        аргументы will be ignored where they are пусто.

                        Время complexity: O(n)

                ***************************************************************/
version (Фильтр)
{        
                Узел значение (T[] префикс, T[] local, T[] значение)
                {
                        if (значение.ptr)
                            return имя (префикс, local, (Узел n){return значение == n.НеобрValue;});
                        return имя (префикс, local);
                }
}
                /***************************************************************
        
                        Sweep nodes looking for a match, and returns either 
                        a node or пусто. See значение(x,y,z) or имя(x,y,z) for
                        добавьitional filtering.

                        Время complexity: O(n)

                ***************************************************************/

                Узел значение (T[] match)
                {
                        if (match.ptr)
                            for (auto n=node; n; n = n.nextSibling)
                                 if (match == n.НеобрValue)
                                     return n;
                        return пусто;
                }

                /***************************************************************
                
                        Sweep the nodes looking for a значение match. Returns 
                        да if найдено. See значение(x,y,z) or имя(x,y,z) for
                        добавьitional filtering.

                        Время complexity: O(n)

                ***************************************************************/
        
                бул hasValue (T[] match)
                {
                        return значение(match) != пусто;
                }
        }
        
        
        /***********************************************************************
        
                The node implementation

        ***********************************************************************/
        
        private struct NodeImpl
        {
                public ук             пользователь;           /// открой for usage
                package Документ        doc;            // owning document
                package ПТипУзлаРЯР     опр;             // node тип
                package T[]             псеп_в_начале;       // namespace
                package T[]             localName;      // имя
                package T[]             НеобрValue;       // данные значение
                
                package Узел            хост,           // предок node
                                        prevSibling,    // prior
                                        nextSibling,    // следщ
                                        firstChild,     // голова
                                        lastChild,      // хвост
                                        firstAttr,      // голова
                                        lastAttr;       // хвост

                package T*              конец,            // срез of the  ...
                                        старт;          // original xml текст 

                /***************************************************************
                
                        Return the hosting document

                ***************************************************************/
        
                Документ document () 
                {
                        return doc;
                }
        
                /***************************************************************
                
                        Return the node тип-опр

                ***************************************************************/
        
                ПТипУзлаРЯР тип () 
                {
                        return опр;
                }
        
                /***************************************************************
                
                        Return the предок, which may be пусто

                ***************************************************************/
        
                Узел предок () 
                {
                        return хост;
                }
        
                /***************************************************************
                
                        Return the first ветвь, which may be пусто

                ***************************************************************/
                
                Узел ветвь () 
                {
                        return firstChild;
                }
        
                /***************************************************************
                
                        Return the последний ветвь, which may be пусто

                        Deprecated: exposes too much implementation detail. 
                                    Please файл a ticket if you really need 
                                    this functionality

                ***************************************************************/
        
                deprecated Узел childTail () 
                {
                        return lastChild;
                }
        
                /***************************************************************
                
                        Return the prior sibling, which may be пусто

                ***************************************************************/
        
                Узел prev () 
                {
                        return prevSibling;
                }
        
                /***************************************************************
                
                        Return the следщ sibling, which may be пусто

                ***************************************************************/
        
                Узел следщ () 
                {
                        return nextSibling;
                }
        
                /***************************************************************
                
                        Return the namespace префикс of this node (may be пусто)

                ***************************************************************/
        
                T[] префикс ()
                {
                        return псеп_в_начале;
                }

                /***************************************************************
                
                        Набор the namespace префикс of this node (may be пусто)

                ***************************************************************/
        
                Узел префикс (T[] замени)
                {
                        псеп_в_начале = замени;
                        return this;
                }

                /***************************************************************
                
                        Return the vanilla node имя (sans префикс)

                ***************************************************************/
        
                T[] имя ()
                {
                        return localName;
                }

                /***************************************************************
                
                        Набор the vanilla node имя (sans префикс)

                ***************************************************************/
        
                Узел имя (T[] замени)
                {
                        localName = замени;
                        return this;
                }

                /***************************************************************
                
                        Return the данные контент, which may be пусто

                ***************************************************************/
        
                T[] значение ()
                {
version(discrete)
{
                        if (тип is ПТипУзлаРЯР.Element)
                            foreach (ветвь; ветви)
                                     if (ветвь.опр is ПТипУзлаРЯР.Данные || 
                                         ветвь.опр is ПТипУзлаРЯР.СиДанные)
                                         return ветвь.НеобрValue;
}
                        return НеобрValue;
                }
                
                /***************************************************************
                
                        Набор the необр данные контент, which may be пусто

                ***************************************************************/
        
                проц значение (T[] знач)
                {
version(discrete)
{
                        if (тип is ПТипУзлаРЯР.Element)
                            foreach (ветвь; ветви)
                                     if (ветвь.опр is ПТипУзлаРЯР.Данные)
                                         return ветвь.значение (знач);
}
                        НеобрValue = знач; 
                        mutate;
                }
                
                /***************************************************************
                
                        Return the full node имя, which is a combination 
                        of the префикс & local names. Nodes without a префикс 
                        will return local-имя only

                ***************************************************************/
        
                T[] вТкст (T[] вывод = пусто)
                {
                        if (псеп_в_начале.length)
                           {
                           auto длин = псеп_в_начале.length + localName.length + 1;
                           
                           // is the префикс already attached в_ the имя?
                           if (псеп_в_начале.ptr + псеп_в_начале.length + 1 is localName.ptr &&
                               ':' is *(localName.ptr-1))
                               return псеп_в_начале.ptr [0 .. длин];
       
                           // nope, копируй the discrete segments преобр_в вывод
                           if (вывод.length < длин)
                               вывод.length = длин;
                           вывод[0..псеп_в_начале.length] = псеп_в_начале;
                           вывод[псеп_в_начале.length] = ':';
                           вывод[псеп_в_начале.length+1 .. длин] = localName;
                           return вывод[0..длин];
                           }

                        return localName;
                }
                
                /***************************************************************
                
                        Return the индекс of this node, or как many 
                        prior siblings it есть. 

                        Время complexity: O(n) 

                ***************************************************************/
       
                бцел позиция ()
                {
                        auto счёт = 0;
                        auto prior = prevSibling;
                        while (prior)
                               ++счёт, prior = prior.prevSibling;                        
                        return счёт;
                }
                
                /***************************************************************
                
                        Detach this node из_ its предок and siblings

                ***************************************************************/
        
                Узел открепи ()
                {
                        return удали;
                }

                /***************************************************************
        
                        Return an xpath укз в_ запрос this node

                        See also Документ.запрос

                ***************************************************************/
        
                final ПутьРЯР!(T).NodeSet запрос ()
                {
                        return doc.xpath.старт (this);
                }

                /***************************************************************
                
                        Return a foreach iterator for node ветви

                ***************************************************************/
        
                Visitor ветви () 
                {
                        Visitor v = {firstChild};
                        return v;
                }
        
                /***************************************************************
                
                        Return a foreach iterator for node атрибуты

                ***************************************************************/
        
                Visitor атрибуты () 
                {
                        Visitor v = {firstAttr};
                        return v;
                }
        
                /***************************************************************
                
                        Returns whether there are атрибуты present or not

                        Deprecated: use node.атрибуты.exist instead

                ***************************************************************/
        
                deprecated бул hasAttributes () 
                {
                        return firstAttr !is пусто;
                }
                               
                /***************************************************************
                
                        Returns whether there are ветви present or nor

                        Deprecated: use node.ветвь or node.ветви.exist
                        instead

                ***************************************************************/
        
                deprecated бул hasChildren () 
                {
                        return firstChild !is пусто;
                }
                
                /***************************************************************
                
                        Duplicate the given sub-дерево преобр_в place as a ветвь 
                        of this node. 
                        
                        Returns a reference в_ the subtree

                ***************************************************************/
        
                Узел копируй (Узел дерево)
                {
                        assert (дерево);
                        дерево = дерево.clone;
                        дерево.migrate (document);

                        if (дерево.опр is ПТипУзлаРЯР.Атрибут)
                            attrib (дерево);
                        else
                            добавь (дерево);
                        return дерево;
                }

                /***************************************************************
                
                        Relocate the given sub-дерево преобр_в place as a ветвь 
                        of this node. 
                        
                        Returns a reference в_ the subtree

                ***************************************************************/
        
                Узел перемести (Узел дерево)
                {
                        дерево.открепи;
                        if (дерево.doc is doc)
                           {
                           if (дерево.опр is ПТипУзлаРЯР.Атрибут)
                               attrib (дерево);
                           else
                              добавь (дерево);
                           }
                        else
                           дерево = копируй (дерево);
                        return дерево;
                }

                /***************************************************************
        
                        Appends a new (ветвь) Element and returns a reference 
                        в_ it.

                ***************************************************************/
        
                Узел element (T[] префикс, T[] local, T[] значение = пусто)
                {
                        return element_ (префикс, local, значение).mutate;
                }
        
                /***************************************************************
        
                        Attaches an Атрибут and returns this, the хост 

                ***************************************************************/
        
                Узел attribute (T[] префикс, T[] local, T[] значение = пусто)
                { 
                        return attribute_ (префикс, local, значение).mutate;
                }
        
                /***************************************************************
        
                        Attaches a Данные node and returns this, the хост

                ***************************************************************/
        
                Узел данные (T[] данные)
                {
                        return data_ (данные).mutate;
                }
        
                /***************************************************************
        
                        Attaches a СиДанные node and returns this, the хост

                ***************************************************************/
        
                Узел cdata (T[] cdata)
                {
                        return cdata_ (cdata).mutate;
                }
        
                /***************************************************************
        
                        Attaches a Комментарий node and returns this, the хост

                ***************************************************************/
        
                Узел коммент (T[] коммент)
                {
                        return comment_ (коммент).mutate;
                }
        
                /***************************************************************
        
                        Attaches a Доктип node and returns this, the хост

                ***************************************************************/
        
                Узел doctype (T[] doctype)
                {
                        return doctype_ (doctype).mutate;
                }
        
                /***************************************************************
        
                        Attaches a PI node and returns this, the хост

                ***************************************************************/
        
                Узел pi (T[] pi)
                {
                        return pi_ (pi, пусто).mutate;
                }

                /***************************************************************
        
                        Attaches a ветвь Element, and returns a reference 
                        в_ the ветвь

                ***************************************************************/
        
                private Узел element_ (T[] префикс, T[] local, T[] значение = пусто)
                {
                        auto node = создай (ПТипУзлаРЯР.Element, пусто);
                        добавь (node.установи (префикс, local));
version(discrete)
{
                        if (значение.length)
                            node.data_ (значение);
}
else
{
                        node.НеобрValue = значение;
}
                        return node;
                }
        
                /***************************************************************
        
                        Attaches an Атрибут, and returns the хост

                ***************************************************************/
        
                private Узел attribute_ (T[] префикс, T[] local, T[] значение = пусто)
                { 
                        auto node = создай (ПТипУзлаРЯР.Атрибут, значение);
                        attrib (node.установи (префикс, local));
                        return this;
                }
        
                /***************************************************************
        
                        Attaches a Данные node, and returns the хост

                ***************************************************************/
        
                private Узел data_ (T[] данные)
                {
                        добавь (создай (ПТипУзлаРЯР.Данные, данные));
                        return this;
                }
        
                /***************************************************************
        
                        Attaches a СиДанные node, and returns the хост

                ***************************************************************/
        
                private Узел cdata_ (T[] cdata)
                {
                        добавь (создай (ПТипУзлаРЯР.СиДанные, cdata));
                        return this;
                }
        
                /***************************************************************
        
                        Attaches a Комментарий node, and returns the хост

                ***************************************************************/
        
                private Узел comment_ (T[] коммент)
                {
                        добавь (создай (ПТипУзлаРЯР.Комментарий, коммент));
                        return this;
                }
        
                /***************************************************************
        
                        Attaches a PI node, and returns the хост

                ***************************************************************/
        
                private Узел pi_ (T[] pi, T[] patch)
                {
                        добавь (создай(ПТипУзлаРЯР.PI, pi).patch(patch));
                        return this;
                }
        
                /***************************************************************
        
                        Attaches a Доктип node, and returns the хост

                ***************************************************************/
        
                private Узел doctype_ (T[] doctype)
                {
                        добавь (создай (ПТипУзлаРЯР.Доктип, doctype));
                        return this;
                }
        
                /***************************************************************
                
                        Append an attribute в_ this node, The given attribute
                        cannot have an existing предок.

                ***************************************************************/
        
                private проц attrib (Узел node)
                {
                        assert (node.предок is пусто);
                        node.хост = this;
                        if (lastAttr) 
                           {
                           lastAttr.nextSibling = node;
                           node.prevSibling = lastAttr;
                           lastAttr = node;
                           }
                        else 
                           firstAttr = lastAttr = node;
                }
        
                /***************************************************************
                
                        Append a node в_ this one. The given node cannot
                        have an existing предок.

                ***************************************************************/
        
                private проц добавь (Узел node)
                {
                        assert (node.предок is пусто);
                        node.хост = this;
                        if (lastChild) 
                           {
                           lastChild.nextSibling = node;
                           node.prevSibling = lastChild;
                           lastChild = node;
                           }
                        else 
                           firstChild = lastChild = node;                  
                }

                /***************************************************************
                
                        Prepend a node в_ this one. The given node cannot
                        have an existing предок.

                ***************************************************************/
        
                private проц приставь (Узел node)
                {
                        assert (node.предок is пусто);
                        node.хост = this;
                        if (firstChild) 
                           {
                           firstChild.prevSibling = node;
                           node.nextSibling = firstChild;
                           firstChild = node;
                           }
                        else 
                           firstChild = lastChild = node;
                }
                
                /***************************************************************
        
                        Configure node values
        
                ***************************************************************/
        
                private Узел установи (T[] префикс, T[] local)
                {
                        this.localName = local;
                        this.псеп_в_начале = префикс;
                        return this;
                }
        
                /***************************************************************
        
                        Creates and returns a ветвь Element node

                ***************************************************************/
        
                private Узел создай (ПТипУзлаРЯР тип, T[] значение)
                {
                        auto node = document.размести;
                        node.НеобрValue = значение;
                        node.опр = тип;
                        return node;
                }
        
                /***************************************************************
                
                        Detach this node из_ its предок and siblings

                ***************************************************************/
        
                private Узел удали()
                {
                        if (! хост) 
                              return this;
                        
                        mutate;
                        if (prevSibling && nextSibling) 
                           {
                           prevSibling.nextSibling = nextSibling;
                           nextSibling.prevSibling = prevSibling;
                           prevSibling = пусто;
                           nextSibling = пусто;
                           хост = пусто;
                           }
                        else 
                           if (nextSibling)
                              {
                              debug assert(хост.firstChild == this);
                              предок.firstChild = nextSibling;
                              nextSibling.prevSibling = пусто;
                              nextSibling = пусто;
                              хост = пусто;
                              }
                           else 
                              if (тип != ПТипУзлаРЯР.Атрибут)
                                 {
                                 if (prevSibling)
                                    {
                                    debug assert(хост.lastChild == this);
                                    хост.lastChild = prevSibling;
                                    prevSibling.nextSibling = пусто;
                                    prevSibling = пусто;
                                    хост = пусто;
                                    }
                                 else
                                    {
                                    debug assert(хост.firstChild == this);
                                    debug assert(хост.lastChild == this);
                                    хост.firstChild = пусто;
                                    хост.lastChild = пусто;
                                    хост = пусто;
                                    }
                                 }
                              else
                                 {
                                 if (prevSibling)
                                    {
                                    debug assert(хост.lastAttr == this);
                                    хост.lastAttr = prevSibling;
                                    prevSibling.nextSibling = пусто;
                                    prevSibling = пусто;
                                    хост = пусто;
                                    }
                                 else
                                    {
                                    debug assert(хост.firstAttr == this);
                                    debug assert(хост.lastAttr == this);
                                    хост.firstAttr = пусто;
                                    хост.lastAttr = пусто;
                                    хост = пусто;
                                    }
                                 }

                        return this;
                }

                /***************************************************************
        
                        Patch the serialization текст, causing ДокПринтер
                        в_ ignore the subtree of this node, and instead
                        излей the provопрed текст as необр XML вывод.

                        Предупреждение: this function does *not* копируй the provопрed 
                        текст, and may be removed из_ future revisions

                ***************************************************************/
        
                private Узел patch (T[] текст)
                {
                        конец = текст.ptr + текст.length;
                        старт = текст.ptr;
                        return this;
                }
        
                /***************************************************************

                        purge serialization cache for this node and its
                        ancestors

                ***************************************************************/
        
                private Узел mutate ()
                {
                        auto node = this;
                        do {
                           node.конец = пусто;
                           } while ((node = node.хост) !is пусто);

                        return this;
                }

                /***************************************************************
                
                        Duplicate a single node

                ***************************************************************/
        
                private Узел dup ()
                {
                        return создай(тип, НеобрValue.dup).установи(псеп_в_начале.dup, localName.dup);
                }

                /***************************************************************
                
                        Duplicate a subtree

                ***************************************************************/
        
                private Узел clone ()
                {
                        auto p = dup;

                        foreach (attr; атрибуты)
                                 p.attrib (attr.dup);
                        foreach (ветвь; ветви)
                                 p.добавь (ветвь.clone);
                        return p;
                }

                /***************************************************************

                        Reset the document хост for this subtree

                ***************************************************************/
        
                private проц migrate (Документ хост)
                {
                        this.doc = хост;
                        foreach (attr; атрибуты)
                                 attr.migrate (хост);
                        foreach (ветвь; ветви)
                                 ветвь.migrate (хост);
                }
        }
}


/*******************************************************************************

        XPath support 

        Provопрes support for common XPath axis and filtering functions,
        via a исконный-D interface instead of typical interpreted notation.

        The general опрea here is в_ generate a NodeSet consisting of those
        дерево-nodes which satisfy a filtering function. The direction, or
        axis, of дерево traversal is governed by one of several predefined
        operations. все methods facilitiate вызов-chaining, where each step 
        returns a new NodeSet экземпляр в_ be operated upon.

        The установи of nodes themselves are collected in a freelist, avoопрing
        куча-activity and making good use of D Массив-slicing facilities.

        XPath examples
        ---
        auto doc = new Документ!(сим);

        // прикрепи an element with some атрибуты, plus 
        // a ветвь element with an attached данные значение
        doc.дерево.element   (пусто, "element")
                .attribute (пусто, "attrib1", "значение")
                .attribute (пусто, "attrib2")
                .element   (пусто, "ветвь", "значение");

        // выбери named-elements
        auto установи = doc.запрос["element"]["ветвь"];

        // выбери все атрибуты named "attrib1"
        установи = doc.запрос.descendant.attribute("attrib1");

        // выбери elements with one предок and a matching текст значение
        установи = doc.запрос[].фильтр((doc.Узел n) {return n.ветви.hasData("значение");});
        ---

        Note that путь queries are temporal - they do not retain контент
        across mulitple queries. That is, the lifetime of a запрос результат
        is limited unless you explicitly копируй it. For example, this will 
        краш в_ operate as one might expect
        ---
        auto elements = doc.запрос["element"];
        auto ветви = elements["ветвь"];
        ---

        The above will lose elements, because the associated document reuses 
        node пространство for subsequent queries. In order в_ retain results, do this
        ---
        auto elements = doc.запрос["element"].dup;
        auto ветви = elements["ветвь"];
        ---

        The above .dup is generally very small (a установи of pointers only). On
        the другой hand, recursive queries are fully supported
        ---
        установи = doc.запрос[].фильтр((doc.Узел n) {return n.запрос[].счёт > 1;});
        ---
  
        Typical usage tends в_ exhibit the following образец, Where each запрос 
        результат is processed before другой is initiated
        ---
        foreach (node; doc.запрос.ветвь("element"))
                {
                // do something with each node
                }
        ---

        Supported axis include:
        ---
        .ветвь                  immediate ветви
        .предок                 immediate предок 
        .следщ                   following siblings
        .prev                   prior siblings
        .ancestor               все parents
        .descendant             все descendants
        .данные                   текст ветви
        .cdata                  cdata ветви
        .attribute              attribute ветви
        ---

        Each of the above прими an optional ткст, which is used in an
        axis-specific way в_ фильтр nodes. For экземпляр, a .ветвь("food") 
        will фильтр <food> ветвь elements. These variants are shortcuts
        в_ using a фильтр в_ post-process a результат. Each of the above also
        have variants which прими a delegate instead.

        In general, you traverse an axis and operate upon the results. The
        operation applied may be другой axis traversal, or a filtering 
        step. все steps can be, and generally should be chained together. 
        Filters are implemented via a delegate mechanism
        ---
        .фильтр (бул delegate(Узел))
        ---

        Where the delegate returns да if the node проходки the фильтр. An
        example might be selecting все nodes with a specific attribute
        ---
        auto установи = doc.запрос.descendant.фильтр (
                    (doc.Узел n){return n.атрибуты.hasName (пусто, "тест");}
                   );
        ---

        Obviously this is not as clean and tопрy as да XPath notation, but 
        that can be wrapped atop this API instead. The benefit here is one 
        of необр throughput - important for some applications. 

        Note that every operation returns a discrete результат. Methods first()
        and последний() also return a установи of one or zero elements. Some language
        specific extensions are provопрed for too
        ---
        * .ветвь() can be substituted with [] notation instead

        * [] notation can be used в_ индекс a specific element, like .nth()

        * the .nodes attribute exposes an underlying Узел[], which may be
          sliced or traversed in the usual D manner
        ---

       Other (запрос результат) utility methods include
       ---
       .dup
       .first
       .последний
       .opIndex
       .nth
       .счёт
       .opApply
       ---

       ПутьРЯР itself needs в_ be a class in order в_ avoопр forward-ref issues.

*******************************************************************************/

private class ПутьРЯР(T)
{       
        public alias Документ!(T) Док;          /// the typed document
        public alias Док.Узел     Узел;         /// generic document node
         
        private Узел[]          freelist;
        private бцел            freeIndex,
                                markIndex;
        private бцел            recursion;

        /***********************************************************************
        
                Prime a запрос

                Returns a NodeSet containing just the given node, which
                can then be used в_ cascade results преобр_в subsequent NodeSet
                instances.

        ***********************************************************************/
        
        final NodeSet старт (Узел корень)
        {
                // we have в_ support recursion which may occur within
                // a фильтр обрвызов
                if (recursion is 0)
                   {
                   if (freelist.length is 0)
                       freelist.length = 256;
                   freeIndex = 0;
                   }

                NodeSet установи = {this};
                auto mark = freeIndex;
                размести(корень);
                return установи.присвой (mark);
        }

        /***********************************************************************
        
                This is the meat of XPath support. все of the NodeSet
                operators exist here, in order в_ enable вызов-chaining.

                Note that some of the axis do дво-duty as a фильтр 
                also. This is just a convenience factor, and doesn't 
                change the underlying mechanisms.

        ***********************************************************************/
        
        struct NodeSet
        {
                private ПутьРЯР хост;
                public  Узел[]  nodes;  /// Массив of selected nodes
               
                /***************************************************************
        
                        Return a duplicate NodeSet

                ***************************************************************/
        
                NodeSet dup ()
                {
                        NodeSet копируй = {хост};
                        копируй.nodes = nodes.dup;
                        return копируй;
                }

                /***************************************************************
        
                        Return the число of selected nodes in the установи

                ***************************************************************/
        
                бцел счёт ()
                {
                        return nodes.length;
                }

                /***************************************************************
        
                        Return a установи containing just the first node of
                        the current установи

                ***************************************************************/
        
                NodeSet first ()
                {
                        return nth (0);
                }

                /***************************************************************
       
                        Return a установи containing just the последний node of
                        the current установи

                ***************************************************************/
        
                NodeSet последний ()
                {       
                        auto i = nodes.length;
                        if (i > 0)
                            --i;
                        return nth (i);
                }

                /***************************************************************
        
                        Return a установи containing just the nth node of
                        the current установи

                ***************************************************************/
        
                NodeSet opIndex (бцел i)
                {
                        return nth (i);
                }

                /***************************************************************
        
                        Return a установи containing just the nth node of
                        the current установи
        
                ***************************************************************/
        
                NodeSet nth (бцел индекс)
                {
                        NodeSet установи = {хост};
                        auto mark = хост.mark;
                        if (индекс < nodes.length)
                            хост.размести (nodes [индекс]);
                        return установи.присвой (mark);
                }

                /***************************************************************
        
                        Return a установи containing все ветвь elements of the 
                        nodes within this установи
        
                ***************************************************************/
        
                NodeSet opSlice ()
                {
                        return ветвь();
                }

                /***************************************************************
        
                        Return a установи containing все ветвь elements of the 
                        nodes within this установи, which match the given имя

                ***************************************************************/
        
                NodeSet opIndex (T[] имя)
                {
                        return ветвь (имя);
                }

                /***************************************************************
        
                        Return a установи containing все предок elements of the 
                        nodes within this установи, which match the optional имя

                ***************************************************************/
        
                NodeSet предок (T[] имя = пусто)
                {
                        if (имя.ptr)
                            return предок ((Узел node){return node.имя == имя;});
                        return предок (&always);
                }

                /***************************************************************
        
                        Return a установи containing все данные nodes of the 
                        nodes within this установи, which match the optional
                        значение

                ***************************************************************/
        
                NodeSet данные (T[] значение = пусто)
                {
                        if (значение.ptr)
                            return ветвь ((Узел node){return node.значение == значение;}, 
                                           ПТипУзлаРЯР.Данные);
                        return ветвь (&always, ПТипУзлаРЯР.Данные);
                }

                /***************************************************************
        
                        Return a установи containing все cdata nodes of the 
                        nodes within this установи, which match the optional
                        значение

                ***************************************************************/
        
                NodeSet cdata (T[] значение = пусто)
                {
                        if (значение.ptr)
                            return ветвь ((Узел node){return node.значение == значение;}, 
                                           ПТипУзлаРЯР.СиДанные);
                        return ветвь (&always, ПТипУзлаРЯР.СиДанные);
                }

                /***************************************************************
        
                        Return a установи containing все атрибуты of the 
                        nodes within this установи, which match the optional
                        имя

                ***************************************************************/
        
                NodeSet attribute (T[] имя = пусто)
                {
                        if (имя.ptr)
                            return attribute ((Узел node){return node.имя == имя;});
                        return attribute (&always);
                }

                /***************************************************************
        
                        Return a установи containing все descendant elements of 
                        the nodes within this установи, which match the given имя

                ***************************************************************/
        
                NodeSet descendant (T[] имя = пусто)
                {
                        if (имя.ptr)
                            return descendant ((Узел node){return node.имя == имя;});
                        return descendant (&always);
                }

                /***************************************************************
        
                        Return a установи containing все ветвь elements of the 
                        nodes within this установи, which match the optional имя

                ***************************************************************/
        
                NodeSet ветвь (T[] имя = пусто)
                {
                        if (имя.ptr)
                            return ветвь ((Узел node){return node.имя == имя;});
                        return  ветвь (&always);
                }

                /***************************************************************
        
                        Return a установи containing все ancestor elements of 
                        the nodes within this установи, which match the optional
                        имя

                ***************************************************************/
        
                NodeSet ancestor (T[] имя = пусто)
                {
                        if (имя.ptr)
                            return ancestor ((Узел node){return node.имя == имя;});
                        return ancestor (&always);
                }

                /***************************************************************
        
                        Return a установи containing все prior sibling elements of 
                        the nodes within this установи, which match the optional
                        имя

                ***************************************************************/
        
                NodeSet prev (T[] имя = пусто)
                {
                        if (имя.ptr)
                            return prev ((Узел node){return node.имя == имя;});
                        return prev (&always);
                }

                /***************************************************************
        
                        Return a установи containing все subsequent sibling 
                        elements of the nodes within this установи, which 
                        match the optional имя

                ***************************************************************/
        
                NodeSet следщ (T[] имя = пусто)
                {
                        if (имя.ptr)
                            return следщ ((Узел node){return node.имя == имя;});
                        return следщ (&always);
                }

                /***************************************************************
        
                        Return a установи containing все nodes within this установи
                        which пароль the filtering тест

                ***************************************************************/
        
                NodeSet фильтр (бул delegate(Узел) фильтр)
                {
                        NodeSet установи = {хост};
                        auto mark = хост.mark;

                        foreach (node; nodes)
                                 тест (фильтр, node);
                        return установи.присвой (mark);
                }

                /***************************************************************
        
                        Return a установи containing все ветвь nodes of 
                        the nodes within this установи which пароль the 
                        filtering тест

                ***************************************************************/
        
                NodeSet ветвь (бул delegate(Узел) фильтр, 
                               ПТипУзлаРЯР тип = ПТипУзлаРЯР.Element)
                {
                        NodeSet установи = {хост};
                        auto mark = хост.mark;

                        foreach (предок; nodes)
                                 foreach (ветвь; предок.ветви)
                                          if (ветвь.опр is тип)
                                              тест (фильтр, ветвь);
                        return установи.присвой (mark);
                }

                /***************************************************************
        
                        Return a установи containing все attribute nodes of 
                        the nodes within this установи which пароль the given
                        filtering тест

                ***************************************************************/
        
                NodeSet attribute (бул delegate(Узел) фильтр)
                {
                        NodeSet установи = {хост};
                        auto mark = хост.mark;

                        foreach (node; nodes)
                                 foreach (attr; node.атрибуты)
                                          тест (фильтр, attr);
                        return установи.присвой (mark);
                }

                /***************************************************************
        
                        Return a установи containing все descendant nodes of 
                        the nodes within this установи, which пароль the given
                        filtering тест

                ***************************************************************/
        
                NodeSet descendant (бул delegate(Узел) фильтр, 
                                    ПТипУзлаРЯР тип = ПТипУзлаРЯР.Element)
                {
                        проц traverse (Узел предок)
                        {
                                 foreach (ветвь; предок.ветви)
                                         {
                                         if (ветвь.опр is тип)
                                             тест (фильтр, ветвь);
                                         if (ветвь.firstChild)
                                             traverse (ветвь);
                                         }                                                
                        }

                        NodeSet установи = {хост};
                        auto mark = хост.mark;

                        foreach (node; nodes)
                                 traverse (node);
                        return установи.присвой (mark);
                }

                /***************************************************************
        
                        Return a установи containing все предок nodes of 
                        the nodes within this установи which пароль the given
                        filtering тест

                ***************************************************************/
        
                NodeSet предок (бул delegate(Узел) фильтр)
                {
                        NodeSet установи = {хост};
                        auto mark = хост.mark;

                        foreach (node; nodes)
                                {
                                auto p = node.предок;
                                if (p && p.опр != ПТипУзлаРЯР.Документ && !установи.есть(p))
                                   {
                                   тест (фильтр, p);
                                   // continually обнови our установи of nodes, so
                                   // that установи.есть() can see a prior Запись.
                                   // Ideally we'd avoопр invoking тест() on
                                   // prior nodes, but I don't feel the добавьed
                                   // complexity is warranted
                                   установи.nodes = хост.срез (mark);
                                   }
                                }
                        return установи.присвой (mark);
                }

                /***************************************************************
        
                        Return a установи containing все ancestor nodes of 
                        the nodes within this установи, which пароль the given
                        filtering тест

                ***************************************************************/
        
                NodeSet ancestor (бул delegate(Узел) фильтр)
                {
                        NodeSet установи = {хост};
                        auto mark = хост.mark;

                        проц traverse (Узел ветвь)
                        {
                                auto p = ветвь.хост;
                                if (p && p.опр != ПТипУзлаРЯР.Документ && !установи.есть(p))
                                   {
                                   тест (фильтр, p);
                                   // continually обнови our установи of nodes, so
                                   // that установи.есть() can see a prior Запись.
                                   // Ideally we'd avoопр invoking тест() on
                                   // prior nodes, but I don't feel the добавьed
                                   // complexity is warranted
                                   установи.nodes = хост.срез (mark);
                                   traverse (p);
                                   }
                        }

                        foreach (node; nodes)
                                 traverse (node);
                        return установи.присвой (mark);
                }

                /***************************************************************
        
                        Return a установи containing все following siblings 
                        of the ones within this установи, which пароль the given
                        filtering тест

                ***************************************************************/
        
                NodeSet следщ (бул delegate(Узел) фильтр, 
                              ПТипУзлаРЯР тип = ПТипУзлаРЯР.Element)
                {
                        NodeSet установи = {хост};
                        auto mark = хост.mark;

                        foreach (node; nodes)
                                {
                                auto p = node.nextSibling;
                                while (p)
                                      {
                                      if (p.опр is тип)
                                          тест (фильтр, p);
                                      p = p.nextSibling;
                                      }
                                }
                        return установи.присвой (mark);
                }

                /***************************************************************
        
                        Return a установи containing все prior sibling nodes 
                        of the ones within this установи, which пароль the given
                        filtering тест

                ***************************************************************/
        
                NodeSet prev (бул delegate(Узел) фильтр, 
                              ПТипУзлаРЯР тип = ПТипУзлаРЯР.Element)
                {
                        NodeSet установи = {хост};
                        auto mark = хост.mark;

                        foreach (node; nodes)
                                {
                                auto p = node.prevSibling;
                                while (p)
                                      {
                                      if (p.опр is тип)
                                          тест (фильтр, p);
                                      p = p.prevSibling;
                                      }
                                }
                        return установи.присвой (mark);
                }

                /***************************************************************
                
                        Traverse the nodes of this установи

                ***************************************************************/
        
                цел opApply (цел delegate(ref Узел) дг)
                {
                        цел ret;

                        foreach (node; nodes)
                                 if ((ret = дг (node)) != 0) 
                                      break;
                        return ret;
                }

                /***************************************************************
        
                        Common predicate
                                
                ***************************************************************/
        
                private бул always (Узел node)
                {
                        return да;
                }

                /***************************************************************
        
                        Assign a срез of the freelist в_ this NodeSet

                ***************************************************************/
        
                private NodeSet присвой (бцел mark)
                {
                        nodes = хост.срез (mark);
                        return *this;
                }

                /***************************************************************
        
                        Execute a фильтр on the given node. We have в_
                        deal with potential запрос recusion, so we установи
                        все kinda crap в_ recover из_ that

                ***************************************************************/
        
                private проц тест (бул delegate(Узел) фильтр, Узел node)
                {
                        auto вынь = хост.push;
                        auto добавь = фильтр (node);
                        хост.вынь (вынь);
                        if (добавь)
                            хост.размести (node);
                }

                /***************************************************************
        
                        We typically need в_ фильтр ancestors in order
                        в_ avoопр duplicates, so this is used for those
                        purposes                        

                ***************************************************************/
        
                private бул есть (Узел p)
                {
                        foreach (node; nodes)
                                 if (node is p)
                                     return да;
                        return нет;
                }
        }

        /***********************************************************************

                Return the current freelist индекс
                        
        ***********************************************************************/
        
        private бцел mark ()
        {       
                return freeIndex;
        }

        /***********************************************************************

                Recurse and save the current состояние
                        
        ***********************************************************************/
        
        private бцел push ()
        {       
                ++recursion;
                return freeIndex;
        }

        /***********************************************************************

                Restore prior состояние
                        
        ***********************************************************************/
        
        private проц вынь (бцел prior)
        {       
                freeIndex = prior;
                --recursion;
        }

        /***********************************************************************
        
                Return a срез of the freelist

        ***********************************************************************/
        
        private Узел[] срез (бцел mark)
        {
                assert (mark <= freeIndex);
                return freelist [mark .. freeIndex];
        }

        /***********************************************************************
        
                Размести an Запись in the freelist, expanding as necessary

        ***********************************************************************/
        
        private бцел размести (Узел node)
        {
                if (freeIndex >= freelist.length)
                    freelist.length = freelist.length + freelist.length / 2;

                freelist[freeIndex] = node;
                return ++freeIndex;
        }
}


version (Old)
{
/*******************************************************************************

        Specification for an XML serializer

*******************************************************************************/

interface IXmlPrinter(T)
{
        public alias Документ!(T) Док;          /// the typed document
        public alias Док.Узел Узел;             /// generic document node
        public alias выведи opCall;              /// alias for выведи метод

        /***********************************************************************
        
                Generate a текст representation of the document дерево

        ***********************************************************************/
        
        T[] выведи (Док doc);
        
        /***********************************************************************
        
                Generate a representation of the given node-subtree 

        ***********************************************************************/
        
        проц выведи (Узел корень, проц delegate(T[][]...) излей);
}
}



/*******************************************************************************

*******************************************************************************/

debug (Документ)
{
        import io.Stdout;
        import text.xml.DocPrinter;

        проц main()
        {
                auto doc = new Документ!(сим);

                // прикрепи an xml заголовок
                doc.заголовок;

                // прикрепи an element with some атрибуты, plus 
                // a ветвь element with an attached данные значение
                doc.дерево.element   (пусто, "корень")
                        .attribute (пусто, "attrib1", "значение")
                        .attribute (пусто, "attrib2", "другой")
                        .element   (пусто, "ветвь")
                        .cdata     ("some текст");

                // прикрепи a sibling в_ the interior elements
                doc.elements.element (пусто, "sibling");
        
                бул foo (doc.Узел node)
                {
                        node = node.атрибуты.имя(пусто, "attrib1");
                        return node && "значение" == node.значение;
                }

                foreach (node; doc.запрос.descendant("корень").фильтр(&foo).ветвь)
                         Стдвыв.форматнс(">> {}", node.имя);

                foreach (node; doc.elements.атрибуты)
                         Стдвыв.форматнс("<< {}", node.имя);
                         
                foreach (node; doc.elements.ветви)
                         Стдвыв.форматнс("<< {}", node.имя);
                         
                foreach (node; doc.запрос.descendant.cdata)
                         Стдвыв.форматнс ("{}: {}", node.предок.имя, node.значение);

                // излей the результат
                auto printer = new ДокПринтер!(сим);
                printer.выведи (doc, стдвыв);
                doc.сбрось;
        }
}
