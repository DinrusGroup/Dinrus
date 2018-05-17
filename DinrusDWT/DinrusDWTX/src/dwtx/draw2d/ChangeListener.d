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
module dwtx.draw2d.ChangeListener;

import dwt.dwthelper.utils;
import dwtx.draw2d.ChangeEvent;
import tango.core.Traits;
import tango.core.Tuple;

/**
 * A generic state listener
 */
public interface ChangeListener {

/**
 * Called when the listened to object's state has changed.
 * @param event the ChangeEvent
 */
void handleStateChanged(ChangeEvent event);

}

// DWT Helper
private class _DgChangeListenerT(Dg,T...) : ChangeListener {

    alias ParameterTupleOf!(Dg) DgArgs;
    static assert( is(DgArgs == Tuple!(ChangeEvent,T)),
                "Delegate args not correct" );

    Dg dg;
    T  t;

    private this( Dg dg, T t ){
        this.dg = dg;
        static if( T.length > 0 ){
            this.t = t;
        }
    }

    void handleStateChanged( ChangeEvent e ){
        dg(e,t);
    }
}

ChangeListener dgChangeListener( Dg, T... )( Dg dg, T args ){
    return new _DgChangeListenerT!( Dg, T )( dg, args );
}
