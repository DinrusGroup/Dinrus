//Автор Кристофер Миллер. Переработано для Динрус Виталием Кулич.
//Библиотека визуальных конпонентов VIZ (первоначально DFL).


module viz.splitter;

private import viz.control, viz.x.winapi, viz.base, viz.drawing;
private import viz.event;


class SplitterEventArgs: АргиСоб
{
		this(цел ш, цел в, цел splitX, цел splitY)
	{
		_x = ш;
		_y = в;
		_splitX = splitX;
		_splitY = splitY;
	}
	
	
		final цел ш() // getter
	{
		return _x;
	}
	
	
		final цел в() // getter
	{
		return _y;
	}
	
	
		final проц splitX(цел val) // setter
	{
		_splitX = val;
	}
	
	
	final цел splitX() // getter
	{
		return _splitX;
	}
	
	
		final проц splitY(цел val) // setter
	{
		_splitY = val;
	}
	
	
	final цел splitY() // getter
	{
		return _splitY;
	}
	
	
	private:
	цел _x, _y, _splitX, _splitY;
}


class Splitter: УпрЭлт // docmain
{
	this()
	{
		// DMD 0.95: need 'this' to access member док
		this.док = ПДокСтиль.ЛЕВ;
		
		if(HBRUSH.init == hbrxor)
			inithbrxor();
	}
	
	
	/+
	override проц anchor(ПСтилиЯкоря а) // setter
	{
		throw new ВизИскл("Splitter cannot be anchored");
	}
	
	alias УпрЭлт.anchor anchor; // Overload.
	+/
	
	
	override проц док(ПДокСтиль ds) // setter
	{
		switch(ds)
		{
			case ПДокСтиль.ЛЕВ:
			case ПДокСтиль.ПРАВ:
				//курсор = new Курсор(LoadCursorA(пусто, IDC_SIZEWE), нет);
				курсор = Курсоры.вСплит;
				break;
			
			case ПДокСтиль.ВЕРХ:
			case ПДокСтиль.НИЗ:
				//курсор = new Курсор(LoadCursorA(пусто, IDC_SIZENS), нет);
				курсор = Курсоры.гСплит;
				break;
			
			default:
				throw new ВизИскл("Invalid splitter доr");
		}
		
		super.док(ds);
	}
	
	alias УпрЭлт.док док; // Overload.
	
	
	package проц initsplit(цел sx, цел sy)
	{
		захвати = да;
		
		downing = да;
		//downpos = Точка(mea.ш, mea.в);
		
		switch(док)
		{
			case ПДокСтиль.ВЕРХ:
			case ПДокСтиль.НИЗ:
				downpos = sy;
				lastpos = 0;
				drawxorClient(0, lastpos);
				break;
			
			default: // ЛЕВ / ПРАВ.
				downpos = sx;
				lastpos = 0;
				drawxorClient(lastpos, 0);
		}
	}
	
	
	final проц resumeSplit(цел sx, цел sy) // package
	{
		if(УпрЭлт.кнопкиМыши & ПКнопкиМыши.ЛЕВ)
		{
			initsplit(sx, sy);
			
			if(курсор)
				Курсор.текущий = курсор;
		}
	}
	
	// 
	final проц resumeSplit() // package
	{
		Точка тчк = точкаККлиенту(Курсор.положение);
		return resumeSplit(тчк.ш, тчк.в);
	}
	
	
		проц movingGrip(бул подтвержд) // setter
	{
		if(mgrip == подтвержд)
			return;
		
		this.mgrip = подтвержд;
		
		if(создан)
		{
			инвалидируй();
		}
	}
	
	
	бул movingGrip() // getter
	{
		return mgrip;
	}
	
