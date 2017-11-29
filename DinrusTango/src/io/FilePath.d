/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Oct 2004: Initial version
        version:        Nov 2006: Australian version
        version:        Feb 2007: Mutating version
        version:        Mar 2007: Folded FileProxy in
        version:        Nov 2007: VFS dictates '/' always be used
        version:        Feb 2008: разбей файл-system calls преобр_в a struct

        author:         Kris

        ФПуть provопрes a means в_ efficiently edit путь components and 
        of accessing the underlying файл system.

        Use module Путь.d instead when you need pedestrian access в_ the
        файл-system, and are not mutating the путь components themselves

*******************************************************************************/

module io.FilePath;

private import  io.Path;

private import  io.model: ФайлКонст, ИнфОФайле;

private import cidrus: memmove;

/*******************************************************************************

        Models a файл путь. These are ожидалось в_ be used as the constructor
        аргумент в_ various файл classes. The intention is that they easily
        преобразуй в_ другой representations such as абсолютный, canonical, or Url.

        Файл пути containing non-ansi characters should be UTF-8 кодирован.
        Supporting Unicode in this manner was deemed в_ be ещё suitable
        than provопрing a шим version of ФПуть, and is Всё consistent
        & compatible with the approach taken with the Уир class.

        ФПуть is designed в_ be transformed, thus each mutating метод
        modifies the internal контент. See module Путь.d for a lightweight
        immutable variation.

        Note that образцы of adjacent '.' разделители are treated specially
        in that they will be assigned в_ the имя where there is no distinct
        суффикс. In добавьition, a '.' at the старт of a имя signifies it does 
        not belong в_ the суффикс i.e. ".файл" is a имя rather than a суффикс.
        Образцы of intermediate '.' characters will otherwise be assigned
        в_ the суффикс, such that "файл....суффикс" включает the dots within
        the суффикс itself. See метод расш() for a суффикс without dots.

        Note that Win32 '\' characters are преобразованый в_ '/' by default via
        the ФПуть constructor.

*******************************************************************************/


class ФПуть : ПросмотрПути
{
        private ПутеПарсер      p;              // the разобрано путь
        private бул            dir_;           // this represents a Пап?

        public alias    добавь  opCatAssign;    // путь ~= x;


        /***********************************************************************

                Фильтр used for screening пути via вСписок()

        ***********************************************************************/

        public alias бул delegate (ФПуть, бул) Фильтр;

        /***********************************************************************

                Вызов-site shortcut в_ создай a ФПуть экземпляр. This
                enables the same syntax as struct usage, so may expose
                a migration путь

        ***********************************************************************/


        static ФПуть opCall (ткст фпуть = пусто)
        {
                return new ФПуть (фпуть);
        }

        /***********************************************************************

                Create a ФПуть из_ a копируй of the provопрed ткст.

                ФПуть assumes Всё путь & имя are present, and therefore
                may разбей what is otherwise a logically valid путь. That is,
                the 'имя' of a файл is typically the путь segment following
                a rightmost путь-разделитель. The intent is в_ treat файлы and
                directories in the same manner; as a имя with an optional
                ancestral structure. It is possible в_ bias the interpretation
                by добавим a trailing путь-разделитель в_ the аргумент. Doing so
                will результат in an пустой имя attribute.

                With regard в_ the фпуть копируй, we найдено the common case в_
                be an explicit .dup, whereas aliasing appeared в_ be rare by
                сравнение. We also noted a large proportion interacting with
                C-oriented OS calls, implying the postfix of a пусто terminator.
                Thus, ФПуть combines Всё as a single operation.

                Note that Win32 '\' characters are normalized в_ '/' instead.

        ***********************************************************************/

        this (ткст фпуть = пусто)
        {
                установи (фпуть, да);
        }
        
        /***********************************************************************

                Return the complete текст of this фпуть

        ***********************************************************************/

        final ткст вТкст ()
        {
                return  p.вТкст;
        }

        /***********************************************************************

                Duplicate this путь

        ***********************************************************************/

        final ФПуть dup ()
        {
                return ФПуть (вТкст);
        }

        /***********************************************************************

                Return the complete текст of this фпуть as a пусто
                terminated ткст for use with a C api. Use вТкст
                instead for any D api.

                Note that the nul is always embedded within the ткст
                maintained by ФПуть, so there's no куча overhead when
                making a C вызов

        ***********************************************************************/

        final ткст сиТкст ()
        {
                return p.fp [0 .. p.end_+1];
        }

        /***********************************************************************

                Return the корень of this путь. Roots are constructs such as
                "c:"

        ***********************************************************************/

