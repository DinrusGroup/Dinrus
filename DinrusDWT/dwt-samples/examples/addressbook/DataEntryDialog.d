/*******************************************************************************
 * Copyright (c) 2000, 2005 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *******************************************************************************/
module DataEntryDialog;

import dwt.DWT;
import dwt.events.ModifyEvent;
import dwt.events.ModifyListener;
import dwt.events.SelectionAdapter;
import dwt.events.SelectionEvent;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Button;
import dwt.widgets.Composite;
import dwt.widgets.Display;
import dwt.widgets.Label;
import dwt.widgets.Shell;
import dwt.widgets.Text;

import dwt.dwthelper.ResourceBundle;
import dwt.dwthelper.utils;

/**
 * DataEntryDialog class uses <code>org.eclipse.swt</code>
 * libraries to implement a dialog that accepts basic personal information that
 * is added to a <code>Table</code> widget or edits a <code>TableItem</code> entry
 * to represent the entered data.
 */
public class DataEntryDialog {

    private static ResourceBundle resAddressBook;

    Shell shell;
    char[][] values;
    char[][] labels;

public this(Shell parent, ResourceBundle bdl ) {
    if( resAddressBook is null ){
        resAddressBook = bdl;//ResourceBundle.getBundle("examples_addressbook");
    }
    shell = new Shell(parent, DWT.DIALOG_TRIM | DWT.PRIMARY_MODAL);
    shell.setLayout(new GridLayout());
}

private void addTextListener(Text text) {
    text.addModifyListener(new class(text) ModifyListener {
        Text text;
        this( Text text ){ this.text = text; }
        public void modifyText(ModifyEvent e){
            Integer index = cast(Integer)(this.text.getData("index"));
            values[index.intValue()] = this.text.getText();
        }
    });
}
private void createControlButtons() {
    Composite composite = new Composite(shell, DWT.NONE);
    composite.setLayoutData(new GridData(GridData.HORIZONTAL_ALIGN_CENTER));
    GridLayout layout = new GridLayout();
    layout.numColumns = 2;
    composite.setLayout(layout);

    Button okButton = new Button(composite, DWT.PUSH);
    okButton.setText(resAddressBook.getString("OK"));
    okButton.addSelectionListener(new class() SelectionAdapter {
        public void widgetSelected(SelectionEvent e) {
            shell.close();
        }
    });

    Button cancelButton = new Button(composite, DWT.PUSH);
    cancelButton.setText(resAddressBook.getString("Cancel"));
    cancelButton.addSelectionListener(new class() SelectionAdapter {
        public void widgetSelected(SelectionEvent e) {
            values = null;
            shell.close();
        }
    });

    shell.setDefaultButton(okButton);
}

private void createTextWidgets() {
    if (labels is null) return;

    Composite composite = new Composite(shell, DWT.NONE);
    composite.setLayoutData(new GridData(GridData.FILL_HORIZONTAL));
    GridLayout layout= new GridLayout();
    layout.numColumns = 2;
    composite.setLayout(layout);

    if (values is null)
        values = new char[][labels.length];

    for (int i = 0; i < labels.length; i++) {
        Label label = new Label(composite, DWT.RIGHT);
        label.setText(labels[i]);
        Text text = new Text(composite, DWT.BORDER);
        GridData gridData = new GridData();
        gridData.widthHint = 400;
        text.setLayoutData(gridData);
        if (values[i] !is null) {
            text.setText(values[i]);
        }
        text.setData("index", new Integer(i));
        addTextListener(text);
    }
}

public char[][] getLabels() {
    return labels;
}
public char[] getTitle() {
    return shell.getText();
}
/**
 * Returns the contents of the <code>Text</code> widgets in the dialog in a
 * <code>char[]</code> array.
 *
 * @return  char[][]
 *          The contents of the text widgets of the dialog.
 *          May return null if all text widgets are empty.
 */
public char[][] getValues() {
    return values;
}
/**
 * Opens the dialog in the given state.  Sets <code>Text</code> widget contents
 * and dialog behaviour accordingly.
 *
 * @param   dialogState int
 *                  The state the dialog should be opened in.
 */
public char[][] open() {
    createTextWidgets();
    createControlButtons();
    shell.pack();
    shell.open();
    Display display = shell.getDisplay();
    while(!shell.isDisposed()){
        if(!display.readAndDispatch())
            display.sleep();
    }

    return getValues();
}
public void setLabels(char[][] labels) {
    this.labels = labels;
}
public void setTitle(char[] title) {
    shell.setText(title);
}
/**
 * Sets the values of the <code>Text</code> widgets of the dialog to
 * the values supplied in the parameter array.
 *
 * @param   itemInfo    char[][]
 *                      The values to which the dialog contents will be set.
 */
public void setValues(char[][] itemInfo) {
    if (labels is null) return;

    if (values is null)
        values = new char[][labels.length];

    int numItems = Math.min(values.length, itemInfo.length);
    for(int i = 0; i < numItems; i++) {
        values[i] = itemInfo[i];
    }
}
}
