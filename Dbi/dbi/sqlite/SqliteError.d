/**
 * Authors: The D DBI project
 *
 * Version: 0.2.5
 *
 * Copyright: BSD license
 */
module dbi.sqlite.SqliteError;

private import dbi.ErrorCode;
private import dbi.sqlite.imp;

/**
 * Convert a SQLite _error code to an КодОшибки.
 *
 * Params:
 *	ошибка = The SQLite _error code.
 *
 * Returns:
 *	The КодОшибки representing ошибка.
 *
 * Note:
 *	Written against the SQLite 3.3.6 documentation.
 */
package КодОшибки спецВОбщ (цел ошибка) {
	switch (ошибка) {
		case (SQLITE_OK):
			return КодОшибки.ОшибкиНет;
		case (SQLITE_ERROR):
			return КодОшибки.НеправильныйЗапрос;
		case (SQLITE_INTERNAL):
			return КодОшибки.ОшибкаСервера;
		case (SQLITE_PERM):
			return КодОшибки.ОшибкаРазрешений;
		case (SQLITE_ABORT):
			return КодОшибки.Неизвестен;
		case (SQLITE_BUSY):
			return КодОшибки.ОшибкаСервера;
		case (SQLITE_LOCKED):
			return КодОшибки.ОшибкаСервера;
		case (SQLITE_NOMEM):
			return КодОшибки.ОшибкаСервера;
		case (SQLITE_READONLY):
			return КодОшибки.НеправильныйЗапрос;
		case (SQLITE_INTERRUPT):
			return КодОшибки.Неизвестен;
		case (SQLITE_IOERR):
			return КодОшибки.НеправильныеДанные;
		case (SQLITE_CORRUPT):
			return КодОшибки.НеправильныеДанные;
		case (SQLITE_NOTFOUND):
			return КодОшибки.НеправильныйЗапрос;
		case (SQLITE_FULL):
			return КодОшибки.ОшибкаСервера;
		case (SQLITE_CANTOPEN):
			return КодОшибки.ОшибкаСервера;
		case (SQLITE_PROTOCOL):
			return КодОшибки.ОшибкаПротокола;
		case (SQLITE_EMPTY):
			return КодОшибки.НеправильныеДанные;
		case (SQLITE_SCHEMA):
			return КодОшибки.НеправильныеДанные;
		case (SQLITE_TOOBIG):
			return КодОшибки.НеправильныеДанные;
		case (SQLITE_CONSTRAINT):
			return КодОшибки.НеправильныйЗапрос;
		case (SQLITE_MISMATCH):
			return КодОшибки.НеправильныеДанные;
		case (SQLITE_MISUSE):
			return КодОшибки.НеправильныйЗапрос;
		case (SQLITE_NOLFS):
			return КодОшибки.ОшибкаСервера;
		case (SQLITE_AUTH):
			return КодОшибки.ОшибкаРазрешений;
		case (SQLITE_ROW):
			return КодОшибки.ОшибкиНет;
		case (SQLITE_DONE):
			return КодОшибки.ОшибкиНет;
		default:
			return КодОшибки.Неизвестен;
	}
	// Bugfix for DMD 0.162
	return КодОшибки.Неизвестен;
}