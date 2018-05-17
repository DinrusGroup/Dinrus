/*
 * This class handles draw requests. When the event fires
 * it will use the GC (graphics context) to draw the shape
 * defined by the events handled in MouseHandler.
 * For more on the GC visit:
 * http://www.eclipse.org/articles/Article-SWT-graphics/SWT_graphics.html
 *
 * Written by Jesse Phillips <Jesse.K.Phillips+D> gmail.com
 * All code is free with no restrictions
 */
module user.drawingboard.PaintHandler;

import dwt.DWT;
import dwt.events.PaintListener;
import dwt.widgets.Button;
import dwt.widgets.Canvas;
import dwt.widgets.Display;
import dwt.widgets.MenuItem;

import dwt.graphics.GC;
import dwt.graphics.Rectangle;

import tango.io.Stdout;

/**
 * This class extends the PaintListener interface.
 * PaintListener requires one function:
 *  paintControl(PaintEvent e)
 */
class PaintHandler : PaintListener {
    public int x, y, xDiff, yDiff;
    Canvas canvas;
    Display display;
    MenuItem[] colors, shapes;
    MenuItem fill;

    this(Canvas can, Display d, MenuItem[] co, MenuItem[] s, MenuItem f) {
        canvas = can;
        display = d;
        colors = co;
        shapes = s;
        fill = f;
    }

    /**
     * Used to draw the defined shape to a canvas.
     * It will change the color and shape based on the
     * options set by the other widgets.
     */
    public void paintControl(PaintEvent e) {
         Rectangle clientArea = canvas.getClientArea();

            /*
             * Decide what the color will be
             */
            auto color = display.getSystemColor(DWT.COLOR_CYAN);
            if(colors[0].getSelection()) {
                color = display.getSystemColor(DWT.COLOR_RED);
            } else if(colors[1].getSelection()) {
                color = display.getSystemColor(DWT.COLOR_GREEN);
            } else if(colors[2].getSelection())
                color = display.getSystemColor(DWT.COLOR_BLUE);
                
         e.gc.setBackground(color);
         e.gc.setForeground(color);

            /*
             * Decide what is to be drawn
             */
            if(fill.getSelection()) {
                mixin(buildShape!("fill"));
            } else
                mixin(buildShape!("draw"));

                
   }

    public void reDraw() {
        canvas.redraw();
    }

    private static int abs(int val) {
        return val < 0 ? -val : val;
    }

    template buildShape(char[] pre) {
        const char[] buildShape = "
            if(shapes[0].getSelection()) {
                e.gc." ~ pre ~ "RoundRectangle(x,y,xDiff,yDiff,50,50);
            } else if(shapes[1].getSelection()) {
                e.gc." ~ pre ~ "Oval(x,y,xDiff,yDiff);
            } else if(shapes[2].getSelection())
                e.gc." ~ pre ~
                      "Rectangle(x,y,abs(xDiff)>abs(yDiff)?xDiff:yDiff,
                                     abs(xDiff)>abs(yDiff)?xDiff:yDiff);";
    }
        

}
