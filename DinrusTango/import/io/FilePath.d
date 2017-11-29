﻿module io.FilePath;

private import  io.Path;
private import  io.model:
ФайлКонст, ИнфОФайле;



class ФПуть : ПросмотрПути
{
    public alias    добавь  opCatAssign;    // путь ~= x;
    public alias бул delegate (ФПуть, бул) Фильтр;

    static ФПуть opCall (ткст фпуть = пусто);
    this (ткст фпуть = пусто);
    final ткст вТкст ();
    final ФПуть dup ();
    final ткст сиТкст ();
    final ткст корень ();
    final ткст папка ();
    final ткст предок ();
    final ткст имя ();
    final ткст расш ();
    final ткст суффикс ();
    final ткст путь ();
    final ткст файл ();
    final override цел opEquals (Объект o);
    final цел opEquals (ткст s);
    final бул абс_ли ();
    final бул пуст_ли ();
    final бул ветвь_ли ();
    final ФПуть замени (сим из_, сим в_);
    final ФПуть стандарт ();
    final ФПуть исконный ();
    final ФПуть склей (ткст[] другие...);
    final ФПуть добавь (ткст путь);
    final ФПуть приставь (ткст путь);
    ФПуть установи (ФПуть путь);
    final ФПуть установи (ткст путь, бул преобразуй = нет);
    final ФПуть папка_ли (бул папка);
    final ФПуть корень (ткст другой);
    final ФПуть папка (ткст другой);
    final ФПуть имя (ткст другой);
    final ФПуть суффикс (ткст другой);
    final ФПуть путь (ткст другой);
    final ФПуть файл (ткст другой);
    final ФПуть вынь ();
    static ткст объедини (ткст[] пути...);
    final ФПуть абсолютный (ткст префикс);
    static ткст очищенный (ткст путь, сим c = ФайлКонст.СимПутьРазд);
    static ткст псеп_в_конце (ткст путь, сим c = ФайлКонст.СимПутьРазд);
    static ткст псеп_в_начале (ткст s, сим c = ФайлКонст.СимПутьРазд);
    private final ФПуть разбор ();
    private final проц расширь (бцел размер);
    private final цел исправь (цел голова, цел хвост, цел длин, ткст sub);
    final ФПуть создай ();
    final ФПуть[] вСписок (Фильтр фильтр = пусто);
    static ФПуть из_ (ref ИнфОФайле инфо);
    final бул есть_ли ();
    final Время изменён ();
    final Время использовался ();
    final Время создан ();
    final ФПуть переименуй (ФПуть приёмн);
    final ФПуть копируй (ткст источник);
    final бдол размерФайла ();
    final бул записываем_ли ();
    final бул папка_ли ();
    final бул файл_ли ();
    final Штампы штампыВремени ();
    final ФПуть копируй (ФПуть ист);
    final ФПуть удали ();
    final ФПуть переименуй (ткст приёмн);
    final ФПуть создайФайл ();
    final ФПуть создайПапку ();
    final цел opApply (цел delegate(ref ИнфОФайле) дг);
}
//===========================================================
interface ПросмотрПути
{
    alias ФС.Штампы         Штампы;

    abstract ткст вТкст ();
    abstract ткст сиТкст ();
    abstract ткст корень ();
    abstract ткст папка ();
    abstract ткст имя ();
    abstract ткст расш ();
    abstract ткст суффикс ();
    abstract ткст путь ();
    abstract ткст файл ();
    abstract бул абс_ли ();
    abstract бул пуст_ли ();
    abstract бул ветвь_ли ();
    abstract бул есть_ли ();
    abstract Время изменён ();
    abstract Время использовался ();
    abstract Время создан ();
    abstract бдол размерФайла ();
    abstract бул записываем_ли ();
    abstract бул папка_ли ();
    abstract Штампы штампыВремени ();
}
