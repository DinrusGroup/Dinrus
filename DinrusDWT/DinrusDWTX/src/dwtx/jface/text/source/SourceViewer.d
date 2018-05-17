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
module dwtx.jface.text.source.SourceViewer;

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

import dwtx.dwtxhelper.Collection;


import dwt.DWT;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.widgets.Canvas;
import dwt.widgets.Composite;
import dwt.widgets.Control;
import dwt.widgets.Layout;
import dwtx.jface.internal.text.NonDeletingPositionUpdater;
import dwtx.jface.internal.text.StickyHoverManager;
import dwtx.jface.text.AbstractHoverInformationControlManager;
import dwtx.jface.text.BadLocationException;
import dwtx.jface.text.BadPositionCategoryException;
import dwtx.jface.text.DocumentRewriteSession;
import dwtx.jface.text.DocumentRewriteSessionType;
import dwtx.jface.text.IDocument;
import dwtx.jface.text.IDocumentExtension4;
import dwtx.jface.text.IPositionUpdater;
import dwtx.jface.text.IRegion;
import dwtx.jface.text.IRewriteTarget;
import dwtx.jface.text.ISlaveDocumentManager;
import dwtx.jface.text.ISlaveDocumentManagerExtension;
import dwtx.jface.text.ITextViewerExtension2;
import dwtx.jface.text.ITextViewerExtension8;
import dwtx.jface.text.Position;
import dwtx.jface.text.Region;
import dwtx.jface.text.TextViewer;
import dwtx.jface.text.contentassist.IContentAssistant;
import dwtx.jface.text.contentassist.IContentAssistantExtension4;
import dwtx.jface.text.formatter.FormattingContext;
import dwtx.jface.text.formatter.FormattingContextProperties;
import dwtx.jface.text.formatter.IContentFormatter;
import dwtx.jface.text.formatter.IContentFormatterExtension;
import dwtx.jface.text.formatter.IFormattingContext;
import dwtx.jface.text.hyperlink.IHyperlinkDetector;
import dwtx.jface.text.information.IInformationPresenter;
import dwtx.jface.text.presentation.IPresentationReconciler;
import dwtx.jface.text.projection.ChildDocument;
import dwtx.jface.text.quickassist.IQuickAssistAssistant;
import dwtx.jface.text.quickassist.IQuickAssistInvocationContext;
import dwtx.jface.text.reconciler.IReconciler;

/**
 * DWT based implementation of
 * {@link dwtx.jface.text.source.ISourceViewer} and its extension
 * interfaces. The same rules apply as for
 * {@link dwtx.jface.text.TextViewer}. A source viewer uses an
 * <code>IVerticalRuler</code> as its annotation presentation area. The
 * vertical ruler is a small strip shown left of the viewer's text widget. A
 * source viewer uses an <code>IOverviewRuler</code> as its presentation area
 * for the annotation overview. The overview ruler is a small strip shown right
 * of the viewer's text widget.
 * <p>
 * Clients are supposed to instantiate a source viewer and subsequently to
 * communicate with it exclusively using the <code>ISourceViewer</code> and
 * its extension interfaces.</p>
 * <p>
 * Clients may subclass this class but should expect some breakage by future releases.</p>
 */
public class SourceViewer : TextViewer , ISourceViewer, ISourceViewerExtension, ISourceViewerExtension2, ISourceViewerExtension3, ISourceViewerExtension4 {


    /**
     * Layout of a source viewer. Vertical ruler, text widget, and overview ruler are shown side by side.
     */
    protected class RulerLayout : Layout {

        /** The gap between the text viewer and the vertical ruler. */
        protected int fGap;

        /**
         * Creates a new ruler layout with the given gap between text viewer and vertical ruler.
         *
         * @param gap the gap between text viewer and vertical ruler
         */
        public this(int gap) {
            fGap= gap;
        }

        /*
         * @see Layout#computeSize(Composite, int, int, bool)
         */
        protected Point computeSize(Composite composite, int wHint, int hHint, bool flushCache) {
            Control[] children= composite.getChildren();
            Point s= children[children.length - 1].computeSize(DWT.DEFAULT, DWT.DEFAULT, flushCache);
            if (fVerticalRuler !is null && fIsVerticalRulerVisible)
                s.x += fVerticalRuler.getWidth() + fGap;
            return s;
        }

