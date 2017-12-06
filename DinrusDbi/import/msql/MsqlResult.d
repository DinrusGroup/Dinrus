/**
 * Authors: The D DBI project
 *
 * Version: 0.2.5
 *
 * Copyright: BSD license
 */
module dbi.msql.MsqlResult;

private import dbi.DBIException, dbi.Result, dbi.Row;
private import dbi.msql.imp;


class РезультатМЭсКюЭл : Результат
{
public:
    this ();
    override Ряд получиРяд ();
    override проц финиш ();

private:
}
