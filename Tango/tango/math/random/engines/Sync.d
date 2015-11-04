/*******************************************************************************
        copyright:      Copyright (c) 2008. Fawzi Mohamed
        license:        BSD стиль: $(LICENSE)
        version:        Initial release: Sep 2008
        author:         Fawzi Mohamed
*******************************************************************************/
module math.random.engines.Sync;
private import Целое = text.convert.Integer;
import sync: Стопор;

/+ Makes a synchronized engine out of the engine E, so multИПle нить access is ok
+ (but if you need multИПle нить access think about having генератор случайных чисел per нить)
+ This is the engine, *never* use it directly, always use it though a СлуччисГ class
+/
struct Sync(E){
    E engine;
    Стопор блокируй;
    
    const цел canCheckpoint=E.canCheckpoint;
    const цел можноСеять=E.можноСеять;
    
    проц пропусти(бцел n){
        for (цел i=n;i!=n;--i){
            engine.следщ;
        }
    }
    ббайт следщБ(){
        synchronized(блокируй){
            return engine.следщБ();
        }
    }
    бцел следщ(){
        synchronized(блокируй){
            return engine.следщ();
        }
    }
    бдол следщД(){
        synchronized(блокируй){
            return engine.следщД();
        }
    }
    
    проц сей(бцел delegate() r){
        if (!блокируй) блокируй=new Стопор();
        synchronized(блокируй){
            engine.сей(r);
        }
    }
    /// writes the current статус in a ткст
    ткст вТкст(){
        synchronized(блокируй){
            return "Sync"~engine.вТкст();
        }
    }
    /// reads the current статус из_ a ткст (его следует обработать)
    /// возвращает число считанных символов
    т_мера fromString(ткст s){
        т_мера i;
        assert(s[0..4]=="Sync","unexpected kind, ожидалось Sync");
        synchronized(блокируй){
            i=engine.fromString(s[i+4..$]);
        }
        return i+4;
    }
}
