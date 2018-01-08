//Автор Кристофер Миллер. Переработано для Динрус Виталием Кулич.
//Библиотека визуальных конпонентов VIZ (первоначально DFL).


module viz.treeview;

private import viz.x.dlib;

private import viz.control, viz.application, viz.base, viz.x.winapi;
private import viz.event, viz.drawing, viz.collections, viz.x.utf;

version(VIZ_NO_IMAGELIST)
{
}
else
{
	private import viz.imagelist;
}


private extern(Windows) проц _initTreeview();


enum TreeViewAction: ббайт
{
	UNKNOWN, 	COLLAPSE, 
	EXPAND, 
	BY_KEYBOARD, 
	BY_MOUSE, 
}


class TreeViewCancelEventArgs: АргиСобОтмены
{
		this(TreeNode node, бул отмена, TreeViewAction действие)
	{
		super(отмена);
		
		_node = node;
		_действие = действие;
	}
	
	
		final TreeViewAction действие() // getter
	{
		return _действие;
	}
	
	
		final TreeNode node() // getter
	{
		return _node;
	}
	
	
	private:
	TreeNode _node;
	TreeViewAction _действие;
}


class TreeViewEventArgs: АргиСоб
{
		this(TreeNode node, TreeViewAction действие)
	{
		_node = node;
		_действие = действие;
	}
	
	
	this(TreeNode node)
	{
		_node = node;
		//_действие = TreeViewAction.UNKNOWN;
	}
	
	
		final TreeViewAction действие() // getter
	{
		return _действие;
	}
	
	
		final TreeNode node() // getter
	{
		return _node;
	}
	
	
	private:
	TreeNode _node;
	TreeViewAction _действие = TreeViewAction.UNKNOWN;
}


class NodeLabelEditEventArgs: АргиСоб
{
		this(TreeNode node, Ткст надпись)
	{
		_node = node;
		_label = надпись;
	}
	
	
	this(TreeNode node)
	{
		_node = node;
	}
	
	
		final TreeNode node() // getter
	{
		return _node;
	}
	
	
		final Ткст надпись() // getter
	{
		return _label;
	}
	
	
		final проц cancelEdit(бул подтвержд) // setter
	{
		_cancel = подтвержд;
	}
	
	
	final бул cancelEdit() // getter
	{
		return _cancel;
	}
	
	
	private:
	TreeNode _node;
	Ткст _label;
	бул _cancel = нет;
}


class TreeNode: Объект
{
		this(Ткст labelText)
	{
		this();
		
		tтекст = labelText;
	}
	
	
	this(Ткст labelText, TreeNode[] отпрыски)
	{
		this();
		
		tтекст = labelText;
		tchildren.добавьДиапазон(отпрыски);
	}
	
	
	this()
	{
		Приложение.ppin(cast(проц*)this);
		
		/+
		зцвет = Цвет.пуст;
		пцвет = Цвет.пуст;
		+/
		
		tchildren = new TreeNodeCollection(tview, this);
	}
	
