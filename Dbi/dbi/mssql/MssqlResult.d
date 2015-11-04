/**
 * Authors: The D DBI project
 *
 * Version: 0.2.5
 *
 * Copyright: BSD license
 */
module dbi.mssql.MssqlResult;

version(Rulada) {
	private import stdrus : toDString = вТкст, toCString = вТкст0, locate = найди;
} else {
	private import stdrus : toDString = вТкст, toCString = вТкст0;
	private import text.Util : locate;
	private static import text.convert.Float, text.convert.Integer;
}
import dbi.DBIException, dbi.Result, dbi.Row;
import dbi.mssql.imp, dbi.mssql.MssqlDate;

/**
 * Manage a результат установи from a MSSQL бд запрос.
 *
 * See_Also:
 *	Результат is the interface of which this provides an implementation.
 */
class MssqlResult : Результат {
	public:
	this (CS_COMMAND* cmd) {
		this.cmd = cmd;
	}

	/**
	 * Get the следщ ряд from a результат установи.
	 *
	 * Returns:
	 *	A Ряд object with the queried information or пусто for an empty установи.
	 */
	override Ряд получиРяд () {
		while (ct_results(cmd, &restype) == CS_SUCCEED) {
			switch (restype) {
				case CS_CMD_SUCCEED:
					break;
				case CS_CMD_DONE:
					break;
				case CS_CMD_FAIL:
					// TODO: MssqlError or some such
					throw new ИсклДБИ("Failed to дай Результатs");
				case CS_ROW_RESULT:
					// установи numFields if needed
					if (numFields < 0) {
						установиЧлоПолей();
						установиПоля();
					}
					// create new Ряд object, populate it, and return it
					Ряд r = new Ряд();
					цел счёт;

					while (ct_fetch(cmd, CS_UNUSED, CS_UNUSED, CS_UNUSED, &счёт) == CS_SUCCEED) {
						numРяды += счёт;

						ткст значение;
						ткст fieldимя;

						for (цел i = 0; i < numFields; ++i) {
							fieldимя = поля[i].имя[0 .. locate(поля[i].имя, '\0')];
							switch (поля[i].datatype) {
								case CS_CHAR_TYPE:
									значение = strings[i][0 .. lengths[i]];
									break;
								case CS_FLOAT_TYPE:
									version(Rulada) {
										значение = toDString(floats[i]);
									} else {
										значение = text.convert.Float.вТкст(floats[i]);
									}
									break;
								case CS_DATETIME_TYPE:
									MssqlDate date = new MssqlDate(dts[i]);
									значение = date.getString();
									break;
								case CS_DATETIME4_TYPE:
									MssqlDate date = new MssqlDate(dt4s[i]);
									значение = date.getString();
									break;
								case CS_MONEY_TYPE:
									/* fall through */
								case CS_MONEY4_TYPE:
									version(Rulada) {
										значение = toDString(cast(плав)ints[i] / 10000);
									} else {
										значение = text.convert.Float.вТкст(cast(плав)ints[i] / 10000);
									}
									break;
								default:
									version(Rulada) {
										значение = toDString(ints[i]);
									} else {
										значение = text.convert.Integer.вТкст(ints[i]);
									}
									break;
							}

							version(Rulada) {
								r.добавьПоле(fieldимя, значение, toDString(поля[i].datatype), поля[i].datatype);
							} else {
								r.добавьПоле(fieldимя, значение, text.convert.Integer.вТкст(поля[i].datatype), поля[i].datatype);
							}
						}
						// we only want to return one ряд, so exit both while loops
						return r;
					}
					default:
						break;
				}
			}
			return пусто;
		}

	/**
	 * Free all бд resources used by a результат установи.
	 */
	override проц финиш () {
		/* TODO: */
	}

	private:
	CS_COMMAND* cmd;
	CS_RETCODE restype;

	цел numРяды = -1;
	цел numFields = -1;

	CS_DATAFMT[] поля;
	ткст[] strings;
	CS_FLOAT[] floats;
	CS_INT[] ints;
	CS_DATETIME[] dts;
	CS_DATETIME4[] dt4s;
	цел[] lengths;
	крат[] inds;

	проц установиЧлоПолей() {
		// дай field счёт
		цел _numFields;
		ct_res_info(cmd, CS_NUMDATA, &_numFields, CS_UNUSED, пусто);
		this.numFields =_numFields;

		// we can also установи the length of the поля, strings, lengths, inds arrays
		поля.length = lengths.length = inds.length= strings.length = floats.length = ints.length = dts.length = dt4s.length = numFields;
	}

	проц установиПоля() {
		цел i;

		// for each field, установи the field info in поля array, and вяжи field
		// to other arrays
		for (i = 0; i < numFields; ++i) {
			ct_describe(cmd, (i + 1), &поля[i]);

			switch (поля[i].datatype) {
				case CS_CHAR_TYPE:
					if (strings[i].length != поля[i].maxlength) {
						strings[i].length = поля[i].maxlength;
					}
					ct_подвяз(cmd, (i + 1), &поля[i], strings[i].ptr, &lengths[i], &inds[i]);
					break;
				case CS_FLOAT_TYPE:
					ct_подвяз(cmd, (i + 1), &поля[i], &floats[i], &lengths[i], &inds[i]);
					break;
				case CS_DATETIME_TYPE:
					ct_подвяз(cmd, (i + 1), &поля[i], &dts[i], &lengths[i], &inds[i]);
					break;
				case CS_DATETIME4_TYPE:
					ct_подвяз(cmd, (i + 1), &поля[i], &dt4s[i], &lengths[i], &inds[i]);
					break;
				default:
					ct_подвяз(cmd, (i + 1), &поля[i], &ints[i], &lengths[i], &inds[i]);
					break;
			}
		}
	}
}