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
 * 	 Jesse Phillips <Jesse.K.Phillips+D> gmail.com
 *******************************************************************************/
module ctabfolder.Snippet165;

/*
 * Create a CTabFolder with min and max buttons, as well as close button and 
 * image only on selected tab.
 *
 * For a list of all DWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 * 
 * @since 3.0
 */
import dwt.DWT;
import dwt.custom.CTabFolder;
import dwt.custom.CTabFolder2Adapter ;
import dwt.custom.CTabFolderEvent ;
import dwt.custom.CTabItem;
import dwt.graphics.GC;
import dwt.graphics.Image;
import dwt.layout.GridLayout;
import dwt.layout.GridData;
import dwt.widgets.Display;
import dwt.widgets.Shell;
import dwt.widgets.Text;

import tango.util.Convert;

void main () {
    auto display = new Display ();
    auto image = new Image(display, 16, 16);
    auto gc = new GC(image);
    gc.setBackground(display.getSystemColor(DWT.COLOR_BLUE));
    gc.fillRectangle(0, 0, 16, 16);
    gc.setBackground(display.getSystemColor(DWT.COLOR_YELLOW));
    gc.fillRectangle(3, 3, 10, 10);
    gc.dispose();
    auto shell = new Shell (display);
    shell.setLayout(new GridLayout());
    auto folder = new CTabFolder(shell, DWT.BORDER);
    folder.setLayoutData(new GridData(DWT.FILL, DWT.FILL, true, false));
    folder.setSimple(false);
    folder.setUnselectedImageVisible(false);
    folder.setUnselectedCloseVisible(false);
    for (int i = 0; i < 8; i++) {
        CTabItem item = new CTabItem(folder, DWT.CLOSE);
        item.setText("Item " ~ to!(char[])(i));
        item.setImage(image);
        Text text = new Text(folder, DWT.MULTI | DWT.V_SCROLL | DWT.H_SCROLL);
        text.setText("Text for item " ~ to!(char[])(i) ~
                     "\n\none, two, three\n\nabcdefghijklmnop");
        item.setControl(text);
    }
    folder.setMinimizeVisible(true);
    folder.setMaximizeVisible(true);
    folder.addCTabFolder2Listener(new class CTabFolder2Adapter {
        public void minimize(CTabFolderEvent event) {
            folder.setMinimized(true);
            shell.layout(true);
        }
        public void maximize(CTabFolderEvent event) {
            folder.setMaximized(true);
            folder.setLayoutData(new GridData(DWT.FILL, DWT.FILL, true, true));
            shell.layout(true);
        }
        public void restore(CTabFolderEvent event) {
            folder.setMinimized(false);
            folder.setMaximized(false);
            folder.setLayoutData(new GridData(DWT.FILL, DWT.FILL, true, false));
            shell.layout(true);
        }
    });
    shell.setSize(300, 300);
    shell.open ();
    while (!shell.isDisposed ()) {
        if (!display.readAndDispatch ()) display.sleep ();
    }
    image.dispose();
    display.dispose ();
}
