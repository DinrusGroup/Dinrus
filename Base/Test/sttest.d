import st.stackcontext, st.stackthread, dinrus;


проц Тест()
{
    скажифнс("Тестируется создание/удаление контекста");
    цел s0 = 0;
    static цел s1 = 0;
    
    КонтекстСтэка a = new КонтекстСтэка(
    delegate проц()
    {
        s0++;
    });
    
    static проц fb() { s1++; }
    
    КонтекстСтэка b = new КонтекстСтэка(&fb);
    
    КонтекстСтэка c = new КонтекстСтэка(
        delegate проц() { assert(false); });
    
    assert(a);
    assert(b);
    assert(c);
    
    assert(s0 == 0);
    assert(s1 == 0);
    assert(a.дайСостояние == ПСостояниеКонтекста.Готов);
    assert(b.дайСостояние == ПСостояниеКонтекста.Готов);
    assert(c.дайСостояние == ПСостояниеКонтекста.Готов);
    
    delete c;
    
    assert(s0 == 0);
    assert(s1 == 0);
    assert(a.дайСостояние == ПСостояниеКонтекста.Готов);
    assert(b.дайСостояние == ПСостояниеКонтекста.Готов);
    
    скажифнс("выполняется a");
    a.пуск();
    скажифнс("a выполнен");
    
    assert(a);
    
    assert(s0 == 1);
    assert(s1 == 0);
    assert(a.дайСостояние == ПСостояниеКонтекста.Завершён);
    assert(b.дайСостояние == ПСостояниеКонтекста.Готов);    
    
    assert(b.дайСостояние == ПСостояниеКонтекста.Готов);
    
    скажифнс("Запускается b");
    b.пуск();
    скажифнс("b выполнен");
    
    assert(s0 == 1);
    assert(s1 == 1);
    assert(b.дайСостояние == ПСостояниеКонтекста.Завершён);
    
    delete a;
    delete b;
    
    скажифнс("Создание контекста пройдено");
}
    
проц Тест1()
{
    скажифнс("Тестируется переключение контекста");
    цел s0 = 0;
    цел s1 = 0;
    цел s2 = 0;
    
    КонтекстСтэка a = new КонтекстСтэка(
    delegate проц()
    {
        while(true)
        {
            debug скажифнс(" ---A---");
            s0++;
            КонтекстСтэка.жни();
        }
    });
    
    
    КонтекстСтэка b = new КонтекстСтэка(
    delegate проц()
    {
        while(true)
        {
            debug скажифнс(" ---B---");
            s1++;
            КонтекстСтэка.жни();
        }
    });
    
    
    КонтекстСтэка c = new КонтекстСтэка(
    delegate проц()
    {
        while(true)
        {
            debug скажифнс(" ---C---");
            s2++;
            КонтекстСтэка.жни();
        }
    });
    
    assert(a);
    assert(b);
    assert(c);
    assert(s0 == 0);
    assert(s1 == 0);
    assert(s2 == 0);
    
    a.пуск();
    b.пуск();
    
    assert(a);
    assert(b);
    assert(c);
    assert(s0 == 1);
    assert(s1 == 1);
    assert(s2 == 0);
    
    for(цел i=0; i<20; i++)
    {
        c.пуск();
        a.пуск();
    }
    
    assert(a);
    assert(b);
    assert(c);
    assert(s0 == 21);
    assert(s1 == 1);
    assert(s2 == 20);
    
    delete a;
    delete b;
    delete c;
    
    скажифнс("Переключение контекста пройдено");
}
    
проц Тест2()
{
    скажифнс("Тестируются гнездовые контексты");
    КонтекстСтэка a, b, c;
    
    цел t0 = 0;
    цел t1 = 0;
    цел t2 = 0;
    
    a = new КонтекстСтэка(
    delegate проц()
    {
        
        t0++;
        b.пуск();
        
    });
    
    b = new КонтекстСтэка(
    delegate проц()
    {
        assert(t0 == 1);
        assert(t1 == 0);
        assert(t2 == 0);
        
        t1++;
        c.пуск();
        
    });
    
    c = new КонтекстСтэка(
    delegate проц()
    {
        assert(t0 == 1);
        assert(t1 == 1);
        assert(t2 == 0);
        
        t2++;
    });
    
    assert(a);
    assert(b);
    assert(c);
    assert(t0 == 0);
    assert(t1 == 0);
    assert(t2 == 0);
    
    a.пуск();
    
    assert(t0 == 1);
    assert(t1 == 1);
    assert(t2 == 1);
    
    assert(a);
    assert(b);
    assert(c);
    
    delete a;
    delete b;
    delete c;
    
    скажифнс("Гнездовые контексты пройдены");
}

