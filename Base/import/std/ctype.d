module std.ctype;


бул число_ли(ИнфОТипе[] _arguments, спис_ва _argptr)
{
    ткст  s  = "";
    шткст ws = "";
    юткст ds = "";

    
    if (_arguments.length == 0)
        return нет;

    if (_arguments[0] == typeid(ткст))
        return чис_ли(ва_арг!(ткст)(_argptr));
    else if (_arguments[0] == typeid(шткст))
        return чис_ли(вЮ8(ва_арг!(шткст)(_argptr)));
    else if (_arguments[0] == typeid(юткст))
        return чис_ли(вЮ8(ва_арг!(юткст)(_argptr)));
    else if (_arguments[0] == typeid(реал))
        return да;
    else if (_arguments[0] == typeid(дво)) 
        return да;   
    else if (_arguments[0] == typeid(плав)) 
        return да;  
    else if (_arguments[0] == typeid(бдол)) 
        return да; 
    else if (_arguments[0] == typeid(дол)) 
        return да;   
    else if (_arguments[0] == typeid(бцел)) 
        return да;  
    else if (_arguments[0] == typeid(цел)) 
        return да;   
    else if (_arguments[0] == typeid(бкрат)) 
        return да;   
    else if (_arguments[0] == typeid(крат)) 
        return да;   
    else if (_arguments[0] == typeid(ббайт)) 
    {
       s.length = 1;
       s[0]= ва_арг!(ббайт)(_argptr);
       return чис_ли(cast(ткст)s);
    }
    else if (_arguments[0] == typeid(байт)) 
    {
       s.length = 1;
       s[0] = ва_арг!(сим)(_argptr);
       return чис_ли(cast(ткст)s);
    }
    else if (_arguments[0] == typeid(вреал))
        return да;
    else if (_arguments[0] == typeid(вдво)) 
        return да;   
    else if (_arguments[0] == typeid(вплав)) 
        return да;  
    else if (_arguments[0] == typeid(креал))
        return да;
    else if (_arguments[0] == typeid(кдво)) 
        return да;   
    else if (_arguments[0] == typeid(кплав)) 
        return да;  
    else if (_arguments[0] == typeid(сим))
    {
        s.length = 1;
        s[0] = ва_арг!(сим)(_argptr);
        return чис_ли(s);
    }
    else if (_arguments[0] == typeid(шим))
    {
        ws.length = 1;
        ws[0] = ва_арг!(шим)(_argptr);
        return чис_ли(вЮ8(ws));
    }
    else if (_arguments[0] == typeid(дим))
    { 
        ds.length =  1;
        ds[0] = ва_арг!(дим)(_argptr);
        return чис_ли(вЮ8(ds));
    }    
    else       		
       return нет; 	   
} 

бул число_ли(...)
	{ 
		return cast(бул) число_ли(_arguments, _argptr);
	}


	 extern(D):

	цел числобукв(дим б);
	цел буква(дим б);
	цел управ(дим б);
	цел цифра(дим б);
	цел проп(дим б);
	цел пунктзнак(дим б);
	цел межбукв(дим б);
	цел заг(дим б);
	цел цифраикс(дим б);
	цел граф(дим б);
	цел печат(дим б);
	цел аски(дим б);
	дим впроп(дим б);
	дим взаг(дим б);

    бул пробел(сим c) ;
	бул цифра(сим c) ;
	бул цифра8(сим c) ;
	бул цифра16(сим c) ;
 	бул рус(дим б);
	цел проверьРус(дим б);
	цел руспроп(дим б) ;
	цел русзаг(дим б);


	alias числобукв isalnum;
	alias буква isalpha;
	alias управ iscntrl;
	alias цифра isdigit;
	alias проп islower;
	alias пунктзнак ispunct;
	alias межбукв isspace;
	alias заг isupper;
	alias цифраикс isxdigit;
	alias граф isgraph;
	alias печат isprint;
	alias аски isascii;
	alias впроп tolower;
	alias взаг toupper;