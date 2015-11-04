/* /////////////////////////////////////////////////////////////////////////////
 * File:    std/openrj.d
 *
 * Purpose: Open-RJ/D mapping for the D standard library
 *
 * Created: 11th June 2004
 * Updated: 10th March 2005
 *
 * Home:    http://openrj.org/
 *
 * Copyright 2004-2005 by Matthew Wilson and Synesis Software
 * Written by Matthew Wilson
 *
 * This software is provided 'as-is', without any express or implied
 * warranty. In no событие will the authors be held liable for any damages
 * arising from the use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, in both source and binary form, subject to the following
 * restrictions:
 *
 * -  The origin of this software must not be misrepresented; you must not
 *    claim that you wrote the original software. If you use this software
 *    in a product, an acknowledgment in the product documentation would be
 *    appreciated but is not required.
 * -  Altered source versions must be plainly marked as such, and must not
 *    be misrepresented as being the original software.
 * -  This notice may not be removed or altered from any source
 *    distribution.
 *
 * //////////////////////////////////////////////////////////////////////////
 * Altered by Walter Bright.
 */


/**
 * Open-RJ mapping for the D standard library.
 *
 * Authors:
 *	Matthew Wilson
 * References:
 *	$(LINK2 http://www.$(OPENRJ).org/, Open-RJ)
 * Macros:
 *	WIKI=Phobos/StdOpenrj
 *	OPENRJ=openrj
 */

/* /////////////////////////////////////////////////////////////////////////////
 * Module
 */

module openrj;

/* /////////////////////////////////////////////////////////////////////////////
 * Imports
 */

private import std.ctype;
version(MainTest)
{
    private import std.file;
    private import std.perf;
} // version(MainTest)
private import std.string;

/* /////////////////////////////////////////////////////////////////////////////
 * Версия information
 */

// This'll be moved out to somewhere common soon

private struct Версия
{
    ткст  имя;
    ткст  описание;
    бцел    мажор;
    бцел    минор;
    бцел    ревизия;
    бцел    редакц;
    ulong   времяПостроения;
}

public static Версия   ВЕРСИЯ =
{
        "base.openrj"
    ,   "Record-JAR database reader"
    ,   1
    ,   0
    ,   7
    ,   7
    ,   0
};

/* /////////////////////////////////////////////////////////////////////////////
 * Structs
 */

// This'll be moved out to somewhere common soon

private struct СтрокаПеречня
{
    цел     значение;
    ткст  стр;
};

private template перечень_в_ткст(T)
{
    ткст перечень_в_ткст(СтрокаПеречня[] строки, T t)
    {
        // 'Optimised' search.
        //
        // Since many enums start at 0 and are contiguously ordered, it's quite
        // likely that the значение will equal the индекс. If it does, we can just
        // return the string from that индекс.
        цел индекс   =   cast(цел)(t);

        if( индекс >= 0 &&
            индекс < строки.length &&
            строки[индекс].значение == индекс)
        {
            return строки[индекс].стр;
        }

        // Otherwise, just do a linear search
        foreach(СтрокаПеречня s; строки)
        {
            if(cast(цел)(t) == s.значение)
            {
                return s.стр;
            }
        }

        return "<неизвестно>";
    }
}

/* /////////////////////////////////////////////////////////////////////////////
 * Enumerations
 */

/** Flags that moderate the creation of Databases */
public enum ОРДЖ_ФЛАГ
{
    УПОРЯДОЧИТЬ_ПОЛЯ                    =   0x0001,  /// Arranges the поля in alphabetical order
    ИГНОР_ПУСТЫЕ_ЗАПИСИ             =   0x0002,  /// Causes blank записи to be ignored
}

/**
 *
 */
export ткст вТкст(ОРДЖ_ФЛАГ f)
{
    const СтрокаПеречня    строки[] = 
    [
            {   ОРДЖ_ФЛАГ.УПОРЯДОЧИТЬ_ПОЛЯ,           "Организует поля в алфавитном порядке" }
        ,   {   ОРДЖ_ФЛАГ.ИГНОР_ПУСТЫЕ_ЗАПИСИ,    "Вызывает игнорирование пустых записей"        }
    ];

    return перечень_в_ткст!(ОРДЖ_ФЛАГ)(строки, f);
}

