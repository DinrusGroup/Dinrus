/* \file linkednode
 * \brief Linked list node
 */

/*
  Originally written by Doug Lea and released into the public domain.
  This may be used for any purposes whatsoever without acknowledgment.
  Thanks for the assistance and support of Sun Microsystems Labs,
  and everyone contributing, testing, and using this code.

  History:
  Date       Who                What
	01May2004  Mike Swieton     Translated to D
  11Jun1998  dl               Create public version
  25may2000  dl               Change class access to public
  26nov2001  dl               Added no-arg constructor, all public access.
*/

module conc.linkednode;

/** A standard linked list node used in various очередь классы **/
class ЛинкованныйУзел(T) { 
	public:
		T значение;
		.ЛинкованныйУзел!(T) следщ = пусто;

		this() {}

		this(T x)
		{
			значение = x;
		}

		this(T x, .ЛинкованныйУзел!(T) n) 
		{
			значение = x;
			следщ = n;
		}
}