	this(Объект val) // package
	{
		this(дайТкстОбъекта(val));
	}
	
	
	/+
		final проц цветФона(Цвет ктрл) // setter
	{
		зцвет = ктрл;
	}
	
	
	final Цвет цветФона() // getter
	{
		return зцвет;
	}
	+/
	
	
		final Прям границы() // getter
	{
		Прям результат;
		
		if(создан)
		{
			RECT rect;
			*(cast(HTREEITEM*)&rect) = hnode;
			if(SendMessageA(tview.указатель, TVM_GETITEMRECT, FALSE, cast(LPARAM)&rect))
			{
				результат = Прям(&rect);
			}
		}
		
		return результат;
	}
	
	
		final TreeNode firstNode() // getter
	{
		if(tchildren.length)
			return tchildren._nodes[0];
		return пусто;
	}
	
	
	/+
		final проц цветПП(Цвет ктрл) // setter
	{
		пцвет = ктрл;
	}
	
	
	final Цвет цветПП() // getter
	{
		return пцвет;
	}
	+/
	
	
		// Path from the root to this node.
	final Ткст fullPath() // getter
	{
		if(!tparent)
			return tтекст;
		
		// Might want to manually loop through parents and preallocate the whole buffer.
		assert(tview !is пусто);
		дим sep;
		sep = tview.pathSeparator;
		//return std.string.format("%s%s%s", tparent.fullPath, sep, tтекст);
		сим[4] ssep;
		цел sseplen = 0;
		foreach(сим ch; (&sep)[0 .. 1])
		{
			ssep[sseplen++] = ch;
		}
		//return tparent.fullPath ~ ssep[0 .. sseplen] ~ tтекст;
		return tparent.fullPath ~ cast(Ткст)ssep[0 .. sseplen] ~ tтекст; // Needed in D2.
	}
	
	
		final HTREEITEM указатель() // getter
	{
		return hnode;
	}
	
	
		// Index of this node in the родитель node.
	final цел индекс() // getter
	{
		цел результат = -1;
		if(tparent)
		{
			результат = tparent.tchildren.индексУ(this);
			assert(результат != -1);
		}
		return результат;
	}
	
	
	/+
		final бул isEditing() // getter
	{
	}
	+/
	
	
		final бул isExpanded() // getter
	{
		return isState(TVIS_EXPANDED);
	}
	
	
		final бул isSelected() // getter
	{
		return isState(TVIS_SELECTED);
	}
	
	
	/+
		final бул isVisible() // getter
	{
	}
	+/
	
	
		final TreeNode lastNode() // getter
	{
		if(tchildren.length)
			return tchildren._nodes[tchildren.length - 1];
		return пусто;
	}
	
	
		// Next sibling node.
	final TreeNode nextNode() // getter
	{
		if(tparent)
		{
			цел i;
			i = tparent.tchildren.индексУ(this);
			assert(i != -1);
			
			i++;
			if(i != tparent.tchildren.length)
				return tparent.tchildren._nodes[i];
		}
		return пусто;
	}
	
	
	/+
		final проц nodeFont(Шрифт f) // setter
	{
		tfont = f;
	}
	
	
	final Шрифт nodeFont() // getter
	{
		return tfont;
	}
	+/
	
	
		final TreeNodeCollection nodes() // getter
	{
		return tchildren;
	}
	
	
		final TreeNode родитель() // getter
	{
		return tparent;
	}
	
	
		// Previous sibling node.
	final TreeNode prevNode() // getter
	{
		if(tparent)
		{
			цел i;
			i = tparent.tchildren.индексУ(this);
			assert(i != -1);
			
			if(i)
			{
				i--;
				return tparent.tchildren._nodes[i];
			}
		}
		return пусто;
	}
	
	
		final проц тэг(Объект o) // setter
	{
		ttag = o;
	}
	
	
	final Объект тэг() // getter
	{
		return ttag;
	}
	
	
		final проц текст(Ткст newText) // setter
	{
		tтекст = newText;
		
		if(создан)
		{
			TV_ITEMA item;
			Сообщение m;
			
			item.mask = TVIF_HANDLE | TVIF_TEXT;
			item.hItem = hnode;
			/+
			item.pszText = вТкст0(tтекст);
			//item.cchTextMax = tтекст.length; // ?
			m = Сообщение(tview.указатель, TVM_SETITEMA, 0, cast(LPARAM)&item);
			+/
			if(viz.x.utf.использоватьЮникод)
			{
				item.pszText = cast(typeof(item.pszText))viz.x.utf.вЮни0(tтекст);
				m = Сообщение(tview.указатель, TVM_SETITEMW, 0, cast(LPARAM)&item);
			}
			else
			{
				item.pszText = cast(typeof(item.pszText))viz.x.utf.небезопАнзи0(tтекст);
				m = Сообщение(tview.указатель, TVM_SETITEMA, 0, cast(LPARAM)&item);
			}
			tview.предшОкПроц(m);
		}
	}
	
	
	final Ткст текст() // getter
	{
		return tтекст;
	}
	
	
		// Get the TreeView упрэлт this node belongs to.
	final TreeView treeView() // getter
	{
		return tview;
	}
	
	
		final проц beginEdit()
	{
		if(создан)
		{
			SetFocus(tview.уок); // Needs to have фокус.
			УОК hwEdit;
			hwEdit = cast(УОК)SendMessageA(tview.уок, TVM_EDITLABELA, 0, cast(LPARAM)hnode);
			if(!hwEdit)
				goto err_edit;
		}
		else
		{
			err_edit:
			throw new ВизИскл("Не удаётся редактировать узел дерева");
		}
	}
	
	
	/+
		final проц endEdit(бул отмена)
	{
		// ?
	}
	+/
	
	
		final проц ensureVisible()
	{
		if(создан)
		{
			SendMessageA(tview.уок, TVM_ENSUREVISIBLE, 0, cast(LPARAM)hnode);
		}
	}
	
	
		final проц collapse()
	{
		if(создан)
		{
			SendMessageA(tview.уок, TVM_EXPAND, TVE_COLLAPSE, cast(LPARAM)hnode);
		}
	}
	
	
		final проц expand()
	{
		if(создан)
		{
			SendMessageA(tview.уок, TVM_EXPAND, TVE_EXPAND, cast(LPARAM)hnode);
		}
	}
	
	
		final проц expandAll()
	{
		if(создан)
		{
			SendMessageA(tview.уок, TVM_EXPAND, TVE_EXPAND, cast(LPARAM)hnode);
			
			foreach(TreeNode node; tchildren._nodes)
			{
				node.expandAll();
			}
		}
	}
	
	
		static TreeNode поУказателю(TreeView tree, HTREEITEM указатель)
	{
		return tree.treeNodeFromHandle(указатель);
	}
	
	
		final проц удали()
	{
		if(tparent)
			tparent.tchildren.удали(this);
		else if(tview) // It's а верх level node.
			tview.tchildren.удали(this);
	}
	
	
		final проц toggle()
	{
		if(создан)
		{
			SendMessageA(tview.уок, TVM_EXPAND, TVE_TOGGLE, cast(LPARAM)hnode);
		}
	}
	
	
	version(VIZ_NO_IMAGELIST)
	{
	}
	else
	{
				final проц imageIndex(цел индекс) // setter
		{
			this._imgidx = индекс;
			
			if(создан)
			{
				TV_ITEMA item;
				Сообщение m;
				
				item.mask = TVIF_HANDLE | TVIF_IMAGE;
				item.hItem = hnode;
				item.iImage = _imgidx;
				if(tview._selimgidx < 0)
				{
					item.mask |= TVIF_SELECTEDIMAGE;
					item.iSelectedImage = _imgidx;
				}
				tview.предшОкПроц(m);
			}
		}
		
		
		final цел imageIndex() // getter
		{
			return _imgidx;
		}
	}
	
	
	Ткст вТкст()
	{
		return tтекст;
	}
	
	
	override т_рав opEquals(Объект o)
	{
		return 0 == сравнлюб(tтекст, дайТкстОбъекта(o)); // ?
	}
	
	т_рав opEquals(TreeNode node)
	{
		return 0 == сравнлюб(tтекст, node.tтекст);
	}
	
	т_рав opEquals(Ткст val)
	{
		return 0 == сравнлюб(tтекст, val);
	}
	
	
	override цел opCmp(Объект o)
	{
		return сравнлюб(tтекст, дайТкстОбъекта(o)); // ?
	}
	
	цел opCmp(TreeNode node)
	{
		return сравнлюб(tтекст, node.tтекст);
	}
	
