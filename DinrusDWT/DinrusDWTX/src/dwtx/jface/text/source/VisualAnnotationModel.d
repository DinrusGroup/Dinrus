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
module dwtx.jface.text.source.VisualAnnotationModel;

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
import dwtx.jface.text.source.OverviewRulerHoverManager; // packageimport


import dwt.dwthelper.utils;


import dwtx.dwtxhelper.Collection;


import dwtx.jface.text.IDocument;
import dwtx.jface.text.Position;



/**
 * Annotation model for visual annotations. Assume a viewer's input element is annotated with
 * some semantic annotation such as a breakpoint and that it is simultaneously shown in multiple
 * viewers. A source viewer, e.g., supports visual range indication for which it utilizes
 * annotations. The range indicating annotation is specific to the visual presentation
 * of the input element in this viewer and thus should only be visible in this viewer. The
 * breakpoints however are independent from the input element's presentation and thus should
 * be shown in all viewers in which the element is shown. As a viewer supports one vertical
 * ruler which is based on one annotation model, there must be a visual annotation model for
 * each viewer which all wrap the same element specific model annotation model.
 */
class VisualAnnotationModel : AnnotationModel , IAnnotationModelListener {

    /** The wrapped model annotation model */
    private IAnnotationModel fModel;

    /**
     * Constructs a visual annotation model which wraps the given
     * model based annotation model
     *
     * @param modelAnnotationModel the model based annotation model
     */
    public this(IAnnotationModel modelAnnotationModel) {
        fModel= modelAnnotationModel;
    }

    /**
     * Returns the visual annotation model's wrapped model based annotation model.
     *
     * @return the model based annotation model
     */
    public IAnnotationModel getModelAnnotationModel() {
        return fModel;
    }

    /*
     * @see IAnnotationModel#addAnnotationModelListener(IAnnotationModelListener)
     */
    public void addAnnotationModelListener(IAnnotationModelListener listener) {

        if (fModel !is null && fAnnotationModelListeners.isEmpty())
            fModel.addAnnotationModelListener(this);

        super.addAnnotationModelListener(listener);
    }

    /*
     * @see IAnnotationModel#connect(IDocument)
     */
    public void connect(IDocument document) {
        super.connect(document);
        if (fModel !is null)
            fModel.connect(document);
    }

    /*
     * @see IAnnotationModel#disconnect(IDocument)
     */
    public void disconnect(IDocument document) {
        super.disconnect(document);
        if (fModel !is null)
            fModel.disconnect(document);
    }

    /*
     * @see IAnnotationModel#getAnnotationIterator()
     */
    public Iterator getAnnotationIterator() {

        if (fModel is null)
            return super.getAnnotationIterator();

        ArrayList a= new ArrayList(20);

        Iterator e= fModel.getAnnotationIterator();
        while (e.hasNext())
            a.add(e.next());

        e= super.getAnnotationIterator();
        while (e.hasNext())
            a.add(e.next());

        return a.iterator();
    }

    /*
     * @see IAnnotationModel#getPosition(Annotation)
     */
    public Position getPosition(Annotation annotation) {

        Position p= cast(Position) getAnnotationMap().get(annotation);
        if (p !is null)
            return p;

        if (fModel !is null)
            return fModel.getPosition(annotation);

        return null;
    }

    /*
     * @see IAnnotationModelListener#modelChanged(IAnnotationModel)
     */
    public void modelChanged(IAnnotationModel model) {
        if (model is fModel) {
            Iterator iter= (new ArrayList(fAnnotationModelListeners)).iterator();
            while (iter.hasNext()) {
                IAnnotationModelListener l= cast(IAnnotationModelListener)iter.next();
                l.modelChanged(this);
            }
        }
    }

    /*
     * @see IAnnotationModel#removeAnnotationModelListener(IAnnotationModelListener)
     */
    public void removeAnnotationModelListener(IAnnotationModelListener listener) {
        super.removeAnnotationModelListener(listener);

        if (fModel !is null && fAnnotationModelListeners.isEmpty())
            fModel.removeAnnotationModelListener(this);
    }
}
