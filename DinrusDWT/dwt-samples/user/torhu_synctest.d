module user.torhu_synctest;

import dwt.DWT;
import dwt.dwthelper.Runnable;
import dwt.widgets.Display;
import dwt.widgets.Shell;
import dwt.widgets.Button;
import dwt.widgets.Synchronizer;
import dwt.widgets.Text;

import tango.core.Thread;
import tango.io.Stdout;
import tango.math.Math;
import tango.text.convert.Format;
import tango.util.Convert;
import tango.util.PathUtil;
import dwt.events.SelectionListener;
import dwt.events.SelectionEvent;


void main(){

    try{

        Display display = new Display();
        Shell shell = new Shell(display);
        shell.setSize(300, 200);
        shell.setText("Simple DWT Sample");
        auto btn = new Button( shell, DWT.PUSH );
        btn.setBounds(40, 50, 100, 50);
        btn.setText( "test syncExec" );

        auto txt = new Text(shell, DWT.BORDER);
        txt.setBounds(170, 50, 100, 40);

        auto t = new Thread({Display.getDefault.syncExec(new class Runnable {
            void run() { txt.setText("inside syncExec"); }
        });});
                

        btn.addSelectionListener(new class () SelectionListener {
            public void widgetSelected(SelectionEvent event) {
                
                t.start();
            }
            public void widgetDefaultSelected(SelectionEvent event) {
                //txt.setText("No worries!");
            }
        });

        shell.open();
        while (!shell.isDisposed()) {
            if (!display.readAndDispatch()) {
                display.sleep();
                Stdout( "." ).flush;
            }
        }
    }
    catch (Exception e) {
        Stdout.formatln (e.toString);
    }
}
