/**
 * Authors: The D DBI project
 * Copyright: BSD license
 */

module dbi.mysql.MysqlStatement;

//version = MySQL_51;
version = dbi_mysql;

private import dbi.model.Statement,
               dbi.model.Result, dbi.mysql.MysqlError,
               dbi.model.Constants, lib.mysql, dbi.mysql.imp;

private import dbi.DBIException;

private import dbi.mysql.MysqlResult,
               dbi.mysql.MysqlError;

private import lib.mysql;

private import util.log.Log;
private import cidrus,
               stringz;
private import time.Time,
               time.Clock;

class ИнструкцияМайЭсКюЭл : Инструкция, Преддоб
{

private:
    MYSQL * подключение;
    MYSQL_STMT * инстр;
	MYSQL_BIND[] paramBind;
	ПомощникПодвязки paramHelper;
	MYSQL_BIND[] resBind;
    ИнфОСтолбце[] _метаданные;
	ПомощникПодвязки resHelper;
    Логгер лог;

    Размест _размест;

    бул преддобудьed = false;
    Время _штампврем;
	
package:
    
    this(MYSQL_STMT * инстр, MYSQL * подключение)
	{
		this.инстр = инстр;
        this.подключение = подключение;
        _штампврем = Часы.сейчас;
        лог = Журнал.отыщи(this.classinfo.вТкст);
	}

public:

    override бцел члоПарамов()
    {
        return mysql_stmt_param_count(инстр);
    }

    override проц типыПарамов(ТипДби[] типыПарамов ...)
    {
	    иницПодвязку(типыПарамов, paramBind, paramHelper);
    }

    override проц типыРезультата(ТипДби[] типыРез ...)
    {
        иницПодвязку(типыРез, resBind, resHelper);
    }

    override Размест разместитель()
    {
        return _размест;
    }

    override проц разместитель(Размест размест)
    {
        _размест = размест;
    }

    override проц выполни(ук[] вяжи ...)
    {
        if (вяжи.length == 0)
            return exec();

		if(!вяжи || !paramBind) throw new ИсклДБИ("Попытка выполнения инструкции с неустановленными параметрами\nили без передачи действительного массива привязки.");
		if(вяжи.length != paramBind.length) throw new ИсклДБИ("Неверное количество указателей в массиве привязки");
		
		auto len = вяжи.length;
		for(т_мера i = 0; i < len; ++i)
		{
			switch(paramHelper.types[i])
			{
			case(ТипДби.Ткст):
			case(ТипДби.Бинар):
				ббайт[]* arr = cast(ббайт[]*)(вяжи[i]);
				paramBind[i].буфер = (*arr).ptr;
				auto l = (*arr).length;
				paramBind[i].buffer_length = l;
				paramHelper.len[i] = l;
				break;
			case(ТипДби.Время):
				auto время = *cast(Время*)(вяжи[i]);
				auto dateTime = Часы.вДату(время); 
				paramHelper.время[i].год = dateTime.дата.год;
				paramHelper.время[i].месяц = dateTime.дата.месяц;
				paramHelper.время[i].день = dateTime.дата.день;
				paramHelper.время[i].час = dateTime.время.часы;
				paramHelper.время[i].минута = dateTime.время.минуты;
				paramHelper.время[i].секунда = dateTime.время.сек;
				break;
			case(ТипДби.ДатаВремя):
				auto dateTime = *cast(ДатаВремя*)(вяжи[i]);
				paramHelper.время[i].год = dateTime.дата.год;
				paramHelper.время[i].месяц = dateTime.дата.месяц;
				paramHelper.время[i].день = dateTime.дата.день;
				paramHelper.время[i].час = dateTime.время.часы;
				paramHelper.время[i].минута = dateTime.время.минуты;
				paramHelper.время[i].секунда = dateTime.время.сек;
				break;
			default:
				paramBind[i].буфер = вяжи[i];
				break;
			}
		}
		
		auto рез = mysql_stmt_bind_param(инстр, paramBind.ptr);
		if(рез != 0) {
			throw new ИсклДБИ("Ошибка привязки параметров для выполнения инструкции", рез, dbi.mysql.MysqlError.спецВОбщ(рез));
		}
        exec;
    }