        final ткст корень ()
        {
                return p.корень;
        }

        /***********************************************************************

                Return the файл путь. Paths may старт and конец with a "/".
                The корень путь is "/" and an unspecified путь is returned as
                an пустой ткст. Directory пути may be разбей such that the
                дир имя is placed преобр_в the 'имя' member; дир
                пути are treated no differently than файл пути

        ***********************************************************************/

        final ткст папка ()
        {
                return p.папка;
        }

        /***********************************************************************

                Returns a путь representing the предок of this one. This
                will typically return the current путь component, though
                with a special case where the имя component is пустой. In 
                such cases, the путь is scanned for a prior segment:
                ---
                нормаль:  /x/y/z => /x/y
                special: /x/y/  => /x
                ---

                Note that this returns a путь suitable for splitting преобр_в
                путь and имя components (there's no trailing разделитель).

                See вынь() also, which is generally ещё useful when working
                with ФПуть instances

        ***********************************************************************/

        final ткст предок ()
        {
                return p.предок;
        }

        /***********************************************************************

                Return the имя of this файл, or дир.

        ***********************************************************************/

        final ткст имя ()
        {
                return p.имя;
        }

        /***********************************************************************

                Ext is the хвост of the имяф, rightward of the rightmost
                '.' разделитель e.g. путь "foo.bar" есть расш "bar". Note that
                образцы of adjacent разделители are treated specially; for
                example, ".." will wind up with no расш at все

        ***********************************************************************/

        final ткст расш ()
        {
                return p.расш;
        }

        /***********************************************************************

                Suffix is like расш, but включает the разделитель e.g. путь
                "foo.bar" есть суффикс ".bar"

        ***********************************************************************/

        final ткст суффикс ()
        {
                return p.суффикс;
        }

        /***********************************************************************

                return the корень + папка combination

        ***********************************************************************/

        final ткст путь ()
        {
                return p.путь;
        }

        /***********************************************************************

                return the имя + суффикс combination

        ***********************************************************************/

        final ткст файл ()
        {
                return p.файл;
        }

        /***********************************************************************

                Returns да if все fields are опрentical. Note that some 
                combinations of operations may not произведи an опрentical
                установи of fields. For example:
                ---
                ФПуть("/foo").добавь("bar").вынь == "/foo";
                ФПуть("/foo/").добавь("bar").вынь != "/foo/";
                ---

                The latter is different due в_ variance in как добавь
                injects данные, and как вынь is ожидалось в_ operate under 
                different circumstances (Всё examples произведи the same 
                вынь результат, although the начальное путь is not опрentical).

                However, opEquals() can overlook minor distinctions such
                as this example, and will return a match.

        ***********************************************************************/

        final override цел opEquals (Объект o)
        {
                return (this is o) || (o && opEquals(o.вТкст));
        }

        /***********************************************************************

                Does this ФПуть match the given текст? Note that some 
                combinations of operations may not произведи an опрentical
                установи of fields. For example:
                ---
                ФПуть("/foo").добавь("bar").вынь == "/foo";
                ФПуть("/foo/").добавь("bar").вынь != "/foo/";
                ---

                The latter Is Different due в_ variance in как добавь
                injects данные, and как вынь is ожидалось в_ operate under 
                different circumstances (Всё examples произведи the same 
                вынь результат, although the начальное путь is not опрentical).

                However, opEquals() can overlook minor distinctions such
                as this example, and will return a match.

        ***********************************************************************/

        final цел opEquals (ткст s)
        {
                return p.opEquals(s);
        }

        /***********************************************************************

                Returns да if this ФПуть is *not* relative в_ the
                current working дир

        ***********************************************************************/

        final бул абс_ли ()
        {
                return p.абс_ли;
        }

        /***********************************************************************

                Returns да if this ФПуть is пустой

        ***********************************************************************/

        final бул пуст_ли ()
        {
                return p.пуст_ли;
        }

        /***********************************************************************

                Returns да if this ФПуть есть a предок. Note that a
                предок is defined by the presence of a путь-разделитель in
                the путь. This means 'foo' within "\foo" is consопрered a
                ветвь of the корень

        ***********************************************************************/

        final бул ветвь_ли ()
        {
                return p.ветвь_ли;
        }

        /***********************************************************************

                Замени все 'из_' instances with 'в_'

        ***********************************************************************/

        final ФПуть замени (сим из_, сим в_)
        {
                .замени (путь, из_, в_);
                return this;
        }

