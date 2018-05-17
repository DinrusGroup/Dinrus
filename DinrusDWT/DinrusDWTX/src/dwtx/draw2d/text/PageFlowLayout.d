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
module dwtx.draw2d.text.PageFlowLayout;

import dwt.dwthelper.utils;
import dwtx.draw2d.text.BlockFlowLayout;
import dwtx.draw2d.text.FlowPage;

/**
 * A block layout which requires no FlowContext to perform its layout. This class is used
 * by {@link FlowPage}.
 * <p>
 * WARNING: This class is not intended to be subclassed by clients.
 */
public class PageFlowLayout
    : BlockFlowLayout
{

/**
 * Creates a new PageFlowLayout with the given FlowPage
 * @param page the FlowPage
 */
public this(FlowPage page) {
    super(page);
}

/**
 * @see dwtx.draw2d.text.BlockFlowLayout#getContextWidth()
 */
int getContextWidth() {
    return (cast(FlowPage)getFlowFigure()).getPageWidth();
}

}
