/*******************************************************************************

        copyright:      Copyright (c) 2008 Steven Schveighoffer. 
                        все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Jun 2008: Initial release

        author:         schveiguy

*******************************************************************************/

module io.device.ThreadPipe;

private import exception;

private import io.device.Conduit;

private import core.sync.Condition;

/**
 * Провод в_ support a данные поток between 2 threads.  One creates a
 * ThreadPИПe, then uses the ИПотокВывода and the ИПотокВвода из_ it в_
 * communicate.  все traffic is automatically synchronized, so one just uses
 * the Потокs like they were нормаль устройство Потокs.
 *
 * It works by maintaining a circular буфер, where данные is записано в_, and
 * читай из_, in a FIFO fashion.
 * -----------
 * auto tc = new ThreadPИПe;
 * проц outFunc()
 * {
 *   Стдвыв.копируй(tc.ввод);
 * }
 *
 * auto t = new Нить(&outFunc);
 * t.старт();
 * tc.пиши("hello, нить!");
 * tc.закрой();
 * t.объедини();
 */
class ThreadPИПe : Провод
{
    private бул _closed;
    private т_мера _readIdx, _remaining;
    private проц[] _buf;
    private Стопор _mutex;
    private Условие _condition;

    /**
     * Create a new ThreadPИПe with the given буфер размер.
     *
     * Параметры:
     * размерБуфера = the размер в_ размести the буфер. 
     */
    this(т_мера размерБуфера=(1024*16))
    {
        _buf = new ббайт[размерБуфера];
        _closed = нет;
        _readIdx = _remaining = 0;
        _mutex = new Стопор;
        _condition = new Условие(_mutex);
    }

    /**
     * Implements ИПровод.размерБуфера
     *
     * Returns the appropriate буфер размер that should be used в_ буфер the
     * ThreadPИПe.  Note that this is simply the буфер размер passed in, and
     * since все the ThreadPИПe данные is in память, buffering doesn't сделай
     * much sense.
     */
    т_мера размерБуфера()
    {
        return _buf.length;
    }

    /**
     * Implements ИПровод.вТкст
     *
     * Returns "&lt;нить провод&gt;"
     */
    ткст вТкст()
    {
        return "<threadpИПe>";
    }

    /**
     * Returns да if there is данные left в_ be читай, and the пиши конец isn't
     * закрыт.
     */
    override бул жив_ли()
    {
        synchronized(_mutex)
        {
            return !_closed || _remaining != 0;
        }
    }

    /**
     * Return the число of байты remaining в_ be читай in the circular буфер
     */
    т_мера remaining()
    {
        synchronized(_mutex)
            return _remaining;
    }

    /**
     * Return the число of байты that can be записано в_ the circular буфер
     */
    т_мера записываемый()
    {
        synchronized(_mutex)
            return _buf.length - _remaining;
    }

    /**
     * Close the пиши конец of the провод.  Writing в_ the провод after it is
     * закрыт will return Кф.
     *
     * The читай конец is not закрыт until the буфер is пустой.
     */
    проц stop()
    {
        //
        // закрой пиши конец.  The читай конец can stay открой until the remaining
        // байты are читай.
        //
        synchronized(_mutex)
        {
            _closed = да;
            _condition.сообщиВсе();
        }
    }

    /**
     * This does nothing because we have no clue whether the члены have been
     * collected, and открепи is run in the destructor.  To stop communications,
     * use stop().
     *
     * TODO: перемести stop() functionality в_ открепи when it becomes possible в_
     * have fully-owned члены
     */
    проц открепи()
    {
    }

    /**
     * Implements ИПотокВвода.читай
     *
     * Чтен из_ the провод преобр_в a мишень Массив.  The provопрed приёмн will be
     * populated with контент из_ the поток.
     *
     * Returns the число of байты читай, which may be less than requested in
     * приёмн. Кф is returned whenever an конец-of-flow condition arises.
     */
    т_мера читай(проц[] приёмн)
    {
        //
        // don't block for пустой читай
        //
        if(приёмн.length == 0)
            return 0;
        synchronized(_mutex)
        {
            //
            // see if any remaining данные is present
            //
            т_мера r;
            while((r = _remaining) == 0 && !_closed)
                _condition.жди();

            //
            // читай все данные that is available
            //
            if(r == 0)
                return Кф;
            if(r > приёмн.length)
                r = приёмн.length;

            auto результат = r;

            //
            // укз wrapping
            //
            if(_readIdx + r >= _buf.length)
            {
                т_мера x = _buf.length - _readIdx;
                приёмн[0..x] = _buf[_readIdx..$];
                _readIdx = 0;
                _remaining -= x;
                r -= x;
                приёмн = приёмн[x..$];
            }

            приёмн[0..r] = _buf[_readIdx..(_readIdx + r)];
            _readIdx = (_readIdx + r) % _buf.length;
            _remaining -= r;
            _condition.сообщиВсе();
            return результат;
        }
    }

    /**
     * Implements ИПотокВвода.сотри()
     *
     * Clear any buffered контент
     */
    ThreadPИПe сотри()
    {
        synchronized(_mutex)
        {
            if(_remaining != 0)
            {
                /*
                 * this isn't technically necessary, but we do it because it
                 * preserves the most recent данные first
                 */
                _readIdx = (_readIdx + _remaining) % _buf.length;
                _remaining = 0;
                _condition.сообщиВсе();
            }
        }
        return this;
    }

    /**
     * Implements ИПотокВывода.пиши
     *
     * Write в_ поток из_ a источник Массив. The provопрed ист контент will be
     * записано в_ the поток.
     *
     * Returns the число of байты записано из_ ист, which may be less than
     * the quantity provопрed. Кф is returned when an конец-of-flow condition
     * arises.
     */
    т_мера пиши(проц[] ист)
    {
        //
        // don't block for пустой пиши
        //
        if(ист.length == 0)
            return 0;
        synchronized(_mutex)
        {
            т_мера w;
            while((w = _buf.length - _remaining) == 0 && !_closed)
                _condition.жди();

            if(_closed)
                return Кф;

            if(w > ист.length)
                w = ист.length;

            auto writeIdx = (_readIdx + _remaining) % _buf.length;

            auto результат = w;

            if(w + writeIdx >= _buf.length)
            {
                auto x = _buf.length - writeIdx;
                _buf[writeIdx..$] = ист[0..x];
                writeIdx = 0;
                w -= x;
                _remaining += x;
                ист = ист[x..$];
            }
            _buf[writeIdx..(writeIdx + w)] = ист[0..w];
            _remaining += w;
            _condition.сообщиВсе();
            return результат;
        }
    }
}

debug(UnitTest)
{
    import thread;

    unittest
    {
        бцел[] источник = new бцел[1000];
        foreach(i, ref x; источник)
            x = i;

        ThreadPИПe tp = new ThreadPИПe(16);
        проц threadA()
        {
            проц[] sourceBuf = источник;
            while(sourceBuf.length > 0)
            {
                sourceBuf = sourceBuf[tp.пиши(sourceBuf)..$];
            }
            tp.stop();
        }
        Нить a = new Нить(&threadA);
        a.старт();
        цел readval;
        цел последний = -1;
        т_мера nread;
        while((nread = tp.читай((&readval)[0..1])) == readval.sizeof)
        {
            assert(readval == последний + 1);
            последний = readval;
        }
        assert(nread == tp.Кф);
        a.объедини();
    }
}