        /*
         * @see Layout#layout(Composite, bool)
         */
        protected void layout(Composite composite, bool flushCache) {
            Rectangle clArea= composite.getClientArea();
            Rectangle trim= getTextWidget().computeTrim(0, 0, 0, 0);
            int topTrim= - trim.y;
            int scrollbarHeight= trim.height - topTrim; // scrollbar is only under the client area

            int x= clArea.x;
            int width= clArea.width;

            if (fOverviewRuler !is null && fIsOverviewRulerVisible) {
                int overviewRulerWidth= fOverviewRuler.getWidth();
                fOverviewRuler.getControl().setBounds(clArea.x + clArea.width - overviewRulerWidth - 1, clArea.y + scrollbarHeight, overviewRulerWidth, clArea.height - 3*scrollbarHeight);
                fOverviewRuler.getHeaderControl().setBounds(clArea.x + clArea.width - overviewRulerWidth - 1, clArea.y, overviewRulerWidth, scrollbarHeight);

                width -= overviewRulerWidth + fGap;
            }

            if (fVerticalRuler !is null && fIsVerticalRulerVisible) {
                int verticalRulerWidth= fVerticalRuler.getWidth();
                final Control verticalRulerControl= fVerticalRuler.getControl();
                int oldWidth= verticalRulerControl.getBounds().width;
                verticalRulerControl.setBounds(clArea.x, clArea.y + topTrim, verticalRulerWidth, clArea.height - scrollbarHeight - topTrim);
                if (flushCache && getVisualAnnotationModel() !is null && oldWidth is verticalRulerWidth)
                    verticalRulerControl.redraw();

                x += verticalRulerWidth + fGap;
                width -= verticalRulerWidth + fGap;
            }

            getTextWidget().setBounds(x, clArea.y, width, clArea.height);
        }
    }

    /**
     * The size of the gap between the vertical ruler and the text widget
     * (value <code>2</code>).
     * <p>
     * Note: As of 3.2, the text editor framework is no longer using 2 as
     * gap but 1, see {{@link #GAP_SIZE_1 }.
     * </p>
     */
    protected final static int GAP_SIZE= 2;
    /**
     * The size of the gap between the vertical ruler and the text widget
     * (value <code>1</code>).
     * @since 3.2
     */
    protected final static int GAP_SIZE_1= 1;
    /**
     * Partial name of the position category to manage remembered selections.
     * @since 3.0
     */
    protected final static String _SELECTION_POSITION_CATEGORY= "__selection_category"; //$NON-NLS-1$
    /**
     * Key of the model annotation model inside the visual annotation model.
     * @since 3.0
     */
    private static Object MODEL_ANNOTATION_MODEL_;
    protected static Object MODEL_ANNOTATION_MODEL(){
        if( MODEL_ANNOTATION_MODEL_ is null ){
            synchronized(SourceViewer.classinfo ){
                if( MODEL_ANNOTATION_MODEL_ is null ){
                    MODEL_ANNOTATION_MODEL_ = new Object();
                }
            }
        }
        return MODEL_ANNOTATION_MODEL_;
    }

    /** The viewer's content assistant */
    protected IContentAssistant fContentAssistant;
    /**
     * The viewer's facade to its content assistant.
     * @since 3.4
     */
    private ContentAssistantFacade fContentAssistantFacade;
    /**
     * Flag indicating whether the viewer's content assistant is installed.
     * @since 2.0
     */
    protected bool fContentAssistantInstalled;
    /**
     * This viewer's quick assist assistant.
     * @since 3.2
     */
    protected IQuickAssistAssistant fQuickAssistAssistant;
    /**
     * Flag indicating whether this viewer's quick assist assistant is installed.
     * @since 3.2
     */
    protected bool fQuickAssistAssistantInstalled;
    /** The viewer's content formatter */
    protected IContentFormatter fContentFormatter;
    /** The viewer's model reconciler */
    protected IReconciler fReconciler;
    /** The viewer's presentation reconciler */
    protected IPresentationReconciler fPresentationReconciler;
    /** The viewer's annotation hover */
    protected IAnnotationHover fAnnotationHover;
    /**
     * Stack of saved selections in the underlying document
     * @since 3.0
     */
    protected const Stack fSelections;
    /**
     * Position updater for saved selections
     * @since 3.0
     */
    protected IPositionUpdater fSelectionUpdater= null;
    /**
     * Position category used by the selection updater
     * @since 3.0
     */
    protected String fSelectionCategory;
    /**
     * The viewer's overview ruler annotation hover
     * @since 3.0
     */
    protected IAnnotationHover fOverviewRulerAnnotationHover;
    /**
     * The viewer's information presenter
     * @since 2.0
     */
    protected IInformationPresenter fInformationPresenter;

    /** Visual vertical ruler */
    private IVerticalRuler fVerticalRuler;
    /** Visibility of vertical ruler */
    private bool fIsVerticalRulerVisible;
    /** The DWT widget used when supporting a vertical ruler */
    private Composite fComposite;
    /** The vertical ruler's annotation model */
    private IAnnotationModel fVisualAnnotationModel;
    /** The viewer's range indicator to be shown in the vertical ruler */
    private Annotation fRangeIndicator;
    /** The viewer's vertical ruler hovering controller */
    private AnnotationBarHoverManager fVerticalRulerHoveringController;
    /**
     * The viewer's overview ruler hovering controller
     * @since 2.1
     */
    private AbstractHoverInformationControlManager fOverviewRulerHoveringController;

