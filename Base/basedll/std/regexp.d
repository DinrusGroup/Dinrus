
module std.regexp;
import std.outbuffer, std.bitarray, std.string;

struct т_регсвер
{
    цел рснач;          // индекс начала совпадения
    цел рскон;          // индекс по завершению совпадения
}

export extern(D)
ткст подставь(ткст текст, ткст образец, ткст формат, ткст атрибуты = null)
    {
        auto r = new РегВыр(образец, атрибуты);
    auto результат = r.замени(текст, формат);
    delete r;
    return результат;
    }
alias подставь sub;


export extern(D)
 ткст подставь(ткст текст, ткст образец, ткст delegate(РегВыр) дг, ткст атрибуты = null)
    {
      auto r = РегВыр(образец, атрибуты);
    рсим[] результат;
    цел последниндкс;
    цел смещение;

    результат = текст;
    последниндкс = 0;
    смещение = 0;
    while (r.проверь(текст, последниндкс))
    {
    цел so = r.псовп[0].рснач;
    цел eo = r.псовп[0].рскон;

    рсим[] замена = дг(r);

    // Optimize by using std.string.replace if possible - Dave Fladebo
    рсим[] срез = результат[смещение + so .. смещение + eo];
    if (r.атрибуты & РегВыр.РВА.глоб &&     // глоб, so replace all
        !(r.атрибуты & РегВыр.РВА.любрег) &&    // not ignoring case
        !(r.атрибуты & РегВыр.РВА.многострок) &&    // not многострок
        образец == срез)                // simple образец (exact match, no special символs)
    {
        debug(РегВыр)
        win.скажинс(фм("образец: %s, срез: %s, замена: %s\n", образец, результат[смещение + so .. смещение + eo],замена));
        результат = замени(результат,срез,замена);
        break;
    }

    результат = заменисрез(результат, результат[смещение + so .. смещение + eo], замена);

    if (r.атрибуты & РегВыр.РВА.глоб)
    {
        смещение += замена.length - (eo - so);

        if (последниндкс == eo)
        последниндкс++;     // always consume some source
        else
        последниндкс = eo;
    }
    else
        break;
    }
    delete r;

    return результат;

    }

export extern(D)
 РегВыр ищи(ткст текст, ткст образец, ткст атрибуты = null)
    {
    auto r = РегВыр(образец, атрибуты);

    if (r.проверь(текст))
        {
        }
        else
        {   delete r;
        r = null;
        }
    return r;
    }

export extern (D)
    цел найди(рткст текст, ткст образец, ткст атрибуты = null)//Возврат -1=совпадений нет, иначе=индекс совпадения
        {

    //debug win.скажинс("РегВыр.найди");
    //debug win.скажинс(текст);
            int i = -1;

    auto r = new РегВыр(образец, атрибуты);
    if (r.проверь(текст))
    {
    i = r.псовп[0].рснач;
    }
    delete r;
    return i;
     }

  export extern (D)
    цел найдирек(рткст текст, ткст образец, ткст атрибуты = null)
        {
        return rfind(текст, образец, атрибуты);
        }

   export extern (D)
    ткст[] разбей(ткст текст, ткст образец, ткст атрибуты = null)
        {
    //debug win.скажинс(текст);
    auto r = new РегВыр(образец, атрибуты);
    auto результат = r.разбей(текст);
    delete r;
    return результат;

        //return split(текст, образец, атрибуты);
        }


export extern(D)
 class ИсключениеРегВыр : Исключение
{

export:

    this(ткст сооб)
    {
    super("Неудачная операция с регулярным выражением: "~сооб,__FILE__,__LINE__);
    }
}


