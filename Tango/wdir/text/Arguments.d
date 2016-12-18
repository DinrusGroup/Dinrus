/*******************************************************************************

        copyright:      Copyright (c) 2009 Kris. все rights reserved.

        license:        BSD стиль: $(LICENSE)
        
        version:        Oct 2009: Initial release
        
        author:         Kris
    
*******************************************************************************/

module text.Arguments;

private import text.Util;
private import util.container.more.Stack;

version=dashdash;       // -- everything назначено в_ the пусто аргумент

/*******************************************************************************

        Парсер аргументов командной строки. Простое использование:
        ---
        auto арги = new Аргументы;
        арги.разбор ("-a -b", да);
        auto a = арги("a");
        auto b = арги("b");
        if (a.установи && b.установи)
            ...
        ---

        Параметры аргумента назначаются последней известной цели, при этом
        несколько параметров накапливается:
        ---
        арги.разбор ("-a=1 -a=2 foo", да);
        assert (арги('a').назначено.length is 3);
        ---

        В итоге в примере аргументу 'a' назначено три параметра.
        Два параметра назначено явно, с помощью '=', третий
        назначен косвенно. Косвенные параметры часто пригодны для
        собериing filenames or другой параметры without specifying the
        associated аргумент:
        ---
        арги.разбор ("thisfile.txt thatfile.doc -v", да);
        assert (арги(пусто).назначено.length is 2);
        ---
        The 'пусто' аргумент is always defined и acts as an accumulator
        for параметры left uncaptured by другой аргументы. In the above
        экземпляр it was назначено Всё параметры. 
        
        Examples thus far have использован 'sloppy' аргумент declaration, via
        the секунда аргумент of разбор() being установи да. This allows the
        парсер в_ создай аргумент declaration on-the-fly, which can be
        handy for trivial usage. However, most features require the a-
        priori declaration of аргументы:
        ---
        арги = new Аргументы;
        арги('x').требуется;
        if (! арги.разбор("-x"))
              // x not supplied!
        ---

        Sloppy аргументы are disabled in that example, и a требуется
        аргумент 'x' is declared. The разбор() метод will краш if the
        pre-conditions are not fully met. добавьitional qualifiers include
        specifying как many параметры are allowed for each indivопрual
        аргумент, default параметры, whether an аргумент требует the 
        presence or exclusion of другой, etc. Qualifiers are typically 
        chained together и the following example shows аргумент "foo"
        being made требуется, with one parameter, есть_алиас в_ 'f', и
        dependent upon the presence of другой аргумент "bar":
        ---
        арги("foo").требуется.парамы(1).есть_алиас('f').требует("bar");
        арги("помощь").есть_алиас('?').есть_алиас('h');
        ---

        Параметры can be constrained в_ a установи of совпадают текст значения,
        и the парсер will краш on mismatched ввод:
        ---
        арги("greeting").ограничь("hello", "yo", "gday");
        арги("включен").ограничь("да", "нет", "t", "f", "y", "n");  
        ---

        A установи of declared аргументы may be configured in this manner
        и the парсер will return да only where все conditions are
        met. Where a ошибка condition occurs you may traverse the установи
        of аргументы в_ найди out which аргумент имеется что ошибка. This
        can be handled like so, where арг.ошибка holds a defined код:
        ---
        if (! арги.разбор (...))
              foreach (арг; арги)
                       if (арг.ошибка)
                           ...
        ---
       
        Ошибка codes are as follows:
        ---
        Нет:           ok (zero)
        ПарамМлад:        too few парамы for an аргумент
        ПарамСтарш:        too many парамы for an аргумент
        Требуется:       missing аргумент is требуется 
        Требует:       depends on a missing аргумент
        Конфликт:       conflicting аргумент is present
        Экстра:          неожиданный аргумент (see sloppy)
        Опция:         parameter does not сверь опции
        ---
        
        A simpler way в_ укз ошибки is в_ invoke an internal форматируй
        routine, which constructs ошибка messages on your behalf:
        ---
        if (! арги.разбор (...))
              стдош (арги.ошибки(&стдош.выкладка.sprint));
        ---

        Note that messages are constructed via a выкладка handler и
        the messages themselves may be customized (for i18n purposes).
        See the two ошибки() methods for ещё information on this.

        The парсер сделай a distinction between a крат и дол префикс, 
        in that a дол префикс аргумент is always distinct while крат
        префикс аргументы may be combined as a shortcut:
        ---
        арги.разбор ("--foo --bar -abc", да);
        assert (арги("foo").установи);
        assert (арги("bar").установи);
        assert (арги("a").установи);
        assert (арги("b").установи);
        assert (арги("c").установи);
        ---

        In добавьition, крат-префикс аргументы may be "smushed" with an
        associated parameter when configured в_ do so:
        ---
        арги('o').парамы(1).smush;
        if (арги.разбор ("-ofile"))
            assert (арги('o').назначено[0] == "файл");
        ---

        There are two обрвызов varieties supports, where one is invoked
        when an associated аргумент is разобрано и the другой is invoked
        as параметры are назначено. See the вяжи() methods for delegate
        сигнатура details.

        You may change the аргумент префикс в_ be something другой than 
        "-" и "--" via the constructor. You might, for example, need 
        в_ specify a "/" indicator instead, и use ':' for explicitly
        assigning параметры:
        ---
        auto арги = new Арги ("/", "-", ':');
        арги.разбор ("-foo:param -bar /abc");
        assert (арги("foo").установи);
        assert (арги("bar").установи);
        assert (арги("a").установи);
        assert (арги("b").установи);
        assert (арги("c").установи);
        assert (арги("foo").назначено.length is 1);
        ---

        Returning в_ an earlier example we can declare some specifics:
        ---
        арги('v').парамы(0);
        assert (арги.разбор (`-v thisfile.txt thatfile.doc`));
        assert (арги(пусто).назначено.length is 2);
        ---

        Note that the -v флаг is сейчас in front of the implicit параметры
        but ignores them because it is declared в_ используй Неук. That is,
        implicit параметры are назначено в_ аргументы из_ right в_ left,
        according в_ как many параметры saопр аргументы may используй. Each
        sloppy аргумент consumes параметры by default, so those implicit
        параметры would have been назначено в_ -v without the declaration 
        shown. On the другой hand, an явный assignment (via '=') always 
        associates the parameter with that аргумент even when an перебор
        would occur (though will cause an ошибка в_ be raised).

        Certain параметры are использован for capturing comments or другой plain
        текст из_ the пользователь, включая пробел и другой special симвы.
        Such parameter значения should be quoted on the commandline, и be
        назначено explicitly rather than implicitly:
        ---
        арги.разбор (`--коммент="-- a коммент --"`);
        ---

        Without the явный assignment, the текст контент might otherwise 
        be consопрered the старт of другой аргумент (due в_ как argv/argc
        значения are очищенный of original кавычки).

        Lastly, все subsequent текст is treated as paramter-значения after a
        "--" токен is encountered. This notion is applied by unix systems 
        в_ терминируй аргумент processing in a similar manner. Such значения
        are consопрered в_ be implicit, и are назначено в_ preceding арги
        in the usual right в_ left fashion (or в_ the пусто аргумент):
        ---
        арги.разбор (`-- -thisfile --thatfile`);
        assert (арги(пусто).назначено.length is 2);
        ---
        
*******************************************************************************/

