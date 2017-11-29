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
interface Добавляемый(З)
{
    /**
     * возвращает this.
     */
    Добавляемый!(З) добавь(З з);

    /**
     * возвращает this.
     *
     * был_добавлен равно true, если добавлено значение.
     */
    Добавляемый!(З) добавь(З з, ref бул был_добавлен);

    /**
     * добавить все значения, полученные из коллекции, с пом. метода
     * opApply обходчика.  Возвращает this.
     */
    Добавляемый!(З) добавь(Обходчик!(З) обх);

    /**
     * добавить все значения, полученные из коллекции, с пом. метода
     * opApply обходчика. чло_добавленных равно числу добавляемых элементов.
     */
    Добавляемый!(З) добавь(Обходчик!(З) обх, ref бцел чло_добавленных);

    /**
     * добавить все значения из массив.  Возвращает this.
     */
    Добавляемый!(З) добавь(З[] массив);

    /**
     * добавить все значения из массив.  Возвращает this.
     *
     * чло_добавленных равно числу добавляемых элементов.
     */
    Добавляемый!(З) добавь(З[] массив, ref бцел чло_добавленных);
}