    /**
     * The overview ruler.
     * @since 2.1
     */
    private IOverviewRuler fOverviewRuler;
    /**
     * The visibility of the overview ruler
     * @since 2.1
     */
    private bool fIsOverviewRulerVisible;


    /**
     * Constructs a new source viewer. The vertical ruler is initially visible.
     * The viewer has not yet been initialized with a source viewer configuration.
     *
     * @param parent the parent of the viewer's control
     * @param ruler the vertical ruler used by this source viewer
     * @param styles the DWT style bits for the viewer's control,
     *          <em>if <code>DWT.WRAP</code> is set then a custom document adapter needs to be provided, see {@link #createDocumentAdapter()}
     */
    public this(Composite parent, IVerticalRuler ruler, int styles) {
        this(parent, ruler, null, false, styles);
    }

    /**
     * Constructs a new source viewer. The vertical ruler is initially visible.
     * The overview ruler visibility is controlled by the value of <code>showAnnotationsOverview</code>.
     * The viewer has not yet been initialized with a source viewer configuration.
     *
     * @param parent the parent of the viewer's control
     * @param verticalRuler the vertical ruler used by this source viewer
     * @param overviewRuler the overview ruler
     * @param showAnnotationsOverview <code>true</code> if the overview ruler should be visible, <code>false</code> otherwise
     * @param styles the DWT style bits for the viewer's control,
     *          <em>if <code>DWT.WRAP</code> is set then a custom document adapter needs to be provided, see {@link #createDocumentAdapter()}
     * @since 2.1
     */
    public this(Composite parent, IVerticalRuler verticalRuler, IOverviewRuler overviewRuler, bool showAnnotationsOverview, int styles) {
        fSelections= new Stack();
        super();

        fVerticalRuler= verticalRuler;
        fIsVerticalRulerVisible= (verticalRuler !is null);
        fOverviewRuler= overviewRuler;
        fIsOverviewRulerVisible= (showAnnotationsOverview && overviewRuler !is null);

        createControl(parent, styles);
    }

    /*
     * @see TextViewer#createControl(Composite, int)
     */
    protected void createControl(Composite parent, int styles) {

        if (fVerticalRuler !is null || fOverviewRuler !is null) {
            styles= (styles & ~DWT.BORDER);
            fComposite= new Canvas(parent, DWT.NONE);
            fComposite.setLayout(createLayout());
            parent= fComposite;
        }

        super.createControl(parent, styles);

        if (fVerticalRuler !is null)
            fVerticalRuler.createControl(fComposite, this);
        if (fOverviewRuler !is null)
            fOverviewRuler.createControl(fComposite, this);
    }

    /**
     * Creates the layout used for this viewer.
     * Subclasses may override this method.
     *
     * @return the layout used for this viewer
     * @since 3.0
     */
    protected Layout createLayout() {
        return new RulerLayout(GAP_SIZE_1);
    }

    /*
     * @see TextViewer#getControl()
     */
    public Control getControl() {
        if (fComposite !is null)
            return fComposite;
        return super.getControl();
    }

    /*
     * @see ISourceViewer#setAnnotationHover(IAnnotationHover)
     */
    public void setAnnotationHover(IAnnotationHover annotationHover) {
        fAnnotationHover= annotationHover;
    }

    /**
     * Sets the overview ruler's annotation hover of this source viewer.
     * The annotation hover provides the information to be displayed in a hover
     * popup window if requested over the overview rulers area. The annotation
     * hover is assumed to be line oriented.
     *
     * @param annotationHover the hover to be used, <code>null</code> is a valid argument
     * @since 3.0
     */
    public void setOverviewRulerAnnotationHover(IAnnotationHover annotationHover) {
        fOverviewRulerAnnotationHover= annotationHover;
    }

