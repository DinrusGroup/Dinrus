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
module dwtx.draw2d.ExclusionSearch;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;

import dwtx.draw2d.TreeSearch;
import dwtx.draw2d.IFigure;

/**
 * A <code>TreeSearch</code> that excludes figures contained in a {@link
 * java.util.Collection}.
 * @author hudsonr
 * @since 2.1
 */
public class ExclusionSearch : TreeSearch {

private const Collection c;

/**
 * Constructs an Exclusion search using the given collection.
 * @param collection the exclusion set
 */
public this(Collection collection) {
    this.c = collection;
}

/**
 * @see dwtx.draw2d.TreeSearch#accept(IFigure)
 */
public bool accept(IFigure figure) {
    //Prune is called before accept, so there is no reason to check the collection again.
    return true;
}

/**
 * Returns <code>true</code> if the figure is a member of the Collection.
 * @see dwtx.draw2d.TreeSearch#prune(IFigure)
 */
public bool prune(IFigure f) {
    return c.contains(cast(Object)f);
}

}
