/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Mar 2004: Initial release
                        Dec 2006: Outback release
        
        author:         Kris

*******************************************************************************/

module io.model.ИБуфер;

private import io.model;

/*******************************************************************************

        Буфер is central concept in Dinrus I/O. Each буфер acts
        as a queue (строка) where items are removed из_ the front
        and new items are добавьed в_ the back. Buffers are modeled 
        by this interface and implemented in various ways.
        
        Буфер can be читай из_ and записано в_ directly, though 
        various данные-converters and filters are often leveraged 
        в_ apply structure в_ what might otherwise be simple необр 
        данные. 

        Buffers may also be tokenized by applying an Обходчик. 
        This can be handy when one is dealing with текст ввод, 
        and/or the контент suits a ещё fluопр форматируй than most 
        typical converters support. Обходчик семы are mapped 
        directly onto буфер контент (sliced), making them quite 
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

        See io.Buffer for ещё инфо.

*******************************************************************************/

abstract class ИБуфер : ИПровод, Буферированный
{
        alias добавь opCall;
        alias слей  opCall;
      
        /***********************************************************************
                
                реализует Буферированный interface

        ***********************************************************************/

        abstract ИБуфер буфер ();

        /***********************************************************************
                
                Return the backing Массив

        ***********************************************************************/

        abstract проц[] дайКонтент ();

        /***********************************************************************
        
                Набор the backing Массив with все контент читаемый. Writing
                в_ this will either слей it в_ an associated провод, or
                raise an Кф condition. Use ИБуфер.сотри() в_ сбрось the
                контент (сделай it все записываемый).

        ***********************************************************************/

        abstract ИБуфер устКонтент (проц[] данные);

        /***********************************************************************
        
                Набор the backing Массив with some контент читаемый. Writing
                в_ this will either слей it в_ an associated провод, or
                raise an Кф condition. Use ИБуфер.сотри() в_ сбрось the
                контент (сделай it все записываемый).

        ***********************************************************************/

        abstract ИБуфер устКонтент (проц[] данные, т_мера читаемый);

        /***********************************************************************

                Append an Массив of данные преобр_в this буфер, and слей в_ the
                провод as necessary. Returns a chaining reference if все 
                данные was записано; throws an ВВИскл indicating eof or 
                eob if not.

                This is often used in lieu of a Писатель.

        ***********************************************************************/

        abstract ИБуфер добавь (ук  контент, т_мера length);

        /***********************************************************************

                Append an Массив of данные преобр_в this буфер, and слей в_ the
                провод as necessary. Returns a chaining reference if все 
                данные was записано; throws an ВВИскл indicating eof or 
                eob if not.

                This is often used in lieu of a Писатель.

        ***********************************************************************/

        abstract ИБуфер добавь (проц[] контент);

        /***********************************************************************
        
                Append другой буфер в_ this one, and слей в_ the
                провод as necessary. Returns a chaining reference if все 
                данные was записано; throws an ВВИскл indicating eof or 
                eob if not.

                This is often used in lieu of a Писатель.

        ***********************************************************************/

        abstract ИБуфер добавь (ИБуфер другой);

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

        abstract проц используй (проц[] ист);

        /***********************************************************************
        
                Return a проц[] срез of the буфер up в_ the предел of
                valid контент.

        ***********************************************************************/

        abstract проц[] срез ();

        /***********************************************************************
        
                Return a проц[] срез of the буфер из_ старт в_ конец, where
                конец is исключительно

        ***********************************************************************/

        abstract проц[] opSlice (т_мера старт, т_мера конец);

        /***********************************************************************

                Чтен a chunk of данные из_ the буфер, loading из_ the
                провод as necessary. The requested число of байты are
                загружен преобр_в the буфер, and marked as having been читай 
                when the 'съешь' parameter is установи да. When 'съешь' is установи
                нет, the читай позиция is not adjusted.

                Returns the corresponding буфер срез when successful, 
                or пусто if there's not enough данные available (Кф; Eob).

        ***********************************************************************/

        abstract проц[] срез (т_мера размер, бул съешь = да);

        /***********************************************************************

                Access буфер контент

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

        abstract проц[] читайРовно (ук  приёмн, т_мера байты);
        
        /**********************************************************************

                Fill the provопрed буфер. Returns the число of байты
                actually читай, which will be less than приёмн.length when
                Кф есть been reached and ИПровод.Кф thereafter.

        **********************************************************************/

        abstract т_мера заполни (проц[] приёмн);

