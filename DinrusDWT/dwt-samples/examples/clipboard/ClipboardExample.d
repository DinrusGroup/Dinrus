/*******************************************************************************
 * Copyright (c) 2000, 2004 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * D Port:
 *     Jesse Phillips <Jesse.K.Phillips+D> gmail.com
 *******************************************************************************/
module examples.clipboard.ClipboardExample;

import dwt.DWT;
import dwt.custom.ScrolledComposite;
import dwt.custom.StyledText;
import dwt.dnd.Clipboard;
import dwt.dnd.FileTransfer;
import dwt.dnd.HTMLTransfer;
import dwt.dnd.RTFTransfer;
import dwt.dnd.TextTransfer;
import dwt.dnd.Transfer;
import dwt.events.SelectionAdapter;
import dwt.events.SelectionEvent;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.layout.FillLayout;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Button;
import dwt.widgets.Combo;
import dwt.widgets.Composite;
import dwt.widgets.DirectoryDialog;
import dwt.widgets.Display;
import dwt.widgets.FileDialog;
import dwt.widgets.Group;
import dwt.widgets.Label;
import dwt.widgets.List;
import dwt.widgets.Shell;
import dwt.widgets.Table;
import dwt.widgets.TableItem;
import dwt.widgets.Text;
import dwt.dwthelper.utils;

import tango.io.Stdout;
version(JIVE) import jive.stacktrace;
import tango.io.model.IFile;

class ClipboardExample {
    static const int SIZE = 60;
    Clipboard clipboard;
    Shell shell;
    Text copyText;
    Text pasteText;
    Text copyRtfText;
    Text pasteRtfText;
    Text copyHtmlText;
    Text pasteHtmlText;
    Table copyFileTable;
    Table pasteFileTable;
    Text text;
    Combo combo;
    StyledText styledText;
    Label status;

