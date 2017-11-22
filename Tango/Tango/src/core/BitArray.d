/**
 * This module содержит a packed bit Массив implementation in the стиль of D's
 * built-in dynamic массивы.
 *
 * Copyright: Copyright (C) 2005-2006 Digital Mars, www.digitalmars.com.
 *            все rights reserved.
 * License:   BSD стиль: $(LICENSE)
 * Authors:   Walter Bright, Sean Kelly
 */
module core.BitArray;


private import core.BitManip;


/**
 * This struct represents an Массив of булево values, each of which occupy one
 * bit of память for хранилище.  Thus an Массив of 32 биты would occupy the same
 * пространство as one целое значение.  The typical Массив operations--such as indexing
 * and sorting--are supported, as well as bitwise operations such as and, or,
 * xor, and complement.
 */
struct МассивБит
{
    т_мера  длин;
    бцел*   ptr;


    /**
     * This initializes a МассивБит of биты.длина биты, where each bit значение
     * matches the corresponding булево значение in биты.
     *
     * Параметры:
     *  биты = The initialization значение.
     *
     * Возвращает:
     *  A МассивБит with the same число and sequence of elements as биты.
     */
    static МассивБит opCall( бул[] биты )
    {
        МассивБит temp;

        temp.длина = биты.length;
        foreach( поз, знач; биты )
            temp[поз] = знач;
        return temp;
    }

    /**
     * Get the число of биты in this Массив.
     *
     * Возвращает:
     *  The число of биты in this Массив.
     */
    т_мера длина()
    {
        return длин;
    }


    /**
     * Resizes this Массив в_ новдлин биты.  If новдлин is larger than the current
     * длина, the new биты will be инициализован в_ zero.
     *
     * Параметры:
     *  новдлин = The число of биты this Массив should contain.
     */
    проц длина( т_мера новдлин )
    {
        if( новдлин != длин )
        {
            auto olddim = цразм();
            auto newdim = (новдлин + 31) / 32;

            if( newdim != olddim )
            {
                // Create a fake Массив so we can use D's realloc machinery
                бцел[] буф = ptr[0 .. olddim];

                буф.length = newdim; // realloc
                ptr = буф.ptr;
                if( newdim & 31 )
                {
                    // Набор any pad биты в_ 0
                    ptr[newdim - 1] &= ~(~0 << (newdim & 31));
                }
            }
            длин = новдлин;
        }
    }


    /**
     * Gets the длина of a бцел Массив large enough в_ hold все stored биты.
     *
     * Возвращает:
     *  The размер a бцел Массив would have в_ be в_ сохрани this Массив.
     */
    т_мера цразм()
    {
        return (длин + 31) / 32;
    }


    /**
     * Duplicates this Массив, much like the dup property for built-in массивы.
     *
     * Возвращает:
     *  A duplicate of this Массив.
     */
    МассивБит dup()
    {
        МассивБит ba;

        бцел[] буф = ptr[0 .. цразм].dup;
        ba.длин = длин;
        ba.ptr = буф.ptr;
        return ba;
    }


    debug( UnitTest )
    {
      unittest
      {
        МассивБит a;
        МассивБит b;

        a.длина = 3;
        a[0] = 1; a[1] = 0; a[2] = 1;
        b = a.dup;
        assert( b.длина == 3 );
        for( цел i = 0; i < 3; ++i )
        {
            assert( b[i] == (((i ^ 1) & 1) ? да : нет) );
        }
      }
    }


    /**
     * Resets the длина of this Массив в_ биты.длина and then initializes this
     *
     * Resizes this Массив в_ hold биты.длина биты and initializes each bit
     * значение в_ match the corresponding булево значение in биты.
     *
     * Параметры:
     *  биты = The initialization значение.
     */
    проц opAssign( бул[] биты )
    {
        длина = биты.length;
        foreach( i, b; биты )
        {
            (*this)[i] = b;
        }
    }

