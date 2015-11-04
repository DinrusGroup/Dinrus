module util.container.more.HashFile;

private import io.device.FileMap : MappedFile;

/******************************************************************************

        HashFile реализует a simple mechanism в_ сохрани and recover a 
        large quantity of данные for the duration of the hosting process.
        It is intended в_ act as a local-cache for a remote данные-источник, 
        or as a spillover area for large in-память cache instances. 
        
        Note that any and все stored данные is rendered не_годится the moment
        a HashFile объект is garbage-collected.

        The implementation follows a fixed-ёмкость record scheme, where
        контент can be rewritten in-place until saопр ёмкость is reached.
        At such время, the altered контент is moved в_ a larger ёмкость
        record at конец-of-файл, and a hole remains at the prior location.
        These holes are not collected, since the lifespan of a HashFile
        is limited в_ that of the хост process.

        все индекс ключи must be unique. Writing в_ the HashFile with an
        existing ключ will overwrite any previous контент. What follows
        is a contrived example:
        
        ---
        alias HashFile!(ткст, ткст) Bucket;

        auto bucket = new Bucket ("bucket.bin", HashFile.HalfK);

        // вставь some данные, and retrieve it again
        auto текст = "this is a тест";
        bucket.помести ("a ключ", текст);
        auto b = cast(ткст) bucket.получи ("a ключ");

        assert (b == текст);
        bucket.закрой;
        ---

******************************************************************************/

class HashFile(K, V)
{
        /**********************************************************************

                Define the ёмкость (block-размер) of each record

        **********************************************************************/

        struct РазмерБлока
        {
                цел ёмкость;
        }

        // backing storage
        private MappedFile              файл;

        // память-mapped контент
        private ббайт[]                 куча;

        // basic ёмкость for each record
        private РазмерБлока               block;

        // pointers в_ файл records
        private Record[K]               карта;

        // current файл размер
        private бдол                   размерФайла;

        // current файл usage
        private бдол                   waterLine;

        // supported block sizes
        public static const РазмерБлока   EighthK  = {128-1},
                                        QuarterK = {256-1},
                                        HalfK    = {512-1},
                                        OneK     = {1024*1-1},
                                        TwoK     = {1024*2-1},
                                        FourK    = {1024*4-1},
                                        EightK   = {1024*8-1},
                                        SixteenK = {1024*16-1},
                                        ThirtyTwoK = {1024*32-1},
                                        SixtyFourK = {1024*64-1};


        /**********************************************************************

                Construct a HashFile with the provопрed путь, record-размер,
                and inital record счёт. The latter causes records в_ be 
                pre-allocated, saving a certain amount of growth activity.
                Selecting a record размер that roughly matches the serialized 
                контент will предел 'thrashing'. 

        **********************************************************************/

        this (ткст путь, РазмерБлока block, бцел initialRecords = 100)
        {
                this.block = block;

                // открой a storage файл
                файл = new MappedFile (путь);

                // установи начальное файл размер (cannot be zero)
                размерФайла = initialRecords * (block.ёмкость + 1);

                // карта the файл контент
                куча = файл.resize (размерФайла);
        }

        /**********************************************************************
        
                Return where the HashFile is located

        **********************************************************************/

        final ткст путь ()
        {
                return файл.путь;
        }

        /**********************************************************************

                Return the currently populated размер of this HashFile

        **********************************************************************/

        final бдол length ()
        {
                return waterLine;
        }

        /**********************************************************************

                Return the serialized данные for the provопрed ключ. Returns
                пусто if the ключ was не найден.

                Be sure в_ synchronize access by multИПle threads

        **********************************************************************/

        final V получи (K ключ, бул сотри = нет)
        {
                auto p = ключ in карта;

                if (p)
                    return p.читай (this, сотри);
                return V.init;
        }

        /**********************************************************************

                Удали the provопрed ключ из_ this HashFile. Leaves a 
                hole in the backing файл

                Be sure в_ synchronize access by multИПle threads

        **********************************************************************/

        final проц удали (K ключ)
        {
                карта.удали (ключ);
        }