    бул добудь(ук[] вяжи ...)
    {
		if(!вяжи || !resBind) throw new ИсклДБИ("Попытка получить результат от инструкции\n без установки типов параметров\nили передачи действительного массива привязки.");
		if(вяжи.length != resBind.length) throw new ИсклДБИ("Неверное количество указателей в массиве привязки");
		
		auto len = вяжи.length;
		for(т_мера i = 0; i < len; ++i)
		{
			with(enum_field_types)
			{
			switch(resBind[i].тип_буфера)
			{
			case(MYSQL_TYPE_STRING):
			case(MYSQL_TYPE_BLOB):
				ббайт[]* arr = cast(ббайт[]*)(вяжи[i]);
				resHelper.буфер[i] = *arr;
				resBind[i].buffer_length = arr.length;
				resHelper.len[i] = 0;
				resBind[i].буфер = arr.ptr;
				break;
			case(MYSQL_TYPE_DATETIME):
				break;
			default:
				resBind[i].буфер = вяжи[i];
				break;
			}
			}
		}
		
		my_bool резподвяз = mysql_stmt_bind_result(инстр, resBind.ptr);
		if(резподвяз != 0) {
			debug {
				лог.ошибка("Неучная привязка параметров результата");
                лог.ошибка(изТкст0(mysql_error(подключение)));
			}
			return false;
		}
		цел рез = mysql_stmt_fetch(инстр);
		if(рез == 1) {
			debug(Log) {
                // TODO : fix
				лог.ошибка("Ошибка в получении данных результата");
                лог.ошибка(изТкст0(mysql_error(подключение)));
			}
			return false;
		}
		if(рез == 100 /*MYSQL_NO_DATA*/) {
			сбрось;
			return false;
		}
		
		foreach(i, mysqlTime; resHelper.время)
		{
			if(resHelper.types[i] == ТипДби.Время) {
				Время* время = cast(Время*)(вяжи[i]);
				ДатаВремя dt;
				dt.дата.год = mysqlTime.год;
				dt.дата.месяц = mysqlTime.месяц;
				dt.дата.день = mysqlTime.день;
				dt.время.часы = mysqlTime.час;
				dt.время.минуты = mysqlTime.минута;
				dt.время.сек = mysqlTime.секунда;
				*время = Часы.изДаты(dt);
			}
			else if(resHelper.types[i] == ТипДби.ДатаВремя) {
				ДатаВремя* dt = cast(ДатаВремя*)(вяжи[i]);
				(*dt).дата.год = mysqlTime.год;
				(*dt).дата.месяц = mysqlTime.месяц;
				(*dt).дата.день = mysqlTime.день;
				(*dt).время.часы = mysqlTime.час;
				(*dt).время.минуты = mysqlTime.минута;
				(*dt).время.сек = mysqlTime.секунда;
			}
		}
		
		if(рез == 0) {
			foreach(i, buf; resHelper.буфер)
			{
				ббайт[]* arr = cast(ббайт[]*)(вяжи[i]);
				auto l = resHelper.len[i];
				*arr = buf[0 .. l];
			}
			return да;
		}
		else if(рез == 101/*MYSQL_DATA_TRUNCATED*/)
		{
			foreach(i, buf; resHelper.буфер)
			{
				ббайт[]* arr = cast(ббайт[]*)(вяжи[i]);
				auto l = resHelper.len[i];
				
				if(resBind[i].ошибка) {
					if(_размест) {
						ббайт* ptr = cast(ббайт*)_размест(l);
						buf = ptr[0 .. l];
					}
					else {
						buf = new ббайт[l];
					}
					resBind[i].buffer_length = l;
					resBind[i].буфер = buf.ptr;
					if(mysql_stmt_fetch_column(инстр, &resBind[i], i, 0) != 0) {
						debug(Log) {
							лог.ошибка("Ошибка при получении бинарного текста из-за обрезки");
							logError;
						}
						return false;
					}
				}
				*arr = buf[0 .. l];
			}
			return да;
		}
		else if(рез == 100/*MYSQL_NO_DATA*/) return false;
		else return false;

    }

    override проц закрой()
    {
        if (инстр !is пусто) {
	        mysql_stmt_close(инстр);
	        инстр = пусто;
	    }
    }
	
	override проц сбрось()
	{
		mysql_stmt_free_result(инстр);
	}

    override бдол идПоследнейВставки()
	{
		return mysql_stmt_insert_id(инстр);
	}

    override проц преддобудь()
    {
        преддобудьed = да;
        mysql_stmt_store_result(инстр);
    }

    /**
      * Returns the number of ряды available in the результат from this statement.
      * However, this значение is not available unless преддобудь was called. If it
      * wasn't, the счёт is установи to 0.
      *
      * Returns:
      *     The number of ряды in the результат if преддобудьed, 0 otherwise.
      */
    override бдол члоРядов()
    {
        if (преддобудьed)
            return mysql_stmt_num_rows(инстр);
        else
            return 0;
    }

    override бдол члоПолей()
    {
        return mysql_stmt_field_count(инстр);
    }

    override бдол задействованныеРяды()
    {
        return mysql_stmt_affected_rows(инстр);
    }

	override ИнфОСтолбце[] метаданные()
    {
		MYSQL_RES* рез = mysql_stmt_result_metadata(инстр);
		if(!рез) return пусто;
		т_мера numfields = mysql_num_fields(рез);
		if(!numfields) return пусто;
		
		MYSQL_FIELD* поля = mysql_fetch_fields(рез);
		
		_метаданные.length = numfields;
		
		for(бцел i = 0; i < numfields; i++)
		{
			_метаданные[i].имя = поля[i].имя[0 .. поля[i].имя_поля].dup;
			_метаданные[i].тип = изТипаМайЭсКюЭл(поля[i].тип);
		}
		mysql_free_result(рез);
		return _метаданные;
    }

    override ИнфОСтолбце метаданные(т_мера инд)
    {
        if (_метаданные is пусто)
            метаданные;

        return _метаданные[инд];
    }

    override Время штампВремени() { return _штампврем; }

