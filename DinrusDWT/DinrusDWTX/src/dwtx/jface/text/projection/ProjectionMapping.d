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
module dwtx.jface.text.projection.ProjectionMapping;

import dwtx.jface.text.projection.ChildDocumentManager; // packageimport
import dwtx.jface.text.projection.SegmentUpdater; // packageimport
import dwtx.jface.text.projection.Segment; // packageimport
import dwtx.jface.text.projection.ProjectionDocument; // packageimport
import dwtx.jface.text.projection.FragmentUpdater; // packageimport
import dwtx.jface.text.projection.ProjectionDocumentEvent; // packageimport
import dwtx.jface.text.projection.ChildDocument; // packageimport
import dwtx.jface.text.projection.IMinimalMapping; // packageimport
import dwtx.jface.text.projection.Fragment; // packageimport
import dwtx.jface.text.projection.ProjectionTextStore; // packageimport
import dwtx.jface.text.projection.ProjectionDocumentManager; // packageimport


import dwt.dwthelper.utils;


import dwtx.core.runtime.Assert;
import dwtx.jface.text.BadLocationException;
import dwtx.jface.text.BadPositionCategoryException;
import dwtx.jface.text.IDocument;
import dwtx.jface.text.IDocumentInformationMapping;
import dwtx.jface.text.IDocumentInformationMappingExtension;
import dwtx.jface.text.IDocumentInformationMappingExtension2;
import dwtx.jface.text.IRegion;
import dwtx.jface.text.Position;
import dwtx.jface.text.Region;


/**
 * Internal class. Do not use. Only public for testing purposes.
 * <p>
 * Implementation of {@link dwtx.jface.text.IDocumentInformationMapping}
 * for the projection mapping between a master and a slave document.
 *
 * @since 3.0
 * @noinstantiate This class is not intended to be instantiated by clients.
 * @noextend This class is not intended to be subclassed by clients.
 */
public class ProjectionMapping : IDocumentInformationMapping , IDocumentInformationMappingExtension, IDocumentInformationMappingExtension2, IMinimalMapping {

    private static const int LEFT=  -1;
    private static const int NONE=   0;
    private static const int RIGHT= +1;

    /** The master document */
    private IDocument fMasterDocument;
    /** The position category used to manage the projection fragments inside the master document */
    private String fFragmentsCategory;
    /** The projection document */
    private IDocument fSlaveDocument;
    /** The position category to manage the projection segments inside the slave document. */
    private String fSegmentsCategory;
    /** Cached segments */
    private Position[] fCachedSegments;
    /** Cached fragments */
    private Position[] fCachedFragments;

    /**
     * Creates a new mapping between the given parent document and the given projection document.
     *
     * @param masterDocument the master document
     * @param fragmentsCategory the position category of the parent document used to manage the projected regions
     * @param slaveDocument the slave document
     * @param segmentsCategory the position category of the projection document used to manage the fragments
     */
    public this(IDocument masterDocument, String fragmentsCategory, IDocument slaveDocument, String segmentsCategory) {
        fMasterDocument= masterDocument;
        fFragmentsCategory= fragmentsCategory;
        fSlaveDocument= slaveDocument;
        fSegmentsCategory= segmentsCategory;
    }

    /**
     * Notifies this projection mapping that there was a projection change.
     */
    public void projectionChanged() {
        fCachedSegments= null;
        fCachedFragments= null;
    }

    private Position[] getSegments() {
        if (fCachedSegments is null) {
            try {
                fCachedSegments= fSlaveDocument.getPositions(fSegmentsCategory);
            } catch (BadPositionCategoryException e) {
                return new Position[0];
            }
        }
        return fCachedSegments;
    }

    private Position[] getFragments() {
        if (fCachedFragments is null) {
            try {
                fCachedFragments= fMasterDocument.getPositions(fFragmentsCategory);
            } catch (BadPositionCategoryException e) {
                return new Position[0];
            }
        }
        return fCachedFragments;
    }

    private int findSegmentIndex(int offset)  {
        Position[] segments= getSegments();
        if (segments.length is 0) {
            if (offset > 0)
                throw new BadLocationException();
            return -1;
        }

        try {
            int index= fSlaveDocument.computeIndexInCategory(fSegmentsCategory, offset);
            if (index is segments.length && offset > exclusiveEnd(segments[index-1]))
                throw new BadLocationException();

            if (index < segments.length && offset is segments[index].offset)
                return index;

            if (index > 0)
                index--;

            return index;

        } catch (BadPositionCategoryException e) {
            throw new IllegalStateException();
        }
    }

