//Автор Кристофер Миллер. Переработано для Динрус Виталием Кулич.
//Библиотека визуальных конпонентов VIZ (первоначально DFL).


module viz.resources;

private import viz.common;

const LPCSTR RT_STRING = MAKEINTRESOURCEA(6);
version(VIZ_NO_RESOURCES)
{
}
else
{
	/*export*/	class Ресурсы // docmain
	{
	/*export*/
		this(экз экземп, WORD язык = 0, бул owned = нет)
		{
			this.hinst = экземп;
			this.lang = язык;
			this._owned = owned;
		}
		
		
		// Note: libName gets unloaded and may take down все its ресурсы with it.
		this(Ткст libName, WORD язык = 0)
		{
			экз экземп;
			экземп = загрузиБиблиотекуДоп(libName, LOAD_LIBRARY_AS_DATAFILE);
			if(!экземп)
				throw new ВизИскл("Не удаётся загрузить ресурсы из '" ~ libName ~ "'");
			this(экземп, язык, да); // Owned.
		}
		
		/+ // Let's not depend on Приложение; the user can do so if they wish.
		
		this(WORD язык = 0)
		{
			this(Приложение.дайЭкз(), язык);
		}
		+/
		
		
		проц вымести()
		{
			assert(_owned);
			//if(hinst != Приложение.дайЭкз()) // ?
				FreeLibrary(cast(HINSTANCE) hinst);
			hinst = пусто;
		}
		
		
		final WORD язык() // getter
		{
			return lang;
		}
		
		
		final Пиктограмма дайПиктограмму(цел id, бул дефРазм = да)
		in
		{
			assert(id >= WORD.min && id <= WORD.max);
		}
		body
		{
			/+
			HICON hi;
			hi = LoadIconA(hinst, cast(LPCSTR)cast(WORD)id);
			if(!hi)
				return пусто;
			return Пиктограмма.поУказателю(hi);
			+/
			HICON hi;
			hi = cast(HICON)LoadImageA(hinst, cast(LPCSTR)cast(WORD)id, IMAGE_ICON,
				0, 0, дефРазм ? (LR_DEFAULTSIZE | LR_SHARED) : 0);
			if(!hi)
				return пусто;
			return new Пиктограмма(hi, да); // Owned.
		}		
		
		final Пиктограмма дайПиктограмму(Ткст имя, бул дефРазм = да)
		{
			/+
			HICON hi;
			hi = LoadIconA(hinst, небезопТкст0(имя));
			if(!hi)
				return пусто;
			return Пиктограмма.поУказателю(hi);
			+/
			HICON hi;
			hi = cast(HICON)загрузиРисунок(hinst, имя, IMAGE_ICON,
				0, 0, дефРазм ? (LR_DEFAULTSIZE | LR_SHARED) : 0);
			if(!hi)
				return пусто;
			return new Пиктограмма(hi, да); // Owned.
		}		
		
		final Пиктограмма дайПиктограмму(цел id, цел ширина, цел высота)
		in
		{
			assert(id >= WORD.min && id <= WORD.max);
		}
		body
		{
			// Can't have размер 0 (plus causes Windows to use the actual размер).
			//if(ширина <= 0 || высота <= 0)
			//	_noload("пиктограмма");
			HICON hi;
			hi = cast(HICON)LoadImageA(hinst, cast(LPCSTR)cast(WORD)id, IMAGE_ICON,
				ширина, высота, 0);
			if(!hi)
				return пусто;
			return new Пиктограмма(hi, да); // Owned.
		}
				
		final Пиктограмма дайПиктограмму(Ткст имя, цел ширина, цел высота)
		{
			// Can't have размер 0 (plus causes Windows to use the actual размер).
			//if(ширина <= 0 || высота <= 0)
			//	_noload("пиктограмма");
			HICON hi;
			hi = cast(HICON)загрузиРисунок(hinst, имя, IMAGE_ICON,
				ширина, высота, 0);
			if(!hi)
				return пусто;
			return new Пиктограмма(hi, да); // Owned.
		}
		
		deprecated alias дайПиктограмму loadIcon;
		
		
		final Битмап дайБитмап(цел id)
		in
		{
			assert(id >= WORD.min && id <= WORD.max);
		}
		body
		{
			HBITMAP h;
			h = cast(HBITMAP)LoadImageA(hinst, cast(LPCSTR)cast(WORD)id, IMAGE_BITMAP,
				0, 0, 0);
			if(!h)
				return пусто;
			return new Битмап(h, да); // Owned.
		}
		
		
		final Битмап дайБитмап(Ткст имя)
		{
			HBITMAP h;
			h = cast(HBITMAP)загрузиРисунок(hinst, имя, IMAGE_BITMAP,
				0, 0, 0);
			if(!h)
				return пусто;
			return new Битмап(h, да); // Owned.
		}
		
		deprecated alias дайБитмап loadBitmap;
		
		
				final Курсор дайКурсор(цел id)
		in
		{
			assert(id >= WORD.min && id <= WORD.max);
		}
		body
		{
			УКурсор h;
			h = cast(УКурсор)LoadImageA(hinst, cast(LPCSTR)cast(WORD)id, IMAGE_CURSOR,
				0, 0, 0);
			if(!h)
				return пусто;
			return new Курсор(h, да); // Owned.
		}
		
		
		final Курсор дайКурсор(Ткст имя)
		{
			УКурсор h;
			h = cast(УКурсор)загрузиРисунок(hinst, имя, IMAGE_CURSOR,
				0, 0, 0);
			if(!h)
				return пусто;
			return new Курсор(h, да); // Owned.
		}
		
		deprecated alias дайКурсор loadCursor;
		
		
		final Ткст дайЮ8(цел id)
		in
		{
			assert(id >= WORD.min && id <= WORD.max);
		}
		body
		{
			// Not casting to wDstring because а resource isn't guaranteed to be the same размер.
			шткст0 ws = cast(шткст0)_getData(cast(LPCWSTR)RT_STRING, cast(LPCWSTR)cast(WORD)(id / 16 + 1)).ptr;
			Ткст результат;
			if(ws)
			{
				цел i;
				for(i = 0; i < (id & 15); i++)
				{
					ws += 1 + cast(т_мера)*ws;
				}
				результат = вЮ8((ws + 1)[0 .. cast(т_мера)*ws]);
			}
			return результат;
		}
		
		deprecated alias дайЮ8 loadString;
		
		
		// Used internally
		// NOTE: win9x doesn't like these strings to be on the heap!
		final проц[] _getData(LPCWSTR тип, LPCWSTR имя) // internal
		{
			HRSRC hrc;
			hrc = FindResourceExW(cast(HINSTANCE)hinst, тип, имя, lang);
			if(!hrc)
				return пусто;
			HGLOBAL hg = LoadResource(cast(HINSTANCE) hinst, hrc);
			if(!hg)
				return пусто;
			LPVOID pv = LockResource(hg);
			if(!pv)
				return пусто;
			return pv[0 .. SizeofResource(cast(HINSTANCE) hinst, hrc)];
		}
		
				final проц[] получитьДанные(цел тип, цел id)
		in
		{
			assert(тип >= WORD.min && тип <= WORD.max);
			assert(id >= WORD.min && id <= WORD.max);
		}
		body
		{
			return _getData(cast(LPCWSTR)тип, cast(LPCWSTR)id);
		}
		
		
		final проц[] получитьДанные(Ткст тип, цел id)
		in
		{
			assert(id >= WORD.min && id <= WORD.max);
		}
		body
		{
			return _getData(вЮ16н(тип), cast(LPCWSTR)id);
		}
		
		
		final проц[] получитьДанные(цел тип, Ткст имя)
		in
		{
			assert(тип >= WORD.min && тип <= WORD.max);
		}
		body
		{
			return _getData(cast(LPCWSTR)тип, вЮ16н(имя));
		}
		
		
		final проц[] получитьДанные(Ткст тип, Ткст имя)
		{
			return _getData(вЮ16н(тип), вЮ16н(имя));
		}
		
		
		~this()
		{
			if(_owned)
				вымести();
		}
		
		
		private:
		
		экз hinst;
		WORD lang = 0;
		бул _owned = нет;
		
		
		проц _noload(Ткст тип)
		{
			throw new ВизИскл("Не удаётся загрузить ресурс " ~ тип);
		}
	}
}