class Аргументы
{
        public alias получи                opCall;         // арги("имя")
        public alias получи                opIndex;        // арги["имя"]

        private Стэк!(Аргумент)        стэк;          // арги with парамы
        private Аргумент[ткст]        арги;           // the установи of арги
        private Аргумент[ткст]        алиасы;        // установи of алиасы
        private сим                    eq;             // '=' or ':'
        private ткст                  sp,             // крат префикс
                                        lp;             // дол префикс
        private ткст[]                сообы = ошсооб;  // ошибка messages
        private const ткст[]          ошсооб =        // default ошибки
                [
                "аргумент '{0}' ожидает {2} параметр(s) но имеется {1}\n", 
                "аргумент '{0}' ожидает {3} параметр(s) но имеется {1}\n", 
                "аргумент '{0}' отсутствует\n", 
                "аргумент '{0}' требует '{4}'\n", 
                "аргумент '{0}' конфликтует с '{4}'\n", 
                "неожиданный аргумент '{0}'\n", 
                "аргумент '{0}' ожидает один из {5}\n", 
                "параметр не подходит для аргумента '{0}': {4}\n", 
                ];

        /***********************************************************************
              
              Construct with the specific крат & дол prefixes, и the 
              given assignment character (typically ':' on Windows but we
              установи the дефолты в_ look like unix instead)

        ***********************************************************************/
        
