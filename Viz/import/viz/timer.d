﻿//Автор Кристофер Миллер. Переработано для Динрус Виталием Кулич.
//Библиотека визуальных конпонентов VIZ (первоначально DFL).


module viz.timer;

private import viz.common, viz.app;


extern(D) class Таймер
{

	Событие!(Таймер, АргиСоб) тик; 	
	
	проц включен(бул on);
	бул включен();
	final проц интервал(т_мера timeout);
	final т_мера интервал();
	final проц старт();
	final проц стоп();
	this();
	this(проц delegate(Таймер) дг);
	this(проц delegate(Объект, АргиСоб) дг);
	this(проц delegate(Таймер, АргиСоб) дг);
	~this();
	protected:	
	проц вымести();
	проц наТик(АргиСоб ea);
}

