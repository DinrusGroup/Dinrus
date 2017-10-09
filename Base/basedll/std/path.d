// Написано на языке программирования Динрус. Разработчик Виталий Кулич.

module std.path;

import std.x.path;

export extern(D):

ткст извлекиРасш(ткст полнимя){return std.x.path.getExt(полнимя);}
//getExt(r"d:\путь\foo.bat") // "bat"     getExt(r"d:\путь.two\bar") // null
ткст дайИмяПути(ткст полнимя){return std.x.path.getName(полнимя);}
//getName(r"d:\путь\foo.bat") => "d:\путь\foo"     getName(r"d:\путь.two\bar") => null
ткст извлекиИмяПути(ткст пимя){return std.x.path.getBaseName(пимя);}//getBaseName(r"d:\путь\foo.bat") => "foo.bat"
ткст извлекиПапку(ткст пимя){return std.x.path.getDirName(пимя);}
//getDirName(r"d:\путь\foo.bat") => "d:\путь"     getDirName(getDirName(r"d:\путь\foo.bat")) => r"d:\"
ткст извлекиМеткуДиска(ткст пимя){return std.x.path.getDrive(пимя);}
ткст устДефРасш(ткст пимя, ткст расш){return std.x.path.defaultExt(пимя, расш);}
ткст добРасш(ткст фимя, ткст расш){return std.x.path.addExt(фимя, расш);}
бул абсПуть_ли(ткст путь){return cast(бул) std.x.path.isabs(путь);}
ткст слейПути(ткст п1, ткст п2){return std.x.path.join(п1, п2);}
бул сравниПути(дим п1, дим п2){return cast(бул) std.x.path.fncharmatch(п1, п2);}
бул сравниПутьОбразец(ткст фимя, ткст образец){return cast(бул) std.x.path.fnmatch(фимя, образец);}
ткст разверниТильду(ткст путь){return std.x.path.expandTilde(путь);}

struct Путь 
{
	private
	{
		ткст м_путь;
		ткст м_расш;
	}

export:

	проц opCall(ткст путь) {м_путь = путь;}

	ткст расширение()
	{
		return м_расш = std.x.path.getExt(м_путь);
	}

	ткст добавьРасширение(ткст нрасш)
	{
		return м_расш =~ std.x.path.addExt(м_путь, нрасш);
	}

	ткст имя()
	{
		return std.x.path.getName(м_путь);
	}

	ткст меткаДиска()
	{
		return std.x.path.getDrive(м_путь);
	}

	ткст объединиС(ткст с)
	{
		return std.x.path.join(м_путь, с);}
	}

	бул сравниС(ткст путь)
	{
		return cast(бул) std.x.path.fnmatch(м_путь, путь);
	}



}