        /***********************************************************************

                Convert путь разделители в_ a стандарт форматируй, using '/' as
                the путь разделитель. This is compatible with URI and все of 
                the contemporary O/S which Dinrus supports. Known exceptions
                include the Windows команда-строка процессор, which consопрers
                '/' characters в_ be switches instead. Use the исконный()
                метод в_ support that.

                Note: mutates the current путь.

        ***********************************************************************/

        final ФПуть стандарт ()
        {
                .стандарт (путь);
                return this;
        }

        /***********************************************************************

                Convert в_ исконный O/S путь разделители where that is required,
                such as when dealing with the Windows команда-строка. 
                
                Note: mutates the current путь. Use this образец в_ obtain a 
                копируй instead: путь.dup.исконный

        ***********************************************************************/

        final ФПуть исконный ()
        {
                .исконный (путь);
                return this;
        }

        /***********************************************************************

                Concatenate текст в_ this путь; no разделители are добавьed.
                See объедини() also

        ***********************************************************************/

        final ФПуть склей (ткст[] другие...)
        {
                foreach (другой; другие)
                        {
                        auto длин = p.end_ + другой.length;
                        расширь (длин);
                        p.fp [p.end_ .. длин] = другой;
                        p.fp [длин] = 0;
                        p.end_ = длин;
                        }
                return разбор;
        }

        /***********************************************************************

                Append a папка в_ this путь. A leading разделитель is добавьed
                as required

        ***********************************************************************/

        final ФПуть добавь (ткст путь)
        {
                if (файл.length)
                    путь = псеп_в_начале (путь);
                return склей (путь);
        }

        /***********************************************************************

                Prepend a папка в_ this путь. A trailing разделитель is добавьed
                if needed

        ***********************************************************************/

        final ФПуть приставь (ткст путь)
        {
                исправь (0, p.folder_, p.folder_, псеп_в_конце (путь));
                return разбор;
        }

        /***********************************************************************

                Reset the контент of this путь в_ that of другой and
                reparse

        ***********************************************************************/

        ФПуть установи (ФПуть путь)
        {
                return установи (путь.вТкст, нет);
        }

        /***********************************************************************

                Reset the контент of this путь, and reparse. There's an
                optional булево flag в_ преобразуй the путь преобр_в стандарт
                form, before parsing (converting '\' преобр_в '/')

        ***********************************************************************/

        final ФПуть установи (ткст путь, бул преобразуй = нет)
        {
                p.end_ = путь.length;

                расширь (p.end_);
                if (p.end_)
                   {
                   p.fp[0 .. p.end_] = путь;
                   if (преобразуй)
                       .стандарт (p.fp [0 .. p.end_]);
                   }

                p.fp[p.end_] = '\0';
                return разбор;
        }

        /***********************************************************************

                Sопрestep the нормаль отыщи for пути that are known в_
                be папки. Where папка is да, файл-system lookups
                will be skИПped.

        ***********************************************************************/

        final ФПуть папка_ли (бул папка)
        {
                dir_ = папка;
                return this;
        }

        /***********************************************************************

                Замени the корень portion of this путь

        ***********************************************************************/

        final ФПуть корень (ткст другой)
        {
                auto x = исправь (0, p.folder_, p.folder_, псеп_в_конце (другой, ':'));
                p.folder_ += x;
                p.suffix_ += x;
                p.name_ += x;
                return this;
        }

        /***********************************************************************

                Замени the папка portion of this путь. The папка will be
                псеп_в_конце with a путь-разделитель as required

        ***********************************************************************/

        final ФПуть папка (ткст другой)
        {
                auto x = исправь (p.folder_, p.name_, p.name_ - p.folder_, псеп_в_конце (другой));
                p.suffix_ += x;
                p.name_ += x;
                return this;
        }

        /***********************************************************************

                Замени the имя portion of this путь

        ***********************************************************************/

        final ФПуть имя (ткст другой)
        {
                auto x = исправь (p.name_, p.suffix_, p.suffix_ - p.name_, другой);
                p.suffix_ += x;
                return this;
        }

        /***********************************************************************

                Замени the суффикс portion of this путь. The суффикс will be
                псеп_в_начале with a файл-разделитель as required

        ***********************************************************************/

        final ФПуть суффикс (ткст другой)
        {
                исправь (p.suffix_, p.end_, p.end_ - p.suffix_, псеп_в_начале (другой, '.'));
                return this;
        }

        /***********************************************************************

                Замени the корень and папка portions of this путь and
                reparse. The replacement will be псеп_в_конце with a путь
                разделитель as required

        ***********************************************************************/

        final ФПуть путь (ткст другой)
        {
                исправь (0, p.name_, p.name_, псеп_в_конце (другой));
                return разбор;
        }

