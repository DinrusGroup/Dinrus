/**
 * Authors: The D DBI project
 *
 * Version: 0.2.5
 *
 * Copyright: BSD license
 */
module dbi.odbc.OdbcResult;

// Almost every cast involving chars and SQLCHARs shouldn't exist, but involve bugs in
// WindowsAPI revision 144.  I'll see about fixing their ODBC and SQL files soon.
// WindowsAPI should also include odbc32.lib itself.

version(Rulada) {
	private import stdrus : убери = strip;
} else {
	private import text.Util : убери;
}
private import dbi.DBIException, dbi.Result, dbi.Row;
private import win32.odbcinst, win32.sql, win32.sqlext, win32.sqltypes, win32.sqlucode, win32.windef;

version (Windows) pragma (lib, "odbc32.lib");

/*
 * This is in the эскюэл headers, but wasn't ported in WindowsAPI revision 144.
 */
private бул SQL_SUCCEEDED (SQLRETURN ret) {
	return (ret == SQL_SUCCESS || ret == SQL_SUCCESS_WITH_INFO) ? да : false;
}

/**
 * Manage a результат установи from an ODBC interface запрос.
 *
 * See_Also:
 *	Результат is the interface of which this provides an implementation.
 */
class РезультатОДБЦ : Результат {
	public:
	this (SQLHSTMT инстр) {
		this.инстр = инстр;

		if (!SQL_SUCCEEDED(SQLNumResultCols(инстр, &numColumns))) {
			throw new ИсклДБИ("Не удаётся получить число колонок.  ODBC вернуло " ~ дайСообПоследнОш, дайКодПоследнОш);
		}
		columnTypesNum.length = numColumns;
		columnTypesName.length = numColumns;
		columnNames.length = numColumns;

		SQLLEN typeNum;
		SQLCHAR[512] typeName;
		SQLSMALLINT typeNameLength;
		SQLCHAR[512] columnName;
		SQLSMALLINT columnNameLength;
		for (SQLUSMALLINT i = 1; i <= numColumns; i++) {
			if (!SQL_SUCCEEDED(SQLColAttribute(инстр, i, SQL_DESC_TYPE, пусто, 0, пусто, &typeNum))) {
				throw new ИсклДБИ("Не удаётся получить типы колонок SQL.  ODBC вернуло " ~ дайСообПоследнОш, дайКодПоследнОш);
			}
			if (!SQL_SUCCEEDED(SQLColAttribute(инстр, i, SQL_DESC_TYPE_NAME, typeName.ptr, typeName.length, &typeNameLength, пусто))) {
				throw new ИсклДБИ("Не удалось получить имена типов колонок SQL.  ODBC вернуло " ~ дайСообПоследнОш, дайКодПоследнОш);
			}
			if (!SQL_SUCCEEDED(SQLColAttribute(инстр, i, SQL_DESC_NAME, columnName.ptr, columnName.length, &columnNameLength, пусто))) {
				throw new ИсклДБИ("Не удалось получить имена колонок SQL.  ODBC вернуло " ~ дайСообПоследнОш, дайКодПоследнОш);
			}

			columnTypesNum[i - 1] = typeNum;
			columnTypesName[i - 1] = cast(ткст)typeName[0 .. typeNameLength].dup;
			columnNames[i - 1] = cast(ткст)columnName[0 .. columnNameLength].dup;
		}
	}

	/**
	 * Get the следщ ряд from a результат установи.
	 *
	 * Returns:
	 *	A Ряд object with the queried information or пусто for an empty установи.
	 */
	override Ряд получиРяд () {
		if (SQL_SUCCEEDED(SQLFetch(инстр))) {
			Ряд ряд = new Ряд();
			SQLLEN indicator;
			SQLCHAR[512] buf;

			for (SQLUSMALLINT i = 1; i <= numColumns; i++) {
				if (SQL_SUCCEEDED(SQLGetData(инстр, i, SQL_C_CHAR, buf.ptr, buf.length, &indicator))) {
					if (indicator == SQL_NULL_DATA) {
						buf[0 .. 4] = cast(SQLCHAR[])"null";
						buf[4 .. length] = cast(SQLCHAR)'\0';
					}
					if (indicator < 0) {
						ряд.добавьПоле(columnNames[i - 1], пусто, columnTypesName[i - 1], columnTypesNum[i - 1]);
					} else {
						ряд.добавьПоле(columnNames[i - 1], убери(cast(ткст)buf[0 .. indicator]), columnTypesName[i - 1], columnTypesNum[i - 1]);
					}
				}
			}
			return ряд;
		} else {
			return пусто;
		}
	}

	/**
	 * Free all бд resources used by a результат установи.
	 *
	 * Thряды:
	 *	ИсклДБИ if an ODBC statement couldn't be destroyed.
	 */
	override проц финиш () {
		if (cast(ук)инстр !is пусто) {
			if (!SQL_SUCCEEDED(SQLFreeHandle(SQL_HANDLE_STMT, инстр))) {
				throw new ИсклДБИ("Не удаётся удалить инструкцию ODBC. ODBC вернуло " ~ дайСообПоследнОш, дайКодПоследнОш);
			}
			инстр = cast(SQLHANDLE)пусто;
		}
	}

	private:
	SQLHSTMT инстр;
	SQLSMALLINT numColumns;
	цел[] columnTypesNum;
	ткст[] columnTypesName;
	ткст[] columnNames;
	char[512][] columnData;

	/**
	 * Get the last ошибка message returned by the server.
	 */
	ткст дайСообПоследнОш () {
		SQLSMALLINT errorNumber;
		SQLCHAR[5] state;
		SQLINTEGER nativeCode;
		SQLCHAR[512] text;
		SQLSMALLINT textLength;

		SQLGetDiagField(SQL_HANDLE_STMT, инстр, 0, SQL_DIAG_NUMBER, &errorNumber, 0, пусто);
		SQLGetDiagRec(SQL_HANDLE_STMT, инстр, errorNumber, state.ptr, &nativeCode, text.ptr, text.length, &textLength);
		return cast(ткст)state ~ " = " ~ cast(ткст)text;
	}

	/**
	 * Get the last ошибка code return by the server.  This is the native code.
	 */
	цел дайКодПоследнОш () {
		SQLSMALLINT errorNumber;
		SQLCHAR[5] state;
		SQLINTEGER nativeCode;
		SQLCHAR[512] text;
		SQLSMALLINT textLength;

		SQLGetDiagField(SQL_HANDLE_STMT, инстр, 0, SQL_DIAG_NUMBER, &errorNumber, 0, пусто);
		SQLGetDiagRec(SQL_HANDLE_STMT, инстр, errorNumber, state.ptr, &nativeCode, text.ptr, text.length, &textLength);
		return nativeCode;
	}
}