module std.bitarray;
private import std.intrinsic;

export extern(D) struct МассивБит
{


    т_мера len;
    alias len длин;

    бцел* ptr;
	alias ptr укз;

    

	export т_мера разм()
	{
	return dim();
	}

    т_мера dim()
    {
	return (длин + 31) / 32;
    }

	export т_мера длина()
	{
	return cast(т_мера) length();
	}

    т_мера length()
    {
	return длин;
    }

	export проц длина(т_мера новдлин)
	{
	return length(новдлин);
	}

    проц length(т_мера новдлин)
    {
	if (новдлин != длин)
	{
	    т_мера старразм = разм();
	    т_мера новразм = (новдлин + 31) / 32;

	    if (новразм != старразм)
	    {
		// Create a fake array so we can use D'т realloc machinery
		бцел[] b = ptr[0 .. старразм];
		b.length = новразм;		// realloc
		ptr = b.ptr;
		if (новразм & 31)
		{   // Уст any pad bits to 0
		    ptr[новразм - 1] &= ~(~0 << (новразм & 31));
		}
	    }

	    длин = новдлин;
	}
    }

  export  бул opIndex(т_мера i)
    in
    {
	assert(i < длин);
    }
    body
    {
	return cast(бул)bt(ptr, i);
    }

    /** ditto */
   export бул opIndexAssign(бул b, т_мера i)
    in
    {
	assert(i < длин);
    }
    body
    {
	if (b)
	    bts(ptr, i);
	else
	    btr(ptr, i);
	return b;
    }


	export МассивБит дубль()
	 {
	 return dup();
	 }

    МассивБит dup()
    {
	МассивБит ba;

	бцел[] b = ptr[0 .. dim].dup;
	ba.длин = длин;
	ba.ptr = b.ptr;
	return ba;
    }

   export цел opApply(цел delegate(inout бул) дг)
    {
	цел результат;

	for (т_мера i = 0; i < длин; i++)
	{   бул b = opIndex(i);
	    результат = дг(b);
	    (*this)[i] = b;
	    if (результат)
		break;
	}
	return результат;
    }


   export цел opApply(цел delegate(inout т_мера, inout бул) дг)
    {
	цел результат;

	for (т_мера i = 0; i < длин; i++)
	{   бул b = opIndex(i);
	    результат = дг(i, b);
	    (*this)[i] = b;
	    if (результат)
		break;
	}
	return результат;
    }

	export МассивБит реверсни()
	{
	return  reverse();
	}

    МассивБит reverse()
	out (результат)
	{
	    assert(результат == *this);
	}
	body
	{
	    if (длин >= 2)
	    {
		бул t;
		т_мера lo, hi;

		lo = 0;
		hi = длин - 1;
		for (; lo < hi; lo++, hi--)
		{
		    t = (*this)[lo];
		    (*this)[lo] = (*this)[hi];
		    (*this)[hi] = t;
		}
	    }
	    return *this;
	}


	export МассивБит сортируй()
	{
	return sort();
	}

    МассивБит sort()
	out (результат)
	{
	    assert(результат == *this);
	}
	body
	{
	    if (длин >= 2)
	    {
		т_мера lo, hi;

		lo = 0;
		hi = длин - 1;
		while (1)
		{
		    while (1)
		    {
			if (lo >= hi)
			    goto Ldone;
			if ((*this)[lo] == да)
			    break;
			lo++;
		    }

		    while (1)
		    {
			if (lo >= hi)
			    goto Ldone;
			if ((*this)[hi] == нет)
			    break;
			hi--;
		    }

		    (*this)[lo] = нет;
		    (*this)[hi] = да;

		    lo++;
		    hi--;
		}
	    Ldone:
		;
	    }
	    return *this;
	}

    export цел opEquals(МассивБит a2)
    {   цел i;

	if (this.length != a2.length)
	    return 0;		// not equal
	байт *p1 = cast(байт*)this.ptr;
	байт *p2 = cast(байт*)a2.ptr;
	бцел n = this.length / 8;
	for (i = 0; i < n; i++)
	{
	    if (p1[i] != p2[i])
		return 0;		// not equal
	}

	ббайт маска;

	n = this.length & 7;
	маска = cast(ббайт)((1 << n) - 1);
	//prцелf("i = %d, n = %d, маска = %x, %x, %x\n", i, n, маска, p1[i], p2[i]);
	return (маска == 0) || (p1[i] & маска) == (p2[i] & маска);
    }

   export цел opCmp(МассивБит a2)
    {
	бцел длин;
	бцел i;

	длин = this.length;
	if (a2.length < длин)
	    длин = a2.length;
	ббайт* p1 = cast(ббайт*)this.ptr;
	ббайт* p2 = cast(ббайт*)a2.ptr;
	бцел n = длин / 8;
	for (i = 0; i < n; i++)
	{
	    if (p1[i] != p2[i])
		break;		// not equal
	}
	for (бцел j = i * 8; j < длин; j++)
	{   ббайт маска = cast(ббайт)(1 << j);
	    цел c;

	    c = cast(цел)(p1[i] & маска) - cast(цел)(p2[i] & маска);
	    if (c)
		return c;
	}
	return cast(цел)this.длин - cast(цел)a2.length;
    }

	export проц иниц(бул[] бм)
	{
	init(cast(бул[]) бм);
	}

    проц init(бул[] ba)
    {
	length = ba.length;
	foreach (i, b; ba)
	{
	    (*this)[i] = b;
	}
    }

	export проц иниц(проц[] в, т_мера члобит)
	{
	init(cast(проц[]) в, cast(т_мера) члобит);
	}

    проц init(проц[] v, т_мера numbits)
    in
    {
	assert(numbits <= v.length * 8);
	assert((v.length & 3) == 0);
    }
    body
    {
	ptr = cast(бцел*)v.ptr;
	длин = numbits;
    }

  export  проц[] opCast()
    {
	return cast(проц[])ptr[0 .. dim];
    }


  export  МассивБит opCom()
    {
	auto dim = this.dim();

	МассивБит результат;

	результат.length = длин;
	for (т_мера i = 0; i < dim; i++)
	    результат.ptr[i] = ~this.ptr[i];
	if (длин & 31)
	    результат.ptr[dim - 1] &= ~(~0 << (длин & 31));
	return результат;
    }

  export  МассивБит opAnd(МассивБит e2)
    in
    {
	assert(длин == e2.length);
    }
    body
    {
	auto dim = this.dim();

	МассивБит результат;

	результат.length = длин;
	for (т_мера i = 0; i < dim; i++)
	    результат.ptr[i] = this.ptr[i] & e2.ptr[i];
	return результат;
    }

    export МассивБит opOr(МассивБит e2)
    in
    {
	assert(длин == e2.length);
    }
    body
    {
	auto dim = this.dim();

	МассивБит результат;

	результат.length = длин;
	for (т_мера i = 0; i < dim; i++)
	    результат.ptr[i] = this.ptr[i] | e2.ptr[i];
	return результат;
    }

   export МассивБит opXor(МассивБит e2)
    in
    {
	assert(длин == e2.length);
    }
    body
    {
	auto dim = this.dim();

	МассивБит результат;

	результат.length = длин;
	for (т_мера i = 0; i < dim; i++)
	    результат.ptr[i] = this.ptr[i] ^ e2.ptr[i];
	return результат;
    }

  export  МассивБит opSub(МассивБит e2)
    in
    {
	assert(длин == e2.length);
    }
    body
    {
	auto dim = this.dim();

	МассивБит результат;

	результат.length = длин;
	for (т_мера i = 0; i < dim; i++)
	    результат.ptr[i] = this.ptr[i] & ~e2.ptr[i];
	return результат;
    }

   export МассивБит opAndAssign(МассивБит e2)
    in
    {
	assert(длин == e2.length);
    }
    body
    {
	auto dim = this.dim();

	for (т_мера i = 0; i < dim; i++)
	    ptr[i] &= e2.ptr[i];
	return *this;
    }

   export МассивБит opOrAssign(МассивБит e2)
    in
    {
	assert(длин == e2.length);
    }
    body
    {
	auto dim = this.dim();

	for (т_мера i = 0; i < dim; i++)
	    ptr[i] |= e2.ptr[i];
	return *this;
    }

   export МассивБит opXorAssign(МассивБит e2)
    in
    {
	assert(длин == e2.length);
    }
    body
    {
	auto dim = this.dim();

	for (т_мера i = 0; i < dim; i++)
	    ptr[i] ^= e2.ptr[i];
	return *this;
    }

   export МассивБит opSubAssign(МассивБит e2)
    in
    {
	assert(длин == e2.length);
    }
    body
    {
	auto dim = this.dim();

	for (т_мера i = 0; i < dim; i++)
	    ptr[i] &= ~e2.ptr[i];
	return *this;
    }

    export МассивБит opCatAssign(бул b)
    {
	length = длин + 1;
	(*this)[длин - 1] = b;
	return *this;
    }

   export МассивБит opCatAssign(МассивБит b)
    {
	auto istart = длин;
	length = длин + b.length;
	for (auto i = istart; i < длин; i++)
	    (*this)[i] = b[i - istart];
	return *this;
    }

   export МассивБит opCat(бул b)
    {
	МассивБит r;

	r = this.dup;
	r.length = длин + 1;
	r[длин] = b;
	return r;
    }

   export МассивБит opCat_r(бул b)
    {
	МассивБит r;

	r.length = длин + 1;
	r[0] = b;
	for (т_мера i = 0; i < длин; i++)
	    r[1 + i] = (*this)[i];
	return r;
    }

  export  МассивБит opCat(МассивБит b)
    {
	МассивБит r;

	r = this.dup();
	r ~= b;
	return r;
    }

}/////end of class

/*

МассивБит вМасБит(std.bitarray.BitArray ба)
	{
	МассивБит рез;
	рез.длин = ба.длин;
	рез.укз = ба.ptr;
	return  рез;
	}

BitArray изМасБита(МассивБит мб)
	{
	std.bitarray.BitArray рез;
	рез.длин = мб.длин;
	рез.ptr = мб.укз;
	return  рез;
	}

    unittest
    {
	debug(bitarray) эхо("BitArray.opCat unittest\n");

	static bool[] ba = [1,0];
	static bool[] bb = [0,1,0];

	BitArray a; a.init(ba);
	BitArray b; b.init(bb);
	BitArray c;

	c = (a ~ b);
	assert(c.length == 5);
	assert(c[0] == 1);
	assert(c[1] == 0);
	assert(c[2] == 0);
	assert(c[3] == 1);
	assert(c[4] == 0);

	c = (a ~ true);
	assert(c.length == 3);
	assert(c[0] == 1);
	assert(c[1] == 0);
	assert(c[2] == 1);

	c = (false ~ a);
	assert(c.length == 3);
	assert(c[0] == 0);
	assert(c[1] == 1);
	assert(c[2] == 0);
    }

*/