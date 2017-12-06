//import std.file, std.utf, std.io, std.string, exception, cidrus;
import stdrus, win, io.Path;

version = UCRT;
version(UCRT)
{
	pragma(lib, "ucrt.lib");
	extern(C)
	{
	int _waccess(wchar* path, int access_mode);
	int _wchmod(wchar* path, int mode);
	}
}
alias скажифнс ск;

проц main()
 { 
 цел скопировано = 0;
 ткст флрасш = "*.d";
 ткст путь = ".\\import";
 ткст голова, хвост;

ск("Подождите пока строится список файлов => "~ флрасш );
нс;
	auto файлы = списпап(путь, флрасш);
	foreach (ф; файлы)
	{	try
		{
		version(UCRT){
		if( _wchmod(вЮ16н(ф), 6) == -1) ошибка(фм("Файл незаписываемый: %s", ф));
		}
		io.Path.разбей(ф, голова, хвост);
		ск(голова); таб; ск(хвост);нс;
		копируйФайл(ф, "%DINRUS%\\..\\imp\\dinrus\\"~голова~".di");
		скопировано++;
		}
		catch(ВВИскл искл){
		//throw искл;
		}
		ск("Скопирован : "~ф);		
	}
	нс;
	ск("Файлов скопировано: %d", скопировано);
	нс;
}



	
