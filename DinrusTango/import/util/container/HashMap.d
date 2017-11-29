﻿/*******************************************************************************

        copyright:      Copyright (c) 2008 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Apr 2008: Initial release

        authors:        Kris

        Since:          0.99.7

        Based upon Doug Lea's Java collection package

*******************************************************************************/

module util.container.HashMap;

private import util.container.Slink;

public  import util.container.Container;

private import util.container.model.IContainer;

private import exception :
НетЭлементаИскл;

/*******************************************************************************

        Хэш таблица implementation of a Карта

        ---
        Обходчик обходчик ()
        цел opApply (цел delegate(ref V значение) дг)
        цел opApply (цел delegate(ref K ключ, ref V значение) дг)

        бул получи (K ключ, ref V элемент)
        бул ключК (V значение, ref K ключ)
        бул содержит (V элемент)
        бул содержитПару (K ключ, V элемент)

        бул удалиКлюч (K ключ)
        бул возьми (ref V элемент)
        бул возьми (K ключ, ref V элемент)
        т_мера удали (V элемент, бул все)
        т_мера удали (ИКонтейнер!(V) e, бул все)
        т_мера замени (V старЭлемент, V новЭлемент, бул все)
        бул замениПару (K ключ, V старЭлемент, V новЭлемент)

        бул добавь (K ключ, V элемент)
        бул opIndexAssign (V элемент, K ключ)
        V    opIndex (K ключ)
        V*   opIn_r (K ключ)

        т_мера размер ()
        бул пуст_ли ()
        V[] вМассив (V[] приёмн)
        ХэшКарта dup ()
        ХэшКарта очисть ()
        ХэшКарта сбрось ()
        т_мера корзины ()
        плав порог ()
        проц корзины (т_мера cap)
        проц порог (плав desired)
        ---

*******************************************************************************/

