/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Mar 2004: Initial release
                        Dec 2006: Outback release

        authors:        Kris

*******************************************************************************/

module io.Buffer;

private import  exception;

public  import    io.model;

pragma (msg, "warning - io.Буфер functionality есть been разбей преобр_в io.поток.Буферированный and io.устройство.Массив - use the former for discrete Потокs, and the latter for combined I/O");


/******************************************************************************

******************************************************************************/

extern (C)
{
        protected проц * memcpy (проц *приёмн, проц *ист, т_мера);
}

/*******************************************************************************

       Буфер является центральным понятием в Dinrus I/O. Каждый буфер
       действует как очередь (линия), где впереди элементы снимаются,
       а сзади добавляются новые. Буферы моделируются io.model.ИБуфер,
	  и этим классом обеспечивается конкретная реализация.

        Можно непосредственно писать и читать из буфера, но чаще всего
        используются различные фильтры данных и преобразователи,
        которые применяют стрptrтуры к тому, что в противном случае было бы
		простыми "грубыми" данными.

        Их также можно разбивать на токены, применяя Итератор.
        Это может пригодиться при работе с текстовым вводом,
        и/или когда к контенту применяется более тонкий формат,
		чем обычно поддерживают преобразователи. 
		Обходчик семы are mapped directly onto буфер контент
		(sliced), making them quite
        efficient in practice. Like другой типы of буфер клиент,
        multИПle iterators can be mapped onto one common буфер
        and access will be serialized.

        Buffers are sometimes память-only, in which case there
        is nothing left в_ do when a клиент есть consumed все the
        контент. Other buffers are themselves bound в_ an external
        устройство called a провод. When this is the case, a consumer
        will eventually cause a буфер в_ reload via its associated
        провод and previous буфер контент will be lost.

        A similar approach is applied в_ clients which наполни a
        буфер, whereby the контент of a full буфер will be flushed
        в_ a bound провод before continuing. другой variation is
        that of a память-mapped буфер, whereby the буфер контент
        is mapped directly в_ virtual память exposed via the OS. This
        can be used в_ адрес large файлы as an Массив of контент.

        Direct буфер manИПulation typically involves appending,
        as in the following example:
        ---
        // создай a small буфер
        auto буф = new Буфер (256);

        auto foo = "в_ пиши some D";

        // добавь some текст directly в_ it
        буф.добавь ("сейчас is the время for все good men ").добавь(foo);
        ---

        Alternatively, one might use a форматёр в_ добавь the буфер:
        ---
        auto вывод = new ТекстВывод (new Буфер(256));
        вывод.форматируй ("сейчас is the время for {} good men {}", 3, foo);
        ---

        A срез() метод will return все valid контент within a буфер.
        БуферРоста can be used instead, where one wishes в_ добавь beyond
        a specified предел.

        A common usage of a буфер is in conjunction with a провод,
        such as FileConduit. Each провод exposes a preferred-размер for
        its associated buffers, utilized during буфер construction:
        ---
        auto файл = new Файл ("имя");
        auto буф = new Буфер (файл);
        ---

        However, this is typically скрытый by higher уровень constructors
        such as those exposed via the поток wrappers. For example:
        ---
        auto ввод = new ВводДанных (new Файл ("имя"));
        ---

        There is indeed a буфер between the resultant поток and the
        файл, but explicit буфер construction is unecessary in common 
        cases.

        An Обходчик is constructed in a similar manner, where you provопрe
        it an ввод поток в_ operate upon. There's a variety of iterators
        available in the io.Поток package, and they are templated
        for each of utf8, utf16, and utf32. This example uses a строка-iterator
        derivative в_ смети a текст файл:
        ---
        auto lines = new ТекстВвод (new Файл ("имя"));
        foreach (строка; lines)
                 Квывод(строка).нс;
        lines.закрой;
        ---

        Buffers are useful for many purposes within Dinrus, but there are 
        times when it may be ещё appropriate в_ sопрestep them. For such 
        cases, все провод derivations (such as Файл) support Массив-based 
        I/O via a pair of читай() and пиши() methods.

*******************************************************************************/

class Буфер : ИБуфер
{
        protected ИПотокВывода  бвывод;                // optional данные бвывод
        protected ИПотокВвода   бввод;                 // optional данные бввод
        protected проц[]        данные;                   // the необр данные буфер
        protected т_мера        индекс;                  // current читай позиция
        protected т_мера        протяженность;                 // предел of valid контент
        protected т_мера        дименсия;              // maximum протяженность of контент
        protected бул          можноСжать = да;     // сожми iterator контент?


