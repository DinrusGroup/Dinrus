/*******************************************************************************

    copyright:  Copyright © 2007 Daniel Keep.  все rights reserved.

    license:    BSD стиль: $(LICENSE)

    version:    The Great Namechange: February 2008

                Initial release: December 2007

    author:     Daniel Keep

*******************************************************************************/

module io.vfs.ZipFolder;

import Путь = io.Path;
import io.device.File : Файл;
import io.FilePath : ФПуть;
import io.device.TempFile : ВремФайл;
import util.compress.Zip : ЧитательЗип, ЧитательБлокаЗип,
       ПисательЗип, ПисательБлокаЗип, ЗаписьЗип, ИнфоОЗаписиЗип, Метод;
import io.model : ИПровод, ИПотокВвода, ИПотокВывода;
import io.vfs.model : ПапкаВфс, ЗаписьПапкиВфс, ФайлВфс,
       ПапкиВфс, ФайлыВфс, ФильтрВфс, СтатсВфс, ИнфОФильтреВфс,
       ИнфОВфс, СинхВфс;
import time.Time : Время;

debug( ПапкаЗип )
{
    import io.Stdout : Стдош;
}

// This disables код that is causing куча corruption in Dinrus 0.99.3
version = Bug_HeapCorruption;

// ************************************************************************ //
// ************************************************************************ //

private
{
    enum ТипЗаписи { Пап, Файл }
   
    /*
     * Entries are what сделай up the internal дерево that describes the
     * filesystem of the архив.  Each Запись is either a дир or a файл.
     */
    struct Запись
    {
        ТипЗаписи тип;

        union
        {
            ПапЗапись пап;
            ФайлЗапись файл;
        }

        ткст полное_имя;
        ткст имя;

        /+
        invariant
        {
            assert( (тип == ТипЗаписи.Пап)
                 || (тип == ТипЗаписи.Файл) );

            assert( полное_имя.nz() );
            assert( имя.nz() );
        }
        +/

        ИнфОФильтреВфс инфОФильтреВфс;

        ИнфОВфс инфОВфс()
        {
            return &инфОФильтреВфс;
        }

        /*
         * Updates the ИнфОВфс structure for this Запись.
         */
        проц сделайИнфОВфс()
        {
            with( инфОФильтреВфс )
            {
                // Cheat horribly here
                имя = this.имя;
                путь = this.полное_имя[0..($-имя.length+"/".length)];

                папка = папка_ли;
                байты = папка ? 0 : размерФайла;
            }
        }

        бул папка_ли()
        {
            return (тип == ТипЗаписи.Пап);
        }

        бул файл_ли()
        {
            return (тип == ТипЗаписи.Файл);
        }

        бдол размерФайла()
        in
        {
            assert( тип == ТипЗаписи.Файл );
        }
        body
        {
            if( файл.зипЗапись !is пусто )
                return файл.зипЗапись.размер;

            else if( файл.времФайл !is пусто )
            {
                assert( файл.времФайл.length >= 0 );
                return cast(бдол) файл.времФайл.length;
            }
            else
                return 0;
        }

        /*
         * Opens a Файл Запись for reading.
         *
         * BUG: Currently, if a пользователь opens a new or unmodified файл for ввод,
         * and then opens it for вывод, the two Потокs will be working with
         * different underlying conduits.  This means that the результат of
         * откройВвод should probably be wrapped in some kind of switching
         * поток that can обнови when the backing сохрани for the файл changes.
         */
        ИПотокВвода откройВвод()
        in
        {
            assert( тип == ТипЗаписи.Файл );
        }
        body
        {
            if( файл.зипЗапись !is пусто )
            {
                файл.зипЗапись.проверь;
                return файл.зипЗапись.открой;
            }
            else if( файл.времФайл !is пусто )
                return new WrapSeekInputПоток(файл.времФайл, 0);

            else
               {
               throw new Исключение ("cannot открой ввод поток for '"~полное_имя~"'");
               //return new DummyInputПоток;
               }
        }

        /*
         * Opens a файл Запись for вывод.
         */
        ИПотокВывода откройВывод()
        in
        {
            assert( тип == ТипЗаписи.Файл );
        }
        body
        {
            if( файл.времФайл !is пусто )
                return new WrapSeekOutputПоток(файл.времФайл);

            else
            {
                // Ok; we need в_ сделай a temporary файл в_ сохрани вывод in.
                // If we already have a zИП Запись, we need в_ dump that преобр_в
                // the temp. файл and удали the зипЗапись.
                if( файл.зипЗапись !is пусто )
                {
                    {
                        auto zi = файл.зипЗапись.открой;
                        scope(exit) zi.закрой;
    
                        файл.времФайл = new ВремФайл;
                        файл.времФайл.копируй(zi).закрой;

                        debug( ПапкаЗип )
                            Стдош.форматнс("Запись.откройВывод: duplicated"
                                    " temp файл {} for {}",
                                    файл.времФайл, this.полное_имя);
                    }

                    // TODO: Copy файл инфо if available

                    файл.зипЗапись = пусто;
                }
                else
                {
                    // Otherwise, just сделай a new, blank temp файл
                    файл.времФайл = new ВремФайл;

                    debug( ПапкаЗип )
                        Стдош.форматнс("Запись.откройВывод: создан"
                                " temp файл {} for {}",
                                файл.времФайл, this.полное_имя);
                }

                assert( файл.времФайл !is пусто );
                return откройВывод;
            }
        }

        проц вымести()
        {
            полное_имя = имя = пусто;
            
            with( инфОФильтреВфс )
            {
                имя = путь = пусто;
            }

            вымести_отпрыски;
        }

        проц вымести_отпрыски()
        {
            switch( тип )
            {
                case ТипЗаписи.Пап:
                    auto ключи = Пап.ветви.ключи;
                    scope(exit) delete ключи;
                    foreach( k ; ключи )
                    {
                        auto ветвь = Пап.ветви[k];
                        ветвь.вымести();
                        Пап.ветви.удали(k);
                        delete ветвь;
                    }
                    Пап.ветви = Пап.ветви.init;
                    break;

                case ТипЗаписи.Файл:
                    if( файл.зипЗапись !is пусто )
                    {
                        // Don't really need в_ do anything here
                        файл.зипЗапись = пусто;
                    }
                    else if( файл.времФайл !is пусто )
                    {
                        // Detatch в_ destroy the physical файл itself
                        файл.времФайл.открепи();
                        файл.времФайл = пусто;
                    }
                    break;

                default:
                    debug( ПапкаЗип ) Стдош.форматнс(
                            "Запись.вымести_отпрыски: неизвестное тип {}",
                            тип);
                    assert(нет);
            }
        }
    }

    struct ПапЗапись
    {
        Запись*[ткст] ветви;
    }

    struct ФайлЗапись
    {
        ЗаписьЗип зипЗапись;
        ВремФайл времФайл;

        invariant
        {
            auto zn = зипЗапись is пусто;
            auto tn = времФайл is пусто;
            assert( (zn && tn)
          /* zn xor tn */ || (!(zn&&tn)&&(zn||tn)) );
        }
    }
}

