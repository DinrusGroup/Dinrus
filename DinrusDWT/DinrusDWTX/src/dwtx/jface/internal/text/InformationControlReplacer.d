/*******************************************************************************
 * Copyright (c) 2008 IBM Corporation and others.
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
module dwtx.jface.internal.text.InformationControlReplacer;

import dwtx.jface.internal.text.NonDeletingPositionUpdater; // packageimport
import dwtx.jface.internal.text.InternalAccessor; // packageimport
import dwtx.jface.internal.text.StickyHoverManager; // packageimport
import dwtx.jface.internal.text.TableOwnerDrawSupport; // packageimport
import dwtx.jface.internal.text.DelayedInputChangeListener; // packageimport


import dwt.dwthelper.utils;



import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.widgets.Shell;
import dwtx.jface.text.AbstractInformationControlManager;
import dwtx.jface.text.AbstractReusableInformationControlCreator;
import dwtx.jface.text.DefaultInformationControl;
import dwtx.jface.text.IInformationControl;
import dwtx.jface.text.IInformationControlCreator;
import dwtx.jface.text.IInformationControlExtension2;
import dwtx.jface.text.IInformationControlExtension3;
import dwtx.jface.util.Geometry;


/**
 * An information control replacer can replace an
 * {@link AbstractInformationControlManager}'s control.
 *
 * @see AbstractInformationControlManager#setInformationControlReplacer(InformationControlReplacer)
 * @since 3.4
 */
public class InformationControlReplacer : AbstractInformationControlManager {
    alias AbstractInformationControlManager.showInformationControl showInformationControl;
    /**
     * Minimal width in pixels.
     */
    private static const int MIN_WIDTH= 80;
    /**
     * Minimal height in pixels.
     */
    private static const int MIN_HEIGHT= 50;

    /**
     * Default control creator.
     */
    protected static class DefaultInformationControlCreator : AbstractReusableInformationControlCreator {
        public IInformationControl doCreateInformationControl(Shell shell) {
            return new DefaultInformationControl(shell, true);
        }
    }

    private bool fIsReplacing;
    private Object fReplacableInformation;
    private bool fDelayedInformationSet;
    private Rectangle fReplaceableArea;
    private Rectangle fContentBounds;


    /**
     * Creates a new information control replacer.
     *
     * @param creator the default information control creator
     */
    public this(IInformationControlCreator creator) {
        super(creator);
        takesFocusWhenVisible(false);
    }

    /**
     * Replace the information control.
     *
     * @param informationPresenterControlCreator the information presenter control creator
     * @param contentBounds the bounds of the content area of the information control
     * @param information the information to show
     * @param subjectArea the subject area
     * @param takeFocus <code>true</code> iff the replacing information control should take focus
     */
    public void replaceInformationControl(IInformationControlCreator informationPresenterControlCreator, Rectangle contentBounds, Object information, Rectangle subjectArea, bool takeFocus) {

        try {
            fIsReplacing= true;
            if (! fDelayedInformationSet)
                fReplacableInformation= information;
            else
                takeFocus= true; // delayed input has been set, so the original info control must have been focused
            fContentBounds= contentBounds;
            fReplaceableArea= subjectArea;

            setCustomInformationControlCreator(informationPresenterControlCreator);

            takesFocusWhenVisible(takeFocus);

            showInformation();
        } finally {
            fIsReplacing= false;
            fReplacableInformation= null;
            fDelayedInformationSet= false;
            fReplaceableArea= null;
            setCustomInformationControlCreator(null);
        }
    }

    /*
     * @see dwtx.jface.text.AbstractInformationControlManager#computeInformation()
     */
    protected void computeInformation() {
        if (fIsReplacing && fReplacableInformation !is null) {
            setInformation(fReplacableInformation, fReplaceableArea);
            return;
        }

        if (DEBUG)
            System.out_.println("InformationControlReplacer: no active replaceable"); //$NON-NLS-1$
    }

    /**
     * Opens the information control with the given information and the specified
     * subject area. It also activates the information control closer.
     *
     * @param subjectArea the information area
     * @param information the information
     */
    public void showInformationControl(Rectangle subjectArea, Object information) {
        IInformationControl informationControl= getInformationControl();

        Rectangle controlBounds= fContentBounds;
        if ( cast(IInformationControlExtension3)informationControl ) {
            IInformationControlExtension3 iControl3= cast(IInformationControlExtension3) informationControl;
            Rectangle trim= iControl3.computeTrim();
            controlBounds= Geometry.add(controlBounds, trim);

            /*
             * Ensure minimal size. Interacting with a tiny information control
             * (resizing, selecting text) would be a pain.
             */
            controlBounds.width= Math.max(controlBounds.width, MIN_WIDTH);
            controlBounds.height= Math.max(controlBounds.height, MIN_HEIGHT);

            getInternalAccessor().cropToClosestMonitor(controlBounds);
        }

        Point location= Geometry.getLocation(controlBounds);
        Point size= Geometry.getSize(controlBounds);

        // Caveat: some IInformationControls fail unless setSizeConstraints(..) is called with concrete values
        informationControl.setSizeConstraints(size.x, size.y);

        if ( cast(IInformationControlExtension2)informationControl )
            (cast(IInformationControlExtension2) informationControl).setInput(information);
        else
            informationControl.setInformation(information.toString());

        informationControl.setLocation(location);
        informationControl.setSize(size.x, size.y);

        showInformationControl(subjectArea);
    }

    /*
     * @see dwtx.jface.text.AbstractInformationControlManager#hideInformationControl()
     */
    public void hideInformationControl() {
        super.hideInformationControl();
    }

    /**
     * @param input the delayed input, or <code>null</code> to request cancellation
     */
    public void setDelayedInput(Object input) {
        fReplacableInformation= input;
        if (! isReplacing()) {
            fDelayedInformationSet= true;
        } else if (cast(IInformationControlExtension2)getCurrentInformationControl2() ) {
            (cast(IInformationControlExtension2) getCurrentInformationControl2()).setInput(input);
        } else if (getCurrentInformationControl2() !is null) {
            getCurrentInformationControl2().setInformation(input.toString());
        }
    }

    /**
     * Tells whether the replacer is currently replacing another information control.
     *
     * @return <code>true</code> while code from {@link #replaceInformationControl(IInformationControlCreator, Rectangle, Object, Rectangle, bool)} is run
     */
    public bool isReplacing() {
        return fIsReplacing;
    }

    /**
     * @return the current information control, or <code>null</code> if none available
     */
    public IInformationControl getCurrentInformationControl2() {
        return getInternalAccessor().getCurrentInformationControl();
    }

    /**
     * The number of pixels to blow up the keep-up zone.
     *
     * @return the margin in pixels
     */
    public int getKeepUpMargin() {
        return 15;
    }
}
