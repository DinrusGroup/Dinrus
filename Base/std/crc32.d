﻿module std.crc32;

public import stdrus: иницЦПИ32, обновиЦПИ32б, обновиЦПИ32с, ткстЦПИ32 ;

alias ЦПИ32.иниц init_crc32;
alias ЦПИ32.обнови update_crc32;
alias ЦПИ32.текст crc32;

struct ЦПИ32
{

alias иниц opCall;
private бкрат значение;

	бкрат иниц(){return значение = иницЦПИ32();}
	бкрат обнови(ббайт зн, бцел црц){return значение = обновиЦПИ32б(зн, црц);}
	бкрат обнови(сим зн, бцел црц){return значение = обновиЦПИ32с(зн, црц);}
	бкрат текст(ткст т){return значение = ткстЦПИ32(т);}
	бкрат знач(){return значение;}

}
unittest
{
//	import win, stdrus;

	ЦПИ32 а;
	а.иниц();
	скажинс(вТкст(а.знач()));

}