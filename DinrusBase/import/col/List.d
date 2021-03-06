//============================================================================
// Список.d - Структура данных линкованного списка 
//
// Написано на языке программирования Динрус (http://github.com/DinrusGroup)
/*****************************************************************************
 * Структура данных линкованного списка.
 * 
 * Структура данных дважды линкованного списка изначально основана на таковой в 
 *  ArcLib.  Интерфейс был изменён в подражание STL std.list
 * тип уплотнён, добавлено несколько новых членов.
 *
 *  Автор:  William З. Baxter III, OLM Digital, Inc.
 *  Дата: 04 Sep 2007
 *  Лицензия:       zlib/libpng
 */
//============================================================================
module col.List;

/+ ИНТЕРФЕЙС:

class неверный_обходчик : Искл
{
    this(ткст сооб) ;
}


struct ОбходСписка(Т, бул резерв_ли = нет)
 {
    alias Т тип_значения;
    alias Т* указатель;
    alias Список!(Т).Узел тип_узла;
    alias Список!(Т).Узел* указатель_на_узел;

    private static ОбходСписка opCall(указатель_на_узел иниц) ;
    Т знач();
    Т* укз();
    цел opEquals(ref ОбходСписка other);
    проц opPostInc();
    проц opAddAssign(цел i) ;
    проц opPostDec() ;
    проц opSubAssign(цел i) ;
}

ОбходСписка!(Т) обход_списка_начало(Т)(Т[] x);
ОбходСписка!(Т) обход_списка_конец(Т)(Т[] x);
ОбходСписка!(Т,да) обход_списка_начало_рев(Т)(Т[] x);
ОбходСписка!(Т,да) обход_списка_конец_рев(Т)(Т[] x);

template обходчик_списка(Т) {
    alias ОбходСписка!(Т,нет) обходчик_списка;
}

template обходчик_списка_рев(Т) {
    alias ОбходСписка!(Т,да) обходчик_списка_рев;
}


struct Список(Т)
{

    alias Т тип_значения;
    alias Т* указатель;
    alias Узел тип_узла;
    alias Узел* указатель_на_узел;
    alias обходчик_списка!(Т) обходчик;
    alias обходчик_списка_рев!(Т) реверсОбходчик;


    обходчик приставь(ref Т новДанные);
    проц opCatAssign(ref Т новДанные);
    обходчик предпоставь(ref Т новДанные);
    обходчик вставь(обходчик обход, ref Т новДанные);
    обходчик удали(обходчик обход);
    цел длина();
    цел размер();
    бул пуст();
    проц сотри();
	бул opIn_r(Т данные);
	обходчик найди(Т данные);
	цел opApply(цел delegate(ref Т) dg);
	цел opApplyReverse(цел delegate(ref Т) dg);
    обходчик начало() ;
    обходчик конец() ;
    реверсОбходчик начало_рев() ;
    реверсОбходчик конец_рев();
    Т первый(); 
    Т последний();
	
protected:
    Узел* голова();
    Узел* хвост();
    проц голова(Узел* h);
    проц хвост(Узел* т) ;

private:
   цел размерСписка_ = 0;
    struct Узел
    {
        Т данные;
        Узел* предш = пусто;
        Узел* следщ = пусто;
    }
}


+/


class неверный_обходчик : Искл
{
    this(ткст сооб) { super(сооб); }
}


/// Iterator type for Список
struct ОбходСписка(Т, бул резерв_ли = нет) {
    alias Т тип_значения;
    alias Т* указатель;
    alias Список!(Т).Узел тип_узла;
    alias Список!(Т).Узел* указатель_на_узел;

    private static ОбходСписка opCall(указатель_на_узел иниц) {
        ОбходСписка M; with(M) {
            укз_ = иниц;
        } return M;
    }

    /// Вернуть значение, на которое ссылается обходчик
    Т знач() { assert(укз_ !is пусто); return укз_.данные; }

    ///Вернуть указатель на значение, к которому ссылается обходчик
    Т* укз() { assert(укз_ !is пусто); return &укз_.данные; }
    
    цел opEquals(ref ОбходСписка other) {
        return укз_ is other.укз_;
    }

