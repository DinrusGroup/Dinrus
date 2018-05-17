module jface.Librarian;

import dwtx.core.runtime.IProgressMonitor;
import dwtx.jface.action.MenuManager;
import dwtx.jface.action.StatusLineManager;
import dwtx.jface.action.ToolBarManager;
import dwtx.jface.action.CoolBarManager;
import dwtx.jface.action.Action;
import dwtx.jface.action.IAction;
import dwtx.jface.dialogs.MessageDialog;
import dwtx.jface.operation.IRunnableWithProgress;
import dwtx.jface.operation.ModalContext;
import dwtx.jface.util.IPropertyChangeListener;
import dwtx.jface.util.PropertyChangeEvent;
import dwtx.jface.viewers.TableViewer;
import dwtx.jface.viewers.Viewer;
import dwtx.jface.viewers.ITableLabelProvider;
import dwtx.jface.viewers.IStructuredContentProvider;
import dwtx.jface.viewers.ICellModifier;
import dwtx.jface.viewers.ILabelProviderListener;
import dwtx.jface.viewers.TextCellEditor;
import dwtx.jface.viewers.CellEditor;
import dwtx.jface.viewers.CheckboxCellEditor;
import dwtx.jface.action.Separator;
import dwtx.jface.viewers.IStructuredSelection;
import dwtx.jface.window.ApplicationWindow;
import dwtx.jface.resource.ImageDescriptor;

import dwt.DWT;

import dwt.graphics.Image;
import dwt.graphics.ImageData;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Display;
import dwt.widgets.FileDialog;
import dwt.widgets.MessageBox;
import dwt.widgets.Shell;
import dwt.widgets.Table;
import dwt.widgets.TableColumn;
import dwt.widgets.Control;
import dwt.widgets.Composite;
import dwt.widgets.Item;

import dwt.dwthelper.utils;
import dwt.dwthelper.ByteArrayInputStream;

import tango.text.convert.Format;
import tango.util.collection.LinkSeq;
import tango.io.FilePath;
import tango.io.File;
import tango.io.Print;
import tango.io.stream.FileStream;
import tango.text.Util;
import tango.text.stream.LineIterator;
import tango.util.log.Trace;

version(JIVE) import jive.stacktrace;

/**
 * The application entry point
 *
 * @param args the command line arguments
 */
void main() {
    (new Librarian()).run();
}


/**
 * This class keeps track of you library, and who you've loaned books to
 */
public class Librarian : ApplicationWindow {
    // A static instance to the running application
    private static Librarian APP;

    // Table column names/properties
    public static const String TITLE = "Title";
    public static const String CHECKED_OUT = "?";
    public static const String WHO = "By Whom";
    public static const String[] PROPS = [ TITLE, CHECKED_OUT, WHO ];

    // The viewer
    private TableViewer viewer;

    // The current library
    private Library library;

    // The actions
    private NewAction newAction;
    private OpenAction openAction;
    private SaveAction saveAction;
    private SaveAsAction saveAsAction;
    private ExitAction exitAction;
    private AddBookAction addBookAction;
    private RemoveBookAction removeBookAction;
    private AboutAction aboutAction;
    private ShowBookCountAction showBookCountAction;

    /**
    * Gets the running application
    */
    public static Librarian getApp() {
        return APP;
    }

    /**
    * Librarian constructor
    */
    public this() {
        super(null);

        APP = this;

        // Create the data model
        library = new Library();

        // Create the actions
        newAction = new NewAction();
        openAction = new OpenAction();
        saveAction = new SaveAction();
        saveAsAction = new SaveAsAction();
        exitAction = new ExitAction();
        addBookAction = new AddBookAction();
        removeBookAction = new RemoveBookAction();
        aboutAction = new AboutAction();
        showBookCountAction = new ShowBookCountAction();

        addMenuBar();
        //addCoolBar(DWT.NONE);
        addToolBar(DWT.FLAT);
        addStatusLine();
    }

    /**
    * Runs the application
    */
    public void run() {
        // Don't return from open() until window closes
        setBlockOnOpen(true);

        // Open the main window
        open();

        // Dispose the display
        Display.getCurrent().dispose();
    }

