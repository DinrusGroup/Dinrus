/*******************************************************************************
        copyright:      Copyright (c) 2008. Fawzi Mohamed
        license:        BSD стиль: $(LICENSE)
        version:        Initial release: July 2008
        author:         Fawzi Mohamed
*******************************************************************************/
module math.random.engines.ArraySource;

/// very simple Массив based источник (use with care, some methods in non униформа distributions
/// expect a random источник with correct statistics, и could loop forever with such a источник)
struct МассИсток{
    бцел[] a;
    т_мера i;
    const цел canCheckpoint=нет; // implement?
    const цел можноСеять=нет;
    
    static МассИсток opCall(бцел[] a,т_мера i=0)
    in { assert(a.length>0,"Массиву нужен хотя бы один элемент"); }
    body {
        МассИсток рез;
        рез.a=a;
        рез.i=i;
        return рез;
    }
    бцел следщ(){
        assert(a.length>i,"ошибка, Выход за границы массива");
        бцел el=a[i];
        i=(i+1)%a.length;
        return el;
    }
    ббайт следщБ(){
        return cast(ббайт)(0xFF&следщ);
    }
    бдол следщД(){
        return ((cast(бдол)следщ)<<32)+cast(бдол)следщ;
    }
}