	deprecated alias movingGrip moveingGrip;
	deprecated alias movingGrip moveGrip;
	deprecated alias movingGrip sizingGrip;
	
	
	protected override проц приОтрисовке(АргиСобРис ea)
	{
		super.приОтрисовке(ea);
		
		if(mgrip)
		{
			ea.графика.drawMoveGrip(выведиПрямоугольник, ПДокСтиль.ЛЕВ == док || ПДокСтиль.ПРАВ == док);
		}
	}
	
	
	protected override проц приИзмененииРазмера(АргиСоб ea)
	{
		if(mgrip)
		{
			инвалидируй();
		}
		
		перемерка(this, ea);
	}
	
	
	protected override проц приМышиВнизу(АргиСобМыши mea)
	{
		super.приМышиВнизу(mea);
		
		if(mea.кнопка == ПКнопкиМыши.ЛЕВ && 1 == mea.клики)
		{
			initsplit(mea.ш, mea.в);
		}
	}
	
	
	protected override проц приДвиженииМыши(АргиСобМыши mea)
	{
		super.приДвиженииМыши(mea);
		
		if(downing)
		{
			switch(док)
			{
				case ПДокСтиль.ВЕРХ:
				case ПДокСтиль.НИЗ:
					drawxorClient(0, mea.в - downpos, 0, lastpos);
					lastpos = mea.в - downpos;
					break;
				
				default: // ЛЕВ / ПРАВ.
					drawxorClient(mea.ш - downpos, 0, lastpos, 0);
					lastpos = mea.ш - downpos;
			}
			
			scope sea = new SplitterEventArgs(mea.ш, mea.в, лево, верх);
			onSplitterMoving(sea);
		}
	}
	
	
	protected override проц приПеремещении(АргиСоб ea)
	{
		super.приПеремещении(ea);
		
		if(downing) // ?
		{
			Точка curpos = Курсор.положение;
			curpos = точкаККлиенту(curpos);
			scope sea = new SplitterEventArgs(curpos.ш, curpos.в, лево, верх);
			onSplitterMoved(sea);
		}
	}
	
	
	final УпрЭлт getSplitControl() // package
	{
		УпрЭлт splat; // Splitted.
		// DMD 0.95: need 'this' to access member док
		//switch(док())
		switch(this.док())
		{
			case ПДокСтиль.ЛЕВ:
				foreach(УпрЭлт упрэлм; родитель.упрэлты())
				{
					if(ПДокСтиль.ЛЕВ != упрэлм.док) //if(this.док != упрэлм.док)
						continue;
					// DMD 0.95: overloads цел(Объект o) and цел(УпрЭлт упрэлм) both match argument list for opEquals
					//if(упрэлм == this)
					if(упрэлм == cast(УпрЭлт)this)
						return splat;
					splat = упрэлм;
				}
				break;
			
			case ПДокСтиль.ПРАВ:
				foreach(УпрЭлт упрэлм; родитель.упрэлты())
				{
					if(ПДокСтиль.ПРАВ != упрэлм.док) //if(this.док != упрэлм.док)
						continue;
					// DMD 0.95: overloads цел(Объект o) and цел(УпрЭлт упрэлм) both match argument list for opEquals
					//if(упрэлм == this)
					if(упрэлм == cast(УпрЭлт)this)
						return splat;
					splat = упрэлм;
				}
				break;
			
			case ПДокСтиль.ВЕРХ:
				foreach(УпрЭлт упрэлм; родитель.упрэлты())
				{
					if(ПДокСтиль.ВЕРХ != упрэлм.док) //if(this.док != упрэлм.док)
						continue;
					// DMD 0.95: overloads цел(Объект o) and цел(УпрЭлт упрэлм) both match argument list for opEquals
					//if(упрэлм == this)
					if(упрэлм == cast(УпрЭлт)this)
						return splat;
					splat = упрэлм;
				}
				break;
			
			case ПДокСтиль.НИЗ:
				foreach(УпрЭлт упрэлм; родитель.упрэлты())
				{
					if(ПДокСтиль.НИЗ != упрэлм.док) //if(this.док != упрэлм.док)
						continue;
					// DMD 0.95: overloads цел(Объект o) and цел(УпрЭлт упрэлм) both match argument list for opEquals
					//if(упрэлм == this)
					if(упрэлм == cast(УпрЭлт)this)
						return splat;
					splat = упрэлм;
				}
				break;
		}
		return пусто;
	}
	
	
	protected override проц приМышиВверху(АргиСобМыши mea)
	{
		if(downing)
		{
			захвати = нет;
			
			downing = нет;
			
			if(mea.кнопка != ПКнопкиМыши.ЛЕВ)
			{
				// Abort.
				switch(док)
				{
					case ПДокСтиль.ВЕРХ:
					case ПДокСтиль.НИЗ:
						drawxorClient(0, lastpos);
						break;
					
					default: // ЛЕВ / ПРАВ.
						drawxorClient(lastpos, 0);
				}
				super.приМышиВверху(mea);
				return;
			}
			
			цел adj, val, vx;
			auto splat = getSplitControl(); // Splitted.
			if(splat)
			{
				// DMD 0.95: need 'this' to access member док
				//switch(док())
				switch(this.док())
				{
					case ПДокСтиль.ЛЕВ:
						drawxorClient(lastpos, 0);
						//val = лево - splat.лево + mea.ш - downpos.ш;
						val = лево - splat.лево + mea.ш - downpos;
						if(val < msize)
							val = msize;
						splat.ширина = val;
						break;
					
					case ПДокСтиль.ПРАВ:
						drawxorClient(lastpos, 0);
						//adj = право - splat.лево + mea.ш - downpos.ш;
						adj = право - splat.лево + mea.ш - downpos;
						val = splat.ширина - adj;
						vx = splat.лево + adj;
						if(val < msize)
						{
							vx -= msize - val;
							val = msize;
						}
						splat.границы = Прям(vx, splat.верх, val, splat.высота);
						break;
					
					case ПДокСтиль.ВЕРХ:
						drawxorClient(0, lastpos);
						//val = верх - splat.верх + mea.в - downpos.в;
						val = верх - splat.верх + mea.в - downpos;
						if(val < msize)
							val = msize;
						splat.высота = val;
						break;
					
					case ПДокСтиль.НИЗ:
						drawxorClient(0, lastpos);
						//adj = низ - splat.верх + mea.в - downpos.в;
						adj = низ - splat.верх + mea.в - downpos;
						val = splat.высота - adj;
						vx = splat.верх + adj;
						if(val < msize)
						{
							vx -= msize - val;
							val = msize;
						}
						splat.границы = Прям(splat.лево, vx, splat.ширина, val);
						break;
					
					default: ;
				}
			}
			
			// This is needed when the moved упрэлт first overlaps the splitter and the splitter
			// gets bumped over, causing а little area to not be updated correctly.
			// I'll fix it someday.
			родитель.инвалидируй(да);
			
			// Событие..
		}
		
		super.приМышиВверху(mea);
	}
	
	
	/+
	// Not quite sure how to implement this yet.
	// Might need to scan все упрэлты until one of:
	//    УпрЭлт with opposite док (право if лево док): stay -mextra- away from it,
	//    УпрЭлт with fill док: that упрэлт can't have less than -mextra- ширина,
	//    Reached end of child упрэлты: stay -mextra- away from the edge.
	
