module tstjsn;

pragma(lib, "dinrus.lib");
import win, stdrus, json;

void джейсон() {

/+	скажиф("Тест модуля libDJSON на создание JSON...\n");
	auto корень = new ОбъектДжейСОН();
	auto мас = new МассивДжейСОН();
	мас ~= new ТкстДжейСОН("da blue teeths!\"\\");
	корень["what is that on your ear?"] = мас;
	корень["my pants"] = new ТкстДжейСОН("are on fire");
	корень["i am this many"] = new ЧислоДжейСОН(10.253);
	корень["blank"] = new ОбъектДжейСОН();
	ткст jstr1 = корень.вТкст;
	скажиф("Generated JSON ткст: " ~ jstr1 ~ "\n");
	скажиф("Regenerated JSON ткст: " ~ читайДжейСОН(jstr1).вТкст ~ "\n");
	скажиф("Output using вФТкст:\n"~корень.вФТкст~"\nEnd pretty output\n");
	assert(jstr1 == читайДжейСОН(jstr1).вТкст);+/
	скажиф("Тест модуля libDJSON на парсинг JSON...\n");
	ткст jstr = "{\"имя\": \"Джон\",\"фамилия\": \"Смит\",\"адрес\": {\"адресУлицы\": \"21 2-я Улица\",\"город\": \"Нью-Йорк\",\"штат\": \"НЙ\",\"почтовыйКод\": 10021},\"телефонныеНомера\": [{ \"тип\": \"дом\", \"номер\": \"212 555-1234\" },{ \"тип\": \"факс\", \"номер\": \"646 555-4567\" }],\"новаяПодписка\": false,\"названиеКомпании\": null }";
	скажиф("Образцовый JSON ткст: " ~ jstr ~ "\n");
	jstr = jstr.читайДжейСОН().вТкст;
	скажиф("Разобранный JSON ткст: " ~ jstr ~ "\n");
	скажиф("Вывод с использованием вФТкст:\n"~jstr.читайДжейСОН().вФТкст~"\nКонец форматированного вывода\n");
	// ensure that the ткст doesn't mutate after a second reading, it shouldn't
	assert(jstr.читайДжейСОН().вТкст == jstr);
	// ensure that pretty output still parses properly and doesn't mutate
	jstr = jstr.читайДжейСОН().вФТкст;
	assert(jstr.читайДжейСОН().вФТкст == jstr);
	скажиф("Тест модуля libDJSON на доступ к JSON...\n");
	скажиф("Получено имя:" ~ jstr.читайДжейСОН()["имя"].вТкстДжейСОН.дай ~ "\n");
	скажиф("Получена фамилия:" ~ jstr.читайДжейСОН()["фамилия"].вТкстДжейСОН.дай ~ "\n");
	скажиф("Unit Test libDJSON opApply interface...\n");
	foreach(obj;jstr.читайДжейСОН()["телефонныеНомера"]) {
		скажиф("Получен " ~ obj["тип"].вТкстДжейСОН.дай ~ " номер телефона:" ~ obj["номер"].вТкстДжейСОН.дай ~ "\n");
	}
	скажиф("Unit Test libDJSON opIndex interface to ensure breakage where incorrectly used...\n");
	try {
		jstr.читайДжейСОН()[5];
		assert(false,"An exception should have been thrown on the line above.");
	} catch (ОшибкаДжейСОН e) {/*shazam! program flow should дай here, it is a correct thing*/}
}

void main()
{
джейсон();
	_нс;_нс;_пауза;
}