module tstrandom;

private import runtime,linalg.random, win, stdrus: пз;

extern(C) проц выход(цел);

проц тест1()
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


проц тест2()
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


проц тест3()
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


проц тест4()
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

проц main()
{
тест1();
тест2();
тест3();
тест4();
	скажинс("Тест удачно пройден");
	пз;
	выход(0);
	
}