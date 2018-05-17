module dwtx.dwtxhelper.Collection;

import dwt.dwthelper.utils;

static import tango.core.Exception;
static import tango.util.container.CircularList;
static import tango.util.container.HashMap;
static import tango.util.container.HashSet;
static import tango.util.container.SortedMap;
static import tango.util.container.more.Vector;
static import tango.core.Array;

//     class AListIterator {
//
//         ArraySeq!(Object) c;
//         int i;
//
//         this( ArraySeq!(Object) c ){
//             this.c = c;
//         }
//
//         Object next(){
//             return c.get(++i);
//         }
//         Object previous(){
//             return c.get(--i);
//         }
//
//         bool hasNext(){
//             return i+1 < c.size();
//         }
//         bool hasPrevious(){
//             return i > 0;
//         }
//
//         void remove(){
//             c.removeAt(i);
//             if( i is c.size() ) i--;
//         }
//         int nextIndex(){
//             return i+1;
//         }
//     }


interface Iterator {
    public bool hasNext();
    public Object next();
    public void  remove();
}

interface Enumeration {
    public bool hasMoreElements();
    public Object nextElement();
}

interface Collection {
    public bool     add(Object o);
    public bool     add(String o);
    public bool    addAll(Collection c);
    public void   clear();
    public bool    contains(Object o);
    public bool    containsAll(Collection c);
    public int    opEquals(Object o);
    public hash_t   toHash();
    public bool    isEmpty();
    public Iterator   iterator();
    public bool    remove(Object o);
    public bool    remove(String o);
    public bool    removeAll(Collection c);
    public bool    retainAll(Collection c);
    public int    size();
    public Object[]   toArray();
    public Object[]   toArray(Object[] a);

    // only for D
    public int opApply (int delegate(ref Object value) dg);
}

interface Map {
    interface Entry {
        int   opEquals(Object o);
        Object     getKey();
        Object     getValue();
        hash_t     toHash();
        Object     setValue(Object value);
    }
    public void clear();
    public bool containsKey(Object key);
    public bool containsKey(String key);
    public bool containsValue(Object value);
    public Set  entrySet();
    public int opEquals(Object o);
    public Object get(Object key);
    public Object get(String key);
    public hash_t toHash();
    public bool isEmpty();
    public Set    keySet();
    public Object put(Object key, Object value);
    public Object put(String key, Object value);
    public Object put(Object key, String value);
    public Object put(String key, String value);
    public void   putAll(Map t);
    public Object remove(Object key);
    public Object remove(String key);
    public int    size();
    public Collection values();

    // only for D
    public int opApply (int delegate(ref Object value) dg);
    public int opApply (int delegate(ref Object key, ref Object value) dg);
}

interface List : Collection {
    public void     add(int index, Object element);
    public bool     add(Object o);
    public bool     add(String o);
    public bool     addAll(Collection c);
    public bool     addAll(int index, Collection c);
    public void     clear();
    public bool     contains(Object o);
    public bool     contains(String o);
    public bool     containsAll(Collection c);
    public int      opEquals(Object o);
    public Object   get(int index);
    public hash_t   toHash();
    public int      indexOf(Object o);
    public bool     isEmpty();
    public Iterator iterator();
    public int      lastIndexOf(Object o);
    public ListIterator   listIterator();
    public ListIterator   listIterator(int index);
    public Object   remove(int index);
    public bool     remove(Object o);
    public bool     remove(String o);
    public bool     removeAll(Collection c);
    public bool     retainAll(Collection c);
    public Object   set(int index, Object element);
    public int      size();
    public List     subList(int fromIndex, int toIndex);
    public Object[] toArray();
    public Object[] toArray(Object[] a);
}

interface Set : Collection {
    public bool     add(Object o);
    public bool     add(String o);
    public bool     addAll(Collection c);
    public void     clear();
    public bool     contains(Object o);
    public bool     contains(String o);
    public bool     containsAll(Collection c);
    public int      opEquals(Object o);
    public hash_t   toHash();
    public bool     isEmpty();
    public Iterator iterator();
    public bool     remove(Object o);
    public bool     remove(String o);
    public bool     removeAll(Collection c);
    public bool     retainAll(Collection c);
    public int      size();
    public Object[] toArray();
    public Object[] toArray(Object[] a);
    public String   toString();

    // only for D
    public int opApply (int delegate(ref Object value) dg);
}

interface SortedSet : Set {
    Comparator     comparator();
    Object         first();
    SortedSet      headSet(Object toElement);
    Object         last();
    SortedSet      subSet(Object fromElement, Object toElement);
    SortedSet      tailSet(Object fromElement);
}

interface SortedMap : Map {
    Comparator     comparator();
    Object         firstKey();
    SortedMap      headMap(Object toKey);
    Object         lastKey();
    SortedMap      subMap(Object fromKey, Object toKey);
    SortedMap      tailMap(Object fromKey);
}

interface ListIterator : Iterator {
    public void   add(Object o);
    public bool   add(String o);
    public bool   hasNext();
    public bool   hasPrevious();
    public Object next();
    public int    nextIndex();
    public Object previous();
    public int    previousIndex();
    public void   remove();
    public void   set(Object o);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
class MapEntry : Map.Entry {
    Map map;
    Object key;
    private this( Map map, Object key){
        this.map = map;
        this.key = key;
    }
    public override int opEquals(Object o){
        if( auto other = cast(MapEntry)o){

            if(( getKey() is null ? other.getKey() is null : getKey() == other.getKey() )  &&
               ( getValue() is null ? other.getValue() is null : getValue() == other.getValue() )){
                return true;
            }
            return false;
        }
        return false;
    }
    public Object getKey(){
        return key;
    }
    public Object getValue(){
        return map.get(key);
    }
    public override hash_t toHash(){
        return ( getKey()   is null ? 0 : getKey().toHash()   ) ^
               ( getValue() is null ? 0 : getValue().toHash() );
    }
    public Object     setValue(Object value){
        return map.put( key, value );
    }

}

private struct ObjRef {
    Object obj;
    static ObjRef opCall( Object obj ){
        ObjRef res;
        res.obj = obj;
        return res;
    }
    public hash_t toHash(){
        return obj is null ? 0 : obj.toHash();
    }
    public int opEquals( ObjRef other ){
        return obj is null ? other.obj is null : obj.opEquals( other.obj );
    }
    public int opEquals( Object other ){
        return obj is null ? other is null : obj.opEquals( other );
    }
}

class HashMap : Map {
    // The HashMap  class is roughly equivalent to Hashtable, except that it is unsynchronized and permits nulls.
    alias tango.util.container.HashMap.HashMap!(ObjRef,ObjRef) MapType;
    private MapType map;

