module util.pathex;

version(linux)  version = Posix;
version(darwin) version = Posix;

private {
    import util.str;
    import util.booltype;   // definition of Да и Нет
    alias util.booltype.Да Да;
    alias util.booltype.Нет Нет;
    alias util.booltype.Бул Бул;

    import dinrus;
}

private {
    ткст vInitCurDir;
}

// Module constructor
// ----------------------------------------------
static this()
// ----------------------------------------------
{
    vInitCurDir = дайТекПап();
}

// ----------------------------------------------
ткст дайТекПап()
// ----------------------------------------------
{
    ткст текпап;

    текпап = дайтекпап();
    // Ensure that it оканчивается_на in a путь separator.
    if (util.str.оканчивается_на(текпап, РАЗДПАП) == Нет)
        текпап ~= РАЗДПАП;

    return текпап;
}

// ----------------------------------------------
ткст дайТекПап(сим драйв)
// ----------------------------------------------
{
    ткст lOrigDir;
    ткст текпап;
    ткст lDrive;

    lOrigDir = дайтекпап();
    lDrive.length = 2;
    lDrive[0] = драйв;
    lDrive[1] = ':';
    сменипап(lDrive);
    текпап =дайтекпап();
    сменипап(lOrigDir[0..2]);

    // Ensure that it оканчивается_на in a путь separator.
    if (util.str.оканчивается_на(текпап, РАЗДПАП) == Нет)
        текпап ~= РАЗДПАП;

    return текпап;
}

// ----------------------------------------------
ткст дайТекИницПап()
// ----------------------------------------------
{
    return vInitCurDir;
}

// ----------------------------------------------
бул относительныйПуть_ли(ткст путь)
// ----------------------------------------------
{
    version(Windows)
    {
        // Strip off an drive prefix первый.
        if (путь.length > 1 && путь[1] == ':')
            путь = путь[2..$];
    }

    return cast(бул) ~(util.str.начинается_с(путь, РАЗДПАП));
}

// ----------------------------------------------
бул абсолютныйПуть_ли(ткст путь)
// ----------------------------------------------
{
    version(Windows)
    {
        // Strip off an drive prefix первый.
        if (путь.length > 1 && путь[1] == ':')
            путь = путь[2..$];
    }

    return cast(бул) util.str.начинается_с(путь, РАЗДПАП);
}

// ----------------------------------------------
ткст каноническийПуть(ткст путь, бул pDirInput = да)
// ----------------------------------------------
{
    // Does not (yet) handle UNC paths or unix links.
    ткст lPath;
    цел lPosA = -1;
    цел lPosB = -1;
    цел lPosC = -1;
    ткст lLevel;
    ткст текпап;
    ткст lDrive;

    lPath = путь.dup;

    // Strip off any enclosing quotes.
    if (lPath.length > 2 && lPath[0] == '"' && lPath[$-1] == '"')
    {
        lPath = lPath[1..$-1];
    }

    // Replace any leading tilde with 'HOME' directory.
    if (lPath.length > 0 && lPath[0] == '~')
    {
        version(Windows) lPath = util.str.дайСред("HOMEDRIVE") ~  util.str.дайСред("HOMEPATH") ~ РАЗДПАП ~ lPath[1..$];
        version(Posix) lPath = util.str.дайСред("HOME") ~ РАЗДПАП ~ lPath[1..$];
    }

    version(Windows)
    {
        if ( (lPath.length > 1) && (lPath[1] == ':' ) )
        {
            lDrive = lPath[0..2].dup;
            lPath = lPath[2..$];
        }

        if ( (lPath.length == 0) || (lPath[0] != РАЗДПАП[0]) )
        {
            if (lDrive.length == 0)
                lPath = дайТекПап ~ lPath;
            else
                lPath = дайТекПап(lDrive[0]) ~ lPath;

            if ( (lPath.length > 1) && (lPath[1] == ':' ) )
            {
                if (lDrive.length == 0)
                    lDrive = lPath[0..2].dup;
                lPath = lPath[2..$];
            }
        }

    }
    version(Posix){
        if ( (lPath.length == 0) || (lPath[0] != РАЗДПАП[0]) )
        {
            lPath = дайТекПап() ~ lPath;
        }
    }

    if (pDirInput && (lPath[$-РАЗДПАП.length .. $] != РАЗДПАП) ){
        lPath ~= РАЗДПАП;
    }

    lLevel = РАЗДПАП ~ "." ~ РАЗДПАП;
    lPosA = stdrus.найди(lPath, lLevel);
    while( lPosA != -1 ){
        lPath = lPath[0..lPosA] ~
                lPath[lPosA + lLevel.length - РАЗДПАП.length .. length];

        lPosA = stdrus.найди(lPath, lLevel);
    }

    lLevel = РАЗДПАП ~ ".." ~ РАЗДПАП;
    lPosA = stdrus.найди(lPath, lLevel);
    while( lPosA != -1 ){
        // Locate preceding directory separator.
        lPosB = lPosA-1;
        while((lPosB > 0) && (lPath[lPosB] != РАЗДПАП[0]))
            lPosB--;
        if (lPosB < 0)
            lPosB = 0;

        lPath = lPath[0..lPosB] ~
                lPath[lPosA + lLevel.length - РАЗДПАП.length .. length];

        lPosA = stdrus.найди(lPath, lLevel);
    }

    return lDrive ~ lPath;
}

