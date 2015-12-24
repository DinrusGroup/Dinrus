﻿import thread, stdrus, win;
pragma(lib, "dinrus.lib");

проц созданиеКонтекста()
{
 скажинс("Проверка создания/удаления контекста");
    int s0 = 0;
    static int s1 = 0;
    
    Фибра a = new Фибра(
    delegate void()
    {
        s0++;
    });
    
    void fb() { s1++; }
    
    Фибра b = new Фибра(&fb);
    
    Фибра к = new Фибра(
        delegate void() { assert(false); });
    
    assert(a);
    assert(b);
    assert(к);
    
    assert(s0 == 0);
    assert(s1 == 0);
    assert(a.состояние == Фибра.Состояние.ЗАДЕРЖ);
    assert(b.состояние == Фибра.Состояние.ЗАДЕРЖ);
    assert(к.состояние == Фибра.Состояние.ЗАДЕРЖ);
    
    delete к;
    
    assert(s0 == 0);
    assert(s1 == 0);
    assert(a.состояние == Фибра.Состояние.ЗАДЕРЖ);
    assert(b.состояние == Фибра.Состояние.ЗАДЕРЖ);
    
    скажинс("Пущена фибра а");
    a.вызови();
    скажинс("а выполнена");
    
    assert(a);
    
    assert(s0 == 1);
    assert(s1 == 0);
    assert(a.состояние == Фибра.Состояние.ТЕРМ);
    assert(b.состояние == Фибра.Состояние.ЗАДЕРЖ);    
    
    assert(b.состояние == Фибра.Состояние.ЗАДЕРЖ);
    
    скажинс("Пущена b");
    b.вызови();
    скажинс("b выполнена");
    
    assert(s0 == 1);
    assert(s1 == 1);
    assert(b.состояние == Фибра.Состояние.ТЕРМ);
    
    delete a;
    delete b;
    
    скажинс("Создание контекста пройдено");
}

проц переключениеКонтекста()
{
    скажинс("Проверка переключения контекста");
    int s0 = 0;
    int s1 = 0;
    int s2 = 0;
    
    Фибра a = new Фибра(
    delegate void()
    {
        while(true)
        {
            debug эхо(" ---A---\n");
            s0++;
            Фибра.жни();
        }
    });
    
    
    Фибра b = new Фибра(
    delegate void()
    {
        while(true)
        {
            debug эхо(" ---B---\n");
            s1++;
            Фибра.жни();
        }
    });
    
    
    Фибра к = new Фибра(
    delegate void()
    {
        while(true)
        {
            debug эхо(" ---C---\n");
            s2++;
            Фибра.жни();
        }
    });
    
    assert(a);
    assert(b);
    assert(к);
    assert(s0 == 0);
    assert(s1 == 0);
    assert(s2 == 0);
    
    a.вызови();
    b.вызови();
    
    assert(a);
    assert(b);
    assert(к);
    assert(s0 == 1);
    assert(s1 == 1);
    assert(s2 == 0);
    
    for(int и=0; и<20; и++)
    {
        к.вызови();
        a.вызови();
    }
    
    assert(a);
    assert(b);
    assert(к);
    assert(s0 == 21);
    assert(s1 == 1);
    assert(s2 == 20);
    
    delete a;
    delete b;
    delete к;
    
    скажинс("Переключение контекста пройдено");
}
    
проц внедрениеКонтекста()
{
    скажинс("Проверка внедрения контекста");
    Фибра a, b, к;
    
    int t0 = 0;
    int t1 = 0;
    int t2 = 0;
    
    a = new Фибра(
    delegate void()
    {
        
        t0++;
        b.вызови();
        
    });
    
    b = new Фибра(
    delegate void()
    {
        assert(t0 == 1);
        assert(t1 == 0);
        assert(t2 == 0);
        
        t1++;
        к.вызови();
        
    });
    
    к = new Фибра(
    delegate void()
    {
        assert(t0 == 1);
        assert(t1 == 1);
        assert(t2 == 0);
        
        t2++;
    });
    
    assert(a);
    assert(b);
    assert(к);
    assert(t0 == 0);
    assert(t1 == 0);
    assert(t2 == 0);
    
    a.вызови();
    
    assert(t0 == 1);
    assert(t1 == 1);
    assert(t2 == 1);
    
    assert(a);
    assert(b);
    assert(к);
    
    delete a;
    delete b;
    delete к;
    
    скажинс("Внедрение контекса пройдено");
}