    /**
     * Copy the биты из_ one Массив преобр_в this Массив.  This is not a shallow
     * копируй.
     *
     * Параметры:
     *  rhs = A МассивБит with at least the same число of биты as this bit
     *  Массив.
     *
     * Возвращает:
     *  A shallow копируй of this Массив.
     *
     *  --------------------
     *  МассивБит ba = [0,1,0,1,0];
     *  МассивБит ba2;
     *  ba2.длина = ba.длина;
     *  ba2[] = ba; // perform the копируй
     *  ba[0] = да;
     *  assert(ba2[0] == нет);
     */
     МассивБит opSliceAssign(МассивБит rhs)
     in
     {
         assert(rhs.длин == длин);
     }
     body
     {
         т_мера mDim=длин/32;
         ptr[0..mDim] = rhs.ptr[0..mDim];
         цел rest=cast(цел)(длин & cast(т_мера)31u);
         if (rest){
             бцел маска=(~0u)<<rest;
             ptr[mDim]=(rhs.ptr[mDim] & (~маска))|(ptr[mDim] & маска);
         }
         return *this;
     }


    /**
     * Map МассивБит onto мишень, with члобит being the число of биты in the
     * Массив. Does not копируй the данные.  This is the inverse of opCast.
     *
     * Параметры:
     *  мишень  = The Массив в_ карта.
     *  члобит = The число of биты в_ карта in мишень.
     */
    проц иниц( проц[] мишень, т_мера члобит )
    in
    {
        assert( члобит <= мишень.length * 8 );
        assert( (мишень.length & 3) == 0 );
    }
    body
    {
        ptr = cast(бцел*)мишень.ptr;
        длин = члобит;
    }


    debug( UnitTest )
    {
      unittest
      {
        МассивБит a = [1,0,1,0,1];
        МассивБит b;
        проц[] буф;

        буф = cast(проц[])a;
        b.иниц( буф, a.длина );

        assert( b[0] == 1 );
        assert( b[1] == 0 );
        assert( b[2] == 1 );
        assert( b[3] == 0 );
        assert( b[4] == 1 );

        a[0] = 0;
        assert( b[0] == 0 );

        assert( a == b );

        // тест opSliceAssign
        МассивБит c;
        c.длина = a.длина;
        c[] = a;
        assert( c == a );
        a[0] = 1;
        assert( c != a );
      }
    }


    /**
     * Reverses the contents of this Массив in place, much like the реверс
     * property for built-in массивы.
     *
     * Возвращает:
     *  A shallow копируй of this Массив.
     */
    МассивБит реверс()
    out( результат )
    {
        assert( результат == *this );
    }
    body
    {
        if( длин >= 2 )
        {
            бул t;
            т_мера lo, hi;

            lo = 0;
            hi = длин - 1;
            for( ; lo < hi; ++lo, --hi )
            {
                t = (*this)[lo];
                (*this)[lo] = (*this)[hi];
                (*this)[hi] = t;
            }
        }
        return *this;
    }


    debug( UnitTest )
    {
      unittest
      {
        static бул[5] данные = [1,0,1,1,0];
        МассивБит b = данные;
        b.реверс;

        for( т_мера i = 0; i < данные.длина; ++i )
        {
            assert( b[i] == данные[4 - i] );
        }
      }
    }


    /**
     * Sorts this Массив in place, with zero записи sorting before one.  This
     * is equivalent в_ the сортируй property for built-in массивы.
     *
     * Возвращает:
     *  A shallow копируй of this Массив.
     */
    МассивБит сортируй()
    out( результат )
    {
        assert( результат == *this );
    }
    body
    {
        if( длин >= 2 )
        {
            т_мера lo, hi;

            lo = 0;
            hi = длин - 1;
            while( да )
            {
                while( да )
                {
                    if( lo >= hi )
                        goto Ldone;
                    if( (*this)[lo] == да )
                        break;
                    ++lo;
                }

                while( да )
                {
                    if( lo >= hi )
                        goto Ldone;
                    if( (*this)[hi] == нет )
                        break;
                    --hi;
                }

                (*this)[lo] = нет;
                (*this)[hi] = да;

                ++lo;
                --hi;
            }
            Ldone:
            ;
        }
        return *this;
    }


