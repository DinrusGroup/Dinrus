/*********************************************************
   Copyright: (C) 2008 by Steven Schveighoffer.
              All rights reserved

   License: $(LICENSE)

   This is a collection of useful iterators, и обходчик
   functions.
**********************************************************/
module col.Iterators;

public import col.model.Iterator;

/**
 * This обходчик transforms every элемент from another обходчик using a
 * transformation function.
 */
class ТрансформОбходчик(V, U=V) : Обходчик!(V)
{
    private Обходчик!(U) _ист;
    private проц delegate(ref U, ref V) _дг;
    private проц function(ref U, ref V) _фн;

    /**
     * Construct a transform обходчик using a transform delegate.
     *
     * The transform function transforms a type U object into a type V object.
     */
    this(Обходчик!(U) исток, проц delegate(ref U, ref V) дг)
    {
        _ист = исток;
        _дг = дг;
    }

    /**
     * Construct a transform обходчик using a transform function pointer.
     *
     * The transform function transforms a type U object into a type V object.
     */
    this(Обходчик!(U) исток, проц function(ref U, ref V) фн)
    {
        _ист = исток;
        _фн = фн;
    }

    /**
     * Returns the длина that the исток provides.
     */
    бцел длина()
    {
        return _ист.length;
    }
	alias длина length;
    /**
     * Iterate through the исток обходчик, working with temporary copies of a
     * transformed V элемент.
     */
    цел opApply(цел delegate(ref V v) дг)
    {
        цел privateDG(ref U u)
        {
            V v;
            _дг(u, v);
            return дг(v);
        }

        цел privateFN(ref U u)
        {
            V v;
            _фн(u, v);
            return дг(v);
        }

        if(_дг is пусто)
            return _ист.opApply(&privateFN);
        else
            return _ист.opApply(&privateDG);
    }
}

/**
 * Transform for a keyed обходчик
 */
class ТрансформКлючник(K, V, J=K, U=V) : Ключник!(K, V)
{
    private Ключник!(J, U) _ист;
    private проц delegate(ref J, ref U, ref K, ref V) _дг;
    private проц function(ref J, ref U, ref K, ref V) _фн;

    /**
     * Construct a transform обходчик using a transform delegate.
     *
     * The transform function transforms a J, U пара into a K, V пара.
     */
    this(Ключник!(J, U) исток, проц delegate(ref J, ref U, ref K, ref V) дг)
    {
        _ист = исток;
        _дг = дг;
    }

    /**
     * Construct a transform обходчик using a transform function pointer.
     *
     * The transform function transforms a J, U пара into a K, V пара.
     */
    this(Ключник!(J, U) исток, проц function(ref J, ref U, ref K, ref V) фн)
    {
        _ист = исток;
        _фн = фн;
    }

    /**
     * Returns the длина that the исток provides.
     */
    бцел длина()
    {
        return _ист.length;
    }
	alias длина length;

    /**
     * Iterate through the исток обходчик, working with temporary copies of a
     * transformed V элемент.  Note that K can be пропущен if this is the only
     * use for the обходчик.
     */
    цел opApply(цел delegate(ref V v) дг)
    {
        цел privateDG(ref J j, ref U u)
        {
            K k;
            V v;
            _дг(j, u, k, v);
            return дг(v);
        }

        цел privateFN(ref J j, ref U u)
        {
            K k;
            V v;
            _фн(j, u, k, v);
            return дг(v);
        }

        if(_дг is пусто)
            return _ист.opApply(&privateFN);
        else
            return _ист.opApply(&privateDG);
    }

    /**
     * Iterate through the исток обходчик, working with temporary copies of a
     * transformed K,V пара.
     */
    цел opApply(цел delegate(ref K k, ref V v) дг)
    {
        цел privateDG(ref J j, ref U u)
        {
            K k;
            V v;
            _дг(j, u, k, v);
            return дг(k, v);
        }

        цел privateFN(ref J j, ref U u)
        {
            K k;
            V v;
            _фн(j, u, k, v);
            return дг(k, v);
        }

        if(_дг is пусто)
            return _ист.opApply(&privateFN);
        else
            return _ист.opApply(&privateDG);
    }
}

/**
 * A Chain обходчик chains several iterators together.
 */
class ОбходчикЦепи(V) : Обходчик!(V)
{
    private Обходчик!(V)[] _цепь;
    private бул _поддержкаДлины;

    /**
     * Constructor.  Pass in the iterators you wish to цепь together in the
     * order you wish them to be chained.
     *
     * If all of the iterators support длина, then this обходчик supports
     * длина.  If one doesn't, then the длина is not supported.
     */
    this(Обходчик!(V)[] цепь ...)
    {
        _цепь = цепь.dup;
        _поддержкаДлины = true;
        foreach(обх; _цепь)
            if(обх.length == ~0)
            {
                _поддержкаДлины = false;
                break;
            }
    }

