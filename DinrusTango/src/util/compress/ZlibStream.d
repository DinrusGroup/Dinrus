/*******************************************************************************

    copyright:  Copyright (C) 2007 Daniel Keep.  все rights reserved.

    license:    BSD стиль: $(LICENSE)

    author:     Daniel Keep

    version:    Feb 08: добавьed support for different поток encodings, removed
                        old "window биты" ctors.
                        
                Dec 07: добавьed support for "window биты", needed for ZIP support.
                
                Jul 07: Initial release.

*******************************************************************************/

module util.compress.ZlibStream;

private import lib.zlib;

private import stringz : изТкст0;

private import exception : ВВИскл;

private import io.device.Conduit : ФильтрВвода, ФильтрВывода;

private import io.model : ИПотокВвода, ИПотокВывода, ИПровод;

private import text.convert.Integer : вТкст;


/* This constant controls the размер of the ввод/вывод buffers we use
 * internally.  This should be a fairly sane значение (it's suggested by the zlib
 * documentation), that should only need changing for память-constrained
 * platforms/use cases.
 *
 * An alternative would be в_ сделай the chunk размер a template parameter в_ the
 * filters themselves, but Dinrus already есть ещё than enough template
 * параметры getting in the way :)
 */

private enum { РАЗМЕР_ЧАНКА = 256 * 1024 };

/* This constant specifies the default окноБиты значение.  This is taken из_
 * documentation in zlib.h.  It shouldn't break anything if zlib changes в_
 * a different default.
 */

private enum { ОКНОБИТЫ_ДЕФОЛТ = 15 };

/*******************************************************************************
  
    This ввод фильтр can be used в_ perform decompression of zlib Потокs.

*******************************************************************************/

class ВводЗлиб : ФильтрВвода
{
    /***************************************************************************
    
        This enumeration allows you в_ specify the кодировка of the compressed
        поток.
    
    ***************************************************************************/

    enum Кодировка : цел
    {
        /**
         *  The код should attempt в_ automatically determine what the кодировка
         *  of the поток should be.  Note that this cannot detect the case
         *  where the поток was compressed with no кодировка.
         */
        Guess,
        /**
         *  Поток есть zlib кодировка.
         */
        Zlib,
        /**
         *  Поток есть gzip кодировка.
         */
        Gzip,
        /**
         *  Поток есть no кодировка.
         */
        Нет
    }

    private
    {
        /* Used в_ сделай sure we don't try в_ perform operations on a dead
         * поток. */
        бул zs_valid = нет;

        z_stream zs;
        ббайт[] in_chunk;
    }
    
    /***************************************************************************

        Constructs a new zlib decompression фильтр.  You need в_ пароль in the
        поток that the decompression фильтр will читай из_.  If you are using
        this фильтр with a провод, the опрiom в_ use is:

        ---
        auto ввод = new ВводЗлиб(myConduit.ввод));
        ввод.читай(myContent);
        ---

        The optional окноБиты parameter is the основа two logarithm of the
        window размер, and should be in the range 8-15, defaulting в_ 15 if not
        specified.  добавьitionally, the окноБиты parameter may be негатив в_
        indicate that zlib should omit the стандарт zlib заголовок and trailer,
        with the window размер being -окноБиты.
        
      Параметры:
        поток = compressed ввод поток.
        
        кодировка =
            поток кодировка.  Defaults в_ Кодировка.Guess, which
            should be sufficient unless the поток was compressed with
            no кодировка; in this case, you must manually specify
            Кодировка.Нет.
            
        окноБиты =
            the основа two logarithm of the window размер, and should be in the
            range 8-15, defaulting в_ 15 if not specified.

    ***************************************************************************/

