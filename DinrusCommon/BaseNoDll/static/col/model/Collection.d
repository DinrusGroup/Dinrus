/*********************************************************
   Copyright: (C) 2008 by Steven Schveighoffer.
              All rights reserved

   License: $(LICENSE)

**********************************************************/
module col.model.Collection;

public import col.model.Iterator;

/**
 * The collection interface defines the basic API for all собериions.
 *
 * A basic collection should be able to iterate over its элементы, tell if обх
 * содержит an элемент, и удали элементы.  Adding элементы is not supported
 * here, because элементы are not always simply addable.  For example, a map
 * needs both the элемент и the ключ to добавь обх.
 */
interface Коллекция(V) : Обходчик!(V), Чистящий!(V) 
{
    /**
     * очисти the container of all значения
     */
    Коллекция!(V) очисти();

    /**
     * удали an элемент with the specific значение.  This may be an O(n)
     * operation.  If the collection is keyed, the первый элемент whose значение
     * совпадает will be removed.
     *
     * returns this.
     */
    Коллекция!(V) удали(V v);

    /**
     * удали an элемент with the specific значение.  This may be an O(n)
     * operation.  If the collection is keyed, the первый элемент whose значение
     * совпадает will be removed.
     *
     * returns this.
     *
     * sets был_Удалён to true if the элемент existed и was removed.
     */
    Коллекция!(V) удали(V v, ref бул был_Удалён);

    /**
     * returns true if the collection содержит the значение.  can be O(n).
     */
    бул содержит(V v);

    /**
     * make a копируй of this collection.  This does not do a deep копируй of the
     * элементы if they are ссылка or pointer types.
     */
    Коллекция!(V) dup();
}
