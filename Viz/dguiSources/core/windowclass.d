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

module dgui.core.windowclass;

public import dgui.core.winapi;
public import dgui.core.enums;
public import dgui.canvas;
public import stdrus;

private alias WNDPROC[string] ClassMap; //Tiene traccia delle окно procedure originali: [OrgClassName | OrgWndProc]

public void registerWindowClass(string className, ClassStyles classStyle, Cursor cursor, WNDPROC окПроц)
{	
	static HINSTANCE hInst;
	WNDCLASSEXA ко;

	if(!hInst)
	{
		hInst = getHInstance();
	}

	бул found = cast(бул)GetClassInfoExA(hInst, toStringz(className), &ко);

	if(!found)
	{
		ко.cbSize = WNDCLASSEXA.sizeof;
		ко.lpszClassName = toStringz(className);
		ко.hCursor = cursor ? cursor.handle : SystemCursors.стрелка.handle;
		ко.hInstance = hInst;
		ко.hbrBackground = SystemBrushes.brushBtnFace.handle;
		ко.lpfnWndProc = окПроц;
		ко.style = classStyle;
			
		if(!RegisterClassExA(&ко))
		{
			debug
			{
				throw new Win32Exception(фм("Windows Class \"%s\" not created", className), __FILE__, __LINE__);
			}
			else
			{
				throw new Win32Exception(фм("Windows Class \"%s\" not created", className));
			}
		}
	}
}

public WNDPROC superClassWindowClass(string oldClassName, string newClassName, WNDPROC newWndProc)
{
	static HINSTANCE hInst;
	static ClassMap classMap;
	WNDCLASSEXA oldWc = void, newWc = void; //Non serve inizializzarli

	if(!hInst)
	{
		hInst = getHInstance();
	}

	oldWc.cbSize = WNDCLASSEXA.sizeof;
	newWc.cbSize = WNDCLASSEXA.sizeof;
	
	ткст0 pOldClassName = toStringz(oldClassName);
	ткст0 pNewClassName = toStringz(newClassName);

	if(!GetClassInfoExA(hInst, pNewClassName, &newWc)) // IF Classe Non Trovata THEN
	{
		// Super Classing
		GetClassInfoExA(hInst, pOldClassName, &oldWc);

		//Salvo la окно procedure originale nella ClassMap
		classMap[oldClassName] = oldWc.lpfnWndProc;

		newWc = oldWc;
		newWc.style &= ClassStyles.PARENTDC | (~ClassStyles.GLOBALCLASS);
		newWc.lpfnWndProc = newWndProc;
		newWc.lpszClassName = pNewClassName;
		newWc.hInstance = hInst;
		//newWc.hbrBackground = пусто; //Lo disegno io (se serve).

		if(!RegisterClassExA(&newWc))
		{
			debug
			{
				throw new Win32Exception(фм("Windows Class \"%s\" not created", newClassName), __FILE__, __LINE__);
			}
			else
			{
				throw new Win32Exception(фм("Windows Class \"%s\" not created", newClassName));
			}
		}
	}

	return classMap[oldClassName]; //Ritorno la Window Procedure Originale
}