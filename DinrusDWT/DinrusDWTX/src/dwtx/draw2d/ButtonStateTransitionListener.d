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
module dwtx.draw2d.ButtonStateTransitionListener;

import dwt.dwthelper.utils;

class ButtonStateTransitionListener {

protected final void cancel() { }
public void canceled() { }
final void cancelled() { }

protected final void press() { }
public void pressed() { }

protected final void release() { }
public void released() { }

public void resume() { }

public void suspend() { }

}
