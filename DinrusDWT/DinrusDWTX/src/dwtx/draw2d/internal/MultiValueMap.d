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
module dwtx.draw2d.internal.MultiValueMap;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;

public class MultiValueMap {
    private HashMap map;

    public this(){
        map = new HashMap();
    }

    public ArrayList get(Object key) {
        Object value = map.get(key);
        if (value is null) return null;

        if (auto r = cast(ArrayList)value )
            return r;
        ArrayList v = new ArrayList(1);
        v.add(value);
        return v;
    }



    public void put(Object key, Object value) {
        Object existingValues = map.get(key);
        if (existingValues is null) {
            map.put(key, value);
            return;
        }
        if (auto v = cast(ArrayList)existingValues ) {
            if (!v.contains(value))
                v.add(value);
            return;
        }
        if (existingValues !is value) {
            ArrayList v = new ArrayList(2);
            v.add(existingValues);
            v.add(value);
            map.put(key, v);
        }
    }

    public int remove(Object key, Object value) {
        Object existingValues = map.get(key);
        if (existingValues !is null) {
            if (auto v = cast(ArrayList)existingValues ) {
                int result = v.indexOf(value);
                if (result is -1)
                    return -1;
                v.remove(result);
                if (v.isEmpty())
                    map.remove(key);
                return result;
            }
            if (map.remove(key) !is null)
                return 0;
        }
        return -1;
    }

    public Object removeValue(Object value) {
        Iterator iter = map.values().iterator();
        Object current;
        while (iter.hasNext()) {
            current = iter.next();
            if (value.opEquals(current)) {
                iter.remove();
                return value;
            } else if (auto curlist = cast(List)current ) {
                if (curlist.remove(value)) {
                    if (curlist.isEmpty())
                        iter.remove();
                    return value;
                }
            }
        }
        return null;
    }

    public int size() {
        return map.size();
    }
}
