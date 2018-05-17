/*******************************************************************************
 * Copyright (c) 2000, 2007 IBM Corporation and others.
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
module dwtx.jface.text.source.LineNumberChangeRulerColumn;

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
import dwtx.jface.text.source.OverviewRulerHoverManager; // packageimport


import dwt.dwthelper.utils;





import dwt.graphics.Color;
import dwt.graphics.GC;
import dwt.widgets.Composite;
import dwt.widgets.Control;
import dwtx.core.runtime.Assert;
import dwtx.jface.internal.text.revisions.RevisionPainter;
import dwtx.jface.internal.text.source.DiffPainter;
import dwtx.jface.text.revisions.IRevisionListener;
import dwtx.jface.text.revisions.IRevisionRulerColumn;
import dwtx.jface.text.revisions.IRevisionRulerColumnExtension;
import dwtx.jface.text.revisions.RevisionInformation;
import dwtx.jface.viewers.ISelectionProvider;

/**
 * A vertical ruler column displaying line numbers and serving as a UI for quick diff.
 * Clients usually instantiate and configure object of this class.
 *
 * @since 3.0
 */
public final class LineNumberChangeRulerColumn : LineNumberRulerColumn , IVerticalRulerInfo, IVerticalRulerInfoExtension, IChangeRulerColumn, IRevisionRulerColumn, IRevisionRulerColumnExtension {

    public Control getControl() {
        return super.getControl();
    }

    /** The ruler's annotation model. */
    private IAnnotationModel fAnnotationModel;
    /** <code>true</code> if changes should be displayed using character indications instead of background colors. */
    private bool fCharacterDisplay;
    /**
     * The revision painter strategy.
     *
     * @since 3.2
     */
    private const RevisionPainter fRevisionPainter;
    /**
     * The diff information painter strategy.
     *
     * @since 3.2
     */
    private const DiffPainter fDiffPainter;
    /**
     * Whether to show number or to behave like a change ruler column.
     * @since 3.3
     */
    private bool fShowNumbers= true;

    /**
     * Creates a new instance.
     *
     * @param sharedColors the shared colors provider to use
     */
    public this(ISharedTextColors sharedColors) {
        Assert.isNotNull(cast(Object)sharedColors);
        fRevisionPainter= new RevisionPainter(this, sharedColors);
        fDiffPainter= new DiffPainter(this, sharedColors);
    }

    /*
     * @see dwtx.jface.text.source.LineNumberRulerColumn#createControl(dwtx.jface.text.source.CompositeRuler, dwt.widgets.Composite)
     */
    public Control createControl(CompositeRuler parentRuler, Composite parentControl) {
        Control control= super.createControl(parentRuler, parentControl);
        fRevisionPainter.setParentRuler(parentRuler);
        fDiffPainter.setParentRuler(parentRuler);
        return control;
    }

    /*
     * @see dwtx.jface.text.source.IVerticalRulerInfo#getLineOfLastMouseButtonActivity()
     */
    public int getLineOfLastMouseButtonActivity() {
        return getParentRuler().getLineOfLastMouseButtonActivity();
    }

    /*
     * @see dwtx.jface.text.source.IVerticalRulerInfo#toDocumentLineNumber(int)
     */
    public int toDocumentLineNumber(int y_coordinate) {
        return getParentRuler().toDocumentLineNumber(y_coordinate);
    }

    /*
     * @see IVerticalRulerColumn#setModel(IAnnotationModel)
     */
    public void setModel(IAnnotationModel model) {
        setAnnotationModel(model);
        fRevisionPainter.setModel(model);
        fDiffPainter.setModel(model);
        updateNumberOfDigits();
        computeIndentations();
        layout(true);
        postRedraw();
    }

    private void setAnnotationModel(IAnnotationModel model) {
        if (fAnnotationModel !is model)
            fAnnotationModel= model;
    }


    /**
     * Sets the display mode of the ruler. If character mode is set to <code>true</code>, diff
     * information will be displayed textually on the line number ruler.
     *
     * @param characterMode <code>true</code> if diff information is to be displayed textually.
     */
    public void setDisplayMode(bool characterMode) {
        if (characterMode !is fCharacterDisplay) {
            fCharacterDisplay= characterMode;
            updateNumberOfDigits();
            computeIndentations();
            layout(true);
        }
    }