        this (ткст sp="-", ткст lp="--", сим eq='=')
        {
                this.sp = sp;
                this.lp = lp;
                this.eq = eq;
                получи(пусто).парамы;       // установи пусто аргумент в_ используй парамы
        }

        /***********************************************************************
              
                Parse ткст[] преобр_в a установи of Аргумент экземпляры. The 'sloppy'
                опция allows for неожиданный аргументы without ошибка.
                
                Returns нет where an ошибка condition occurred, whereupon the 
                аргументы should be traversed в_ discover saопр condition(s):
                ---
                auto арги = new Аргументы;
                if (! арги.разбор (...))
                      стдош (арги.ошибки(&стдош.выкладка.sprint));
                ---

        ***********************************************************************/
        
        final бул разбор (ткст ввод, бул sloppy=нет)
        {
                ткст[] врем;
                foreach (s; кавычки(ввод, " "))
                         врем ~= s;
                return разбор (врем, sloppy);
        }

        /***********************************************************************
              
                Parse a ткст преобр_в a установи of Аргумент экземпляры. The 'sloppy'
                опция allows for неожиданный аргументы without ошибка.
                
                Returns нет where an ошибка condition occurred, whereupon the 
                аргументы should be traversed в_ discover saопр condition(s):
                ---
                auto арги = new Аргументы;
                if (! арги.разбор (...))
                      Стдош (арги.ошибки(&Стдош.выкладка.sprint));
                ---

        ***********************************************************************/
        
        final бул разбор (ткст[] ввод, бул sloppy=нет)
        {
                бул    готово;
                цел     ошибка;

                debug(Аргументы) стдвыв.форматнс ("\ncmdline: '{}'", ввод);
                стэк.сунь (получи(пусто));
                foreach (s; ввод)
                        {
                        debug(Аргументы) стдвыв.форматнс ("'{}'", s);
                        if (готово is нет)
                            if (s == "--")
                               {готово=да; version(dashdash){стэк.очисть.сунь(получи(пусто));} continue;}
                            else
                               if (аргумент (s, lp, sloppy, нет) ||
                                   аргумент (s, sp, sloppy, да))
                                   continue;
                        стэк.верх.добавь (s);
                        }  
                foreach (арг; арги)
                         ошибка |= арг.действителен;
                return ошибка is 0;
        }

        /***********************************************************************
              
                Clear parameter assignments, флаги и ошибки. Note this 
                does not удали any Аргументы

        ***********************************************************************/
        
        final Аргументы очисть ()
        {
                стэк.очисть;
                foreach (арг; арги)
                        {
                        арг.установи = нет;
                        арг.значения = пусто;
                        арг.ошибка = арг.Нет;
                        }
                return this;
        }

        /***********************************************************************
              
                Obtain an аргумент reference, creating an new экземпляр where
                necessary. Use Массив indexing or opCall syntax if you prefer

        ***********************************************************************/
        
        final Аргумент получи (сим имя)
        {
                return получи ((&имя)[0..1]);
        }

        /***********************************************************************
              
                Obtain an аргумент reference, creating an new экземпляр where
                necessary. Use Массив indexing or opCall syntax if you prefer.

                Pass пусто в_ доступ the 'default' аргумент (where unassigned
                implicit параметры are gathered)
                
        ***********************************************************************/
        
        final Аргумент получи (ткст имя)
        {
                auto a = имя in арги;
                if (a is пусто)
                   {имя=имя.dup; return арги[имя] = new Аргумент(имя);}
                return *a;
        }

        /***********************************************************************

                Traverse the установи of аргументы

        ***********************************************************************/

        final цел opApply (цел delegate(ref Аргумент) дг)
        {
                цел результат;
                foreach (арг; арги)  
                         if ((результат=дг(арг)) != 0)
                              break;
                return результат;
        }