    this(ИПотокВвода поток, Кодировка кодировка,
            цел окноБиты = ОКНОБИТЫ_ДЕФОЛТ)
    {
        /*
         * Here's как окноБиты works, according в_ zlib.h:
         * 
         * 8 .. 15
         *      zlib кодировка.
         *      
         * (8 .. 15) + 16
         *      gzip кодировка.
         *      
         * (8 .. 15) + 32
         *      auto-detect кодировка.
         *      
         * (8 .. 15) * -1
         *      необр/no кодировка.
         *      
         * Since we're going в_ be playing with the значение, we DO care whether
         * окноБиты is in the ожидалось range, so we'll check it.
         */
        if( !( 8 <= окноБиты && окноБиты <= 15 ) )
        {
            // No compression for you!
            throw new ИсклЗлиб("непригодный аргумент окноБиты"
                ~ .вТкст(окноБиты));
        }
        
        switch( кодировка )
        {
        case Кодировка.Zlib:
            // no-op
            break;
            
        case Кодировка.Gzip:
            окноБиты += 16;
            break;

        case Кодировка.Guess:
            окноБиты += 32;
            break;
            
        case Кодировка.Нет:
            окноБиты *= -1;
            break;
        }
        
        super (поток);
        in_chunk = new ббайт[РАЗМЕР_ЧАНКА];

        // Размести inflate состояние
        with( zs )
        {
            zalloc = пусто;
            zfree = пусто;
            opaque = пусто;
            avail_in = 0;
            next_in = пусто;
        }

        auto возвр = inflateInit2(&zs, окноБиты);
        if( возвр != Z_OK )
            throw new ИсклЗлиб(возвр);

        zs_valid = да;
    }
    
    /// ditto
    this(ИПотокВвода поток)
    {
        // DRK 2009-02-26
        // Removed unique implementation in favour of passing on в_ другой
        // constructor.  The specific implementation was because the default
        // значение of окноБиты is documented in zlib.h, but not actually
        // exposed.  Using inflateInit over inflateInit2 ensured we would
        // never получи it wrong.  That saопр, the default значение of 15 is REALLY
        // unlikely в_ change: values below that aren't terribly useful, and
        // values higher than 15 are already used for другой purposes.
        // Also, this leads в_ less код which is always good.  :D
        this(поток, Кодировка.init);
    }
    
    ~this()
    {
        if( zs_valid )
            туши_зп();
    }

    /***************************************************************************

        Decompresses данные из_ the underlying провод преобр_в a мишень Массив.

        Returns the число of байты stored преобр_в приёмн, which may be less than
        requested.

    ***************************************************************************/ 

    override т_мера читай(проц[] приёмн)
    {
        if( !zs_valid )
            return ИПровод.Кф;

        // Check в_ see if we've run out of ввод данные.  If we have, получи some
        // ещё.
        if( zs.avail_in == 0 )
        {
            auto длин = источник.читай(in_chunk);
            if( длин == ИПровод.Кф )
                return ИПровод.Кф;

            zs.avail_in = длин;
            zs.next_in = in_chunk.ptr;
        }

        // We'll tell zlib в_ inflate straight преобр_в the мишень Массив.
        zs.avail_out = приёмн.length;
        zs.next_out = cast(ббайт*)приёмн.ptr;
        auto возвр = inflate(&zs, Z_NO_FLUSH);

        switch( возвр )
        {
            case Z_NEED_DICT:
                // Whilst not technically an ошибка, this should never happen
                // for general-use код, so treat it as an ошибка.
            case Z_DATA_ERROR:
            case Z_MEM_ERROR:
                туши_зп();
                throw new ИсклЗлиб(возвр);

            case Z_STREAM_END:
                // zlib поток is завершено; затуши the поток so we don't try в_
                // читай из_ it again.
                туши_зп();
                break;

            default:
        }

        return приёмн.length - zs.avail_out;
    }

    /***************************************************************************

        Clear any buffered контент.  No-op.

    ***************************************************************************/ 

    override ИПотокВвода слей()
    {
        проверьГожесть();

        // TODO: What should this метод do?  We don't do any куча allocation,
        // so there's really nothing в_ сотри...  For сейчас, just invalidate the
        // поток...
        туши_зп();

        super.слей();
        return this;
    }

    // This function kills the поток: it deallocates the internal состояние, and
    // unsets the zs_valid flag.
    private проц туши_зп()
    {
        проверьГожесть();

        inflateEnd(&zs);
        zs_valid = нет;
    }

    // Asserts that the поток is still valid and usable (except that this
    // check doesn't получи elопрed with -release).
    private проц проверьГожесть()
    {
        if( !zs_valid )
            throw new ИсклЗлибЗакрыт;
    }
}

