/*******************************************************************************
 * Copyright (c) 2000, 2004 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * Port to the D programming language:
 *     Bill Baxter <bill@billbaxter.com>
 *******************************************************************************/
module control.Snippet25;
 
/*
 * Control example snippet: print key state, code and character
 *
 * For a list of all DWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 * 
 * @since 3.0
 */
import dwt.DWT;
import dwt.widgets.Display;
import dwt.widgets.Shell;
import dwt.widgets.Listener;
import dwt.widgets.Event;

import tango.io.Stdout;
import tango.text.convert.Format;

static char[] stateMask (int stateMask) {
	char[] string = "";
	if ((stateMask & DWT.CTRL) != 0) string ~= " CTRL";
	if ((stateMask & DWT.ALT) != 0) string ~= " ALT";
	if ((stateMask & DWT.SHIFT) != 0) string ~= " SHIFT";
	if ((stateMask & DWT.COMMAND) != 0) string ~= " COMMAND";
	return string;
}

static char[] character (char character) {
	switch (character) {
    case 0: 		return "'\\0'";
    case DWT.BS:	return "'\\b'";
    case DWT.CR:	return "'\\r'";
    case DWT.DEL:	return "DEL";
    case DWT.ESC:	return "ESC";
    case DWT.LF:	return "'\\n'";
    case DWT.TAB:	return "'\\t'";
    default:
        return "'" ~ character ~"'";
	}
}

static char[] keyCode (int keyCode) {
	switch (keyCode) {
		
		/* Keyboard and Mouse Masks */
    case DWT.ALT: 		return "ALT";
    case DWT.SHIFT: 	return "SHIFT";
    case DWT.CONTROL:	return "CONTROL";
    case DWT.COMMAND:	return "COMMAND";
			
		/* Non-Numeric Keypad Keys */
    case DWT.ARROW_UP:		return "ARROW_UP";
    case DWT.ARROW_DOWN:	return "ARROW_DOWN";
    case DWT.ARROW_LEFT:	return "ARROW_LEFT";
    case DWT.ARROW_RIGHT:	return "ARROW_RIGHT";
    case DWT.PAGE_UP:		return "PAGE_UP";
    case DWT.PAGE_DOWN:		return "PAGE_DOWN";
    case DWT.HOME:			return "HOME";
    case DWT.END:			return "END";
    case DWT.INSERT:		return "INSERT";

		/* Virtual and Ascii Keys */
    case DWT.BS:	return "BS";
    case DWT.CR:	return "CR";		
    case DWT.DEL:	return "DEL";
    case DWT.ESC:	return "ESC";
    case DWT.LF:	return "LF";
    case DWT.TAB:	return "TAB";
	
		/* Functions Keys */
    case DWT.F1:	return "F1";
    case DWT.F2:	return "F2";
    case DWT.F3:	return "F3";
    case DWT.F4:	return "F4";
    case DWT.F5:	return "F5";
    case DWT.F6:	return "F6";
    case DWT.F7:	return "F7";
    case DWT.F8:	return "F8";
    case DWT.F9:	return "F9";
    case DWT.F10:	return "F10";
    case DWT.F11:	return "F11";
    case DWT.F12:	return "F12";
    case DWT.F13:	return "F13";
    case DWT.F14:	return "F14";
    case DWT.F15:	return "F15";
		
		/* Numeric Keypad Keys */
    case DWT.KEYPAD_ADD:		return "KEYPAD_ADD";
    case DWT.KEYPAD_SUBTRACT:	return "KEYPAD_SUBTRACT";
    case DWT.KEYPAD_MULTIPLY:	return "KEYPAD_MULTIPLY";
    case DWT.KEYPAD_DIVIDE:		return "KEYPAD_DIVIDE";
    case DWT.KEYPAD_DECIMAL:	return "KEYPAD_DECIMAL";
    case DWT.KEYPAD_CR:			return "KEYPAD_CR";
    case DWT.KEYPAD_0:			return "KEYPAD_0";
    case DWT.KEYPAD_1:			return "KEYPAD_1";
    case DWT.KEYPAD_2:			return "KEYPAD_2";
    case DWT.KEYPAD_3:			return "KEYPAD_3";
    case DWT.KEYPAD_4:			return "KEYPAD_4";
    case DWT.KEYPAD_5:			return "KEYPAD_5";
    case DWT.KEYPAD_6:			return "KEYPAD_6";
    case DWT.KEYPAD_7:			return "KEYPAD_7";
    case DWT.KEYPAD_8:			return "KEYPAD_8";
    case DWT.KEYPAD_9:			return "KEYPAD_9";
    case DWT.KEYPAD_EQUAL:		return "KEYPAD_EQUAL";

		/* Other keys */
    case DWT.CAPS_LOCK:		return "CAPS_LOCK";
    case DWT.NUM_LOCK:		return "NUM_LOCK";
    case DWT.SCROLL_LOCK:	return "SCROLL_LOCK";
    case DWT.PAUSE:			return "PAUSE";
    case DWT.BREAK:			return "BREAK";
    case DWT.PRINT_SCREEN:	return "PRINT_SCREEN";
    case DWT.HELP:			return "HELP";

    default:
        return character (cast(char) keyCode);
	}

}

void main () {
	Display display = new Display ();
	Shell shell = new Shell (display);
	Listener listener = new class Listener {
		public void handleEvent (Event e) {
			char[] string = e.type == DWT.KeyDown ? "DOWN:" : "UP  :";
			string ~= Format("stateMask=0x{:x}{},", e.stateMask, stateMask (e.stateMask));
			string ~= Format(" keyCode=0x{:x} {},", e.keyCode, keyCode (e.keyCode));
			string ~= Format(" character=0x{:x} {}", e.character, character (e.character));
			Stdout.formatln (string);
		}
	};
	shell.addListener (DWT.KeyDown, listener);
	shell.addListener (DWT.KeyUp, listener);
	shell.setSize (200, 200);
	shell.open ();
	while (!shell.isDisposed ()) {
		if (!display.readAndDispatch ()) display.sleep ();
	}
	display.dispose ();
}