    debug( UnitTest )
    {
      unittest
      {
        static бцел x = 0b1100011000;
        static МассивБит ba = { 10, &x };

        ba.сортируй;
        for( т_мера i = 0; i < 6; ++i )
            assert( ba[i] == нет );
        for( т_мера i = 6; i < 10; ++i )
            assert( ba[i] == да );
      }
    }


    /**
     * Operates on все биты in this Массив.
     *
     * Параметры:
     *  дг = The supplied код as a delegate.
     */
    цел opApply( цел delegate(ref бул) дг )
    {
        цел результат;

        for( т_мера i = 0; i < длин; ++i )
        {
            бул b = opIndex( i );
            результат = дг( b );
            opIndexAssign( b, i );
            if( результат )
                break;
        }
        return результат;
    }


    /** ditto */
    цел opApply( цел delegate(ref т_мера, ref бул) дг )
    {
        цел результат;

        for( т_мера i = 0; i < длин; ++i )
        {
            бул b = opIndex( i );
            результат = дг( i, b );
            opIndexAssign( b, i );
            if( результат )
                break;
        }
        return результат;
    }


    debug( UnitTest )
    {
      unittest
      {
        МассивБит a = [1,0,1];

        цел i;
        foreach( b; a )
        {
            switch( i )
            {
            case 0: assert( b == да );  break;
            case 1: assert( b == нет ); break;
            case 2: assert( b == да );  break;
            default: assert( нет );
            }
            i++;
        }

        foreach( j, b; a )
        {
            switch( j )
            {
            case 0: assert( b == да );  break;
            case 1: assert( b == нет ); break;
            case 2: assert( b == да );  break;
            default: assert( нет );
            }
        }
      }
    }


    /**
     * Compares this Массив в_ другой for equality.  Two bit массивы are equal
     * if they are the same размер and contain the same series of биты.
     *
     * Параметры:
     *  rhs = The Массив в_ compare against.
     *
     * Возвращает:
     *  zero if not equal and non-zero otherwise.
     */
    цел opEquals( МассивБит rhs )
    {
        if( this.длина != rhs.длина )
            return 0; // not equal
        бцел* p1 = this.ptr;
        бцел* p2 = rhs.ptr;
        т_мера n = this.длина / 32;
        т_мера i;
        for( i = 0; i < n; ++i )
        {
            if( p1[i] != p2[i] )
            return 0; // not equal
        }
        цел rest = cast(цел)(this.длина & cast(т_мера)31u);
        бцел маска = ~((~0u)<<rest);
        return (rest == 0) || (p1[i] & маска) == (p2[i] & маска);
    }

    debug( UnitTest )
    {
      unittest
      {
        МассивБит a = [1,0,1,0,1];
        МассивБит b = [1,0,1];
        МассивБит c = [1,0,1,0,1,0,1];
        МассивБит d = [1,0,1,1,1];
        МассивБит e = [1,0,1,0,1];

        assert(a != b);
        assert(a != c);
        assert(a != d);
        assert(a == e);
      }
    }


    /**
     * Performs a lexicographical сравнение of this Массив в_ the supplied
     * Массив.
     *
     * Параметры:
     *  rhs = The Массив в_ compare against.
     *
     * Возвращает:
     *  A значение less than zero if this Массив sorts before the supplied Массив,
     *  zero if the массивы are equavalent, and a значение greater than zero if
     *  this Массив sorts after the supplied Массив.
     */
    цел opCmp( МассивБит rhs )
    {
        auto длин = this.длина;
        if( rhs.длина < длин )
            длин = rhs.длина;
        бцел* p1 = this.ptr;
        бцел* p2 = rhs.ptr;
        т_мера n = длин / 32;
        т_мера i;
        for( i = 0; i < n; ++i )
        {
            if( p1[i] != p2[i] ){
                return ((p1[i] < p2[i])?-1:1);
            }
        }
        цел rest=cast(цел)(длин & cast(т_мера) 31u);
        if (rest>0) {
            бцел маска=~((~0u)<<rest);
            бцел v1=p1[i] & маска;
            бцел v2=p2[i] & маска;
            if (v1 != v2) return ((v1<v2)?-1:1);
        }
        return ((this.длина<rhs.длина)?-1:((this.длина==rhs.длина)?0:1));
    }

