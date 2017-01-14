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
class ЭмЭсЭсКюЭлБД : БазаДанных {
	public:
	/**
	 * Create a new instance of БазаДанных, but don't подключись.
	 */
	 
	this () ;

	/**
	 * Create a new instance of БазаДанных and подключись to a server.
	 *
	 * See_Also:
	 *	подключись
	 */
	 
	this (ткст парамы, ткст имя_пользователя = пусто, ткст пароль = пусто);

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
	 *	ЭмЭсЭсКюЭлБД бд = new ЭмЭсЭсКюЭлБД();
	 *	бд.подключись("host порт", "имя_пользователя", "пароль");
	 *	---
	 */
	 
	override проц подключись (ткст парамы, ткст имя_пользователя = пусто, ткст пароль = пусто) ;
	
	/**
	 * Close the current подключение to the бд.
	 */
	 
	override проц закрой () ;

	/**
	 * Execute a SQL statement that returns no результаты.
	 *
	 * Params:
	 *	эскюэл = The SQL statement to _выполни.
	 *
	 * Thряды:
	 *	ИсклДБИ if the SQL code couldn't be выполниd.
	 */
	 
	override проц выполни (ткст эскюэл);
	
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
	 
	override MssqlResult запрос (ткст эскюэл) ;
	
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
	deprecated override цел дайКодОшибки () ;

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
	deprecated override ткст дайСообОшибки () ;


}