    /**
     * Returns the sum of all the обходчик lengths in the цепь.
     *
     * returns ДЛИНА_НЕ_ПОДДЕРЖИВАЕТСЯ if a single обходчик in the цепь does not support
     * длина
     */
    бцел длина()
    {
        if(_поддержкаДлины)
        {
            бцел рез = 0;
            foreach(обх; _цепь)
                рез += обх.length;
            return рез;
        }
        return ДЛИНА_НЕ_ПОДДЕРЖИВАЕТСЯ;
    }
	alias длина length;
    /**
     * Iterate through the цепь of iterators.
     */
    цел opApply(цел delegate(ref V v) дг)
    {
        цел рез = 0;
        foreach(обх; _цепь)
        {
            if((рез = обх.opApply(дг)) != 0)
                break;
        }
        return рез;
    }
}

/**
 * A Chain обходчик chains several iterators together.
 */
class КлючникЦепи(K, V) : Ключник!(K, V)
{
    private Ключник!(K, V)[] _цепь;
    private бул _поддержкаДлины;

    /**
     * Constructor.  Pass in the iterators you wish to цепь together in the
     * order you wish them to be chained.
     *
     * If all of the iterators support длина, then this обходчик supports
     * длина.  If one doesn't, then the длина is not supported.
     */
    this(Ключник!(K, V)[] цепь ...)
    {
        _цепь = цепь.dup;
        _поддержкаДлины = true;
        foreach(обх; _цепь)
            if(обх.length == ДЛИНА_НЕ_ПОДДЕРЖИВАЕТСЯ)
            {
                _поддержкаДлины = false;
                break;
            }
    }

    /**
     * Returns the sum of all the обходчик lengths in the цепь.
     *
     * returns ДЛИНА_НЕ_ПОДДЕРЖИВАЕТСЯ if any iterators in the цепь return -1 for длина
     */
    бцел длина()
    {
        if(_поддержкаДлины)
        {
            бцел рез = 0;
            foreach(обх; _цепь)
                рез += обх.length;
            return рез;
        }
        return ДЛИНА_НЕ_ПОДДЕРЖИВАЕТСЯ;
    }
	alias длина length;
    /**
     * Iterate through the цепь of iterators using значения only.
     */
    цел opApply(цел delegate(ref V v) дг)
    {
        цел рез = 0;
        foreach(обх; _цепь)
        {
            if((рез = обх.opApply(дг)) != 0)
                break;
        }
        return рез;
    }

    /**
     * Iterate through the цепь of iterators using ключи и значения.
     */
    цел opApply(цел delegate(ref K, ref V) дг)
    {
        цел рез = 0;
        foreach(обх; _цепь)
        {
            if((рез = обх.opApply(дг)) != 0)
                break;
        }
        return рез;
    }
}

/**
 * A Filter обходчик filters out unwanted элементы based on a function or
 * delegate.
 */
class ФильтрОбходчик(V) : Обходчик!(V)
{
    private Обходчик!(V) _ист;
    private бул delegate(ref V) _дг;
    private бул function(ref V) _фн;

    /**
     * Construct a filter обходчик with the given delegate deciding whether an
     * элемент will be iterated or not.
     *
     * The delegate should return true for элементы that should be iterated.
     */
    this(Обходчик!(V) исток, бул delegate(ref V) дг)
    {
        _ист = исток;
        _дг = дг;
    }

    /**
     * Construct a filter обходчик with the given function deciding whether an
     * элемент will be iterated or not.
     *
     * the function should return true for элементы that should be iterated.
     */
    this(Обходчик!(V) исток, бул function(ref V) фн)
    {
        _ист = исток;
        _фн = фн;
    }

    /**
     * Returns ДЛИНА_НЕ_ПОДДЕРЖИВАЕТСЯ
     */
    бцел длина()
    {
        //
        // cannot know что the filter delegate/function will decide.
        //
        return ДЛИНА_НЕ_ПОДДЕРЖИВАЕТСЯ;
    }
	alias длина length;
    /**
     * Iterate through the исток обходчик, only accepting элементы where the
     * delegate/function returns true.
     */
    цел opApply(цел delegate(ref V v) дг)
    {
        цел privateDG(ref V v)
        {
            if(_дг(v))
                return дг(v);
            return 0;
        }

        цел privateFN(ref V v)
        {
            if(_фн(v))
                return дг(v);
            return 0;
        }

        if(_дг is пусто)
            return _ист.opApply(&privateFN);
        else
            return _ист.opApply(&privateDG);
    }
}

