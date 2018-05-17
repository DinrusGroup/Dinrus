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
module dwtx.draw2d.Cursors;

import dwt.dwthelper.utils;

import dwt.DWT;
import dwt.graphics.Cursor;
import dwtx.draw2d.PositionConstants;

/**
 * A collection of cursors.
 */
public class Cursors {

/**
 * Returns the cursor corresponding to the given direction, defined in
 * {@link PositionConstants}. Note that {@link #getDirectionalCursor(int, bool)} should
 * be used for applications which want to run properly when running in a mirrored
 * environment. The behavior is the same as calling {@link #getDirectionalCursor(int,
 * bool) getDirectionalCursor(direction, false)}.
 *
 * @param direction the relative direction of the desired cursor
 * @return The appropriate directional cursor
 */
public static Cursor getDirectionalCursor(int direction) {
    return getDirectionalCursor(direction, false);
}

/**
 * Returns the cursor corresponding to the given direction and mirroring. The direction
 * must be one of:
 * <UL>
 *   <LI>{@link PositionConstants#NORTH}
 *   <LI>{@link PositionConstants#SOUTH}
 *   <LI>{@link PositionConstants#EAST}
 *   <LI>{@link PositionConstants#WEST}
 *   <LI>{@link PositionConstants#NORTH_EAST}
 *   <LI>{@link PositionConstants#NORTH_WEST}
 *   <LI>{@link PositionConstants#SOUTH_EAST}
 *   <LI>{@link PositionConstants#SOUTH_WEST}
 * </UL>
 * <P>The behavior is undefined for other values. If <code>isMirrored</code> is set to
 * <code>true</code>, EAST and WEST will be inverted.
 * @param direction the relative direction of the desired cursor
 * @param isMirrored <code>true</code> if EAST and WEST should be inverted
 * @return The appropriate directional cursor
 */
public static Cursor getDirectionalCursor(int direction, bool isMirrored) {
    if (isMirrored && (direction & PositionConstants.EAST_WEST) !is 0)
        direction = direction ^ PositionConstants.EAST_WEST;
    switch (direction) {
        case PositionConstants.NORTH :
            return SIZEN;
        case PositionConstants.SOUTH:
            return SIZES;
        case PositionConstants.EAST :
            return SIZEE;
        case PositionConstants.WEST:
            return SIZEW;
        case PositionConstants.SOUTH_EAST:
            return SIZESE;
        case PositionConstants.SOUTH_WEST:
            return SIZESW;
        case PositionConstants.NORTH_EAST:
            return SIZENE;
        case PositionConstants.NORTH_WEST:
            return SIZENW;
        default:
            break;
    }
    return null;
}

/**
 * @see DWT#CURSOR_ARROW
 */
private static Cursor ARROW_;
public static Cursor ARROW(){
    if( !initStaticCtor_done ) initStaticCtor();
    return ARROW_;
}

/**
 * @see DWT#CURSOR_SIZEN
 */
private static Cursor SIZEN_;
public static Cursor SIZEN(){
    if( !initStaticCtor_done ) initStaticCtor();
    return SIZEN_;
}

/**
 * @see DWT#CURSOR_SIZENE
 */
private static Cursor SIZENE_;
public static Cursor SIZENE(){
    if( !initStaticCtor_done ) initStaticCtor();
    return SIZENE_;
}

/**
 * @see DWT#CURSOR_SIZEE
 */
private static Cursor SIZEE_;
public static Cursor SIZEE(){
    if( !initStaticCtor_done ) initStaticCtor();
    return SIZEE_;
}

/**
 * @see DWT#CURSOR_SIZESE
 */
private static Cursor SIZESE_;
public static Cursor SIZESE(){
    if( !initStaticCtor_done ) initStaticCtor();
    return SIZESE_;
}

/**
 * @see DWT#CURSOR_SIZES
 */
private static Cursor SIZES_;
public static Cursor SIZES(){
    if( !initStaticCtor_done ) initStaticCtor();
    return SIZES_;
}

/**
 * @see DWT#CURSOR_SIZESW
 */
private static Cursor SIZESW_;
public static Cursor SIZESW(){
    if( !initStaticCtor_done ) initStaticCtor();
    return SIZESW_;
}

/**
 * @see DWT#CURSOR_SIZEW
 */
private static Cursor SIZEW_;
public static Cursor SIZEW(){
    if( !initStaticCtor_done ) initStaticCtor();
    return SIZEW_;
}

/**
 * @see DWT#CURSOR_SIZENW
 */
private static Cursor SIZENW_;
public static Cursor SIZENW(){
    if( !initStaticCtor_done ) initStaticCtor();
    return SIZENW_;
}

/**
 * @see DWT#CURSOR_APPSTARTING
 */
private static Cursor APPSTARTING_;
public static Cursor APPSTARTING(){
    if( !initStaticCtor_done ) initStaticCtor();
    return APPSTARTING_;
}

/**
 * @see DWT#CURSOR_CROSS
 */
private static Cursor CROSS_;
public static Cursor CROSS(){
    if( !initStaticCtor_done ) initStaticCtor();
    return CROSS_;
}

/**
 * @see DWT#CURSOR_HAND
 */
private static Cursor HAND_;
public static Cursor HAND(){
    if( !initStaticCtor_done ) initStaticCtor();
    return HAND_;
}

/**
 * @see DWT#CURSOR_HELP
 */
private static Cursor HELP_;
public static Cursor HELP(){
    if( !initStaticCtor_done ) initStaticCtor();
    return HELP_;
}

/**
 * @see DWT#CURSOR_IBEAM
 */
private static Cursor IBEAM_;
public static Cursor IBEAM(){
    if( !initStaticCtor_done ) initStaticCtor();
    return IBEAM_;
}

/**
 * @see DWT#CURSOR_NO
 */
private static Cursor NO_;
public static Cursor NO(){
    if( !initStaticCtor_done ) initStaticCtor();
    return NO_;
}

/**
 * @see DWT#CURSOR_SIZEALL
 */
private static Cursor SIZEALL_;
public static Cursor SIZEALL(){
    if( !initStaticCtor_done ) initStaticCtor();
    return SIZEALL_;
}

/**
 * @see DWT#CURSOR_SIZENESW
 */
private static Cursor SIZENESW_;
public static Cursor SIZENESW(){
    if( !initStaticCtor_done ) initStaticCtor();
    return SIZENESW_;
}

/**
 * @see DWT#CURSOR_SIZENWSE
 */
private static Cursor SIZENWSE_;
public static Cursor SIZENWSE(){
    if( !initStaticCtor_done ) initStaticCtor();
    return SIZENWSE_;
}

/**
 * @see DWT#CURSOR_SIZEWE
 */
private static Cursor SIZEWE_;
public static Cursor SIZEWE(){
    if( !initStaticCtor_done ) initStaticCtor();
    return SIZEWE_;
}

/**
 * @see DWT#CURSOR_SIZENS
 */
private static Cursor SIZENS_;
public static Cursor SIZENS(){
    if( !initStaticCtor_done ) initStaticCtor();
    return SIZENS_;
}

/**
 * @see DWT#CURSOR_UPARROW
 */
private static Cursor UPARROW_;
public static Cursor UPARROW(){
    if( !initStaticCtor_done ) initStaticCtor();
    return UPARROW_;
}

/**
 * @see DWT#CURSOR_WAIT
 */
private static Cursor WAIT_;
public static Cursor WAIT(){
    if( !initStaticCtor_done ) initStaticCtor();
    return WAIT_;
}

private static bool initStaticCtor_done = false;
private static void initStaticCtor() {
    synchronized(Cursor.classinfo){
        if(!initStaticCtor_done){
            ARROW_        = new Cursor(null, DWT.CURSOR_ARROW);
            SIZEN_        = new Cursor(null, DWT.CURSOR_SIZEN);
            SIZENE_       = new Cursor(null, DWT.CURSOR_SIZENE);
            SIZEE_        = new Cursor(null, DWT.CURSOR_SIZEE);
            SIZESE_       = new Cursor(null, DWT.CURSOR_SIZESE);
            SIZES_        = new Cursor(null, DWT.CURSOR_SIZES);
            SIZESW_       = new Cursor(null, DWT.CURSOR_SIZESW);
            SIZEW_        = new Cursor(null, DWT.CURSOR_SIZEW);
            SIZENW_       = new Cursor(null, DWT.CURSOR_SIZENW);
            SIZENS_       = new Cursor(null, DWT.CURSOR_SIZENS);
            SIZEWE_       = new Cursor(null, DWT.CURSOR_SIZEWE);
            APPSTARTING_  = new Cursor(null, DWT.CURSOR_APPSTARTING);
            CROSS_        = new Cursor(null, DWT.CURSOR_CROSS);
            HAND_         = new Cursor(null, DWT.CURSOR_HAND);
            HELP_         = new Cursor(null, DWT.CURSOR_HELP);
            IBEAM_        = new Cursor(null, DWT.CURSOR_IBEAM);
            NO_           = new Cursor(null, DWT.CURSOR_NO);
            SIZEALL_      = new Cursor(null, DWT.CURSOR_SIZEALL);
            SIZENESW_     = new Cursor(null, DWT.CURSOR_SIZENESW);
            SIZENWSE_     = new Cursor(null, DWT.CURSOR_SIZENWSE);
            UPARROW_      = new Cursor(null, DWT.CURSOR_UPARROW);
            WAIT_         = new Cursor(null, DWT.CURSOR_WAIT);
            initStaticCtor_done = true;
        }
    }
}

}