    public void open(Display display) {
         clipboard = new Clipboard(display);
         shell = new Shell (display);
         shell.setText("DWT Clipboard");
         shell.setLayout(new FillLayout());

         ScrolledComposite sc = new ScrolledComposite(shell, DWT.H_SCROLL | DWT.V_SCROLL);
         Composite parent = new Composite(sc, DWT.NONE);
         sc.setContent(parent);
         parent.setLayout(new GridLayout(2, true));

         Group copyGroup = new Group(parent, DWT.NONE);
         copyGroup.setText("Copy From:");
         GridData data = new GridData(GridData.FILL_BOTH);
         copyGroup.setLayoutData(data);
         copyGroup.setLayout(new GridLayout(3, false));

         Group pasteGroup = new Group(parent, DWT.NONE);
         pasteGroup.setText("Paste To:");
         data = new GridData(GridData.FILL_BOTH);
         pasteGroup.setLayoutData(data);
         pasteGroup.setLayout(new GridLayout(3, false));

         Group controlGroup = new Group(parent, DWT.NONE);
         controlGroup.setText("Control API:");
         data = new GridData(GridData.FILL_BOTH);
         data.horizontalSpan = 2;
         controlGroup.setLayoutData(data);
         controlGroup.setLayout(new GridLayout(5, false));

         /* Enable with Available Types */
         Group typesGroup = new Group(parent, DWT.NONE);
         typesGroup.setText("Available Types");
         data = new GridData(GridData.FILL_BOTH);
         data.horizontalSpan = 2;
         typesGroup.setLayoutData(data);
         typesGroup.setLayout(new GridLayout(2, false));
         /**/

         status = new Label(parent, DWT.BORDER);
         data = new GridData(GridData.FILL_HORIZONTAL);
         data.horizontalSpan = 2;
         data.heightHint = 60;
         status.setLayoutData(data);

         createTextTransfer(copyGroup, pasteGroup);
         createRTFTransfer(copyGroup, pasteGroup);
         createHTMLTransfer(copyGroup, pasteGroup);
         createFileTransfer(copyGroup, pasteGroup);
         createMyTransfer(copyGroup, pasteGroup);
         createControlTransfer(controlGroup);
         createAvailableTypes(typesGroup);

         sc.setMinSize(parent.computeSize(DWT.DEFAULT, DWT.DEFAULT));
         sc.setExpandHorizontal(true);
         sc.setExpandVertical(true);

         Point size = shell.computeSize(DWT.DEFAULT, DWT.DEFAULT);
         Rectangle monitorArea = shell.getMonitor().getClientArea();
         shell.setSize(Math.min(size.x, monitorArea.width - 20), Math.min(size.y, monitorArea.height - 20));
         shell.open();
         while (!shell.isDisposed ()) {
              if (!display.readAndDispatch ()) display.sleep ();
         }
         clipboard.dispose();
    }
    void createTextTransfer(Composite copyParent, Composite pasteParent) {

         // TextTransfer
         Label l = new Label(copyParent, DWT.NONE);
         l.setText("TextTransfer:"); //$NON-NLS-1$
         copyText = new Text(copyParent, DWT.MULTI | DWT.BORDER | DWT.V_SCROLL | DWT.H_SCROLL);
         copyText.setText("some\nplain\ntext");
         GridData data = new GridData(GridData.FILL_HORIZONTAL);
         data.heightHint = data.widthHint = SIZE;
         copyText.setLayoutData(data);
         Button b = new Button(copyParent, DWT.PUSH);
         b.setText("Copy");
         b.addSelectionListener(new class SelectionAdapter {
              public void widgetSelected(SelectionEvent e) {
                    auto data = copyText.getText();
                    if (data.length > 0) {
                         status.setText("");
                         auto obj = new Object[1];
                         auto trans = new TextTransfer[1];
                         obj[0] = cast(Object) new ArrayWrapperString(data);
                         trans[0] = TextTransfer.getInstance();
                         clipboard.setContents(obj, trans);
                    } else {
                         status.setText("nothing to copy");
                    }
              }
         });

         l = new Label(pasteParent, DWT.NONE);
         l.setText("TextTransfer:"); //$NON-NLS-1$
         pasteText = new Text(pasteParent, DWT.READ_ONLY | DWT.MULTI | DWT.BORDER | DWT.V_SCROLL | DWT.H_SCROLL);
         data = new GridData(GridData.FILL_HORIZONTAL);
         data.heightHint = data.widthHint = SIZE;
         pasteText.setLayoutData(data);
         b = new Button(pasteParent, DWT.PUSH);
         b.setText("Paste");
         b.addSelectionListener(new class SelectionAdapter {
              public void widgetSelected(SelectionEvent e) {
                    auto data = cast(ArrayWrapperString) clipboard.getContents(TextTransfer.getInstance());
                    if (data !is null) {
                        status.setText("");
                         pasteText.setText("begin paste>"~data.array~"<end paste");
                    } else {
                         status.setText("nothing to paste");
                    }
              }
         });
    }
    void createRTFTransfer(Composite copyParent, Composite pasteParent){
         //  RTF Transfer
         Label l = new Label(copyParent, DWT.NONE);
         l.setText("RTFTransfer:"); //$NON-NLS-1$
         copyRtfText = new Text(copyParent, DWT.MULTI | DWT.BORDER | DWT.V_SCROLL | DWT.H_SCROLL);
         copyRtfText.setText("some\nrtf\ntext");
         GridData data = new GridData(GridData.FILL_HORIZONTAL);
         data.heightHint = data.widthHint = SIZE;
         copyRtfText.setLayoutData(data);
         Button b = new Button(copyParent, DWT.PUSH);
         b.setText("Copy");
         b.addSelectionListener(new class SelectionAdapter {
              public void widgetSelected(SelectionEvent e) {
                    auto data = copyRtfText.getText();
                    if (data.length > 0) {
                         status.setText("");
                         data = "{\\rtf1{\\colortbl;\\red255\\green0\\blue0;}\\uc1\\b\\i " ~ data ~ "}";
                         auto obj = new Object[1];
                         auto trans = new Transfer[1];
                         obj[0] = cast(Object) new ArrayWrapperString(data);
                         trans[0] = RTFTransfer.getInstance();
                         clipboard.setContents(obj, trans);
                    } else {
                         status.setText("nothing to copy");
                    }
              }
         });

         l = new Label(pasteParent, DWT.NONE);
         l.setText("RTFTransfer:"); //$NON-NLS-1$
         pasteRtfText = new Text(pasteParent, DWT.READ_ONLY | DWT.MULTI | DWT.BORDER | DWT.V_SCROLL | DWT.H_SCROLL);
         data = new GridData(GridData.FILL_HORIZONTAL);
         data.heightHint = data.widthHint = SIZE;
         pasteRtfText.setLayoutData(data);
         b = new Button(pasteParent, DWT.PUSH);
         b.setText("Paste");
         b.addSelectionListener(new class SelectionAdapter {
              public void widgetSelected(SelectionEvent e) {
                    auto data = cast(ArrayWrapperString) clipboard.getContents(RTFTransfer.getInstance());
                    if (data !is null) {
                        status.setText("");
                        pasteRtfText.setText("begin paste>"~data.array~"<end paste");
                    } else {
                         status.setText("nothing to paste");
                    }
              }
         });
    }
    void createHTMLTransfer(Composite copyParent, Composite pasteParent){
         //  HTML Transfer
         Label l = new Label(copyParent, DWT.NONE);
         l.setText("HTMLTransfer:"); //$NON-NLS-1$
         copyHtmlText = new Text(copyParent, DWT.MULTI | DWT.BORDER | DWT.V_SCROLL | DWT.H_SCROLL);
         copyHtmlText.setText("<b>Hello World</b>");
         GridData data = new GridData(GridData.FILL_HORIZONTAL);
         data.heightHint = data.widthHint = SIZE;
         copyHtmlText.setLayoutData(data);
         Button b = new Button(copyParent, DWT.PUSH);
         b.setText("Copy");
         b.addSelectionListener(new class SelectionAdapter {
              public void widgetSelected(SelectionEvent e) {
                    auto data = copyHtmlText.getText();
                    if (data.length > 0) {
                         status.setText("");
                         auto obj = new Object[1];
                         auto trans = new Transfer[1];
                         obj[0] = cast(Object) new ArrayWrapperString(data);
                         trans[0] = HTMLTransfer.getInstance();
                         clipboard.setContents(obj, trans);
                    } else {
                         status.setText("nothing to copy");
                    }
              }
         });

         l = new Label(pasteParent, DWT.NONE);
         l.setText("HTMLTransfer:"); //$NON-NLS-1$
         pasteHtmlText = new Text(pasteParent, DWT.READ_ONLY | DWT.MULTI | DWT.BORDER | DWT.V_SCROLL | DWT.H_SCROLL);
         data = new GridData(GridData.FILL_HORIZONTAL);
         data.heightHint = data.widthHint = SIZE;
         pasteHtmlText.setLayoutData(data);
         b = new Button(pasteParent, DWT.PUSH);
         b.setText("Paste");
         b.addSelectionListener(new class SelectionAdapter {
              public void widgetSelected(SelectionEvent e) {
                    auto data = cast(ArrayWrapperString) clipboard.getContents(HTMLTransfer.getInstance());
                    if (data !is null) {
                         status.setText("");
                         pasteHtmlText.setText("begin paste>"~data.array~"<end paste");
                    } else {
                         status.setText("nothing to paste");
                    }
              }
         });
    }
    void createFileTransfer(Composite copyParent, Composite pasteParent){
         //File Transfer
         Label l = new Label(copyParent, DWT.NONE);
         l.setText("FileTransfer:"); //$NON-NLS-1$

         Composite c = new Composite(copyParent, DWT.NONE);
         c.setLayout(new GridLayout(2, false));
         GridData data = new GridData(GridData.FILL_HORIZONTAL);
         c.setLayoutData(data);

         copyFileTable = new Table(c, DWT.MULTI | DWT.BORDER);
         data = new GridData(GridData.FILL_HORIZONTAL);
         data.heightHint = data.widthHint = SIZE;
         data.horizontalSpan = 2;
         copyFileTable.setLayoutData(data);

         Button b = new Button(c, DWT.PUSH);
         b.setText("Select file(s)");
         b.addSelectionListener(new class SelectionAdapter {
              public void widgetSelected(SelectionEvent e) {
                    FileDialog dialog = new FileDialog(shell, DWT.OPEN | DWT.MULTI);
                    auto result = dialog.open();
                    if (result !is null && result.length > 0){
                         //copyFileTable.removeAll();
                         //This cannot be used
                         auto separator = tango.io.model.IFile.FileConst.PathSeparatorString;
                         auto path = dialog.getFilterPath();
                         auto names = dialog.getFileNames();
                         for (int i = 0; i < names.length; i++) {
                              TableItem item = new TableItem(copyFileTable, DWT.NONE);
                              item.setText(path~separator~names[i]);
                         }
                    }
              }
         });
         b = new Button(c, DWT.PUSH);
         b.setText("Select directory");
         b.addSelectionListener(new class SelectionAdapter {
              public void widgetSelected(SelectionEvent e) {
                    DirectoryDialog dialog = new DirectoryDialog(shell, DWT.OPEN);
                    auto result = dialog.open();
                    if (result !is null && result.length > 0){
                         //copyFileTable.removeAll();
                         TableItem item = new TableItem(copyFileTable, DWT.NONE);
                         item.setText(result);
                    }
              }
         });

         b = new Button(copyParent, DWT.PUSH);
         b.setText("Copy");
         b.addSelectionListener(new class SelectionAdapter {
              public void widgetSelected(SelectionEvent e) {
                    TableItem[] items = copyFileTable.getItems();
                    if (items.length > 0){
                         status.setText("");
                         auto data = new char[][items.length];
                         for (int i = 0; i < data.length; i++) {
                              data[i] = items[i].getText();
                         }
                         auto obj = new Object[1];
                         auto trans = new Transfer[1];
                         obj[0] = cast(Object) new ArrayWrapperString2(data);
                         trans[0] = FileTransfer.getInstance();
                         clipboard.setContents(obj, trans);
                    } else {
                         status.setText("nothing to copy");
                    }
              }
         });

         l = new Label(pasteParent, DWT.NONE);
         l.setText("FileTransfer:"); //$NON-NLS-1$
         pasteFileTable = new Table(pasteParent, DWT.MULTI | DWT.BORDER);
         data = new GridData(GridData.FILL_HORIZONTAL);
         data.heightHint = data.widthHint = SIZE;
         pasteFileTable.setLayoutData(data);
         b = new Button(pasteParent, DWT.PUSH);
         b.setText("Paste");
         b.addSelectionListener(new class SelectionAdapter {
              public void widgetSelected(SelectionEvent e) {
                    auto data = cast(ArrayWrapperString2) clipboard.getContents(FileTransfer.getInstance());
                    if (data !is null && data.array.length > 0) {
                         status.setText("");
                         pasteFileTable.removeAll();
                         foreach (s; data.array) {
                              TableItem item = new TableItem(pasteFileTable, DWT.NONE);
                              item.setText(s);
                         }
                    } else {
                         status.setText("nothing to paste");
                    }
              }
         });
    }
    void createMyTransfer(Composite copyParent, Composite pasteParent){
         //  MyType Transfer
         // TODO
    }
    void createControlTransfer(Composite parent){
         Label l = new Label(parent, DWT.NONE);
         l.setText("Text:");
         Button b = new Button(parent, DWT.PUSH);
         b.setText("Cut");
         b.addSelectionListener(new class SelectionAdapter {
              public void widgetSelected(SelectionEvent e) {
                    text.cut();
              }
         });
         b = new Button(parent, DWT.PUSH);
         b.setText("Copy");
         b.addSelectionListener(new class SelectionAdapter {
              public void widgetSelected(SelectionEvent e) {
                    text.copy();
              }
         });
         b = new Button(parent, DWT.PUSH);
         b.setText("Paste");
         b.addSelectionListener(new class SelectionAdapter {
              public void widgetSelected(SelectionEvent e) {
                    text.paste();
              }
         });
         text = new Text(parent, DWT.BORDER | DWT.MULTI | DWT.H_SCROLL | DWT.V_SCROLL);
         GridData data = new GridData(GridData.FILL_HORIZONTAL);
         data.heightHint = data.widthHint = SIZE;
         text.setLayoutData(data);

         l = new Label(parent, DWT.NONE);
         l.setText("Combo:");
         b = new Button(parent, DWT.PUSH);
         b.setText("Cut");
         b.addSelectionListener(new class SelectionAdapter {
              public void widgetSelected(SelectionEvent e) {
                    combo.cut();
              }
         });
         b = new Button(parent, DWT.PUSH);
         b.setText("Copy");
         b.addSelectionListener(new class SelectionAdapter {
              public void widgetSelected(SelectionEvent e) {
                    combo.copy();
              }
         });
         b = new Button(parent, DWT.PUSH);
         b.setText("Paste");
         b.addSelectionListener(new class SelectionAdapter {
              public void widgetSelected(SelectionEvent e) {
                    combo.paste();
              }
         });
         combo = new Combo(parent, DWT.NONE);
         char[][] str = new char[][4];
         str[0] = "Item 1";
         str[1] = "Item 2";
         str[2] = "Item 3";
         str[3] = "A longer Item";
         combo.setItems(str);

         l = new Label(parent, DWT.NONE);
         l.setText("StyledText:");
         l = new Label(parent, DWT.NONE);
         l.setVisible(false);
         b = new Button(parent, DWT.PUSH);
         b.setText("Copy");
         b.addSelectionListener(new class SelectionAdapter {
              public void widgetSelected(SelectionEvent e) {
                    styledText.copy();
              }
         });
         b = new Button(parent, DWT.PUSH);
         b.setText("Paste");
         b.addSelectionListener(new class SelectionAdapter {
              public void widgetSelected(SelectionEvent e) {
                    styledText.paste();
              }
         });
         styledText = new StyledText(parent, DWT.BORDER | DWT.MULTI | DWT.H_SCROLL | DWT.V_SCROLL);
         data = new GridData(GridData.FILL_HORIZONTAL);
         data.heightHint = data.widthHint = SIZE;
         styledText.setLayoutData(data);
    }

    List list;
    void createAvailableTypes(Composite parent){
         list = new List(parent, DWT.BORDER | DWT.H_SCROLL | DWT.V_SCROLL);
         GridData data = new GridData(GridData.FILL_BOTH);
         data.heightHint = 100;
         list.setLayoutData(data);
         Button b = new Button(parent, DWT.PUSH);
         b.setText("Get Available Types");
         b.addSelectionListener(new class SelectionAdapter {
              public void widgetSelected(SelectionEvent e) {
                    list.removeAll();
                    auto names = clipboard.getAvailableTypeNames();
                    for (int i = 0; i < names.length; i++) {
                         list.add(names[i]);
                    }
              }
         });
    }
}
void main() {
    Display display = new Display();
    (new ClipboardExample()).open(display);
    display.dispose();
}

