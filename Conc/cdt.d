  import thread, conc.countdown, conc.fifosemaphore, conc.waitnotify,conc.mutex;
 
проц кд(){ 
    class Работяга { 
      private final ОбратныйОтсчёт done;
      this(ОбратныйОтсчёт d) { done = d; }
      проц пуск() {
	эхо("counting down...\n");
	for (цел k=0;k<10000; k++){}
	done.отпусти();
	//return 0;
      }
    }
    цел N = 5;
    эхо("starting countdown unittest\n");
    ОбратныйОтсчёт done = new ОбратныйОтсчёт(N);
    for (цел i = 0; i < N; ++i) {
      Работяга w = new Работяга(done);
      Нить t = new Нить(&w.пуск);
      t.старт();
    }
    for (цел k=0;k<10000; k++){}
    done.обрети(); // жди for all to finish
    эхо("finished countdown unittest\n");
	
}
проц фифосем() {

    СемафорПВПВ sem = new СемафорПВПВ(3);
    цел done = 0;
    Нить[] t = new Нить[10];
	
    void f() {
      цел n;
      Нить tt = Нить.дайЭту();
      for (n=0; n < t.length; n++) {
	if (tt is t[n])
	  break;
      }
      sem.обрети();
      //return 0;
    }
    void f2() {
      цел n;
      Нить tt = Нить.дайЭту();
      for (n=0; n < t.length; n++) {
	if (tt is t[n])
	  break;
      }
      sem.отпусти();
      //return 0;
    }
	
    цел n;
    for (n=0; n<t.length/2; n++) {
      t[n] = new Нить(&f);
    }
    for (; n<t.length; n++) {
      t[n] = new Нить(&f2);
    }
    эхо("starting fifosemaphore unittest\n");
    for (n=0; n<t.length/2; n++) {
      t[n].старт();
    }
    Нить.жни();
    for (; n<t.length; n++) {
      t[n].старт();
      Нить.жни();
    }
/+
		foreach(цел n, Нить нить; t)
		{
			эхо("ждущий on %d\n", n);
			нить.жди();
		}
+/
    эхо("finished fifosemaphore unittest\n");
    delete sem;
    t[] = пусто;
  }


проц вн() {

  class A {
    mixin ЖдиУведоми;
    бул done;
    this()  { иницЖдиУведоми(); }
    ~this() { удалиЖдиУведоми(); }

    synchronized проц doSomething1() {
      while (!done) {
	//	эхо("S1 ждущий\n");
	жди();
      }      
    }

    synchronized проц doSomething2() {
      done = да;
      //      эхо("S1 notifying\n");
      уведоми();      
    }
  } // A
	
  эхо("starting waitnotify unittest\n");
  A a = new A();
  Нить t1 = new Нить(&a.doSomething1);
  Нить t2 = new Нить(&a.doSomething2);
  t1.старт();
  t2.старт();

  t1.жни();
  t2.жни();
  //  delete a;  // causes errors with DMD on linux
  эхо("finished waitnotify unittest\n");
	
  assert(да);
}
  проц стопор() {
    class Test {
      Мютекс замок;
      цел acquired;
      Нить[] t;
      проц f() {
	цел n;
	Нить tt = Нить.дайЭту();
	for (n=0; n < t.length; n++) {
	  if (tt is t[n])
	    break;
	}
	эхо(" thread %d started\n",n);
	замок.обрети();
	эхо(" thread %d aquired\n",n);
	замок.отпусти();
	acquired++;
	эхо(" thread %d released\n",n);	
      }
	  
      проц пуск() {
	замок = new Мютекс();
	acquired = 0;
	t = new Нить[3];
	цел n;
	for (n=0; n<t.length; n++) {
	  t[n] = new Нить(&this.f);
	}
	эхо("starting mutex unittest\n");
	for (n=0; n<t.length; n++) {
	  t[n].старт();
	}
	while (acquired != n)
	  Нить.жни();
	эхо("finished mutex unittest\n");
      }
    }
    Test t = new Test();
    t.пуск();
  }

void main()
{
фифосем();
вн();
стопор();
кд();

 }