/*******************************************************************************

        copyright:      Copyright (c) 2009 Kris. все rights reserved.

        license:        BSD стиль: $(LICENSE)
        
        version:        Oct 2009: Initial release
        
        author:         Kris
    
*******************************************************************************/

module text.Arguments;

private import text.Util;
private import util.container.more.Stack;

version=dashdash;       // -- everything assigned в_ the пусто аргумент

/*******************************************************************************

        Command-строка аргумент парсер. Simple usage is:
        ---
        auto арги = new Аргументы;
        арги.разбор ("-a -b", да);
        auto a = арги("a");
        auto b = арги("b");
        if (a.установи && b.установи)
            ...
        ---

        Аргумент параметры are assigned в_ the последний known мишень, such
        that multИПle параметры accumulate:
        ---
        арги.разбор ("-a=1 -a=2 foo", да);
        assert (арги('a').assigned.length is 3);
        ---

        That example results in аргумент 'a' assigned three параметры.
        Two параметры are explicitly assigned using '=', while a third
        is implicitly assigned. Implicit параметры are often useful for
        collecting filenames or другой параметры without specifying the
        associated аргумент:
        ---
        арги.разбор ("thisfile.txt thatfile.doc -v", да);
        assert (арги(пусто).assigned.length is 2);
        ---
        The 'пусто' аргумент is always defined and acts as an accumulator
        for параметры left uncaptured by другой аргументы. In the above
        экземпляр it was assigned Всё параметры. 
        
        Examples thus far have used 'sloppy' аргумент declaration, via
        the сукунда аргумент of разбор() being установи да. This allows the
        парсер в_ создай аргумент declaration on-the-fly, which can be
        handy for trivial usage. However, most features require the a-
        priori declaration of аргументы:
        ---
        арги = new Аргументы;
        арги('x').required;
        if (! арги.разбор("-x"))
              // x not supplied!
        ---

        Sloppy аргументы are disabled in that example, and a required
        аргумент 'x' is declared. The разбор() метод will краш if the
        pre-conditions are not fully met. добавьitional qualifiers include
        specifying как many параметры are allowed for each indivопрual
        аргумент, default параметры, whether an аргумент requires the 
        presence or exclusion of другой, etc. Qualifiers are typically 
        chained together and the following example shows аргумент "foo"
        being made required, with one parameter, aliased в_ 'f', and
        dependent upon the presence of другой аргумент "bar":
        ---
        арги("foo").required.params(1).aliased('f').requires("bar");
        арги("help").aliased('?').aliased('h');
        ---

        Параметры can be constrained в_ a установи of matching текст values,
        and the парсер will краш on mismatched ввод:
        ---
        арги("greeting").restrict("hello", "yo", "gday");
        арги("включен").restrict("да", "нет", "t", "f", "y", "n");  
        ---

        A установи of declared аргументы may be configured in this manner
        and the парсер will return да only where все conditions are
        met. Where a ошибка condition occurs you may traverse the установи
        of аргументы в_ найди out which аргумент есть what ошибка. This
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
        ParamLo:        too few params for an аргумент
        ParamHi:        too many params for an аргумент
        Required:       missing аргумент is required 
        Requires:       depends on a missing аргумент
        Конфликт:       conflicting аргумент is present
        Extra:          unexpected аргумент (see sloppy)
        Option:         parameter does not match options
        ---
        
        A simpler way в_ укз ошибки is в_ invoke an internal форматируй
        routine, which constructs ошибка messages on your behalf:
        ---
        if (! арги.разбор (...))
              стдош (арги.ошибки(&стдош.выкладка.sprint));
        ---

        Note that messages are constructed via a выкладка handler and
        the messages themselves may be customized (for i18n purposes).
        See the two ошибки() methods for ещё information on this.

        The парсер сделай a distinction between a крат and дол префикс, 
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
        арги('o').params(1).smush;
        if (арги.разбор ("-ofile"))
            assert (арги('o').assigned[0] == "файл");
        ---

        There are two обрвызов varieties supports, where one is invoked
        when an associated аргумент is разобрано and the другой is invoked
        as параметры are assigned. See the свяжи() methods for delegate
        сигнатура details.

        You may change the аргумент префикс в_ be something другой than 
        "-" and "--" via the constructor. You might, for example, need 
        в_ specify a "/" indicator instead, and use ':' for explicitly
        assigning параметры:
        ---
        auto арги = new Арги ("/", "-", ':');
        арги.разбор ("-foo:param -bar /abc");
        assert (арги("foo").установи);
        assert (арги("bar").установи);
        assert (арги("a").установи);
        assert (арги("b").установи);
        assert (арги("c").установи);
        assert (арги("foo").assigned.length is 1);
        ---

        Returning в_ an earlier example we can declare some specifics:
        ---
        арги('v').params(0);
        assert (арги.разбор (`-v thisfile.txt thatfile.doc`));
        assert (арги(пусто).assigned.length is 2);
        ---

        Note that the -v flag is сейчас in front of the implicit параметры
        but ignores them because it is declared в_ используй Неук. That is,
        implicit параметры are assigned в_ аргументы из_ right в_ left,
        according в_ как many параметры saопр аргументы may используй. Each
        sloppy аргумент consumes параметры by default, so those implicit
        параметры would have been assigned в_ -v without the declaration 
        shown. On the другой hand, an explicit assignment (via '=') always 
        associates the parameter with that аргумент even when an перебор
        would occur (though will cause an ошибка в_ be raised).

        Certain параметры are used for capturing comments or другой plain
        текст из_ the пользователь, включая пробел and другой special chars.
        Such parameter values should be quoted on the commandline, and be
        assigned explicitly rather than implicitly:
        ---
        арги.разбор (`--коммент="-- a коммент --"`);
        ---

        Without the explicit assignment, the текст контент might otherwise 
        be consопрered the старт of другой аргумент (due в_ как argv/argc
        values are очищенный of original quotes).

        Lastly, все subsequent текст is treated as paramter-values after a
        "--" token is encountered. This notion is applied by unix systems 
        в_ терминируй аргумент processing in a similar manner. Such values
        are consопрered в_ be implicit, and are assigned в_ preceding арги
        in the usual right в_ left fashion (or в_ the пусто аргумент):
        ---
        арги.разбор (`-- -thisfile --thatfile`);
        assert (арги(пусто).assigned.length is 2);
        ---
        
*******************************************************************************/