    /*
     * @see ISourceViewer#configure(SourceViewerConfiguration)
     */
    public void configure(SourceViewerConfiguration configuration) {

        if (getTextWidget() is null)
            return;

        setDocumentPartitioning(configuration.getConfiguredDocumentPartitioning(this));

        // install content type independent plug-ins
        fPresentationReconciler= configuration.getPresentationReconciler(this);
        if (fPresentationReconciler !is null)
            fPresentationReconciler.install(this);

        fReconciler= configuration.getReconciler(this);
        if (fReconciler !is null)
            fReconciler.install(this);

        fContentAssistant= configuration.getContentAssistant(this);
        if (fContentAssistant !is null) {
            fContentAssistant.install(this);
            if ( cast(IContentAssistantExtension4)fContentAssistant  && cast(IContentAssistantExtension4)fContentAssistant )
                fContentAssistantFacade= new ContentAssistantFacade(fContentAssistant);
            fContentAssistantInstalled= true;
        }

        fQuickAssistAssistant= configuration.getQuickAssistAssistant(this);
        if (fQuickAssistAssistant !is null) {
            fQuickAssistAssistant.install(this);
            fQuickAssistAssistantInstalled= true;
        }

        fContentFormatter= configuration.getContentFormatter(this);

        fInformationPresenter= configuration.getInformationPresenter(this);
        if (fInformationPresenter !is null)
            fInformationPresenter.install(this);

        setUndoManager(configuration.getUndoManager(this));

        getTextWidget().setTabs(configuration.getTabWidth(this));

        setAnnotationHover(configuration.getAnnotationHover(this));
        setOverviewRulerAnnotationHover(configuration.getOverviewRulerAnnotationHover(this));

        setHoverControlCreator(configuration.getInformationControlCreator(this));

        setHyperlinkPresenter(configuration.getHyperlinkPresenter(this));
        IHyperlinkDetector[] hyperlinkDetectors= configuration.getHyperlinkDetectors(this);
        int eventStateMask= configuration.getHyperlinkStateMask(this);
        setHyperlinkDetectors(hyperlinkDetectors, eventStateMask);

        // install content type specific plug-ins
        String[] types= configuration.getConfiguredContentTypes(this);
        for (int i= 0; i < types.length; i++) {

            String t= types[i];

            setAutoEditStrategies(configuration.getAutoEditStrategies(this, t), t);
            setTextDoubleClickStrategy(configuration.getDoubleClickStrategy(this, t), t);

            int[] stateMasks= configuration.getConfiguredTextHoverStateMasks(this, t);
            if (stateMasks !is null) {
                for (int j= 0; j < stateMasks.length; j++)  {
                    int stateMask= stateMasks[j];
                    setTextHover(configuration.getTextHover(this, t, stateMask), t, stateMask);
                }
            } else {
                setTextHover(configuration.getTextHover(this, t), t, ITextViewerExtension2.DEFAULT_HOVER_STATE_MASK);
            }

            String[] prefixes= configuration.getIndentPrefixes(this, t);
            if (prefixes !is null && prefixes.length > 0)
                setIndentPrefixes(prefixes, t);

            prefixes= configuration.getDefaultPrefixes(this, t);
            if (prefixes !is null && prefixes.length > 0)
                setDefaultPrefixes(prefixes, t);
        }

        activatePlugins();
    }

    /**
     * After this method has been executed the caller knows that any installed annotation hover has been installed.
     */
    protected void ensureAnnotationHoverManagerInstalled() {
        if (fVerticalRuler !is null && (fAnnotationHover !is null || !isVerticalRulerOnlyShowingAnnotations()) && fVerticalRulerHoveringController is null && fHoverControlCreator !is null) {
            fVerticalRulerHoveringController= new AnnotationBarHoverManager(fVerticalRuler, this, fAnnotationHover, fHoverControlCreator);
            fVerticalRulerHoveringController.install(fVerticalRuler.getControl());
            fVerticalRulerHoveringController.getInternalAccessor().setInformationControlReplacer(new StickyHoverManager(this));
        }
    }

    /**
     * After this method has been executed the caller knows that any installed overview hover has been installed.
     */
    protected void ensureOverviewHoverManagerInstalled() {
        if (fOverviewRuler !is null &&  fOverviewRulerAnnotationHover !is null  && fOverviewRulerHoveringController is null && fHoverControlCreator !is null)  {
            fOverviewRulerHoveringController= new OverviewRulerHoverManager(fOverviewRuler, this, fOverviewRulerAnnotationHover, fHoverControlCreator);
            fOverviewRulerHoveringController.install(fOverviewRuler.getControl());
            fOverviewRulerHoveringController.getInternalAccessor().setInformationControlReplacer(new StickyHoverManager(this));
        }
    }

    /*
     * @see dwtx.jface.text.TextViewer#setHoverEnrichMode(dwtx.jface.text.ITextViewerExtension8.EnrichMode)
     * @since 3.4
     */
    public void setHoverEnrichMode(ITextViewerExtension8_EnrichMode mode) {
        super.setHoverEnrichMode(mode);
        if (fVerticalRulerHoveringController !is null)
            fVerticalRulerHoveringController.getInternalAccessor().setHoverEnrichMode(mode);
        if (fOverviewRulerHoveringController !is null)
            fOverviewRulerHoveringController.getInternalAccessor().setHoverEnrichMode(mode);
    }

    /*
     * @see TextViewer#activatePlugins()
     */
    public void activatePlugins() {
        ensureAnnotationHoverManagerInstalled();
        ensureOverviewHoverManagerInstalled();
        super.activatePlugins();
    }

