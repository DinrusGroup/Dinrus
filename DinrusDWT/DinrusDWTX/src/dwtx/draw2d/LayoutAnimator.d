/*******************************************************************************
 * Copyright (c) 2005 IBM Corporation and others.
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

module dwtx.draw2d.LayoutAnimator;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;

import dwtx.draw2d.geometry.Rectangle;
import dwtx.draw2d.Animator;
import dwtx.draw2d.LayoutListener;
import dwtx.draw2d.IFigure;
import dwtx.draw2d.Animation;

/**
 * Animates the layout of a figure's children. The animator will capture the effects of a
 * layout manager, and then play back the placement of children using linear interpolation
 * for each child's start and end locations.
 * <P>
 * To use an animator, hook it as a layout listener for the figure whose layout is to
 * be animated, by calling {@link IFigure#addLayoutListener(LayoutListener)}. It is not
 * necessary to have an animator for every figure in a composition that is undergoing
 * animation. For example, if a figure without an animator moves during the animation, it
 * will continue to move and layout its children normally during each step of the
 * animation.
 * <P>
 * Animator must be used in conjunction with layouts. If figures are placed manually using
 * <code>setBounds()</code>, the animator may not be able to track and playback the
 * changes that occur.
 *
 * @since 3.2
 */
public class LayoutAnimator : Animator , LayoutListener {

private static LayoutAnimator INSTANCE_;
static LayoutAnimator INSTANCE(){
    if( INSTANCE_ is null ){
        synchronized( LayoutAnimator.classinfo ){
            if( INSTANCE_ is null ){
                INSTANCE_ = new LayoutAnimator();
            }
        }
    }
    assert(INSTANCE_);
    return INSTANCE_;
}

/**
 * Constructs a new Animator. The default instance ({@link #getDefault()}) can be used on
 * all figures being animated.
 *
 * @since 3.2
 */
protected this() { }

/**
 * Returns an object encapsulating the placement of children in a container. This method
 * is called to capture both the initial and final states.
 * @param container the container figure
 * @return the current state
 * @since 3.2
 */
protected Object getCurrentState(IFigure container) {
    Map locations = new HashMap();
    List children = container.getChildren();
    IFigure child;
    for (int i = 0; i < children.size(); i++) {
        child = cast(IFigure)children.get(i);
        locations.put(cast(Object)child, child.getBounds().getCopy());
    }
    return cast(Object)locations;
}

/**
 * Returns the default instance.
 * @return the default instance
 * @since 3.2
 */
public static LayoutAnimator getDefault() {
    return INSTANCE;
}

/**
 * Hooks invalidation in case animation is in progress.
 * @see LayoutListener#invalidate(IFigure)
 */
public final void invalidate(IFigure container) {
    if (Animation.isInitialRecording())
        Animation.hookAnimator(container, this);
}

/**
 * Hooks layout in case animation is in progress.
 * @see dwtx.draw2d.LayoutListener#layout(dwtx.draw2d.IFigure)
 */
public final bool layout(IFigure container) {
    if (Animation.isAnimating())
        return Animation.hookPlayback(container, this);
    return false;
}

/**
 * Plays back the animated layout.
 * @see Animator#playback(IFigure)
 */
protected bool playback(IFigure container) {
    Map initial = cast(Map) Animation.getInitialState(this, container);
    Map ending = cast(Map) Animation.getFinalState(this, container);
    if (initial is null)
        return false;
    List children = container.getChildren();

    float progress = Animation.getProgress();
    float ssergorp = 1 - progress;

    Rectangle rect1, rect2;

    for (int i = 0; i < children.size(); i++) {
        IFigure child = cast(IFigure) children.get(i);
        rect1 = cast(Rectangle)initial.get(cast(Object)child);
        rect2 = cast(Rectangle)ending.get(cast(Object)child);

        //TODO need to change this to hide the figure until the end.
        if (rect1 is null)
            continue;
        child.setBounds(new Rectangle(
            cast(int)Math.round(progress * rect2.x + ssergorp * rect1.x),
            cast(int)Math.round(progress * rect2.y + ssergorp * rect1.y),
            cast(int)Math.round(progress * rect2.width + ssergorp * rect1.width),
            cast(int)Math.round(progress * rect2.height + ssergorp * rect1.height)
        ));
    }
    return true;
}

/**
 * Hooks post layout in case animation is in progress.
 * @see LayoutListener#postLayout(IFigure)
 */
public final void postLayout(IFigure container) {
    if (Animation.isFinalRecording())
        Animation.hookNeedsCapture(container, this);
}

/**
 * This callback is unused. Reserved for possible future use.
 * @see LayoutListener#remove(IFigure)
 */
public final void remove(IFigure child) { }

/**
 * This callback is unused. Reserved for possible future use.
 * @see LayoutListener#setConstraint(IFigure, Object)
 */
public final void setConstraint(IFigure child, Object constraint) { }

}
