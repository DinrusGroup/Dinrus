/*********************************************************
   Copyright: (C) 2008 by Steven Schveighoffer.
              All rights reserved

   License: $(LICENSE)

**********************************************************/
module col.model.Iterator;

enum : бцел
{
    /**
     * Возвращается из длина(), когда length не поддерживается
     */
    ДЛИНА_НЕ_ПОДДЕРЖИВАЕТСЯ = ~0
}

/**
 * Basic обходчик.  Allows iterating over all the элементы of an object.
 */
interface Обходчик(V)
{
    /**
     * If supported, returns the number of элементы that will be iterated.
     *
     * If not supported, returns ДЛИНА_НЕ_ПОДДЕРЖИВАЕТСЯ.
     */
    бцел длина(); alias длина length;

    /**
     * foreach operator.
     */
    цел opApply(цел delegate(ref V v) дг);
}

/**
 * Обходчик с ключами.  This allows one to view the ключ of the элемент as well
 * as the значение while iterating.
 */
interface Ключник(K, V) : Обходчик!(V)
{
    alias Обходчик!(V).opApply opApply;

    /**
     * iterate over both ключи и значения
     */
    цел opApply(цел delegate(ref K k, ref V v) дг);
}

/**
 * A очистить обходчик is используется to очистить значения from a collection.  This works by
 * telling the обходчик that you want обх to удали the значение последн iterated.
 */
interface Чистящий(V)
{
    /**
     * iterate over the значения of the обходчик, telling обх which значения to
     * удали.  To удали a значение, установи чистить_ли to true перед exiting the
     * loop.
     *
     * Make sure you specify ref for the чистить_ли parameter:
     *
     * -----
     * foreach(ref чистить_ли, v; &чистящий.очистить){
     * ...
     * -----
     */
    цел очистить(цел delegate(ref бул чистить_ли, ref V v) дг);
}

/**
 * A очистить обходчик for keyed containers.
 */
interface ЧистящийКлючи(K, V) : Чистящий!(V)
{
    /**
     * iterate over the ключ/значение pairs of the обходчик, telling обх which ones
     * to удали.
     *
     * Make sure you specify ref for the чистить_ли parameter:
     *
     * -----
     * foreach(ref чистить_ли, k, v; &чистящий.чисть_ключ){
     * ...
     * -----
     *
     * TODO: note this should have the имя очистить, but because of asonine
     * lookup rules, обх makes обх difficult to specify this version over the
     * base version.  Once this is fixed, обх's highly likely that this goes
     * тыл to the имя очистить.
     *
     * See bugzilla #2498
     */
    цел чисть_ключ(цел delegate(ref бул чистить_ли, ref K k, ref V v) дг);
}