/** General error codes */
public enum ОРДЖК
{
    УСПЕХ                      =   0,          /// Operation was successful
    ДЖАРФАЙЛ_НЕ_ОТКРЫВАЕТСЯ,                        /// The given файл does not exist, or cannot be accessed
    НЕТ_ЗАПИСЕЙ,                                  /// The бд файл contained no записи
    НЕТ_ПАМЯТИ,                               /// The API suffered память exhaustion
    ФАЙЛ_НЕ_ЧИТАЕТСЯ,                               /// A read operation failed
    ОШИБКА_РАЗБОРА,                                 /// Parsing of the бд файл failed due to a syntax error
    НЕВЕРНЫЙ_ИНДЕКС,                               /// An invalid индекс was specified
    НЕОЖИДАННОЕ,                                  /// An unexpected condition was encountered
    ПОВРЕЖДЕНИЕ_КОНТЕНТА,                             /// The бд файл contained invalid content
}

/**
 *
 */
export ткст вТкст(ОРДЖК f)
{
    const СтрокаПеречня    строки[] = 
    [
            {   ОРДЖК.УСПЕХ,              "Операция прошла удачно"                                      }
        ,   {   ОРДЖК.ДЖАРФАЙЛ_НЕ_ОТКРЫВАЕТСЯ, "Указанного файла либо нет, либо доступ к нему закрыт"          }
        ,   {   ОРДЖК.НЕТ_ЗАПИСЕЙ,           "Файл базы данных не содержит записей"                        }
        ,   {   ОРДЖК.НЕТ_ПАМЯТИ,        "API столкнулся с нехваткий памяти"                            }
        ,   {   ОРДЖК.ФАЙЛ_НЕ_ЧИТАЕТСЯ,        "Операция чтения провалилась"                                       }
        ,   {   ОРДЖК.ОШИБКА_РАЗБОРА,          "Разбор файла базы данных натолкнулся на синтактическую ошибку"     }
        ,   {   ОРДЖК.НЕВЕРНЫЙ_ИНДЕКС,        "Был задан неверный индекс"                                }
        ,   {   ОРДЖК.НЕОЖИДАННОЕ,           "Столкновение с неожиданным условием"                       }   
        ,   {   ОРДЖК.ПОВРЕЖДЕНИЕ_КОНТЕНТА,      "В файле базы данных содержится повреждённый контент"                   }       
    ];

    return перечень_в_ткст!(ОРДЖК)(строки, f);
}

/** Parsing error codes */
public enum ОРДЖ_ОШИБКА_РАЗБОРА
{
    УСПЕХ                         =   0,       /// Parsing was successful
    РАЗДЕЛИТЕЛЬ_ЗАПИСИ_В_СТРОКЕ,            /// A запись separator was encountered during a content line continuation
    НЕОКОНЧЕННАЯ_СТРОКА,                             /// The last line in the бд was not terminated by a line-feed
    НЕОКОНЧЕННОЕ_ПОЛЕ,                            /// The last поле in the бд файл was not terminated by a запись separator
    НЕОКОНЧЕННАЯ_ЗАПИСЬ,                           /// The last запись in the бд файл was not terminated by a запись separator
}

/**
 *
 */
