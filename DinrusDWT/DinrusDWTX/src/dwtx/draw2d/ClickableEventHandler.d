/*******************************************************************************
 * Copyright (c) 2000, 2005 IBM Corporation and others.
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
module dwtx.draw2d.ClickableEventHandler;

import dwt.dwthelper.utils;
import dwtx.draw2d.MouseMotionListener;
import dwtx.draw2d.MouseEvent;
import dwtx.draw2d.KeyEvent;
import dwtx.draw2d.FocusEvent;
import dwtx.draw2d.KeyListener;
import dwtx.draw2d.FocusListener;
import dwtx.draw2d.IFigure;
import dwtx.draw2d.ChangeEvent;
import dwtx.draw2d.ChangeListener;
import dwtx.draw2d.MouseListener;
import dwtx.draw2d.FigureListener;
import dwtx.draw2d.Clickable;
import dwtx.draw2d.ButtonModel;


class ClickableEventHandler
    : MouseMotionListener.Stub
    ,
        MouseListener,
        FigureListener,
        ChangeListener,
        KeyListener,
        FocusListener
{

private MouseEvent lastEvent;

public void focusLost(FocusEvent fe) {
    Clickable loser = cast(Clickable)fe.loser;
    loser.repaint();
    loser.getModel().setArmed(false);
    loser.getModel().setPressed(false);
}

public void focusGained(FocusEvent fe) {
    Clickable clickable = cast(Clickable)fe.gainer;
    clickable.repaint();
}

public void figureMoved(IFigure source) {
    if (lastEvent is null)
        return;
    mouseDragged(lastEvent);
}

public void handleStateChanged(ChangeEvent change) {
    Clickable clickable = cast(Clickable)change.getSource();
    if (change.getPropertyName() is ButtonModel.MOUSEOVER_PROPERTY
        && !clickable.isRolloverEnabled())
        return;
    clickable.repaint();
}

public void mouseDoubleClicked(MouseEvent me) { }

public void mouseDragged(MouseEvent me) {
    lastEvent = me;
    Clickable click = cast(Clickable)me.getSource();
    ButtonModel model = click.getModel();
    if (model.isPressed()) {
        bool over = click.containsPoint(me.getLocation());
            model.setArmed(over);
            model.setMouseOver(over);
    }
}

public void mouseEntered(MouseEvent me) {
    Clickable click = cast(Clickable)me.getSource();
    click.getModel().setMouseOver(true);
    click.addFigureListener(this);
}

public void mouseExited(MouseEvent me) {
    Clickable click = cast(Clickable)me.getSource();
    click.getModel().setMouseOver(false);
    click.removeFigureListener(this);
}

public void mouseMoved(MouseEvent me) { }

public void mousePressed(MouseEvent me) {
    if (me.button !is 1)
        return;
    lastEvent = me;
    Clickable click = cast(Clickable)me.getSource();
    ButtonModel model = click.getModel();
    click.requestFocus();
    model.setArmed(true);
    model.setPressed(true);
    me.consume();
}

public void mouseReleased(MouseEvent me) {
    if (me.button !is 1)
        return;
    ButtonModel model = (cast(Clickable)me.getSource()).getModel();
    if (!model.isPressed())
        return;
    model.setPressed(false);
    model.setArmed(false);
    me.consume();
}

public void keyPressed(KeyEvent ke) {
    ButtonModel model = (cast(Clickable)ke.getSource()).getModel();
    if (ke.character is ' ' || ke.character is '\r') {
        model.setPressed(true);
        model.setArmed(true);
    }
}

public void keyReleased(KeyEvent ke) {
    ButtonModel model = (cast(Clickable)ke.getSource()).getModel();
    if (ke.character is ' ' || ke.character is '\r') {
        model.setPressed(false);
        model.setArmed(false);
    }
}

}
