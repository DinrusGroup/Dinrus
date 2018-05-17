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
module dwtx.text.edits.EditDocument;

import dwtx.text.edits.MultiTextEdit; // packageimport
import dwtx.text.edits.CopySourceEdit; // packageimport
import dwtx.text.edits.MoveSourceEdit; // packageimport
import dwtx.text.edits.CopyingRangeMarker; // packageimport
import dwtx.text.edits.ReplaceEdit; // packageimport
import dwtx.text.edits.UndoCollector; // packageimport
import dwtx.text.edits.DeleteEdit; // packageimport
import dwtx.text.edits.MoveTargetEdit; // packageimport
import dwtx.text.edits.CopyTargetEdit; // packageimport
import dwtx.text.edits.TextEditCopier; // packageimport
import dwtx.text.edits.ISourceModifier; // packageimport
import dwtx.text.edits.TextEditMessages; // packageimport
import dwtx.text.edits.TextEditProcessor; // packageimport
import dwtx.text.edits.MalformedTreeException; // packageimport
import dwtx.text.edits.TreeIterationInfo; // packageimport
import dwtx.text.edits.TextEditVisitor; // packageimport
import dwtx.text.edits.TextEditGroup; // packageimport
import dwtx.text.edits.TextEdit; // packageimport
import dwtx.text.edits.RangeMarker; // packageimport
import dwtx.text.edits.UndoEdit; // packageimport
import dwtx.text.edits.InsertEdit; // packageimport


import dwt.dwthelper.utils;

import dwtx.jface.text.BadLocationException;
import dwtx.jface.text.BadPositionCategoryException;
import dwtx.jface.text.IDocument;
import dwtx.jface.text.IDocumentListener;
import dwtx.jface.text.IDocumentPartitioner;
import dwtx.jface.text.IDocumentPartitioningListener;
import dwtx.jface.text.IPositionUpdater;
import dwtx.jface.text.IRegion;
import dwtx.jface.text.ITypedRegion;
import dwtx.jface.text.Position;

class EditDocument : IDocument {

    private StringBuffer fBuffer;

    public this(String content) {
        fBuffer= new StringBuffer(content);
    }

    public void addDocumentListener(IDocumentListener listener) {
        throw new UnsupportedOperationException();
    }

    public void addDocumentPartitioningListener(IDocumentPartitioningListener listener) {
        throw new UnsupportedOperationException();
    }

    public void addPosition(Position position)  {
        throw new UnsupportedOperationException();
    }

    public void addPosition(String category, Position position)  {
        throw new UnsupportedOperationException();
    }

    public void addPositionCategory(String category) {
        throw new UnsupportedOperationException();
    }

    public void addPositionUpdater(IPositionUpdater updater) {
        throw new UnsupportedOperationException();
    }

    public void addPrenotifiedDocumentListener(IDocumentListener documentAdapter) {
        throw new UnsupportedOperationException();
    }

    public int computeIndexInCategory(String category, int offset)  {
        throw new UnsupportedOperationException();
    }

    public int computeNumberOfLines(String text) {
        throw new UnsupportedOperationException();
    }

    public ITypedRegion[] computePartitioning(int offset, int length)  {
        throw new UnsupportedOperationException();
    }

    public bool containsPosition(String category, int offset, int length) {
        throw new UnsupportedOperationException();
    }

    public bool containsPositionCategory(String category) {
        throw new UnsupportedOperationException();
    }

    public String get() {
        return fBuffer.toString();
    }

    public String get(int offset, int length_)  {
        return fBuffer.slice()[offset .. offset + length_ ];
    }

    public char getChar(int offset)  {
        throw new UnsupportedOperationException();
    }

    public String getContentType(int offset)  {
        throw new UnsupportedOperationException();
    }

    public IDocumentPartitioner getDocumentPartitioner() {
        throw new UnsupportedOperationException();
    }

    public String[] getLegalContentTypes() {
        throw new UnsupportedOperationException();
    }

    public String[] getLegalLineDelimiters() {
        throw new UnsupportedOperationException();
    }

    public int getLength() {
        return fBuffer.length();
    }

    public String getLineDelimiter(int line)  {
        throw new UnsupportedOperationException();
    }

    public IRegion getLineInformation(int line)  {
        throw new UnsupportedOperationException();
    }

    public IRegion getLineInformationOfOffset(int offset)  {
        throw new UnsupportedOperationException();
    }

    public int getLineLength(int line)  {
        throw new UnsupportedOperationException();
    }

    public int getLineOffset(int line)  {
        throw new UnsupportedOperationException();
    }

    public int getLineOfOffset(int offset)  {
        throw new UnsupportedOperationException();
    }

    public int getNumberOfLines() {
        throw new UnsupportedOperationException();
    }

    public int getNumberOfLines(int offset, int length)  {
        throw new UnsupportedOperationException();
    }

    public ITypedRegion getPartition(int offset)  {
        throw new UnsupportedOperationException();
    }

    public String[] getPositionCategories() {
        throw new UnsupportedOperationException();
    }

    public Position[] getPositions(String category)  {
        throw new UnsupportedOperationException();
    }

    public IPositionUpdater[] getPositionUpdaters() {
        throw new UnsupportedOperationException();
    }

    public void insertPositionUpdater(IPositionUpdater updater, int index) {
        throw new UnsupportedOperationException();
    }

    public void removeDocumentListener(IDocumentListener listener) {
        throw new UnsupportedOperationException();
    }

    public void removeDocumentPartitioningListener(IDocumentPartitioningListener listener) {
        throw new UnsupportedOperationException();
    }

    public void removePosition(Position position) {
        throw new UnsupportedOperationException();
    }

    public void removePosition(String category, Position position)  {
        throw new UnsupportedOperationException();
    }

    public void removePositionCategory(String category)  {
        throw new UnsupportedOperationException();
    }

    public void removePositionUpdater(IPositionUpdater updater) {
        throw new UnsupportedOperationException();
    }

    public void removePrenotifiedDocumentListener(IDocumentListener documentAdapter) {
        throw new UnsupportedOperationException();
    }

    public void replace(int offset, int length, String text)  {
        fBuffer.select(offset, length );
        fBuffer.replace(text);
    }

    public int search(int startOffset, String findString, bool forwardSearch, bool caseSensitive, bool wholeWord)  {
        throw new UnsupportedOperationException();
    }

    public void set(String text) {
        throw new UnsupportedOperationException();
    }

    public void setDocumentPartitioner(IDocumentPartitioner partitioner) {
        throw new UnsupportedOperationException();
    }
}
