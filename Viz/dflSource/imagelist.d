//Автор Кристофер Миллер. Переработано для Динрус Виталием Кулич.
//Библиотека визуальных конпонентов VIZ (первоначально DFL).


module viz.imagelist;

import viz.base, viz.drawing, viz.x.winapi;
import viz.collections;


version(VIZ_NO_IMAGELIST)
{
}
else
{
		class ImageList // docmain
	{
				class ImageCollection
		{
			protected this()
			{
			}
			
			
			проц вставь(цел индекс, Рисунок img)
			{
				if(индекс >= _images.length)
				{
					добавь(img);
				}
				else
				{
					assert(0, "Must добавь images to the end of the рисунок list");
				}
			}
			
			
			final проц addStrip(Рисунок img)
			{
				HGDIOBJ hgo;
				if(1 != img._imgtype(&hgo))
				{
					debug
					{
						assert(0, "Рисунок list: addStrip needs битмап");
					}
					_unableimg();
				}
				
				auto разм = imageSize;
				if(img.высота != разм.высота
					|| img.ширина % разм.ширина)
				{
					debug
					{
						assert(0, "Рисунок list: invalid рисунок размер");
					}
					_unableimg();
				}
				цел num = img.ширина / разм.ширина;
				
				/+
				if(1 == num)
				{
					добавь(img);
					return;
				}
				+/
				
				auto _hdl = указатель; // _addhbitmap needs the указатель! Could avoid this in the future.
				_addhbitmap(hgo);
				
				цел ш = 0;
				for(; num; num--)
				{
					auto sp = new StripPart();
					sp.origImg = img;
					sp.hbm = hgo;
					sp.partBounds = Прям(ш, 0, разм.ширина, разм.высота);
					
					_images ~= sp;
					
					ш += разм.ширина;
				}
			}
			
			
			package:
			
			Рисунок[] _images;
			
			
			static class StripPart: Рисунок
			{
				override Размер размер() // getter
				{
					return partBounds.размер;
				}
				
				
				override проц рисуй(Графика з, Точка тчк)
				{
					HDC memdc;
					memdc = CreateCompatibleDC(з.указатель);
					try
					{
						HGDIOBJ hgo;
						hgo = SelectObject(memdc, hbm);
						BitBlt(з.указатель, тчк.ш, тчк.в, partBounds.ширина, partBounds.высота, memdc, partBounds.ш, partBounds.в, SRCCOPY);
						SelectObject(memdc, hgo); // Old битмап.
					}
					finally
					{
						DeleteDC(memdc);
					}
				}
				
				
				override проц рисуйРастяни(Графика з, Прям к)
				{
					HDC memdc;
					memdc = CreateCompatibleDC(з.указатель);
					try
					{
						HGDIOBJ hgo;
						цел lstretch;
						hgo = SelectObject(memdc, hbm);
						lstretch = SetStretchBltMode(з.указатель, COLORONCOLOR);
						StretchBlt(з.указатель, к.ш, к.в, к.ширина, к.высота,
							memdc, partBounds.ш, partBounds.в, partBounds.ширина, partBounds.высота, SRCCOPY);
						SetStretchBltMode(з.указатель, lstretch);
						SelectObject(memdc, hgo); // Old битмап.
					}
					finally
					{
						DeleteDC(memdc);
					}
				}
				
				
				Рисунок origImg; // Hold this so the HBITMAP doesn't get collected.
				HBITMAP hbm;
				Прям partBounds;
			}
			
			
			проц _adding(т_мера idx, Рисунок val)
			{
				assert(val !is пусто);
				
				switch(val._imgtype(пусто))
				{
					case 1:
					case 2:
						break;
					default:
						debug
						{
							assert(0, "Рисунок list: invalid рисунок тип");
						}
						_unableimg();
				}
				
				if(val.размер != imageSize)
				{
					debug
					{
						assert(0, "Рисунок list: invalid рисунок размер");
					}
					_unableimg();
				}
			}
			
			
			проц _added(т_мера idx, Рисунок val)
			{
				if(созданУказатель_ли)
				{
					//if(idx >= _images.length) // Can't test for this here because -val- is already added to the массив.
					_addimg(val);
				}
			}
			
			
			проц _removed(т_мера idx, Рисунок val)
			{
				if(созданУказатель_ли)
				{
					if(т_мера.max == idx) // Clear все.
					{
						imageListRemove(указатель, -1);
					}
					else
					{
						imageListRemove(указатель, idx);
					}
				}
			}
			
			
			public:
			
			mixin ListWrapArray!(Рисунок, _images,
				_adding, _added,
				_blankListCallback!(Рисунок), _removed,
				нет, нет, нет);
		}
		
		
		this()
		{
			InitCommonControls();
			
			_cimages = new ImageCollection();
			_transcolor = Цвет.прозрачный;
		}
		
		
				final проц colorDepth(ГлубинаЦвета depth) // setter
		{
			assert(!созданУказатель_ли);
			
			this._depth = depth;
		}
		
		
		final ГлубинаЦвета colorDepth() // getter
		{
			return _depth;
		}
		
		
				final проц transparentColor(Цвет tc) // setter
		{
			assert(!созданУказатель_ли);
			
			_transcolor = tc;
		}
		
		
		final Цвет transparentColor() // getter
		{
			return _transcolor;
		}
		
		
				final проц imageSize(Размер разм) // setter
		{
			assert(!созданУказатель_ли);
			
			assert(разм.ширина && разм.высота);
			
			_w = разм.ширина;
			_h = разм.высота;
		}
		
		
		final Размер imageSize() // getter
		{
			return Размер(_w, _h);
		}
		
		
				final ImageCollection images() // getter
		{
			return _cimages;
		}
		
		
				final проц тэг(Объект t) // setter
		{
			this._tag = t;
		}
		
		
		final Объект тэг() // getter
		{
			return this._tag;
		}
		
		
		/+ // Actually, forget about these; just рисуй with the actual images.
				final проц рисуй(Графика з, Точка тчк, цел индекс)
		{
			return рисуй(з, тчк.ш, тчк.в, индекс);
		}
		
		
		final проц рисуй(Графика з, цел ш, цел в, цел индекс)
		{
			imageListDraw(указатель, индекс, з.указатель, ш, в, ILD_NORMAL);
		}
		
		
		// stretch
		final проц рисуй(Графика з, цел ш, цел в, цел ширина, цел высота, цел индекс)
		{
			// ImageList_DrawEx operates differently if the ширина or высота is zero
			// so bail out if zero and pretend the zero размер рисунок was drawn.
			if(!ширина)
				return;
			if(!высота)
				return;
			
			imageListDrawEx(указатель, индекс, з.указатель, ш, в, ширина, высота,
				CLR_NONE, CLR_NONE, ILD_NORMAL); // ?
		}
		+/
		
		
				final бул созданУказатель_ли() // getter
		{
			return HIMAGELIST.init != _hil;
		}
		
		deprecated alias созданУказатель_ли созданУказатель;
		
		
				final HIMAGELIST указатель() // getter
		{
			if(!созданУказатель_ли)
				_createimagelist();
			return _hil;
		}
		
		
				проц вымести()
		{
			return вымести(да);
		}
		
		
		проц вымести(бул вымещается)
		{
			if(созданУказатель_ли)
				imageListDestroy(_hil);
			_hil = HIMAGELIST.init;
			
			if(вымещается)
			{
				//_cimages._images = пусто; // Not GC-safe in dtor.
				//_cimages = пусто; // Could cause bad things.
			}
		}
		
		
		~this()
		{
			вымести();
		}
		
		
		private:
		
		ГлубинаЦвета _depth = ГлубинаЦвета.БИТ8;
		Цвет _transcolor;
		ImageCollection _cimages;
		HIMAGELIST _hil;
		цел _w = 16, _h = 16;
		Объект _tag;
		
		
		проц _createimagelist()
		{
			if(созданУказатель_ли)
			{
				imageListDestroy(_hil);
				_hil = HIMAGELIST.init;
			}
			
			UINT флаги = ILC_MASK;
			switch(_depth)
			{
				case ГлубинаЦвета.БИТ4:          флаги |= ILC_COLOR4;  break;
				default: case ГлубинаЦвета.БИТ8: флаги |= ILC_COLOR8;  break;
				case ГлубинаЦвета.БИТ16:         флаги |= ILC_COLOR16; break;
				case ГлубинаЦвета.БИТ24:         флаги |= ILC_COLOR24; break;
				case ГлубинаЦвета.БИТ32:         флаги |= ILC_COLOR32; break;
			}
			
			// Note: cGrow is not а limit, but how many images to preallocate each grow.
			_hil = imageListCreate(_w, _h, флаги, _cimages._images.length, 4 + _cimages._images.length / 4);
			if(!_hil)
				throw new ВизИскл("Unable to create рисунок list");
			
			foreach(img; _cimages._images)
			{
				_addimg(img);
			}
		}
		
		
		проц _unableimg()
		{
			throw new ВизИскл("Unable to добавь рисунок to рисунок list");
		}
		
		
		цел _addimg(Рисунок img)
		{
			assert(созданУказатель_ли);
			
			HGDIOBJ hgo;
			цел результат;
			switch(img._imgtype(&hgo))
			{
				case 1:
					результат = _addhbitmap(hgo);
					break;
				
				case 2:
					результат = imageListAddIcon(_hil, cast(HICON)hgo);
					break;
				
				default:
					результат = -1;
			}
			
			//if(-1 == результат)
			//	_unableimg();
			return результат;
		}
		
		цел _addhbitmap(HBITMAP hbm)
		{
			assert(созданУказатель_ли);
			
			COLORREF cr;
			if(_transcolor == Цвет.пуст
				|| _transcolor == Цвет.прозрачный)
			{
				cr = CLR_NONE; // ?
			}
			else
			{
				cr = _transcolor.вКзс();
			}
			return imageListAddMasked(_hil, cast(HBITMAP)hbm, cr);
		}
	}


	private extern(Windows)
	{
		// This was the only way I could figure out how to use the текущий actctx (Windows issue).
		
		HIMAGELIST imageListCreate(
			цел cx, цел cy, UINT флаги, цел cInitial, цел cGrow)
		{
			alias typeof(&ImageList_Create) TProc;
			static TProc proc = пусто;
			if(!proc)
				proc = cast(typeof(proc))GetProcAddress(GetModuleHandleA("comctl32.dll"), "ImageList_Create");
			return proc(cx, cy, флаги, cInitial, cGrow);
		}
		
		цел imageListAddIcon(
			HIMAGELIST himl, HICON hicon)
		{
			alias typeof(&ImageList_AddIcon) TProc;
			static TProc proc = пусто;
			if(!proc)
				proc = cast(typeof(proc))GetProcAddress(GetModuleHandleA("comctl32.dll"), "ImageList_AddIcon");
			return proc(himl, hicon);
		}
		
		цел imageListAddMasked(
			HIMAGELIST himl, HBITMAP hbmImage, COLORREF crMask)
		{
			alias typeof(&ImageList_AddMasked) TProc;
			static TProc proc = пусто;
			if(!proc)
				proc = cast(typeof(proc))GetProcAddress(GetModuleHandleA("comctl32.dll"), "ImageList_AddMasked");
			return proc(himl, hbmImage, crMask);
		}
		
		BOOL imageListRemove(
			HIMAGELIST himl, цел i)
		{
			alias typeof(&ImageList_Remove) TProc;
			static TProc proc = пусто;
			if(!proc)
				proc = cast(typeof(proc))GetProcAddress(GetModuleHandleA("comctl32.dll"), "ImageList_Remove");
			return proc(himl, i);
		}
		
		BOOL imageListDestroy(
			HIMAGELIST himl)
		{
			alias typeof(&ImageList_Destroy) TProc;
			static TProc proc = пусто;
			if(!proc)
				proc = cast(typeof(proc))GetProcAddress(GetModuleHandleA("comctl32.dll"), "ImageList_Destroy");
			return proc(himl);
		}
	}
}

