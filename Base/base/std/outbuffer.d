module std.outbuffer;

private
{
    import std.string;
    import runtime;
    import cidrus;	
}

/*********************************************
 * OutBuffer provides a way to build up an array of bytes out
 * of raw data. It is useful for things like preparing an
 * array of bytes to write out to a file.
 * OutBuffer's byte order is the format native to the computer.
 * To control the byte order (endianness), use a class derived
 * from OutBuffer.
 */
export extern (D) class БуферВывода
{



ббайт данные[];
бцел смещение;

invariant
    {
	//say(format("this = %p, смещение = %x, данные.length = %u\n", this, смещение, данные.length));
	assert(смещение <= данные.length);
	assert(данные.length <= смЁмкость(данные.ptr));
    }

	export this()
    {
	//say("in OutBuffer constructor\n");
	}

export	ббайт[] вБайты() { return данные[0 .. смещение]; }

export	проц резервируй(бцел члобайт)
	in
	{
	    assert(смещение + члобайт >= смещение);
	}
	out
	{
	    assert(смещение + члобайт <= данные.length);
	    assert(данные.length <= смЁмкость(данные.ptr));
	}
	body
	{
	    if (данные.length < смещение + члобайт)
	    {
		данные.length = (смещение + члобайт) * 2;
		setTypeInfo(null, данные.ptr);
	    }
	}

 export   проц пиши(ббайт[] байты)
	{
	    резервируй(байты.length);
	    данные[смещение .. смещение + байты.length] = байты;
	    смещение += байты.length;
	}

  export  проц пиши(ббайт b)		/// ditto
	{
	    резервируй(ббайт.sizeof);
	    this.данные[смещение] = b;
	    смещение += ббайт.sizeof;
	}

  export  проц пиши(байт b) { пиши(cast(ббайт)b); }		/// ditto
 export   проц пиши(сим c) { пиши(cast(ббайт)c); }		/// ditto

 export   проц пиши(бкрат w)		/// ditto
    {
	резервируй(бкрат.sizeof);
	*cast(бкрат *)&данные[смещение] = w;
	смещение += бкрат.sizeof;
    }

  export  проц пиши(крат т) { пиши(cast(бкрат)т); }		/// ditto

  export  проц пиши(шим c)		/// ditto
    {
	резервируй(шим.sizeof);
	*cast(шим *)&данные[смещение] = c;
	смещение += шим.sizeof;
    }

  export  проц пиши(бцел w)		/// ditto
    {
	резервируй(бцел.sizeof);
	*cast(бцел *)&данные[смещение] = w;
	смещение += бцел.sizeof;
    }

  export  проц пиши(цел i) { пиши(cast(бцел)i); }		/// ditto

  export  проц пиши(бдол l)		/// ditto
    {
	резервируй(бдол.sizeof);
	*cast(бдол *)&данные[смещение] = l;
	смещение += бдол.sizeof;
    }

  export  проц пиши(дол l) { пиши(cast(бдол)l); }		/// ditto

   export проц пиши(плав f)		/// ditto
    {
	резервируй(плав.sizeof);
	*cast(плав *)&данные[смещение] = f;
	смещение += плав.sizeof;
    }

   export проц пиши(дво f)		/// ditto
    {
	резервируй(дво.sizeof);
	*cast(дво *)&данные[смещение] = f;
	смещение += дво.sizeof;
    }

  export  проц пиши(реал f)		/// ditto
    {
	резервируй(реал.sizeof);
	*cast(реал *)&данные[смещение] = f;
	смещение += реал.sizeof;
    }

   export проц пиши(ткст т)		/// ditto
    {
	пиши(cast(ббайт[])т);
    }

   export проц пиши(БуферВывода буф)		/// ditto
    {
	пиши(буф.вБайты());
    }

    /****************************************
     * Добавка члобайт of 0 to the internal буфер.
     */

  export  проц занули(бцел члобайт)
    {
	резервируй(члобайт);
	данные[смещение .. смещение + члобайт] = 0;
	смещение += члобайт;
    }

    /**********************************
     * 0-fill to align on power of 2 boundary.
     */

  export  проц расклад(бцел мера)
    in
    {
	assert(мера && (мера & (мера - 1)) == 0);
    }
    out
    {
	assert((смещение & (мера - 1)) == 0);
    }
    body
    {   бцел члобайт;

	члобайт = смещение & (мера - 1);
	if (члобайт)
	    занули(мера - члобайт);
    }

    /****************************************
     * Optimize common special case расклад(2)
     */

  export  проц расклад2()
    {
	if (смещение & 1)
	    пиши(cast(байт)0);
    }

    /****************************************
     * Optimize common special case расклад(4)
     */

   export проц расклад4()
    {
	if (смещение & 3)
	{   бцел члобайт = (4 - смещение) & 3;
	    занули(члобайт);
	}
    }

    /**************************************
     * Convert internal буфер to array of симs.
     */

   export ткст вТкст()
    {
	//эхо("БуферВывода.вТкст()\n");
	return cast(сим[])данные[0 .. смещение];
    }

    /*****************************************
     * Добавка output of C'т vprintf() to internal буфер.
     */

  export  проц ввыводф(ткст формат, спис_ва арги)
    {
	сим[128] буфер;
	сим* p;
	бцел psize;
	цел count;

	auto f = std.string.вТкст0(формат);
	p = буфер.ptr;
	psize = буфер.length;
	for (;;)
		{
			count = _vsnprintf(p,psize,f,арги);
			if (count != -1)
				break;
			psize *= 2;
			p = cast(сим *) cidrus.alloca(psize);	// буфер too small, try again with larger размер
		}
	пиши(p[0 .. count]);
    }

    /*****************************************
     * Добавка output of C'т эхо() to internal буфер.
     */

  export  проц выводф(ткст формат, ...)
    {
	спис_ва ap;
	ap = cast(спис_ва)&формат;
	ap += формат.sizeof;
	ввыводф(формат, ap);
    }

    /*****************************************
     * At смещение index целo буфер, создай члобайт of space by shifting upwards
     * all данные past index.
     */

  export  проц простели(бцел индекс, бцел члобайт)
	in
	{
	    assert(индекс <= смещение);
	}
	body
	{
	    резервируй(члобайт);

	    // This is an overlapping copy - should use memmove()
	    for (бцел i = смещение; i > индекс; )
	    {
		--i;
		данные[i + члобайт] = данные[i];
	    }
	    смещение += члобайт;
	}

	export ~this(){}
}

unittest
{
    //эхо("Starting OutBuffer test\n");

    БуферВывода buf = new БуферВывода();

    //эхо("buf = %p\n", buf);
    //эхо("buf.offset = %x\n", buf.offset);
    assert(buf.смещение == 0);
    buf.пиши("hello");
    buf.пиши(cast(byte)0x20);
    buf.пиши("world");
    buf.эхо(" %d", 6);
    //эхо("buf = '%.*s'\n", buf.toString());
    assert(cmp(buf.вТкст(), "hello world 6") == 0);
}