    /*
     * @see ISourceViewer#setDocument(IDocument, IAnnotationModel)
     */
    public void setDocument(IDocument document) {
        setDocument(document, null, -1, -1);
    }

    /*
     * @see ISourceViewer#setDocument(IDocument, IAnnotationModel, int, int)
     */
    public void setDocument(IDocument document, int visibleRegionOffset, int visibleRegionLength) {
        setDocument(document, null, visibleRegionOffset, visibleRegionLength);
    }

    /*
     * @see ISourceViewer#setDocument(IDocument, IAnnotationModel)
     */
    public void setDocument(IDocument document, IAnnotationModel annotationModel) {
        setDocument(document, annotationModel, -1, -1);
    }

    /**
     * Creates the visual annotation model on top of the given annotation model.
     *
     * @param annotationModel the wrapped annotation model
     * @return the visual annotation model on top of the given annotation model
     * @since 3.0
     */
    protected IAnnotationModel createVisualAnnotationModel(IAnnotationModel annotationModel) {
        IAnnotationModelExtension model= new AnnotationModel();
        model.addAnnotationModel(MODEL_ANNOTATION_MODEL, annotationModel);
        return cast(IAnnotationModel) model;
    }

    /**
     * Disposes the visual annotation model.
     *
     * @since 3.1
     */
    protected void disposeVisualAnnotationModel() {
        if (fVisualAnnotationModel !is null) {
            if (getDocument() !is null)
                fVisualAnnotationModel.disconnect(getDocument());

            if ( cast(IAnnotationModelExtension)fVisualAnnotationModel )
                (cast(IAnnotationModelExtension)fVisualAnnotationModel).removeAnnotationModel(MODEL_ANNOTATION_MODEL);

            fVisualAnnotationModel= null;
        }
    }

    /*
     * @see ISourceViewer#setDocument(IDocument, IAnnotationModel, int, int)
     */
    public void setDocument(IDocument document, IAnnotationModel annotationModel, int modelRangeOffset, int modelRangeLength) {
        disposeVisualAnnotationModel();

        if (annotationModel !is null && document !is null) {
            fVisualAnnotationModel= createVisualAnnotationModel(annotationModel);
            fVisualAnnotationModel.connect(document);
        }

        if (modelRangeOffset is -1 && modelRangeLength is -1)
            super.setDocument(document);
        else
            super.setDocument(document, modelRangeOffset, modelRangeLength);

        if (fVerticalRuler !is null)
            fVerticalRuler.setModel(fVisualAnnotationModel);

        if (fOverviewRuler !is null)
            fOverviewRuler.setModel(fVisualAnnotationModel);
    }

    /*
     * @see ISourceViewer#getAnnotationModel()
     */
    public IAnnotationModel getAnnotationModel() {
        if ( cast(IAnnotationModelExtension)fVisualAnnotationModel ) {
            IAnnotationModelExtension extension= cast(IAnnotationModelExtension) fVisualAnnotationModel;
            return extension.getAnnotationModel(MODEL_ANNOTATION_MODEL);
        }
        return null;
    }

    /*
     * @see dwtx.jface.text.source.ISourceViewerExtension3#getQuickAssistAssistant()
     * @since 3.2
     */
    public IQuickAssistAssistant getQuickAssistAssistant() {
        return fQuickAssistAssistant;
    }

    /**
     * {@inheritDoc}
     *
     * @since 3.4
     */
    public final ContentAssistantFacade getContentAssistantFacade() {
        return fContentAssistantFacade;
    }

    /*
     * @see dwtx.jface.text.source.ISourceViewerExtension3#getQuickAssistInvocationContext()
     * @since 3.2
     */
    public IQuickAssistInvocationContext getQuickAssistInvocationContext() {
        Point selection= getSelectedRange();
        return new TextInvocationContext(this, selection.x, selection.x);
    }

    /*
     * @see dwtx.jface.text.source.ISourceViewerExtension2#getVisualAnnotationModel()
     * @since 3.0
     */
    public IAnnotationModel getVisualAnnotationModel() {
        return fVisualAnnotationModel;
    }