class ХэшКарта (K, V, alias Хэш = Контейнер.хэш,
                            alias Извл = Контейнер.извлеки,
                            alias Куча = Контейнер.ДефСбор)
        : ИКонтейнер!(V)
{
    // bucket типы
    version (ХэшКэш)
    private alias Slink!(V, K, нет, да) Тип;
    else
        private alias Slink!(V, K) Тип;

    private alias Тип         *Реф;

    // разместитель тип
    private alias Куча!(Тип)  Размест;

    // each таблица Запись is a linked список, or пусто
    private Реф                таблица[];

    // число of элементы contained
    private т_мера             счёт;

    // the порог загрузи factor
    private плав              факторЗагрузки;

    // configured куча manager
    private Размест              куча;

    // мутация тэг updates on each change
    private т_мера             мутация;

    /***********************************************************************

            Construct a ХэшКарта экземпляр

    ***********************************************************************/

    this (плав f = Контейнер.дефФакторЗагрузки)
    {
        факторЗагрузки = f;
    }

    /***********************************************************************

            Clean up when deleted

    ***********************************************************************/

    ~this ()
    {
        сбрось;
    }

    /***********************************************************************

            Return a генерный обходчик for contained элементы

    ***********************************************************************/

    final Обходчик обходчик ()
    {
        Обходчик i =void;
        i.мутация = мутация;
        i.таблица = таблица;
        i.хозяин = this;
        i.ячейка = пусто;
        i.ряд = 0;
        return i;
    }

    /***********************************************************************


    ***********************************************************************/

    final цел opApply (цел delegate(ref K ключ, ref V значение) дг)
    {
        return обходчик.opApply (дг);
    }

    /***********************************************************************


    ***********************************************************************/

    final цел opApply (цел delegate(ref V значение) дг)
    {
        return обходчик.opApply ((ref K k, ref V v)
        {
            return дг(v);
        });
    }

    /***********************************************************************

            Return the число of элементы contained

    ***********************************************************************/

    final т_мера размер ()
    {
        return счёт;
    }

    /***********************************************************************

            Добавь a new элемент в_ the установи. Does not добавь if there is an
            equivalent already present. Returns да where an элемент
            is добавьed, нет where it already есть_ли (и was possibly
            updated).

            Время complexity: O(1) average; O(n) worst.

    ***********************************************************************/

    final бул добавь (K ключ, V элемент)
    {
        if (таблица is пусто)
            перемерь (Контейнер.дефНачКорзины);

        auto hd = &таблица [Хэш (ключ, таблица.length)];
        auto узел = *hd;

        if (узел is пусто)
        {
            *hd = куча.размести.установи (ключ, элемент, пусто);
            инкремент;
        }
        else
        {
            auto p = узел.найдиКлюч (ключ);
            if (p)
            {
                if (элемент != p.значение)
                {
                    p.значение = элемент;
                    измени;
                }
                return нет;
            }
            else
            {
                *hd = куча.размести.установи (ключ, элемент, узел);
                инкремент;

                // we only проверь загрузи factor on добавь в_ Неукmpty bin
                проверьЗагрузку;
            }
        }
        return да;
    }

    /***********************************************************************

            Добавь a new элемент в_ the установи. Does not добавь if there is an
            equivalent already present. Returns да where an элемент
            is добавьed, нет where it already есть_ли (и was possibly
            updated). This variation invokes the given retain function
            when the ключ does not already exist. You would typically
            use that в_ дубликат a ткст, or whatever is требуется.

            Время complexity: O(1) average; O(n) worst.

    ***********************************************************************/

    final бул добавь (K ключ, V элемент, K function(K) retain)
    {
        if (таблица is пусто)
            перемерь (Контейнер.дефНачКорзины);

        auto hd = &таблица [Хэш (ключ, таблица.length)];
        auto узел = *hd;

        if (узел is пусто)
        {
            *hd = куча.размести.установи (retain(ключ), элемент, пусто);
            инкремент;
        }
        else
        {
            auto p = узел.найдиКлюч (ключ);
            if (p)
            {
                if (элемент != p.значение)
                {
                    p.значение = элемент;
                    измени;
                }
                return нет;
            }
            else
            {
                *hd = куча.размести.установи (retain(ключ), элемент, узел);
                инкремент;

                // we only проверь загрузи factor on добавь в_ Неукmpty bin
                проверьЗагрузку;
            }
        }
        return да;
    }

    /***********************************************************************

            Return the элемент associated with ключ

            param: a ключ
            param: a значение reference (where returned значение will resопрe)
            Возвращает: whether the ключ is contained or not

    ************************************************************************/

    final бул получи (K ключ, ref V элемент)
    {
        if (счёт)
        {
            auto p = таблица [Хэш (ключ, таблица.length)];
            if (p && (p = p.найдиКлюч(ключ)) !is пусто)
            {
                элемент = p.значение;
                return да;
            }
        }
        return нет;
    }

    /***********************************************************************

            Return the элемент associated with ключ

            param: a ключ
            Возвращает: a pointer в_ the located значение, or пусто if не найден

    ************************************************************************/

    final V* opIn_r (K ключ)
    {
        if (счёт)
        {
            auto p = таблица [Хэш (ключ, таблица.length)];
            if (p && (p = p.найдиКлюч(ключ)) !is пусто)
                return &p.значение;
        }
        return пусто;
    }

    /***********************************************************************

            Does this установи contain the given элемент?

            Время complexity: O(1) average; O(n) worst

    ***********************************************************************/

    final бул содержит (V элемент)
    {
        return экземпляры (элемент) > 0;
    }

    /***********************************************************************

            Время complexity: O(n).

    ************************************************************************/

    final бул ключК (V значение, ref K ключ)
    {
        if (счёт)
            foreach (список; таблица)
            if (список)
            {
                auto p = список.найди (значение);
                if (p)
                {
                    ключ = p.ключ;
                    return да;
                }
            }
        return нет;
    }

    /***********************************************************************

            Время complexity: O(1) average; O(n) worst.

    ***********************************************************************/

    final бул содержитКлюч (K ключ)
    {
        if (счёт)
        {
            auto p = таблица[Хэш (ключ, таблица.length)];
            if (p && p.найдиКлюч(ключ))
                return да;
        }
        return нет;
    }

    /***********************************************************************

            Время complexity: O(1) average; O(n) worst.

    ***********************************************************************/

    final бул содержитПару (K ключ, V элемент)
    {
        if (счёт)
        {
            auto p = таблица[Хэш (ключ, таблица.length)];
            if (p && p.найдиПару (ключ, элемент))
                return да;
        }
        return нет;
    }

    /***********************************************************************

            Make an independent копируй of the container. Does not клонируй
            элементы

            Время complexity: O(n)

    ***********************************************************************/

    final ХэшКарта dup ()
    {
        auto клонируй = new ХэшКарта!(K, V, Хэш, Извл, куча) (факторЗагрузки);

        if (счёт)
        {
            клонируй.корзины (корзины);

            foreach (ключ, значение; обходчик)
            клонируй.добавь (ключ, значение);
        }
        return клонируй;
    }

    /***********************************************************************

            Время complexity: O(1) average; O(n) worst.

    ***********************************************************************/

    final бул удалиКлюч (K ключ)
    {
        V значение;

        return возьми (ключ, значение);
    }

    /***********************************************************************

            Время complexity: O(1) average; O(n) worst.

    ***********************************************************************/

    final бул replaceKey (K ключ, K замени)
    {
        if (счёт)
        {
            auto h = Хэш (ключ, таблица.length);
            auto hd = таблица[h];
            auto trail = hd;
            auto p = hd;

            while (p)
            {
                auto n = p.следщ;
                if (ключ == p.ключ)
                {
                    if (p is hd)
                        таблица[h] = n;
                    else
                        trail.отторочьСледщ;

                    // инъекцируй преобр_в new location
                    h = Хэш (замени, таблица.length);
                    таблица[h] = p.установи (замени, p.значение, таблица[h]);
                    return да;
                }
                else
                {
                    trail = p;
                    p = n;
                }
            }
        }
        return нет;
    }

    /***********************************************************************

            Время complexity: O(1) average; O(n) worst.

    ***********************************************************************/

    final бул замениПару (K ключ, V старЭлемент, V новЭлемент)
    {
        if (счёт)
        {
            auto p = таблица [Хэш (ключ, таблица.length)];
            if (p)
            {
                auto c = p.найдиПару (ключ, старЭлемент);
                if (c)
                {
                    c.значение = новЭлемент;
                    измени;
                    return да;
                }
            }
        }
        return нет;
    }

    /***********************************************************************

            Удали и expose the первый элемент. Returns нет when no
            ещё элементы are contained

            Время complexity: O(n)

    ***********************************************************************/

    final бул возьми (ref V элемент)
    {
        if (счёт)
            foreach (ref список; таблица)
            if (список)
            {
                auto p = список;
                элемент = p.значение;
                список = p.следщ;
                декремент (p);
                return да;
            }
        return нет;
    }

    /***********************************************************************

            Удали и expose the элемент associated with ключ

            param: a ключ
            param: a значение reference (where returned значение will resопрe)
            Возвращает: whether the ключ is contained or not

            Время complexity: O(1) average, O(n) worst

    ***********************************************************************/

    final бул возьми (K ключ, ref V значение)
    {
        if (счёт)
        {
            auto p = &таблица [Хэш (ключ, таблица.length)];
            auto n = *p;

            while ((n = *p) !is пусто)
                if (ключ == n.ключ)
                {
                    *p = n.следщ;
                    значение = n.значение;
                    декремент (n);
                    return да;
                }
                else
                    p = &n.следщ;
        }
        return нет;
    }

    /***********************************************************************

            Operator shortcut for assignment

    ***********************************************************************/

    final бул opIndexAssign (V элемент, K ключ)
    {
        return добавь (ключ, элемент);
    }

    /***********************************************************************

            Operator retreival function

            Throws НетЭлементаИскл where ключ is missing

    ***********************************************************************/

    final V opIndex (K ключ)
    {
        auto p = opIn_r (ключ);
        if (p)
            return *p;
        throw new НетЭлементаИскл ("missing or не_годится ключ");
    }

    /***********************************************************************

            Удали a установи of значения

    ************************************************************************/

    final т_мера удали (ИКонтейнер!(V) e, бул все = нет)
    {
        auto i = счёт;
        foreach (значение; e)
        удали (значение, все);
        return i - счёт;
    }

    /***********************************************************************

            Removes элемент экземпляры, и returns the число of элементы
            removed

            Время complexity: O(1) average; O(n) worst

    ************************************************************************/

    final т_мера удали (V элемент, бул все = нет)
    {
        auto i = счёт;

        if (i)
            foreach (ref узел; таблица)
        {
            auto p = узел;
            auto trail = узел;

            while (p)
            {
                auto n = p.следщ;
                if (элемент == p.значение)
                {
                    декремент (p);
                    if (p is узел)
                    {
                        узел = n;
                        trail = n;
                    }
                    else
                        trail.следщ = n;

                    if (! все)
                        return i - счёт;
                    else
                        p = n;
                }
                else
                {
                    trail = p;
                    p = n;
                }
            }
        }

        return i - счёт;
    }

    /***********************************************************************

            Замени экземпляры of старЭлемент with новЭлемент, и returns
            the число of replacements

            Время complexity: O(n).

    ************************************************************************/

    final т_мера замени (V старЭлемент, V новЭлемент, бул все = нет)
    {
        т_мера i;

        if (счёт && старЭлемент != новЭлемент)
            foreach (узел; таблица)
            while (узел && (узел = узел.найди(старЭлемент)) !is пусто)
            {
                ++i;
                измени;
                узел.значение = новЭлемент;
                if (! все)
                    return i;
            }
        return i;
    }

    /***********************************************************************

            Clears the ХэшКарта contents. Various атрибуты are
            retained, such as the internal таблица itself. Invoke
            сбрось() в_ drop everything.

            Время complexity: O(n)

    ***********************************************************************/

    final ХэшКарта очисть ()
    {
        return очисть (нет);
    }

    /***********************************************************************

            Reset the ХэшКарта contents. This releases ещё память
            than очисть() does

            Время complexity: O(n)

    ***********************************************************************/

    final ХэшКарта сбрось ()
    {
        очисть (да);
        куча.собери (таблица);
        таблица = пусто;
        return this;
    }

    /***********************************************************************

            Return the число of корзины

            Время complexity: O(1)

    ***********************************************************************/

    final т_мера корзины ()
    {
        return таблица ? таблица.length : 0;
    }

    /***********************************************************************

            Набор the desired число of корзины in the хэш таблица. Any
            значение greater than or equal в_ one is ОК.

            If different than текущ корзины, causes a version change

            Время complexity: O(n)

    ***********************************************************************/

    final ХэшКарта корзины (т_мера cap)
    {
        if (cap < Контейнер.дефНачКорзины)
            cap = Контейнер.дефНачКорзины;

        if (cap !is корзины)
            перемерь (cap);
        return this;
    }

    /***********************************************************************

            Набор the число of корзины for the given порог
            и перемерь as требуется

            Время complexity: O(n)

    ***********************************************************************/

    final ХэшКарта корзины (т_мера cap, плав порог)
    {
        факторЗагрузки = порог;
        return корзины (cast(т_мера)(cap / порог) + 1);
    }

    /***********************************************************************

            Configure the назначено разместитель with the размер of each
            allocation блок (число of узелs allocated at one время)
            и the число of узелs в_ pre-наполни the кэш with.

            Время complexity: O(n)

    ***********************************************************************/

    final ХэшКарта кэш (т_мера чанк, т_мера счёт=0)
    {
        куча.конфиг (чанк, счёт);
        return this;
    }

    /***********************************************************************

            Return the текущ загрузи factor порог

            The Хэш таблица occasionally проверьa against the загрузи factor
            resizes itself if it имеется gone past it.

            Время complexity: O(1)

    ***********************************************************************/

    final плав порог ()
    {
        return факторЗагрузки;
    }

    /***********************************************************************

            Набор the перемерь порог, и перемерь as требуется
            Набор the текущ desired загрузи factor. Any значение greater
            than 0 is ОК. The текущ загрузи is проверьed against it,
            possibly causing a перемерь.

            Время complexity: O(n)

    ***********************************************************************/

    final проц порог (плав desired)
    {
        assert (desired > 0.0);
        факторЗагрузки = desired;
        if (таблица)
            проверьЗагрузку;
    }

    /***********************************************************************

            Copy и return the contained установи of значения in an Массив,
            using the optional приёмн as a реципиент (which is resized
            as necessary).

            Returns a срез of приёмн representing the container значения.

            Время complexity: O(n)

    ***********************************************************************/

    final V[] вМассив (V[] приёмн = пусто)
    {
        if (приёмн.length < счёт)
            приёмн.length = счёт;

        т_мера i = 0;
        foreach (k, v; this)
        приёмн[i++] = v;
        return приёмн [0 .. счёт];
    }

    /***********************************************************************

            Is this container пустой?

            Время complexity: O(1)

    ***********************************************************************/

    final бул пуст_ли ()
    {
        return счёт is 0;
    }

    /***********************************************************************

            Sanity проверь

    ***********************************************************************/

    final ХэшКарта проверь ()
    {
        assert(!(таблица is пусто && счёт !is 0));
        assert((таблица is пусто || таблица.length > 0));
        assert(факторЗагрузки > 0.0f);

        if (таблица)
        {
            т_мера c = 0;
            for (т_мера i=0; i < таблица.length; ++i)
                for (auto p = таблица[i]; p; p = p.следщ)
                {
                    ++c;
                    assert(содержит(p.значение));
                    assert(содержитКлюч(p.ключ));
                    assert(экземпляры(p.значение) >= 1);
                    assert(содержитПару(p.ключ, p.значение));
                    assert(Хэш (p.ключ, таблица.length) is i);
                }
            assert(c is счёт);
        }
        return this;
    }

    /***********************************************************************

            Счёт the элемент экземпляры in the установи (there can only be
            0 or 1 экземпляры in a Набор).

            Время complexity: O(n)

    ***********************************************************************/

    private т_мера экземпляры (V элемент)
    {
        т_мера c = 0;
        foreach (узел; таблица)
        if (узел)
            c += узел.счёт (элемент);
        return c;
    }

    /***********************************************************************

             Check в_ see if we are past загрузи factor порог. If so,
             перемерь so that we are at half of the desired порог.

    ***********************************************************************/

    private ХэшКарта проверьЗагрузку ()
    {
        плав fc = счёт;
        плав ft = таблица.length;
        if (fc / ft > факторЗагрузки)
            перемерь (2 * cast(т_мера)(fc / факторЗагрузки) + 1);
        return this;
    }

    /***********************************************************************

            перемерь таблица в_ new ёмкость, rehashing все элементы

    ***********************************************************************/

    private проц перемерь (т_мера newCap)
    {
        // Стдвыв.форматнс ("перемерь {}", newCap);
        auto newtab = куча.размести (newCap);
        измени;

        foreach (bucket; таблица)
        while (bucket)
        {
            auto n = bucket.следщ;
            version (ХэшКэш)
            auto h = n.кэш;
            else
                auto h = Хэш (bucket.ключ, newCap);
            bucket.следщ = newtab[h];
            newtab[h] = bucket;
            bucket = n;
        }

        // release the приор таблица и присвой new one
        куча.собери (таблица);
        таблица = newtab;
    }

    /***********************************************************************

            Удали the indicated узел. We need в_ traverse корзины
            for this, since we're singly-linked only. Better в_ save
            the per-узел память than в_ gain a little on each удали

            Used by iterators only

    ***********************************************************************/

    private бул удалиУзел (Реф узел, Реф* список)
    {
        auto p = список;
        auto n = *p;

        while ((n = *p) !is пусто)
            if (n is узел)
            {
                *p = n.следщ;
                декремент (n);
                return да;
            }
            else
                p = &n.следщ;
        return нет;
    }

    /***********************************************************************

            Clears the ХэшКарта contents. Various атрибуты are
            retained, such as the internal таблица itself. Invoke
            сбрось() в_ drop everything.

            Время complexity: O(n)

    ***********************************************************************/

    private final ХэшКарта очисть (бул все)
    {
        измени;

        // собери each узел if we can't собери все at once
        if (куча.собери(все) is нет)
            foreach (v; таблица)
            while (v)
            {
                auto n = v.следщ;
                декремент (v);
                v = n;
            }

        // retain таблица, but удали bucket chains
        foreach (ref v; таблица)
        v = пусто;

        счёт = 0;
        return this;
    }

    /***********************************************************************

            new элемент was добавьed

    ***********************************************************************/

    private проц инкремент ()
    {
        ++мутация;
        ++счёт;
    }

    /***********************************************************************

            элемент was removed

    ***********************************************************************/

    private проц декремент (Реф p)
    {
        Извл (p.ключ, p.значение);
        куча.собери (p);
        ++мутация;
        --счёт;
    }

    /***********************************************************************

            установи was изменён

    ***********************************************************************/

    private проц измени ()
    {
        ++мутация;
    }

    /***********************************************************************

            Обходчик with no filtering

    ***********************************************************************/

    private struct Обходчик
    {
        т_мера  ряд;
        Реф     ячейка,
        приор;
        Реф[]   таблица;
        ХэшКарта хозяин;
        т_мера  мутация;

        /***************************************************************

                Dопр the container change underneath us?

        ***************************************************************/

        бул действителен ()
        {
            return хозяин.мутация is мутация;
        }

        /***************************************************************

                Accesses the следщ значение, и returns нет when
                there are no further значения в_ traverse

        ***************************************************************/

        бул следщ (ref K k, ref V v)
        {
            auto n = следщ (k);
            return (n) ? v = *n, да : нет;
        }

        /***************************************************************

                Return a pointer в_ the следщ значение, or пусто when
                there are no further значения в_ traverse

        ***************************************************************/

        V* следщ (ref K k)
        {
            while (ячейка is пусто)
                if (ряд < таблица.length)
                    ячейка = таблица [ряд++];
                else
                    return пусто;

            приор = ячейка;
            k = ячейка.ключ;
            ячейка = ячейка.следщ;
            return &приор.значение;

        }

        /***************************************************************

                Foreach support

        ***************************************************************/

        цел opApply (цел delegate(ref K ключ, ref V значение) дг)
        {
            цел результат;

            auto c = ячейка;
loop:
            while (да)
            {
                while (c is пусто)
                    if (ряд < таблица.length)
                        c = таблица [ряд++];
                    else
                        break loop;

                приор = c;
                c = c.следщ;
                if ((результат = дг(приор.ключ, приор.значение)) != 0)
                    break loop;
            }

            ячейка = c;
            return результат;
        }

        /***************************************************************

                Удали значение at the текущ обходчик location

        ***************************************************************/

        бул удали ()
        {
            if (приор)
                if (хозяин.удалиУзел (приор, &таблица[ряд-1]))
                {
                    // ignore this change
                    ++мутация;
                    return да;
                }

            приор = пусто;
            return нет;
        }
    }
}


