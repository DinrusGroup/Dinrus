﻿module gc;
import dinrus;

const бцел ВЕРСИЯ_СМ = 1;
alias проц (*ФИНАЛИЗАТОР_СМ)(ук p, бул dummy);
alias ФИНАЛИЗАТОР_СМ GC_FINALIZER;
/////////////////////////////////////////////////
/**
 * Данная структура инкапсулирует в себе функциональность сборщика мусора
 * языка программирования Динрус.
 */
extern (D) class СборщикМусора
{
    private т_см экз;

    бцел версия();

    this()
    {
        this = смНовый();
        this.иниц();
    }

    ~this()
    {
        смУдали(this);
    }
    проц иниц();
    проц Дтор();
    проц монитор (проц delegate() начало, проц delegate(цел, цел) конец);
    проц вкл();
    проц откл();
    проц собери();//!!!
    проц уменьши();
    бцел дайАтр( ук p );
    бцел устАтр( ук p, ПАтрБлока a );
    бцел удалиАтр( ук p, ПАтрБлока a );
    ук празмести( т_мера разм, бцел ba = 0, т_мера *alloc_size = null );
    ук кразмести( т_мера разм, бцел ba = 0, т_мера *alloc_size = null );
    ук перемести( ук p, т_мера разм, бцел ba = 0, т_мера *alloc_size = null);
    т_мера расширь(ук p, т_мера минразм, т_мера максразм);
    т_мера резервируй( т_мера разм );
    проц освободи( ук p );
    ук адрес_у( ук p );
    т_мера размер_у( ук p );
    ИнфОБл опроси( ук p );
    проц проверь(ук p);
    проц добавьКорень( ук p );
    цел delegate(цел delegate(ref ук)) обходКорня();
    проц добавьПространство( ук p, т_мера разм );
    проц добавьПространство(ук Низ, ук Верх);
    цел delegate(цел delegate(ref Пространство)) обходПространства();
    проц удалиКорень( ук p );
    проц удалиПространство( ук p );
    проц мониторируй( проц delegate() начало, проц delegate(цел, цел) конец );
    ук создайСлабУк( Объект o );
    проц удалиСлабУк( ук p );
    Объект дайСлабУк( ук p );
    т_мера нарастиДлину (т_мера newlength, т_мера elSize=1);
    т_мера нарастиДлину(т_мера newlength, т_мера elSize, т_мера a, т_мера b=0, т_мера minBits=1);
    проц полныйСбор();
    проц полныйСборБезСтэка();
    проц генСбор();
    проц естьУказатели(ук p);
    проц нетУказателей(ук p);
    проц устВ1_0();
    т_мера ёмкость(ук p);
    проц сканируйСтатДан(т_см g);
    проц отсканируйСтатДан(т_см g);
    проц экономь();
    проц дайСтат(out СМСтат стат);
    проц устФинализатор(ук p, ФИНАЛИЗАТОР_СМ pFn);
}
alias СборщикМусора СМ, т_см, gc_t;

extern (C):

//Закомментированнные импорты указаны в модуле base,
//хотя и относятся к сборщику мусора. base - это базовый модуль,
//поэтому его импортом будет импортироваться весь рантайм Динрус,
//без необходимости подключать данный модуль или какие-то ещё, например, thread.

    /+
    бул смПроверь(ук p);
    бул смУменьши();
    бул смДобавьКорень( ук p );
    бул смДобавьПространство( ук p, т_мера разм );
    бул смДобавьПространство2( ук p, ук разм );
    бул смУдалиКорень( ук p );
    бул смУдалиПространство( ук p );
    т_мера смЁмкость(ук p);
    бул смМонитор(ddel начало, dint конец );
    бул смСтат();
    СМСтат смДайСтат();
    проц[] смПразместиМас(т_мера члобайт);
    проц[] смПереместиМас(ук  p, т_мера члобайт);
    бул устИнфОТипе(ИнфОТипе иот, ук  p);
    ук  дайУкНаСМ();
    бул укНаСМ(ук  p);
    бул сбросьУкНаСМ();
    бцел смДайАтр( ук  p );
    бцел смУстАтр( ук  p, ПАтрБлока a );
    бцел смУдалиАтр( ук  p, ПАтрБлока a );
    ук  смПразмести( т_мера разм, бцел ba = 0 );
    ук  смКразмести( т_мера разм, бцел ba = 0 );
    ук  смПеремести( ук  p, т_мера разм, бцел ba = 0 );
    т_мера смРасширь( ук p, т_мера mx, т_мера разм );
    т_мера смРезервируй( т_мера разм );
    бул смОсвободи( ук  p );
    ук  смАдрес( ук  p );
    т_мера смРазмер( ук  p );
    ук  смСоздайСлабУк( Объект r );
    бул смУдалиСлабУк( ук  wp );
    Объект смДайСлабУк( ук  wp );
    ИнфОБл смОпроси( ук  p );
    бул смВключи();
    бул смОтключи();
    бул смСобери();
    +/
    т_см смНовый();
    проц смУдали(т_см см);
    /+бул смИниц_ли();
//цел смОбходКорня();
//цел смОбходПространства();

    проц setFinalizer(ук p, GC_FINALIZER pFn);

    void setTypeInfo(TypeInfo ti, void* p);
    void* getGCHandle();
    void setGCHandle(void* p);
    void endGCHandle();

    void gc_init();
    void gc_term();
    size_t gc_capacity(void* p);
    void gc_minimize();
    void gc_addRoot( void* p );
    void gc_addRange( void* p, size_t разм );
    void gc_removeRoot( void* p );
    void gc_removeRange( void* p );
    void gc_monitor(ddel begin, dint end );
    +/
    void gc_printStats(gc_t gc);
    /+GCStats gc_stats();
    void _d_gc_addrange(void *pbot, void *ptop);
    void _d_gc_removerange(void *pbot);
    uint gc_getAttr( void* p );
    uint gc_setAttr( void* p, uint a );
    uint gc_clrAttr( void* p, uint a );
    void* gc_malloc( size_t разм, uint ba = 0 );
    void* gc_calloc( size_t разм, uint ba = 0 );
    void* gc_realloc( void* p, size_t разм, uint ba = 0 );
    size_t gc_extend( void* p, size_t mx, size_t разм );
    size_t gc_reserve( size_t разм );
    void gc_free( void* p );
    void* gc_addrOf( void* p );
    size_t gc_sizeOf( void* p );
    void* gc_weakpointerCreate( Object r );
    void gc_weakpointerDestroy( void* wp );
    Object gc_weakpointerGet( void* wp );
    BlkInfo gc_query( void* p );
    void gc_enable();
    void gc_disable();
    void gc_collect();
    void gc_check(void *p);
    void gc_addRangeOld( ук  p, ук разм );
    +/