    /// обход++
    проц opPostInc() {
        _аванс(); 
    }
    /// ++обход
    проц opAddAssign(цел i) {
        assert(i==1, "неверная операция");
        _аванс(); 
    }
    /// обход--
    проц opPostDec() {
        _отход(); 
    }
    /// --обход
    проц opSubAssign(цел i) {
        assert(i==1, "неверная операция");
        _отход(); 
    }
private:
    проц _аванс() {
        assert(укз_ !is пусто);
        static if(резерв_ли) {
            укз_=укз_.предш;
        } else {
            укз_=укз_.следщ;
        }
    }
    проц _отход() {
        assert(укз_ !is пусто);
        static if(резерв_ли) {
            укз_=укз_.следщ;
        }
        else {
            укз_=укз_.предш;
        }
    }
private:
    указатель_на_узел укз_  = пусто;
}

ОбходСписка!(Т) обход_списка_начало(Т)(Т[] x) {
    return x.начало();
}
ОбходСписка!(Т) обход_списка_конец(Т)(Т[] x) {
    return x.конец();
}
ОбходСписка!(Т,да) обход_списка_начало_рев(Т)(Т[] x) {
    return ОбходСписка!(Т).начало(x);
}
ОбходСписка!(Т,да) обход_списка_конец_рев(Т)(Т[] x) {
    return ОбходСписка!(Т).конец(x);
}

template обходчик_списка(Т) {
    alias ОбходСписка!(Т,нет) обходчик_списка;
}

template обходчик_списка_рев(Т) {
    alias ОбходСписка!(Т,да) обходчик_списка_рев;
}


/** Структура данных линкованного списка
 *
 *  Использует структура данных дважды линкованного списка внутренне.
 */
struct Список(Т)
{
public:
    alias Т тип_значения;
    alias Т* указатель;
    alias Узел тип_узла;
    alias Узел* указатель_на_узел;
    alias обходчик_списка!(Т) обходчик;
    alias обходчик_списка_рев!(Т) реверсОбходчик;

    /// Приставить  элт в список
    обходчик приставь(ref Т новДанные)
    {
        return вставь_узел_перед(&якорь_, новДанные);
    }

    /// Также приставить элт к списку, используя синтаксис L ~= элт.
    проц opCatAssign(/*const*/ ref Т новДанные) { приставь(новДанные); }

    /// Предпоставить элт в голову списка
    обходчик предпоставь(ref Т новДанные)
    {
        if (пуст() && голова is пусто) {
            // Really we'd like all lists to be initialized this way,
            // but without forcing the use of a static opCall constructor
            // it's not currently possible.
            якорь_.следщ = &якорь_;
            якорь_.предш = &якорь_;
        }
        return вставь_узел_перед(голова, новДанные);
    }


    /// Вставить элемент перед обход
    обходчик вставь(обходчик обход, ref Т новДанные)
    {
        return вставь_узел_перед(обход.укз_, новДанные);
    }

    // Выполняет все вставки
    private обходчик вставь_узел_перед(Узел* перед, ref Т новДанные)
    {
        Узел* элт = new Узел;
        элт.данные = новДанные;
      
        if (пуст()) // первый элт в списке
        {
            assert (перед is &якорь_);
            элт.следщ = &якорь_;
            элт.предш = &якорь_;
            якорь_.следщ = элт;
            якорь_.предш = элт;
        } 

        else // добавить перед 'перед'
        {
            Узел* предш = перед.предш;
            assert(предш !is пусто);

            элт.предш   = предш;
            элт.следщ   = перед;
            предш.следщ   = элт;
            перед.предш = элт;
        }

        размерСписка_++;

        return ОбходСписка!(Т)(элт);
    }

    /// Удалить узел, на к-й указывает обход, из списка
    /// возвращает обходчик к узлу, следующему за удалённым узлом.
    обходчик удали(обходчик обход)
    {
        Узел* curr = обход.укз_;
        бул bad_iter = (curr is пусто) || (curr is &якорь_);
        if (bad_iter) {
            throw new неверный_обходчик("Список.удали: неверный обходчик");
        }
        debug {
            //Правда ли этот узел в нашем списке??
        }
        обходчик next_iter = обход; ++next_iter;

        curr.следщ.предш = curr.предш;
        curr.предш.следщ = curr.следщ;
      
        delete curr;
      
        размерСписка_--;

        return next_iter;
    }


    /// Возвращает длина списка
    цел длина() { return размерСписка_; }

    /// Возвращает размер списка, так же как и длина()
    цел размер() { return размерСписка_; }
   
    /// Простая функция для определения, пуст ли список или нет
    бул пуст() 
    {
        return (размерСписка_ == 0);
    }

    ///Очистить все данные из списка
    проц сотри()
    {
        auto it = начало();
        auto конец = конец();

        for (; it != конец; ++it)
            удали(it);
    }

	/// 'элт в реализации списка.  Производительность O(N).
	бул opIn_r(Т данные)
	{
		foreach(Т d; *this)
			if (d == данные)
				return да; 
				
		return нет; 
	}

