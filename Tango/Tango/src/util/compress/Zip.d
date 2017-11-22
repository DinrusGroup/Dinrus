/*******************************************************************************
 *
 * copyright:   Copyright (c) 2007 Daniel Keep.  все rights reserved.
 *
 * license:     BSD стиль: $(LICENSE)
 *
 * version:     Initial release: December 2007
 *
 * author:      Daniel Keep
 *
 ******************************************************************************/

module util.compress.Zip;

/*

TODO
====

* Disable UTF кодировка until I've worked out what version of ZIP that's
  related в_... (actually; it's entirely possible that's it's merely a
  *proposal* at the moment.) (*Готово*)

* Make ЗаписьЗип safe: сделай them aware that their creating читатель есть been
  destroyed.

*/

import core.ByteSwap : ПерестановкаБайт;
import io.device.Array : Массив;
import io.device.File : Файл;
import io.FilePath : ФПуть, ПросмотрПути;
import io.device.FileMap : ФайлМэп;
import util.compress.ZlibStream : ВводЗлиб, ВыводЗлиб;
import util.digest.Crc32 : Crc32;
import io.model : ИПровод, ИПотокВвода, ИПотокВывода;
import io.stream.Digester : ДайджестВвод;
import time.Time : Время, ИнтервалВремени;
import time.WallClock : Куранты;
import time.chrono.Gregorian : Грегориан;

import Путь = io.Path;
import PathUtil = util.PathUtil;
import Целое = text.convert.Integer;


debug(ZIP) import io.Stdout : Стдош;

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
// Implementation crap
//
// Why is this here, you ask?  Because of bloody DMD forward reference bugs.
// For pete's sake, Walter, FIX THEM, please!
//
// To пропусти в_ the actual пользователь-visible stuff, search for "Shared stuff".