        /***********************************************************************

                Construct a ткст of ошибка messages, using the given
                delegate в_ форматируй the вывод. You would typically пароль
                the system форматёр here, like so:
                ---
                auto сообы = арги.ошибки (&стдош.выкладка.sprint);
                ---

                The messages are replacable with custom (i18n) versions
                instead, using the ошибки(ткст[]) метод 

        ***********************************************************************/

        final ткст ошибки (ткст delegate(ткст буф, ткст фмт, ...) дг)
        {
                сим[256] врем;
                ткст результат;
                foreach (арг; арги)
                         if (арг.ошибка)
                             результат ~= дг (врем, сообы[арг.ошибка-1], арг.имя, 
                                           арг.значения.length, арг.min, арг.max, 
                                           арг.bogus, арг.опции);
                return результат;                             
        }

        /***********************************************************************
                
                Use this метод в_ замени the default ошибка messages. Note
                that аргументы are passed в_ the форматёр in the following
                order, и these should be indexed appropriately by each of
                the ошибка messages (see examples in ошсооб above):
                ---
                индекс 0: the аргумент имя
                индекс 1: число of параметры
                индекс 2: configured minimum параметры
                индекс 3: configured maximum параметры
                индекс 4: conflicting/dependent аргумент (or не_годится param)
                индекс 5: Массив of configured parameter опции
                ---

        ***********************************************************************/

        final Аргументы ошибки (ткст[] ошибки)
        {
                if (ошибки.length is ошсооб.length)
                    сообы = ошибки;
                else
                   assert (нет);
                return this;
        }

        /***********************************************************************
                
                Expose the configured установи of помощь текст, via the given 
                delegate

        ***********************************************************************/

        final Аргументы помощь (проц delegate(ткст арг, ткст помощь) дг)
        {
                foreach (арг; арги)
                         if (арг.текст.ptr)
                             дг (арг.имя, арг.текст);
                return this;
        }

        /***********************************************************************
              
                Test for the presence of a switch (дол/крат префикс) 
                и активируй the associated арг where найдено. Also look 
                for и укз явный parameter assignment
                
        ***********************************************************************/
        
        private бул аргумент (ткст s, ткст p, бул sloppy, бул флаг)
        {
                if (s.length >= p.length && s[0..p.length] == p)
                   {
                   s = s [p.length..$];
                   auto i = местоположение (s, eq);
                   if (i < s.length)
                       активируй (s[0..i], sloppy, флаг).добавь (s[i+1..$], да);
                   else
                      // trap пустой аргументы; прикрепи as param в_ пусто-арг
                      if (s.length)
                          активируй (s, sloppy, флаг);
                      else
                         получи(пусто).добавь (p, да);
                   return да;
                   }
                return нет;
        }

        /***********************************************************************
              
                Indicate the existance of an аргумент, и укз sloppy
                опции along with multИПle-флаги и smushed параметры.
                Note that sloppy аргументы are configured with параметры
                включен.

        ***********************************************************************/
        
        private Аргумент активируй (ткст элем, бул sloppy, бул флаг=нет)
        {
                if (флаг && элем.length > 1)
                   {
                   // местоположение арг for первый сим
                   auto арг = активируй (элем[0..1], sloppy);
                   элем = элем[1..$];

                   // drop further processing of this флаг where in ошибка
                   if (арг.ошибка is арг.Нет)
                       // smush остаток текст or treat as добавьitional арги
                       if (арг.склей)
                           арг.добавь (элем, да);
                       else
                          арг = активируй (элем, sloppy, да);
                   return арг;
                   }

                // if not in арги, or in алиасы, then создай new арг
                auto a = элем in арги;
                if (a is пусто)
                    if ((a = элем in алиасы) is пусто)
                         return получи(элем).парамы.активируй(!sloppy);
                return a.активируй;
        }

        /***********************************************************************
              
                A specific аргумент экземпляр. You получи one of these из_ 
                Аргументы.получи() и visit them via Аргументы.opApply()

        ***********************************************************************/
        
