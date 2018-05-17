/*******************************************************************************
 * Copyright (c) 2000, 2008 IBM Corporation and others.
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
module dwtx.jface.text.source.OverviewRulerHoverManager;

import dwtx.jface.text.source.ISharedTextColors; // packageimport
import dwtx.jface.text.source.ILineRange; // packageimport
import dwtx.jface.text.source.IAnnotationPresentation; // packageimport
import dwtx.jface.text.source.IVerticalRulerInfoExtension; // packageimport
import dwtx.jface.text.source.ICharacterPairMatcher; // packageimport
import dwtx.jface.text.source.TextInvocationContext; // packageimport
import dwtx.jface.text.source.LineChangeHover; // packageimport
import dwtx.jface.text.source.IChangeRulerColumn; // packageimport
import dwtx.jface.text.source.IAnnotationMap; // packageimport
import dwtx.jface.text.source.IAnnotationModelListenerExtension; // packageimport
import dwtx.jface.text.source.ISourceViewerExtension2; // packageimport
import dwtx.jface.text.source.IAnnotationHover; // packageimport
import dwtx.jface.text.source.ContentAssistantFacade; // packageimport
import dwtx.jface.text.source.IAnnotationAccess; // packageimport
import dwtx.jface.text.source.IVerticalRulerExtension; // packageimport
import dwtx.jface.text.source.IVerticalRulerColumn; // packageimport
import dwtx.jface.text.source.LineNumberRulerColumn; // packageimport
import dwtx.jface.text.source.MatchingCharacterPainter; // packageimport
import dwtx.jface.text.source.IAnnotationModelExtension; // packageimport
import dwtx.jface.text.source.ILineDifferExtension; // packageimport
import dwtx.jface.text.source.DefaultCharacterPairMatcher; // packageimport
import dwtx.jface.text.source.LineNumberChangeRulerColumn; // packageimport
import dwtx.jface.text.source.IAnnotationAccessExtension; // packageimport
import dwtx.jface.text.source.ISourceViewer; // packageimport
import dwtx.jface.text.source.AnnotationModel; // packageimport
import dwtx.jface.text.source.ILineDifferExtension2; // packageimport
import dwtx.jface.text.source.IAnnotationModelListener; // packageimport
import dwtx.jface.text.source.IVerticalRuler; // packageimport
import dwtx.jface.text.source.DefaultAnnotationHover; // packageimport
import dwtx.jface.text.source.SourceViewer; // packageimport
import dwtx.jface.text.source.SourceViewerConfiguration; // packageimport
import dwtx.jface.text.source.AnnotationBarHoverManager; // packageimport
import dwtx.jface.text.source.CompositeRuler; // packageimport
import dwtx.jface.text.source.ImageUtilities; // packageimport
import dwtx.jface.text.source.VisualAnnotationModel; // packageimport
import dwtx.jface.text.source.IAnnotationModel; // packageimport
import dwtx.jface.text.source.ISourceViewerExtension3; // packageimport
import dwtx.jface.text.source.ILineDiffInfo; // packageimport
import dwtx.jface.text.source.VerticalRulerEvent; // packageimport
import dwtx.jface.text.source.ChangeRulerColumn; // packageimport
import dwtx.jface.text.source.ILineDiffer; // packageimport
import dwtx.jface.text.source.AnnotationModelEvent; // packageimport
import dwtx.jface.text.source.AnnotationColumn; // packageimport
import dwtx.jface.text.source.AnnotationRulerColumn; // packageimport
import dwtx.jface.text.source.IAnnotationHoverExtension; // packageimport
import dwtx.jface.text.source.AbstractRulerColumn; // packageimport
import dwtx.jface.text.source.ISourceViewerExtension; // packageimport
import dwtx.jface.text.source.AnnotationMap; // packageimport
import dwtx.jface.text.source.IVerticalRulerInfo; // packageimport
import dwtx.jface.text.source.IAnnotationModelExtension2; // packageimport
import dwtx.jface.text.source.LineRange; // packageimport
import dwtx.jface.text.source.IAnnotationAccessExtension2; // packageimport
import dwtx.jface.text.source.VerticalRuler; // packageimport
import dwtx.jface.text.source.JFaceTextMessages; // packageimport
import dwtx.jface.text.source.IOverviewRuler; // packageimport
import dwtx.jface.text.source.Annotation; // packageimport
import dwtx.jface.text.source.IVerticalRulerListener; // packageimport
import dwtx.jface.text.source.ISourceViewerExtension4; // packageimport
import dwtx.jface.text.source.AnnotationPainter; // packageimport
import dwtx.jface.text.source.IAnnotationHoverExtension2; // packageimport
import dwtx.jface.text.source.OverviewRuler; // packageimport


import dwt.dwthelper.utils;



import dwt.custom.StyledText;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.widgets.ScrollBar;
import dwtx.jface.text.IInformationControlCreator;

/**
 * This manager controls the layout, content, and visibility of an information
 * control in reaction to mouse hover events issued by the overview ruler of a
 * source viewer.
 *
 * @since 2.1
 */
class OverviewRulerHoverManager : AnnotationBarHoverManager {

    /**
     * Creates an overview hover manager with the given parameters. In addition,
     * the hovers anchor is RIGHT and the margin is 5 points to the right.
     *
     * @param ruler the overview ruler this manager connects to
     * @param sourceViewer the source viewer this manager connects to
     * @param annotationHover the annotation hover providing the information to be displayed
     * @param creator the information control creator
     */
    public this(IOverviewRuler ruler, ISourceViewer sourceViewer, IAnnotationHover annotationHover, IInformationControlCreator creator) {
        super(ruler, sourceViewer, annotationHover, creator);
        setAnchor(ANCHOR_LEFT);
        StyledText textWidget= sourceViewer.getTextWidget();
        if (textWidget !is null) {
            ScrollBar verticalBar= textWidget.getVerticalBar();
            if (verticalBar !is null)
                setMargins(verticalBar.getSize().x, 5);
        }
    }

    /*
     * @see AbstractHoverInformationControlManager#computeInformation()
     */
    protected void computeInformation() {
        Point location= getHoverEventLocation();
        int line= getVerticalRulerInfo().toDocumentLineNumber(location.y);
        IAnnotationHover hover= getAnnotationHover();
        
        IInformationControlCreator controlCreator= null;
        if ( cast(IAnnotationHoverExtension)hover )
            controlCreator= (cast(IAnnotationHoverExtension)hover).getHoverControlCreator();
        setCustomInformationControlCreator(controlCreator);
        
        setInformation(hover.getHoverInfo(getSourceViewer(), line), computeArea(location.y));
    }

    /**
     * Determines graphical area covered for which the hover is valid.
     *
     * @param y y-coordinate in the vertical ruler
     * @return the graphical extend where the hover is valid
     */
    private Rectangle computeArea(int y) {
        // This is OK (see constructor)
        IOverviewRuler overviewRuler= cast(IOverviewRuler) getVerticalRulerInfo();

        int hover_height= overviewRuler.getAnnotationHeight();
        int hover_width= getVerticalRulerInfo().getControl().getSize().x;

        // Calculate y-coordinate for hover
        int hover_y= y;
        bool hasAnnotation= true;
        while (hasAnnotation && hover_y > y - hover_height) {
            hover_y--;
            hasAnnotation= overviewRuler.hasAnnotation(hover_y);
        }
        hover_y++;

        return new Rectangle(0, hover_y, hover_width, hover_height);
    }
}