	цел opCmp(Ткст val)
	{
		return сравнлюб(текст, val);
	}
	
	
	private:
	Ткст tтекст;
	TreeNode tparent;
	TreeNodeCollection tchildren;
	Объект ttag;
	HTREEITEM hnode;
	TreeView tview;
	version(VIZ_NO_IMAGELIST)
	{
	}
	else
	{
		цел _imgidx = -1;
	}
	/+
	Цвет зцвет, пцвет;
	Шрифт tfont;
	+/
	
	
	package final бул создан() // getter
	{
		if(tview && tview.создан())
		{
			assert(hnode);
			return да;
		}
		return нет;
	}
	
	
	бул isState(UINT состояние)
	{
		if(создан)
		{
			TV_ITEMA ti;
			ti.mask = TVIF_HANDLE | TVIF_STATE;
			ti.hItem = hnode;
			ti.stateMask = состояние;
			if(SendMessageA(tview.указатель, TVM_GETITEMA, 0, cast(LPARAM)&ti))
			{
				if(ti.состояние & состояние)
					return да;
			}
		}
		return нет;
	}
	
	
	проц _reset()
	{
		hnode = пусто;
		tview = пусто;
		tparent = пусто;
	}
}


class TreeNodeCollection
{
	проц добавь(TreeNode node)
	{
		//эхо("Adding node %p '%.*s'\n", cast(проц*)node, дайТкстОбъекта(node));
		
		цел i;
		
		if(tview && tview.сортированный())
		{
			// Insertion sort.
			
			for(i = 0; i != _nodes.length; i++)
			{
				if(node < _nodes[i])
					break;
			}
		}
		else
		{
			i = _nodes.length;
		}
		
		вставь(i, node);
	}
	
	проц добавь(Ткст текст)
	{
		return добавь(new TreeNode(текст));
	}
	
	проц добавь(Объект val)
	{
		return добавь(new TreeNode(дайТкстОбъекта(val))); // ?
	}
	
	
	проц добавьДиапазон(Объект[] range)
	{
		foreach(Объект o; range)
		{
			добавь(o);
		}
	}
	
	проц добавьДиапазон(TreeNode[] range)
	{
		foreach(TreeNode node; range)
		{
			добавь(node);
		}
	}
	
	проц добавьДиапазон(Ткст[] range)
	{
		foreach(Ткст s; range)
		{
			добавь(s);
		}
	}
	
	
	// Like сотри but doesn't bother removing stuff from the lists.
	// Used when а родитель is being removed and the отпрыски only
	// need to be сброс.
	private проц _reset()
	{
		foreach(TreeNode node; _nodes)
		{
			node._reset();
		}
	}
	
	
	// Clear node уки when the TreeView окно is destroyed so
	// that it can be reconstructed.
	private проц _resetHandles()
	{
		foreach(TreeNode node; _nodes)
		{
			node.tchildren._resetHandles();
			node.hnode = пусто;
		}
	}
	
	
	private:
	
	TreeView tview; // пусто if not assigned to а TreeView yet.
	TreeNode tparent; // пусто if root. The родитель of -_nodes-.
	TreeNode[] _nodes;
	
	
	проц verifyNoParent(TreeNode node)
	{
		if(node.tparent)
			throw new ВизИскл("TreeNode already belongs to а TreeView");
	}
	
	
	package this(TreeView treeView, TreeNode parentNode)
	{
		tview = treeView;
		tparent = parentNode;
	}
	
	
	package final проц setTreeView(TreeView treeView)
	{
		tview = treeView;
		foreach(TreeNode node; _nodes)
		{
			node.tchildren.setTreeView(treeView);
		}
	}
	
	
	package final бул создан() // getter
	{
		return tview && tview.создан();
	}
	
	
	package проц populateInsertChildNode(inout Сообщение m, inout TV_ITEMA dest, TreeNode node)
	{
		with(dest)
		{
			mask = /+ TVIF_CHILDREN | +/ TVIF_PARAM | TVIF_TEXT;
			version(VIZ_NO_IMAGELIST)
			{
			}
			else
			{
				mask |= TVIF_IMAGE | TVIF_SELECTEDIMAGE;
				iImage = node._imgidx;
				if(tview._selimgidx < 0)
					iSelectedImage = node._imgidx;
				else
					iSelectedImage = tview._selimgidx;
			}
			/+ cChildren = I_CHILDRENCALLBACK; +/
			парам2 = cast(LPARAM)cast(проц*)node;
			/+
			pszText = вТкст0(node.текст);
			//cchTextMax = node.текст.length; // ?
			+/
			if(viz.x.utf.использоватьЮникод)
			{
				pszText = cast(typeof(pszText))viz.x.utf.вЮни0(node.текст);
				m.уок = tview.указатель;
				m.сооб = TVM_INSERTITEMW;
			}
			else
			{
				pszText = cast(typeof(pszText))viz.x.utf.небезопАнзи0(node.текст);
				m.уок = tview.указатель;
				m.сооб = TVM_INSERTITEMA;
			}
		}
	}
	
	
	проц doNodes()
	in
	{
		assert(создан);
	}
	body
	{
		TV_INSERTSTRUCTA tis;
		Сообщение m;
		
		tis.hInsertAfter = TVI_LAST;
		
		m.уок = tview.указатель;
		m.парам1 = 0;
		
		foreach(TreeNode node; _nodes)
		{
			assert(!node.указатель);
			
			tis.hParent = tparent ? tparent.указатель : TVI_ROOT;
			populateInsertChildNode(m, tis.item, node);
			
			m.парам2 = cast(LPARAM)&tis;
			tview.предшОкПроц(m);
			assert(m.результат);
			node.hnode = cast(HTREEITEM)m.результат;
			
			node.tchildren.doNodes();
		}
	}
	
	
	проц _added(т_мера idx, TreeNode val)
	{
		verifyNoParent(val);
		
		val.tparent = tparent;
		val.tview = tview;
		val.tchildren.setTreeView(tview);
		
		if(создан)
		{
			TV_INSERTSTRUCTA tis;
			
			if(idx <= 0)
			{
				tis.hInsertAfter = TVI_FIRST;
			}
			else if(idx >= cast(цел)_nodes.length)
			{
				tis.hInsertAfter = TVI_LAST;
			}
			else
			{
				tis.hInsertAfter = _nodes[idx - 1].указатель;
			}
			
			tis.hParent = tparent ? tparent.указатель : TVI_ROOT;
			assert(tis.hInsertAfter);
			
			Сообщение m;
			m.парам1 = 0;
			
			populateInsertChildNode(m, tis.item, val);
			
			m.парам2 = cast(LPARAM)&tis;
			tview.предшОкПроц(m);
			assert(m.результат);
			val.hnode = cast(HTREEITEM)m.результат;
			
			val.tchildren.doNodes();
			
			if(tparent)
				tview.инвалидируй(tparent.границы);
		}
	}
	
	
	проц _removing(т_мера idx, TreeNode val)
	{
		if(т_мера.max == idx) // Clearing все...
		{
			TreeNode[] nodes = _nodes;
			_nodes = _nodes[0 .. 0]; // Not nice to viz.collections, but ОК.
			if(создан)
			{
				Сообщение m;
				m.уок = tview.указатель;
				m.сооб = TVM_DELETEITEM;
				m.парам1 = 0;
				if(tparent)
				{
					foreach(TreeNode node; nodes)
					{
						assert(node.указатель !is пусто);
						m.парам2 = cast(LPARAM)node.указатель;
						tview.предшОкПроц(m);
						
						node._reset();
					}
				}
				else
				{
					m.парам2 = TVI_ROOT;
					tview.предшОкПроц(m);
					foreach(TreeNode node; nodes)
					{
						node._reset();
					}
				}
			}
		}
		else
		{
		}
	}
	
	
	проц _removed(т_мера idx, TreeNode val)
	{
		if(т_мера.max == idx) // Clear все.
		{
		}
		else
		{
			if(создан)
			{
				assert(val.hnode);
				Сообщение m;
				m = Сообщение(tview.указатель, TVM_DELETEITEM, 0, cast(LPARAM)val.hnode);
				tview.предшОкПроц(m);
			}
			
			// Clear отпрыски.
			val._reset();
		}
	}
	
	
	public:
	
