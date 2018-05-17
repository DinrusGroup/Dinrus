/*******************************************************************************
 * Copyright (c) 2005, 2008 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module dwtx.jface.fieldassist.TextContentAdapter;

import dwtx.jface.fieldassist.IControlContentAdapter;
import dwtx.jface.fieldassist.IControlContentAdapter2;

import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.widgets.Control;
import dwt.widgets.Text;

import dwt.dwthelper.utils;

/**
 * An {@link IControlContentAdapter} for DWT Text controls. This is a
 * convenience class for easily creating a {@link ContentProposalAdapter} for
 * text fields.
 *
 * @since 3.2
 */
public class TextContentAdapter : IControlContentAdapter,
        IControlContentAdapter2 {

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.dialogs.taskassistance.IControlContentAdapter#getControlContents(dwt.widgets.Control)
     */
    public String getControlContents(Control control) {
        return (cast(Text) control).getText();
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.fieldassist.IControlContentAdapter#setControlContents(dwt.widgets.Control,
     *      java.lang.String, int)
     */
    public void setControlContents(Control control, String text,
            int cursorPosition) {
        (cast(Text) control).setText(text);
        (cast(Text) control).setSelection(cursorPosition, cursorPosition);
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.fieldassist.IControlContentAdapter#insertControlContents(dwt.widgets.Control,
     *      java.lang.String, int)
     */
    public void insertControlContents(Control control, String text,
            int cursorPosition) {
        Point selection = (cast(Text) control).getSelection();
        (cast(Text) control).insert(text);
        // Insert will leave the cursor at the end of the inserted text. If this
        // is not what we wanted, reset the selection.
        if (cursorPosition < text.length) {
            (cast(Text) control).setSelection(selection.x + cursorPosition,
                    selection.x + cursorPosition);
        }
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.fieldassist.IControlContentAdapter#getCursorPosition(dwt.widgets.Control)
     */
    public int getCursorPosition(Control control) {
        return (cast(Text) control).getCaretPosition();
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.fieldassist.IControlContentAdapter#getInsertionBounds(dwt.widgets.Control)
     */
    public Rectangle getInsertionBounds(Control control) {
        Text text = cast(Text) control;
        Point caretOrigin = text.getCaretLocation();
        // We fudge the y pixels due to problems with getCaretLocation
        // See https://bugs.eclipse.org/bugs/show_bug.cgi?id=52520
        return new Rectangle(caretOrigin.x + text.getClientArea().x,
                caretOrigin.y + text.getClientArea().y + 3, 1, text.getLineHeight());
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.fieldassist.IControlContentAdapter#setCursorPosition(dwt.widgets.Control,
     *      int)
     */
    public void setCursorPosition(Control control, int position) {
        (cast(Text) control).setSelection(new Point(position, position));
    }

    /**
     * @see dwtx.jface.fieldassist.IControlContentAdapter2#getSelection(dwt.widgets.Control)
     *
     * @since 3.4
     */
    public Point getSelection(Control control) {
        return (cast(Text) control).getSelection();
    }

    /**
     * @see dwtx.jface.fieldassist.IControlContentAdapter2#setSelection(dwt.widgets.Control,
     *      dwt.graphics.Point)
     *
     * @since 3.4
     */
    public void setSelection(Control control, Point range) {
        (cast(Text) control).setSelection(range);
    }
}
