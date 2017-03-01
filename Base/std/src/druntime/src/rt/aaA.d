/**
 * Implementation of associative arrays.
 *
 * Copyright: Copyright Digital Mars 2000 - 2015.
 * License:   $(WEB www.boost.org/LICENSE_1_0.txt, Boost License 1.0).
 * Authors:   Martin Nowak
 */
module rt.aaA;

/// AA version for debuggers, bump whenever changing the layout
extern (C) immutable int _aaVersion = 1;

import core.memory : GC;

// grow threshold
private enum GROW_NUM = 4;
private enum GROW_DEN = 5;
// shrink threshold
private enum SHRINK_NUM = 1;
private enum SHRINK_DEN = 8;
// grow factor
private enum GROW_FAC = 4;
// growing the AA doubles it's size, so the shrink threshold must be
// smaller than half the grow threshold to have a hysteresis
static assert(GROW_FAC * SHRINK_NUM * GROW_DEN < GROW_NUM * SHRINK_DEN);
// initial load factor (for literals), mean of both thresholds
private enum INIT_NUM = (GROW_DEN * SHRINK_NUM + GROW_NUM * SHRINK_DEN) / 2;
private enum INIT_DEN = SHRINK_DEN * GROW_DEN;

private enum INIT_NUM_BUCKETS = 8;
// magic hash constants to distinguish empty, deleted, and filled buckets
private enum HASH_EMPTY = 0;
private enum HASH_DELETED = 0x1;
private enum HASH_FILLED_MARK = size_t(1) << 8 * size_t.sizeof - 1;

/// Opaque AA wrapper
struct AA
{
    Impl* impl;
    alias impl this;

    private @property bool empty() const pure nothrow @nogc
    {
        return impl is null || !impl.length;
    }
}

private struct Impl
{
private:
    this(in TypeInfo_AssociativeArray ti, size_t sz = INIT_NUM_BUCKETS)
    {
        keysz = cast(uint) ti.key.tsize;
        valsz = cast(uint) ti.value.tsize;
        buckets = allocBuckets(sz);
        firstUsed = cast(uint) buckets.length;
        entryTI = fakeEntryTI(ti.key, ti.value);
        valoff = cast(uint) talign(keysz, ti.value.talign);

        import rt.lifetime : hasPostblit, unqualify;

        if (hasPostblit(unqualify(ti.key)))
            flags |= Flags.keyHasPostblit;
        if ((ti.key.flags | ti.value.flags) & 1)
            flags |= Flags.hasPointers;
    }

    Bucket[] buckets;
    uint used;
    uint deleted;
    TypeInfo_Struct entryTI;
    uint firstUsed;
    immutable uint keysz;
    immutable uint valsz;
    immutable uint valoff;
    Flags flags;

    enum Flags : ubyte
    {
        none = 0x0,
        keyHasPostblit = 0x1,
        hasPointers = 0x2,
    }

    @property size_t length() const pure nothrow @nogc
    {
        assert(used >= deleted);
        return used - deleted;
    }

    @property size_t dim() const pure nothrow @nogc
    {
        return buckets.length;
    }

    @property size_t mask() const pure nothrow @nogc
    {
        return dim - 1;
    }

    // find the first slot to insert a value with hash
    inout(Bucket)* findSlotInsert(size_t hash) inout pure nothrow @nogc
    {
        for (size_t i = hash & mask, j = 1;; ++j)
        {
            if (!buckets[i].filled)
                return &buckets[i];
            i = (i + j) & mask;
        }
    }

    // lookup a key
    inout(Bucket)* findSlotLookup(size_t hash, in void* pkey, in TypeInfo keyti) inout
    {
        for (size_t i = hash & mask, j = 1;; ++j)
        {
            if (buckets[i].hash == hash && keyti.equals(pkey, buckets[i].entry))
                return &buckets[i];
            else if (buckets[i].empty)
                return null;
            i = (i + j) & mask;
        }
    }

    void grow(in TypeInfo keyti)
    {
        // If there are so many deleted entries, that growing would push us
        // below the shrink threshold, we just purge deleted entries instead.
        if (length * SHRINK_DEN < GROW_FAC * dim * SHRINK_NUM)
            resize(dim);
        else
            resize(GROW_FAC * dim);
    }

    void shrink(in TypeInfo keyti)
    {
        if (dim > INIT_NUM_BUCKETS)
            resize(dim / GROW_FAC);
    }