проц Тест3()
{
	скажифнс("Тескируются базовые исключения");


	цел t0 = 0;
	цел t1 = 0;
	цел t2 = 0;

	assert(t0 == 0);
	assert(t1 == 0);
	assert(t2 == 0);

	try
	{

		try
		{
			throw new Исключение("Проверка");
			t2++;
		}
		catch(Исключение fx)
		{
			t1++;
			throw fx;
		}
	
		t2++;
	}
	catch(Исключение ex)
	{
		t0++;
		ex.print;
	}

	assert(t0 == 1);
	assert(t1 == 1);
	assert(t2 == 0);

	скажифнс("Базовые исключения поддерживаются");
}


//Anonymous delegates are slightly broken on linux. Don't пуск this test yet,
//since dmd will break it.
version(Win32)
проц Тест4()
{
    скажифнс("Проверка исключений");
    КонтекстСтэка a, b, c;
    
    цел t0 = 0;
    цел t1 = 0;
    цел t2 = 0;
    
    скажифнс("t0 = %s\nt1 = %s\nt2 = %s", t0, t1, t2);
    
    a = new КонтекстСтэка(
    delegate проц()
    {
        t0++;
        throw new Исключение("Исключение A");
        t0++;
    });
    
    b = new КонтекстСтэка(
    delegate проц()
    {
        t1++;
        c.пуск();
        t1++;
    });
    
    c = new КонтекстСтэка(
    delegate проц()
    {
        t2++;
        throw new Исключение("Исключение C");
        t2++;
    });
    
    assert(a);
    assert(b);
    assert(c);
    assert(t0 == 0);
    assert(t1 == 0);
    assert(t2 == 0);
    
    try
    {
        a.пуск();
        assert(false);
    }
    catch(Исключение e)
    {
        e.print;
    }
    
    assert(a);
    assert(a.дайСостояние == ПСостояниеКонтекста.Завершён);
    assert(b);
    assert(c);
    assert(t0 == 1);
    assert(t1 == 0);
    assert(t2 == 0);
    
    try
    {
        b.пуск();
        assert(false);
    }
    catch(Исключение e)
    {
        e.print;
    }
    
    скажифнс("blah2");
    
    assert(a);
    assert(b);
    assert(b.дайСостояние == ПСостояниеКонтекста.Завершён);
    assert(c);
    assert(c.дайСостояние == ПСостояниеКонтекста.Завершён);
    assert(t0 == 1);
    assert(t1 == 1);
    assert(t2 == 1);

	delete a;
	delete b;
	delete c;
    

	КонтекстСтэка t;
	цел q0 = 0;
	цел q1 = 0;

	t = new КонтекстСтэка(
	delegate проц()
	{
		try
		{
			q0++;
			throw new Исключение("Исключение T");
			q0++;
		}
		catch(Исключение ex)
		{
			q1++;
			скажифнс("!!!!!!!!ПОЛУЧЕНО ИСКЛЮЧЕНИЕ!!!!!!!!");
			ex.print;
		}
	});


	assert(t);
	assert(q0 == 0);
	assert(q1 == 0);
	t.пуск();
	assert(t);
	assert(t.мёртв);
	assert(q0 == 1);
	assert(q1 == 1);

	delete t;
   
    КонтекстСтэка d, e;
    цел s0 = 0;
    цел s1 = 0;
    
    d = new КонтекстСтэка(
    delegate проц()
    {
        try
        {
            s0++;
            e.пуск();
            КонтекстСтэка.жни();
            s0++;
            e.пуск();
            s0++;
        }
        catch(Исключение ex)
        {
            ex.print;
        }
    });
    
    e = new КонтекстСтэка(
    delegate проц()
    {
        s1++;
        КонтекстСтэка.жни();
        throw new Исключение("Исключение Е");
        s1++;
    });
    
    assert(d);
    assert(e);
    assert(s0 == 0);
    assert(s1 == 0);
    
    d.пуск();
    
    assert(d);
    assert(e);
    assert(s0 == 1);
    assert(s1 == 1);
    
    d.пуск();
    
    assert(d);
    assert(e);
    assert(s0 == 2);
    assert(s1 == 1);
    
    assert(d.мёртв);
    assert(e.мёртв);
    
    delete d;
    delete e;
    
    скажифнс("Исключения пройдены");
}