export ткст вТкст(ОРДЖ_ОШИБКА_РАЗБОРА f)
{
    const СтрокаПеречня    строки[] = 
    [
            {   ОРДЖ_ОШИБКА_РАЗБОРА.УСПЕХ,                            "Разбор успешно завершён"                                                        }
        ,   {   ОРДЖ_ОШИБКА_РАЗБОРА.РАЗДЕЛИТЕЛЬ_ЗАПИСИ_В_СТРОКЕ,   "В строке контента обнаружен разделитель записей"         }
        ,   {   ОРДЖ_ОШИБКА_РАЗБОРА.НЕОКОНЧЕННАЯ_СТРОКА,                    "Последняя строка в базе данных не окончена символом перевода строки"               }
        ,   {   ОРДЖ_ОШИБКА_РАЗБОРА.НЕОКОНЧЕННОЕ_ПОЛЕ,                   "Последнее поле в базе данных не окончено разделителем записей"  }
        ,   {   ОРДЖ_ОШИБКА_РАЗБОРА.НЕОКОНЧЕННАЯ_ЗАПИСЬ,                  "Последняя запись в базе данных не окончена разделителем записей" }
    ];

    return перечень_в_ткст!(ОРДЖ_ОШИБКА_РАЗБОРА)(строки, f);
}

/* /////////////////////////////////////////////////////////////////////////////
 * Classes
 */

/**
 *
 */
class ИсклОпенРДж
    : public Exception
{
/* \имя Construction */

protected:
    this(ткст сооб)
    {
        super(сооб,__FILE__,__LINE__);
    }

}

/**
 *
 */
class ИсклБД
    : public ИсклОпенРДж
{
/* \имя Construction */
private:
    this(ткст детали, ОРДЖК рк)
    {
//эхо("ИсклБД(0: %.*s, %.*s)\n", детали, openrj.вТкст(рк));

        ткст  сооб    =   std.string.format(   "Создание базы данных неудачно; ошибка: %s, %s"
                                                ,   cast(цел)рк
                                                ,   openrj.вТкст(рк));

        m_rc        =   рк;
        m_pe        =   ОРДЖ_ОШИБКА_РАЗБОРА.УСПЕХ;
        m_lineNum   =   -1;

        super(сооб);
    }

    this(ОРДЖК рк, цел номСтр)
    {
//эхо("ИсклБД(1: %.*s, %d)\n", openrj.вТкст(рк), номСтр);

        ткст  сооб    =   std.string.format(   "Создание базы данных неудачно, строка %s; ошибка: %s, %s"
                                                ,   номСтр
                                                ,   cast(цел)рк
                                                ,   openrj.вТкст(рк));

        m_rc        =   рк;
        m_pe        =   ОРДЖ_ОШИБКА_РАЗБОРА.УСПЕХ;
        m_lineNum   =   номСтр;

        super(сооб);
    }

    this(ОРДЖ_ОШИБКА_РАЗБОРА pe, цел номСтр)
    {
//эхо("ИсклБД(2: %.*s, %d)\n", openrj.вТкст(pe), номСтр);

        ткст  сооб    =   std.string.format(   "Ошибка разбора в базе данных, строка %s; ошибка парсинга: %s, %s"
                                                ,   номСтр
                                                ,   cast(цел)pe
                                                ,   openrj.вТкст(pe));

        m_rc        =   ОРДЖК.ОШИБКА_РАЗБОРА;
        m_pe        =   pe;
        m_lineNum   =   номСтр;

        super(сооб);
    }

    this(ткст детали, ОРДЖ_ОШИБКА_РАЗБОРА pe, цел номСтр)
    {
//эхо("ИсклБД(3: %.*s, %.*s, %d)\n", детали, openrj.вТкст(рк), номСтр);

        ткст  сооб    =   std.string.format(   "Ошибка разбора в базе данных, строка %s; ошибка парсинга: %s, %s; %s"
                                                ,   номСтр
                                                ,   cast(цел)pe
                                                ,   openrj.вТкст(pe)
                                                ,   детали);

        m_rc        =   ОРДЖК.ОШИБКА_РАЗБОРА;
        m_pe        =   pe;
        m_lineNum   =   номСтр;

        super(сооб);
    }

/* \имя Attributes */
public:

    /**
     *
     */
    ОРДЖК рк()
    {
        return m_rc;
    }

    /**
     *
     */
    ОРДЖ_ОШИБКА_РАЗБОРА ошибкаРазбора()
    {
        return m_pe;
    }

    /**
     *
     */
    цел номСтр()
    {
        return m_lineNum;
    }

// Members
private:
    цел             m_lineNum;
    ОРДЖК           m_rc;
    ОРДЖ_ОШИБКА_РАЗБОРА m_pe;
}

