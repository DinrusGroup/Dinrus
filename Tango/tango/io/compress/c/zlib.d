/* zlib.h -- interface of the 'zlib' general purpose compression library
  version 1.2.3, July 18th, 2005

  Copyright (C) 1995-2005 Jean-loup Gailly and Mark Adler

  This software is provопрed 'as-is', without any express or implied
  warranty.  In no событие will the authors be held liable for any damages
  arising из_ the use of this software.

  Permission is granted в_ anyone в_ use this software for any purpose,
  включая commercial applications, and в_ alter it and redistribute it
  freely, субъект в_ the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered источник versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered из_ any источник distribution.

  Jean-loup Gailly        Mark Adler
  jloup@gzИП.org          madler@alumni.caltech.edu


  The данные форматируй used by the zlib library is described by RFCs (Request for
  Comments) 1950 в_ 1952 in the файлы http://www.ietf.org/rfc/rfc1950.txt
  (zlib форматируй), rfc1951.txt (deflate форматируй) and rfc1952.txt (gzИП форматируй).
*/

module lib.zlib;

extern (C):

const сим* ZLIB_VERSION = "1.2.3";
const бцел  ZLIB_VERNUM  = 0x1230;

/*
     The 'zlib' compression library provопрes in-память compression and
  decompression functions, включая integrity checks of the uncompressed
  данные.  This version of the library supports only one compression метод
  (deflation) but другой algorithms will be добавьed later and will have the same
  поток interface.

     Compression can be готово in a single step if the buffers are large
  enough (for example if an ввод файл is mmap'ed), or can be готово by
  repeated calls of the compression function.  In the latter case, the
  application must provопрe ещё ввод and/or используй the вывод
  (provопрing ещё вывод пространство) before each вызов.

     The compressed данные форматируй used by default by the in-память functions is
  the zlib форматируй, which is a zlib wrapper documented in RFC 1950, wrapped
  around a deflate поток, which is itself documented in RFC 1951.

     The library also supports reading and writing файлы in gzИП (.gz) форматируй
  with an interface similar в_ that of stdio using the functions that старт
  with "gz".  The gzИП форматируй is different из_ the zlib форматируй.  gzИП is a
  gzИП wrapper, documented in RFC 1952, wrapped around a deflate поток.

     This library can optionally читай and пиши gzИП Потокs in память as well.

     The zlib форматируй was designed в_ be compact and fast for use in память
  and on communications channels.  The gzИП форматируй was designed for single-
  файл compression on файл systems, есть a larger заголовок than zlib в_ maintain
  дир information, and uses a different, slower check метод than zlib.

     The library does not install any signal handler. The decoder checks
  the consistency of the compressed данные, so the library should never
  crash even in case of corrupted ввод.
*/

private
{
    import base : c_long, c_ulong;

    version( Posix )
    {
        import rt.core.stdc.posix.sys.типы : z_off_t = off_t;
    }
    else
    {
        alias c_long z_off_t;
    }

    alias ббайт     Byte;
    alias бцел      uInt;
    alias c_ulong   uLong;

    alias Byte      Bytef;
    alias сим      charf;
    alias цел       intf;
    alias uInt      uIntf;
    alias uLong     uLongf;

    alias ук      voопрpc; // TODO: normally const
    alias ук      voопрpf;
    alias ук      voопрp;

    alias voопрpf function(voопрpf opaque, uInt items, uInt размер) alloc_func;
    alias проц   function(voопрpf opaque, voопрpf адрес)        free_func;

    struct internal_state {}
}

struct z_stream
{
    Bytef*          next_in;   /* следщ ввод байт */
    uInt            avail_in;  /* число of байты available at next_in */
    uLong           total_in;  /* total nb of ввод байты читай so far */

    Bytef*          next_out;  /* следщ вывод байт should be помести there */
    uInt            avail_out; /* remaining free пространство at next_out */
    uLong           total_out; /* total nb of байты вывод so far */

    сим*           сооб;       /* последний ошибка сообщение, NULL if no ошибка */
    internal_state* состояние;     /* not visible by applications */

    alloc_func      zalloc;    /* used в_ размести the internal состояние */
    free_func       zfree;     /* used в_ free the internal состояние */
    voопрpf          opaque;    /* private данные объект passed в_ zalloc and zfree */

    цел             data_type; /* best guess about the данные тип: binary or текст */
    uLong           adler;     /* adler32 значение of the uncompressed данные */
    uLong           reserved;  /* reserved for future use */
}

alias z_stream* z_Потокp;

/*
     gzИП заголовок information passed в_ and из_ zlib routines.  See RFC 1952
  for ещё details on the meanings of these fields.
*/
struct gz_header
{
    цел     текст;       /* да if compressed данные believed в_ be текст */
    uLong   время;       /* modification время */
    цел     xflags;     /* extra флаги (not used when writing a gzИП файл) */
    цел     os;         /* operating system */
    Bytef*  extra;      /* pointer в_ extra field or Z_NULL if Неук */
    uInt    extra_len;  /* extra field length (valid if extra != Z_NULL) */
    uInt    extra_max;  /* пространство at extra (only when reading заголовок) */
    Bytef*  имя;       /* pointer в_ zero-terminated файл имя or Z_NULL */
    uInt    name_max;   /* пространство at имя (only when reading заголовок) */
    Bytef*  коммент;    /* pointer в_ zero-terminated коммент or Z_NULL */
    uInt    comm_max;   /* пространство at коммент (only when reading заголовок) */
    цел     hcrc;       /* да if there was or will be a заголовок crc */
    цел     готово;       /* да when готово reading gzИП заголовок (not used
                           when writing a gzИП файл) */
}

alias gz_header* gz_headerp;

/*
   The application must обнови next_in and avail_in when avail_in есть
   dropped в_ zero. It must обнови next_out and avail_out when avail_out
   есть dropped в_ zero. The application must инициализуй zalloc, zfree and
   opaque before calling the init function. все другой fields are установи by the
   compression library and must not be updated by the application.

   The opaque значение provопрed by the application will be passed as the first
   parameter for calls of zalloc and zfree. This can be useful for custom
   память management. The compression library attaches no meaning в_ the
   opaque значение.

   zalloc must return Z_NULL if there is not enough память for the объект.
   If zlib is used in a multi-threaded application, zalloc and zfree must be
   нить safe.

   On 16-bit systems, the functions zalloc and zfree must be able в_ размести
   exactly 65536 байты, but will not be required в_ размести ещё than this
   if the symbol MAXSEG_64K is defined (see zconf.h). WARNING: On MSDOS,
   pointers returned by zalloc for objects of exactly 65536 байты *must*
   have their смещение normalized в_ zero. The default allocation function
   provопрed by this library ensures this (see zutil.c). To reduce память
   requirements and avoопр any allocation of 64K objects, at the expense of
   compression ratio, компилируй the library with -DMAX_WBITS=14 (see zconf.h).

   The fields total_in and total_out can be used for statistics or
   ход reports. After compression, total_in holds the total размер of
   the uncompressed данные and may be saved for use in the decompressor
   (particularly if the decompressor wants в_ decompress everything in
   a single step).
*/

                        /* constants */

enum
{
    Z_NO_FLUSH      = 0,
    Z_PARTIAL_FLUSH = 1, /* will be removed, use Z_SYNC_FLUSH instead */
    Z_SYNC_FLUSH    = 2,
    Z_FULL_FLUSH    = 3,
    Z_FINISH        = 4,
    Z_BLOCK         = 5,
}
/* Allowed слей values; see deflate() and inflate() below for details */

enum
{
    Z_OK            = 0,
    Z_STREAM_END    = 1,
    Z_NEED_DICT     = 2,
    Z_ERRNO         = -1,
    Z_STREAM_ERROR  = -2,
    Z_DATA_ERROR    = -3,
    Z_MEM_ERROR     = -4,
    Z_BUF_ERROR     = -5,
    Z_VERSION_ERROR = -6,
}
/* Return codes for the compression/decompression functions. Negative
 * values are ошибки, positive values are used for special but нормаль события.
 */

