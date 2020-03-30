/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1985-1998 by Symantec
 *              Copyright (C) 2000-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/fp.d backend/fp.d)
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/backend/fp.d
 */

 module drc.backend.fp;

version (SPP) {} else
{
    import cidrus;
    import util.longdouble;
    import drc.backend.cdef;

    /*extern (C++):*/

    

    цел statusFE()
    {
        return 0;
    }

    цел testFE()
    {
        return fetestexcept(FE_ALL_EXCEPT);
    }

    проц clearFE()
    {
        feclearexcept(FE_ALL_EXCEPT);
    }

    бул have_float_except() { return да; }

    longdouble _modulo(longdouble x, longdouble y)
    {
        static if (TARGET_FREEBSD || TARGET_OPENBSD || TARGET_DRAGONFLYBSD)
        {
            return fmod(x, y);
        }
        else
        {
            return fmodl(x, y);
        }
    }
}
