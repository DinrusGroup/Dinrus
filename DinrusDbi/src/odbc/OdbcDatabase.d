module dbi.odbc.OdbcDatabase;

// Almost every cast involving chars and SQLCHARs shouldn't exist, but involve bugs in
// WindowsAPI revision 144.  I'll see about fixing their ODBC and SQL files soon.
// WindowsAPI should also include odbc32.lib itself.

version(Rulada) {
	private static import stdrus;
	debug (UnitTest) private static import std.io;
} else {
	private static import text.Util;
	debug (UnitTest) private static import io.Stdout;
}
private import dbi.DataBase, dbi.DBIException, dbi.Result;
private import dbi.odbc.OdbcResult;
private import win32.odbcinst, win32.sql, win32.sqlext, win32.sqltypes, win32.sqlucode, win32.windef;
debug (UnitTest) private import dbi.Row, dbi.Statement;

version (Windows) pragma (lib, "odbc32.lib");

private SQLHENV environment;

/*
 * This is in the эскюэл headers, but wasn't ported in WindowsAPI revision 144.
 */
private бул SQL_SUCCEEDED (SQLRETURN ret) {
	return (ret == SQL_SUCCESS || ret == SQL_SUCCESS_WITH_INFO) ? да : false;
}

static this () {
	// Note: The cast is a pseudo-bug workaround for WindowsAPI revision 144.
	if (!SQL_SUCCEEDED(SQLAllocHandle(SQL_HANDLE_ENV, cast(SQLHANDLE)SQL_NULL_HANDLE, &environment))) {
		throw new ИсклДБИ("Не удаётся инициализировать среду ODBC.");
	}
	// Note: The cast is a pseudo-bug workaround for WindowsAPI revision 144.
	if (!SQL_SUCCEEDED(SQLSetEnvAttr(environment, SQL_ATTR_ODBC_VERSION, cast(SQLPOINTER)SQL_OV_ODBC3, 0))) {
		throw new ИсклДБИ("Не удаётся установить среду ODBC в версию 3.");
	}
}

static ~this () {
	if (!SQL_SUCCEEDED(SQLFreeHandle(SQL_HANDLE_ENV, environment))) {
		throw new ИсклДБИ("Не удаётся закрыть среду ODBC.");
	}
}

/**
 * An implementation of БазаДанных for use with the ODBC interface.
 *
 * Bugs:
 *	БазаДанных-specific ошибка codes are not converted to КодОшибки.
 *
 * See_Also:
 *	БазаДанных is the interface that this provides an implementation of.
 */
class ОдбцБД : БазаДанных {
	public:
	/**
	 * Create a new instance of ОдбцБД, but don't подключись.
	 *
	 * Thряды:
	 *	ИсклДБИ if an ODBC подключение couldn't be created.
	 */
	this () {
		if (!SQL_SUCCEEDED(SQLAllocHandle(SQL_HANDLE_DBC, environment, &подключение))) {
			throw new ИсклДБИ("Не удаётся создать подключение к ODBC.  ODBC вернуло " ~ дайСообПоследнОш, дайКодПоследнОш);
		}

	}

	/**
	 * Create a new instance of ОдбцБД and подключись to a server.
	 *
	 * Thряды:
	 *	ИсклДБИ if an ODBC подключение couldn't be created.
	 *
	 * See_Also:
	 *	подключись
	 */
	this (ткст парамы, ткст имя_пользователя = пусто, ткст пароль = пусто) {
		this();
		подключись(парамы, имя_пользователя, пароль);
	}

	/**
	 * Deallocate the подключение handle.
	 */
	~this () {
		закрой();
		if (!SQL_SUCCEEDED(SQLFreeHandle(SQL_HANDLE_DBC, подключение))) {
			throw new ИсклДБИ("Не удаётся закрыть подключение к ODBC.  ODBC вернуло " ~ дайСообПоследнОш, дайКодПоследнОш);
		}
		подключение = cast(SQLHANDLE)пусто;
	}