enum
{
    Z_NO_COMPRESSION      = 0,
    Z_BEST_SPEED          = 1,
    Z_BEST_COMPRESSION    = 9,
    Z_DEFAULT_COMPRESSION = -1,
}
/* compression levels */

enum
{
    Z_FILTERED            = 1,
    Z_HUFFMAN_ONLY        = 2,
    Z_RLE                 = 3,
    Z_FIXED               = 4,
    Z_DEFAULT_STRATEGY    = 0,
}
/* compression strategy; see deflateInit2() below for details */

enum
{
    Z_BINARY   = 0,
    Z_TEXT     = 1,
    Z_ASCII    = Z_TEXT,  /* for compatibility with 1.2.2 and earlier */
    Z_UNKNOWN  = 2,
}
/* Possible values of the data_type field (though see inflate()) */

enum
{
    Z_DEFLATED = 8,
}
/* The deflate compression метод (the only one supported in this version) */

const Z_NULL = пусто;    /* for initializing zalloc, zfree, opaque */

alias zlibVersion zlib_version;
/* for compatibility with versions < 1.0.2 */

                        /* basic functions */

сим* zlibVersion();
/* The application can compare zlibVersion and ZLIB_VERSION for consistency.
   If the first character differs, the library код actually used is
   not compatible with the zlib.h заголовок файл used by the application.
   This check is automatically made by deflateInit and inflateInit.
 */

/*
цел deflateInit (z_Потокp strm, цел уровень);

     Initializes the internal поток состояние for compression. The fields
   zalloc, zfree and opaque must be инициализован before by the caller.
   If zalloc and zfree are установи в_ Z_NULL, deflateInit updates them в_
   use default allocation functions.

     The compression уровень must be Z_DEFAULT_COMPRESSION, or between 0 and 9:
   1 gives best скорость, 9 gives best compression, 0 gives no compression at
   все (the ввод данные is simply copied a block at a время).
   Z_DEFAULT_COMPRESSION requests a default compromise between скорость and
   compression (currently equivalent в_ уровень 6).

     deflateInit returns Z_OK if success, Z_MEM_ERROR if there was not
   enough память, Z_STREAM_ERROR if уровень is not a valid compression уровень,
   Z_VERSION_ERROR if the zlib library version (zlib_version) is incompatible
   with the version assumed by the caller (ZLIB_VERSION).
   сооб is установи в_ пусто if there is no ошибка сообщение.  deflateInit does not
   perform any compression: this will be готово by deflate().
*/


цел deflate(z_Потокp strm, цел слей);
/*
    deflate compresses as much данные as possible, and stops when the ввод
  буфер becomes пустой or the вывод буфер becomes full. It may introduce some
  вывод latency (reading ввод without producing any вывод) except when
  forced в_ слей.

    The detailed semantics are as follows. deflate performs one or Всё of the
  following actions:

  - Compress ещё ввод starting at next_in and обнови next_in and avail_in
    accordingly. If not все ввод can be processed (because there is not
    enough room in the вывод буфер), next_in and avail_in are updated and
    processing will resume at this point for the следщ вызов of deflate().

  - Provопрe ещё вывод starting at next_out and обнови next_out and avail_out
    accordingly. This action is forced if the parameter слей is non zero.
    Forcing слей frequently degrades the compression ratio, so this parameter
    should be установи only when necessary (in interactive applications).
    Some вывод may be provопрed even if слей is not установи.

  Before the вызов of deflate(), the application should ensure that at least
  one of the actions is possible, by provопрing ещё ввод and/or consuming
  ещё вывод, and updating avail_in or avail_out accordingly; avail_out
  should never be zero before the вызов. The application can используй the
  compressed вывод when it wants, for example when the вывод буфер is full
  (avail_out == 0), or after each вызов of deflate(). If deflate returns Z_OK
  and with zero avail_out, it must be called again after making room in the
  вывод буфер because there might be ещё вывод pending.

    Normally the parameter слей is установи в_ Z_NO_FLUSH, which allows deflate в_
  decопрe как much данные в_ accumualte before producing вывод, in order в_
  maximize compression.

    If the parameter слей is установи в_ Z_SYNC_FLUSH, все pending вывод is
  flushed в_ the вывод буфер and the вывод is aligned on a байт boundary, so
  that the decompressor can получи все ввод данные available so far. (In particular
  avail_in is zero after the вызов if enough вывод пространство есть been provопрed
  before the вызов.)  Flushing may degrade compression for some compression
  algorithms and so it should be used only when necessary.

    If слей is установи в_ Z_FULL_FLUSH, все вывод is flushed as with
  Z_SYNC_FLUSH, and the compression состояние is сбрось so that decompression can
  restart из_ this point if previous compressed данные есть been damaged or if
  random access is desired. Using Z_FULL_FLUSH too often can seriously degrade
  compression.

    If deflate returns with avail_out == 0, this function must be called again
  with the same значение of the слей parameter and ещё вывод пространство (updated
  avail_out), until the слей is complete (deflate returns with non-zero
  avail_out). In the case of a Z_FULL_FLUSH or Z_SYNC_FLUSH, сделай sure that
  avail_out is greater than six в_ avoопр repeated слей markers due в_
  avail_out == 0 on return.

    If the parameter слей is установи в_ Z_FINISH, pending ввод is processed,
  pending вывод is flushed and deflate returns with Z_STREAM_END if there
  was enough вывод пространство; if deflate returns with Z_OK, this function must be
  called again with Z_FINISH and ещё вывод пространство (updated avail_out) but no
  ещё ввод данные, until it returns with Z_STREAM_END or an ошибка. After
  deflate есть returned Z_STREAM_END, the only possible operations on the
  поток are deflateReset or deflateEnd.

    Z_FINISH can be used immediately after deflateInit if все the compression
  is в_ be готово in a single step. In this case, avail_out must be at least
  the значение returned by deflateBound (see below). If deflate does not return
  Z_STREAM_END, then it must be called again as described above.

    deflate() sets strm->adler в_ the adler32 checksum of все ввод читай
  so far (that is, total_in байты).

    deflate() may обнови strm->data_type if it can сделай a good guess about
  the ввод данные тип (Z_BINARY or Z_TEXT). In doubt, the данные is consопрered
  binary. This field is only for information purposes and does not affect
  the compression algorithm in any manner.

    deflate() returns Z_OK if some ход есть been made (ещё ввод
  processed or ещё вывод produced), Z_STREAM_END if все ввод есть been
  consumed and все вывод есть been produced (only when слей is установи в_
  Z_FINISH), Z_STREAM_ERROR if the поток состояние was inconsistent (for example
  if next_in or next_out was NULL), Z_BUF_ERROR if no ход is possible
  (for example avail_in or avail_out was zero). Note that Z_BUF_ERROR is not
  фатал, and deflate() can be called again with ещё ввод and ещё вывод
  пространство в_ continue compressing.
*/


цел deflateEnd(z_Потокp strm);
/*
     все dynamically allocated данные structures for this поток are freed.
   This function discards any unprocessed ввод and does not слей any
   pending вывод.

     deflateEnd returns Z_OK if success, Z_STREAM_ERROR if the
   поток состояние was inconsistent, Z_DATA_ERROR if the поток was freed
   prematurely (some ввод or вывод was discarded). In the ошибка case,
   сооб may be установи but then points в_ a static ткст (which must not be
   deallocated).
*/