проц базовыеИсключения()
{
	скажинс("Проверка базовых исключений");


	int t0 = 0;
	int t1 = 0;
	int t2 = 0;

	assert(t0 == 0);
	assert(t1 == 0);
	assert(t2 == 0);

	try
	{

		try
		{
			throw new ФибраИскл("проверка исключений");
			t2++;
		}
		catch(ФибраИскл fx)
		{
			t1++;
			throw fx;
		}
	
		t2++;
	}
	catch(ФибраИскл е)
	{
		t0++;
		е.выведи();
	}

	assert(t0 == 1);
	assert(t1 == 1);
	assert(t2 == 0);

	скажинс("Базовые исключения поддерживаются\n");
}


проц проверкаИсключений()
{
    скажинс("Проверка исключений");
    Фибра a, b, к;
    
    int t0 = 0;
    int t1 = 0;
    int t2 = 0;
    
    эхо("t0 = %d\nt1 = %d\nt2 = %d\n", t0, t1, t2);
    
    a = new Фибра(
    delegate void()
    {
        t0++;
        throw new ФибраИскл("исключение А");
        t0++;
    });
    
    b = new Фибра(
    delegate void()
    {
        t1++;
        к.вызови();
        t1++;
    });
    
    к = new Фибра(
    delegate void()
    {
        t2++;
        throw new Исключение("исключение Б",__FILE__, __LINE__);
        t2++;
    });
    
	скажинс("Ассерт");
    assert(a);
    assert(b);
    assert(к);
    assert(t0 == 0);
    assert(t1 == 0);
    assert(t2 == 0);
	скажинс("Ассерт пройден");
    
	 try
    {
		try
		{
			a.вызови(нет);
			assert(false);
		}
		
		catch(Исключение e)
		{
			e.выведи;
		}
	}
	catch(Исключение j)
	{
		j.выведи;
	}
    
    assert(a);
    assert(a.состояние == Фибра.Состояние.ТЕРМ);
    assert(b);
    assert(к);
    assert(t0 == 1);
    assert(t1 == 0);
    assert(t2 == 0);
    
    try
    {
        b.вызови(нет);
        assert(false);
    }
    catch(Исключение и)
    {
       и.выведи;
    }
    
    скажинс("ух ты!");
    
    assert(a);
    assert(b);
    assert(b.состояние == Фибра.Состояние.ТЕРМ);
    assert(к);
    assert(к.состояние == Фибра.Состояние.ТЕРМ);
    assert(t0 == 1);
    assert(t1 == 1);
    assert(t2 == 1);

	delete a;
	delete b;
	delete к;
    

	Фибра t;
	int q0 = 0;
	int q1 = 0;

	t = new Фибра(
	delegate void()
	{
		try
		{
			q0++;
			throw new Исключение("исключение В",__FILE__, __LINE__);
			q0++;
		}
		catch(Исключение ex)
		{
			q1++;
			скажинс("!!!!!!!!ВПОЙМАНО ИСКЛЮЧЕНИЕ!!!!!!!!");
			ex.выведи;
		}
	});


	assert(t);
	assert(q0 == 0);
	assert(q1 == 0);
	t.вызови();
	assert(t);
	assert(t.состояние == Фибра.Состояние.ТЕРМ);
	assert(q0 == 1);
	assert(q1 == 1);

	delete t;
   
    Фибра d, e;
    int s0 = 0;
    int s1 = 0;
    
    d = new Фибра(
    delegate void()
    {
        try
        {
            s0++;
            e.вызови(нет);
            Фибра.жни();
            s0++;
            e.вызови(нет);
            s0++;
        }
        catch(Исключение ex)
        {
            ex.выведи;
        }
    });
    
    e = new Фибра(
    delegate void()
    {
        s1++;
        Фибра.жни();
        throw new Исключение("исключение Г",__FILE__, __LINE__);
        s1++;
    });
    
    assert(d);
    assert(e);
    assert(s0 == 0);
    assert(s1 == 0);
    
    d.вызови();
    
    assert(d);
    assert(e);
    assert(s0 == 1);
    assert(s1 == 1);
    
    d.вызови();
    
    assert(d);
    assert(e);
    assert(s0 == 2);
    assert(s1 == 1);
    
    assert(d.состояние == Фибра.Состояние.ТЕРМ);
    assert(e.состояние == Фибра.Состояние.ТЕРМ);
    
    delete d;
    delete e;
    
    скажинс("Исключения пройдены");
}

