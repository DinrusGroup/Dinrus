module dbi.test;
pragma(lib,"DinrusDbi.lib");

import dbi.connect, win, stdrus: пз;

проц main()
{
скажинс("Тест подключения");
ПодключениеКБазеДанных бд = new ПодключениеКБазеДанных(ПТипБД.Sqlite);
бд.подключи("test.db");
бд.выполни("CREATE TABLE test");
бд.выполни("INSERT INTO test VALUES (2, 'Jane Doe', '2000-12-31')");
скажинс("Подключено");
пз;
бд.закрой();
}