/*
цел inflateInit(z_Потокp strm);

     Initializes the internal поток состояние for decompression. The fields
   next_in, avail_in, zalloc, zfree and opaque must be инициализован before by
   the caller. If next_in is not Z_NULL and avail_in is large enough (the exact
   значение depends on the compression метод), inflateInit determines the
   compression метод из_ the zlib заголовок and allocates все данные structures
   accordingly; otherwise the allocation will be deferred в_ the first вызов of
   inflate.  If zalloc and zfree are установи в_ Z_NULL, inflateInit updates them в_
   use default allocation functions.

     inflateInit returns Z_OK if success, Z_MEM_ERROR if there was not enough
   память, Z_VERSION_ERROR if the zlib library version is incompatible with the
   version assumed by the caller.  сооб is установи в_ пусто if there is no ошибка
   сообщение. inflateInit does not perform any decompression apart из_ reading
   the zlib заголовок if present: this will be готово by inflate().  (So next_in and
   avail_in may be изменён, but next_out and avail_out are unchanged.)
*/


цел inflate(z_Потокp strm, цел слей);
/*
    inflate decompresses as much данные as possible, and stops when the ввод
  буфер becomes пустой or the вывод буфер becomes full. It may introduce
  some вывод latency (reading ввод without producing any вывод) except when
  forced в_ слей.

  The detailed semantics are as follows. inflate performs one or Всё of the
  following actions:

  - Decompress ещё ввод starting at next_in and обнови next_in and avail_in
    accordingly. If not все ввод can be processed (because there is not
    enough room in the вывод буфер), next_in is updated and processing
    will resume at this point for the следщ вызов of inflate().

  - Provопрe ещё вывод starting at next_out and обнови next_out and avail_out
    accordingly.  inflate() provопрes as much вывод as possible, until there
    is no ещё ввод данные or no ещё пространство in the вывод буфер (see below
    about the слей parameter).

  Before the вызов of inflate(), the application should ensure that at least
  one of the actions is possible, by provопрing ещё ввод and/or consuming
  ещё вывод, and updating the next_* and avail_* values accordingly.
  The application can используй the uncompressed вывод when it wants, for
  example when the вывод буфер is full (avail_out == 0), or after each
  вызов of inflate(). If inflate returns Z_OK and with zero avail_out, it
  must be called again after making room in the вывод буфер because there
  might be ещё вывод pending.

    The слей parameter of inflate() can be Z_NO_FLUSH, Z_SYNC_FLUSH,
  Z_FINISH, or Z_BLOCK. Z_SYNC_FLUSH requests that inflate() слей as much
  вывод as possible в_ the вывод буфер. Z_BLOCK requests that inflate() stop
  if and when it gets в_ the следщ deflate block boundary. When decoding the
  zlib or gzИП форматируй, this will cause inflate() в_ return immediately after
  the заголовок and before the first block. When doing a необр inflate, inflate()
  will go ahead and process the first block, and will return when it gets в_
  the конец of that block, or when it runs out of данные.

    The Z_BLOCK опция assists in appending в_ or combining deflate Потокs.
  Also в_ assist in this, on return inflate() will установи strm->data_type в_ the
  число of unused биты in the последний байт taken из_ strm->next_in, plus 64
  if inflate() is currently decoding the последний block in the deflate поток,
  plus 128 if inflate() returned immediately after decoding an конец-of-block
  код or decoding the complete заголовок up в_ just before the first байт of the
  deflate поток. The конец-of-block will not be indicated until все of the
  uncompressed данные из_ that block есть been записано в_ strm->next_out.  The
  число of unused биты may in general be greater than seven, except when
  bit 7 of data_type is установи, in which case the число of unused биты will be
  less than eight.

    inflate() should normally be called until it returns Z_STREAM_END or an
  ошибка. However if все decompression is в_ be performed in a single step
  (a single вызов of inflate), the parameter слей should be установи в_
  Z_FINISH. In this case все pending ввод is processed and все pending
  вывод is flushed; avail_out must be large enough в_ hold все the
  uncompressed данные. (The размер of the uncompressed данные may have been saved
  by the compressor for this purpose.) The следщ operation on this поток must
  be inflateEnd в_ deallocate the decompression состояние. The use of Z_FINISH
  is never required, but can be used в_ inform inflate that a faster approach
  may be used for the single inflate() вызов.

     In this implementation, inflate() always flushes as much вывод as
  possible в_ the вывод буфер, and always uses the faster approach on the
  first вызов. So the only effect of the слей parameter in this implementation
  is on the return значение of inflate(), as noted below, or when it returns early
  because Z_BLOCK is used.

     If a preset dictionary is needed after this вызов (see inflateSetDictionary
  below), inflate sets strm->adler в_ the adler32 checksum of the dictionary
  chosen by the compressor and returns Z_NEED_DICT; otherwise it sets
  strm->adler в_ the adler32 checksum of все вывод produced so far (that is,
  total_out байты) and returns Z_OK, Z_STREAM_END or an ошибка код as described
  below. At the конец of the поток, inflate() checks that its computed adler32
  checksum is equal в_ that saved by the compressor and returns Z_STREAM_END
  only if the checksum is correct.

    inflate() will decompress and check either zlib-wrapped or gzИП-wrapped
  deflate данные.  The заголовок тип is detected automatically.  Any information
  contained in the gzИП заголовок is not retained, so applications that need that
  information should instead use необр inflate, see inflateInit2() below, or
  inflateBack() and perform their own processing of the gzИП заголовок and
  trailer.

    inflate() returns Z_OK if some ход есть been made (ещё ввод processed
  or ещё вывод produced), Z_STREAM_END if the конец of the compressed данные есть
  been reached and все uncompressed вывод есть been produced, Z_NEED_DICT if a
  preset dictionary is needed at this point, Z_DATA_ERROR if the ввод данные was
  corrupted (ввод поток not conforming в_ the zlib форматируй or incorrect check
  значение), Z_STREAM_ERROR if the поток structure was inconsistent (for example
  if next_in or next_out was NULL), Z_MEM_ERROR if there was not enough память,
  Z_BUF_ERROR if no ход is possible or if there was not enough room in the
  вывод буфер when Z_FINISH is used. Note that Z_BUF_ERROR is not фатал, and
  inflate() can be called again with ещё ввод and ещё вывод пространство в_
  continue decompressing. If Z_DATA_ERROR is returned, the application may then
  вызов inflateSync() в_ look for a good compression block if a partial recovery
  of the данные is desired.
*/


цел inflateEnd(z_Потокp strm);
/*
     все dynamically allocated данные structures for this поток are freed.
   This function discards any unprocessed ввод and does not слей any
   pending вывод.

     inflateEnd returns Z_OK if success, Z_STREAM_ERROR if the поток состояние
   was inconsistent. In the ошибка case, сооб may be установи but then points в_ a
   static ткст (which must not be deallocated).
*/

                        /* Advanced functions */

/*
    The following functions are needed only in some special applications.
*/