    /*
     * @see dwtx.jface.text.source.ISourceViewerExtension2#unconfigure()
     * @since 3.0
     */
    public void unconfigure() {
        clearRememberedSelection();

        if (fPresentationReconciler !is null) {
            fPresentationReconciler.uninstall();
            fPresentationReconciler= null;
        }

        if (fReconciler !is null) {
            fReconciler.uninstall();
            fReconciler= null;
        }

        if (fContentAssistant !is null) {
            fContentAssistant.uninstall();
            fContentAssistantInstalled= false;
            fContentAssistant= null;
            if (fContentAssistantFacade !is null)
                fContentAssistantFacade= null;
        }

        if (fQuickAssistAssistant !is null) {
            fQuickAssistAssistant.uninstall();
            fQuickAssistAssistantInstalled= false;
            fQuickAssistAssistant= null;
        }

        fContentFormatter= null;

        if (fInformationPresenter !is null) {
            fInformationPresenter.uninstall();
            fInformationPresenter= null;
        }

        fAutoIndentStrategies= null;
        fDoubleClickStrategies= null;
        fTextHovers= null;
        fIndentChars= null;
        fDefaultPrefixChars= null;

        if (fVerticalRulerHoveringController !is null) {
            fVerticalRulerHoveringController.dispose();
            fVerticalRulerHoveringController= null;
        }

        if (fOverviewRulerHoveringController !is null) {
            fOverviewRulerHoveringController.dispose();
            fOverviewRulerHoveringController= null;
        }

        if (fUndoManager !is null) {
            fUndoManager.disconnect();
            fUndoManager= null;
        }

        setHyperlinkDetectors(null, DWT.NONE);
    }

    /*
     * @see dwtx.jface.text.TextViewer#handleDispose()
     */
    protected void handleDispose() {
        unconfigure();

        disposeVisualAnnotationModel();

        fVerticalRuler= null;

        fOverviewRuler= null;

        // http://dev.eclipse.org/bugs/show_bug.cgi?id=15300
        fComposite= null;

        super.handleDispose();
    }

    /*
     * @see ITextOperationTarget#canDoOperation(int)
     */
    public bool canDoOperation(int operation) {

        if (getTextWidget() is null || (!redraws() && operation !is FORMAT))
            return false;

        if (operation is CONTENTASSIST_PROPOSALS)
            return fContentAssistant !is null && fContentAssistantInstalled && isEditable();

        if (operation is CONTENTASSIST_CONTEXT_INFORMATION)
            return fContentAssistant !is null && fContentAssistantInstalled && isEditable();

        if (operation is QUICK_ASSIST)
            return fQuickAssistAssistant !is null && fQuickAssistAssistantInstalled && isEditable();

        if (operation is INFORMATION)
            return fInformationPresenter !is null;

        if (operation is FORMAT) {
            return fContentFormatter !is null && isEditable();
        }

        return super.canDoOperation(operation);
    }

    /**
     * Creates a new formatting context for a format operation.
     * <p>
     * After the use of the context, clients are required to call
     * its <code>dispose</code> method.
     *
     * @return The new formatting context
     * @since 3.0
     */
    protected IFormattingContext createFormattingContext() {
        return new FormattingContext();
    }

    /**
     * Remembers and returns the current selection. The saved selection can be restored
     * by calling <code>restoreSelection()</code>.
     *
     * @return the current selection
     * @see dwtx.jface.text.ITextViewer#getSelectedRange()
     * @since 3.0
     */
    protected Point rememberSelection() {

        final Point selection= getSelectedRange();
        final IDocument document= getDocument();

        if (fSelections.isEmpty()) {
            fSelectionCategory= _SELECTION_POSITION_CATEGORY ~ Integer.toString(toHash());
            fSelectionUpdater= new NonDeletingPositionUpdater(fSelectionCategory);
            document.addPositionCategory(fSelectionCategory);
            document.addPositionUpdater(fSelectionUpdater);
        }

        try {

            final Position position= new Position(selection.x, selection.y);
            document.addPosition(fSelectionCategory, position);
            fSelections.push(position);

        } catch (BadLocationException exception) {
            // Should not happen
        } catch (BadPositionCategoryException exception) {
            // Should not happen
        }

        return selection;
    }

    /**
     * Restores a previously saved selection in the document.
     * <p>
     * If no selection was previously saved, nothing happens.
     *
     * @since 3.0
     */
    protected void restoreSelection() {

        if (!fSelections.isEmpty()) {

            final IDocument document= getDocument();
            final Position position= cast(Position) fSelections.pop();

            try {
                document.removePosition(fSelectionCategory, position);
                Point currentSelection= getSelectedRange();
                if (currentSelection is null || currentSelection.x !is position.getOffset() || currentSelection.y !is position.getLength())
                    setSelectedRange(position.getOffset(), position.getLength());

                if (fSelections.isEmpty())
                    clearRememberedSelection();
            } catch (BadPositionCategoryException exception) {
                // Should not happen
            }
        }
    }

    protected void clearRememberedSelection() {
        if (!fSelections.isEmpty())
            fSelections.clear();

        IDocument document= getDocument();
        if (document !is null && fSelectionUpdater !is null) {
            document.removePositionUpdater(fSelectionUpdater);
            try {
                document.removePositionCategory(fSelectionCategory);
            } catch (BadPositionCategoryException e) {
                // ignore
            }
        }
        fSelectionUpdater= null;
        fSelectionCategory= null;
    }

