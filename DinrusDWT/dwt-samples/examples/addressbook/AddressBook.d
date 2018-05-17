/*******************************************************************************
 * Copyright (c) 2000, 2006 IBM Corporation and others.
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
module AddressBook;

import dwt.DWT;
import dwt.events.MenuAdapter;
import dwt.events.MenuEvent;
import dwt.events.SelectionAdapter;
import dwt.events.SelectionEvent;
import dwt.events.ShellAdapter;
import dwt.events.ShellEvent;
import dwt.graphics.Cursor;
import dwt.layout.FillLayout;
import dwt.widgets.Display;
import dwt.widgets.FileDialog;
import dwt.widgets.Menu;
import dwt.widgets.MenuItem;
import dwt.widgets.MessageBox;
import dwt.widgets.Shell;
import dwt.widgets.Table;
import dwt.widgets.TableColumn;
import dwt.widgets.TableItem;

import dwt.dwthelper.ResourceBundle;

import tango.core.Exception;
import tango.io.FilePath;
import tango.io.File;
import tango.io.FileConduit;
import tango.io.stream.FileStream;
import TextUtil = tango.text.Util;
import Unicode = tango.text.Unicode;

import SearchDialog;
import DataEntryDialog;
import FindListener;

version(JIVE){
    import jive.stacktrace;
}
void main() {
    Display display = new Display();
    auto application = new AddressBook();
    Shell shell = application.open(display);
    while(!shell.isDisposed()){
        if(!display.readAndDispatch()){
            display.sleep();
        }
    }
    display.dispose();
}

/**
 * AddressBookExample is an example that uses <code>org.eclipse.swt</code>
 * libraries to implement a simple address book.  This application has
 * save, load, sorting, and searching functions common
 * to basic address books.
 */
public class AddressBook {

    private static ResourceBundle resAddressBook;
    private static const char[] resAddressBookData = cast(char[]) import( "examples.addressbook.addressbook.properties" );
    private Shell shell;

    private Table table;
    private SearchDialog searchDialog;

    private FilePath file;
    private bool isModified;

    private char[][] copyBuffer;

    private int lastSortColumn= -1;