    void resize(size_t ndim) pure nothrow
    {
        auto obuckets = buckets;
        buckets = allocBuckets(ndim);

        foreach (ref b; obuckets)
            if (b.filled)
                *findSlotInsert(b.hash) = b;

        firstUsed = 0;
        used -= deleted;
        deleted = 0;
        GC.free(obuckets.ptr); // safe to free b/c impossible to reference
    }
}

//==============================================================================
// Bucket
//------------------------------------------------------------------------------

private struct Bucket
{
private pure nothrow @nogc:
    size_t hash;
    void* entry;

    @property bool empty() const
    {
        return hash == HASH_EMPTY;
    }

    @property bool deleted() const
    {
        return hash == HASH_DELETED;
    }

    @property bool filled() const
    {
        return cast(ptrdiff_t) hash < 0;
    }
}

Bucket[] allocBuckets(size_t dim) @trusted pure nothrow
{
    enum attr = GC.BlkAttr.NO_INTERIOR;
    immutable sz = dim * Bucket.sizeof;
    return (cast(Bucket*) GC.calloc(sz, attr))[0 .. dim];
}

//==============================================================================
// Entry
//------------------------------------------------------------------------------

private void* allocEntry(in Impl* aa, in void* pkey)
{
    import rt.lifetime : _d_newitemU;
    import core.stdc.string : memcpy, memset;

    immutable akeysz = aa.valoff;
    void* res = void;
    if (aa.entryTI)
        res = _d_newitemU(aa.entryTI);
    else
    {
        auto flags = (aa.flags & Impl.Flags.hasPointers) ? 0 : GC.BlkAttr.NO_SCAN;
        res = GC.malloc(akeysz + aa.valsz, flags);
    }

    memcpy(res, pkey, aa.keysz); // copy key
    memset(res + akeysz, 0, aa.valsz); // zero value

    return res;
}

package void entryDtor(void* p, const TypeInfo_Struct sti)
{
    // key and value type info stored after the TypeInfo_Struct by tiEntry()
    auto sizeti = __traits(classInstanceSize, TypeInfo_Struct);
    auto extra = cast(const(TypeInfo)*)(cast(void*) sti + sizeti);
    extra[0].destroy(p);
    extra[1].destroy(p + talign(extra[0].tsize, extra[1].talign));
}

private bool hasDtor(const TypeInfo ti)
{
    import rt.lifetime : unqualify;

    if (typeid(ti) is typeid(TypeInfo_Struct))
        if ((cast(TypeInfo_Struct) cast(void*) ti).xdtor)
            return true;
    if (typeid(ti) is typeid(TypeInfo_StaticArray))
        return hasDtor(unqualify(ti.next));

    return false;
}

// build type info for Entry with additional key and value fields
TypeInfo_Struct fakeEntryTI(const TypeInfo keyti, const TypeInfo valti)
{
    import rt.lifetime : unqualify;

    auto kti = unqualify(keyti);
    auto vti = unqualify(valti);
    if (!hasDtor(kti) && !hasDtor(vti))
        return null;

    // save kti and vti after type info for struct
    enum sizeti = __traits(classInstanceSize, TypeInfo_Struct);
    void* p = GC.malloc(sizeti + 2 * (void*).sizeof);
    import core.stdc.string : memcpy;

    memcpy(p, typeid(TypeInfo_Struct).init().ptr, sizeti);

    auto ti = cast(TypeInfo_Struct) p;
    auto extra = cast(TypeInfo*)(p + sizeti);
    extra[0] = cast() kti;
    extra[1] = cast() vti;

    static immutable tiName = __MODULE__ ~ ".Entry!(...)";
    ti.name = tiName;

    // we don't expect the Entry objects to be used outside of this module, so we have control
    // over the non-usage of the callback methods and other entries and can keep these null
    // xtoHash, xopEquals, xopCmp, xtoString and xpostblit
    ti.m_RTInfo = null;
    immutable entrySize = talign(kti.tsize, vti.talign) + vti.tsize;
    ti.m_init = (cast(ubyte*) null)[0 .. entrySize]; // init length, but not ptr

    // xdtor needs to be built from the dtors of key and value for the GC
    ti.xdtorti = &entryDtor;

    ti.m_flags = TypeInfo_Struct.StructFlags.isDynamicType;
    ti.m_flags |= (keyti.flags | valti.flags) & TypeInfo_Struct.StructFlags.hasPointers;
    ti.m_align = cast(uint) max(kti.talign, vti.talign);

    return ti;
}