    private Segment findSegment(int offset)  {

        checkImageOffset(offset);

        int index= findSegmentIndex(offset);
        if (index is -1) {

            Segment s= new Segment(0, 0);
            Fragment f= new Fragment(0, 0);
            s.fragment= f;
            f.segment= s;
            return s;
        }

        Position[] segments= getSegments();
        return cast(Segment) segments[index];
    }

    /**
     * Computes the fragment index given an origin offset. Returns the index of
     * the fragment that contains <code>offset</code>, or <code>-1</code>
     * if no fragment contains <code>offset</code>.
     * <p>
     * If <code>extensionDirection</code> is set to <code>RIGHT</code> or
     * <code>LEFT</code>, the next fragment in that direction is returned if
     * there is no fragment containing <code>offset</code>. Note that if
     * <code>offset</code> occurs before any fragment and
     * <code>extensionDirection</code> is <code>LEFT</code>,
     * <code>-1</code> is also returned. The same applies for an offset after
     * the last fragment and <code>extensionDirection</code> set to
     * <code>RIGHT</code>.
     * </p>
     *
     * @param offset an origin offset
     * @param extensionDirection the direction in which to extend the search, or
     *        <code>NONE</code>
     * @return the index of the fragment containing <code>offset</code>, or
     *         <code>-1</code>
     * @throws BadLocationException if the index is not valid on the master
     *         document
     */
    private int findFragmentIndex(int offset, int extensionDirection)  {
        try {

            Position[] fragments= getFragments();
            if (fragments.length is 0)
                return -1;

            int index= fMasterDocument.computeIndexInCategory(fFragmentsCategory, offset);

            if (index < fragments.length && offset is fragments[index].offset)
                return index;

            if (0 < index && index <= fragments.length && fragments[index - 1].includes(offset))
                return index - 1;

            switch (extensionDirection) {
                case LEFT:
                    return index - 1;
                case RIGHT:
                    if (index < fragments.length)
                        return index;
                default:
            }

            return -1;

        } catch (BadPositionCategoryException e) {
            throw new IllegalStateException();
        }
    }

    private Fragment findFragment(int offset)  {
        checkOriginOffset(offset);

        int index= findFragmentIndex(offset, NONE);
        Position[] fragments= getFragments();
        if (index is -1) {
            if (fragments.length > 0) {
                Fragment last= cast(Fragment) fragments[fragments.length - 1];
                if (exclusiveEnd(last) is offset)
                    return last;
            }
            return null;
        }
        return cast(Fragment) fragments[index];
    }

    /**
     * Returns the image region for <code>originRegion</code>.
     *
     * @param originRegion the region to get the image for
     * @param exact if <code>true</code>, the begin and end offsets of
     *        <code>originRegion</code> must be projected, otherwise
     *        <code>null</code> is returned. If <code>false</code>, the
     *        begin and end range that is not visible is simply clipped.
     * @param takeClosestImage if <code>false</code>, <code>null</code> is
     *        returned if <code>originRegion</code> is completely invisible.
     *        If <code>true</code>, the zero-length region is returned that
     *        "covers" the hidden origin region
     * @return the image region of <code>originRegion</code>
     * @throws BadLocationException if the region is not a valid origin region
     */
    private IRegion toImageRegion(IRegion originRegion, bool exact, bool takeClosestImage)  {
        if (originRegion.getLength() is 0 && !takeClosestImage) {
            int imageOffset= toImageOffset(originRegion.getOffset());
            return imageOffset is -1 ? null : new Region(imageOffset, 0);
        }

        Fragment[] fragments= findFragments(originRegion, exact, takeClosestImage);
        if (fragments is null) {
            if (takeClosestImage) {
                // originRegion may before the first or after the last fragment
                Position[] allFragments= getFragments();
                if (allFragments.length > 0) {
                    // before the first
                    if (exclusiveEnd(originRegion) <= allFragments[0].getOffset())
                        return new Region(0, 0);
                    // after last
                    Position last= allFragments[allFragments.length - 1];
                    if (originRegion.getOffset() >= exclusiveEnd(last))
                        return new Region(exclusiveEnd((cast(Fragment) last).segment), 0);
                }
                return new Region(0, 0);
            }
            return null;
        }

        int imageOffset, exclusiveImageEndOffset;

        // translate start offset
        int relative= originRegion.getOffset() - fragments[0].getOffset();
        if (relative < 0) {
            Assert.isTrue(!exact);
            relative= 0;
        }
        imageOffset= fragments[0].segment.getOffset() + relative;

        // translate end offset
        relative= exclusiveEnd(originRegion) - fragments[1].getOffset();
        if (relative > fragments[1].getLength()) {
            Assert.isTrue(!exact);
            relative= fragments[1].getLength();
        }
        exclusiveImageEndOffset= fragments[1].segment.getOffset() + relative;

        return new Region(imageOffset, exclusiveImageEndOffset - imageOffset);
    }