    private static const char[] DELIMITER = "\t";
    private static char[][] columnNames;

public this(){
    if( resAddressBook is null ){
        resAddressBook = ResourceBundle.getBundleFromData(resAddressBookData);
        columnNames = [
            resAddressBook.getString("Last_name"),
            resAddressBook.getString("First_name"),
            resAddressBook.getString("Business_phone"),
            resAddressBook.getString("Home_phone"),
            resAddressBook.getString("Email"),
            resAddressBook.getString("Fax") ];
    }
}


public Shell open(Display display) {
    shell = new Shell(display);
    shell.setLayout(new FillLayout());

    shell.addShellListener( new class() ShellAdapter {
        public void shellClosed(ShellEvent e) {
            e.doit = closeAddressBook();
        }
    });

    createMenuBar();

    searchDialog = new SearchDialog(shell, resAddressBook );
    searchDialog.setSearchAreaNames(columnNames);
    searchDialog.setSearchAreaLabel(resAddressBook.getString("Column"));
    searchDialog.addFindListener(new class() FindListener {
        public bool find() {
            return findEntry();
        }
    });

    table = new Table(shell, DWT.SINGLE | DWT.BORDER | DWT.FULL_SELECTION);
    table.setHeaderVisible(true);
    table.setMenu(createPopUpMenu());
    table.addSelectionListener(new class() SelectionAdapter {
        public void widgetDefaultSelected(SelectionEvent e) {
            TableItem[] items = table.getSelection();
            if (items.length > 0) editEntry(items[0]);
        }
    });
    for(int i = 0; i < columnNames.length; i++) {
        TableColumn column = new TableColumn(table, DWT.NONE);
        column.setText(columnNames[i]);
        column.setWidth(150);
        int columnIndex = i;
        column.addSelectionListener(new class(columnIndex) SelectionAdapter {
            int c;
            this( int c ){ this.c = c; }
            public void widgetSelected(SelectionEvent e) {
                sort(c);
            }
        });
    }

    newAddressBook();

    shell.setSize(table.computeSize(DWT.DEFAULT, DWT.DEFAULT).x, 300);
    shell.open();
    return shell;
}

private bool closeAddressBook() {
    if(isModified) {
        //ask user if they want to save current address book
        MessageBox box = new MessageBox(shell, DWT.ICON_WARNING | DWT.YES | DWT.NO | DWT.CANCEL);
        box.setText(shell.getText());
        box.setMessage(resAddressBook.getString("Close_save"));

        int choice = box.open();
        if(choice is DWT.CANCEL) {
            return false;
        } else if(choice is DWT.YES) {
            if (!save()) return false;
        }
    }

    TableItem[] items = table.getItems();
    for (int i = 0; i < items.length; i ++) {
        items[i].dispose();
    }

    return true;
}
/**
 * Creates the menu at the top of the shell where most
 * of the programs functionality is accessed.
 *
 * @return      The <code>Menu</code> widget that was created
 */
private Menu createMenuBar() {
    Menu menuBar = new Menu(shell, DWT.BAR);
    shell.setMenuBar(menuBar);

    //create each header and subMenu for the menuBar
    createFileMenu(menuBar);
    createEditMenu(menuBar);
    createSearchMenu(menuBar);
    createHelpMenu(menuBar);

    return menuBar;
}

/**
 * Converts an encoded <code>char[]</code> to a char[] array representing a table entry.
 */
private char[][] decodeLine(char[] line) {
    char[][] toks = TextUtil.split( line, DELIMITER );
    while( toks.length < table.getColumnCount() ){
        toks ~= "";
    }
    return toks[ 0 .. table.getColumnCount() ];
}
private void displayError(char[] msg) {
    MessageBox box = new MessageBox(shell, DWT.ICON_ERROR);
    box.setMessage(msg);
    box.open();
}
private void editEntry(TableItem item) {
    DataEntryDialog dialog = new DataEntryDialog(shell, resAddressBook );
    dialog.setLabels(columnNames);
    char[][] values = new char[][table.getColumnCount()];
    for (int i = 0; i < values.length; i++) {
        values[i] = item.getText(i);
    }
    dialog.setValues(values);
    values = dialog.open();
    if (values !is null) {
        item.setText(values);
        isModified = true;
    }
}
private char[] encodeLine(char[][] tableItems) {
    char[] line = "";
    for (int i = 0; i < tableItems.length - 1; i++) {
        line ~= tableItems[i] ~ DELIMITER;
    }
    line ~= tableItems[tableItems.length - 1] ~ "\n";

    return line;
}
private bool findEntry() {
    Cursor waitCursor = new Cursor(shell.getDisplay(), DWT.CURSOR_WAIT);
    shell.setCursor(waitCursor);

    bool matchCase = searchDialog.getMatchCase();
    bool matchWord = searchDialog.getMatchWord();
    char[] searchString = searchDialog.getSearchString();
    int column = searchDialog.getSelectedSearchArea();

    searchString = matchCase ? searchString : Unicode.toLower( searchString );

    bool found = false;
    if (searchDialog.getSearchDown()) {
        for(int i = table.getSelectionIndex() + 1; i < table.getItemCount(); i++) {
            found = findMatch(searchString, table.getItem(i), column, matchWord, matchCase);
            if ( found ){
                table.setSelection(i);
                break;
            }
        }
    } else {
        for(int i = table.getSelectionIndex() - 1; i > -1; i--) {
            found = findMatch(searchString, table.getItem(i), column, matchWord, matchCase);
            if ( found ){
                table.setSelection(i);
                break;
            }
        }
    }

    shell.setCursor(cast(Cursor)null);
    waitCursor.dispose();

    return found;
}
private bool findMatch(char[] searchString, TableItem item, int column, bool matchWord, bool matchCase) {

    char[] tableText = matchCase ? item.getText(column) : Unicode.toLower( item.getText(column));
    if (matchWord) {
        if (tableText !is null && tableText==searchString) {
            return true;
        }

    } else {
        if(tableText!is null && TextUtil.containsPattern( tableText, searchString)) {
            return true;
        }
    }
    return false;
}
private void newAddressBook() {
    shell.setText(resAddressBook.getString("Title_bar") ~ resAddressBook.getString("New_title"));
    *(cast(Object*)&file) = null;
    ///cast(Object)file = null;
    isModified = false;
}
private void newEntry() {
    DataEntryDialog dialog = new DataEntryDialog(shell, resAddressBook);
    dialog.setLabels(columnNames);
    char[][] data = dialog.open();
    if (data !is null) {
        TableItem item = new TableItem(table, DWT.NONE);
        item.setText(data);
        isModified = true;
    }
}

private void openAddressBook() {
    FileDialog fileDialog = new FileDialog(shell, DWT.OPEN);

    fileDialog.setFilterExtensions(["*.adr;", "*.*"]);
    fileDialog.setFilterNames([
        resAddressBook.getString("Book_filter_name") ~ " (*.adr)",
        resAddressBook.getString("All_filter_name") ~ " (*.*)"]);
    char[] name = fileDialog.open();

    if(name is null) return;
    FilePath file = new FilePath(name);
    if (!file.exists()) {
        displayError(resAddressBook.getString("File")~file.toString()~" "~resAddressBook.getString("Does_not_exist"));
        return;
    }

    Cursor waitCursor = new Cursor(shell.getDisplay(), DWT.CURSOR_WAIT);
    shell.setCursor(waitCursor);

    char[][] data;
    try {
        scope ioFile = new tango.io.File.File (file.toString);
        data = TextUtil.splitLines (cast(char[]) ioFile.read);
    } catch (IOException e ) {
        displayError(resAddressBook.getString("IO_error_read") ~ "\n" ~ file.toString());
        return;
    } finally {

        shell.setCursor(cast(Cursor)null);
        waitCursor.dispose();
    }

    char[][][] tableInfo = new char[][][](data.length,table.getColumnCount());
    foreach( idx, line; data ){
        char[][] linetoks = decodeLine(line);
        tableInfo[ idx ] = linetoks;
    }
    /+
    int writeIndex = 0;
    for (int i = 0; i < data.length; i++) {
        char[][] line = decodeLine(data[i]);
        if (line !is null) tableInfo[writeIndex++] = line;
    }
    if (writeIndex !is data.length) {
        char[][][] result = new char[][writeIndex][table.getColumnCount()];
        System.arraycopy(tableInfo, 0, result, 0, writeIndex);
        tableInfo = result;
    }
    +/
    tango.core.Array.sort( tableInfo, new RowComparator(0));

    for (int i = 0; i < tableInfo.length; i++) {
        TableItem item = new TableItem(table, DWT.NONE);
        item.setText(tableInfo[i]);
    }
    shell.setText(resAddressBook.getString("Title_bar")~fileDialog.getFileName());
    isModified = false;
    this.file = file;
}
private bool save() {
    if(file is null) return saveAs();

    Cursor waitCursor = new Cursor(shell.getDisplay(), DWT.CURSOR_WAIT);
    shell.setCursor(waitCursor);

    TableItem[] items = table.getItems();
    char[][] lines = new char[][items.length];
    for(int i = 0; i < items.length; i++) {
        char[][] itemText = new char[][table.getColumnCount()];
        for (int j = 0; j < itemText.length; j++) {
            itemText[j] = items[i].getText(j);
        }
        lines[i] = encodeLine(itemText);
    }

    FileOutput fileOutput;
    bool result = true;
    try {
        fileOutput = new FileOutput( file.toString );
        for (int i = 0; i < lines.length; i++) {
            fileOutput.write(lines[i]);
        }
    } catch(IOException e ) {
        displayError(resAddressBook.getString("IO_error_write") ~ "\n" ~ file.toString());
        result = false;
    } catch(Exception e2 ) {
        displayError(resAddressBook.getString("error_write") ~ "\n" ~ e2.toString());
        result = false;
    } finally {
        shell.setCursor(null);
        waitCursor.dispose();

    }

    if(fileOutput !is null) {
        try {
            fileOutput.close();
        } catch(IOException e) {
            displayError(resAddressBook.getString("IO_error_close") ~ "\n" ~ file.toString());
            return false;
        }
    }
    if( !result ){
        return false;
    }

    shell.setText(resAddressBook.getString("Title_bar")~file.toString());
    isModified = false;
    return true;
}
private bool saveAs() {

    FileDialog saveDialog = new FileDialog(shell, DWT.SAVE);
    saveDialog.setFilterExtensions(["*.adr;",  "*.*"]);
    saveDialog.setFilterNames(["Address Books (*.adr)", "All Files "]);

    saveDialog.open();
    char[] name = saveDialog.getFileName();
    if(!name) return false;

    if( TextUtil.locatePatternPrior( name, ".adr" ) !is name.length - 4) {
        name ~= ".adr";
    }

    FilePath file = new FilePath(saveDialog.getFilterPath() );
    file.append( name );
    if(file.exists()) {
        MessageBox box = new MessageBox(shell, DWT.ICON_WARNING | DWT.YES | DWT.NO);
        box.setText(resAddressBook.getString("Save_as_title"));
        box.setMessage(resAddressBook.getString("File") ~ file.toString()~" "~resAddressBook.getString("Query_overwrite"));
        if(box.open() !is DWT.YES) {
            return false;
        }
    }
    this.file = file;
    return save();
}
private void sort(int column) {
    if(table.getItemCount() <= 1) return;

    TableItem[] items = table.getItems();
    char[][][] data = new char[][][](items.length, table.getColumnCount());
    for(int i = 0; i < items.length; i++) {
        for(int j = 0; j < table.getColumnCount(); j++) {
            data[i][j] = items[i].getText(j);
        }
    }

    tango.core.Array.sort(data, new RowComparator(column));

    if (lastSortColumn !is column) {
        table.setSortColumn(table.getColumn(column));
        table.setSortDirection(DWT.DOWN);
        for (int i = 0; i < data.length; i++) {
            items[i].setText(data[i]);
        }
        lastSortColumn = column;
    } else {
        // reverse order if the current column is selected again
        table.setSortDirection(DWT.UP);
        int j = data.length -1;
        for (int i = 0; i < data.length; i++) {
            items[i].setText(data[j--]);
        }
        lastSortColumn = -1;
    }

}
/**
 * Creates all the items located in the File submenu and
 * associate all the menu items with their appropriate
 * functions.
 *
 * @param   menuBar Menu
 *              the <code>Menu</code> that file contain
 *              the File submenu.
 */
private void createFileMenu(Menu menuBar) {
    //File menu.
    MenuItem item = new MenuItem(menuBar, DWT.CASCADE);
    item.setText(resAddressBook.getString("File_menu_title"));
    Menu menu = new Menu(shell, DWT.DROP_DOWN);
    item.setMenu(menu);
    /**
     * Adds a listener to handle enabling and disabling
     * some items in the Edit submenu.
     */
    menu.addMenuListener(new class() MenuAdapter {
        public void menuShown(MenuEvent e) {
            Menu menu = cast(Menu)e.widget;
            MenuItem[] items = menu.getItems();
            items[1].setEnabled(table.getSelectionCount() !is 0); // edit contact
            items[5].setEnabled((file !is null) && isModified); // save
            items[6].setEnabled(table.getItemCount() !is 0); // save as
        }
    });


    //File -> New Contact
    MenuItem subItem = new MenuItem(menu, DWT.NONE);
    subItem.setText(resAddressBook.getString("New_contact"));
    subItem.setAccelerator(DWT.MOD1 + 'N');
    subItem.addSelectionListener(new class() SelectionAdapter {
        public void widgetSelected(SelectionEvent e) {
            newEntry();
        }
    });
    subItem = new MenuItem(menu, DWT.NONE);
    subItem.setText(resAddressBook.getString("Edit_contact"));
    subItem.setAccelerator(DWT.MOD1 + 'E');
    subItem.addSelectionListener(new class() SelectionAdapter {
        public void widgetSelected(SelectionEvent e) {
            TableItem[] items = table.getSelection();
            if (items.length is 0) return;
            editEntry(items[0]);
        }
    });


    new MenuItem(menu, DWT.SEPARATOR);

    //File -> New Address Book
    subItem = new MenuItem(menu, DWT.NONE);
    subItem.setText(resAddressBook.getString("New_address_book"));
    subItem.setAccelerator(DWT.MOD1 + 'B');
    subItem.addSelectionListener(new class() SelectionAdapter {
        public void widgetSelected(SelectionEvent e) {
            if (closeAddressBook()) {
                newAddressBook();
            }
        }
    });

    //File -> Open
    subItem = new MenuItem(menu, DWT.NONE);
    subItem.setText(resAddressBook.getString("Open_address_book"));
    subItem.setAccelerator(DWT.MOD1 + 'O');
    subItem.addSelectionListener(new class() SelectionAdapter {
        public void widgetSelected(SelectionEvent e) {
            if (closeAddressBook()) {
                openAddressBook();
            }
        }
    });

    //File -> Save.
    subItem = new MenuItem(menu, DWT.NONE);
    subItem.setText(resAddressBook.getString("Save_address_book"));
    subItem.setAccelerator(DWT.MOD1 + 'S');
    subItem.addSelectionListener(new class() SelectionAdapter {
        public void widgetSelected(SelectionEvent e) {
            save();
        }
    });

    //File -> Save As.
    subItem = new MenuItem(menu, DWT.NONE);
    subItem.setText(resAddressBook.getString("Save_book_as"));
    subItem.setAccelerator(DWT.MOD1 + 'A');
    subItem.addSelectionListener(new class() SelectionAdapter {
        public void widgetSelected(SelectionEvent e) {
            saveAs();
        }
    });


    new MenuItem(menu, DWT.SEPARATOR);

    //File -> Exit.
    subItem = new MenuItem(menu, DWT.NONE);
    subItem.setText(resAddressBook.getString("Exit"));
    subItem.addSelectionListener(new class() SelectionAdapter {
        public void widgetSelected(SelectionEvent e) {
            shell.close();
        }
    });
}

/**
 * Creates all the items located in the Edit submenu and
 * associate all the menu items with their appropriate
 * functions.
 *
 * @param   menuBar Menu
 *              the <code>Menu</code> that file contain
 *              the Edit submenu.
 *
 * @see #createSortMenu()
 */
private MenuItem createEditMenu(Menu menuBar) {
    //Edit menu.
    MenuItem item = new MenuItem(menuBar, DWT.CASCADE);
    item.setText(resAddressBook.getString("Edit_menu_title"));
    Menu menu = new Menu(shell, DWT.DROP_DOWN);
    item.setMenu(menu);

    /**
     * Add a listener to handle enabling and disabling
     * some items in the Edit submenu.
     */
    menu.addMenuListener(new class() MenuAdapter {
        public void menuShown(MenuEvent e) {
            Menu menu = cast(Menu)e.widget;
            MenuItem[] items = menu.getItems();
            int count = table.getSelectionCount();
            items[0].setEnabled(count !is 0); // edit
            items[1].setEnabled(count !is 0); // copy
            items[2].setEnabled(copyBuffer !is null); // paste
            items[3].setEnabled(count !is 0); // delete
            items[5].setEnabled(table.getItemCount() !is 0); // sort
        }
    });

    //Edit -> Edit
    MenuItem subItem = new MenuItem(menu, DWT.PUSH);
    subItem.setText(resAddressBook.getString("Edit"));
    subItem.setAccelerator(DWT.MOD1 + 'E');
    subItem.addSelectionListener(new class() SelectionAdapter {
        public void widgetSelected(SelectionEvent e) {
            TableItem[] items = table.getSelection();
            if (items.length is 0) return;
            editEntry(items[0]);
        }
    });

    //Edit -> Copy
    subItem = new MenuItem(menu, DWT.NONE);
    subItem.setText(resAddressBook.getString("Copy"));
    subItem.setAccelerator(DWT.MOD1 + 'C');
    subItem.addSelectionListener(new class() SelectionAdapter {
        public void widgetSelected(SelectionEvent e) {
            TableItem[] items = table.getSelection();
            if (items.length is 0) return;
            copyBuffer = new char[][table.getColumnCount()];
            for (int i = 0; i < copyBuffer.length; i++) {
                copyBuffer[i] = items[0].getText(i);
            }
        }
    });

    //Edit -> Paste
    subItem = new MenuItem(menu, DWT.NONE);
    subItem.setText(resAddressBook.getString("Paste"));
    subItem.setAccelerator(DWT.MOD1 + 'V');
    subItem.addSelectionListener(new class() SelectionAdapter {
        public void widgetSelected(SelectionEvent e) {
            if (copyBuffer is null) return;
            TableItem item = new TableItem(table, DWT.NONE);
            item.setText(copyBuffer);
            isModified = true;
        }
    });

    //Edit -> Delete
    subItem = new MenuItem(menu, DWT.NONE);
    subItem.setText(resAddressBook.getString("Delete"));
    subItem.addSelectionListener(new class() SelectionAdapter {
        public void widgetSelected(SelectionEvent e) {
            TableItem[] items = table.getSelection();
            if (items.length is 0) return;
            items[0].dispose();
            isModified = true;      }
    });

    new MenuItem(menu, DWT.SEPARATOR);

    //Edit -> Sort(Cascade)
    subItem = new MenuItem(menu, DWT.CASCADE);
    subItem.setText(resAddressBook.getString("Sort"));
    Menu submenu = createSortMenu();
    subItem.setMenu(submenu);

    return item;

}

/**
 * Creates all the items located in the Sort cascading submenu and
 * associate all the menu items with their appropriate
 * functions.
 *
 * @return  Menu
 *          The cascading menu with all the sort menu items on it.
 */
private Menu createSortMenu() {
    Menu submenu = new Menu(shell, DWT.DROP_DOWN);
    MenuItem subitem;
    for(int i = 0; i < columnNames.length; i++) {
        subitem = new MenuItem (submenu, DWT.NONE);
        subitem.setText(columnNames [i]);
        int column = i;
        subitem.addSelectionListener(new class(column) SelectionAdapter {
            int c;
            this(int c){ this.c = c; }
            public void widgetSelected(SelectionEvent e) {
                sort(c);
            }
        });
    }

    return submenu;
}

/**
 * Creates all the items located in the Search submenu and
 * associate all the menu items with their appropriate
 * functions.
 *
 * @param   menuBar Menu
 *              the <code>Menu</code> that file contain
 *              the Search submenu.
 */
private void createSearchMenu(Menu menuBar) {
    //Search menu.
    MenuItem item = new MenuItem(menuBar, DWT.CASCADE);
    item.setText(resAddressBook.getString("Search_menu_title"));
    Menu searchMenu = new Menu(shell, DWT.DROP_DOWN);
    item.setMenu(searchMenu);

    //Search -> Find...
    item = new MenuItem(searchMenu, DWT.NONE);
    item.setText(resAddressBook.getString("Find"));
    item.setAccelerator(DWT.MOD1 + 'F');
    item.addSelectionListener(new class() SelectionAdapter {
        public void widgetSelected(SelectionEvent e) {
            searchDialog.setMatchCase(false);
            searchDialog.setMatchWord(false);
            searchDialog.setSearchDown(true);
            searchDialog.setSearchString("");
            searchDialog.setSelectedSearchArea(0);
            searchDialog.open();
        }
    });

    //Search -> Find Next
    item = new MenuItem(searchMenu, DWT.NONE);
    item.setText(resAddressBook.getString("Find_next"));
    item.setAccelerator(DWT.F3);
    item.addSelectionListener(new class() SelectionAdapter {
        public void widgetSelected(SelectionEvent e) {
            searchDialog.open();
        }
    });
}

/**
 * Creates all items located in the popup menu and associates
 * all the menu items with their appropriate functions.
 *
 * @return  Menu
 *          The created popup menu.
 */
private Menu createPopUpMenu() {
    Menu popUpMenu = new Menu(shell, DWT.POP_UP);

    /**
     * Adds a listener to handle enabling and disabling
     * some items in the Edit submenu.
     */
    popUpMenu.addMenuListener(new class() MenuAdapter {
        public void menuShown(MenuEvent e) {
            Menu menu = cast(Menu)e.widget;
            MenuItem[] items = menu.getItems();
            int count = table.getSelectionCount();
            items[2].setEnabled(count !is 0); // edit
            items[3].setEnabled(count !is 0); // copy
            items[4].setEnabled(copyBuffer !is null); // paste
            items[5].setEnabled(count !is 0); // delete
            items[7].setEnabled(table.getItemCount() !is 0); // find
        }
    });

    //New
    MenuItem item = new MenuItem(popUpMenu, DWT.PUSH);
    item.setText(resAddressBook.getString("Pop_up_new"));
    item.addSelectionListener(new class() SelectionAdapter {
        public void widgetSelected(SelectionEvent e) {
            newEntry();
        }
    });

    new MenuItem(popUpMenu, DWT.SEPARATOR);

    //Edit
    item = new MenuItem(popUpMenu, DWT.PUSH);
    item.setText(resAddressBook.getString("Pop_up_edit"));
    item.addSelectionListener(new class() SelectionAdapter {
        public void widgetSelected(SelectionEvent e) {
            TableItem[] items = table.getSelection();
            if (items.length is 0) return;
            editEntry(items[0]);
        }
    });

    //Copy
    item = new MenuItem(popUpMenu, DWT.PUSH);
    item.setText(resAddressBook.getString("Pop_up_copy"));
    item.addSelectionListener(new class() SelectionAdapter {
        public void widgetSelected(SelectionEvent e) {
            TableItem[] items = table.getSelection();
            if (items.length is 0) return;
            copyBuffer = new char[][table.getColumnCount()];
            for (int i = 0; i < copyBuffer.length; i++) {
                copyBuffer[i] = items[0].getText(i);
            }
        }
    });

    //Paste
    item = new MenuItem(popUpMenu, DWT.PUSH);
    item.setText(resAddressBook.getString("Pop_up_paste"));
    item.addSelectionListener(new class() SelectionAdapter {
        public void widgetSelected(SelectionEvent e) {
            if (copyBuffer is null) return;
            TableItem item = new TableItem(table, DWT.NONE);
            item.setText(copyBuffer);
            isModified = true;
        }
    });

    //Delete
    item = new MenuItem(popUpMenu, DWT.PUSH);
    item.setText(resAddressBook.getString("Pop_up_delete"));
    item.addSelectionListener(new class() SelectionAdapter {
        public void widgetSelected(SelectionEvent e) {
            TableItem[] items = table.getSelection();
            if (items.length is 0) return;
            items[0].dispose();
            isModified = true;
        }
    });

    new MenuItem(popUpMenu, DWT.SEPARATOR);

    //Find...
    item = new MenuItem(popUpMenu, DWT.PUSH);
    item.setText(resAddressBook.getString("Pop_up_find"));
    item.addSelectionListener(new class() SelectionAdapter {
        public void widgetSelected(SelectionEvent e) {
            searchDialog.open();
        }
    });

    return popUpMenu;
}

/**
 * Creates all the items located in the Help submenu and
 * associate all the menu items with their appropriate
 * functions.
 *
 * @param   menuBar Menu
 *              the <code>Menu</code> that file contain
 *              the Help submenu.
 */
private void createHelpMenu(Menu menuBar) {

    //Help Menu
    MenuItem item = new MenuItem(menuBar, DWT.CASCADE);
    item.setText(resAddressBook.getString("Help_menu_title"));
    Menu menu = new Menu(shell, DWT.DROP_DOWN);
    item.setMenu(menu);

    //Help -> About Text Editor
    MenuItem subItem = new MenuItem(menu, DWT.NONE);
    subItem.setText(resAddressBook.getString("About"));
    subItem.addSelectionListener(new class() SelectionAdapter {
        public void widgetSelected(SelectionEvent e) {
            MessageBox box = new MessageBox(shell, DWT.NONE);
            box.setText(resAddressBook.getString("About_1") ~ shell.getText());
            box.setMessage(shell.getText() ~ resAddressBook.getString("About_2"));
            box.open();
        }
    });
}


/**
 * To compare entries (rows) by the given column
 */
private class RowComparator /*: Comparator*/ {
    private int column;

    /**
     * Constructs a RowComparator given the column index
     * @param col The index (starting at zero) of the column
     */
    public this(int col) {
        column = col;
    }

    /**
     * Compares two rows (type char[][]) using the specified
     * column entry.
     * @param obj1 First row to compare
     * @param obj2 Second row to compare
     * @return negative if obj1 less than obj2, positive if
     *          obj1 greater than obj2, and zero if equal.
     */
    public bool compare(char[][] row1, char[][] row2) {
        return row1[column] < row2[column];
    }

    alias compare opCall;
}

}
