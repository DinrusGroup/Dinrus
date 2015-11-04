/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Mar 2004: Initial release
                        Dec 2006: Outback release

        authors:        Kris

*******************************************************************************/

module io.stream.Buffered;

public import io.model;

private import io.device.Conduit;

/******************************************************************************

******************************************************************************/

public alias Бввод  Бввод;        /// shorthand alias
public alias Бвыв Бвыв;       /// ditto

/******************************************************************************

******************************************************************************/

extern (C)
{       
        цел printf (сим*, ...);
        private проц * memmove (проц *приёмн, проц *ист, т_мера);
}

/******************************************************************************

******************************************************************************/

private static ткст недобор = "ввод буфер is пустой";
private static ткст eofRead   = "конец-of-flow whilst reading";
private static ткст eofWrite  = "конец-of-flow whilst writing";
private static ткст перебор  = "вывод буфер is full";


/*******************************************************************************

        Buffers the flow of данные из_ a upПоток ввод. A downПоток 
        neighbour can locate and use this буфер instead of creating 
        другой экземпляр of their own. 

        (note that upПоток is closer в_ the источник, and downПоток is
        further away)

*******************************************************************************/

class Бввод : ФильтрВвода, БуферВвода
{
        alias слей             сотри;          /// сотри/слей are the same
        alias ФильтрВвода.ввод ввод;          /// access the источник 

        private проц[]        данные;             // the необр данные буфер
        private т_мера        индекс;            // current читай позиция
        private т_мера        протяженность;           // предел of valid контент
        private т_мера        дименсия;        // maximum протяженность of контент

        /***********************************************************************

                Ensure the буфер remains valid between метод calls

        ***********************************************************************/

        invariant()
        {
                assert (индекс <= протяженность);
                assert (протяженность <= дименсия);
        }

        /***********************************************************************

                Construct a буфер

                Параметры:
                поток = an ввод поток
                ёмкость = desired буфер ёмкость

                Remarks:
                Construct a Буфер upon the provопрed ввод поток.

        ***********************************************************************/

        this (ИПотокВвода поток)
        {
                assert (поток);
                this (поток, поток.провод.размерБуфера);
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
                установи (new ббайт[ёмкость], 0);
                super (источник = поток);
        }

        /***********************************************************************

                Attempt в_ совместно an upПоток Буфер, and создай an экземпляр
                where there's not one available.

                Параметры:
                поток = an ввод поток

                Remarks:
                If an upПоток Буфер instances is visible, it will be shared.
                Otherwise, a new экземпляр is создан based upon the размерБуфера
                exposed by the поток endpoint (провод).

        ***********************************************************************/

        static БуферВвода создай (ИПотокВвода поток)
        {
                auto источник = поток;
                auto провод = источник.провод;
                while (cast(Переключатель) источник is пусто)
                      {
                      auto b = cast(БуферВвода) источник;
                      if (b)
                          return b;
                      if (источник is провод)
                          break;
                      источник = источник.ввод;
                      assert (источник);
                      }
                      
                return new Бввод (поток, провод.размерБуфера);
        }

        /***********************************************************************
        
                Place ещё данные из_ the источник поток преобр_в this буфер, and
                return the число of байты добавьed. This does not сожми the
                current буфер контент, so consопрer doing that explicitly.
                
                Возвращает: число of байты добавьed, which will be Кф when there
                         is no further ввод available. Zero is also a valid
                         ответ, meaning no данные was actually добавьed. 

        ***********************************************************************/

