/*******************************************************************************
 * Copyright (c) 2000, 2004 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * D Port:
 *     Bill Baxter <wbaxter> at gmail com
 *******************************************************************************/
module canvas.Snippet21;

/*
 * Canvas example snippet: implement tab traversal (behave like a tab group)
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 */
import dwt.DWT;
import dwt.graphics.Color;
import dwt.widgets.Display;
import dwt.widgets.Shell;
import dwt.widgets.Listener;
import dwt.widgets.Event;
import dwt.widgets.Button;
import dwt.widgets.Text;
import dwt.widgets.Canvas;

import tango.io.Stdout;

import dwt.dwthelper.utils;

void main () {
	Display display = new Display ();
	final Color red = display.getSystemColor (DWT.COLOR_RED);
	final Color blue = display.getSystemColor (DWT.COLOR_BLUE);
	Shell shell = new Shell (display);
	Button b = new Button (shell, DWT.PUSH);
	b.setBounds (10, 10, 100, 32);
	b.setText ("Button");
	shell.setDefaultButton (b);
	final Canvas c = new Canvas (shell, DWT.BORDER);
	c.setBounds (10, 50, 100, 32);

    void onTraverse(Event e, Canvas c) {
        switch (e.detail) {
            /* Do tab group traversal */
        case DWT.TRAVERSE_ESCAPE:
        case DWT.TRAVERSE_RETURN:
        case DWT.TRAVERSE_TAB_NEXT:	
        case DWT.TRAVERSE_TAB_PREVIOUS:
        case DWT.TRAVERSE_PAGE_NEXT:	
        case DWT.TRAVERSE_PAGE_PREVIOUS:
            e.doit = true;
            break;
        }
    }

    void onFocusIn(Event e, Canvas c) {
        c.setBackground (red);
    }

    void onFocusOut(Event e, Canvas c) {
        c.setBackground (blue);
    }

    void onKeyDown (Event e, Canvas c) {
        Stdout("KEY").newline;
        for (int i=0; i<64; i++) {
            Color c1 = red, c2 = blue;
            if (c.isFocusControl ()) {
                c1 = blue;  c2 = red;
            }
            c.setBackground (c1);
            c.update ();
            c.setBackground (c2);
        }
    }

	c.addListener (DWT.Traverse, dgListener(&onTraverse, c));
	c.addListener (DWT.FocusIn, dgListener(&onFocusIn, c));
	c.addListener (DWT.FocusOut, dgListener(&onFocusOut, c));
	c.addListener (DWT.KeyDown, dgListener(&onKeyDown, c));

	Text t = new Text (shell, DWT.SINGLE | DWT.BORDER);
	t.setBounds (10, 85, 100, 32);

	Text r = new Text (shell, DWT.MULTI | DWT.BORDER);
	r.setBounds (10, 120, 100, 32);
	
	c.setFocus ();
	shell.setSize (200, 200);
	shell.open ();
	while (!shell.isDisposed()) {
		if (!display.readAndDispatch ()) display.sleep ();
	}
	display.dispose ();
}
