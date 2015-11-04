module dbi.AbstractDatabase;

private import dbi.model.Database,
               dbi.model.Result;

class АбстрактнаяТаблица : Таблица
{

protected:    

    ткст _имя = пусто;
    бдол _члоРядов;
    ИнфОСтолбце[] _метаданные = пусто;

public:

    abstract ИнфОСтолбце[] метаданные();

    проц установи(ткст имя)
    in {
        assert (имя !is пусто);
    }
    body {
        _имя = имя;
    }

    ткст имя() { 
        return _имя; 
    }

}
