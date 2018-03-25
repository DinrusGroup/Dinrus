/*********************************************************
   Copyright: (C) 2008 by Steven Schveighoffer.
              All rights reserved

   License: $(LICENSE)

**********************************************************/
module col.Functions;

/**
 * Define a хэш function type.
 */
template ХэшФунк(V)
{
    alias бцел function(ref V v) ХэшФунк;
}

/**
 * Define an update function type.  The update function is responsible for
 * performing the operation denoted by:
 *
 * origv = newv
 *
 * This can be different for Maps for example, where V may contain the ключ as
 * well as the значение.
 */
template ФункцОбновления(V)
{
    alias проц function(ref V origv, ref V newv) ФункцОбновления;
}

/**
 * Define a comparison function type
 *
 * This can be different for Maps in the same way the update function is
 * different.
 */
template ФункцСравнения(V)
{
    alias цел function(ref V v1, ref V v2) ФункцСравнения;
}

/**
 * Define the default сравни
 */
цел ДефСравнить(V)(ref V v1, ref V v2)
{
    return typeid(V).сравни(&v1, &v2);
}

/**
 * Define the default хэш function
 */
бцел ДефХэш(V)(ref V v)
{
    return typeid(V).дайХэш(&v);
}