    /**
    * Configures the shell
    *
    * @param shell the shell
    */
    protected void configureShell(Shell shell) {
        super.configureShell(shell);

        // Set the title bar text
        shell.setText("Librarian");
    }

    /**
    * Creates the main window's contents
    *
    * @param parent the main window
    * @return Control
    */
    protected Control createContents(Composite parent) {
        Composite composite = new Composite(parent, DWT.NONE);
        composite.setLayout(new GridLayout(1, false));

        viewer = new TableViewer(composite, DWT.FULL_SELECTION | DWT.BORDER);
        Table table = viewer.getTable();
        table.setLayoutData(new GridData(GridData.FILL_BOTH));

        // Set up the viewer
        viewer.setContentProvider(new LibraryContentProvider());
        viewer.setLabelProvider(new LibraryLabelProvider());
        viewer.setInput(library);
        viewer.setColumnProperties(PROPS);
        viewer.setCellEditors( [ cast(CellEditor) new TextCellEditor(table),
            new CheckboxCellEditor(table), new TextCellEditor(table)]);
        viewer.setCellModifier(new LibraryCellModifier());

        // Set up the table
        for (int i = 0, n = PROPS.length; i < n; i++)
        (new TableColumn(table, DWT.LEFT)).setText(PROPS[i]);
        table.setHeaderVisible(true);
        table.setLinesVisible(true);

        // Add code to hide or display the book count based on the action
        showBookCountAction.addPropertyChangeListener(new class IPropertyChangeListener {
            public void propertyChange(PropertyChangeEvent event) {
                // The value has changed; refresh the view
                refreshView();
            }
        });

        // Rfresh the view to get the columns right-sized
        refreshView();

        return composite;
    }

    /**
    * Creates the menu for the application
    *
    * @return MenuManager
    */
    protected MenuManager createMenuManager() {
        // Create the main menu
        MenuManager mm = new MenuManager();

        // Create the File menu
        MenuManager fileMenu = new MenuManager("File");
        mm.add(fileMenu);

        // Add the actions to the File menu
        fileMenu.add(newAction);
        fileMenu.add(openAction);
        fileMenu.add(saveAction);
        fileMenu.add(saveAsAction);
        fileMenu.add(new Separator());
        fileMenu.add(exitAction);

        // Create the Book menu
        MenuManager bookMenu = new MenuManager("Book");
        mm.add(bookMenu);

        // Add the actions to the Book menu
        bookMenu.add(addBookAction);
        bookMenu.add(removeBookAction);

        // Create the View menu
        MenuManager viewMenu = new MenuManager("View");
        mm.add(viewMenu);

        // Add the actions to the View menu
        viewMenu.add(showBookCountAction);

        // Create the Help menu
        MenuManager helpMenu = new MenuManager("Help");
        mm.add(helpMenu);

        // Add the actions to the Help menu
        helpMenu.add(aboutAction);

        return mm;
    }

    /**
    * Creates the toolbar for the application
    */
    protected ToolBarManager createToolBarManager(int style) {
        // Create the toolbar manager
        ToolBarManager tbm = new ToolBarManager(style);

        // Add the file actions
        tbm.add(newAction);
        tbm.add(openAction);
        tbm.add(saveAction);
        tbm.add(saveAsAction);

        // Add a separator
        tbm.add(new Separator());

        // Add the book actions
        tbm.add(addBookAction);
        tbm.add(removeBookAction);

        // Add a separator
        tbm.add(new Separator());

        // Add the show book count, which will appear as a toggle button
        tbm.add(showBookCountAction);

        // Add a separator
        tbm.add(new Separator());

        // Add the about action
        tbm.add(aboutAction);

        return tbm;
    }
/+
    /**
     * Creates the coolbar for the application
     */
    protected CoolBarManager createCoolBarManager(int style) {
        // Create the coolbar manager
        CoolBarManager cbm = new CoolBarManager(style);

        // Add the toolbar
        cbm.add(createToolBarManager(DWT.FLAT));

        return cbm;
    }
+/
    /**
     * Creates the status line manager
     */
    protected StatusLineManager createStatusLineManager() {
        return new StatusLineManager();
    }