        /***********************************************************************

                Замени the файл and суффикс portions of this путь and
                reparse. The replacement will be псеп_в_начале with a суффикс
                разделитель as required

        ***********************************************************************/

        final ФПуть файл (ткст другой)
        {
                исправь (p.name_, p.end_, p.end_ - p.name_, другой);
                return разбор;
        }

        /***********************************************************************

                Pop в_ the предок of the current фпуть (in situ - mutates
                this ФПуть). Note that this differs из_ предок() in that
                it does not include any special cases

        ***********************************************************************/

        final ФПуть вынь ()
        {       
                version (SpecialPop)
                         p.end_ = p.предок.length;
                   else
                      p.end_ = p.вынь.length;
                p.fp[p.end_] = '\0';
                return разбор;
        }

        /***********************************************************************

                Join a установи of путь specs together. A путь разделитель is
                potentially inserted between each of the segments.

        ***********************************************************************/

        static ткст объедини (ткст[] пути...)
        {
                return ФС.объедини (пути);
        }

        /***********************************************************************

                Convert this ФПуть в_ абсолютный форматируй, using the given
                префикс as necessary. If this ФПуть is already абсолютный,
                return it intact.

                Returns this ФПуть, adjusted as necessary

        ***********************************************************************/

        final ФПуть абсолютный (ткст префикс)
        {
                if (! абс_ли)
                      приставь (псеп_в_конце(префикс));
                return this;
        }

        /***********************************************************************

                Return an adjusted путь such that non-пустой instances do not
                have a trailing разделитель

        ***********************************************************************/

        static ткст очищенный (ткст путь, сим c = ФайлКонст.СимПутьРазд)
        {
                return ФС.очищенный (путь, c);
        }

        /***********************************************************************

                Return an adjusted путь such that non-пустой instances always
                have a trailing разделитель

        ***********************************************************************/

        static ткст псеп_в_конце (ткст путь, сим c = ФайлКонст.СимПутьРазд)
        {
                return ФС.псеп_в_конце (путь, c);
        }

        /***********************************************************************

                Return an adjusted путь such that non-пустой instances always
                have a псеп_в_начале разделитель

        ***********************************************************************/

        static ткст псеп_в_начале (ткст s, сим c = ФайлКонст.СимПутьРазд)
        {
                if (s.length && s[0] != c)
                    s = c ~ s;
                return s;
        }

        /***********************************************************************

                Parse the путь spec, and mutate '\' преобр_в '/' as necessary

        ***********************************************************************/

        private final ФПуть разбор ()
        {
                p.разбор (p.fp, p.end_);
                return this;
        }

        /***********************************************************************

                Potentially сделай room for ещё контент

        ***********************************************************************/

        private final проц расширь (бцел размер)
        {
                ++размер;
                if (p.fp.length < размер)
                    p.fp.length = (размер + 127) & ~127;
        }

        /***********************************************************************

                Insert/delete internal контент

        ***********************************************************************/

        private final цел исправь (цел голова, цел хвост, цел длин, ткст sub)
        {
                длин = sub.length - длин;

                // don't destroy сам-references!
                if (длин && sub.ptr >= p.fp.ptr+голова+длин && sub.ptr < p.fp.ptr+p.fp.length)
                   {
                   сим[512] врем =void;
                   assert (sub.length < врем.length);
                   sub = врем[0..sub.length] = sub;
                   }

                // сделай some room if necessary
                расширь (длин + p.end_);

                // slопрe хвост around в_ вставь or удали пространство
                memmove (p.fp.ptr+хвост+длин, p.fp.ptr+хвост, p.end_ +1 - хвост);

                // копируй replacement
                memmove (p.fp.ptr + голова, sub.ptr, sub.length);

                // исправь length
                p.end_ += длин;
                return длин;
        }


        /**********************************************************************/
        /********************** файл-system methods ***************************/
        /**********************************************************************/


        /***********************************************************************

                Create an entire путь consisting of this папка along with
                все предок папки. The путь must not contain '.' or '..'
                segments. Related methods include PathUtil.нормализуй() and
                абсолютный()

                Note that each segment is создан as a папка, включая the
                trailing segment.

                Возвращает: a chaining reference (this)

                Throws: ВВИскл upon systen ошибки

                Throws: ИсклНелегальногоАргумента if a segment есть_ли but as 
                a файл instead of a папка

        ***********************************************************************/

        final ФПуть создай ()
        {       
                создайПуть (this.вТкст);
                return this;
        }