/*
цел deflateInit2 (z_Потокp strm,
                                  цел       уровень,
                                  цел       метод,
                                  цел       windowBits,
                                  цел       memУровень,
                                  цел       strategy);

     This is другой version of deflateInit with ещё compression options. The
   fields next_in, zalloc, zfree and opaque must be инициализован before by
   the caller.

     The метод parameter is the compression метод. It must be Z_DEFLATED in
   this version of the library.

     The windowBits parameter is the основа two logarithm of the window размер
   (the размер of the history буфер). It should be in the range 8..15 for this
   version of the library. Larger values of this parameter результат in better
   compression at the expense of память usage. The default значение is 15 if
   deflateInit is used instead.

     windowBits can also be -8..-15 for необр deflate. In this case, -windowBits
   determines the window размер. deflate() will then generate необр deflate данные
   with no zlib заголовок or trailer, and will not compute an adler32 check значение.

     windowBits can also be greater than 15 for optional gzИП кодировка. Добавь
   16 в_ windowBits в_ пиши a simple gzИП заголовок and trailer around the
   compressed данные instead of a zlib wrapper. The gzИП заголовок will have no
   файл имя, no extra данные, no коммент, no modification время (установи в_ zero),
   no заголовок crc, and the operating system will be установи в_ 255 (неизвестное).  If a
   gzИП поток is being записано, strm->adler is a crc32 instead of an adler32.

     The memУровень parameter specifies как much память should be allocated
   for the internal compression состояние. memУровень=1 uses minimum память but
   is slow and reduces compression ratio; memУровень=9 uses maximum память
   for optimal скорость. The default значение is 8. See zconf.h for total память
   usage as a function of windowBits and memУровень.

     The strategy parameter is used в_ tune the compression algorithm. Use the
   значение Z_DEFAULT_STRATEGY for нормаль данные, Z_FILTERED for данные produced by a
   фильтр (or predictor), Z_HUFFMAN_ONLY в_ force Huffman кодировка only (no
   ткст match), or Z_RLE в_ предел match distances в_ one (run-length
   кодировка). Filtered данные consists mostly of small values with a somewhat
   random distribution. In this case, the compression algorithm is tuned в_
   сожми them better. The effect of Z_FILTERED is в_ force ещё Huffman
   coding and less ткст matching; it is somewhat intermediate between
   Z_DEFAULT and Z_HUFFMAN_ONLY. Z_RLE is designed в_ be almost as fast as
   Z_HUFFMAN_ONLY, but give better compression for PNG образ данные. The strategy
   parameter only affects the compression ratio but not the correctness of the
   compressed вывод even if it is not установи appropriately.  Z_FIXED prevents the
   use of dynamic Huffman codes, allowing for a simpler decoder for special
   applications.

      deflateInit2 returns Z_OK if success, Z_MEM_ERROR if there was not enough
   память, Z_STREAM_ERROR if a parameter is не_годится (such as an не_годится
   метод). сооб is установи в_ пусто if there is no ошибка сообщение.  deflateInit2 does
   not perform any compression: this will be готово by deflate().
*/

цел deflateSetDictionary(z_Потокp strm,
                         Bytef*    dictionary,
                         uInt      dictLength);
/*
     Initializes the compression dictionary из_ the given байт sequence
   without producing any compressed вывод. This function must be called
   immediately after deflateInit, deflateInit2 or deflateReset, before any
   вызов of deflate. The compressor and decompressor must use exactly the same
   dictionary (see inflateSetDictionary).

     The dictionary should consist of strings (байт sequences) that are likely
   в_ be encountered later in the данные в_ be compressed, with the most commonly
   used strings preferably помести towards the конец of the dictionary. Using a
   dictionary is most useful when the данные в_ be compressed is крат and can be
   predicted with good accuracy; the данные can then be compressed better than
   with the default пустой dictionary.

     Depending on the размер of the compression данные structures selected by
   deflateInit or deflateInit2, a часть of the dictionary may in effect be
   discarded, for example if the dictionary is larger than the window размер in
   deflate or deflate2. Thus the strings most likely в_ be useful should be
   помести at the конец of the dictionary, not at the front. In добавьition, the
   current implementation of deflate will use at most the window размер minus
   262 байты of the provопрed dictionary.

     Upon return of this function, strm->adler is установи в_ the adler32 значение
   of the dictionary; the decompressor may later use this значение в_ determine
   which dictionary есть been used by the compressor. (The adler32 значение
   applies в_ the whole dictionary even if only a поднабор of the dictionary is
   actually used by the compressor.) If a необр deflate was requested, then the
   adler32 значение is not computed and strm->adler is not установи.

     deflateSetDictionary returns Z_OK if success, or Z_STREAM_ERROR if a
   parameter is не_годится (such as NULL dictionary) or the поток состояние is
   inconsistent (for example if deflate есть already been called for this поток
   or if the compression метод is bsort). deflateSetDictionary does not
   perform any compression: this will be готово by deflate().
*/

цел deflateCopy(z_Потокp приёмник,
                z_Потокp источник);
/*
     Sets the destination поток as a complete копируй of the источник поток.

     This function can be useful when several compression strategies will be
   tried, for example when there are several ways of pre-processing the ввод
   данные with a фильтр. The Потокs that will be discarded should then be freed
   by calling deflateEnd.  Note that deflateCopy duplicates the internal
   compression состояние which can be quite large, so this strategy is slow and
   can используй lots of память.

     deflateCopy returns Z_OK if success, Z_MEM_ERROR if there was not
   enough память, Z_STREAM_ERROR if the источник поток состояние was inconsistent
   (such as zalloc being NULL). сооб is left unchanged in Всё источник and
   destination.
*/

цел deflateReset(z_Потокp strm);
/*
     This function is equivalent в_ deflateEnd followed by deflateInit,
   but does not free and reallocate все the internal compression состояние.
   The поток will keep the same compression уровень and any другой атрибуты
   that may have been установи by deflateInit2.

      deflateReset returns Z_OK if success, or Z_STREAM_ERROR if the источник
   поток состояние was inconsistent (such as zalloc or состояние being NULL).
*/

цел deflateParams(z_Потокp strm,
                  цел       уровень,
                  цел       strategy);
/*
     Dynamically обнови the compression уровень and compression strategy.  The
   interpretation of уровень and strategy is as in deflateInit2.  This can be
   used в_ switch between compression and straight копируй of the ввод данные, or
   в_ switch в_ a different kind of ввод данные requiring a different
   strategy. If the compression уровень is изменён, the ввод available so far
   is compressed with the old уровень (and may be flushed); the new уровень will
   take effect only at the следщ вызов of deflate().

     Before the вызов of deflateParams, the поток состояние must be установи as for
   a вызов of deflate(), since the currently available ввод may have в_
   be compressed and flushed. In particular, strm->avail_out must be non-zero.

     deflateParams returns Z_OK if success, Z_STREAM_ERROR if the источник
   поток состояние was inconsistent or if a parameter was не_годится, Z_BUF_ERROR
   if strm->avail_out was zero.
*/

цел deflateTune(z_Потокp strm,
                цел       good_length,
                цел       max_lazy,
                цел       nice_length,
                цел       max_chain);
/*
     Fine tune deflate's internal compression параметры.  This should only be
   used by someone who understands the algorithm used by zlib's deflate for
   searching for the best matching ткст, and even then only by the most
   fanatic optimizer trying в_ squeeze out the последний compressed bit for their
   specific ввод данные.  Чтен the deflate.c источник код for the meaning of the
   max_lazy, good_length, nice_length, and max_chain параметры.

     deflateTune() can be called after deflateInit() or deflateInit2(), and
   returns Z_OK on success, or Z_STREAM_ERROR for an не_годится deflate поток.
 */

uLong deflateBound(z_Потокp strm,
                   uLong     sourceLen);
/*
     deflateBound() returns an upper bound on the compressed размер after
   deflation of sourceLen байты.  It must be called after deflateInit()
   or deflateInit2().  This would be used в_ размести an вывод буфер
   for deflation in a single пароль, and so would be called before deflate().
*/

цел deflatePrime(z_Потокp strm,
                 цел       биты,
                 цел       значение);
/*
     deflatePrime() inserts биты in the deflate вывод поток.  The intent
  is that this function is used в_ старт off the deflate вывод with the
  биты leftover из_ a previous deflate поток when appending в_ it.  As such,
  this function can only be used for необр deflate, and must be used before the
  first deflate() вызов after a deflateInit2() or deflateReset().  биты must be
  less than or equal в_ 16, and that many of the least significant биты of
  значение will be inserted in the вывод.

      deflatePrime returns Z_OK if success, or Z_STREAM_ERROR if the источник
   поток состояние was inconsistent.
*/

цел deflateSetHeader(z_Потокp  strm,
                     gz_headerp голова);
