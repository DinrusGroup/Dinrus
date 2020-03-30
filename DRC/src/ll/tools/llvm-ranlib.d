module llvmAr;
import common, ll.Target;

extern (C){
цел ЛЛВхоФункцЛЛРанлиб(ткст0* args);
ткст[] дайАргиКС();
}

ткст ПомРанлиб ="
ОБЗОР: LLVM Ranlib (llvm-ranlib)

Эта программа генерирует индекс для ускорения доступа к архивам

ИСПОЛЬЗОВАНИЕ: llvm-ranlib <файл-архива>

ОПЦИИ:
-help                             - Показать доступные опции
-version                          - Показать версию этой программы
";



цел main(ткст[]) 
{
	ЛЛНициализуйВсеИнфОЦели();
	ЛЛНициализуйВсеЦелевыеМК();
	ЛЛНициализуйВсеАсмПарсеры();

	ткст[] арги = дайАргиКС();
	ткст0 марги =  cast(ткст0) арги[0..$];
		//выдай("Вызывается ЛЛВМ-РАНЛИБ").нс;
		if(арги.length < 2)
		{
			выдай(ПомРанлиб).нс;
			return ЛЛВхоФункцЛЛРанлиб(&марги);
		}
		else if(арги.length >= 2) return ЛЛВхоФункцЛЛРанлиб(&марги);
}