// ----------------------------------------------
ткст замениРасш(ткст фимя, ткст новРасш)
// ----------------------------------------------
{
    ткст новфимя;

    новфимя = добРасш(фимя, новРасш);

    /* Needs this to work around the 'feature' in addExt in which
       replacing an extention with an empty string leaves a dot
       after the файл имя.
    */
    if (новРасш.length == 0)
    {
        if (новфимя.length > 0)
        {
            if (новфимя[length-1] == '.')
            {
                новфимя.length = новфимя.length - 1;
            }
        }
    }

    return новфимя;
}

// ----------------------------------------------
бул сделайПуть(ткст новПуть)
// ----------------------------------------------
{
    /*
        This creates the путь, including all intervening
        parent directories, specified by the parameter.

        Note that the путь is only that portion of the
        parameter up to the последний directory separator. This
        means that you can provide a файл имя in the parameter
        и it will still create the путь for that файл.

        This returns Нет if the путь was not created. That
        could occur if the путь already exists or if you do not
        permissions to create the путь on the device, or if
        device is read-only or doesn't exist.

        This returns true if the путь was created.
    */
    бул рез;  // false means it did not create a new путь.
    ткст lNewPath;
    ткст lParentPath;

    // выкинь out the directory part of the parameter.
    for (цел i = новПуть.length-1; i >= 0; i--)
    {
        if (новПуть[i] == РАЗДПАП[0])
        {
            lNewPath = новПуть[0 .. i].dup;
            break;
        }
    }
    version(Windows) {
        if ((lNewPath.length > 0) && (lNewPath[length-1] == ':'))
            lNewPath.length = 0;
    }

    if (lNewPath.length == 0)
        return false;
    else {
    // выкинь out the parent directory
    for (цел i = lNewPath.length-1; i >= 0; i--)
    {
        if (lNewPath[i] == РАЗДПАП[0])
        {
            lParentPath = lNewPath[0 .. i].dup;
            break;
        }
    }

    // make sure the parent exists.
    version(Windows) {
        if ((lParentPath.length > 0) && (lParentPath[length-1] == ':'))
                lParentPath.length = 0;
    }
    if (lParentPath.length != 0)
    {
        сделайПуть(lParentPath ~ РАЗДПАП);
    }


    // create this directory
    try {
        сделайпап(lNewPath);
        рез = true;
    }
    catch (ФайлИскл Е) {
         // Assume the exception is that the directory already exists.
         рез = false;
    }
    return рез;
    }
}

