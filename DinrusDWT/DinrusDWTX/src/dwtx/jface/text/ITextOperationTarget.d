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
module dwtx.jface.text.ITextOperationTarget;


import dwt.dwthelper.utils;


/**
 * Defines the target for text operations. <code>canDoOperation</code> informs
 * the clients about the ability of the target to perform the specified
 * operation at the current point in time. <code>doOperation</code> executes
 * the specified operation.
 * <p>
 * In order to provide backward compatibility for clients of
 * <code>ITextOperationTarget</code>, extension interfaces are used as a
 * means of evolution. The following extension interfaces exist:
 * <ul>
 * <li>{@link dwtx.jface.text.ITextOperationTargetExtension} since
 *     version 2.0 introducing text operation enabling/disabling.</li>
 * </ul>
 *
 * @see dwtx.jface.text.ITextOperationTargetExtension
 */
public interface ITextOperationTarget {


    /**
     * Text operation code for undoing the last edit command.
     */
    public static const int UNDO= 1;

    /**
     * Text operation code for redoing the last undone edit command.
     */
    public static const int REDO= 2;

    /**
     * Text operation code for moving the selected text to the clipboard.
     */
    public static const int CUT= 3;

    /**
     * Text operation code for copying the selected text to the clipboard.
     */
    public static const int COPY= 4;

    /**
     * Text operation code for inserting the clipboard content at the
     * current position.
     */
    public static const int PASTE= 5;

    /**
     * Text operation code for deleting the selected text or if selection
     * is empty the character  at the right of the current position.
     */
    public static const int DELETE= 6;

    /**
     * Text operation code for selecting the complete text.
     */
    public static const int SELECT_ALL= 7;

    /**
     * Text operation code for shifting the selected text block to the right.
     */
    public static const int SHIFT_RIGHT= 8;

    /**
     * Text operation code for shifting the selected text block to the left.
     */
    public static const int SHIFT_LEFT= 9;

    /**
     * Text operation code for printing the complete text.
     */
    public static const int PRINT= 10;

    /**
     * Text operation code for prefixing the selected text block.
     */
    public static const int PREFIX= 11;

    /**
     * Text operation code for removing the prefix from the selected text block.
     */
    public static const int STRIP_PREFIX= 12;


    /**
     * Returns whether the operation specified by the given operation code
     * can be performed.
     *
     * @param operation the operation code
     * @return <code>true</code> if the specified operation can be performed
     */
    bool canDoOperation(int operation);

    /**
     * Performs the operation specified by the operation code on the target.
     * <code>doOperation</code> must only be called if <code>canDoOperation</code>
     * returns <code>true</code>.
     *
     * @param operation the operation code
     */
    void doOperation(int operation);
}