        class Аргумент
        {       
                /***************************************************************
                
                        Ошибка определители:
                        ---
                        Нет:           ok
                        ПарамМлад:        too few парамы for an аргумент
                        ПарамСтарш:        too many парамы for an аргумент
                        Требуется:       missing аргумент is требуется 
                        Требует:       depends on a missing аргумент
                        Конфликт:       conflicting аргумент is present
                        Экстра:          неожиданный аргумент (see sloppy)
                        Опция:         parameter does not сверь опции
                        ---

                ***************************************************************/
        
                enum {Нет, ПарамМлад, ПарамСтарш, Требуется, Требует, Конфликт, Экстра, Опция, Неверный};

                alias проц   delegate() Вызывало;
                alias ткст delegate(ткст значение) Инспектор;

                public цел              min,            /// minimum парамы
                                        max,            /// maximum парамы
                                        ошибка;          /// ошибка condition
                public  бул            установи;            /// арг is present
                private бул            req,            // арг is требуется
                                        склей,            // арг is smushable
                                        эксп,            // implicit парамы
                                        краш;           // краш the разбор
                private ткст          имя,           // арг имя
                                        текст,           // помощь текст
                                        bogus;          // имя of conflict
                private ткст[]        значения,         // назначено значения
                                        опции,        // validation опции
                                        дефолты;       // configured дефолты
                private Вызывало         вызывало;        // invocation обрвызов
                private Инспектор       инспектор;      // inspection обрвызов
                private Аргумент[]      dependees,      // who we require
                                        conflictees;    // who we conflict with
                
                /***************************************************************
              
                        Созд with the given имя

                ***************************************************************/
        
                this (ткст имя)
                {
                        this.имя = имя;
                }

                /***************************************************************
              
                        Return the имя of this аргумент

                ***************************************************************/
        
                override ткст вТкст()
                {
                        return имя;
                }

                /***************************************************************
                
                        return the назначено параметры, or the дефолты if
                        no параметры were назначено

                ***************************************************************/
        
                final ткст[] назначено ()
                {
                        return значения.length ? значения : дефолты;
                }

                /***************************************************************
              
                        Alias this аргумент with the given имя. If you need 
                        дол-names в_ be есть_алиас, создай the дол-имя первый
                        и alias it в_ a крат one

                ***************************************************************/
        
                final Аргумент есть_алиас (сим имя)
                {
                        this.outer.алиасы[(&имя)[0..1].dup] = this;
                        return this;
                }

                /***************************************************************
              
                        Make this аргумент a requirement

                ***************************************************************/
        
                final Аргумент требуется ()
                {
                        this.req = да;
                        return this;
                }

                /***************************************************************
              
                        Набор this аргумент в_ depend upon другой

                ***************************************************************/
        
                final Аргумент требует (Аргумент арг)
                {
                        dependees ~= арг;
                        return this;
                }

                /***************************************************************
              
                        Набор this аргумент в_ depend upon другой

                ***************************************************************/
        
                final Аргумент требует (ткст другой)
                {
                        return требует (this.outer.получи(другой));
                }

                /***************************************************************
              
                        Набор this аргумент в_ depend upon другой

                ***************************************************************/
        
                final Аргумент требует (сим другой)
                {
                        return требует ((&другой)[0..1]);
                }

                /***************************************************************
              
                        Набор this аргумент в_ conflict with другой

                ***************************************************************/
        
                final Аргумент конфликтует (Аргумент арг)
                {
                        conflictees ~= арг;
                        return this;
                }

                /***************************************************************
              
                        Набор this аргумент в_ conflict with другой

                ***************************************************************/
        
                final Аргумент конфликтует (ткст другой)
                {
                        return конфликтует (this.outer.получи(другой));
                }

                /***************************************************************
              
                        Набор this аргумент в_ conflict with другой

                ***************************************************************/
        
                final Аргумент конфликтует (сим другой)
                {
                        return конфликтует ((&другой)[0..1]);
                }

                /***************************************************************
              
                        Enable parameter assignment: 0 в_ 42 by default

                ***************************************************************/
        
                final Аргумент парамы ()
                {
                        return парамы (0, 42);
                }

                /***************************************************************
              
                        Набор an exact число of параметры требуется

                ***************************************************************/
        
