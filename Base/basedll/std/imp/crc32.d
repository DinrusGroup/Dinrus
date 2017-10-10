﻿module std.crc32;

version DinrusStd{	
	pragma(lib, "DinrusStd.lib");
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
}
else{

extern(D)
{
		бцел иницЦПИ32();
		бцел обновиЦПИ32б(ббайт зн, бцел црц);
		бцел обновиЦПИ32с(сим зн, бцел црц);
		бцел ткстЦПИ32(ткст т);

		struct ЦПИ32 
		{	

			бцел иниц();
			бцел обнови(ббайт зн, бцел црц);
			бцел обнови(сим зн, бцел црц);
			бцел вЦПИ32(ткст т);
		}
	}
}