    /**
     * Adds a book
     */
    public void addBook() {
        library.add(new Book("[Enter Title]"));
        refreshView();
    }

    /**
    * Removes the selected book
    */
    public void removeSelectedBook() {
        Book book = cast(Book) (cast(IStructuredSelection) viewer.getSelection())
            .getFirstElement();
        if (book !is null) library.remove(book);
        refreshView();
    }

    /**
    * Opens a file
    *
    * @param fileName the file name
    */
    public void openFile(String fileName) {
        if (checkOverwrite()) {
            // Disable the actions, so user can't change library while loading
            enableActions(false);

            library = new Library();
            try {
                // Launch the Open runnable
                ModalContext.run( dgIRunnableWithProgress( &internalOpen, fileName ),
                    true, getStatusLineManager().getProgressMonitor(), getShell().getDisplay());
            } catch (InterruptedException e) {
            } catch (InvocationTargetException e) {
            } finally {
                // Enable actions
                enableActions(true);
            }
        }
    }
    private void internalOpen( IProgressMonitor progressMonitor,String filename ){
        try {
            progressMonitor.beginTask("Loading", IProgressMonitor.UNKNOWN);
            library.load(filename);
            progressMonitor.done();
            viewer.setInput(library);
            refreshView();
        } catch (IOException e) {
            showError( Format("Can't load file {}\r{}", filename, e.msg));
        }
    }
    /**
     * Creates a new file
     */
    public void newFile() {
        if (checkOverwrite()) {
        library = new Library();
            viewer.setInput(library);
        }
    }

    /**
     * Saves the current file
     */
    public void saveFile() {
        String fileName = library.getFileName();
        if (fileName is null) {
            fileName = (new SafeSaveDialog(getShell())).open();
        }
        if (fileName is null) {
            return;
        }
        saveFileAs(fileName);
    }

    /**
     * Saves the current file using the specified file name
     *
     * @param fileName the file name
     */
    public void saveFileAs(String fileName) {
        // Disable the actions, so user can't change file while it's saving
        enableActions(false);
        try {
            auto pm = getStatusLineManager().getProgressMonitor();
            auto disp = getShell().getDisplay();
            // Launch the Save runnable
            ModalContext.run( dgIRunnableWithProgress( &internalSave, fileName ), true, pm, disp);

        } catch (InterruptedException e) {
        } catch (InvocationTargetException e) {
        } finally {
            // Enable the actions
            enableActions(true);
        }
    }

    private void internalSave(IProgressMonitor progressMonitor,String filename ){
        try {
            progressMonitor.beginTask("Saving", IProgressMonitor.UNKNOWN );
            library.save(filename);
            progressMonitor.done();
        } catch (IOException e) {
            showError(Format("Can't save file {}\r{}", library.getFileName(), e.msg ));
        }
    }
    /**
     * Shows an error
     *
     * @param msg the error
     */
    public void showError(String msg) {
        MessageDialog.openError(getShell(), "Error", msg);
    }

    /**
    * Refreshes the view
    */
    public void refreshView() {
        // Refresh the view
        viewer.refresh();

        // Repack the columns
        for (int i = 0, n = viewer.getTable().getColumnCount(); i < n; i++) {
            viewer.getTable().getColumn(i).pack();
        }

        getStatusLineManager().setMessage(
            showBookCountAction.isChecked() ? Format( "Book Count: {}",
                library.getBooks().size()) : "");
    }

    /**
    * Checks the current file for unsaved changes. If it has unsaved changes,
    * confirms that user wants to overwrite
    *
    * @return bool
    */
    public bool checkOverwrite() {
        bool proceed = true;
        if (library.isDirty()) {
        proceed = MessageDialog.openConfirm(getShell(), "Are you sure?",
            "You have unsaved changes--are you sure you want to lose them?");
        }
        return proceed;
    }

    /**
    * Sets the current library dirty
    */
    public void setLibraryDirty() {
        library.setDirty();
    }