                final Аргумент парамы (цел счёт)
                {
                        return парамы (счёт, счёт);
                }

                /***************************************************************
              
                        Набор Всё the minimum и maximum parameter counts

                ***************************************************************/
        
                final Аргумент парамы (цел min, цел max)
                {
                        this.min = min;
                        this.max = max;
                        return this;
                }

                /***************************************************************
                        
                        Добавь другой default parameter for this аргумент

                ***************************************************************/
        
                final Аргумент установиДефолты (ткст значения)
                {
                        this.дефолты ~= значения;
                        return this;
                }

                /***************************************************************
              
                        Набор an инспектор for this аргумент, fired when a
                        parameter is appended в_ an аргумент. Return пусто
                        из_ the delegate when the значение is ok, or a текст
                        ткст describing the issue в_ trigger an ошибка

                ***************************************************************/
        
                final Аргумент вяжи (Инспектор инспектор)
                {
                        this.инспектор = инспектор;
                        return this;
                }

                /***************************************************************
              
                        Набор an вызывало for this аргумент, fired when an
                        аргумент declaration is seen

                ***************************************************************/
        
                final Аргумент вяжи (Вызывало вызывало)
                {
                        this.вызывало = вызывало;
                        return this;
                }

                /***************************************************************
              
                        Enable smushing for this аргумент, where "-ofile" 
                        would результат in "файл" being назначено в_ аргумент 
                        'o'

                ***************************************************************/
        
                final Аргумент smush (бул да=да)
                {
                        склей = да;
                        return this;
                }

                /***************************************************************
              
                        Disable implicit аргументы

                ***************************************************************/
        
                final Аргумент явный ()
                {
                        эксп = да;
                        return this;
                }

                /***************************************************************
              
                        Alter the титул of this аргумент, which can be 
                        useful for naming the default аргумент

                ***************************************************************/
        
                final Аргумент титул (ткст имя)
                {
                        this.имя = имя;
                        return this;
                }

                /***************************************************************
              
                        Набор the помощь текст for this аргумент

                ***************************************************************/
        
                final Аргумент помощь (ткст текст)
                {
                        this.текст = текст;
                        return this;
                }

                /***************************************************************
              
                        Fail the разбор when this арг is encountered. You
                        might use this for managing помощь текст

                ***************************************************************/
        
                final Аргумент остановись ()
                {
                        this.краш = да;
                        return this;
                }

                /***************************************************************
              
                        Ограничить значение до одного из набора

                ***************************************************************/
        
                final Аргумент ограничь (ткст[] опции ...)
                {
                        this.опции = опции;
                        return this;
                }

                /***************************************************************
              
                        This арг is present, but установи an ошибка condition
                        (Экстра) when неожиданный и sloppy is not включен.
                        Fires any configured вызывало обрвызов.

                ***************************************************************/
        
                private Аргумент активируй (бул неожиданный=нет)
                {
                        this.установи = да;
                        if (max > 0)
                            this.outer.стэк.сунь(this);

                        if (вызывало)
                            вызывало();
                        if (неожиданный)
                            ошибка = Экстра;
                        return this;
                }

                /***************************************************************
              
                        Доб a parameter значение, invoking an инспектор as
                        necessary

                ***************************************************************/
        
                private проц добавь (ткст значение, бул явный=нет)
                {       
                        // вынь в_ an аргумент that can прими implicit параметры?
                        if (явный is нет)
                            for (auto s=&this.outer.стэк; эксп && s.размер>1; this=s.верх)
                                 s.вынь;

                        this.установи = да;        // needed for default assignments 
                        значения ~= значение;        // добавь new значение

                        if (ошибка is Нет)
                           {
                           if (инспектор)
                               if ((bogus = инспектор(значение)).length)
                                    ошибка = Неверный;

                           if (опции.length)
                              {
                              ошибка = Опция;
                              foreach (опция; опции)
                                       if (опция == значение)
                                           ошибка = Нет;
                              }
                           }
                        // вынь в_ an аргумент that can прими параметры
                        for (auto s=&this.outer.стэк; значения.length >= max && s.размер>1; this=s.верх)
                             s.вынь;
                }

