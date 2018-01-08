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

module dgui.кнопка;

public import dgui.control;

package const string WC_BUTTON = "Button";
private const string WC_DBUTTON = "DButton";
private const string WC_DCHECKBOX = "DCheckBox";
private const string WC_DRADIOBUTTON = "DRadioButton";

enum CheckState: uint
{
	CHECKED = BST_CHECKED,
	UNCHECKED = BST_UNCHECKED,
	INDETERMINATE = BST_INDETERMINATE,
}

abstract class AbstractButton: SubclassedControl
{
	private DialogResult _dr = DialogResult.NONE;

	protected override void preCreateWindow(inout PreCreateWindow pcw)
	{
		pcw.OldClassName = WC_BUTTON;

		super.preCreateWindow(pcw);
	}

	protected override int поОбратномуСообщению(uint msg, WPARAM парам1, LPARAM парам2)
	{
		switch(msg)
		{
			case WM_COMMAND:
			{
				switch(HIWORD(парам1))
				{
					 case BN_CLICKED:
					 {
						 if(this._dr !is DialogResult.NONE)
						 {
							IDialogResult iresult = cast(IDialogResult)this.topLevelControl;
							iresult.dialogResult = this._dr;
						 }
					 }
					 break;
					
					default:
						break;
				}
			}
			break;
			
			default:
				break;
		}
		
		return super.поОбратномуСообщению(msg, парам1, парам2);
	}

	protected override int окПроц(uint msg, WPARAM парам1, LPARAM парам2)
	{
		switch(msg)
		{
			case WM_ERASEBKGND:
				return this.originalWndProc(msg, парам1, парам2);
			
			default:
				return super.окПроц(msg, парам1, парам2);
		}
	}
}

abstract class CheckedButton: AbstractButton
{
	public Signal!(Control, EventArgs) checkChanged;
	
	private CheckState _checkState = CheckState.UNCHECKED;
	
	public бул checked()
	{
		return this.checkState is CheckState.CHECKED;		
	}
	
	public void checked(бул с)
	{
		this.checkState = с ? CheckState.CHECKED : CheckState.UNCHECKED;
	}
	
	public CheckState checkState()
	{
		if(this.created)
		{
			return cast(CheckState)this.шлиСооб(BM_GETCHECK, 0, 0);
		}

		return this._checkState;
	}

	public void checkState(CheckState cs)
	{
		this._checkState = cs;

		if(this.created)
		{
			this.шлиСооб(BM_SETCHECK, cs, 0);
		}
	}
	
	protected override void поСозданиюУказателя(EventArgs e)
	{
		this.шлиСооб(BM_SETCHECK, this._checkState, 0);
		super.поСозданиюУказателя(e);
	}
	
	protected override int поОбратномуСообщению(uint msg, WPARAM парам1, LPARAM парам2)
	{
		switch(msg)
		{
			case WM_COMMAND:
			{
				switch(HIWORD(парам1))
				{
					 case BN_CLICKED:
					 {
						if(this._checkState !is this.checkState) //Is Check State Changed?
						{
							this._checkState = this.checkState;
							this.onCheckChanged(EventArgs.пуст);
						}
					 }
					 break;
					
					default:
						break;
				}
			}
			break;
			
			default:
				break;
		}
		
		return super.поОбратномуСообщению(msg, парам1, парам2);
	}
	
	protected void onCheckChanged(EventArgs e)
	{
		this.checkChanged(this, e);
	}
}

class Button: AbstractButton
{	
	public this()
	{
		super();
		
		this.установиСтиль(BS_DEFPUSHBUTTON, да);
	}

	public DialogResult dialogResult()
	{
		return this._dr;
	}

	public void dialogResult(DialogResult dr)
	{
		this._dr = dr;
	}
	
	protected override void preCreateWindow(inout PreCreateWindow pcw)
	{
		pcw.ClassName = WC_DBUTTON;

		super.preCreateWindow(pcw);
	}
}

class Флажок: CheckedButton
{
	public this()
	{
		super();
		
		this.установиСтиль(BS_AUTOCHECKBOX, да);
	}
	
	protected override void preCreateWindow(inout PreCreateWindow pcw)
	{
		pcw.ClassName = WC_DCHECKBOX;

		super.preCreateWindow(pcw);
	}
}

class РадиоКнопка: CheckedButton
{
	public this()
	{
		super();
		
		this.установиСтиль(BS_AUTORADIOBUTTON, да);
	}
	
	protected override void preCreateWindow(inout PreCreateWindow pcw)
	{
		pcw.ClassName = WC_DRADIOBUTTON;

		super.preCreateWindow(pcw);
	}
}