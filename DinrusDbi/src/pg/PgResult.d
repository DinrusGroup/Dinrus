/**
 * Authors: The D DBI project
 *
 * Version: 0.2.5
 *
 * Copyright: BSD license
 */
module dbi.pg.PgResult;

version (Rulada) {
	private import stdrus : убери = strip, toDString = вТкст;
} else {
	private import stdrus : toDString = вТкст;
	private import text.Util : убери;
}
private import dbi.DBIException, dbi.Result, dbi.Row;
private import dbi.pg.imp, dbi.pg.PgError;

/**
 * Manage a результат установи from a PostgreSQL бд запрос.
 *
 * See_Also:
 *	Результат is the interface of which this provides an implementation.
 */
class PgРезультат : Результат {
	public:
	this (PGconn* conn, PGresult* результаты) {
		this.результаты = результаты;
		numРяды = PQntuples(результаты);
		numFields = PQnfields(результаты);
	}

	/**
	 * Get the следщ ряд from a результат установи.
	 *
	 * Returns:
	 *	A Ряд object with the queried information or пусто for an empty установи.
	 */
	override Ряд получиРяд () {
		if (индекс >= numРяды) {
			return пусто;
		}
		Ряд r = new Ряд();
		for (цел a = 0; a < numFields; a++) {
			r.добавьПоле(убери(toDString(PQfname(результаты, a))), убери(toDString(PQgetvalue(результаты, индекс, a))), "", PQftype(результаты, a));
		}
		индекс++;
		return r;
	}

	/**
	 * Free all бд resources used by a результат установи.
	 */
	override проц финиш () {
		if (результаты !is пусто) {
			PQclear(результаты);
			результаты = пусто;
		}
	}

	private:
	PGresult* результаты;
	цел индекс;
	const цел numРяды;
	const цел numFields;
}