/**
 * Authors: The D DBI project
 * Copyright: BSD license
 */
module dbi.ErrorCode;

/**
 * The standardized D DBI ошибка code list.
 *
 * Note that the only things guaranteed not to change are ОшибкиНет and Неизвестен.
 */
enum КодОшибки {
	ОшибкиНет = 0,		// There is no ошибка right now.
	Неизвестен,		// Either DB-specific or not mapped to a standard ошибка code.

	// Errors in establishing a подключение.

	ОшибкаСокета,		/// There was a local ошибка initializing the подключение.
	ОшибкаПротокола,		/// Different versions of the подключение protocol are in use.
	ОшибкаПодключения,	/// Invalid имя_пользователя, пароль, or security установиtings.

	// Errors in making a запрос (general).

	ОбрывСинхронизации,		/// The statement was действителен, but couldn't be выполниd.
	НеправильныеДанные,		/// Invalid data was passed to or received from the server.
	НеправильныйЗапрос,		/// A запрос could not be successfully parsed.
	ОшибкаРазрешений,	/// You do not have appropriate permission to do that.

	// Errors in making a запрос (подготовьd statements).

	НеПодготовлен,		/// A statement wasn't подготовьd.
	ПарамыНеПривязаны,		/// A подготовьd statement had unbound parameters.
	НеверныеПараметры,		/// A подготовьd statement was given invalid parameters.

	// Miscellaneous

	НеРеализовано,		/// A возможность or function couldn't be used.
	ОшибкаСервера		/// An ошибка occurred on the server.
}

/**
 * Convert an КодОшибки to its текст form.
 *
 * Params:
 *	ошибка = The КодОшибки in enum format.
 *
 * Returns:
 *	The текст form of ошибка.
 */
ткст вТкст (КодОшибки ошибка) {
	switch (ошибка) {
		case (КодОшибки.ОшибкиНет):
			return "Ошибки Нет";
		case (КодОшибки.Неизвестен):
			return "Неизвестный Код";
		case (КодОшибки.ОшибкаСокета):
			return "Ошибка Сокета";
		case (КодОшибки.ОшибкаПротокола):
			return "Ошибка Несоответствия Протоколу";
		case (КодОшибки.ОшибкаПодключения):
			return "Ошибка Подключения";
		case (КодОшибки.ОбрывСинхронизации):
			return "Обрыв Синхронизации";
		case (КодОшибки.НеправильныеДанные):
			return "Неверные Данные";
		case (КодОшибки.НеправильныйЗапрос):
			return "Неправильный Запрос";
		case (КодОшибки.ОшибкаРазрешений):
			return "Ошибка Допусков";
		case (КодОшибки.НеПодготовлен):
			return "Не Подготовлено";
		case (КодОшибки.ПарамыНеПривязаны):
			return "Параметры Не Привязаны";
		case (КодОшибки.НеверныеПараметры):
			return "Неверные Параметры";
		case (КодОшибки.НеРеализовано):
			return "Не Реализовано";
		case (КодОшибки.ОшибкаСервера):
			return "Ошибка Сервера";
		default:
			return "Не является кодом ошибки";
	}
	// Return workaround
	return "Не является кодом ошибки";
}
