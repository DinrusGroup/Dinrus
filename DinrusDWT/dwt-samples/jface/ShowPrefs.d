module jface.ShowPrefs;

import dwtx.jface.preference.BooleanFieldEditor;
import dwtx.jface.preference.ColorFieldEditor;
import dwtx.jface.preference.DirectoryFieldEditor;
import dwtx.jface.preference.FileFieldEditor;
import dwtx.jface.preference.FontFieldEditor;
import dwtx.jface.preference.FieldEditorPreferencePage;
import dwtx.jface.preference.RadioGroupFieldEditor;
import dwtx.jface.preference.PathEditor;
import dwtx.jface.preference.IntegerFieldEditor;
import dwtx.jface.preference.ScaleFieldEditor;
import dwtx.jface.preference.StringFieldEditor;
import dwtx.jface.preference.IPreferenceStore;
import dwtx.jface.preference.PreferenceManager;
import dwtx.jface.preference.PreferencePage;
import dwtx.jface.preference.PreferenceNode;
import dwtx.jface.preference.PreferenceStore;
import dwtx.jface.preference.PreferenceDialog;
import dwtx.jface.resource.ImageDescriptor;

import dwt.widgets.Display;
import dwt.widgets.Composite;
import dwt.widgets.Label;
import dwt.widgets.Button;
import dwt.widgets.Text;
import dwt.widgets.Control;
import dwt.events.SelectionAdapter;
import dwt.events.SelectionEvent;
import dwt.layout.RowLayout;
import dwt.layout.GridLayout;
import dwt.layout.GridData;
import dwt.DWT;
import dwt.dwthelper.utils;

import tango.io.File;
import Path = tango.io.Path;

version(JIVE) import jive.stacktrace;

const char[] FILENAME = "showprefs";

/**
 * This class creates a preference page
 */
public class PrefPageOne : PreferencePage {
    // Names for preferences
    private static final String ONE = "one.one";
    private static final String TWO = "one.two";
    private static final String THREE = "one.three";

    // Text fields for user to enter preferences
    private Text fieldOne;
    private Text fieldTwo;
    private Text fieldThree;

    /**
    * Creates the controls for this page
    */
    protected Control createContents(Composite parent) {
        Composite composite = new Composite(parent, DWT.NONE);
        composite.setLayout(new GridLayout(2, false));

        // Get the preference store
        IPreferenceStore preferenceStore = getPreferenceStore();

        // Create three text fields.
        // Set the text in each from the preference store
        (new Label(composite, DWT.LEFT)).setText("Field One:");
        fieldOne = new Text(composite, DWT.BORDER);
        fieldOne.setLayoutData(new GridData(GridData.FILL_HORIZONTAL));
        fieldOne.setText(preferenceStore.getString(ONE));

        (new Label(composite, DWT.LEFT)).setText("Field Two:");
        fieldTwo = new Text(composite, DWT.BORDER);
        fieldTwo.setLayoutData(new GridData(GridData.FILL_HORIZONTAL));
        fieldTwo.setText(preferenceStore.getString(TWO));

        (new Label(composite, DWT.LEFT)).setText("Field Three:");
        fieldThree = new Text(composite, DWT.BORDER);
        fieldThree.setLayoutData(new GridData(GridData.FILL_HORIZONTAL));
        fieldThree.setText(preferenceStore.getString(THREE));

        return composite;
    }

    /**
    * Called when user clicks Restore Defaults
    */
    protected void performDefaults() {
        // Get the preference store
        IPreferenceStore preferenceStore = getPreferenceStore();

        // Reset the fields to the defaults
        fieldOne.setText(preferenceStore.getDefaultString(ONE));
        fieldTwo.setText(preferenceStore.getDefaultString(TWO));
        fieldThree.setText(preferenceStore.getDefaultString(THREE));
    }

    /**
     * Called when user clicks Apply or OK
     *
     * @return bool
     */
    public bool performOk() {
        // Get the preference store
        IPreferenceStore preferenceStore = getPreferenceStore();

        // Set the values from the fields
        if (fieldOne !is null) preferenceStore.setValue(ONE, fieldOne.getText());
        if (fieldTwo !is null) preferenceStore.setValue(TWO, fieldTwo.getText());
        if (fieldThree !is null)
            preferenceStore.setValue(THREE, fieldThree.getText());

        // Return true to allow dialog to close
        return true;
    }
}


/**
 * This class creates a preference page
 */
public class PrefPageTwo : PreferencePage {
    // Names for preferences
    private static final String ONE = "two.one";
    private static final String TWO = "two.two";
    private static final String THREE = "two.three";

    // The checkboxes
    private Button checkOne;
    private Button checkTwo;
    private Button checkThree;

