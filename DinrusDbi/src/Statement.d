module dbi.Statement;
private import stdrus, text.Util;
private import dbi.DataBase, dbi.DBIException, dbi.Result;

/**
 * Подготавливает инструкцию на SQL.
 *
 * Bugs:
 *	The statement is stored but not подготовьd.
 *
 *	The индекс version of вяжи ignores its first parameter.
 *
 *	The two forms of вяжи cannot be used at the same время.
 *
 * Todo:
 *	make выполни/запрос("10", "20", 30); work (variable arguments for подвязing to ?, ?, ?, etc...)
 */
final class Инструкция {
	/**
	 * Make a new instance of Инструкция.
	 *
	 * Params:
	 *	бд = The бд подключение to use.
	 *	эскюэл = The SQL code to подготовь.
	 */
	this (БазаДанных бд, ткст эскюэл) {
		this.бд = бд;
		this.эскюэл = эскюэл;
	}

	/**
	 * Bind a _value to the следщ "?".
	 *
	 * Params:
	 *	индекс = Currently ignored.  This is a bug.
	 *	значение = The _value to _подвяз.
	 */
	проц вяжи (т_мера индекс, ткст значение) {
		подвязки ~= искейп(значение);
	}

	/**
	 * Bind a _value to a ":имя:".
	 *
	 * Params:
	 *	fn = The имя to _подвяз значение to.
	 *	значение = The _value to _подвяз.
	 */
	проц вяжи (ткст fn, ткст значение) {
		подвязкиПНн ~= fn;
		подвязки ~= искейп(значение);
	}

	/**
	 * Execute a SQL statement that returns no результаты.
	 */
	проц выполни () {
		бд.выполни(дайЭсКюЭл());
	}

	/**
	 * Query the бд.
	 *
	 * Returns:
	 *	A Результат object with the queried information.
	 */
	Результат запрос () {
		return бд.запрос(дайЭсКюЭл());
	}

	private:
	БазаДанных бд;
	ткст эскюэл;
	ткст[] подвязки;
	ткст[] подвязкиПНн;

	/**
	 * Escape a SQL statement.
	 *
	 * Params:
	 *	текст = An unescaped SQL statement.
	 *
	 * Returns:
	 *	The escaped form of текст.
	 */
	ткст искейп (ткст текст) {
		if (бд !is пусто) {
			return бд.искейп(текст);
		} else {
			ткст результат;
			т_мера счёт = 0;

			// Maximum length needed if every char is to be quoted
			результат.length = текст.length * 2;

			for (т_мера i = 0; i < текст.length; i++) {
				switch (текст[i]) {
					case '"':
					case '\'':
					case '\\':
						результат[счёт++] = '\\';
						break;
					default:
						break;
				}
				результат[счёт++] = текст[i];
			}

			результат.length = счёт;
			return результат;
		}
	}

	/**
	 * Replace every "?" in the current SQL statement with its bound значение.
	 *
	 * Returns:
	 *	The current SQL statement with all occurences of "?" replaced.
	 *
	 * Todo:
	 *	Raise an exception if подвязки.length != счёт(эскюэл, "?")
	 */
	ткст дайЭсКюЭлпоКМ () {
		ткст результат;
		т_мера i = 0, j = 0, счёт = 0;

		// подвязки.length is for the '', only 1 because we replace the ? too
		результат.length = эскюэл.length + подвязки.length;
		for (i = 0; i < подвязки.length; i++) {
			результат.length = результат.length + подвязки[i].length;
		}

		for (i = 0; i < эскюэл.length; i++) {
			if (эскюэл[i] == '?') {
				результат[j++] = '\'';
				результат[j .. j + подвязки[счёт].length] = подвязки[счёт];
				j += подвязки[счёт++].length;
				результат[j++] = '\'';
			}
			else {
				результат[j++] = эскюэл[i];
			}
		}

		эскюэл = результат;
		return результат;
	}