    debug( UnitTest )
    {
      unittest
      {
        МассивБит a = [1,0,1,0,1];
        МассивБит b = [1,0,1];
        МассивБит c = [1,0,1,0,1,0,1];
        МассивБит d = [1,0,1,1,1];
        МассивБит e = [1,0,1,0,1];
        МассивБит f = [1,0,1,0];

        assert( a >  b );
        assert( a >= b );
        assert( a <  c );
        assert( a <= c );
        assert( a <  d );
        assert( a <= d );
        assert( a == e );
        assert( a <= e );
        assert( a >= e );
        assert( f >  b );
      }
    }


    /**
     * Convert this Массив в_ a проц Массив.
     *
     * Возвращает:
     *  This Массив represented as a проц Массив.
     */
    проц[] opCast()
    {
        return cast(проц[])ptr[0 .. цразм];
    }


    debug( UnitTest )
    {
      unittest
      {
        МассивБит a = [1,0,1,0,1];
        проц[] v = cast(проц[])a;

        assert( v.длина == a.цразм * бцел.sizeof );
      }
    }


    /**
     * Support for индекс operations, much like the behavior of built-in массивы.
     *
     * Параметры:
     *  поз = The desired индекс позиция.
     *
     * In:
     *  поз must be less than the длина of this Массив.
     *
     * Возвращает:
     *  The значение of the bit at поз.
     */
    бул opIndex( т_мера поз )
    in
    {
        assert( поз < длин );
    }
    body
    {
        return cast(бул)bt( ptr, поз );
    }


    /**
     * Generates a копируй of this Массив with the unary complement operation
     * applied.
     *
     * Возвращает:
     *  A new Массив which is the complement of this Массив.
     */
    МассивБит opCom()
    {
        auto цразм = this.цразм();

        МассивБит результат;

        результат.длина = длин;
        for( т_мера i = 0; i < цразм; ++i )
            результат.ptr[i] = ~this.ptr[i];
        if( длин & 31 )
            результат.ptr[цразм - 1] &= ~(~0 << (длин & 31));
        return результат;
    }


    debug( UnitTest )
    {
      unittest
      {
        МассивБит a = [1,0,1,0,1];
        МассивБит b = ~a;

        assert(b[0] == 0);
        assert(b[1] == 1);
        assert(b[2] == 0);
        assert(b[3] == 1);
        assert(b[4] == 0);
      }
    }


    /**
     * Generates a new Массив which is the результат of a bitwise and operation
     * between this Массив and the supplied Массив.
     *
     * Параметры:
     *  rhs = The Массив with which в_ perform the bitwise and operation.
     *
     * In:
     *  rhs.длина must equal the длина of this Массив.
     *
     * Возвращает:
     *  A new Массив which is the результат of a bitwise and with this Массив and
     *  the supplied Массив.
     */
    МассивБит opAnd( МассивБит rhs )
    in
    {
        assert( длин == rhs.длина );
    }
    body
    {
        auto цразм = this.цразм();

        МассивБит результат;

        результат.длина = длин;
        for( т_мера i = 0; i < цразм; ++i )
            результат.ptr[i] = this.ptr[i] & rhs.ptr[i];
        return результат;
    }