		final проц minExtra(цел min) // setter
	{
		mextra = min;
	}
	
	
	final цел minExtra() // getter
	{
		return mextra;
	}
	+/
	
	
		final проц minSize(цел min) // setter
	{
		msize = min;
	}
	
	
	final цел minSize() // getter
	{
		return msize;
	}
	
	
		final проц splitPosition(цел поз) // setter
	{
		auto splat = getSplitControl(); // Splitted.
		if(splat)
		{
			// DMD 0.95: need 'this' to access member док
			//switch(док())
			switch(this.док())
			{
				case ПДокСтиль.ЛЕВ:
				case ПДокСтиль.ПРАВ:
					splat.ширина = поз;
					break;
				
				case ПДокСтиль.ВЕРХ:
				case ПДокСтиль.НИЗ:
					splat.высота = поз;
					break;
				
				default: ;
			}
		}
	}
	
	
	// -1 if not docked to а упрэлт.
	final цел splitPosition() // getter
	{
		auto splat = getSplitControl(); // Splitted.
		if(splat)
		{
			// DMD 0.95: need 'this' to access member док
			//switch(док())
			switch(this.док())
			{
				case ПДокСтиль.ЛЕВ:
				case ПДокСтиль.ПРАВ:
					return splat.ширина;
				
				case ПДокСтиль.ВЕРХ:
				case ПДокСтиль.НИЗ:
					return splat.высота;
				
				default: ;
			}
		}
		return -1;
	}
	
	
	//SplitterEventHandler splitterMoved;
	Событие!(Splitter, SplitterEventArgs) splitterMoved; 	//SplitterEventHandler splitterMoving;
	Событие!(Splitter, SplitterEventArgs) splitterMoving; 	
	
