/*******************************************************************************

        copyright:      Copyright (c) 2007 the Dinrus team. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: July 2007

        author:         Cyborg16, Sean Kelly

*******************************************************************************/

module sys.win32.SpecialPath;

private import text.convert.Utf;
private import sys.Common;
private import sys.win32.CodePage;
private import stringz;


pragma(lib, "DinrusTango.lib");

version(Win32SansUnicode)
    extern(Windows) цел SHGetSpecialFolderPathA(HWND, LPCSTR, цел, BOOL);
else
    extern(Windows) цел SHGetSpecialFolderPathW(HWND, LPCWSTR, цел, BOOL);

enum ПОсобыйПуть
{
    РабСтол = 0,
    Интернет,
    Программы,
    Контролы,
    Принтеры,
    Личное,
    Избраное,
    Пуск,
    Недавнее,
    Почта,
    Битбакет,
    МенюПуск, // = 11
    ПапкаРабСтола = 16,
    Диски,
    Сеть,
    Окружение,
    Шрифты,
    Шаблоны,
    Общее_МенюПуск,
    Общее_Программы,
    Общее_Пуск,
    Общее_ПапкаРабСтола,
    ДанныеПриложений,
    Печать,
    Локальная_ДанныеПриложеий,
    АльтПуск,
    Общее_АльтПуск,
    Общее_Избранное,
    ИнтернетКэш,
    Куки,
    История,
    Общее_ДанныеПриложений,
    Виндовс,
    Система,
    ПрограммныеФайлы,
    МоиРисунки,
    Профиль,
    СистемаХ86,
    ПрограммныеайлыХ86,
    ПрограммныеФайлы_Общее,
    ПрограммныеФайлы_ОбщееХ86,
    Общее_Шаблоны,
    Общее_Документы,
    Общее_Администрирование,
    Администрирование,
    Подключения, // =49
    Общее_Музыка = 53,
    Общее_Рисунки,
    Общее_Видео,
    Ресурсы,
    ЛокализованныеРесурсы,
    Общее_ОЕМ_Ссылки,
    ЗаписьКД, // = 59
    СетевоеОкружение = 61,
    Флаг_НеПроверять = 0x4000,
    Флаг_Создать = 0x8000,
    Флаг_Маска = 0xFF00
}

/**
 * Get a special путь (on Windows).
 *
 * Параметры:
 *  csопрl = Enum of путь в_ получи
 *
 * Throws:
 *
 *
 * Возвращает:
 *  A ткст containing the путь
 */
ткст дайОсобыйПуть( ПОсобыйПуть оп )
{
    version( Win32SansUnicode )
    {
        сим* spath = (new сим[MAX_PATH]).ptr;
        scope(exit) delete spath;

        if( !SHGetSpecialFolderPathA( пусто, spath, оп, да ) )
            throw new Исключение( "дайОсобыйПуть :: " ~ СисОш.последнСооб );
        ткст dpath = new сим[MAX_PATH];
        return КодоваяСтраница.из_(изТкст0(spath), dpath);
    }
    else
    {
        шим* spath = (new шим[MAX_PATH]).ptr;
        scope(exit) delete spath;

        if( !SHGetSpecialFolderPathW( пусто, spath, оп, да ) )
            throw new Исключение( "дайОсобыйПуть :: " ~ СисОш.последнСооб );
        return вТкст(изТкст16н(spath));
    }
}