	/// Найти элт список, return обходчик.  Производительность O(N).
    /// Если не найдено, возвращает this.конец()
	обходчик найди(Т данные)
	{
        обходчик it = начало(), _конец=конец();
        
        for(; it!=_конец; ++it) {
			if (*it.укз == данные)
				return it; 
		}		
		return it; 
    }

	// foreach обходчик forwards 
	цел opApply(цел delegate(ref Т) dg)
	{
		Узел* curr=голова;
        if (curr is пусто) return 0; // особый случай для инициализированного списка
		while (curr !is &якорь_)
		{
            Узел* следщ = curr.следщ;
			цел result = dg(curr.данные);
			if(result) return result;
            curr = следщ;
		}
		return 0; 
	}

	// foreach обходчик backwards 
	цел opApplyReverse(цел delegate(ref Т) dg)
	{
		Узел* curr = хвост;
        if (curr is пусто) return 0; // особый случай для инициализированного списка
		while (curr !is &якорь_)
		{
            Узел* предш = curr.предш;
			цел result = dg(curr.данные);
			if(result) return result;
            curr = предш;
		}
		return 0; 
	}
	

    /*******************************************************************************
   
      Возвращает текущие данные из списка
   
    *******************************************************************************/

    обходчик начало() {
        return ОбходСписка!(Т)(голова);
    }
    обходчик конец() {
        return ОбходСписка!(Т)(&якорь_);
    }
    реверсОбходчик начало_рев() {
        return ОбходСписка!(Т,да)(хвост);
    }
    реверсОбходчик конец_рев() {
        return ОбходСписка!(Т,да)(&якорь_);
    }

	/// Вернуть первый элемент в списке
    Т первый()
    {
        assert(!пуст(), "первый: список пуст!"); 
        return голова.данные;
    }

	/// Возвращает последний элемент в списке 
    Т последний()
    {
        assert(!пуст(), "последний: список пуст!"); 
        return хвост.данные;
    }

/+
	// http://www.chiark.greenend.org.uk/~sgtatham/algorithms/listsort.html
	/// Выполнить маржную сортировку над данным линкованым списком 
	проц sort()
	{
		Узел* p;
		Узел* q;
		Узел* e;
		Узел* oldhead;
		
		цел insize, nmerges, psize, qsize, i;

		/*
		 * Тупо особый случай: если `список' передан как пусто, return
		 * пусто сразу же.
		 */
		if (голова is пусто)
			return;

		insize = 1;

		while (1) 
		{
			p = голова;
			oldhead = голова;		       /* only used for circular linkage */
			голова = пусто;
			хвост = пусто;

			nmerges = 0;  /* считанное число маржей делается в этой проходке */

			while (p !is пусто) 
			{
				nmerges++;  /* сужествует маржа, которую нужно выплнить */
				/* шаг `insize' места along from p */
				q = p;
				psize = 0;
				
				for (i = 0; i < insize; i++) 
				{
					psize++;

					q = q.следщ;

					if (q is пусто) break;
				}

				/* если q не выпало из конец, у нас два маржируемых списка */
				qsize = insize;

				/* теперь у нас два списка; маржируем их */
				while (psize > 0 || (qsize > 0 && q !is пусто)) 
				{

					/* определить, идёт ли следщ элемент маржи от p или q */
					if (psize == 0) 
					{
						/* p is пуст; e must come from q. */
						e = q; q = q.следщ; qsize--;
					} else if (qsize == 0 || q is пусто) 
					{
						/* q is пуст; e must come from p. */
						e = p; p = p.следщ; psize--;
					} else if (p <= q) {
						/* First element of p is lower (or same);
						 * e must come from p. */
						e = p; p = p.следщ; psize--;
					} else {
						/* Первый элемент из q ниже; e должно идти от q. */
						e = q; q = q.следщ; qsize--;
					}

                    /* добавить следщ элемент в маржированный список */
					if (хвост !is пусто) 
					{
						хвост.следщ = e;
					} 
					else 
					{
						голова = e;
					}
                    e.предш = хвост;

					хвост = e;
				}

				/*теперь p вступило `insize' places along, а q должно тоже */
				p = q;
			}
		
			хвост.следщ = пусто;

			/* Если выполнена только одна маржа, мы окончили. */
			if (nmerges <= 1)   /* allow for nmerges==0, t случай с пустым списком*/
				return;

			/* Иначе повторить, маржируя списки на удвоенной размер */
			insize *= 2;
		}
	}
+/

protected:
    Узел* голова() { return якорь_.следщ; }
    Узел* хвост() { return якорь_.предш; }
    проц голова(Узел* h) { якорь_.следщ = h; }
    проц хвост(Узел* т) { якорь_.предш = т; }

private:

    // Note there's always an "anchor" node, and nodes are stored in circular manner.
    // This makes it work well with STL style iterators that need a distinct начало and
    // конец nodes for forward and reverse iteration.
    // Unfortunately it wastes Т.sizeof bytes on useless payload данные.
    // We could make Узел a class and then use inheritance to create AnchorNode and PayloadNode
    // subclasses, but then we have overhead of N*reference.sizeof (i.e. O(N) overhead).
    Узел якорь_;

    // Keep track of размер so that 'длина' checks are O(1) 
    цел размерСписка_ = 0;

    /// The internal node structure with предш/следщ pointers and the user данные payload
    struct Узел
    {
        Т данные;
        Узел* предш = пусто;
        Узел* следщ = пусто;
    }
}

version(Unittest) {
    //import stdrus;
}
unittest {
    version(Unittest){
    скажинс("----список tests----");

    бул checkeq(ref список!(цел) l, ткст знач)
    {
        char[] o;
        foreach(i; l) {
            o ~= фм(i);
        }
        return знач==o;
    }


    Список!(цел) ilist;
    assert(ilist.пуст());

    ilist ~= 1;
    assert(! ilist.пуст());
    ilist.приставь(2);
    ilist ~= 3;
    ilist.приставь(4);
    ilist ~= 5;

    assert(! ilist.пуст());

    char[] o;
    foreach(i; ilist) {
        o ~= фм(i);
    }
    assert(o == "12345");
    o = пусто;
    foreach_reverse(i; ilist) {
        o ~= фм(i);
    }
    assert(o == "54321");

    // Iterator tests //

    {
        o=пусто;
        auto it=ilist.начало(),конец=ilist.конец();
        for(; it != конец; ++it) {
            o ~= фм(it.знач);
        }
        assert(o == "12345");
    }
    {
        o = пусто;
        auto it=ilist.начало_рев(),конец=ilist.конец_рев();
        for(; it != конец; ++it) {
            o ~= фм(it.знач);
        }
        assert(o == "54321");
    }    

    // opIn_r tests //

    for (цел i=1; i<=5; i++) {
        assert(i in ilist);
    }
    assert(!(99 in ilist));
    assert(!(0 in ilist));

    assert(ilist.последний == 5);
    assert(ilist.первый == 1);

    // Find test //
    {
        auto it = ilist.найди(99);
        assert(it==ilist.конец());
        for (цел i=1; i<=5; i++) {
            it = ilist.найди(i);
            assert(it!=ilist.конец());
            assert(it.знач == i);
            assert(*it.укз == i);
        }
    }
    //тесты вставки //
    {
        auto it = ilist.найди(3);
        ilist.вставь(it, 9);
        assert( checkeq(ilist, "129345") );
        ilist.вставь(ilist.начало(), 8);
        assert( checkeq(ilist, "8129345") );
        ilist.вставь(ilist.конец(), 7);
        assert( checkeq(ilist, "81293457") );
    }

    // тесты удаления //
    {
        auto it = ilist.найди(3);
        ilist.удали(it);
        assert( checkeq(ilist, "8129457") );
        ilist.удали(ilist.начало);
        assert( checkeq(ilist, "129457") );
        auto last = ilist.конец; last--;
        ilist.удали(last);
        assert( checkeq(ilist, "12945") );
        
        ilist.удали(ilist.начало);
        assert( checkeq(ilist, "2945") );
        ilist.удали(ilist.начало);
        assert( checkeq(ilist, "945") );
        ilist.удали(ilist.начало);
        assert( checkeq(ilist, "45") );
        ilist.удали(ilist.начало);
        assert( checkeq(ilist, "5") );
        ilist.удали(ilist.начало);
        assert( checkeq(ilist, "") );

        assert(ilist.найди(1) == ilist.конец());
        
        // Попытаемся вставить в ранее не пустой список
        assert(ilist.пуст());
        ilist ~= 9;
        assert(!ilist.пуст());
        assert( checkeq(ilist, "9") );
        assert( ilist.найди(9).знач == 9 );

        *ilist.найди(9).укз = 8;
        assert( ilist.найди(8).знач == 8 );
        assert(ilist.длина == 1);
    }

    скажинс("----тесты списка завершены ----");
    }
    else {
        assert(нет, "List.d module unittest requires -version=Unittest");
    }
}