    /*
     * @see dwtx.jface.text.source.IVerticalRulerInfoExtension#getModel()
     */
    public IAnnotationModel getModel() {
        return fAnnotationModel;
    }

    /*
     * @see dwtx.jface.text.source.LineNumberRulerColumn#createDisplayString(int)
     */
    protected String createDisplayString(int line) {
        StringBuffer buffer= new StringBuffer();
        if (fShowNumbers)
            buffer.append(super.createDisplayString(line));
        if (fCharacterDisplay && getModel() !is null)
            buffer.append(fDiffPainter.getDisplayCharacter(line));
        return buffer.toString();
    }

    /*
     * @see dwtx.jface.text.source.LineNumberRulerColumn#computeNumberOfDigits()
     */
    protected int computeNumberOfDigits() {
        int digits;
        if (fCharacterDisplay && getModel() !is null) {
            if (fShowNumbers)
                digits= super.computeNumberOfDigits() + 1;
            else
                digits= 1;
        } else {
            if (fShowNumbers)
                digits= super.computeNumberOfDigits();
            else
                digits= 0;
        }
        if (fRevisionPainter.hasInformation())
            digits+= fRevisionPainter.getRequiredWidth();
        return digits;
    }

    /*
     * @see dwtx.jface.text.source.IVerticalRulerInfoExtension#addVerticalRulerListener(dwtx.jface.text.source.IVerticalRulerListener)
     */
    public void addVerticalRulerListener(IVerticalRulerListener listener) {
        throw new UnsupportedOperationException();
    }

    /*
     * @see dwtx.jface.text.source.IVerticalRulerInfoExtension#removeVerticalRulerListener(dwtx.jface.text.source.IVerticalRulerListener)
     */
    public void removeVerticalRulerListener(IVerticalRulerListener listener) {
        throw new UnsupportedOperationException();
    }

    /*
     * @see dwtx.jface.text.source.LineNumberRulerColumn#doPaint(dwt.graphics.GC)
     */
    void doPaint(GC gc, ILineRange visibleLines) {
        Color foreground= gc.getForeground();
        if (visibleLines !is null) {
            if (fRevisionPainter.hasInformation())
                fRevisionPainter.paint(gc, visibleLines);
            else if (fDiffPainter.hasInformation()) // don't paint quick diff colors if revisions are painted
                fDiffPainter.paint(gc, visibleLines);
        }
        gc.setForeground(foreground);
        if (fShowNumbers || fCharacterDisplay)
            super.doPaint(gc, visibleLines);
    }

    /*
     * @see dwtx.jface.text.source.IVerticalRulerInfoExtension#getHover()
     */
    public IAnnotationHover getHover() {
        int activeLine= getParentRuler().getLineOfLastMouseButtonActivity();
        if (fRevisionPainter.hasHover(activeLine))
            return fRevisionPainter.getHover();
        if (fDiffPainter.hasHover(activeLine))
            return fDiffPainter.getHover();
        return null;
    }

    /*
     * @see dwtx.jface.text.source.IChangeRulerColumn#setHover(dwtx.jface.text.source.IAnnotationHover)
     */
    public void setHover(IAnnotationHover hover) {
        fRevisionPainter.setHover(hover);
        fDiffPainter.setHover(hover);
    }

    /*
     * @see dwtx.jface.text.source.IChangeRulerColumn#setBackground(dwt.graphics.Color)
     */
    public void setBackground(Color background) {
        super.setBackground(background);
        fRevisionPainter.setBackground(background);
        fDiffPainter.setBackground(background);
    }

    /*
     * @see dwtx.jface.text.source.IChangeRulerColumn#setAddedColor(dwt.graphics.Color)
     */
    public void setAddedColor(Color addedColor) {
        fDiffPainter.setAddedColor(addedColor);
    }

    /*
     * @see dwtx.jface.text.source.IChangeRulerColumn#setChangedColor(dwt.graphics.Color)
     */
    public void setChangedColor(Color changedColor) {
        fDiffPainter.setChangedColor(changedColor);
    }

    /*
     * @see dwtx.jface.text.source.IChangeRulerColumn#setDeletedColor(dwt.graphics.Color)
     */
    public void setDeletedColor(Color deletedColor) {
        fDiffPainter.setDeletedColor(deletedColor);
    }

