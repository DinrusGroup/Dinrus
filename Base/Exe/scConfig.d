module scConfig;
import util.worktools, cidrus, win, stdrus, exception;

version(UCRT)
{
	pragma(lib, "ucrt.lib");
	extern(C)
	{
	int _waccess(wchar* path, int access_mode);
	int _wchmod(wchar* path, int mode);
	}
}
alias пауза пз;
alias раскройГлоб рг;

extern(C):

проц сбросьЦветКонсоли();

const ткст КОНФИГ_РЕБИЛДА;
const ткст КОНФИГ_РУЛАДЫ;
const ткст КОНФИГ_РУЛАДЫДОП;
const ткст КОНФИГ_ДИНРУС;
const ткст КОНФИГ_ДИНРУСДОП;
const ткст КОНФИГ_ДИНРУСДОПГИП;
const ткст КОНФ, СЦ_ИНИ;

static this()
{
КОНФИГ_РЕБИЛДА =рг(
"profile=phobos

compiler=%DINRUS%\\dmd.exe
inifile=%DINRUS%\\sc.ini

exeext=.exe
objext=obj
objmodsep=-


version=DigitalMars
noversion=GNU
noversion=linux
noversion=Unix
noversion=Posix
version=Windows
testversion=Win32
testversion=Win64
version=X86
noversion=PPC
noversion=X86_64
version=D_InlineAsm
version=D_InlineAsm_X86
noversion=D_InlineAsm_PPC
noversion=D_InlineAsm_X86_64
version=LittleEndian
noversion=BigEndian


[compile]
cmd=%DINRUS%\\dmd.exe -c $i
response=@

flag=$i
incdir=-I$i
libdir=-L-L$i
optimize=-O
version=-version=$i


[link]
oneatatime=yes
cmd=%DINRUS%\\dmd.exe $i -of$o
response=@

libdir=-L+$i\\
lib=-L+$i.lib
flag=-L$i
gui=-L/subsystem:windows


[liblink]
safe=yes
oneatatime=yes
cmd=%DINRUS%\\lib.exe -c -p512 $o $i
response=@

libdir=
lib=
flag=


[postliblink]
cmd=echo $i


[shliblink]
shlibs=no

[dyliblink]
dylibs=no
");

КОНФИГ_ДИНРУС =рг(
	"
[Version]
version=7.51 Build 020

#DINRUS CONSOLE SINGLE

[Environment]
PATH=%DINRUS%\\..
BIN=%DINRUS%
INCLUDE=\"%DINRUS%\\..\\include\";%INCLUDE%
LIB=\"%DINRUS%\\..\\lib\";\"%DINRUS%\\..\\lib\\rulada\";\"%DINRUS%\\..\\lib\\c\";\"%DINRUS%\\..\\lib\\sysimport\"
DFLAGS=\"-I%DINRUS%\\..\\imp\\dinrus\" -O -version=Dinrus -defaultlib=Dinrus.lib -debuglib=Dinrus.lib
LINKCMD=%DINRUS%\\dmlink.exe
	");
	
КОНФИГ_ДИНРУСДОП = рг(
	"
[Version]
version=7.51 Build 020

#DINRUS CONSOLE FULL

[Environment]
PATH=%DINRUS%\\..
BIN=%DINRUS%
INCLUDE=\"%DINRUS%\\..\\include\";%INCLUDE%
LIB=\"%DINRUS%\\..\\lib\";\"%DINRUS%\\..\\lib\\rulada\";\"%DINRUS%\\..\\lib\\c\";\"%DINRUS%\\..\\lib\\sysimport\"
DFLAGS=\"-I%DINRUS%\\..\\imp\\dinrus\" -O -version=Dinrus -defaultlib=Dinrus.lib -debuglib=Dinrus.lib -L+DinrusWin32.lib+DinrusConc.lib+import.lib+DinrusTango.lib+DinrusDbi.lib+DinrusWinDLL.lib+DinrusStd.lib
LINKCMD=%DINRUS%\\dmlink.exe
	");
	
КОНФИГ_ДИНРУСДОПГИП =рг(
	"
[Version]
version=7.51 Build 020

#DINRUS CONSOLE FULL

[Environment]
PATH=%DINRUS%\\..
BIN=%DINRUS%
INCLUDE=\"%DINRUS%\\..\\include\";%INCLUDE%
LIB=\"%DINRUS%\\..\\lib\";\"%DINRUS%\\..\\lib\\rulada\";\"%DINRUS%\\..\\lib\\c\";\"%DINRUS%\\..\\lib\\sysimport\"
DFLAGS=\"-I%DINRUS%\\..\\imp\\dinrus\" -O -version=Dinrus -defaultlib=Dinrus.lib -debuglib=Dinrus.lib -L+DinrusWin32.lib+DinrusConc.lib+import.lib+DinrusTango.lib+DinrusDbi.lib -L/exet:nt/su:windows:4.0
LINKCMD=%DINRUS%\\dmlink.exe
	");
	
КОНФИГ_РУЛАДЫ =рг(
	"
[Version]
version=7.51 Build 020

#RULADA CONSOLE SINGLE

[Environment]
PATH=%DINRUS%\\..
BIN=%DINRUS%
INCLUDE=\"%DINRUS%\\..\\include\";%INCLUDE%
LIB=\"%DINRUS%\\..\\lib\";\"%DINRUS%\\..\\lib\\rulada\";\"%DINRUS%\\..\\lib\\rulada_eng\";\"%DINRUS%\\..\\lib\\c\";\"%DINRUS%\\..\\lib\\sysimport\"
DFLAGS=\"-I%DINRUS%\\..\\imp\\rulada_eng\" -O -version=Rulada -defaultlib=rulada.lib -debuglib=rulada.lib
LINKCMD=%DINRUS%\\dmlink.exe
	");
	
КОНФИГ_РУЛАДЫДОП =рг(
	"
[Version]
version=7.51 Build 020

#RULADA CONSOLE FULL

[Environment]
PATH=%DINRUS%\\..
BIN=%DINRUS%
INCLUDE=\"%DINRUS%\\..\\include\";%INCLUDE%
LIB=\"%DINRUS%\\..\\lib\";\"%DINRUS%\\..\\lib\\rulada\";\"%DINRUS%\\..\\lib\\rulada_eng\";\"%DINRUS%\\..\\lib\\c\";\"%DINRUS%\\..\\lib\\sysimport\"
DFLAGS=\"-I%DINRUS%\\..\\imp\\rulada_eng\" -O -version=Rulada -defaultlib=rulada.lib -debuglib=rulada.lib -L+derelict.lib+tango.lib+auxc.lib+auxd.lib+amigos.lib+arc.lib+gtkD.lib+dgui.lib+DD-dwt.lib
LINKCMD=%DINRUS%\\dmlink.exe
	");
	
	КОНФ = рг("%DINRUS%\\..\\etc\\rebuild\\dmd-win");
	СЦ_ИНИ = рг("%DINRUS%\\sc.ini");
}

бул проверьЗапись(ткст файл)
{
version(UCRT) {if( _waccess(вЮ16н(файл), 2) != -1) return да;}
return нет;
}

	
проц версияДинрус()
{
	try
	{
	запиши_в(КОНФ, КОНФИГ_РЕБИЛДА);
	запиши_в(СЦ_ИНИ, КОНФИГ_ДИНРУС);
	}
	catch(ФайлИскл фи)
	{
	}
	скажифнс("Файл sc.ini изменён. Его текст теперь следующий: %s", читай_из(СЦ_ИНИ));
	нс;
	скажинс(" ВЕРСИЯ = ДИНРУС КОНСОЛЬ ");
}
	
проц версияДинрусДоп()
{
	
	try
	{
	запиши_в(КОНФ, КОНФИГ_РЕБИЛДА);
	запиши_в(СЦ_ИНИ, КОНФИГ_ДИНРУСДОП);
	}
	catch(ФайлИскл фи)
	{
	}
	скажифнс("Файл sc.ini изменён. Его текст теперь следующий: %s", читай_из(СЦ_ИНИ));
	нс;
	скажинс(" ВЕРСИЯ = ДИНРУС КОНСОЛЬ С ДОБАВОЧНЫМИ БИБЛИОТЕКАМИ");
}
	
проц версияДинрусДоп_ГИП()
{
	try
	{
	запиши_в(КОНФ, КОНФИГ_РЕБИЛДА);
	запиши_в(СЦ_ИНИ, КОНФИГ_ДИНРУСДОПГИП);
	}
	catch(ФайлИскл фи)
	{
	}
	скажифнс("Файл sc.ini изменён. Его текст теперь следующий: %s", читай_из(рг(СЦ_ИНИ)));
	нс;
	скажинс(" ВЕРСИЯ = ДИНРУС ДЛЯ ГИП-ПРИЛОЖЕНИЙ С ДОБАВОЧНЫМИ БИБЛИОТЕКАМИ ");
}
	
проц версияРулада()
{
	try
	{
	запиши_в(КОНФ, КОНФИГ_РЕБИЛДА);
	запиши_в(СЦ_ИНИ, КОНФИГ_РУЛАДЫ);	
	}
	catch(ФайлИскл фи)
	{
	}

	скажифнс("Файл sc.ini изменён. Его текст теперь следующий: %s", читай_из(рг(СЦ_ИНИ)));
	нс;
	скажинс(" ВЕРСИЯ = РУЛАДА КОНСОЛЬ ");
}
	
проц версияРуладаДоп()
{
	try
	{
	запиши_в(КОНФ, КОНФИГ_РЕБИЛДА);
	запиши_в(СЦ_ИНИ, КОНФИГ_РУЛАДЫДОП);	
	}
	catch(ФайлИскл фи)
	{
	}

	скажифнс("Файл sc.ini изменён. Его текст теперь следующий: %s", читай_из(рг(СЦ_ИНИ)));
	нс;
	скажинс(" ВЕРСИЯ = РУЛАДА КОНСОЛЬ С ДОБАВОЧНЫМИ БИБЛИОТЕКАМИ");
}
/+
	
version(DinrusExG)
{

	проц main()
	{
	версияДинрусДоп_ГИП();
		выход(0);
	}

}

version(DinrusEx)
{

	проц main()
	{
	версияДинрусДоп();
		выход(0);
	}

}

version(DR)
{

	проц main()
	{
	версияДинрус();
		выход(0);
	}

}

version(RD)
{

	проц main()
	{
	версияРулада();
		выход(0);
	}

}

version(RuladaEx)
{

	проц main()
	{
	версияРуладаДоп();
		выход(0);
	}

}
+/