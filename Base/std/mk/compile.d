import dinrus, cidrus: выход;


void main()
{
сис("del compile.obj");
scope флы = списпап("d:\\dinrus\\dev\\DINRUS\\Base\\std", "*.d"); 
    foreach (ф; флы)
	{
		if(ф != "d:\\dinrus\\dev\\DINRUS\\Base\\std\\mk\\compile.d")
		{
		сис("%DINRUS%\\dmd -c "~ф);	
		скажифнс("Попытка компилировать модуль: "~ф);
		}
		else 
		{
		нс;
		скажифнс("Пропуск модуля: "~ф);
		нс;
		сис("del d:\\dinrus\\dev\\DINRUS\\Base\\std\\mk\\compile.obj");
			Процессор процессор;
			скажинс(процессор.вТкст());
			нс;			
		}
	}
	сис("%DINRUS%\\ls2 -d *.obj>>objs.rsp");
	сис("%DINRUS%\\dmd -lib -ofDinrusStd.lib @objs.rsp");
	сис("del *.map *.obj *.rsp");	
	нс;
	таб;
	скажинс("ГОТОВО! Создана библиотека DinrusStd.lib");
	выход(0);

	 
}


