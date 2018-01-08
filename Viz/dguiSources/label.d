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

module dgui.label;

public import dgui.control;

private const string WC_STATIC = "STATIC";
private const string WC_DLABEL = "DLabel";

enum LabelDrawMode: ббайт
{
	NORMAL = 0,
	OWNER_DRAW = 1,
}

class Label: SubclassedControl
{
	private LabelDrawMode _drawMode = LabelDrawMode.NORMAL;
	private РасположениеТекста _textAlign = РасположениеТекста.MIDDLE | РасположениеТекста.LEFT;

	public final LabelDrawMode drawMode()
	{
		return this._drawMode;
	}

	public final void drawMode(LabelDrawMode ldm)
	{
		this._drawMode = ldm;
	}

	public final РасположениеТекста расположение()
	{
		return this._textAlign;
	}

	public final void расположение(РасположениеТекста ta)
	{
		this._textAlign = ta;
	}

	protected override void preCreateWindow(inout PreCreateWindow pcw)
	{
		pcw.ClassName = WC_DLABEL;
		pcw.OldClassName = WC_STATIC;

		super.preCreateWindow(pcw);
	}

	protected override void onPaint(PaintEventArgs e)
	{
		super.onPaint(e);

		if(this._drawMode is LabelDrawMode.NORMAL)
		{
			Rect к = void; //Inizializzata da GetClientRect()
			Canvas ктрл = e.canvas;

			GetClientRect(this._handle, &к.rect);

			//scope ФорматТекста tf = new ФорматТекста(ФлагиФорматаТекста.ЕДИНАЯ_СТРОКА);
			scope ФорматТекста tf = new ФорматТекста(ФлагиФорматаТекста.ПРЕРВАТЬ_СЛОВО);
			tf.расположение = this._textAlign;

			scope ПлотнаяКисть sb = new ПлотнаяКисть(this._controlInfo.BackColor);
			ктрл.заполниПрямоугольник(sb, к);
			ктрл.рисуйТекст(this.text, к, this._controlInfo.ForeColor, this.font, tf);
		}
	}
}