    /**
     * Returns the two fragments containing the begin and end offsets of
     * <code>originRegion</code>.
     *
     * @param originRegion the region to get the fragments for
     * @param exact if <code>true</code>, only the fragments that contain the
     *        begin and end offsets are returned; if <code>false</code>, the
     *        first fragment after the begin offset and the last fragment before
     *        the end offset are returned if the offsets are not projected
     * @param takeClosestImage if <code>true</code>, the method will return
     *        fragments also if <code>originRegion</code> completely lies in
     *        an unprojected region.
     * @return the two fragments containing the begin and end offset of
     *         <code>originRegion</code>, or <code>null</code> if these do
     *         not exist
     * @throws BadLocationException if the region is not a valid origin region
     */
    private Fragment[] findFragments(IRegion originRegion, bool exact, bool takeClosestImage)  {
        Position[] fragments= getFragments();
        if (fragments.length is 0)
            return null;

        checkOriginRegion(originRegion);

        int startFragmentIdx= findFragmentIndex(originRegion.getOffset(), exact ? NONE : RIGHT);
        if (startFragmentIdx is -1)
            return null;

        int endFragmentIdx= findFragmentIndex(inclusiveEnd(originRegion), exact ? NONE : LEFT);
        if (!takeClosestImage && startFragmentIdx > endFragmentIdx || endFragmentIdx is -1)
            return null;

        Fragment[] result= [cast(Fragment) fragments[startFragmentIdx], cast(Fragment) fragments[endFragmentIdx]];
        return result;
    }

    private IRegion createOriginStartRegion(Segment image, int offsetShift) {
        return new Region(image.fragment.getOffset() + offsetShift, image.fragment.getLength() - offsetShift);
    }

    private IRegion createOriginRegion(Segment image) {
        return new Region(image.fragment.getOffset(), image.fragment.getLength());
    }

    private IRegion createOriginEndRegion(Segment image, int lengthReduction) {
        return new Region(image.fragment.getOffset(), image.fragment.getLength() - lengthReduction);
    }

    private IRegion createImageStartRegion(Fragment origin, int offsetShift) {
        int shift= offsetShift > 0 ? offsetShift : 0;
        return new Region(origin.segment.getOffset() + shift, origin.segment.getLength() - shift);
    }

    private IRegion createImageRegion(Fragment origin) {
        return new Region(origin.segment.getOffset(), origin.segment.getLength());
    }

    private IRegion createImageEndRegion(Fragment origin, int lengthReduction) {
        int reduction= lengthReduction > 0 ? lengthReduction : 0;
        return new Region(origin.segment.getOffset(), origin.segment.getLength() - reduction);
    }

    private IRegion createOriginStartRegion(Fragment origin, int offsetShift) {
        int shift= offsetShift > 0 ? offsetShift : 0;
        return new Region(origin.getOffset() + shift, origin.getLength() - shift);
    }

    private IRegion createOriginRegion(Fragment origin) {
        return new Region(origin.getOffset(), origin.getLength());
    }

    private IRegion createOriginEndRegion(Fragment origin, int lengthReduction) {
        int reduction= lengthReduction > 0 ? lengthReduction : 0;
        return new Region(origin.getOffset(), origin.getLength() - reduction);
    }