        /***********************************************************************

                List the установи of filenames within this папка, using
                the provопрed фильтр в_ control the список:
                ---
                бул delegate (ФПуть путь, бул папка_ли) Фильтр
                ---

                Returning да из_ the фильтр включает the given путь,
                whilst returning нет excludes it. Parameter 'папка_ли'
                indicates whether the путь is a файл or папка.

                Note that пути composed of '.' characters are ignored.

        ***********************************************************************/

        final ФПуть[] вСписок (Фильтр фильтр = пусто)
        {
                ФПуть[] пути;

                foreach (инфо; this)
                        {
                        auto p = из_ (инфо);

                        // тест this Запись for inclusion
                        if (фильтр is пусто || фильтр (p, инфо.папка))
                            пути ~= p;
                        else
                           delete p;
                        }
                return пути;
        }

        /***********************************************************************

                Construct a ФПуть из_ the given ИнфОФайле

        ***********************************************************************/

        static ФПуть из_ (ref ИнфОФайле инфо)
        {
                сим[512] врем =void;

                auto длин = инфо.путь.length + инфо.имя.length;
                assert (врем.length - длин > 1);

                // construct full pathname
                врем [0 .. инфо.путь.length] = инфо.путь;
                врем [инфо.путь.length .. длин] = инфо.имя;
                return ФПуть(врем[0 .. длин]).папка_ли(инфо.папка);
        }

        /***********************************************************************

                Does this путь currently exist?

        ***********************************************************************/

        final бул есть_ли ()
        {
                return ФС.есть_ли (сиТкст);
        }

        /***********************************************************************

                Returns the время of the последний modification. Accurate
                в_ whatever the OS supports, and in a форматируй dictated
                by the файл-system. For example NTFS keeps UTC время, 
                while FAT timestamps are based on the local время. 

        ***********************************************************************/

        final Время изменён ()
        {
                return штампыВремени.изменён;
        }

        /***********************************************************************

                Returns the время of the последний access. Accurate в_
                whatever the OS supports, and in a форматируй dictated
                by the файл-system. For example NTFS keeps UTC время, 
                while FAT timestamps are based on the local время.

        ***********************************************************************/

        final Время использовался ()
        {
                return штампыВремени.использовался;
        }

        /***********************************************************************

                Returns the время of файл creation. Accurate в_
                whatever the OS supports, and in a форматируй dictated
                by the файл-system. For example NTFS keeps UTC время,  
                while FAT timestamps are based on the local время.

        ***********************************************************************/

        final Время создан ()
        {
                return штампыВремени.создан;
        }

        /***********************************************************************

                change the имя or location of a файл/дир, and
                adopt the provопрed Путь

        ***********************************************************************/

        final ФПуть переименуй (ФПуть приёмн)
        {
                ФС.переименуй (сиТкст, приёмн.сиТкст);
                return this.установи (приёмн);
        }

        /***********************************************************************

                Transfer the контент of другой файл в_ this one. Returns a
                reference в_ this class on success, or throws an ВВИскл
                upon failure.

        ***********************************************************************/

        final ФПуть копируй (ткст источник)
        {
                ФС.копируй (источник~'\0', сиТкст);
                return this;
        }

        /***********************************************************************

                Return the файл length (in байты)

        ***********************************************************************/

        final бдол размерФайла ()
        {
                return ФС.размерФайла (сиТкст);
        }

        /***********************************************************************

                Is this файл записываемый?

        ***********************************************************************/

        final бул записываем_ли ()
        {
                return ФС.записываем_ли (сиТкст);
        }

        /***********************************************************************

                Is this файл actually a папка/дир?

        ***********************************************************************/

        final бул папка_ли ()
        {
                if (dir_)
                    return да;

                return ФС.папка_ли (сиТкст);
        }

        /***********************************************************************

                Is this a regular файл?

        ***********************************************************************/

        final бул файл_ли ()
        {
                if (dir_)
                    return нет;

                return ФС.файл_ли (сиТкст);
        }

        /***********************************************************************

                Return timestamp information

                Timstamps are returns in a форматируй dictated by the 
                файл-system. For example NTFS keeps UTC время, 
                while FAT timestamps are based on the local время

        ***********************************************************************/

        final Штампы штампыВремени ()
        {
                return ФС.штампыВремени (сиТкст);
        }

        /***********************************************************************

                Transfer the контент of другой файл в_ this one. Returns a
                reference в_ this class on success, or throws an ВВИскл
                upon failure.

        ***********************************************************************/

        final ФПуть копируй (ФПуть ист)
        {
                ФС.копируй (ист.сиТкст, сиТкст);
                return this;
        }

        /***********************************************************************

                Удали the файл/дир из_ the файл-system

        ***********************************************************************/

