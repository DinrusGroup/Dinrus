/*******************************************************************************
        copyright:      Copyright (c) 2008. Fawzi Mohamed
        license:        BSD стиль: $(LICENSE)
        version:        Initial release: Sep 2008
        author:         Fawzi Mohamed
*******************************************************************************/
module math.random.engines.Sync;
private import Целое = text.convert.Integer;
import sync: Стопор;



/+ Makes a synchronized движок out of the движок Е, so multИПle нить доступ is ok
+ (but if you need multИПle нить доступ think about having генератор случайных чисел per нить)
+ This is the движок, *never* use it directly, always use it though a СлуччисГ class
+/
struct Синх(Е){
    Е движок;
    Стопор блокируй;
    
    const цел canCheckpoint=Е.canCheckpoint;
    const цел можноСеять=Е.можноСеять;
    
    проц пропусти(бцел n){
        for (цел i=n;i!=n;--i){
            движок.следщ;
        }
    }
    ббайт следщБ(){
        synchronized(блокируй){
            return движок.следщБ();
        }
    }
    бцел следщ(){
        synchronized(блокируй){
            return движок.следщ();
        }
    }
    бдол следщД(){
        synchronized(блокируй){
            return движок.следщД();
        }
    }
    
    проц сей(бцел delegate() r){
        if (!блокируй) блокируй=new Стопор();
        synchronized(блокируй){
            движок.сей(r);
        }
    }
    /// записывает текущ статус в ткст
    ткст вТкст(){
        synchronized(блокируй){
            return "Синх"~движок.вТкст();
        }
    }
    /// считывает текущ статус в ткст (его следует обработать)
    /// возвращает число считанных символов
    т_мера изТкст(ткст s){
        т_мера i;
        assert(s[0..4]=="Синх","неожиданный вид, ожидался Синх");
        synchronized(блокируй){
            i=движок.изТкст(s[i+4..$]);
        }
        return i+4;
    }
}