	mixin ListWrapArray!(TreeNode, _nodes,
		_blankListCallback!(TreeNode), _added,
		_removing, _removed,
		да, /+да+/ нет, нет) _wraparray;
}


class TreeView: СуперКлассУпрЭлта // docmain
{
	this()
	{
		_initTreeview();
		
		окСтиль |= WS_TABSTOP | TVS_HASBUTTONS | TVS_LINESATROOT | TVS_HASLINES;
		окДопСтиль |= WS_EX_CLIENTEDGE;
		ктрлСтиль |= ПСтилиУпрЭлта.ВЫДЕЛЕНИЕ;
		окСтильКласса = стильКлассаТривью;
		
		tchildren = new TreeNodeCollection(this, пусто);
	}
	
	
	/+
	~this()
	{
		/+
		if(tchildren)
			tchildren._dtorReset();
		+/
	}
	+/
	
	
	static Цвет дефЦветФона() // getter
	{
		return СистемныеЦвета.окно;
	}
	
	
	override Цвет цветФона() // getter
	{
		if(Цвет.пуст == цвфона)
			return дефЦветФона;
		return цвфона;
	}
	
	
	override проц цветФона(Цвет с) // setter
	{
		super.цветФона = с;
		
		if(создан)
		{
			// For some reason the лево edge isn't showing the new цвет.
			// This causes the entire упрэлт to be redrawn with the new цвет.
			// Sets the same шрифт.
			prevwproc(WM_SETFONT, this.шрифт ? cast(WPARAM)this.шрифт.указатель : 0, MAKELPARAM(TRUE, 0));
		}
	}
	
	
	static Цвет дефЦветПП() //getter
	{
		return СистемныеЦвета.текстОкна;
	}
	
	
	override Цвет цветПП() // getter
	{
		if(Цвет.пуст == цвпп)
			return дефЦветПП;
		return цвпп;
	}
	
	alias УпрЭлт.цветПП цветПП; // Overload.
	
	
	final проц стильКромки(ПСтильКромки bs) // setter
	{
		switch(bs)
		{
			case ПСтильКромки.ФИКС_3М:
				_style(_style() & ~WS_BORDER);
				_exStyle(_exStyle() | WS_EX_CLIENTEDGE);
				break;
				
			case ПСтильКромки.ФИКС_ЕДИН:
				_exStyle(_exStyle() & ~WS_EX_CLIENTEDGE);
				_style(_style() | WS_BORDER);
				break;
				
			case ПСтильКромки.НЕУК:
				_style(_style() & ~WS_BORDER);
				_exStyle(_exStyle() & ~WS_EX_CLIENTEDGE);
				break;
		}
		
		if(создан)
		{
			перерисуйПолностью();
		}
	}
	
	
	final ПСтильКромки стильКромки() // getter
	{
		if(_exStyle() & WS_EX_CLIENTEDGE)
			return ПСтильКромки.ФИКС_3М;
		else if(_style() & WS_BORDER)
			return ПСтильКромки.ФИКС_ЕДИН;
		return ПСтильКромки.НЕУК;
	}
	
	
	/+
		final проц checkBoxes(бул подтвержд) // setter
	{
		if(подтвержд)
			_style(_style() | TVS_CHECKBOXES);
		else
			_style(_style() & ~TVS_CHECKBOXES);
		
		_crecreate();
	}
	
	
	final бул checkBoxes() // getter
	{
		return (_style() & TVS_CHECKBOXES) != 0;
	}
	+/
	
	
		final проц fullRowSelect(бул подтвержд) // setter
	{
		if(подтвержд)
			_style(_style() | TVS_FULLROWSELECT);
		else
			_style(_style() & ~TVS_FULLROWSELECT);
		
		_crecreate(); // ?
	}
	
	
	final бул fullRowSelect() // getter
	{
		return (_style() & TVS_FULLROWSELECT) != 0;
	}
	
	
		final проц скройВыделение(бул подтвержд) // setter
	{
		if(подтвержд)
			_style(_style() & ~TVS_SHOWSELALWAYS);
		else
			_style(_style() | TVS_SHOWSELALWAYS);
	}
	
	
	final бул скройВыделение() // getter
	{
		return (_style() & TVS_SHOWSELALWAYS) == 0;
	}
	
	
	deprecated alias hoverSelection hotTracking;
	