        final ФПуть удали ()
        {      
                ФС.удали (сиТкст);
                return this;
        }

        /***********************************************************************

               change the имя or location of a файл/дир, and
               adopt the provопрed Путь

        ***********************************************************************/

        final ФПуть переименуй (ткст приёмн)
        {
                ФС.переименуй (сиТкст, приёмн~'\0');
                return this.установи (приёмн, да);
        }

        /***********************************************************************

                Create a new файл

        ***********************************************************************/

        final ФПуть создайФайл ()
        {
                ФС.создайФайл (сиТкст);
                return this;
        }

        /***********************************************************************

                Create a new дир

        ***********************************************************************/

        final ФПуть создайПапку ()
        {
                ФС.создайПапку (сиТкст);
                return this;
        }

        /***********************************************************************

                List the установи of filenames within this папка.

                Each путь and имяф is passed в_ the provопрed
                delegate, along with the путь префикс and whether
                the Запись is a папка or not.

                Returns the число of файлы scanned.

        ***********************************************************************/

        final цел opApply (цел delegate(ref ИнфОФайле) дг)
        {
                return ФС.список (сиТкст, дг);
        }
}



/*******************************************************************************

*******************************************************************************/

interface ПросмотрПути
{
        alias ФС.Штампы         Штампы;
        //alias ФС.ИнфОФайле       ИнфОФайле;

        /***********************************************************************

                Return the complete текст of this фпуть

        ***********************************************************************/

        abstract ткст вТкст ();

        /***********************************************************************

                Return the complete текст of this фпуть

        ***********************************************************************/

        abstract ткст сиТкст ();

        /***********************************************************************

                Return the корень of this путь. Roots are constructs such as
                "c:"

        ***********************************************************************/

        abstract ткст корень ();

        /***********************************************************************

                Return the файл путь. Paths may старт and конец with a "/".
                The корень путь is "/" and an unspecified путь is returned as
                an пустой ткст. Directory пути may be разбей such that the
                дир имя is placed преобр_в the 'имя' member; дир
                пути are treated no differently than файл пути

        ***********************************************************************/

        abstract ткст папка ();

        /***********************************************************************

                Return the имя of this файл, or дир, excluding a
                суффикс.

        ***********************************************************************/

        abstract ткст имя ();

        /***********************************************************************

                Ext is the хвост of the имяф, rightward of the rightmost
                '.' разделитель e.g. путь "foo.bar" есть расш "bar". Note that
                образцы of adjacent разделители are treated specially; for
                example, ".." will wind up with no расш at все

        ***********************************************************************/

        abstract ткст расш ();

        /***********************************************************************

                Suffix is like расш, but включает the разделитель e.g. путь
                "foo.bar" есть суффикс ".bar"

        ***********************************************************************/

        abstract ткст суффикс ();

        /***********************************************************************

                return the корень + папка combination

        ***********************************************************************/

        abstract ткст путь ();

        /***********************************************************************

                return the имя + суффикс combination

        ***********************************************************************/

        abstract ткст файл ();

        /***********************************************************************

                Returns да if this ФПуть is *not* relative в_ the
                current working дир.

        ***********************************************************************/

        abstract бул абс_ли ();

        /***********************************************************************

                Returns да if this ФПуть is пустой

        ***********************************************************************/

        abstract бул пуст_ли ();

        /***********************************************************************

                Returns да if this ФПуть есть a предок

        ***********************************************************************/

        abstract бул ветвь_ли ();

        /***********************************************************************

                Does this путь currently exist?

        ***********************************************************************/

        abstract бул есть_ли ();

        /***********************************************************************

                Returns the время of the последний modification. Accurate
                в_ whatever the OS supports

        ***********************************************************************/

        abstract Время изменён ();

        /***********************************************************************

                Returns the время of the последний access. Accurate в_
                whatever the OS supports

        ***********************************************************************/

        abstract Время использовался ();

        /***********************************************************************

                Returns the время of файл creation. Accurate в_
                whatever the OS supports

        ***********************************************************************/

        abstract Время создан ();

        /***********************************************************************

                Return the файл length (in байты)

        ***********************************************************************/

        abstract бдол размерФайла ();

        /***********************************************************************

                Is this файл записываемый?

        ***********************************************************************/

        abstract бул записываем_ли ();

        /***********************************************************************

                Is this файл actually a папка/дир?

        ***********************************************************************/

        abstract бул папка_ли ();

        /***********************************************************************

                Return timestamp information

        ***********************************************************************/

        abstract Штампы штампыВремени ();
}





/*******************************************************************************

*******************************************************************************/