	/**
	 * Connect to a бд using ODBC.
	 *
	 * This function will подключись without DSN if парамы has a '=' and with DSN
	 * otherwise.  For information on how to use подключись without DSN, see the
	 * ODBC documentation.
	 *
	 * Bugs:
	 *	Connecting without DSN ignores имя_пользователя and пароль.
	 *
	 * Params:
	 *	парамы = The DSN to use or the подключение parameters.
	 *	имя_пользователя = The _userимя to _подключись with.
	 *	пароль = The _password to _подключись with.
	 *
	 * Thряды:
	 *	ИсклДБИ if there was an ошибка подключисьing.
	 *
	 * Examples:
	 *	---
	 *	ОдбцБД бд = new ОдбцБД();
	 *	бд.подключись("Data Source Name", "_userимя", "_password");
	 *	---
	 *
	 * See_Also:
	 *	The ODBC documentation included with the MDAC 2.8 SDK.
	 */
	override проц подключись (ткст парамы, ткст имя_пользователя = пусто, ткст пароль = пусто) {
		проц подключисьБезДСН () {
			SQLCHAR[1024] буфер;

			if (!SQL_SUCCEEDED(SQLDriverConnect(подключение, пусто, cast(SQLCHAR*)парамы.ptr, cast(SQLSMALLINT)парамы.length, буфер.ptr, буфер.length, пусто, SQL_DRIVER_COMPLETE))) {
				throw new ИсклДБИ("Не удаётся подключиться к базе данных.  ODBC вернуло " ~ дайСообПоследнОш, дайКодПоследнОш);
			}
		}

		проц подключись_с_ДСН () {
			if (!SQL_SUCCEEDED(SQLConnect(подключение, cast(SQLCHAR*)парамы.ptr, cast(SQLSMALLINT)парамы.length, cast(SQLCHAR*)имя_пользователя.ptr, cast(SQLSMALLINT)имя_пользователя.length, cast(SQLCHAR*)пароль.ptr, cast(SQLSMALLINT)пароль.length))) {
				throw new ИсклДБИ("Не удаётся подключиться к базе данных.  ODBC вернуло " ~ дайСообПоследнОш, дайКодПоследнОш);
			}
		}

		version(Rulada) {
			if (stdrus.find(парамы, "=") == -1) {
				подключись_с_ДСН();
			} else {
				подключисьБезДСН();
			}
		} else {
			if (text.Util.содержит(парамы, '=')) {
				подключисьБезДСН();
			} else {
				подключись_с_ДСН();
			}
		}
	}

	/**
	 * Close the current подключение to the бд.
	 *
	 * Thряды:
	 *	ИсклДБИ if there was an ошибка disподключисьing.
	 */
	override проц закрой () {
		if (cast(ук)подключение !is пусто && !SQL_SUCCEEDED(SQLDisconnect(подключение))) {
			if (дайСообПоследнОш[0 .. 5] != "08003") {
				throw new ИсклДБИ("Не удаётся подключиться к базе данных.  ODBC вернуло " ~ дайСообПоследнОш, дайКодПоследнОш);
			}
		}
	}

	/**
	 * Execute a SQL statement that returns no результаты.
	 *
	 * Params:
	 *	эскюэл = The SQL statement to _выполни.
	 *
	 * Thряды:
	 *	ИсклДБИ if an ODBC statement couldn't be created.
	 *
	 *	ИсклДБИ if the SQL code couldn't be выполниd.
	 *
	 *	ИсклДБИ if there is an ошибка while committing the changes.
	 *
	 *	ИсклДБИ if there is an ошибка while rolling back the changes.
	 *
	 *	ИсклДБИ if an ODBC statement couldn't be destroyed.
	 */
	override проц выполни (ткст эскюэл) {
		scope (exit)
			инстр = cast(SQLHANDLE)пусто;
		scope (exit)
			if (!SQL_SUCCEEDED(SQLFreeHandle(SQL_HANDLE_STMT, инстр))) {
				throw new ИсклДБИ("Не удаётся удалить инструкцию ODBC.  ODBC вернуло " ~ дайСообПоследнОш, дайКодПоследнОш);
			}
		scope (failure)
			if (!SQL_SUCCEEDED(SQLEndTran(SQL_HANDLE_DBC, подключение, SQL_ROLLBACK))) {
				throw new ИсклДБИ("Не удался откат после неудачного запроса.  ODBC вернуло " ~ дайСообПоследнОш, дайКодПоследнОш);
			}
		if (!SQL_SUCCEEDED(SQLAllocHandle(SQL_HANDLE_STMT, подключение, &инстр))) {
			throw new ИсклДБИ("Не удаётся создать инструкцию ODBC.  ODBC вернуло " ~ дайСообПоследнОш, дайКодПоследнОш);
		}
		if (!SQL_SUCCEEDED(SQLExecDirect(инстр, cast(SQLCHAR*)эскюэл.ptr, эскюэл.length))) {
			throw new ИсклДБИ("Не удалось выполнить код SQL.  ODBC вернуло " ~ дайСообПоследнОш, дайКодПоследнОш);
		}

	}