/**
 *
 */
class ИсклНеверногоКлюча
    : public ИсклОпенРДж
{
/* \имя Construction */
private:
    this(ткст сооб)
    {
        super(сооб);
    }
}

/**
 *
 */
class ИсклНеверногоТипа
    : public ИсклОпенРДж
{
/* \имя Construction */
private:
    this(ткст сооб)
    {
        super(сооб);
    }
}

/* /////////////////////////////////////////////////////////////////////////////
 * Classes
 */

/// Represents a поле in the бд
export class Поле
{
/* \имя Construction */

export:
    this(ткст имя, ткст значение/* , Запись запись */)
    in
    {
        assert(null !is имя);
        assert(null !is значение);
    }
    body
    {
        m_name      =   имя;
        m_value     =   значение;
        /* m_record =   запись; */
    }


/* \имя Attributes */

export:

    /**
     *
     */
    final ткст  имя()
    {
        return m_name;
    }

    /**
     *
     */
    final ткст  значение()
    {
        return m_value;
    }

    /**
     *
     */
    Запись запись()
    {
        return m_record;
    }


/* \имя Comparison */

/+
public:
    цел opCmp(Object rhs)
    {
        Поле   f   =   cast(Поле)(rhs);

        if(null is f)
        {
            throw new ИсклНеверногоТипа("Attempt to compare a Поле with an instance of another type");
        }

        return opCmp(f);
    }
public:
    цел opCmp(Поле rhs)
    {
        цел res;

        if(this is rhs)
        {
            res = 0;
        }
        else
        {
            res = std.string.cmp(m_name, rhs.m_name);

            if(0 == res)
            {
                res = std.string.cmp(m_value, rhs.m_value);
            }
        }

        return res;
    }
+/


// Members
private:
    ткст  m_name;
    ткст  m_value;
    Запись  m_record;
}

/// Represents a запись in the бд, consisting of a set of поля
export class Запись
{
/* \имя Types */

public:
    alias base.size_t     тип_размера;
    alias base.size_t     тип_индекса;
    alias base.ptrdiff_t  тип_разницы;


/* \имя Construction */

export:
    this(Поле[] поля, бцел флаги, БазаДанных бд)
    {
        m_fields = поля.dup;

        if(флаги & ОРДЖ_ФЛАГ.УПОРЯДОЧИТЬ_ПОЛЯ)
        {
            m_fields = m_fields.sort;
        }

        foreach(Поле поле; m_fields)
        {
            if(!(поле.имя in m_values))
            {
                m_values[поле.имя] = поле;
            }
        }

        m_database = бд;
    }


/* \имя Attributes */

export:

    /**
     *
     */
    бцел члоПолей()
    {
        return m_fields.length;
    }

    /**
     *
     */
    бцел длина()
    {
        return члоПолей();
    }

    /**
     *
     */
    Поле[] поля()
    {
        return m_fields.dup;
    }

    /**
     *
     */
    Поле opIndex(тип_индекса индекс)
    in
    {
        assert(индекс < m_fields.length);
    }
    body
    {
        return m_fields[индекс];
    }

    /**
     *
     */
    ткст opIndex(ткст имяПоля)
    {
        return дайПоле(имяПоля).значение;
    }

    /**
     *
     */
    Поле   дайПоле(ткст имяПоля)
    in
    {
        assert(null !is имяПоля);
    }
    body
    {
        Поле   поле   =   найдиПоле(имяПоля);

        if(null is поле)
        {
            throw new ИсклНеверногоКлюча("поле не найдено");
        }

        return поле;
    }

    /**
     *
     */
    Поле   найдиПоле(ткст имяПоля)
    in
    {
        assert(null !is имяПоля);
    }
    body
    {
        Поле   *pfield =   (имяПоля in m_values);

        return (null is pfield) ? null : *pfield;
    }

    /**
     *
     */
    цел естьПоле(ткст имяПоля)
    {
        return null !is найдиПоле(имяПоля);
    }

