/*******************************************************************************

        copyright:      Copyright (c) 2005-2006 Lars Ivar Igesund, 
                        Eric Anderton. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: December 2005      
        
        author:         Lars Ivar Igesund, Eric Anderton

*******************************************************************************/

module util.ArgParser;

private import exception;

/**
    An alias в_ a delegate taking a ткст as a parameter. The значение 
    parameter will hold any симвы immediately
    following the аргумент. 
*/
alias проц delegate (ткст значение) ОбрвызПарсераАргов;

/**
    An alias в_ a delegate taking a ткст as a parameter. The значение 
    parameter will hold any симвы immediately
    following the аргумент.

    The порядковый аргумент represents which default аргумент this is for
    the given поток of аргументы.  The first default аргумент will
    be порядковый=0 with each successive вызов в_ this обрвызов having
    порядковый values of 1, 2, 3 and so forth. This can be сбрось в_ zero
    in new calls в_ разбор.
*/
alias проц delegate (ткст значение,бцел порядковый) ДефолтнОбрвызПарсераАргов;

/**
    An alias в_ a delegate taking no параметры
*/
alias проц delegate () ПростойОбрвызПарсераАргов;


/**
    A struct that represents a "{Prefix}{Identifier}" ткст.
*/
struct Аргумент {
    ткст префикс;
    ткст определитель;

    /**
        Creates a new Аргумент экземпляр with given префикс and определитель.
    */
    static Аргумент opCall ( ткст префикс, ткст определитель ) {
        Аргумент результат;

        результат.префикс = префикс;
        результат.определитель = определитель;

        return результат;
    }
}

/**
    Alias for for the lazy people.
*/
alias Аргумент Арг;

/**
    A utility class в_ разбор and укз your команда строка аргументы.
*/
class АргПарсер{

    /**
        A helper struct containing a обрвызов and an опр, corresponding в_
        the аргОпр passed в_ one of the свяжи methods.
    */
    protected struct ОбрвызПрефикса {
        ткст опр;
        ОбрвызПарсераАргов ов;
    }   

    protected ОбрвызПрефикса[][ткст] привязки;
    protected ДефолтнОбрвызПарсераАргов[ткст] дефолтнПривязки;
    protected бцел[ткст] порядковыеПрефикса;
    protected ткст[] порядокПоискаПрефикса;
    protected ДефолтнОбрвызПарсераАргов дефолтнпривяз;
    private бцел дефолтныйПорядковый = 0;

    protected проц добавьПривязки(ОбрвызПрефикса овп, ткст аргПрефикс){
        if (!(аргПрефикс in привязки)) {
            порядокПоискаПрефикса ~= аргПрефикс;
        }
        привязки[аргПрефикс] ~= овп;
    }

    /**
        Binds a delegate обрвызов в_ аргумент with a префикс and 
        a аргОпр.
        
        Параметры:
            аргПрефикс = the префикс of the аргумент, e.g. a dash '-'.
            аргОпр = the имя of the аргумент, what follows the префикс
            ов = the delegate that should be called when this аргумент is найдено
    */
    public проц свяжи(ткст аргПрефикс, ткст аргОпр, ОбрвызПарсераАргов ов){
        ОбрвызПрефикса овп;
        овп.опр = аргОпр;
        овп.ов = ов;
        добавьПривязки(овп, аргПрефикс);
    } 

    /**
        The constructor, creates an пустой АргПарсер экземпляр.
    */
    public this(){
        дефолтнпривяз = пусто;
    }
     
    /**
        The constructor, creates an АргПарсер экземпляр with a defined default обрвызов.
    */    
    public this(ДефолтнОбрвызПарсераАргов обрвызов){
        дефолтнпривяз = обрвызов;
    }    

    protected class ПростойАдаптерОбрвызова{
        ПростойОбрвызПарсераАргов обрвызов;
        public this(ПростойОбрвызПарсераАргов обрвызов){ 
            this.обрвызов = обрвызов; 
        }
        
        public проц обрвызАдаптера(ткст значение){
            обрвызов();
        }
    }

    /**
        Binds a delegate обрвызов в_ аргумент with a префикс and 
        a аргОпр.
        
        Параметры:
            аргПрефикс = the префикс of the аргумент, e.g. a dash '-'.
            аргОпр = the имя of the аргумент, what follows the префикс
            ов = the delegate that should be called when this аргумент is найдено
    */
    public проц свяжи(ткст аргПрефикс, ткст аргОпр, ПростойОбрвызПарсераАргов ов){
        ПростойАдаптерОбрвызова адаптер = new ПростойАдаптерОбрвызова(ов);
        ОбрвызПрефикса овп;
        овп.опр = аргОпр;
        овп.ов = &адаптер.обрвызАдаптера;
        добавьПривязки(овп, аргПрефикс);
    }
    