		final проц hoverSelection(бул подтвержд) // setter
	{
		if(подтвержд)
			_style(_style() | TVS_TRACKSELECT);
		else
			_style(_style() & ~TVS_TRACKSELECT);
	}
	
	
	final бул hoverSelection() // getter
	{
		return (_style() & TVS_TRACKSELECT) != 0;
	}
	
	
		final проц indent(цел newIndent) // setter
	{
		if(newIndent < 0)
			newIndent = 0;
		else if(newIndent > 32_000)
			newIndent = 32_000;
		
		ind = newIndent;
		
		if(создан)
			SendMessageA(уок, TVM_SETINDENT, ind, 0);
	}
	
	
	final цел indent() // getter
	{
		if(создан)
			ind = cast(цел)SendMessageA(уок, TVM_GETINDENT, 0, 0);
		return ind;
	}
	
	
		final проц высотаПункта(цел h) // setter
	{
		if(h < 0)
			h = 0;
		
		iheight = h;
		
		if(создан)
			SendMessageA(уок, TVM_SETITEMHEIGHT, iheight, 0);
	}
	
	
	final цел высотаПункта() // getter
	{
		if(создан)
			iheight = cast(цел)SendMessageA(уок, TVM_GETITEMHEIGHT, 0, 0);
		return iheight;
	}
	
	
		final проц labelEdit(бул подтвержд) // setter
	{
		if(подтвержд)
			_style(_style() | TVS_EDITLABELS);
		else
			_style(_style() & ~TVS_EDITLABELS);
	}
	
	
	final бул labelEdit() // getter
	{
		return (_style() & TVS_EDITLABELS) != 0;
	}
	
	
		final TreeNodeCollection nodes() // getter
	{
		return tchildren;
	}
	
	
		final проц pathSeparator(дим sep) // setter
	{
		pathsep = sep;
	}
	
	
	final дим pathSeparator() // getter
	{
		return pathsep;
	}
	
	
		final проц scrollable(бул подтвержд) // setter
	{
		if(подтвержд)
			_style(_style() & ~TVS_NOSCROLL);
		else
			_style(_style() | TVS_NOSCROLL);
		
		if(создан)
			перерисуйПолностью();
	}
	
	
	final бул scrollable() // getter
	{
		return (_style & TVS_NOSCROLL) == 0;
	}
	
	
		final проц selectedNode(TreeNode node) // setter
	{
		if(создан)
		{
			if(node)
			{
				SendMessageA(уок, TVM_SELECTITEM, TVGN_CARET, cast(LPARAM)node.указатель);
			}
			else
			{
				// Should the selection be cleared if -node- is пусто?
				//SendMessageA(уок, TVM_SELECTITEM, TVGN_CARET, cast(LPARAM)пусто);
			}
		}
	}
	
	
	final TreeNode selectedNode() // getter
	{
		if(создан)
		{
			HTREEITEM hnode;
			hnode = cast(HTREEITEM)SendMessageA(уок, TVM_GETNEXTITEM, TVGN_CARET, cast(LPARAM)пусто);
			if(hnode)
				return treeNodeFromHandle(hnode);
		}
		return пусто;
	}
	
	
		final проц showLines(бул подтвержд) // setter
	{
		if(подтвержд)
			_style(_style() | TVS_HASLINES);
		else
			_style(_style() & ~TVS_HASLINES);
		
		_crecreate(); // ?
	}
	
	
	final бул showLines() // getter
	{
		return (_style() & TVS_HASLINES) != 0;
	}
	
	
		final проц showPlusMinus(бул подтвержд) // setter
	{
		if(подтвержд)
			_style(_style() | TVS_HASBUTTONS);
		else
			_style(_style() & ~TVS_HASBUTTONS);
		
		_crecreate(); // ?
	}
	
	
	final бул showPlusMinus() // getter
	{
		return (_style() & TVS_HASBUTTONS) != 0;
	}
	
	
		// -showPlusMinus- should be нет.
	final проц singleExpand(бул подтвержд) // setter
	{
		if(подтвержд)
			_style(_style() | TVS_SINGLEEXPAND);
		else
			_style(_style() & ~TVS_SINGLEEXPAND);
		
		_crecreate(); // ?
	}
	
	
	final бул singleExpand() // getter
	{
		return (_style & TVS_SINGLEEXPAND) != 0;
	}
	
	
		final проц showRootLines(бул подтвержд) // setter
	{
		if(подтвержд)
			_style(_style() | TVS_LINESATROOT);
		else
			_style(_style() & ~TVS_LINESATROOT);
		
		_crecreate(); // ?
	}
	
	
	final бул showRootLines() // getter
	{
		return (_style() & TVS_LINESATROOT) != 0;
	}
	
	
		final проц сортированный(бул подтвержд) // setter
	{
		_sort = подтвержд;
	}
	
	
	final бул сортированный() // getter
	{
		return _sort;
	}
	
	
		// First виден node, based on the scrolled положение.
	final TreeNode topNode() // getter
	{
		if(создан)
		{
			HTREEITEM hnode;
			hnode = cast(HTREEITEM)SendMessageA(уок, TVM_GETNEXTITEM,
				TVGN_FIRSTVISIBLE, cast(LPARAM)пусто);
			if(hnode)
				return treeNodeFromHandle(hnode);
		}
		return пусто;
	}
	
	
		// Number of виден nodes, including partially виден.
	final цел visibleCount() // getter
	{
		if(!создан)
			return 0;
		return cast(цел)SendMessageA(уок, TVM_GETVISIBLECOUNT, 0, 0);
	}
	
	
		final проц начниОбновление()
	{
		SendMessageA(указатель, WM_SETREDRAW, нет, 0);
	}
	
	
	final проц завершиОбновление()
	{
		SendMessageA(указатель, WM_SETREDRAW, да, 0);
		инвалидируй(да); // покажи updates.
	}
	
	
		final проц collapseAll()
	{
		if(создан)
		{
			проц collapsing(TreeNodeCollection tchildren)
			{
				foreach(TreeNode node; tchildren._nodes)
				{
					SendMessageA(уок, TVM_EXPAND, TVE_COLLAPSE, cast(LPARAM)node.hnode);
					collapsing(node.tchildren);
				}
			}
			
			
			collapsing(tchildren);
		}
	}
	
	
		final проц expandAll()
	{
		if(создан)
		{
			проц expanding(TreeNodeCollection tchildren)
			{
				foreach(TreeNode node; tchildren._nodes)
				{
					SendMessageA(уок, TVM_EXPAND, TVE_EXPAND, cast(LPARAM)node.hnode);
					expanding(node.tchildren);
				}
			}
			
			
			expanding(tchildren);
		}
	}
	
	
		final TreeNode getNodeAt(цел ш, цел в)
	{
		if(создан)
		{
			TVHITTESTINFO thi;
			HTREEITEM hti;
			thi.тчк.ш = ш;
			thi.тчк.в = в;
			hti = cast(HTREEITEM)SendMessageA(уок, TVM_HITTEST, 0, cast(LPARAM)&thi);
			if(hti)
			{
				TreeNode результат;
				результат = treeNodeFromHandle(hti);
				if(результат)
				{
					assert(результат.tview is this);
					return результат;
				}
			}
		}
		return пусто;
	}
	
	
	final TreeNode getNodeAt(Точка тчк)
	{
		return getNodeAt(тчк.ш, тчк.в);
	}
	
	
	/+
		// TODO: finish.
	final цел getNodeCount(бул includeSubNodes)
	{
		цел результат;
		результат = tchildren.length();
		
		if(includeSubNodes)
		{
			// ...
		}
		
		return результат;
	}
	+/
	
	
	version(VIZ_NO_IMAGELIST)
	{
	}
	else
	{
				final проц imageList(ImageList imglist) // setter
		{
			if(созданУказатель_ли)
			{
				prevwproc(TVM_SETIMAGELIST, TVSIL_NORMAL,
					cast(LPARAM)(imglist ? imglist.указатель : cast(HIMAGELIST)пусто));
			}
			
			_imglist = imglist;
		}
		
		
		final ImageList imageList() // getter
		{
			return _imglist;
		}
		
		
		/+
				// Default рисунок индекс (if -1 use this).
		final проц imageIndex(цел индекс)
		{
			_defimgidx = индекс;
		}
		
		
		final цел imageIndex() // getter
		{
			return _defimgidx;
		}
		+/
		
		
				final проц selectedImageIndex(цел индекс)
		{
			//assert(индекс >= 0);
			assert(индекс >= -1);
			_selimgidx = индекс;
			
			if(созданУказатель_ли)
			{
				TreeNode curnode = selectedNode;
				_crecreate();
				if(curnode)
					curnode.ensureVisible();
			}
		}
		
		
		final цел selectedImageIndex() // getter
		{
			return _selimgidx;
		}
	}
	
	
	protected override Размер дефРазм() // getter
	{
		return Размер(120, 100);
	}
	
	
	/+
	override проц создайУказатель()
	{
		if(созданУказатель_ли)
			return;
		
		создайУказательНаКласс(TREEVIEW_CLASSNAME);
		
		поСозданиюУказателя(АргиСоб.пуст);
	}
	+/
	
	
	protected override проц создайПараметры(inout ПарамыСозд cp)
	{
		super.создайПараметры(cp);
		
		cp.имяКласса = TREEVIEW_CLASSNAME;
	}
	
	
	protected override проц поСозданиюУказателя(АргиСоб ea)
	{
		super.поСозданиюУказателя(ea);
		
		prevwproc(CCM_SETVERSION, 5, 0); // Fixes шрифт размер issue.
		
		prevwproc(TVM_SETINDENT, ind, 0);
		
		prevwproc(TVM_SETITEMHEIGHT, iheight, 0);
		
		version(VIZ_NO_IMAGELIST)
		{
		}
		else
		{
			if(_imglist)
				prevwproc(TVM_SETIMAGELIST, TVSIL_NORMAL, cast(LPARAM)_imglist.указатель);
		}
		
		tchildren.doNodes();
	}
	
	
	protected override проц поУдалениюУказателя(АргиСоб ea)
	{
		tchildren._resetHandles();
		
		super.поУдалениюУказателя(ea);
	}
	
	
	protected override проц окПроц(inout Сообщение m)
	{
		// TODO: support these messages.
		switch(m.сооб)
		{
			case TVM_INSERTITEMA:
			case TVM_INSERTITEMW:
				m.результат = cast(LRESULT)пусто;
				return;
			
			case TVM_SETITEMA:
			case TVM_SETITEMW:
				m.результат = cast(LRESULT)-1;
				return;
			
			case TVM_DELETEITEM:
				m.результат = FALSE;
				return;
			
			case TVM_SETIMAGELIST:
				m.результат = cast(LRESULT)пусто;
				return;
			
			default: ;
		}
		
		super.окПроц(m);
	}
	
	
	protected override проц предшОкПроц(inout Сообщение сооб)
	{
		//сооб.результат = CallWindowProcA(первОкПроцТривью, сооб.уок, сооб.сооб, сооб.парам1, сооб.парам2);
		сооб.результат = viz.x.utf.вызовиОкПроц(первОкПроцТривью, сооб.уок, сооб.сооб, сооб.парам1, сооб.парам2);
	}
	
	
	//TreeViewEventHandler afterCollapse;
	Событие!(TreeView, TreeViewEventArgs) afterCollapse; 	//TreeViewEventHandler afterExpand;
	Событие!(TreeView, TreeViewEventArgs) afterExpand; 	//TreeViewEventHandler afterSelect;
	Событие!(TreeView, TreeViewEventArgs) afterSelect; 	//NodeLabelEditEventHandler afterLabelEdit;
	Событие!(TreeView, NodeLabelEditEventArgs) afterLabelEdit; 	//TreeViewCancelEventHandler beforeCollapse;
	Событие!(TreeView, TreeViewCancelEventArgs) beforeCollapse; 	//TreeViewCancelEventHandler beforeExpand;
	Событие!(TreeView, TreeViewCancelEventArgs) beforeExpand; 	//TreeViewCancelEventHandler beforeSelect;
	Событие!(TreeView, TreeViewCancelEventArgs) beforeSelect; 	//NodeLabelEditEventHandler beforeLabelEdit;
	Событие!(TreeView, NodeLabelEditEventArgs) beforeLabelEdit; 	
	
