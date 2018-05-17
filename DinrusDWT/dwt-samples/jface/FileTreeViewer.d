module jface.FileTreeViewer;

import dwt.DWT;
import dwt.widgets.Label;
import dwt.widgets.Control;
import dwt.widgets.Composite;
import dwt.widgets.Display;
import dwt.widgets.Shell;
import dwt.widgets.Button;

import dwt.events.SelectionAdapter;
import dwt.events.SelectionEvent;

import dwt.graphics.Image;
import dwt.graphics.ImageData;

import dwt.layout.GridLayout;
import dwt.layout.GridData;

import dwtx.jface.window.ApplicationWindow;

import dwtx.jface.viewers.Viewer;
import dwtx.jface.viewers.TreeViewer;
import dwtx.jface.viewers.ITreeContentProvider;
import dwtx.jface.viewers.ILabelProvider;
import dwtx.jface.viewers.ILabelProviderListener;
import dwtx.jface.viewers.LabelProviderChangedEvent;

version(JIVE) import jive.stacktrace;

import dwt.dwthelper.utils;
import dwt.dwthelper.ByteArrayInputStream;

//------------------------------------
//import dwt.dwthelper.utils;
//------------------------------------

import tango.io.FileSystem;
import tango.io.FilePath;
import tango.util.log.Trace;

import tango.util.collection.model.Seq;
import tango.util.collection.ArraySeq;
import tango.text.convert.Utf;

void main(){
    auto hw = new FileTree;
    hw.run();
}

class FileTree : ApplicationWindow {

    TreeViewer tv;

    this(){
        super(null);
    }

    public void run(){
        setBlockOnOpen(true);
        open();
        Display.getCurrent().dispose();
    }

    protected void configureShell( Shell shell ){
        super.configureShell(shell);
        shell.setText( "File Tree" );
        shell.setSize( 400, 400 );
    }

    protected Control createContents(Composite parent){

        auto composite = new Composite( parent, DWT.NONE );
        composite.setLayout( new GridLayout(1,false));

        // Add a checkbox to toggle whether the labels preserve case
        auto preserveCase = new Button( composite, DWT.CHECK );
        preserveCase.setText( "&Preserve case" );

        // Create the tree viewer to display the file tree
        tv = new TreeViewer( composite );
        tv.getTree().setLayoutData( new GridData( GridData.FILL_BOTH ));
        tv.setContentProvider( new FileTreeContentProvider());
        tv.setLabelProvider( new FileTreeLabelProvider() );
        tv.setInput( stringcast("root") );

        // When user checks the checkbox, toggle the preserve case attribute
        // of the label provider
        preserveCase.addSelectionListener( new class SelectionAdapter{
            public void widgetSelected( SelectionEvent event ){
                auto preserveCase = (cast(Button)event.widget).getSelection();
                auto ftlp = cast(FileTreeLabelProvider) tv.getLabelProvider();
                ftlp.setPreserveCase(preserveCase);
            }
        });
        return composite;
    }
}

class FileTreeContentProvider : ITreeContentProvider {
    public override Object[] getChildren( Object arg0 ){
        auto fp = cast(FilePath)arg0;
        try{
            if( !fp.isFolder() ){
                return null;
            }
            Object[] res;
            foreach( item; fp ){
                res ~= FilePath.from( item );
            }
            return res;
        }
        catch( Exception e ){
            return null;
        }
    }

    public override Object getParent(Object arg0 ){
        auto fp = cast(FilePath)arg0;
        return fp.pop;
    }

    public override bool hasChildren(Object arg0 ){
        auto obj = getChildren(arg0);
        return obj is null ? false : obj.length > 0;
    }

    public override Object[] getElements( Object arg0 ){
        Object[] res;

        foreach( root; FileSystem.roots()){
            // ignore floppy drives, they bring up strange error messages
            if( root == `A:\`|| root == `B:\` ){
                continue;
            }
            res ~= new FilePath( root );
        }
        return res;
    }

    public override void dispose(){
    }

    public override void inputChanged(Viewer arg0, Object arg1, Object arg2 ){
    }

}

class FileTreeLabelProvider : ILabelProvider {

    private Seq!(ILabelProviderListener) listeners;

    private Image file;
    private Image dir;

    private bool preserveCase;

    public this(){
        listeners = new ArraySeq!(ILabelProviderListener);

        file = new Image( null, new ImageData( new ByteArrayInputStream( cast(byte[])import( "file.png" ))));
        dir = new Image( null, new ImageData( new ByteArrayInputStream( cast(byte[])import( "folder.png" ))));
    }

    public void setPreserveCase(bool preserveCase){
        this.preserveCase = preserveCase;
        auto event = new LabelProviderChangedEvent(this);
        for( int i = 0, n = listeners.size(); i < n; i++ ){
            auto ilpl = listeners.get(i);
            ilpl.labelProviderChanged(event);
        }
    }

    public override Image getImage(Object arg0){
        auto fp = cast(FilePath)arg0;
        // is a root
        if( fp.name.length is 0 ){
            return dir;
        }
        return fp.isFolder() ? dir : file;
    }

    public override char[] getText(Object arg0){
        auto fp = cast(FilePath)arg0;
        auto text = fp.name();
        if( text.length is 0 ){
            // now take all info, it will be drive or the root folder
            text = fp.toString();
        }
        return preserveCase ? text : text.toUpperCase();
    }

    public void addListener( ILabelProviderListener arg0 ){
        listeners.append(arg0);
    }

    public void dispose(){
        if( dir !is null ) dir.dispose();
        if( file !is null ) file.dispose();
    }

    public bool isLabelProperty(Object arg0, char[] arg1){
        return false;
    }

    public void removeListener(ILabelProviderListener arg0){
        listeners.remove(arg0);
    }
}














