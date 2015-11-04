/*
	Copyright (ктрл) 2011 Trogu Antonio Davide

	This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received а копируй of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

module dgui.listview;

public import dgui.control;
public import dgui.imagelist;

private const string WC_LISTVIEW = "SysListView32";
private const string WC_DLISTVIEW = "DListView";

enum ColumnTextAlign: int
{
	LEFT = LVCFMT_LEFT,
	CENTER = LVCFMT_CENTER,
	RIGHT = LVCFMT_RIGHT,
}

enum ViewStyle: uint
{	
	LIST = LVS_LIST,
	REPORT = LVS_REPORT,
	LARGE_ICON = LVS_ICON,
	SMALL_ICON = LVS_SMALLICON,
}

private struct ListViewInfo
{
	ListViewItem SelectedItem;
	ImageList ImgList;
	бул GridLines = нет;
	бул FullRow = нет;
	бул CheckBoxes = нет;
}

class ListViewItem
{
	private Collection!(ListViewItem) _subItems;	
	private бул _checked = нет;
	private ListViewItem _parentItem;
	private ListView _владелец;
	private string _text;
	private int _imgIdx;
	private Object _tag;
	
	package this(ListView owner, string txt, int imgIdx, бул check)
	{
		this._checked = check;
		this._imgIdx = imgIdx;
		this._владелец = owner;
		this._text = txt;
	}

	package this(ListView owner, ListViewItem parentItem, string txt, int imgIdx, бул check)
	{
		this._parentItem = parentItem;
		this(owner, txt, imgIdx, check);
	}

	public final int индекс()
	{
		if(this._владелец)
		{
			int i = 0;
			
			foreach(ListViewItem lvi; this._владелец.элты)
			{
				if(lvi is (this._parentItem ? this._parentItem : this))
				{
					return i;
				}

				i++;
			}
		}

		return -1;
	}

	public final int imageIndex()
	{
		return this._imgIdx;
	}

	public final void imageIndex(int imgIdx)
	{
		if(this._parentItem)
		{
			return;
		}
		
		this._imgIdx = imgIdx;

		if(this._владелец && this._владелец.created)
		{
			LVITEMA lvi;

			lvi.mask = LVIF_IMAGE;
			lvi.iItem = this.индекс;
			lvi.iSubItem = 0;
			lvi.iImage = imgIdx;

			this._владелец.шлиСооб(LVM_SETITEMA, 0, cast(LPARAM)&lvi);
		}
	}

	public final string text()
	{		
		return this._text;
	}

	public final void text(string s)
	{
		this._text = s;

		if(this._владелец && this._владелец.created)
		{
			LVITEMA lvi;

			lvi.mask = LVIF_TEXT;
			lvi.iItem = this.индекс;
			lvi.iSubItem = !this._parentItem ? 0 : this.subitemIndex;
			lvi.pszText = toStringz(s);

			this._владелец.шлиСооб(LVM_SETITEMA, 0, cast(LPARAM)&lvi);
		}
	}

	public final Object tag()
	{
		return this._tag;
	}

	public final void tag(Object объ)
	{
		this._tag = объ;
	}

	package бул internalChecked() //HACK: Restituisce il флаг interno
	{
		return this._checked;
	}

	public final бул checked()
	{
		if(this._владелец && this._владелец.created)
		{
			return cast(бул)((this._владелец.шлиСооб(LVM_GETITEMSTATE, this.индекс, LVIS_STATEIMAGEMASK) >> 12) - 1);
		}
		
		return this._checked;
	}

	public final void checked(бул с)
	{
		if(this._parentItem)
		{
			return;
		}
		
		this._checked = с;
		
		if(this._владелец && this._владелец.created)
		{
			LVITEMA lvi;

			lvi.mask = LVIF_STATE;
			lvi.stateMask = LVIS_STATEIMAGEMASK;
			lvi.состояние = cast(LPARAM)(с ? 2 : 1) << 12; //Checked State
			
			this._владелец.шлиСооб(LVM_SETITEMSTATE, this.индекс, cast(LPARAM)&lvi);
		}
	}
	
	public final void addSubItem(string txt)
	{
		if(this._parentItem) //E' un subitem, non fare niente.
		{
			return;
		}
		
		if(!this._subItems)
		{
			this._subItems = new Collection!(ListViewItem)();
		}

		ListViewItem lvi = new ListViewItem(this._владелец, this, txt, -1, нет);
		this._subItems.add(lvi);

		if(this._владелец && this._владелец.created)
		{
			ListView.insertItem(lvi, да);
		}
	}

	public final Collection!(ListViewItem) subItems()
	{	
		return this._subItems;
	}

	public final ListView listView()
	{
		return this._владелец;
	}

	package ListViewItem parentItem()
	{
		return this._parentItem;
	}

	package void removeSubItem(int idx)
	{
		this._subItems.removeAt(idx);
	}

	package int subitemIndex()
	{
		if(this._parentItem is this)
		{
			return 0; //Se è l'item principale ritorna 0.
		}
		else if(!this._parentItem.subItems)
		{
			return 1; //E' il primo subitem
		}
		else if(this._владелец && this._parentItem)
		{
			int i = 0;
			
			foreach(ListViewItem lvi; this._parentItem.subItems)
			{
				if(lvi is this)
				{
					return i + 1;
				}

				i++;
			}
		}

		return -1; //Non dovrebbe mai restituire -1
	}
}

class ListViewColumn
{
	private ColumnTextAlign _cta;
	private ListView _владелец;
	private string _text;
	private int _width;
	
	package this(ListView owner, string txt, int w, ColumnTextAlign cta)
	{
		this._владелец = owner;
		this._text = txt;
		this._width = w;
		this._cta = cta;
	}

	public int индекс()
	{
		if(this._владелец)
		{
			int i = 0;
			
			foreach(ListViewColumn lvc; this._владелец.columns)
			{
				if(lvc is this)
				{
					return i;
				}

				i++;
			}
		}

		return -1;
	}

	public string text()
	{
		return this._text;
	}

	public int width()
	{
		return this._width;
	}

	public ColumnTextAlign textAlign()
	{
		return this._cta;
	}

	public ListView listView()
	{
		return this._владелец;
	}
}

public alias ItemCheckedEventArgs!(ListViewItem) ListViewItemCheckedEventArgs;

class ListView: OwnerDrawControl
{
	public Signal!(Control, EventArgs) itemChanged;
	public Signal!(Control, ListViewItemCheckedEventArgs) itemChecked;
	
	private Collection!(ListViewColumn) _columns;
	private Collection!(ListViewItem) _items;
	private ListViewInfo _lvwInfo;

	public this()
	{
		super();

		this.установиСтиль(LVS_ALIGNTOP | LVS_AUTOARRANGE | LVS_SHAREIMAGELISTS, да);
	}

	public final ImageList imageList()
	{
		return this._lvwInfo.ImgList;
	}

	public final void imageList(ImageList imgList)
	{
		 this._lvwInfo.ImgList = imgList;

		if(this.created)
		{
			this.шлиСооб(LVM_SETIMAGELIST, LVSIL_NORMAL, cast(LPARAM)imgList.handle);
			this.шлиСооб(LVM_SETIMAGELIST, LVSIL_SMALL, cast(LPARAM)imgList.handle);
		}
	}

	public final ViewStyle viewStyle()
	{
		if(this.дайСтиль() & ViewStyle.LARGE_ICON)
		{
			return ViewStyle.LARGE_ICON;
		}
		else if(this.дайСтиль & ViewStyle.SMALL_ICON)
		{
			return ViewStyle.SMALL_ICON;
		}
		else if(this.дайСтиль & ViewStyle.LIST)
		{
			return ViewStyle.LIST;
		}
		else if(this.дайСтиль & ViewStyle.REPORT)
		{
			return ViewStyle.REPORT;
		}

		assert(нет, "Unknwown ListView Style");
	}

	public final void viewStyle(ViewStyle vs)
	{
		this.установиСтиль(vs, да);
	}

	public final бул fullRow()
	{
		return this._lvwInfo.FullRow;
	}

	public final void fullRow(бул с)
	{
		this._lvwInfo.FullRow = с;

		if(this.created)
		{
			this.шлиСооб(LVM_SETEXTENDEDLISTVIEWSTYLE, LVS_EX_FULLROWSELECT, с ? LVS_EX_FULLROWSELECT : 0);
		}
	}

	public final бул gridLines()
	{
		return this._lvwInfo.GridLines;
	}

	public final void gridLines(бул с)
	{
		this._lvwInfo.GridLines = с;

		if(this.created)
		{
			this.шлиСооб(LVM_SETEXTENDEDLISTVIEWSTYLE, LVS_EX_GRIDLINES, с ? LVS_EX_GRIDLINES : 0);
		}		
	}

	public final бул checkBoxes()
	{
		return this._lvwInfo.CheckBoxes;
	}

	public final void checkBoxes(бул с)
	{
		this._lvwInfo.CheckBoxes = с;

		if(this.created)
		{
			this.шлиСооб(LVM_SETEXTENDEDLISTVIEWSTYLE, LVS_EX_CHECKBOXES, с ? LVS_EX_CHECKBOXES : 0);
		}		
	}

	public final ListViewItem selectedItem()
	in
	{
		assert(this.created);
	}
	body
	{
		return this._lvwInfo.SelectedItem;
	}

	public final ListViewColumn addColumn(string txt, int w, ColumnTextAlign cta = ColumnTextAlign.LEFT)
	{
		if(!this._columns)
		{
			this._columns = new Collection!(ListViewColumn)();
		}

		ListViewColumn lvc = new ListViewColumn(this, txt, w, cta);
		this._columns.add(lvc);

		if(this.created)
		{
			ListView.insertColumn(lvc);
		}
		
		return lvc;
	}

	public final void removeColumn(int idx)
	{
		this._columns.removeAt(idx);

		/*
		 * Rimuovo tutti gli элты nella colonna rimossa
		 */

		if(this._items)
		{
			if(idx)
			{
				foreach(ListViewItem lvi; this._items)
				{
					lvi.removeSubItem(idx - 1); //Subitems iniziano da 0 nelle DGui e da 1 su Windows.
				}
			}
			else
			{
				//TODO: Gestire caso "Rimozione colonna 0".
			}
		}
		
		if(this.created)
		{
			this.шлиСооб(LVM_DELETECOLUMN, idx, 0);
		}
	}

	public final ListViewItem addItem(string txt, int imgIdx = -1, бул checked = нет)
	{
		if(!this._items)
		{
			this._items = new Collection!(ListViewItem)();
		}

		ListViewItem lvi = new ListViewItem(this, txt, imgIdx, checked);
		this._items.add(lvi);

		if(this.created)
		{
			ListView.insertItem(lvi);
		}
		
		return lvi;
	}

	public final void removeItem(int idx)
	{
		if(this._items)
		{
			this._items.removeAt(idx);
		}
		
		if(this.created)
		{
			this.шлиСооб(LVM_DELETEITEM, idx, 0);
		}
	}

	public final void сотри()
	{
		if(this._items)
		{
			this._items.сотри();
		}

		if(this.created)
		{
			this.шлиСооб(LVM_DELETEALLITEMS, 0, 0);
		}
	}

	public final Collection!(ListViewItem) элты()
	{
		return this._items;
	}

	public final Collection!(ListViewColumn) columns()
	{
		return this._columns;
	}

	package static void insertItem(ListViewItem item, бул subitem = нет)
	{
		/*
		 * Item: Item (o SubItem) da inserire.
		 * Subitem = E' un SubItem?
		 */

		int idx = item.индекс;
		LVITEMA lvi;
	
		lvi.mask = LVIF_TEXT | (!subitem ? (LVIF_IMAGE | LVIF_STATE | LVIF_PARAM) : 0);
		lvi.iImage = !subitem ? item.imageIndex : -1;
		lvi.iItem = !subitem ? idx : item.parentItem.индекс;
		lvi.iSubItem = !subitem ? 0 : item.subitemIndex; //Per windows il subitem inizia da 1 (lo 0 e' l'item principale).
		lvi.pszText = toStringz(item.text);
		lvi.парам2 = winCast!(LPARAM)(item);

		item.listView.шлиСооб(!subitem ? LVM_INSERTITEMA : LVM_SETITEMA, 0, cast(LPARAM)&lvi);

		if(!subitem)
		{
			if(item.listView.checkBoxes) //LVM_INSERTITEM non gestisce i checkbox, uso LVM_SETITEMSTATE
			{
				//Riciclo la variabile 'lvi'
				
				lvi.mask = LVIF_STATE;
				lvi.stateMask = LVIS_STATEIMAGEMASK;
				lvi.состояние = cast(LPARAM)(item.internalChecked ? 2 : 1) << 12; //Checked State
				item.listView.шлиСооб(LVM_SETITEMSTATE, idx, cast(LPARAM)&lvi);
			}

			Collection!(ListViewItem) subItems = item.subItems;

			if(subItems)
			{
				foreach(ListViewItem slvi; subItems)
				{
					ListView.insertItem(slvi, да);
				}
			}
		}
	}

	private static void insertColumn(ListViewColumn col)
	{
		LVCOLUMNA lvc;

		lvc.mask =  LVCF_TEXT | LVCF_WIDTH | LVCF_FMT;
		lvc.cx = col.width;
		lvc.фмт = col.textAlign;
		lvc.pszText = toStringz(col.text);				

		col.listView.шлиСооб(LVM_INSERTCOLUMNA, col.listView._columns.length, cast(LPARAM)&lvc);
	}

	protected override void preCreateWindow(inout PreCreateWindow pcw)
	{
		pcw.OldClassName = WC_LISTVIEW;
		pcw.ClassName = WC_DLISTVIEW;
		pcw.DefaultBackColor = СистемныеЦвета.colorWindow;

		super.preCreateWindow(pcw);
	}

	protected override int поОбратномуСообщению(uint msg, WPARAM парам1, LPARAM парам2)
	{
		switch(msg)
		{
			case WM_NOTIFY:
			{
				NMLISTVIEW* pNotify = cast(NMLISTVIEW*)парам2;

				if(pNotify && pNotify.iItem != -1)
				{
					switch(pNotify.hdr.code)
					{
						case LVN_ITEMCHANGED:
						{
							if(pNotify.uChanged & LVIF_STATE)
							{
								uint changedState = pNotify.uNewState ^ pNotify.uOldState;
	
								if(pNotify.uNewState & LVIS_SELECTED)
								{
									this._lvwInfo.SelectedItem = this._items[pNotify.iItem];
									this.onSelectedItemChanged(EventArgs.пуст);
								}
								
								if((changedState & 0x2000) || (changedState & 0x1000)) /* IF Checked || Unchecked THEN */
								{
									scope ListViewItemCheckedEventArgs e = new ListViewItemCheckedEventArgs(this._items[pNotify.iItem]);
									this.onItemChecked(e);
								}
							}
						}
						break;
					
						default:
							break;
					}
				}
			}
			break;

			default:
				break;
		}
		
		return super.поОбратномуСообщению(msg, парам1, парам2);
	}

	protected override void поСозданиюУказателя(EventArgs e)
	{		
		if(this._lvwInfo.GridLines)
		{
			this.шлиСооб(LVM_SETEXTENDEDLISTVIEWSTYLE, LVS_EX_GRIDLINES, LVS_EX_GRIDLINES);
		}

		if(this._lvwInfo.FullRow)
		{
			this.шлиСооб(LVM_SETEXTENDEDLISTVIEWSTYLE, LVS_EX_FULLROWSELECT, LVS_EX_FULLROWSELECT);
		}

		if(this._lvwInfo.CheckBoxes)
		{
			this.шлиСооб(LVM_SETEXTENDEDLISTVIEWSTYLE, LVS_EX_CHECKBOXES, LVS_EX_CHECKBOXES);
		}

		if(this._lvwInfo.ImgList)
		{
			this.шлиСооб(LVM_SETIMAGELIST, LVSIL_NORMAL, cast(LPARAM)this._lvwInfo.ImgList.handle);
			this.шлиСооб(LVM_SETIMAGELIST, LVSIL_SMALL, cast(LPARAM)this._lvwInfo.ImgList.handle);
		}

		if(this.дайСтиль() & ViewStyle.REPORT)
		{
			if(this._columns)
			{
				foreach(ListViewColumn lvc; this._columns)
				{
					ListView.insertColumn(lvc);
				}
			}
		}
		
		if(this._items)
		{
			foreach(ListViewItem lvi; this._items)
			{
				ListView.insertItem(lvi);
			}
		}

		super.поСозданиюУказателя(e);
	}

	protected void onSelectedItemChanged(EventArgs e)
	{
		this.itemChanged(this, e);
	}

	protected void onItemChecked(ListViewItemCheckedEventArgs e)
	{
		this.itemChecked(this, e);
	}
}