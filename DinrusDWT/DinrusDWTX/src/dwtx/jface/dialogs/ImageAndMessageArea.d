/*******************************************************************************
 * Copyright (c) 2006 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 ******************************************************************************/

module dwtx.jface.dialogs.ImageAndMessageArea;

import dwtx.jface.dialogs.IDialogConstants;

import dwt.DWT;
import dwt.events.PaintEvent;
import dwt.events.PaintListener;
import dwt.graphics.Color;
import dwt.graphics.Font;
import dwt.graphics.Image;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Composite;
import dwt.widgets.Layout;
import dwt.widgets.Text;
import dwtx.jface.fieldassist.DecoratedField;
import dwtx.jface.fieldassist.FieldDecorationRegistry;
import dwtx.jface.fieldassist.TextControlCreator;
import dwtx.jface.resource.JFaceResources;

import dwt.dwthelper.utils;

/**
 * Instances of this class provide a message area to display a message and an
 * associated image.
 * <p>
 * This class is not intended to be extended by clients.
 * </p>
 *
 * @since 3.2
 * @deprecated As of 3.3, this class is no longer necessary.
 *
 */
public class ImageAndMessageArea : Composite {

    private int BORDER_MARGIN = IDialogConstants.HORIZONTAL_SPACING / 2;

    private DecoratedField messageField;

    private Composite container;

    /**
     * Constructs a new ImageAndMessageArea with an empty decorated field. Calls
     * to <code>setText(String text)</code> and
     * <code>setImage(Image image)</code> are required in order to fill the
     * message area. Also, the instance will be invisible when initially
     * created.
     * <p>
     * The style bit <code>DWT.WRAP</code> should be used if a larger message
     * area is desired.
     * </p>
     *
     * @param parent
     *            the parent composite
     * @param style
     *            the DWT style bits. Using DWT.WRAP will create a larger
     *            message area.
     */
    public this(Composite parent, int style) {
        super(parent, style);
        container = new Composite(this, style);
        GridLayout glayout = new GridLayout();
        glayout.numColumns = 2;
        glayout.marginWidth = 0;
        glayout.marginHeight = 0;
        glayout.marginTop = BORDER_MARGIN;
        glayout.marginBottom = BORDER_MARGIN;
        container.setLayout(glayout);

        messageField = new DecoratedField(container, DWT.READ_ONLY | style,
                new TextControlCreator());
        setFont(JFaceResources.getDialogFont());

        GridData gd = new GridData(DWT.FILL, DWT.FILL, true, true);
        int lineHeight = (cast(Text) messageField.getControl()).getLineHeight();
        if ((style & DWT.WRAP) > 0)
            gd.heightHint = 2 * lineHeight;
        else
            gd.heightHint = lineHeight;

        messageField.getLayoutControl().setLayoutData(gd);

        addPaintListener(new class PaintListener {
            /*
             * (non-Javadoc)
             *
             * @see dwt.events.PaintListener#paintControl(dwt.events.PaintEvent)
             */
            public void paintControl(PaintEvent e) {
                onPaint(e);
            }
        });

        // sets the layout and size to account for the BORDER_MARGIN between
        // the border drawn around the container and the decorated field.
        setLayout(new class Layout {
            /*
             * (non-Javadoc)
             *
             * @see dwt.widgets.Layout#layout(dwt.widgets.Composite,
             *      bool)
             */
            public void layout(Composite parent, bool changed) {
                Rectangle carea = getClientArea();
                container.setBounds(carea.x + BORDER_MARGIN, carea.y
                        + BORDER_MARGIN, carea.width - (2 * BORDER_MARGIN),
                        carea.height - (2 * BORDER_MARGIN));
            }

            /*
             * (non-Javadoc)
             *
             * @see dwt.widgets.Layout#computeSize(dwt.widgets.Composite,
             *      int, int, bool)
             */
            public Point computeSize(Composite parent, int wHint, int hHint,
                    bool changed) {
                Point size;
                size = container.computeSize(wHint, hHint, changed);

                // size set to account for the BORDER_MARGIN on
                // all sides of the decorated field
                size.x += 4;
                size.y += 4;
                return size;
            }
        });
        setVisible(false);
    }

    /*
     * (non-Javadoc)
     *
     * @see dwt.widgets.Control#setBackground(dwt.graphics.Color)
     */
    public override void setBackground(Color bg) {
        super.setBackground(bg);
        messageField.getLayoutControl().setBackground(bg);
        messageField.getControl().setBackground(bg);
        container.setBackground(bg);
    }

    /**
     * Sets the text in the decorated field which will be displayed in the
     * message area.
     *
     * @param text
     *            the text to be displayed in the message area
     *
     * @see dwt.widgets.Text#setText(String string)
     */
    public void setText(String text) {
        (cast(Text) messageField.getControl()).setText(text);
    }

    /**
     * Adds an image to decorated field to be shown in the message area.
     *
     * @param image
     *            desired image to be shown in the ImageAndMessageArea
     */
    public void setImage(Image image) {
        FieldDecorationRegistry registry = FieldDecorationRegistry.getDefault();
        registry.registerFieldDecoration("messageImage", null, image); //$NON-NLS-1$
        messageField.addFieldDecoration(registry
                .getFieldDecoration("messageImage"), //$NON-NLS-1$
                DWT.LEFT | DWT.TOP, false);
    }

    /**
     * Draws the message area composite with rounded corners.
     */
    private void onPaint(PaintEvent e) {
        Rectangle carea = getClientArea();
        e.gc.setForeground(getForeground());

        // draws the polyline to be rounded in a 2 pixel squared area
        e.gc.drawPolyline([ carea.x, carea.y + carea.height - 1,
                carea.x, carea.y + 2, carea.x + 2, carea.y,
                carea.x + carea.width - 3, carea.y, carea.x + carea.width - 1,
                carea.y + 2, carea.x + carea.width - 1,
                carea.y + carea.height - 1 ]);
    }

    /*
     * (non-Javadoc)
     *
     * @see dwt.widgets.Control#setFont(dwt.graphics.Font)
     */
    public override void setFont(Font font) {
        super.setFont(font);
        (cast(Text) messageField.getControl()).setFont(font);
    }

    /*
     * (non-Javadoc)
     *
     * @see dwt.widgets.Control#setToolTipText(java.lang.String)
     */
    public override void setToolTipText(String text) {
        super.setToolTipText(text);
        (cast(Text) messageField.getControl()).setToolTipText(text);
    }
}