    private IRegion getIntersectingRegion(IRegion left, IRegion right) {
        int offset= Math.max(left.getOffset(), right.getOffset());
        int exclusiveEndOffset= Math.min(exclusiveEnd(left), exclusiveEnd(right));
        if (exclusiveEndOffset < offset)
            return null;
        return new Region(offset, exclusiveEndOffset - offset);
    }

    /*
     * @see dwtx.jface.text.IDocumentInformationMapping#getCoverage()
     */
    public IRegion getCoverage() {
        Position[] fragments= getFragments();
        if (fragments !is null && fragments.length > 0) {
            Position first=fragments[0];
            Position last= fragments[fragments.length -1];
            return  new Region(first.offset, exclusiveEnd(last) - first.offset);
        }
        return new Region(0, 0);
    }

    /*
     * @see dwtx.jface.text.IDocumentInformationMapping#toOriginOffset(int)
     */
    public int toOriginOffset(int imageOffset)  {
        Segment segment= findSegment(imageOffset);
        int relative= imageOffset - segment.offset;
        return segment.fragment.offset + relative;
    }

    /*
     * @see dwtx.jface.text.IDocumentInformationMapping#toOriginRegion(dwtx.jface.text.IRegion)
     */
    public IRegion toOriginRegion(IRegion imageRegion)  {
        int imageOffset= imageRegion.getOffset();
        int imageLength= imageRegion.getLength();

        if (imageLength is 0) {
            if (imageOffset is 0) {
                Position[] fragments= getFragments();
                if (fragments.length is 0 || (fragments.length is 1 && fragments[0].getOffset() is 0 && fragments[0].getLength() is 0))
                    return new Region(0, fMasterDocument.getLength());
            }
            return new Region(toOriginOffset(imageOffset), 0);
        }

        int originOffset= toOriginOffset(imageOffset);
        int inclusiveImageEndOffset= imageOffset + imageLength -1;
        int inclusiveOriginEndOffset= toOriginOffset(inclusiveImageEndOffset);

        return new Region(originOffset, (inclusiveOriginEndOffset + 1) - originOffset);
    }

    /*
     * @see dwtx.jface.text.IDocumentInformationMapping#toOriginLines(int)
     */
    public IRegion toOriginLines(int imageLine)  {
        IRegion imageRegion= fSlaveDocument.getLineInformation(imageLine);
        IRegion originRegion= toOriginRegion(imageRegion);

        int originStartLine= fMasterDocument.getLineOfOffset(originRegion.getOffset());
        if (originRegion.getLength() is 0)
            return new Region(originStartLine, 1);

        int originEndLine= fMasterDocument.getLineOfOffset(inclusiveEnd(originRegion));
        return new Region(originStartLine, (originEndLine + 1) - originStartLine);
    }

    /*
     * @see dwtx.jface.text.IDocumentInformationMapping#toOriginLine(int)
     */
    public int toOriginLine(int imageLine)  {
        IRegion lines= toOriginLines(imageLine);
        return (lines.getLength() > 1 ? -1 : lines.getOffset());
    }

    /*
     * @see dwtx.jface.text.IDocumentInformationMapping#toImageOffset(int)
     */
    public int toImageOffset(int originOffset)  {
        Fragment fragment= findFragment(originOffset);
        if (fragment !is null) {
            int relative= originOffset - fragment.offset;
            return fragment.segment.offset + relative;
        }
        return -1;
    }

    /*
     * @see dwtx.jface.text.IDocumentInformationMappingExtension#toExactImageRegion(dwtx.jface.text.IRegion)
     */
    public IRegion toExactImageRegion(IRegion originRegion)  {
        return toImageRegion(originRegion, true, false);
    }

    /*
     * @see dwtx.jface.text.IDocumentInformationMapping#toImageRegion(dwtx.jface.text.IRegion)
     */
    public IRegion toImageRegion(IRegion originRegion)  {
        return toImageRegion(originRegion, false, false);
    }

    /*
     * @see dwtx.jface.text.IDocumentInformationMappingExtension2#toClosestImageRegion(dwtx.jface.text.IRegion)
     * @since 3.1
     */
    public IRegion toClosestImageRegion(IRegion originRegion)  {
        return toImageRegion(originRegion, false, true);
    }