// ************************************************************************ //
// ************************************************************************ //

/**
 * ПапкаЗип serves as the корень объект for все ZИП archives in the VFS.
 * Presently, it can only открой archives on the local filesystem.
 */
class ПапкаЗип : ПодпапкаЗип
{
    /**
     * Opens an архив из_ the local filesystem.  If the толькочтен_ли аргумент
     * is specified as да, then modification of the архив will be
     * explicitly disallowed.
     */
    this(ткст путь, бул толькочтен_ли=нет)
    out { assert( valid ); }
    body
    {
        debug( ПапкаЗип )
            Стдош.форматнс(`ПапкаЗип("{}", {})`, путь, толькочтен_ли);
        this.сбросьАрхив(путь, толькочтен_ли);
        super(this, корень);
    }

    /**
     * Closes the архив, and releases все internal resources.  If the подай
     * аргумент is да (the default), then changes в_ the архив will be
     * flushed out в_ disk.  If нет, changes will simply be discarded.
     */
    final override ПапкаВфс закрой(бул подай = да)
    in { assert( valid ); }
    body
    {
        debug( ПапкаЗип )
            Стдош.форматнс("ПапкаЗип.закрой({})",подай);

        // MUTATE
        if( подай ) синх;

        // Close ЧитательЗип
        if( zr !is пусто )
        {
            zr.закрой();
            delete zr;
        }

        // Destroy записи
        корень.вымести();
        version( Bug_HeapCorruption )
            корень = пусто;
        else
            delete корень;

        return this;
    }

    /**
     * Flushes все changes в_ the архив out в_ disk.
     */
    final override ПапкаВфс синх()
    in { assert( valid ); }
    out
    {
        assert( valid );
        assert( !изменён );
    }
    body
    {
        debug( ПапкаЗип )
            Стдош("ПапкаЗип.синх()").нс;

        if( !изменён )
            return this;

version( ZИПFolder_NonMutating )
{
        mutate_error("ПапкаЗип.синх");
        assert(нет);
}
else
{
        форсируй_изм;
        
        // First, we need в_ determine if we have any zИП записи.  If we
        // don't, then we can пиши directly в_ the путь.  If there *are*
        // zИП записи, then we'll need в_ пиши в_ a temporary путь instead.
        ИПотокВывода os;
        ВремФайл времФайл;
        scope(exit) if( времФайл !is пусто ) delete времФайл;

        auto p = Путь.разбор (путь);
        foreach( файл ; this.дерево.каталог )
        {
            if( auto zf = cast(ФайлЗип) файл )
                if( zf.Запись.файл.зипЗапись !is пусто )
                {
                    времФайл = new ВремФайл(p.путь, ВремФайл.Навсегда);
                    os = времФайл;
                    debug( ПапкаЗип )
                        Стдош.форматнс(" синх: создан temp файл {}",
                                времФайл.путь);
                    break;
                }
        }

        if( времФайл is пусто )
        {
            // Kill the current zИП читатель so we can re-открой the файл it's
            // using.
            if( zr !is пусто )
            {
                zr.закрой;
                delete zr;
            }

            os = new Файл(путь, Файл.ЗапСозд);
        }

        // Сейчас, we can создай the архив.
        {
            scope zw = new ПисательБлокаЗип(os);
            foreach( файл ; this.дерево.каталог )
            {
                auto zei = ИнфоОЗаписиЗип(файл.вТкст[1..$]);
                // BUG: Passthru doesn't maintain compression for some
                // резон...
                if( auto zf = cast(ФайлЗип) файл )
                {
                    if( zf.Запись.файл.зипЗапись !is пусто )
                        zw.поместиЗапись(zei, zf.Запись.файл.зипЗапись);
                    else
                        zw.поместиПоток(zei, файл.ввод);
                }
                else
                    zw.поместиПоток(zei, файл.ввод);
            }
            zw.финиш;
        }

        // With that готово, we can free все our handles, etc.
        debug( ПапкаЗип )
            Стдош(" синх: закрой").нс;
        this.закрой(/*подай*/ нет);
        os.закрой;

        // If we wrote the архив преобр_в a temporary файл, перемести that over the
        // top of the old архив.
        if( времФайл !is пусто )
        {
            debug( ПапкаЗип )
                Стдош(" синх: destroying temp файл").нс;

            debug( ПапкаЗип )
                Стдош.форматнс(" синх: renaming {} в_ {}",
                        времФайл, путь);

            Путь.переименуй (времФайл.вТкст, путь);
        }

        // Finally, re-открой the архив so that we have все the nicely
        // compressed файлы.
        debug( ПапкаЗип )
            Стдош(" синх: сбрось архив").нс;
        this.сбросьАрхив(путь, толькочтен_ли);
        
        debug( ПапкаЗип )
            Стдош(" синх: сбрось папка").нс;
        this.сбрось(this, корень);

        debug( ПапкаЗип )
            Стдош(" синх: готово").нс;

        return this;
}
    }

    /**
     * Indicates whether the архив was opened for читай-only access.  Note
     * that in добавьition в_ the толькочтен_ли constructor flag, this is also
     * influenced by whether the файл itself is читай-only or not.
     */
    final бул толькочтен_ли() { return _readonly; }

    /**
     * Allows you в_ читай and specify the путь в_ the архив.  The effect of
     * настройка this is в_ change where the архив will be записано в_ when
     * flushed в_ disk.
     */
    final ткст путь() { return _path; }
    final ткст путь(ткст v) { return _path = v; } /// ditto

private:
    ЧитательЗип zr;
    Запись* корень;
    ткст _path;
    бул _readonly;
    бул изменён = нет;

    final бул толькочтен_ли(бул v) { return _readonly = v; }

    final бул закрыт()
    {
        debug( ПапкаЗип )
            Стдош("ПапкаЗип.закрыт()").нс;
        return (корень is пусто);
    }

    final бул valid()
    {
        debug( ПапкаЗип )
            Стдош("ПапкаЗип.valid()").нс;
        return !закрыт;
    }

