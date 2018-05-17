/*******************************************************************************
 * Copyright (c) 2000, 2005 IBM Corporation and others.
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
module dwtx.draw2d.widgets.MultiLineLabel;

import dwt.dwthelper.utils;



import dwt.DWT;
import dwt.accessibility.ACC;
import dwt.accessibility.AccessibleAdapter;
import dwt.accessibility.AccessibleControlAdapter;
import dwt.accessibility.AccessibleControlEvent;
import dwt.accessibility.AccessibleEvent;
import dwt.events.KeyAdapter;
import dwt.events.KeyEvent;
import dwt.graphics.Font;
import dwt.graphics.Image;
import dwt.widgets.Composite;
import dwtx.draw2d.Border;
import dwtx.draw2d.ColorConstants;
import dwtx.draw2d.FigureCanvas;
import dwtx.draw2d.FocusEvent;
import dwtx.draw2d.Graphics;
import dwtx.draw2d.MarginBorder;
import dwtx.draw2d.Viewport;
import dwtx.draw2d.geometry.Point;
import dwtx.draw2d.text.FlowPage;
import dwtx.draw2d.text.TextFlow;
import dwtx.draw2d.widgets.ImageBorder;

/**
 * A widget for displaying a multi-line string. The label will have a vertical or
 * horizontal scrollbar when needed. Unlike the platform Label, this label is focusable
 * and accessible to screen-readers.
 *
 * @author hudsonr
 */
public final class MultiLineLabel : FigureCanvas {

private TextFlow textFlow;
private static Border MARGIN_;
static Border MARGIN(){
    if( MARGIN_ is null ){
        synchronized( MultiLineLabel.classinfo ){
            if( MARGIN_ is null ){
                MARGIN_ = new MarginBorder(2);
            }
        }
    }
    return MARGIN_;
}

private Image image;

class FocusableViewport : Viewport {
    this() {
        super(true);
        setFocusTraversable(true);
        setBorder(MARGIN);
    }

    public void handleFocusGained(FocusEvent event) {
        super.handleFocusGained(event);
        repaint();
    }

    public void handleFocusLost(FocusEvent event) {
        super.handleFocusLost(event);
        repaint();
    }

    protected void paintBorder(Graphics graphics) {
        super.paintBorder(graphics);
        if (hasFocus()) {
            graphics.setForegroundColor(ColorConstants.black);
            graphics.setBackgroundColor(ColorConstants.white);
            graphics.drawFocus(getBounds().getResized(-1, -1));
        }
    }
}

/**
 * Constructs a new MultiLineLabel with the given parent.
 * @param parent the parent
 */
public this(Composite parent) {
    super(parent);
    setViewport(new FocusableViewport());

    FlowPage page = new FlowPage();
    textFlow = new TextFlow();
    page.add(textFlow);

    setContents(page);
    getViewport().setContentsTracksWidth(true);
    addAccessibility();
}

private void addAccessibility() {
    getAccessible().addAccessibleControlListener(new class() AccessibleControlAdapter {
        public void getRole(AccessibleControlEvent e) {
            e.detail = ACC.ROLE_LABEL;
        }
        public void getState(AccessibleControlEvent e) {
            e.detail = ACC.STATE_READONLY;
        }
    });
    getAccessible().addAccessibleListener(new class() AccessibleAdapter {
        public void getName(AccessibleEvent e) {
            e.result = getText();
        }
    });
    addKeyListener(new class() KeyAdapter {
        public void keyPressed(KeyEvent e) {
            Point p = getViewport().getViewLocation();
            int dy = getFont().getFontData()[0].getHeight();
            int dx = dy * 3 / 2;
            bool mirrored = (e.widget.getStyle() & DWT.MIRRORED) !is 0;
            if (e.keyCode is DWT.ARROW_DOWN) {
                scrollToY(p.y + dy / 2);
                scrollToY(p.y + dy);
                scrollToY(p.y + dy * 3 / 2);
                scrollToY(p.y + dy * 2);
            } else if (e.keyCode is DWT.ARROW_UP) {
                scrollToY(p.y - dy / 2);
                scrollToY(p.y - dy);
                scrollToY(p.y - dy * 3 / 2);
                scrollToY(p.y - dy * 2);
            } else if ((!mirrored && e.keyCode is DWT.ARROW_RIGHT)
                    || (mirrored && e.keyCode is DWT.ARROW_LEFT)) {
                scrollToX(p.x + dx);
                scrollToX(p.x + dx * 2);
                scrollToX(p.x + dx * 3);
            } else if ((!mirrored && e.keyCode is DWT.ARROW_LEFT)
                    || (mirrored && e.keyCode is DWT.ARROW_RIGHT)) {
                scrollToX(p.x - dx);
                scrollToX(p.x - dx * 2);
                scrollToX(p.x - dx * 3);
            }
        }
    });
}

/**
 * @see dwt.widgets.Control#setEnabled(bool)
 */
public void setEnabled(bool enabled) {
    super.setEnabled(enabled);
    textFlow.setEnabled(getEnabled());
}

/**
 * @return the Image for this label, or <code>null</code> if there is none
 * @see #setImage(Image)
 */
public Image getImage() {
    return image;
}

/**
 * Returns the text in this label.
 * @return the text
 */
public String getText() {
    return textFlow.getText();
}

/**
 * @see dwt.widgets.Canvas#setFont(dwt.graphics.Font)
 */
public void setFont(Font font) {
    super.setFont(font);
    textFlow.revalidate();
}

/**
 * @param   image   The <code>Image</code> to be used for this label.  It can be
 *                  <code>null</code>.
 */
public void setImage(Image image) {
    this.image = image;
    if (image !is null)
        setBorder(new ImageBorder(image));
    else
        setBorder(null);
}

/**
 * Sets the text for this label.
 * @param text the new text
 */
public void setText(String text) {
    textFlow.setText(text);
}

}
