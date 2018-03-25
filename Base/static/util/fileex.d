
module util.fileex;

version(unix)   version = Unix;
version(Unix)   version = Posix;
version(linux)  version = Posix;
version(darwin) version = Posix;

private{
    import dinrus;

    import util.str;
    import util.booltype;   // definition of Да и Нет
    alias util.booltype.Да Да;
    alias util.booltype.Нет Нет;
    alias util.booltype.Бул Бул;
    static import util.pathex;

    ткст[] vGrepOpts;

    class ФайлДопИскл : Ошибка
    {
        this(ткст pMsg)
        {
            super (__FILE__ ~ ":" ~ pMsg);
        }
    }

}

public {
    version(BuildVerbose) Бул подробно;
    Бул тестЗапуск;
    ткст расширениеЭкзэ;
    ткст идПути;
}
// Module constructor
// ----------------------------------------------
static this()
// ----------------------------------------------
{
    version(Windows)
    {
        расширениеЭкзэ = "exe";
        идПути = "PATH";
    }
    version(Posix)
    {
        расширениеЭкзэ = "";
        идПути = "PATH";
    }
    version(BuildVerbose) подробно = Нет;
    тестЗапуск = Нет;
}

enum ОпцПолучения
{
    Есть = 'e',   // Must exist otherwise Get fails.
    Всегда = 'a'    // Get always returns something, even if it's just
                    //   empty строки for a missing файл.
};

// Зачитать весь файл в текстовое представление.
ткст дайТекст(ткст имяф, ОпцПолучения опц = ОпцПолучения.Всегда)
{
    ткст текстф;
    if (естьФайл( имяф))
    {
        текстф = cast(ткст) читайФайл(имяф);
        if ( (текстф.length == 0) ||
             (текстф[$-1] != '\n'))
             текстф ~= РАЗДСТР;
    }
    else if (опц == ОпцПолучения.Есть) {
        ошибка( фм("Файл '%s' не найден.", имяф));
    }
    return текстф;

}

// Чит a entire файл in to a установи of строки (strings).
ткст[] дайТекстПострочно(ткст имяф, ОпцПолучения опц = ОпцПолучения.Всегда)
{
    ткст[] строки;
    ткст   текст;
    текст = дайТекст(имяф, опц);
    строки = разбейнастр( текст );
    return строки;
}

enum ОпцСоздания
{
    Новый = 'n',      // Must create a new файл, thus it cannot already exist.
    Создать = 'c',   // Can either create or replace; it doesn't matter.
    Заменить = 'r'   // Must replace an existing файл.
};

проц создайТекстФайл(ткст имяф, ткст[] строки, ОпцСоздания опц = ОпцСоздания.Создать)
{
    ткст буф;
    бул есть_ли_ф;

    есть_ли_ф = (естьФайл( имяф) ? true : false);
    if (опц == ОпцСоздания.Заменить && !есть_ли_ф)
        ошибка( фм("Файл '%s' не существует.", имяф));

    if (опц == ОпцСоздания.Новый && есть_ли_ф)
        ошибка( фм("Файл '%s' уже есть.", имяф));

    if (естьФайл(имяф))
        удалиФайл(имяф);

    foreach(ткст текст; строки) {
        // Strip off any trailing line-end chars.
        for(цел i = текст.length-1; i >= 0; i--)
        {
            if (stdrus.найди(РАЗДСТР, текст[i]) == -1)
            {
                if (i != текст.length-1)
                    текст.length = i+1;
                break;
            }
        }

        // Доб the opsys' line-end convention.
        буф ~= текст ~ РАЗДСТР;
    }
    пишиФайл(имяф, буф);
}

проц создайТекстФайл(ткст имяф, ткст строки, ОпцСоздания опц = ОпцСоздания.Создать)
{
    ткст буф;
    бул есть_ли_ф;
    ткст[] встроки;

    // Split into строки, disregarding line-end conventions.
    встроки = разбейнастр(строки);
    // Зап out the text using the opsys' line-end convention.
    создайТекстФайл(имяф, встроки, опц);
}

дол grep(ткст данные, ткст образец)
{
    return stdrus.найди(данные, образец, vGrepOpts[$-1]);
}