    public this(){
        map = new MapType();
    }
    public this(int initialCapacity){
        this();
    }
    public this(int initialCapacity, float loadFactor){
        map = new MapType(loadFactor);
    }
    public this(Map m){
        this();
        putAll(m);
    }
    public void clear(){
        map.clear();
    }
    public bool containsKey(Object key){
        ObjRef v;
        ObjRef keyr = ObjRef(key);
        return map.get(keyr, v );
    }
    public bool containsKey(String key){
        return containsKey(stringcast(key));
    }
    public bool containsValue(Object value){
        ObjRef valuer = ObjRef(value);
        return map.contains(valuer);
    }
    public Set  entrySet(){
        HashSet res = new HashSet();
        foreach( k, v; map ){
            res.add( new MapEntry(this,k.obj));
        }
        return res;
    }
    public override int opEquals(Object o){
        if( auto other = cast(HashMap) o ){
            if( other.size() !is size() ){
                return false;
            }
            foreach( k, v; map ){
                auto vo = other.get(k.obj);
                if( v != vo ){
                    return false;
                }
            }
            return true;
        }
        return false;
    }
    public Object get(Object key){
        ObjRef keyr = ObjRef(key);
        if( auto v = keyr in map ){
            return (*v).obj;
        }
        return null;
    }
    public Object get(String key){
        return get(stringcast(key));
    }
    public override hash_t toHash(){
        return super.toHash();
    }
    public bool isEmpty(){
        return map.isEmpty();
    }
    public Set    keySet(){
        HashSet res = new HashSet();
        foreach( k, v; map ){
            res.add(k.obj);
        }
        return res;
    }
    public Object put(Object key, Object value){
        ObjRef valuer = ObjRef(value);
        ObjRef keyr = ObjRef(key);
        Object res = null;
        if( auto vold = keyr in map ){
            res = (*vold).obj;
        }
        map[ keyr ] = valuer;
        return res;
    }
    public Object put(String key, Object value){
        return put( stringcast(key), value );
    }
    public Object put(Object key, String value){
        return put( key, stringcast(value) );
    }
    public Object put(String key, String value){
        return put( stringcast(key), stringcast(value) );
    }
    public void   putAll(Map t){
        foreach( k, v; t ){
            map[ObjRef(k)] = ObjRef(v);
        }
    }
    public Object remove(Object key){
        ObjRef keyr = ObjRef(key);
        if( auto v = keyr in map ){
            Object res = (*v).obj;
            map.remove(keyr);
            return res;
        }
        map.remove(keyr);
        return null;
    }
    public Object remove(String key){
        return remove(stringcast(key));
    }
    public int    size(){
        return map.size();
    }
    public Collection values(){
        ArrayList res = new ArrayList( size() );
        foreach( k, v; map ){
            res.add( v.obj );
        }
        return res;
    }

    public int opApply (int delegate(ref Object value) dg){
        int ldg( ref ObjRef or ){
            return dg( or.obj );
        }
        return map.opApply( &ldg );
    }
    public int opApply (int delegate(ref Object key, ref Object value) dg){
        int ldg( ref ObjRef key, ref ObjRef value ){
            return dg( key.obj, value.obj );
        }
        return map.opApply( &ldg );
    }

}

class IdentityHashMap : Map {
    alias tango.util.container.HashMap.HashMap!(Object,Object) MapType;
    private MapType map;

    public this(){
        implMissing(__FILE__, __LINE__ );
        map = new MapType();
    }
    public this(int initialCapacity){
        implMissing(__FILE__, __LINE__ );
        this();
    }
    public this(int initialCapacity, float loadFactor){
        implMissing(__FILE__, __LINE__ );
        map = new MapType(loadFactor);
    }
    public this(Map m){
        implMissing(__FILE__, __LINE__ );
        this();
        putAll(m);
    }
    public void clear(){
        map.clear();
    }
    public bool containsKey(Object key){
        Object v;
        return map.get(key, v );
    }
    public bool containsKey(String key){
        return containsKey(stringcast(key));
    }
    public bool containsValue(Object value){
        return map.contains(value);
    }
    public Set  entrySet(){
        HashSet res = new HashSet();
        foreach( k, v; map ){
            res.add( new MapEntry(this,k));
        }
        return res;
    }
    public override int opEquals(Object o){
        if( auto other = cast(HashMap) o ){
            if( other.size() !is size() ){
                return false;
            }
            foreach( k, v; map ){
                Object vo = other.get(k);
                if( v != vo ){
                    return false;
                }
            }
            return true;
        }
        return false;
    }
    public Object get(Object key){
        if( auto v = key in map ){
            return *v;
        }
        return null;
    }
    public Object get(String key){
        return get(stringcast(key));
    }
    public override hash_t toHash(){
        return super.toHash();
    }
    public bool isEmpty(){
        return map.isEmpty();
    }
    public Set    keySet(){
        HashSet res = new HashSet();
        foreach( k, v; map ){
            res.add(k);
        }
        return res;
    }
    public Object put(Object key, Object value){
        Object res = null;
        if( auto vold = key in map ){
            res = *vold;
        }
        map[ key ] = value;
        return res;
    }
    public Object put(String key, Object value){
        return put( stringcast(key), value );
    }
    public Object put(Object key, String value){
        return put( key, stringcast(value) );
    }
    public Object put(String key, String value){
        return put( stringcast(key), stringcast(value) );
    }
    public void   putAll(Map t){
        foreach( k, v; t ){
            map[k] = v;
        }
    }
    public Object remove(Object key){
        if( auto v = key in map ){
            Object res = *v;
            map.remove(key);
            return res;
        }
        map.remove(key);
        return null;
    }
    public Object remove(String key){
        return remove(stringcast(key));
    }
    public int    size(){
        return map.size();
    }
    public Collection values(){
        ArrayList res = new ArrayList( size() );
        foreach( k, v; map ){
            res.add( v );
        }
        return res;
    }

    public int opApply (int delegate(ref Object value) dg){
        return map.opApply( dg );
    }
    public int opApply (int delegate(ref Object key, ref Object value) dg){
        return map.opApply( dg );
    }
}

class Dictionary {
    public this(){
    }
    abstract  Enumeration   elements();
    abstract  Object        get(Object key);
    Object        get(String key){
        return get(stringcast(key));
    }
    abstract  bool          isEmpty();
    abstract  Enumeration   keys();
    abstract  Object        put(Object key, Object value);
    public Object put(String key, Object value){
        return put(stringcast(key), value);
    }
    public Object put(Object key, String value){
        return put(key, stringcast(value));
    }
    public Object put(String key, String value){
        return put(stringcast(key), stringcast(value));
    }
    abstract  Object        remove(Object key);
    public Object remove(String key){
        return remove(stringcast(key));
    }
    abstract  int   size();
}


// no nulls
// synchronized
class Hashtable : Dictionary, Map {

    public Object get(String key){
        return super.get(key);
    }
    public Object put(String key, Object value){
        return super.put(key, value);
    }
    public Object put(Object key, String value){
        return super.put(key, value);
    }
    public Object put(String key, String value){
        return super.put(key, value);
    }
    public Object remove(String key){
        return super.remove(key);
    }

    Object[Object] map;

