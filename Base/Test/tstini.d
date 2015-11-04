import ini, stdrus;
void main()
{

	ткст инифайл = "unittest.ini";
	Ини ини;
	скажинс("Проверка работы ини");	
	ини = new Ини(инифайл);
	with(ини.добавьРаздел("foo"))
	{
		значение("asdf", "jkl");
		значение("bar", "wee!");
		значение("hi", "hello");
	}
	ини.добавьРаздел("BAR");
	with(ини.добавьРаздел("fOO"))
	{
		значение("yes", "no");
	}
	with(ини.добавьРаздел("Hello"))
	{
		значение("world", "yes");
	}
	with(ини.добавьРаздел("test"))
	{
		значение("1", "2");
		значение("3", "4");
	}
	ини["test"]["value"] = "yes";
	assert(ини["Foo"]["yes"] == "no");
	ини.сохрани();
	скажинс("ок");
	delete ини;

	ини = new Ини(инифайл);
	assert(ини["FOO"]["Bar"] == "wee!");
	assert(ини["Foo"]["yes"] == "no");
	assert(ини["hello"]["world"] == "yes");
	assert(ини["FOO"]["Bar"] == "wee!");
	assert(ини["55"] is пусто);
	assert(ини["hello"]["Yes"] is пусто);
	
	ини.открой(инифайл);
	ини["bar"].удали("notta");
	ини["foo"].удали("bar");
	ини.удали("bar");
	assert(ини["bar"] is пусто);
	assert(ини["foo"] !is пусто);
	assert(ини["foo"]["bar"] is пусто);
	ини.удали("foo");
	assert(ини["foo"] is пусто);
	ини.сохрани();
	delete ини;
}


