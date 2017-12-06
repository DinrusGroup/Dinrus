module test2;
import io.Stdout, dbi.odbc.OdbcDatabase,dbi.all, win32.sql, win32.sqlext, win32.sqlucode;

        проц s1 (ткст s)
        {
            io.Stdout.Стдвыв(s).нс();
        }

        проц s2 (ткст s)
        {
            io.Stdout.Стдвыв("   ..." ~ s).нс();
        }
    
void main()
{

    s1("dbi.odbc.OdbcDatabase:");
    ОдбцБД бд = new ОдбцБД();
    s2("подключись (с DSN)");
    бд.подключись("DDBI Unittest", "test", "test");

    s2("запрос");
    Результат рез = бд.запрос("SELECT * FROM test");
    assert (рез !is пусто);

    s2("получиРяд");
    Ряд ряд = рез.получиРяд();
    assert (ряд !is пусто);
    assert (ряд.дайИндексПоля("id") == 0);
    assert (ряд.дайИндексПоля("имя") == 1);
    assert (ряд.дайИндексПоля("dateofbirth") == 2);
    assert (ряд.дай("id") == "1");
    assert (ряд.дай("имя") == "John Doe");
    assert (ряд.дай("dateofbirth") == "1970-01-01");
    assert (ряд.дайТипПоля(0) == SQL_INTEGER);
    assert (ряд.дайТипПоля(1) == SQL_CHAR || ряд.дайТипПоля(1) == SQL_WCHAR);
    assert (ряд.дайТипПоля(2) == SQL_TYPE_DATE || ряд.дайТипПоля(2) == SQL_DATE);
    рез.финиш();

    s2("подготовь");
    Инструкция инстр = бд.подготовь("SELECT * FROM test WHERE id = ?");
    инстр.вяжи(1, "1");
    рез = инстр.запрос();
    ряд = рез.получиРяд();
    рез.финиш();
    assert (ряд[0] == "1");

    s2("fetchOne");
    ряд = бд.запросПолучиОдин("SELECT * FROM test");
    assert (ряд[0] == "1");

    s2("выполни(INSERT)");
    бд.выполни("INSERT INTO test VALUES (2, 'Jane Doe', '2000-12-31')");

    s2("выполни(DELETE via подготовь statement)");
    инстр = бд.подготовь("DELETE FROM test WHERE id=?");
    инстр.вяжи(1, "2");
    инстр.выполни();

    s2("закрой");
    бд.закрой();
    delete бд;
}