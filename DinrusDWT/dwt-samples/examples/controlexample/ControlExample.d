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
module examples.controlexample.ControlExample;

import dwt.DWT;
import dwt.graphics.Image;
import dwt.graphics.ImageData;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.layout.FillLayout;
import dwt.widgets.Composite;
import dwt.widgets.Display;
import dwt.widgets.Shell;
import dwt.widgets.TabFolder;
import dwt.widgets.TabItem;
import dwt.dwthelper.ResourceBundle;
import dwt.dwthelper.ByteArrayInputStream;

import examples.controlexample.Tab;
import examples.controlexample.ButtonTab;
import examples.controlexample.CanvasTab;
import examples.controlexample.ComboTab;
import examples.controlexample.CoolBarTab;
import examples.controlexample.DateTimeTab;
import examples.controlexample.DialogTab;
import examples.controlexample.ExpandBarTab;
import examples.controlexample.GroupTab;
import examples.controlexample.LabelTab;
import examples.controlexample.LinkTab;
import examples.controlexample.ListTab;
import examples.controlexample.MenuTab;
import examples.controlexample.ProgressBarTab;
import examples.controlexample.SashTab;
import examples.controlexample.ScaleTab;
import examples.controlexample.ShellTab;
import examples.controlexample.SliderTab;
import examples.controlexample.SpinnerTab;
import examples.controlexample.TabFolderTab;
import examples.controlexample.TableTab;
import examples.controlexample.TextTab;
import examples.controlexample.ToolBarTab;
import examples.controlexample.ToolTipTab;
import examples.controlexample.TreeTab;

import tango.core.Exception;
import tango.text.convert.Format;
import tango.io.Stdout;
import Math = tango.math.Math;
import dwt.dwthelper.utils;

version(JIVE){
    import jive.stacktrace;
}

interface IControlExampleFactory{
    ControlExample create(Shell shell, char[] title);
}

void main(){
    Display display = new Display();
    Shell shell = new Shell(display, DWT.SHELL_TRIM);
    shell.setLayout(new FillLayout());

    IControlExampleFactory ifactory;
    char[] key;
    if( auto factory = ClassInfo.find( "examples.controlexample.CustomControlExample.CustomControlExampleFactory" )){
        ifactory = cast(IControlExampleFactory) factory.create;
        key = "custom.window.title";
    }
    else{
        ifactory = new ControlExampleFactory();
        key = "window.title";
    }
    auto instance = ifactory.create( shell, key );
    ControlExample.setShellSize(instance, shell);
    shell.open();
    while (! shell.isDisposed()) {
        if (! display.readAndDispatch()) display.sleep();
    }
    instance.dispose();
    display.dispose();
}

public class ControlExampleFactory : IControlExampleFactory {
    ControlExample create(Shell shell, char[] title){
        Stdout.formatln( "The ControlExample: still work left" );
        Stdout.formatln( "todo: Implement Get/Set API reflection" );
        Stdout.formatln( "" );
        version(Windows){
        Stdout.formatln( "On Win2K:" );
        Stdout.formatln( "note: Buttons text+image do show only the image" );
        Stdout.formatln( "        in java it behaves the same" );
        Stdout.formatln( "        it is not supported on all plattforms" );
        Stdout.formatln( "" );
        }
        version(linux){
        Stdout.formatln( "todo: ExpandBarTab looks strange" );
        Stdout.formatln( "On linux GTK:" );
        Stdout.formatln( "todo: DateTimeTab not implemented" );
        Stdout.formatln( "bug:  ProgressBarTab crash on vertical" );
        Stdout.formatln( "        in java it behaves the same" );
        Stdout.formatln( "bug:  SliderTab horizontal arrow buttons are too high." );
        Stdout.formatln( "        in java it behaves the same" );
        Stdout.formatln( "        Known bug:" );
        Stdout.formatln( "        https://bugs.eclipse.org/bugs/show_bug.cgi?id=197402" );
        Stdout.formatln( "        http://bugzilla.gnome.org/show_bug.cgi?id=475909" );
        Stdout.formatln( "" );
        }
        Stdout.formatln( "please report problems" );
        auto res = new ControlExample( shell );
        shell.setText(ControlExample.getResourceString("window.title"));
        return res;
    }
}

public class ControlExample {
    private static ResourceBundle resourceBundle;
    private static const char[] resourceData = import( "examples.controlexample.controlexample.properties" );

    private ShellTab shellTab;
    private TabFolder tabFolder;
    private Tab [] tabs;
    Image images[];

    static const int ciClosedFolder = 0, ciOpenFolder = 1, ciTarget = 2, ciBackground = 3, ciParentBackground = 4;

    static const byte[][] imageData = [
        cast(byte[]) import( "examples.controlexample.closedFolder.gif" ),
        cast(byte[]) import( "examples.controlexample.openFolder.gif" ),
        cast(byte[]) import( "examples.controlexample.target.gif" ),
        cast(byte[]) import( "examples.controlexample.backgroundImage.png" ),
        cast(byte[]) import( "examples.controlexample.parentBackgroundImage.png" )
    ];
    static const int[] imageTypes = [
        DWT.ICON,
        DWT.ICON,
        DWT.ICON,
        DWT.BITMAP,
        DWT.BITMAP];

    bool startup = true;

    static this(){
        resourceBundle = ResourceBundle.getBundleFromData( resourceData ); //$NON-NLS-1$
    }