/**
 * A Filter обходчик filters out unwanted элементы based on a function or
 * delegate.  This version filters on a keyed обходчик.
 */
class ФильтрКлючник(K, V) : Ключник!(K, V)
{
    private Ключник!(K, V) _ист;
    private бул delegate(ref K, ref V) _дг;
    private бул function(ref K, ref V) _фн;

    /**
     * Construct a filter обходчик with the given delegate deciding whether a
     * ключ/значение пара will be iterated or not.
     *
     * The delegate should return true for элементы that should be iterated.
     */
    this(Ключник!(K, V) исток, бул delegate(ref K, ref V) дг)
    {
        _ист = исток;
        _дг = дг;
    }

    /**
     * Construct a filter обходчик with the given function deciding whether a
     * ключ/значение пара will be iterated or not.
     *
     * the function should return true for элементы that should be iterated.
     */
    this(Ключник!(K, V) исток, бул function(ref K, ref V) фн)
    {
        _ист = исток;
        _фн = фн;
    }

    /**
     * Returns ДЛИНА_НЕ_ПОДДЕРЖИВАЕТСЯ
     */
    бцел длина()
    {
        //
        // cannot know что the filter delegate/function will decide.
        //
        return ДЛИНА_НЕ_ПОДДЕРЖИВАЕТСЯ;
    }
	alias длина length;
    /**
     * Iterate through the исток обходчик, only iterating элементы where the
     * delegate/function returns true.
     */
    цел opApply(цел delegate(ref V v) дг)
    {
        цел privateDG(ref K k, ref V v)
        {
            if(_дг(k, v))
                return дг(v);
            return 0;
        }

        цел privateFN(ref K k, ref V v)
        {
            if(_фн(k, v))
                return дг(v);
            return 0;
        }

        if(_дг is пусто)
            return _ист.opApply(&privateFN);
        else
            return _ист.opApply(&privateDG);
    }

    /**
     * Iterate through the исток обходчик, only iterating элементы where the
     * delegate/function returns true.
     */
    цел opApply(цел delegate(ref K k, ref V v) дг)
    {
        цел privateDG(ref K k, ref V v)
        {
            if(_дг(k, v))
                return дг(k, v);
            return 0;
        }

        цел privateFN(ref K k, ref V v)
        {
            if(_фн(k, v))
                return дг(k, v);
            return 0;
        }

        if(_дг is пусто)
            return _ист.opApply(&privateFN);
        else
            return _ист.opApply(&privateDG);
    }
}

/**
 * Simple обходчик wrapper for an массив.
 */
class ОбходчикМассива(V) : Обходчик!(V)
{
    private V[] _массив;

    /**
     * Wrap a given массив.  Note that this does not make a копируй.
     */
    this(V[] массив)
    {
        _массив = массив;
    }
	
    /**
     * Returns the массив длина
     */
    бцел длина()
    {
        return _массив.length;
    }
	alias длина length;
	
    /**
     * Iterate over the массив.
     */
    цел opApply(цел delegate(ref V) дг)
    {
        цел возврзнач = 0;
        foreach(ref x; _массив)
            if((возврзнач = дг(x)) != 0)
                break;
        return возврзнач;
    }
}

/**
 * Wrapper обходчик for an associative массив
 */
class ОбходчикАМ(K, V) : Ключник!(K, V)
{
    private V[K] _массив;

    /**
     * Construct an обходчик wrapper for the given массив
     */
    this(V[K] массив)
    {
        _массив = массив;
    }

    /**
     * Returns the длина of the wrapped AA
     */
    бцел длина()
    {
        return _массив.length;// || _массив.length;
    }

	alias длина length;
    /**
     * Iterate over the AA
     */
    цел opApply(цел delegate(ref K, ref V) дг)
    {
        цел возврзнач;
        foreach(k, ref v; _массив)
            if((возврзнач = дг(k, v)) != 0)
                break;
        return возврзнач;
    }
}

/**
 * Function that converts an обходчик to an массив.
 *
 * More optimized for iterators that support a длина.
 */
V[] вМассив(V)(Обходчик!(V) обх)
{
    V[] рез;
    бцел длин = обх.length;
    if(длин != ДЛИНА_НЕ_ПОДДЕРЖИВАЕТСЯ)
    {
        //
        // can optimize a bit
        //
        рез.length = длин;
        цел i = 0;
        foreach(v; обх)
            рез[i++] = v;
    }
    else
    {
        foreach(v; обх)
            рез ~= v;
    }
    return рез;
}

/**
 * Convert a keyed обходчик to an associative массив.
 */
V[K] вАМ(K, V)(Ключник!(K, V) обх)
{
    V[K] рез;
    foreach(k, v; обх)
        рез[k] = v;
    return рез;
}