/*******************************************************************************
  
    This вывод фильтр can be used в_ perform compression of данные преобр_в a zlib
    поток.

*******************************************************************************/

class ВыводЗлиб : ФильтрВывода
{
    /***************************************************************************

        This enumeration represents several pre-defined compression levels.

        Any целое between -1 and 9 включительно may be used as a уровень,
        although the symbols in this enumeration should suffice for most
        use-cases.

    ***************************************************************************/

    enum Уровень : цел
    {
        /**
         * Default compression уровень.  This is selected for a good compromise
         * between скорость and compression, and the exact compression уровень is
         * determined by the underlying zlib library.  Should be roughly
         * equivalent в_ compression уровень 6.
         */
        Нормальный = -1,
        /**
         * Do not perform compression.  This will cause the поток в_ расширь
         * slightly в_ accommodate поток metadata.
         */
        Нет = 0,
        /**
         * Minimal compression; the fastest уровень which performs at least
         * some compression.
         */
        Быстрый = 1,
        /**
         * Maximal compression.
         */
        Наилучший = 9
    }

    /***************************************************************************
    
        This enumeration allows you в_ specify what the кодировка of the
        compressed поток should be.
    
    ***************************************************************************/

    enum Кодировка : цел
    {
        /**
         *  Поток should use zlib кодировка.
         */
        Zlib,
        /**
         *  Поток should use gzip кодировка.
         */
        Gzip,
        /**
         *  Поток should use no кодировка.
         */
        Нет
    }

    private
    {
        бул zs_valid = нет;
        z_stream zs;
        ббайт[] out_chunk;
        т_мера _written = 0;
    }

    /***************************************************************************

        Constructs a new zlib compression фильтр.  You need в_ пароль in the
        поток that the compression фильтр will пиши в_.  If you are using
        this фильтр with a провод, the опрiom в_ use is:

        ---
        auto вывод = new ВыводЗлиб(myConduit.вывод);
        вывод.пиши(myContent);
        ---

        The optional окноБиты parameter is the основа two logarithm of the
        window размер, and should be in the range 8-15, defaulting в_ 15 if not
        specified.  добавьitionally, the окноБиты parameter may be негатив в_
        indicate that zlib should omit the стандарт zlib заголовок and trailer,
        with the window размер being -окноБиты.

    ***************************************************************************/

    this(ИПотокВывода поток, Уровень уровень, Кодировка кодировка,
            цел окноБиты = ОКНОБИТЫ_ДЕФОЛТ)
    {
        /*
         * Here's как окноБиты works, according в_ zlib.h:
         * 
         * 8 .. 15
         *      zlib кодировка.
         *      
         * (8 .. 15) + 16
         *      gzip кодировка.
         *      
         * (8 .. 15) + 32
         *      auto-detect кодировка.
         *      
         * (8 .. 15) * -1
         *      необр/no кодировка.
         *      
         * Since we're going в_ be playing with the значение, we DO care whether
         * окноБиты is in the ожидалось range, so we'll check it.
         * 
         * Also, note that OUR Кодировка enum doesn't contain the 'Guess'
         * member.  I'm still waiting on io.psychic...
         */
        if( !( 8 <= окноБиты && окноБиты <= 15 ) )
        {
            // No compression for you!
            throw new ИсклЗлиб("непригодный аргумент окноБиты"
                ~ .вТкст(окноБиты));
        }
        
        switch( кодировка )
        {
        case Кодировка.Zlib:
            // no-op
            break;
            
        case Кодировка.Gzip:
            окноБиты += 16;
            break;
            
        case Кодировка.Нет:
            окноБиты *= -1;
            break;
        }
        
        super(поток);
        out_chunk = new ббайт[РАЗМЕР_ЧАНКА];

        // Размести deflate состояние
        with( zs )
        {
            zalloc = пусто;
            zfree = пусто;
            opaque = пусто;
        }

        auto возвр = deflateInit2(&zs, уровень, Z_DEFLATED, окноБиты, 8,
                Z_DEFAULT_STRATEGY);
        if( возвр != Z_OK )
            throw new ИсклЗлиб(возвр);

        zs_valid = да;
    }
    
