/*******************************************************************************
 * Copyright (c) 2005, 2006 IBM Corporation and others.
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
module dwtx.jface.layout.LayoutGenerator;

import dwtx.jface.layout.GridDataFactory;
import dwtx.jface.layout.LayoutConstants;

import dwt.DWT;
import dwt.events.ModifyListener;
import dwt.graphics.Point;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Button;
import dwt.widgets.Composite;
import dwt.widgets.Control;
import dwt.widgets.Layout;
import dwt.widgets.Scrollable;
import dwtx.jface.util.Geometry;

import dwt.dwthelper.utils;
import tango.text.convert.Format;

/* package */class LayoutGenerator {

    /**
     * Default size for controls with varying contents
     */
    private static const Point defaultSize;

    /**
     * Default wrapping size for wrapped labels
     */
    private static const int wrapSize = 350;

    private static const GridDataFactory nonWrappingLabelData;

    static this(){
        defaultSize = new Point(150, 150);
        nonWrappingLabelData = GridDataFactory.fillDefaults().align_(DWT.BEGINNING, DWT.CENTER).grab(false, false);
    }

    private static bool hasStyle(Control c, int style) {
        return (c.getStyle() & style) !is 0;
    }

    /**
     * Generates a GridLayout for the given composite by examining its child
     * controls and attaching layout data to any immediate children that do not
     * already have layout data.
     *
     * @param toGenerate
     *            composite to generate a layout for
     */
    public static void generateLayout(Composite toGenerate) {
        Control[] children = toGenerate.getChildren();

        for (int i = 0; i < children.length; i++) {
            Control control = children[i];

            // Skip any children that already have layout data
            if (control.getLayoutData() !is null) {
                continue;
            }

            applyLayoutDataTo(control);
        }
    }

    private static void applyLayoutDataTo(Control control) {
        defaultsFor(control).applyTo(control);
    }

    /**
     * Creates default factory for this control types:
     * <ul>
     *  <li>{@link Button} with {@link DWT#CHECK}</li>
     *  <li>{@link Button}</li>
     *  <li>{@link Composite}</li>
     * </ul>
     * @param control the control the factory is search for
     * @return a default factory for the control
     */
    public static GridDataFactory defaultsFor(Control control) {
        if ( auto button = cast(Button) control ) {

            if (hasStyle(button, DWT.CHECK)) {
                return nonWrappingLabelData.copy();
            } else {
                return GridDataFactory.fillDefaults().align_(DWT.FILL, DWT.CENTER).hint(Geometry.max(button.computeSize(DWT.DEFAULT, DWT.DEFAULT, true), LayoutConstants.getMinButtonSize()));
            }
        }

        if (auto scrollable = cast(Scrollable) control ) {

            if ( auto composite = cast(Composite) scrollable ) {

                Layout theLayout = composite.getLayout();
                if ( cast(GridLayout) theLayout ) {
                    bool growsHorizontally = false;
                    bool growsVertically = false;

                    Control[] children = composite.getChildren();
                    for (int i = 0; i < children.length; i++) {
                        Control child = children[i];

                        GridData data = cast(GridData) child.getLayoutData();

                        if (data !is null) {
                            if (data.grabExcessHorizontalSpace) {
                                growsHorizontally = true;
                            }
                            if (data.grabExcessVerticalSpace) {
                                growsVertically = true;
                            }
                        }
                    }

                    return GridDataFactory.fillDefaults().grab(growsHorizontally, growsVertically);
                }
            }
        }

        bool wrapping = hasStyle(control, DWT.WRAP);

        // Assume any control with the H_SCROLL or V_SCROLL flags are
        // horizontally or vertically
        // scrollable, respectively.
        bool hScroll = hasStyle(control, DWT.H_SCROLL);
        bool vScroll = hasStyle(control, DWT.V_SCROLL);

        bool containsText = hasMethodSetText(control);//, "setText", [ ArrayWrapperString.classinfo ] ); //$NON-NLS-1$

        // If the control has a setText method, an addModifyListener method, and
        // does not have
        // the DWT.READ_ONLY flag, assume it contains user-editable text.
        bool userEditable = !hasStyle(control, DWT.READ_ONLY) && containsText && hasMethodAddModifyListener(control);//, "addModifyListener", [ ModifyListener.classinfo ]); //$NON-NLS-1$

        // For controls containing user-editable text...
        if (userEditable) {
            if (hasStyle(control, DWT.MULTI)) {
                vScroll = true;
            }

            if (!wrapping) {
                hScroll = true;
            }
        }

        // Compute the horizontal hint
        int hHint = DWT.DEFAULT;
        bool grabHorizontal = hScroll;

        // For horizontally-scrollable controls, override their horizontal
        // preferred size
        // with a constant
        if (hScroll) {
            hHint = defaultSize.x;
        } else {
            // For wrapping controls, there are two cases.
            // 1. For controls that contain text (like wrapping labels,
            // read-only text boxes,
            // etc.) override their preferred size with the preferred wrapping
            // point and
            // make them grab horizontal space.
            // 2. For non-text controls (like wrapping toolbars), assume that
            // their non-wrapped
            // size is best.

            if (wrapping) {
                if (containsText) {
                    hHint = wrapSize;
                    grabHorizontal = true;
                }
            }
        }

        int vAlign = DWT.FILL;

        // Heuristic for labels: Controls that contain non-wrapping read-only
        // text should be
        // center-aligned rather than fill-aligned
        if (!vScroll && !wrapping && !userEditable && containsText) {
            vAlign = DWT.CENTER;
        }

        return GridDataFactory.fillDefaults().grab(grabHorizontal, vScroll).align_(DWT.FILL, vAlign).hint(hHint, vScroll ? defaultSize.y : DWT.DEFAULT);
    }

    struct ControlInfo {
        char[] name;
        bool   hasSetText;
        bool   hasAddModifierListener;
    }
    static ControlInfo[] controlInfo = [
        { "dwt.custom.CBanner.CBanner", false, false },
        { "dwt.custom.CCombo.CCombo", true, true },
        { "dwt.custom.CLabel.CLabel", true, false },
        { "dwt.custom.CTabFolder.CTabFolder", false, false },
        { "dwt.custom.SashForm.SashForm", false, false },
        { "dwt.custom.ScrolledComposite.ScrolledComposite", false, false },
        { "dwt.custom.StyledText.StyledText", true, true },
        { "dwt.custom.TableCursor.TableCursor", false, false },
        { "dwt.custom.TableTree.TableTree", false, false },
        { "dwt.custom.ViewForm.ViewForm", false, false },
        { "dwt.opengl.GLCanvas.GLCanvas", false, false },
        { "dwt.widgets.Button.Button", true, false },
        { "dwt.widgets.Canvas.Canvas", false, false },
        { "dwt.widgets.Combo.Combo", true, true },
        { "dwt.widgets.Composite.Composite", false, false },
        { "dwt.widgets.Control.Control", false, false },
        { "dwt.widgets.CoolBar.CoolBar", false, false },
        { "dwt.widgets.DateTime.DateTime", false, false },
        { "dwt.widgets.Decorations.Decorations", true, false },
        { "dwt.widgets.ExpandBar.ExpandBar", false, false },
        { "dwt.widgets.Group.Group", true, false },
        { "dwt.widgets.Label.Label", true, false },
        { "dwt.widgets.Link.Link", true, false },
        { "dwt.widgets.List.List", false, false },
        { "dwt.widgets.ProgressBar.ProgressBar", false, false },
        { "dwt.widgets.Sash.Sash", false, false },
        { "dwt.widgets.Scale.Scale", false, false },
        { "dwt.widgets.Scrollable.Scrollable", false, false },
        { "dwt.widgets.Shell.Shell", true, false },
        { "dwt.widgets.Slider.Slider", false, false },
        { "dwt.widgets.Spinner.Spinner", false, true },
        { "dwt.widgets.TabFolder.TabFolder", false, false },
        { "dwt.widgets.Table.Table", false, false },
        { "dwt.widgets.Text.Text", true, true },
        { "dwt.widgets.ToolBar.ToolBar", false, false },
        { "dwt.widgets.Tree.Tree", false, false },
    ];
    private static bool hasMethodSetText(Control control) {
        char[] name = control.classinfo.name;
        foreach( ci; controlInfo ){
            if( ci.name == name ){
                return ci.hasSetText;
            }
        }
        throw new Exception( Format( "{}:{} Control was not found for reflection info: {}", __FILE__, __LINE__, name ));
    }
    private static bool hasMethodAddModifyListener(Control control) {
        char[] name = control.classinfo.name;
        foreach( ci; controlInfo ){
            if( ci.name == name ){
                return ci.hasAddModifierListener;
            }
        }
        throw new Exception( Format( "{}:{} Control was not found for reflection info: {}", __FILE__, __LINE__, name ));
    }
//    private static bool hasMethod(Control control, String name, ClassInfo[] parameterTypes) {
//        ClassInfo c = control.classinfo;
//        implMissing(__FILE__,__LINE__);
//        pragma(msg, "FIXME dwtx.jface.layout.LayoutGenerator hasMethod reflection" );
//        return true;
///+        try {
//            return c.getMethod(name, parameterTypes) !is null;
//        } catch (SecurityException e) {
//            return false;
//        } catch (NoSuchMethodException e) {
//            return false;
//        }+/
//    }
}
