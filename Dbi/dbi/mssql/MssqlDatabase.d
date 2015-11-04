/**
 * Authors: The D DBI project
 *
 * Version: 0.2.5
 *
 * Copyright: BSD license
 */
module dbi.mssql.MssqlDatabase;

version (Rulada) {
	private import stdrus : toDString = вТкст, toCString = вТкст0;
	debug (UnitTest) private static import std.io;
} else {
	private import stdrus : toDString = вТкст, toCString = вТкст0;
	debug (UnitTest) private static import io.Stdout;
}
private import dbi.DataBase, dbi.DBIException, dbi.Result, dbi.Row, dbi.Statement;
private import dbi.mssql.imp, dbi.mssql.MssqlResult;

/**
 * An implementation of БазаДанных for use with MSSQL databases.
 *
 * See_Also:
 *	БазаДанных is the interface that this provides an implementation of.
 */
class MssqlDatabase : БазаДанных {
	public:
	/**
	 * Create a new instance of БазаДанных, but don't подключись.
	 */
	this () {
	}

	/**
	 * Create a new instance of БазаДанных and подключись to a server.
	 *
	 * See_Also:
	 *	подключись
	 */
	this (ткст парамы, ткст имя_пользователя = пусто, ткст пароль = пусто) {
		this();
		подключись(парамы, имя_пользователя, пароль);
	}

	/**
	 * Connect to a бд on a MSSQL server.
	 *
	 * Params:
	 *	парамы = A текст in the form "server порт"
	 *
	 * Todo: is it supposed to be "keyword1=value1;keyword2=value2;etc."
	 *           and be consistent with other DBI's ??
	 *
	 *	имя_пользователя = The _userимя to _подключись with.
	 *	пароль = The _password to _подключись with.
	 *
	 * Thряды:
	 *	ИсклДБИ if there was an ошибка подключисьing.
	 *
	 * Examples:
	 *	---
	 *	MssqlDatabase бд = new MssqlDatabase();
	 *	бд.подключись("host порт", "имя_пользователя", "пароль");
	 *	---
	 */
	override проц подключись (ткст парамы, ткст имя_пользователя = пусто, ткст пароль = пусто) {
		CS_RETCODE ret;
		if (парамы is пусто) {
			парамы = "";
		}

		// allocate context
		ret = cs_ctx_размест(CS_VERSION_100, &ctx);
		if (ret != CS_SUCCEED) {
			throw new ИсклДБИ("Cannot allocate context");
		}

		// init context
		ret = ct_init(ctx, CS_VERSION_100);
		if (ret != CS_SUCCEED) {
			throw new ИсклДБИ("Cannot init context");
		}

		// allocate подключение
		ret = ct_con_размест(ctx, &con);
		if (ret != CS_SUCCEED) {
			throw new ИсклДБИ("Cannot allocate подключение");
		}

		// propустанови имя_пользователя
		ret = ct_con_props(con, CS_SET, CS_USERNAME, toCString(имя_пользователя), CS_NULLTERM, пусто);
		if (ret != CS_SUCCEED) {
			throw new ИсклДБИ("Cannot установи 'имя_пользователя' подключение property");
		}

		// propустанови пароль
		ret = ct_con_props(con, CS_SET, CS_PASSWORD, toCString(пароль), CS_NULLTERM, пусто);
		if (ret != CS_SUCCEED) {
			throw new ИсклДБИ("Cannot установи 'пароль' подключение property");
		}

		// propустанови serveraddr (host, порт)
		ret = ct_con_props(con, CS_SET, CS_SERVERADDR, toCString(парамы), CS_NULLTERM, пусто);
		if (ret != CS_SUCCEED) {
			throw new ИсклДБИ("Cannot установи 'serveraddr' подключение properties");
		}

		// подключись
		ret = ct_подключись(con, пусто, CS_NULLTERM);
		if (ret != CS_SUCCEED) {
			throw new ИсклДБИ("Cannot подключись to бд");
		}
	}

	/**
	 * Close the current подключение to the бд.
	 */
	override проц закрой () {
		if (con !is пусто) {
			if (ct_закрой(con, CS_UNUSED) != CS_SUCCEED) {
				throw new ИсклДБИ("Cannot закрой подключение to бд");
			} else {
				con = пусто;
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
	 *	ИсклДБИ if the SQL code couldn't be выполниd.
	 */
	override проц выполни (ткст эскюэл) {
		if (ct_cmd_размест(con, &cmd) != CS_SUCCEED) {
			throw new ИсклДБИ("Cannot allocate command");
		}

		if (ct_command(cmd, CS_LANG_CMD, toCString(эскюэл), CS_NULLTERM, CS_UNUSED) != CS_SUCCEED) {
			throw new ИсклДБИ("Command failed", эскюэл);
		}

		if (ct_send(cmd) != CS_SUCCEED) {
			throw new ИсклДБИ("Sending of command failed");
		}

		CS_RETCODE ret, restype;
		do {
			ret = ct_results(cmd, &restype);

			switch (restype) {
				case CS_CMD_SUCCEED:
					break;
				case CS_CMD_DONE:
					break;
				case CS_CMD_FAIL:
					throw new ИсклДБИ("Failed to выполни command");
				default:
					break;
			}
		} while (ret == CS_SUCCEED)

		switch (ret) {
			case CS_END_RESULTS:
				break;
			case CS_FAIL:
				throw new ИсклДБИ("ct_results() failed");
			default:
				throw new ИсклДБИ("ct_results() unexpected return");
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
	 *	ИсклДБИ if the SQL code couldn't be выполниd.
	 */
	override MssqlResult запрос (ткст эскюэл) {
		if (ct_cmd_размест(con, &cmd) != CS_SUCCEED) {
			throw new ИсклДБИ("Cannot allocate command");
		}

		if (ct_command(cmd, CS_LANG_CMD, toCString(эскюэл), CS_NULLTERM, CS_UNUSED) != CS_SUCCEED) {
			throw new ИсклДБИ("Command failed", эскюэл);
		}

		if (ct_send(cmd) != CS_SUCCEED) {
			throw new ИсклДБИ("Sending of command failed");
		}

		return new MssqlResult(cmd);
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
		// TODO: implement?  or let deprectate take care of it?
		return 0;
		// return m_errorCode;
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
		// TODO: implement? or let depreacate take care of it?
		return "not implemented";
		// return m_errorString;
	}

	private:
	CS_CONTEXT* ctx;
	CS_CONNECTION* con;
	CS_COMMAND* cmd;

}

unittest {
	version (Phobos) {
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

	s1("dbi.mssql.MssqlDatabase:");
	MssqlDatabase бд = new MssqlDatabase();
	s2("подключись");
	бд.подключись("sqlvs1 1433", "test", "test");

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
	/** TODO: test some тип retrieval functions */
	//assert (ряд.дайТипПоля(1) == FIELD_TYPE_STRING);
	//assert (ряд.дайОбъявлПоля(1) == "char(40)");
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
}