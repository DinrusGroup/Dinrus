﻿module io.device.Conduit;

/*private*/ import thread, exception;
public  import io.model;


//export extern(D):

    class Провод : ИПровод
{

//export:

    protected Фибра.Планировщик планировщик;            // optional планировщик
    /*private*/   бцел            продолжительность = -1;        // scheduling таймаут


    this()
    {
        auto f = Фибра.дайЭту;
        if (f)
            планировщик = f.событие.планировщик;
    }


    ~this ()
    {
        открепи;
    }

    Фибра.Планировщик дайПланировщик()
    {
        return планировщик;
    }

    abstract ткст вТкст ();
    abstract т_мера размерБуфера ();
    abstract т_мера читай (проц[] приёмн);
    abstract т_мера пиши (проц [] ист);
    abstract проц открепи ();

    final проц таймаут (бцел миллисек)
    {
        продолжительность = миллисек;
    }

    final бцел таймаут ()
    {
        return продолжительность;
    }

    бул жив_ли ()
    {
        return да;
    }


    final ИПровод провод ()
    {
        return this;
    }


    ИПотокВВ слей ()
    {
        return this;
    }

    проц закрой ()
    {
        this.открепи;
    }

    final проц ошибка (ткст сооб)
    {
        throw new ВВИскл (сооб);
    }



    final ИПотокВвода ввод ()
    {
        return this;
    }


    final ИПотокВывода вывод ()
    {
        return this;
    }


    final Провод помести (проц[] ист)
    {
        помести (ист, this);
        return this;
    }

    final Провод получи (проц[] приёмн)
    {
        получи (приёмн, this);
        return this;
    }


    final Провод отмотай ()
    {
        сместись (0);
        return this;
    }

    ИПотокВывода копируй (ИПотокВвода ист, т_мера макс = -1)
    {
        перемести (ист, this, макс);
        return this;
    }

    дол сместись (дол смещение, Якорь якорь = Якорь.Нач)
    {
        ошибка (this.вТкст ~ " не поддерживается запрос перехода");
        return 0;
    }

    ткст текст(T=сим) (т_мера макс = -1)
    {
        return cast(T[]) загрузи (макс);
    }


    static  проц[] загрузи (ИПотокВвода ист, т_мера макс=-1)
    {
        проц[]  приёмн;
        т_мера  i,
        длин,
        чанк;

        if (макс != -1)
            чанк = макс;
        else
            чанк = ист.провод.размерБуфера;

        while (длин < макс)
        {
            if (приёмн.length - длин is 0)
                приёмн.length = длин + чанк;

            if ((i = ист.читай (приёмн[длин .. $])) is Кф)
                break;
            длин += i;
        }
        return приёмн [0 .. длин];
    }

    проц[] загрузи (т_мера макс = -1)
    {
        return загрузи (this, макс);
    }

    static  проц помести (проц[] ист, ИПотокВывода вывод)
    {
        while (ист.length)
        {
            auto i = вывод.пиши (ист);
            if (i is Кф)
                вывод.провод.ошибка ("Провод.помести :: конец потока достигнут при записи");
            ист = ист [i..$];
        }
    }


    static проц получи (проц[] приёмн, ИПотокВвода ввод)
    {
        while (приёмн.length)
        {
            auto i = ввод.читай (приёмн);
            if (i is Кф)
                ввод.провод.ошибка ("Провод.получи :: конец потока достигнут при чтении");
            приёмн = приёмн [i..$];
        }
    }


    static т_мера перемести (ИПотокВвода ист, ИПотокВывода приёмн, т_мера макс=-1)
    {
        байт[8192] врем;
        т_мера     готово;

        while (макс)
        {
            auto длин = макс;
            if (длин > врем.length)
                длин = врем.length;

            if ((длин = ист.читай(врем[0 .. длин])) is Кф)
                макс = 0;
            else
            {
                макс -= длин;
                готово += длин;
                auto p = врем.ptr;
                for (auto j=0; длин > 0; длин -= j, p += j)
                    if ((j = приёмн.пиши (p[0 .. длин])) is Кф)
                        return Кф;
            }
        }

        return готово;
    }
}


class ФильтрВвода : ИПотокВвода
{

//export:

    protected ИПотокВвода источник;


    this (ИПотокВвода источник)
    {
        this.источник = источник;
    }


    ИПровод провод ()
    {
        return источник.провод;
    }


    т_мера читай (проц[] приёмн)
    {
        return источник.читай (приёмн);
    }

    проц[] загрузи (т_мера макс = -1)
    {
        return Провод.загрузи (this, макс);
    }


    ИПотокВВ слей ()
    {
        источник.слей;
        return this;
    }

    дол сместись (дол смещение, Якорь якорь = Якорь.Нач)
    {
        return источник.сместись (смещение, якорь);
    }


    ИПотокВвода ввод ()
    {
        return источник;
    }


    проц закрой ()
    {
        источник.закрой;
    }
}



class ФильтрВывода : ИПотокВывода
{

//export:

    protected ИПотокВывода сток;

    this (ИПотокВывода сток)
    {
        this.сток = сток;
    }


    ИПровод провод ()
    {
        return сток.провод;
    }


    т_мера пиши (проц[] ист)
    {
        return сток.пиши (ист);
    }


    ИПотокВывода копируй (ИПотокВвода ист, т_мера макс = -1)
    {
        Провод.перемести (ист, this, макс);
        return this;
    }

    ИПотокВВ слей ()
    {
        сток.слей;
        return this;
    }


    дол сместись (дол смещение, Якорь якорь = Якорь.Нач)
    {
        return сток.сместись (смещение, якорь);
    }


    ИПотокВывода вывод ()
    {
        return сток;
    }

    проц закрой ()
    {
        сток.закрой;
    }
}
