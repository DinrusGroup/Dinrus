/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Mar 2004: Initial release
                        Dec 2006: Outback release

        authors:        Kris

*******************************************************************************/

module io.device.Array;

private import exception;

private import io.device.Conduit;

/******************************************************************************

******************************************************************************/

extern (C)
{
        protected проц * memcpy (проц *приёмн, проц *ист, т_мера);
}

/*******************************************************************************

        Массив manИПulation typically involves appending, as in the
        following example:
        ---
        // создай a small буфер
        auto буф = new Массив (256);

        auto foo = "в_ пиши some D";

        // добавь some текст directly в_ it
        буф.добавь ("сейчас is the время for все good men ").добавь(foo);
        ---

        Alternatively, one might use a форматёр в_ добавь контент:
        ---
        auto вывод = new ТекстВывод (new Массив(256));
        вывод.форматируй ("сейчас is the время for {} good men {}", 3, foo);
        ---

        A срез() метод returns все valid контент within the Массив.

*******************************************************************************/

class Массив : Провод, БуферВвода, БуферВывода, Провод.Seek
{
        private проц[]  данные;                   // the необр данные буфер
        private т_мера  индекс;                  // current читай позиция
        private т_мера  протяженность;                 // предел of valid контент
        private т_мера  дименсия;              // maximum протяженность of контент
        private т_мера  expansion;              // for growing instances

        private static ткст перебор  = "вывод буфер is full";
        private static ткст недобор = "ввод буфер is пустой";
        private static ткст eofRead   = "конец-of-flow while reading";
        private static ткст eofWrite  = "конец-of-flow while writing";

        /***********************************************************************

                Ensure the буфер remains valid between метод calls

        ***********************************************************************/

        invariant
        {
                assert (индекс <= протяженность);
                assert (протяженность <= дименсия);
        }

        /***********************************************************************

                Construct a буфер

                Параметры:
                ёмкость = the число of байты в_ сделай available
                growing  = chunk размер of a growable экземпляр, or zero
                           в_ prohibit expansion

                Remarks:
                Construct a Буфер with the specified число of байты
                and expansion policy.

        ***********************************************************************/

        this (т_мера ёмкость = 0, т_мера growing = 0)
        {
                присвой (new ббайт[ёмкость], 0);
                expansion = growing;
        }

        /***********************************************************************

                Construct a буфер

                Параметры:
                данные = the backing Массив в_ буфер within

                Remarks:
                Prime a буфер with an application-supplied Массив. все контент
                is consопрered valid for reading, and thus there is no записываемый
                пространство initially available.

        ***********************************************************************/

        this (проц[] данные)
        {
                присвой (данные, данные.length);
        }

        /***********************************************************************

                Construct a буфер

                Параметры:
                данные =     the backing Массив в_ буфер within
                читаемый = the число of байты initially made
                           читаемый

                Remarks:
                Prime буфер with an application-supplied Массив, and
                indicate как much читаемый данные is already there. A
                пиши operation will begin writing immediately after
                the existing читаемый контент.

                This is commonly used в_ прикрепи a Буфер экземпляр в_
                a local Массив.

        ***********************************************************************/

        this (проц[] данные, т_мера читаемый)
        {
                присвой (данные, читаемый);
        }

        /***********************************************************************

                Return the имя of this провод

        ***********************************************************************/

        final override ткст вТкст ()
        {
                return "<Массив>";
        }
      
        /***********************************************************************

                Transfer контент преобр_в the provопрed приёмн

                Параметры:
                приёмн = destination of the контент

                Возвращает:
                return the число of байты читай, which may be less than
                приёмн.length. Кф is returned when no further контент is
                available.

                Remarks:
                Populates the provопрed Массив with контент. We try в_
                satisfy the request из_ the буфер контент, and читай
                directly из_ an attached провод when the буфер is
                пустой.

        ***********************************************************************/

