/**
 * Authors: The D DBI project
 * Copyright: BSD license
 */

module dbi.mysql.MysqlResult;

private import dbi.DBIException;
private import dbi.model.Result,
               dbi.model.Constants;
private import dbi.AbstractResult,
               dbi.ValidityToken;

private import lib.mysql, dbi.mysql.imp;

private import core.Variant;
private import util.log.Log;
private import time.Time,
               time.Clock;

debug private import io.Stdout;

class РезультатМайЭсКюЭл : АбстрактныйРезультат, МультиРезультат
{
private:
    РядыМайЭсКюЭл _ряды;
    MYSQL* _дбаза = пусто;
    ТокеноДерж _token;

package:
    MYSQL_RES* результат = пусто;

public:

    alias АбстрактныйРезультат.метаданные метаданные;

    this(MYSQL* дбаза, ТокеноДерж токен)
    in{
        assert (дбаза !is пусто);
        assert (токен !is пусто);
    }
    body {
       super();
       _дбаза = дбаза; 
       _token = токен;
       токен.зарегиХук(&инвалидируй);
    }

    this(MYSQL_RES* рез, MYSQL* дбаза, ТокеноДерж токен)
    in {
        assert (рез !is пусто);
    }
    body {
        this (дбаза, токен);
        результат = рез;
        _ряды = пусто;
    }

    ~this()
    {
        if (действителен)
            закрой;
    }

    проц установи(MYSQL_RES* рез)
    {
        if (результат !is пусто)
            закрой;

        результат = рез;
    }

    РядыМайЭсКюЭл ряды()
    {
        if (_ряды is пусто)
            _ряды = new РядыМайЭсКюЭл(this);

        return _ряды;
    }

    ИнфОСтолбце[] метаданные()
    {
        auto поля = mysql_fetch_fields(результат);

        _метаданные = new ИнфОСтолбце[члоПолей];
        for (бдол i = 0; i < члоПолей; i++) {
            изПоляМайЭсКюЭл(_метаданные[i], поля[i]);
        }

        return _метаданные;
    }

    бдол члоРядов() { return mysql_num_rows(результат); }
    бдол члоПолей() { return mysql_num_fields(результат); }

    проц закрой()
    {
        if (результат is пусто)
            throw new Exception ("Данный набор результатов уже был закрыт.");

        mysql_free_result(результат);
        if (_дбаза !is пусто) {
            while (mysql_more_results(_дбаза)) {
                auto рез = mysql_next_result(_дбаза);
                assert(рез <= 0);
                результат = mysql_store_result(_дбаза);
                mysql_free_result(результат);
            }
        }
        результат = пусто;
    }

    бул ещё()
    in {
        assert (результат !is пусто);
    }
    body {
        if (результат is пусто)
            throw new ИсклДБИ ("Данный набор результатов уже был закрыт.");

        return cast(бул)mysql_more_results(_дбаза);
    }

    РезультатМайЭсКюЭл следщ()
    in {
        assert (результат !is пусто);
    }
    body {
        if (результат is пусто)
            throw new ИсклДБИ ("Данный набор результатов уже был закрыт.");

        mysql_free_result(результат);
        auto рез = mysql_next_result(_дбаза);
        if (рез <= 0) {
            результат = mysql_store_result(_дбаза);
            return this;
        }
        else {
            throw new ИсклДБИ("Не удалось получить следующий набор результатов.");
        }
    }

    бул действителен() { return результат !is пусто; }

private:

    проц инвалидируй(Объект o) {
        _дбаза = пусто;    
        if (действителен) закрой;
    }
}

class РядыМайЭсКюЭл : АбстрактныеРяды
{
private:

    РезультатМайЭсКюЭл _ряды;
    ИнфОСтолбце[] _метаданные;

public:

    this (РезультатМайЭсКюЭл результаты)
    {
        super (результаты);
        _ряды = результаты;
    }

    ИнфОСтолбце[] метаданные()
    {
        auto поля = mysql_fetch_fields(_ряды.результат);

        _метаданные = new ИнфОСтолбце[_ряды.члоПолей];
        for (бдол i = 0; i < _ряды.члоПолей; i++) {
            изПоляМайЭсКюЭл(_метаданные[i], поля[i]);
        }

        return _метаданные;
    }

    цел opApply (цел delegate(inout Ряд) дг)
    {
        assert (_ряды !is пусто);
        цел результат;
        РядМайЭсКюЭл host = new РядМайЭсКюЭл; 
        MYSQL_ROW ряд;
        assert (_ряды !is пусто && _ряды.действителен);
        debug Стдвыв("Ряды действительны.").нс;
        while ((ряд = mysql_fetch_row(_ряды.результат)) !is пусто) {
            host.установи(ряд, mysql_fetch_lengths(_ряды.результат));
            Ряд r = host;
            if ((результат = дг(r)) != 0)
                break;
        }
        return результат;
    }

    РядМайЭсКюЭл следщ()
    {
        // TODO reuse
        return new РядМайЭсКюЭл(_ряды);
    }