/*******************************************************************************

*******************************************************************************/

debug (ХэшКарта)
{
    import io.Stdout;
    import time.StopWatch;

    проц main()
    {
        // usage examples ...
        auto карта = new ХэшКарта!(ткст, цел);
        карта.добавь ("foo", 1);
        карта.добавь ("bar", 2);
        карта.добавь ("wumpus", 3);

        // implicit генерный iteration
        foreach (ключ, значение; карта)
        Стдвыв.форматнс ("{}:{}", ключ, значение);

        // явный генерный iteration
        foreach (ключ, значение; карта.обходчик)
        Стдвыв.форматнс ("{}:{}", ключ, значение);

        // генерный iteration with optional удали
        auto s = карта.обходчик;
        foreach (ключ, значение; s)
        {} // s.удали;

        // incremental iteration, with optional удали
        ткст k;
        цел    v;
        auto обходчик = карта.обходчик;
        while (обходчик.следщ(k, v))
        {} //обходчик.удали;

        // incremental iteration, with optional failfast
        auto it = карта.обходчик;
        while (it.действителен && it.следщ(k, v))
        {}

        // удали specific элемент
        карта.удалиКлюч ("wumpus");

        // удали первый элемент ...
        while (карта.возьми(v))
            Стдвыв.форматнс ("taking {}, {} left", v, карта.размер);

        // установи for benchmark, with a установи of целыйs. We
        // use a чанк разместитель, и presize the bucket[]
        auto тест = new ХэшКарта!(цел, цел);//, Контейнер.хэш, Контейнер.извлеки, Контейнер.ЧанкСМ);
        тест.корзины(1_500_000);//.кэш(8000, 1000000);
        const счёт = 1_000_000;
        Секундомер w;

        смСобери;
        тест.проверь;

        // benchmark добавим
        w.старт;
        for (цел i=счёт; i--;)
            тест.добавь(i, i);
        Стдвыв.форматнс ("{} добавьs: {}/s", тест.размер, тест.размер/w.stop);

        // benchmark reading
        w.старт;
        for (цел i=счёт; i--;)
            тест.получи(i, v);
        Стдвыв.форматнс ("{} lookups: {}/s", тест.размер, тест.размер/w.stop);

        // benchmark добавим without allocation overhead
        тест.очисть;
        w.старт;
        for (цел i=счёт; i--;)
            тест.добавь(i, i);
        Стдвыв.форматнс ("{} добавьs (after очисть): {}/s", тест.размер, тест.размер/w.stop);

        // benchmark duplication
        w.старт;
        auto dup = тест.dup;
        Стдвыв.форматнс ("{} элемент dup: {}/s", dup.размер, dup.размер/w.stop);

        // benchmark iteration
        w.старт;
        foreach (ключ, значение; тест) {}
        Стдвыв.форматнс ("{} элемент iteration: {}/s", тест.размер, тест.размер/w.stop);

        смСобери;
        тест.проверь;
        /+
        auto aa = new ХэшКарта!(дол, цел, Контейнер.хэш, Контейнер.извлеки, Контейнер.Чанк);
        aa.корзины(7_500_000).кэш(100000, 5_000_000);
        w.старт;
        for (цел i=5_000_000; i--;)
            aa.добавь (i, 0);
        Стдвыв.форматнс ("{} тест iteration: {}/s", aa.размер, aa.размер/w.stop);
        +/
    }
}
