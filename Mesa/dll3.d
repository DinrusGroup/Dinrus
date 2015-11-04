// Dinrus Dll Intro
import ru.base.runtime;
pragma(lib, "dinrus.lib");

extern  (C) ModuleInfo[] _moduleinfo_array;
extern (C) проц _moduleCtor2(ModuleInfo[] mi, цел skip);
alias ук HINSTANCE;
alias цел BOOL;
Прокси* прокси;
HINSTANCE g_hInst;
ук б;


enum
{
	ДЛЛ_ПРИКРЕПИ_ПРОЦЕСС	 = 1 ,
    ДЛЛ_ПРИКРЕПИ_НИТЬ 			= 2 ,
    ДЛЛ_ОТКРЕПИ_НИТЬ			 = 3,
    ДЛЛ_ОТКРЕПИ_ПРОЦЕСС			 = 0,
}

export extern (C) бул function() запущенЭкз;

extern (Windows)
BOOL DllMain(HINSTANCE экземп, бдол резон, ук резерв)
{
    switch (резон)
    {
	case ДЛЛ_ПРИКРЕПИ_ПРОЦЕСС:
	   
		прокси =cast(Прокси*) рт.загрузи("Dinrus.Base.dll");//смДайПрокси();
		//смУстановиПрокси(прокси);
		if(прокси) эхо("PROXYYYY!!!!!!!!");
		
	    break;
	case ДЛЛ_ОТКРЕПИ_ПРОЦЕСС:
		    if(прокси) смУдалиПрокси();
		
	    break;

	case ДЛЛ_ПРИКРЕПИ_НИТЬ:
	case ДЛЛ_ОТКРЕПИ_НИТЬ:
	    // Несколько нитей пока не поддерживаются
	    return нет;
		
	default: ;
    }
    g_hInst = экземп;
    return да;
}