    override бул действителен() { return инстр !is пусто; }

private:
 
    override проц exec()
    {
        auto рез = mysql_stmt_execute(инстр);

		if(рез) {
			throw new ИсклДБИ("Ошибка при выполнении инструкции", рез, спецВОбщ(рез));
		}
    }
   	
	static struct ПомощникПодвязки
	{	
		проц установиДлину(т_мера l)
		{
			ошибка.length = l;
			is_null.length = l;
			len.length = l;
			время = пусто;
			буфер = пусто;
			foreach(ref n; is_null)
			{
				n = false;
			}
			
			foreach(ref e; ошибка)
			{
				e = false;
			}
			
			foreach(ref i; len)
			{
				i = 0;
			}
		}
		my_bool[] ошибка;
		my_bool[] is_null;
		т_мера[] len;
		MYSQL_TIME[бцел] время;
		ббайт[][бцел] буфер;
		ТипДби[] types;
	}

    static проц иницПодвязку(ТипДби[] types, inout MYSQL_BIND[] вяжи, 
                             inout ПомощникПодвязки helper)
	{
		т_мера l = types.length;
		вяжи.length = l;
		foreach(ref b; вяжи)
		{
			memset(&b, 0, MYSQL_BIND.sizeof);
		}
		helper.установиДлину(l);
		for(т_мера i = 0; i < l; ++i)
		{
			switch(types[i])
			{
			case(ТипДби.Бул):
				вяжи[i].тип_буфера = enum_field_types.MYSQL_TYPE_TINY;
				вяжи[i].без_знака = false;
				break;
			case(ТипДби.Байт):
				вяжи[i].тип_буфера = enum_field_types.MYSQL_TYPE_TINY;
				вяжи[i].без_знака = false;
				break;
			case(ТипДби.Крат):
				вяжи[i].тип_буфера = enum_field_types.MYSQL_TYPE_SHORT;
				вяжи[i].без_знака = false;
				break;
			case(ТипДби.Цел):
				вяжи[i].тип_буфера = enum_field_types.MYSQL_TYPE_LONG;
				вяжи[i].buffer_length = 4;
				вяжи[i].без_знака = false;
				break;
			case(ТипДби.Дол):
				вяжи[i].тип_буфера = enum_field_types.MYSQL_TYPE_LONGLONG;
				вяжи[i].buffer_length = 8;
				вяжи[i].без_знака = false;
				break;
			case(ТипДби.ББайт):
				вяжи[i].тип_буфера = enum_field_types.MYSQL_TYPE_TINY;
				вяжи[i].без_знака = да;
				break;
			case(ТипДби.БКрат):
				вяжи[i].тип_буфера = enum_field_types.MYSQL_TYPE_SHORT;
				вяжи[i].без_знака = да;
				break;
			case(ТипДби.БЦел):
				вяжи[i].тип_буфера = enum_field_types.MYSQL_TYPE_LONG;
				вяжи[i].buffer_length = 4;
				вяжи[i].без_знака = да;
				break;
			case(ТипДби.БДол):
				вяжи[i].тип_буфера = enum_field_types.MYSQL_TYPE_LONGLONG;
				вяжи[i].buffer_length = 8;
				вяжи[i].без_знака = да;
				break;
			case(ТипДби.Плав):
				вяжи[i].тип_буфера = enum_field_types.MYSQL_TYPE_FLOAT;
				вяжи[i].без_знака = false;
				break;
			case(ТипДби.Дво):
				вяжи[i].тип_буфера = enum_field_types.MYSQL_TYPE_DOUBLE;
				вяжи[i].без_знака = false;
				break;
			case(ТипДби.Ткст):
				вяжи[i].тип_буфера = enum_field_types.MYSQL_TYPE_STRING;
				вяжи[i].без_знака = false;
				break;
			case(ТипДби.Бинар):
				вяжи[i].тип_буфера = enum_field_types.MYSQL_TYPE_BLOB;
				вяжи[i].без_знака = false;
				break;
			case(ТипДби.Время):
				helper.время[i] = MYSQL_TIME();
				вяжи[i].буфер = &helper.время[i];
				вяжи[i].тип_буфера = enum_field_types.MYSQL_TYPE_DATETIME;
				вяжи[i].без_знака = false;
				break;
			case(ТипДби.ДатаВремя):
				helper.время[i] = MYSQL_TIME();
				вяжи[i].буфер = &helper.время[i];
				вяжи[i].тип_буфера = enum_field_types.MYSQL_TYPE_DATETIME;
				вяжи[i].без_знака = false;
				break;
			case(ТипДби.Пусто):
				вяжи[i].тип_буфера = enum_field_types.MYSQL_TYPE_NULL;
				break;
			default:
				assert(false, "Необрабатывае5мый тип привязки"); //TODO ещё detailed information;
				вяжи[i].тип_буфера = enum_field_types.MYSQL_TYPE_NULL;
				break;
			}
			
			вяжи[i].length = &helper.len[i];
			вяжи[i].ошибка = &helper.ошибка[i];
			вяжи[i].is_null = &helper.is_null[i];
		}
		
		helper.types = types;
	}

}