    final ИПотокВывода измениПоток(ИПотокВывода источник)
    {
        return new EventSeekOutputПоток(источник,
                EventSeekOutputПоток.Обрвызовы(
                    пусто,
                    пусто,
                    &измени_зап,
                    пусто));
    }

    проц измени_зап(бцел байты, проц[] ист)
    {
        if( !(байты == 0 || байты == ИПровод.Кф) )
            this.изменён = да;
    }

    проц сбросьАрхив(ткст путь, бул толькочтен_ли=нет)
    out { assert( valid ); }
    body
    {
        debug( ПапкаЗип )
            Стдош.форматнс(`ПапкаЗип.сбросьАрхив("{}", {})`, путь, толькочтен_ли);

        debug( ПапкаЗип )
            Стдош.форматнс(" .. размер of Запись: {0}, {0:x} байты", Запись.sizeof);

        this.путь = путь;
        this.толькочтен_ли = толькочтен_ли;

        // Make sure the изменён flag is установи appropriately
        scope(exit) изменён = нет;

        // First, создай a корень Запись
        корень = new Запись;
        корень.тип = ТипЗаписи.Пап;
        корень.полное_имя = корень.имя = "/";

        // If the пользователь allowed writing, also allow creating a new архив.
        // Note that we MUST drop out here if the архив DOES NOT exist,
        // since Путь.isWriteable will throw an исключение if called on a
        // non-existent путь.
        if( !this.толькочтен_ли && !Путь.есть_ли(путь) )
            return;

        // Update толькочтен_ли в_ reflect the пиши-protected статус of the
        // архив.
        this.толькочтен_ли = this.толькочтен_ли || !Путь.записываем_ли(путь);

        // Parse the contents of the архив
        foreach( зипЗапись ; zr )
        {
            // Normalise имя
            auto имя = ФПуть(зипЗапись.инфо.имя).стандарт.вТкст;

            // If the последний character is '/', treat as a дир and пропусти
            // TODO: is there a better way of detecting this?
            if( имя[$-1] == '/' )
                continue;

            // Сейчас, we need в_ locate the right spot в_ вставь this Запись.
            {
                // That's CURrent ENTity, not current OR currant...
                Запись* curent = корень;
                ткст h,t;
                headTail(имя,h,t);
                while( t.nz() )
                {
                    assert( curent.папка_ли );
                    if( auto nextent = (h in curent.Пап.ветви) )
                        curent = *nextent;
                    
                    else
                    {
                        // Create new дир Запись
                        Запись* dirent = new Запись;
                        dirent.тип = ТипЗаписи.Пап;
                        if( curent.полное_имя != "/" )
                            dirent.полное_имя = curent.полное_имя ~ "/" ~ h;
                        else
                            dirent.полное_имя = "/" ~ h;
                        dirent.имя = dirent.полное_имя[$-h.length..$];

                        // Insert преобр_в current Запись
                        curent.Пап.ветви[dirent.имя] = dirent;

                        // Make it the new current Запись
                        curent = dirent;
                    }

                    headTail(t,h,t);
                }

                // Getting here means that t is пустой, which means the final
                // component of the путь--the файл имя--is in h.  The Запись
                // of the containing дир is in curent.

                // Make sure the файл isn't already there (you never know!)
                assert( !(h in curent.Пап.ветви) );

                // Create a new файл Запись for it.
                {
                    // BUG: Bug_HeapCorruption
                    // with ZИПTest, on the сбросьАрхив operation, on
                    // the сукунда время through this следщ строка, it erroneously
                    // allocates filent 16 байты lower than curent.  Запись
                    // is *way* larger than 16 байты, and this causes it в_
                    // zero-out the existing корень element, which leads в_
                    // segfaults later on at строка +12:
                    //
                    //      // Insert
                    //      curent.Пап.ветви[filent.имя] = filent;

                    Запись* filent = new Запись;
                    filent.тип = ТипЗаписи.Файл;
                    if( curent.полное_имя != "/" )
                        filent.полное_имя = curent.полное_имя ~ "/" ~ h;
                    else
                        filent.полное_имя = "/" ~ h;
                    filent.имя = filent.полное_имя[$-h.length..$];
                    filent.файл.зипЗапись = зипЗапись.dup;

                    filent.сделайИнфОВфс;

                    // Insert
                    curent.Пап.ветви[filent.имя] = filent;
                }
            }
        }
    }
}

// ************************************************************************ //
// ************************************************************************ //

/**
 * This class represents a папка in an архив.  In добавьition в_ supporting
 * the синх operation, you can also use the архив member в_ получи a reference
 * в_ the underlying ПапкаЗип экземпляр.
 */
class ПодпапкаЗип : ПапкаВфс, СинхВфс
{
    ///
    final ткст имя()
    in { assert( valid ); }
    body
    {
        return Запись.имя;
    }

    ///
    final override ткст вТкст()
    in { assert( valid ); }
    body
    {
        return Запись.полное_имя;
    }

    ///
    final ФайлВфс файл(ткст путь)
    in
    {
        assert( valid );
        assert( !Путь.разбор(путь).абс_ли );
    }
    body
    {
        auto fp = Путь.разбор(путь);
        auto Пап = fp.путь;
        auto имя = fp.файл;

        if (Пап.length > 0 && '/' == Пап[$-1]) {
            Пап = Пап[0..$-1];
        }
		
        // If the файл is in другой дир, then we need в_ look up that
        // up first.
        if( Пап.nz() )
        {
            auto dir_ent = this.папка(Пап);
            auto dir_obj = dir_ent.открой;
            return dir_obj.файл(имя);
        }
        else
        {
            // Otherwise, we need в_ check and see whether the файл is in our
            // Запись список.
            if( auto file_entry = (имя in this.Запись.Пап.ветви) )
            {
                // It is; создай a new объект for it.
                return new ФайлЗип(архив, this.Запись, *file_entry);
            }
            else
            {
                // Oh dear... return a holding объект.
                return new ФайлЗип(архив, this.Запись, имя);
            }
        }
    }

    ///
    final ЗаписьПапкиВфс папка(ткст путь)
    in
    {
        assert( valid );
        assert( !Путь.разбор(путь).абс_ли );
    }
    body
    {
        // Locate the папка in question.  We do this by "walking" the
        // путь components.  If we найди a component that doesn't exist,
        // then we создай a ЗаписьПодпапкиЗип for the remainder.
        Запись* curent = this.Запись;

        // h is the "голова" of the путь, t is the remainder.  ht is Всё
        // joined together.
        ткст h,t,ht;
        ht = путь;

        do
        {
            // разбей ht at the first путь разделитель.
            assert( ht.nz() );
            headTail(ht,h,t);

            // Look for a pre-existing subentry
            auto subent = (h in curent.Пап.ветви);
            if( t.nz() && !!subent )
            {
                // Move в_ the subentry, and разбей the хвост on the следщ
                // iteration.
                curent = *subent;
                ht = t;
            }
            else
                // If the следщ component doesn't exist, return a папка Запись.
                // If the хвост is пустой, return a папка Запись as well (let
                // the ЗаписьПодпапкиЗип do the последний отыщи.)
                return new ЗаписьПодпапкиЗип(архив, curent, ht);
        }
        while( да )
        //assert(нет);
    }