    /// ditto
    this(ИПотокВывода поток, Уровень уровень = Уровень.Нормальный)
    {
        // DRK 2009-02-26
        // Removed unique implementation in favour of passing on в_ другой
        // constructor.  See ВводЗлиб.this(ИПотокВвода).
        this(поток, уровень, Кодировка.init);
    }

    ~this()
    {
        if( zs_valid )
            туши_зп();
    }

    /***************************************************************************

        Compresses the given данные в_ the underlying провод.

        Returns the число of байты из_ ист that were compressed; пиши
        should always используй все данные provопрed в_ it, although it may not be
        immediately записано в_ the underlying вывод поток.

    ***************************************************************************/

    override т_мера пиши(проц[] ист)
    {
        проверьГожесть();
        scope(failure) туши_зп();

        zs.avail_in = ист.length;
        zs.next_in = cast(ббайт*)ист.ptr;

        do
        {
            zs.avail_out = out_chunk.length;
            zs.next_out = out_chunk.ptr;

            auto возвр = deflate(&zs, Z_NO_FLUSH);
            if( возвр == Z_STREAM_ERROR )
                throw new ИсклЗлиб(возвр);

            // Push the compressed байты out в_ the поток, until it's either
            // записано them все, or choked.
            auto have = out_chunk.length-zs.avail_out;
            auto out_buffer = out_chunk[0..have];
            do
            {
                auto w = сток.пиши(out_buffer);
                if( w == ИПровод.Кф )
                    return w;

                out_buffer = out_buffer[w..$];
                _written += w;
            }
            while( out_buffer.length > 0 );
        }
        // Loop while we are still using up the whole вывод буфер
        while( zs.avail_out == 0 );

        assert( zs.avail_in == 0, "неудачное сжатие всех предложенных данных" );

        return ист.length;
    }

    /***************************************************************************

        This читай-only property returns the число of compressed байты that
        have been записано в_ the underlying поток.  Following a вызов в_
        either закрой or подай, this will contain the total compressed размер of
        the ввод данные поток.

    ***************************************************************************/

    т_мера записано()
    {
        return _written;
    }

    /***************************************************************************

        подай the вывод

    ***************************************************************************/

    override проц закрой()
    {
        // Only подай if the поток is still открой.
        if( zs_valid ) подай;

        super.закрой;
    }

    /***************************************************************************

        Purge any buffered контент.  Calling this will implicitly конец the zlib
        поток, so it should not be called until you are завершено compressing
        данные.  Any calls в_ either пиши or подай after a compression фильтр
        есть been committed will throw an исключение.

    ***************************************************************************/

    проц подай()
    {
        проверьГожесть();
        scope(failure) туши_зп();

        zs.avail_in = 0;
        zs.next_in = пусто;

        бул завершено = нет;

        do
        {
            zs.avail_out = out_chunk.length;
            zs.next_out = out_chunk.ptr;

            auto возвр = deflate(&zs, Z_FINISH);
            switch( возвр )
            {
                case Z_OK:
                    // Keep going
                    break;

                case Z_STREAM_END:
                    // We're готово!
                    завершено = да;
                    break;

                default:
                    throw new ИсклЗлиб(возвр);
            }

            auto have = out_chunk.length - zs.avail_out;
            auto out_buffer = out_chunk[0..have];
            if( have > 0 )
            {
                do
                {
                    auto w = сток.пиши(out_buffer);
                    if( w == ИПровод.Кф )
                        return;

                    out_buffer = out_buffer[w..$];
                    _written += w;
                }
                while( out_buffer.length > 0 );
            }
        }
        while( !завершено );

        туши_зп();
    }

    // This function kills the поток: it deallocates the internal состояние, and
    // unsets the zs_valid flag.
    private проц туши_зп()
    {
        проверьГожесть();

        deflateEnd(&zs);
        zs_valid = нет;
    }

    // Asserts that the поток is still valid and usable (except that this
    // check doesn't получи elопрed with -release).
    private проц проверьГожесть()
    {
        if( !zs_valid )
            throw new ИсклЗлибЗакрыт;
    }
}