//==============================================================================
// Helper functions
//------------------------------------------------------------------------------

private size_t talign(size_t tsize, size_t algn) @safe pure nothrow @nogc
{
    immutable mask = algn - 1;
    assert(!(mask & algn));
    return (tsize + mask) & ~mask;
}

// mix hash to "fix" bad hash functions
private size_t mix(size_t h) @safe pure nothrow @nogc
{
    // final mix function of MurmurHash2
    enum m = 0x5bd1e995;
    h ^= h >> 13;
    h *= m;
    h ^= h >> 15;
    return h;
}

private size_t calcHash(in void* pkey, in TypeInfo keyti)
{
    immutable hash = keyti.getHash(pkey);
    // highest bit is set to distinguish empty/deleted from filled buckets
    return mix(hash) | HASH_FILLED_MARK;
}

private size_t nextpow2(in size_t n) pure nothrow @nogc
{
    import core.bitop : bsr;

    if (!n)
        return 1;

    const isPowerOf2 = !((n - 1) & n);
    return 1 << (bsr(n) + !isPowerOf2);
}

pure nothrow @nogc unittest
{
    //                            0, 1, 2, 3, 4, 5, 6, 7, 8,  9
    foreach (const n, const pow2; [1, 1, 2, 4, 4, 8, 8, 8, 8, 16])
        assert(nextpow2(n) == pow2);
}

private T min(T)(T a, T b) pure nothrow @nogc
{
    return a < b ? a : b;
}

private T max(T)(T a, T b) pure nothrow @nogc
{
    return b < a ? a : b;
}

//==============================================================================
// API Implementation
//------------------------------------------------------------------------------

/// Determine number of entries in associative array.
extern (C) size_t _aaLen(in AA aa) pure nothrow @nogc
{
    return aa ? aa.length : 0;
}

/// Get LValue for key
extern (C) void* _aaGetY(AA* aa, const TypeInfo_AssociativeArray ti, in size_t valsz,
    in void* pkey)
{
    // lazily alloc implementation
    if (aa.impl is null)
        aa.impl = new Impl(ti);

    // get hash and bucket for key
    immutable hash = calcHash(pkey, ti.key);

    // found a value => return it
    if (auto p = aa.findSlotLookup(hash, pkey, ti.key))
        return p.entry + aa.valoff;

    auto p = aa.findSlotInsert(hash);
    if (p.deleted)
        --aa.deleted;
    // check load factor and possibly grow
    else if (++aa.used * GROW_DEN > aa.dim * GROW_NUM)
    {
        aa.grow(ti.key);
        p = aa.findSlotInsert(hash);
        assert(p.empty);
    }

    // update search cache and allocate entry
    aa.firstUsed = min(aa.firstUsed, cast(uint)(p - aa.buckets.ptr));
    p.hash = hash;
    p.entry = allocEntry(aa.impl, pkey);
    // postblit for key
    if (aa.flags & Impl.Flags.keyHasPostblit)
    {
        import rt.lifetime : __doPostblit, unqualify;

        __doPostblit(p.entry, aa.keysz, unqualify(ti.key));
    }
    // return pointer to value
    return p.entry + aa.valoff;
}

/// Get RValue for key, returns null if not present
extern (C) inout(void)* _aaGetRvalueX(inout AA aa, in TypeInfo keyti, in size_t valsz,
    in void* pkey)
{
    return _aaInX(aa, keyti, pkey);
}

/// Return pointer to value if present, null otherwise
extern (C) inout(void)* _aaInX(inout AA aa, in TypeInfo keyti, in void* pkey)
{
    if (aa.empty)
        return null;

    immutable hash = calcHash(pkey, keyti);
    if (auto p = aa.findSlotLookup(hash, pkey, keyti))
        return p.entry + aa.valoff;
    return null;
}

/// Delete entry in AA, return true if it was present
extern (C) bool _aaDelX(AA aa, in TypeInfo keyti, in void* pkey)
{
    if (aa.empty)
        return false;

    immutable hash = calcHash(pkey, keyti);
    if (auto p = aa.findSlotLookup(hash, pkey, keyti))
    {
        // clear entry
        p.hash = HASH_DELETED;
        p.entry = null;

        ++aa.deleted;
        if (aa.length * SHRINK_DEN < aa.dim * SHRINK_NUM)
            aa.shrink(keyti);

        return true;
    }
    return false;
}