class Аргументы
{
        public alias получи                opCall;         // арги("имя")
        public alias получи                opIndex;        // арги["имя"]

        private Stack!(Аргумент)        stack;          // арги with params
        private Аргумент[ткст]        арги;           // the установи of арги
        private Аргумент[ткст]        aliases;        // установи of aliases
        private сим                    eq;             // '=' or ':'
        private ткст                  sp,             // крат префикс
                                        lp;             // дол префикс
        private ткст[]                msgs = errmsg;  // ошибка messages
        private const ткст[]          errmsg =        // default ошибки
                [
                "аргумент '{0}' expects {2} parameter(s) but есть {1}\n", 
                "аргумент '{0}' expects {3} parameter(s) but есть {1}\n", 
                "аргумент '{0}' is missing\n", 
                "аргумент '{0}' requires '{4}'\n", 
                "аргумент '{0}' conflicts with '{4}'\n", 
                "unexpected аргумент '{0}'\n", 
                "аргумент '{0}' expects one of {5}\n", 
                "не_годится parameter for аргумент '{0}': {4}\n", 
                ];

        /***********************************************************************
              
              Construct with the specific крат & дол prefixes, and the 
              given assignment character (typically ':' on Windows but we
              установи the defaults в_ look like unix instead)

        ***********************************************************************/
        
        this (ткст sp="-", ткст lp="--", сим eq='=')
        {
                this.sp = sp;
                this.lp = lp;
                this.eq = eq;
                получи(пусто).params;       // установи пусто аргумент в_ используй params
        }

