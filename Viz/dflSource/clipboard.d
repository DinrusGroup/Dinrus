//Автор Кристофер Миллер. Переработано для Динрус Виталием Кулич.
//Библиотека визуальных конпонентов VIZ (первоначально DFL).


/// Interfacing with the system clipboard for копируй and вставь operations.
module viz.clipboard;

private import viz.base, viz.x.winapi, viz.data, viz.x.wincom,
	viz.x.dlib;


class Clipboard // docmain
{
	private this() {}
	
	
	static:
	
		viz.data.ИОбъектДанных getDataObject()
	{
		viz.x.wincom.ИОбъектДанных comdobj;
		if(S_OK != OleGetClipboard(&comdobj))
			throw new ВизИскл("Unable to obtain clipboard данные object");
		if(comdobj is comd)
			return dd;
		//delete dd;
		comd = comdobj;
		return dd = new КомВОбъектДанных(comdobj);
	}
	
	
	проц setDataObject(Данные объ, бул persist = нет)
	{
		comd = пусто;
		/+
		Объект ddd;
		ddd = cast(Объект)dd;
		delete ddd;
		+/
		dd = пусто;
		objref = пусто;
		
		if(объ.инфо)
		{
			if(cast(TypeInfo_Class)объ.инфо)
			{
				Объект foo;
				foo = объ.дайОбъект();
				
				/+
				if(cast(Битмап)foo)
				{
					// ...
				}
				else +/ if(cast(viz.data.ИОбъектДанных)foo)
				{
					dd = cast(viz.data.ИОбъектДанных)foo;
					objref = foo;
				}
				else
				{
					// Can't установи any old class object.
					throw new ВизИскл("Unknown данные object");
				}
			}
			else if(объ.инфо == typeid(viz.data.ИОбъектДанных))
			{
				dd = объ.дайЗначение!(viz.data.ИОбъектДанных)();
				objref = cast(Объект)dd;
			}
			else if(cast(TypeInfo_Interface)объ.инфо)
			{
				// Can't установи any old interface.
				throw new ВизИскл("Unknown данные object");
			}
			else
			{
				ОбъектДанных foo = new ОбъектДанных;
				dd = foo;
				objref = foo;
				dd.установиДанные(объ);
			}
			
			assert(!(dd is пусто));
			comd = new DtoComDataObject(dd);
			if(S_OK != OleSetClipboard(comd))
			{
				comd = пусто;
				//delete dd;
				dd = пусто;
				goto err_set;
			}
			
			if(persist)
				OleFlushClipboard();
		}
		else
		{
			dd = пусто;
			if(S_OK != OleSetClipboard(пусто))
				goto err_set;
		}
		
		return;
		err_set:
		throw new ВизИскл("Unable to установи clipboard данные");
	}
	
	
	проц setDataObject(viz.data.ИОбъектДанных объ, бул persist = нет)
	{
		setDataObject(Данные(объ), persist);
	}
	
	
		проц setString(Ткст str, бул persist = нет)
	{
		setDataObject(Данные(str), persist);
	}
	
	
	Ткст дайЮ8()
	{
		viz.data.ИОбъектДанных ido;
		ido = getDataObject();
		if(ido.дайИмеющиесяДанные(ФорматыДанных.utf8))
			return ido.получитьДанные(ФорматыДанных.utf8).дайЮ8();
		return пусто; // ?
	}
	
	
		// ANSI текст.
	проц setText(ббайт[] ansiText, бул persist = нет)
	{
		setDataObject(Данные(ansiText), persist);
	}
	
	
	ббайт[] дайТекст()
	{
		viz.data.ИОбъектДанных ido;
		ido = getDataObject();
		if(ido.дайИмеющиесяДанные(ФорматыДанных.текст))
			return ido.получитьДанные(ФорматыДанных.текст).дайТекст();
		return пусто; // ?
	}
	
	
	private:
	viz.x.wincom.ИОбъектДанных comd;
	viz.data.ИОбъектДанных dd;
	Объект objref; // Prevent dd from being garbage collected!
	
	
	/+
	static ~this()
	{
		Объект ddd;
		ddd = cast(Объект)dd;
		delete ddd;
	}
	+/
}