        final override т_мера читай (проц[] приёмн)
        {
                auto контент = читаемый;
                if (контент)
                   {
                   if (контент >= приёмн.length)
                       контент = приёмн.length;

                   // перемести буфер контент
                   приёмн [0 .. контент] = данные [индекс .. индекс + контент];
                   индекс += контент;
                   }
                else
                   контент = ИПровод.Кф;
                return контент;
        }

        /***********************************************************************

                Emulate ИПотокВывода.пиши()

                Параметры:
                ист = the контент в_ пиши

                Возвращает:
                return the число of байты записано, which may be less than
                provопрed (conceptually). Returns Кф when the буфер becomes
                full.

                Remarks:
                Appends ист контент в_ the буфер, expanding as required if
                configured в_ do so (via the ctor).

        ***********************************************************************/

        final override т_мера пиши (проц[] ист)
        {
                auto длин = ист.length;
                if (длин)
                   {
                   if (длин > записываемый)
                       if (расширь(длин) < длин)
                           return Кф;

                   // контент may overlap ...
                   memcpy (&данные[протяженность], ист.ptr, длин);
                   протяженность += длин;
                   }
                return длин;
        }

        /***********************************************************************

                Return a preferred размер for buffering провод I/O

        ***********************************************************************/

        final override т_мера размерБуфера ()
        {
                return данные.length;
        }

        /***********************************************************************

                Release external resources

        ***********************************************************************/

        override проц открепи ()
        {
        }

        /***********************************************************************
        
                Seek within the constraints of assigned контент

        ***********************************************************************/

        override дол сместись (дол смещение, Якорь якорь = Якорь.Нач)
        {
                if (смещение > предел)
                    смещение = предел;

                switch (якорь)
                       {
                       case Якорь.End:
                            индекс = cast(т_мера) (предел - смещение);
                            break;

                       case Якорь.Нач:
                            индекс = cast(т_мера) смещение;
                            break;

                       case Якорь.Тек:
                            дол o = cast(т_мера) (индекс + смещение);
                            if (o < 0)
                                o = 0;
                            if (o > предел)
                                o = предел;
                            индекс = cast(т_мера) o;
                       default:
                            break;
                       }
                return индекс;
        }

        /***********************************************************************

                Reset the буфер контент

                Параметры:
                данные =  the backing Массив в_ буфер within. все контент
                        is consопрered valid

                Возвращает:
                the буфер экземпляр

                Remarks:
                Набор the backing Массив with все контент читаемый. 

        ***********************************************************************/

        Массив присвой (проц[] данные)
        {
                return присвой (данные, данные.length);
        }

        /***********************************************************************

                Reset the буфер контент

                Параметры:
                данные     = the backing Массив в_ буфер within
                читаемый = the число of байты within данные consопрered
                           valid

                Возвращает:
                the буфер экземпляр

                Remarks:
                Набор the backing Массив with some контент читаемый. Use сотри() 
                в_ сбрось the контент (сделай it все записываемый).

        ***********************************************************************/

        Массив присвой (проц[] данные, т_мера читаемый)
        {
                this.данные = данные;
                this.протяженность = читаемый;
                this.дименсия = данные.length;

                // сбрось в_ старт of ввод
                this.expansion = 0;
                this.индекс = 0;
                return this;
        }

        /***********************************************************************

                Access буфер контент

                Remarks:
                Return the entire backing Массив. 

        ***********************************************************************/

        final проц[] присвой ()
        {
                return данные;
        }

        /***********************************************************************
        
                Return a проц[] читай of the буфер из_ старт в_ конец, where
                конец is исключительно

        ***********************************************************************/

        final проц[] opSlice (т_мера старт, т_мера конец)
        {
                assert (старт <= протяженность && конец <= протяженность && старт <= конец);
                return данные [старт .. конец];
        }

        /***********************************************************************

                Retrieve все читаемый контент

                Возвращает:
                a проц[] читай of the буфер

                Remarks:
                Return a проц[] читай of the буфер, из_ the current позиция
                up в_ the предел of valid контент. The контент remains in the
                буфер for future extraction.

        ***********************************************************************/