/// Rehash AA
extern (C) void* _aaRehash(AA* paa, in TypeInfo keyti) pure nothrow
{
    if (!paa.empty)
        paa.resize(nextpow2(INIT_DEN * paa.length / INIT_NUM));
    return *paa;
}

/// Return a GC allocated array of all values
extern (C) inout(void[]) _aaValues(inout AA aa, in size_t keysz, in size_t valsz,
    const TypeInfo tiValueArray) pure nothrow
{
    if (aa.empty)
        return null;

    import rt.lifetime : _d_newarrayU;

    auto res = _d_newarrayU(tiValueArray, aa.length).ptr;
    auto pval = res;

    immutable off = aa.valoff;
    foreach (b; aa.buckets[aa.firstUsed .. $])
    {
        if (!b.filled)
            continue;
        pval[0 .. valsz] = b.entry[off .. valsz + off];
        pval += valsz;
    }
    // postblit is done in object.values
    return (cast(inout(void)*) res)[0 .. aa.length]; // fake length, return number of elements
}

/// Return a GC allocated array of all keys
extern (C) inout(void[]) _aaKeys(inout AA aa, in size_t keysz, const TypeInfo tiKeyArray) pure nothrow
{
    if (aa.empty)
        return null;

    import rt.lifetime : _d_newarrayU;

    auto res = _d_newarrayU(tiKeyArray, aa.length).ptr;
    auto pkey = res;

    foreach (b; aa.buckets[aa.firstUsed .. $])
    {
        if (!b.filled)
            continue;
        pkey[0 .. keysz] = b.entry[0 .. keysz];
        pkey += keysz;
    }
    // postblit is done in object.keys
    return (cast(inout(void)*) res)[0 .. aa.length]; // fake length, return number of elements
}

// opApply callbacks are extern(D)
extern (D) alias dg_t = int delegate(void*);
extern (D) alias dg2_t = int delegate(void*, void*);

/// foreach opApply over all values
extern (C) int _aaApply(AA aa, in size_t keysz, dg_t dg)
{
    if (aa.empty)
        return 0;

    immutable off = aa.valoff;
    foreach (b; aa.buckets)
    {
        if (!b.filled)
            continue;
        if (auto res = dg(b.entry + off))
            return res;
    }
    return 0;
}

/// foreach opApply over all key/value pairs
extern (C) int _aaApply2(AA aa, in size_t keysz, dg2_t dg)
{
    if (aa.empty)
        return 0;

    immutable off = aa.valoff;
    foreach (b; aa.buckets)
    {
        if (!b.filled)
            continue;
        if (auto res = dg(b.entry, b.entry + off))
            return res;
    }
    return 0;
}

/// Construct an associative array of type ti from keys and value
extern (C) Impl* _d_assocarrayliteralTX(const TypeInfo_AssociativeArray ti, void[] keys,
    void[] vals)
{
    assert(keys.length == vals.length);

    immutable keysz = ti.key.tsize;
    immutable valsz = ti.value.tsize;
    immutable length = keys.length;

    if (!length)
        return null;

    auto aa = new Impl(ti, nextpow2(INIT_DEN * length / INIT_NUM));

    void* pkey = keys.ptr;
    void* pval = vals.ptr;
    immutable off = aa.valoff;
    foreach (_; 0 .. length)
    {
        immutable hash = calcHash(pkey, ti.key);

        auto p = aa.findSlotLookup(hash, pkey, ti.key);
        if (p is null)
        {
            p = aa.findSlotInsert(hash);
            p.hash = hash;
            p.entry = allocEntry(aa, pkey); // move key, no postblit
            aa.firstUsed = min(aa.firstUsed, cast(uint)(p - aa.buckets.ptr));
        }
        else if (aa.entryTI && hasDtor(ti.value))
        {
            // destroy existing value before overwriting it
            ti.value.destroy(p.entry + off);
        }
        // set hash and blit value
        auto pdst = p.entry + off;
        pdst[0 .. valsz] = pval[0 .. valsz]; // move value, no postblit

        pkey += keysz;
        pval += valsz;
    }
    aa.used = cast(uint) length;
    return aa;
}

