module std.ctype;


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