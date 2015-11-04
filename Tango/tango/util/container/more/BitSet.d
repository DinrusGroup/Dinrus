/*******************************************************************************

        copyright:      Copyright (c) 2009 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Sept 2009: Initial release

        since:          0.99.9

        author:         Kris

*******************************************************************************/

module util.container.more.BitSet;

private import std.intrinsic;

/******************************************************************************

        A fixed or dynamic установи of биты. Note that this does no память 
        allocation of its own when Size != 0, and does куча allocation 
        when Size is zero. Thus you can have a fixed-размер low-overhead 
        'экземпляр, or a куча oriented экземпляр. The latter есть support
        for resizing, whereas the former does not.

        Note that leveraging intrinsics is slower when using dmd ...

******************************************************************************/

struct BitSet (цел Count=0) 
{               
        public alias and        opAnd;
        public alias or         opOrAssign;
        public alias xor        opXorAssign;
        private const           width = т_мера.sizeof * 8;

        static if (Count == 0)
                   private т_мера[] биты;
               else
                  private т_мера [(Count+width-1)/width] биты;

        /**********************************************************************

                Набор the indexed bit, resizing as necessary for куча-based
                instances (IndexOutOfBounds for statically-sized instances)

        **********************************************************************/

        проц добавь (т_мера i)
        {
                static if (Count == 0)
                           размер (i);
                or (i);
        }

        /**********************************************************************

                Test whether the indexed bit is включен 

        **********************************************************************/

        бул есть (т_мера i)
        {
                auto инд = i / width;
                return инд < биты.length && (биты[инд] & (1 << (i % width))) != 0;
                //return инд < биты.length && bt(&биты[инд], i % width) != 0;
        }

        /**********************************************************************

                Like получи() but a little faster for when you know the range
                is valid

        **********************************************************************/

        бул and (т_мера i)
        {
                return (биты[i / width] & (1 << (i % width))) != 0;
                //return bt(&биты[i / width], i % width) != 0;
        }

        /**********************************************************************

                Turn on an indexed bit

        **********************************************************************/

        проц or (т_мера i)
        {
                биты[i / width] |= (1 << (i % width));
                //bts (&биты[i / width], i % width);
        }
        
        /**********************************************************************

                Invert an indexed bit

        **********************************************************************/

        проц xor (т_мера i)
        {
                биты[i / width] ^= (1 << (i % width));
                //btc (&биты[i / width], i % width);
        }
        
        /**********************************************************************

                Clear an indexed bit

        **********************************************************************/

        проц clr (т_мера i)
        {
                биты[i / width] &= ~(1 << (i % width));
                //btr (&биты[i / width], i % width);
        }

        /**********************************************************************

                Clear все биты

        **********************************************************************/

        BitSet* clr ()
        {
                биты[] = 0;
                return this;
        }
        
        /**********************************************************************

                Clone this BitSet and return it

        **********************************************************************/

        BitSet dup ()
        {
                BitSet x;
                static if (Count == 0)
                           x.биты.length = this.биты.length;
                x.биты[] = биты[];
                return x;
        }

        /**********************************************************************

                Return the число of биты we have room for

        **********************************************************************/

        т_мера размер ()
        {
                return width * биты.length;
        }

        /**********************************************************************

                Expand в_ include the indexed bit (dynamic only)

        **********************************************************************/

        static if (Count == 0) BitSet* размер (т_мера i)
        {
                i = i / width;
                if (i >= биты.length)
                    биты.length = i + 1;
                return this;
        }
}
