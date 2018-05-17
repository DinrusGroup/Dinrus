/*******************************************************************************
 * Copyright (c) 2000, 2006 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * D Port:
 *     Jesse Phillips <Jesse.K.Phillips+D> gmail.com
 *******************************************************************************/
module expandbar.Snippet223;
/* 
 * example snippet: ExpandBar example
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 * 
 * @since 3.2
 */

import dwt.DWT;
import dwt.dwthelper.ByteArrayInputStream;
import dwt.graphics.Image;
import dwt.graphics.ImageData;
import dwt.layout.FillLayout;
import dwt.layout.GridLayout;
import dwt.widgets.Button;
import dwt.widgets.Composite;
import dwt.widgets.Display;
import dwt.widgets.ExpandBar;
import dwt.widgets.ExpandItem;
import dwt.widgets.Label;
import dwt.widgets.Shell;
import dwt.widgets.Scale;
import dwt.widgets.Spinner;
import dwt.widgets.Slider;

void main () {
    auto display = new Display ();
    auto shell = new Shell (display);
    shell.setLayout(new FillLayout());
    shell.setText("ExpandBar Example");
    auto bar = new ExpandBar (shell, DWT.V_SCROLL);
    auto image = new Image(display, new ImageData(new ByteArrayInputStream( cast(byte[]) import("eclipse.png")))); 
    
    // First item
    Composite composite = new Composite (bar, DWT.NONE);
    GridLayout layout = new GridLayout ();
    layout.marginLeft = layout.marginTop = layout.marginRight = layout.marginBottom = 10;
    layout.verticalSpacing = 10;
    composite.setLayout(layout);
    Button button = new Button (composite, DWT.PUSH);
    button.setText("DWT.PUSH");
    button = new Button (composite, DWT.RADIO);
    button.setText("DWT.RADIO");
    button = new Button (composite, DWT.CHECK);
    button.setText("DWT.CHECK");
    button = new Button (composite, DWT.TOGGLE);
    button.setText("DWT.TOGGLE");
    ExpandItem item0 = new ExpandItem (bar, DWT.NONE, 0);
    item0.setText("What is your favorite button");
    item0.setHeight(composite.computeSize(DWT.DEFAULT, DWT.DEFAULT).y);
    item0.setControl(composite);
    item0.setImage(image);
    
    // Second item
    composite = new Composite (bar, DWT.NONE);
    layout = new GridLayout (2, false);
    layout.marginLeft = layout.marginTop = layout.marginRight = layout.marginBottom = 10;
    layout.verticalSpacing = 10;
    composite.setLayout(layout);    
    Label label = new Label (composite, DWT.NONE);
    label.setImage(display.getSystemImage(DWT.ICON_ERROR));
    label = new Label (composite, DWT.NONE);
    label.setText("DWT.ICON_ERROR");
    label = new Label (composite, DWT.NONE);
    label.setImage(display.getSystemImage(DWT.ICON_INFORMATION));
    label = new Label (composite, DWT.NONE);
    label.setText("DWT.ICON_INFORMATION");
    label = new Label (composite, DWT.NONE);
    label.setImage(display.getSystemImage(DWT.ICON_WARNING));
    label = new Label (composite, DWT.NONE);
    label.setText("DWT.ICON_WARNING");
    label = new Label (composite, DWT.NONE);
    label.setImage(display.getSystemImage(DWT.ICON_QUESTION));
    label = new Label (composite, DWT.NONE);
    label.setText("DWT.ICON_QUESTION");
    ExpandItem item1 = new ExpandItem (bar, DWT.NONE, 1);
    item1.setText("What is your favorite icon");
    item1.setHeight(composite.computeSize(DWT.DEFAULT, DWT.DEFAULT).y);
    item1.setControl(composite);
    item1.setImage(image);
    
    // Third item
    composite = new Composite (bar, DWT.NONE);
    layout = new GridLayout (2, true);
    layout.marginLeft = layout.marginTop = layout.marginRight = layout.marginBottom = 10;
    layout.verticalSpacing = 10;
    composite.setLayout(layout);
    label = new Label (composite, DWT.NONE);
    label.setText("Scale"); 
    new Scale (composite, DWT.NONE);
    label = new Label (composite, DWT.NONE);
    label.setText("Spinner");   
    new Spinner (composite, DWT.BORDER);
    label = new Label (composite, DWT.NONE);
    label.setText("Slider");    
    new Slider (composite, DWT.NONE);
    ExpandItem item2 = new ExpandItem (bar, DWT.NONE, 2);
    item2.setText("What is your favorite range widget");
    item2.setHeight(composite.computeSize(DWT.DEFAULT, DWT.DEFAULT).y);
    item2.setControl(composite);
    item2.setImage(image);
    
    item1.setExpanded(true);
    bar.setSpacing(8);
    shell.setSize(400, 350);
    shell.open();
    while (!shell.isDisposed ()) {
        if (!display.readAndDispatch ()) {
            display.sleep ();
        }
    }
    image.dispose();
    display.dispose();
}
