// Dinrus Dll Intro
import ru.base.runtime;

alias ук HINSTANCE;
alias цел BOOL;

HINSTANCE g_hInst;

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
	   //рт = new РТ;
		//рт.старт();
		ртСтарт();
		модИниц();
		модКтор();
		
	    break;
	case ДЛЛ_ОТКРЕПИ_ПРОЦЕСС:
		     ртСтоп();
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