        final т_мера наполни ()
        {
                return писатель (&ввод.читай);
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

                Retrieve the valid контент

                Возвращает:
                a проц[] срез of the буфер

                Remarks:
                Return a проц[] срез of the буфер, из_ the current позиция
                up в_ the предел of valid контент. The контент remains in the
                буфер for future extraction.

        ***********************************************************************/

        final проц[] срез ()
        {
                return  данные [индекс .. протяженность];
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

        final проц[] срез (т_мера размер, бул съешь = да)
        {
                if (размер > читаемый)
                   {
                   // сделай some пространство? This will try в_ покинь as much контент
                   // in the буфер as possible, such that entire records may
                   // be aliased directly из_ within.
                   if (размер > (дименсия - индекс))
                       if (размер <= дименсия)
                           сожми;
                       else
                          провод.ошибка (недобор);

                   // наполни хвост of буфер with new контент
                   do {
                      if (писатель (&источник.читай) is Кф)
                          провод.ошибка (eofRead);
                      } while (размер > читаемый);
                   }

                auto i = индекс;
                if (съешь)
                    индекс += размер;
                return данные [i .. i + размер];
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

                if (счёт != Кф)
                   {
                   индекс += счёт;
                   assert (индекс <= протяженность);
                   }
                return счёт;
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

        public т_мера писатель (т_мера delegate (проц[]) дг)
        {
                auto счёт = дг (данные [протяженность..дименсия]);

                if (счёт != Кф)
                   {
                   протяженность += счёт;
                   assert (протяженность <= дименсия);
                   }
                return счёт;
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
                т_мера контент = читаемый;
                if (контент)
                   {
                   if (контент >= приёмн.length)
                       контент = приёмн.length;

                   // перемести буфер контент
                   приёмн [0 .. контент] = данные [индекс .. индекс + контент];
                   индекс += контент;
                   }
                else
                   // pathological cases читай directly из_ провод
                   if (приёмн.length > дименсия)
                       контент = источник.читай (приёмн);
                   else
                      {
                      if (записываемый is 0)
                          индекс = протяженность = 0;  // same as сотри, without вызов-chain

                      // keep буфер partially populated
                      if ((контент = писатель (&источник.читай)) != Кф && контент > 0)
                           контент = читай (приёмн);
                      }
                return контент;
        }

        /**********************************************************************

                Fill the provопрed буфер. Returns the число of байты
                actually читай, which will be less that приёмн.length when
                Кф есть been reached and Кф thereafter.

                Параметры:
                приёмн = where данные should be placed 
                exact = whether в_ throw an исключение when приёмн is not
                        filled (an Кф occurs first). Defaults в_ нет

        **********************************************************************/

        final т_мера заполни (проц[] приёмн, бул exact = нет)
        {
                т_мера длин = 0;

                while (длин < приёмн.length)
                      {
                      т_мера i = читай (приёмн [длин .. $]);
                      if (i is Кф)
                         {
                         if (exact && длин < приёмн.length)
                             провод.ошибка (eofRead);
                         return (длин > 0) ? длин : Кф;
                         }
                      длин += i;
                      }
                return длин;
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

        final бул пропусти (цел размер)
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

        /***********************************************************************

                Move the current читай location

        ***********************************************************************/

        final override дол сместись (дол смещение, Якорь старт = Якорь.Нач)
        {
                if (старт is Якорь.Тек)
                   {
                   // укз this specially because we know this is
                   // buffered - we should take преобр_в account the буфер
                   // позиция when seeking
                   смещение -= читаемый;
                   auto bpos = смещение + предел;

                   if (bpos >= 0 && bpos < предел)
                      {
                      // the new позиция is within the current
                      // буфер, пропусти в_ that позиция.
                      пропусти (cast(цел) bpos - cast(цел) позиция);

                      // see if we can return a valid смещение
                      auto поз = источник.сместись (0, Якорь.Тек);
                      if (поз != Кф)
                          return поз - читаемый;
                      return Кф;
                      }
                   // else, позиция is outsопрe the буфер. Do a реал
                   // сместись using the adjusted позиция.
                   }

                сотри;
                return источник.сместись (смещение, старт);
        }

        /***********************************************************************

                Обходчик support

                Параметры:
                скан = the delegate в_ invoke with the current контент

                Возвращает:
                Returns да if a token was isolated, нет otherwise.

                Remarks:
                Upon success, the delegate should return the байт-based
                индекс of the consumed образец (хвост конец of it). Failure
                в_ match a образец should be indicated by returning an
                Кф

                Each образец is ожидалось в_ be очищенный of the delimiter.
                An конец-of-файл condition causes trailing контент в_ be
                placed преобр_в the token. Requests made beyond Кф результат
                in пустой matches (length is zero).

                Note that добавьitional iterator and/or читатель instances
                will operate in lockstep when bound в_ a common буфер.

        ***********************************************************************/

        final бул следщ (т_мера delegate (проц[]) скан)
        {
                while (читатель(скан) is Кф)
                      {
                      // dопр we старт at the beginning?
                      if (позиция)
                          // yep - перемести partial token в_ старт of буфер
                          сожми;
                      else
                         // no ещё пространство in the буфер?
                         if (записываемый is 0)
                             провод.ошибка ("Бввод.следщ :: ввод буфер is full");

                      // читай другой chunk of данные
                      if (писатель(&источник.читай) is Кф)
                          return нет;
                      }
                return да;
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

        final Бввод сожми ()
        {       
                auto r = читаемый;

                if (индекс > 0 && r > 0)
                    // контент may overlap ...
                    memmove (&данные[0], &данные[индекс], r);

                индекс = 0;
                протяженность = r;
                return this;
        }

        /***********************************************************************

                Drain буфер контент в_ the specific провод

                Возвращает:
                Returns the число of байты записано, or Кф

                Remarks:
                Write as much of the буфер that the associated провод
                can используй. The провод is not obliged в_ используй все
                контент, so some may remain within the буфер.

        ***********************************************************************/

        final т_мера дренируй (ИПотокВывода приёмн)
        {
                assert (приёмн);

                т_мера ret = читатель (&приёмн.пиши);
                сожми;
                return ret;
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

                Cast в_ a мишень тип without invoking the wrath of the
                рантайм checks for misalignment. Instead, we обрежь the
                Массив length

        ***********************************************************************/

        static T[] преобразуй(T)(проц[] x)
        {
                return (cast(T*) x.ptr) [0 .. (x.length / T.sizeof)];
        }

        /***********************************************************************

                Clear буфер контент

                Remarks:
                Reset 'позиция' and 'предел' в_ zero. This effectively
                clears все контент из_ the буфер.

        ***********************************************************************/

        final override Бввод слей ()
        {
                индекс = протяженность = 0;

                // сотри the фильтр chain also
                if (источник) 
                    super.слей;
                return this;
        }

        /***********************************************************************

                Набор the ввод поток

        ***********************************************************************/

        final проц ввод (ИПотокВвода источник)
        {
                this.источник = источник;
        }

        /***********************************************************************

                Load the биты из_ a поток, up в_ an indicated length, and 
                return them все in an Массив. The function may используй ещё
                than the indicated размер where добавьitional данные is available
                during a block читай operation, but will not жди for ещё 
                than specified. An Кф terminates the operation.

                Returns an Массив representing the контент, and throws
                ВВИскл on ошибка
                              
        ***********************************************************************/

        final override проц[] загрузи (т_мера max = т_мера.max)
        {
                загрузи (super.ввод, super.провод.размерБуфера, max);
                return срез;
        }
                
        /***********************************************************************

                Import контент из_ the specified провод, expanding 
                as necessary up в_ the indicated maximum or until an 
                Кф occurs

                Returns the число of байты contained.
        
        ***********************************************************************/

        private т_мера загрузи (ИПотокВвода ист, т_мера инкремент, т_мера max)
        {
                т_мера  длин,
                        счёт;
                
                // сделай some room
                сожми;

                // explicitly resize?
                if (max != max.max)
                    if ((длин = записываемый) < max)
                         инкремент = max - длин;
                        
                while (счёт < max)
                      {
                      if (! записываемый)
                         {
                         дименсия += инкремент;
                         данные.length = дименсия;               
                         }
                      if ((длин = писатель(&ист.читай)) is Кф)
                           break;
                      else
                         счёт += длин;
                      }
                return счёт;
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

        private final Бввод установи (проц[] данные, т_мера читаемый)
        {
                this.данные = данные;
                this.протяженность = читаемый;
                this.дименсия = данные.length;

                // сбрось в_ старт of ввод
                this.индекс = 0;

                return this;
        }

        /***********************************************************************

                Available пространство

                Remarks:
                Return счёт of _writable байты available in буфер. This is
                calculated simply as ёмкость() - предел()

        ***********************************************************************/

        private final т_мера записываемый ()
        {
                return дименсия - протяженность;
        }
}



/*******************************************************************************

        Buffers the flow of данные из_ a upПоток вывод. A downПоток 
        neighbour can locate and use this буфер instead of creating 
        другой экземпляр of their own.

        (note that upПоток is closer в_ the источник, and downПоток is
        further away)

        Don't forget в_ слей() buffered контент before closing.

*******************************************************************************/

class Бвыв : ФильтрВывода, БуферВывода
{
        alias ФильтрВывода.вывод вывод;       /// access the сток

        private проц[]        данные;             // the необр данные буфер
        private т_мера        индекс;            // current читай позиция
        private т_мера        протяженность;           // предел of valid контент
        private т_мера        дименсия;        // maximum протяженность of контент

        /***********************************************************************

                Ensure the буфер remains valid between метод calls

        ***********************************************************************/

        invariant()
        {
                assert (индекс <= протяженность);
                assert (протяженность <= дименсия);
        }

        /***********************************************************************

                Construct a буфер

                Параметры:
                поток = an ввод поток
                ёмкость = desired буфер ёмкость

                Remarks:
                Construct a Буфер upon the provопрed ввод поток.

        ***********************************************************************/

        this (ИПотокВывода поток)
        {
                assert (поток);
                this (поток, поток.провод.размерБуфера);
        }

        /***********************************************************************

                Construct a буфер

                Параметры:
                поток = an ввод поток
                ёмкость = desired буфер ёмкость

                Remarks:
                Construct a Буфер upon the provопрed ввод поток.

        ***********************************************************************/

        this (ИПотокВывода поток, т_мера ёмкость)
        {
                установи (new ббайт[ёмкость], 0);
                super (сток = поток);
        }

        /***********************************************************************

                Attempts в_ совместно an upПоток Бвыв, and creates a new
                экземпляр where there's not a shared one available.

                Параметры:
                поток = an вывод поток

                Remarks:
                Where an upПоток экземпляр is visible it will be returned.
                Otherwise, a new экземпляр is создан based upon the размерБуфера
                exposed by the associated провод

        ***********************************************************************/

        static БуферВывода создай (ИПотокВывода поток)
        {
                auto сток = поток;
                auto провод = сток.провод;
                while (cast(Переключатель) сток is пусто)
                      {
                      auto b = cast(БуферВывода) сток;
                      if (b)
                          return b;
                      if (сток is провод)
                          break;
                      сток = сток.вывод;
                      assert (сток);
                      }
                      
                return new Бвыв (поток, провод.размерБуфера);
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

        final проц[] срез ()
        {
                return данные [индекс .. протяженность];
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

        final override т_мера пиши (проц[] ист)
        {
                добавь (ист.ptr, ист.length);
                return ист.length;
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

        final Бвыв добавь (проц[] ист)
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

        final Бвыв добавь (ук  ист, т_мера length)
        {
                if (length > записываемый)
                   {
                   слей;

                   // check for pathological case
                   if (length > дименсия)
                       do {
                          auto записано = сток.пиши (ист [0 .. length]);
                          if (записано is Кф)
                              провод.ошибка (eofWrite);
                          length -= записано;
                          ист += записано; 
                          } while (length > дименсия);
                    }

                // avoопр "out of bounds" тест on zero length
                if (length)
                   {
                   // контент may overlap ...
                   memmove (&данные[протяженность], ист, length);
                   протяженность += length;
                   }
                return this;
        }

        /***********************************************************************

                Available пространство

                Remarks:
                Return счёт of _writable байты available in буфер. This is
                calculated as ёмкость() - предел()

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

                Truncate буфер контент

                Remarks:
                Truncate the буфер within its протяженность. Returns да if
                the new length is valid, нет otherwise.

        ***********************************************************************/

        final бул обрежь (т_мера length)
        {
                if (length <= данные.length)
                   {
                   протяженность = length;
                   return да;
                   }
                return нет;
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

        /***********************************************************************

                Flush все буфер контент в_ the specific провод

                Remarks:
                Flush the contents of this буфер. This will block until
                все контент is actually flushed via the associated провод,
                whereas дренируй() will not.

                Throws an ВВИскл on premature Кф.

        ***********************************************************************/

        final override Бвыв слей ()
        {
                while (читаемый > 0)
                      {
                      auto ret = читатель (&сток.пиши);
                      if (ret is Кф)
                          провод.ошибка (eofWrite);
                      }

                // слей the фильтр chain also
                сотри;
                super.слей;
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

        final override Бвыв копируй (ИПотокВвода ист, т_мера max = -1)
        {
                т_мера chunk,
                       copied;

                while (copied < max && (chunk = писатель(&ист.читай)) != Кф)
                      {
                      copied += chunk;

                      // don't дренируй until we actually need в_
                      if (записываемый is 0)
                          if (дренируй(сток) is Кф)
                              провод.ошибка (eofWrite);
                      }
                return this;
        }

        /***********************************************************************

                Drain буфер контент в_ the specific провод

                Возвращает:
                Returns the число of байты записано, or Кф

                Remarks:
                Write as much of the буфер that the associated провод
                can используй. The провод is not obliged в_ используй все
                контент, so some may remain within the буфер.

        ***********************************************************************/

        final т_мера дренируй (ИПотокВывода приёмн)
        {
                assert (приёмн);

                т_мера ret = читатель (&приёмн.пиши);
                сожми;
                return ret;
        }

        /***********************************************************************

                Clear буфер контент

                Remarks:
                Reset 'позиция' and 'предел' в_ zero. This effectively
                clears все контент из_ the буфер.

        ***********************************************************************/

        final Бвыв сотри ()
        {
                индекс = протяженность = 0;
                return this;
        }

        /***********************************************************************

                Набор the вывод поток

        ***********************************************************************/

        final проц вывод (ИПотокВывода сток)
        {
                this.сток = сток;
        }

        /***********************************************************************

                Seek within this поток. Any and все buffered вывод is 
                disposed before the upПоток is invoked. Use an explicit
                слей() в_ излей контент prior в_ seeking

        ***********************************************************************/

        final override дол сместись (дол смещение, Якорь старт = Якорь.Нач)
        {       
                сотри;
                return super.сместись (смещение, старт);
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
                if it writes valid контент, or Кф on ошибка.

        ***********************************************************************/

        final т_мера писатель (т_мера delegate (проц[]) дг)
        {
                auto счёт = дг (данные [протяженность..дименсия]);

                if (счёт != Кф)
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
                байты consumed; or Кф в_ indicate an ошибка.

        ***********************************************************************/

        private final т_мера читатель (т_мера delegate (проц[]) дг)
        {
                auto счёт = дг (данные [индекс..протяженность]);

                if (счёт != Кф)
                   {
                   индекс += счёт;
                   assert (индекс <= протяженность);
                   }
                return счёт;
        }

        /***********************************************************************

                Available контент

                Remarks:
                Return счёт of _readable байты remaining in буфер. This is
                calculated simply as предел() - позиция()

        ***********************************************************************/

        private final т_мера читаемый ()
        {
                return протяженность - индекс;
        }

        /***********************************************************************

                Reset the буфер контент

                Параметры:
                данные =     the backing Массив в_ буфер within
                читаемый = the число of байты within данные consопрered
                           valid

                Возвращает:
                the буфер экземпляр

                Remarks:
                Набор the backing Массив with some контент читаемый. Writing
                в_ this will either слей it в_ an associated провод, or
                raise an Кф condition. Use сотри() в_ сбрось the контент
                (сделай it все записываемый).

        ***********************************************************************/

        private final Бвыв установи (проц[] данные, т_мера читаемый)
        {
                this.данные = данные;
                this.протяженность = читаемый;
                this.дименсия = данные.length;

                // сбрось в_ старт of ввод
                this.индекс = 0;

                return this;
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

        private final Бвыв сожми ()
        {       
                т_мера r = читаемый;

                if (индекс > 0 && r > 0)
                    // контент may overlap ...
                    memmove (&данные[0], &данные[индекс], r);

                индекс = 0;
                протяженность = r;
                return this;
        }
}



/******************************************************************************

******************************************************************************/

debug (Буферированный)
{
        проц main()
        {
                auto ввод = new Бввод (пусто);
                auto вывод = new Бвыв (пусто);
        }
}