    /*
     * @see dwtx.jface.text.IDocumentInformationMapping#toImageLine(int)
     */
    public int toImageLine(int originLine)  {
        IRegion originRegion= fMasterDocument.getLineInformation(originLine);
        IRegion imageRegion= toImageRegion(originRegion);
        if (imageRegion is null) {
            int imageOffset= toImageOffset(originRegion.getOffset());
            if (imageOffset > -1)
                imageRegion= new Region(imageOffset, 0);
            else
                return -1;
        }

        int startLine= fSlaveDocument.getLineOfOffset(imageRegion.getOffset());
        if (imageRegion.getLength() is 0)
            return startLine;

        int endLine= fSlaveDocument.getLineOfOffset(imageRegion.getOffset() + imageRegion.getLength());
        if (endLine !is startLine)
            throw new IllegalStateException();

        return startLine;
    }

    /*
     * @see dwtx.jface.text.IDocumentInformationMapping#toClosestImageLine(int)
     */
    public int toClosestImageLine(int originLine)  {
        try {

            int imageLine= toImageLine(originLine);
            if (imageLine > -1)
                return imageLine;

            Position[] fragments= getFragments();
            if (fragments.length is 0)
                return -1;

            IRegion originLineRegion= fMasterDocument.getLineInformation(originLine);
            int index= fMasterDocument.computeIndexInCategory(fFragmentsCategory, originLineRegion.getOffset());

            if (0 < index && index < fragments.length) {
                Fragment left= cast(Fragment) fragments[index - 1];
                int leftDistance= originLineRegion.getOffset() - (exclusiveEnd(left));
                Fragment right= cast(Fragment) fragments[index];
                int rightDistance= right.getOffset() - (exclusiveEnd(originLineRegion));

                if (leftDistance <= rightDistance)
                    originLine= fMasterDocument.getLineOfOffset(left.getOffset() + Math.max(left.getLength() - 1, 0));
                else
                    originLine= fMasterDocument.getLineOfOffset(right.getOffset());

            } else if (index is 0) {
                Fragment right= cast(Fragment) fragments[index];
                originLine= fMasterDocument.getLineOfOffset(right.getOffset());
            } else if (index is fragments.length) {
                Fragment left= cast(Fragment) fragments[index - 1];
                originLine= fMasterDocument.getLineOfOffset(exclusiveEnd(left));
            }

            return toImageLine(originLine);

        } catch (BadPositionCategoryException x) {
        }

        return -1;
    }

    /*
     * @see dwtx.jface.text.IDocumentInformationMappingExtension#toExactOriginRegions(dwtx.jface.text.IRegion)
     */
    public IRegion[] toExactOriginRegions(IRegion imageRegion)  {

        if (imageRegion.getLength() is 0)
            return [ new Region(toOriginOffset(imageRegion.getOffset()), 0) ];

        int endOffset= exclusiveEnd(imageRegion);
        Position[] segments= getSegments();
        int firstIndex= findSegmentIndex(imageRegion.getOffset());
        int lastIndex= findSegmentIndex(endOffset - 1);

        int resultLength= lastIndex - firstIndex + 1;
        IRegion[] result= new IRegion[resultLength];

        // first
        result[0]= createOriginStartRegion(cast(Segment) segments[firstIndex], imageRegion.getOffset() - segments[firstIndex].getOffset());
        // middles
        for (int i= 1; i < resultLength - 1; i++)
            result[i]= createOriginRegion(cast(Segment) segments[firstIndex + i]);
        // last
        Segment last= cast(Segment) segments[lastIndex];
        int segmentEndOffset= exclusiveEnd(last);
        IRegion lastRegion= createOriginEndRegion(last, segmentEndOffset - endOffset);
        if (resultLength > 1) {
            // first !is last
            result[resultLength - 1]= lastRegion;
        } else {
            // merge first and last
            IRegion intersection= getIntersectingRegion(result[0], lastRegion);
            if (intersection is null)
                result= new IRegion[0];
            else
                result[0]= intersection;
        }

        return result;
    }

    /*
     * @see dwtx.jface.text.IDocumentInformationMappingExtension#getImageLength()
     */
    public int getImageLength() {
        Position[] segments= getSegments();
        int length= 0;
        for (int i= 0; i < segments.length; i++)
            length += segments[i].length;
        return length;
    }