    ///
    final ПапкиВфс сам()
    in { assert( valid ); }
    body
    {
        return new ГруппаПодпапокЗип(архив, this, нет);
    }

    ///
    final ПапкиВфс дерево()
    in { assert( valid ); }
    body
    {
        return new ГруппаПодпапокЗип(архив, this, да);
    }

    ///
    final цел opApply(цел delegate(ref ПапкаВфс) дг)
    in { assert( valid ); }
    body
    {
        цел результат = 0;

        foreach( _,childEntry ; this.Запись.Пап.ветви )
        {
            if( childEntry.папка_ли )
            {
                ПапкаВфс childFolder = new ПодпапкаЗип(архив, childEntry);
                if( (результат = дг(childFolder)) != 0 )
                    break;
            }
        }

        return результат;
    }

    ///
    final ПапкаВфс сотри()
    in { assert( valid ); }
    body
    {
version( ZИПFolder_NonMutating )
{
        mutate_error("ПапкаВфс.сотри");
        assert(нет);
}
else
{
        // MUTATE
        форсируй_изм;

        // Disposing of the underlying Запись subtree should do our дело for us.
        Запись.вымести_отпрыски;
        mutate;
        return this;
}
    }

    ///
    final бул записываемый()
    in { assert( valid ); }
    body
    {
        return !архив.толькочтен_ли;
    }

    /**
     * Closes this папка объект.  If подай is да, then the папка is
     * синх'ed before being закрыт.
     */
    ПапкаВфс закрой(бул подай = да)
    in { assert( valid ); }
    body
    {
        // MUTATE
        if( подай ) синх;

        // Just clean up our pointers
        архив = пусто;
        Запись = пусто;
        return this;
    }

    /**
     * This will слей any changes в_ the архив в_ disk.  Note that this
     * applies в_ the entire архив, not just this папка and its contents.
     */
    ПапкаВфс синх()
    in { assert( valid ); }
    body
    {
        // MUTATE
        архив.синх;
        return this;
    }

    ///
    final проц проверь(ПапкаВфс папка, бул mounting)
    in { assert( valid ); }
    body
    {
        auto zИПfolder = cast(ПодпапкаЗип) папка;

        if( mounting
                && zИПfolder !is пусто
                && zИПfolder.архив is архив )
        {
            auto ист = this.вТкст;
            auto приёмн = zИПfolder.вТкст;

            auto длин = ист.length > приёмн.length ? приёмн.length : ист.length;

            if( ист[0..длин] == приёмн[0..длин] )
                ошибка(`папки "`~приёмн~`" and "`~ист~`" in архив "`
                        ~архив.путь~`" overlap`);
        }
    }

    /**
     * Returns a reference в_ the underlying ПапкаЗип экземпляр.
     */
    final ПапкаЗип архив() { return _archive; }

private:
    ПапкаЗип _archive;
    Запись* Запись;
    СтатсВфс статс;

    final ПапкаЗип архив(ПапкаЗип v) { return _archive = v; }

    this(ПапкаЗип архив, Запись* Запись)
    {
        this.сбрось(архив, Запись);
    }

    final проц сбрось(ПапкаЗип архив, Запись* Запись)
    in
    {
        assert( архив !is пусто );
        assert( Запись.папка_ли );
    }
    out { assert( valid ); }
    body
    {
        this.архив = архив;
        this.Запись = Запись;
    }

    final бул valid()
    {
        return( (архив !is пусто) && !архив.закрыт );
    }

    final проц форсируй_изм()
    in { assert( valid ); }
    body
    {
        if( архив.толькочтен_ли )
            // TODO: исключение
            throw new Исключение("cannot mutate a читай-only ZИП архив");
    }

    final проц mutate()
    in { assert( valid ); }
    body
    {
        форсируй_изм;
        архив.изменён = да;
    }

    final ПодпапкаЗип[] папки(бул collect)
    in { assert( valid ); }
    body
    {
        ПодпапкаЗип[] папки;
        статс = статс.init;

        foreach( _,childEntry ; Запись.Пап.ветви )
        {
            if( childEntry.папка_ли )
            {
                if( collect ) папки ~= new ПодпапкаЗип(архив, childEntry);
                ++ статс.папки;
            }
            else
            {
                assert( childEntry.файл_ли );
                статс.байты += childEntry.размерФайла;
                ++ статс.файлы;
            }
        }

        return папки;
    }

    final Запись*[] файлы(ref СтатсВфс статс, ФильтрВфс фильтр = пусто)
    in { assert( valid ); }
    body
    {
        Запись*[] файлы;

        foreach( _,childEntry ; Запись.Пап.ветви )
        {
            if( childEntry.файл_ли )
                if( фильтр is пусто || фильтр(childEntry.инфОВфс) )
                {
                    файлы ~= childEntry;
                    статс.байты += childEntry.размерФайла;
                    ++статс.файлы;
                }
        }

        return файлы;
    }
}

// ************************************************************************ //
// ************************************************************************ //

/**
 * This class represents a файл within an архив.
 */
class ФайлЗип : ФайлВфс
{
    ///
    final ткст имя()
    in { assert( valid ); }
    body
    {
        if( Запись ) return Запись.имя;
        else        return name_;
    }

    ///
    final override ткст вТкст()
    in { assert( valid ); }
    body
    {
        if( Запись ) return Запись.полное_имя;
        else        return предок.полное_имя ~ "/" ~ name_;
    }

    ///
    final бул есть_ли()
    in { assert( valid ); }
    body
    {
        // If we've only got a предок and a имя, this means we don't actually
        // exist; EXISTENTIAL CRISIS TEIM!!!
        return !!Запись;
    }

    ///
    final бдол размер()
    in { assert( valid ); }
    body
    {
        if( есть_ли )
            return Запись.размерФайла;
        else
            ошибка("ФайлЗип.размер: cannot reliably determine размер of a "
                    "non-existent файл");

        assert(нет);
    }