    debug( UnitTest )
    {
      unittest
      {
        МассивБит a = [1,0,1,0,1];
        МассивБит b = [1,0,1,1,0];

        МассивБит c = a & b;

        assert(c[0] == 1);
        assert(c[1] == 0);
        assert(c[2] == 1);
        assert(c[3] == 0);
        assert(c[4] == 0);
      }
    }


    /**
     * Generates a new Массив which is the результат of a bitwise or operation
     * between this Массив and the supplied Массив.
     *
     * Параметры:
     *  rhs = The Массив with which в_ perform the bitwise or operation.
     *
     * In:
     *  rhs.длина must equal the длина of this Массив.
     *
     * Возвращает:
     *  A new Массив which is the результат of a bitwise or with this Массив and
     *  the supplied Массив.
     */
    МассивБит opOr( МассивБит rhs )
    in
    {
        assert( длин == rhs.длина );
    }
    body
    {
        auto цразм = this.цразм();

        МассивБит результат;

        результат.длина = длин;
        for( т_мера i = 0; i < цразм; ++i )
            результат.ptr[i] = this.ptr[i] | rhs.ptr[i];
        return результат;
    }


    debug( UnitTest )
    {
      unittest
      {
        МассивБит a = [1,0,1,0,1];
        МассивБит b = [1,0,1,1,0];

        МассивБит c = a | b;

        assert(c[0] == 1);
        assert(c[1] == 0);
        assert(c[2] == 1);
        assert(c[3] == 1);
        assert(c[4] == 1);
      }
    }


    /**
     * Generates a new Массив which is the результат of a bitwise xor operation
     * between this Массив and the supplied Массив.
     *
     * Параметры:
     *  rhs = The Массив with which в_ perform the bitwise xor operation.
     *
     * In:
     *  rhs.длина must equal the длина of this Массив.
     *
     * Возвращает:
     *  A new Массив which is the результат of a bitwise xor with this Массив and
     *  the supplied Массив.
     */
    МассивБит opXor( МассивБит rhs )
    in
    {
        assert( длин == rhs.длина );
    }
    body
    {
        auto цразм = this.цразм();

        МассивБит результат;

        результат.длина = длин;
        for( т_мера i = 0; i < цразм; ++i )
            результат.ptr[i] = this.ptr[i] ^ rhs.ptr[i];
        return результат;
    }


    debug( UnitTest )
    {
      unittest
      {
        МассивБит a = [1,0,1,0,1];
        МассивБит b = [1,0,1,1,0];

        МассивБит c = a ^ b;

        assert(c[0] == 0);
        assert(c[1] == 0);
        assert(c[2] == 0);
        assert(c[3] == 1);
        assert(c[4] == 1);
      }
    }


    /**
     * Generates a new Массив which is the результат of this Массив minus the
     * supplied Массив.  $(I a - b) for BitArrays means the same thing as
     * $(I a &amp; ~b).
     *
     * Параметры:
     *  rhs = The Массив with which в_ perform the subtraction operation.
     *
     * In:
     *  rhs.длина must equal the длина of this Массив.
     *
     * Возвращает:
     *  A new Массив which is the результат of this Массив minus the supplied Массив.
     */
    МассивБит opSub( МассивБит rhs )
    in
    {
        assert( длин == rhs.длина );
    }
    body
    {
        auto цразм = this.цразм();

        МассивБит результат;

        результат.длина = длин;
        for( т_мера i = 0; i < цразм; ++i )
            результат.ptr[i] = this.ptr[i] & ~rhs.ptr[i];
        return результат;
    }


    debug( UnitTest )
    {
      unittest
      {
        МассивБит a = [1,0,1,0,1];
        МассивБит b = [1,0,1,1,0];

        МассивБит c = a - b;

        assert( c[0] == 0 );
        assert( c[1] == 0 );
        assert( c[2] == 0 );
        assert( c[3] == 0 );
        assert( c[4] == 1 );
      }
    }