    /**
     * PrefPageTwo constructor
     */
    public this() {
        super("Two");
        setDescription("Check the checks");
    }

    /**
     * Creates the controls for this page
     */
    protected Control createContents(Composite parent) {
        Composite composite = new Composite(parent, DWT.NONE);
        composite.setLayout(new RowLayout(DWT.VERTICAL));

        // Get the preference store
        IPreferenceStore preferenceStore = getPreferenceStore();

        // Create three checkboxes
        checkOne = new Button(composite, DWT.CHECK);
        checkOne.setText("Check One");
        checkOne.setSelection(preferenceStore.getBoolean(ONE));

        checkTwo = new Button(composite, DWT.CHECK);
        checkTwo.setText("Check Two");
        checkTwo.setSelection(preferenceStore.getBoolean(TWO));

        checkThree = new Button(composite, DWT.CHECK);
        checkThree.setText("Check Three");
        checkThree.setSelection(preferenceStore.getBoolean(THREE));

        return composite;
    }

    /**
     * Add buttons
     *
     * @param parent the parent composite
     */
    protected void contributeButtons(Composite parent) {
        // Add a select all button
        Button selectAll = new Button(parent, DWT.PUSH);
        selectAll.setText("Select All");
        selectAll.addSelectionListener(new class SelectionAdapter {
            public void widgetSelected(SelectionEvent event) {
                checkOne.setSelection(true);
                checkTwo.setSelection(true);
                checkThree.setSelection(true);
            }
        });

        // Add a select all button
        Button clearAll = new Button(parent, DWT.PUSH);
        clearAll.setText("Clear All");
        clearAll.addSelectionListener(new class SelectionAdapter {
            public void widgetSelected(SelectionEvent event) {
                checkOne.setSelection(false);
                checkTwo.setSelection(false);
                checkThree.setSelection(false);
            }
        });

        // Add two columns to the parent's layout
        (cast(GridLayout) parent.getLayout()).numColumns += 2;
    }

    /**
     * Change the description label
     */
    protected Label createDescriptionLabel(Composite parent) {
        Label label = null;
        String description = getDescription();
        if (description != null) {
        // Upper case the description
        description = description.toUpperCase();

        // Right-align the label
        label = new Label(parent, DWT.RIGHT);
        label.setText(description);
        }
        return label;
    }

    /**
     * Called when user clicks Restore Defaults
     */
    protected void performDefaults() {
        // Get the preference store
        IPreferenceStore preferenceStore = getPreferenceStore();

        // Reset the fields to the defaults
        checkOne.setSelection(preferenceStore.getDefaultBoolean(ONE));
        checkTwo.setSelection(preferenceStore.getDefaultBoolean(TWO));
        checkThree.setSelection(preferenceStore.getDefaultBoolean(THREE));
    }

    /**
     * Called when user clicks Apply or OK
     *
     * @return bool
     */
    public bool performOk() {
        // Get the preference store
        IPreferenceStore preferenceStore = getPreferenceStore();

        // Set the values from the fields
        if (checkOne !is null) preferenceStore.setValue(ONE, checkOne.getSelection());
        if (checkTwo !is null) preferenceStore.setValue(TWO, checkTwo.getSelection());
        if (checkThree !is null)
            preferenceStore.setValue(THREE, checkThree.getSelection());

        // Return true to allow dialog to close
        return true;
    }
}



/**
 * This class demonstrates JFace preferences
 */
public class ShowPrefs {
    /**
     * Runs the application
     */
    public void run() {
//         Display display = new Display();

        // Create the preference manager
        PreferenceManager mgr = new PreferenceManager();

        // Create the nodes
        PreferenceNode one = new PreferenceNode("one", "One", ImageDescriptor
            .createFromFile(getImportData!("cancel.gif")), PrefPageOne.classinfo.name );
        PreferenceNode two = new PreferenceNode("two", new PrefPageTwo());

        // Add the nodes
        mgr.addToRoot(one);
        mgr.addTo(one.getId(), two);

        // Create the preferences dialog
        PreferenceDialog dlg = new PreferenceDialog(null, mgr);

        // Set the preference store
        PreferenceStore ps = new PreferenceStore( FILENAME );
        try {
            ps.load();
        } catch (IOException e) {
            // Ignore
        }
        dlg.setPreferenceStore(ps);

        // Open the dialog
        dlg.open();

        try {
            // Save the preferences
            ps.save();
        } catch (IOException e) {
            ExceptionPrintStackTrace(e);
        }
//         display.dispose();
    }

    /**
     * The application entry point
     *
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        (new ShowPrefs()).run();
    }
}

void main(){
    if( !Path.exists(FILENAME) ){
        scope prefs = new File( FILENAME );
        prefs.write( import("jface.showprefs.properties" ));
    }
    ShowPrefs.main( null );
}