бдол[] найдиВФайле(ткст имяф, ткст текст, ткст опции = "", бцел макс=1)
{
    бул lCaseSensitive;
    бул lRegExp;
    бул lWordOnly;
    бул lCounting;
    ткст буф;
    цел lPos;
    цел lStartPos;
    бдол[] lResult;
    цел function(ткст a, ткст b) lFind;
    ткст lGrepOpt;


    lCaseSensitive = true;
    lRegExp = false;
    lGrepOpt = "m";
    lWordOnly = false;
    lCounting = true;
    foreach (сим c; опции)
    {
        switch (c)
        {
            case 'i', 'I':
                lCaseSensitive = false;
                break;

            case 'r', 'R':
                lRegExp = true;
                break;

            case 'w', 'W':
                lWordOnly = true;
                break;

            case 'a', 'A':
                lCounting = false;
                break;

            case 'd', 'D':
                lCaseSensitive = true;
                lRegExp = false;
                lWordOnly = false;
                lCounting = true;
                break;

            default:
                // Ignore unrecognized опции.
                break;
        }
    }

    if (lRegExp)
    {
        lFind = cast(цел function(ткст a, ткст b)) &grep;
        if (lCaseSensitive)
            lGrepOpt ~= 'i';

        vGrepOpts ~= lGrepOpt;
        lWordOnly = false;
    }
    else
    {
        if (lCaseSensitive)
            lFind = cast(цел function(ткст a, ткст b)) &stdrus.найди;
        else
            lFind = cast(цел function(ткст a, ткст b)) &stdrus.найдлюб;
    }

    // Pull the entire text into RAM.
    буф = cast(ткст)читайФайл(имяф);

    // Locate next instance и process it.
    while ( lStartPos = lPos, (lPos = lFind(буф[lStartPos..$], текст)) != -1)
    {
        lPos += lStartPos;
        if (lWordOnly)
        {
            // A 'word' is an instance not surrounded by alphanumerics.
            if (lPos > 0)
            {
                if (stdrus.числобукв_ли(буф[lPos-1]) )
                {
                    // Instance preceeded by a alphanumic so I
                    // move one place to the right и try to find
                    // another instance.
                    lPos++;
                    continue;
                }
            }
            if (lPos + текст.length < буф.length)
            {
                if (stdrus.числобукв_ли(буф[lPos + текст.length - 1]) )
                {
                    // Instance followed by a alphanumic so I
                    // move one place to the right и try to find
                    // another instance.
                    lPos++;
                    continue;
                }
            }
        }

        // Add this instance's позиция to the results list.
        lResult ~= lPos;

        // If I'm counting the number of hits, see if I've got the
        // requested number yet. If so, stop searching.
        if (lCounting)
        {
            макс--;
            if (макс == 0)
                break;
        }

        // Skip over текущ instance.
        lPos += текст.length;

        // If there is not enough characters left, then stop searching.
        if ((буф.length - lPos) < текст.length)
            break;

    }
    if (vGrepOpts.length > 0)
        vGrepOpts.length = vGrepOpts.length - 1;

    return lResult;
}

//-------------------------------------------------------
цел ВыполниКоманду(ткст pExeName, ткст команда)
//-------------------------------------------------------
{

    if (расширениеЭкзэ.length > 0)
    {
        if (дайРасш(pExeName).length == 0)
            pExeName ~= "." ~ расширениеЭкзэ;
    }

    if (util.pathex.относительныйПуть_ли(pExeName) == да)
    {
        ткст lExePath;
        lExePath = util.pathex.найдиФайлВСпискеПутей(идПути, pExeName);
        if (util.str.оканчивается_на(lExePath, РАЗДПАП) == Нет)
            lExePath ~= РАЗДПАП;

        pExeName = util.pathex.каноническийПуть(lExePath ~ pExeName, да);
    }

    if (естьФайлВКэш(pExeName) == false)
    {
        throw new ФайлИскл(фм("Не удалось найти приложение '%s' для последующего запуска", pExeName));
    }
    return ВыполниКоманду(pExeName ~ " " ~ команда);
}

//-------------------------------------------------------
цел ВыполниКоманду(ткст команда)
//-------------------------------------------------------
{
    цел lRC;
    цел lTrueRC;

    if (тестЗапуск == Да) {
        скажифнс("Команда: '%s'",команда);
        return 0;
    }
    else
    {


        version(BuildVerbose)
        {
            if(подробно == Да)
                скажифнс("Выполняется '%s'",команда);
        }

        lRC = cidrus.system(вТкст0(команда));
        version(Posix) lTrueRC = ((lRC & 0xFF00) >> 8);
        version(Windows) lTrueRC = lRC;

        version(BuildVerbose)
        {
            if(подробно == Да) {
                if (lTrueRC == 0){
                    скажинс("Успешно");
                } else {
                   скажифнс("Неудачно. Возвратный код: %04x",lRC);
                }
            }
        }
        return lTrueRC;
    }
}