/*
      deflateSetHeader() provопрes gzИП заголовок information for when a gzИП
   поток is requested by deflateInit2().  deflateSetHeader() may be called
   after deflateInit2() or deflateReset() and before the first вызов of
   deflate().  The текст, время, os, extra field, имя, and коммент information
   in the provопрed gz_header structure are записано в_ the gzИП заголовок (xflag is
   ignored -- the extra флаги are установи according в_ the compression уровень).  The
   caller must assure that, if not Z_NULL, имя and коммент are terminated with
   a zero байт, and that if extra is not Z_NULL, that extra_len байты are
   available there.  If hcrc is да, a gzИП заголовок crc is included.  Note that
   the current versions of the команда-строка version of gzИП (up through version
   1.3.x) do not support заголовок crc's, and will report that it is a "multi-часть
   gzИП файл" and give up.

      If deflateSetHeader is not used, the default gzИП заголовок есть текст нет,
   the время установи в_ zero, and os установи в_ 255, with no extra, имя, or коммент
   fields.  The gzИП заголовок is returned в_ the default состояние by deflateReset().

      deflateSetHeader returns Z_OK if success, or Z_STREAM_ERROR if the источник
   поток состояние was inconsistent.
*/

/*
цел inflateInit2(z_Потокp strm,
                 цел       windowBits);

     This is другой version of inflateInit with an extra parameter. The
   fields next_in, avail_in, zalloc, zfree and opaque must be инициализован
   before by the caller.

     The windowBits parameter is the основа two logarithm of the maximum window
   размер (the размер of the history буфер).  It should be in the range 8..15 for
   this version of the library. The default значение is 15 if inflateInit is used
   instead. windowBits must be greater than or equal в_ the windowBits значение
   provопрed в_ deflateInit2() while compressing, or it must be equal в_ 15 if
   deflateInit2() was not used. If a compressed поток with a larger window
   размер is given as ввод, inflate() will return with the ошибка код
   Z_DATA_ERROR instead of trying в_ размести a larger window.

     windowBits can also be -8..-15 for необр inflate. In this case, -windowBits
   determines the window размер. inflate() will then process необр deflate данные,
   not looking for a zlib or gzИП заголовок, not generating a check значение, and not
   looking for any check values for comparison at the конец of the поток. This
   is for use with другой formats that use the deflate compressed данные форматируй
   such as zИП.  Those formats provопрe their own check values. If a custom
   форматируй is developed using the необр deflate форматируй for compressed данные, it is
   recommended that a check значение such as an adler32 or a crc32 be applied в_
   the uncompressed данные as is готово in the zlib, gzИП, and zИП formats.  For
   most applications, the zlib форматируй should be used as is. Note that comments
   above on the use in deflateInit2() applies в_ the magnitude of windowBits.

     windowBits can also be greater than 15 for optional gzИП decoding. Добавь
   32 в_ windowBits в_ enable zlib and gzИП decoding with automatic заголовок
   detection, or добавь 16 в_ раскодируй only the gzИП форматируй (the zlib форматируй will
   return a Z_DATA_ERROR).  If a gzИП поток is being decoded, strm->adler is
   a crc32 instead of an adler32.

     inflateInit2 returns Z_OK if success, Z_MEM_ERROR if there was not enough
   память, Z_STREAM_ERROR if a parameter is не_годится (such as a пусто strm). сооб
   is установи в_ пусто if there is no ошибка сообщение.  inflateInit2 does not perform
   any decompression apart из_ reading the zlib заголовок if present: this will
   be готово by inflate(). (So next_in and avail_in may be изменён, but next_out
   and avail_out are unchanged.)
*/

цел inflateSetDictionary(z_Потокp strm,
                         Bytef*    dictionary,
                         uInt      dictLength);
/*
     Initializes the decompression dictionary из_ the given uncompressed байт
   sequence. This function must be called immediately after a вызов of inflate,
   if that вызов returned Z_NEED_DICT. The dictionary chosen by the compressor
   can be determined из_ the adler32 значение returned by that вызов of inflate.
   The compressor and decompressor must use exactly the same dictionary (see
   deflateSetDictionary).  For необр inflate, this function can be called
   immediately after inflateInit2() or inflateReset() and before any вызов of
   inflate() в_ установи the dictionary.  The application must insure that the
   dictionary that was used for compression is provопрed.

     inflateSetDictionary returns Z_OK if success, Z_STREAM_ERROR if a
   parameter is не_годится (such as NULL dictionary) or the поток состояние is
   inconsistent, Z_DATA_ERROR if the given dictionary doesn't match the
   ожидалось one (incorrect adler32 значение). inflateSetDictionary does not
   perform any decompression: this will be готово by subsequent calls of
   inflate().
*/

цел inflateSync(z_Потокp strm);
/*
    SkИПs не_годится compressed данные until a full слей point (see above the
  descrИПtion of deflate with Z_FULL_FLUSH) can be найдено, or until все
  available ввод is skИПped. No вывод is provопрed.

    inflateSync returns Z_OK if a full слей point есть been найдено, Z_BUF_ERROR
  if no ещё ввод was provопрed, Z_DATA_ERROR if no слей point есть been найдено,
  or Z_STREAM_ERROR if the поток structure was inconsistent. In the success
  case, the application may save the current current значение of total_in which
  indicates where valid compressed данные was найдено. In the ошибка case, the
  application may repeatedly вызов inflateSync, provопрing ещё ввод each время,
  until success or конец of the ввод данные.
*/

цел inflateCopy(z_Потокp приёмник,
                z_Потокp источник);
/*
     Sets the destination поток as a complete копируй of the источник поток.

     This function can be useful when randomly accessing a large поток.  The
   first пароль through the поток can periodically record the inflate состояние,
   allowing restarting inflate at those points when randomly accessing the
   поток.

     inflateCopy returns Z_OK if success, Z_MEM_ERROR if there was not
   enough память, Z_STREAM_ERROR if the источник поток состояние was inconsistent
   (such as zalloc being NULL). сооб is left unchanged in Всё источник and
   destination.
*/

цел inflateReset(z_Потокp strm);
/*
     This function is equivalent в_ inflateEnd followed by inflateInit,
   but does not free and reallocate все the internal decompression состояние.
   The поток will keep атрибуты that may have been установи by inflateInit2.

      inflateReset returns Z_OK if success, or Z_STREAM_ERROR if the источник
   поток состояние was inconsistent (such as zalloc or состояние being NULL).
*/

цел inflatePrime(z_Потокp strm,
                 цел       биты,
                 цел       значение);
/*
     This function inserts биты in the inflate ввод поток.  The intent is
  that this function is used в_ старт inflating at a bit позиция in the
  mопрdle of a байт.  The provопрed биты will be used before any байты are used
  из_ next_in.  This function should only be used with необр inflate, and
  should be used before the first inflate() вызов after inflateInit2() or
  inflateReset().  биты must be less than or equal в_ 16, and that many of the
  least significant биты of значение will be inserted in the ввод.

      inflatePrime returns Z_OK if success, or Z_STREAM_ERROR if the источник
   поток состояние was inconsistent.
*/

цел inflateGetHeader(z_Потокp  strm,
                     gz_headerp голова);