    // The HashMap  class is roughly equivalent to Hashtable, except that it is unsynchronized and permits nulls.
    public this(){
    }
    public this(int initialCapacity){
        implMissing( __FILE__, __LINE__ );
    }
    public this(int initialCapacity, float loadFactor){
        implMissing( __FILE__, __LINE__ );
    }
    public this(Map t){
        implMissing( __FILE__, __LINE__ );
    }

    class ObjectEnumeration : Enumeration {
        Object[] values;
        int index = 0;
        this( Object[] values ){
            this.values = values;
        }
        public bool hasMoreElements(){
            return index < values.length;
        }
        public Object nextElement(){
            Object res = values[index];
            index++;
            return res;
        }
    }

    Enumeration  elements(){
        return new ObjectEnumeration( map.values );
    }
    Enumeration        keys() {
        return new ObjectEnumeration( map.keys );
    }
    public synchronized void clear(){
        map = null;
    }
    public synchronized bool containsKey(Object key){
        if( auto v = key in map ){
            return true;
        }
        return false;
    }
    public synchronized bool containsKey(String key){
        return containsKey(stringcast(key));
    }
    public synchronized bool containsValue(Object value){
        foreach( k, v; map ){
            if( v == value ){
                return true;
            }
        }
        return false;
    }
    public Set  entrySet(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public int opEquals(Object o){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    public synchronized Object get(Object key){
        if( auto v = key in map ){
            return *v;
        }
        return null;
    }
    public hash_t toHash(){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    public synchronized bool isEmpty(){
        return map.length is 0;
    }
    public Set    keySet(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public synchronized Object put(Object key, Object value){
        Object res = null;
        if( auto v = key in map ){
            res = *v;
        }
        map[ key ] = value;
        return res;
    }
//     public Object put(String key, Object value)
//     public Object put(Object key, String value)
//     public Object put(String key, String value)
    public synchronized void   putAll(Map t){
        implMissing( __FILE__, __LINE__ );
    }
    public synchronized Object remove(Object key){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
//     public Object remove(String key)
    public synchronized int    size(){
        return map.length;
    }
    public Collection values(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }

    // only for D
    public int opApply (int delegate(ref Object value) dg){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    public int opApply (int delegate(ref Object key, ref Object value) dg){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }

}

abstract class AbstractMap : Map {
    public this(){
        implMissing( __FILE__, __LINE__ );
    }
    void   clear(){
        implMissing( __FILE__, __LINE__ );
    }
    protected  Object       clone(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    bool        containsKey(Object key){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    bool        containsValue(Object value){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    abstract  Set   entrySet();

    public override int       opEquals(Object o){
        if( Map other = cast(Map)o){
            return entrySet().opEquals( cast(Object) other.entrySet() );
        }
        return false;
    }

    Object         get(Object key){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public override hash_t    toHash(){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    bool        isEmpty(){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    Set    keySet(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    Object         put(Object key, Object value){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    void   putAll(Map t){
        implMissing( __FILE__, __LINE__ );
    }
    Object         remove(Object key){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    int    size(){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    String         toString(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    Collection     values(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
}

class TreeMap : Map, SortedMap {
    alias tango.util.container.SortedMap.SortedMap!(Object,Object) MapType;
    private MapType map;

    public this(){
        map = new MapType();
    }
    public this(Comparator c){
        implMissing( __FILE__, __LINE__ );
    }
    public this(Map m){
        implMissing( __FILE__, __LINE__ );
    }
    public this(SortedMap m){
        implMissing( __FILE__, __LINE__ );
    }
    public void clear(){
        map.clear();
    }
    Comparator     comparator(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public bool containsKey(Object key){
        Object v;
        return map.get(key, v );
    }
    public bool containsKey(String key){
        return containsKey(stringcast(key));
    }
    public bool containsValue(Object value){
        return map.contains(value);
    }
    public Set  entrySet(){
        TreeSet res = new TreeSet();
        foreach( k, v; map ){
            res.add( new MapEntry(this,k) );
        }
        return res;
    }
    public override int opEquals(Object o){
        if( auto other = cast(TreeMap) o ){
            if( other.size() !is size() ){
                return false;
            }
            foreach( k, v; map ){
                Object vo = other.get(k);
                if( v != vo ){
                    return false;
                }
            }
            return true;
        }
        return false;
    }
    Object         firstKey(){
        foreach( k; map ){
            return k;
        }
        throw new tango.core.Exception.NoSuchElementException( "TreeMap.firstKey" );
    }
    public Object get(Object key){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public Object get(String key){
        return get(stringcast(key));
    }
    public override hash_t toHash(){
        // http://java.sun.com/j2se/1.4.2/docs/api/java/util/AbstractMap.html#hashCode()
        hash_t res = 0;
        foreach( e; entrySet() ){
            res += e.toHash();
        }
        return res;
    }
    SortedMap headMap(Object toKey){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public bool isEmpty(){
        return map.isEmpty();
    }
    public Set keySet(){
        TreeSet res = new TreeSet();
        foreach( k; map ){
            res.add( k );
        }
        return res;
    }
    Object lastKey(){
        Object res;
        foreach( k; map ){
            res = k;
        }
        if( map.size() ) return res;
        throw new tango.core.Exception.NoSuchElementException( "TreeMap.lastKey" );
    }
    public Object put(Object key, Object value){
        if( map.contains(key) ){ // TODO if tango has opIn_r, then use the "in" operator
            Object res = map[key];
            map[key] = value;
            return res;
        }
        map[key] = value;
        return null;
    }
    public Object put(String key, Object value){
        return put(stringcast(key), value);
    }
    public Object put(Object key, String value){
        return put(key, stringcast(value));
    }
    public Object put(String key, String value){
        return put(stringcast(key), stringcast(value));
    }
    public void   putAll(Map t){
        foreach( k, v; t ){
            put( k, v );
        }
    }
    public Object remove(Object key){
        Object res;
        map.take(key,res);
        return res;
    }
    public Object remove(String key){
        return remove(stringcast(key));
    }
    public int    size(){
        return map.size();
    }
    SortedMap      subMap(Object fromKey, Object toKey){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    SortedMap      tailMap(Object fromKey){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public Collection values(){
        ArrayList res = new ArrayList( size() );
        foreach( k, v; map ){
            res.add( v );
        }
        return res;
    }

    public int opApply (int delegate(ref Object value) dg){
        return map.opApply( dg );
    }
    public int opApply (int delegate(ref Object key, ref Object value) dg){
        return map.opApply( dg );
    }
}

class HashSet : Set {
    alias tango.util.container.HashSet.HashSet!(Object) SetType;
    private SetType set;

    public this(){
        set = new SetType();
    }
    public this(Collection c){
        implMissing( __FILE__, __LINE__ );
    }
    public this(int initialCapacity){
        implMissing( __FILE__, __LINE__ );
    }
    public this(int initialCapacity, float loadFactor){
        implMissing( __FILE__, __LINE__ );
    }
    public bool    add(Object o){
        return set.add(o);
    }
    public bool    add(String o){
        return add(stringcast(o));
    }
    public bool    addAll(Collection c){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    public void   clear(){
        set.clear();
    }
    public bool    contains(Object o){
        return set.contains(o);
    }
    public bool     contains(String o){
        return contains(stringcast(o));
    }
    public bool    containsAll(Collection c){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    public override int    opEquals(Object o){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    public override hash_t    toHash(){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    public bool    isEmpty(){
        return set.isEmpty();
    }
    class LocalIterator : Iterator {
        SetType.Iterator iter;
        Object nextElem;
        this( SetType.Iterator iter){
            this.iter = iter;
        }
        public bool hasNext(){
            return iter.next(nextElem);
        }
        public Object next(){
            return nextElem;
        }
        public void  remove(){
            iter.remove();
        }
    }
    public Iterator   iterator(){
        return new LocalIterator(set.iterator());
    }
    public bool    remove(Object o){
        return set.remove(o);
    }
    public bool remove(String key){
        return remove(stringcast(key));
    }
    public bool    removeAll(Collection c){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    public bool    retainAll(Collection c){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    public int    size(){
        return set.size();
    }
    public Object[]   toArray(){
        Object[] res;
        res.length = size();
        int idx = 0;
        foreach( o; set ){
            res[idx] = o;
            idx++;
        }
        return res;
    }
    public Object[]   toArray(Object[] a){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public override String toString(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }

    // only for D
    public int opApply (int delegate(ref Object value) dg){
        return set.opApply(dg);
    }

}

abstract class AbstractCollection : Collection {
    this(){
    }
    bool        add(Object o){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    bool        addAll(Collection c){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    void   clear(){
        implMissing( __FILE__, __LINE__ );
    }
    bool        contains(Object o){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    bool        containsAll(Collection c){
        if( c is null ) throw new NullPointerException();
        foreach( o; c ){
            if( !contains(o) ) return false;
        }
        return true;
    }
    override int opEquals(Object o){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    bool        isEmpty(){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    abstract  Iterator      iterator();
    override hash_t toHash(){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    bool        remove(Object o){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    bool        remove(String o){
        return remove(stringcast(o));
    }
    bool        removeAll(Collection c){
        if( c is null ) throw new NullPointerException();
        bool res = false;
        foreach( o; c ){
            res |= remove(o);
        }
        return res;
    }
    bool        retainAll(Collection c){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    abstract  int   size();
    Object[]       toArray(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    Object[]       toArray(Object[] a){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    String         toString(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
}

abstract class AbstractSet : AbstractCollection, Set {
    this(){
    }
    int         opEquals(Object o){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    hash_t      toHash(){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    bool        removeAll(Collection c){
        return super.removeAll(c);
    }
    public abstract bool     add(Object o);
    public abstract bool     add(String o);
    public abstract bool     addAll(Collection c);
    public abstract void     clear();
    public abstract bool     contains(Object o);
    public abstract bool     contains(String o);
    public abstract bool     containsAll(Collection c);


    public abstract bool     isEmpty();
    public abstract Iterator iterator();
    public abstract bool     remove(Object o);
    public abstract bool     remove(String o);
    public abstract bool     removeAll(Collection c);
    public abstract bool     retainAll(Collection c);
    public abstract int      size();
    public abstract Object[] toArray();
    public abstract Object[] toArray(Object[] a);
    public abstract String   toString(){
        return super.toString();
    }

    // only for D
    public abstract int opApply (int delegate(ref Object value) dg);
}

abstract class AbstractList : AbstractCollection, List {
    this(){
    }

    public abstract void   add(int index, Object element);
    public abstract bool        add(Object o);
    public abstract bool     addAll(Collection c);
    public abstract bool        addAll(int index, Collection c);
    public abstract void   clear();
    public abstract bool     contains(Object o);
    public bool contains(String str){
        return contains(stringcast(str));
    }
    public abstract bool     containsAll(Collection c);
    public abstract int  opEquals(Object o);
    public abstract  Object        get(int index);

    public hash_t  toHash(){
        // http://java.sun.com/j2se/1.4.2/docs/api/java/util/List.html#hashCode()
        hash_t hashCode = 1;
        Iterator i = iterator();
        while (i.hasNext()) {
            Object obj = i.next();
            hashCode = 31 * hashCode + (obj is null ? 0 : obj.toHash());
        }
        return hashCode;
    }

    public abstract int    indexOf(Object o);
    public abstract bool     isEmpty();
    public abstract Iterator       iterator();
    public abstract int    lastIndexOf(Object o);
    public abstract ListIterator   listIterator();
    public abstract ListIterator   listIterator(int index);
    public abstract Object         remove(int index);
    protected abstract void         removeRange(int fromIndex, int toIndex);
    public abstract bool     remove(Object o);
    public abstract bool     remove(String o);
    public abstract bool     removeAll(Collection c);
    public abstract bool     retainAll(Collection c);
    public abstract Object         set(int index, Object element);
    public abstract List   subList(int fromIndex, int toIndex);
    public abstract Object[] toArray();
    public abstract Object[] toArray(Object[] a);

}

class TreeSet : AbstractSet, SortedSet {

    alias tango.util.container.SortedMap.SortedMap!(Object,int) SetType;
    private SetType set;

    public this(){
        set = new SetType();
    }
    public this(Collection c){
        implMissing( __FILE__, __LINE__ );
    }
    public this(Comparator c){
        implMissing( __FILE__, __LINE__ );
    }
    public this(SortedSet){
        implMissing( __FILE__, __LINE__ );
    }

    public bool    add(Object o){
        return set.add(o, 0);
    }
    public bool    add(String o){
        return add(stringcast(o));
    }
    public bool    addAll(Collection c){
        foreach( o; c ){
            add(o);
        }
        return true;
    }
    public void   clear(){
        set.clear();
    }
    public bool    contains(Object o){
        return set.containsKey(o);
    }
    public bool     contains(String o){
        return contains(stringcast(o));
    }
    public bool    containsAll(Collection c){
        foreach( o; c ){
            if( !contains(o) ){
                return false;
            }
        }
        return true;
    }
    public Comparator     comparator(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public override int    opEquals(Object o){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    public Object         first(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public override hash_t    toHash(){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    public SortedSet      headSet(Object toElement){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public bool    isEmpty(){
        return set.isEmpty();
    }
    public Iterator   iterator(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public Object         last(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public bool    remove(Object o){
        return false;
    }
    public bool remove(String key){
        return remove(stringcast(key));
    }
    public bool    removeAll(Collection c){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    public bool    retainAll(Collection c){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    public int    size(){
        return set.size();
    }
    public SortedSet      subSet(Object fromElement, Object toElement){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public SortedSet      tailSet(Object fromElement){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public Object[]   toArray(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public Object[]   toArray(Object[] a){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public override String toString(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }


    // only for D
    public int opApply (int delegate(ref Object value) dg){
        int localDg( ref Object key, ref int value ){
            return dg( key );
        }
        return set.opApply(&localDg);
    }
}

class Vector : AbstractList, List {
    Object[] vect;
    int used;
    int capacityIncrement = 32;
    public this(){
    }
    public this(Collection c){
        implMissing( __FILE__, __LINE__ );
    }
    public this(int initialCapacity){
        vect.length = initialCapacity;
    }
    public this(int initialCapacity, int capacityIncrement){
        implMissing( __FILE__, __LINE__ );
    }
    public void   add(int index, Object element){
        implMissing( __FILE__, __LINE__ );
    }
    public bool    add(Object o){
        if( used + 1 >= vect.length ){
            vect.length = vect.length + capacityIncrement;
        }
        vect[used] = o;
        used++;
        return true;
    }
    public bool    add(String o){
        return add(stringcast(o));
    }
    public bool    addAll(Collection c){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    public bool    addAll(int index, Collection c){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    public void   addElement(Object obj){
        add(obj);
    }
    public int    capacity(){
        return vect.length;
    }
    public void   clear(){
        used = 0;
    }
    public Object     clone(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public bool    contains(Object elem){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    public bool    contains(String str){
        return contains(stringcast(str));
    }
    public bool    containsAll(Collection c){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    public void   copyInto(Object[] anArray){
        implMissing( __FILE__, __LINE__ );
    }
    public Object     elementAt(int index){
        return get(index);
    }
    public Enumeration    elements(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
   public  void   ensureCapacity(int minCapacity){
        implMissing( __FILE__, __LINE__ );
    }
    public int opEquals(Object o){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    public Object     firstElement(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public Object     get(int index){
        if( index >= used || index < 0 ){
            throw new tango.core.Exception.ArrayBoundsException( __FILE__, __LINE__ );
        }
        return vect[index];
    }
    public hash_t    toHash(){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    public int    indexOf(Object elem){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    public int    indexOf(Object elem, int index){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    public void   insertElementAt(Object obj, int index){
        implMissing( __FILE__, __LINE__ );
    }
    public bool    isEmpty(){
        return used is 0;
    }
    public Iterator   iterator(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public Object     lastElement(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public int    lastIndexOf(Object elem){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    public int    lastIndexOf(Object elem, int index){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    public ListIterator   listIterator(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public ListIterator   listIterator(int index){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public Object     remove(int index){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public bool    remove(Object o){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    public bool remove(String key){
        return remove(stringcast(key));
    }
    public bool    removeAll(Collection c){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    public void   removeAllElements(){
        implMissing( __FILE__, __LINE__ );
    }
    public bool    removeElement(Object obj){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    public void   removeElementAt(int index){
        implMissing( __FILE__, __LINE__ );
    }
    protected  void     removeRange(int fromIndex, int toIndex){
        implMissing( __FILE__, __LINE__ );
    }
    public bool    retainAll(Collection c){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    public Object     set(int index, Object element){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public void   setElementAt(Object obj, int index){
        implMissing( __FILE__, __LINE__ );
    }
    public void   setSize(int newSize){
        implMissing( __FILE__, __LINE__ );
    }
    public int    size(){
        return used;
    }
    public List   subList(int fromIndex, int toIndex){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public Object[]   toArray(){
        return vect[ 0 .. used ].dup;
    }
    public Object[]   toArray(Object[] a){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public String     toString(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public void   trimToSize(){
        implMissing( __FILE__, __LINE__ );
    }

    // only for D
    public int opApply (int delegate(ref Object value) dg){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }

}

class Stack : Vector {
    this(){
    }
    void   add(int index, Object element){
        implMissing( __FILE__, __LINE__ );
    }
    bool    add(Object o){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    public bool    add(String o){
        return add(stringcast(o));
    }
    bool    addAll(Collection c){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    bool    addAll(int index, Collection c){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    void   addElement(Object obj){
        implMissing( __FILE__, __LINE__ );
    }
    int    capacity(){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    void   clear(){
        implMissing( __FILE__, __LINE__ );
    }
    Object     clone(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    bool    contains(Object elem){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    bool    containsAll(Collection c){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    void   copyInto(Object[] anArray){
        implMissing( __FILE__, __LINE__ );
    }
    Object     elementAt(int index){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
//     Enumeration    elements(){
//         implMissing( __FILE__, __LINE__ );
//         return null;
//     }
    void   ensureCapacity(int minCapacity){
        implMissing( __FILE__, __LINE__ );
    }
    int opEquals(Object o){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    Object     firstElement(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    Object     get(int index){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    hash_t    toHash(){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    int    indexOf(Object elem){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    int    indexOf(Object elem, int index){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    void   insertElementAt(Object obj, int index){
        implMissing( __FILE__, __LINE__ );
    }
//     bool    isEmpty(){
//         implMissing( __FILE__, __LINE__ );
//         return false;
//     }
    Iterator   iterator(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    Object     lastElement(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    int    lastIndexOf(Object elem){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    int    lastIndexOf(Object elem, int index){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    ListIterator   listIterator(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    ListIterator   listIterator(int index){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    Object     remove(int index){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    bool    remove(Object o){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    public bool remove(String key){
        return remove(stringcast(key));
    }
    bool    removeAll(Collection c){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    void   removeAllElements(){
        implMissing( __FILE__, __LINE__ );
    }
    bool    removeElement(Object obj){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    void   removeElementAt(int index){
        implMissing( __FILE__, __LINE__ );
    }
    protected  void     removeRange(int fromIndex, int toIndex){
        implMissing( __FILE__, __LINE__ );
    }
    bool    retainAll(Collection c){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    Object     set(int index, Object element){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    void   setElementAt(Object obj, int index){
        implMissing( __FILE__, __LINE__ );
    }
    void   setSize(int newSize){
        implMissing( __FILE__, __LINE__ );
    }
    int    size(){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    List   subList(int fromIndex, int toIndex){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    Object[]   toArray(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    Object[]   toArray(Object[] a){
        implMissing( __FILE__, __LINE__ );
        return null;
    }

    // from Stack
    String     toString(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    void   trimToSize(){
        implMissing( __FILE__, __LINE__ );
    }
    bool     empty(){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    Object     peek(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    Object     pop(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    Object     push(Object item){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    int    search(Object o){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }

    // only for D
    public int opApply (int delegate(ref Object value) dg){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }

}

class LinkedList : List {
    alias tango.util.container.CircularList.CircularList!(Object) ListType;
    private ListType list;

    this(){
        list = new ListType();
    }
    this( Collection c ){
        this();
        addAll(c);
    }
    void   add(int index, Object element){
        list.addAt(index,element);
        //return true;
    }
    bool    add(Object o){
        list.add(o);
        return true;
    }
    public bool    add(String o){
        return add(stringcast(o));
    }
    bool    addAll(Collection c){
        if( c is null ) throw new NullPointerException();
        bool res = false;
        foreach( o; c ){
            res |= add( o );
        }
        return res;
    }
    bool    addAll(int index, Collection c){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    void   addFirst(Object o){
        list.prepend( o );
    }
    void   addLast(Object o){
        list.append( o );
    }
//     void   addElement(Object obj){
//         implMissing( __FILE__, __LINE__ );
//     }
    int    capacity(){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    void   clear(){
        list.clear();
    }
    Object     clone(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    bool    contains(Object elem){
        return list.contains(elem);
    }
    bool    contains(String elem){
        return contains(stringcast(elem));
    }
    bool    containsAll(Collection c){
        foreach(o; c){
            if( !list.contains(o)) return false;
        }
        return true;
    }
    void   copyInto(Object[] anArray){
        implMissing( __FILE__, __LINE__ );
    }
    Object     elementAt(int index){
        return list.get(index);
    }
//     Enumeration    elements(){
//         implMissing( __FILE__, __LINE__ );
//         return null;
//     }
    void   ensureCapacity(int minCapacity){
        implMissing( __FILE__, __LINE__ );
    }
    int opEquals(Object o){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    Object     firstElement(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    Object     get(int index){
        return list.get(index);
    }
    Object     getFirst(){
        return list.get(0);
    }
    Object     getLast(){
        return list.get(list.size()-1);
    }
    hash_t    toHash(){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    int    indexOf(Object elem){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    int    indexOf(Object elem, int index){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    void   insertElementAt(Object obj, int index){
        implMissing( __FILE__, __LINE__ );
    }
    bool    isEmpty(){
        return list.isEmpty();
    }
    Iterator   iterator(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    Object     lastElement(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    int    lastIndexOf(Object elem){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    int    lastIndexOf(Object elem, int index){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    ListIterator   listIterator(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    ListIterator   listIterator(int index){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    Object     remove(int index){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    bool    remove(Object o){
        return list.remove(o,false) !is 0;
    }
    public bool remove(String key){
        return remove(stringcast(key));
    }
    bool    removeAll(Collection c){
        bool res = false;
        foreach( o; c){
            res |= list.remove(o,false) !is 0;
        }
        return res;
    }
    void   removeAllElements(){
        implMissing( __FILE__, __LINE__ );
    }
    Object     removeFirst(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    Object     removeLast(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    bool    removeElement(Object obj){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    void   removeElementAt(int index){
        implMissing( __FILE__, __LINE__ );
    }
    protected  void     removeRange(int fromIndex, int toIndex){
        implMissing( __FILE__, __LINE__ );
    }
    bool    retainAll(Collection c){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    Object     set(int index, Object element){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    void   setElementAt(Object obj, int index){
        implMissing( __FILE__, __LINE__ );
    }
    void   setSize(int newSize){
        implMissing( __FILE__, __LINE__ );
    }
    int    size(){
        return list.size();
    }
    List   subList(int fromIndex, int toIndex){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    Object[]   toArray(){
        if( list.size() is 0 ) return null; // workaround tango ticket 1237
        return list.toArray();
    }
    Object[]   toArray(Object[] a){
        if( list.size() is 0 ) return a[0 .. 0]; // workaround tango ticket 1237
        return list.toArray( a );
    }
    String     toString(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    void   trimToSize(){
        implMissing( __FILE__, __LINE__ );
    }

    // only for D
    public int opApply (int delegate(ref Object value) dg){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }

}

class ArrayList : AbstractList, List {
    private Object[] data;

    this(){
    }
    this(int size){
        data.length = size;
        data.length = 0;
    }
    this(Collection col){
        this(cast(int)(col.size*1.1));
        addAll(col);
    }
    void   add(int index, Object element){
        data.length = data.length +1;
        System.arraycopy( data, index, data, index+1, data.length - index -1 );
        data[index] = element;
    }
    bool    add(Object o){
        data ~= o;
        return true;
    }
    public bool    add(String o){
        return add(stringcast(o));
    }
    bool    addAll(Collection c){
        if( c.size() is 0 ) return false;
        uint idx = data.length;
        data.length = data.length + c.size();
        foreach( o; c ){
            data[ idx++ ] = o;
        }
        return true;
    }
    bool    addAll(int index, Collection c){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    void   clear(){
        data.length = 0;
    }
    ArrayList clone(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    bool    contains(Object o){
        foreach( v; data ){
            if( o is v ){
                return true;
            }
            if(( o is null ) || ( v is null )){
                continue;
            }
            if( o == v ){
                return true;
            }
        }
        return false;
    }
    bool    contains(String o){
        return contains(stringcast(o));
    }
    bool    containsAll(Collection c){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    int opEquals(Object o){
        if( auto other = cast(ArrayList)o ){
            if( data.length !is other.data.length ){
                return false;
            }
            for( int i = 0; i < data.length; i++ ){
                if( data[i] is other.data[i] ){
                    continue;
                }
                if(( data[i] is null ) || ( other.data[i] is null )){
                    return false;
                }
                if( data[i] == other.data[i] ){
                    continue;
                }
                return false;
            }
            return true;
        }
        return false;
    }
    Object     get(int index){
        return data[index];
    }
    public override hash_t toHash(){
        return super.toHash();
    }
    int    indexOf(Object o){
        foreach( i, v; data ){
            if( data[i] is o ){
                return i;
            }
            if(( data[i] is null ) || ( o is null )){
                continue;
            }
            if( data[i] == o ){
                return i;
            }
        }
        return -1;
    }
    bool    isEmpty(){
        return data.length is 0;
    }
    class LocalIterator : Iterator{
        int idx = -1;
        public this(){
        }
        public bool hasNext(){
            return idx+1 < data.length;
        }
        public Object next(){
            idx++;
            Object res = data[idx];
            return res;
        }
        public void  remove(){
            implMissing( __FILE__, __LINE__ );
            this.outer.remove(idx);
            idx--;
        }
    }

    Iterator   iterator(){
        return new LocalIterator();
    }
    int    lastIndexOf(Object o){
        foreach_reverse( i, v; data ){
            if( data[i] is o ){
                return i;
            }
            if(( data[i] is null ) || ( o is null )){
                continue;
            }
            if( data[i] == o ){
                return i;
            }
        }
        return -1;
    }

    class LocalListIterator : ListIterator {
        int idx_next = 0;
        public bool hasNext(){
            return idx_next < data.length;
        }
        public Object next(){
            Object res = data[idx_next];
            idx_next++;
            return res;
        }
        public void  remove(){
            implMissing( __FILE__, __LINE__ );
            this.outer.remove(idx_next);
            idx_next--;
        }
        public void   add(Object o){
            implMissing( __FILE__, __LINE__ );
        }
        public bool   add(String o){
            implMissing( __FILE__, __LINE__ );
            return false;
        }
        public bool   hasPrevious(){
            return idx_next > 0;
        }
        public int    nextIndex(){
            return idx_next;
        }
        public Object previous(){
            idx_next--;
            Object res = data[idx_next];
            return res;
        }
        public int    previousIndex(){
            return idx_next-1;
        }
        public void   set(Object o){
            implMissing( __FILE__, __LINE__ );
        }
    }

    ListIterator   listIterator(){
        return new LocalListIterator();
    }
    ListIterator   listIterator(int index){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    Object     remove(int index){
        Object res = data[index];
        System.arraycopy( data, index+1, data, index, data.length - index - 1 );
        data.length = data.length -1;
        return res;
    }
    bool    remove(Object o){
        return tango.core.Array.remove(data, o) !is 0;
    }
    public bool remove(String key){
        return remove(stringcast(key));
    }
    bool    removeAll(Collection c){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    bool    retainAll(Collection c){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    protected  void     removeRange(int fromIndex, int toIndex){
        implMissing( __FILE__, __LINE__ );
    }
    Object     set(int index, Object element){
        Object res = data[index];
        data[index] = element;
        return res;
    }
    int    size(){
        return data.length;
    }
    List   subList(int fromIndex, int toIndex){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    Object[]   toArray(){
        return data.dup;
    }
    Object[]   toArray(Object[] a){
        if( data.length <= a.length ){
            a[ 0 .. data.length ] = data;
        }
        else{
            return data.dup;
        }
        if( data.length < a.length ){
            a[data.length] = null;
        }
        return a;
    }

    // only for D
    public int opApply (int delegate(ref Object value) dg){
        foreach( o; data ){
            auto res = dg( o );
            if( res ) return res;
        }
        return 0;
    }
}

class Arrays {
    public static bool equals(T)(T[] a, T[] b){
        if( a.length !is b.length ){
            return false;
        }
        for( int i = 0; i < a.length; i++ ){
            if( a[i] is null && b[i] is null ){
                continue;
            }
            if( a[i] !is null && b[i] !is null && a[i] == b[i] ){
                continue;
            }
            return false;
        }
        return true;
    }
/+    public static bool equals(Object[] a, Object[] b){
        if( a.length !is b.length ){
            return false;
        }
        for( int i = 0; i < a.length; i++ ){
            if( a[i] is null && b[i] is null ){
                continue;
            }
            if( a[i] !is null && b[i] !is null && a[i] == b[i] ){
                continue;
            }
            return false;
        }
        return true;
    }
+/
    static void sort( T )( T[] a, Comparator c ){
        static if( is( T : char[] )){
            bool isLess( String o1, String o2 ){
                return c.compare( stringcast(o1), stringcast(o2) ) < 0;
            }
        }
        else{
            bool isLess( T o1, T o2 ){
                return c.compare( cast(Object)o1, cast(Object)o2 ) < 0;
            }
        }
        tango.core.Array.sort( a, &isLess );
    }
    static List    asList(Object[] a) {
        if( a.length is 0 ) return Collections.EMPTY_LIST;
        ArrayList res = new ArrayList( a.length );
        foreach( o; a ){
            res.add(o);
        }
        return res;
    }
    public static void fill( String str, char c ){
        str[] = c;
    }
}

class Collections {
    private static void unsupported(){
        throw new UnsupportedOperationException();
    }

    private static List EMPTY_LIST_;
    public static List EMPTY_LIST(){
        if( EMPTY_LIST_ is null ){
            synchronized(Collections.classinfo ){
                if( EMPTY_LIST_ is null ){
                    EMPTY_LIST_ = new ArrayList(0);
                }
            }
        }
        return EMPTY_LIST_;
    }
    private static Map EMPTY_MAP_;
    public static Map EMPTY_MAP(){
        if( EMPTY_MAP_ is null ){
            synchronized(Collections.classinfo ){
                if( EMPTY_MAP_ is null ){
                    EMPTY_MAP_ = new TreeMap();
                }
            }
        }
        return EMPTY_MAP_;
    }
    private static Set EMPTY_SET_;
    public static Set EMPTY_SET(){
        if( EMPTY_SET_ is null ){
            synchronized(Collections.classinfo ){
                if( EMPTY_SET_ is null ){
                    EMPTY_SET_ = new TreeSet();
                }
            }
        }
        return EMPTY_SET_;
    }
    static class UnmodifiableIterator : Iterator {
        Iterator it;
        this(Iterator it){
            this.it = it;
        }
        public bool hasNext(){
            return it.hasNext();
        }
        public Object next(){
            return it.next();
        }
        public void  remove(){
            unsupported();
        }
    }
    static class UnmodifiableListIterator : ListIterator {
        ListIterator it;
        this(ListIterator it){
            this.it = it;
        }
        public void   add(Object o){
            unsupported();
        }
        public bool   add(String o){
            unsupported();
            return false; // make compiler happy
        }
        public bool   hasNext(){
            return it.hasNext();
        }
        public bool   hasPrevious(){
            return it.hasPrevious();
        }
        public Object next(){
            return it.next();
        }
        public int    nextIndex(){
            return it.nextIndex();
        }
        public Object previous(){
            return it.previous();
        }
        public int    previousIndex(){
            return it.previousIndex();
        }
        public void   remove(){
            unsupported();
        }
        public void   set(Object o){
            unsupported();
        }
    }
    static class UnmodifieableList : List {
        List list;
        this(List list){
            this.list = list;
        }
        public void     add(int index, Object element){
            unsupported();
        }
        public bool     add(Object o){
            unsupported();
            return false; // make compiler happy
        }
        public bool     add(String o){
            unsupported();
            return false; // make compiler happy
        }
        public bool     addAll(Collection c){
            unsupported();
            return false; // make compiler happy
        }
        public bool     addAll(int index, Collection c){
            unsupported();
            return false; // make compiler happy
        }
        public void     clear(){
            unsupported();
            //return false; // make compiler happy
        }
        public bool     contains(Object o){
            return list.contains(o);
        }
        public bool     contains(String o){
            return list.contains(o);
        }
        public bool     containsAll(Collection c){
            return list.containsAll(c);
        }
        public int      opEquals(Object o){
            return list.opEquals(o);
        }
        public Object   get(int index){
            return list.get(index);
        }
        public hash_t   toHash(){
            return list.toHash();
        }
        public int      indexOf(Object o){
            return list.indexOf(o);
        }
        public bool     isEmpty(){
            return list.isEmpty();
        }
        public Iterator iterator(){
            return new UnmodifiableIterator( list.iterator() );
        }
        public int      lastIndexOf(Object o){
            return list.lastIndexOf(o);
        }
        public ListIterator   listIterator(){
            return new UnmodifiableListIterator( list.listIterator() );
        }
        public ListIterator   listIterator(int index){
            return new UnmodifiableListIterator( list.listIterator(index) );
        }
        public Object   remove(int index){
            unsupported();
            return null; // make compiler happy
        }
        public bool     remove(Object o){
            unsupported();
            return false; // make compiler happy
        }
        public bool     remove(String o){
            unsupported();
            return false; // make compiler happy
        }
        public bool     removeAll(Collection c){
            unsupported();
            return false; // make compiler happy
        }
        public bool     retainAll(Collection c){
            unsupported();
            return false; // make compiler happy
        }
        public Object   set(int index, Object element){
            unsupported();
            return null; // make compiler happy
        }
        public int      size(){
            return list.size();
        }
        public List     subList(int fromIndex, int toIndex){
            return new UnmodifieableList( list.subList(fromIndex,toIndex));
        }
        public Object[] toArray(){
            return list.toArray();
        }
        public Object[] toArray(Object[] a){
            return list.toArray(a);
        }
        public int opApply (int delegate(ref Object value) dg){
            implMissing(__FILE__, __LINE__ );
            return 0;
        }
        public int opApply (int delegate(ref Object key, ref Object value) dg){
            implMissing(__FILE__, __LINE__ );
            return 0;
        }
    }
    static int binarySearch(List list, Object key){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    static int binarySearch(List list, Object key, Comparator c){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    public static List unmodifiableList( List list ){
        return new UnmodifieableList(list);
    }
    public static Map unmodifiableMap( Map list ){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public static Set unmodifiableSet( Set list ){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public static Set singleton( Object o ){
        TreeSet res = new TreeSet();
        res.add(o);
        return res;
    }
    public static void     sort(List list){
        implMissing( __FILE__, __LINE__ );
    }
    public static void     sort(List list, Comparator c){
        implMissing( __FILE__, __LINE__ );
    }

    static Collection   synchronizedCollection(Collection c){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    static class SynchronizedList : List {
        private List list;
        private this( List list ){ this.list = list; }
        // Collection
        public int opApply (int delegate(ref Object value) dg){ synchronized(this){ return this.list.opApply(dg); } }
        // List
        public void     add(int index, Object element){ synchronized(this){ return this.list.add(index, element); } }
        public bool     add(Object o){ synchronized(this){ return this.list.add(o); } }
        public bool     add(String o){ synchronized(this){ return this.list.add(o); } }
        public bool     addAll(Collection c){ synchronized(this){ return this.list.addAll(c); } }
        public bool     addAll(int index, Collection c){ synchronized(this){ return this.list.addAll(index, c); } }
        public void     clear(){ synchronized(this){ return this.list.clear(); } }
        public bool     contains(Object o){ synchronized(this){ return this.list.contains(o); } }
        public bool     contains(String o){ synchronized(this){ return this.list.contains(o); } }
        public bool     containsAll(Collection c){ synchronized(this){ return this.list.containsAll(c); } }
        public int      opEquals(Object o){ synchronized(this){ return this.list.opEquals(o); } }
        public Object   get(int index){ synchronized(this){ return this.list.get(index); } }
        public hash_t   toHash(){ synchronized(this){ return this.list.toHash(); } }
        public int      indexOf(Object o){ synchronized(this){ return this.list.indexOf(o); } }
        public bool     isEmpty(){ synchronized(this){ return this.list.isEmpty(); } }
        public Iterator iterator(){ synchronized(this){ return this.list.iterator(); } }
        public int      lastIndexOf(Object o){ synchronized(this){ return this.list.lastIndexOf(o); } }
        public ListIterator   listIterator(){ synchronized(this){ return this.list.listIterator(); } }
        public ListIterator   listIterator(int index){ synchronized(this){ return this.list.listIterator(index); } }
        public Object   remove(int index){ synchronized(this){ return this.list.remove(index); } }
        public bool     remove(Object o){ synchronized(this){ return this.list.remove(o); } }
        public bool     remove(String o){ synchronized(this){ return this.list.remove(o); } }
        public bool     removeAll(Collection c){ synchronized(this){ return this.list.removeAll(c); } }
        public bool     retainAll(Collection c){ synchronized(this){ return this.list.retainAll(c); } }
        public Object   set(int index, Object element){ synchronized(this){ return this.list.set(index,element); } }
        public int      size(){ synchronized(this){ return this.list.size(); } }
        public List     subList(int fromIndex, int toIndex){ synchronized(this){ return this.list.subList(fromIndex,toIndex); } }
        public Object[] toArray(){ synchronized(this){ return this.list.toArray(); } }
        public Object[] toArray(Object[] a){ synchronized(this){ return this.list.toArray(a); } }
    }
    static List     synchronizedList(List list){
        return new SynchronizedList(list);
    }

    static class SynchronizedMap : Map {
        private Map map;
        //interface Entry {
        //    int   opEquals(Object o);
        //    Object     getKey();
        //    Object     getValue();
        //    hash_t     toHash();
        //    Object     setValue(Object value);
        //}
        private this( Map map ){
            this.map = map;
        }
        public void clear(){ synchronized(this){ this.map.clear(); } }
        public bool containsKey(Object key){ synchronized(this){ return this.map.containsKey(key); } }
        public bool containsKey(String key){ synchronized(this){ return this.map.containsKey(key); } }
        public bool containsValue(Object value){ synchronized(this){ return this.map.containsValue(value); } }
        public Set  entrySet(){ synchronized(this){ return this.map.entrySet(); } }
        public int opEquals(Object o){ synchronized(this){ return this.map.opEquals(o); } }
        public Object get(Object key){ synchronized(this){ return this.map.get(key); } }
        public Object get(String key){ synchronized(this){ return this.map.get(key); } }
        public hash_t toHash(){ synchronized(this){ return this.map.toHash(); } }
        public bool isEmpty(){ synchronized(this){ return this.map.isEmpty(); } }
        public Set    keySet(){ synchronized(this){ return this.map.keySet(); } }
        public Object put(Object key, Object value){ synchronized(this){ return this.map.put(key,value); } }
        public Object put(String key, Object value){ synchronized(this){ return this.map.put(key,value); } }
        public Object put(Object key, String value){ synchronized(this){ return this.map.put(key,value); } }
        public Object put(String key, String value){ synchronized(this){ return this.map.put(key,value); } }
        public void   putAll(Map t){ synchronized(this){ return this.map.putAll(t); } }
        public Object remove(Object key){ synchronized(this){ return this.map.remove(key); } }
        public Object remove(String key){ synchronized(this){ return this.map.remove(key); } }
        public int    size(){ synchronized(this){ return this.map.size(); } }
        public Collection values(){ synchronized(this){ return this.map.values(); } }

        // only for D
        public int opApply (int delegate(ref Object value) dg){ synchronized(this){ return this.map.opApply( dg ); } }
        public int opApply (int delegate(ref Object key, ref Object value) dg){ synchronized(this){ return this.map.opApply( dg ); } }
    }
    static Map  synchronizedMap(Map m){
        return new SynchronizedMap(m);
    }
    static Set  synchronizedSet(Set s){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
//     static SortedMap    synchronizedSortedMap(SortedMap m){
//         implMissing( __FILE__, __LINE__ );
//         return null;
//     }
//     static SortedSet    synchronizedSortedSet(SortedSet s){
//         implMissing( __FILE__, __LINE__ );
//         return null;
//     }
    static void     reverse(List list) {
        Object[] data = list.toArray();
        for( int idx = 0; idx < data.length; idx++ ){
            list.set( data.length -1 -idx, data[idx] );
        }
    }
    static class LocalEnumeration : Enumeration {
        Object[] data;
        this( Object[] data ){
            this.data = data;
        }
        public bool hasMoreElements(){
            return data.length > 0;
        }
        public Object nextElement(){
            Object res = data[0];
            data = data[ 1 .. $ ];
            return res;
        }
    }
    static Enumeration     enumeration(Collection c){
        return new LocalEnumeration( c.toArray() );
    }
}

class LinkedHashMap : HashMap {
    this(){
        implMissing( __FILE__, __LINE__ );
    }
}