/// compares 2 AAs for equality
extern (C) int _aaEqual(in TypeInfo tiRaw, in AA aa1, in AA aa2)
{
    if (aa1.impl is aa2.impl)
        return true;

    immutable len = _aaLen(aa1);
    if (len != _aaLen(aa2))
        return false;

    if (!len) // both empty
        return true;

    import rt.lifetime : unqualify;

    auto uti = unqualify(tiRaw);
    auto ti = *cast(TypeInfo_AssociativeArray*)&uti;
    // compare the entries
    immutable off = aa1.valoff;
    foreach (b1; aa1.buckets)
    {
        if (!b1.filled)
            continue;
        auto pb2 = aa2.findSlotLookup(b1.hash, b1.entry, ti.key);
        if (pb2 is null || !ti.value.equals(b1.entry + off, pb2.entry + off))
            return false;
    }
    return true;
}

/// compute a hash
extern (C) hash_t _aaGetHash(in AA* aa, in TypeInfo tiRaw) nothrow
{
    if (aa.empty)
        return 0;

    import rt.lifetime : unqualify;

    auto uti = unqualify(tiRaw);
    auto ti = *cast(TypeInfo_AssociativeArray*)&uti;
    immutable off = aa.valoff;
    auto valHash = &ti.value.getHash;

    size_t h;
    foreach (b; aa.buckets)
    {
        if (!b.filled)
            continue;
        size_t[2] h2 = [b.hash, valHash(b.entry + off)];
        // use XOR here, so that hash is independent of element order
        h ^= hashOf(h2.ptr, h2.length * h2[0].sizeof);
    }
    return h;
}

/**
 * _aaRange implements a ForwardRange
 */
struct Range
{
    Impl* impl;
    size_t idx;
    alias impl this;
}

extern (C) pure nothrow @nogc
{
    Range _aaRange(AA aa)
    {
        if (!aa)
            return Range();

        foreach (i; aa.firstUsed .. aa.dim)
        {
            if (aa.buckets[i].filled)
                return Range(aa.impl, i);
        }
        return Range(aa, aa.dim);
    }

    bool _aaRangeEmpty(Range r)
    {
        return r.impl is null || r.idx == r.dim;
    }

    void* _aaRangeFrontKey(Range r)
    {
        return r.buckets[r.idx].entry;
    }

    void* _aaRangeFrontValue(Range r)
    {
        return r.buckets[r.idx].entry + r.valoff;
    }

    void _aaRangePopFront(ref Range r)
    {
        for (++r.idx; r.idx < r.dim; ++r.idx)
        {
            if (r.buckets[r.idx].filled)
                break;
        }
    }
}

//==============================================================================
// Unittests
//------------------------------------------------------------------------------

pure nothrow unittest
{
    int[string] aa;

    assert(aa.keys.length == 0);
    assert(aa.values.length == 0);

    aa["hello"] = 3;
    assert(aa["hello"] == 3);
    aa["hello"]++;
    assert(aa["hello"] == 4);

    assert(aa.length == 1);

    string[] keys = aa.keys;
    assert(keys.length == 1);
    assert(keys[0] == "hello");

    int[] values = aa.values;
    assert(values.length == 1);
    assert(values[0] == 4);

    aa.rehash;
    assert(aa.length == 1);
    assert(aa["hello"] == 4);

    aa["foo"] = 1;
    aa["bar"] = 2;
    aa["batz"] = 3;

    assert(aa.keys.length == 4);
    assert(aa.values.length == 4);

    foreach (a; aa.keys)
    {
        assert(a.length != 0);
        assert(a.ptr != null);
    }

    foreach (v; aa.values)
    {
        assert(v != 0);
    }
}

unittest  // Test for Issue 10381
{
    alias II = int[int];
    II aa1 = [0 : 1];
    II aa2 = [0 : 1];
    II aa3 = [0 : 2];
    assert(aa1 == aa2); // Passes
    assert(typeid(II).equals(&aa1, &aa2));
    assert(!typeid(II).equals(&aa1, &aa3));
}

pure nothrow unittest
{
    string[int] key1 = [1 : "true", 2 : "false"];
    string[int] key2 = [1 : "false", 2 : "true"];
    string[int] key3;

    // AA lits create a larger hashtable
    int[string[int]] aa1 = [key1 : 100, key2 : 200, key3 : 300];

    // Ensure consistent hash values are computed for key1
    assert((key1 in aa1) !is null);

    // Manually assigning to an empty AA creates a smaller hashtable
    int[string[int]] aa2;
    aa2[key1] = 100;
    aa2[key2] = 200;
    aa2[key3] = 300;

    assert(aa1 == aa2);

    // Ensure binary-independence of equal hash keys
    string[int] key2a;
    key2a[1] = "false";
    key2a[2] = "true";

    assert(aa1[key2a] == 200);
}