export extern (D) class РегВыр
{

   export ~this(){};

    export this(рсим[] образец, рсим[] атрибуты = null)
    {
    псовп = (&гсовп)[0 .. 1];
    компилируй(образец, атрибуты);
    }

    export static РегВыр opCall(рсим[] образец, рсим[] атрибуты = null)
    {
    return new РегВыр(образец, атрибуты);
    }

    export РегВыр ищи(рсим[] текст)
    {
    ввод = текст;
    псовп[0].рскон = 0;
    return this;
    }

    /** ditto */
   export  цел opApply(цел delegate(inout РегВыр) дг)
    {
    цел результат;
    РегВыр r = this;

    while (проверь())
    {
        результат = дг(r);
        if (результат)
        break;
    }

    return результат;
    }

   export  ткст сверь(т_мера n)
    {
    if (n >= псовп.length)
        return null;
    else
    {   т_мера рснач, рскон;
        рснач = псовп[n].рснач;
        рскон = псовп[n].рскон;
        if (рснач == рскон)
        return null;
        return ввод[рснач .. рскон];
    }
    }

   export  ткст перед()
    {
    return ввод[0 .. псовп[0].рснач];
    }

   export  ткст после()
    {
    return ввод[псовп[0].рскон .. $];
    }

    бцел члоподстр;     // number of parenthesized subexpression matches
    т_регсвер[] псовп;  // array [члоподстр + 1]

    рсим[] ввод;        // the текст to ищи

    // per instance:

    рсим[] образец;     // source text of the regular expression

    рсим[] флаги;       // source text of the атрибуты parameter

    цел ошибки;

    бцел атрибуты;

    enum РВА
    {
    глоб        = 1,    // has the g attribute
    любрег  = 2,    // has the i attribute
    многострок  = 4,    // if treat as multiple lines separated
                // by newlines, or as a single строка
    тчксовплф   = 8,    // if . matches \n
    }


private{
    т_мера истк;            // current source index in ввод[]
    т_мера старт_истк;      // starting index for сверь in ввод[]
    т_мера p;           // позиция of paрсer in образец[]
    т_регсвер гсовп;        // сверь for the entire regular expression
                // (serves as storage for псовп[0])

    ббайт[] программа;      // образец[] compiled целo regular expression программа
    БуферВывода буф;
    }

// Opcodes

enum : ббайт
{
    РВконец,        // end of программа
    РВсим,      // single символ
    РВлсим,     // single символ, case insensitive
    РВдим,      // single UCS символ
    РВлдим,     // single wide символ, case insensitive
    РВлюбсим,       // any символ
    РВлюбзвезда,        // ".*"
    РВткст,     // текст of символs
    РВлткст,        // текст of символs, case insensitive
    РВтестбит,      // any in bitmap, non-consuming
    РВбит,      // any in the bit map
    РВнебит,        // any not in the bit map
    РВдиапазон,     // any in the текст
    РВнедиапазон,       // any not in the текст
    РВили,      // a | b
    РВплюс,     // 1 or more
    РВзвезда,       // 0 or more
    РВвопрос,       // 0 or 1
    РВнм,       // n..m
    РВнмкю,     // n..m, non-greedy version
    РВначстр,       // beginning of строка
    РВконстр,       // end of строка
    РВвскоб,        // parenthesized subexpression
    РВгоуту,        // goto смещение

    РВгранслова,
    РВнегранслова,
    РВцифра,
    РВнецифра,
    РВпространство,
    РВнепространство,
    РВслово,
    РВнеслово,
    РВобрссыл,
};

// BUG: should this include '$'?
private цел слово_ли(дим c) { return числобукв_ли(c) || c == '_'; }

private бцел бескн = ~0u;

/* ********************************
 * Throws ИсключениеРегВыр on ошибка
 */

export проц компилируй(рсим[] образец, рсим[] атрибуты)
{
   debug(РегВыр) скажи(фм("РегВыр.компилируй('%s', '%s')\n", образец, атрибуты));

    this.атрибуты = 0;
    foreach (рсим c; атрибуты)
    {   РВА att;

    switch (c)
    {
        case 'g': att = РВА.глоб;       break;
        case 'i': att = РВА.любрег; break;
        case 'm': att = РВА.многострок; break;
        default:
        ошибка("нераспознанный атрибут");
        return;
    }
    if (this.атрибуты & att)
    {   ошибка("повторяющийся атрибут");
        return;
    }
    this.атрибуты |= att;
    }

    ввод = null;

    this.образец = образец;
    this.флаги = атрибуты;

    бцел oldre_nsub = члоподстр;
    члоподстр = 0;
    ошибки = 0;

    буф = new БуферВывода();
    буф.резервируй(образец.length * 8);
    p = 0;
    разборРегвыр();
    if (p < образец.length)
    {   ошибка("несовпадение ')'");
    }
    оптимизируй();
    программа = буф.данные;
    буф.данные = null;
   // delete буф;//Вызывает ошибку!)))

    if (члоподстр > oldre_nsub)
    {
    if (псовп.ptr is &гсовп)
        псовп = null;
    псовп.length = члоподстр + 1;
    }
    псовп[0].рснач = 0;
    псовп[0].рскон = 0;
}


 export рсим[][] разбей(рсим[] текст)
{
    debug(РегВыр) скажи("РегВыр.разбей()\n");

    рсим[][] результат;

    if (текст.length)
    {
    цел p = 0;
    цел q;
    for (q = p; q != текст.length;)
    {
        if (проверь(текст, q))
        {   цел e;

        q = псовп[0].рснач;
        e = псовп[0].рскон;
        if (e != p)
        {
            результат ~= текст[p .. q];
            for (цел i = 1; i < псовп.length; i++)
            {
            цел so = псовп[i].рснач;
            цел eo = псовп[i].рскон;
            if (so == eo)
            {   so = 0; // -1 gives array bounds ошибка
                eo = 0;
            }
            результат ~= текст[so .. eo];
            }
            q = p = e;
            continue;
        }
        }
        q++;
    }
    результат ~= текст[p .. текст.length];
    }
    else if (!проверь(текст))
    результат ~= текст;
    return результат;
}

 export цел найди(рсим[] текст)
{
    цел i;

    i = проверь(текст);
    if (i)
    i = псовп[0].рснач;
    else
    i = -1;         // no сверь
    return i;
}

 export рсим[][] сверь(рсим[] текст)
{
    рсим[][] результат;

    if (атрибуты & РВА.глоб)
    {
    цел последниндкс = 0;

    while (проверь(текст, последниндкс))
    {   цел eo = псовп[0].рскон;

        результат ~= ввод[псовп[0].рснач .. eo];
        if (последниндкс == eo)
        последниндкс++;     // always consume some source
        else
        последниндкс = eo;
    }
    }
    else
    {
    результат = выполни(текст);
    }
    return результат;
}

 export рсим[] замени(рсим[] текст, рсим[] формат)
{
    рсим[] результат;
    цел последниндкс;
    цел смещение;

    результат = текст;
    последниндкс = 0;
    смещение = 0;
    for (;;)
    {
    if (!проверь(текст, последниндкс))
        break;

    цел so = псовп[0].рснач;
    цел eo = псовп[0].рскон;

    рсим[] замена = замени(формат);

    // Optimize by using std.текст.замени if possible - Dave Fladebo
    рсим[] срез = результат[смещение + so .. смещение + eo];
    if (атрибуты & РВА.глоб &&      // глоб, so замени all
       !(атрибуты & РВА.любрег) &&  // not ignoring case
       !(атрибуты & РВА.многострок) &&  // not многострок
       образец == срез &&           // simple образец (exact сверь, no special символs)
       формат == замена)        // simple формат, not $ formats
    {
        debug(РегВыр)
        скажифнс("образец: %s срез: %s, формат: %s, замена: %s\n" ,образец,результат[смещение + so .. смещение + eo],формат, замена);
        результат = std.string.replace(результат,срез,замена);
        break;
    }

    результат = replaceSlice(результат, результат[смещение + so .. смещение + eo], замена);

    if (атрибуты & РВА.глоб)
    {
        смещение += замена.length - (eo - so);

        if (последниндкс == eo)
        последниндкс++;     // always consume some source
        else
        последниндкс = eo;
    }
    else
        break;
    }

    return результат;
}

 export рсим[][] выполни(рсим[] текст)
{
    debug(РегВыр) win.скажи(фм("РегВыр.выполни(текст = '%s')\n", текст));
    ввод = текст;
    псовп[0].рснач = 0;
    псовп[0].рскон = 0;
    return выполни();
}

 export рсим[][] выполни()
{
    if (!проверь())
    return null;

    auto результат = new рсим[][псовп.length];
    for (цел i = 0; i < псовп.length; i++)
    {
    if (псовп[i].рснач == псовп[i].рскон)
        результат[i] = null;
    else
        результат[i] = ввод[псовп[i].рснач .. псовп[i].рскон];
    }

    return результат;
}

 export цел проверь(рсим[] текст)
{
    return проверь(текст, 0 /*псовп[0].рскон*/);
}

export цел проверь()
{
    return проверь(ввод, псовп[0].рскон);
}

export цел проверь(ткст текст, цел стартиндекс)
{
    сим fiрсtc;
    бцел ит;

    ввод = текст;
    debug (РегВыр) win.скажи(фм("РегВыр.проверь(ввод[] = '%s', стартиндекс = %d)\n", ввод, стартиндекс));
    псовп[0].рснач = 0;
    псовп[0].рскон = 0;
    if (стартиндекс < 0 || стартиндекс > ввод.length)
    {
    return 0;           // fail
    }
    debug(РегВыр) выведиПрограмму(программа);

    // Fiрсt символ optimization
    fiрсtc = 0;
    if (программа[0] == РВсим)
    {
    fiрсtc = программа[1];
    if (атрибуты & РВА.любрег && буква_ли(fiрсtc))
        fiрсtc = 0;
    }

    for (ит = стартиндекс; ; ит++)
    {
    if (fiрсtc)
    {
        if (ит == ввод.length)
        break;          // no сверь
        if (ввод[ит] != fiрсtc)
        {
        ит++;
        if (!чр(ит, fiрсtc))    // if fiрсt символ not found
            break;      // no сверь
        }
    }
    for (цел i = 0; i < члоподстр + 1; i++)
    {
        псовп[i].рснач = -1;
        псовп[i].рскон = -1;
    }
    старт_истк = истк = ит;
    if (пробнсвер(0, программа.length))
    {
        псовп[0].рснач = ит;
        псовп[0].рскон = истк;
        //debug(РегВыр) эхо("старт = %d, end = %d\n", гсовп.рснач, гсовп.рскон);
        return 1;
    }
    // If possible сверь must старт at beginning, we are done
    if (программа[0] == РВначстр || программа[0] == РВлюбзвезда)
    {
        if (атрибуты & РВА.многострок)
        {
        // Scan for the следщ \n
        if (!чр(ит, '\n'))
            break;      // no сверь if '\n' not found
        }
        else
        break;
    }
    if (ит == ввод.length)
        break;
    //debug(РегВыр) эхо("Starting new try: '%.*т'\n", ввод[ит + 1 .. ввод.length]);
    }
    return 0;       // no сверь
}

export цел чр(inout бцел ит, рсим c)
{
    for (; ит < ввод.length; ит++)
    {
    if (ввод[ит] == c)
        return 1;
    }
    return 0;
}


export проц выведиПрограмму(ббайт[] прог)
{

    бцел pc;
    бцел длин;
    бцел n;
    бцел m;
    бкрат *pu;
    бцел *pбцел;

    debug(РегВыр) win.скажи("Вывод Программы()\n");
    for (pc = 0; pc < прог.length; )
    {
    debug(РегВыр) скажифнс("прог[pc] = %d, РВсим = %d, РВнмкю = %d\n", прог[pc], РВсим, РВнмкю);
    switch (прог[pc])
    {
        case РВсим:
        debug(РегВыр) win.скажи(фм("\tРВсим '%c'\n", прог[pc + 1]));
        pc += 1 + сим.sizeof;
        break;

        case РВлсим:
        debug(РегВыр) скажифнс("\tРВлсим '%c'\n", прог[pc + 1]);
        pc += 1 + сим.sizeof;
        break;

        case РВдим:
        debug(РегВыр) скажифнс("\tРВдим '%c'\n", *cast(дим *)&прог[pc + 1]);
        pc += 1 + дим.sizeof;
        break;

        case РВлдим:
        debug(РегВыр) скажифнс("\tРВлдим '%c'\n", *cast(дим *)&прог[pc + 1]);
        pc += 1 + дим.sizeof;
        break;

        case РВлюбсим:
        debug(РегВыр) win.скажи("\tРВлюбсим\n");
        pc++;
        break;

        case РВткст:
        длин = *cast(бцел *)&прог[pc + 1];
        debug(РегВыр) скажифнс("\tРВткст x%x, '%s'\n", длин,
            (&прог[pc + 1 + бцел.sizeof])[0 .. длин]);
        pc += 1 + бцел.sizeof + длин * рсим.sizeof;
        break;

        case РВлткст:
        длин = *cast(бцел *)&прог[pc + 1];
        debug(РегВыр) скажифнс("\tРВлткст x%x, '%s'\n", длин,
            (&прог[pc + 1 + бцел.sizeof])[0 .. длин]);
        pc += 1 + бцел.sizeof + длин * рсим.sizeof;
        break;

        case РВтестбит:
        pu = cast(бкрат *)&прог[pc + 1];
        debug(РегВыр) скажифнс("\tРВтестбит %d, %d\n", pu[0], pu[1]);
        длин = pu[1];
        pc += 1 + 2 * бкрат.sizeof + длин;
        break;

        case РВбит:
        pu = cast(бкрат *)&прог[pc + 1];
        длин = pu[1];
        debug(РегВыр) скажифнс("\tРВбит cmax=%x, длин=%d:", pu[0], длин);
        for (n = 0; n < длин; n++)
          debug(РегВыр)  скажифнс(" %x", прог[pc + 1 + 2 * бкрат.sizeof + n]);
        debug(РегВыр)скажифнс("\n");
        pc += 1 + 2 * бкрат.sizeof + длин;
        break;

        case РВнебит:
        pu = cast(бкрат *)&прог[pc + 1];
        debug(РегВыр) скажифнс("\tРВнебит %d, %d\n", pu[0], pu[1]);
        длин = pu[1];
        pc += 1 + 2 * бкрат.sizeof + длин;
        break;

        case РВдиапазон:
        длин = *cast(бцел *)&прог[pc + 1];
        debug(РегВыр) скажифнс("\tРВдиапазон %d\n", длин);
        // BUG: REAignoreCase?
        pc += 1 + бцел.sizeof + длин;
        break;

        case РВнедиапазон:
        длин = *cast(бцел *)&прог[pc + 1];
        debug(РегВыр) скажифнс("\tРВнедиапазон %d\n", длин);
        // BUG: REAignoreCase?
        pc += 1 + бцел.sizeof + длин;
        break;

        case РВначстр:
        debug(РегВыр) win.скажи("\tРВначстр\n");
        pc++;
        break;

        case РВконстр:
        debug(РегВыр) win.скажи("\tРВконстр\n");
        pc++;
        break;

        case РВили:
        длин = *cast(бцел *)&прог[pc + 1];
        debug(РегВыр) скажифнс("\tРВили %d, pc=>%d\n", длин, pc + 1 + бцел.sizeof + длин);
        pc += 1 + бцел.sizeof;
        break;

        case РВгоуту:
        длин = *cast(бцел *)&прог[pc + 1];
        debug(РегВыр) скажифнс("\tРВгоуту %d, pc=>%d\n", длин, pc + 1 + бцел.sizeof + длин);
        pc += 1 + бцел.sizeof;
        break;

        case РВлюбзвезда:
        debug(РегВыр) win.скажи("\tРВлюбзвезда\n");
        pc++;
        break;

        case РВнм:
        case РВнмкю:
        // длин, n, m, ()
        pбцел = cast(бцел *)&прог[pc + 1];
        длин = pбцел[0];
        n = pбцел[1];
        m = pбцел[2];
        debug(РегВыр) скажифнс("\tРВнм = %s длин=%d, n=%u, m=%u, pc=>%d\n", (прог[pc] == РВнмкю) ? "q" : " ",   длин, n, m, pc + 1 + бцел.sizeof * 3 + длин);
        pc += 1 + бцел.sizeof * 3;
        break;

        case РВвскоб:
        // длин, n, ()
        pбцел = cast(бцел *)&прог[pc + 1];
        длин = pбцел[0];
        n = pбцел[1];
        debug(РегВыр) скажифнс("\tРВвскоб длин=%d n=%d, pc=>%d\n", длин, n, pc + 1 + бцел.sizeof * 2 + длин);
        pc += 1 + бцел.sizeof * 2;
        break;

        case РВконец:
        debug(РегВыр) win.скажи("\tРВконец\n");
        return;

        case РВгранслова:
        debug(РегВыр) win.скажи("\tРВгранслова\n");
        pc++;
        break;

        case РВнегранслова:
        debug(РегВыр) win.скажи("\tРВнегранслова\n");
        pc++;
        break;

        case РВцифра:
        debug(РегВыр) win.скажи("\tРВцифра\n");
        pc++;
        break;

        case РВнецифра:
        debug(РегВыр) win.скажи("\tРВнецифра\n");
        pc++;
        break;

        case РВпространство:
        debug(РегВыр) win.скажи("\tРВпространство\n");
        pc++;
        break;

        case РВнепространство:
        debug(РегВыр) win.скажи("\tРВнепространство\n");
        pc++;
        break;

        case РВслово:
        debug(РегВыр) win.скажи("\tРВслово\n");
        pc++;
        break;

        case РВнеслово:
        debug(РегВыр) win.скажи("\tРВнеслово\n");
        pc++;
        break;

        case РВобрссыл:
        debug(РегВыр) скажифнс("\tРВобрссыл %d\n", прог[1]);
        pc += 2;
        break;

        default:
        assert(0);
    }
  }
  //}
}


export цел пробнсвер(цел pc, цел pcend)
{   цел srcsave;
    бцел длин;
    бцел n;
    бцел m;
    бцел count;
    бцел pop;
    бцел ss;
    т_регсвер *psave;
    бцел c1;
    бцел c2;
    бкрат* pu;
    бцел* pбцел;

    debug(РегВыр)   win.скажи(фм("РегВыр.пробнсвер(pc = %d, истк = '%s', pcend = %d)\n",
        pc, ввод[истк .. ввод.length], pcend));
    srcsave = истк;
    psave = null;
    for (;;)
    {
    if (pc == pcend)        // if done matching
    {   debug(РегВыр) win.скажи("\tконецпрог\n");
        return 1;
    }

    //эхо("\top = %d\n", программа[pc]);
    switch (программа[pc])
    {
        case РВсим:
        if (истк == ввод.length)
            goto Lnomatch;
        debug(РегВыр) win.скажи(фм("\tРВсим '%i', истк = '%i'\n", программа[pc + 1], ввод[истк]));
        if (программа[pc + 1] != ввод[истк])
            goto Lnomatch;
        истк++;
        pc += 1 + сим.sizeof;
        break;

        case РВлсим:
        if (истк == ввод.length)
            goto Lnomatch;
        debug(РегВыр) win.скажи(фм("\tРВлсим '%i', истк = '%i'\n", программа[pc + 1], ввод[истк]));
        c1 = программа[pc + 1];
        c2 = ввод[истк];
        if (c1 != c2)
        {
            if (проп_ли(cast(рсим)c2))
            c2 = std.ctype.toupper(cast(рсим)c2);
            else
            goto Lnomatch;
            if (c1 != c2)
            goto Lnomatch;
        }
        истк++;
        pc += 1 + сим.sizeof;
        break;

        case РВдим:
        debug(РегВыр) win.скажи(фм("\tРВдим '%i', истк = '%i'\n", *(cast(дим *)&программа[pc + 1]), ввод[истк]));
        if (истк == ввод.length)
            goto Lnomatch;
        if (*(cast(дим *)&программа[pc + 1]) != ввод[истк])
            goto Lnomatch;
        истк++;
        pc += 1 + дим.sizeof;
        break;

        case РВлдим:
        debug(РегВыр) win.скажи(фм("\tРВлдим '%i', истк = '%i'\n", *(cast(дим *)&программа[pc + 1]), ввод[истк]));
        if (истк == ввод.length)
            goto Lnomatch;
        c1 = *(cast(дим *)&программа[pc + 1]);
        c2 = ввод[истк];
        if (c1 != c2)
        {
            if (проп_ли(cast(рсим)c2))
            c2 = std.ctype.toupper(cast(рсим)c2);
            else
            goto Lnomatch;
            if (c1 != c2)
            goto Lnomatch;
        }
        истк++;
        pc += 1 + дим.sizeof;
        break;

        case РВлюбсим:
        debug(РегВыр) win.скажи("\tРВлюбсим\n");
        if (истк == ввод.length)
            goto Lnomatch;
        if (!(атрибуты & РВА.тчксовплф) && ввод[истк] == cast(рсим)'\n')
            goto Lnomatch;
        истк += std.utf.stride(ввод, истк);
        //истк++;
        pc++;
        break;

        case РВткст:
        длин = *cast(бцел *)&программа[pc + 1];
        debug(РегВыр) win.скажи(фм("\tРВткст x%x, '%s'\n", длин,
            (&программа[pc + 1 + бцел.sizeof])[0 .. длин]));
        if (истк + длин > ввод.length)
            goto Lnomatch;
        if (cidrus.memcmp(&программа[pc + 1 + бцел.sizeof], &ввод[истк], длин * рсим.sizeof))
            goto Lnomatch;
        истк += длин;
        pc += 1 + бцел.sizeof + длин * рсим.sizeof;
        break;

        case РВлткст:
        длин = *cast(бцел *)&программа[pc + 1];
        debug(РегВыр) win.скажи(фм("\tРВлткст x%x, '%s'\n", длин,
            (&программа[pc + 1 + бцел.sizeof])[0 .. длин]));
        if (истк + длин > ввод.length)
            goto Lnomatch;
        version (Win32)
        {
            if (memicmp(cast(сим*)&программа[pc + 1 + бцел.sizeof], &ввод[истк], длин * рсим.sizeof))
            goto Lnomatch;
        }
        else
        {
            if (icmp((cast(сим*)&программа[pc + 1 + бцел.sizeof])[0..длин],
                 ввод[истк .. истк + длин]))
            goto Lnomatch;
        }
        истк += длин;
        pc += 1 + бцел.sizeof + длин * рсим.sizeof;
        break;

        case РВтестбит:
        pu = (cast(бкрат *)&программа[pc + 1]);
        debug(РегВыр) win.скажи(фм("\tРВтестбит %d, %d, '%i', x%x\n",
            pu[0], pu[1], ввод[истк], ввод[истк]));
        if (истк == ввод.length)
            goto Lnomatch;
        длин = pu[1];
        c1 = ввод[истк];
        //эхо("[x%02x]=x%02x, x%02x\n", c1 >> 3, ((&программа[pc + 1 + 4])[c1 >> 3] ), (1 << (c1 & 7)));
        if (c1 <= pu[0] &&
            !((&(программа[pc + 1 + 4]))[c1 >> 3] & (1 << (c1 & 7))))
            goto Lnomatch;
        pc += 1 + 2 * бкрат.sizeof + длин;
        break;

        case РВбит:
        pu = (cast(бкрат *)&программа[pc + 1]);
        debug(РегВыр) win.скажи(фм("\tРВбит %d, %d, '%c'\n",
            pu[0], pu[1], ввод[истк]));
        if (истк == ввод.length)
            goto Lnomatch;
        длин = pu[1];
        c1 = ввод[истк];
        if (c1 > pu[0])
            goto Lnomatch;
        if (!((&программа[pc + 1 + 4])[c1 >> 3] & (1 << (c1 & 7))))
            goto Lnomatch;
        истк++;
        pc += 1 + 2 * бкрат.sizeof + длин;
        break;

        case РВнебит:
        pu = (cast(бкрат *)&программа[pc + 1]);
        debug(РегВыр) win.скажи(фм("\tРВнебит %d, %d, '%c'\n",
            pu[0], pu[1], ввод[истк]));
        if (истк == ввод.length)
            goto Lnomatch;
        длин = pu[1];
        c1 = ввод[истк];
        if (c1 <= pu[0] &&
            ((&программа[pc + 1 + 4])[c1 >> 3] & (1 << (c1 & 7))))
            goto Lnomatch;
        истк++;
        pc += 1 + 2 * бкрат.sizeof + длин;
        break;

        case РВдиапазон:
        длин = *cast(бцел *)&программа[pc + 1];
        debug(РегВыр) win.скажи(фм("\tРВдиапазон %d\n", длин));
        if (истк == ввод.length)
            goto Lnomatch;
        // BUG: РВА.любрег?
        if (memchr(cast(сим*)&программа[pc + 1 + бцел.sizeof], ввод[истк], длин) == null)
            goto Lnomatch;
        истк++;
        pc += 1 + бцел.sizeof + длин;
        break;

        case РВнедиапазон:
        длин = *cast(бцел *)&программа[pc + 1];
        debug(РегВыр) win.скажи(фм("\tРВнедиапазон %d\n", длин));
        if (истк == ввод.length)
            goto Lnomatch;
        // BUG: РВА.любрег?
        if (memchr(cast(сим*)&программа[pc + 1 + бцел.sizeof], ввод[истк], длин) != null)
            goto Lnomatch;
        истк++;
        pc += 1 + бцел.sizeof + длин;
        break;

        case РВначстр:
        debug(РегВыр) win.скажи("\tРВначстр\n");
        if (истк == 0)
        {
        }
        else if (атрибуты & РВА.многострок)
        {
            if (ввод[истк - 1] != '\n')
            goto Lnomatch;
        }
        else
            goto Lnomatch;
        pc++;
        break;

        case РВконстр:
        debug(РегВыр) win.скажи("\tРВконстр\n");
        if (истк == ввод.length)
        {
        }
        else if (атрибуты & РВА.многострок && ввод[истк] == '\n')
            истк++;
        else
            goto Lnomatch;
        pc++;
        break;

        case РВили:
        длин = (cast(бцел *)&программа[pc + 1])[0];
        debug(РегВыр) win.скажи(фм("\tРВили %d\n", длин));
        pop = pc + 1 + бцел.sizeof;
        ss = истк;
        if (пробнсвер(pop, pcend))
        {
            if (pcend != программа.length)
            {   цел т;

            т = истк;
            if (пробнсвер(pcend, программа.length))
            {   debug(РегВыр) win.скажи("\tпервый операнд соответствует\n");
                истк = т;
                return 1;
            }
            else
            {
                // If second branch doesn't сверь to end, take fiрсt anyway
                истк = ss;
                if (!пробнсвер(pop + длин, программа.length))
                {
                debug(РегВыр) win.скажи("\tпервый операнд соответствует\n");
                истк = т;
                return 1;
                }
            }
            истк = ss;
            }
            else
            {   debug(РегВыр) win.скажи("\tпервый операнд соответствует\n");
            return 1;
            }
        }
        pc = pop + длин;        // proceed with 2nd branch
        break;

        case РВгоуту:
        debug(РегВыр) win.скажи("\tРВгоуту\n");
        длин = (cast(бцел *)&программа[pc + 1])[0];
        pc += 1 + бцел.sizeof + длин;
        break;

        case РВлюбзвезда:
        debug(РегВыр) win.скажи("\tРВлюбзвезда\n");
        pc++;
        for (;;)
        {   цел s1;
            цел s2;

            s1 = истк;
            if (истк == ввод.length)
            break;
            if (!(атрибуты & РВА.тчксовплф) && ввод[истк] == '\n')
            break;
            истк++;
            s2 = истк;

            // If no сверь after consumption, but it
            // did сверь before, then no сверь
            if (!пробнсвер(pc, программа.length))
            {
            истк = s1;
            // BUG: should we save/restore псовп[]?
            if (пробнсвер(pc, программа.length))
            {
                истк = s1;      // no сверь
                break;
            }
            }
            истк = s2;
        }
        break;

        case РВнм:
        case РВнмкю:
        // длин, n, m, ()
        pбцел = cast(бцел *)&программа[pc + 1];
        длин = pбцел[0];
        n = pбцел[1];
        m = pбцел[2];
        debug(РегВыр) скажифнс("\tРВнм %s длин=%d, n=%u, m=%u\n", (программа[pc] == РВнмкю) ? cast(сим*)"q" : cast(сим*)"", длин, n, m);
        pop = pc + 1 + бцел.sizeof * 3;
        for (count = 0; count < n; count++)
        {
            if (!пробнсвер(pop, pop + длин))
            goto Lnomatch;
        }
        if (!psave && count < m)
        {
            //version (Win32)
            psave = cast(т_регсвер *)cidrus.alloca((члоподстр + 1) * т_регсвер.sizeof);
            //else
            //psave = new т_регсвер[члоподстр + 1];
        }
        if (программа[pc] == РВнмкю)    // if minimal munch
        {
            for (; count < m; count++)
            {   цел s1;

            cidrus.memcpy(psave, псовп.ptr, (члоподстр + 1) * т_регсвер.sizeof);
            s1 = истк;

            if (пробнсвер(pop + длин, программа.length))
            {
                истк = s1;
                cidrus.memcpy(псовп.ptr, psave, (члоподстр + 1) * т_регсвер.sizeof);
                break;
            }

            if (!пробнсвер(pop, pop + длин))
            {   debug(РегВыр) win.скажи("\tнесовпадение с подвыражением\n");
                break;
            }

            // If source is not consumed, don't
            // infinite loop on the сверь
            if (s1 == истк)
            {   debug(РегВыр) win.скажи("\tисточник не потреблён\n");
                break;
            }
            }
        }
        else    // maximal munch
        {
            for (; count < m; count++)
            {   цел s1;
            цел s2;

            cidrus.memcpy(psave, псовп.ptr, (члоподстр + 1) * т_регсвер.sizeof);
            s1 = истк;
            if (!пробнсвер(pop, pop + длин))
            {   debug(РегВыр) win.скажи("\tнесовпадение с подвыражением\n");
                break;
            }
            s2 = истк;

            // If source is not consumed, don't
            // infinite loop on the сверь
            if (s1 == s2)
            {   debug(РегВыр) win.скажи("\tисточник не потреблён\n");
                break;
            }

            // If no сверь after consumption, but it
            // did сверь before, then no сверь
            if (!пробнсвер(pop + длин, программа.length))
            {
                истк = s1;
                if (пробнсвер(pop + длин, программа.length))
                {
                истк = s1;      // no сверь
                cidrus.memcpy(псовп.ptr, psave, (члоподстр + 1) * т_регсвер.sizeof);
                break;
                }
            }
            истк = s2;
            }
        }
        debug(РегВыр) win.скажинс(фм("\tРВнм len=%d, n=%u, m=%u, DONE count=%d\n", длин, n, m, count));
        pc = pop + длин;
        break;

        case РВвскоб:
        // длин, ()
        debug(РегВыр) win.скажи("\tРВвскоб\n");
        pбцел = cast(бцел *)&программа[pc + 1];
        длин = pбцел[0];
        n = pбцел[1];
        pop = pc + 1 + бцел.sizeof * 2;
        ss = истк;
        if (!пробнсвер(pop, pop + длин))
            goto Lnomatch;
        псовп[n + 1].рснач = ss;
        псовп[n + 1].рскон = истк;
        pc = pop + длин;
        break;

        case РВконец:
        debug(РегВыр) win.скажи("\tРВконец\n");
        return 1;       // successful сверь

        case РВгранслова:
        debug(РегВыр) win.скажи("\tРВгранслова\n");
        if (истк > 0 && истк < ввод.length)
        {
            c1 = ввод[истк - 1];
            c2 = ввод[истк];
            if (!(
              (слово_ли(cast(рсим)c1) && !слово_ли(cast(рсим)c2)) ||
              (!слово_ли(cast(рсим)c1) && слово_ли(cast(рсим)c2))
             )
               )
            goto Lnomatch;
        }
        pc++;
        break;

        case РВнегранслова:
        debug(РегВыр) win.скажи("\tРВнегранслова\n");
        if (истк == 0 || истк == ввод.length)
            goto Lnomatch;
        c1 = ввод[истк - 1];
        c2 = ввод[истк];
        if (
            (слово_ли(cast(рсим)c1) && !слово_ли(cast(рсим)c2)) ||
            (!слово_ли(cast(рсим)c1) && слово_ли(cast(рсим)c2))
           )
            goto Lnomatch;
        pc++;
        break;

        case РВцифра:
        debug(РегВыр) win.скажи("\tРВцифра\n");
        if (истк == ввод.length)
            goto Lnomatch;
        if (!std.ctype.isdigit(ввод[истк]))
            goto Lnomatch;
        истк++;
        pc++;
        break;

        case РВнецифра:
        debug(РегВыр) win.скажи("\tРВнецифра\n");
        if (истк == ввод.length)
            goto Lnomatch;
        if (std.ctype.isdigit(ввод[истк]))
            goto Lnomatch;
        истк++;
        pc++;
        break;

        case РВпространство:
        debug(РегВыр) win.скажи("\tРВпространство\n");
        if (истк == ввод.length)
            goto Lnomatch;
        if (!межбукв_ли(ввод[истк]))
            goto Lnomatch;
        истк++;
        pc++;
        break;

        case РВнепространство:
        debug(РегВыр) win.скажи("\tРВнепространство\n");
        if (истк == ввод.length)
            goto Lnomatch;
        if (межбукв_ли(ввод[истк]))
            goto Lnomatch;
        истк++;
        pc++;
        break;

        case РВслово:
        debug(РегВыр) win.скажи("\tРВслово\n");
        if (истк == ввод.length)
            goto Lnomatch;
        if (!слово_ли(ввод[истк]))
            goto Lnomatch;
        истк++;
        pc++;
        break;

        case РВнеслово:
        debug(РегВыр) win.скажи("\tРВнеслово\n");
        if (истк == ввод.length)
            goto Lnomatch;
        if (слово_ли(ввод[истк]))
            goto Lnomatch;
        истк++;
        pc++;
        break;

        case РВобрссыл:
        {
        n = программа[pc + 1];
        debug(РегВыр) win.скажи(фм("\tРВобрссыл %d\n", n));

        цел so = псовп[n + 1].рснач;
        цел eo = псовп[n + 1].рскон;
        длин = eo - so;
        if (истк + длин > ввод.length)
            goto Lnomatch;
        else if (атрибуты & РВА.любрег)
        {
            if (icmp(ввод[истк .. истк + длин], ввод[so .. eo]))
            goto Lnomatch;
        }
        else if (cidrus.memcmp(&ввод[истк], &ввод[so], длин * рсим.sizeof))
            goto Lnomatch;
        истк += длин;
        pc += 2;
        break;
        }

        default:
        assert(0);
    }
    }

Lnomatch:
    debug(РегВыр) скажифнс("\tnomatch pc=%d\n", pc);
    истк = srcsave;
    return 0;
}

/* =================== Compiler ================== */

export цел разборРегвыр()
{   бцел смещение;
    бцел переходКсмещению;
    бцел len1;
    бцел len2;

    debug(РегВыр) скажифнс("разборРегвыр() '%s'\n", образец[p .. образец.length]);
    смещение = буф.смещение;
    for (;;)
    {
    assert(p <= образец.length);
    if (p == образец.length)
    {   буф.пиши(РВконец);
        return 1;
    }
    switch (образец[p])
    {
        case ')':
        return 1;

        case '|':
        p++;
        переходКсмещению = буф.смещение;
        буф.пиши(РВгоуту);
        буф.пиши(cast(бцел)0);
        len1 = буф.смещение - смещение;
        буф.простели(смещение, 1 + бцел.sizeof);
        переходКсмещению += 1 + бцел.sizeof;
        разборРегвыр();
        len2 = буф.смещение - (переходКсмещению + 1 + бцел.sizeof);
        буф.данные[смещение] = РВили;
        (cast(бцел *)&буф.данные[смещение + 1])[0] = len1;
        (cast(бцел *)&буф.данные[переходКсмещению + 1])[0] = len2;
        break;

        default:
        разборКуска();
        break;
    }
    }
}

export цел разборКуска()
{   бцел смещение;
    бцел длин;
    бцел n;
    бцел m;
    ббайт op;
    цел plength = образец.length;

    debug(РегВыр)  скажифнс("разборКуска() '%s'\n", образец[p .. образец.length]);
    смещение = буф.смещение;
    разборАтома();
    if (p == plength)
    return 1;
    switch (образец[p])
    {
    case '*':
        // Special optimization: замени .* with РВлюбзвезда
        if (буф.смещение - смещение == 1 &&
        буф.данные[смещение] == РВлюбсим &&
        p + 1 < plength &&
        образец[p + 1] != '?')
        {
        буф.данные[смещение] = РВлюбзвезда;
        p++;
        break;
        }

        n = 0;
        m = бескн;
        goto Lnm;

    case '+':
        n = 1;
        m = бескн;
        goto Lnm;

    case '?':
        n = 0;
        m = 1;
        goto Lnm;

    case '{':   // {n} {n,} {n,m}
        p++;
        if (p == plength || !std.ctype.isdigit(образец[p]))
        goto Lerr;
        n = 0;
        do
        {
        // BUG: хэндл overflow
        n = n * 10 + образец[p] - '0';
        p++;
        if (p == plength)
            goto Lerr;
        } while (std.ctype.isdigit(образец[p]));
        if (образец[p] == '}')      // {n}
        {   m = n;
        goto Lnm;
        }
        if (образец[p] != ',')
        goto Lerr;
        p++;
        if (p == plength)
        goto Lerr;
        if (образец[p] == /*{*/ '}')    // {n,}
        {   m = бескн;
        goto Lnm;
        }
        if (!std.ctype.isdigit(образец[p]))
        goto Lerr;
        m = 0;          // {n,m}
        do
        {
        // BUG: хэндл overflow
        m = m * 10 + образец[p] - '0';
        p++;
        if (p == plength)
            goto Lerr;
        } while (std.ctype.isdigit(образец[p]));
        if (образец[p] != /*{*/ '}')
        goto Lerr;
        goto Lnm;

    Lnm:
        p++;
        op = РВнм;
        if (p < plength && образец[p] == '?')
        {   op = РВнмкю;    // minimal munch version
        p++;
        }
        длин = буф.смещение - смещение;
        буф.простели(смещение, 1 + бцел.sizeof * 3);
        буф.данные[смещение] = op;
        бцел* pбцел = cast(бцел *)&буф.данные[смещение + 1];
        pбцел[0] = длин;
        pбцел[1] = n;
        pбцел[2] = m;
        break;

    default:
        break;
    }
    return 1;

Lerr:
    ошибка("неверно оформленные {n,m}");
    assert(0);
}

export цел разборАтома()
{   ббайт op;
    бцел смещение;
    рсим c;

    debug(РегВыр) скажифнс("разборАтома() '%s'\n", образец[p .. образец.length]);
    if (p < образец.length)
    {
    c = образец[p];
    switch (c)
    {
        case '*':
        case '+':
        case '?':
        ошибка("*+? недопустимо в атоме");
        p++;
        return 0;

        case '(':
        p++;
        буф.пиши(РВвскоб);
        смещение = буф.смещение;
        буф.пиши(cast(бцел)0);      // резервируй space for length
        буф.пиши(члоподстр);
        члоподстр++;
        разборРегвыр();
        *cast(бцел *)&буф.данные[смещение] =
            буф.смещение - (смещение + бцел.sizeof * 2);
        if (p == образец.length || образец[p] != ')')
        {
            ошибка("')' ожидалось");
            return 0;
        }
        p++;
        break;

        case '[':
        if (!разборДиапазона())
            return 0;
        break;

        case '.':
        p++;
        буф.пиши(РВлюбсим);
        break;

        case '^':
        p++;
        буф.пиши(РВначстр);
        break;

        case '$':
        p++;
        буф.пиши(РВконстр);
        break;

        case '\\':
        p++;
        if (p == образец.length)
        {
        ошибка("отсутствие символов после '\\'");
            return 0;
        }
        c = образец[p];
        switch (c)
        {
            case 'b':    op = РВгранслова;   goto Lop;
            case 'B':    op = РВнегранслова; goto Lop;
            case 'd':    op = РВцифра;       goto Lop;
            case 'D':    op = РВнецифра;     goto Lop;
            case 's':    op = РВпространство;        goto Lop;
            case 'S':    op = РВнепространство;  goto Lop;
            case 'w':    op = РВслово;       goto Lop;
            case 'W':    op = РВнеслово;     goto Lop;

            Lop:
            буф.пиши(op);
            p++;
            break;

            case 'f':
            case 'n':
            case 'r':
            case 't':
            case 'v':
            case 'c':
            case 'x':
            case 'u':
            case '0':
            c = cast(сим)escape();
            goto Lbyte;

            case '1': case '2': case '3':
            case '4': case '5': case '6':
            case '7': case '8': case '9':
            c -= '1';
            if (c < члоподстр)
            {   буф.пиши(РВобрссыл);
                буф.пиши(cast(ббайт)c);
            }
            else
            {   ошибка("нет соответствующей обратной ссылки");
                return 0;
            }
            p++;
            break;

            default:
            p++;
            goto Lbyte;
        }
        break;

        default:
        p++;
        Lbyte:
        op = РВсим;
        if (атрибуты & РВА.любрег)
        {
            if (буква_ли(c))
            {
            op = РВлсим;
            c = cast(сим)std.ctype.toupper(c);
            }
        }
        if (op == РВсим && c <= 0xFF)
        {
            // Look ahead and see if we can make this целo
            // an РВткст
            цел q;
            цел длин;

            for (q = p; q < образец.length; ++q)
            {   рсим qc = образец[q];

            switch (qc)
            {
                case '{':
                case '*':
                case '+':
                case '?':
                if (q == p)
                    goto Lсим;
                q--;
                break;

                case '(':   case ')':
                case '|':
                case '[':   case ']':
                case '.':   case '^':
                case '$':   case '\\':
                case '}':
                break;

                default:
                continue;
            }
            break;
            }
            длин = q - p;
            if (длин > 0)
            {
            debug(РегВыр) скажифнс("записывается текст длин %d, c = '%c', образец[p] = '%c'\n", длин+1, c, образец[p]);
            буф.резервируй(5 + (1 + длин) * рсим.sizeof);
            буф.пиши((атрибуты & РВА.любрег) ? РВлткст : РВткст);
            буф.пиши(длин + 1);
            буф.пиши(c);
            буф.пиши(образец[p .. p + длин]);
            p = q;
            break;
            }
        }
        if (c >= 0x80)
        {
            // Convert to дим opcode
            op = (op == РВсим) ? РВдим : РВлдим;
            буф.пиши(op);
            буф.пиши(c);
        }
        else
        {
         Lсим:
            debug(РегВыр) скажифнс(" РВсим '%c'\n", c);
            буф.пиши(op);
            буф.пиши(cast(сим)c);
        }
        break;
    }
    }
    return 1;
}


class Диапазон
{
    бцел maxc;
    бцел maxb;
    БуферВывода буф;
    ббайт* base;
    МассивБит биты;

    this(БуферВывода буф)
    {
    this.буф = буф;
    if (буф.данные.length)
        this.base = &буф.данные[буф.смещение];
    }

    проц устбитмакс(бцел u)
    {   бцел b;

    //эхо("устбитмакс(x%x), maxc = x%x\n", u, maxc);
    if (u > maxc)
    {
        maxc = u;
        b = u / 8;
        if (b >= maxb)
        {   бцел u2;

        u2 = base ? base - &буф.данные[0] : 0;
        буф.занули(b - maxb + 1);
        base = &буф.данные[u2];
        maxb = b + 1;
        //биты = (cast(bit*)this.base)[0 .. maxc + 1];
        биты.ptr = cast(бцел*)this.base;
        }
        биты.длин = maxc + 1;
    }
    }

    проц устбит2(бцел u)
    {
    устбитмакс(u + 1);
    //эхо("устбит2 [x%02x] |= x%02x\n", u >> 3, 1 << (u & 7));
    биты[u] = 1;
    }

};

цел разборДиапазона()
{   ббайт op;
    цел c;
    цел c2;
    бцел i;
    бцел cmax;
    бцел смещение;

    cmax = 0x7F;
    p++;
    op = РВбит;
    if (p == образец.length)
    goto Lerr;
    if (образец[p] == '^')
    {   p++;
    op = РВнебит;
    if (p == образец.length)
        goto Lerr;
    }
    буф.пиши(op);
    смещение = буф.смещение;
    буф.пиши(cast(бцел)0);      // резервируй space for length
    буф.резервируй(128 / 8);
    auto r = new Диапазон(буф);
    if (op == РВнебит)
    r.устбит2(0);
    switch (образец[p])
    {
    case ']':
    case '-':
        c = образец[p];
        p++;
        r.устбит2(c);
        break;

    default:
        break;
    }

    enum РС { старт, рлитерал, тире };
    РС рс;

    рс = РС.старт;
    for (;;)
    {
    if (p == образец.length)
        goto Lerr;
    switch (образец[p])
    {
        case ']':
        switch (рс)
        {   case РС.тире:
            r.устбит2('-');
            case РС.рлитерал:
            r.устбит2(c);
            break;
            case РС.старт:
            break;
            default:
            assert(0);
        }
        p++;
        break;

        case '\\':
        p++;
        r.устбитмакс(cmax);
        if (p == образец.length)
            goto Lerr;
        switch (образец[p])
        {
            case 'd':
            for (i = '0'; i <= '9'; i++)
                r.биты[i] = 1;
            goto Lрс;

            case 'D':
            for (i = 1; i < '0'; i++)
                r.биты[i] = 1;
            for (i = '9' + 1; i <= cmax; i++)
                r.биты[i] = 1;
            goto Lрс;

            case 's':
            for (i = 0; i <= cmax; i++)
                if (межбукв_ли(i))
                r.биты[i] = 1;
            goto Lрс;

            case 'S':
            for (i = 1; i <= cmax; i++)
                if (!межбукв_ли(i))
                r.биты[i] = 1;
            goto Lрс;

            case 'w':
            for (i = 0; i <= cmax; i++)
                if (слово_ли(cast(рсим)i))
                r.биты[i] = 1;
            goto Lрс;

            case 'W':
            for (i = 1; i <= cmax; i++)
                if (!слово_ли(cast(рсим)i))
                r.биты[i] = 1;
            goto Lрс;

            Lрс:
            switch (рс)
            {   case РС.тире:
                r.устбит2('-');
                case РС.рлитерал:
                r.устбит2(c);
                break;
                default:
                break;
            }
            рс = РС.старт;
            continue;

            default:
            break;
        }
        c2 = escape();
        goto LДиапазон;

        case '-':
        p++;
        if (рс == РС.старт)
            goto LДиапазон;
        else if (рс == РС.рлитерал)
            рс = РС.тире;
        else if (рс == РС.тире)
        {
            r.устбит2(c);
            r.устбит2('-');
            рс = РС.старт;
        }
        continue;

        default:
        c2 = образец[p];
        p++;
        LДиапазон:
        switch (рс)
        {   case РС.рлитерал:
            r.устбит2(c);
            case РС.старт:
            c = c2;
            рс = РС.рлитерал;
            break;

            case РС.тире:
            if (c > c2)
            {   ошибка("инвертированный диапазон в классе символов");
                return 0;
            }
            r.устбитмакс(c2);
            //эхо("c = %x, c2 = %x\n",c,c2);
            for (; c <= c2; c++)
                r.биты[c] = 1;
            рс = РС.старт;
            break;

            default:
            assert(0);
        }
        continue;
    }
    break;
    }
    if (атрибуты & РВА.любрег)
    {
    // BUG: what about дим?
    r.устбитмакс(0x7F);
    for (c = 'a'; c <= 'z'; c++)
    {
        if (r.биты[c])
        r.биты[c + 'A' - 'a'] = 1;
        else if (r.биты[c + 'A' - 'a'])
        r.биты[c] = 1;
    }
    }
    //эхо("maxc = %d, maxb = %d\n",r.maxc,r.maxb);
    (cast(бкрат *)&буф.данные[смещение])[0] = cast(бкрат)r.maxc;
    (cast(бкрат *)&буф.данные[смещение])[1] = cast(бкрат)r.maxb;
    return 1;

Lerr:
    ошибка("неверный диапазон");
    return 0;
}

проц ошибка(ткст msg)
{
    ошибки++;
    debug(РегВыр) скажифнс("ошибка: %s\n", msg);
//assert(0);
//*(сим*)0=0;
    throw new ИсключениеРегВыр(msg);
}

// p is following the \ сим
цел escape()
in
{
    assert(p < образец.length);
}
body
{   цел c;
    цел i;
    рсим tc;

    c = образец[p];     // none of the cases are multibyte
    switch (c)
    {
    case 'b':    c = '\b';  break;
    case 'f':    c = '\f';  break;
    case 'n':    c = '\n';  break;
    case 'r':    c = '\r';  break;
    case 't':    c = '\t';  break;
    case 'v':    c = '\v';  break;

    // BUG: Perl does \a and \e too, should we?

    case 'c':
        ++p;
        if (p == образец.length)
        goto Lretc;
        c = образец[p];
        // Note: we are deliberately not allowing дим letteрс
        if (!(('a' <= c && c <= 'z') || ('A' <= c && c <= 'Z')))
        {
         Lcerr:
        ошибка("ожидалась буква после \\c");
        return 0;
        }
        c &= 0x1F;
        break;

    case '0':
    case '1':
    case '2':
    case '3':
    case '4':
    case '5':
    case '6':
    case '7':
        c -= '0';
        for (i = 0; i < 2; i++)
        {
        p++;
        if (p == образец.length)
            goto Lretc;
        tc = образец[p];
        if ('0' <= tc && tc <= '7')
        {   c = c * 8 + (tc - '0');
            // Treat overflow as if last
            // digit was not an octal digit
            if (c >= 0xFF)
            {   c >>= 3;
            return c;
            }
        }
        else
            return c;
        }
        break;

    case 'x':
        c = 0;
        for (i = 0; i < 2; i++)
        {
        p++;
        if (p == образец.length)
            goto Lretc;
        tc = образец[p];
        if ('0' <= tc && tc <= '9')
            c = c * 16 + (tc - '0');
        else if ('a' <= tc && tc <= 'f')
            c = c * 16 + (tc - 'a' + 10);
        else if ('A' <= tc && tc <= 'F')
            c = c * 16 + (tc - 'A' + 10);
        else if (i == 0)    // if no hex digits after \x
        {
            // Not a значid \xXX sequence
            return 'x';
        }
        else
            return c;
        }
        break;

    case 'u':
        c = 0;
        for (i = 0; i < 4; i++)
        {
        p++;
        if (p == образец.length)
            goto Lretc;
        tc = образец[p];
        if ('0' <= tc && tc <= '9')
            c = c * 16 + (tc - '0');
        else if ('a' <= tc && tc <= 'f')
            c = c * 16 + (tc - 'a' + 10);
        else if ('A' <= tc && tc <= 'F')
            c = c * 16 + (tc - 'A' + 10);
        else
        {
            // Not a значid \uXXXX sequence
            p -= i;
            return 'u';
        }
        }
        break;

    default:
        break;
    }
    p++;
Lretc:
    return c;
}

/* ==================== optimizer ======================= */

export проц оптимизируй()
{   ббайт[] прог;

    debug(РегВыр) win.скажи("РегВыр.оптимизируй()\n");
    прог = буф.вБайты();
    for (т_мера i = 0; 1;)
    {
    //эхо("\tprog[%d] = %d, %d\n", i, прог[i], РВткст);
    switch (прог[i])
    {
        case РВконец:
        case РВлюбсим:
        case РВлюбзвезда:
        case РВобрссыл:
        case РВконстр:
        case РВсим:
        case РВлсим:
        case РВдим:
        case РВлдим:
        case РВткст:
        case РВлткст:
        case РВтестбит:
        case РВбит:
        case РВнебит:
        case РВдиапазон:
        case РВнедиапазон:
        case РВгранслова:
        case РВнегранслова:
        case РВцифра:
        case РВнецифра:
        case РВпространство:
        case РВнепространство:
        case РВслово:
        case РВнеслово:
        return;

        case РВначстр:
        i++;
        continue;

        case РВили:
        case РВнм:
        case РВнмкю:
        case РВвскоб:
        case РВгоуту:
        {
        auto bitbuf = new БуферВывода;
        auto r = new Диапазон(bitbuf);
        бцел смещение;

        смещение = i;
        if (starрchars(r, прог[i .. прог.length]))
        {
            debug(РегВыр) эхо("\tfilter built\n");
            буф.простели(смещение, 1 + 4 + r.maxb);
            буф.данные[смещение] = РВтестбит;
            (cast(бкрат *)&буф.данные[смещение + 1])[0] = cast(бкрат)r.maxc;
            (cast(бкрат *)&буф.данные[смещение + 1])[1] = cast(бкрат)r.maxb;
            i = смещение + 1 + 4;
            буф.данные[i .. i + r.maxb] = r.base[0 .. r.maxb];
        }
        return;
        }
        default:
        assert(0);
    }
    }
}

/////////////////////////////////////////
// OR the leading символ биты целo r.
// Limit the символ Диапазон from 0..7F,
// пробнсвер() will allow through anything over maxc.
// Return 1 if success, 0 if we can't build a filter or
// if there is no poцел to one.

export цел starрchars(Диапазон r, ббайт[] прог)
{   рсим c;
    бцел maxc;
    бцел maxb;
    бцел длин;
    бцел b;
    бцел n;
    бцел m;
    ббайт* pop;

  //  debug(РегВыр) скажифнс("РегВыр.starрchars(прог = %p, progend = %p)\n", прог, progend);
    for (т_мера i = 0; i < прог.length;)
    {
    switch (прог[i])
    {
        case РВсим:
        c = прог[i + 1];
        if (c <= 0x7F)
            r.устбит2(c);
        return 1;

        case РВлсим:
        c = прог[i + 1];
        if (c <= 0x7F)
        {   r.устбит2(c);
            r.устбит2(std.ctype.tolower(cast(рсим)c));
        }
        return 1;

        case РВдим:
        case РВлдим:
        return 1;

        case РВлюбсим:
        return 0;       // no poцел

        case РВткст:
        длин = *cast(бцел *)&прог[i + 1];
        assert(длин);
        c = *cast(рсим *)&прог[i + 1 + бцел.sizeof];
        debug(РегВыр) скажифнс("\tРВткст %d, '%c'\n", длин, c);
        if (c <= 0x7F)
            r.устбит2(c);
        return 1;

        case РВлткст:
        длин = *cast(бцел *)&прог[i + 1];
        assert(длин);
        c = *cast(рсим *)&прог[i + 1 + бцел.sizeof];
        debug(РегВыр) скажифнс("\tРВлткст %d, '%c'\n", длин, c);
        if (c <= 0x7F)
        {   r.устбит2(std.ctype.toupper(cast(рсим)c));
            r.устбит2(std.ctype.tolower(cast(рсим)c));
        }
        return 1;

        case РВтестбит:
        case РВбит:
        maxc = (cast(бкрат *)&прог[i + 1])[0];
        maxb = (cast(бкрат *)&прог[i + 1])[1];
        if (maxc <= 0x7F)
            r.устбитмакс(maxc);
        else
            maxb = r.maxb;
        for (b = 0; b < maxb; b++)
            r.base[b] |= прог[i + 1 + 4 + b];
        return 1;

        case РВнебит:
        maxc = (cast(бкрат *)&прог[i + 1])[0];
        maxb = (cast(бкрат *)&прог[i + 1])[1];
        if (maxc <= 0x7F)
            r.устбитмакс(maxc);
        else
            maxb = r.maxb;
        for (b = 0; b < maxb; b++)
            r.base[b] |= ~прог[i + 1 + 4 + b];
        return 1;

        case РВначстр:
        case РВконстр:
        return 0;

        case РВили:
        длин = (cast(бцел *)&прог[i + 1])[0];
        return starрchars(r, прог[i + 1 + бцел.sizeof .. прог.length]) &&
               starрchars(r, прог[i + 1 + бцел.sizeof + длин .. прог.length]);

        case РВгоуту:
        длин = (cast(бцел *)&прог[i + 1])[0];
        i += 1 + бцел.sizeof + длин;
        break;

        case РВлюбзвезда:
        return 0;

        case РВнм:
        case РВнмкю:
        // длин, n, m, ()
        длин = (cast(бцел *)&прог[i + 1])[0];
        n   = (cast(бцел *)&прог[i + 1])[1];
        m   = (cast(бцел *)&прог[i + 1])[2];
        pop = &прог[i + 1 + бцел.sizeof * 3];
        if (!starрchars(r, pop[0 .. длин]))
            return 0;
        if (n)
            return 1;
        i += 1 + бцел.sizeof * 3 + длин;
        break;

        case РВвскоб:
        // длин, ()
        длин = (cast(бцел *)&прог[i + 1])[0];
        n   = (cast(бцел *)&прог[i + 1])[1];
        pop = &прог[0] + i + 1 + бцел.sizeof * 2;
        return starрchars(r, pop[0 .. длин]);

        case РВконец:
        return 0;

        case РВгранслова:
        case РВнегранслова:
        return 0;

        case РВцифра:
        r.устбитмакс('9');
        for (c = '0'; c <= '9'; c++)
            r.биты[c] = 1;
        return 1;

        case РВнецифра:
        r.устбитмакс(0x7F);
        for (c = 0; c <= '0'; c++)
            r.биты[c] = 1;
        for (c = '9' + 1; c <= r.maxc; c++)
            r.биты[c] = 1;
        return 1;

        case РВпространство:
        r.устбитмакс(0x7F);
        for (c = 0; c <= r.maxc; c++)
            if (межбукв_ли(c))
            r.биты[c] = 1;
        return 1;

        case РВнепространство:
        r.устбитмакс(0x7F);
        for (c = 0; c <= r.maxc; c++)
            if (!межбукв_ли(c))
            r.биты[c] = 1;
        return 1;

        case РВслово:
        r.устбитмакс(0x7F);
        for (c = 0; c <= r.maxc; c++)
            if (слово_ли(cast(рсим)c))
            r.биты[c] = 1;
        return 1;

        case РВнеслово:
        r.устбитмакс(0x7F);
        for (c = 0; c <= r.maxc; c++)
            if (!слово_ли(cast(рсим)c))
            r.биты[c] = 1;
        return 1;

        case РВобрссыл:
        return 0;

        default:
        assert(0);
    }
    }
    return 1;
}


 export рсим[] замени(рсим[] формат)
{
    return замени3(формат, ввод, псовп[0 .. члоподстр + 1]);
}

// Static version that doesn't require a РегВыр объект to be created

 export static рсим[] замени3(рсим[] формат, рсим[] ввод, т_регсвер[] псовп)
{
    рсим[] результат;
    бцел c2;
    цел рснач;
    цел рскон;
    цел i;
   debug(РегВыр) скажифнс("замени3(формат = '%s', ввод = '%s')\n", формат, ввод);
    результат.length = формат.length;
    результат.length = 0;
    for (т_мера f = 0; f < формат.length; f++)
    {
    auto c = формат[f];
      L1:
    if (c != '$')
    {
        результат ~= c;
        continue;
    }
    ++f;
    if (f == формат.length)
    {
        результат ~= '$';
        break;
    }
    c = формат[f];
    switch (c)
    {
        case '&':
        рснач = псовп[0].рснач;
        рскон = псовп[0].рскон;
        goto Lstring;

        case '`':
        рснач = 0;
        рскон = псовп[0].рснач;
        goto Lstring;

        case '\'':
        рснач = псовп[0].рскон;
        рскон = ввод.length;
        goto Lstring;

        case '0': case '1': case '2': case '3': case '4':
        case '5': case '6': case '7': case '8': case '9':
        i = c - '0';
        if (f + 1 == формат.length)
        {
            if (i == 0)
            {
            результат ~= '$';
            результат ~= c;
            continue;
            }
        }
        else
        {
            c2 = формат[f + 1];
            if (c2 >= '0' && c2 <= '9')
            {   i = (c - '0') * 10 + (c2 - '0');
            f++;
            }
            if (i == 0)
            {
            результат ~= '$';
            результат ~= c;
            c = cast(сим)c2;
            goto L1;
            }
        }

        if (i < псовп.length)
        {   рснач = псовп[i].рснач;
            рскон = псовп[i].рскон;
            goto Lstring;
        }
        break;

        Lstring:
        if (рснач != рскон)
            результат ~= ввод[рснач .. рскон];
        break;

        default:
        результат ~= '$';
        результат ~= c;
        break;
    }
    }
    return результат;
}

 export рсим[] замениСтарый(рсим[] формат)
{
    рсим[] результат;

//debug(РегВыр)  скажифнс("замени: this = %p so = %d, eo = %d\n", this, псовп[0].рснач, псовп[0].рскон);
//эхо("3input = '%.*т'\n", ввод);
    результат.length = формат.length;
    результат.length = 0;
    for (т_мера i; i < формат.length; i++)
    {
    auto c = формат[i];
    switch (c)
    {
        case '&':
//эхо("сверь = '%.*т'\n", ввод[псовп[0].рснач .. псовп[0].рскон]);
        результат ~= ввод[псовп[0].рснач .. псовп[0].рскон];
        break;

        case '\\':
        if (i + 1 < формат.length)
        {
            c = формат[++i];
            if (c >= '1' && c <= '9')
            {   бцел j;

            j = c - '0';
            if (j <= члоподстр && псовп[j].рснач != псовп[j].рскон)
                результат ~= ввод[псовп[j].рснач .. псовп[j].рскон];
            break;
            }
        }
        результат ~= c;
        break;

        default:
        результат ~= c;
        break;
    }
    }
    return результат;
}

}


////////////////////////
int rfind(рсим[] str, char[] pattern, char[] attributes = null)
{
    int i = -1;
    int lastindex = 0;

    auto r = new РегВыр(pattern, attributes);
    while (r.проверь(str, lastindex))
    {   int eo = r.псовп[0].рскон;
    i = r.псовп[0].рснач;
    if (lastindex == eo)
        lastindex++;        // always consume some source
    else
        lastindex = eo;
    }
    delete r;
    return i;
}