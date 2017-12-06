module sys.activex;

import win32.oaidl, win32.objbase; /* for VARIANTARG */

alias VARIANT Вар;
alias VARIANTARG Варарг;
alias ITypeInfo ИИнфОТипе;

enum ПТипВызова
{
    Функция    = 1,
    ВыводСвойства    = 2,
    ВводСвойства    = 4,
    ВводСвойстваРеф    = 8
}

extern(D):
    class АктивОбъ
{
    this(ткст имяПриложения);
    ~this();
    проц загрузиСостав();
    проц загрузиСостав(ИИнфОТипе иот);
    проц покажиСостав();
    Варарг[] делайМассив(ИнфОТипе[] арги, ук укз);
    Вар дай(ткст член);
    проц установи(ткст член, Варарг арг);
    проц установиПоСсыл(ткст член, Варарг арг);
    Вар вызови(ткст член,...);
}
АктивОбъ объАктив(ткст арг);


Варарг вар(...);

