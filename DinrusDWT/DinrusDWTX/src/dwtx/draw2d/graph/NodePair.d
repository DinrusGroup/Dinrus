/*******************************************************************************
 * Copyright (c) 2003, 2005 IBM Corporation and others.
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
module dwtx.draw2d.graph.NodePair;

import dwt.dwthelper.utils;
import dwtx.draw2d.graph.Node;
import tango.text.convert.Format;

/**
 * @author hudsonr
 * @since 2.1
 */
class NodePair {

public Node n1;
public Node n2;

public this() { }

public this(Node n1, Node n2) {
    this.n1 = n1;
    this.n2 = n2;
}

public override int opEquals(Object obj) {
    if (auto np = cast(NodePair) obj ) {
        return np.n1 is n1 && np.n2 is n2;
    }
    return false;
}

public override hash_t toHash() {
    return n1.toHash() ^ n2.toHash();
}

/**
 * @see java.lang.Object#toString()
 */
public String toString() {
    return Format("[{}, {}]", n1, n2 ); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
}

}