/*
      inflateGetHeader() requests that gzИП заголовок information be stored in the
   provопрed gz_header structure.  inflateGetHeader() may be called after
   inflateInit2() or inflateReset(), and before the first вызов of inflate().
   As inflate() processes the gzИП поток, голова->готово is zero until the заголовок
   is completed, at which время голова->готово is установи в_ one.  If a zlib поток is
   being decoded, then голова->готово is установи в_ -1 в_ indicate that there will be
   no gzИП заголовок information forthcoming.  Note that Z_BLOCK can be used в_
   force inflate() в_ return immediately after заголовок processing is complete
   and before any actual данные is decompressed.

      The текст, время, xflags, and os fields are filled in with the gzИП заголовок
   contents.  hcrc is установи в_ да if there is a заголовок CRC.  (The заголовок CRC
   was valid if готово is установи в_ one.)  If extra is not Z_NULL, then extra_max
   содержит the maximum число of байты в_ пиши в_ extra.  Once готово is да,
   extra_len содержит the actual extra field length, and extra содержит the
   extra field, or that field truncated if extra_max is less than extra_len.
   If имя is not Z_NULL, then up в_ name_max characters are записано there,
   terminated with a zero unless the length is greater than name_max.  If
   коммент is not Z_NULL, then up в_ comm_max characters are записано there,
   terminated with a zero unless the length is greater than comm_max.  When
   any of extra, имя, or коммент are not Z_NULL and the respective field is
   not present in the заголовок, then that field is установи в_ Z_NULL в_ signal its
   absence.  This allows the use of deflateSetHeader() with the returned
   structure в_ duplicate the заголовок.  However if those fields are установи в_
   allocated память, then the application will need в_ save those pointers
   elsewhere so that they can be eventually freed.

      If inflateGetHeader is not used, then the заголовок information is simply
   discarded.  The заголовок is always checked for validity, включая the заголовок
   CRC if present.  inflateReset() will сбрось the process в_ discard the заголовок
   information.  The application would need в_ вызов inflateGetHeader() again в_
   retrieve the заголовок из_ the следщ gzИП поток.

      inflateGetHeader returns Z_OK if success, or Z_STREAM_ERROR if the источник
   поток состояние was inconsistent.
*/

/*
цел inflateBackInit(z_Потокp strm,
                    цел       windowBits,
                    ббайт*    window);

     Initialize the internal поток состояние for decompression using inflateBack()
   calls.  The fields zalloc, zfree and opaque in strm must be инициализован
   before the вызов.  If zalloc and zfree are Z_NULL, then the default library-
   производный память allocation routines are used.  windowBits is the основа two
   logarithm of the window размер, in the range 8..15.  window is a caller
   supplied буфер of that размер.  Except for special applications where it is
   assured that deflate was used with small window sizes, windowBits must be 15
   and a 32K байт window must be supplied в_ be able в_ decompress general
   deflate Потокs.

     See inflateBack() for the usage of these routines.

     inflateBackInit will return Z_OK on success, Z_STREAM_ERROR if any of
   the paramaters are не_годится, Z_MEM_ERROR if the internal состояние could not
   be allocated, or Z_VERSION_ERROR if the version of the library does not
   match the version of the заголовок файл.
*/

alias бцел function(проц*, ббайт**)      in_func;
alias цел  function(проц*, ббайт*, бцел) out_func;

цел inflateBack(z_Потокp strm,
                in_func   in_fn,
                ук      in_desc,
                out_func  out_fn,
                ук      out_desc);
/*
     inflateBack() does a необр inflate with a single вызов using a вызов-back
   interface for ввод and вывод.  This is ещё efficient than inflate() for
   файл i/o applications in that it avoопрs copying between the вывод and the
   slопрing window by simply making the window itself the вывод буфер.  This
   function trusts the application в_ not change the вывод буфер passed by
   the вывод function, at least until inflateBack() returns.

     inflateBackInit() must be called first в_ размести the internal состояние
   and в_ инициализуй the состояние with the пользователь-provопрed window буфер.
   inflateBack() may then be used multИПle times в_ inflate a complete, необр
   deflate поток with each вызов.  inflateBackEnd() is then called в_ free
   the allocated состояние.

     A необр deflate поток is one with no zlib or gzИП заголовок or trailer.
   This routine would normally be used in a utility that reads zИП or gzИП
   файлы and writes out uncompressed файлы.  The utility would раскодируй the
   заголовок and process the trailer on its own, hence this routine expects
   only the необр deflate поток в_ decompress.  This is different из_ the
   нормаль behavior of inflate(), which expects either a zlib or gzИП заголовок and
   trailer around the deflate поток.

     inflateBack() uses two subroutines supplied by the caller that are then
   called by inflateBack() for ввод and вывод.  inflateBack() calls those
   routines until it reads a complete deflate поток and writes out все of the
   uncompressed данные, or until it encounters an ошибка.  The function's
   параметры and return типы are defined above in the in_func and out_func
   typedefs.  inflateBack() will вызов in(in_desc, &буф) which should return the
   число of байты of provопрed ввод, and a pointer в_ that ввод in буф.  If
   there is no ввод available, in() must return zero--буф is ignored in that
   case--and inflateBack() will return a буфер ошибка.  inflateBack() will вызов
   out(out_desc, буф, длин) в_ пиши the uncompressed данные буф[0..длин-1].  out()
   should return zero on success, or non-zero on failure.  If out() returns
   non-zero, inflateBack() will return with an ошибка.  Neither in() nor out()
   are permitted в_ change the contents of the window provопрed в_
   inflateBackInit(), which is also the буфер that out() uses в_ пиши из_.
   The length записано by out() will be at most the window размер.  Any non-zero
   amount of ввод may be provопрed by in().

     For convenience, inflateBack() can be provопрed ввод on the first вызов by
   настройка strm->next_in and strm->avail_in.  If that ввод is exhausted, then
   in() will be called.  Therefore strm->next_in must be инициализован before
   calling inflateBack().  If strm->next_in is Z_NULL, then in() will be called
   immediately for ввод.  If strm->next_in is not Z_NULL, then strm->avail_in
   must also be инициализован, and then if strm->avail_in is not zero, ввод will
   initially be taken из_ strm->next_in[0 .. strm->avail_in - 1].

     The in_desc and out_desc параметры of inflateBack() is passed as the
   first parameter of in() and out() respectively when they are called.  These
   descrИПtors can be optionally used в_ пароль any information that the caller-
   supplied in() and out() functions need в_ do their дело.

     On return, inflateBack() will установи strm->next_in and strm->avail_in в_
   пароль back any unused ввод that was provопрed by the последний in() вызов.  The
   return values of inflateBack() can be Z_STREAM_END on success, Z_BUF_ERROR
   if in() or out() returned an ошибка, Z_DATA_ERROR if there was a форматируй
   ошибка in the deflate поток (in which case strm->сооб is установи в_ indicate the
   nature of the ошибка), or Z_STREAM_ERROR if the поток was not properly
   инициализован.  In the case of Z_BUF_ERROR, an ввод or вывод ошибка can be
   distinguished using strm->next_in which will be Z_NULL only if in() returned
   an ошибка.  If strm->следщ is not Z_NULL, then the Z_BUF_ERROR was due в_
   out() returning non-zero.  (in() will always be called before out(), so
   strm->next_in is assured в_ be defined if out() returns non-zero.)  Note
   that inflateBack() cannot return Z_OK.
*/

цел inflateBackEnd(z_Потокp strm);
/*
     все память allocated by inflateBackInit() is freed.

     inflateBackEnd() returns Z_OK on success, or Z_STREAM_ERROR if the поток
   состояние was inconsistent.
*/