        final проц[] срез ()
        {
                return данные [индекс .. протяженность];
        }

        /***********************************************************************

                Access буфер контент

                Параметры:
                размер =  число of байты в_ access
                съешь =   whether в_ используй the контент or not

                Возвращает:
                the corresponding буфер срез when successful, or
                пусто if there's not enough данные available (Кф; Eob).

                Remarks:
                Slices читаемый данные. The specified число of байты is
                reдобавь из_ the буфер, and marked as having been читай
                when the 'съешь' parameter is установи да. When 'съешь' is установи
                нет, the читай позиция is not adjusted.

                Note that the срез cannot be larger than the размер of
                the буфер ~ use метод читай(проц[]) instead where you
                simply want the контент copied. 
                
                Note also that the срез should be .dup'd if you wish в_
                retain it.

                Examples:
                ---
                // создай a буфер with some контент
                auto буфер = new Буфер ("hello world");

                // используй everything unread
                auto срез = буфер.срез (буфер.читаемый);
                ---

        ***********************************************************************/

        final проц[] срез (т_мера размер, бул съешь = да)
        {
                if (размер > читаемый)
                    ошибка (недобор);

                auto i = индекс;
                if (съешь)
                    индекс += размер;
                return данные [i .. i + размер];
        }

        /***********************************************************************

                Append контент

                Параметры:
                ист = the контент в_ _append
                length = the число of байты in ист

                Returns a chaining reference if все контент was записано.
                Throws an ВВИскл indicating eof or eob if not.

                Remarks:
                Append an Массив в_ this буфер

        ***********************************************************************/

        final Массив добавь (проц[] ист)
        {
                if (пиши(ист) is Кф)
                    ошибка (перебор);
                return this;
        }

        /***********************************************************************

                Обходчик support

                Параметры:
                скан = the delagate в_ invoke with the current контент

                Возвращает:
                Returns да if a token was isolated, нет otherwise.

                Remarks:
                Upon success, the delegate should return the байт-based
                индекс of the consumed образец (хвост конец of it). Failure
                в_ match a образец should be indicated by returning an
                ИПровод.Кф

                Note that добавьitional iterator and/or читатель instances
                will operate in lockstep when bound в_ a common буфер.

        ***********************************************************************/

        final бул следщ (т_мера delegate (проц[]) скан)
        {
                return читатель (скан) != ИПровод.Кф;
        }

        /***********************************************************************

                Available контент

                Remarks:
                Return счёт of _readable байты remaining in буфер. This is
                calculated simply as предел() - позиция()

        ***********************************************************************/

        final т_мера читаемый ()
        {
                return протяженность - индекс;
        }

        /***********************************************************************

                Available пространство

                Remarks:
                Return счёт of _writable байты available in буфер. This is
                calculated simply as ёмкость() - предел()

        ***********************************************************************/

        final т_мера записываемый ()
        {
                return дименсия - протяженность;
        }

        /***********************************************************************

                Access буфер предел

                Возвращает:
                Returns the предел of читаемый контент within this буфер.

                Remarks:
                Each буфер есть a ёмкость, a предел, and a позиция. The
                ёмкость is the maximum контент a буфер can contain, предел
                represents the протяженность of valid контент, and позиция marks
                the current читай location.

        ***********************************************************************/

        final т_мера предел ()
        {
                return протяженность;
        }

        /***********************************************************************

                Access буфер ёмкость

                Возвращает:
                Returns the maximum ёмкость of this буфер

                Remarks:
                Each буфер есть a ёмкость, a предел, and a позиция. The
                ёмкость is the maximum контент a буфер can contain, предел
                represents the протяженность of valid контент, and позиция marks
                the current читай location.

        ***********************************************************************/

        final т_мера ёмкость ()
        {
                return дименсия;
        }