	protected:
	
	override Размер дефРазм() // getter
	{
		//return Размер(GetSystemMetrics(SM_CXSIZEFRAME), GetSystemMetrics(SM_CYSIZEFRAME));
		цел sx = GetSystemMetrics(SM_CXSIZEFRAME);
		цел sy = GetSystemMetrics(SM_CYSIZEFRAME);
		// Need а bit extra room for the перемещение-grips.
		if(sx < 5)
			sx = 5;
		if(sy < 5)
			sy = 5;
		return Размер(sx, sy);
	}
	
	
		проц onSplitterMoving(SplitterEventArgs sea)
	{
		splitterMoving(this, sea);
	}
	
	
		проц onSplitterMoved(SplitterEventArgs sea)
	{
		splitterMoving(this, sea);
	}
	
	
	private:
	
	бул downing = нет;
	бул mgrip = да;
	//Точка downpos;
	цел downpos;
	цел lastpos;
	цел msize = 25; // Min размер of упрэлт that's being sized from the splitter.
	цел mextra = 25; // Min размер of the упрэлт on the opposite side.
	
	static HBRUSH hbrxor;
	
	
	static проц inithbrxor()
	{
		static ббайт[] bmbits = [0xAA, 0, 0x55, 0, 0xAA, 0, 0x55, 0,
			0xAA, 0, 0x55, 0, 0xAA, 0, 0x55, 0, ];
		
		HBITMAP hbm;
		hbm = CreateBitmap(8, 8, 1, 1, bmbits.ptr);
		hbrxor = CreatePatternBrush(hbm);
		DeleteObject(hbm);
	}
	
	
	static проц drawxor(HDC hdc, Прям к)
	{
		SetBrushOrgEx(hdc, к.ш, к.в, пусто);
		HGDIOBJ hbrold = SelectObject(hdc, hbrxor);
		PatBlt(hdc, к.ш, к.в, к.ширина, к.высота, PATINVERT);
		SelectObject(hdc, hbrold);
	}
	
	
	проц drawxorClient(HDC hdc, цел ш, цел в)
	{
		POINT тчк;
		тчк.ш = ш;
		тчк.в = в;
		//ClientToScreen(указатель, &тчк);
		MapWindowPoints(указатель, родитель.указатель, &тчк, 1);
		
		drawxor(hdc, Прям(тчк.ш, тчк.в, ширина, высота));
	}
	
	
	проц drawxorClient(цел ш, цел в, цел xold = цел.min, цел yold = цел.min)
	{
		HDC hdc;
		//hdc = GetWindowDC(пусто);
		hdc = GetDCEx(родитель.указатель, пусто, DCX_CACHE);
		
		if(xold != цел.min)
			drawxorClient(hdc, xold, yold);
		
		drawxorClient(hdc, ш, в);
		
		ReleaseDC(пусто, hdc);
	}
}