        /***********************************************************************
              
                Parse ткст[] преобр_в a установи of Аргумент instances. The 'sloppy'
                опция allows for unexpected аргументы without ошибка.
                
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
                foreach (s; quotes(ввод, " "))
                         врем ~= s;
                return разбор (врем, sloppy);
        }

        /***********************************************************************
              
                Parse a ткст преобр_в a установи of Аргумент instances. The 'sloppy'
                опция allows for unexpected аргументы without ошибка.
                
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
                stack.push (получи(пусто));
                foreach (s; ввод)
                        {
                        debug(Аргументы) стдвыв.форматнс ("'{}'", s);
                        if (готово is нет)
                            if (s == "--")
                               {готово=да; version(dashdash){stack.сотри.push(получи(пусто));} continue;}
                            else
                               if (аргумент (s, lp, sloppy, нет) ||
                                   аргумент (s, sp, sloppy, да))
                                   continue;
                        stack.top.добавь (s);
                        }  
                foreach (арг; арги)
                         ошибка |= арг.valid;
                return ошибка is 0;
        }

        /***********************************************************************
              
                Clear parameter assignments, флаги and ошибки. Note this 
                does not удали any Аргументы

        ***********************************************************************/
        
        final Аргументы сотри ()
        {
                stack.сотри;
                foreach (арг; арги)
                        {
                        арг.установи = нет;
                        арг.values = пусто;
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

                Pass пусто в_ access the 'default' аргумент (where unassigned
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
                auto msgs = арги.ошибки (&стдош.выкладка.sprint);
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
                             результат ~= дг (врем, msgs[арг.ошибка-1], арг.имя, 
                                           арг.values.length, арг.min, арг.max, 
                                           арг.bogus, арг.options);
                return результат;                             
        }

        /***********************************************************************
                
                Use this метод в_ замени the default ошибка messages. Note
                that аргументы are passed в_ the форматёр in the following
                order, and these should be indexed appropriately by each of
                the ошибка messages (see examples in errmsg above):
                ---
                индекс 0: the аргумент имя
                индекс 1: число of параметры
                индекс 2: configured minimum параметры
                индекс 3: configured maximum параметры
                индекс 4: conflicting/dependent аргумент (or не_годится param)
                индекс 5: Массив of configured parameter options
                ---

        ***********************************************************************/

        final Аргументы ошибки (ткст[] ошибки)
        {
                if (ошибки.length is errmsg.length)
                    msgs = ошибки;
                else
                   assert (нет);
                return this;
        }

        /***********************************************************************
                
                Expose the configured установи of help текст, via the given 
                delegate

        ***********************************************************************/

        final Аргументы help (проц delegate(ткст арг, ткст help) дг)
        {
                foreach (арг; арги)
                         if (арг.текст.ptr)
                             дг (арг.имя, арг.текст);
                return this;
        }

        /***********************************************************************
              
                Test for the presence of a switch (дол/крат префикс) 
                and enable the associated арг where найдено. Also look 
                for and укз explicit parameter assignment
                
        ***********************************************************************/
        
        private бул аргумент (ткст s, ткст p, бул sloppy, бул flag)
        {
                if (s.length >= p.length && s[0..p.length] == p)
                   {
                   s = s [p.length..$];
                   auto i = locate (s, eq);
                   if (i < s.length)
                       enable (s[0..i], sloppy, flag).добавь (s[i+1..$], да);
                   else
                      // trap пустой аргументы; прикрепи as param в_ пусто-арг
                      if (s.length)
                          enable (s, sloppy, flag);
                      else
                         получи(пусто).добавь (p, да);
                   return да;
                   }
                return нет;
        }

        /***********************************************************************
              
                Indicate the existance of an аргумент, and укз sloppy
                options along with multИПle-флаги and smushed параметры.
                Note that sloppy аргументы are configured with параметры
                включен.

        ***********************************************************************/
        
        private Аргумент enable (ткст elem, бул sloppy, бул flag=нет)
        {
                if (flag && elem.length > 1)
                   {
                   // locate арг for first сим
                   auto арг = enable (elem[0..1], sloppy);
                   elem = elem[1..$];

                   // drop further processing of this flag where in ошибка
                   if (арг.ошибка is арг.Нет)
                       // smush remaining текст or treat as добавьitional арги
                       if (арг.склей)
                           арг.добавь (elem, да);
                       else
                          арг = enable (elem, sloppy, да);
                   return арг;
                   }

                // if not in арги, or in aliases, then создай new арг
                auto a = elem in арги;
                if (a is пусто)
                    if ((a = elem in aliases) is пусто)
                         return получи(elem).params.enable(!sloppy);
                return a.enable;
        }

        /***********************************************************************
              
                A specific аргумент экземпляр. You получи one of these из_ 
                Аргументы.получи() and visit them via Аргументы.opApply()

        ***********************************************************************/
        
        class Аргумент
        {       
                /***************************************************************
                
                        Ошибка определители:
                        ---
                        Нет:           ok
                        ParamLo:        too few params for an аргумент
                        ParamHi:        too many params for an аргумент
                        Required:       missing аргумент is required 
                        Requires:       depends on a missing аргумент
                        Конфликт:       conflicting аргумент is present
                        Extra:          unexpected аргумент (see sloppy)
                        Option:         parameter does not match options
                        ---

                ***************************************************************/
        
                enum {Нет, ParamLo, ParamHi, Required, Requires, Конфликт, Extra, Option, Invalid};

                alias проц   delegate() Invoker;
                alias ткст delegate(ткст значение) Inspector;

                public цел              min,            /// minimum params
                                        max,            /// maximum params
                                        ошибка;          /// ошибка condition
                public  бул            установи;            /// арг is present
                private бул            req,            // арг is required
                                        склей,            // арг is smushable
                                        эксп,            // implicit params
                                        краш;           // краш the разбор
                private ткст          имя,           // арг имя
                                        текст,           // help текст
                                        bogus;          // имя of conflict
                private ткст[]        values,         // assigned values
                                        options,        // validation options
                                        дефолты;       // configured defaults
                private Invoker         invoker;        // invocation обрвызов
                private Inspector       inspector;      // inspection обрвызов
                private Аргумент[]      dependees,      // who we require
                                        conflictees;    // who we conflict with
                
                /***************************************************************
              
                        Create with the given имя

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
                
                        return the assigned параметры, or the defaults if
                        no параметры were assigned

                ***************************************************************/
        
                final ткст[] assigned ()
                {
                        return values.length ? values : дефолты;
                }

                /***************************************************************
              
                        Alias this аргумент with the given имя. If you need 
                        дол-names в_ be aliased, создай the дол-имя first
                        and alias it в_ a крат one

                ***************************************************************/
        
                final Аргумент aliased (сим имя)
                {
                        this.outer.aliases[(&имя)[0..1].dup] = this;
                        return this;
                }

                /***************************************************************
              
                        Make this аргумент a requirement

                ***************************************************************/
        
                final Аргумент required ()
                {
                        this.req = да;
                        return this;
                }

                /***************************************************************
              
                        Набор this аргумент в_ depend upon другой

                ***************************************************************/
        
                final Аргумент requires (Аргумент арг)
                {
                        dependees ~= арг;
                        return this;
                }

                /***************************************************************
              
                        Набор this аргумент в_ depend upon другой

                ***************************************************************/
        
                final Аргумент requires (ткст другой)
                {
                        return requires (this.outer.получи(другой));
                }

                /***************************************************************
              
                        Набор this аргумент в_ depend upon другой

                ***************************************************************/
        
                final Аргумент requires (сим другой)
                {
                        return requires ((&другой)[0..1]);
                }

                /***************************************************************
              
                        Набор this аргумент в_ conflict with другой

                ***************************************************************/
        
                final Аргумент conflicts (Аргумент арг)
                {
                        conflictees ~= арг;
                        return this;
                }

                /***************************************************************
              
                        Набор this аргумент в_ conflict with другой

                ***************************************************************/
        
                final Аргумент conflicts (ткст другой)
                {
                        return conflicts (this.outer.получи(другой));
                }

                /***************************************************************
              
                        Набор this аргумент в_ conflict with другой

                ***************************************************************/
        
                final Аргумент conflicts (сим другой)
                {
                        return conflicts ((&другой)[0..1]);
                }

                /***************************************************************
              
                        Enable parameter assignment: 0 в_ 42 by default

                ***************************************************************/
        
                final Аргумент params ()
                {
                        return params (0, 42);
                }

                /***************************************************************
              
                        Набор an exact число of параметры required

                ***************************************************************/
        
                final Аргумент params (цел счёт)
                {
                        return params (счёт, счёт);
                }

                /***************************************************************
              
                        Набор Всё the minimum and maximum parameter counts

                ***************************************************************/
        
                final Аргумент params (цел min, цел max)
                {
                        this.min = min;
                        this.max = max;
                        return this;
                }

                /***************************************************************
                        
                        Добавь другой default parameter for this аргумент

                ***************************************************************/
        
                final Аргумент defaults (ткст values)
                {
                        this.дефолты ~= values;
                        return this;
                }

                /***************************************************************
              
                        Набор an inspector for this аргумент, fired when a
                        parameter is appended в_ an аргумент. Return пусто
                        из_ the delegate when the значение is ok, or a текст
                        ткст describing the issue в_ trigger an ошибка

                ***************************************************************/
        
                final Аргумент свяжи (Inspector inspector)
                {
                        this.inspector = inspector;
                        return this;
                }

                /***************************************************************
              
                        Набор an invoker for this аргумент, fired when an
                        аргумент declaration is seen

                ***************************************************************/
        
                final Аргумент свяжи (Invoker invoker)
                {
                        this.invoker = invoker;
                        return this;
                }

                /***************************************************************
              
                        Enable smushing for this аргумент, where "-ofile" 
                        would результат in "файл" being assigned в_ аргумент 
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
        
                final Аргумент explicit ()
                {
                        эксп = да;
                        return this;
                }

                /***************************************************************
              
                        Alter the title of this аргумент, which can be 
                        useful for naming the default аргумент

                ***************************************************************/
        
                final Аргумент title (ткст имя)
                {
                        this.имя = имя;
                        return this;
                }

                /***************************************************************
              
                        Набор the help текст for this аргумент

                ***************************************************************/
        
                final Аргумент help (ткст текст)
                {
                        this.текст = текст;
                        return this;
                }

                /***************************************************************
              
                        Fail the разбор when this арг is encountered. You
                        might use this for managing help текст

                ***************************************************************/
        
                final Аргумент halt ()
                {
                        this.краш = да;
                        return this;
                }

                /***************************************************************
              
                        Restrict values в_ one of the given установи

                ***************************************************************/
        
                final Аргумент restrict (ткст[] options ...)
                {
                        this.options = options;
                        return this;
                }

                /***************************************************************
              
                        This арг is present, but установи an ошибка condition
                        (Extra) when unexpected and sloppy is not включен.
                        Fires any configured invoker обрвызов.

                ***************************************************************/
        
                private Аргумент enable (бул unexpected=нет)
                {
                        this.установи = да;
                        if (max > 0)
                            this.outer.stack.push(this);

                        if (invoker)
                            invoker();
                        if (unexpected)
                            ошибка = Extra;
                        return this;
                }

                /***************************************************************
              
                        Append a parameter значение, invoking an inspector as
                        necessary

                ***************************************************************/
        
                private проц добавь (ткст значение, бул explicit=нет)
                {       
                        // вынь в_ an аргумент that can прими implicit параметры?
                        if (explicit is нет)
                            for (auto s=&this.outer.stack; эксп && s.размер>1; this=s.top)
                                 s.вынь;

                        this.установи = да;        // needed for default assignments 
                        values ~= значение;        // добавь new значение

                        if (ошибка is Нет)
                           {
                           if (inspector)
                               if ((bogus = inspector(значение)).length)
                                    ошибка = Invalid;

                           if (options.length)
                              {
                              ошибка = Option;
                              foreach (опция; options)
                                       if (опция == значение)
                                           ошибка = Нет;
                              }
                           }
                        // вынь в_ an аргумент that can прими параметры
                        for (auto s=&this.outer.stack; values.length >= max && s.размер>1; this=s.top)
                             s.вынь;
                }

                /***************************************************************
                
                        Test and установи the ошибка flag appropriately 

                ***************************************************************/
        
                private цел valid ()
                {
                        if (ошибка is Нет)
                            if (req && !установи)      
                                ошибка = Required;
                            else
                               if (установи)
                                  {
                                  // крат circuit?
                                  if (краш)
                                      return -1;

                                  if (values.length < min)
                                      ошибка = ParamLo;
                                  else
                                     if (values.length > max)
                                         ошибка = ParamHi;
                                     else
                                        {
                                        foreach (арг; dependees)
                                                 if (! арг.установи)
                                                       ошибка = Requires, bogus=арг.имя;

                                        foreach (арг; conflictees)
                                                 if (арг.установи)
                                                     ошибка = Конфликт, bogus=арг.имя;
                                        }
                                  }

                        debug(Аргументы) стдвыв.форматнс ("{}: ошибка={}, установи={}, min={}, max={}, "
                                               "req={}, values={}, defaults={}, requires={}", 
                                               имя, ошибка, установи, min, max, req, values, 
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
        x.required;
        assert (арги.разбор ("") is нет);
        assert (арги.сотри.разбор ("-x"));
        assert (x.установи);

        // alias
        x.aliased('X');
        assert (арги.сотри.разбор ("-X"));
        assert (x.установи);

        // unexpected арг (with sloppy)
        assert (арги.сотри.разбор ("-y") is нет);
        assert (арги.сотри.разбор ("-y") is нет);
        assert (арги.сотри.разбор ("-y", да) is нет);
        assert (арги['y'].установи);
        assert (арги.сотри.разбор ("-x -y", да));

        // параметры
        x.params(0);
        assert (арги.сотри.разбор ("-x param"));
        assert (x.assigned.length is 0);
        assert (арги(пусто).assigned.length is 1);
        x.params(1);
        assert (арги.сотри.разбор ("-x=param"));
        assert (x.assigned.length is 1);
        assert (x.assigned[0] == "param");
        assert (арги.сотри.разбор ("-x param"));
        assert (x.assigned.length is 1);
        assert (x.assigned[0] == "param");

        // too many арги
        x.params(1);
        assert (арги.сотри.разбор ("-x param1 param2"));
        assert (x.assigned.length is 1);
        assert (x.assigned[0] == "param1");
        assert (арги(пусто).assigned.length is 1);
        assert (арги(пусто).assigned[0] == "param2");
        
        // сейчас with default params
        assert (арги.сотри.разбор ("param1 param2 -x=blah"));
        assert (арги[пусто].assigned.length is 2);
        assert (арги(пусто).assigned.length is 2);
        assert (x.assigned.length is 1);
        x.params(0);
        assert (!арги.сотри.разбор ("-x=blah"));

        // арги as parameter
        assert (арги.сотри.разбор ("- -x"));
        assert (арги[пусто].assigned.length is 1);
        assert (арги[пусто].assigned[0] == "-");

        // multИПle флаги, with alias and sloppy
        assert (арги.сотри.разбор ("-xy"));
        assert (арги.сотри.разбор ("-xyX"));
        assert (x.установи);
        assert (арги['y'].установи);
        assert (арги.сотри.разбор ("-xyz") is нет);
        assert (арги.сотри.разбор ("-xyz", да));
        auto z = арги['z'];
        assert (z.установи);

        // multИПle флаги with trailing арг
        assert (арги.сотри.разбор ("-xyz=10"));
        assert (z.assigned.length is 1);

        // again, but without sloppy param declaration
        z.params(0);
        assert (!арги.сотри.разбор ("-xyz=10"));
        assert (арги.сотри.разбор ("-xzy=10"));
        assert (арги('y').assigned.length is 1);
        assert (арги('x').assigned.length is 0);
        assert (арги('z').assigned.length is 0);

        // x requires y
        x.requires('y');
        assert (арги.сотри.разбор ("-xy"));
        assert (арги.сотри.разбор ("-xz") is нет);

        // defaults
        z.defaults("foo");
        assert (арги.сотри.разбор ("-xy"));
        assert (z.assigned.length is 1);

        // дол names, with params
        assert (арги.сотри.разбор ("-xy --fСПДar") is нет);
        assert (арги.сотри.разбор ("-xy --fСПДar", да));
        assert (арги["y"].установи && x.установи);
        assert (арги["fСПДar"].установи);
        assert (арги.сотри.разбор ("-xy --fСПДar=10"));
        assert (арги["fСПДar"].assigned.length is 1);
        assert (арги["fСПДar"].assigned[0] == "10");

        // smush аргумент z, but not другие
        z.params;
        assert (арги.сотри.разбор ("-xy -zsmush") is нет);
        assert (x.установи);
        z.smush;
        assert (арги.сотри.разбор ("-xy -zsmush"));
        assert (z.assigned.length is 1);
        assert (z.assigned[0] == "smush");
        assert (x.assigned.length is 0);
        z.params(0);

        // conflict x with z
        x.conflicts(z);
        assert (арги.сотри.разбор ("-xyz") is нет);

        // word режим, with префикс elimination
        арги = new Аргументы (пусто, пусто);
        assert (арги.сотри.разбор ("foo bar wumpus") is нет);
        assert (арги.сотри.разбор ("foo bar wumpus wombat", да));
        assert (арги("foo").установи);
        assert (арги("bar").установи);
        assert (арги("wumpus").установи);
        assert (арги("wombat").установи);

        // use '/' instead of '-'
        арги = new Аргументы ("/", "/");
        assert (арги.сотри.разбор ("/foo /bar /wumpus") is нет);
        assert (арги.сотри.разбор ("/foo /bar /wumpus /wombat", да));
        assert (арги("foo").установи);
        assert (арги("bar").установи);
        assert (арги("wumpus").установи);
        assert (арги("wombat").установи);

        // use '/' for крат and '-' for дол
        арги = new Аргументы ("/", "-");
        assert (арги.сотри.разбор ("-foo -bar -wumpus -wombat /abc", да));
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
                арги('f').params(0);
                assert (арги.разбор ("-f -- -bar -wumpus -wombat --abc"));
                assert (арги('f').assigned.length is 0);
                assert (арги(пусто).assigned.length is 4);
                }
             else
                {
                арги('f').params(2);
                assert (арги.разбор ("-f -- -bar -wumpus -wombat --abc"));
                assert (арги('f').assigned.length is 2);
                assert (арги(пусто).assigned.length is 2);
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

                арги(пусто).title("корень").params.help("корень help");
                арги('x').aliased('X').params(0).required.help("x help");
                арги('y').defaults("hi").params(2).smush.explicit.help("y help");
                арги('a').required.defaults("hi").requires('y').params(1).help("a help");
                арги("fСПДar").params(2).help("fСПДar help");
                if (! арги.разбор ("'one =two' -xa=bar -y=ff -yss --fСПДar=blah1 --fСПДar barf blah2 -- a b c d e"))
                      стдвыв (арги.ошибки(&стдвыв.выкладка.sprint));
                else
                   if (арги.получи('x'))
                       арги.help ((ткст a, ткст b){Стдвыв.форматнс ("{}{}\n\t{}", арги.lp, a, b);});
        }
}