    /*
     * @see dwtx.jface.text.revisions.IRevisionRulerColumn#setRevisionInformation(dwtx.jface.text.revisions.RevisionInformation)
     */
    public void setRevisionInformation(RevisionInformation info) {
        fRevisionPainter.setRevisionInformation(info);
        updateNumberOfDigits();
        computeIndentations();
        layout(true);
        postRedraw();
    }

    /*
     * @see dwtx.jface.text.revisions.IRevisionRulerColumnExtension#getRevisionSelectionProvider()
     * @since 3.2
     */
    public ISelectionProvider getRevisionSelectionProvider() {
        return fRevisionPainter.getRevisionSelectionProvider();
    }

    /*
     * @see dwtx.jface.text.revisions.IRevisionRulerColumnExtension#setRenderingMode(dwtx.jface.text.revisions.IRevisionRulerColumnExtension.RenderingMode)
     * @since 3.3
     */
    public void setRevisionRenderingMode(RenderingMode renderingMode) {
        fRevisionPainter.setRenderingMode(renderingMode);
    }

    /**
     * Sets the line number display mode.
     *
     * @param showNumbers <code>true</code> to show numbers, <code>false</code> to only show
     *        diff / revision info.
     * @since 3.3
     */
    public void showLineNumbers(bool showNumbers) {
        if (fShowNumbers !is showNumbers) {
            fShowNumbers= showNumbers;
            updateNumberOfDigits();
            computeIndentations();
            layout(true);
        }
    }

    /*
     * @see dwtx.jface.text.source.LineNumberRulerColumn#getWidth()
     * @since 3.3
     */
    public int getWidth() {
        int width= super.getWidth();
        return width > 0 ? width : 8; // minimal width to display quick diff / revisions if no textual info is shown
    }

    /**
     * Returns <code>true</code> if the ruler is showing line numbers, <code>false</code>
     * otherwise
     *
     * @return <code>true</code> if line numbers are shown, <code>false</code> otherwise
     * @since 3.3
     */
    public bool isShowingLineNumbers() {
        return fShowNumbers;
    }

    /**
     * Returns <code>true</code> if the ruler is showing revision information, <code>false</code>
     * otherwise
     *
     * @return <code>true</code> if revision information is shown, <code>false</code> otherwise
     * @since 3.3
     */
    public bool isShowingRevisionInformation() {
        return fRevisionPainter.hasInformation();
    }

    /**
     * Returns <code>true</code> if the ruler is showing change information, <code>false</code>
     * otherwise
     *
     * @return <code>true</code> if change information is shown, <code>false</code> otherwise
     * @since 3.3
     */
    public bool isShowingChangeInformation() {
        return fDiffPainter.hasInformation();
    }

    /*
     * @see dwtx.jface.text.revisions.IRevisionRulerColumnExtension#showRevisionAuthor(bool)
     * @since 3.3
     */
    public void showRevisionAuthor(bool show) {
        fRevisionPainter.showRevisionAuthor(show);
        updateNumberOfDigits();
        computeIndentations();
        layout(true);
        postRedraw();
    }

    /*
     * @see dwtx.jface.text.revisions.IRevisionRulerColumnExtension#showRevisionId(bool)
     * @since 3.3
     */
    public void showRevisionId(bool show) {
        fRevisionPainter.showRevisionId(show);
        updateNumberOfDigits();
        computeIndentations();
        layout(true);
        postRedraw();
    }

    /*
     * @see dwtx.jface.text.revisions.IRevisionRulerColumnExtension#addRevisionListener(dwtx.jface.text.revisions.IRevisionListener)
     * @since 3.3
     */
    public void addRevisionListener(IRevisionListener listener) {
        fRevisionPainter.addRevisionListener(listener);
    }

    /*
     * @see dwtx.jface.text.revisions.IRevisionRulerColumnExtension#removeRevisionListener(dwtx.jface.text.revisions.IRevisionListener)
     * @since 3.3
     */
    public void removeRevisionListener(IRevisionListener listener) {
        fRevisionPainter.removeRevisionListener(listener);
    }

    /*
     * @see dwtx.jface.text.source.LineNumberRulerColumn#handleDispose()
     * @since 3.3
     */
    protected void handleDispose() {
        fRevisionPainter.setParentRuler(null);
        fRevisionPainter.setModel(null);
        fDiffPainter.setParentRuler(null);
        fDiffPainter.setModel(null);
        super.handleDispose();
    }
}
