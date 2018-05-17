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
module dwtx.draw2d.SchemeBorder;

import dwt.dwthelper.utils;



import dwt.graphics.Color;
import dwtx.draw2d.geometry.Insets;
import dwtx.draw2d.geometry.Rectangle;
import dwtx.draw2d.IFigure;
import dwtx.draw2d.Border;
import dwtx.draw2d.Graphics;
import dwtx.draw2d.AbstractBorder;
import dwtx.draw2d.ColorConstants;

/**
 * SchemeBorder allows the creation of borders based on
 * {@link SchemeBorder.Scheme Schemes}. A <i>Scheme</i> is a class whose only purpose is
 * to carry border specific information. SchemeBorder renders the border based on the
 * information given by the <i>Scheme</i> set to it.
 */
public class SchemeBorder
    : AbstractBorder
    //, ColorConstants
{

/** The {@link SchemeBorder.Scheme} associated with this SchemeBorder **/
protected Scheme scheme = null;

/** Arrays of Colors, used for shadow or highlight effects **/
private static bool initStaticConsts_done = false;
private static Color[]
    DARKEST_DARKER_,
    LIGHTER_DARKER_,
    DARKER_LIGHTER_;

protected static Color[] DARKEST_DARKER(){
    if( !initStaticConsts_done ) initStaticConsts();
    return DARKEST_DARKER_;
}
protected static Color[] LIGHTER_DARKER(){
    if( !initStaticConsts_done ) initStaticConsts();
    return LIGHTER_DARKER_;
}
protected static Color[] DARKER_LIGHTER(){
    if( !initStaticConsts_done ) initStaticConsts();
    return DARKER_LIGHTER_;
}


static void initStaticConsts(){
    synchronized( SchemeBorder.classinfo ){
        if( !initStaticConsts_done ) {
            DARKEST_DARKER_   = [ColorConstants.buttonDarkest,  ColorConstants.buttonDarker];
            LIGHTER_DARKER_   = [ColorConstants.buttonLightest, ColorConstants.buttonDarker];
            DARKER_LIGHTER_   = [ColorConstants.buttonDarker, ColorConstants.buttonLightest];
            initStaticConsts_done = true;
        }
    }
}

/**
 * Holds a set of information about a border, which can be changed to create a wide range
 * of schemes. Provides support for border opacity, size, highlight side and shadow side
 * colors.
 */
public static class Scheme {
    private Insets insets;
    private bool isOpaque_ = false;

    /** Arrays of Colors, used for highlight and shadow effecsts */
    protected Color[]
        highlight,
        shadow;

    /**
     * Constructs a default border Scheme with no border sides.
     * @since 2.0
     */
    protected this() { }

    /**
     * Constructs a border Scheme with the specified highlight and shadow colors. The size
     * of the border depends on the number of colors passed in for each parameter.
     * Hightlight colors are used in the top and left sides of the border, and Shadow
     * colors are used in the bottom and right sides of the border.
     *
     * @param highlight the hightlight colors
     * @param shadow the shadow colors
     * @since 2.0
     */
    public this(Color[] highlight, Color[] shadow) {
        this.highlight = highlight;
        this.shadow = shadow;
        init();
    }

    /**
     * Constructs a border scheme with the specified colors. The input colors serve as
     * both highlight and shadow colors. The size of the border is the number of colors
     * passed in as input. Hightlight colors are used in the top and left sides of the
     * border, and Shadow colors are used in the bottom and right sides of the border.
     *
     * @param colors the colors to be used for the border
     * @since 2.0
     */
    public this(Color[] colors) {
        highlight = shadow = colors;
        init();
    }

    /**
     * Calculates and returns the Insets for this border Scheme. The calculations depend
     * on the number of colors passed in as input.
     *
     * @return the Insets used by this border
     * @since 2.0
     */
    protected Insets calculateInsets() {
        int tl = getHighlight().length;
        int br = getShadow().length;
        return new Insets(tl, tl, br, br);
    }

    /**
     * Calculates and retuns the opaque state of this border scheme. Returns
     * <code>false</code> if any of the border colors are <code>null</code>. This is done
     * to prevent the appearance of underlying pixels since the border color is
     * <code>null</code>.
     *
     * @return <code>true</code> if this border is opaque
     * @since 2.0
     */
    protected bool calculateOpaque() {
        Color colors [] = getHighlight();
        for (int i = 0; i < colors.length; i++)
            if (colors[i] is null)
                return false;
        colors = getShadow();
        for (int i = 0; i < colors.length; i++)
            if (colors[i] is null)
                return false;
        return true;
    }

    /**
     * Returns the highlight colors of this border scheme as an array of Colors.
     *
     * @return the highlight colors
     * @since 2.0
     */
    protected Color[] getHighlight() {
        return highlight;
    }

    /**
     * Returns the Insets required by this Scheme.
     *
     * @return the Insets
     * @since 2.0
     */
    protected Insets getInsets() {
        return insets;
    }

    /**
     * Returns the shadow colors of this border scheme as an array of Colors.
     *
     * @return the shadow colors
     * @since 2.0
     */
    protected Color[] getShadow() {
        return shadow;
    }

    /**
     * Calculates and initializes the properties of this border scheme.
     *
     * @since 2.0
     */
    protected void init() {
        insets = calculateInsets();
        isOpaque_ = calculateOpaque();
    }

    /**
     * Returns whether this border should be opaque or not.
     *
     * @return <code>true</code> if this border is opaque
     * @since 2.0
     */
    protected bool isOpaque() {
        return isOpaque_;
    }
}

/**
 * Interface which defines some commonly used schemes for the border. These schemes can be
 * given as input to the {@link SchemeBorder SchemeBorder} to generate appropriate borders.
 */
public struct SCHEMES {

    /** Schemes used for shadow and highlight effects **/
    private static bool initStaticConsts_done = false;
    private static Scheme
        BUTTON_CONTRAST_,
        BUTTON_RAISED_,
        BUTTON_PRESSED_,
        RAISED_,
        LOWERED_,
        RIDGED_,
        ETCHED_;

    public static Scheme BUTTON_CONTRAST(){
        if( !initStaticConsts_done ) initStaticConsts();
        return BUTTON_CONTRAST_;
    }
    public static Scheme BUTTON_RAISED(){
        if( !initStaticConsts_done ) initStaticConsts();
        return BUTTON_RAISED_;
    }
    public static Scheme BUTTON_PRESSED(){
        if( !initStaticConsts_done ) initStaticConsts();
        return BUTTON_PRESSED_;
    }
    public static Scheme RAISED(){
        if( !initStaticConsts_done ) initStaticConsts();
        return RAISED_;
    }
    public static Scheme LOWERED(){
        if( !initStaticConsts_done ) initStaticConsts();
        return LOWERED_;
    }
    public static Scheme RIDGED(){
        if( !initStaticConsts_done ) initStaticConsts();
        return RIDGED_;
    }
    public static Scheme ETCHED(){
        if( !initStaticConsts_done ) initStaticConsts();
        return ETCHED_;
    }


    static void initStaticConsts(){
        synchronized( SchemeBorder.classinfo ){
            if( !initStaticConsts_done ) {
                BUTTON_CONTRAST_ = new Scheme(
                    [ColorConstants.button, ColorConstants.buttonLightest],
                    DARKEST_DARKER
                );
                BUTTON_RAISED_ = new Scheme(
                    [ColorConstants.buttonLightest],
                    DARKEST_DARKER
                );
                BUTTON_PRESSED_ = new Scheme(
                    DARKEST_DARKER,
                    [ColorConstants.buttonLightest]
                );
                RAISED_ = new Scheme(
                    [ColorConstants.buttonLightest],
                    [ColorConstants.buttonDarkest]
                );
                LOWERED_ = new Scheme(
                    [ColorConstants.buttonDarkest],
                    [ColorConstants.buttonLightest]
                );
                RIDGED_ = new Scheme(LIGHTER_DARKER, DARKER_LIGHTER);
                ETCHED_ = new Scheme(DARKER_LIGHTER, LIGHTER_DARKER);
                initStaticConsts_done = true;
            }
        }
    }

}

/**
 * Constructs a default SchemeBorder with no scheme defined.
 * @since 2.0
 */
protected this() { }

/**
 * Constructs a SchemeBorder with the Scheme given as input.
 *
 * @param scheme the Scheme to be used by this border
 * @since 2.0
 */
public this(Scheme scheme) {
    setScheme(scheme);
}

/**
 * @see Border#getInsets(IFigure)
 */
public Insets getInsets(IFigure figure) {
    return getScheme().getInsets();
}

/**
 * Returns the scheme used by this border.
 *
 * @return the Scheme used by this border
 * @since 2.0
 */
protected Scheme getScheme() {
    return scheme;
}

/**
 * Returns the opaque state of this border. Returns <code>true</code> indicating that this
 * will fill in the area enclosed by the border.
 *
 * @see Border#isOpaque()
 */
public bool isOpaque() {
    return true;
}

/**
 * Sets the Scheme for this border to the Scheme given as input.
 *
 * @param scheme the Scheme for this border
 * @since 2.0
 */
protected void setScheme(Scheme scheme) {
    this.scheme = scheme;
}

/**
 * @see Border#paint(IFigure, Graphics, Insets)
 */
public void paint(IFigure figure, Graphics g, Insets insets) {
    Color [] tl = scheme.getHighlight();
    Color [] br = scheme.getShadow();

    paint (g, figure, insets, tl, br);
}

/**
 * Paints the border using the information in the set Scheme and the inputs given. Side
 * widths are determined by the number of colors in the Scheme for each side.
 *
 * @param graphics the graphics object
 * @param fig the figure this border belongs to
 * @param insets the insets
 * @param tl the highlight (top/left) colors
 * @param br the shadow (bottom/right) colors
 */
protected void paint(Graphics graphics, IFigure fig,
                        Insets insets, Color[] tl, Color[] br) {
    graphics.setLineWidth(1);
    graphics.setLineStyle(Graphics.LINE_SOLID);
    graphics.setXORMode(false);

    Rectangle rect = getPaintRectangle(fig, insets);

    int top    = rect.y;
    int left   = rect.x;
    int bottom = rect.bottom() - 1;
    int right  = rect.right() - 1;
    Color color;

    for (int i = 0; i < br.length; i++) {
        color = br[i];
        graphics.setForegroundColor(color);
        graphics.drawLine(right - i, bottom - i, right - i, top + i);
        graphics.drawLine(right - i, bottom - i, left + i, bottom - i);
    }

    right--;
    bottom--;

    for (int i = 0; i < tl.length; i++) {
        color = tl[i];
        graphics.setForegroundColor(color);
        graphics.drawLine(left + i, top + i, right - i, top + i);
        graphics.drawLine(left + i, top + i, left + i, bottom - i);
    }
}

}