проц Тест5()
{
    скажифнс("Проверяется перезапуск");
    цел t0 = 0;
    цел t1 = 0;
    цел t2 = 0;
    
    КонтекстСтэка a = new КонтекстСтэка(
    delegate проц()
    {
        t0++;
        КонтекстСтэка.жни();
        t1++;
        КонтекстСтэка.жни();
        t2++;
    });
    
    assert(a);
    assert(t0 == 0);
    assert(t1 == 0);
    assert(t2 == 0);
    
    a.пуск();
    assert(a);
    assert(t0 == 1);
    assert(t1 == 0);
    assert(t2 == 0);
    
    a.пуск();
    assert(a);
    assert(t0 == 1);
    assert(t1 == 1);
    assert(t2 == 0);
    
    a.пуск();
    assert(a);
    assert(t0 == 1);
    assert(t1 == 1);
    assert(t2 == 1);
    
    a.перезапуск();
    assert(a);
    assert(t0 == 1);
    assert(t1 == 1);
    assert(t2 == 1);
    
    a.пуск();
    assert(a);
    assert(t0 == 2);
    assert(t1 == 1);
    assert(t2 == 1);
    
    a.перезапуск();
    a.пуск();
    assert(a);
    assert(t0 == 3);
    assert(t1 == 1);
    assert(t2 == 1);
    
    a.пуск();
    assert(a);
    assert(t0 == 3);
    assert(t1 == 2);
    assert(t2 == 1);
    
    a.перезапуск();
    a.пуск();
    assert(a);
    assert(t0 == 4);
    assert(t1 == 2);
    assert(t2 == 1);
    
    delete a;
    
    скажифнс("Перезапуск пройден");
}
/+
//Same problem as above.  
version (Win32)
проц Тест6()
{
    скажифнс("Testing standard exceptions");
    цел t = 0;
    
    КонтекстСтэка a = new КонтекстСтэка(
    delegate проц()
    {
        бцел * tmp = пусто;
        
        *tmp = 0xbadc0de;
        
        t++;
    });
    
    assert(a);
    assert(t == 0);
    
    try
    {
        a.пуск();
        assert(false);
    }
    catch(Исключение e)
    {
        e.print();
    }
    
    assert(a);
    assert(a.мёртв);
    assert(t == 0);
    
    delete a;
    
    
    скажифнс("Standard exceptions passed");
}
+/
проц Тест7()
{
    скажифнс("Тест на стресс памяти");
    
    const бцел STRESS_SIZE = 5000;
    
    КонтекстСтэка конткст[];
    конткст.length = STRESS_SIZE;
    
    цел cnt0 = 0;
    цел cnt1 = 0;
    
    проц threadFunc()
    {
        cnt0++;
        КонтекстСтэка.жни;
        cnt1++;
    }
    
    foreach(inout КонтекстСтэка c; конткст)
    {
        c = new КонтекстСтэка(&threadFunc, МИН_РАЗМЕР_СТЕКА);
    }
    
    assert(cnt0 == 0);
    assert(cnt1 == 0);
    
    foreach(inout КонтекстСтэка c; конткст)
    {
        c.пуск;
    }
    
    assert(cnt0 == STRESS_SIZE);
    assert(cnt1 == 0);
    
    foreach(inout КонтекстСтэка c; конткст)
    {
        c.пуск;
    }
    
    assert(cnt0 == STRESS_SIZE);
    assert(cnt1 == STRESS_SIZE);
    
    foreach(inout КонтекстСтэка c; конткст)
    {
        delete c;
    }
    
    assert(cnt0 == STRESS_SIZE);
    assert(cnt1 == STRESS_SIZE);
    
    скажифнс("Тест на стресс памяти пройден");
}

проц Тест8()
{
    скажифнс("Testing floating point");
    
    float f0 = 1.0;
    float f1 = 0.0;
    
    double d0 = 2.0;
    double d1 = 0.0;
    
    real r0 = 3.0;
    real r1 = 0.0;
    
    assert(f0 == 1.0);
    assert(f1 == 0.0);
    assert(d0 == 2.0);
    assert(d1 == 0.0);
    assert(r0 == 3.0);
    assert(r1 == 0.0);
    
    КонтекстСтэка a, b, c;
    
    a = new КонтекстСтэка(
    delegate проц()
    {
        while(true)
        {
            f0 ++;
            d0 ++;
            r0 ++;
            
            КонтекстСтэка.жни();
        }
    });
    
    b = new КонтекстСтэка(
    delegate проц()
    {
        while(true)
        {
            f1 = d0 + r0;
            d1 = f0 + r0;
            r1 = f0 + d0;
            
            КонтекстСтэка.жни();
        }
    });
    
    c = new КонтекстСтэка(
    delegate проц()
    {
        while(true)
        {
            f0 *= d1;
            d0 *= r1;
            r0 *= f1;
            
            КонтекстСтэка.жни();
        }
    });
    
    a.пуск();
    assert(f0 == 2.0);
    assert(f1 == 0.0);
    assert(d0 == 3.0);
    assert(d1 == 0.0);
    assert(r0 == 4.0);
    assert(r1 == 0.0);
    
    b.пуск();
    assert(f0 == 2.0);
    assert(f1 == 7.0);
    assert(d0 == 3.0);
    assert(d1 == 6.0);
    assert(r0 == 4.0);
    assert(r1 == 5.0);
    
    c.пуск();
    assert(f0 == 12.0);
    assert(f1 == 7.0);
    assert(d0 == 15.0);
    assert(d1 == 6.0);
    assert(r0 == 28.0);
    assert(r1 == 5.0);
    
    a.пуск();
    assert(f0 == 13.0);
    assert(f1 == 7.0);
    assert(d0 == 16.0);
    assert(d1 == 6.0);
    assert(r0 == 29.0);
    assert(r1 == 5.0);
    
    скажифнс("Floating point passed");
}


