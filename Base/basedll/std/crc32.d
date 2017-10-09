module std.crc32;
import std.x.crc32;

export extern(D):

import std.x.crc32;

бцел иницЦПИ32(){return std.x.crc32.init_crc32();}
бцел обновиЦПИ32б(ббайт зн, бцел црц){return std.x.crc32.update_crc32(зн, црц);}
бцел обновиЦПИ32с(сим зн, бцел црц){return std.x.crc32.update_crc32(зн, црц);}
бцел ткстЦПИ32(ткст т){return std.x.crc32.crc32(т);}

struct ЦПИ32 
{
	export:

	бцел иниц()
	{
		return std.x.crc32.init_crc32();
	}

	бцел обнови(ббайт зн, бцел црц)
	{
		return std.x.crc32.update_crc32(зн, црц);
	}

	бцел обнови(сим зн, бцел црц)
	{
		return std.x.crc32.update_crc32(зн, црц);
	}

	бцел ткст(ткст т)
	{
		return std.x.crc32.crc32(т);
	}
}