    ///
    final ФайлВфс копируй(ФайлВфс источник)
    in { assert( valid ); }
    body
    {
version( ZИПFolder_NonMutating )
{
        mutate_error("ФайлЗип.копируй");
        assert(нет);
}
else
{
        // MUTATE
        форсируй_изм;

        if( !есть_ли ) this.создай;
        this.вывод.копируй(источник.ввод);

        return this;
}
    }

    ///
    final ФайлВфс перемести(ФайлВфс источник)
    in { assert( valid ); }
    body
    {
version( ZИПFolder_NonMutating )
{
        mutate_error("ФайлЗип.перемести");
        assert(нет);
}
else
{
        // MUTATE
        форсируй_изм;

        this.копируй(источник);
        источник.удали;

        return this;
}
    }

    ///
    final ФайлВфс создай()
    in { assert( valid ); }
    out { assert( valid ); }
    body
    {
version( ZИПFolder_NonMutating )
{
        mutate_error("ФайлЗип.создай");
        assert(нет);
}
else
{
        if( есть_ли )
            ошибка("ФайлЗип.создай: cannot создай already existing файл: "
                    "this папка ain't big enough for the Всё of 'em");

        // MUTATE
        форсируй_изм;

        auto Запись = new Запись;
        Запись.тип = ТипЗаписи.Файл;
        Запись.полное_имя = предок.полное_имя.dir_app(имя);
        Запись.имя = Запись.полное_имя[$-имя.length..$];
        Запись.сделайИнфОВфс;

        assert( !(Запись.имя in предок.Пап.ветви) );
        предок.Пап.ветви[Запись.имя] = Запись;
        this.сбрось(архив, предок, Запись);
        mutate;

        // Готово
        return this;
}
    }

    ///
    final ФайлВфс создай(ИПотокВвода поток)
    in { assert( valid ); }
    body
    {
version( ZИПFolder_NonMutating )
{
        mutate_error("ФайлЗип.создай");
        assert(нет);
}
else
{
        создай;
        вывод.копируй(поток).закрой;
        return this;
}
    }

    ///
    final ФайлВфс удали()
    in{ assert( valid ); }
    out { assert( valid ); }
    body
    {
version( ZИПFolder_NonMutating )
{
        mutate_error("ФайлЗип.удали");
        assert(нет);
}
else
{
        if( !есть_ли )
            ошибка("ФайлЗип.удали: cannot удали non-existent файл; "
                    "rather redundant, really");

        // MUTATE
        форсируй_изм;

        // Save the old имя
        auto old_name = имя;

        // Do the removal
        assert( !!(имя in предок.Пап.ветви) );
        предок.Пап.ветви.удали(имя);
        Запись.вымести;
        Запись = пусто;
        mutate;

        // Swap out our сейчас пустой Запись for the имя, so the файл can be
        // directly recreated.
        this.сбрось(архив, предок, old_name);

        return this;
}
    }

    ///
    final ИПотокВвода ввод()
    in { assert( valid ); }
    body
    {
        if( есть_ли )
            return Запись.откройВвод;

        else
            ошибка("ФайлЗип.ввод: cannot открой non-existent файл for ввод; "
                    "results would not be very useful");

        assert(нет);
    }

    ///
    final ИПотокВывода вывод()
    in { assert( valid ); }
    body
    {
version( ZИПFolder_NonMutable )
{
        mutate_error("ФайлЗип.вывод");
        assert(нет);
}
else
{
        // MUTATE
        форсируй_изм;
        
        // Don't вызов mutate; defer that until the пользователь actually writes в_ or
        // modifies the underlying поток.
        return архив.измениПоток(Запись.откройВывод);
}
    }

    ///
    final ФайлВфс dup()
    in { assert( valid ); }
    body
    {
        if( Запись )
            return new ФайлЗип(архив, предок, Запись);
        else
            return new ФайлЗип(архив, предок, имя);
    }

    ///
    final Время изменён()
    {
        return Запись.файл.зипЗапись.инфо.изменён;
    }
    
    private:
    ПапкаЗип архив;
    Запись* Запись;

    Запись* предок;
    ткст name_;

    this()
    out { assert( !valid ); }
    body
    {
    }

    this(ПапкаЗип архив, Запись* предок, Запись* Запись)
    in
    {
        assert( архив !is пусто );
        assert( предок );
        assert( предок.папка_ли );
        assert( Запись );
        assert( Запись.файл_ли );
        assert( предок.Пап.ветви[Запись.имя] is Запись );
    }
    out { assert( valid ); }
    body
    {
        this.сбрось(архив, предок, Запись);
    }

    this(ПапкаЗип архив, Запись* предок, ткст имя)
    in
    {
        assert( архив !is пусто );
        assert( предок );
        assert( предок.папка_ли );
        assert( имя.nz() );
        assert( !(имя in предок.Пап.ветви) );
    }
    out { assert( valid ); }
    body
    {
        this.сбрось(архив, предок, имя);
    }

    final бул valid()
    {
        return( (архив !is пусто) && !архив.закрыт );
    }

    final проц форсируй_изм()
    in { assert( valid ); }
    body
    {
        if( архив.толькочтен_ли )
            // TODO: исключение
            throw new Исключение("cannot mutate a читай-only ZИП архив");
    }

    final проц mutate()
    in { assert( valid ); }
    body
    {
        форсируй_изм;
        архив.изменён = да;
    }

    final проц сбрось(ПапкаЗип архив, Запись* предок, Запись* Запись)
    in
    {
        assert( архив !is пусто );
        assert( предок );
        assert( предок.папка_ли );
        assert( Запись );
        assert( Запись.файл_ли );
        assert( предок.Пап.ветви[Запись.имя] is Запись );
    }
    out { assert( valid ); }
    body
    {
        this.предок = предок;
        this.архив = архив;
        this.Запись = Запись;
        this.name_ = пусто;
    }

    final проц сбрось(ПапкаЗип архив, Запись* предок, ткст имя)
    in
    {
        assert( архив !is пусто );
        assert( предок );
        assert( предок.папка_ли );
        assert( имя.nz() );
        assert( !(имя in предок.Пап.ветви) );
    }
    out { assert( valid ); }
    body
    {
        this.архив = архив;
        this.предок = предок;
        this.Запись = пусто;
        this.name_ = имя;
    }

    final проц закрой()
    in { assert( valid ); }
    out { assert( !valid ); }
    body
    {
        архив = пусто;
        предок = пусто;
        Запись = пусто;
        name_ = пусто;
    }
}

// ************************************************************************ //
// ************************************************************************ //

