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
module dwtx.jface.text.source.projection.ProjectionSummary;

import dwtx.jface.text.source.projection.ProjectionViewer; // packageimport
import dwtx.jface.text.source.projection.ProjectionSupport; // packageimport
import dwtx.jface.text.source.projection.IProjectionPosition; // packageimport
import dwtx.jface.text.source.projection.AnnotationBag; // packageimport
import dwtx.jface.text.source.projection.ProjectionAnnotationHover; // packageimport
import dwtx.jface.text.source.projection.ProjectionRulerColumn; // packageimport
import dwtx.jface.text.source.projection.ProjectionAnnotationModel; // packageimport
import dwtx.jface.text.source.projection.SourceViewerInformationControl; // packageimport
import dwtx.jface.text.source.projection.IProjectionListener; // packageimport
import dwtx.jface.text.source.projection.ProjectionAnnotation; // packageimport


import dwt.dwthelper.utils;
import dwtx.dwtxhelper.JThread;

import dwtx.dwtxhelper.Collection;





import dwtx.core.runtime.IProgressMonitor;
import dwtx.core.runtime.NullProgressMonitor;
import dwtx.jface.text.IDocument;
import dwtx.jface.text.IRegion;
import dwtx.jface.text.ISynchronizable;
import dwtx.jface.text.Position;
import dwtx.jface.text.source.Annotation;
import dwtx.jface.text.source.IAnnotationAccess;
import dwtx.jface.text.source.IAnnotationAccessExtension;
import dwtx.jface.text.source.IAnnotationModel;
import dwtx.jface.text.source.IAnnotationModelExtension;


/**
 * Strategy for managing annotation summaries for collapsed ranges.
 *
 * @since 3.0
 */
class ProjectionSummary {

    private class Summarizer {

        JThread thread;
        private bool fReset= true;

        /**
         * Creates a new thread.
         */
        public this() {
            thread = new JThread( &run );
            fProgressMonitor= new NullProgressMonitor(); // might be given by client in the future
            thread.setDaemon(true);
            thread.start();
        }

        /**
         * Resets the thread.
         */
        public void reset() {
            synchronized (fLock) {
                fReset= true;
                fProgressMonitor.setCanceled(true);
            }
        }

        /*
         * @see java.lang.Thread#run()
         */
        public void run() {
            while (true) {
                synchronized (fLock) {
                    if (!fReset)
                        break;
                    fReset= false;
                    fProgressMonitor.setCanceled(false);
                }
                internalUpdateSummaries(fProgressMonitor);
            }

            synchronized (fLock) {
                fSummarizer= null;
            }
        }
    }


    private ProjectionViewer fProjectionViewer;
    private IAnnotationModel fAnnotationModel;
    private IAnnotationAccess fAnnotationAccess;
    private List fConfiguredAnnotationTypes;

    private Object fLock;
    private IProgressMonitor fProgressMonitor;
    private /+volatile+/ Summarizer fSummarizer;

    /**
     * Creates a new projection summary.
     *
     * @param projectionViewer the projection viewer
     * @param annotationAccess the annotation access
     */
    public this(ProjectionViewer projectionViewer, IAnnotationAccess annotationAccess) {
//         super();
        fLock= new Object();

        fProjectionViewer= projectionViewer;
        fAnnotationAccess= annotationAccess;
    }

    /**
     * Adds the given annotation type. For now on, annotations of that type are
     * also reflected in their enclosing collapsed regions.
     *
     * @param annotationType the annotation type to add
     */
    public void addAnnotationType(String annotationType) {
        synchronized(fLock) {
            if (fConfiguredAnnotationTypes is null) {
                fConfiguredAnnotationTypes= new ArrayList();
                fConfiguredAnnotationTypes.add(annotationType);
            } else if (!fConfiguredAnnotationTypes.contains(annotationType))
                fConfiguredAnnotationTypes.add(annotationType);
        }
    }

    /**
     * Removes the given annotation. Annotation of that type are no
     * longer reflected in their enclosing collapsed region.
     *
     * @param annotationType the annotation type to remove
     */
    public void removeAnnotationType(String annotationType) {
        synchronized (fLock) {
            if (fConfiguredAnnotationTypes !is null) {
                fConfiguredAnnotationTypes.remove(annotationType);
                if (fConfiguredAnnotationTypes.size() is 0)
                    fConfiguredAnnotationTypes= null;
            }
        }
    }

    /**
     * Forces an updated of the annotation summary.
     */
    public void updateSummaries() {
        synchronized (fLock) {
            if (fConfiguredAnnotationTypes !is null) {
                if (fSummarizer is null)
                    fSummarizer= new Summarizer();
                fSummarizer.reset();
            }
        }
    }

    private void internalUpdateSummaries(IProgressMonitor monitor) {

        Object previousLockObject= null;
        fAnnotationModel= fProjectionViewer.getVisualAnnotationModel();
        if (fAnnotationModel is null)
            return;

        try {


            IDocument document= fProjectionViewer.getDocument();
            if ( cast(ISynchronizable)document  && cast(ISynchronizable)fAnnotationModel ) {
                ISynchronizable sync= cast(ISynchronizable) fAnnotationModel;
                previousLockObject= sync.getLockObject();
                sync.setLockObject((cast(ISynchronizable) document).getLockObject());
            }


            removeSummaries(monitor);

            if (isCanceled(monitor))
                return;

            createSummaries(monitor);

        } finally {

            if ( cast(ISynchronizable)fAnnotationModel ) {
                ISynchronizable sync= cast(ISynchronizable) fAnnotationModel;
                sync.setLockObject(previousLockObject);
            }
            fAnnotationModel= null;

        }
    }