ткст сократиФИмя(ткст имя, ткст[] списПрефиксов = пусто)
{
    // If the файл путь supplied can be expressed relative to
    // the текущ directory, (without resorting to '..'), it
    // is returned in its shortened form.

    ткст[] lPrefixList;
    ткст lShortName;
    ткст lTemp;
    ткст lOrigName;
    ткст lFullName;

    lPrefixList ~= util.pathex.дайТекИницПап();
    if (списПрефиксов.length != 0)
    {
        lPrefixList.length = lPrefixList.length + списПрефиксов.length;
        lPrefixList[1..$] = списПрефиксов[];
    }
    lFullName = каноническийПуть(имя, false);
    LBL_CheckDirs:
    foreach (ткст текпап; lPrefixList)
    {
        lOrigName = lFullName.dup;
        if (lOrigName.length > текпап.length)
        {
            version(Windows)
            {
                if( stdrus.впроп(lOrigName[0.. текпап.length]) ==
                    stdrus.впроп(текпап) )
                {
                    lShortName = lOrigName[текпап.length .. $];
                    break LBL_CheckDirs;
                }

            }
            else
            {
                if (lOrigName[0.. текпап.length] == текпап )
                {
                    lShortName = lOrigName[текпап.length .. $];
                    break LBL_CheckDirs;
                }
            }
        }
    }

    if (lShortName.length == 0)
        lShortName = имя.dup;

    version(Windows)
    // Remove any double путь seps.
    {{
        бцел lPos;
        while ( (lPos = stdrus.найди(lShortName, `\\`)) != -1)
        {
            lShortName = lShortName[0..lPos] ~ lShortName[lPos+1 .. $];
        }
    }}
    return lShortName;
}

ткст определиФайл(ткст фимя, ткст списПутей)
{
    return определиФайл(фимя,
                        разбей(списПутей, РАЗДПСТР));
}

ткст определиФайл(ткст фимя, ткст[] списПутей)
{
    ткст lFullName;

    foreach(ткст lPath; списПутей)
    {
        if (lPath.length == 0)
            lPath = дайтекпап.dup;

        if (lPath[$-РАЗДПАП.length .. $] != РАЗДПАП)
            lPath ~= РАЗДПАП;

        lFullName = lPath ~ фимя;
        if (естьФайлВКэш(lFullName) )
            return lFullName;
    }

    return фимя;
}

/**
    Return everything up to but not including the final '.'
*/
ткст дайОсновуИмени(ткст фимяПути)
{
    ткст lBaseName;

    lBaseName = фимяПути; //.dup;
    for(цел i = lBaseName.length-1; i >= 0; i--)
    {
        if (lBaseName[i] == '.')
        {
            lBaseName.length = i;
            break;
        }
    }
    return lBaseName;
}

/**
    Return everything from the beginning of the файл имя
    up to but not including the final '.'
*/
ткст дайОсновуИмениФайла(ткст фимяПути)
{
    ткст lBaseName;

    lBaseName = фимяПути; //.dup;
    for(цел i = lBaseName.length-1; i >= 0; i--)
    {
        if (lBaseName[i] == '.')
        {
            lBaseName.length = i;
            break;
        }
    }

    for(цел i = lBaseName.length-1; i >= 0; i--)
    {
        version(Windows)
        {
            if (lBaseName[i] == '\\')
            {
                lBaseName = lBaseName[i+1 .. $];
                break;
            }
            if (lBaseName[i] == ':')
            {
                lBaseName = lBaseName[i+1 .. $];
                break;
            }
        }
        version(Posix)
        {
            if (lBaseName[i] == '/')
            {
                lBaseName = lBaseName[i+1 .. $];
                break;
            }
        }
    }
    return lBaseName;
}

// Function to locate where an файл is installed from the supplied
// environment symbol, which is a list of paths.
// This returns the путь to the файл if the файл exists otherwise пусто.
// -------------------------------------------
ткст найдиФайлВСпискеПутей(ткст pSymName, ткст фимя)
// -------------------------------------------
{
    ткст[] пути;
    ткст   путьККомпилятору;
    ткст   необработЗнач;

    // Assume that an environment symbol имя was supplied,
    // but if that fails, assume its a list of paths.
    необработЗнач = util.str.дайСред(pSymName);
    if (необработЗнач.length == 0)
        необработЗнач = pSymName;

    // Rearrange путь list into an массив of paths.
    пути = разбей(util.str.вАСКИ(необработЗнач), РАЗДПСТР);

    путьККомпилятору.length = 0;
    foreach(ткст lPath; пути)
    {
        if (lPath.length > 0)
        {
            // Ensure that the путь оканчивается_на with a действителен separator.
            if (lPath[length-1] != РАЗДПАП[0] )
                lPath ~= РАЗДПАП;
            // If the файл is in the текущ путь we can stop looking.
            if(естьФайлВКэш(lPath ~ фимя))
            {
                // Return the путь we actually found it in.
                путьККомпилятору = lPath;
                break;
            }
        }
    }

    return путьККомпилятору;
}

