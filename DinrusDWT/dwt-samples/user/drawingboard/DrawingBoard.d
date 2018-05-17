/*
 * This example is meant to let the user have a area to draw simple shapes.
 * It uses the FillLayout layout manager.
 * For information on layout managers an excellent read is:
 * http://www.eclipse.org/articles/Article-Understanding-Layouts/Understanding-Layouts.htm
 *
 * Written by Jesse Phillips <Jesse.K.Phillips+D> gmail.com
 * All code is free with no restrictions
 */

module user.drawingboard.DrawingBoard;

import dwt.DWT;
import dwt.events.MouseListener;
import dwt.events.MouseMoveListener;
import dwt.events.PaintListener;
import dwt.events.SelectionListener;
import dwt.events.SelectionEvent;
import dwt.layout.FillLayout;
import dwt.widgets.Button;
import dwt.widgets.Canvas;
import dwt.widgets.Control;
import dwt.widgets.Display;
import dwt.widgets.Group;
import dwt.widgets.Menu;
import dwt.widgets.MenuItem;
import dwt.widgets.Shell;

import tango.io.Stdout;

import user.drawingboard.MouseHandler;
import user.drawingboard.PaintHandler;

void main(){
    try{
        auto display = new Display();
        auto shell = new Shell(display);
        auto layout = new FillLayout();
        shell.setSize(500, 500);
        shell.setText("Draw window");
        shell.setLayout(layout);

        auto menu = new Menu(shell, DWT.BAR);
        auto colorMenuHeader = new MenuItem(menu, DWT.CASCADE);
        colorMenuHeader.setText("&Color");
        auto colorMenu = new Menu(shell, DWT.DROP_DOWN);
        colorMenuHeader.setMenu(colorMenu);

        MenuItem[3] colors; 
        colors[0] = new MenuItem(colorMenu, DWT.RADIO);
        colors[0].setText("&Red");
        colors[1] = new MenuItem(colorMenu, DWT.RADIO);
        colors[1].setText("&Green");
        colors[2] = new MenuItem(colorMenu, DWT.RADIO);
        colors[2].setText("&Blue");

        auto shapeMenuHeader = new MenuItem(menu, DWT.CASCADE);
        shapeMenuHeader.setText("&Shape");
        auto shapeMenu = new Menu(shell, DWT.DROP_DOWN);
        shapeMenuHeader.setMenu(shapeMenu);

        MenuItem[3] shapes;
        shapes[0] = new MenuItem(shapeMenu, DWT.RADIO);
        shapes[0].setText("&Rectangle");
        shapes[0].setSelection(true);
        shapes[1] = new MenuItem(shapeMenu, DWT.RADIO);
        shapes[1].setText("&Oval");
        shapes[2] = new MenuItem(shapeMenu, DWT.RADIO);
        shapes[2].setText("S&quare");

        MenuItem fill = new MenuItem(shapeMenu, DWT.CHECK);
        fill.setText("&Fill");

        auto canvas = new Canvas(shell,DWT.NO_REDRAW_RESIZE);
        auto hPaint= new PaintHandler(canvas, display, colors, shapes, fill);
        auto hMouse = new MouseHandler(hPaint);

        canvas.addPaintListener(hPaint);
        canvas.addMouseListener(hMouse);
        canvas.addMouseMoveListener(hMouse);

        shell.setMenuBar(menu);

        shell.open();
        while (!shell.isDisposed()) {
            if (!display.readAndDispatch()) {
                display.sleep();
            }
        }
    } catch (Exception e) {
        Stdout.formatln (e.toString);
    }
}