    /**
     *
     */
    БазаДанных бд()
    {
        return m_database;
    }


/* \имя Enumeration */

export:

    /**
     *
     */
    цел opApply(цел delegate(inout Поле поле) дг)
    {
        цел результат  =   0;

        foreach(Поле поле; m_fields)
        {
            результат = дг(поле);

            if(0 != результат)
            {
                break;
            }
        }

        return результат;
    }

    /**
     *
     */
    цел opApply(цел delegate(in ткст имя, in ткст значение) дг)
    {
        цел результат  =   0;

        foreach(Поле поле; m_fields)
        {
            результат = дг(поле.имя(), поле.значение());

            if(0 != результат)
            {
                break;
            }
        }

        return результат;
    }


// Members
private:
    Поле[]         m_fields;
    Поле[ткст]   m_values;
    БазаДанных        m_database;
}


/**
 *
 */
export class БазаДанных
{
/* \имя Types */

public:
    alias base.size_t     тип_размера;
    alias base.size_t     тип_индекса;
    alias base.ptrdiff_t  тип_разницы;


/* \имя Construction */

private:
    void init_(ткст[] строчки, бцел флаги)
    {
        // Enumerate
        цел         bContinuing =   false;
        Поле[]     поля;
        ткст      nextLine;
        цел         номСтр     =   1;
        цел         nextLineNum =   1;

        foreach(ткст line; строчки)
        {
            // Always strip trailing space
            line = stripr(line);

            // Check that we don't start a continued line with a запись separator
            if( bContinuing &&
                line.length > 1 &&
                "%%" == line[0 .. 2])
            {
                throw new ИсклБД(ОРДЖ_ОШИБКА_РАЗБОРА.РАЗДЕЛИТЕЛЬ_ЗАПИСИ_В_СТРОКЕ, номСтр);
            }

            // Always strip leading whitespace
            line = stripl(line);

            цел bContinuationLine;

            if( line.length > 0 &&
                '\\' == line[line.length - 1])
            {
                bContinuationLine   =   true;
                bContinuing         =   true;
                line                =   line[0 .. line.length - 1];
            }

            // Always add on to the previous line
            nextLine = nextLine ~ line;

            line = null;

            if(!bContinuationLine)
            {
                if(0 == nextLine.length)
                {
                    // Just ignore these строчки
                }
                else if(1 == nextLine.length)
                {
                    throw new ИсклБД(ОРДЖ_ОШИБКА_РАЗБОРА.НЕОКОНЧЕННОЕ_ПОЛЕ, номСтр);
                }
                else
                {
                    if("%%" == nextLine[0 .. 2])
                    {
                        // Comment line - terminate the запись
//                      эхо("-- запись --\n");

                        if( 0 != поля.length ||
                            0 == (ОРДЖ_ФЛАГ.ИГНОР_ПУСТЫЕ_ЗАПИСИ & флаги))
                        {
                            Запись  запись  =   new Запись(поля, флаги, this);

                            foreach(Поле поле; поля)
                            {
                                поле.m_record = запись;
                            }

                            m_records   ~=  запись;
                            поля      =   null;
                        }
                    }
                    else
                    {
                        цел colon   =   find(nextLine, ':');

                        if(-1 == colon)
                        {
                            throw new ИсклБД(ОРДЖ_ОШИБКА_РАЗБОРА.НЕОКОНЧЕННОЕ_ПОЛЕ, номСтр);
                        }

//                      эхо("%.*s(%d): %.*s (%d)\n", файл, nextLineNum, nextLine, colon);

                        ткст  имя    =   nextLine[0 .. colon];
                        ткст  значение   =   nextLine[colon + 1 .. nextLine.length];

                        имя    =   stripr(имя);
                        значение   =   stripl(значение);

//                      эхо("%.*s(%d): %.*s=%.*s\n", файл, nextLineNum, имя, значение);

                        Поле   поле   =   new Поле(имя, значение);

                        поля      ~=  поле;
                        m_fields    ~=  поле;
                    }
                }

                nextLine    =   "";
                nextLineNum =   номСтр + 1;
                bContinuing =   false;
            }

/+ // This is currently commented out as it seems unlikely to be sensible to 
   // order the Fields globally. The reasoning is that if the Fields are used
   // globally then it's more likely that their ordering in the бд source
   // is meaningful. If someone really needs an all-Fields array ordered, they
   // can do it manually.
            if(флаги & ОРДЖ_ФЛАГ.УПОРЯДОЧИТЬ_ПОЛЯ)
            {
                m_fields = m_fields.sort;
            }
+/

            ++номСтр;
        }
        if(bContinuing)
        {
            throw new ИсклБД(ОРДЖ_ОШИБКА_РАЗБОРА.НЕОКОНЧЕННАЯ_СТРОКА, номСтр);
        }
        if(поля.length > 0)
        {
            throw new ИсклБД(ОРДЖ_ОШИБКА_РАЗБОРА.НЕОКОНЧЕННАЯ_ЗАПИСЬ, номСтр);
        }
        if(0 == m_records.length)
        {
            throw new ИсклБД(ОРДЖК.НЕТ_ЗАПИСЕЙ, номСтр);
        }

        m_flags     =   флаги;
        m_numLines  =   строчки.length;
    }
export:

