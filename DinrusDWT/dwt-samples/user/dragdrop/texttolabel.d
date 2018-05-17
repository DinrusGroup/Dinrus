module user.dragdrop.texttolabel;

/**
 * Original
 * http://www.java2s.com/Tutorial/Java/0280__SWT/DragselectedtextinTexttoLabel.htm
 *
 * Drag sellected text to a label.
 *
 * Port to the D programming language:
 *     Jesse Phillips <Jesse.K.Phillips+D> gmail.com
 *
 */

import dwt.DWT;
import dwt.DWTException;
import dwt.dnd.DND;
import dwt.dnd.DragSource;
import dwt.dnd.DragSourceAdapter;
import dwt.dnd.DragSourceEvent;
import dwt.dnd.DropTarget;
import dwt.dnd.DropTargetAdapter;
import dwt.dnd.DropTargetEvent;
import dwt.dnd.TextTransfer;
import dwt.dnd.Transfer;
import dwt.widgets.Display;
import dwt.widgets.Label;
import dwt.widgets.Shell;
import dwt.widgets.Text;
import dwt.dwthelper.utils;

import tango.io.Stdout;

void main() {
    auto display = new Display();
    auto shell = new Shell(display);

    auto text = new Text(shell, DWT.BORDER|DWT.SINGLE);

    int i = 0;

    auto types = new Transfer[1];
    types[0] = TextTransfer.getInstance();
    auto source = new DragSource(text, DND.DROP_MOVE | DND.DROP_COPY);
    source.setTransfer(types);

    source.addDragListener(new class DragSourceAdapter {
      public void dragSetData(DragSourceEvent event) {
        // Get the selected items in the drag source
        DragSource ds = cast(DragSource) event.widget;
        Text text = cast(Text) ds.getControl();

        event.data = new ArrayWrapperString(text.getSelectionText());
      }
    });

    auto label = new Label(shell, DWT.BORDER);
    // Create the drop target
    auto target = new DropTarget(label, DND.DROP_MOVE | DND.DROP_COPY | DND.DROP_DEFAULT);
    target.setTransfer(types);
    target.addDropListener(new class DropTargetAdapter {
      public void dragEnter(DropTargetEvent event) {
        if (event.detail == DND.DROP_DEFAULT) {
          event.detail = (event.operations & DND.DROP_COPY) != 0 ? DND.DROP_COPY : DND.DROP_NONE;
        }

        // Allow dropping text only
        foreach (dataType; event.dataTypes) {
          if (TextTransfer.getInstance().isSupportedType(dataType)) {
            event.currentDataType = dataType;
          }
        }
      }

      public void dragOver(DropTargetEvent event) {
         event.feedback = DND.FEEDBACK_SELECT | DND.FEEDBACK_SCROLL;
      }
      public void drop(DropTargetEvent event) {
        if (TextTransfer.getInstance().isSupportedType(event.currentDataType)) {
          // Get the dropped data
          DropTarget target = cast(DropTarget) event.widget;
          Label label = cast(Label) target.getControl();
          auto data = cast(ArrayWrapperString) event.data;

          label.setText(data.array);
          label.redraw();
        }
      }
    });

    text.setBounds(10,10,100,25);
    label.setBounds(10,55,100,25);
	 shell.setSize(300, 200);
    shell.open();

    while (!shell.isDisposed()) {
      if (!display.readAndDispatch()) {
        display.sleep();
      }
    }
    display.dispose();
}