    /**
     * Generates a new Массив which is the результат of this Массив concatenated
     * with the supplied Массив.
     *
     * Параметры:
     *  rhs = The Массив with which в_ perform the concatenation operation.
     *
     * Возвращает:
     *  A new Массив which is the результат of this Массив concatenated with the
     *  supplied Массив.
     */
    МассивБит opCat( бул rhs )
    {
        МассивБит результат;

        результат = this.dup;
        результат.длина = длин + 1;
        результат[длин] = rhs;
        return результат;
    }


    /** ditto */
    МассивБит opCat_r( бул lhs )
    {
        МассивБит результат;

        результат.длина = длин + 1;
        результат[0] = lhs;
        for( т_мера i = 0; i < длин; ++i )
            результат[1 + i] = (*this)[i];
        return результат;
    }


    /** ditto */
    МассивБит opCat( МассивБит rhs )
    {
        МассивБит результат;

        результат = this.dup();
        результат ~= rhs;
        return результат;
    }


    debug( UnitTest )
    {
      unittest
      {
        МассивБит a = [1,0];
        МассивБит b = [0,1,0];
        МассивБит c;

        c = (a ~ b);
        assert( c.длина == 5 );
        assert( c[0] == 1 );
        assert( c[1] == 0 );
        assert( c[2] == 0 );
        assert( c[3] == 1 );
        assert( c[4] == 0 );

        c = (a ~ да);
        assert( c.длина == 3 );
        assert( c[0] == 1 );
        assert( c[1] == 0 );
        assert( c[2] == 1 );

        c = (нет ~ a);
        assert( c.длина == 3 );
        assert( c[0] == 0 );
        assert( c[1] == 1 );
        assert( c[2] == 0 );
      }
    }


    /**
     * Support for индекс operations, much like the behavior of built-in массивы.
     *
     * Параметры:
     *  b   = The new bit значение в_ установи.
     *  поз = The desired индекс позиция.
     *
     * In:
     *  поз must be less than the длина of this Массив.
     *
     * Возвращает:
     *  The new значение of the bit at поз.
     */
    бул opIndexAssign( бул b, т_мера поз )
    in
    {
        assert( поз < длин );
    }
    body
    {
        if( b )
            bts( ptr, поз );
        else
            btr( ptr, поз );
        return b;
    }


    /**
     * Updates the contents of this Массив with the результат of a bitwise and
     * operation between this Массив and the supplied Массив.
     *
     * Параметры:
     *  rhs = The Массив with which в_ perform the bitwise and operation.
     *
     * In:
     *  rhs.длина must equal the длина of this Массив.
     *
     * Возвращает:
     *  A shallow копируй of this Массив.
     */
    МассивБит opAndAssign( МассивБит rhs )
    in
    {
        assert( длин == rhs.длина );
    }
    body
    {
        auto цразм = this.цразм();

        for( т_мера i = 0; i < цразм; ++i )
            ptr[i] &= rhs.ptr[i];
        return *this;
    }


    debug( UnitTest )
    {
      unittest
      {
        МассивБит a = [1,0,1,0,1];
        МассивБит b = [1,0,1,1,0];

        a &= b;
        assert( a[0] == 1 );
        assert( a[1] == 0 );
        assert( a[2] == 1 );
        assert( a[3] == 0 );
        assert( a[4] == 0 );
      }
    }


    /**
     * Updates the contents of this Массив with the результат of a bitwise or
     * operation between this Массив and the supplied Массив.
     *
     * Параметры:
     *  rhs = The Массив with which в_ perform the bitwise or operation.
     *
     * In:
     *  rhs.длина must equal the длина of this Массив.
     *
     * Возвращает:
     *  A shallow копируй of this Массив.
     */
    МассивБит opOrAssign( МассивБит rhs )
    in
    {
        assert( длин == rhs.длина );
    }
    body
    {
        auto цразм = this.цразм();

        for( т_мера i = 0; i < цразм; ++i )
            ptr[i] |= rhs.ptr[i];
        return *this;
    }


