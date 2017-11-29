module dbi.connect;
//Предполагается последующее создание общего модуля Dinrus.DBI.dll
import dbi.sqlite.all;
import dbi.odbc.all;
import dbi.msql.all;
//import dbi.mssql.all;
import dbi.mysql.all;
import dbi.pg.all;

enum ПТипБД
{
Sqlite,
ODBC,
MySQL,
Pg,
MSQL,
//MSSQL
}

class ПодключениеКБазеДанных
{
private:
БДЭскюлайт лайт;
ПгБД пг;
ОдбцБД одбц;
МайЭсКюЭлБД май;
//ЭмЭсЭсКюЭлБД мс;
ЭмЭсКюЭлБД м;
ПТипБД типБд;

public:

	this (ПТипБД тип)
	{

	switch(тип)
		{
			case ПТипБД.Sqlite:
			this.лайт = new БДЭскюлайт();
			this.типБд = ПТипБД.Sqlite;
			//Здесь реально должно появляться окно запроса параметров подключения
			//и вторым шагом - проводиться подключение!))
			break;

			case ПТипБД.ODBC:
			this.одбц = new ОдбцБД();
			this.типБд = ПТипБД.ODBC;
			//То же (Нереализовано)
			break;

			case ПТипБД.MySQL:
			this.май = new МайЭсКюЭлБД();
			this.типБд = ПТипБД.MySQL;
			//То же (Нереализовано)
			break;

			case ПТипБД.Pg:
			this.пг = new ПгБД();
			this.типБд = ПТипБД.Pg;
			//То же (Нереализовано)
			break;

			case ПТипБД.MSQL:
			this.м = new ЭмЭсКюЭлБД();
			this.типБд = ПТипБД.MSQL;
			//То же (Нереализовано)
			break;
			/*
			case ПТипБД.MSSQL:
			this.мс =new ЭмЭсЭсКюЭлБД();
			this.типБд = ПТипБД.MSSQL;
			//То же (Нереализовано)
			break;
			*/
			default:
		}

	}

	проц подключи(ткст параметры, ткст имя_пользователя = пусто, ткст пароль = пусто)
	{
	switch(this.типБд)
		{
			case ПТипБД.Sqlite:
			this.лайт.подключись(параметры, имя_пользователя, пароль);
			break;

			case ПТипБД.ODBC:
			this.одбц.подключись(параметры, имя_пользователя, пароль);
			break;

			case ПТипБД.MySQL:
			this.май.подключись (параметры, имя_пользователя, пароль, пусто, пусто);
			break;

			case ПТипБД.Pg:
			this.пг.подключись(параметры, имя_пользователя, пароль);
			break;

			case ПТипБД.MSQL:
			this.м.подключись(параметры, имя_пользователя, пароль);
			break;
			/*
			case ПТипБД.MSSQL:
			this.мс.подключись(параметры, имя_пользователя, пароль);
			break;
			*/
			default:
		}


	}

	проц выполни(ткст эскюэл)
	{
	switch(this.типБд)
		{
			case ПТипБД.Sqlite:
			this.лайт.выполни(эскюэл);
			break;

			case ПТипБД.ODBC:
			this.одбц.выполни(эскюэл);
			break;

			case ПТипБД.MySQL:
			this.май.выполни (эскюэл);
			break;

			case ПТипБД.Pg:
			this.пг.выполни(эскюэл);
			break;

			case ПТипБД.MSQL:
			this.м.выполни(эскюэл);
			break;
			/*
			case ПТипБД.MSSQL:
			this.мс.подключись(параметры, имя_пользователя, пароль);
			break;
			*/
			default:
		}


	проц закрой()
	{
	switch(this.типБд)
		{
			case ПТипБД.Sqlite:
			this.лайт.закрой();
			break;

			case ПТипБД.ODBC:
			this.одбц.закрой();
			break;

			case ПТипБД.MySQL:
			this.май.закрой ();
			break;

			case ПТипБД.Pg:
			this.пг.закрой();
			break;

			case ПТипБД.MSQL:
			this.м.закрой();
			break;
			/*
			case ПТипБД.MSSQL:
			this.мс.подключись(параметры, имя_пользователя, пароль);
			break;
			*/
			default:
		}


	}


	}


}