проц стандартныеИскл()
{
    скажинс("Проверка стандартных исключений");
    int t = 0;
    
    Фибра a = new Фибра(
    delegate void()
    {
        throw new Исключение("BLAHAHA",__FILE__, __LINE__);
    });
    
    assert(a);
    assert(t == 0);
    
    try
    {
        a.вызови(нет);
        assert(false);
    }
    catch(Исключение e)
    {
        e.выведи;
    }
    
    assert(a);
    assert(a.состояние == Фибра.Состояние.ТЕРМ);
    assert(t == 0);
    
    delete a;
    
    
    скажинс("Стандартные исключения пройдены");
}

проц стрессПамяти()
{
    скажинс("Тест на стресс памяти");
	  
    const uint РАЗМЕР_СТРЕССА = 5000;
    
    Фибра[] ctx;
    ctx.length = РАЗМЕР_СТРЕССА;
    
    int cnt0 = 0;
    int cnt1 = 0;
	
        void threadFunc()
    {
        cnt0++;
        Фибра.жни;
        cnt1++;
    }
   
    foreach(inout Фибра к; ctx)
    {
        к = new Фибра(&threadFunc, 1024);
    }
    	
    assert(cnt0 == 0);
    assert(cnt1 == 0);
    
    foreach(inout Фибра к; ctx)
    {
        к.вызови;
    }
    
    assert(cnt0 == РАЗМЕР_СТРЕССА);
    assert(cnt1 == 0);
    
    foreach(inout Фибра к; ctx)
    {
        к.вызови;
    }
    
    assert(cnt0 == РАЗМЕР_СТРЕССА);
    assert(cnt1 == РАЗМЕР_СТРЕССА);
    
    foreach(inout Фибра к; ctx)
    {
        delete к;
    }
    
    assert(cnt0 == РАЗМЕР_СТРЕССА);
    assert(cnt1 == РАЗМЕР_СТРЕССА);
    
    скажинс("Тест на стресс пройден\n");
}

проц плавТчк()
{
    скажинс("Проверка плавающей точки");
    
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
    
    Фибра a, b, к;
    
    a = new Фибра(
    delegate void()
    {
        while(true)
        {
            f0 ++;
            d0 ++;
            r0 ++;
            
            Фибра.жни();
        }
    });
    
    b = new Фибра(
    delegate void()
    {
        while(true)
        {
            f1 = d0 + r0;
            d1 = f0 + r0;
            r1 = f0 + d0;
            
            Фибра.жни();
        }
    });
    
    к = new Фибра(
    delegate void()
    {
        while(true)
        {
            f0 *= d1;
            d0 *= r1;
            r0 *= f1;
            
            Фибра.жни();
        }
    });
    
    a.вызови();
    assert(f0 == 2.0);
    assert(f1 == 0.0);
    assert(d0 == 3.0);
    assert(d1 == 0.0);
    assert(r0 == 4.0);
    assert(r1 == 0.0);
    
    b.вызови();
    assert(f0 == 2.0);
    assert(f1 == 7.0);
    assert(d0 == 3.0);
    assert(d1 == 6.0);
    assert(r0 == 4.0);
    assert(r1 == 5.0);
    
    к.вызови();
    assert(f0 == 12.0);
    assert(f1 == 7.0);
    assert(d0 == 15.0);
    assert(d1 == 6.0);
    assert(r0 == 28.0);
    assert(r1 == 5.0);
    
    a.вызови();
    assert(f0 == 13.0);
    assert(f1 == 7.0);
    assert(d0 == 16.0);
    assert(d1 == 6.0);
    assert(r0 == 29.0);
    assert(r1 == 5.0);
    
    скажинс("Плавающая точка пройдена");
}

/+
проц проверкаРегистров()
{
    скажинс("Проверка регистров");
    
    struct registers
    {
        int eax, ebx, ecx, edx;
        int esi, edi;
        int ebp, esp;
        
        //TODO: Add fpu stuff
    }
    
    static registers old;
    static registers next;
    static registers g_old;
    static registers g_next;
    
    //I believe that D calling convention requires that
    //EBX, ESI and EDI be saved.  In order to validate
    //this, we write to those registers and вызови the
    //stack thread.
    static StackThread reg_test = new StackThread(
    delegate void() 
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
            
            call StackThread.жни;
            
            mov [next.ebx], EBX;
            mov [next.esi], ESI;
            mov [next.edi], EDI;
            mov [next.ebp], EBP;
            mov [next.esp], ESP;
            
            popad;
        }
    });
    
    //Run the stack context
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
        call StackThread.вызови;
        
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
    
    эхо("Registers passed!\n");
}
+/