    /**
     *
     */
    this(ткст память, бцел флаги)
    {
        ткст[]    строчки = split(память, "\n");

        init_(строчки, флаги);
    }

    /**
     *
     */
    this(ткст[] строчки, бцел флаги)
    {
        init_(строчки, флаги);
    }


/* \имя Attributes */

export:

    /**
     *
     */
    тип_размера   члоЗаписей()
    {
        return m_records.length;
    }

    /**
     *
     */
    тип_размера   члоПолей()
    {
        return m_fields.length;
    }

    /**
     *
     */
    тип_размера   члоСтрок()
    {
        return m_numLines;
    }


/* \имя Attributes */

export:

    /**
     *
     */
    бцел флаги()
    {
        return m_flags;
    }

    /**
     *
     */
    Запись[] записи()
    {
        return m_records.dup;
    }

    /**
     *
     */
    Поле[] поля()
    {
        return m_fields.dup;
    }

    /**
     *
     */
    бцел длина()
    {
        return члоЗаписей();
    }

    /**
     *
     */
    Запись  opIndex(тип_индекса индекс)
    in
    {
        assert(индекс < m_records.length);
    }
    body
    {
        return m_records[индекс];
    }


/* \имя Searching */

export:

    /**
     *
     */
    Запись[]    дайЗаписиСПолем(ткст имяПоля)
    {
        Запись[]    записи;

        foreach(Запись запись; m_records)
        {
            if(null !is запись.найдиПоле(имяПоля))
            {
                записи ~= запись;
            }
        }

        return записи;
    }

    /**
     *
     */
    Запись[]    дайЗаписиСПолем(ткст имяПоля, ткст значениеПоля)
    {
        Запись[]    записи;
        бцел        флаги   =   флаги;

        foreach(Запись запись; m_records)
        {
            Поле   поле   =   запись.найдиПоле(имяПоля);

            if(null !is поле)
            {
                // Since there can be more than one поле with the same имя in
                // the same запись, we need to search all поля in this запись
                if(ОРДЖ_ФЛАГ.УПОРЯДОЧИТЬ_ПОЛЯ == (флаги & ОРДЖ_ФЛАГ.УПОРЯДОЧИТЬ_ПОЛЯ))
                {
                    // We can do a sorted search
                    foreach(Поле поле; запись)
                    {
                        цел res =   cmp(поле.имя, имяПоля);

                        if( 0 == res &&
                            (   null is значениеПоля ||
                                поле.значение == значениеПоля))
                        {
                            записи ~= запись;

                            break;
                        }
                        else if(res > 0)
                        {
                            break;
                        }
                    }
                }
                else
                {
                    foreach(Поле поле; запись)
                    {
                        if( поле.имя == имяПоля &&
                            (   null is значениеПоля ||
                                поле.значение == значениеПоля))
                        {
                            записи ~= запись;

                            break;
                        }
                    }
                }
            }
        }

        return записи;
    }


/* \имя Enumeration */

export:

    /**
     *
     */
    цел opApply(цел delegate(inout Запись запись) дг)
    {
        цел результат  =   0;

        foreach(Запись запись; m_records)
        {
            результат = дг(запись);

            if(0 != результат)
            {
                break;
            }
        };

        return результат;
    }

    /**
     *
     */
    цел opApply(цел delegate(inout Поле поле) дг)
    {
        цел результат  =   0;

        foreach(Поле поле; m_fields)
        {
            результат = дг(поле);

            if(0 != результат)
            {
                break;
            }
        };

        return результат;
    }


// Members
private:
    бцел        m_flags;
    тип_размера   m_numLines;
    Запись[]    m_records;
    Поле[]     m_fields;
}

/* ////////////////////////////////////////////////////////////////////////// */

version(MainTest)
{

    цел main(ткст[] args)
    {
        цел флаги   =   0
                    |   ОРДЖ_ФЛАГ.УПОРЯДОЧИТЬ_ПОЛЯ
                    |   ОРДЖ_ФЛАГ.ИГНОР_ПУСТЫЕ_ЗАПИСИ
                    |   0;

        if(args.length < 2)
        {
            эхо("Need to specify jar файл\n");
        }
        else
        {
            PerformanceCounter  counter =   new PerformanceCounter();

            try
            {
                эхо( "std.openrj test:\n\tmodule:      \t%.*s\n\tdescription: \t%.*s\n\tversion:     \t%d.%d.%d.%d\n"
                    ,   openrj.ВЕРСИЯ.имя
                    ,   openrj.ВЕРСИЯ.описание
                    ,   openrj.ВЕРСИЯ.мажор
                    ,   openrj.ВЕРСИЯ.минор
                    ,   openrj.ВЕРСИЯ.ревизия
                    ,   openrj.ВЕРСИЯ.редакц);

                counter.start();

                ткст      файл        =   args[1];
                ткст      chars       =   cast(ткст)std.файл.read(файл);
                БазаДанных    бд    =   new БазаДанных(chars, флаги);
//                БазаДанных    бд    =   new БазаДанных(split(chars, "\n"), флаги);

                counter.stop();

                PerformanceCounter.interval_type    loadTime    =   counter.microseconds();

                counter.start();

                цел i   =   0;
                foreach(Запись запись; бд.записи)
                {
                    foreach(Поле поле; запись)
                    {
                        i += поле.имя.length + поле.значение.length;
                    }
                }

                counter.stop();

                PerformanceCounter.interval_type    enumerateTime   =   counter.microseconds();

                эхо("Open-RJ/D test: 100%%-D!!\n");
                эхо("Load time:       %ld\n", loadTime);
                эхо("Enumerate time:  %ld\n", enumerateTime);

                return 0;

                эхо("Records (%u)\n", бд.члоЗаписей);
                foreach(Запись запись; бд)
                {
                    эхо("  Запись\n");
                    foreach(Поле поле; запись.поля)
                    {
                        эхо("    Поле: %.*s=%.*s\n", поле.имя, поле.значение);
                    }
                }

                эхо("Fields (%u)\n", бд.члоПолей);
                foreach(Поле поле; бд)
                {
                        эхо("    Поле: %.*s=%.*s\n", поле.имя, поле.значение);
                }

                Запись[]    записи =   бд.дайЗаписиСПолем("Name");
                эхо("Records containing 'Name' (%u)\n", записи);
                foreach(Запись запись; записи)
                {
                    эхо("  Запись\n");
                    foreach(Поле поле; запись.поля)
                    {
                        эхо("    Поле: %.*s=%.*s\n", поле.имя, поле.значение);
                    }
                }
            }
            catch(Exception x)
            {
                эхо("Exception: %.*s\n", x.вТкст());
            }
        }

        return 0;
    }

} // version(MainTest)

/* ////////////////////////////////////////////////////////////////////////// */
