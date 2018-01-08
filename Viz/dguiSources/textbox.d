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

module dgui.textbox;

public import dgui.core.winapi;
public import dgui.control;
public import std.string;

private const string WC_EDIT = "EDIT";
private const string WC_DEDIT = "DTextBox";

enum CharacterCasing
{
	NORMAL = 0,
	UPPERCASE = ES_UPPERCASE,
	LOWERCASE = ES_LOWERCASE,
}

abstract class TextControl: SubclassedControl
{
	public Signal!(Control, EventArgs) textChanged;
	
	public this()
	{
		
	}

	public void добавьТекст(string s)
	{
		if(this.created)
		{
			this.шлиСооб(EM_REPLACESEL, да, cast(LPARAM)toStringz(s));
		}
		else
		{
			this._controlInfo.Text ~= s;
		}
	}
	
	public final бул readOnly()
	{
		return !(this.дайСтиль() & ES_READONLY);
	}

	public final void readOnly(бул с)
	{
		this.установиСтиль(ES_READONLY, с);
	}

	public void отмени()
	in
	{
		assert(this.created);
	}
	body
	{
		this.шлиСооб(EM_UNDO, 0, 0);
	}

	public void вырежь()
	in
	{
		assert(this.created);
	}
	body
	{
		this.шлиСооб(WM_CUT, 0, 0);
	}

	public void копируй()
	in
	{
		assert(this.created);
	}
	body
	{
		this.шлиСооб(WM_COPY, 0, 0);
	}

	public void вставь()
	in
	{
		assert(this.created);
	}
	body
	{
		this.шлиСооб(WM_PASTE, 0, 0);
	}
	public void selectAll()
	in
	{
		assert(this.created);
	}
	body
	{
		this.шлиСооб(EM_SETSEL, 0, -1);
	}

	public void сотри()
	in
	{
		assert(this.created);
	}
	body
	{
		this.шлиСооб(WM_CLEAR, 0, 0);
	}

	public бул изменён()
	{
		if(this.created)
		{
			return cast(бул)this.шлиСооб(EM_GETMODIFY, 0, 0);
		}

		return нет;
	}

	public void изменён(бул с)
	in
	{
		assert(this.created);
	}
	body
	{
		this.шлиСооб(EM_SETMODIFY, с, 0);
	}

	public int textLength()
	{
		return this.шлиСооб(WM_GETTEXTLENGTH, 0, 0);
	}

	public final string выделенныйТекст()
	{
		CHARRANGE chrg = void; //Inizializzata sotto

		this.шлиСооб(EM_EXGETSEL, 0, cast(LPARAM)&chrg);
		return this.text[chrg.cpMin..chrg.cpMax];
	}

	public final int началоВыделения()
	{
		CHARRANGE chrg = void; //Inizializzata sotto

		this.шлиСооб(EM_EXGETSEL, 0, cast(LPARAM)&chrg);
		return chrg.cpMin;
	}

	public final int длинаВыделения()
	{
		CHARRANGE chrg = void; //Inizializzata sotto

		this.шлиСооб(EM_EXGETSEL, 0, cast(LPARAM)&chrg);
		return chrg.cpMax - chrg.cpMin;
	}

	protected override void preCreateWindow(inout PreCreateWindow pcw)
	{
		pcw.ExtendedStyle = WS_EX_CLIENTEDGE;
		pcw.DefaultBackColor = СистемныеЦвета.colorWindow;

		super.preCreateWindow(pcw);
	}

	protected override int поОбратномуСообщению(uint msg, WPARAM парам1, LPARAM  парам2)
	{
		if(msg == WM_COMMAND)
		{
			if(HIWORD(парам1) == EN_CHANGE)
			{
				this.onTextChanged(EventArgs.пуст);
			}
		}
		
		return super.поОбратномуСообщению(msg, парам1, парам2);
	}

	protected override void поСозданиюУказателя(EventArgs e)
	{
		this.focus();
		this.изменён = нет; //Lo metto а 0 (ci puo' essere del testo inserito mentre il componente viene creato).
		
		super.поСозданиюУказателя(e);
	}

	protected void onTextChanged(EventArgs e)
	{
		this.textChanged(this, e);
	}
}

class TextBox: TextControl
{
	private CharacterCasing _chChasing  = CharacterCasing.NORMAL;
	private бул _numbersOnly = нет;
	private бул _passText = нет;

	public final CharacterCasing characterCasing()
	{
		return this._chChasing;
	}

	public final void characterCasing(CharacterCasing ch)
	{
		if(this.created)
		{
			this.установиСтиль(this._chChasing, нет); //Vecchio
			this.установиСтиль(ch, да); //Nuovo
		}
		
		this._chChasing = ch;
	}

	public final void numbersOnly(бул с)
	{
		this._numbersOnly = с;

		if(this.created)
		{
			this.установиСтиль(ES_NUMBER, с);
		}
	}

	public final void passwordText(бул с)
	{
		this._passText = с;

		if(this.created)
		{
			this.установиСтиль(ES_PASSWORD, с);
		}
	}
	
	protected override void preCreateWindow(inout PreCreateWindow pcw)
	{
		pcw.OldClassName = WC_EDIT;
		pcw.ClassName = WC_DEDIT;
		pcw.Style |= this._chChasing;

		if(this._numbersOnly)
		{
			pcw.Style |= ES_NUMBER;
		}

		if(this._passText)
		{
			pcw.Style |= ES_PASSWORD;
		}

		this.height = 20;
		super.preCreateWindow(pcw);
	}
}