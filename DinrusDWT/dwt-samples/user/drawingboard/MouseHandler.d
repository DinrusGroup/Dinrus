/*
 * This class handles events created by the mouse. It will
 * define the area that PaintHandler will use to draw the shape,
 * based on where the mouse was pressed and released.
 *
 * Written by Jesse Phillips <Jesse.K.Phillips+D> gmail.com
 * All code is free with no restrictions
 */
module user.drawingboard.MouseHandler;

import dwt.events.MouseListener;
import dwt.events.MouseMoveListener;
import dwt.events.MouseEvent;

import tango.io.Stdout;

import user.drawingboard.PaintHandler;

/**
 * This class extends the MouseListener and MouseMoveListener.
 * MouseListener requires functions:
 *  mouseDoubleClick(MouseEvent e);
 *  mouseDown(MouseEvent e);
 *  mousePush(MouseEvent e);
 * MouseMoveListener requires function:
 *  mouseMove(MouseEvent e);
 */
class MouseHandler : MouseListener, MouseMoveListener {
    PaintHandler hPaint;
    bool pressed = false;

    /**
     * MouseHandler takes a PaintHandler, which is the class
     * that will handle draw to the screen when needed.
     */
    this(PaintHandler ph) {
        hPaint = ph;
    }

    /**
     * Unused but required by MouseListener interface.
     */
    void mouseDoubleClick(MouseEvent e) {
    }

    /**
     * Sets the start location for where to draw from.
     * Sets pressed to true so it can be known that
     * the mouse is being dragged.
     */
    void mouseDown(MouseEvent e) {
        hPaint.x = e.x;
        hPaint.y = e.y;
        pressed = true;
    }

    /**
     * Sets pressed to fales to turn of dragging.
     */
    void mouseUp(MouseEvent e) {
        pressed = false;
    }

    /**
     * Sets the end location for for the drawing.
     */
    void mouseMove(MouseEvent e) {
        if(pressed) {
            hPaint.xDiff = e.x-hPaint.x;
            hPaint.yDiff = e.y-hPaint.y;
            hPaint.reDraw();
        }
    }
}