uLong zlibCompileFlags();
/* Return флаги indicating компилируй-время options.

    Тип sizes, two биты each, 00 = 16 биты, 01 = 32, 10 = 64, 11 = другой:
     1.0: размер of uInt
     3.2: размер of uLong
     5.4: размер of voопрpf (pointer)
     7.6: размер of z_off_t

    Compiler, assembler, and debug options:
     8: DEBUG
     9: ASMV or ASMINF -- use ASM код
     10: ZLIB_WINAPI -- exported functions use the WINAPI calling convention
     11: 0 (reserved)

    One-время table building (smaller код, but not нить-safe if да):
     12: BUILDFIXED -- build static block decoding tables when needed
     13: DYNAMIC_CRC_TABLE -- build CRC calculation tables when needed
     14,15: 0 (reserved)

    Library контент (indicates missing functionality):
     16: NO_GZCOMPRESS -- gz* functions cannot сожми (в_ avoопр linking
                          deflate код when not needed)
     17: NO_GZИП -- deflate can't пиши gzИП Потокs, and inflate can't detect
                    and раскодируй gzИП Потокs (в_ avoопр linking crc код)
     18-19: 0 (reserved)

    Operation variations (changes in library functionality):
     20: PKZИП_BUG_WORKAROUND -- slightly ещё permissive inflate
     21: FASTEST -- deflate algorithm with only one, lowest compression уровень
     22,23: 0 (reserved)

    The sprintf variant used by gzprintf (zero is best):
     24: 0 = vs*, 1 = s* -- 1 means limited в_ 20 аргументы after the форматируй
     25: 0 = *nprintf, 1 = *printf -- 1 means gzprintf() not безопасно!
     26: 0 = returns значение, 1 =void -- 1 means inferred ткст length returned

    Remainder:
     27-31: 0 (reserved)
 */


                        /* utility functions */

/*
     The following utility functions are implemented on top of the
   basic поток-oriented functions. To simplify the interface, some
   default options are assumed (compression уровень and память usage,
   стандарт память allocation functions). The источник код of these
   utility functions can easily be изменён if you need special options.
*/

цел сожми(Bytef*  приёмник,
             uLongf* destLen,
             Bytef*  источник,
             uLong   sourceLen);
/*
     Compresses the источник буфер преобр_в the destination буфер.  sourceLen is
   the байт length of the источник буфер. Upon Запись, destLen is the total
   размер of the destination буфер, which must be at least the значение returned
   by compressBound(sourceLen). Upon exit, destLen is the actual размер of the
   compressed буфер.
     This function can be used в_ сожми a whole файл at once if the
   ввод файл is mmap'ed.
     сожми returns Z_OK if success, Z_MEM_ERROR if there was not
   enough память, Z_BUF_ERROR if there was not enough room in the вывод
   буфер.
*/

цел compress2(Bytef*  приёмник,
              uLongf* destLen,
              Bytef*  источник,
              uLong   sourceLen,
              цел     уровень);
/*
     Compresses the источник буфер преобр_в the destination буфер. The уровень
   parameter есть the same meaning as in deflateInit.  sourceLen is the байт
   length of the источник буфер. Upon Запись, destLen is the total размер of the
   destination буфер, which must be at least the значение returned by
   compressBound(sourceLen). Upon exit, destLen is the actual размер of the
   compressed буфер.

     compress2 returns Z_OK if success, Z_MEM_ERROR if there was not enough
   память, Z_BUF_ERROR if there was not enough room in the вывод буфер,
   Z_STREAM_ERROR if the уровень parameter is не_годится.
*/

uLong compressBound(uLong sourceLen);
/*
     compressBound() returns an upper bound on the compressed размер after
   сожми() or compress2() on sourceLen байты.  It would be used before
   a сожми() or compress2() вызов в_ размести the destination буфер.
*/

цел uncompress(Bytef*  приёмник,
               uLongf* destLen,
               Bytef*  источник,
               uLong   sourceLen);
/*
     Decompresses the источник буфер преобр_в the destination буфер.  sourceLen is
   the байт length of the источник буфер. Upon Запись, destLen is the total
   размер of the destination буфер, which must be large enough в_ hold the
   entire uncompressed данные. (The размер of the uncompressed данные must have
   been saved previously by the compressor and transmitted в_ the decompressor
   by some mechanism outsопрe the scope of this compression library.)
   Upon exit, destLen is the actual размер of the compressed буфер.
     This function can be used в_ decompress a whole файл at once if the
   ввод файл is mmap'ed.

     uncompress returns Z_OK if success, Z_MEM_ERROR if there was not
   enough память, Z_BUF_ERROR if there was not enough room in the вывод
   буфер, or Z_DATA_ERROR if the ввод данные was corrupted or incomplete.
*/


typedef voопрp gzFile;

gzFile gzopen(сим* путь, сим* режим);
/*
     Opens a gzИП (.gz) файл for reading or writing. The режим parameter
   is as in fopen ("rb" or "wb") but can also include a compression уровень
   ("wb9") or a strategy: 'f' for filtered данные as in "wb6f", 'h' for
   Huffman only compression as in "wb1h", or 'R' for run-length кодировка
   as in "wb1R". (See the descrИПtion of deflateInit2 for ещё information
   about the strategy parameter.)

     gzopen can be used в_ читай a файл which is not in gzИП форматируй; in this
   case gzread will directly читай из_ the файл without decompression.

     gzopen returns NULL if the файл could not be opened or if there was
   insufficient память в_ размести the (de)compression состояние; errno
   can be checked в_ distinguish the two cases (if errno is zero, the
   zlib ошибка is Z_MEM_ERROR).  */

gzFile gzdopen(цел fd, сим* режим);
/*
     gzdopen() associates a gzFile with the файл descrИПtor fd.  Файл
   descrИПtors are obtained из_ calls like открой, dup, creat, pipe or
   fileno (in the файл есть been previously opened with fopen).
   The режим parameter is as in gzopen.
     The следщ вызов of gzclose on the returned gzFile will also закрой the
   файл descrИПtor fd, just like fclose(fdopen(fd), режим) closes the файл
   descrИПtor fd. If you want в_ keep fd открой, use gzdopen(dup(fd), режим).
     gzdopen returns NULL if there was insufficient память в_ размести
   the (de)compression состояние.
*/

цел gzsetparams(gzFile файл, цел уровень, цел strategy);
/*
     Dynamically обнови the compression уровень or strategy. See the descrИПtion
   of deflateInit2 for the meaning of these параметры.
     gzsetparams returns Z_OK if success, or Z_STREAM_ERROR if the файл was not
   opened for writing.
*/

цел gzread(gzFile файл, voопрp буф, бцел длин);
/*
     Reads the given число of uncompressed байты из_ the compressed файл.
   If the ввод файл was not in gzИП форматируй, gzread copies the given число
   of байты преобр_в the буфер.
     gzread returns the число of uncompressed байты actually читай (0 for
   конец of файл, -1 for ошибка). */

цел gzwrite(gzFile файл, voопрpc буф, бцел длин);
/*
     Writes the given число of uncompressed байты преобр_в the compressed файл.
   gzwrite returns the число of uncompressed байты actually записано
   (0 in case of ошибка).
*/

цел gzprintf (gzFile файл, сим* форматируй, ...);
/*
     Converts, formats, and writes the арги в_ the compressed файл under
   control of the форматируй ткст, as in fprintf. gzprintf returns the число of
   uncompressed байты actually записано (0 in case of ошибка).  The число of
   uncompressed байты записано is limited в_ 4095. The caller should assure that
   this предел is not exceeded. If it is exceeded, then gzprintf() will return
   return an ошибка (0) with nothing записано. In this case, there may also be a
   буфер перебор with unpredictable consequences, which is possible only if
   zlib was compiled with the insecure functions sprintf() or vsprintf()
   because the безопасно snprintf() or vsnprintf() functions were not available.
*/

цел gzputs(gzFile файл, сим* s);
/*
      Writes the given пусто-terminated ткст в_ the compressed файл, excluding
   the terminating пусто character.
      gzputs returns the число of characters записано, or -1 in case of ошибка.
*/

сим* gzgets(gzFile файл, сим* буф, цел длин);
/*
      Reads байты из_ the compressed файл until длин-1 characters are читай, or
   a нс character is читай and transferred в_ буф, or an конец-of-файл
   condition is encountered.  The ткст is then terminated with a пусто
   character.
      gzgets returns буф, or Z_NULL in case of ошибка.
*/

цел gzputc(gzFile файл, цел c);
/*
      Writes c, преобразованый в_ an unsigned сим, преобр_в the compressed файл.
   gzputc returns the значение that was записано, or -1 in case of ошибка.
*/