class ЗаписьПодпапкиЗип : ЗаписьПапкиВфс
{
    final ПапкаВфс открой()
    in { assert( valid ); }
    body
    {
        auto Запись = (имя in предок.Пап.ветви);
        if( Запись )
            return new ПодпапкаЗип(архив, *Запись);

        else
        {
            // NOTE: this can be called with a multi-часть путь.
            ошибка("ЗаписьПодпапкиЗип.открой: \""
                    ~ предок.полное_имя ~ "/" ~ имя
                    ~ "\" does not exist");

            assert(нет);
        }
    }

    final ПапкаВфс создай()
    in { assert( valid ); }
    body
    {
version( ZИПFolder_NonMutating )
{
        // TODO: different исключение if папка есть_ли (this operation is
        // currently не_годится either way...)
        mutate_error("ЗаписьПодпапкиЗип.создай");
        assert(нет);
}
else
{
        // MUTATE
        форсируй_изм;

        // If the папка есть_ли, we can't really создай it, сейчас can we?
        if( this.есть_ли )
            ошибка("ЗаписьПодпапкиЗип.создай: cannot создай папка that already "
                    "есть_ли, and believe me, I *tried*");
        
        // Ok, I suppose I can do this for ya...
        auto Запись = new Запись;
        Запись.тип = ТипЗаписи.Пап;
        Запись.полное_имя = предок.полное_имя.dir_app(имя);
        Запись.имя = Запись.полное_имя[$-имя.length..$];
        Запись.сделайИнфОВфс;

        assert( !(Запись.имя in предок.Пап.ветви) );
        предок.Пап.ветви[Запись.имя] = Запись;
        mutate;

        // Готово
        return new ПодпапкаЗип(архив, Запись);
}
    }

    final бул есть_ли()
    in { assert( valid ); }
    body
    {
        return !!(имя in предок.Пап.ветви);
    }

private:
    ПапкаЗип архив;
    Запись* предок;
    ткст имя;

    this(ПапкаЗип архив, Запись* предок, ткст имя)
    in
    {
        assert( архив !is пусто );
        assert( предок.папка_ли );
        assert( имя.nz() );
        assert( имя.single_path_part() );
    }
    out { assert( valid ); }
    body
    {
        this.архив = архив;
        this.предок = предок;
        this.имя = имя;
    }

    final бул valid()
    {
        return (архив !is пусто) && !архив.закрыт;
    }
    
    final проц форсируй_изм()
    in { assert( valid ); }
    body
    {
        if( архив.толькочтен_ли )
            // TODO: исключение
            throw new Исключение("cannot mutate a читай-only ZИП архив");
    }

    final проц mutate()
    in { assert( valid ); }
    body
    {
        форсируй_изм;
        архив.изменён = да;
    }
}

// ************************************************************************ //
// ************************************************************************ //

class ГруппаПодпапокЗип : ПапкиВфс
{
    final цел opApply(цел delegate(ref ПапкаВфс) дг)
    in { assert( valid ); }
    body
    {
        цел результат = 0;

        foreach( папка ; члены )
        {
            ПапкаВфс x = папка;
            if( (результат = дг(x)) != 0 )
                break;
        }

        return результат;
    }

    final бцел файлы()
    in { assert( valid ); }
    body
    {
        бцел файлы = 0;

        foreach( папка ; члены )
            файлы += папка.статс.файлы;

        return файлы;
    }

    final бцел папки()
    in { assert( valid ); }
    body
    {
        return члены.length;
    }

    final бцел записи()
    in { assert( valid ); }
    body
    {
        return файлы + папки;
    }

    final бдол байты()
    in { assert( valid ); }
    body
    {
        бдол байты = 0;

        foreach( папка ; члены )
            байты += папка.статс.байты;

        return байты;
    }

    final ПапкиВфс поднабор(ткст образец)
    in { assert( valid ); }
    body
    {
        ПодпапкаЗип[] установи;

        foreach( папка ; члены )
            if( Путь.совпадение(папка.имя, образец) )
                установи ~= папка;

        return new ГруппаПодпапокЗип(архив, установи);
    }

    final ФайлыВфс каталог(ткст образец)
    in { assert( valid ); }
    body
    {
        бул фильтр (ИнфОВфс инфо)
        {
                return Путь.совпадение(инфо.имя, образец);
        }

        return каталог (&фильтр);
    }

    final ФайлыВфс каталог(ФильтрВфс фильтр = пусто)
    in { assert( valid ); }
    body
    {
        return new ГруппаФайловЗип(архив, this, фильтр);
    }

private:
    ПапкаЗип архив;
    ПодпапкаЗип[] члены;

    this(ПапкаЗип архив, ПодпапкаЗип корень, бул рекурсия)
    out { assert( valid ); }
    body
    {
        this.архив = архив;
        члены = корень ~ скан(корень, рекурсия);
    }

    this(ПапкаЗип архив, ПодпапкаЗип[] члены)
    out { assert( valid ); }
    body
    {
        this.архив = архив;
        this.члены = члены;
    }

    final бул valid()
    {
        return (архив !is пусто) && !архив.закрыт;
    }

    final ПодпапкаЗип[] скан(ПодпапкаЗип корень, бул рекурсия)
    in { assert( valid ); }
    body
    {
        auto папки = корень.папки(рекурсия);

        if( рекурсия )
            foreach( ветвь ; папки )
                папки ~= скан(ветвь, рекурсия);

        return папки;
    }
}

// ************************************************************************ //
// ************************************************************************ //

class ГруппаФайловЗип : ФайлыВфс
{
    final цел opApply(цел delegate(ref ФайлВфс) дг)
    in { assert( valid ); }
    body
    {
        цел результат = 0;
        auto файл = new ФайлЗип;

        foreach( Запись ; группа )
        {
            файл.сбрось(архив,Запись.предок,Запись.Запись);
            ФайлВфс x = файл;
            if( (результат = дг(x)) != 0 )
                break;
        }

        return результат;
    }

    final бцел файлы()
    in { assert( valid ); }
    body
    {
        return группа.length;
    }

    final бдол байты()
    in { assert( valid ); }
    body
    {
        return статс.байты;
    }

private:
    ПапкаЗип архив;
    ФайлЗапись[] группа;
    СтатсВфс статс;

    struct ФайлЗапись
    {
        Запись* предок;
        Запись* Запись;
    }

    this(ПапкаЗип архив, ГруппаПодпапокЗип хост, ФильтрВфс фильтр)
    out { assert( valid ); }
    body
    {
        this.архив = архив;
        foreach( папка ; хост.члены )
            foreach( файл ; папка.файлы(статс, фильтр) )
                группа ~= ФайлЗапись(папка.Запись, файл);
    }

    final бул valid()
    {
        return (архив !is пусто) && !архив.закрыт;
    }
}

// ************************************************************************ //
// ************************************************************************ //