    private bool isCanceled(IProgressMonitor monitor) {
        return monitor !is null && monitor.isCanceled();
    }

    private void removeSummaries(IProgressMonitor monitor) {
        IAnnotationModelExtension extension= null;
        List bags= null;

        if ( cast(IAnnotationModelExtension)fAnnotationModel ) {
            extension= cast(IAnnotationModelExtension) fAnnotationModel;
            bags= new ArrayList();
        }

        Iterator e= fAnnotationModel.getAnnotationIterator();
        while (e.hasNext()) {
            Annotation annotation= cast(Annotation) e.next();
            if ( cast(AnnotationBag)annotation ) {
                if (bags is null)
                    fAnnotationModel.removeAnnotation(annotation);
                else
                    bags.add(annotation);
            }

            if (isCanceled(monitor))
                return;
        }

        if (bags !is null && bags.size() > 0) {
            Annotation[] deletions= new Annotation[bags.size()];
            bags.toArray(deletions);
            if (!isCanceled(monitor))
                extension.replaceAnnotations(deletions, null);
        }
    }

    private void createSummaries(IProgressMonitor monitor) {
        ProjectionAnnotationModel model= fProjectionViewer.getProjectionAnnotationModel();
        if (model is null)
            return;

        Map additions= new HashMap();

        Iterator e= model.getAnnotationIterator();
        while (e.hasNext()) {
            ProjectionAnnotation projection= cast(ProjectionAnnotation) e.next();
            if (projection.isCollapsed()) {
                Position position= model.getPosition(projection);
                if (position !is null) {
                    IRegion[] summaryRegions= fProjectionViewer.computeCollapsedRegions(position);
                    if (summaryRegions !is null) {
                        Position summaryAnchor= fProjectionViewer.computeCollapsedRegionAnchor(position);
                        if (summaryAnchor !is null)
                            createSummary(additions, summaryRegions, summaryAnchor);
                    }
                }
            }

            if (isCanceled(monitor))
                return;
        }

        if (additions.size() > 0) {
            if ( cast(IAnnotationModelExtension)fAnnotationModel ) {
                IAnnotationModelExtension extension= cast(IAnnotationModelExtension) fAnnotationModel;
                if (!isCanceled(monitor))
                    extension.replaceAnnotations(null, additions);
            } else {
                Iterator e1= additions.keySet().iterator();
                while (e1.hasNext()) {
                    AnnotationBag bag= cast(AnnotationBag) e1.next();
                    Position position= cast(Position) additions.get(bag);
                    if (isCanceled(monitor))
                        return;
                    fAnnotationModel.addAnnotation(bag, position);
                }
            }
        }
    }

    private void createSummary(Map additions, IRegion[] summaryRegions, Position summaryAnchor) {

        int size= 0;
        Map map= null;

        synchronized (fLock) {
            if (fConfiguredAnnotationTypes !is null) {
                size= fConfiguredAnnotationTypes.size();
                map= new HashMap();
                for (int i= 0; i < size; i++) {
                    String type= stringcast( fConfiguredAnnotationTypes.get(i));
                    map.put(type, new AnnotationBag(type));
                }
            }
        }

        if (map is null)
            return;

        IAnnotationModel model= fProjectionViewer.getAnnotationModel();
        if (model is null)
            return;
        Iterator e= model.getAnnotationIterator();
        while (e.hasNext()) {
            Annotation annotation= cast(Annotation) e.next();
            AnnotationBag bag= findBagForType(map, annotation.getType());
            if (bag !is null) {
                Position position= model.getPosition(annotation);
                if (includes(summaryRegions, position))
                    bag.add(annotation);
            }
        }

        for (int i= 0; i < size; i++) {
            AnnotationBag bag= cast(AnnotationBag) map.get(fConfiguredAnnotationTypes.get(i));
            if (!bag.isEmpty())
                additions.put(bag, new Position(summaryAnchor.getOffset(), summaryAnchor.getLength()));
        }
    }

    private AnnotationBag findBagForType(Map bagMap, String annotationType) {
        AnnotationBag bag= cast(AnnotationBag) bagMap.get(annotationType);
        if (bag is null && cast(IAnnotationAccessExtension)fAnnotationAccess ) {
            IAnnotationAccessExtension extension= cast(IAnnotationAccessExtension) fAnnotationAccess;
            Object[] superTypes= extension.getSupertypes(stringcast(annotationType));
            for (int i= 0; i < superTypes.length && bag is null; i++) {
                bag= cast(AnnotationBag) bagMap.get(superTypes[i]);
            }
        }
        return bag;
    }

    private bool includes(IRegion[] regions, Position position) {
        for (int i= 0; i < regions.length; i++) {
            IRegion region= regions[i];
            if (position !is null && !position.isDeleted()
                    && region.getOffset() <= position.getOffset() &&  position.getOffset() + position.getLength() <= region.getOffset() + region.getLength())
                return true;
        }
        return false;
    }
}