    /**
    * Closes the application
    */
    public bool close() {
        if (checkOverwrite()) return super.close();
        return false;
    }

    /**
    * Enables or disables the actions
    *
    * @param enable true to enable, false to disable
    */
    private void enableActions(bool enable) {
        newAction.setEnabled(enable);
        openAction.setEnabled(enable);
        saveAction.setEnabled(enable);
        saveAsAction.setEnabled(enable);
        exitAction.setEnabled(enable);
        addBookAction.setEnabled(enable);
        removeBookAction.setEnabled(enable);
        aboutAction.setEnabled(enable);
        showBookCountAction.setEnabled(enable);
    }
}


/**
 * This action class responds to requests to save a file
 */
public class SaveAction : Action {
    /**
    * SaveAction constructor
    */
    public this() {
        super("&Save@Ctrl+S", ImageDescriptor.createFromFile( getImportData!("jface.librarian.save.gif")));
        setDisabledImageDescriptor(ImageDescriptor.createFromFile(getImportData!("jface.librarian.disabledSave.gif")));
        setToolTipText("Save");
    }

    /**
    * Saves the file
    */
    public void run() {
        Librarian.getApp().saveFile();
    }
}




/**
 * This action class responds to requests open a file
 */
public class OpenAction : Action {
    /**
    * OpenAction constructor
    */
    public this() {
        super("&Open...@Ctrl+O", ImageDescriptor.createFromFile(getImportData!("jface.librarian.open.gif")));
        setDisabledImageDescriptor(ImageDescriptor.createFromFile(getImportData!("jface.librarian.disabledOpen.gif")));
        setToolTipText("Open");
    }

    /**
    * Opens an existing file
    */
    public void run() {
        // Use the file dialog
        FileDialog dlg = new FileDialog(Librarian.getApp().getShell(), DWT.OPEN);
        String fileName = dlg.open();
        if (fileName !is null) {
            Librarian.getApp().openFile(fileName);
        }
    }
}

/**
 * This action class reponds to requests for a new file
 */
public class NewAction : Action {
    /**
    * NewAction constructor
    */
    public this() {
        super("&New@Ctrl+N", ImageDescriptor.createFromFile(getImportData!("jface.librarian.new.gif")));
        setDisabledImageDescriptor(ImageDescriptor.createFromFile(getImportData!("jface.librarian.disabledNew.gif")));
        setToolTipText("New");
    }

    /**
    * Creates a new file
    */
    public void run() {
        Librarian.getApp().newFile();
    }
}

/**
 * This action class responds to requests to save a file as . . .
 */
public class SaveAsAction : Action {
    /**
    * SaveAsAction constructor
    */
    public this() {
        super("Save As...", ImageDescriptor.createFromFile(getImportData!("jface.librarian.saveAs.gif")));
        setDisabledImageDescriptor(ImageDescriptor.createFromFile(getImportData!("jface.librarian.disabledSaveAs.gif")));
        setToolTipText("Save As");
    }

    /**
    * Saves the file
    */
    public void run() {
        SafeSaveDialog dlg = new SafeSaveDialog(Librarian.getApp().getShell());
        String fileName = dlg.open();
        if (fileName !is null) {
            Librarian.getApp().saveFileAs(fileName);
        }
    }
}


/**
 * This action class deletes a book
 */
public class RemoveBookAction : Action {
    /**
    * RemoveBookAction constructor
    */
    public this() {
        super("&Remove Book@Ctrl+X", ImageDescriptor.createFromFile(getImportData!("jface.librarian.removeBook.gif")));
        setDisabledImageDescriptor(ImageDescriptor.createFromFile(getImportData!("jface.librarian.disabledRemoveBook.gif")));
        setToolTipText("Remove");
    }

    /**
    * Removes the selected book after confirming
    */
    public void run() {
        if (MessageDialog.openConfirm(Librarian.getApp().getShell(), "Are you sure?",
            "Are you sure you want to remove the selected book?")) {
        Librarian.getApp().removeSelectedBook();
        }
    }
}


