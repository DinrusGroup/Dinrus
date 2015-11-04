module linalg.random;

private import linalg.basic;

struct СлучДвиг48
{
	const static бцел мин = 0;
	const static бцел макс = бцел.max;

	/**
	Generates следщ pseudo-random number.
	Возвращает:
		Pseudo-random number in closed interval [this.мин; this.макс]
	*/
	бцел вынь()
	{
		x = (a * x + b) & маска;
		return x >> 16;
	}

	/**
	Reinitializes движок. Sets new _seed использован for pseudo-random number generation.

	If two different linear congruential engines are initialized with the same
	_seed they will generate equivalent pseudo-number sequences.
	Params:
		nx = Нов _seed использован for pseudo-random numbers generation.
	*/
	void сей(бдол nx)
	{
		x = nx & маска;
	}
	
	private:
		static const бдол a = 25214903917;
		static const бдол b = 1L;
		static const бдол m = 1uL << 48;
		static const бдол маска = m - 1;
		бдол x = 0;
}

unittest
{
	СлучДвиг48 e1;
	e1.сей = 12345;
	for (цел i = 0; i < 100; ++i)
		e1.вынь();
	
	СлучДвиг48 e2 = e1;

	// must generate the same sequence
	for (цел i = 0; i < 100; ++i)
		assert(e1.вынь() == e2.вынь());

	e1.сей = 54321;
	e2.сей = 54321;

	// must generate the same sequence
	for (цел i = 0; i < 100; ++i)
		assert(e1.вынь() == e2.вынь());
}

/*********************************************************************/
struct ДвигМерсенаТвистера
{
	static const бцел мин = 0;
	static const бцел макс = бцел.max;

	static const бцел n = 624;
	static const бцел m = 397;

	бцел вынь()
	{
		if (следщ >= n) // overflow, движок reload needed
		{
			бцел твист(бцел m, бцел u, бцел v)
			{
				return m ^ (((u & 0x8000_0000u) | (v & 0x7fff_ffffu)) >> 1) ^
					(-(u & 0x1u) & 0x9908_b0dfu);
			}

			бцел* p = s.ptr;
			
			for (цел i = n - m; i--; ++p)
				*p = твист( p[m], p[0], p[1] );

			for (цел i = m; --i; ++p)
				*p = твист( p[m - n], p[0], p[1] );

			*p = твист( p[m - n], p[0], s[0] );

			следщ = 0;
		}

		// use 'state.ptr[следщ]' instead of 'state[следщ]' to
		// suppress массив bound проверьs, namely performance penalty
		бцел x = s.ptr[следщ];
		++следщ;

		x ^= (x >> 11);
		x ^= (x <<  7) & 0x9d2c_5680u;
		x ^= (x << 15) & 0xefc6_0000u;
		return x ^ (x >> 18);
	}

	void сей(бцел x)
	{
		s[0] = x;
		for (цел i = 1; i < n; ++i)
			s[i] = 1_812_433_253u * (s[i-1] ^ (s[i-1] >> 30)) + i;

		следщ = 1;
	}

	private:
		бцел[n] s = void;
		бцел следщ = 0;		
}

unittest
{
	ДвигМерсенаТвистера e1;
	e1.сей = 12345;
	for (цел i = 0; i < 100; ++i)
		e1.вынь();
	
	ДвигМерсенаТвистера e2 = e1;

	// must generate the same sequence
	for (цел i = 0; i < 100; ++i)
		assert(e1.вынь() == e2.вынь());

	e1.сей = 54321;
	e2.сей = 54321;

	// must generate the same sequence
	for (цел i = 0; i < 100; ++i)
		assert(e1.вынь() == e2.вынь());
}

/********************************************************************/
struct ЮниформЮнитДвиг(ДвигОснова, бул слеваЗакрыт, бул справаЗакрыт)
{
	private ДвигОснова двигОснова;

	const static
	{
		реал мин = (слеваЗакрыт ? 0 : прирост) * (1/знаменатель);
		реал макс = (диапазон + (слеваЗакрыт ? 0 : прирост)) * (1/знаменатель);
	}

	private const static
	{
		реал диапазон = cast(реал)(двигОснова.макс - двигОснова.мин);
		реал прирост = (двигОснова.макс > бцел.макс) ? 2.L : 0.2L;
		реал знаменатель = диапазон + (слеваЗакрыт ? 0 : прирост) + (справаЗакрыт ? 0 : прирост);
	}