version(x86) проц Тест9()
{
    скажифнс("Testing registers");
    
    struct registers
    {
        цел eax, ebx, ecx, edx;
        цел esi, edi;
        цел ebp, esp;
        
        //TODO: Add fpu stuff
    }
    
    static registers old;
    static registers next;
    static registers g_old;
    static registers g_next;
    
    //I believe that D calling convention требует that
    //EBX, ESI и EDI be saveauxd.  In order to validate
    //this, we пиши to those registers и call the
    //стэк threaauxd.
    static СтэкНить reg_test = new СтэкНить(
    delegate проц() 
    {
        asm
        {
            naked;
            
            pushad;
            
            mov EBX, 1;
            mov ESI, 2;
            mov EDI, 3;
            
            mov [old.ebx], EBX;
            mov [old.esi], ESI;
            mov [old.edi], EDI;
            mov [old.ebp], EBP;
            mov [old.esp], ESP;
            
            call СтэкНить.жни;
            
            mov [next.ebx], EBX;
            mov [next.esi], ESI;
            mov [next.edi], EDI;
            mov [next.ebp], EBP;
            mov [next.esp], ESP;
            
            popad;
        }
    });
    
    //Run the стэк контекст
    asm
    {
        naked;
        
        pushad;
        
        mov EBX, 10;
        mov ESI, 11;
        mov EDI, 12;
        
        mov [g_old.ebx], EBX;
        mov [g_old.esi], ESI;
        mov [g_old.edi], EDI;
        mov [g_old.ebp], EBP;
        mov [g_old.esp], ESP;
        
        mov EAX, [reg_test];
        call СтэкНить.пуск;
        
        mov [g_next.ebx], EBX;
        mov [g_next.esi], ESI;
        mov [g_next.edi], EDI;
        mov [g_next.ebp], EBP;
        mov [g_next.esp], ESP;
        
        popad;
    }
    
    
    //Make sure the registers are byte for byte equal.
    assert(old.ebx = 1);
    assert(old.esi = 2);
    assert(old.edi = 3);
    assert(old == next);
    
    assert(g_old.ebx = 10);
    assert(g_old.esi = 11);
    assert(g_old.edi = 12);
    assert(g_old == g_next);
    
    скажифнс("Registers passed!");
}


проц Тест10()
{
    скажифнс("Проверка бросьЖни");
    
    цел q0 = 0;
    
    КонтекстСтэка st0 = new КонтекстСтэка(
    delegate проц()
    {
        q0++;
        КонтекстСтэка.бросьЖни(new Исключение("проверяется бросьЖни"));
        q0++;
    });
    
    try
    {
        st0.пуск();
        assert(false);
    }
    catch(Исключение e)
    {
        e.print();
    }
    
    assert(q0 == 1);
    assert(st0.готов);
    
    st0.пуск();
    assert(q0 == 2);
    assert(st0.мёртв);
    
    скажифнс("бросьЖни пройден!");
}

проц Тест11()
{
    скажифнс("Testing thread safety");
    
    цел x = 0, y = 0;
    
    КонтекстСтэка sc0 = new КонтекстСтэка(
	delegate проц()
    {
        while(true)
        {
            x++;
            КонтекстСтэка.жни;
        }
    });
    
    КонтекстСтэка sc1 = new КонтекстСтэка(
	delegate проц()
    {
        while(true)
        {
            y++;
            КонтекстСтэка.жни;
        }
    });
    
    stdrus.Нить t0 = new stdrus.Нить(
    {
        for(цел i=0; i<10000; i++)
            sc0.пуск();
        
        return 0;
    });
    
    stdrus.Нить t1 = new stdrus.Нить(
    {
        for(цел i=0; i<10000; i++)
            sc1.пуск();
        
        return 0;
    });
    
    assert(sc0);
    assert(sc1);
    assert(t0);
    assert(t1);
    
    t0.старт;
    t1.старт;
    t0.жди;
    t1.жди;
    
    assert(x == 10000);
    assert(y == 10000);
    
    скажифнс("Нить safety passed!");
}

проц main()
{
Тест();
Тест1();
Тест2();
Тест3();
Тест4();
Тест5();
//Тест6();
//Тест7(); - не пройден!!!!!
Тест8();
//Тест9();
Тест10();
//Тест11();
}