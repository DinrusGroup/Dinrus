﻿/*******************************************************************************

        copyright:      Copyright (c) 2007 Kris Bell. Все права защищены

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: Oct 2007

        author:         Kris

*******************************************************************************/

module io.stream.Text;

private import io.stream.Lines;

private import io.stream.Format;

private import io.stream.Buffered;

private import io.model;

/*******************************************************************************

        Ввод is buffered

*******************************************************************************/

class ТекстВвод : Строки!(сим)
{
    /**********************************************************************

    **********************************************************************/

    this (ИПотокВвода ввод)
    {
        super (ввод);
    }
}

/*******************************************************************************

        Вывод is buffered

*******************************************************************************/

class ТекстВывод : ФормВывод!(сим)
{
    /**********************************************************************

            Construct a ФормВывод экземпляр, tying the предоставленный поток
            в_ a выкладка форматёр

    **********************************************************************/

    this (ИПотокВывода вывод)
    {
        super (Бвыв.создай(вывод));
    }
}