	реал вынь()
	{
		auto x = двигОснова.вынь();
		
		static if (
			is (typeof(двигОснова.вынь) : реал) && // base движок pops плав-type значения
			cast(реал)двигОснова.мин == this.мин &&
			cast(реал)двигОснова.макс == this.макс)
		{
			// no manipulations требуется, return value as is.
			return cast(реал)x;
		}
		else
		{
			return (cast(реал)(x - двигОснова.мин) + (слеваЗакрыт ? 0 : прирост)) * (1/знаменатель);
		}
	}

	void сей(бцел x)
	{
		двигОснова.сей = x;
	}
}

unittest
{
	alias ЮниформЮнитДвиг!(СлучДвиг48, true, true) полностьюЗакрыт;
	alias ЮниформЮнитДвиг!(СлучДвиг48, true, false) слеваЗакрыт;
	alias ЮниформЮнитДвиг!(СлучДвиг48, false, true) справаЗакрыт;
	alias ЮниформЮнитДвиг!(СлучДвиг48, false, false) полностьюОткрыт;

	static assert(полностьюЗакрыт.мин == 0.L);
	static assert(полностьюЗакрыт.макс == 1.L);

	static assert(слеваЗакрыт.мин == 0.L);
	static assert(слеваЗакрыт.макс < 1.L);
	
	static assert(справаЗакрыт.мин > 0.L);
	static assert(справаЗакрыт.макс == 1.L);

	static assert(полностьюОткрыт.мин > 0.L);
	static assert(полностьюОткрыт.макс < 1.L);
}

/********************************************************************/
struct ЮниформЮнитДвигХайреса(ДвигОснова, бул слеваЗакрыт, бул справаЗакрыт)
{
	private ДвигОснова двигОснова;

	static const
	{
		реал мин = (слеваЗакрыт ? 0 : прирост) * (1 / знаменатель);
		реал макс = (приблМакс + (слеваЗакрыт ? 0 : прирост)) * (1 / знаменатель);
	}

	private const static
	{
		реал приблМакс = бцел.max * 0x1p32 + бцел.max;
		реал прирост = 2.L;
		реал знаменатель = приблМакс + (слеваЗакрыт ? 0 : прирост) + (справаЗакрыт ? 0 : прирост);
	}

	реал вынь()
	{
		static if (
			is (typeof(двигОснова.вынь) : реал) && // base движок pops плав-type значения
			cast(реал)двигОснова.мин == this.мин &&
			cast(реал)двигОснова.макс == this.макс)
		{
			// no manipulations требуется, return value as is.
			return cast(реал)двигОснова.вынь();
		}
		else
		{
			// this is necessary condition to generate truly uniform
			// result. However it is possible to use base движок with any диапазон,
			// but this feature isn't implemented for now и can be introduced
			// in future.
			static assert( двигОснова.мин == 0 && двигОснова.макс == бцел.макс );

			бцел a = cast(бцел)двигОснова.вынь();
			бцел b = cast(бцел)двигОснова.вынь();
			return (a * 0x1p32 + b + (слеваЗакрыт ? 0 : прирост)) * (1 / знаменатель);
		}
	}

	void сей(бцел x)
	{
		двигОснова.сей = x;
	}
}

unittest
{
	alias ЮниформЮнитДвигХайреса!(СлучДвиг48, true, true) полностьюЗакрыт;
	alias ЮниформЮнитДвигХайреса!(СлучДвиг48, true, false) слеваЗакрыт;
	alias ЮниформЮнитДвигХайреса!(СлучДвиг48, false, true) справаЗакрыт;
	alias ЮниформЮнитДвигХайреса!(СлучДвиг48, false, false) полностьюОткрыт;

	static assert(полностьюЗакрыт.мин == 0.L);
	static assert(полностьюЗакрыт.макс == 1.L);

	static assert(слеваЗакрыт.мин == 0.L);
	static assert(слеваЗакрыт.макс < 1.L);
	
	static assert(справаЗакрыт.мин > 0.L);
	static assert(справаЗакрыт.макс == 1.L);

	static assert(полностьюОткрыт.мин > 0.L);
	static assert(полностьюОткрыт.макс < 1.L);
}
