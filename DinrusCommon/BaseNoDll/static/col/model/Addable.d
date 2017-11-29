﻿/*********************************************************
   Copyright: (C) 2008 by Steven Schveighoffer.
              All rights reserved

   License: $(LICENSE)

**********************************************************/
module col.model.Addable;

public import col.model.Collection;

/**
 *  Определяем интерфейс для коллекций, в которые могут добавляться значения.
 */
interface Добавляемый(V)
{
    /**
     * возвращает this.
     */
    Добавляемый!(V) добавь(V v);

    /**
     * возвращает this.
     *
     * был_добавлен равно true, если добавлено значение.
     */
    Добавляемый!(V) добавь(V v, ref бул был_добавлен);

    /**
     * добавить все значения, полученные из коллекции, с пом. метода
     * opApply обходчика.  Возвращает this.
     */
    Добавляемый!(V) добавь(Обходчик!(V) обх);

    /**
     * добавить все значения, полученные из коллекции, с пом. метода
     * opApply обходчика. чло_добавленных равно числу добавляемых элементов.
     */
    Добавляемый!(V) добавь(Обходчик!(V) обх, ref бцел чло_добавленных);

    /**
     * добавить все значения из массив.  Возвращает this.
     */
    Добавляемый!(V) добавь(V[] массив);

    /**
     * добавить все значения из массив.  Возвращает this.
     *
     * чло_добавленных равно числу добавляемых элементов.
     */
    Добавляемый!(V) добавь(V[] массив, ref бцел чло_добавленных);
}