    /*
     * @see ITextOperationTarget#doOperation(int)
     */
    public void doOperation(int operation) {

        if (getTextWidget() is null || (!redraws() && operation !is FORMAT))
            return;

        switch (operation) {
            case CONTENTASSIST_PROPOSALS:
                fContentAssistant.showPossibleCompletions();
                return;
            case CONTENTASSIST_CONTEXT_INFORMATION:
                fContentAssistant.showContextInformation();
                return;
            case QUICK_ASSIST:
                // FIXME: must find a way to post to the status line
                /* String msg= */ fQuickAssistAssistant.showPossibleQuickAssists();
                // setStatusLineErrorMessage(msg);
                return;
            case INFORMATION:
                fInformationPresenter.showInformation();
                return;
            case FORMAT:
                {
                    final Point selection= rememberSelection();
                    final IRewriteTarget target= getRewriteTarget();
                    final IDocument document= getDocument();
                    IFormattingContext context= null;
                    DocumentRewriteSession rewriteSession= null;

                    if ( cast(IDocumentExtension4)document ) {
                        IDocumentExtension4 extension= cast(IDocumentExtension4) document;
                        DocumentRewriteSessionType type= selection.y is 0 || selection.y > 1000 ? DocumentRewriteSessionType.SEQUENTIAL : DocumentRewriteSessionType.UNRESTRICTED_SMALL;
                        rewriteSession= extension.startRewriteSession(type);
                    } else {
                        setRedraw(false);
                        target.beginCompoundChange();
                    }

                    try {

                        final String rememberedContents= document.get();

                        try {

                            if ( cast(IContentFormatterExtension)fContentFormatter ) {
                                final IContentFormatterExtension extension= cast(IContentFormatterExtension) fContentFormatter;
                                context= createFormattingContext();
                                if (selection.y is 0) {
                                    context.setProperty(stringcast(FormattingContextProperties.CONTEXT_DOCUMENT), Boolean.TRUE);
                                } else {
                                    context.setProperty(stringcast(FormattingContextProperties.CONTEXT_DOCUMENT), Boolean.FALSE);
                                    context.setProperty(stringcast(FormattingContextProperties.CONTEXT_REGION), new Region(selection.x, selection.y));
                                }
                                extension.format(document, context);
                            } else {
                                IRegion r;
                                if (selection.y is 0) {
                                    IRegion coverage= getModelCoverage();
                                    r= coverage is null ? new Region(0, 0) : coverage;
                                } else {
                                    r= new Region(selection.x, selection.y);
                                }
                                fContentFormatter.format(document, r);
                            }

                            updateSlaveDocuments(document);

                        } catch (RuntimeException x) {
                            // fire wall for https://bugs.eclipse.org/bugs/show_bug.cgi?id=47472
                            // if something went wrong we undo the changes we just did
                            // TODO to be removed after 3.0 M8
                            document.set(rememberedContents);
                            throw x;
                        }

                    } finally {

                        if ( cast(IDocumentExtension4)document ) {
                            IDocumentExtension4 extension= cast(IDocumentExtension4) document;
                            extension.stopRewriteSession(rewriteSession);
                        } else {
                            target.endCompoundChange();
                            setRedraw(true);
                        }

                        restoreSelection();
                        if (context !is null)
                            context.dispose();
                    }
                    return;
                }
            default:
                super.doOperation(operation);
        }
    }

    /**
     * Updates all slave documents of the given document. This default implementation calls <code>updateSlaveDocument</code>
     * for their current visible range. Subclasses may reimplement.
     *
     * @param masterDocument the master document
     * @since 3.0
     */
    protected void updateSlaveDocuments(IDocument masterDocument) {
        ISlaveDocumentManager manager= getSlaveDocumentManager();
        if ( cast(ISlaveDocumentManagerExtension)manager ) {
            ISlaveDocumentManagerExtension extension= cast(ISlaveDocumentManagerExtension) manager;
            IDocument[] slaves= extension.getSlaveDocuments(masterDocument);
            if (slaves !is null) {
                for (int i= 0; i < slaves.length; i++) {
                    if ( auto child = cast(ChildDocument)slaves[i] ) {
                        Position p= child.getParentDocumentRange();
                        try {

                            if (!updateSlaveDocument(child, p.getOffset(), p.getLength()))
                                child.repairLineInformation();

                        } catch (BadLocationException e) {
                            // ignore
                        }
                    }
                }
            }
        }
    }

