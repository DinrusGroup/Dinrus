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
module dwtx.draw2d.graph.GraphVisitor;

import dwt.dwthelper.utils;
import dwtx.draw2d.graph.DirectedGraph;

/**
 * Performs some action on a Graph.
 * @author Randy Hudson
 * @since 2.1.2
 */
abstract class GraphVisitor {

/**
 * Act on the given directed graph.
 * @param g the graph
 */
void visit(DirectedGraph g) { }

/**
 * Called in reverse order of visit.
 * @since 3.1
 * @param g the graph to act upon
 */
void revisit(DirectedGraph g) { }

}
