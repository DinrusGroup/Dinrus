import sys.registry,win;
void main()
{
    Ключ HKCR    =   Реестр.кореньКлассов;
    Ключ CLSID   =   HKCR.дайКлюч("CLSID");

    foreach(Ключ ключ; CLSID.ключи())
    {
        foreach(Значение зн; ключ.значения())
        {
		скажинс(зн.имя());
        }
    }
}