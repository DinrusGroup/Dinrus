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
module dwtx.draw2d.CheckBox;

import dwt.dwthelper.utils;
import dwt.dwthelper.ByteArrayInputStream;

import dwt.graphics.Image;
import dwt.graphics.ImageData;
import dwtx.draw2d.Toggle;
import dwtx.draw2d.Label;
import dwtx.draw2d.ChangeListener;
import dwtx.draw2d.ChangeEvent;
import dwtx.draw2d.ButtonModel;

/**
 * A Checkbox is a toggle figure which toggles between the checked and unchecked figures
 * to simulate a check box. A check box contains a text label to represent it.
 */
public final class CheckBox
    : Toggle
{

private Label label = null;

private static Image
    UNCHECKED_,
    CHECKED_;

package static Image UNCHECKED(){
    if( UNCHECKED_ is null ){
        synchronized( CheckBox.classinfo ){
            if( UNCHECKED_ is null ){
                UNCHECKED_ = createImage( getImportData!("dwtx.draw2d.checkboxenabledoff.gif"));
            }
        }
    }
    assert( UNCHECKED_ );
    return UNCHECKED_;
}
package static Image CHECKED(){
    if( CHECKED_ is null ){
        synchronized( CheckBox.classinfo ){
            if( CHECKED_ is null ){
                CHECKED_ = createImage( getImportData!("dwtx.draw2d.checkboxenabledon.gif"));
            }
        }
    }
    assert( CHECKED_ );
    return CHECKED_;
}

private static Image createImage( ImportData importdata ) {
    Image image = new Image(null, new ImageData(new ByteArrayInputStream( cast(byte[]) importdata.data)));
    return image;
}

/**
 * Constructs a CheckBox with no text.
 *
 * @since 2.0
 */
public this() {
    this(""); //$NON-NLS-1$
}

/**
 * Constructs a CheckBox with the passed text in its label.
 * @param text The label text
 * @since 2.0
 */
public this(String text) {
    setContents(label = new Label(text, UNCHECKED));
}

/**
 * Adjusts CheckBox's icon depending on selection status.
 *
 * @since 2.0
 */
protected void handleSelectionChanged() {
    if (isSelected())
        label.setIcon(CHECKED);
    else
        label.setIcon(UNCHECKED);
}

/**
 * Initializes this Clickable by setting a default model and adding a clickable event
 * handler for that model. Also adds a ChangeListener to update icon when  selection
 * status changes.
 *
 * @since 2.0
 */
protected void init() {
    super.init();
    addChangeListener(new class() ChangeListener {
        public void handleStateChanged(ChangeEvent changeEvent) {
            if (changeEvent.getPropertyName().equals(ButtonModel.SELECTED_PROPERTY))
                handleSelectionChanged();
        }
    });
}

}