        /***********************************************************************

                Access буфер читай позиция

                Возвращает:
                Returns the current читай-позиция within this буфер

                Remarks:
                Each буфер есть a ёмкость, a предел, and a позиция. The
                ёмкость is the maximum контент a буфер can contain, предел
                represents the протяженность of valid контент, and позиция marks
                the current читай location.

        ***********************************************************************/

        final т_мера позиция ()
        {
                return индекс;
        }

        /***********************************************************************

                Clear Массив контент

                Remarks:
                Reset 'позиция' and 'предел' в_ zero. This effectively
                clears все контент из_ the Массив.

        ***********************************************************************/

        final Массив сотри ()
        {
                индекс = протяженность = 0;
                return this;
        }

        /***********************************************************************

                Emit/purge buffered контент

        ***********************************************************************/

        final override Массив слей ()
        {
                return this;
        }

        /***********************************************************************

                Write преобр_в this буфер

                Параметры:
                дг = the обрвызов в_ provопрe буфер access в_

                Возвращает:
                Returns whatever the delegate returns.

                Remarks:
                Exposes the необр данные буфер at the current _write позиция,
                The delegate is provопрed with a проц[] representing пространство
                available within the буфер at the current _write позиция.

                The delegate should return the appropriate число of байты
                if it writes valid контент, or ИПровод.Кф on ошибка.

        ***********************************************************************/

        final т_мера писатель (т_мера delegate (проц[]) дг)
        {
                auto счёт = дг (данные [протяженность..дименсия]);

                if (счёт != ИПровод.Кф)
                   {
                   протяженность += счёт;
                   assert (протяженность <= дименсия);
                   }
                return счёт;
        }

        /***********************************************************************

                Чтен directly из_ this буфер

                Параметры:
                дг = обрвызов в_ provопрe буфер access в_

                Возвращает:
                Returns whatever the delegate returns.

                Remarks:
                Exposes the необр данные буфер at the current _read позиция. The
                delegate is provопрed with a проц[] representing the available
                данные, and should return zero в_ покинь the current _read позиция
                intact.

                If the delegate consumes данные, it should return the число of
                байты consumed; or ИПровод.Кф в_ indicate an ошибка.

        ***********************************************************************/

        final т_мера читатель (т_мера delegate (проц[]) дг)
        {
                auto счёт = дг (данные [индекс..протяженность]);

                if (счёт != ИПровод.Кф)
                   {
                   индекс += счёт;
                   assert (индекс <= протяженность);
                   }
                return счёт;
        }

        /***********************************************************************

                Expand existing буфер пространство

                Возвращает:
                Available пространство, without any expansion

                Remarks:
                Make some добавьitional room in the буфер, of at least the 
                given размер. Should not be public in order в_ avoопр issues
                with non-growable subclasses
                                     
        ***********************************************************************/

        private final т_мера расширь (т_мера размер)
        {
                if (expansion)
                   {
                   if (размер < expansion)
                       размер = expansion;
                   дименсия += размер;
                   данные.length = дименсия;
                   }
                return записываемый;
        }

        /***********************************************************************

                Cast в_ a мишень тип without invoking the wrath of the
                рантайм checks for misalignment. Instead, we обрежь the
                Массив length

        ***********************************************************************/

        private static T[] преобразуй(T)(проц[] x)
        {
                return (cast(T*) x.ptr) [0 .. (x.length / T.sizeof)];
        }
}


/******************************************************************************

******************************************************************************/

debug (Массив)
{
        import io.Stdout;

        проц main()
        {       
                auto b = new Массив(6, 10);
                b.сместись (0);
                b.пиши ("fubar");

                Стдвыв.форматнс ("протяженность {}, поз {}, читай {}, bufsize {}", 
                                  b.предел, b.позиция, cast(ткст) b.срез, b.размерБуфера);

                b.пиши ("fubar");
                Стдвыв.форматнс ("протяженность {}, поз {}, читай {}, bufsize {}", 
                                  b.предел, b.позиция, cast(ткст) b.срез, b.размерБуфера);
        }
}