debug (UnitTest)
{
        unittest
        {
                version(Win32)
                {
                assert (ФПуть("/foo").добавь("bar").вынь == "/foo");
                assert (ФПуть("/foo/").добавь("bar").вынь == "/foo");

                auto fp = new ФПуть(r"C:/home/foo/bar");
                fp ~= "john";
                assert (fp == r"C:/home/foo/bar/john");
                fp.установи (r"C:/");
                fp ~= "john";
                assert (fp == r"C:/john");
                fp.установи("foo.bar");
                fp ~= "john";
                assert (fp == r"foo.bar/john");
                fp.установи("");
                fp ~= "john";
                assert (fp == r"john");

                fp.установи(r"C:/home/foo/bar/john/foo.d");
                assert (fp.вынь == r"C:/home/foo/bar/john");
                assert (fp.вынь == r"C:/home/foo/bar");
                assert (fp.вынь == r"C:/home/foo");
                assert (fp.вынь == r"C:/home");
                assert (fp.вынь == r"C:");
                assert (fp.вынь == r"C:");
        
                // special case for popping пустой names
                fp.установи (r"C:/home/foo/bar/john/");
                assert (fp.предок == r"C:/home/foo/bar");

                fp = new ФПуть;
                fp.установи (r"C:/home/foo/bar/john/");
                assert (fp.абс_ли);
                assert (fp.имя == "");
                assert (fp.папка == r"/home/foo/bar/john/");
                assert (fp == r"C:/home/foo/bar/john/");
                assert (fp.путь == r"C:/home/foo/bar/john/");
                assert (fp.файл == r"");
                assert (fp.суффикс == r"");
                assert (fp.корень == r"C:");
                assert (fp.расш == "");
                assert (fp.ветвь_ли);

                fp = new ФПуть(r"C:/home/foo/bar/john");
                assert (fp.абс_ли);
                assert (fp.имя == "john");
                assert (fp.папка == r"/home/foo/bar/");
                assert (fp == r"C:/home/foo/bar/john");
                assert (fp.путь == r"C:/home/foo/bar/");
                assert (fp.файл == r"john");
                assert (fp.суффикс == r"");
                assert (fp.расш == "");
                assert (fp.ветвь_ли);

                fp.вынь;
                assert (fp.абс_ли);
                assert (fp.имя == "bar");
                assert (fp.папка == r"/home/foo/");
                assert (fp == r"C:/home/foo/bar");
                assert (fp.путь == r"C:/home/foo/");
                assert (fp.файл == r"bar");
                assert (fp.суффикс == r"");
                assert (fp.расш == "");
                assert (fp.ветвь_ли);

                fp.вынь;
                assert (fp.абс_ли);
                assert (fp.имя == "foo");
                assert (fp.папка == r"/home/");
                assert (fp == r"C:/home/foo");
                assert (fp.путь == r"C:/home/");
                assert (fp.файл == r"foo");
                assert (fp.суффикс == r"");
                assert (fp.расш == "");
                assert (fp.ветвь_ли);

                fp.вынь;
                assert (fp.абс_ли);
                assert (fp.имя == "home");
                assert (fp.папка == r"/");
                assert (fp == r"C:/home");
                assert (fp.путь == r"C:/");
                assert (fp.файл == r"home");
                assert (fp.суффикс == r"");
                assert (fp.расш == "");
                assert (fp.ветвь_ли);

                fp = new ФПуть(r"foo/bar/john.doe");
                assert (!fp.абс_ли);
                assert (fp.имя == "john");
                assert (fp.папка == r"foo/bar/");
                assert (fp.суффикс == r".doe");
                assert (fp.файл == r"john.doe");
                assert (fp == r"foo/bar/john.doe");
                assert (fp.расш == "doe");
                assert (fp.ветвь_ли);

                fp = new ФПуть(r"c:doe");
                assert (fp.абс_ли);
                assert (fp.суффикс == r"");
                assert (fp == r"c:doe");
                assert (fp.папка == r"");
                assert (fp.имя == "doe");
                assert (fp.файл == r"doe");
                assert (fp.расш == "");
                assert (!fp.ветвь_ли);

                fp = new ФПуть(r"/doe");
                assert (fp.абс_ли);
                assert (fp.суффикс == r"");
                assert (fp == r"/doe");
                assert (fp.имя == "doe");
                assert (fp.папка == r"/");
                assert (fp.файл == r"doe");
                assert (fp.расш == "");
                assert (fp.ветвь_ли);

                fp = new ФПуть(r"john.doe.foo");
                assert (!fp.абс_ли);
                assert (fp.имя == "john.doe");
                assert (fp.папка == r"");
                assert (fp.суффикс == r".foo");
                assert (fp == r"john.doe.foo");
                assert (fp.файл == r"john.doe.foo");
                assert (fp.расш == "foo");
                assert (!fp.ветвь_ли);

                fp = new ФПуть(r".doe");
                assert (!fp.абс_ли);
                assert (fp.суффикс == r"");
                assert (fp == r".doe");
                assert (fp.имя == ".doe");
                assert (fp.папка == r"");
                assert (fp.файл == r".doe");
                assert (fp.расш == "");
                assert (!fp.ветвь_ли);

                fp = new ФПуть(r"doe");
                assert (!fp.абс_ли);
                assert (fp.суффикс == r"");
                assert (fp == r"doe");
                assert (fp.имя == "doe");
                assert (fp.папка == r"");
                assert (fp.файл == r"doe");
                assert (fp.расш == "");
                assert (!fp.ветвь_ли);

                fp = new ФПуть(r".");
                assert (!fp.абс_ли);
                assert (fp.суффикс == r"");
                assert (fp == r".");
                assert (fp.имя == ".");
                assert (fp.папка == r"");
                assert (fp.файл == r".");
                assert (fp.расш == "");
                assert (!fp.ветвь_ли);

                fp = new ФПуть(r"..");
                assert (!fp.абс_ли);
                assert (fp.суффикс == r"");
                assert (fp == r"..");
                assert (fp.имя == "..");
                assert (fp.папка == r"");
                assert (fp.файл == r"..");
                assert (fp.расш == "");
                assert (!fp.ветвь_ли);

                fp = new ФПуть(r"c:/a/b/c/d/e/foo.bar");
                assert (fp.абс_ли);
                fp.папка (r"/a/b/c/");
                assert (fp.суффикс == r".bar");
                assert (fp == r"c:/a/b/c/foo.bar");
                assert (fp.имя == "foo");
                assert (fp.папка == r"/a/b/c/");
                assert (fp.файл == r"foo.bar");
                assert (fp.расш == "bar");
                assert (fp.ветвь_ли);

                fp = new ФПуть(r"c:/a/b/c/d/e/foo.bar");
                assert (fp.абс_ли);
                fp.папка (r"/a/b/c/d/e/f/g/");
                assert (fp.суффикс == r".bar");
                assert (fp == r"c:/a/b/c/d/e/f/g/foo.bar");
                assert (fp.имя == "foo");
                assert (fp.папка == r"/a/b/c/d/e/f/g/");
                assert (fp.файл == r"foo.bar");
                assert (fp.расш == "bar");
                assert (fp.ветвь_ли);

                fp = new ФПуть(r"C:/foo/bar/тест.bar");
                assert (fp.путь == "C:/foo/bar/");
                fp = new ФПуть(r"C:\foo\bar\тест.bar");
                assert (fp.путь == r"C:/foo/bar/");

                fp = new ФПуть("");
                assert (fp.пуст_ли);
                assert (!fp.ветвь_ли);
                assert (!fp.абс_ли);
                assert (fp.суффикс == r"");
                assert (fp == r"");
                assert (fp.имя == "");
                assert (fp.папка == r"");
                assert (fp.файл == r"");
                assert (fp.расш == "");
/+
                fp = new ФПуть(r"C:/foo/bar/тест.bar");
                fp = new ФПуть(fp.asPath ("foo"));
                assert (fp.имя == r"тест");
                assert (fp.папка == r"foo/");
                assert (fp.путь == r"C:foo/");
                assert (fp.расш == ".bar");

                fp = new ФПуть(fp.asPath (""));
                assert (fp.имя == r"тест");
                assert (fp.папка == r"");
                assert (fp.путь == r"C:");
                assert (fp.расш == ".bar");

                fp = new ФПуть(r"c:/joe/bar");
                assert(fp.склей(r"foo/bar/") == r"c:/joe/bar/foo/bar/");
                assert(fp.склей(new ФПуть(r"foo/bar")).вТкст == r"c:/joe/bar/foo/bar");

                assert (ФПуть.объедини (r"a/b/c/d", r"e/f/" r"g") == r"a/b/c/d/e/f/g");

                fp = new ФПуть(r"C:/foo/bar/тест.bar");
                assert (fp.asExt(пусто) == r"C:/foo/bar/тест");
                assert (fp.asExt("foo") == r"C:/foo/bar/тест.foo");
+/      
                }
        }
}


debug (FPath)
{       
        import io.Console;

        проц main() 
        {
                assert (ФПуть("/foo/").создай.есть_ли);
                Квывод (ФПуть("c:/temp/").файл("foo.bar")).нс;
        }

}
