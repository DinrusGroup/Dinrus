/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 2000-2020 by The D Language Foundation, All Rights Reserved
 *
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/backend.d, backend/backend.d)
 */
module drc.backend.backend;

version (SCPP)
    version = COMPILE;
version (Dinrus)
    version = COMPILE;

version (COMPILE)
{

import drc.backend.code_x86;
import drc.backend.el;

/*extern (C++):*/

//

extern  { цел stackused; }
extern  NDP[8] _8087elems;

}
