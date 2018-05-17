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
module dwtx.jface.text.source.AnnotationMap;

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







/**
 * Internal implementation of {@link dwtx.jface.text.source.IAnnotationMap}.
 *
 * @since 3.0
 */
class AnnotationMap : IAnnotationMap {

    /**
     * The lock object used to synchronize the operations explicitly defined by
     * <code>IAnnotationMap</code>
     */
    private Object fLockObject;
    /**
     * The internal lock object used if <code>fLockObject</code> is <code>null</code>.
     * @since 3.2
     */
    private const Object fInternalLockObject;

    /** The map holding the annotations */
    private Map fInternalMap;

    /**
     * Creates a new annotation map with the given capacity.
     *
     * @param capacity the capacity
     */
    public this(int capacity) {
        fInternalLockObject= new Object();
        fInternalMap= new HashMap(capacity);
    }

    /*
     * @see dwtx.jface.text.source.ISynchronizable#setLockObject(java.lang.Object)
     */
    public synchronized void setLockObject(Object lockObject) {
        fLockObject= lockObject;
    }

    /*
     * @see dwtx.jface.text.source.ISynchronizable#getLockObject()
     */
    public synchronized Object getLockObject() {
        if (fLockObject is null)
            return fInternalLockObject;
        return fLockObject;
    }

    /*
     * @see dwtx.jface.text.source.IAnnotationMap#valuesIterator()
     */
    public Iterator valuesIterator() {
        synchronized (getLockObject()) {
            return (new ArrayList(fInternalMap.values())).iterator();
        }
    }

    /*
     * @see dwtx.jface.text.source.IAnnotationMap#keySetIterator()
     */
    public Iterator keySetIterator() {
        synchronized (getLockObject()) {
            return (new ArrayList(fInternalMap.keySet())).iterator();
        }
    }

    /*
     * @see java.util.Map#containsKey(java.lang.Object)
     */
    public bool containsKey(Object annotation) {
        synchronized (getLockObject()) {
            return fInternalMap.containsKey(annotation);
        }
    }

    /*
     * @see java.util.Map#put(java.lang.Object, java.lang.Object)
     */
    public Object put(Object annotation, Object position) {
        synchronized (getLockObject()) {
            return fInternalMap.put(annotation, position);
        }
    }

    /*
     * @see java.util.Map#get(java.lang.Object)
     */
    public Object get(Object annotation) {
        synchronized (getLockObject()) {
            return fInternalMap.get(annotation);
        }
    }

    /*
     * @see java.util.Map#clear()
     */
    public void clear() {
        synchronized (getLockObject()) {
            fInternalMap.clear();
        }
    }

    /*
     * @see java.util.Map#remove(java.lang.Object)
     */
    public Object remove(Object annotation) {
        synchronized (getLockObject()) {
            return fInternalMap.remove(annotation);
        }
    }

    /*
     * @see java.util.Map#size()
     */
    public int size() {
        synchronized (getLockObject()) {
            return fInternalMap.size();
        }
    }

    /*
     * @see java.util.Map#isEmpty()
     */
    public bool isEmpty() {
        synchronized (getLockObject()) {
            return fInternalMap.isEmpty();
        }
    }

    /*
     * @see java.util.Map#containsValue(java.lang.Object)
     */
    public bool containsValue(Object value) {
        synchronized(getLockObject()) {
            return fInternalMap.containsValue(value);
        }
    }

    /*
     * @see java.util.Map#putAll(java.util.Map)
     */
    public void putAll(Map map) {
        synchronized (getLockObject()) {
            fInternalMap.putAll(map);
        }
    }

    /*
     * @see IAnnotationMap#entrySet()
     */
    public Set entrySet() {
        synchronized (getLockObject()) {
            return fInternalMap.entrySet();
        }
    }

    /*
     * @see IAnnotationMap#keySet()
     */
    public Set keySet() {
        synchronized (getLockObject()) {
            return fInternalMap.keySet();
        }
    }

    /*
     * @see IAnnotationMap#values()
     */
    public Collection values() {
        synchronized (getLockObject()) {
            return fInternalMap.values();
        }
    }

    /// DWT extension of Collection interfaces

    public bool containsKey(String key) {
        return containsKey(stringcast(key));
    }
    public Object get(String key) {
        return get(stringcast(key));
    }
    public Object put(String key, String value) {
        return put(stringcast(key), stringcast(value));
    }
    public Object put(Object key, String value) {
        return put(key, stringcast(value));
    }
    public Object put(String key, Object value) {
        return put(stringcast(key), value);
    }
    public Object remove(String key) {
        return remove(stringcast(key));
    }
    public int opApply (int delegate(ref Object value) dg){
        implMissing(__FILE__,__LINE__);
        return 0;
    }
    public int opApply (int delegate(ref Object key, ref Object value) dg){
        implMissing(__FILE__,__LINE__);
        return 0;
    }

}