проц проверкаФибраЖни()
{
    скажинс("Проверка Фибра.жни");
    
    int q0 = 0;
    
    Фибра st0 = new Фибра(
    delegate void()
    {
        q0++;
        Фибра.жниИБросай(new Исключение("Проверка броса исключения из Фибра.жни",__FILE__, __LINE__));
        q0++;
    });
    
    try
    {
        st0.вызови(нет);
        assert(false);
    }
    catch(Исключение e)
    {
        e.выведи();
    }
    
    assert(q0 == 1);
    assert(st0.состояние == Фибра.Состояние.ЗАДЕРЖ);
    
    st0.вызови();
    assert(q0 == 2);
    assert(st0.состояние == Фибра.Состояние.ТЕРМ);
    
    скажинс("Фибра.жниИБросай пройдено!\n");
}

проц безопасностьНити()
{
    скажинс("Проверка безопасности нити");
    
    int x = 0, y = 0;
    
    Фибра sc0 = new Фибра(
    {
        while(true)
        {
            x++;
            Фибра.жни;
        }
    });
    
    Фибра sc1 = new Фибра(
    {
        while(true)
        {
            y++;
            Фибра.жни;
        }
    });
    
    thread.Нить t0 = new thread.Нить(
    {
        for(int и=0; и<10000; и++)
            sc0.вызови();
    });
    
    thread.Нить t1 = new thread.Нить(
    {
        for(int и=0; и<10000; и++)
            sc1.вызови();
    });
    
    assert(sc0);
    assert(sc1);
    assert(t0);
    assert(t1);
    
    t0.старт;
    t1.старт;
    t0.присоедини;
    t1.присоедини;
    
    assert(x == 10000);
    assert(y == 10000);
    
    скажинс("Безопасность нити сдана!");
}

проц сбросФибры()
{
    скажинс("Проверка сброса фибры");
    int чловызовов=1;
    Фибра sc0 = new Фибра(
    {
        for (int и=0;и<чловызовов;++и)
        {
            Фибра.жни;
        }
    });

    for (int и=0;и<чловызовов+1;++и){
        assert(sc0.состояние==Фибра.Состояние.ЗАДЕРЖ);
        sc0.вызови();
    }
    assert(sc0.состояние==Фибра.Состояние.ТЕРМ);
    sc0.сбрось();
    for (int и=0;и<чловызовов+1;++и){
        assert(sc0.состояние==Фибра.Состояние.ЗАДЕРЖ);
        sc0.вызови();
    }
    assert(sc0.состояние==Фибра.Состояние.ТЕРМ);
    sc0.сотри();
    
    sc0.сбрось(delegate void(){
        for (int и=0;и<чловызовов+1;++и)
        {
            Фибра.жни;
        }
    });
    for (int и=0;и<чловызовов+2;++и){
        assert(sc0.состояние==Фибра.Состояние.ЗАДЕРЖ);
        sc0.вызови();
    }
    assert(sc0.состояние==Фибра.Состояние.ТЕРМ);
    sc0.сотри();
    
    sc0.сбрось(function void(){
        for (int и=0;и<1;++и)
        {
            Фибра.жни;
        }
    });
    for (int и=0;и<2;++и){
        assert(sc0.состояние==Фибра.Состояние.ЗАДЕРЖ);
        sc0.вызови();
    }
    assert(sc0.состояние==Фибра.Состояние.ТЕРМ);
    
    
    скажинс("Сброс фибры сработал!");
}


void main()
{
скажинс("НАЧАЛО ТЕСТИРОВАНИЯ КЛАССА ФИБРА ИЗ МОДУЛЯ THREAD");
сбросФибры();
созданиеКонтекста();
переключениеКонтекста();
внедрениеКонтекста();
плавТчк();
безопасностьНити();
//Ниже приведены неработающие тесты
проверкаИсключений();
стандартныеИскл();
базовыеИсключения();
проверкаФибраЖни();
стрессПамяти();




скажинс("ТЕСТИРОВАНИЕ КЛАССА ФИБРА ИЗ МОДУЛЯ THREAD ЗАВЕРШЕНО");
пз;
}