/**
 * This action class adds a book
 */
public class AddBookAction : Action {
    /**
    * AddBookAction constructor
    */
    public this() {
        super("&Add Book@Ctrl+B", ImageDescriptor.createFromFile(getImportData!("jface.librarian.addBook.gif")));
        setDisabledImageDescriptor(ImageDescriptor.createFromFile(getImportData!("jface.librarian.disabledAddBook.gif")));
        setToolTipText("Add");
    }

    /**
    * Adds a book to the current library
    */
    public void run() {
        Librarian.getApp().addBook();
    }
}

/**
 * This action class exits the application
 */
public class ExitAction : Action {
    /**
    * ExitAction constructor
    */
    public this() {
        super("E&xit@Alt+F4");
        setToolTipText("Exit");
    }

    /**
    * Exits the application
    */
    public void run() {
        Librarian.getApp().close();
    }
}

/**
 * This action class shows an About box
 */
public class AboutAction : Action {
    /**
    * AboutAction constructor
    */
    public this() {
        super("&About@Ctrl+A", ImageDescriptor.createFromFile(getImportData!("jface.librarian.about.gif")));
        setDisabledImageDescriptor(ImageDescriptor.createFromFile(getImportData!("jface.librarian.disabledAbout.gif")));
        setToolTipText("About");
    }

    /**
    * Shows an about box
    */
    public void run() {
        MessageDialog.openInformation(Librarian.getApp().getShell(), "About",
            "Librarian--to manage your books");
    }
}



/**
 * This action class determines whether to show the book count
 */
public class ShowBookCountAction : Action {
    public this() {
        super("&Show Book Count@Ctrl+C", IAction.AS_CHECK_BOX);
        setChecked(true);
        setImageDescriptor(ImageDescriptor.createFromFile(getImportData!("jface.librarian.count.gif")));
        setDisabledImageDescriptor(ImageDescriptor.createFromFile(getImportData!("jface.librarian.disabledCount.gif")));
    }
}

/**
 * This class represents a book
 */
public class Book {
    private String title;
    private String checkedOutTo;

    /**
    * Book constructor
    * @param title the title
    */
    public this(String title) {
        setTitle(title);
    }

    /**
    * Sets the title
    * @param title the title
    */
    public void setTitle(String title) {
        this.title = title;
    }

    /**
    * Gets the title
    * @return String
    */
    public String getTitle() {
        return title;
    }

    /**
    * Check out
    * @param who the person checking this book out
    */
    public void checkOut(String who) {
        checkedOutTo = who;
        if (checkedOutTo.length is 0) checkedOutTo = null;
    }

    public bool isCheckedOut() {
        return checkedOutTo !is null && checkedOutTo.length > 0;
    }

    public void checkIn() {
        checkedOutTo = null;
    }

    /**
    * Gets who this book is checked out to
    * @return String
    */
    public String getCheckedOutTo() {
        return checkedOutTo;
    }
}


/**
 * This class provides a facade for the "save"
 * FileDialog class. If the selected file already
 * exists, the user is asked to confirm before
 * overwriting.
 */
public class SafeSaveDialog
{
  // The wrapped FileDialog
  private FileDialog dlg;

    /**
    * SafeSaveDialog constructor
    * @param shell the parent shell
    */
    public this(Shell shell)
    {
        dlg = new FileDialog(shell, DWT.SAVE);
    }

    public String open()
    {
        // We store the selected file name in fileName
        String fileName = null;

        // The user has finished when one of the
        // following happens:
        // 1) The user dismisses the dialog by pressing Cancel
        // 2) The selected file name does not exist
        // 3) The user agrees to overwrite existing file
        bool done = false;

        while (!done)
        {
        // Open the File Dialog
        fileName = dlg.open();
        if (fileName is null)
        {
            // User has cancelled, so quit and return
            done = true;
        }
        else
        {
            // User has selected a file; see if it already exists
            FilePath file = new FilePath(fileName);
            if (file.exists())
            {
                // The file already exists; asks for confirmation
                MessageBox mb = new MessageBox(dlg.getParent(),
                    DWT.ICON_WARNING | DWT.YES | DWT.NO);

                // We really should read this string from a
                // resource bundle
                mb.setMessage(fileName ~ " already exists. Do you want to replace it?");

                // If they click Yes, we're done and we drop out. If
                // they click No, we redisplay the File Dialog
                done = mb.open() is DWT.YES;
            }
            else
            {
                // File does not exist, so drop out
                done = true;
            }
        }
        }
        return fileName;
    }