private
{

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
// ЛокалФайлЗаг
//

    align(1)
    struct ДанныеЛокалФайлЗага
    {
        бкрат      версия_извлечения = бкрат.max;
        бкрат      основные_флаги = 0;
        бкрат      метод_сжатия = 0;
        бкрат      время_изменения_файла = 0;
        бкрат      дата_изменения_файла = 0;
        бцел        crc_32 = 0; // offsetof = 10
        бцел        сжатый_размер = 0;
        бцел        разжатый_размер = 0;
        бкрат      длина_названия_файла = 0;
        бкрат      экстрадлина_поля = 0;

        debug(ZIP) проц dump()
        {
            Стдош
            ("ЛокалФайлЗаг.Данные {")("\n")
            ("  версия_извлечения = ")(версия_извлечения)("\n")
            ("  основные_флаги = ")(основные_флаги)("\n")
            ("  метод_сжатия = ")(метод_сжатия)("\n")
            ("  время_изменения_файла = ")(время_изменения_файла)("\n")
            ("  дата_изменения_файла = ")(дата_изменения_файла)("\n")
            ("  crc_32 = ")(crc_32)("\n")
            ("  сжатый_размер = ")(сжатый_размер)("\n")
            ("  разжатый_размер = ")(разжатый_размер)("\n")
            ("  длина_названия_файла = ")(длина_названия_файла)("\n")
            ("  экстрадлина_поля = ")(экстрадлина_поля)("\n")
            ("}").нс;
        }
    }

struct ЛокалФайлЗаг
{
    const бцел сигнатура = 0x04034b50;

    alias ДанныеЛокалФайлЗага Данные;
    Данные данные;
    static assert( Данные.sizeof == 26 );

    ткст имя_файла;
    ббайт[] допполе;

    проц[] массив_данн()
    {
        return (&данные)[0..1];
    }

    проц помести(ИПотокВывода вывод)
    {
        // Make sure var-length fields will fit.
        if( имя_файла.length > бкрат.max )
            ИсклЗип.fntoolong;

        if( допполе.length > бкрат.max )
            ИсклЗип.eftoolong;

        // Encode имяф
        auto имя_файла = utf8_to_cp437(this.имя_файла);
        scope(exit) if( имя_файла !is cast(ббайт[])this.имя_файла )
            delete имя_файла;

        if( имя_файла is пусто )
            ИсклЗип.fnencode;

        // Update lengths in данные
        Данные данные = this.данные;
        данные.длина_названия_файла = cast(бкрат) имя_файла.length;
        данные.экстрадлина_поля = cast(бкрат) допполе.length;

        // Do it
        version( БигЭндиан ) свопВсе(данные);
        пишиРовно(вывод, (&данные)[0..1]);
        пишиРовно(вывод, имя_файла);
        пишиРовно(вывод, допполе);
    }

    проц заполни(ИПотокВвода ист)
    {
        читайРовно(ист, массив_данн);
        version( БигЭндиан ) свопВсе(данные);

        //debug(ZIP) данные.dump;

        auto врем = new ббайт[данные.длина_названия_файла];
        читайРовно(ист, врем);
        имя_файла = кс437_в_утф8(врем);
        if( cast(сим*) врем.ptr !is имя_файла.ptr ) delete врем;

        допполе = new ббайт[данные.экстрадлина_поля];
        читайРовно(ист, допполе);
    }

    /*
     * This метод will check в_ сделай sure that the local and central заголовки
     * are the same; if they're not, then that indicates that the архив is
     * corrupt.
     */
    бул agrees_with(ФайлЗаг h)
    {
        // NOTE: допполе used в_ be compared with h.допполе, but this caused
        // an assertion in certain archives. I найдено a mention of these fields being
        // allowed в_ be different, so I think it in general is wrong в_ include in
        // this sanity check. larsivi 20081111
        if( данные.версия_извлечения != h.данные.версия_извлечения
                || данные.основные_флаги != h.данные.основные_флаги
                || данные.метод_сжатия != h.данные.метод_сжатия
                || данные.время_изменения_файла != h.данные.время_изменения_файла
                || данные.дата_изменения_файла != h.данные.дата_изменения_файла
                || данные.crc_32 != h.данные.crc_32
                || данные.сжатый_размер != h.данные.сжатый_размер
                || данные.разжатый_размер != h.данные.разжатый_размер
                || имя_файла != h.имя_файла )
            return нет;
        
        // We need a separate check for the sizes and crc32, since these will
        // be zero if a trailing descrИПtor was used.
        if( !h.используетДескрипторДанных && (
                   данные.crc_32 != h.данные.crc_32
                || данные.сжатый_размер != h.данные.сжатый_размер
                || данные.разжатый_размер != h.данные.разжатый_размер ) )
            return нет;

        return да;
    }
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
// ФайлЗаг
//

    align(1)
    struct ДанныеФайлЗага
    {
        ббайт       версия_зип;
        ббайт       тип_файл_атров;
        бкрат      версия_извлечения;
        бкрат      основные_флаги;
        бкрат      метод_сжатия;
        бкрат      время_изменения_файла;
        бкрат      дата_изменения_файла;
        бцел        crc_32;
        бцел        сжатый_размер;
        бцел        разжатый_размер;
        бкрат      длина_названия_файла;
        бкрат      экстрадлина_поля;
        бкрат      file_comment_length;
        бкрат      disk_number_start;
        бкрат      internal_file_attributes = 0;
        бцел        external_file_attributes = 0;
        цел         relative_offset_of_local_header;

        debug(ZIP) проц dump()
        {
            Стдош
            ("ФайлЗаг.Данные {\n")
            ("  версия_зип = ")(версия_зип)("\n")
            ("  тип_файл_атров = ")(тип_файл_атров)("\n")
            ("  версия_извлечения = ")(версия_извлечения)("\n")
            ("  основные_флаги = ")(основные_флаги)("\n")
            ("  метод_сжатия = ")(метод_сжатия)("\n")
            ("  время_изменения_файла = ")(время_изменения_файла)("\n")
            ("  дата_изменения_файла = ")(дата_изменения_файла)("\n")
            ("  crc_32 = ")(crc_32)("\n")
            ("  сжатый_размер = ")(сжатый_размер)("\n")
            ("  разжатый_размер = ")(разжатый_размер)("\n")
            ("  длина_названия_файла = ")(длина_названия_файла)("\n")
            ("  экстрадлина_поля = ")(экстрадлина_поля)("\n")
            ("  file_comment_length = ")(file_comment_length)("\n")
            ("  disk_number_start = ")(disk_number_start)("\n")
            ("  internal_file_attributes = ")(internal_file_attributes)("\n")
            ("  external_file_attributes = ")(external_file_attributes)("\n")
            ("  relative_offset_of_local_header = ")(relative_offset_of_local_header)
                ("\n")
            ("}").нс;
        }

        проц fromLocal(ЛокалФайлЗаг.Данные данные)
        {
            версия_извлечения = данные.версия_извлечения;
            основные_флаги = данные.основные_флаги;
            метод_сжатия = данные.метод_сжатия;
            время_изменения_файла = данные.время_изменения_файла;
            дата_изменения_файла = данные.дата_изменения_файла;
            crc_32 = данные.crc_32;
            сжатый_размер = данные.сжатый_размер;
            разжатый_размер = данные.разжатый_размер;
            длина_названия_файла = данные.длина_названия_файла;
            экстрадлина_поля = данные.экстрадлина_поля;
        }
    }

struct ФайлЗаг
{
    const бцел сигнатура = 0x02014b50;

    alias ДанныеФайлЗага Данные;
    Данные* данные;
    static assert( Данные.sizeof == 42 );

    ткст имя_файла;
    ббайт[] допполе;
    ткст комментарий_файла;

    бул используетДескрипторДанных()
    {
        return !!(данные.основные_флаги & 1<<3);
    }

    бцел опцииСжатия()
    {
        return (данные.основные_флаги >> 1) & 0b11;
    }

    бул используетУтф8()
    {
        //return !!(данные.основные_флаги & 1<<11);
        return нет;
    }

    проц[] массив_данн()
    {
        return (cast(проц*)данные)[0 .. Данные.sizeof];
    }

    проц помести(ИПотокВывода вывод)
    {
        // Make sure the var-length fields will fit.
        if( имя_файла.length > бкрат.max )
            ИсклЗип.fntoolong;

        if( допполе.length > бкрат.max )
            ИсклЗип.eftoolong;

        if( комментарий_файла.length > бкрат.max )
            ИсклЗип.cotoolong;

        // кодируй the имяф and коммент
        auto имя_файла = utf8_to_cp437(this.имя_файла);
        scope(exit) if( имя_файла !is cast(ббайт[])this.имя_файла )
            delete имя_файла;
        auto комментарий_файла = utf8_to_cp437(this.комментарий_файла);
        scope(exit) if( комментарий_файла !is cast(ббайт[])this.комментарий_файла )
            delete комментарий_файла;

        if( имя_файла is пусто )
            ИсклЗип.fnencode;

        if( комментарий_файла is пусто && this.комментарий_файла !is пусто )
            ИсклЗип.coencode;

        // Update the lengths
        Данные данные = *(this.данные);
        данные.длина_названия_файла = cast(бкрат) имя_файла.length;
        данные.экстрадлина_поля = cast(бкрат) допполе.length;
        данные.file_comment_length = cast(бкрат) комментарий_файла.length;

        // Ok; let's do this!
        version( БигЭндиан ) свопВсе(данные);
        пишиРовно(вывод, (&данные)[0..1]);
        пишиРовно(вывод, имя_файла);
        пишиРовно(вывод, допполе);
        пишиРовно(вывод, комментарий_файла);
    }

    дол карта(проц[] ист)
    {
        //debug(ZIP) Стдош.форматнс("ФайлЗаг.карта([0..{}])",ист.length);

        auto old_ptr = ист.ptr;

        данные = cast(Данные*) ист.ptr;
        ист = ист[Данные.sizeof..$];
        version( БигЭндиан ) свопВсе(*данные);

        //debug(ZIP) данные.dump;

        ткст function(ббайт[]) conv_fn;
        if( используетУтф8 )
            conv_fn = &кс437_в_утф8;
        else
            conv_fn = &utf8_to_utf8;

        имя_файла = conv_fn(
                cast(ббайт[]) ист[0..данные.длина_названия_файла]);
        ист = ист[данные.длина_названия_файла..$];

        допполе = cast(ббайт[]) ист[0..данные.экстрадлина_поля];
        ист = ист[данные.экстрадлина_поля..$];

        комментарий_файла = conv_fn(
                cast(ббайт[]) ист[0..данные.file_comment_length]);
        ист = ист[данные.file_comment_length..$];

        // Return как many байты we've eaten
        //debug(ZIP) Стдош.форматнс(" . used {} байты", cast(дол)(ист.ptr - old_ptr));
        return cast(дол)(ист.ptr - old_ptr);
    }
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
// EndOfCDRecord
//

    align(1)
    struct EndOfCDRecordData
    {
        бкрат      disk_number = 0;
        бкрат      disk_with_start_of_central_directory = 0;
        бкрат      central_directory_entries_on_this_disk;
        бкрат      central_directory_entries_total;
        бцел        size_of_central_directory;
        бцел        offset_of_start_of_cd_from_starting_disk;
        бкрат      file_comment_length;

        debug(ZIP) проц dump()
        {
            Стдош
                .форматнс("EndOfCDRecord.Данные {}","{")
                .форматнс("  disk_number = {}", disk_number)
                .форматнс("  disk_with_start_of_central_directory = {}",
                        disk_with_start_of_central_directory)
                .форматнс("  central_directory_entries_on_this_disk = {}",
                        central_directory_entries_on_this_disk)
                .форматнс("  central_directory_entries_total = {}",
                        central_directory_entries_total)
                .форматнс("  size_of_central_directory = {}",
                        size_of_central_directory)
                .форматнс("  offset_of_start_of_cd_from_starting_disk = {}",
                        offset_of_start_of_cd_from_starting_disk)
                .форматнс("  file_comment_length = {}", file_comment_length)
                .форматнс("}");
        }
    }

struct EndOfCDRecord
{
    const бцел  сигнатура = 0x06054b50;

    alias EndOfCDRecordData Данные;
    Данные данные;
    static assert( данные.sizeof == 18 );

    ткст комментарий_файла;

    проц[] массив_данн()
    {
        return (cast(проц*)&данные)[0 .. данные.sizeof];
    }

    проц помести(ИПотокВывода вывод)
    {
        // Набор up the коммент; check length, кодируй
        if( комментарий_файла.length > бкрат.max )
            ИсклЗип.cotoolong;

        auto комментарий_файла = utf8_to_cp437(this.комментарий_файла);
        scope(exit) if( комментарий_файла !is cast(ббайт[])this.комментарий_файла )
                delete комментарий_файла;

        // Набор up данные block
        Данные данные = this.данные;
        данные.file_comment_length = cast(бкрат) комментарий_файла.length;

        version( БигЭндиан ) свопВсе(данные);
        пишиРовно(вывод, (&данные)[0..1]);
    }

    проц заполни(проц[] ист)
    {
        //Стдош.форматнс("EndOfCDRecord.заполни([0..{}])",ист.length);

        auto _data = массив_данн;
        _data[] = ист[0.._data.length];
        ист = ист[_data.length..$];
        version( БигЭндиан ) свопВсе(данные);

        //данные.dump;

        комментарий_файла = cast(ткст) ист[0..данные.file_comment_length].dup;
    }
}

// End of implementation crap
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
// Shared stuff

public
{
    /**
     * This enumeration denotes the kind of compression used on a файл.
     */
    enum Метод
    {
        /// No compression should be used.
        Store,
        /// Deflate compression.
        Deflate,
        /**
         * This is a special значение used for unsupported or unrecognised
         * compression methods.  This значение is only used internally.
         */
        Unsupported
    }
}

private
{
    const бкрат ZIP_VERSION = 20;
    const бкрат MAX_EXTRACT_VERSION = 20;

    /*                                     compression флаги
                                  uses trailing descrИПtor |
                               utf-8 кодировка            | |
                                            ^            ^ /\               */
    const бкрат SUPPORTED_FLAGS = 0b00_0_0_0_0000_0_0_0_1_11_0;
    const бкрат UNSUPPORTED_FLAGS = ~SUPPORTED_FLAGS;

    Метод toMethod(бкрат метод)
    {
        switch( метод )
        {
            case 0:     return Метод.Store;
            case 8:     return Метод.Deflate;
            default:    return Метод.Unsupported;
        }
    }

    бкрат fromMethod(Метод метод)
    {
        switch( метод )
        {
            case Метод.Store:      return 0;
            case Метод.Deflate:    return 8;
            default:
                assert(нет, "неподдерживаемый метод сжатия");
        }
    }

    /* NOTE: This doesn't actually appear в_ work.  Using the default magic
     * число with Dinrus's Crc32 дайджест works, however.
     */
    //const CRC_MAGIC = 0xdebb20e3u;
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
// ЧитательЗип

interface ЧитательЗип
{
    бул поточно();
    проц закрой();
    бул ещё();
    ЗаписьЗип получи();
    ЗаписьЗип получи(ЗаписьЗип);
    цел opApply(цел delegate(ref ЗаписьЗип));
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
// ПисательЗип

interface ПисательЗип
{
    проц финиш();
    проц поместиФайл(ИнфоОЗаписиЗип инфо, ткст путь);
    проц поместиФайл(ИнфоОЗаписиЗип инфо, ткст путь);
    проц поместиПоток(ИнфоОЗаписиЗип инфо, ИПотокВвода источник);
    проц поместиЗапись(ИнфоОЗаписиЗип инфо, ЗаписьЗип Запись);
    проц поместиДанные(ИнфоОЗаписиЗип инфо, проц[] данные);
    Метод метод();
    Метод метод(Метод);
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
// ЧитательБлокаЗип

/**
 * The ЧитательБлокаЗип class is used в_ разбор a ZIP архив.  It exposes the
 * contents of the архив via an iteration interface.  For экземпляр, в_ loop
 * over все файлы in an архив, one can use either
 *
 * -----
 *  foreach( Запись ; читатель )
 *      ...
 * -----
 *
 * Or
 *
 * -----
 *  while( читатель.ещё )
 *  {
 *      auto Запись = читатель.получи;
 *      ...
 *  }
 * -----
 *
 * See the ЗаписьЗип class for ещё information on the contents of записи.
 *
 * Note that this class can only be used with ввод sources which can be
 * freely seeked.  Also note that you may открой a ЗаписьЗип экземпляр produced by
 * this читатель at any время until the ЧитательЗип that создан it is закрыт.
 */
class ЧитательБлокаЗип : ЧитательЗип
{
    /**
     * Creates a ЧитательБлокаЗип using the specified файл on the local
     * filesystem.
     */
    this(ткст путь)
    {
        file_source = new Файл(путь);
        this(file_source);
    }

version( Неук )
{
    /**
     * Creates a ЧитательБлокаЗип using the provопрed Файл экземпляр.  Where
     * possible, the провод will be wrapped in a память-mapped буфер for
     * optimum performance.  If you do not want the Файл память-mapped,
     * either cast it в_ an ИПотокВвода first, or пароль источник.ввод в_ the
     * constructor.
     */
    this(Файл источник)
    {
        // BUG: ФайлМэп doesn't implement ИПровод.ИШаг
        //mm_source = new ФайлМэп(источник);
        //this(mm_source);
        this(источник.ввод);
    }
}

    /**
     * Creates a ЧитательБлокаЗип using the provопрed ИПотокВвода.  Please note
     * that this ИПотокВвода must be attached в_ a провод implementing the 
     * ИПровод.ИШаг interface.
     */
    this(ИПотокВвода источник)
    in
    {
        assert( cast(ИПровод.ИШаг) источник.провод, "источник поток must be seekable" );
    }
    body
    {
        this.источник = источник;
        this.шагун = источник; //cast(ИПровод.ИШаг) источник;
    }

    бул поточно() { return нет; }

    /**
     * Closes the читатель, and releases все resources.  After this operation,
     * все ЗаписьЗип instances создан by this ЧитательЗип are не_годится and should
     * not be used.
     */
    проц закрой()
    {
        // NOTE: Originally ещё of the СМ allocated данные in this class were
        // explicitly deleted here, such as cd_data - this caused segfaults
        // and have been removed as they were not necessary из_ correctness
        // точка of view, and the память usage win is questionable.
        состояние = Состояние.Готово;
        источник = пусто;
        шагун = пусто;
        delete заголовки;

        if( file_source !is пусто )  
          {
          file_source.закрой;
          delete file_source;
          }

        if( mm_source !is пусто )    
            delete mm_source;
    }

    /**
     * Returns да if and only if there are добавьitional файлы in the архив
     * which have not been читай via the получи метод.  This returns да before
     * the first вызов в_ получи (assuming the opened архив is non-пустой), and
     * нет after the последний файл есть been использовался.
     */
    бул ещё()
    {
        switch( состояние )
        {
            case Состояние.Init:
                read_cd;
                assert( состояние == Состояние.Open );
                return ещё;

            case Состояние.Open:
                return (current_index < заголовки.length);

            case Состояние.Готово:
                return нет;

            default:
                assert(нет);
        }
    }

    /**
     * Retrieves the следщ файл из_ the архив.  Note that although this does
     * perform IO operations, it will not читай the contents of the файл.
     *
     * The optional reuse аргумент can be used в_ instruct the читатель в_ reuse
     * an existing ЗаписьЗип экземпляр.  If passed a пусто reference, it will
     * создай a new ЗаписьЗип экземпляр.
     */
    ЗаписьЗип получи()
    {
        if( !ещё )
            ZIPExhaustedException();

        return new ЗаписьЗип(заголовки[current_index++], &open_file);
    }

    /// ditto
    ЗаписьЗип получи(ЗаписьЗип reuse)
    {
        if( !ещё )
            ZIPExhaustedException();

        if( reuse is пусто )
            return new ЗаписьЗип(заголовки[current_index++], &open_file);
        else
            return reuse.сбрось(заголовки[current_index++], &open_file);
    }

    /**
     * This is used в_ iterate over the contents of an архив using a foreach
     * loop.  Please note that the iteration will reuse the ЗаписьЗип экземпляр
     * passed в_ your loop.  If you wish в_ keep the экземпляр and re-use it
     * later, you $(B must) use the dup member в_ создай a копируй.
     */
    цел opApply(цел delegate(ref ЗаписьЗип) дг)
    {
        цел результат = 0;
        ЗаписьЗип Запись;

        while( ещё )
        {
            Запись = получи(Запись);

            результат = дг(Запись);
            if( результат )
                break;
        }

        if( Запись !is пусто )
            delete Запись;

        return результат;
    }

private:
    ИПотокВвода источник;
    ИПотокВвода шагун; //ИПровод.ИШаг шагун;

    enum Состояние { Init, Open, Готово }
    Состояние состояние;
    т_мера current_index = 0;
    ФайлЗаг[] заголовки;

    // These should be killed when the читатель is закрыт.
    ббайт[] cd_data;
    Файл file_source = пусто;
    ФайлМэп mm_source = пусто;

    /*
     * This function will читай the contents of the central дир.  разбей
     * or spanned archives aren't supported.
     */
    проц read_cd()
    in
    {
        assert( состояние == Состояние.Init );
        assert( заголовки is пусто );
        assert( cd_data is пусто );
    }
    out
    {
        assert( состояние == Состояние.Open );
        assert( заголовки !is пусто );
        assert( cd_data !is пусто );
        assert( current_index == 0 );
    }
    body
    {
        //Стдош.форматнс("ЧитательЗип.read_cd()");

        // First, we need в_ местоположение the конец of cd record, so that we know
        // where the cd itself is, and как big it is.
        auto eocdr = read_eocd_record;

        // Сейчас, сделай sure the архив is все in one файл.
        if( eocdr.данные.disk_number !=
                    eocdr.данные.disk_with_start_of_central_directory
                || eocdr.данные.central_directory_entries_on_this_disk !=
                    eocdr.данные.central_directory_entries_total )
            ZIPNotSupportedException.spanned;

        // Ok, читай the whole damn thing in one go.
        cd_data = new ббайт[eocdr.данные.size_of_central_directory];
        дол cd_offset = eocdr.данные.offset_of_start_of_cd_from_starting_disk;
        шагун.сместись(cd_offset, шагун.Якорь.Нач);
        читайРовно(источник, cd_data);

        // Cake.  Сейчас, we need в_ break it up преобр_в records.
        заголовки = new ФайлЗаг[
            eocdr.данные.central_directory_entries_total];

        дол cdr_offset = cd_offset;

        // Ok, карта the CD данные преобр_в файл заголовки.
        foreach( i,ref заголовок ; заголовки )
        {
            //Стдош.форматнс(" . reading заголовок {}...", i);

            // Check сигнатура
            {
                бцел sig = (cast(бцел[])(cd_data[0..4]))[0];
                version( БигЭндиан ) своп(sig);
                if( sig != ФайлЗаг.сигнатура )
                    ИсклЗип.badsig("файл заголовок");
            }

            auto used = заголовок.карта(cd_data[4..$]);
            assert( used <= (т_мера.max-4) );
            cd_data = cd_data[4+cast(т_мера)used..$];

            // Update смещение for следщ record
            cdr_offset += 4 /* for sig. */ + used;
        }

        // Готово!
        состояние = Состояние.Open;
    }

    /*
     * This will местоположение the конец of CD record in the открой поток.
     *
     * This код sucks, but that's because ZIP sucks.
     *
     * Basically, the EOCD record is stuffed somewhere at the конец of the файл.
     * In a brilliant перемести, the record is *variably sized*, which means we
     * have в_ do a linear backwards search в_ найди it.
     *
     * The заголовок itself (включая the сигнатура) is at minimum 22 байты
     * дол, plus anywhere between 0 and 2^16-1 байты of коммент.  That means
     * we need в_ читай the последний 2^16-1 + 22 байты из_ the файл, and look for
     * the сигнатура [0x50,0x4b,0x05,0x06] in [0 .. $-18].
     *
     * If we найди the EOCD record, we'll return its contents.  If we couldn't
     * найди it, we'll throw an исключение.
     */
    EndOfCDRecord read_eocd_record()
    in
    {
        assert( состояние == Состояние.Init );
    }
    body
    {
        //Стдош.форматнс("read_eocd_record()");

        // Signature + record + max. коммент length
        const max_chunk_len = 4 + EndOfCDRecord.Данные.sizeof + бкрат.max;

        auto file_len = шагун.сместись(0, шагун.Якорь.Кон);
        assert( file_len <= т_мера.max );

        // We're going в_ need min(max_chunk_len, file_len) байты.
        т_мера chunk_len = max_chunk_len;
        if( file_len < max_chunk_len )
            chunk_len = cast(т_мера) file_len;
        //Стдош.форматнс(" . chunk_len = {}", chunk_len);

        // Seek back and читай in the chunk.  Don't forget в_ clean up after
        // ourselves.
        шагун.сместись(-cast(дол)chunk_len, шагун.Якорь.Кон);
        auto chunk_offset = шагун.сместись(0, шагун.Якорь.Тек);
        //Стдош.форматнс(" . chunk_offset = {}", chunk_offset);
        auto chunk = new ббайт[chunk_len];
        scope(exit) delete chunk;
        читайРовно(источник, chunk);

        // Сейчас look for our magic число.  Don't forget that on big-эндиан
        // machines, we need в_ byteсвоп the значение we're looking for.
        бцел eocd_magic = EndOfCDRecord.сигнатура;
        version( БигЭндиан )
            своп(eocd_magic);

        т_мера eocd_loc = -1;

        if( chunk_len >= 18 )
            for( т_мера i=chunk_len-18; i>=0; --i )
            {
                if( *(cast(бцел*)(chunk.ptr+i)) == eocd_magic )
                {
                    // Найдено the bugger!  Make sure we пропусти the сигнатура (forgot
                    // в_ do that originally; talk about weird ошибки :P)
                    eocd_loc = i+4;
                    break;
                }
            }

        // If we dопрn't найди it, then we'll assume that this is not a valid
        // архив.
        if( eocd_loc == -1 )
            ИсклЗип.missingdir;

        // Ok, so we найдено it; сейчас what?  Сейчас we need в_ читай the record
        // itself in.  eocd_loc is the смещение within the chunk where the eocd
        // record was найдено, so срез it out.
        EndOfCDRecord eocdr;
        eocdr.заполни(chunk[eocd_loc..$]);

        // Excellent.  We're готово here.
        return eocdr;
    }

    /*
     * Opens the specified файл for reading.  If the необр аргумент passed is
     * да, then the файл is *not* decompressed.
     */
    ИПотокВвода open_file(ФайлЗаг заголовок, бул необр)
    {
        // Check в_ сделай sure that we actually *can* открой this файл.
        if( заголовок.данные.версия_извлечения > MAX_EXTRACT_VERSION )
            ZIPNotSupportedException.zИПver(заголовок.данные.версия_извлечения);

        if( заголовок.данные.основные_флаги & UNSUPPORTED_FLAGS )
            ZIPNotSupportedException.флаги;

        if( toMethod(заголовок.данные.метод_сжатия) == Метод.Unsupported )
            ZIPNotSupportedException.метод(заголовок.данные.метод_сжатия);

        // Open a необр поток
        ИПотокВвода поток = open_file_Необр(заголовок);

        // If that's все they wanted, пароль it back.
        if( необр )
            return поток;

        // Next up, wrap in an appropriate decompression поток
        switch( toMethod(заголовок.данные.метод_сжатия) )
        {
            case Метод.Store:
                // Do nothing: \o/
                break;

            case Метод.Deflate:
                // Wrap in a zlib поток.  We want a необр deflate поток,
                // so force no кодировка.
                поток = new ВводЗлиб(поток, ВводЗлиб.Кодировка.Нет);
                break;

            default:
                assert(нет);
        }

        // We готово, yo!
        return поток;
    }

    /*
     * Opens a файл's необр ввод поток.  Basically, this returns a срез of
     * the архив's ввод поток.
     */
    ИПотокВвода open_file_Необр(ФайлЗаг заголовок)
    {
        // Seek в_ and разбор the local файл заголовок
        шагун.сместись(заголовок.данные.relative_offset_of_local_header,
                шагун.Якорь.Нач);

        {
            бцел sig;
            читайРовно(источник, (&sig)[0..1]);
            version( БигЭндиан ) своп(sig);
            if( sig != ЛокалФайлЗаг.сигнатура )
                ИсклЗип.badsig("local файл заголовок");
        }

        ЛокалФайлЗаг lheader; lheader.заполни(источник);

        if( !lheader.agrees_with(заголовок) )
            ИсклЗип.incons(заголовок.имя_файла);

        // Ok; получи a срез поток for the файл
        return new SliceSeekInputПоток(
             источник, шагун.сместись(0, шагун.Якорь.Тек),
             заголовок.данные.сжатый_размер);
    }
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
// ПисательБлокаЗип

/**
 * The ПисательБлокаЗип class is used в_ создай a ZIP архив.  It uses a
 * writing iterator interface.
 *
 * Note that this class can only be used with вывод Потокs which can be
 * freely seeked.
 */

class ПисательБлокаЗип : ПисательЗип
{
    /**
     * Creates a ПисательБлокаЗип using the specified файл on the local
     * filesystem.
     */
    this(ткст путь)
    {
        file_output = new Файл(путь, Файл.ЗапСозд);
        this(file_output);
    }

    /**
     * Creates a ПисательБлокаЗип using the provопрed ИПотокВывода.  Please note
     * that this ИПотокВывода must be attached в_ a провод implementing the 
     * ИПровод.ИШаг interface.
     */
    this(ИПотокВывода вывод)
    in
    {
        assert( вывод !is пусто );
        assert( (cast(ИПровод.ИШаг) вывод.провод) !is пусто );
    }
    body
    {
        this.вывод = вывод;
        this.шагун = вывод; // cast(ИПровод.ИШаг) вывод;

        // Default в_ Deflate compression
        метод = Метод.Deflate;
    }

    /**
     * Finalises the архив, writes out the central дир, and closes the
     * вывод поток.
     */
    проц финиш()
    {
        put_cd;
        вывод.закрой();
        вывод = пусто;
        шагун = пусто;

        if( file_output !is пусто ) delete file_output;
    }

    /**
     * добавьs a файл из_ the local filesystem в_ the архив.
     */
    проц поместиФайл(ИнфоОЗаписиЗип инфо, ткст путь)
    {
        scope файл = new Файл(путь);
        scope(exit) файл.закрой();
        поместиПоток(инфо, файл);
    }

    /**
     * добавьs a файл using the contents of the given ИПотокВвода в_ the архив.
     */
    проц поместиПоток(ИнфоОЗаписиЗип инфо, ИПотокВвода источник)
    {
        put_compressed(инфо, источник);
    }

    /**
     * Transfers a файл из_ другой архив преобр_в this архив.  Note that
     * this метод will not perform any compression: whatever compression was
     * applied в_ the файл originally will be preserved.
     */
    проц поместиЗапись(ИнфоОЗаписиЗип инфо, ЗаписьЗип Запись)
    {
        put_Необр(инфо, Запись);
    }

    /**
     * добавьs a файл using the contents of the given Массив в_ the архив.
     */
    проц поместиДанные(ИнфоОЗаписиЗип инфо, проц[] данные)
    {
        //scope mc = new MemoryConduit(данные);
        scope mc = new Массив(данные);
        scope(exit) mc.закрой;
        put_compressed(инфо, mc);
    }

    /**
     * This property allows you в_ control what compression метод should be
     * used for файлы being добавьed в_ the архив.
     */
    Метод метод() { return _method; }
    Метод метод(Метод v) { return _method = v; } /// ditto

private:
    ИПотокВывода вывод;
    ИПотокВывода шагун;
    Файл file_output;

    Метод _method;

    struct Запись
    {
        ДанныеФайлЗага данные;
        дол header_position;
        ткст имяф;
        ткст коммент;
        ббайт[] extra;
    }
    Запись[] записи;

    проц put_cd()
    {
        // check that there aren't too many CD записи
        if( записи.length > бкрат.max )
            ИсклЗип.toomanyentries;

        auto cd_pos = шагун.сместись(0, шагун.Якорь.Тек);
        if( cd_pos > бцел.max )
            ИсклЗип.toolong;

        foreach( Запись ; записи )
        {
            ФайлЗаг заголовок;
            заголовок.данные = &Запись.данные;
            заголовок.имя_файла = Запись.имяф;
            заголовок.допполе = Запись.extra;
            заголовок.комментарий_файла = Запись.коммент;

            пиши(вывод, ФайлЗаг.сигнатура);
            заголовок.помести(вывод);
        }

        auto cd_len = шагун.сместись(0, шагун.Якорь.Тек) - cd_pos;

        if( cd_len > бцел.max )
            ИсклЗип.cdtoolong;

        {
            assert( записи.length < бкрат.max );
            assert( cd_len < бцел.max );
            assert( cd_pos < бцел.max );

            EndOfCDRecord eocdr;
            eocdr.данные.central_directory_entries_on_this_disk =
                cast(бкрат) записи.length;
            eocdr.данные.central_directory_entries_total =
                cast(бкрат) записи.length;
            eocdr.данные.size_of_central_directory =
                cast(бцел) cd_len;
            eocdr.данные.offset_of_start_of_cd_from_starting_disk =
                cast(бцел) cd_pos;

            пиши(вывод, EndOfCDRecord.сигнатура);
            eocdr.помести(вывод);
        }
    }

    проц put_Необр(ИнфоОЗаписиЗип инфо, ЗаписьЗип Запись)
    {
        // Write out local файл заголовок
        ЛокалФайлЗаг.Данные lhdata;
        auto chdata = Запись.заголовок.данные;
        lhdata.версия_извлечения = chdata.версия_извлечения;
        lhdata.основные_флаги = chdata.основные_флаги;
        lhdata.метод_сжатия = chdata.метод_сжатия;
        lhdata.crc_32 = chdata.crc_32;
        lhdata.сжатый_размер = chdata.сжатый_размер;
        lhdata.разжатый_размер = chdata.разжатый_размер;

        timeToDos(инфо.изменён, lhdata.время_изменения_файла,
                                 lhdata.дата_изменения_файла);

        put_local_header(lhdata, инфо.имя);

        // Store коммент
        записи[$-1].коммент = инфо.коммент;

        // Вывод файл contents
        {
            auto ввод = Запись.open_Необр;
            scope(exit) ввод.закрой;
            вывод.копируй(ввод).слей();
        }
    }

    проц put_compressed(ИнфоОЗаписиЗип инфо, ИПотокВвода источник)
    {
        debug(ZIP) Стдош.форматнс("ПисательБлокаЗип.put_compressed()");

        // Write out partial local файл заголовок
        auto header_pos = шагун.сместись(0, шагун.Якорь.Тек);
        debug(ZIP) Стдош.форматнс(" . заголовок for {} at {}", инфо.имя, header_pos);
        put_local_header(инфо, _method);

        // Store коммент
        записи[$-1].коммент = инфо.коммент;

        бцел crc;
        бцел сжатый_размер;
        бцел разжатый_размер;

        // Вывод файл contents
        {
            // Ввод/вывод chains
            ИПотокВвода in_chain = источник;
            ИПотокВывода out_chain = new WrapSeekOutputПоток(вывод);

            // Count число of байты coming in из_ the источник файл
            scope in_counter = new ВводСоСчётом(in_chain);
            in_chain = in_counter;
            assert( in_counter.счёт <= typeof(разжатый_размер).max );
            scope(success) разжатый_размер = cast(бцел) in_counter.счёт;

            // Count the число of байты going out в_ the архив
            scope out_counter = new ВыводСоСчётом(out_chain);
            out_chain = out_counter;
            assert( out_counter.счёт <= typeof(сжатый_размер).max );
            scope(success) сжатый_размер = cast(бцел) out_counter.счёт;

            // Добавь crc
            scope crc_d = new Crc32(/*CRC_MAGIC*/);
            scope crc_s = new ДайджестВвод(in_chain, crc_d);
            in_chain = crc_s;
            scope(success)
            {
                debug(ZIP) Стдош.форматнс(" . Success: storing CRC.");
                crc = crc_d.crc32Digest;
            }

            // Добавь compression
            ВыводЗлиб сожми;
            scope(exit) if( сожми !is пусто ) delete сожми;

            switch( _method )
            {
                case Метод.Store:
                    break;

                case Метод.Deflate:
                    сожми = new ВыводЗлиб(out_chain,
                            ВыводЗлиб.Уровень.init, ВыводЗлиб.Кодировка.Нет);
                    out_chain = сожми;
                    break;

                default:
                    assert(нет);
            }

            // все готово.
            scope(exit) in_chain.закрой();
            scope(success) in_chain.слей();
            scope(exit) out_chain.закрой();

            out_chain.копируй(in_chain).слей;

            debug(ZIP) if( сожми !is пусто )
            {
                Стдош.форматнс(" . compressed в_ {} байты", сожми.записано);
            }

            debug(ZIP) Стдош.форматнс(" . wrote {} байты", out_counter.счёт);
            debug(ZIP) Стдош.форматнс(" . contents записано");
        }

        debug(ZIP) Стдош.форматнс(" . CRC for \"{}\": 0x{:x8}", инфо.имя, crc);

        // Rewind, and patch the заголовок
        auto final_pos = шагун.сместись(0, шагун.Якорь.Тек);
        шагун.сместись(header_pos);
        patch_local_header(crc, сжатый_размер, разжатый_размер);

        // Seek back в_ the конец of the файл, and we're готово!
        шагун.сместись(final_pos);
    }

    /*
     * Patches the local файл заголовок starting at the current вывод location
     * with updated crc and размер information.  Also updates the current последний
     * Запись.
     */
    проц patch_local_header(бцел crc_32, бцел сжатый_размер,
            бцел разжатый_размер)
    {
        /* BUG: For some резон, this код won't компилируй.  No опрea why... if
         * you instantiate LFHD, it says that there is no "offsetof" property.
         */
        /+
        alias ДанныеЛокалФайлЗага LFHD;
        static assert( LFHD.сжатый_размер.offsetof
                == LFHD.crc_32.offsetof + 4 );
        static assert( LFHD.разжатый_размер.offsetof
                == LFHD.сжатый_размер.offsetof + 4 );
        +/

        // Don't forget we have в_ сместись past the сигнатура, too
        // BUG: .offsetof is broken here
        /+шагун.сместись(LFHD.crc_32.offsetof+4, шагун.Якорь.Тек);+/
        шагун.сместись(10+4, шагун.Якорь.Тек);
        пиши(вывод, crc_32);
        пиши(вывод, сжатый_размер);
        пиши(вывод, разжатый_размер);

        with( записи[$-1] )
        {
            данные.crc_32 = crc_32;
            данные.сжатый_размер = сжатый_размер;
            данные.разжатый_размер = разжатый_размер;
        }
    }

    /*
     * Generates and outputs a local файл заголовок из_ the given инфо block and
     * compression метод.  Note that the crc_32, сжатый_размер and
     * разжатый_размер заголовок fields will be установи в_ zero, and must be
     * patched.
     */
    проц put_local_header(ИнфоОЗаписиЗип инфо, Метод метод)
    {
        ЛокалФайлЗаг.Данные данные;

        данные.метод_сжатия = fromMethod(метод);
        timeToDos(инфо.изменён, данные.время_изменения_файла,
                                 данные.дата_изменения_файла);

        put_local_header(данные, инфо.имя);
    }

    /*
     * Writes the given local файл заголовок данные and имяф out в_ the вывод
     * поток.  It also appends a new Запись with the данные and имяф.
     */
    проц put_local_header(ДанныеЛокалФайлЗага данные,
            ткст имя_файла)
    {
        auto f_name = PathUtil.нормализуй(имя_файла);
        auto p = Путь.разбор(f_name);

        // Compute ZIP version
        if( данные.версия_извлечения == данные.версия_извлечения.max )
        {

            бкрат zИПver = 10;
            проц minver(бкрат v) { zИПver = v>zИПver ? v : zИПver; }

            {
                // Compression метод
                switch( данные.метод_сжатия )
                {
                    case 0: minver(10); break;
                    case 8: minver(20); break;
                    default:
                        assert(нет);
                }

                // Файл is a папка
                if( f_name.length > 0 && f_name[$-1] == '/' )
                    // Is a дир, not a реал файл
                    minver(20);
            }
            данные.версия_извлечения = zИПver;
        }

        /+// Encode имяф
        auto file_name_437 = utf8_to_cp437(имя_файла);
        if( file_name_437 is пусто )
            ИсклЗип.fnencode;+/

        /+// Набор up файл имя length
        if( file_name_437.length > бкрат.max )
            ИсклЗип.fntoolong;

        данные.длина_названия_файла = file_name_437.length;+/

        ЛокалФайлЗаг заголовок;
        заголовок.данные = данные;
        if (p.абс_ли)
            f_name = f_name[p.корень.length+1..$]; 
        заголовок.имя_файла = Путь.исконный(f_name);

        // Write out the заголовок and the имяф
        auto header_pos = шагун.сместись(0, шагун.Якорь.Тек);

        пиши(вывод, ЛокалФайлЗаг.сигнатура);
        заголовок.помести(вывод);

        // Save the заголовок
        assert( header_pos <= цел.max );
        Запись Запись;
        Запись.данные.fromLocal(заголовок.данные);
        Запись.имяф = заголовок.имя_файла;
        Запись.header_position = header_pos;
        Запись.данные.relative_offset_of_local_header = cast(цел) header_pos;
        записи ~= Запись;
    }
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
// ЗаписьЗип

/**
 * This class is used в_ represent a single Запись in an архив.
 * Specifically, it combines meta-данные about the файл (see the инфо field)
 * along with the two basic operations on an Запись: открой and проверь.
 */
class ЗаписьЗип
{
    /**
     * Header information on the файл.  See the ИнфоОЗаписиЗип structure for
     * ещё information.
     */
    ИнфоОЗаписиЗип инфо;

    /**
     * Size (in байты) of the файл's uncompressed contents.
     */
    бцел размер()
    {
        return заголовок.данные.разжатый_размер;
    }

    /**
     * Opens a поток for reading из_ the файл.  The contents of this поток
     * represent the decompressed contents of the файл stored in the архив.
     *
     * You should not assume that the returned поток is seekable.
     *
     * Note that the returned поток may be safely закрыт without affecting
     * the underlying архив поток.
     *
     * If the файл есть not yet been verified, then the поток will be checked
     * as you читай из_ it.  When the поток is either exhausted or закрыт,
     * then the integrity of the файл's данные will be checked.  This means that
     * if the файл is corrupt, an исключение will be thrown only after you have
     * завершено reading из_ the поток.  If you wish в_ сделай sure the данные is
     * valid before you читай из_ the файл, вызов the проверь метод.
     */
    ИПотокВвода открой()
    {
        // If we haven't verified yet, wrap the поток in the appropriate
        // decorators.
        if( !verified )
            return new СверщикЗаписиЗип(this, open_dg(заголовок, нет));

        else
            return open_dg(заголовок, нет);
    }

    /**
     * Verifies the contents of this файл by computing the CRC32 checksum,
     * and comparing it against the stored one.  Throws an исключение if the
     * checksums do not match.
     *
     * Not valid on поточно ZIP archives.
     */
    проц проверь()
    {
        // If we haven't verified the contents yet, just читай everything in
        // в_ trigger it.
        auto s = открой;
        auto буфер = new ббайт[s.провод.размерБуфера];
        while( s.читай(буфер) != s.Кф )
            {/*Do nothing*/}
        s.закрой;
    }

    /**
     * Creates a new, independent копируй of this экземпляр.
     */
    ЗаписьЗип dup()
    {
        return new ЗаписьЗип(заголовок, open_dg);
    }

private:
    /*
     * Callback used в_ открой the файл.
     */
    alias ИПотокВвода delegate(ФайлЗаг, бул необр) open_dg_t;
    open_dg_t open_dg;

    /*
     * Необр ZIP заголовок.
     */
    ФайлЗаг заголовок;

    /*
     * The flag used в_ keep track of whether the файл's contents have been
     * verified.
     */
    бул verified = нет;

    /*
     * Opens a поток that does not perform any decompression or
     * transformation of the файл contents.  This is used internally by
     * ПисательЗип в_ perform fast zИП в_ zИП transfers without having в_
     * decompress and then recompress the contents.
     *
     * Note that because zИП stores CRCs for the *uncompressed* данные, this
     * метод currently does not do any verification.
     */
    ИПотокВвода open_Необр()
    {
        return open_dg(заголовок, да);
    }

    /*
     * Creates a new ЗаписьЗип из_ the ФайлЗаг.
     */
    this(ФайлЗаг заголовок, open_dg_t open_dg)
    {
        this.сбрось(заголовок, open_dg);
    }

    /*
     * Resets the current экземпляр with new values.
     */
    ЗаписьЗип сбрось(ФайлЗаг заголовок, open_dg_t open_dg)
    {
        this.заголовок = заголовок;
        this.open_dg = open_dg;
        with( инфо )
        {
            имя = Путь.стандарт(заголовок.имя_файла.dup);
            dosToTime(заголовок.данные.время_изменения_файла,
                      заголовок.данные.дата_изменения_файла,
                      изменён);
            коммент = заголовок.комментарий_файла.dup;
        }

        this.verified = нет;

        return this;
    }
}

/**
 * This structure содержит various pieces of meta-данные on a файл.  The
 * contents of this structure may be safely mutated.
 *
 * This structure is also used в_ specify meta-данные about a файл when добавим
 * it в_ an архив.
 */
struct ИнфоОЗаписиЗип
{
    /// Full путь and файл имя of this файл.
    ткст имя;
    /// Modification timestamp.  If this is left uninitialised when passed в_
    /// a ПисательЗип, it will be сбрось в_ the current system время.
    Время изменён = Время.мин;
    /// Комментарий on the файл.
    ткст коммент;
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
// Exceptions
//

/**
 * This is the основа class из_ which все exceptions generated by this module
 * derive из_.
 */
class ИсклЗип : Исключение
{
    this(ткст сооб) { super(сооб); }

private:
    alias typeof(this) thisT;
    static проц opCall(ткст сооб) { throw new ИсклЗип(сооб); }

    static проц badsig()
    {
        thisT("обнаружена повреждённая сигнатура или неожидаемая секция");
    }

    static проц badsig(ткст тип)
    {
        thisT("У "~тип~" повреждена сигнатура или найдена неожидаемая секция");
    }

    static проц incons(ткст имя)
    {
        thisT("неожидаемые заголовки у файла \""~имя~"\"; "
                "архив, кажется, повреждён");
    }

    static проц missingdir()
    {
        thisT("не обнаружена центральная дир архива; "
                "файл повреждён или не является ZIP архивом");
    }

    static проц toomanyentries()
    {
        thisT("в архиве слишком много записей");
    }

    static проц toolong()
    {
        thisT("архив слишком длинный; он ограничен до 4GB вцелом");
    }

    static проц cdtoolong()
    {
        thisT("слишком длинная центральная дир; ограничение до 4GB вцелом");
    }

    static проц fntoolong()
    {
        thisT("имя файла слишком длинное; ограничение до 65,535 символов");
    }

    static проц eftoolong()
    {
        thisT("экстра поле слишком длинное; ограничение до 65,535 символов");
    }

    static проц cotoolong()
    {
        thisT("экстра поле слишком длинное; ограничение до 65,535 символов");
    }

    static проц fnencode()
    {
        thisT("не удаётся кодировать файл в кодовую страницу 437");
    }

    static проц coencode()
    {
        thisT("could not кодируй коммент преобр_в codepage 437");
    }

    static проц tooold()
    {
        thisT("не удаётся представить даты до 1 Января, 1980");
    }
}

/**
 * This исключение is thrown if a ЧитательЗип detects that a файл's contents do
 * not match the stored checksum.
 */
class ИсклКСЗип : ИсклЗип
{
    this(ткст имя)
    {
        super("неверна контрольная сумма записи ЗИП \""~имя~"\"");
    }

private:
    static проц opCall(ткст имя) { throw new ИсклКСЗип(имя); }
}

/**
 * This исключение is thrown if you вызов получи читатель метод when there are no
 * ещё файлы in the архив.
 */
class ZIPExhaustedException : ИсклЗип
{
    this() { super("no ещё записи in архив"); }

private:
    static проц opCall() { throw new ZIPExhaustedException; }
}

/**
 * This исключение is thrown if you attempt в_ читай an архив that uses
 * features not supported by the читатель.
 */
class ZIPNotSupportedException : ИсклЗип
{
    this(ткст сооб) { super(сооб); }

private:
    alias ZIPNotSupportedException thisT;

    static проц opCall(ткст сооб)
    {
        throw new thisT(сооб ~ " не поддерживается");
    }

    static проц spanned()
    {
        thisT("многодисковые и разделённые на части архивы");
    }

    static проц zИПver(бкрат ver)
    {
        throw new thisT("формат zИП  версии "
                ~Целое.вТкст(ver / 10)
                ~"."
                ~Целое.вТкст(ver % 10)
                ~" не поддерживается; максимально версия "
                ~Целое.вТкст(MAX_EXTRACT_VERSION / 10)
                ~"."
                ~Целое.вТкст(MAX_EXTRACT_VERSION % 10)
                ~" поддерживается.");
    }

    static проц флаги()
    {
        throw new thisT("применён неизвестный или неподдерживаемый флаг к файлу");
    }

    static проц метод(бкрат m)
    {
        // Cheat here and work out what the метод *actually* is
        ткст ms;
        switch( m )
        {
            case 0:
            case 8:     assert(нет); // supported

            case 1:     ms = "Shrink"; break;
            case 2:     ms = "Reduce (factor 1)"; break;
            case 3:     ms = "Reduce (factor 2)"; break;
            case 4:     ms = "Reduce (factor 3)"; break;
            case 5:     ms = "Reduce (factor 4)"; break;
            case 6:     ms = "Implode"; break;

            case 9:     ms = "Deflate64"; break;
            case 10:    ms = "TERSE (old)"; break;

            case 12:    ms = "BzИП2"; break;
            case 14:    ms = "LZMA"; break;

            case 18:    ms = "TERSE (new)"; break;
            case 19:    ms = "LZ77"; break;

            case 97:    ms = "WavPack"; break;
            case 98:    ms = "PPMd"; break;

            default:    ms = "неизвестно";
        }

        thisT(ms ~ " метод сжатия");
    }
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
// Convenience methods

проц создайАрхив(ткст архив, Метод метод, ткст[] файлы...)
{
    scope zw = new ПисательБлокаЗип(архив);
    zw.метод = метод;

    foreach( файл ; файлы )
        zw.поместиФайл(ИнфоОЗаписиЗип(файл), файл);

    zw.финиш;
}

проц извлекиАрхив(ткст архив, ткст приёмник)
{
    scope zr = new ЧитательБлокаЗип(архив);

    foreach( Запись ; zr )
    {
        // SkИП directories
        if( Запись.инфо.имя[$-1] == '/' ||
            Запись.инфо.имя[$-1] == '\\') continue;

        auto путь = Путь.объедини(приёмник, Запись.инфо.имя);
        путь = Путь.исконный(путь);
        scope fout = new Файл(путь, Файл.ЗапСозд);
        fout.копируй(Запись.открой);
    }
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
// Private implementation stuff
//

private:

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
// Verification stuff

/*
 * This class wraps an ввод поток, and computes the CRC as it проходки
 * through.  On the событие of either a закрой or EOF, it checks the CRC against
 * the one in the provопрed ЗаписьЗип.  If they don't match, it throws an
 * исключение.
 */

class СверщикЗаписиЗип : ИПотокВвода
{
    this(ЗаписьЗип Запись, ИПотокВвода источник)
    in
    {
        assert( Запись !is пусто );
        assert( источник !is пусто );
    }
    body
    {
        this.Запись = Запись;
        this.дайджест = new Crc32;
        this.источник = new ДайджестВвод(источник, дайджест);
    }

    ИПровод провод()
    {
        return источник.провод;
    }

    ИПотокВвода ввод()
    {
        return источник;
    }

    дол сместись (дол ofs, Якорь якорь = Якорь.Нач) 
    {
        return источник.сместись (ofs, якорь);
    }

    проц закрой()
    {
        check;

        this.источник.закрой;
        this.Запись = пусто;
        this.дайджест = пусто;
        this.источник = пусто;
    }

    т_мера читай(проц[] приёмн)
    {
        auto байты = источник.читай(приёмн);
        if( байты == ИПровод.Кф )
            check;
        return байты;
    }

    override проц[] загрузи(т_мера max=-1)
    {
        return Провод.загрузи(this, max);
    }
    
    override ИПотокВвода слей()
    {
        this.источник.слей;
        return this;
    }

private:
    Crc32 дайджест;
    ИПотокВвода источник;
    ЗаписьЗип Запись;

    проц check()
    {
        if( дайджест is пусто ) return;

        auto crc = дайджест.crc32Digest;
        delete дайджест;

        if( crc != Запись.заголовок.данные.crc_32 )
            ИсклКСЗип(Запись.инфо.имя);

        else
            Запись.verified = да;
    }
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
// IO functions

/*
 * Really, seriously, читай some байты without having в_ go through a sodding
 * буфер.
 */
проц читайРовно(ИПотокВвода s, проц[] приёмн)
{
    //Стдош.форматнс("читайРовно(s, [0..{}])", приёмн.length);
    while( приёмн.length > 0 )
    {
        auto octets = s.читай(приёмн);
        //Стдош.форматнс(" . octets = {}", octets);
        if( octets == -1 ) // Beware the dangers of MAGICAL THINKING
            throw new Исключение("unexpected конец of поток");
        приёмн = приёмн[octets..$];
    }
}

/*
 * Really, seriously, пиши some байты.
 */
проц пишиРовно(ИПотокВывода s, проц[] ист)
{
    while( ист.length > 0 )
    {
        auto octets = s.пиши(ист);
        if( octets == -1 )
            throw new Исключение("неожидаемый конец потока");
        ист = ист[octets..$];
    }
}

проц пиши(T)(ИПотокВывода s, T значение)
{
    version( БигЭндиан ) своп(значение);
    пишиРовно(s, (&значение)[0..1]);
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
// Endian garbage

проц свопВсе(T)(inout T данные)
{
    static if( is(typeof(T.record_fields)) )
        const fields = T.record_fields;
    else
        const fields = данные.tupleof.length;

    foreach( i,_ ; данные.tupleof )
    {
        if( i == fields ) break;
        своп(данные.tupleof[i]);
    }
}

проц своп(T)(inout T данные)
{
    static if( T.sizeof == 1 )
        {}
    else static if( T.sizeof == 2 )
        ПерестановкаБайт.своп16(&данные, 2);
    else static if( T.sizeof == 4 )
        ПерестановкаБайт.своп32(&данные, 4);
    else static if( T.sizeof == 8 )
        ПерестановкаБайт.своп64(&данные, 8);
    else static if( T.sizeof == 10 )
        ПерестановкаБайт.своп80(&данные, 10);
    else
        static assert(нет, "Can't своп "~T.stringof~"s.");
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
// IBM Code Page 437 stuff
//

const ткст[] cp437_to_utf8_map_low = [
    "\u0000"[], "\u263a",   "\u263b",   "\u2665",
    "\u2666",   "\u2663",   "\u2660",   "\u2022",
    "\u25d8",   "\u25cb",   "\u25d9",   "\u2642",
    "\u2640",   "\u266a",   "\u266b",   "\u263c",

    "\u25b6",   "\u25c0",   "\u2195",   "\u203c",
    "\u00b6",   "\u00a7",   "\u25ac",   "\u21a8",
    "\u2191",   "\u2193",   "\u2192",   "\u2190",
    "\u221f",   "\u2194",   "\u25b2",   "\u25bc"
];

const ткст[] cp437_to_utf8_map_high = [
    "\u00c7"[], "\u00fc",   "\u00e9",   "\u00e2",
    "\u00e4",   "\u00e0",   "\u00e5",   "\u00e7",
    "\u00ea",   "\u00eb",   "\u00e8",   "\u00ef",
    "\u00ee",   "\u00ec",   "\u00c4",   "\u00c5",

    "\u00c9",   "\u00e6",   "\u00c6",   "\u00f4",
    "\u00f6",   "\u00f2",   "\u00fb",   "\u00f9",
    "\u00ff",   "\u00d6",   "\u00dc",   "\u00f8",
    "\u00a3",   "\u00a5",   "\u20a7",   "\u0192",

    "\u00e1",   "\u00ed",   "\u00f3",   "\u00fa",
    "\u00f1",   "\u00d1",   "\u00aa",   "\u00ba",
    "\u00bf",   "\u2310",   "\u00ac",   "\u00bd",
    "\u00bc",   "\u00a1",   "\u00ab",   "\u00bb",

    "\u2591",   "\u2592",   "\u2593",   "\u2502",
    "\u2524",   "\u2561",   "\u2562",   "\u2556",
    "\u2555",   "\u2563",   "\u2551",   "\u2557",
    "\u255d",   "\u255c",   "\u255b",   "\u2510",

    "\u2514",   "\u2534",   "\u252c",   "\u251c",
    "\u2500",   "\u253c",   "\u255e",   "\u255f",
    "\u255a",   "\u2554",   "\u2569",   "\u2566",
    "\u2560",   "\u2550",   "\u256c",   "\u2567",

    "\u2568",   "\u2564",   "\u2565",   "\u2559",
    "\u2558",   "\u2552",   "\u2553",   "\u256b",
    "\u256a",   "\u2518",   "\u250c",   "\u2588",
    "\u2584",   "\u258c",   "\u2590",   "\u2580",
    "\u03b1",   "\u00df",   "\u0393",   "\u03c0",
    "\u03a3",   "\u03c3",   "\u00b5",   "\u03c4",
    "\u03a6",   "\u0398",   "\u03a9",   "\u03b4",
    "\u221e",   "\u03c6",   "\u03b5",   "\u2229",

    "\u2261",   "\u00b1",   "\u2265",   "\u2264",
    "\u2320",   "\u2321",   "\u00f7",   "\u2248",
    "\u00b0",   "\u2219",   "\u00b7",   "\u221a",
    "\u207f",   "\u00b2",   "\u25a0",   "\u00a0"
];

ткст кс437_в_утф8(ббайт[] s)
{
    foreach( i,c ; s )
    {
        if( (1 <= c && c <= 31) || c >= 127 )
        {
            /* Damn; we got a character not in ASCII.  Since this is the first
             * non-ASCII character we найдено, копируй everything up в_ this точка
             * преобр_в the вывод verbatim.  We'll размести twice as much пространство
             * as there are remaining characters в_ ensure we don't need в_ do
             * any further allocations.
             */
            auto r = new сим[i+2*(s.length-i)];
            r[0..i] = cast(ткст) s[0..i];
            т_мера k=i; // current length

            // We вставь new characters at r[i+j+k]

            foreach( d ; s[i..$] )
            {
                if( 32 <= d && d <= 126 || d == 0 )
                {
                    r[k++] = d;
                }
                else if( 1 <= d && d <= 31 )
                {
                    ткст repl = cp437_to_utf8_map_low[d];
                    r[k..k+repl.length] = repl[];
                    k += repl.length;
                }
                else if( d == 127 )
                {
                    ткст repl = "\u2302";
                    r[k..k+repl.length] = repl[];
                    k += repl.length;
                }
                else if( d > 127 )
                {
                    ткст repl = cp437_to_utf8_map_high[d-128];
                    r[k..k+repl.length] = repl[];
                    k += repl.length;
                }
                else
                    assert(нет);
            }

            return r[0..k];
        }
    }

    /* If we got here, then все the characters in s are also in ASCII, which
     * means it's also valid UTF-8; return the ткст unmodified.
     */
    return cast(ткст) s;
}

debug( UnitTest )
{
    unittest
    {
        ткст c(ткст s) { return кс437_в_утф8(cast(ббайт[]) s); }

        auto s = c("Hi there \x01 old \x0c!");
        assert( s == "Hi there \u263a old \u2640!", "\""~s~"\"" );
        s = c("Marker \x7f and divопрe \xf6.");
        assert( s == "Marker \u2302 and divide \u00f7.", "\""~s~"\"" );
    }
}

const сим[дим] utf8_to_cp437_map;

static this()
{
    utf8_to_cp437_map = [
        '\u0000': '\x00', '\u263a': '\x01', '\u263b': '\x02', '\u2665': '\x03',
        '\u2666': '\x04', '\u2663': '\x05', '\u2660': '\x06', '\u2022': '\x07',
        '\u25d8': '\x08', '\u25cb': '\x09', '\u25d9': '\x0a', '\u2642': '\x0b',
        '\u2640': '\x0c', '\u266a': '\x0d', '\u266b': '\x0e', '\u263c': '\x0f',

        '\u25b6': '\x10', '\u25c0': '\x11', '\u2195': '\x12', '\u203c': '\x13',
        '\u00b6': '\x14', '\u00a7': '\x15', '\u25ac': '\x16', '\u21a8': '\x17',
        '\u2191': '\x18', '\u2193': '\x19', '\u2192': '\x1a', '\u2190': '\x1b',
        '\u221f': '\x1c', '\u2194': '\x1d', '\u25b2': '\x1e', '\u25bc': '\x1f',

        /*
         * Printable ASCII range (well, most of it) is handled specially.
         */

        '\u00c7': '\x80', '\u00fc': '\x81', '\u00e9': '\x82', '\u00e2': '\x83',
        '\u00e4': '\x84', '\u00e0': '\x85', '\u00e5': '\x86', '\u00e7': '\x87',
        '\u00ea': '\x88', '\u00eb': '\x89', '\u00e8': '\x8a', '\u00ef': '\x8b',
        '\u00ee': '\x8c', '\u00ec': '\x8d', '\u00c4': '\x8e', '\u00c5': '\x8f',

        '\u00c9': '\x90', '\u00e6': '\x91', '\u00c6': '\x92', '\u00f4': '\x93',
        '\u00f6': '\x94', '\u00f2': '\x95', '\u00fb': '\x96', '\u00f9': '\x97',
        '\u00ff': '\x98', '\u00d6': '\x99', '\u00dc': '\x9a', '\u00f8': '\x9b',
        '\u00a3': '\x9c', '\u00a5': '\x9d', '\u20a7': '\x9e', '\u0192': '\x9f',

        '\u00e1': '\xa0', '\u00ed': '\xa1', '\u00f3': '\xa2', '\u00fa': '\xa3',
        '\u00f1': '\xa4', '\u00d1': '\xa5', '\u00aa': '\xa6', '\u00ba': '\xa7',
        '\u00bf': '\xa8', '\u2310': '\xa9', '\u00ac': '\xaa', '\u00bd': '\xab',
        '\u00bc': '\xac', '\u00a1': '\xad', '\u00ab': '\xae', '\u00bb': '\xaf',

        '\u2591': '\xb0', '\u2592': '\xb1', '\u2593': '\xb2', '\u2502': '\xb3',
        '\u2524': '\xb4', '\u2561': '\xb5', '\u2562': '\xb6', '\u2556': '\xb7',
        '\u2555': '\xb8', '\u2563': '\xb9', '\u2551': '\xba', '\u2557': '\xbb',
        '\u255d': '\xbc', '\u255c': '\xbd', '\u255b': '\xbe', '\u2510': '\xbf',

        '\u2514': '\xc0', '\u2534': '\xc1', '\u252c': '\xc2', '\u251c': '\xc3',
        '\u2500': '\xc4', '\u253c': '\xc5', '\u255e': '\xc6', '\u255f': '\xc7',
        '\u255a': '\xc8', '\u2554': '\xc9', '\u2569': '\xca', '\u2566': '\xcb',
        '\u2560': '\xcc', '\u2550': '\xcd', '\u256c': '\xce', '\u2567': '\xcf',

        '\u2568': '\xd0', '\u2564': '\xd1', '\u2565': '\xd2', '\u2559': '\xd3',
        '\u2558': '\xd4', '\u2552': '\xd5', '\u2553': '\xd6', '\u256b': '\xd7',
        '\u256a': '\xd8', '\u2518': '\xd9', '\u250c': '\xda', '\u2588': '\xdb',
        '\u2584': '\xdc', '\u258c': '\xdd', '\u2590': '\xde', '\u2580': '\xdf',

        '\u03b1': '\xe0', '\u00df': '\xe1', '\u0393': '\xe2', '\u03c0': '\xe3',
        '\u03a3': '\xe4', '\u03c3': '\xe5', '\u00b5': '\xe6', '\u03c4': '\xe7',
        '\u03a6': '\xe8', '\u0398': '\xe9', '\u03a9': '\xea', '\u03b4': '\xeb',
        '\u221e': '\xec', '\u03c6': '\xed', '\u03b5': '\xee', '\u2229': '\xef',

        '\u2261': '\xf0', '\u00b1': '\xf1', '\u2265': '\xf2', '\u2264': '\xf3',
        '\u2320': '\xf4', '\u2321': '\xf5', '\u00f7': '\xf6', '\u2248': '\xf7',
        '\u00b0': '\xf8', '\u2219': '\xf9', '\u00b7': '\xfa', '\u221a': '\xfb',
        '\u207f': '\xfc', '\u00b2': '\xfd', '\u25a0': '\xfe', '\u00a0': '\xff'
    ];
}

ббайт[] utf8_to_cp437(ткст s)
{
    foreach( i,дим c ; s )
    {
        if( !((32 <= c && c <= 126) || c == 0) )
        {
            /* We got a character not in CP 437: we need в_ создай a буфер в_
             * hold the new ткст.  Since UTF-8 is *always* larger than CP
             * 437, we need, at most, an Массив of the same число of elements.
             */
            auto r = new ббайт[s.length];
            r[0..i] = cast(ббайт[]) s[0..i];
            т_мера k=i;

            foreach( дим d ; s[i..$] )
            {
                if( 32 <= d && d <= 126 || d == 0 )
                    r[k++] = d;

                else if( d == '\u2302' )
                    r[k++] = '\x7f';

                else if( auto e_ptr = d in utf8_to_cp437_map )
                    r[k++] = *e_ptr;

                else
                {
                    throw new Исключение("не удаётся кодировать символ \""
                            ~ Целое.вТкст(cast(бцел)d)
                            ~ "\" в кодовой странице 437.");
                }
            }

            return r[0..k];
        }
    }

    // If we got here, then the entire ткст is printable ASCII, which just
    // happens в_ *also* be valid CP 437!  Huzzah!
    return cast(ббайт[]) s;
}

debug( UnitTest )
{
    unittest
    {
        alias кс437_в_утф8 x;
        alias utf8_to_cp437 y;

        ббайт[256] s;
        foreach( i,ref c ; s )
            c = i;

        auto a = x(s);
        auto b = y(a);
        if(!( b == s ))
        {
            // Display список of characters that неудачно в_ преобразуй as ожидалось,
            // and what значение we got.
            auto hex = "0123456789abcdef";
            auto сооб = "".dup;
            foreach( i,ch ; b )
            {
                if( ch != i )
                {
                    сооб ~= hex[i>>4];
                    сооб ~= hex[i&15];
                    сооб ~= " (";
                    сооб ~= hex[ch>>4];
                    сооб ~= hex[ch&15];
                    сооб ~= "), ";
                }
            }
            сооб ~= "полный провал.";

            assert( нет, сооб );
        }
    }
}

/*
 * This is here в_ simplify the код elsewhere.
 */
ткст utf8_to_utf8(ббайт[] s) { return cast(ткст) s; }
ббайт[] utf8_to_utf8(ткст s) { return cast(ббайт[]) s; }

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
// Date/время stuff

проц dosToTime(бкрат dostime, бкрат dosdate, out Время время)
{
    бцел sec, min, час, день, mon, год;
    sec = (dostime & 0b00000_000000_11111) * 2;
    min = (dostime & 0b00000_111111_00000) >> 5;
    час= (dostime & 0b11111_000000_00000) >> 11;
    день = (dosdate & 0b0000000_0000_11111);
    mon = (dosdate & 0b0000000_1111_00000) >> 5;
    год=((dosdate & 0b1111111_0000_00000) >> 9) + 1980;

    // This код rules!
    время = Грегориан.генерный.воВремя(год, mon, день, час, min, sec);
}

проц timeToDos(Время время, out бкрат dostime, out бкрат dosdate)
{
    // Treat Время.min specially
    if( время == Время.мин )
        время = Куранты.сейчас;

    // *muttering happily*
    auto дата = Грегориан.генерный.вДату(время);
    if( дата.год < 1980 )
        ИсклЗип.tooold;

    auto tod = время.время();
    dostime = cast(бкрат) (
        (tod.сек / 2)
      | (tod.минуты << 5)
      | (tod.часы   << 11));

    dosdate = cast(бкрат) (
        (дата.день)
      | (дата.месяц << 5)
      | ((дата.год - 1980) << 9));
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

//module tangox.io.поток.CounterПоток;

//import io.device.Conduit : Провод;
//import io.model : ИПровод, ИПотокВвода, ИПотокВывода;

/**
 * The counter поток classes are used в_ keep track of как many байты flow
 * through a поток.
 *
 * To use them, simply wrap it around an existing поток.  The число of байты
 * that have flowed through the wrapped поток may be использовался using the
 * счёт member.
 */
class ВводСоСчётом : ИПотокВвода
{
    ///
    this(ИПотокВвода ввод)
    in
    {
        assert( ввод !is пусто );
    }
    body
    {
        this.источник = ввод;
    }

    override ИПровод провод()
    {
        return источник.провод;
    }

    ИПотокВвода ввод()
    {
        return источник;
    }

    дол сместись (дол ofs, Якорь якорь = Якорь.Нач) 
    {
        return источник.сместись (ofs, якорь);
    }

    override проц закрой()
    {
        источник.закрой();
        источник = пусто;
    }

    override т_мера читай(проц[] приёмн)
    {
        auto читай = источник.читай(приёмн);
        if( читай != ИПровод.Кф )
            _count += читай;
        return читай;
    }

    override проц[] загрузи(т_мера max=-1)
    {
        return Провод.загрузи(this, max);
    }

    override ИПотокВвода слей()
    {
        источник.слей();
        return this;
    }

    ///
    дол счёт() { return _count; }

private:
    ИПотокВвода источник;
    дол _count;
}

/// ditto
class ВыводСоСчётом : ИПотокВывода
{
    ///
    this(ИПотокВывода вывод)
    in
    {
        assert( вывод !is пусто );
    }
    body
    {
        this.сток = вывод;
    }

    override ИПровод провод()
    {
        return сток.провод;
    }

    ИПотокВывода вывод()
    {
        return сток;
    }

    дол сместись (дол ofs, Якорь якорь = Якорь.Нач) 
    {
        return сток.сместись (ofs, якорь);
    }

    override проц закрой()
    {
        сток.закрой();
        сток = пусто;
    }

    override т_мера пиши(проц[] приёмн)
    {
        auto wrote = сток.пиши(приёмн);
        if( wrote != ИПровод.Кф )
            _count += wrote;
        return wrote;
    }

    override ИПотокВывода копируй(ИПотокВвода ист, т_мера max=-1)
    {
        Провод.перемести(ист, this, max);
        return this;
    }

    override ИПотокВывода слей()
    {
        сток.слей();
        return this;
    }

  ///
    дол счёт() { return _count; }

private:
    ИПотокВывода сток;
    дол _count;
}

/*******************************************************************************

    copyright:  Copyright © 2007 Daniel Keep.  все rights reserved.

    license:    BSD стиль: $(LICENSE)

    version:    Prerelease

    author:     Daniel Keep

*******************************************************************************/

//module tangox.io.поток.SliceПоток;

//import io.device.Conduit : Провод;
//import io.model : ИПровод, ИПотокВвода, ИПотокВывода;

/**
 * This поток can be used в_ provопрe поток-based access в_ a поднабор of
 * другой поток.  It is akin в_ slicing an Массив.
 *
 * This поток fully supports seeking, and as such requires that the
 * underlying поток also support seeking.
 */
class SliceSeekInputПоток : ИПотокВвода
{
    //alias ИПровод.ИШаг.Якорь Якорь;

    /**
     * Create a new срез поток из_ the given источник, covering the контент
     * starting at позиция begin, for length байты.
     */
    this(ИПотокВвода источник, дол begin, дол length)
    in
    {
        assert( источник !is пусто );
        assert( (cast(ИПровод.ИШаг) источник.провод) !is пусто );
        assert( begin >= 0 );
        assert( length >= 0 );
    }
    body
    {
        this.источник = источник;
        this.шагун = источник; //cast(ИПровод.ИШаг) источник;
        this.begin = begin;
        this.length = length;
    }

    override ИПровод провод()
    {
        return источник.провод;
    }

    override проц закрой()
    {
        источник = пусто;
        шагун = пусто;
    }

    override т_мера читай(проц[] приёмн)
    {
        // If we're at the конец of the срез, return eof
        if( _position >= length )
            return ИПровод.Кф;

        // Otherwise, сделай sure we don't try в_ читай past the конец of the срез
        if( _position+приёмн.length > length )
            приёмн.length = cast(т_мера) (length-_position);

        // Seek источник поток в_ the appropriate location.
        if( шагун.сместись(0, Якорь.Тек) != begin+_position )
            шагун.сместись(begin+_position, Якорь.Нач);

        // Do the читай
        auto читай = источник.читай(приёмн);
        if( читай == ИПровод.Кф )
            // If we got an Кф, we'll consider that a bug for the moment.
            // TODO: proper исключение
            throw new Исключение("неожиданный конец потока");

        _position += читай;
        return читай;
    }

    override проц[] загрузи(т_мера max=-1)
    {
        return Провод.загрузи(this, max);
    }

    override ИПотокВвода слей()
    {
        источник.слей();
        return this;
    }

    ИПотокВвода ввод()
    {
        return источник;
    }

    override дол сместись(дол смещение, Якорь якорь = cast(Якорь)0)
    {
        switch( якорь )
        {
            case Якорь.Нач:
                _position = смещение;
                break;

            case Якорь.Тек:
                _position += смещение;
                if( _position < 0 ) _position = 0;
                break;

            case Якорь.Кон:
                _position = length+смещение;
                if( _position < 0 ) _position = 0;
                break;

            default:
                assert(нет);
        }

        return _position;
    }

private:
    ИПотокВвода источник;
    ИПотокВвода шагун;

    дол _position, begin, length;

    invariant
    {
        assert( cast(Объект) источник is cast(Объект) шагун );
        assert( begin >= 0 );
        assert( length >= 0 );
        assert( _position >= 0 );
    }
}

/**
 * This поток can be used в_ provопрe поток-based access в_ a поднабор of
 * другой поток.  It is akin в_ slicing an Массив.
 */
class SliceInputПоток : ИПотокВвода
{
    /**
     * Create a new срез поток из_ the given источник, covering the контент
     * starting at the current сместись позиция for length байты.
     */
    this(ИПотокВвода источник, дол length)
    in
    {
        assert( источник !is пусто );
        assert( length >= 0 );
    }
    body
    {
        this.источник = источник;
        this._length = length;
    }

    override ИПровод провод()
    {
        return источник.провод;
    }

    override проц закрой()
    {
        источник = пусто;
    }

    ИПотокВвода ввод()
    {
        return источник;
    }

    дол сместись (дол ofs, Якорь якорь = Якорь.Нач) 
    {
        return источник.сместись (ofs, якорь);
    }

    override т_мера читай(проц[] приёмн)
    {
        // If we're at the конец of the срез, return eof
        if( _length <= 0 )
            return ИПровод.Кф;

        // Otherwise, сделай sure we don't try в_ читай past the конец of the срез
        if( приёмн.length > _length )
            приёмн.length = cast(т_мера) _length;

        // Do the читай
        auto читай = источник.читай(приёмн);
        if( читай == ИПровод.Кф )
            // If we got an Кф, we'll consider that a bug for the moment.
            // TODO: proper исключение
            throw new Исключение("неожиданный конец потока");

        _length -= читай;
        return читай;
    }

    override проц[] загрузи(т_мера max=-1)
    {
        return Провод.загрузи(this, max);
    }

    override ИПотокВвода слей()
    {
        источник.слей();
        return this;
    }

private:
    ИПотокВвода источник;
    дол _length;

    invariant
    {
        if( _length > 0 ) assert( источник !is пусто );
    }
}

/**
 * This поток can be used в_ provопрe поток-based access в_ a поднабор of
 * другой поток.  It is akin в_ slicing an Массив.
 *
 * This поток fully supports seeking, and as such requires that the
 * underlying поток also support seeking.
 */
class SliceSeekOutputПоток : ИПотокВывода
{
    //alias ИПровод.ИШаг.Якорь Якорь;

    /**
     * Create a new срез поток из_ the given источник, covering the контент
     * starting at позиция begin, for length байты.
     */
    this(ИПотокВывода источник, дол begin, дол length)
    in
    {
        assert( (cast(ИПровод.ИШаг) источник.провод) !is пусто );
        assert( begin >= 0 );
        assert( length >= 0 );
    }
    body
    {
        this.источник = источник;
        this.шагун = источник; //cast(ИПровод.ИШаг) источник;
        this.begin = begin;
        this.length = length;
    }

    override ИПровод провод()
    {
        return источник.провод;
    }

    override проц закрой()
    {
        источник = пусто;
        шагун = пусто;
    }

    т_мера пиши(проц[] ист)
    {
        // If we're at the конец of the срез, return eof
        if( _position >= length )
            return ИПровод.Кф;

        // Otherwise, сделай sure we don't try в_ пиши past the конец of the
        // срез
        if( _position+ист.length > length )
            ист.length = cast(т_мера) (length-_position);

        // Seek источник поток в_ the appropriate location.
        if( шагун.сместись(0, Якорь.Тек) != begin+_position )
            шагун.сместись(begin+_position, Якорь.Нач);

        // Do the пиши
        auto wrote = источник.пиши(ист);
        if( wrote == ИПровод.Кф )
            // If we got an Кф, we'll consider that a bug for the moment.
            // TODO: proper исключение
            throw new Исключение("неожиданный конец потока");

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

    override ИПотокВывода вывод()
    {
        return источник;
    }

    override дол сместись(дол смещение, Якорь якорь = cast(Якорь)0)
    {
        switch( якорь )
        {
            case Якорь.Нач:
                _position = смещение;
                break;

            case Якорь.Тек:
                _position += смещение;
                if( _position < 0 ) _position = 0;
                break;

            case Якорь.Кон:
                _position = length+смещение;
                if( _position < 0 ) _position = 0;
                break;

            default:
                assert(нет);
        }

        return _position;
    }

private:
    ИПотокВывода источник;
    ИПотокВывода шагун;

    дол _position, begin, length;

    invariant
    {
        assert( cast(Объект) источник is cast(Объект) шагун );
        assert( begin >= 0 );
        assert( length >= 0 );
        assert( _position >= 0 );
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
class WrapSeekInputПоток : ИПотокВвода
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

    override проц[] загрузи(т_мера max=-1)
    {
        return Провод.загрузи(this, max);
    }

    override ИПотокВвода слей()
    {
        источник.слей();
        return this;
    }

    ИПотокВвода ввод()
    {
        return источник;
    }

    override дол сместись(дол смещение, Якорь якорь = cast(Якорь)0)
    {
        шагун.сместись(_position, Якорь.Нач);
        return (_position = шагун.сместись(смещение, якорь));
    }

private:
    ИПотокВвода источник;
    ИПотокВвода шагун;
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
class WrapSeekOutputПоток : ИПотокВывода
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

    override ИПотокВывода вывод()
    {
        return источник;
    }

    override дол сместись(дол смещение, Якорь якорь = cast(Якорь)0)
    {
        шагун.сместись(_position, Якорь.Нач);
        return (_position = шагун.сместись(смещение, якорь));
    }

private:
    ИПотокВывода источник;
    ИПотокВывода шагун;
    дол _position;

    invariant
    {
        assert( cast(Объект) источник is cast(Объект) шагун );
        assert( _position >= 0 );
    }
}


