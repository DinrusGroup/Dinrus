/*******************************************************************************
 * Copyright (c) 2000, 2003 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *******************************************************************************/
module examples.addressbook.SearchDialog;


import dwt.DWT;
import dwt.events.ModifyEvent;
import dwt.events.ModifyListener;
import dwt.events.SelectionAdapter;
import dwt.events.SelectionEvent;
import dwt.events.ShellAdapter;
import dwt.events.ShellEvent;
import dwt.layout.FillLayout;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Button;
import dwt.widgets.Combo;
import dwt.widgets.Composite;
import dwt.widgets.Group;
import dwt.widgets.Label;
import dwt.widgets.MessageBox;
import dwt.widgets.Shell;
import dwt.widgets.Text;

import FindListener;

import dwt.dwthelper.ResourceBundle;

/**
 * SearchDialog is a simple class that uses <code>org.eclipse.swt</code>
 * libraries to implement a basic search dialog.
 */
public class SearchDialog {

    private static ResourceBundle resAddressBook;

    Shell shell;
    Text searchText;
    Combo searchArea;
    Label searchAreaLabel;
    Button matchCase;
    Button matchWord;
    Button findButton;
    Button down;
    FindListener findHandler;

/**
 * Class constructor that sets the parent shell and the table widget that
 * the dialog will search.
 *
 * @param parent    Shell
 *          The shell that is the parent of the dialog.
 */
public this(Shell parent, ResourceBundle bdl ) {
    if( resAddressBook is null ){
        resAddressBook = bdl;//ResourceBundle.getBundle("examples_addressbook");
    }
    shell = new Shell(parent, DWT.CLOSE | DWT.BORDER | DWT.TITLE);
    GridLayout layout = new GridLayout();
    layout.numColumns = 2;
    shell.setLayout(layout);
    shell.setText(resAddressBook.getString("Search_dialog_title"));
    shell.addShellListener(new class() ShellAdapter{
        public void shellClosed(ShellEvent e) {
            // don't dispose of the shell, just hide it for later use
            e.doit = false;
            shell.setVisible(false);
        }
    });

    Label label = new Label(shell, DWT.LEFT);
    label.setText(resAddressBook.getString("Dialog_find_what"));
    searchText = new Text(shell, DWT.BORDER);
    GridData gridData = new GridData(GridData.FILL_HORIZONTAL);
    gridData.widthHint = 200;
    searchText.setLayoutData(gridData);
    searchText.addModifyListener(new class() ModifyListener {
        public void modifyText(ModifyEvent e) {
            bool enableFind = (searchText.getCharCount() !is 0);
            findButton.setEnabled(enableFind);
        }
    });

    searchAreaLabel = new Label(shell, DWT.LEFT);
    searchArea = new Combo(shell, DWT.DROP_DOWN | DWT.READ_ONLY);
    gridData = new GridData(GridData.FILL_HORIZONTAL);
    gridData.widthHint = 200;
    searchArea.setLayoutData(gridData);

    matchCase = new Button(shell, DWT.CHECK);
    matchCase.setText(resAddressBook.getString("Dialog_match_case"));
    gridData = new GridData();
    gridData.horizontalSpan = 2;
    matchCase.setLayoutData(gridData);

    matchWord = new Button(shell, DWT.CHECK);
    matchWord.setText(resAddressBook.getString("Dialog_match_word"));
    gridData = new GridData();
    gridData.horizontalSpan = 2;
    matchWord.setLayoutData(gridData);

    Group direction = new Group(shell, DWT.NONE);
    gridData = new GridData();
    gridData.horizontalSpan = 2;
    direction.setLayoutData(gridData);
    direction.setLayout (new FillLayout ());
    direction.setText(resAddressBook.getString("Dialog_direction"));

    Button up = new Button(direction, DWT.RADIO);
    up.setText(resAddressBook.getString("Dialog_dir_up"));
    up.setSelection(false);

    down = new Button(direction, DWT.RADIO);
    down.setText(resAddressBook.getString("Dialog_dir_down"));
    down.setSelection(true);

    Composite composite = new Composite(shell, DWT.NONE);
    gridData = new GridData(GridData.HORIZONTAL_ALIGN_FILL);
    gridData.horizontalSpan = 2;
    composite.setLayoutData(gridData);
    layout = new GridLayout();
    layout.numColumns = 2;
    layout.makeColumnsEqualWidth = true;
    composite.setLayout(layout);

    findButton = new Button(composite, DWT.PUSH);
    findButton.setText(resAddressBook.getString("Dialog_find"));
    findButton.setLayoutData(new GridData(GridData.HORIZONTAL_ALIGN_END));
    findButton.setEnabled(false);
    findButton.addSelectionListener(new class() SelectionAdapter {
        public void widgetSelected(SelectionEvent e) {
            if (!findHandler.find()){
                MessageBox box = new MessageBox(shell, DWT.ICON_INFORMATION | DWT.OK | DWT.PRIMARY_MODAL);
                box.setText(shell.getText());
                box.setMessage(resAddressBook.getString("Cannot_find") ~ "\"" ~ searchText.getText() ~ "\"");
                box.open();
            }
        }
    });

    Button cancelButton = new Button(composite, DWT.PUSH);
    cancelButton.setText(resAddressBook.getString("Cancel"));
    cancelButton.setLayoutData(new GridData(GridData.HORIZONTAL_ALIGN_BEGINNING));
    cancelButton.addSelectionListener(new class() SelectionAdapter {
        public void widgetSelected(SelectionEvent e) {
            shell.setVisible(false);
        }
    });

    shell.pack();
}
public char[] getSearchAreaLabel(char[] label) {
    return searchAreaLabel.getText();
}

public char[][] getsearchAreaNames() {
    return searchArea.getItems();
}
public bool getMatchCase() {
    return matchCase.getSelection();
}
public bool getMatchWord() {
    return matchWord.getSelection();
}
public char[] getSearchString() {
    return searchText.getText();
}
public bool getSearchDown(){
    return down.getSelection();
}
public int getSelectedSearchArea() {
    return searchArea.getSelectionIndex();
}
public void open() {
    if (shell.isVisible()) {
        shell.setFocus();
    } else {
        shell.open();
    }
    searchText.setFocus();
}
public void setSearchAreaNames(char[][] names) {
    for (int i = 0; i < names.length; i++) {
        searchArea.add(names[i]);
    }
    searchArea.select(0);
}
public void setSearchAreaLabel(char[] label) {
    searchAreaLabel.setText(label);
}
public void setMatchCase(bool match) {
    matchCase.setSelection(match);
}
public void setMatchWord(bool match) {
    matchWord.setSelection(match);
}
public void setSearchDown(bool searchDown){
    down.setSelection(searchDown);
}
public void setSearchString(char[] searchString) {
    searchText.setText(searchString);
}

public void setSelectedSearchArea(int index) {
    searchArea.select(index);
}
public void addFindListener(FindListener listener) {
    this.findHandler = listener;
}
public void removeFindListener(FindListener listener) {
    this.findHandler = null;
}
}
