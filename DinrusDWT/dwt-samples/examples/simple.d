module example.simple;

import dwt.DWT;
import dwt.events.SelectionEvent;
import dwt.events.SelectionListener;
import dwt.widgets.Button;
import dwt.widgets.Display;
import dwt.widgets.Shell;
import dwt.widgets.Text;

import tango.io.Stdout;

void main(){

    try{

        Display display = new Display();
        Shell shell = new Shell(display);
        shell.setSize(300, 200);
        shell.setText("Simple DWT Sample");
        auto btn = new Button( shell, DWT.PUSH );
        btn.setBounds(40, 50, 100, 50);
        btn.setText( "hey" );

        auto txt = new Text(shell, DWT.BORDER);
        txt.setBounds(170, 50, 100, 40);

        btn.addSelectionListener(new class () SelectionListener {
            public void widgetSelected(SelectionEvent event) {
                txt.setText("No problem");
            }
            public void widgetDefaultSelected(SelectionEvent event) {
                txt.setText("No worries!");
            }
        });

        shell.open();
        while (!shell.isDisposed()) {
            if (!display.readAndDispatch()) {
                display.sleep();
            }
        }
    }
    catch (Exception e) {
        Stdout.formatln (e.toString);
    }
}

