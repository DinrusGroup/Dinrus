/*******************************************************************************
 * Copyright (c) 2000, 2006 IBM Corporation and others.
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
module dwtx.jface.text.source.projection.ProjectionAnnotation;

import dwtx.jface.text.source.projection.ProjectionViewer; // packageimport
import dwtx.jface.text.source.projection.ProjectionSupport; // packageimport
import dwtx.jface.text.source.projection.IProjectionPosition; // packageimport
import dwtx.jface.text.source.projection.AnnotationBag; // packageimport
import dwtx.jface.text.source.projection.ProjectionSummary; // packageimport
import dwtx.jface.text.source.projection.ProjectionAnnotationHover; // packageimport
import dwtx.jface.text.source.projection.ProjectionRulerColumn; // packageimport
import dwtx.jface.text.source.projection.ProjectionAnnotationModel; // packageimport
import dwtx.jface.text.source.projection.SourceViewerInformationControl; // packageimport
import dwtx.jface.text.source.projection.IProjectionListener; // packageimport


import dwt.dwthelper.utils;




import dwt.DWT;
import dwt.graphics.FontMetrics;
import dwt.graphics.GC;
import dwt.graphics.Image;
import dwt.graphics.Rectangle;
import dwt.widgets.Canvas;
import dwt.widgets.Display;
import dwtx.jface.resource.ImageDescriptor;
import dwtx.jface.text.source.Annotation;
import dwtx.jface.text.source.IAnnotationPresentation;
import dwtx.jface.text.source.ImageUtilities;

/**
 * Annotation used to represent the projection of a master document onto a
 * {@link dwtx.jface.text.projection.ProjectionDocument}. A projection
 * annotation can be either expanded or collapsed. If expanded it corresponds to
 * a segment of the projection document. If collapsed, it represents a region of
 * the master document that does not have a corresponding segment in the
 * projection document.
 * <p>
 * Clients may subclass or use as is.
 * </p>
 *
 * @since 3.0
 */
public class ProjectionAnnotation : Annotation , IAnnotationPresentation {

    private static class DisplayDisposeRunnable : Runnable {

        public void run() {
            if (fgCollapsedImage !is null) {
                fgCollapsedImage.dispose();
                fgCollapsedImage= null;
            }
            if (fgExpandedImage !is null) {
                fgExpandedImage.dispose();
                fgExpandedImage= null;
            }
        }
    }

    /**
     * The type of projection annotations.
     */
    public static const String TYPE= "dwtx.projection"; //$NON-NLS-1$


    private static const int COLOR= DWT.COLOR_GRAY;
    private static Image fgCollapsedImage;
    private static Image fgExpandedImage;


    /** The state of this annotation */
    private bool fIsCollapsed= false;
    /** Indicates whether this annotation should be painted as range */
    private bool fIsRangeIndication= false;

    /**
     * Creates a new expanded projection annotation.
     */
    public this() {
        this(false);
    }

    /**
     * Creates a new projection annotation. When <code>isCollapsed</code>
     * is <code>true</code> the annotation is initially collapsed.
     *
     * @param isCollapsed <code>true</code> if the annotation should initially be collapsed, <code>false</code> otherwise
     */
    public this(bool isCollapsed) {
        super(TYPE, false, null);
        fIsCollapsed= isCollapsed;
    }

    /**
     * Enables and disables the range indication for this annotation.
     *
     * @param rangeIndication the enable state for the range indication
     */
    public void setRangeIndication(bool rangeIndication) {
        fIsRangeIndication= rangeIndication;
    }

    private void drawRangeIndication(GC gc, Canvas canvas, Rectangle r) {
        final int MARGIN= 3;

        /* cap the height - at least on GTK, large numbers are converted to
         * negatives at some point */
        int height= Math.min(r.y + r.height - MARGIN, canvas.getSize().y);

        gc.setForeground(canvas.getDisplay().getSystemColor(COLOR));
        gc.setLineWidth(0); // NOTE: 0 means width is 1 but with optimized performance
        gc.drawLine(r.x + 4, r.y + 12, r.x + 4, height);
        gc.drawLine(r.x + 4, height, r.x + r.width - MARGIN, height);
    }

    /*
     * @see dwtx.jface.text.source.IAnnotationPresentation#paint(dwt.graphics.GC, dwt.widgets.Canvas, dwt.graphics.Rectangle)
     */
    public void paint(GC gc, Canvas canvas, Rectangle rectangle) {
        Image image= getImage(canvas.getDisplay());
        if (image !is null) {
            ImageUtilities.drawImage(image, gc, canvas, rectangle, DWT.CENTER, DWT.TOP);
            if (fIsRangeIndication) {
                FontMetrics fontMetrics= gc.getFontMetrics();
                int delta= (fontMetrics.getHeight() - image.getBounds().height)/2;
                rectangle.y += delta;
                rectangle.height -= delta;
                drawRangeIndication(gc, canvas, rectangle);
            }
        }
    }

    /*
     * @see dwtx.jface.text.source.IAnnotationPresentation#getLayer()
     */
    public int getLayer() {
        return IAnnotationPresentation.DEFAULT_LAYER;
    }

    private Image getImage(Display display) {
        initializeImages(display);
        return isCollapsed() ? fgCollapsedImage : fgExpandedImage;
    }

    private void initializeImages(Display display) {
        if (fgCollapsedImage is null) {
            ImageDescriptor descriptor= ImageDescriptor.createFromFile( getImportData!("dwtx.jface.text.source.projection.collapsed.gif")); //$NON-NLS-1$
            fgCollapsedImage= descriptor.createImage(display);
            descriptor= ImageDescriptor.createFromFile( getImportData!( "dwtx.jface.text.source.projection.expanded.gif")); //$NON-NLS-1$
            fgExpandedImage= descriptor.createImage(display);

            display.disposeExec(new DisplayDisposeRunnable());
        }
    }

    /**
     * Returns the state of this annotation.
     *
     * @return <code>true</code> if collapsed
     */
    public bool isCollapsed() {
        return fIsCollapsed;
    }

    /**
     * Marks this annotation as being collapsed.
     */
    public void markCollapsed() {
        fIsCollapsed= true;
    }

    /**
     * Marks this annotation as being unfolded.
     */
    public void markExpanded() {
        fIsCollapsed= false;
    }
}