private:

проц ошибка(ткст сооб)
{
    throw new Исключение(сооб);
}

проц mutate_error(ткст метод)
{
    ошибка(метод ~ ": mutating the contents of a ПапкаЗип "
            "is not supported yet; terribly sorry");
}

бул nz(ткст s)
{
    return s.length > 0;
}

бул zero(ткст s)
{
    return s.length == 0;
}

бул single_path_part(ткст s)
{
    foreach( c ; s )
        if( c == '/' ) return нет;
    return да;
}

ткст dir_app(ткст Пап, ткст имя)
{
    return Пап ~ (Пап[$-1]!='/' ? "/" : "") ~ имя;
}

проц headTail(ткст путь, out ткст голова, out ткст хвост)
{
    foreach( i,дим c ; путь[1..$] )
        if( c == '/' )
        {
            голова = путь[0..i+1];
            хвост = путь[i+2..$];
            return;
        }

    голова = путь;
    хвост = пусто;
}

debug (UnitTest)
{
unittest
{
    ткст h,t;

    headTail("/a/b/c", h, t);
    assert( h == "/a" );
    assert( t == "b/c" );

    headTail("a/b/c", h, t);
    assert( h == "a" );
    assert( t == "b/c" );

    headTail("a/", h, t);
    assert( h == "a" );
    assert( t == "" );

    headTail("a", h, t);
    assert( h == "a" );
    assert( t == "" );
}
}

// ************************************************************************** //
// ************************************************************************** //
// ************************************************************************** //

// Dependencies
private:
import io.device.Conduit : Провод;

/*******************************************************************************

    copyright:  Copyright © 2007 Daniel Keep.  все rights reserved.

    license:    BSD стиль: $(LICENSE)

    version:    Prerelease

    author:     Daniel Keep

*******************************************************************************/

//module tangox.io.поток.DummyПоток;

//import io.device.Conduit : Провод;
//import io.model : ИПровод, ИПотокВвода, ИПотокВывода;

/**
 * The dummy поток classes are used в_ provопрe simple, пустой поток objects
 * where one is required, but Неук is available.
 *
 * Note that, currently, these classes return 'пусто' for the underlying
 * провод, which will likely break код which expects Потокs в_ have an
 * underlying провод.
 */
private deprecated class DummyInputПоток : ИПотокВвода // ИПровод.ИШаг
{
    //alias ИПровод.ИШаг.Якорь Якорь;

    override ИПотокВвода ввод() {return пусто;}
    override ИПровод провод() { return пусто; }
    override проц закрой() {}
    override т_мера читай(проц[] приёмн) { return ИПровод.Кф; }
    override ИПотокВвода слей() { return this; }
    override проц[] загрузи(т_мера max=-1)
    {
        return Провод.загрузи(this, max);
    }
    override дол сместись(дол смещение, Якорь якорь = cast(Якорь)0) { return 0; }
}

/// ditto
private deprecated class DummyOutputПоток : ИПотокВывода //, ИПровод.ИШаг
{
    //alias ИПровод.ИШаг.Якорь Якорь;

    override ИПотокВывода вывод() {return пусто;}
    override ИПровод провод() { return пусто; }
    override проц закрой() {}
    override т_мера пиши(проц[] ист) { return ИПровод.Кф; }
    override ИПотокВывода копируй(ИПотокВвода ист, т_мера max=-1)
    {
        Провод.перемести(ист, this, max);
        return this;
    }
    override ИПотокВывода слей() { return this; }
    override дол сместись(дол смещение, Якорь якорь = cast(Якорь)0) { return 0; }
}

/*******************************************************************************

    copyright:  Copyright © 2007 Daniel Keep.  все rights reserved.

    license:    BSD стиль: $(LICENSE)

    version:    Prerelease

    author:     Daniel Keep

*******************************************************************************/

//module tangox.io.поток.EventПоток;

//import io.device.Conduit : Провод;
//import io.model : ИПровод, ИПотокВвода, ИПотокВывода;

/**
 * The событие поток classes are designed в_ allow you в_ принять feedback on
 * как a поток chain is being used.  This is готово through the use of
 * delegate обрвызовы which are invoked just before the associated метод is
 * complete.
 */
class EventSeekInputПоток : ИПотокВвода //, ИПровод.ИШаг
{
    ///
    struct Обрвызовы
    {
        проц delegate()                     закрой; ///
        проц delegate()                     сотри; ///
        проц delegate(бцел, проц[])         читай; ///
        проц delegate(дол, дол, Якорь)   сместись; ///
    }

    //alias ИПровод.ИШаг.Якорь Якорь;

    ///
    this(ИПотокВвода источник, Обрвызовы обрвызовы)
    in
    {
        assert( источник !is пусто );
        assert( (cast(ИПровод.ИШаг) источник.провод) !is пусто );
    }
    body
    {
        this.источник = источник;
        this.шагун = источник; //cast(ИПровод.ИШаг) источник;
        this.обрвызовы = обрвызовы;
    }

    override ИПровод провод()
    {
        return источник.провод;
    }

    ИПотокВвода ввод()
    {
        return источник;
    }

    override проц закрой()
    {
        источник.закрой;
        источник = пусто;
        шагун = пусто;
        if( обрвызовы.закрой ) обрвызовы.закрой();
    }

    override т_мера читай(проц[] приёмн)
    {
        auto результат = источник.читай(приёмн);
        if( обрвызовы.читай ) обрвызовы.читай(результат, приёмн);
        return результат;
    }

    override ИПотокВвода слей()
    {
        источник.слей();
        if( обрвызовы.сотри ) обрвызовы.сотри();
        return this;
    }

    override проц[] загрузи(т_мера max=-1)
    {
        return Провод.загрузи(this, max);
    }

    override дол сместись(дол смещение, Якорь якорь = cast(Якорь)0)
    {
        auto результат = шагун.сместись(смещение, якорь);
        if( обрвызовы.сместись ) обрвызовы.сместись(результат, смещение, якорь);
        return результат;
    }

private:
    ИПотокВвода источник;
    ИПотокВвода шагун; //ИПровод.ИШаг шагун;
    Обрвызовы обрвызовы;

    invariant
    {
        assert( cast(Объект) источник is cast(Объект) шагун );
    }
}

/// ditto
class EventSeekOutputПоток : ИПотокВывода //, ИПровод.ИШаг
{
    ///
    struct Обрвызовы
    {
        проц delegate()                     закрой; ///
        проц delegate()                     слей; ///
        проц delegate(бцел, проц[])         пиши; ///
        проц delegate(дол, дол, Якорь)   сместись; ///
    }

