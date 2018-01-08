//Автор Кристофер Миллер. Переработано для Динрус Виталием Кулич.
//Библиотека визуальных конпонентов VIZ (первоначально DFL).


module viz.menu;

private import winapi, viz.control, viz.common, viz.collections;
private import viz.app;


version(ВИЗ_БЕЗ_МЕНЮ)
{
}
else
{
	/*export*/	class КонтекстноеМеню: Меню // docmain
	{
	/*export*/
				final проц покажи(УпрЭлт упрэлт, Точка поз)
		{
			SetForegroundWindow(упрэлт.указатель);
			TrackPopupMenu(hmenu, TPM_LEFTALIGN | TPM_LEFTBUTTON | TPM_RIGHTBUTTON,
				поз.ш, поз.в, 0, упрэлт.указатель, пусто);
		}
		
		
		//СобОбработчик всплытие;
		Событие!(КонтекстноеМеню, АргиСоб) всплытие; 		
		
		// Used internally.
		this(HMENU hmenu, бул owned = да)
		{
			super(hmenu, owned);
			
			_init();
		}
		
		
		this()
		{
			super(CreatePopupMenu());
			
			_init();
		}
		
		
		~this()
		{
			Приложение.удалиМеню(this);
			
			debug(APP_PRINT)
				скажиф("~КонтекстноеМеню\n");
		}
		
		
		 override проц поОбратномуСообщению(inout Сообщение m)
		{
			super.поОбратномуСообщению(m);
			
			switch(m.сооб)
			{
				case WM_INITMENU:
					assert(cast(HMENU)m.парам1 == указатель);
					
					//поВсплытию(АргиСоб.пуст);
					всплытие(this, АргиСоб.пуст);
					break;
				
				default: ;
			}
		}
		
		
		private:
		проц _init()
		{
			Приложение.добавьКонтекстноеМеню(this);
		}
	}


	/*export*/ class ПунктМеню: Меню // docmain
	{
	/*export*/
				final проц текст(Ткст txt) // setter
		{
			if(!элтыМеню.length && txt == SEPARATOR_TEXT)
			{
				_type(_type() | MFT_SEPARATOR);
			}
			else
			{
				if(mparent)
				{
					MENUITEMINFOA mii;
					
					if(fType & MFT_SEPARATOR)
						fType = ~MFT_SEPARATOR;
					mii.cbSize = mii.sizeof;
					mii.fMask = MIIM_TYPE | MIIM_STATE; // Not setting the состояние can cause implicit disabled/gray if the текст was пуст.
					mii.fType = fType;
					mii.fState = fState;
					//mii.dwTypeData = вТкст0(txt);
					
					mparent._setInfo(mid, нет, &mii, txt);
				}
			}
			
			mтекст = txt;
		}
		
		
		final Ткст текст() // getter
		{
			// if(mparent) fetch текст ?
			return mтекст;
		}
		
		
				final проц родитель(Меню m) // setter
		{
			m.элтыМеню.добавь(this);
		}
		
		
		final Меню родитель() // getter
		{
			return mparent;
		}
		
		
		package final проц _setParent(Меню newParent)
		{
			assert(!mparent);
			mparent = newParent;
			
			if(cast(т_мера)mindex > mparent.элтыМеню.length)
				mindex = mparent.элтыМеню.length;
			
			_setParent();
		}
		
		
		private проц _setParent()
		{
			MENUITEMINFOA mii;
			ПунктМеню miparent;
			
			mii.cbSize = mii.sizeof;
			mii.fMask = MIIM_TYPE | MIIM_STATE | MIIM_ID | MIIM_SUBMENU;
			mii.fType = fType;
			mii.fState = fState;
			mii.wID = mid;
			mii.hSubMenu = указатель;
			//if(!(fType & MFT_SEPARATOR))
			//	mii.dwTypeData = вТкст0(mтекст);
			miparent = cast(ПунктМеню)mparent;
			if(miparent && !miparent.hmenu)
			{
				miparent.hmenu = CreatePopupMenu();
				
				if(miparent.родитель() && miparent.родитель.hmenu)
				{
					MENUITEMINFOA miiPopup;
					
					miiPopup.cbSize = miiPopup.sizeof;
					miiPopup.fMask = MIIM_SUBMENU;
					miiPopup.hSubMenu = miparent.hmenu;
					miparent.родитель._setInfo(miparent._menuID, нет, &miiPopup);
				}
			}
			mparent._insert(mindex, да, &mii, (fType & MFT_SEPARATOR) ? пусто : mтекст);
		}
		
		
		package final проц _unsetParent()
		{
			assert(mparent);
			assert(mparent.элтыМеню.length > 0);
			assert(mparent.hmenu);
			
			// Last child меню item, make the родитель non-всплытие now.
			if(mparent.элтыМеню.length == 1)
			{
				ПунктМеню miparent;
				
				miparent = cast(ПунктМеню)mparent;
				if(miparent && miparent.hmenu)
				{
					MENUITEMINFOA miiPopup;
					
					miiPopup.cbSize = miiPopup.sizeof;
					miiPopup.fMask = MIIM_SUBMENU;
					miiPopup.hSubMenu = пусто;
					miparent.родитель._setInfo(miparent._menuID, нет, &miiPopup);
					
					miparent.hmenu = пусто;
				}
			}
			
			mparent = пусто;
			
			if(!Меню._compat092)
			{
				mindex = -1;
			}
		}
		
		
				final проц barBreak(бул подтвержд) // setter
		{
			if(подтвержд)
				_type(_type() | MFT_MENUBARBREAK);
			else
				_type(_type() & ~MFT_MENUBARBREAK);
		}
		
		
		final бул barBreak() // getter
		{
			return (_type() & MFT_MENUBARBREAK) != 0;
		}
		
		
		// Can't be break().
		
				final проц breakItem(бул подтвержд) // setter
		{
			if(подтвержд)
				_type(_type() | MFT_MENUBREAK);
			else
				_type(_type() & ~MFT_MENUBREAK);
		}
		
		
		final бул breakItem() // getter
		{
			return (_type() & MFT_MENUBREAK) != 0;
		}
		
		
				final проц установлен(бул подтвержд) // setter
		{
			if(подтвержд)
				_state(_state() | MFS_CHECKED);
			else
				_state(_state() & ~MFS_CHECKED);
		}
		
		
		final бул установлен() // getter
		{
			return (_state() & MFS_CHECKED) != 0;
		}
		
		
				final проц дефЭлт(бул подтвержд) // setter
		{
			if(подтвержд)
				_state(_state() | MFS_DEFAULT);
			else
				_state(_state() & ~MFS_DEFAULT);
		}
		
		
		final бул дефЭлт() // getter
		{
			return (_state() & MFS_DEFAULT) != 0;
		}
		
		
				final проц включен(бул подтвержд) // setter
		{
			if(подтвержд)
				_state(_state() & ~MFS_GRAYED);
			else
				_state(_state() | MFS_GRAYED);
		}
		
		
		final бул включен() // getter
		{
			return (_state() & MFS_GRAYED) == 0;
		}
		
		
				final проц индекс(цел idx) // setter
		{// Note: probably fails when the родитель exists because mparent is still установи and элтыМеню.вставь asserts it's пусто.
			if(mparent)
			{
				if(cast(бцел)idx > mparent.элтыМеню.length)
					throw new ВизИскл("Invalid меню индекс");
				
				//RemoveMenu(mparent.указатель, mid, MF_BYCOMMAND);
				mparent._remove(mid, MF_BYCOMMAND);
				mparent.элтыМеню._delitem(mindex);
				
				/+
				mindex = idx;
				_setParent();
				mparent.элтыМеню._additem(this);
				+/
				mparent.элтыМеню.вставь(idx, this);
			}
			
			if(Меню._compat092)
			{
				mindex = idx;
			}
		}
		
		
		final цел индекс() // getter
		{
			return mindex;
		}
		
		
		override бул родитель_ли() // getter
		{
			return указатель != пусто; // ?
		}
		
		
		deprecated final проц mergeOrder(цел ord) // setter
		{
			//mergeord = ord;
		}
		
		deprecated final цел mergeOrder() // getter
		{
			//return mergeord;
			return 0;
		}
		
		
		// TODO: mergeType().
		
		
				// Returns а NUL сим if none.
		final сим мнемоника() // getter
		{
			бул singleAmp = нет;
			
			foreach(сим ch; mтекст)
			{
				if(singleAmp)
				{
					if(ch == '&')
						singleAmp = нет;
					else
						return ch;
				}
				else
				{
					if(ch == '&')
						singleAmp = да;
				}
			}
			
			return 0;
		}
		
		
		/+
		// TODO: implement хозяин drawn menus.
		
		final проц ownerDraw(бул подтвержд)
		{
			
		}
		
		final бул ownerDraw() // getter
		{
			
		}
		+/
		
		
				final проц радиоФлажок(бул подтвержд) // setter
		{
			auto par = родитель;
			auto pidx = индекс;
			if(par)
				par.элтыМеню._removing(pidx, this);
			
			if(подтвержд)
				//_type(_type() | MFT_RADIOCHECK);
				fType |= MFT_RADIOCHECK;
			else
				//_type(_type() & ~MFT_RADIOCHECK);
				fType &= ~MFT_RADIOCHECK;
			
			if(par)
				par.элтыМеню._added(pidx, this);
		}
		
		
		final бул радиоФлажок() // getter
		{
			return (_type() & MFT_RADIOCHECK) != 0;
		}
		
		
		// TODO: быстрыйЗапуск(), showShortcut().
		
		
		/+
		// TODO: need to fake this ?
		
		final проц виден(бул подтвержд) // setter
		{
			// ?
			mvisible = подтвержд;
		}
		
		final бул виден() // getter
		{
			return mvisible;
		}
		+/
		
		
				final проц выполниКлик()
		{
			приКлике(АргиСоб.пуст);
		}
		
		
				final проц выполниВыделение()
		{
			поВыделению(АргиСоб.пуст);
		}
		
		
		// Used internally.
		this(HMENU hmenu, бул owned = да) // package
		{
			super(hmenu, owned);
			_init();
		}
		
		
				this(ПунктМеню[] элты)
		{
			if(элты.length)
			{
				HMENU hm = CreatePopupMenu();
				super(hm);
			}
			else
			{
				super();
			}
			_init();
			
			элтыМеню.добавьДиапазон(элты);
		}
		
		
		this(Ткст текст)
		{
			_init();
			
			this.текст = текст;
		}
		
		
		this(Ткст текст, ПунктМеню[] элты)
		{
			if(элты.length)
			{
				HMENU hm = CreatePopupMenu();
				super(hm);
			}
			else
			{
				super();
			}
			_init();
			
			this.текст = текст;
			
			элтыМеню.добавьДиапазон(элты);
		}
		
		
		this()
		{
			_init();
		}
		
		
		~this()
		{
			Приложение.удалиМеню(this);
			
			debug(APP_PRINT)
				скажиф("~ПунктМеню\n");
		}
		
		
		Ткст вТкст()
		{
			return текст;
		}
		
		
		override т_рав opEquals(Объект o)
		{
			return текст == дайТкстОбъекта(o);
		}
		
		
		т_рав opEquals(Ткст val)
		{
			return текст == val;
		}
		
		
		override цел opCmp(Объект o)
		{
			return сравнлюб(текст, дайТкстОбъекта(o));
		}
		
		
		цел opCmp(Ткст val)
		{
			return сравнлюб(текст, val);
		}
		
		
		 override проц поОбратномуСообщению(inout Сообщение m)
		{
			super.поОбратномуСообщению(m);
			
			switch(m.сооб)
			{
				case WM_COMMAND:
					assert(LOWORD(m.парам1) == mid);
					
					приКлике(АргиСоб.пуст);
					break;
				
				case WM_MENUSELECT:
					поВыделению(АргиСоб.пуст);
					break;
				
				case WM_INITMENUPOPUP:
					assert(!HIWORD(m.парам2));
					//assert(cast(HMENU)сооб.парам1 == mparent.указатель);
					assert(cast(HMENU)m.парам1 == указатель);
					//assert(GetMenuItemID(mparent.указатель, LOWORD(сооб.парам2)) == mid);
					
					поВсплытию(АргиСоб.пуст);
					break;
				
				default: ;
			}
		}
		
		
		//СобОбработчик клик;
		Событие!(ПунктМеню, АргиСоб) клик; 		//СобОбработчик всплытие;
		Событие!(ПунктМеню, АргиСоб) всплытие; 		//СобОбработчик выдели;
		Событие!(ПунктМеню, АргиСоб) выдели; 		
		

		
				final цел идМеню() // getter
		{
			return mid;
		}
		
		
		package final цел _menuID()
		{
			return mid;
		}
		
		
				проц приКлике(АргиСоб ea)
		{
			клик(this, ea);
		}
		
		
				проц поВсплытию(АргиСоб ea)
		{
			всплытие(this, ea);
		}
		
		
				проц поВыделению(АргиСоб ea)
		{
			выдели(this, ea);
		}
		
		
		private:
		
		цел mid; // Меню ID.
		Ткст mтекст;
		Меню mparent;
		UINT fType = 0; // MFT_*
		UINT fState = 0;
		цел mindex = -1; //0;
		//цел mergeord = 0;
		
		const Ткст SEPARATOR_TEXT = "-";
		
		static assert(!MFS_UNCHECKED);
		static assert(!MFT_STRING);
		
		
		проц _init()
		{
			if(Меню._compat092)
			{
				mindex = 0;
			}
			
			mid = Приложение.добавьПунктМеню(this);
		}
		
		
		проц _type(UINT newType) // setter
		{
			if(mparent)
			{
				MENUITEMINFOA mii;
				
				mii.cbSize = mii.sizeof;
				mii.fMask = MIIM_TYPE;
				mii.fType = newType;
				
				mparent._setInfo(mid, нет, &mii);
			}
			
			fType = newType;
		}
		
		
		UINT _type() // getter
		{
			// if(mparent) fetch значение ?
			return fType;
		}
		
		
		проц _state(UINT newState) // setter
		{
			if(mparent)
			{
				MENUITEMINFOA mii;
				
				mii.cbSize = mii.sizeof;
				mii.fMask = MIIM_STATE;
				mii.fState = newState;
				
				mparent._setInfo(mid, нет, &mii);
			}
			
			fState = newState;
		}
		
		
		UINT _state() // getter
		{
			// if(mparent) fetch значение ? No: Windows seems to добавь disabled/gray when the текст is пуст.
			return fState;
		}
	}


	/*export*/ abstract class Меню: Объект // docmain
	{
		// Retain DFL 0.9.2 compatibility.
		deprecated static проц setDFL092()
		{
			version(SET_VIZ_092)
			{
				pragma(сооб, "viz: DFL 0.9.2 compatibility установи at compile time");
			}
			else
			{
				//_compat092 = да;
				Приложение.setCompat(DflCompat.MENU_092);
			}
		}
		
		version(SET_VIZ_092)
			private const бул _compat092 = да;
		else version(VIZ_NO_COMPAT)
			private const бул _compat092 = нет;
		else
			private static бул _compat092() // getter
				{ return 0 != (Приложение._compat & DflCompat.MENU_092); }
		
		/*export*/
				static class КоллекцияЭлементовМеню
		{
		/*export*/
			 this(Меню хозяин)
			{
				_владелец = хозяин;
			}
			
			
			package final проц _additem(ПунктМеню mi)
			{
				// Fix indices after this Точка.
				цел idx;
				idx = mi.индекс + 1; // Note, not orig idx.
				if(idx < элты.length)
				{
					foreach(ПунктМеню onmi; элты[idx .. элты.length])
					{
						onmi.mindex++;
					}
				}
			}
			
			
			// Note: сотри() doesn't call this. Update: does now.
			package final проц _delitem(цел idx)
			{
				// Fix indices after this Точка.
				if(idx < элты.length)
				{
					foreach(ПунктМеню onmi; элты[idx .. элты.length])
					{
						onmi.mindex--;
					}
				}
			}
			
			
			/+
			проц вставь(цел индекс, ПунктМеню mi)
			{
				mi.mindex = индекс;
				mi._setParent(_владелец);
				_additem(mi);
			}
			+/
			
			
			проц добавь(ПунктМеню mi)
			{
				if(!Меню._compat092)
				{
					mi.mindex = length;
				}
				
				/+
				mi._setParent(_владелец);
				_additem(mi);
				+/
				вставь(mi.mindex, mi);
			}
			
			проц добавь(Ткст значение)
			{
				return добавь(new ПунктМеню(значение));
			}
			
			
			проц добавьДиапазон(ПунктМеню[] элты)
			{
				if(!Меню._compat092)
					return _wraparray.добавьДиапазон(элты);
				
				foreach(ПунктМеню it; элты)
				{
					вставь(length, it);
				}
			}
			
			проц добавьДиапазон(Ткст[] элты)
			{
				if(!Меню._compat092)
					return _wraparray.добавьДиапазон(элты);
				
				foreach(Ткст it; элты)
				{
					вставь(length, it);
				}
			}
			
			
			// TODO: finish.
			
			
			package:
			
			Меню _владелец;
			ПунктМеню[] элты; // Kept populated so the меню can be moved around.
			
			
			проц _added(т_мера idx, ПунктМеню val)
			{
				val.mindex = idx;
				val._setParent(_владелец);
				_additem(val);
			}
			
			
			проц _removing(т_мера idx, ПунктМеню val)
			{
				if(т_мера.max == idx) // Clear все.
				{
				}
				else
				{
					val._unsetParent();
					//RemoveMenu(_владелец.указатель, val._menuID, MF_BYCOMMAND);
					//_владелец._remove(val._menuID, MF_BYCOMMAND);
					_владелец._remove(idx, MF_BYPOSITION);
					_delitem(idx);
				}
			}
			
			
			public:
			
			mixin ListWrapArray!(ПунктМеню, элты,
				_blankListCallback!(ПунктМеню), _added,
				_removing, _blankListCallback!(ПунктМеню),
				да, нет, нет,
				да) _wraparray; // СТЕРЕТЬ_КАЖДЫЙ
		}
		
		
		// Extra.
		deprecated final проц opCatAssign(ПунктМеню mi)
		{
			элтыМеню.вставь(элтыМеню.length, mi);
		}
		
		
		private проц _init()
		{
			элты = new КоллекцияЭлементовМеню(this);
		}
		
		
		// Меню item that isn't всплытие (yet).
		 this()
		{
			_init();
		}
		
		
		// Used internally.
		this(HMENU hmenu, бул owned = да) // package
		{
			this.hmenu = hmenu;
			this.owned = owned;
			
			_init();
		}
		
		
		// Used internally.
		this(HMENU hmenu, ПунктМеню[] элты) // package
		{
			this.owned = да;
			this.hmenu = hmenu;
			
			_init();
			
			элтыМеню.добавьДиапазон(элты);
		}
		
		
		// Don't call directly.
		this(ПунктМеню[] элты)
		{
			/+
			this.owned = да;
			
			_init();
			
			элтыМеню.добавьДиапазон(элты);
			+/
			
			assert(0);
		}
		
		
		~this()
		{
			if(owned)
				DestroyMenu(hmenu);
		}
		
		
				final проц тэг(Объект o) // setter
		{
			ttag = o;
		}
		
		
		final Объект тэг() // getter
		{
			return ttag;
		}
		
		
				final HMENU указатель() // getter
		{
			return hmenu;
		}
		
		
				final КоллекцияЭлементовМеню элтыМеню() // getter
		{
			return элты;
		}
		
		
				бул родитель_ли() // getter
		{
			return нет;
		}
		
		
				 проц поОбратномуСообщению(inout Сообщение m)
		{
		}
		
		
		package final проц _reflectMenu(inout Сообщение m)
		{
			поОбратномуСообщению(m);
		}
		
		
		  проц _setInfo(UINT uItem, BOOL fByPosition, LPMENUITEMINFOA lpmii, Ткст typeData = пусто) // package
		{
			if(typeData.length)
			{
				if(использоватьЮникод)
				{
					static assert(MENUITEMINFOW.sizeof == MENUITEMINFOA.sizeof);
					lpmii.dwTypeData = cast(typeof(lpmii.dwTypeData))вЮни0(typeData);
					_setMenuItemInfoW(hmenu, uItem, fByPosition, cast(MENUITEMINFOW*)lpmii);
				}
				else
				{
					lpmii.dwTypeData = cast(typeof(lpmii.dwTypeData))небезопАнзи0(typeData);
					SetMenuItemInfoA(hmenu, uItem, fByPosition, lpmii);
				}
			}
			else
			{
				SetMenuItemInfoA(hmenu, uItem, fByPosition, lpmii);
			}
		}
		
		
		  проц _insert(UINT uItem, BOOL fByPosition, LPMENUITEMINFOA lpmii, Ткст typeData = пусто) // package
		{
			if(typeData.length)
			{
				if(использоватьЮникод)
				{
					static assert(MENUITEMINFOW.sizeof == MENUITEMINFOA.sizeof);
					lpmii.dwTypeData = cast(typeof(lpmii.dwTypeData))вЮни0(typeData);
					_insertMenuItemW(hmenu, uItem, fByPosition, cast(MENUITEMINFOW*)lpmii);
				}
				else
				{
					lpmii.dwTypeData = cast(typeof(lpmii.dwTypeData))небезопАнзи0(typeData);
					InsertMenuItemA(hmenu, uItem, fByPosition, lpmii);
				}
			}
			else
			{
				InsertMenuItemA(hmenu, uItem, fByPosition, lpmii);
			}
		}
		
		
		  проц _remove(UINT uPosition, UINT uFlags) // package
		{
			RemoveMenu(hmenu, uPosition, uFlags);
		}
		
		
		package HMENU hmenu;
		
		private:
		бул owned = да;
		КоллекцияЭлементовМеню элты;
		Объект ttag;
	}


/*export*/	class ГлавноеМеню: Меню // docmain
	{
	/*export*/
		// Used internally.
		this(HMENU hmenu, бул owned = да)
		{
			super(hmenu, owned);
		}
		
		
				this()
		{
			super(CreateMenu());
		}
		
		
		this(ПунктМеню[] элты)
		{
			super(CreateMenu(), элты);
		}
		
		
		  override проц _setInfo(UINT uItem, BOOL fByPosition, LPMENUITEMINFOA lpmii, Ткст typeData = пусто) // package
		{
			Меню._setInfo(uItem, fByPosition, lpmii, typeData);
			
			if(уок)
				DrawMenuBar(уок);
		}
		
		
		  override проц _insert(UINT uItem, BOOL fByPosition, LPMENUITEMINFOA lpmii, Ткст typeData = пусто) // package
		{
			Меню._insert(uItem, fByPosition, lpmii, typeData);
			
			if(уок)
				DrawMenuBar(уок);
		}
		
		
		  override проц _remove(UINT uPosition, UINT uFlags) // package
		{
			Меню._remove(uPosition, uFlags);
			
			if(уок)
				DrawMenuBar(уок);
		}
		
		
		private:
		
		УОК уок = HWND.init;
		
		
		package final проц _setHwnd(УОК уок)
		{
			this.уок = уок;
		}
	}
}