// Issue 9852
pure nothrow unittest
{
    // Original test case (revised, original assert was wrong)
    int[string] a;
    a["foo"] = 0;
    a.remove("foo");
    assert(a == null); // should not crash

    int[string] b;
    assert(b is null);
    assert(a == b); // should not deref null
    assert(b == a); // ditto

    int[string] c;
    c["a"] = 1;
    assert(a != c); // comparison with empty non-null AA
    assert(c != a);
    assert(b != c); // comparison with null AA
    assert(c != b);
}

// Bugzilla 14104
unittest
{
    import core.stdc.stdio;

    alias K = const(ubyte)*;
    size_t[K] aa;
    immutable key = cast(K)(cast(size_t) uint.max + 1);
    aa[key] = 12;
    assert(key in aa);
}

unittest
{
    int[int] aa;
    foreach (k, v; aa)
        assert(false);
    foreach (v; aa)
        assert(false);
    assert(aa.byKey.empty);
    assert(aa.byValue.empty);
    assert(aa.byKeyValue.empty);

    size_t n;
    aa = [0 : 3, 1 : 4, 2 : 5];
    foreach (k, v; aa)
    {
        n += k;
        assert(k >= 0 && k < 3);
        assert(v >= 3 && v < 6);
    }
    assert(n == 3);
    n = 0;

    foreach (v; aa)
    {
        n += v;
        assert(v >= 3 && v < 6);
    }
    assert(n == 12);

    n = 0;
    foreach (k, v; aa)
    {
        ++n;
        break;
    }
    assert(n == 1);

    n = 0;
    foreach (v; aa)
    {
        ++n;
        break;
    }
    assert(n == 1);
}

unittest
{
    int[int] aa;
    assert(!aa.remove(0));
    aa = [0 : 1];
    assert(aa.remove(0));
    assert(!aa.remove(0));
    aa[1] = 2;
    assert(!aa.remove(0));
    assert(aa.remove(1));

    assert(aa.length == 0);
    assert(aa.byKey.empty);
}

// test zero sized value (hashset)
unittest
{
    alias V = void[0];
    auto aa = [0 : V.init];
    assert(aa.length == 1);
    assert(aa.byKey.front == 0);
    assert(aa.byValue.front == V.init);
    aa[1] = V.init;
    assert(aa.length == 2);
    aa[0] = V.init;
    assert(aa.length == 2);
    assert(aa.remove(0));
    aa[0] = V.init;
    assert(aa.length == 2);
    assert(aa == [0 : V.init, 1 : V.init]);
}

// test tombstone purging
unittest
{
    int[int] aa;
    foreach (i; 0 .. 6)
        aa[i] = i;
    foreach (i; 0 .. 6)
        assert(aa.remove(i));
    foreach (i; 6 .. 10)
        aa[i] = i;
    assert(aa.length == 4);
    foreach (i; 6 .. 10)
        assert(i in aa);
}

// test postblit for AA literals
unittest
{
    static struct T
    {
        static size_t postblit, dtor;
        this(this)
        {
            ++postblit;
        }

        ~this()
        {
            ++dtor;
        }
    }

    T t;
    auto aa1 = [0 : t, 1 : t];
    assert(T.dtor == 0 && T.postblit == 2);
    aa1[0] = t;
    assert(T.dtor == 1 && T.postblit == 3);

    T.dtor = 0;
    T.postblit = 0;

    auto aa2 = [0 : t, 1 : t, 0 : t]; // literal with duplicate key => value overwritten
    assert(T.dtor == 1 && T.postblit == 3);

    T.dtor = 0;
    T.postblit = 0;

    auto aa3 = [t : 0];
    assert(T.dtor == 0 && T.postblit == 1);
    aa3[t] = 1;
    assert(T.dtor == 0 && T.postblit == 1);
    aa3.remove(t);
    assert(T.dtor == 0 && T.postblit == 1);
    aa3[t] = 2;
    assert(T.dtor == 0 && T.postblit == 2);

    // dtor will be called by GC finalizers
    aa1 = null;
    aa2 = null;
    aa3 = null;
    GC.runFinalizers((cast(char*)(&entryDtor))[0 .. 1]);
    assert(T.dtor == 6 && T.postblit == 2);
}