    бул добудь(Размест размест, ук ...)
    {
        // TODO
        return false;
    }

    РядМайЭсКюЭл opIndex(бдол инд)
    {
        // TODO
        return пусто;
    }

    проц сместись(бдол offустанови)
    {
        mysql_data_seek(_ряды.результат, offустанови);
    }
}

class РядМайЭсКюЭл : Ряд
{
private:
    РезультатМайЭсКюЭл _results = пусто;
    MYSQL_ROW _row;
    т_мера* _lengths = пусто;
    private Логгер лог;

private:

    проц initRow() {
        _row = mysql_fetch_row(_results.результат);
        _lengths = mysql_fetch_lengths(_results.результат);
    }


public:

    this () 
    {
        лог = Журнал.дайЛоггер(this.classinfo.вТкст);
    }

    this (РезультатМайЭсКюЭл результаты)
    in {
        assert (результаты !is пусто);
    }
    body {
        _results = результаты;
        initRow;
    }

    this (MYSQL_ROW ряд, т_мера* lengths)
    {
        _row = ряд;
        _lengths = lengths;
    }


    РядМайЭсКюЭл установи(MYSQL_ROW ряд, т_мера* lengths)
    {
        _row = ряд;
        _lengths = lengths;
        return this;
    }

    РядМайЭсКюЭл установи(РезультатМайЭсКюЭл результаты) {
        _results = результаты;
        initRow; 
        
        return this;
    }

    ИнфОСтолбце[] метаданные()
    {
        return _results.метаданные();
    }

    ИнфОСтолбце метаданные(т_мера инд)
    {
        return _results.метаданные(инд);
    }

    бдол члоПолей()
    {
        return _results.члоПолей;
    }

    ткст текстПо(т_мера инд)
    {
        return _row[инд][0 .. _lengths[инд]];
    }

    ткст текстПо(ткст имя)
    {
        foreach (i, column; метаданные) 
            if (имя is column.имя)
                return _row[i][0 .. _lengths[i]];

        return пусто;
    }

    проц добудь(inout ткст[] значения)
    in {
        assert (значения.length >= члоПолей);
    }
    body {
        for (цел i = 0; i < члоПолей; i++) {
            значения[i] = _row[i][0 .. _lengths[i]];
        }
    }

    проц добудь(inout ткст значение, т_мера инд = 0)
    in {
        assert(инд < члоПолей);
    }
    body {
        значение = _row[инд][0 .. _lengths[инд]];
    }
}

package:

ТипДби изТипаМайЭсКюЭл(enum_field_types тип)
{
    with (enum_field_types) {
        switch (тип) {
            case MYSQL_TYPE_DECIMAL:
                return ТипДби.Десяток;
            case MYSQL_TYPE_TINY:
                return ТипДби.Байт;
            case MYSQL_TYPE_SHORT:
                return ТипДби.Крат;
            case MYSQL_TYPE_LONG:
            case MYSQL_TYPE_ENUM:
                return ТипДби.Цел;
            case MYSQL_TYPE_FLOAT:
                return ТипДби.Плав;
            case MYSQL_TYPE_DOUBLE:
                return ТипДби.Дво;
            case MYSQL_TYPE_NULL:
                return ТипДби.Пусто;
            case MYSQL_TYPE_TIMESTAMP:
                 return ТипДби.ДатаВремя;
            case MYSQL_TYPE_LONGLONG:
                return ТипДби.Дол;
            case MYSQL_TYPE_INT24:
                 return ТипДби.Цел;
            case MYSQL_TYPE_DATE:
            case MYSQL_TYPE_TIME:
            case MYSQL_TYPE_DATETIME:
            case MYSQL_TYPE_YEAR:
            case MYSQL_TYPE_NEWDATE:
                return ТипДби.ДатаВремя;
            case MYSQL_TYPE_BIT:
                assert(false);
            case MYSQL_TYPE_NEWDECIMAL:
                return ТипДби.Десяток;
            case MYSQL_TYPE_SET:
                assert(false);
            case MYSQL_TYPE_TINY_BLOB:
            case MYSQL_TYPE_MEDIUM_BLOB:
            case MYSQL_TYPE_LONG_BLOB:
            case MYSQL_TYPE_BLOB:
                return ТипДби.Бинар;
            case MYSQL_TYPE_VARCHAR:
            case MYSQL_TYPE_VAR_STRING:
            case MYSQL_TYPE_STRING:
                return ТипДби.Ткст;
            case MYSQL_TYPE_GEOMETRY:
                assert(false);
            default:
                return ТипДби.Неук;
        }
    }
}

проц изПоляМайЭсКюЭл(inout ИнфОСтолбце column, MYSQL_FIELD field)
{
    column.имя = field.имя[0..field.имя_поля];
    column.имя.length = field.имя_поля;
    column.тип = изТипаМайЭсКюЭл(field.тип);
    column.флаги = field.flags;
}