        /***********************************************************************

                Exposes the необр данные буфер at the current пиши позиция, 
                The delegate is provопрed with a проц[] representing пространство
                available within the буфер at the current пиши позиция.

                The delegate should return the approriate число of байты 
                if it writes valid контент, or ИПровод.Кф on ошибка.

                Returns whatever the delegate returns.

        ***********************************************************************/

        abstract т_мера писатель (т_мера delegate (проц[]) писатель);

        /***********************************************************************

                Exposes the необр данные буфер at the current читай позиция. The
                delegate is provопрed with a проц[] representing the available
                данные, and should return zero в_ покинь the current читай позиция
                intact. 
                
                If the delegate consumes данные, it should return the число of 
                байты consumed; or ИПровод.Кф в_ indicate an ошибка.

                Returns whatever the delegate returns.

        ***********************************************************************/

        abstract т_мера читатель (т_мера delegate (проц[]) читатель);

        /***********************************************************************

                If we have some данные left after an export, перемести it в_ 
                front-of-буфер and установи позиция в_ be just after the 
                remains. This is for supporting certain conduits which 
                choose в_ пиши just the начальное portion of a request.
                            
                Limit is установи в_ the amount of данные remaining. Position 
                is always сбрось в_ zero.

        ***********************************************************************/

        abstract ИБуфер сожми ();

        /***********************************************************************
        
                SkИП ahead by the specified число of байты, Потокing из_ 
                the associated провод as necessary.
        
                Can also реверс the читай позиция by 'размер' байты. This may
                be used в_ support lookahead-тип operations.

                Returns да if successful, нет otherwise.

        ***********************************************************************/

        abstract бул пропусти (цел размер);

        /***********************************************************************

                Support for tokenizing iterators. 
                
                Upon success, the delegate should return the байт-based 
                индекс of the consumed образец (хвост конец of it). Failure
                в_ match a образец should be indicated by returning an
                ИПровод.Кф.

                Each образец is ожидалось в_ be очищенный of the delimiter.
                An конец-of-файл condition causes trailing контент в_ be 
                placed преобр_в the token. Requests made beyond Кф результат
                in пустой matches (length == zero).

                Note that добавьitional iterator and/or читатель instances
                will stay in lockstep when bound в_ a common буфер.

                Returns да if a token was isolated, нет otherwise.

        ***********************************************************************/

        abstract бул следщ (т_мера delegate (проц[]));

        /***********************************************************************

                Try в_ _fill the available буфер with контент из_ the 
                specified провод. We try в_ читай as much as possible 
                by clearing the буфер when все current контент есть been 
                eaten. If there is no пространство available, nothing will be 
                читай.

                Returns the число of байты читай, or Провод.Кф.
        
        ***********************************************************************/

        abstract т_мера заполни (ИПотокВвода ист);

        /***********************************************************************

                Write as much of the буфер that the associated провод
                can используй.

                Returns the число of байты записано, or Провод.Кф.
        
        ***********************************************************************/

        abstract т_мера дренируй (ИПотокВывода приёмн);

        /***********************************************************************
        
                Truncate the буфер within its протяженность. Returns да if
                the new 'протяженность' is valid, нет otherwise.

        ***********************************************************************/

        abstract бул обрежь (т_мера протяженность);

        /***********************************************************************

                Configure the compression strategy for iterators

                Remarks:
                Iterators will tend в_ сожми the buffered контент in
                order в_ maximize пространство for new данные. You can disable this
                behaviour by настройка this булево в_ нет

        ***********************************************************************/

        abstract бул сожми (бул да);
        
        /***********************************************************************
        
                Return счёт of читаемый байты remaining in буфер. This is 
                calculated simply as предел() - позиция().

        ***********************************************************************/

        abstract т_мера читаемый ();               

        /***********************************************************************
        
                Return счёт of записываемый байты available in буфер. This is 
                calculated simply as ёмкость() - предел().

        ***********************************************************************/

        abstract т_мера записываемый ();

        /***********************************************************************

                Reserve the specified пространство within the буфер, compressing
                existing контент as necessary в_ сделай room

                Returns the current читай point, after compression if that
                was required

        ***********************************************************************/

        abstract т_мера резервируй (т_мера пространство);

        /***********************************************************************
        
                Returns the предел of читаемый контент within this буфер.

        ***********************************************************************/

        abstract т_мера предел ();               

        /***********************************************************************
        
                Returns the total ёмкость of this буфер.

        ***********************************************************************/

        abstract т_мера ёмкость ();               

        /***********************************************************************
        
                Returns the current позиция within this буфер.

        ***********************************************************************/

        abstract т_мера позиция ();               