    /**
        Binds a delegate обрвызов в_ все аргументы with префикс аргПрефикс, but that
        do not conform в_ an аргумент bound in a вызов в_ свяжи(). 

        Параметры:
            аргПрефикс = the префикс for the обрвызов
            обрвызов = the default обрвызов
    */
    public проц свяжиДефолт(ткст аргПрефикс, ДефолтнОбрвызПарсераАргов обрвызов){
        дефолтнПривязки[аргПрефикс] = обрвызов;
        порядковыеПрефикса[аргПрефикс] = 0;
        if (!(аргПрефикс in привязки)) {
            порядокПоискаПрефикса ~= аргПрефикс;
        }
    }

    /**
        Binds a delegate обрвызов в_ все аргументы not conforming в_ an
        аргумент bound in a вызов в_ свяжи(). These аргументы will be passed в_ the
        delegate without having any совпадают prefixes removed.

        Параметры:
            обрвызов = the default обрвызов
    */
    public проц свяжиДефолт(ДефолтнОбрвызПарсераАргов обрвызов){
        дефолтнпривяз = обрвызов;
    }

    /**
        Binds a delegate обрвызов в_ an аргумент.

        Параметры:
            аргумент = аргумент в_ respond в_
            обрвызов = the delegate that should be called when the аргумент is найдено
    */
    public проц свяжи (Аргумент аргумент, ОбрвызПарсераАргов обрвызов) {
        свяжи(аргумент.префикс, аргумент.определитель, обрвызов);
    }

    /**
        Binds a delegate обрвызов в_ any число of аргументы.

        Параметры:
            аргументы = an Массив of Аргумент struct instances
            обрвызов = the delegate that should be called when one of the аргументы is найдено
    */
    public проц свяжи ( Аргумент[] аргументы, проц delegate(ткст) обрвызов ) {
        foreach (аргумент; аргументы) { свяжи(аргумент, обрвызов); }
    }

    /**
        Binds a delegate обрвызов в_ an определитель with Posix-like prefixes. This means,
        it binds for Всё prefixes "-" and "--", as well as определитель with, and
        without a delimiting "=" between определитель and значение.

        Параметры:
            определитель = аргумент определитель
            обрвызов = the delegate that should be called when one of the аргументы is найдено
    */
    public проц свяжиПосикс ( ткст определитель, ОбрвызПарсераАргов обрвызов ) {
        свяжи([ Аргумент("-", определитель ~ "="), Аргумент("-", определитель),
               Аргумент("--", определитель ~ "="), Аргумент("--", определитель) ], обрвызов);
    }

    /**
        Binds a delegate обрвызов в_ any число of определители with Posix-like prefixes.
        See свяжиПосикс(определитель, обрвызов).

        Параметры:
            аргументы = an Массив of аргумент определители
            обрвызов = the delegate that should be called when one of the аргументы is найдено
    */
    public проц свяжиПосикс ( ткст[] определители, ОбрвызПарсераАргов обрвызов ) {
        foreach (определитель; определители) { свяжиПосикс(определитель, обрвызов); }
    }

    /**
        Parses the аргументы provопрed by the parameter. The bound обрвызовы are called as
        аргументы are recognized. If two аргументы have the same префикс, and старт with 
        the same characters (e.g.: --открой, --opened), the longest совпадают bound обрвызов
        is called.

        Параметры:
            аргументы = the команда строка аргументы из_ the application
            сбросьПорядковые = if да, все порядковый counts will be установи в_ zero
    */
    public проц разбор(ткст[] аргументы, бул сбросьПорядковые = нет){
        if (привязки.length == 0) return;

        if (сбросьПорядковые) {
            дефолтныйПорядковый = 0;
            foreach (ключ; порядковыеПрефикса.keys) {
                порядковыеПрефикса[ключ] = 0;
            }
        }

        foreach (ткст арг; аргументы) {
            ткст argData = арг;
            ткст argOrig = argData;
            бул найдено = нет;

            foreach (ткст префикс; порядокПоискаПрефикса) {
                if(argData.length < префикс.length) continue; 

                if(argData[0..префикс.length] != префикс) continue;
                else argData = argData[префикс.length..$];

                if (префикс in привязки) {
                    ОбрвызПрефикса[] кандидаты;

                    foreach (ОбрвызПрефикса ов; привязки[префикс]) {
                        if (argData.length < ов.опр.length) continue;
                        
                        т_мера cbil = ов.опр.length;

                        if (ов.опр == argData[0..cbil]) {
                            найдено = да;
                            кандидаты ~= ов;
                        }
                    }

                    if (найдено) {
                        // Find the longest совпадают обрвызов определитель из_ the кандидаты.
                        т_мера indexLongestMatch = 0;

						if (кандидаты.length > 1) {
							foreach (i, кандидат; кандидаты) {
								if (кандидат.опр.length > кандидаты[indexLongestMatch].опр.length) {
									indexLongestMatch = i;
								}
							}
						}

                        // Вызов the best совпадают обрвызов.
                        with(кандидаты[indexLongestMatch]) { ов(argData[опр.length..$]); }
                    }
                }
                if (найдено) {
                    break;
                }
                else if (префикс in дефолтнПривязки){
                    дефолтнПривязки[префикс](argData,порядковыеПрефикса[префикс]);
                    порядковыеПрефикса[префикс]++;
                    найдено = да;
                    break;
                }
                argData = argOrig;
            }
            if (!найдено) {
                if (дефолтнпривяз !is пусто) {
                    дефолтнпривяз(argData,дефолтныйПорядковый);
                    дефолтныйПорядковый++;
                }
                else {
                    throw new ИсклНелегальногоАргумента("Недопустимый аргумент "~ argData);
                }
            }
        }
    }
}