	/**
	 * Replace every ":имя:" in the current SQL statement with its bound значение.
	 *
	 * Returns:
	 *	The current SQL statement with all occurences of ":имя:" replaced.
	 *
	 * Todo:
	 *	Raise an exception if подвязки.length != (счёт(эскюэл, ":") * 2)
	 */
	ткст дайЭсКюЭлпоПН () {
		ткст результат = эскюэл;
		version(Rulada) {
			ptrdiff_t beginIndex = 0, endIndex = 0;
			while ((beginIndex = stdrus.find(результат, ":")) != -1 && (endIndex = stdrus.find(результат[beginIndex + 1 .. length], ":")) != -1) {
				результат = результат[0 .. beginIndex] ~ "'" ~ дайСвязанноеЗначение(результат[beginIndex + 1.. beginIndex + endIndex + 1]) ~ "'" ~ результат[beginIndex + endIndex + 2 .. length];
			}
		} else {
			бцел beginIndex = 0, endIndex = 0;
			while ((beginIndex = text.Util.местоположение(результат, ':')) != результат.length && (endIndex = text.Util.местоположение(результат, ':', beginIndex + 1)) != результат.length) {
				результат = результат[0 .. beginIndex] ~ "'" ~ дайСвязанноеЗначение(результат[beginIndex + 1 .. endIndex]) ~ "'" ~ результат[endIndex + 1 .. length];
			}
		}
		return результат;
	}

	/**
	 * Replace all variables with their bound значения.
	 *
	 * Returns:
	 *	The current SQL statement with all occurences of variables replaced.
	 */
	ткст дайЭсКюЭл () {
		version(Rulada) {
			if (stdrus.find(эскюэл, "?") != -1) {
				return дайЭсКюЭлпоКМ();
			} else if (stdrus.find(эскюэл, ":") != -1) {
				return дайЭсКюЭлпоПН();
			} else {
				return эскюэл;
			}
		} else {
			if (text.Util.содержит(эскюэл, '?')) {
				return дайЭсКюЭлпоКМ();
			} else if (text.Util.содержит(эскюэл, ':')) {
				return дайЭсКюЭлпоПН();
			} else {
				return эскюэл;
			}
		}
	}

	/**
	 * Get the значение bound to a ":имя:".
	 *
	 * Params:
	 *	fn = The ":имя:" to return the bound значение of.
	 *
	 * Returns:
	 *	The bound значение of fn.
	 *
	 * Thряды:
	 *	ИсклДБИ if fn is not bound
	 */
	ткст дайСвязанноеЗначение (ткст fn) {
		for (т_мера индекс = 0; индекс < подвязкиПНн.length; индекс++) {
			if (подвязкиПНн[индекс] == fn) {
				return подвязки[индекс];
			}
		}
		throw new ИсклДБИ(fn ~ " не привязано к Инструкции.");
	}
}

debug(Stat)
{
import stdrus;

			проц s1 (ткст s) {
				скажифнс("%s", s);
			}

			проц s2 (ткст s) {
				скажифнс("   ...%s", s);
			}
	void main() 
	{
		
		s1("dbi.Statement:");
		Инструкция инстр = new Инструкция(пусто, "SELECT * FROM люди");
		ткст резЭсКюЭл = "SELECT * FROM люди WHERE id = '10' OR имя LIKE 'John Mc\\'Donald'";

		s2("искейп");
		assert (инстр.искейп("John Mc'Donald") == "John Mc\\'Donald");

		s2("простой эскюэл");
		инстр = new Инструкция(пусто, "SELECT * FROM люди");
		assert (инстр.дайЭсКюЭл() == "SELECT * FROM люди");

		s2("вяжим по '?'");
		инстр = new Инструкция(пусто, "SELECT * FROM люди WHERE id = ? OR имя LIKE ?");
		инстр.вяжи(1, "10");
		инстр.вяжи(2, "John Mc'Donald");
		assert (инстр.дайЭсКюЭл() == резЭсКюЭл);

		/+
		s2("вяжи by '?' sent to дайЭсКюЭл via variable arguments");
		инстр = new Инструкция("SELECT * FROM люди WHERE id = ? OR имя LIKE ?");
		assert (инстр.дайЭсКюЭл("10", "John Mc'Donald") == резЭсКюЭл);
		+/

		s2("вяжим по ':имя_поля:'");
		инстр = new Инструкция(пусто, "SELECT * FROM люди WHERE id = :id: OR имя LIKE :имя:");
		инстр.вяжи("id", "10");
		инстр.вяжи("имя", "John Mc'Donald");
		assert (инстр.дайСвязанноеЗначение("имя") == "John Mc\\'Donald");
		assert (инстр.дайЭсКюЭл() == резЭсКюЭл);
	}
}