		protected проц onAfterCollapse(TreeViewEventArgs ea)
	{
		afterCollapse(this, ea);
	}
	
	
		protected проц onAfterExpand(TreeViewEventArgs ea)
	{
		afterExpand(this, ea);
	}
	
	
		protected проц onAfterSelect(TreeViewEventArgs ea)
	{
		afterSelect(this, ea);
	}
	
	
		protected проц onAfterLabelEdit(NodeLabelEditEventArgs ea)
	{
		afterLabelEdit(this, ea);
	}
	
	
		protected проц onBeforeCollapse(TreeViewCancelEventArgs ea)
	{
		beforeCollapse(this, ea);
	}
	
	
		protected проц onBeforeExpand(TreeViewCancelEventArgs ea)
	{
		beforeExpand(this, ea);
	}
	
	
		protected проц onBeforeSelect(TreeViewCancelEventArgs ea)
	{
		beforeSelect(this, ea);
	}
	
	
		protected проц onBeforeLabelEdit(NodeLabelEditEventArgs ea)
	{
		beforeLabelEdit(this, ea);
	}
	
	
	protected override проц поОбратномуСообщению(inout Сообщение m) // package
	{
		super.поОбратномуСообщению(m);
		
		switch(m.сооб)
		{
			case WM_NOTIFY:
				{
					NMHDR* nmh;
					NM_TREEVIEW* nmtv;
					TreeViewCancelEventArgs cea;
					
					nmh = cast(NMHDR*)m.парам2;
					assert(nmh.hwndFrom == уок);
					
					switch(nmh.code)
					{
						case NM_CUSTOMDRAW:
							{
								NMTVCUSTOMDRAW* tvcd;
								tvcd = cast(NMTVCUSTOMDRAW*)nmh;
								//if(tvcd.nmcd.dwDrawStage & CDDS_ITEM)
								{
									//if(tvcd.nmcd.uItemState & CDIS_SELECTED)
									if((tvcd.nmcd.dwDrawStage & CDDS_ITEM)
										&& (tvcd.nmcd.uItemState & CDIS_SELECTED))
									{
										// Note: might not look good with custom colors.
										tvcd.clrText = СистемныеЦвета.подсветкаТекста.вКзс();
										tvcd.clrTextBk = СистемныеЦвета.подсветка.вКзс();
									}
									else
									{
										//tvcd.clrText = цветПП.вКзс();
										tvcd.clrText = цветПП.плотныйЦвет(цветФона).вКзс();
										tvcd.clrTextBk = цветФона.вКзс();
									}
								}
								m.результат |= CDRF_NOTIFYITEMDRAW; // | CDRF_NOTIFYITEMERASE;
								
								// This doesn't seem to be doing anything.
								Шрифт fon;
								fon = this.шрифт;
								if(fon)
								{
									SelectObject(tvcd.nmcd.hdc, fon.указатель);
									m.результат |= CDRF_NEWFONT;
								}
							}
							break;
						
						/+
						case TVN_GETDISPINFOA:
							
							break;
						+/
						
						case TVN_SELCHANGINGW:
							goto sel_changing;
						
						case TVN_SELCHANGINGA:
							if(viz.x.utf.использоватьЮникод)
								break;
							sel_changing:
							
							nmtv = cast(NM_TREEVIEW*)nmh;
							switch(nmtv.действие)
							{
								case TVC_BYMOUSE:
									cea = new TreeViewCancelEventArgs(cast(TreeNode)cast(проц*)nmtv.itemNew.парам2,
										нет, TreeViewAction.BY_MOUSE);
									onBeforeSelect(cea);
									m.результат = cea.отмена;
									break;
								
								case TVC_BYKEYBOARD:
									cea = new TreeViewCancelEventArgs(cast(TreeNode)cast(проц*)nmtv.itemNew.парам2,
										нет, TreeViewAction.BY_KEYBOARD);
									onBeforeSelect(cea);
									m.результат = cea.отмена;
									break;
								
								//case TVC_UNKNOWN:
								default:
									cea = new TreeViewCancelEventArgs(cast(TreeNode)cast(проц*)nmtv.itemNew.парам2,
										нет, TreeViewAction.UNKNOWN);
									onBeforeSelect(cea);
									m.результат = cea.отмена;
							}
							break;
						
						case TVN_SELCHANGEDW:
							goto sel_changed;
						
						case TVN_SELCHANGEDA:
							if(viz.x.utf.использоватьЮникод)
								break;
							sel_changed:
							
							nmtv = cast(NM_TREEVIEW*)nmh;
							switch(nmtv.действие)
							{
								case TVC_BYMOUSE:
									onAfterSelect(new TreeViewEventArgs(cast(TreeNode)cast(проц*)nmtv.itemNew.парам2,
										TreeViewAction.BY_MOUSE));
									break;
								
								case TVC_BYKEYBOARD:
									onAfterSelect(new TreeViewEventArgs(cast(TreeNode)cast(проц*)nmtv.itemNew.парам2,
										TreeViewAction.BY_KEYBOARD));
									break;
								
								//case TVC_UNKNOWN:
								default:
									onAfterSelect(new TreeViewEventArgs(cast(TreeNode)cast(проц*)nmtv.itemNew.парам2,
										TreeViewAction.UNKNOWN));
							}
							break;
						
						case TVN_ITEMEXPANDINGW:
							goto item_expanding;
						
						case TVN_ITEMEXPANDINGA:
							if(viz.x.utf.использоватьЮникод)
								break;
							item_expanding:
							
							nmtv = cast(NM_TREEVIEW*)nmh;
							switch(nmtv.действие)
							{
								case TVE_COLLAPSE:
									cea = new TreeViewCancelEventArgs(cast(TreeNode)cast(проц*)nmtv.itemNew.парам2,
										нет, TreeViewAction.COLLAPSE);
									onBeforeCollapse(cea);
									m.результат = cea.отмена;
									break;
								
								case TVE_EXPAND:
									cea = new TreeViewCancelEventArgs(cast(TreeNode)cast(проц*)nmtv.itemNew.парам2,
										нет, TreeViewAction.EXPAND);
									onBeforeExpand(cea);
									m.результат = cea.отмена;
									break;
								
								default: ;
							}
							break;
						
						case TVN_ITEMEXPANDEDW:
							goto item_expanded;
						
						case TVN_ITEMEXPANDEDA:
							if(viz.x.utf.использоватьЮникод)
								break;
							item_expanded:
							
							nmtv = cast(NM_TREEVIEW*)nmh;
							switch(nmtv.действие)
							{
								case TVE_COLLAPSE:
									{
										scope TreeViewEventArgs tvea = new TreeViewEventArgs(
											cast(TreeNode)cast(проц*)nmtv.itemNew.парам2,
											TreeViewAction.COLLAPSE);
										onAfterCollapse(tvea);
									}
									break;
								
								case TVE_EXPAND:
									{
										scope TreeViewEventArgs tvea = new TreeViewEventArgs(
											cast(TreeNode)cast(проц*)nmtv.itemNew.парам2,
											TreeViewAction.EXPAND);
										onAfterExpand(tvea);
									}
									break;
								
								default: ;
							}
							break;
						
						case TVN_BEGINLABELEDITW:
							goto begin_label_edit;
						
						case TVN_BEGINLABELEDITA:
							if(viz.x.utf.использоватьЮникод)
								break;
							begin_label_edit:
							
							{
								TV_DISPINFOA* nmdi;
								nmdi = cast(TV_DISPINFOA*)nmh;
								TreeNode node;
								node = cast(TreeNode)cast(проц*)nmdi.item.парам2;
								scope NodeLabelEditEventArgs nleea = new NodeLabelEditEventArgs(node);
								onBeforeLabelEdit(nleea);
								m.результат = nleea.cancelEdit;
							}
							break;
						
						case TVN_ENDLABELEDITW:
							{
								Ткст надпись;
								TV_DISPINFOW* nmdi;
								nmdi = cast(TV_DISPINFOW*)nmh;
								if(nmdi.item.pszText)
								{
									TreeNode node;
									node = cast(TreeNode)cast(проц*)nmdi.item.парам2;
									надпись = изЮникода0(nmdi.item.pszText);
									scope NodeLabelEditEventArgs nleea = new NodeLabelEditEventArgs(node, надпись);
									onAfterLabelEdit(nleea);
									if(nleea.cancelEdit)
									{
										m.результат = FALSE;
									}
									else
									{
										// TODO: check if correct implementation.
										// Update the node's cached текст..
										node.tтекст = надпись;
										
										m.результат = TRUE;
									}
								}
							}
							break;
						
						case TVN_ENDLABELEDITA:
							if(viz.x.utf.использоватьЮникод)
								break;
							{
								Ткст надпись;
								TV_DISPINFOA* nmdi;
								nmdi = cast(TV_DISPINFOA*)nmh;
								if(nmdi.item.pszText)
								{
									TreeNode node;
									node = cast(TreeNode)cast(проц*)nmdi.item.парам2;
									надпись = изАнзи0(nmdi.item.pszText);
									scope NodeLabelEditEventArgs nleea = new NodeLabelEditEventArgs(node, надпись);
									onAfterLabelEdit(nleea);
									if(nleea.cancelEdit)
									{
										m.результат = FALSE;
									}
									else
									{
										// TODO: check if correct implementation.
										// Update the node's cached текст..
										node.tтекст = надпись;
										
										m.результат = TRUE;
									}
								}
							}
							break;
						
						default: ;
					}
				}
				break;
			
			default: ;
		}
	}
	
	
	private:
	TreeNodeCollection tchildren;
	цел ind = 19; // Indent.
	дим pathsep = '\\';
	бул _sort = нет;
	цел iheight = 16;
	version(VIZ_NO_IMAGELIST)
	{
	}
	else
	{
		ImageList _imglist;
		цел _selimgidx = -1; //0;
	}
	
	
	TreeNode treeNodeFromHandle(HTREEITEM hnode)
	{
		TV_ITEMA ti;
		ti.mask = TVIF_HANDLE | TVIF_PARAM;
		ti.hItem = hnode;
		if(SendMessageA(уок, TVM_GETITEMA, 0, cast(LPARAM)&ti))
		{
			return cast(TreeNode)cast(проц*)ti.парам2;
		}
		return пусто;
	}
	
	package:
	final:
	LRESULT prevwproc(UINT сооб, WPARAM wparam, LPARAM lparam)
	{
		//return CallWindowProcA(первОкПроцТривью, уок, сооб, wparam, lparam);
		return viz.x.utf.вызовиОкПроц(первОкПроцТривью, уок, сооб, wparam, lparam);
	}
}