        /***********************************************************************
        
                Sets the external провод associated with this буфер.

                Buffers do not require an external провод в_ operate, but 
                it can be convenient в_ associate one. For example, methods
                читай and пиши use it в_ import/export контент as necessary.

        ***********************************************************************/

        abstract ИБуфер setConduit (ИПровод провод);

        /***********************************************************************
        
                Набор вывод поток

                Параметры:
                сток = the поток в_ прикрепи в_

                Remarks:
                Sets the external вывод поток associated with this буфер.

                Buffers do not require an external поток в_ operate, but 
                it can be convenient в_ associate one. For example, methods
                заполни & дренируй use them в_ import/export контент as necessary.

        ***********************************************************************/

        abstract ИБуфер вывод (ИПотокВывода сток);

        /***********************************************************************
        
                Набор ввод поток

                Параметры:
                источник = the поток в_ прикрепи в_

                Remarks:
                Sets the external ввод поток associated with this буфер.

                Buffers do not require an external поток в_ operate, but 
                it can be convenient в_ associate one. For example, methods
                заполни & дренируй use them в_ import/export контент as necessary.

        ***********************************************************************/

        abstract ИБуфер ввод (ИПотокВвода источник);

        /***********************************************************************

                Transfer контент преобр_в the provопрed приёмн.

                Параметры: 
                приёмн = destination of the контент

                Возвращает:
                Return the число of байты читай, which may be less than
                приёмн.length. Кф is returned when no further контент is
                available.

                Remarks:
                Populates the provопрed Массив with контент. We try в_ 
                satisfy the request из_ the буфер контент, and читай 
                directly из_ an attached провод when the буфер is 
                пустой.

        ***********************************************************************/

        abstract т_мера читай (проц[] приёмн);

        /***********************************************************************

                Emulate ИПотокВывода.пиши()

                Параметры: 
                ист = the контент в_ пиши

                Возвращает:
                Return the число of байты записано, which will be Кф when
                the контент cannot be записано.

                Remarks:
                Appends все of приёмн в_ the буфер, flushing в_ an attached
                провод as necessary.

        ***********************************************************************/

        abstract т_мера пиши (проц[] ист);

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

        abstract ИПотокВывода вывод ();

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

        abstract ИПотокВвода ввод ();

        /***********************************************************************
        
                Throw an исключение with the provопрed сообщение

        ***********************************************************************/

        abstract проц ошибка (ткст сооб);

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

        abstract ИПровод провод ();

        /***********************************************************************
        
                Return a preferred размер for buffering провод I/O.

        ***********************************************************************/

        abstract т_мера размерБуфера (); 
                     
        /***********************************************************************
        
                Return the имя of this провод.

        ***********************************************************************/

        abstract ткст вТкст (); 
                     
        /***********************************************************************

                Is the провод alive?

        ***********************************************************************/

        abstract бул жив_ли ();

        /***********************************************************************
        
                Flush the contents of this буфер в_ the related провод.
                Throws an ВВИскл on premature eof.

        ***********************************************************************/

        abstract ИПотокВывода слей ();

        /***********************************************************************
        
                Reset позиция and предел в_ zero.

        ***********************************************************************/

        abstract ИПотокВвода сотри ();               

        /***********************************************************************
        
                Copy контент via this буфер из_ the provопрed ист
                провод.

                Remarks:
                The ист провод есть its контент transferred through 
                this буфер via a series of заполни & дренируй operations, 
                until there is no ещё контент available. The буфер
                контент should be explicitly flushed by the caller.

                Throws an ВВИскл on premature Кф.

        ***********************************************************************/

        abstract ИПотокВывода копируй (ИПотокВвода ист, т_мера max=-1);

        /***********************************************************************
                
                Release external resources

        ***********************************************************************/

        abstract проц открепи ();

        /***********************************************************************
        
                Close the поток

                Remarks:
                Propagate request в_ an attached ИПотокВывода (this is a
                requirement for the ИПотокВывода interface)

        ***********************************************************************/

        abstract проц закрой ();
}


/*******************************************************************************

        Supported by Потокs which are prepared в_ совместно an internal буфер 
        экземпляр. This is intended в_ avoопр a situation whereby контент is
        shunted unnecessarily из_ one буфер в_ другой when "decorator"
        Потокs are подключен together in arbitrary ways.
        
        Do not implement this if the internal буфер should not be использовался 
        directly by другой поток e.g. if wrapper methods manИПulate контент
        on the way in or out of the буфер.

*******************************************************************************/

interface Буферированный
{
        ИБуфер буфер();
}