    public String getFileName()
    {
        return dlg.getFileName();
    }

    public String[] getFileNames()
    {
        return dlg.getFileNames();
    }

    public String[] getFilterExtensions()
    {
        return dlg.getFilterExtensions();
    }

    public String[] getFilterNames()
    {
        return dlg.getFilterNames();
    }

    public String getFilterPath()
    {
        return dlg.getFilterPath();
    }

    public void setFileName(String string)
    {
        dlg.setFileName(string);
    }

    public void setFilterExtensions(String[] extensions)
    {
        dlg.setFilterExtensions(extensions);
    }

    public void setFilterNames(String[] names)
    {
        dlg.setFilterNames(names);
    }

    public void setFilterPath(String string)
    {
        dlg.setFilterPath(string);
    }

    public Shell getParent()
    {
        return dlg.getParent();
    }

    public int getStyle()
    {
        return dlg.getStyle();
    }

    public String getText()
    {
        return dlg.getText();
    }

    public void setText(String string)
    {
        dlg.setText(string);
    }
}


/**
 * This class is the cell modifier for the Librarian program
 */
public class LibraryCellModifier : ICellModifier {
    /**
    * Gets whether the specified property can be modified
    *
    * @param element the book
    * @param property the property
    * @return bool
    */
    public bool canModify(Object element, String property) {
        return true;
    }

    /**
    * Gets the value for the property
    *
    * @param element the book
    * @param property the property
    * @return Object
    */
    public Object getValue(Object element, String property) {
        Book book = cast(Book) element;
        if (Librarian.TITLE.equals(property))
            return stringcast(book.getTitle());
        else if (Librarian.CHECKED_OUT.equals(property))
            return Boolean.valueOf(book.isCheckedOut());
        else if (Librarian.WHO.equals(property))
            return stringcast( book.getCheckedOutTo() is null ? "" : book.getCheckedOutTo());
        else
            return null;
    }

    /**
    * Modifies the element
    *
    * @param element the book
    * @param property the property
    * @param value the new value
    */
    public void modify(Object element, String property, Object value) {
        if ( auto item = cast(Item)element ){
            element = item.getData();
        }

        Book book = cast(Book) element;
        if (Librarian.TITLE.equals(property))
        book.setTitle(stringcast(value));
        else if (Librarian.CHECKED_OUT.equals(property)) {
            bool b = (cast(Boolean) value).booleanValue();
            if (b)
                book.checkOut("[Enter Name]");
            else
                book.checkIn();
        } else if (Librarian.WHO.equals(property))
            book.checkOut(stringcast(value));

        // Refresh the view
        Librarian.getApp().refreshView();

        // Set the library dirty
        Librarian.getApp().setLibraryDirty();
    }
}

/**
 * This class holds all the books in a library. It also handles loading from and
 * saving to disk
 */
public class Library {
    private static const String SEP = "|";

    // The filename
    private String filename;

    // The books
    private LinkSeq!(Book) books;

    // The dirty flag
    private bool dirty;

    /**
    * Library constructor Note the signature :-)
    */
    public this() {
        books = new LinkSeq!(Book);
    }

    /**
     * Loads the library from a file
     *
     * @param filename the filename
     * @throws IOException
     */
    public void load(String filename) {
        auto istr = (new FileInput(filename)).input;
        auto lines = new LineIterator!(char)(istr);
        String line;
        foreach (line; lines ) {
            auto tokens = tango.text.Util.delimit(line, SEP);
            Book book = null;
            if ( tokens.length > 0 ) book = new Book( tokens[0].dup );
            if (tokens.length > 1) book.checkOut(tokens[1].dup );
            if (book !is null) add(book);
        }
        istr.close();
        this.filename = filename;
        dirty = false;
    }

