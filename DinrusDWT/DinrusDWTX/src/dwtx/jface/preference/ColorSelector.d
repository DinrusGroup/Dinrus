/*******************************************************************************
 * Copyright (c) 2000, 2007 IBM Corporation and others.
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
module dwtx.jface.preference.ColorSelector;


import dwt.DWT;
import dwt.accessibility.AccessibleAdapter;
import dwt.accessibility.AccessibleEvent;
import dwt.events.DisposeEvent;
import dwt.events.DisposeListener;
import dwt.events.SelectionAdapter;
import dwt.events.SelectionEvent;
import dwt.graphics.Color;
import dwt.graphics.Font;
import dwt.graphics.GC;
import dwt.graphics.Image;
import dwt.graphics.Point;
import dwt.graphics.RGB;
import dwt.widgets.Button;
import dwt.widgets.ColorDialog;
import dwt.widgets.Composite;
import dwt.widgets.Control;
import dwt.widgets.Display;
import dwtx.core.commands.common.EventManager;
import dwtx.jface.resource.JFaceResources;
import dwtx.jface.util.IPropertyChangeListener;
import dwtx.jface.util.PropertyChangeEvent;

import dwt.dwthelper.utils;

/**
 * The <code>ColorSelector</code> is a wrapper for a button that displays a
 * selected <code>Color</code> and allows the user to change the selection.
 */
public class ColorSelector : EventManager {
    /**
     * Property name that signifies the selected color of this
     * <code>ColorSelector</code> has changed.
     *
     * @since 3.0
     */
    public static const String PROP_COLORCHANGE = "colorValue"; //$NON-NLS-1$

    private Button fButton;

    private Color fColor;

    private RGB fColorValue;

    private Point fExtent;

    private Image fImage;

    /**
     * Create a new instance of the reciever and the button that it wrappers in
     * the supplied parent <code>Composite</code>.
     *
     * @param parent
     *            The parent of the button.
     */
    public this(Composite parent) {
        fButton = new Button(parent, DWT.PUSH);
        fExtent = computeImageSize(parent);
        fImage = new Image(parent.getDisplay(), fExtent.x, fExtent.y);
        GC gc = new GC(fImage);
        gc.setBackground(fButton.getBackground());
        gc.fillRectangle(0, 0, fExtent.x, fExtent.y);
        gc.dispose();
        fButton.setImage(fImage);
        fButton.addSelectionListener(new class SelectionAdapter {
            public void widgetSelected(SelectionEvent event) {
                open();
            }
        });
        fButton.addDisposeListener(new class DisposeListener {
            public void widgetDisposed(DisposeEvent event) {
                if (fImage !is null) {
                    fImage.dispose();
                    fImage = null;
                }
                if (fColor !is null) {
                    fColor.dispose();
                    fColor = null;
                }
            }
        });
        fButton.getAccessible().addAccessibleListener(new class AccessibleAdapter {
            /*
             * (non-Javadoc)
             *
             * @see dwt.accessibility.AccessibleAdapter#getName(dwt.accessibility.AccessibleEvent)
             */
            public void getName(AccessibleEvent e) {
                e.result = JFaceResources.getString("ColorSelector.Name"); //$NON-NLS-1$
            }
        });
    }

    /**
     * Adds a property change listener to this <code>ColorSelector</code>.
     * Events are fired when the color in the control changes via the user
     * clicking an selecting a new one in the color dialog. No event is fired in
     * the case where <code>setColorValue(RGB)</code> is invoked.
     *
     * @param listener
     *            a property change listener
     * @since 3.0
     */
    public void addListener(IPropertyChangeListener listener) {
        addListenerObject(cast(Object)listener);
    }

    /**
     * Compute the size of the image to be displayed.
     *
     * @param window -
     *            the window used to calculate
     * @return <code>Point</code>
     */
    private Point computeImageSize(Control window) {
        GC gc = new GC(window);
        Font f = JFaceResources.getFontRegistry().get(
                JFaceResources.DIALOG_FONT);
        gc.setFont(f);
        int height = gc.getFontMetrics().getHeight();
        gc.dispose();
        Point p = new Point(height * 3 - 6, height);
        return p;
    }

    /**
     * Get the button control being wrappered by the selector.
     *
     * @return <code>Button</code>
     */
    public Button getButton() {
        return fButton;
    }

    /**
     * Return the currently displayed color.
     *
     * @return <code>RGB</code>
     */
    public RGB getColorValue() {
        return fColorValue;
    }

    /**
     * Removes the given listener from this <code>ColorSelector</code>. Has
     * no affect if the listener is not registered.
     *
     * @param listener
     *            a property change listener
     * @since 3.0
     */
    public void removeListener(IPropertyChangeListener listener) {
        removeListenerObject(cast(Object)listener);
    }

    /**
     * Set the current color value and update the control.
     *
     * @param rgb
     *            The new color.
     */
    public void setColorValue(RGB rgb) {
        fColorValue = rgb;
        updateColorImage();
    }

    /**
     * Set whether or not the button is enabled.
     *
     * @param state
     *            the enabled state.
     */
    public void setEnabled(bool state) {
        getButton().setEnabled(state);
    }

    /**
     * Update the image being displayed on the button using the current color
     * setting.
     */
    protected void updateColorImage() {
        Display display = fButton.getDisplay();
        GC gc = new GC(fImage);
        gc.setForeground(display.getSystemColor(DWT.COLOR_BLACK));
        gc.drawRectangle(0, 2, fExtent.x - 1, fExtent.y - 4);
        if (fColor !is null) {
            fColor.dispose();
        }
        fColor = new Color(display, fColorValue);
        gc.setBackground(fColor);
        gc.fillRectangle(1, 3, fExtent.x - 2, fExtent.y - 5);
        gc.dispose();
        fButton.setImage(fImage);
    }

    /**
     * Activate the editor for this selector. This causes the color selection
     * dialog to appear and wait for user input.
     *
     * @since 3.2
     */
    public void open() {
        ColorDialog colorDialog = new ColorDialog(fButton.getShell());
        colorDialog.setRGB(fColorValue);
        RGB newColor = colorDialog.open();
        if (newColor !is null) {
            RGB oldValue = fColorValue;
            fColorValue = newColor;
            final Object[] finalListeners = getListeners();
            if (finalListeners.length > 0) {
                PropertyChangeEvent pEvent = new PropertyChangeEvent(
                        this, PROP_COLORCHANGE, oldValue, newColor);
                for (int i = 0; i < finalListeners.length; ++i) {
                    IPropertyChangeListener listener = cast(IPropertyChangeListener) finalListeners[i];
                    listener.propertyChange(pEvent);
                }
            }
            updateColorImage();
        }
    }
}
