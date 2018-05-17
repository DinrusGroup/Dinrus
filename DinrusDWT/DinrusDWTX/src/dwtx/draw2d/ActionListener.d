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
module dwtx.draw2d.ActionListener;

import dwt.dwthelper.utils;
import tango.core.Traits;
import tango.core.Tuple;

import dwtx.draw2d.ActionEvent;

/**
 * A Listener interface for receiving {@link ActionEvent ActionEvents}.
 */
public interface ActionListener {

/**
 * Called when the action occurs.
 * @param event The event
 */
void actionPerformed(ActionEvent event);

}
// DWT Helper
private class _DgActionListenerT(Dg,T...) : ActionListener {

    alias ParameterTupleOf!(Dg) DgArgs;
    static assert( is(DgArgs == Tuple!(ActionEvent,T)),
                "Delegate args not correct" );

    Dg dg;
    T  t;

    private this( Dg dg, T t ){
        this.dg = dg;
        static if( T.length > 0 ){
            this.t = t;
        }
    }

    void actionPerformed( ActionEvent e ){
        dg(e,t);
    }
}

ActionListener dgActionListener( Dg, T... )( Dg dg, T args ){
    return new _DgActionListenerT!( Dg, T )( dg, args );
}
