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
module dwtx.jface.fieldassist.ComboContentAdapter;

import dwt.DWT;
import dwtx.jface.fieldassist.IControlContentAdapter;
import dwtx.jface.fieldassist.IControlContentAdapter2;

import dwt.graphics.GC;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.widgets.Combo;
import dwt.widgets.Control;

import dwt.dwthelper.utils;
import tango.text.Text;
alias tango.text.Text.Text!(char) StringBuffer;
/**
 * An {@link IControlContentAdapter} for DWT Combo controls. This is a
 * convenience class for easily creating a {@link ContentProposalAdapter} for
 * combo fields.
 *
 * @since 3.2
 */
public class ComboContentAdapter : IControlContentAdapter,
        IControlContentAdapter2 {

    /*
     * Set to <code>true</code> if we should compute the text
     * vertical bounds rather than just use the field size.
     * Workaround for https://bugs.eclipse.org/bugs/show_bug.cgi?id=164748
     * The corresponding DWT bug is
     * https://bugs.eclipse.org/bugs/show_bug.cgi?id=44072
     */
    private static final bool COMPUTE_TEXT_USING_CLIENTAREA = !"carbon".equals(DWT.getPlatform()); //$NON-NLS-1$


    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.dialogs.taskassistance.IControlContentAdapter#getControlContents(dwt.widgets.Control)
     */
    public String getControlContents(Control control) {
        return (cast(Combo) control).getText();
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.fieldassist.IControlContentAdapter#setControlContents(dwt.widgets.Control,
     *      java.lang.String, int)
     */
    public void setControlContents(Control control, String text,
            int cursorPosition) {
        (cast(Combo) control).setText(text);
        (cast(Combo) control)
                .setSelection(new Point(cursorPosition, cursorPosition));
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.fieldassist.IControlContentAdapter#insertControlContents(dwt.widgets.Control,
     *      java.lang.String, int)
     */
    public void insertControlContents(Control control, String text,
            int cursorPosition) {
        Combo combo = cast(Combo) control;
        String contents = combo.getText();
        Point selection = combo.getSelection();
        StringBuffer sb = new StringBuffer();
        sb.append(contents.substring(0, selection.x));
        sb.append(text);
        if (selection.y < contents.length) {
            sb.append(contents.substring(selection.y, contents.length));
        }
        combo.setText(sb.toString());
        selection.x = selection.x + cursorPosition;
        selection.y = selection.x;
        combo.setSelection(selection);
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.fieldassist.IControlContentAdapter#getCursorPosition(dwt.widgets.Control)
     */
    public int getCursorPosition(Control control) {
        return (cast(Combo) control).getSelection().x;
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.fieldassist.IControlContentAdapter#getInsertionBounds(dwt.widgets.Control)
     */
    public Rectangle getInsertionBounds(Control control) {
        // This doesn't take horizontal scrolling into affect.
        // see https://bugs.eclipse.org/bugs/show_bug.cgi?id=204599
        Combo combo = cast(Combo) control;
        int position = combo.getSelection().y;
        String contents = combo.getText();
        GC gc = new GC(combo);
        gc.setFont(combo.getFont());
        Point extent = gc.textExtent(contents.substring(0, Math.min(position,
                contents.length)));
        gc.dispose();
        if (COMPUTE_TEXT_USING_CLIENTAREA) {
            return new Rectangle(combo.getClientArea().x + extent.x, combo
                .getClientArea().y, 1, combo.getClientArea().height);
        }
        return new Rectangle(extent.x, 0, 1, combo.getSize().y);
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.fieldassist.IControlContentAdapter#setCursorPosition(dwt.widgets.Control,
     *      int)
     */
    public void setCursorPosition(Control control, int index) {
        (cast(Combo) control).setSelection(new Point(index, index));
    }

    /**
     * @see dwtx.jface.fieldassist.IControlContentAdapter2#getSelection(dwt.widgets.Control)
     *
     * @since 3.4
     */
    public Point getSelection(Control control) {
        return (cast(Combo) control).getSelection();
    }

    /**
     * @see dwtx.jface.fieldassist.IControlContentAdapter2#setSelection(dwt.widgets.Control,
     *      dwt.graphics.Point)
     *
     * @since 3.4
     */
    public void setSelection(Control control, Point range) {
        (cast(Combo) control).setSelection(range);
    }

}