    /*
     * @see dwtx.jface.text.IDocumentInformationMappingExtension#toExactImageRegions(dwtx.jface.text.IRegion)
     */
    public IRegion[] toExactImageRegions(IRegion originRegion)  {

        int offset= originRegion.getOffset();
        if (originRegion.getLength() is 0) {
            int imageOffset= toImageOffset(offset);
            return imageOffset > -1 ? [ cast(IRegion) new Region(imageOffset, 0) ] : null;
        }

        int endOffset= exclusiveEnd(originRegion);
        Position[] fragments= getFragments();
        int firstIndex= findFragmentIndex(offset, RIGHT);
        int lastIndex= findFragmentIndex(endOffset - 1, LEFT);

        if (firstIndex is -1 || firstIndex > lastIndex)
            return null;

        int resultLength= lastIndex - firstIndex + 1;
        IRegion[] result= new IRegion[resultLength];

        // first
        result[0]= createImageStartRegion(cast(Fragment) fragments[firstIndex], offset - fragments[firstIndex].getOffset());
        // middles
        for (int i= 1; i < resultLength - 1; i++)
            result[i]= createImageRegion(cast(Fragment) fragments[firstIndex + i]);
        // last
        Fragment last= cast(Fragment) fragments[lastIndex];
        int fragmentEndOffset= exclusiveEnd(last);
        IRegion lastRegion= createImageEndRegion(last, fragmentEndOffset - endOffset);
        if (resultLength > 1) {
            // first !is last
            result[resultLength - 1]= lastRegion;
        } else {
            // merge first and last
            IRegion intersection= getIntersectingRegion(result[0], lastRegion);
            if (intersection is null)
                return null;
            result[0]= intersection;
        }

        return result;
    }

    /*
     * @see dwtx.jface.text.IDocumentInformationMappingExtension#getExactCoverage(dwtx.jface.text.IRegion)
     */
    public IRegion[] getExactCoverage(IRegion originRegion)  {

        int originOffset= originRegion.getOffset();
        int originLength= originRegion.getLength();

        if (originLength is 0) {
            int imageOffset= toImageOffset(originOffset);
            return imageOffset > -1 ? [ cast(IRegion)new Region(originOffset, 0) ] : null;
        }

        int endOffset= originOffset + originLength;
        Position[] fragments= getFragments();
        int firstIndex= findFragmentIndex(originOffset, RIGHT);
        int lastIndex= findFragmentIndex(endOffset - 1, LEFT);

        if (firstIndex is -1 || firstIndex > lastIndex)
            return null;

        int resultLength= lastIndex - firstIndex + 1;
        IRegion[] result= new IRegion[resultLength];

        // first
        result[0]= createOriginStartRegion(cast(Fragment) fragments[firstIndex], originOffset - fragments[firstIndex].getOffset());
        // middles
        for (int i= 1; i < resultLength - 1; i++)
            result[i]= createOriginRegion(cast(Fragment) fragments[firstIndex + i]);
        // last
        Fragment last= cast(Fragment) fragments[lastIndex];
        int fragmentEndOffset= exclusiveEnd(last);
        IRegion lastRegion= createOriginEndRegion(last, fragmentEndOffset - endOffset);
        if (resultLength > 1) {
            // first !is last
            result[resultLength - 1]= lastRegion;
        } else {
            // merge first and last
            IRegion intersection= getIntersectingRegion(result[0], lastRegion);
            if (intersection is null)
                return null;
            result[0]= intersection;
        }

        return result;
    }

    private final void checkOriginRegion(IRegion originRegion)  {
        int offset= originRegion.getOffset();
        int endOffset= inclusiveEnd(originRegion);
        int max= fMasterDocument.getLength();
        if (offset < 0 || offset > max || endOffset < 0 || endOffset > max)
            throw new BadLocationException();
    }

    private final void checkOriginOffset(int originOffset)  {
        if (originOffset < 0 || originOffset > fMasterDocument.getLength())
            throw new BadLocationException();
    }

    private final void checkImageOffset(int imageOffset)  {
        if (imageOffset < 0 || imageOffset > getImageLength())
            throw new BadLocationException();
    }

    private final int exclusiveEnd(Position position) {
        return position.offset + position.length;
    }

    private final int exclusiveEnd(IRegion region) {
        return region.getOffset() + region.getLength();
    }

    private final int inclusiveEnd(IRegion region) {
        int length= region.getLength();
        if (length is 0)
            return region.getOffset();
        return region.getOffset() + length - 1;
    }


}