        protected static ткст перебор  = "вывод буфер is full";
        protected static ткст недобор = "ввод буфер is пустой";
        protected static ткст eofRead   = "конец-of-flow whilst reading";
        protected static ткст eofWrite  = "конец-of-flow whilst writing";

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
                провод = the провод в_ буфер

                Remarks:
                Construct a Буфер upon the provопрed провод. A relevant
                буфер размер is supplied via the provопрed провод.

        ***********************************************************************/

        this (ИПровод провод)
        {
                assert (провод);

                this (провод.размерБуфера);
                setConduit (провод);
        }

        /***********************************************************************

                Construct a буфер

                Параметры:
                поток = an ввод поток
                ёмкость = desired буфер ёмкость

                Remarks:
                Construct a Буфер upon the provопрed ввод поток.

        ***********************************************************************/

        this (ИПотокВвода поток, т_мера ёмкость)
        {
                this (ёмкость);
                ввод = поток;
        }

        /***********************************************************************

                Construct a буфер

                Параметры:
                поток = an вывод поток
                ёмкость = desired буфер ёмкость

                Remarks:
                Construct a Буфер upon the provопрed вывод поток.

        ***********************************************************************/

        this (ИПотокВывода поток, т_мера ёмкость)
        {
                this (ёмкость);
                вывод = поток;
        }

        /***********************************************************************

                Construct a буфер

                Параметры:
                ёмкость = the число of байты в_ сделай available

                Remarks:
                Construct a Буфер with the specified число of байты.

        ***********************************************************************/

        this (т_мера ёмкость = 0)
        {
                устКонтент (new ббайт[ёмкость], 0);
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
                устКонтент (данные, данные.length);
        }

        /***********************************************************************

                Construct a буфер

                Параметры:
                данные =          the backing Массив в_ буфер within
                читаемый =      the число of байты initially made
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
                устКонтент (данные, читаемый);
        }

        /***********************************************************************

                Attempt в_ совместно an upПоток Буфер, and создай an экземпляр
                where there not one available.

                Параметры:
                поток = an ввод поток
                размер = a hint of the desired буфер размер. Defaults в_ the
                провод-defined размер

                Remarks:
                If an upПоток Буфер instances is visible, it will be shared.
                Otherwise, a new экземпляр is создан based upon the размерБуфера
                exposed by the поток endpoint (провод).

        ***********************************************************************/

        static ИБуфер совместно (ИПотокВвода поток, т_мера размер = т_мера.max)
        {
                auto b = cast(Буферированный) поток;
                if (b)
                    return b.буфер;

                if (размер is т_мера.max)
                    размер = поток.провод.размерБуфера;

                return new Буфер (поток, размер);
        }

        /***********************************************************************

                Attempt в_ совместно an upПоток Буфер, and создай an экземпляр
                where there not one available.

                Параметры:
                поток = an вывод поток
                размер = a hint of the desired буфер размер. Defaults в_ the
                провод-defined размер

                Remarks:
                If an upПоток Буфер instances is visible, it will be shared.
                Otherwise, a new экземпляр is создан based upon the размерБуфера
                exposed by the поток endpoint (провод).

        ***********************************************************************/

        static ИБуфер совместно (ИПотокВывода поток, т_мера размер = т_мера.max)
        {
                auto b = cast(Буферированный) поток;
                if (b)
                    return b.буфер;

                if (размер is т_мера.max)
                    размер = поток.провод.размерБуфера;

                return new Буфер (поток, размер);
        }

        /***********************************************************************

                Reset the буфер контент

                Параметры:
                данные =  the backing Массив в_ буфер within. все контент
                        is consопрered valid

                Возвращает:
                the буфер экземпляр

                Remarks:
                Набор the backing Массив with все контент читаемый. Writing
                в_ this will either слей it в_ an associated провод, or
                raise an Кф condition. Use сотри() в_ сбрось the контент
                (сделай it все записываемый).

        ***********************************************************************/

        ИБуфер устКонтент (проц[] данные)
        {
                return устКонтент (данные, данные.length);
        }

        /***********************************************************************

                Reset the буфер контент

                Параметры:
                данные =          the backing Массив в_ буфер within
                читаемый =      the число of байты within данные consопрered
                                valid

                Возвращает:
                the буфер экземпляр

                Remarks:
                Набор the backing Массив with some контент читаемый. Writing
                в_ this will either слей it в_ an associated провод, or
                raise an Кф condition. Use сотри() в_ сбрось the контент
                (сделай it все записываемый).

        ***********************************************************************/

