//Автор Кристофер Миллер. Переработано для Динрус Виталием Кулич.
//Библиотека визуальных конпонентов VIZ (первоначально DFL).


module viz.messagebox;

private import viz.x.winapi, viz.x.dlib, viz.base;


enum КнопкиОкнаСооб
{
	ABORT_RETRY_IGNORE = MB_ABORTRETRYIGNORE, 	ОК = MB_OK, 
	OK_CANCEL = MB_OKCANCEL, 
	RETRY_CANCEL = MB_RETRYCANCEL, 
	YES_NO = MB_YESNO, 
	YES_NO_CANCEL = MB_YESNOCANCEL, 
}


enum ПиктограммаОкнаСооб
{
	НЕУК = 0, 	
	ASTERISK = MB_ICONASTERISK, 
	ERROR = MB_ICONERROR, 
	EXCLAMATION = MB_ICONEXCLAMATION, 
	HAND = MB_ICONHAND, 
	INFORMATION = MB_ICONINFORMATION, 
	QUESTION = MB_ICONQUESTION, 
	STOP = MB_ICONSTOP, 
	WARNING = MB_ICONWARNING, 
}


enum MsgBoxDefaultButton
{
	BUTTON1 = MB_DEFBUTTON1, 	BUTTON2 = MB_DEFBUTTON2, 
	BUTTON3 = MB_DEFBUTTON3, 
	
	// Extra.
	BUTTON4 = MB_DEFBUTTON4,
}


enum MsgBoxOptions
{
	DEFAULT_DESKTOP_ONLY = MB_DEFAULT_DESKTOP_ONLY, 	RIGHT_ALIGN = MB_RIGHT, 
	LEFT_ALIGN = MB_RTLREADING, 
	SERVICE_NOTIFICATION = MB_SERVICE_NOTIFICATION, 
}


ПРезДиалога msgBox(Ткст txt) // docmain
{
	return cast(ПРезДиалога)viz.x.utf.окноСообщ(GetActiveWindow(), txt, \0, MB_OK);
}


ПРезДиалога msgBox(ИОкно хозяин, Ткст txt) // docmain
{
	return cast(ПРезДиалога)viz.x.utf.окноСообщ(хозяин ? хозяин.указатель : GetActiveWindow(),
		txt, \0, MB_OK);
}


ПРезДиалога msgBox(Ткст txt, Ткст заглавие) // docmain
{
	return cast(ПРезДиалога)viz.x.utf.окноСообщ(GetActiveWindow(), txt, заглавие, MB_OK);
}


ПРезДиалога msgBox(ИОкно хозяин, Ткст txt, Ткст заглавие) // docmain
{
	return cast(ПРезДиалога)viz.x.utf.окноСообщ(хозяин ? хозяин.указатель : GetActiveWindow(),
		txt, заглавие, MB_OK);
}


ПРезДиалога msgBox(Ткст txt, Ткст заглавие, КнопкиОкнаСооб buttons) // docmain
{
	return cast(ПРезДиалога)viz.x.utf.окноСообщ(GetActiveWindow(), txt, заглавие, buttons);
}


ПРезДиалога msgBox(ИОкно хозяин, Ткст txt, Ткст заглавие,
	КнопкиОкнаСооб buttons) // docmain
{
	return cast(ПРезДиалога)viz.x.utf.окноСообщ(хозяин ? хозяин.указатель : GetActiveWindow(),
		txt, заглавие, buttons);
}


ПРезДиалога msgBox(Ткст txt, Ткст заглавие, КнопкиОкнаСооб buttons,
	ПиктограммаОкнаСооб пиктограмма) // docmain
{
	return cast(ПРезДиалога)viz.x.utf.окноСообщ(GetActiveWindow(), txt,
		заглавие, buttons | пиктограмма);
}


ПРезДиалога msgBox(ИОкно хозяин, Ткст txt, Ткст заглавие, КнопкиОкнаСооб buttons,
	ПиктограммаОкнаСооб пиктограмма) // docmain
{
	return cast(ПРезДиалога)viz.x.utf.окноСообщ(хозяин ? хозяин.указатель : GetActiveWindow(),
		txt, заглавие, buttons | пиктограмма);
}


ПРезДиалога msgBox(Ткст txt, Ткст заглавие, КнопкиОкнаСооб buttons, ПиктограммаОкнаСооб пиктограмма,
	MsgBoxDefaultButton defaultButton) // docmain
{
	return cast(ПРезДиалога)viz.x.utf.окноСообщ(GetActiveWindow(), txt,
		заглавие, buttons | пиктограмма | defaultButton);
}


ПРезДиалога msgBox(ИОкно хозяин, Ткст txt, Ткст заглавие, КнопкиОкнаСооб buttons,
	ПиктограммаОкнаСооб пиктограмма, MsgBoxDefaultButton defaultButton) // docmain
{
	return cast(ПРезДиалога)viz.x.utf.окноСообщ(хозяин ? хозяин.указатель : GetActiveWindow(),
		txt, заглавие, buttons | пиктограмма | defaultButton);
}


ПРезДиалога msgBox(ИОкно хозяин, Ткст txt, Ткст заглавие, КнопкиОкнаСооб buttons,
	ПиктограммаОкнаСооб пиктограмма, MsgBoxDefaultButton defaultButton, MsgBoxOptions options) // docmain
{
	return cast(ПРезДиалога)viz.x.utf.окноСообщ(хозяин ? хозяин.указатель : GetActiveWindow(),
		txt, заглавие, buttons | пиктограмма | defaultButton | options);
}


deprecated final class MessageBox
{
	private this() {}
	
	
	static:
	deprecated alias msgBox покажи;
}


deprecated alias msgBox окноСообщ;

deprecated alias MsgBoxOptions MessageBoxOptions;
deprecated alias MsgBoxDefaultButton MessageBoxDefaultButton;
deprecated alias КнопкиОкнаСооб MessageBoxButtons;
deprecated alias ПиктограммаОкнаСооб MessageBoxIcon;

