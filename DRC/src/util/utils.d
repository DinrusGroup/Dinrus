/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 * Utility functions for DMD.
 *
 * This modules defines some utility functions for DMD.
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/utils.d, _utils.d)
 * Documentation:  https://dlang.org/phobos/dmd_utils.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/utils.d
 */

module util.utils;

import cidrus;
//import dmd.errors;
//import dmd.globals;
import util.file;
import util.filename;
import util.outbuffer;
import util.string;


/**
 * Нормализовать путь, превратив слэши в обратные слэши
 *
 * Параметры:
 *   src = Исхдный путь с применением в unix-стиле ('/') путесепараторов
 *
 * Возвращает:
 *   A newly-allocated ткст with '/' turned into backslashes
 */
ткст0 toWinPath(ткст0 src)
{
    if (src is null)
        return null;
    ткст0 результат = strdup(src);
    ткст0 p = результат;
    while (*p != '\0')
    {
        if (*p == '/')
            *p = '\\';
        p++;
    }
    return результат;
}


/**
 * Reads a файл, terminate the program on error
 *
 * Параметры:
 *   место = The line number information from where the call originates
 *   имяф = Path to файл
 */
ФайлБуфер readFile(Место место, ткст0 имяф)
{
    auto результат = Файл.читай(имяф);
    if (!результат.успех)
    {
        выведиОшибку(место, "Ошибка при чтении файла '%s'", имяф);
        fatal();
    }
    return ФайлБуфер(результат.извлекиСрез());
}


/**
 * Writes a файл, terminate the program on error
 *
 * Параметры:
 *   место = The line number information from where the call originates
 *   имяф = Path to файл
 *   данные = Full content of the файл to be written
 */
проц writeFile(Место место, ткст имяф, проц[] данные)
{
    ensurePathToNameExists(Место.initial, имяф);
    if (!Файл.пиши(имяф, данные))
    {
        выведиОшибку(место, "Ошибка при записи файла '%*.s'", имяф.length, имяф.ptr);
        fatal();
    }
}


/**
 * Гарант the root path (the path minus the имя) of the provided path
 * exists, and terminate the process if it doesn't.
 *
 * Параметры:
 *   место = The line number information from where the call originates
 *   имя = a path to check (the имя is stripped)
 */
проц ensurePathToNameExists(Место место, ткст имя)
{
    const ткст pt = ИмяФайла.path(имя);
    if (pt.length)
    {
        if (!ИмяФайла.ensurePathExists(pt))
        {
            выведиОшибку(место, "Не удаётся создать папку %*.s", pt.length, pt.ptr);
            fatal();
        }
    }
    ИмяФайла.free(pt.ptr);
}


/**
 * Takes a path, and escapes '(', ')' and backslashes
 *
 * Параметры:
 *   буф = Buffer to пиши the escaped path to
 *   fname = Path to ýñêàïèðóé
 */
проц escapePath(БуфВыв* буф, ткст0 fname)
{
    while (1)
    {
        switch (*fname)
        {
        case 0:
            return;
        case '(':
        case ')':
        case '\\':
            буф.пишиБайт('\\');
            goto default;
        default:
            буф.пишиБайт(*fname);
            break;
        }
        fname++;
    }
}