	/**
	 * Query the бд.
	 *
	 * Params:
	 *	эскюэл = The SQL statement to выполни.
	 *
	 * Returns:
	 *	A Результат object with the queried information.
	 *
	 * Thряды:
	 *	ИсклДБИ if an ODBC statement couldn't be created.
	 *
	 *	ИсклДБИ if the SQL code couldn't be выполниd.
	 *
	 *	ИсклДБИ if there is an ошибка while committing the changes.
	 *
	 *	ИсклДБИ if there is an ошибка while rolling back the changes.
	 *
	 *	ИсклДБИ if an ODBC statement couldn't be destroyed.
	 */
	override РезультатОДБЦ запрос (ткст эскюэл) {
		scope (failure)
			if (!SQL_SUCCEEDED(SQLFreeHandle(SQL_HANDLE_STMT, инстр))) {
				throw new ИсклДБИ("Не удалось удалить инструкцию ODBC.  ODBC вернуло " ~ дайСообПоследнОш, дайКодПоследнОш);
			}
		scope (failure)
			if (!SQL_SUCCEEDED(SQLEndTran(SQL_HANDLE_DBC, подключение, SQL_ROLLBACK))) {
				throw new ИсклДБИ("Не удался откат после неудачного запроса.  ODBC вернуло " ~ дайСообПоследнОш, дайКодПоследнОш);
			}
		if (!SQL_SUCCEEDED(SQLAllocHandle(SQL_HANDLE_STMT, подключение, &инстр))) {
			throw new ИсклДБИ("Не удаётся создать инструкцию ODBC.  ODBC вернуло " ~ дайСообПоследнОш, дайКодПоследнОш);
		}
		if (SQL_SUCCEEDED(SQLExecDirect(инстр, cast(SQLCHAR*)эскюэл.ptr, эскюэл.length))) {
			return new РезультатОДБЦ(инстр);
		} else {
			throw new ИсклДБИ("Не удаётся запрос к базе данных.  ODBC вернуло " ~ дайСообПоследнОш, дайКодПоследнОш);
		}
	}

	/**
	 * Get the ошибка code.
	 *
	 * Deprecated:
	 *	This functionality now есть in ИсклДБИ.  This will be
	 *	removed in version 0.3.0.
	 *
	 * Returns:
	 *	The бд specific ошибка code.
	 */
	deprecated override цел дайКодОшибки () {
		return дайКодПоследнОш;
	}

	/**
	 * Get the ошибка message.
	 *
	 * Deprecated:
	 *	This functionality now есть in ИсклДБИ.  This will be
	 *	removed in version 0.3.0.
	 *
	 * Returns:
	 *	The бд specific ошибка message.
	 */
	deprecated override ткст дайСообОшибки () {
		return дайСообПоследнОш();
}

	/*
	 * Note: The following are not in the DBI API.
	 */

	/**
	 * Get a list of currently installed ODBC drivers.
	 *
	 * Returns:
	 *	A list of all the installed ODBC drivers.
	 */
	ткст[] дайДрайверы () {
		SQLCHAR[][] driverList;
		SQLCHAR[512] driver;
		SQLCHAR[512] attr;
		SQLSMALLINT driverLength;
		SQLSMALLINT attrLength;
		SQLUSMALLINT direction = SQL_FETCH_FIRST;
		SQLRETURN ret = SQL_SUCCESS;

		while (SQL_SUCCEEDED(ret = SQLDrivers(environment, direction, driver.ptr, driver.length, &driverLength, attr.ptr, attr.length, &attrLength))) {
			direction = SQL_FETCH_NEXT;
			driverList ~= driver[0 .. driverLength] ~ cast(SQLCHAR[])" ~ " ~ attr[0 .. attrLength];
			if (ret == SQL_SUCCESS_WITH_INFO) {
				throw new ИсклДБИ("В списке драйверов произошла обрезка данных.  ODBC вернуло " ~ дайСообПоследнОш, дайКодПоследнОш);
			}
		}
		return cast(ткст[])driverList;
	}

	/**
	 * Get a list of currently available ODBC data sources.
	 *
	 * Returns:
	 *	A list of all the installed ODBC data sources.
	 */
	ткст[] дайИсточникиДанных () {
		SQLCHAR[][] dataSourceList;
		SQLCHAR[512] dsn;
		SQLCHAR[512] desc;
		SQLSMALLINT dsnLength;
		SQLSMALLINT descLength;
		SQLUSMALLINT direction = SQL_FETCH_FIRST;
		SQLRETURN ret = SQL_SUCCESS;

		while (SQL_SUCCEEDED(ret = SQLDataSources(environment, direction, dsn.ptr, dsn.length, &dsnLength, desc.ptr, desc.length, &descLength))) {
			if (ret == SQL_SUCCESS_WITH_INFO) {
				throw new ИсклДБИ("Произошла обрезка данных в списке источников.  ODBC вернуло " ~ дайСообПоследнОш, дайКодПоследнОш);
			}
			direction = SQL_FETCH_NEXT;
			dataSourceList ~= dsn[0 .. dsnLength] ~ cast(SQLCHAR[])" ~ " ~ desc[0 .. descLength];
		}
		return cast(ткст[])dataSourceList;
	}