цел gzgetc (gzFile файл);
/*
      Reads one байт из_ the compressed файл. gzgetc returns this байт
   or -1 in case of конец of файл or ошибка.
*/

цел gzungetc(цел c, gzFile файл);
/*
      Push one character back onto the поток в_ be читай again later.
   Only one character of push-back is allowed.  gzungetc() returns the
   character pushed, or -1 on failure.  gzungetc() will краш if a
   character есть been pushed but not читай yet, or if c is -1. The pushed
   character will be discarded if the поток is repositioned with gzseek()
   or gzrewind().
*/

цел gzflush(gzFile файл, цел слей);
/*
     Flushes все pending вывод преобр_в the compressed файл. The parameter
   слей is as in the deflate() function. The return значение is the zlib
   ошибка число (see function gzerror below). gzflush returns Z_OK if
   the слей parameter is Z_FINISH and все вывод could be flushed.
     gzflush should be called only when strictly necessary because it can
   degrade compression.
*/

z_off_t gzseek (gzFile файл, z_off_t смещение, цел whence);
/*
      Sets the starting позиция for the следщ gzread or gzwrite on the
   given compressed файл. The смещение represents a число of байты in the
   uncompressed данные поток. The whence parameter is defined as in lseek(2);
   the значение SEEK_END is not supported.
     If the файл is opened for reading, this function is emulated but can be
   extremely slow. If the файл is opened for writing, only forward seeks are
   supported; gzseek then compresses a sequence of zeroes up в_ the new
   starting позиция.

      gzseek returns the resulting смещение location as measured in байты из_
   the beginning of the uncompressed поток, or -1 in case of ошибка, in
   particular if the файл is opened for writing and the new starting позиция
   would be before the current позиция.
*/

цел gzrewind(gzFile файл);
/*
     Rewinds the given файл. This function is supported only for reading.

   gzrewind(файл) is equivalent в_ (цел)gzseek(файл, 0L, SEEK_SET)
*/

z_off_t gztell (gzFile файл);
/*
     Returns the starting позиция for the следщ gzread or gzwrite on the
   given compressed файл. This позиция represents a число of байты in the
   uncompressed данные поток.

   gztell(файл) is equivalent в_ gzseek(файл, 0L, SEEK_CUR)
*/

цел gzeof(gzFile файл);
/*
     Returns 1 when EOF есть previously been detected reading the given
   ввод поток, otherwise zero.
*/

цел gzdirect(gzFile файл);
/*
     Returns 1 if файл is being читай directly without decompression, otherwise
   zero.
*/

цел gzclose(gzFile файл);
/*
     Flushes все pending вывод if necessary, closes the compressed файл
   and deallocates все the (de)compression состояние. The return значение is the zlib
   ошибка число (see function gzerror below).
*/

сим* gzerror(gzFile файл, цел* errnum);
/*
     Returns the ошибка сообщение for the последний ошибка which occurred on the
   given compressed файл. errnum is установи в_ zlib ошибка число. If an
   ошибка occurred in the файл system and not in the compression library,
   errnum is установи в_ Z_ERRNO and the application may consult errno
   в_ получи the exact ошибка код.
*/

проц gzclearerr(gzFile файл);
/*
     Clears the ошибка and конец-of-файл флаги for файл. This is analogous в_ the
   clearerr() function in stdio. This is useful for continuing в_ читай a gzИП
   файл that is being записано concurrently.
*/

                        /* checksum functions */

/*
     These functions are not related в_ compression but are exported
   anyway because they might be useful in applications using the
   compression library.
*/

uLong adler32(uLong adler, Bytef* буф, uInt длин);
/*
     Update a running Adler-32 checksum with the байты буф[0..длин-1] and
   return the updated checksum. If буф is NULL, this function returns
   the required начальное значение for the checksum.
   An Adler-32 checksum is almost as reliable as a CRC32 but can be computed
   much faster. Usage example:

     uLong adler = adler32(0L, Z_NULL, 0);

     while (read_buffer(буфер, length) != EOF) {
       adler = adler32(adler, буфер, length);
     }
     if (adler != original_adler) ошибка();
*/

uLong adler32_combine(uLong adler1, uLong adler2, z_off_t len2);
/*
     Combine two Adler-32 checksums преобр_в one.  For two sequences of байты, seq1
   and seq2 with lengths len1 and len2, Adler-32 checksums were calculated for
   each, adler1 and adler2.  adler32_combine() returns the Adler-32 checksum of
   seq1 and seq2 concatenated, requiring only adler1, adler2, and len2.
*/

uLong crc32(uLong crc, Bytef* буф, uInt длин);
/*
     Update a running CRC-32 with the байты буф[0..длин-1] and return the
   updated CRC-32. If буф is NULL, this function returns the required начальное
   значение for the for the crc. Pre- and post-conditioning (one's complement) is
   performed within this function so it shouldn't be готово by the application.
   Usage example:

     uLong crc = crc32(0L, Z_NULL, 0);

     while (read_buffer(буфер, length) != EOF) {
       crc = crc32(crc, буфер, length);
     }
     if (crc != original_crc) ошибка();
*/

uLong crc32_combine(uLong crc1, uLong crc2, z_off_t len2);

/*
     Combine two CRC-32 check values преобр_в one.  For two sequences of байты,
   seq1 and seq2 with lengths len1 and len2, CRC-32 check values were
   calculated for each, crc1 and crc2.  crc32_combine() returns the CRC-32
   check значение of seq1 and seq2 concatenated, requiring only crc1, crc2, and
   len2.
*/


                        /* various hacks, don't look :) */

/* deflateInit and inflateInit are macros в_ allow checking the zlib version
 * and the compiler's view of z_stream:
 */
цел deflateInit_(z_Потокp  strm,
                 цел        уровень,
                 сим*      ver,
                 цел        Поток_size);
цел inflateInit_(z_Потокp  strm,
                 сим*      ver,
                 цел        Поток_size);
цел deflateInit2_(z_Потокp strm,
                  цел       уровень,
                  цел       метод,
                  цел       windowBits,
                  цел       memУровень,
                  цел       strategy,
                  сим*     ver,
                  цел       Поток_size);
цел inflateInit2_(z_Потокp strm,
                  цел       windowBits,
                  сим*     ver,
                  цел       Поток_size);
цел inflateBackInit_(z_Потокp strm,
                     цел       windowBits,
                     ббайт*    window,
                     сим*     ver,
                     цел       Поток_size);

extern (D) цел deflateInit(z_Потокp  strm,
                           цел        уровень)
{
    return deflateInit_(strm,
                        уровень,
                        ZLIB_VERSION,
                        z_stream.sizeof);
}

extern (D) цел inflateInit(z_Потокp  strm)
{
    return inflateInit_(strm,
                        ZLIB_VERSION,
                        z_stream.sizeof);
}

extern (D) цел deflateInit2(z_Потокp strm,
                           цел       уровень,
                           цел       метод,
                           цел       windowBits,
                           цел       memУровень,
                           цел       strategy)
{
    return deflateInit2_(strm,
                         уровень,
                         метод,
                         windowBits,
                         memУровень,
                         strategy,
                         ZLIB_VERSION,
                         z_stream.sizeof);
}

extern (D) цел inflateInit2(z_Потокp strm,
                            цел       windowBits)
{
    return inflateInit2_(strm,
                         windowBits,
                         ZLIB_VERSION,
                         z_stream.sizeof);
}

extern (D) цел inflateBackInit(z_Потокp strm,
                               цел       windowBits,
                               ббайт*    window)
{
    return inflateBackInit_(strm,
                            windowBits,
                            window,
                            ZLIB_VERSION,
                            z_stream.sizeof);
}

сим*   zError(цел);
цел     inflateSyncPoint(z_Потокp z);
uLongf* get_crc_table();
