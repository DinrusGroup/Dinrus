module dbi.test;
pragma(lib,"DinrusDbi.lib");

import dbi.connect, win;

проц main()
{
скажинс("Тест подключения");
ПодключениеКБазеДанных бд = new ПодключениеКБазеДанных(ПТипБД.Sqlite);
бд.подключи("test.db");
скажинс("Подключено");
пз;
}