    /*
     * @see ITextOperationTargetExtension#enableOperation(int, bool)
     * @since 2.0
     */
    public void enableOperation(int operation, bool enable) {

        switch (operation) {
            case CONTENTASSIST_PROPOSALS:
            case CONTENTASSIST_CONTEXT_INFORMATION: {

                if (fContentAssistant is null)
                    return;

                if (enable) {
                    if (!fContentAssistantInstalled) {
                        fContentAssistant.install(this);
                        fContentAssistantInstalled= true;
                    }
                } else if (fContentAssistantInstalled) {
                    fContentAssistant.uninstall();
                    fContentAssistantInstalled= false;
                }
                break;
            }
            case QUICK_ASSIST: {

                if (fQuickAssistAssistant is null)
                    return;

                if (enable) {
                    if (!fQuickAssistAssistantInstalled) {
                        fQuickAssistAssistant.install(this);
                        fQuickAssistAssistantInstalled= true;
                    }
                } else if (fContentAssistantInstalled) {
                    fQuickAssistAssistant.uninstall();
                    fContentAssistantInstalled= false;
                }
            }
            default:
        }
    }

    /*
     * @see ISourceViewer#setRangeIndicator(Annotation)
     */
    public void setRangeIndicator(Annotation rangeIndicator) {
        fRangeIndicator= rangeIndicator;
    }

    /*
     * @see ISourceViewer#setRangeIndication(int, int, bool)
     */
    public void setRangeIndication(int start, int length, bool moveCursor) {

        if (moveCursor) {
            setSelectedRange(start, 0);
            revealRange(start, length);
        }

        if (fRangeIndicator !is null && cast(IAnnotationModelExtension)fVisualAnnotationModel ) {
            IAnnotationModelExtension extension= cast(IAnnotationModelExtension) fVisualAnnotationModel;
            extension.modifyAnnotationPosition(fRangeIndicator, new Position(start, length));
        }
    }

    /*
     * @see ISourceViewer#getRangeIndication()
     */
    public IRegion getRangeIndication() {
        if (fRangeIndicator !is null && fVisualAnnotationModel !is null) {
            Position position= fVisualAnnotationModel.getPosition(fRangeIndicator);
            if (position !is null)
                return new Region(position.getOffset(), position.getLength());
        }

        return null;
    }

    /*
     * @see ISourceViewer#removeRangeIndication()
     */
    public void removeRangeIndication() {
        if (fRangeIndicator !is null && fVisualAnnotationModel !is null)
            fVisualAnnotationModel.removeAnnotation(fRangeIndicator);
    }

    /*
     * @see ISourceViewer#showAnnotations(bool)
     */
    public void showAnnotations(bool show) {
        bool old= fIsVerticalRulerVisible;

        fIsVerticalRulerVisible= (fVerticalRuler !is null && (show || !isVerticalRulerOnlyShowingAnnotations()));
        if (old !is fIsVerticalRulerVisible && fComposite !is null && !fComposite.isDisposed())
            fComposite.layout();

        if (fIsVerticalRulerVisible && show)
            ensureAnnotationHoverManagerInstalled();
        else if (fVerticalRulerHoveringController !is null) {
            fVerticalRulerHoveringController.dispose();
            fVerticalRulerHoveringController= null;
        }
    }

    /**
     * Tells whether the vertical ruler only acts as annotation ruler.
     *
     * @return <code>true</code> if the vertical ruler only show annotations
     * @since 3.3
     */
    private bool isVerticalRulerOnlyShowingAnnotations() {
        if ( cast(VerticalRuler)fVerticalRuler )
            return true;

        if ( cast(CompositeRuler)fVerticalRuler ) {
            Iterator iter= (cast(CompositeRuler)fVerticalRuler).getDecoratorIterator();
            return iter.hasNext() && cast(AnnotationRulerColumn)iter.next() && !iter.hasNext();
        }
        return false;
    }

    /**
     * Returns the vertical ruler of this viewer.
     *
     * @return the vertical ruler of this viewer
     * @since 3.0
     */
    protected final IVerticalRuler getVerticalRuler() {
        return fVerticalRuler;
    }

    /*
     * @see dwtx.jface.text.source.ISourceViewerExtension#showAnnotationsOverview(bool)
     * @since 2.1
     */
    public void showAnnotationsOverview(bool show) {
        bool old= fIsOverviewRulerVisible;
        fIsOverviewRulerVisible= (show && fOverviewRuler !is null);
        if (old !is fIsOverviewRulerVisible) {
            if (fComposite !is null && !fComposite.isDisposed())
                fComposite.layout();
            if (fIsOverviewRulerVisible) {
                ensureOverviewHoverManagerInstalled();
            } else if (fOverviewRulerHoveringController !is null) {
                fOverviewRulerHoveringController.dispose();
                fOverviewRulerHoveringController= null;
            }
        }
    }

    /*
     * @see dwtx.jface.text.source.ISourceViewer#getCurrentAnnotationHover()
     * @since 3.2
     */
    public IAnnotationHover getCurrentAnnotationHover() {
        if (fVerticalRulerHoveringController is null)
            return null;
        return fVerticalRulerHoveringController.getCurrentAnnotationHover();
    }
}