        ИБуфер устКонтент (проц[] данные, т_мера читаемый)
        {
                this.данные = данные;
                this.протяженность = читаемый;
                this.дименсия = данные.length;

                // сбрось в_ старт of ввод
                this.индекс = 0;

                return this;
        }

        /***********************************************************************

                Retrieve the valid контент

                Возвращает:
                a проц[] срез of the буфер

                Remarks:
                Return a проц[] срез of the буфер, из_ the current позиция
                up в_ the предел of valid контент. The контент remains in the
                буфер for future extraction.

        ***********************************************************************/

        проц[] срез ()
        {
                return  данные [индекс .. протяженность];
        }

        /***********************************************************************
        
                Return a проц[] срез of the буфер из_ старт в_ конец, where
                конец is исключительно

        ***********************************************************************/

        final проц[] opSlice (т_мера старт, т_мера конец)
        {
                assert (старт <= протяженность && конец <= протяженность && старт <= конец);
                return данные [старт .. конец];
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
                Чтен a срез of данные из_ the буфер, loading из_ the
                провод as necessary. The specified число of байты is
                sliced из_ the буфер, and marked as having been читай
                when the 'съешь' parameter is установи да. When 'съешь' is установи
                нет, the читай позиция is not adjusted.

                Note that the срез cannot be larger than the размер of
                the буфер ~ use метод заполни(проц[]) instead where you
                simply want the контент copied, or use провод.читай()
                в_ extract directly из_ an attached провод. Also note
                that if you need в_ retain the срез, then it should be
                .dup'd before the буфер is compressed or repopulated.

                Examples:
                ---
                // создай a буфер with some контент
                auto буфер = new Буфер ("hello world");

                // используй everything unread
                auto срез = буфер.срез (буфер.читаемый);
                ---

        ***********************************************************************/

        проц[] срез (т_мера размер, бул съешь = да)
        {
                if (размер > читаемый)
                   {
                   if (бввод is пусто)
                       ошибка (недобор);

                   // сделай some пространство? This will try в_ покинь as much контент
                   // in the буфер as possible, such that entire records may
                   // be aliased directly из_ within.
                   if (размер > (дименсия - индекс))
                      {
                      if (размер > дименсия)
                          ошибка (недобор);
                      if (можноСжать)
                          сожми ();
                      }

                   // наполни хвост of буфер with new контент
                   do {
                      if (заполни(бввод) is ИПровод.Кф)
                          ошибка (eofRead);
                      } while (размер > читаемый);
                   }

                auto i = индекс;
                if (съешь)
                    индекс += размер;
                return данные [i .. i + размер];
        }

        /**********************************************************************

                Fill the provопрed буфер. Returns the число of байты
                actually читай, which will be less that приёмн.length when
                Кф есть been reached and ИПровод.Кф thereafter

        **********************************************************************/

        т_мера заполни (проц[] приёмн)
        {
                т_мера длин = 0;

                while (длин < приёмн.length)
                      {
                      auto i = читай (приёмн [длин .. $]);
                      if (i is ИПровод.Кф)
                          return (длин > 0) ? длин : ИПровод.Кф;
                      длин += i;
                      }
                return длин;
        }

        /***********************************************************************

                Copy буфер контент преобр_в the provопрed приёмн

                Параметры:
                приёмн = destination of the контент
                байты = размер of приёмн

                Возвращает:
                A reference в_ the populated контент

                Remarks:
                Fill the provопрed Массив with контент. We try в_ satisfy
                the request из_ the буфер контент, and читай directly
                из_ an attached провод where ещё is required.

        ***********************************************************************/

        проц[]  читайРовно (ук  приёмн, т_мера байты)
        {
                auto врем = приёмн [0 .. байты];
                if (заполни (врем) != байты)
                    ошибка (eofRead);

                return врем;
        }

        /***********************************************************************

                Append контент

                Параметры:
                ист = the контент в_ _append

                Returns a chaining reference if все контент was записано.
                Throws an ВВИскл indicating eof or eob if not.

                Remarks:
                Append an Массив в_ this буфер, and слей в_ the
                провод as necessary. This is often used in lieu of
                a Писатель.

        ***********************************************************************/

        ИБуфер добавь (проц[] ист)
        {
                return добавь (ист.ptr, ист.length);
        }

        /***********************************************************************

                Append контент

                Параметры:
                ист = the контент в_ _append
                length = the число of байты in ист

                Returns a chaining reference if все контент was записано.
                Throws an ВВИскл indicating eof or eob if not.

                Remarks:
                Append an Массив в_ this буфер, and слей в_ the
                провод as necessary. This is often used in lieu of
                a Писатель.

        ***********************************************************************/

        ИБуфер добавь (ук  ист, т_мера length)
        {
                if (length > записываемый)
                    // can we пиши externally?
                    if (бвывод)
                       {
                       слей;

                       // check for pathological case
                       if (length > дименсия)
                          {
                          do {
                             auto записано = бвывод.пиши (ист [0 .. length]);
                             if (записано is ИПровод.Кф)
                                 ошибка (eofWrite);
                             ист += записано, length -= записано;
                             } while (length > дименсия);
                          }
                       }
                    else
                       ошибка (перебор);

                копируй (ист, length);
                return this;
        }

        /***********************************************************************

                Append контент

                Параметры:
                другой = a буфер with контент available

                Возвращает:
                Returns a chaining reference if все контент was записано.
                Throws an ВВИскл indicating eof or eob if not.

                Remarks:
                Append другой буфер в_ this one, and слей в_ the
                провод as necessary. This is often used in lieu of
                a Писатель.

        ***********************************************************************/

        ИБуфер добавь (ИБуфер другой)
        {
                return добавь (другой.срез);
        }

        /***********************************************************************

                Consume контент из_ a producer

                Параметры:
                The контент в_ используй. This is consumed verbatim, and in
                необр binary форматируй ~ no implicit conversions are performed.

                Remarks:
                This is often used in lieu of a Писатель, and enables simple
                classes, such as ФПуть and Уир, в_ излей контент directly
                преобр_в a буфер (thus avoопрing potential куча activity)

                Examples:
                ---
                auto путь = new ФПуть (somepath);

                путь.произведи (&буфер.используй);
                ---

        ***********************************************************************/

        проц используй (проц[] x)
        {
                добавь (x);
        }

        /***********************************************************************

                Move the current читай location

                Параметры:
                размер = the число of байты в_ перемести

                Возвращает:
                Returns да if successful, нет otherwise.

                Remarks:
                SkИП ahead by the specified число of байты, Потокing из_
                the associated провод as necessary.

                Can also реверс the читай позиция by 'размер' байты, when размер
                is negative. This may be used в_ support lookahead operations.
                Note that a negative размер will краш where there is not sufficient
                контент available in the буфер (can't _skИП beyond the beginning).

        ***********************************************************************/

        бул пропусти (цел размер)
        {
                if (размер < 0)
                   {
                   размер = -размер;
                   if (индекс >= размер)
                      {
                      индекс -= размер;
                      return да;
                      }
                   return нет;
                   }
                return срез(размер) !is пусто;
        }

        дол сместись (дол смещение, Якорь старт = Якорь.Нач)
        {
                if (старт is Якорь.Тек)
                   {
                   // укз this specially because we know this is
                   // buffered - we should take преобр_в account the буфер
                   // позиция when seeking
                   смещение -= this.читаемый;
                   auto bpos = смещение + this.предел;

                   if (bpos >= 0 && bpos < this.предел)
                      {
                      // the new позиция is within the current
                      // буфер, пропусти в_ that позиция.
                      пропусти (cast(цел) bpos - cast(цел) this.позиция);
                      return 0;
                      //return провод.позиция - ввод.читаемый;
                      }
                   // else, позиция is outsопрe the буфер. Do a реал
                   // сместись using the adjusted позиция.
                   }

                сотри;
                return бввод.сместись (смещение, старт);
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

                Each образец is ожидалось в_ be очищенный of the delimiter.
                An конец-of-файл condition causes trailing контент в_ be
                placed преобр_в the token. Requests made beyond Кф результат
                in пустой matches (length is zero).

                Note that добавьitional iterator and/or читатель instances
                will operate in lockstep when bound в_ a common буфер.

        ***********************************************************************/

        бул следщ (т_мера delegate (проц[]) скан)
        {
                while (читатель(скан) is ИПровод.Кф)
                       // не найден - are we Потокing?
                       if (бввод)
                          {
                          // dопр we старт at the beginning?
                          if (позиция && можноСжать)
                              // yep - перемести partial token в_ старт of буфер
                              сожми;
                          else
                             // no ещё пространство in the буфер?
                             if (записываемый is 0 && расширь(0) is 0)
                                 ошибка ("Токен is too large в_ fit within буфер");

                          // читай другой chunk of данные
                          if (заполни(бввод) is ИПровод.Кф)
                              return нет;
                          }
                       else
                          return нет;

                return да;
        }

        /***********************************************************************

                Configure the compression strategy for iterators

                Remarks:
                Iterators will tend в_ сожми the buffered контент in
                order в_ maximize пространство for new данные. You can disable this
                behaviour by настройка this булево в_ нет

        ***********************************************************************/

        final бул сожми (бул да)
        {
                auto ret = можноСжать;
                можноСжать = да;
                return ret;
        }
        
        /***********************************************************************

                Available контент

                Remarks:
                Return счёт of _readable байты remaining in буфер. This is
                calculated simply as предел() - позиция()

        ***********************************************************************/

        т_мера читаемый ()
        {
                return протяженность - индекс;
        }

        /***********************************************************************

                Available пространство

                Remarks:
                Return счёт of _writable байты available in буфер. This is
                calculated simply as ёмкость() - предел()

        ***********************************************************************/

        т_мера записываемый ()
        {
                return дименсия - протяженность;
        }

        /***********************************************************************

                Reserve the specified пространство within the буфер, compressing
                existing контент as necessary в_ сделай room

                Returns the current читай point, after compression if that
                was required

        ***********************************************************************/

        final т_мера резервируй (т_мера пространство)
        {       
                assert (пространство < дименсия);

                if ((дименсия - индекс) < пространство)
                     сожми;
                return индекс;
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

        т_мера писатель (т_мера delegate (проц[]) дг)
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

        т_мера читатель (т_мера delegate (проц[]) дг)
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

                Compress буфер пространство

                Возвращает:
                the буфер экземпляр

                Remarks:
                If we have some данные left after an export, перемести it в_
                front-of-буфер and установи позиция в_ be just after the
                remains. This is for supporting certain conduits which
                choose в_ пиши just the начальное portion of a request.

                Limit is установи в_ the amount of данные remaining. Position
                is always сбрось в_ zero.

        ***********************************************************************/

        ИБуфер сожми ()
        {       
                auto r = читаемый;

                if (индекс > 0 && r > 0)
                    // контент may overlap ...
                    memcpy (&данные[0], &данные[индекс], r);

                индекс = 0;
                протяженность = r;
                return this;
        }

        /***********************************************************************

                Fill буфер из_ the specific провод

                Возвращает:
                Returns the число of байты читай, or Провод.Кф

                Remarks:
                Try в_ _fill the available буфер with контент из_ the
                specified провод. We try в_ читай as much as possible
                by clearing the буфер when все current контент есть been
                eaten. If there is no пространство available, nothing will be
                читай.

        ***********************************************************************/

        т_мера заполни (ИПотокВвода ист)
        {
                if (ист is пусто)
                    return ИПровод.Кф;
/+
                // should not сбрось here, since we're only filling!
                if (читаемый is 0 && можноСжать)
                    индекс = протяженность = 0;  // same as сотри(), without вызов-chain
                else
                   if (записываемый is 0)
                       return 0;
+/
                return писатель (&ист.читай);
        }

        /***********************************************************************

                Drain буфер контент в_ the specific провод

                Возвращает:
                Returns the число of байты записано

                Remarks:
                Write as much of the буфер that the associated провод
                can используй. The провод is not obliged в_ используй все
                контент, so some may remain within the буфер.

                Throws an ВВИскл on premature Кф.

        ***********************************************************************/

        final т_мера дренируй (ИПотокВывода приёмн)
        {
                if (приёмн is пусто)
                    return ИПровод.Кф;

                auto ret = читатель (&приёмн.пиши);
                if (ret is ИПровод.Кф)
                    ошибка (eofWrite);

                сожми ();
                return ret;
        }

        /***********************************************************************

                Truncate буфер контент

                Remarks:
                Truncate the буфер within its протяженность. Returns да if
                the new length is valid, нет otherwise.

        ***********************************************************************/

        бул обрежь (т_мера length)
        {
                if (length <= данные.length)
                   {
                   протяженность = length;
                   return да;
                   }
                return нет;
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

        т_мера предел ()
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

        т_мера ёмкость ()
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

        т_мера позиция ()
        {
                return индекс;
        }

        /***********************************************************************

                Набор external провод

                Параметры:
                провод = the провод в_ прикрепи в_

                Remarks:
                Sets the external провод associated with this буфер.

                Buffers do not require an external провод в_ operate, but
                it can be convenient в_ associate one. For example, methods
                заполни() & дренируй() use it в_ import/export контент as necessary.

        ***********************************************************************/

        ИБуфер setConduit (ИПровод провод)
        {
                бвывод = провод;
                бввод = провод;
                return this;
        }

        /***********************************************************************

                Набор вывод поток

                Параметры:
                бвывод = the поток в_ прикрепи в_

                Remarks:
                Sets the external вывод поток associated with this буфер.

                Buffers do not require an external поток в_ operate, but
                it can be convenient в_ associate one. For example, methods
                заполни & дренируй use them в_ import/export контент as necessary.

        ***********************************************************************/

        final ИБуфер вывод (ИПотокВывода бвывод)
        {
                this.бвывод = бвывод;
                return this;
        }

        /***********************************************************************

                Набор ввод поток

                Параметры:
                бввод = the поток в_ прикрепи в_

                Remarks:
                Sets the external ввод поток associated with this буфер.

                Buffers do not require an external поток в_ operate, but
                it can be convenient в_ associate one. For example, methods
                заполни & дренируй use them в_ import/export контент as necessary.

        ***********************************************************************/

        final ИБуфер ввод (ИПотокВвода бввод)
        {
                this.бввод = бввод;
                return this;
        }

        /***********************************************************************

                Access буфер контент

                Remarks:
                Return the entire backing Массив. Exposed for subclass usage
                only

        ***********************************************************************/

        protected проц[] дайКонтент ()
        {
                return данные;
        }

        /***********************************************************************

                Copy контент преобр_в буфер

                Параметры:
                ист = the soure of the контент
                размер = the length of контент at ист

                Remarks:
                Bulk _copy of данные из_ 'ист'. The new контент is made
                available for reading. This is exposed for subclass use
                only

        ***********************************************************************/

        protected проц копируй (проц *ист, т_мера размер)
        {
                // avoопр "out of bounds" тест on zero размер
                if (размер)
                   {
                   // контент may overlap ...
                   memcpy (&данные[протяженность], ист, размер);
                   протяженность += размер;
                   }
        }

        /***********************************************************************

                Expand existing буфер пространство

                Возвращает:
                Available пространство, without any expansion

                Remarks:
                Make some добавьitional room in the буфер, of at least the 
                given размер. This can be used by subclasses as appropriate
                                     
        ***********************************************************************/

        protected т_мера расширь (т_мера размер)
        {
                return записываемый;
        }

        /***********************************************************************

                Cast в_ a мишень тип without invoking the wrath of the
                рантайм checks for misalignment. Instead, we обрежь the
                Массив length

        ***********************************************************************/

        static T[] преобразуй(T)(проц[] x)
        {
                return (cast(T*) x.ptr) [0 .. (x.length / T.sizeof)];
        }



        /**********************************************************************/
        /*********************** Буферированный Interface ***************************/
        /**********************************************************************/

        ИБуфер буфер ()
        {
                return this;
        }


        /***********************************************************************
        
                Return a buffered вывод, or пусто if there's not one already
                available.

        ***********************************************************************/

        БуферВвода bin ()
        {
                return пусто;
        }              

        /***********************************************************************
        
                Return a buffered вывод, or пусто if there's not one already
                available.

        ***********************************************************************/

        БуферВывода бвых ()
        {
                return пусто;
        }              

        /**********************************************************************/
        /******************** Поток & Провод Interfaces *********************/
        /**********************************************************************/


        /***********************************************************************

                Return the имя of this провод

        ***********************************************************************/

        override ткст вТкст ()
        {
                return "<буфер>";
        }

        /***********************************************************************

                Generic ВВИскл thrower

                Параметры:
                сооб = a текст сообщение describing the исключение резон

                Remarks:
                Throw an ВВИскл with the provопрed сообщение

        ***********************************************************************/

        final проц ошибка (ткст сооб)
        {
                throw new ВВИскл (сооб);
        }

        /***********************************************************************

                Flush все буфер контент в_ the specific провод

                Remarks:
                Flush the contents of this буфер. This will block until
                все контент is actually flushed via the associated провод,
                whereas дренируй() will not.

                Do nothing where a провод is not attached, enabling память
                buffers в_ treat слей as a noop.

                Throws an ВВИскл on premature Кф.

        ***********************************************************************/

        override ИПотокВывода слей ()
        {
                if (бвывод)
                   {
                   while (читаемый() > 0)
                          дренируй (бвывод);

                   // слей the фильтр chain also
                   бвывод.слей;
                   }
                return this;
        }

        /***********************************************************************

                Clear буфер контент

                Remarks:
                Reset 'позиция' and 'предел' в_ zero. This effectively
                clears все контент из_ the буфер.

        ***********************************************************************/

        override ИПотокВвода сотри ()
        {
                индекс = протяженность = 0;

                // сотри the фильтр chain also
                if (бввод)
                    бввод.слей;
                return this;
        }

        /***********************************************************************

                Copy контент via this буфер из_ the provопрed ист
                провод.

                Remarks:
                The ист провод есть its контент transferred through
                this буфер via a series of заполни & дренируй operations,
                until there is no ещё контент available. The буфер
                контент should be explicitly flushed by the caller.

                Throws an ВВИскл on premature eof

        ***********************************************************************/

        override ИПотокВывода копируй (ИПотокВвода ист, т_мера max=-1)
        {
                while (заполни(ист) != ИПровод.Кф)
                       // don't дренируй until we actually need в_
                       if (записываемый is 0)
                           if (бвывод)
                               дренируй (бвывод);
                           else
                              ошибка (перебор);
                return this;
        }

        /***********************************************************************

                Load the биты из_ a поток, and return them все in an
                Массив. The приёмн Массив can be provопрed as an опция, which
                will be expanded as necessary в_ используй the ввод.

                Returns an Массив representing the контент, and throws
                ВВИскл on ошибка
                              
        ***********************************************************************/

        проц[] загрузи (т_мера max=-1)
        {
                return срез;
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

        override т_мера читай (проц[] приёмн)
        {
                auto контент = читаемый();
                if (контент)
                   {
                   if (контент >= приёмн.length)
                       контент = приёмн.length;

                   // перемести буфер контент
                   приёмн [0 .. контент] = данные [индекс .. индекс + контент];
                   индекс += контент;
                   }
                else
                   if (бввод)
                      {
                      // pathological cases читай directly из_ провод
                      if (приёмн.length > дименсия)
                          контент = бввод.читай (приёмн);
                      else
                         {
                         if (записываемый is 0)
                             индекс = протяженность = 0;  // same as сотри(), without вызов-chain

                         // keep буфер partially populated
                         if ((контент = заполни(бввод)) != ИПровод.Кф && контент > 0)
                              контент = читай (приёмн);
                         }
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
                provопрed (conceptually).

                Remarks:
                Appends ист контент в_ the буфер, flushing в_ an attached
                провод as necessary. An ВВИскл is thrown upon пиши
                failure.

        ***********************************************************************/

        override т_мера пиши (проц[] ист)
        {
                добавь (ист.ptr, ист.length);
                return ист.length;
        }

        /***********************************************************************

                Access configured провод

                Возвращает:
                Returns the провод associated with this буфер. Returns
                пусто if the буфер is purely память based; that is, it's
                not backed by some external medium.

                Remarks:
                Buffers do not require an external провод в_ operate, but
                it can be convenient в_ associate one. For example, methods
                заполни() & дренируй() use it в_ import/export контент as necessary.

        ***********************************************************************/

        final override ИПровод провод ()
        {
                if (бвывод)
                    return бвывод.провод;
                else
                   if (бввод)
                       return бввод.провод;
                return this;
        }

        /***********************************************************************

                Return a preferred размер for buffering провод I/O

        ***********************************************************************/

        final override т_мера размерБуфера ()
        {
                return 32 * 1024;
        }

        /***********************************************************************

                Is the провод alive?

        ***********************************************************************/

        final override бул жив_ли ()
        {
                return да;
        }

        /***********************************************************************

                Exposes configured вывод поток

                Возвращает:
                Returns the ИПотокВывода associated with this буфер. Returns
                пусто if the буфер is not attached в_ an вывод; that is, it's
                not backed by some external medium.

                Remarks:
                Buffers do not require an external поток в_ operate, but
                it can be convenient в_ associate them. For example, methods
                заполни & дренируй use them в_ import/export контент as necessary.

        ***********************************************************************/

        final ИПотокВывода вывод ()
        {
                return бвывод;
        }

        /***********************************************************************

                Exposes configured ввод поток

                Возвращает:
                Returns the ИПотокВвода associated with this буфер. Returns
                пусто if the буфер is not attached в_ an ввод; that is, it's
                not backed by some external medium.

                Remarks:
                Buffers do not require an external поток в_ operate, but
                it can be convenient в_ associate them. For example, methods
                заполни & дренируй use them в_ import/export контент as necessary.

        ***********************************************************************/

        final ИПотокВвода ввод ()
        {
                return бввод;
        }

        /***********************************************************************

                Release external rebinputs

        ***********************************************************************/

        final override проц открепи ()
        {
        }

        /***********************************************************************

                Close the поток

                Remarks:
                Propagate request в_ an attached ИПотокВывода (this is a
                requirement for the ИПотокВывода interface)

        ***********************************************************************/

        override проц закрой ()
        {
                if (бвывод)
                    бвывод.закрой;
                else
                   if (бввод)
                       бввод.закрой;
        }
}



/*******************************************************************************

        Subclass в_ provопрe support for контент growth. This is handy when
        you want в_ keep a буфер around as a scratchpad.

*******************************************************************************/

class БуферРоста : Буфер
{
        private т_мера инкремент;

        alias Буфер.срез  срез;
        alias Буфер.добавь добавь; 

        /***********************************************************************
        
                Create a БуферРоста with the specified начальное размер.

        ***********************************************************************/

        this (т_мера размер = 1024, т_мера инкремент = 1024)
        {
                super (размер);

                assert (инкремент >= 32);
                this.инкремент = инкремент;
        }

        /***********************************************************************
        
                Create a БуферРоста with the specified начальное размер.

        ***********************************************************************/

        this (ИПровод провод, т_мера размер = 1024)
        {
                this (размер, размер);
                setConduit (провод);
        }

        /***********************************************************************
        
                Чтен a chunk of данные из_ the буфер, loading из_ the
                провод as necessary. The specified число of байты is
                загружен преобр_в the буфер, and marked as having been читай 
                when the 'съешь' parameter is установи да. When 'съешь' is установи
                нет, the читай позиция is not adjusted.

                Returns the corresponding буфер срез when successful.

        ***********************************************************************/

        override проц[] срез (т_мера размер, бул съешь = да)
        {   
                if (размер > читаемый)
                   {
                   if (бввод is пусто)
                       ошибка (недобор);

                   if (размер + индекс > дименсия)
                       расширь (размер);

                   // наполни хвост of буфер with new контент
                   do {
                      if (заполни(бввод) is ИПровод.Кф)
                          ошибка (eofRead);
                      } while (размер > читаемый);
                   }

                auto i = индекс;
                if (съешь)
                    индекс += размер;
                return данные [i .. i + размер];               
        }

        /***********************************************************************
        
                Append an Массив of данные в_ this буфер. This is often used 
                in lieu of a Писатель.

        ***********************************************************************/

        override ИБуфер добавь (проц *ист, т_мера length)        
        {               
                if (length > записываемый)
                    расширь (length);

                копируй (ист, length);
                return this;
        }

        /***********************************************************************

                Try в_ заполни the available буфер with контент из_ the 
                specified провод. 

                Returns the число of байты читай, or ИПровод.Кф
        
        ***********************************************************************/

        override т_мера заполни (ИПотокВвода ист)
        {
                if (записываемый <= инкремент/8)
                    расширь (инкремент);

                return писатель (&ист.читай);
        } 

        /***********************************************************************
        
                Expand and используй the провод контент, up в_ the maximum 
                размер indicated by the аргумент or until провод.Кф

                Returns the число of байты in the буфер

        ***********************************************************************/

        т_мера заполни (т_мера размер = т_мера.max)
        {   
                while (читаемый < размер)
                       if (заполни(бввод) is ИПровод.Кф)
                           break;
                return читаемый;
        }

        /***********************************************************************

                Expand existing буфер пространство

                Возвращает:
                Available пространство after adjustment

                Remarks:
                Make some добавьitional room in the буфер, of at least the 
                given размер. This can be used by subclasses as appropriate
                                     
        ***********************************************************************/

        override т_мера расширь (т_мера размер)
        {
                if (размер < инкремент)
                    размер = инкремент;

                дименсия += размер;
                данные.length = дименсия;               
                return записываемый;
        }
}


/******************************************************************************

******************************************************************************/

debug (Буфер)
{
        проц main()
        {       
                auto b = new Буфер(6);
                b.добавь ("fubar");
                b.резервируй (1);
                b.срез (5);
                b.резервируй (4);
        }
}