/*******************************************************************************
  
    This исключение is thrown if you attempt в_ perform a читай, пиши or слей
    operation on a закрыт zlib фильтр поток.  This can occur if the ввод
    поток есть завершено, or an вывод поток was flushed.

*******************************************************************************/

class ИсклЗлибЗакрыт : ВВИскл
{
    this()
    {
        super("операция с закрытым потоком zlib невыполнима");
    }
}

/*******************************************************************************
  
    This исключение is thrown when an ошибка occurs in the underlying zlib
    library.  Where possible, it will indicate Всё the имя of the ошибка, and
    any textural сообщение zlib есть provопрed.

*******************************************************************************/

class ИсклЗлиб : ВВИскл
{
    /*
     * Use this if you want в_ throw an исключение that isn't actually
     * generated by zlib.
     */
    this(ткст сооб)
    {
        super(сооб);
    }
    
    /*
     * код is the ошибка код returned by zlib.  The исключение сообщение will
     * be the имя of the ошибка код.
     */
    this(цел код)
    {
        super(имяКода(код));
    }

    /*
     * As above, except that it appends сооб as well.
     */
    this(цел код, сим* сооб)
    {
        super(имяКода(код)~": "~изТкст0(сооб));
    }

    protected ткст имяКода(цел код)
    {
        ткст имя;

        switch( код )
        {
            case Z_OK:              имя = "Z_OK";              break;
            case Z_STREAM_END:      имя = "Z_STREAM_END";      break;
            case Z_NEED_DICT:       имя = "Z_NEED_DICT";       break;
            case Z_ERRNO:           имя = "Z_ERRNO";           break;
            case Z_STREAM_ERROR:    имя = "Z_STREAM_ERROR";    break;
            case Z_DATA_ERROR:      имя = "Z_DATA_ERROR";      break;
            case Z_MEM_ERROR:       имя = "Z_MEM_ERROR";       break;
            case Z_BUF_ERROR:       имя = "Z_BUF_ERROR";       break;
            case Z_VERSION_ERROR:   имя = "Z_VERSION_ERROR";   break;
            default:                имя = "Z_UNKNOWN";
        }

        return имя;
    }
}

/* *****************************************************************************

    This section содержит a simple unit тест for this module.  It is скрытый
    behind a version statement because it introduces добавьitional dependencies.

***************************************************************************** */

