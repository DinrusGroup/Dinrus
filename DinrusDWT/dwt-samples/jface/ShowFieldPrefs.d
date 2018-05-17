module jface.PreferenceDlgTest;

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

const char[] FILENAME = "showfieldprefs";

/**
 * This class demonstrates field editors
 */
public class FieldEditorPageOne : FieldEditorPreferencePage {
    public this() {
        // Use the "flat" layout
        super(FLAT);
    }

    /**
     * Creates the field editors
     */
    protected void createFieldEditors() {
        // Add a bool field
        BooleanFieldEditor bfe = new BooleanFieldEditor("myBoolean", "Boolean",
            getFieldEditorParent());
        addField(bfe);

        // Add a color field
        ColorFieldEditor cfe = new ColorFieldEditor("myColor", "Color:",
            getFieldEditorParent());
        addField(cfe);

        // Add a directory field
        DirectoryFieldEditor dfe = new DirectoryFieldEditor("myDirectory",
            "Directory:", getFieldEditorParent());
        addField(dfe);

        // Add a file field
        FileFieldEditor ffe = new FileFieldEditor("myFile", "File:",
            getFieldEditorParent());
        addField(ffe);

        // Add a font field
        FontFieldEditor fontFe = new FontFieldEditor("myFont", "Font:",
            getFieldEditorParent());
        addField(fontFe);

        // Add a radio group field
        RadioGroupFieldEditor rfe = new RadioGroupFieldEditor("myRadioGroup",
            "Radio Group", 2, [ [ "First Value", "first"],
                [ "Second Value", "second"], [ "Third Value", "third"],
                [ "Fourth Value", "fourth"]], getFieldEditorParent(), true);
        addField(rfe);

        // Add a path field
        PathEditor pe = new PathEditor("myPath", "Path:", "Choose a Path",
            getFieldEditorParent());
        addField(pe);
    }
}


/**
 * This class demonstrates field editors
 */
public class FieldEditorPageTwo : FieldEditorPreferencePage {
    public this() {
        // Use the "grid" layout
        super(GRID);
    }

    /**
    * Creates the field editors
    */
    protected void createFieldEditors() {
        // Add an integer field
        IntegerFieldEditor ife = new IntegerFieldEditor("myInt", "Int:",
            getFieldEditorParent());
        addField(ife);

        // Add a scale field
        ScaleFieldEditor sfe = new ScaleFieldEditor("myScale", "Scale:",
            getFieldEditorParent(), 0, 100, 1, 10);
        addField(sfe);

        // Add a string field
        StringFieldEditor stringFe = new StringFieldEditor("myString", "String:",
            getFieldEditorParent());
        addField(stringFe);
    }
}


/**
 * This class demonstrates JFace preferences and field editors
 */
public class ShowFieldPrefs {
    /**
    * Runs the application
    */
    public void run() {
//         Display display = new Display();

        // Create the preference manager
        PreferenceManager mgr = new PreferenceManager();

        // Create the nodes
        PreferenceNode one = new PreferenceNode("one", "One", null,
            FieldEditorPageOne.classinfo.name );
        PreferenceNode two = new PreferenceNode("two", "Two", null,
            FieldEditorPageTwo.classinfo.name );

        // Add the nodes
        mgr.addToRoot(one);
        mgr.addToRoot(two);

        // Create the preferences dialog
        PreferenceDialog dlg = new PreferenceDialog(null, mgr);

        // Set the preference store
        PreferenceStore ps = new PreferenceStore(FILENAME);
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
        (new ShowFieldPrefs()).run();
    }
}


void main(){
    if( !Path.exists( FILENAME ) ){
        scope prefs = new File( FILENAME );
        version(linux){
            prefs.write( import("jface.showfieldprefs.properties.linux" ));
        }
        version(Windows){
            prefs.write( import("jface.showfieldprefs.properties.win" ));
        }
    }
    ShowFieldPrefs.main( null );
}