    /**
     * Saves the library to a file
     *
     * @param filename the filename
     * @throws IOException
     */
    public void save(String filename) {
        scope ostr = (new FileOutput(filename)).output;
        scope printer = new Print!(char)( Format, ostr );
        foreach ( book; books ) {
            printer.formatln( "{}|{}",book.getTitle(), (book.getCheckedOutTo() is null ? "" : book.getCheckedOutTo()));
        }
        ostr.close();
        this.filename = filename;
        dirty = false;
    }

    /**
    * Adds a book
    *
    * @param book the book to add
    * @return bool
    */
    public bool add(Book book) {
        books.append(book);
        setDirty();
        return true;
    }

    /**
    * Removes a book
    *
    * @param book the book to remove
    */
    public void remove(Book book) {
        books.remove(book);
        setDirty();
    }

    /**
    * Gets the books
    *
    * @return Collection
    */
    public LinkSeq!(Book) getBooks() {
        return books;
    }

    /**
    * Gets the file name
    *
    * @return String
    */
    public String getFileName() {
        return filename;
    }

    /**
    * Gets whether this file is dirty
    *
    * @return bool
    */
    public bool isDirty() {
        return dirty;
    }

    /**
    * Sets this file as dirty
    */
    public void setDirty() {
        dirty = true;
    }
}


/**
 * This class provides the content for the library table
 */
public class LibraryContentProvider : IStructuredContentProvider {
    /**
     * Gets the books
     *
     * @param inputElement the library
     * @return Object[]
     */
    public Object[] getElements(Object inputElement) {
        return (cast(Library) inputElement).getBooks().toArray();
    }

    /**
     * Disposes any resources
     */
    public void dispose() {
        // Do nothing
    }

    /**
     * Called when the input changes
     *
     * @param viewer the viewer
     * @param oldInput the old library
     * @param newInput the new library
     */
    public void inputChanged(Viewer viewer, Object oldInput, Object newInput) {
        // Ignore
    }
}


/**
 * This class provides the labels for the library table
 */
public class LibraryLabelProvider : ITableLabelProvider {
    private Image checked;
    private Image unchecked;

    /**
     * LibraryLabelProvider constructor
     */
    public this() {
        // Create the check mark images
        checked = new Image(null, new ImageData( new ByteArrayInputStream( cast(byte[])import("jface.librarian.checked.gif"))));
        unchecked = new Image(null,new ImageData( new ByteArrayInputStream( cast(byte[])import("jface.librarian.unchecked.gif"))));
    }

    /**
     * Gets the column image
     *
     * @param element the book
     * @param columnIndex the column index
     * @return Image
     */
    public Image getColumnImage(Object element, int columnIndex) {
        // For the "Checked Out" column, return the check mark
        // if the book is checked out
        if (columnIndex is 1)
            return (cast(Book) element).isCheckedOut() ? checked : unchecked;
        return null;
    }

    /**
     * Gets the column text
     *
     * @param element the book
     * @param columnIndex the column index
     * @return String
     */
    public String getColumnText(Object element, int columnIndex) {
        Book book = cast(Book) element;
        String text = null;
        switch (columnIndex) {
            case 0:
                text = book.getTitle();
                break;
            case 2:
                text = book.getCheckedOutTo();
                break;
            default:
        }
        return text is null ? "" : text;
    }

    /**
     * Adds a listener
     */
    public void addListener(ILabelProviderListener listener) {
    // Ignore
    }

    /**
     * Disposes any resources
     */
    public void dispose() {
        if (checked !is null) checked.dispose();
        if (unchecked !is null) unchecked.dispose();
    }

    /**
     * Gets whether this is a label property
     *
     * @param element the book
     * @param property the property
     * @return bool
     */
    public bool isLabelProperty(Object element, String property) {
        return false;
    }

    /**
     * Removes a listener
     *
     * @param listener the listener
     */
    public void removeListener(ILabelProviderListener listener) {
        // Ignore
    }
}






