/**
 * Authors: The D DBI project
 *
 * Version: 0.2.5
 *
 * Copyright: BSD license
 */
module dbi.DBIException;

private import dinrus: ва_арг;
private import dbi.ErrorCode;

/**
 * This is the exception class used within all of D DBI.
 *
 * Some functions may also throw different types of exceptions when they access the
 * standard library, so be sure to also catch Exception in your code.
 */
class ИсклДБИ : Искл {
	
		/**
	 * Create a new ИсклДБИ.
	 *
	 * Params:
	 *	сооб = The message to report to the users.
	 *
	 * Thряды:
	 *	ИсклДБИ on invalid arguments.
	 */
	this (ткст сооб, дол номОш = 0, КодОшибки кодОш = КодОшибки.ОшибкиНет, ткст эскюэл = пусто) {
		super("ИсклДБИ: " ~ сооб);
		кодДби = кодОш;
		this.эскюэл = эскюэл;
		this.спецКод = номОш;
	}

	/**
	 * Create a new ИсклДБИ.
	 *
	 * Params:
	 *	сооб = The message to report to the users.
	 *
	 * Thряды:
	 *	ИсклДБИ on invalid arguments.
	 */
	 
	 
	this (ткст сооб, ...) {
		super("ИсключениеДБИ: " ~ сооб);
		for (т_мера i = 0; i < _arguments.length; i++) {
			if (_arguments[i] == typeid(ткст)) {
				эскюэл = ва_арг!(ткст)(_argptr);
			} else if (_arguments[i] == typeid(байт)) {
				спецКод = ва_арг!(байт)(_argptr);
			} else if (_arguments[i] == typeid(ббайт)) {
				спецКод = ва_арг!(ббайт)(_argptr);
			} else if (_arguments[i] == typeid(крат)) {
				спецКод = ва_арг!(крат)(_argptr);
			} else if (_arguments[i] == typeid(бкрат)) {
				спецКод = ва_арг!(бкрат)(_argptr);
			} else if (_arguments[i] == typeid(цел)) {
				спецКод = ва_арг!(цел)(_argptr);
			} else if (_arguments[i] == typeid(бцел)) {
				спецКод = ва_арг!(бцел)(_argptr);
			} else if (_arguments[i] == typeid(дол)) {
				спецКод = ва_арг!(дол)(_argptr);
			} else if (_arguments[i] == typeid(бдол)) {
				спецКод = cast(дол)ва_арг!(бдол)(_argptr);
			} else if (_arguments[i] == typeid(КодОшибки)) {
				кодДби = ва_арг!(КодОшибки)(_argptr);
			} else {
					throw new Искл("Конструктору ИсклДБИ передан неверный аргумент типа \"" ~ _arguments[i].вТкст() ~ "\".");
			}
		}
	}
	
		/**
	 * Create a new ИсклДБИ.
	 */
	this () {
		super("Неизвестная Ошибка.");
	}

	/**
	 * Get the бд's DBI ошибка code.
	 *
	 * Returns:
	 *	БазаДанных's DBI ошибка code.
	 */
	КодОшибки дайКодОшибки () {
		return кодДби;
	}

	/**
	 * Get the бд's numeric ошибка code.
	 *
	 * Returns:
	 *	БазаДанных's numeric ошибка code.
	 */
	дол дайСпецКод () {
		return спецКод;
	}

	/**
	 * Get the SQL statement that caused the ошибка.
	 *
	 * Returns:
	 *	SQL statement that caused the ошибка.
	 */
	ткст дайЭсКюЭл () {
		return эскюэл;
	}

	private:
	ткст эскюэл;
	дол спецКод = 0;
	КодОшибки кодДби = КодОшибки.Неизвестен;
}