        /**********************************************************************

                Write a serialized block of данные, and associate it with
                the provопрed ключ. все ключи must be unique, and it is the
                responsibility of the programmer в_ ensure this. Reusing 
                an existing ключ will overwrite previous данные. 

                Note that данные is allowed в_ grow within the occupied 
                bucket until it becomes larger than the allocated пространство.
                When this happens, the данные is moved в_ a larger bucket
                at the файл хвост.

                Be sure в_ synchronize access by multИПle threads

        **********************************************************************/

        final проц помести (K ключ, V данные, K function(K) retain = пусто)
        {
                auto r = ключ in карта;
                
                if (r)
                    r.пиши (this, данные, block);
                else
                   {
                   Record rr;
                   rr.пиши (this, данные, block);
                   if (retain)
                       ключ = retain (ключ);
                   карта [ключ] = rr;
                   }
        }

        /**********************************************************************

                Close this HashFile -- все контент is lost.

        **********************************************************************/

        final проц закрой ()
        {
                if (файл)
                   {
                   файл.закрой;
                   файл = пусто;
                   карта = пусто;
                   }
        }

        /**********************************************************************

                Each Record takes up a число of 'pages' within the файл. 
                The размер of these pages is determined by the РазмерБлока 
                provопрed during HashFile construction. добавьitional пространство
                at the конец of each block is potentially wasted, but enables 
                контент в_ grow in размер without creating a myriad of holes.

        **********************************************************************/

        private struct Record
        {
                private бдол           смещение;
                private цел             used,
                                        ёмкость = -1;

                /**************************************************************

                        This should be protected из_ нить-contention at
                        a higher уровень.

                **************************************************************/

                V читай (HashFile bucket, бул сотри)
                {
                        if (used)
                           {
                           auto ret = cast(V) bucket.куча [смещение .. смещение + used];
                           if (сотри)
                               used = 0;
                           return ret;
                           }
                        return V.init;
                }

                /**************************************************************

                        This should be protected из_ нить-contention at
                        a higher уровень.

                **************************************************************/

                проц пиши (HashFile bucket, V данные, РазмерБлока block)
                {
                        this.used = данные.length;

                        // создай new slot if we exceed ёмкость
                        if (this.used > this.ёмкость)
                            createBucket (bucket, this.used, block);

                        bucket.куча [смещение .. смещение+used] = cast(ббайт[]) данные;
                }

                /**************************************************************

                **************************************************************/

                проц createBucket (HashFile bucket, цел байты, РазмерБлока block)
                {
                        this.смещение = bucket.waterLine;
                        this.ёмкость = (байты + block.ёмкость) & ~block.ёмкость;
                        
                        bucket.waterLine += this.ёмкость;
                        if (bucket.waterLine > bucket.размерФайла)
                           {
                           auto мишень = bucket.waterLine * 2;
                           debug(HashFile) 
                                 printf ("growing файл из_ %lld, %lld, в_ %lld\n", 
                                          bucket.размерФайла, bucket.waterLine, мишень);

                           // расширь the physical файл размер and remap the куча
                           bucket.куча = bucket.файл.resize (bucket.размерФайла = мишень);
                           }
                }
        }
}


/******************************************************************************

******************************************************************************/

debug (HashFile)
{
        extern(C) цел printf (сим*, ...);

        import io.Path;
        import io.Stdout;
        import text.convert.Integer;

        проц main()
        {
                alias HashFile!(ткст, ткст) Bucket;

                auto файл = new Bucket ("foo.карта", Bucket.QuarterK, 1);
        
                сим[16] врем;
                for (цел i=1; i < 1024; ++i)
                     файл.помести (форматируй(врем, i).dup, "blah");

                auto s = файл.получи ("1", да);
                if (s.length)
                    Стдвыв.форматнс ("результат '{}'", s);
                s = файл.получи ("1");
                if (s.length)
                    Стдвыв.форматнс ("результат '{}'", s);
                файл.закрой;
                удали ("foo.карта");
        }
}