debug(UnitTest) {

import io.device.Array : Массив;

проц check_array(ткст FILE=__FILE__, цел LINE=__LINE__)(
        ббайт[] as, ббайт[] bs, lazy ткст сооб)
{
    assert( as.length == bs.length,
        FILE ~":"~ вТкст(LINE) ~ ": " ~ сооб()
        ~ "Массив lengths differ (" ~ вТкст(as.length)
        ~ " vs " ~ вТкст(bs.length) ~ ")" );
    
    foreach( i, a ; as )
    {
        auto b = bs[i];
        
        assert( a == b,
            FILE ~":"~ вТкст(LINE) ~ ": " ~ сооб()
            ~ "массивы differ at " ~ вТкст(i)
            ~ " (" ~ вТкст(cast(цел) a)
            ~ " vs " ~ вТкст(cast(цел) b) ~ ")" );
    }
}

unittest
{
    // One ring в_ правило them все, one ring в_ найди them,
    // One ring в_ bring them все and in the darkness свяжи them.
    const ткст сообщение = 
        "Ash nazg durbatulûk, ash nazg gimbatul, "
        "ash nazg thrakatulûk, agh burzum-ishi krimpatul.";
    
    static assert( сообщение.length == 90 );

    // This compressed данные was создан using Python 2.5's built in zlib
    // module, with the default compression уровень.
    {
        const ббайт[] message_z = [
            0x78,0x9c,0x73,0x2c,0xce,0x50,0xc8,0x4b,
            0xac,0x4a,0x57,0x48,0x29,0x2d,0x4a,0x4a,
            0x2c,0x29,0xcd,0x39,0xbc,0x3b,0x5b,0x47,
            0x21,0x11,0x26,0x9a,0x9e,0x99,0x0b,0x16,
            0x45,0x12,0x2a,0xc9,0x28,0x4a,0xcc,0x46,
            0xa8,0x4c,0xcf,0x50,0x48,0x2a,0x2d,0xaa,
            0x2a,0xcd,0xd5,0xcd,0x2c,0xce,0xc8,0x54,
            0xc8,0x2e,0xca,0xcc,0x2d,0x00,0xc9,0xea,
            0x01,0x00,0x1f,0xe3,0x22,0x99];
    
        scope cond_z = new Массив(2048);
        scope comp = new ВыводЗлиб(cond_z);
        comp.пиши (сообщение);
        comp.закрой;
    
        assert( comp.записано == message_z.length );
        
        /+
        Стдвыв("message_z:").нс;
        foreach( b ; cast(ббайт[]) cond_z.срез )
            Стдвыв.форматируй("0x{0:x2},", b);
        Стдвыв.нс.нс;
        +/
    
        //assert( message_z == cast(ббайт[])(cond_z.срез) );
        check_array!(__FILE__,__LINE__)
            ( message_z, cast(ббайт[]) cond_z.срез, "message_z " );
    
        scope decomp = new ВводЗлиб(cond_z);
        auto буфер = new ббайт[256];
        буфер = буфер[0 .. decomp.читай(буфер)];
    
        //assert( cast(ббайт[])сообщение == буфер );
        check_array!(__FILE__,__LINE__)
            ( cast(ббайт[]) сообщение, буфер, "сообщение (zlib) " );
    }
    
    // This compressed данные was создан using the Cygwin gzip program
    // with default options.  The original файл was called "testdata.txt".
    {
        const ббайт[] message_gz = [
            0x1f,0x8b,0x08,0x00,0x80,0x70,0x6f,0x45,
            0x00,0x03,0x73,0x2c,0xce,0x50,0xc8,0x4b,
            0xac,0x4a,0x57,0x48,0x29,0x2d,0x4a,0x4a,
            0x2c,0x29,0xcd,0x39,0xbc,0x3b,0x5b,0x47,
            0x21,0x11,0x26,0x9a,0x9e,0x99,0x0b,0x16,
            0x45,0x12,0x2a,0xc9,0x28,0x4a,0xcc,0x46,
            0xa8,0x4c,0xcf,0x50,0x48,0x2a,0x2d,0xaa,
            0x2a,0xcd,0xd5,0xcd,0x2c,0xce,0xc8,0x54,
            0xc8,0x2e,0xca,0xcc,0x2d,0x00,0xc9,0xea,
            0x01,0x00,0x45,0x38,0xbc,0x58,0x5a,0x00,
            0x00,0x00];
        
        // Compresses the original сообщение, and outputs the байты.  You can use
        // this в_ тест the вывод of ВыводЗлиб with gzip.  If you use this,
        // don't forget в_ import Стдвыв somewhere.
        /+
        scope comp_gz = new Массив(2048);
        scope comp = new ВыводЗлиб(comp_gz, ВыводЗлиб.Уровень.Нормальный, ВыводЗлиб.Кодировка.Gzip, ОКНОБИТЫ_ДЕФОЛТ);
        comp.пиши(сообщение);
        comp.закрой;
        
        Стдвыв.форматируй("message_gz ({0} байты):", comp_gz.срез.length).нс;
        foreach( b ; cast(ббайт[]) comp_gz.срез )
            Стдвыв.форматируй("0x{0:x2},", b);
        Стдвыв.нс;
        +/
        
        // We aren't going в_ тест that we can сожми в_ a gzip поток
        // since gzip itself always добавьs stuff like the имяф, timestamps,
        // etc.  We'll just сделай sure we can DECOMPRESS gzip Потокs.
        scope decomp_gz = new Массив(message_gz.dup);
        scope decomp = new ВводЗлиб(decomp_gz);
        auto буфер = new ббайт[256];
        буфер = буфер[0 .. decomp.читай(буфер)];
        
        //assert( cast(ббайт[]) сообщение == буфер );
        check_array!(__FILE__,__LINE__)
            ( cast(ббайт[]) сообщение, буфер, "сообщение (gzip) ");
    }
}
}