	private:
	SQLHDBC подключение;
	SQLHSTMT инстр;

	/**
	 * Get the last ошибка message returned by the server.
	 *
	 * Returns:
	 *	The last ошибка message returned by the server.
	 */
	ткст дайСообПоследнОш () {
		SQLSMALLINT errorNumber;
		SQLCHAR[5] state;
		SQLINTEGER nativeCode;
		SQLCHAR[512] text;
		SQLSMALLINT textLength;

		SQLGetDiagField(SQL_HANDLE_DBC, подключение, 0, SQL_DIAG_NUMBER, &errorNumber, 0, пусто);
		SQLGetDiagRec(SQL_HANDLE_DBC, подключение, errorNumber, state.ptr, &nativeCode, text.ptr, text.length, &textLength);
		return cast(ткст)state ~ " = " ~ cast(ткст)text;
	}

	/**
	 * Get the last ошибка code return by the server.  This is the native code.
	 *
	 * Returns:
	 *	The last ошибка message returned by the server.
	 */
	цел дайКодПоследнОш () {
		SQLSMALLINT errorNumber;
		SQLCHAR[5] state;
		SQLINTEGER nativeCode;
		SQLCHAR[512] text;
		SQLSMALLINT textLength;

		SQLGetDiagField(SQL_HANDLE_DBC, подключение, 0, SQL_DIAG_NUMBER, &errorNumber, 0, пусто);
		SQLGetDiagRec(SQL_HANDLE_DBC, подключение, errorNumber, state.ptr, &nativeCode, text.ptr, text.length, &textLength);
		return nativeCode;
	}
}

unittest {
	version(Rulada) {
		проц s1 (ткст s) {
			std.io.writefln("%s", s);
		}

		проц s2 (ткст s) {
			std.io.writefln("   ...%s", s);
		}
	} else {
		проц s1 (ткст s) {
			io.Stdout.Стдвыв(s).нс();
		}

		проц s2 (ткст s) {
			io.Stdout.Стдвыв("   ..." ~ s).нс();
		}
	}

	s1("dbi.odbc.OdbcDatabase:");
	ОдбцБД бд = new ОдбцБД();
	s2("подключись (with DSN)");
	бд.подключись("DDBI Unittest", "test", "test");

	s2("запрос");
	Результат рез = бд.запрос("SELECT * FROM test");
	assert (рез !is пусто);

	s2("получиРяд");
	Ряд ряд = рез.получиРяд();
	assert (ряд !is пусто);
	assert (ряд.дайИндексПоля("id") == 0);
	assert (ряд.дайИндексПоля("имя") == 1);
	assert (ряд.дайИндексПоля("dateofbirth") == 2);
	assert (ряд.дай("id") == "1");
	assert (ряд.дай("имя") == "John Doe");
	assert (ряд.дай("dateofbirth") == "1970-01-01");
	assert (ряд.дайТипПоля(0) == SQL_INTEGER);
	assert (ряд.дайТипПоля(1) == SQL_CHAR || ряд.дайТипПоля(1) == SQL_WCHAR);
	assert (ряд.дайТипПоля(2) == SQL_TYPE_DATE || ряд.дайТипПоля(2) == SQL_DATE);
	рез.финиш();

	s2("подготовь");
	Инструкция инстр = бд.подготовь("SELECT * FROM test WHERE id = ?");
	инстр.вяжи(1, "1");
	рез = инстр.запрос();
	ряд = рез.получиРяд();
	рез.финиш();
	assert (ряд[0] == "1");

	s2("fetchOne");
	ряд = бд.запросПолучиОдин("SELECT * FROM test");
	assert (ряд[0] == "1");

	s2("выполни(INSERT)");
	бд.выполни("INSERT INTO test VALUES (2, 'Jane Doe', '2000-12-31')");

	s2("выполни(DELETE via подготовь statement)");
	инстр = бд.подготовь("DELETE FROM test WHERE id=?");
	инстр.вяжи(1, "2");
	инстр.выполни();

	s2("закрой");
	бд.закрой();
	delete бд;
}
