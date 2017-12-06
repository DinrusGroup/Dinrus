/**
 * Authors: The D DBI project
 * Copyright: BSD license
 */
module dbi.mysql.MysqlError;

version = dbi_mysql;
version (dbi_mysql)
{

    private import dbi.ErrorCode;

package:

    /**
     * Convert a MySQL _error code to an КодОшибки.
     *
     * Params:
     *	ошибка = The MySQL _error code.
     *
     * Returns:
     *	The КодОшибки representing ошибка.
     *
     * Note:
     *	Written against the MySQL 5.1 documentation (revision 2737)
     */

    КодОшибки спецВОбщ (бцел ошибка) ;
}