    debug( UnitTest )
    {
      unittest
      {
        МассивБит a = [1,0,1,0,1];
        МассивБит b = [1,0,1,1,0];

        a |= b;
        assert( a[0] == 1 );
        assert( a[1] == 0 );
        assert( a[2] == 1 );
        assert( a[3] == 1 );
        assert( a[4] == 1 );
      }
    }


    /**
     * Updates the contents of this Массив with the результат of a bitwise xor
     * operation between this Массив and the supplied Массив.
     *
     * Параметры:
     *  rhs = The Массив with which в_ perform the bitwise xor operation.
     *
     * In:
     *  rhs.длина must equal the длина of this Массив.
     *
     * Возвращает:
     *  A shallow копируй of this Массив.
     */
    МассивБит opXorAssign( МассивБит rhs )
    in
    {
        assert( длин == rhs.длина );
    }
    body
    {
        auto цразм = this.цразм();

        for( т_мера i = 0; i < цразм; ++i )
            ptr[i] ^= rhs.ptr[i];
        return *this;
    }


    debug( UnitTest )
    {
      unittest
      {
        МассивБит a = [1,0,1,0,1];
        МассивБит b = [1,0,1,1,0];

        a ^= b;
        assert( a[0] == 0 );
        assert( a[1] == 0 );
        assert( a[2] == 0 );
        assert( a[3] == 1 );
        assert( a[4] == 1 );
      }
    }


    /**
     * Updates the contents of this Массив with the результат of this Массив minus
     * the supplied Массив.  $(I a - b) for BitArrays means the same thing as
     * $(I a &amp; ~b).
     *
     * Параметры:
     *  rhs = The Массив with which в_ perform the subtraction operation.
     *
     * In:
     *  rhs.длина must equal the длина of this Массив.
     *
     * Возвращает:
     *  A shallow копируй of this Массив.
     */
    МассивБит opSubAssign( МассивБит rhs )
    in
    {
        assert( длин == rhs.длина );
    }
    body
    {
        auto цразм = this.цразм();

        for( т_мера i = 0; i < цразм; ++i )
            ptr[i] &= ~rhs.ptr[i];
        return *this;
    }


    debug( UnitTest )
    {
      unittest
      {
        МассивБит a = [1,0,1,0,1];
        МассивБит b = [1,0,1,1,0];

        a -= b;
        assert( a[0] == 0 );
        assert( a[1] == 0 );
        assert( a[2] == 0 );
        assert( a[3] == 0 );
        assert( a[4] == 1 );
      }
    }


    /**
     * Updates the contents of this Массив with the результат of this Массив
     * concatenated with the supplied Массив.
     *
     * Параметры:
     *  rhs = The Массив with which в_ perform the concatenation operation.
     *
     * Возвращает:
     *  A shallow копируй of this Массив.
     */
    МассивБит opCatAssign( бул b )
    {
        длина = длин + 1;
        (*this)[длин - 1] = b;
        return *this;
    }


    debug( UnitTest )
    {
      unittest
      {
        МассивБит a = [1,0,1,0,1];
        МассивБит b;

        b = (a ~= да);
        assert( a[0] == 1 );
        assert( a[1] == 0 );
        assert( a[2] == 1 );
        assert( a[3] == 0 );
        assert( a[4] == 1 );
        assert( a[5] == 1 );

        assert( b == a );
      }
    }


    /** ditto */
    МассивБит opCatAssign( МассивБит rhs )
    {
        auto istart = длин;
        длина = длин + rhs.длина;
        for( auto i = istart; i < длин; ++i )
            (*this)[i] = rhs[i - istart];
        return *this;
    }


    debug( UnitTest )
    {
      unittest
      {
        МассивБит a = [1,0];
        МассивБит b = [0,1,0];
        МассивБит c;

        c = (a ~= b);
        assert( a.длина == 5 );
        assert( a[0] == 1 );
        assert( a[1] == 0 );
        assert( a[2] == 0 );
        assert( a[3] == 1 );
        assert( a[4] == 0 );

        assert( c == a );
      }
    }
}