    //alias ИПровод.ИШаг.Якорь Якорь;

    ///
    this(ИПотокВывода источник, Обрвызовы обрвызовы)
    in
    {
        assert( источник !is пусто );
        assert( (cast(ИПровод.ИШаг) источник.провод) !is пусто );
    }
    body
    {
        this.источник = источник;
        this.шагун = источник; //cast(ИПровод.ИШаг) источник;
        this.обрвызовы = обрвызовы;
    }

    override ИПровод провод()
    {
        return источник.провод;
    }

    override ИПотокВывода вывод()
    {
        return источник;
    }

    override проц закрой()
    {
        источник.закрой;
        источник = пусто;
        шагун = пусто;
        if( обрвызовы.закрой ) обрвызовы.закрой();
    }

    override т_мера пиши(проц[] приёмн)
    {
        auto результат = источник.пиши(приёмн);
        if( обрвызовы.пиши ) обрвызовы.пиши(результат, приёмн);
        return результат;
    }

    override ИПотокВывода слей()
    {
        источник.слей();
        if( обрвызовы.слей ) обрвызовы.слей();
        return this;
    }

    override дол сместись(дол смещение, Якорь якорь = cast(Якорь)0)
    {
        auto результат = шагун.сместись(смещение, якорь);
        if( обрвызовы.сместись ) обрвызовы.сместись(результат, смещение, якорь);
        return результат;
    }

    override ИПотокВывода копируй(ИПотокВвода ист, т_мера max=-1)
    {
        Провод.перемести(ист, this, max);
        return this;
    }

private:
    ИПотокВывода источник;
    ИПотокВывода шагун; //ИПровод.ИШаг шагун;
    Обрвызовы обрвызовы;

    invariant
    {
        assert( cast(Объект) источник is cast(Объект) шагун );
    }
}

/*******************************************************************************

    copyright:  Copyright © 2007 Daniel Keep.  все rights reserved.

    license:    BSD стиль: $(LICENSE)

    version:    Prerelease

    author:     Daniel Keep

*******************************************************************************/

//module tangox.io.поток.WrapПоток;

//import io.device.Conduit : Провод;
//import io.model : ИПровод, ИПотокВвода, ИПотокВывода;

/**
 * This поток can be used в_ provопрe access в_ другой поток.
 * Its distinguishing feature is that users cannot закрой the underlying
 * поток.
 *
 * This поток fully supports seeking, and as such requires that the
 * underlying поток also support seeking.
 */
class WrapSeekInputПоток : ИПотокВвода //, ИПровод.ИШаг
{
    //alias ИПровод.ИШаг.Якорь Якорь;

    /**
     * Create a new wrap поток из_ the given источник.
     */
    this(ИПотокВвода источник)
    in
    {
        assert( источник !is пусто );
        assert( (cast(ИПровод.ИШаг) источник.провод) !is пусто );
    }
    body
    {
        this.источник = источник;
        this.шагун = источник; //cast(ИПровод.ИШаг) источник;
        this._position = шагун.сместись(0, Якорь.Тек);
    }

    /// ditto
    this(ИПотокВвода источник, дол позиция)
    in
    {
        assert( позиция >= 0 );
    }
    body
    {
        this(источник);
        this._position = позиция;
    }

    override ИПровод провод()
    {
        return источник.провод;
    }

    ИПотокВвода ввод()
    {
        return источник;
    }

    override проц закрой()
    {
        источник = пусто;
        шагун = пусто;
    }

    override т_мера читай(проц[] приёмн)
    {
        if( шагун.сместись(0, Якорь.Тек) != _position )
            шагун.сместись(_position, Якорь.Нач);

        auto читай = источник.читай(приёмн);
        if( читай != ИПровод.Кф )
            _position += читай;

        return читай;
    }

    override ИПотокВвода слей()
    {
        источник.слей();
        return this;
    }

    override проц[] загрузи(т_мера max=-1)
    {
        return Провод.загрузи(this, max);
    }

    override дол сместись(дол смещение, Якорь якорь = cast(Якорь)0)
    {
        шагун.сместись(_position, Якорь.Нач);
        return (_position = шагун.сместись(смещение, якорь));
    }

private:
    ИПотокВвода источник;
    ИПотокВвода шагун; //ИПровод.ИШаг шагун;
    дол _position;

    invariant
    {
        assert( cast(Объект) источник is cast(Объект) шагун );
        assert( _position >= 0 );
    }
}

/**
 * This поток can be used в_ provопрe access в_ другой поток.
 * Its distinguishing feature is that the users cannot закрой the underlying
 * поток.
 *
 * This поток fully supports seeking, and as such requires that the
 * underlying поток also support seeking.
 */
class WrapSeekOutputПоток : ИПотокВывода//, ИПровод.ИШаг
{
    //alias ИПровод.ИШаг.Якорь Якорь;

    /**
     * Create a new wrap поток из_ the given источник.
     */
    this(ИПотокВывода источник)
    in
    {
        assert( (cast(ИПровод.ИШаг) источник.провод) !is пусто );
    }
    body
    {
        this.источник = источник;
        this.шагун = источник; //cast(ИПровод.ИШаг) источник;
        this._position = шагун.сместись(0, Якорь.Тек);
    }

    /// ditto
    this(ИПотокВывода источник, дол позиция)
    in
    {
        assert( позиция >= 0 );
    }
    body
    {
        this(источник);
        this._position = позиция;
    }

    override ИПровод провод()
    {
        return источник.провод;
    }

    override ИПотокВывода вывод()
    {
        return источник;
    }

    override проц закрой()
    {
        источник = пусто;
        шагун = пусто;
    }

    т_мера пиши(проц[] ист)
    {
        if( шагун.сместись(0, Якорь.Тек) != _position )
            шагун.сместись(_position, Якорь.Нач);

        auto wrote = источник.пиши(ист);
        if( wrote != ИПровод.Кф )
            _position += wrote;
        return wrote;
    }

    override ИПотокВывода копируй(ИПотокВвода ист, т_мера max=-1)
    {
        Провод.перемести(ист, this, max);
        return this;
    }

    override ИПотокВывода слей()
    {
        источник.слей();
        return this;
    }

    override дол сместись(дол смещение, Якорь якорь = cast(Якорь)0)
    {
        шагун.сместись(_position, Якорь.Нач);
        return (_position = шагун.сместись(смещение, якорь));
    }

private:
    ИПотокВывода источник;
    ИПотокВывода шагун; //ИПровод.ИШаг шагун;
    дол _position;

    invariant
    {
        assert( cast(Объект) источник is cast(Объект) шагун );
        assert( _position >= 0 );
    }
}