    /**
     * Creates an instance of a ControlExample embedded inside
     * the supplied parent Composite.
     *
     * @param parent the container of the example
     */
    public this(Composite parent) {
        initResources();
        tabFolder = new TabFolder (parent, DWT.NONE);
        tabs = createTabs();
        for (int i=0; i<tabs.length; i++) {
            TabItem item = new TabItem (tabFolder, DWT.NONE);
            item.setText (tabs [i].getTabText ());
            item.setControl (tabs [i].createTabFolderPage (tabFolder));
            item.setData (tabs [i]);
        }
        startup = false;
    }

    /**
     * Answers the set of example Tabs
     */
    Tab[] createTabs() {
        return [ cast(Tab)
            new ButtonTab (this),
            new CanvasTab (this),
            new ComboTab (this),
            new CoolBarTab (this),
            new DateTimeTab (this),
            new DialogTab (this),
            new ExpandBarTab (this),
            new GroupTab (this),
            new LabelTab (this),
            new LinkTab (this),
            new ListTab (this),
            new MenuTab (this),
            new ProgressBarTab (this),
            new SashTab (this),
            new ScaleTab (this),
            shellTab = new ShellTab(this),
            new SliderTab (this),
            new SpinnerTab (this),
            new TabFolderTab (this),
            new TableTab (this),
            new TextTab (this),
            new ToolBarTab (this),
            new ToolTipTab (this),
            new TreeTab (this)
        ];
    }

    /**
     * Disposes of all resources associated with a particular
     * instance of the ControlExample.
     */
    public void dispose() {
        /*
         * Destroy any shells that may have been created
         * by the Shells tab.  When a shell is disposed,
         * all child shells are also disposed.  Therefore
         * it is necessary to check for disposed shells
         * in the shells list to avoid disposing a shell
         * twice.
         */
        if (shellTab !is null) shellTab.closeAllShells ();
        shellTab = null;
        tabFolder = null;
        freeResources();
    }

    /**
     * Frees the resources
     */
    void freeResources() {
        if (images !is null) {
            for (int i = 0; i < images.length; ++i) {
                final Image image = images[i];
                if (image !is null) image.dispose();
            }
            images = null;
        }
    }

    /**
     * Gets a string from the resource bundle.
     * We don't want to crash because of a missing String.
     * Returns the key if not found.
     */
    static char[] getResourceString(char[] key) {
        char[] res;
        try {
            res = resourceBundle.getString(key);
        } catch (MissingResourceException e) {
            return key;
        } catch (NoSuchElementException e) {
            return key;
        }
        if( res is null && !resourceBundle.hasString(key)){
            return "!" ~ key ~ "!"; //$NON-NLS-1$ //$NON-NLS-2$
        }
        return res;
    }

//     /**
//      * Gets a string from the resource bundle and binds it
//      * with the given arguments. If the key is not found,
//      * return the key.
//      */
//     static char[] getResourceString(char[] key, Object[] args) {
//         char[] res;
//         try {
//             res = Format(getResourceString(key), args);
//         } catch (NoSuchElementException e) {
//             return key;
//         }
//         if( res is null ){
//             return "!" ~ key ~ "!"; //$NON-NLS-1$ //$NON-NLS-2$
//         }
//         return res;
//     }

    /**
     * Loads the resources
     */
    void initResources() {
        //final Class clazz = ControlExample.class;
        if (resourceBundle !is null) {
            try {
                if (images is null) {
                    images = new Image[imageData.length];

                    for (int i = 0; i < imageData.length; ++i) {
                        InputStream sourceStream = new ByteArrayInputStream( imageData[i] );
                        ImageData source = new ImageData(sourceStream);
                        if (imageTypes[i] is DWT.ICON) {
                            ImageData mask = source.getTransparencyMask();
                            images[i] = new Image(null, source, mask);
                        } else {
                            images[i] = new Image(null, source);
                        }
                        try {
                            sourceStream.close();
                        } catch (IOException e) {
                            Stderr.formatln( "Stacktrace: {}", e.toString );
                        }
                    }
                }
                return;
            } catch (Exception t) {
                Stdout.formatln( "ups {}", t );
            }
        }
        char[] error = (resourceBundle !is null) ?
            getResourceString("error.CouldNotLoadResources") :
            "Unable to load resources"; //$NON-NLS-1$
        freeResources();
        throw new Exception(error);
    }

    /**
     * Grabs input focus.
     */
    public void setFocus() {
        tabFolder.setFocus();
    }

    /**
     * Sets the size of the shell to it's "packed" size,
     * unless that makes it larger than the monitor it is being displayed on,
     * in which case just set the shell size to be slightly smaller than the monitor.
     */
    static void setShellSize(ControlExample instance, Shell shell) {
        Point size = shell.computeSize(DWT.DEFAULT, DWT.DEFAULT);
        Rectangle monitorArea = shell.getMonitor().getClientArea();
        /* Workaround: if the tab folder is wider than the screen,
         * carbon clips instead of somehow scrolling the tab items.
         * We try to recover some width by using shorter tab names. */
        if (size.x > monitorArea.width && DWT.getPlatform()=="carbon") {
            TabItem [] tabItems = instance.tabFolder.getItems();
            for (int i=0; i<tabItems.length; i++) {
                tabItems[i].setText (instance.tabs [i].getShortTabText ());
            }
            size = shell.computeSize(DWT.DEFAULT, DWT.DEFAULT);
        }
        shell.setSize(Math.min(size.x, monitorArea.width), Math.min(size.y, monitorArea.height));
    }
}