debug (UnitTest) {
    import Целое = text.convert.Integer;

    //проц main() {}

unittest {

    АргПарсер парсер = new АргПарсер();
    бул h = нет;
    бул h2 = нет;
    бул b = нет;
    бул bb = нет;
    бул булево = нет;
    цел n = -1;
    цел dashOrdinalCount = -1;
    цел ordinalCount = -1;

    парсер.свяжи("--", "h2", delegate проц(){
        h2 = да;
    });

    парсер.свяжи("-", "h", delegate проц(){
        h = да;
    });

    парсер.свяжи("-", "bb", delegate проц(){
        bb = да;
    });

    парсер.свяжи("-", "бул", delegate проц(ткст значение){
        assert(значение.length == 5);
        assert(значение[0] == '=');
        if (значение[1..5] == "да") {
            булево = да;
        }
        else {
            assert(нет);
        }
    });

    парсер.свяжи("-", "b", delegate проц(){
        b = да;
    });

    парсер.свяжи("-", "n", delegate проц(ткст значение){
        assert(значение[0] == '=');
        n = cast(цел) Целое.разбор(значение[1..5]);
        assert(n == 4349);
    });

    парсер.свяжиДефолт(delegate проц(ткст значение, бцел порядковый){
        ordinalCount = порядковый;
        if (порядковый == 0) {
            assert(значение == "ordinalTest1");
        }
        else if (порядковый == 1) {
            assert(значение == "ordinalTest2");
        }
    });

    парсер.свяжиДефолт("-", delegate проц(ткст значение, бцел порядковый){
        dashOrdinalCount = порядковый;
        if (порядковый == 0) {
            assert(значение == "dashTest1");
        }
        else if (порядковый == 1) {
            assert(значение == "dashTest2");
        }
    });

    парсер.свяжиДефолт("@", delegate проц(ткст значение, бцел порядковый){
        assert (значение == "atTest");
    });

    static ткст[] test1 = ["--h2", "-h", "-bb", "-b", "-n=4349", "-бул=да", "ordinalTest1", "ordinalTest2", "-dashTest1", "-dashTest2", "@atTest"];

    парсер.разбор(test1);
    assert(h2);
    assert(h);
    assert(b);
    assert(bb);
    assert(n == 4349);
    assert(ordinalCount == 1);
    assert(dashOrdinalCount == 1);
    
    h = h2 = b = bb = нет;
    булево = нет;
    n = ordinalCount = dashOrdinalCount = -1;

    static ткст[] test2 = ["-n=4349", "ordinalTest1", "@atTest", "--h2", "-b", "-bb", "-h", "-dashTest1", "-dashTest2", "ordinalTest2", "-бул=да"];

    парсер.разбор(test2, да);
    assert(h2 && h && b && bb && булево && (n ==4349));
    assert(ordinalCount == 1);
    assert(dashOrdinalCount == 1);
 
    h = h2 = b = bb = нет;
    булево = нет;
    n = ordinalCount = dashOrdinalCount = -1;

    static ткст[] test3 = ["-n=4349", "ordinalTest1", "@atTest", "--h2", "-b", "-bb", "-h", "-dashTest1", "-dashTest2", "ordinalTest2", "-бул=да"];

    парсер.разбор(test3, да);
    assert(h2 && h && b && bb && булево && (n ==4349));
    assert((ordinalCount == 1) && (dashOrdinalCount == 1));
 
    ordinalCount = dashOrdinalCount = -1;

    static ткст[] test4 = ["ordinalTest1", "ordinalTest2", "ordinalTest3", "ordinalTest4"];
    static ткст[] test5 = ["-dashTest1", "-dashTest2", "-dashTest3"];

    парсер.разбор(test4, да);
    assert(ordinalCount == 3);

    парсер.разбор(test5, да);
    assert(dashOrdinalCount == 2);
}
}