                /***************************************************************
                
                        Test и установи the ошибка флаг appropriately 

                ***************************************************************/
        
                private цел действителен ()
                {
                        if (ошибка is Нет)
                            if (req && !установи)      
                                ошибка = Требуется;
                            else
                               if (установи)
                                  {
                                  // крат circuit?
                                  if (краш)
                                      return -1;

                                  if (значения.length < min)
                                      ошибка = ПарамМлад;
                                  else
                                     if (значения.length > max)
                                         ошибка = ПарамСтарш;
                                     else
                                        {
                                        foreach (арг; dependees)
                                                 if (! арг.установи)
                                                       ошибка = Требует, bogus=арг.имя;

                                        foreach (арг; conflictees)
                                                 if (арг.установи)
                                                     ошибка = Конфликт, bogus=арг.имя;
                                        }
                                  }

                        debug(Аргументы) стдвыв.форматнс ("{}: ошибка={}, установи={}, min={}, max={}, "
                                               "req={}, значения={}, дефолты={}, требует={}", 
                                               имя, ошибка, установи, min, max, req, значения, 
                                               дефолты, dependees);
                        return ошибка;
                }
        }
}


/*******************************************************************************
      
*******************************************************************************/

debug(UnitTest)
{
        unittest
        {
        auto арги = new Аргументы;

        // basic 
        auto x = арги['x'];
        assert (арги.разбор (""));
        x.требуется;
        assert (арги.разбор ("") is нет);
        assert (арги.очисть.разбор ("-x"));
        assert (x.установи);

        // alias
        x.есть_алиас('X');
        assert (арги.очисть.разбор ("-X"));
        assert (x.установи);

        // неожиданный арг (with sloppy)
        assert (арги.очисть.разбор ("-y") is нет);
        assert (арги.очисть.разбор ("-y") is нет);
        assert (арги.очисть.разбор ("-y", да) is нет);
        assert (арги['y'].установи);
        assert (арги.очисть.разбор ("-x -y", да));

        // параметры
        x.парамы(0);
        assert (арги.очисть.разбор ("-x param"));
        assert (x.назначено.length is 0);
        assert (арги(пусто).назначено.length is 1);
        x.парамы(1);
        assert (арги.очисть.разбор ("-x=param"));
        assert (x.назначено.length is 1);
        assert (x.назначено[0] == "param");
        assert (арги.очисть.разбор ("-x param"));
        assert (x.назначено.length is 1);
        assert (x.назначено[0] == "param");

        // too many арги
        x.парамы(1);
        assert (арги.очисть.разбор ("-x param1 param2"));
        assert (x.назначено.length is 1);
        assert (x.назначено[0] == "param1");
        assert (арги(пусто).назначено.length is 1);
        assert (арги(пусто).назначено[0] == "param2");
        
        // сейчас with default парамы
        assert (арги.очисть.разбор ("param1 param2 -x=blah"));
        assert (арги[пусто].назначено.length is 2);
        assert (арги(пусто).назначено.length is 2);
        assert (x.назначено.length is 1);
        x.парамы(0);
        assert (!арги.очисть.разбор ("-x=blah"));

        // арги as parameter
        assert (арги.очисть.разбор ("- -x"));
        assert (арги[пусто].назначено.length is 1);
        assert (арги[пусто].назначено[0] == "-");

        // multИПle флаги, with alias и sloppy
        assert (арги.очисть.разбор ("-xy"));
        assert (арги.очисть.разбор ("-xyX"));
        assert (x.установи);
        assert (арги['y'].установи);
        assert (арги.очисть.разбор ("-xyz") is нет);
        assert (арги.очисть.разбор ("-xyz", да));
        auto z = арги['z'];
        assert (z.установи);

        // multИПle флаги with trailing арг
        assert (арги.очисть.разбор ("-xyz=10"));
        assert (z.назначено.length is 1);

        // again, but without sloppy param declaration
        z.парамы(0);
        assert (!арги.очисть.разбор ("-xyz=10"));
        assert (арги.очисть.разбор ("-xzy=10"));
        assert (арги('y').назначено.length is 1);
        assert (арги('x').назначено.length is 0);
        assert (арги('z').назначено.length is 0);

        // x требует y
        x.требует('y');
        assert (арги.очисть.разбор ("-xy"));
        assert (арги.очисть.разбор ("-xz") is нет);

        // дефолты
        z.дефолты("foo");
        assert (арги.очисть.разбор ("-xy"));
        assert (z.назначено.length is 1);

        // дол names, with парамы
        assert (арги.очисть.разбор ("-xy --fСПДar") is нет);
        assert (арги.очисть.разбор ("-xy --fСПДar", да));
        assert (арги["y"].установи && x.установи);
        assert (арги["fСПДar"].установи);
        assert (арги.очисть.разбор ("-xy --fСПДar=10"));
        assert (арги["fСПДar"].назначено.length is 1);
        assert (арги["fСПДar"].назначено[0] == "10");

        // smush аргумент z, but not другие
        z.парамы;
        assert (арги.очисть.разбор ("-xy -zsmush") is нет);
        assert (x.установи);
        z.smush;
        assert (арги.очисть.разбор ("-xy -zsmush"));
        assert (z.назначено.length is 1);
        assert (z.назначено[0] == "smush");
        assert (x.назначено.length is 0);
        z.парамы(0);

        // conflict x with z
        x.конфликтует(z);
        assert (арги.очисть.разбор ("-xyz") is нет);

        // word режим, with префикс elimination
        арги = new Аргументы (пусто, пусто);
        assert (арги.очисть.разбор ("foo bar wumpus") is нет);
        assert (арги.очисть.разбор ("foo bar wumpus wombat", да));
        assert (арги("foo").установи);
        assert (арги("bar").установи);
        assert (арги("wumpus").установи);
        assert (арги("wombat").установи);

        // use '/' instead of '-'
        арги = new Аргументы ("/", "/");
        assert (арги.очисть.разбор ("/foo /bar /wumpus") is нет);
        assert (арги.очисть.разбор ("/foo /bar /wumpus /wombat", да));
        assert (арги("foo").установи);
        assert (арги("bar").установи);
        assert (арги("wumpus").установи);
        assert (арги("wombat").установи);

        // use '/' for крат и '-' for дол
        арги = new Аргументы ("/", "-");
        assert (арги.очисть.разбор ("-foo -bar -wumpus -wombat /abc", да));
        assert (арги("foo").установи);
        assert (арги("bar").установи);
        assert (арги("wumpus").установи);
        assert (арги("wombat").установи);
        assert (арги("a").установи);
        assert (арги("b").установи);
        assert (арги("c").установи);

        // "--" makes все subsequent be implicit параметры
        арги = new Аргументы;
        version (dashdash)
                {
                арги('f').парамы(0);
                assert (арги.разбор ("-f -- -bar -wumpus -wombat --abc"));
                assert (арги('f').назначено.length is 0);
                assert (арги(пусто).назначено.length is 4);
                }
             else
                {
                арги('f').парамы(2);
                assert (арги.разбор ("-f -- -bar -wumpus -wombat --abc"));
                assert (арги('f').назначено.length is 2);
                assert (арги(пусто).назначено.length is 2);
                }
        }
}

/*******************************************************************************
      
*******************************************************************************/

debug (Аргументы)
{       
        import io.Stdout;

        проц main()
        {
                ткст crap = "crap";
                auto арги = new Аргументы;

                арги(пусто).титул("корень").парамы.помощь("корень помощь");
                арги('x').есть_алиас('X').парамы(0).требуется.помощь("x помощь");
                арги('y').дефолты("hi").парамы(2).smush.явный.помощь("y помощь");
                арги('a').требуется.дефолты("hi").требует('y').парамы(1).помощь("a помощь");
                арги("fСПДar").парамы(2).помощь("fСПДar помощь");
                if (! арги.разбор ("'one =two' -xa=bar -y=ff -yss --fСПДar=blah1 --fСПДar barf blah2 -- a b c d e"))
                      стдвыв (арги.ошибки(&стдвыв.выкладка.sprint));
                else
                   if (арги.получи('x'))
                       арги.помощь ((ткст a, ткст b){Стдвыв.форматнс ("{}{}\n\t{}", арги.lp, a, b);});
        }
}
