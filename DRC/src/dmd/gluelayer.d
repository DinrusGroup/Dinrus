/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/gluelayer.d, _gluelayer.d)
 * Documentation:  https://dlang.org/phobos/dmd_gluelayer.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/gluelayer.d
 */

module dmd.gluelayer;

import dmd.dmodule;
import dmd.dscope;
import dmd.дсимвол;
import dmd.mtype;
import dmd.инструкция;
import util.file;

version (NoBackend)
{
    struct Symbol;
    struct code;
    struct block;
    struct Blockx;
    struct elem;
    struct TYPE;
    alias TYPE тип;

    
public {
        version (NoMain) {} else
        {
            import drc.Library : Library;

            // glue
            проц obj_write_deferred(Library library)        {}
            проц obj_start(ткст0 srcfile)            {}
            проц obj_end(Library library, ткст0 objfilename) {}
            проц genObjFile(Module m, бул multiobj)        {}

            // msc
            проц backend_init() {}
            проц backend_term() {}
        }

        // iasm
        Инструкция2 asmSemantic(AsmStatement s, Scope* sc)
        {
            sc.func.hasReturnExp = 8;
            return null;
        }

        // toir
        проц toObjFile(ДСимвол ds, бул multiobj)   {}

        /*extern(C++)*/ abstract class ObjcGlue
        {
            static проц initialize() {}
        }
    }
}
else version (Dinrus)
{
    import drc.Library : Library;

    public import drc.backend.cc : block, Blockx, Symbol;
    public import drc.backend.тип : тип;
    public import drc.backend.el : elem;
    public import drc.backend.code_x86 : code;

    
 public{
        проц obj_write_deferred(Library library);
        проц obj_start(ткст0 srcfile);
        проц obj_end(Library library, ткст0 objfilename);
        проц genObjFile(Module m, бул multiobj);

        проц backend_init();
        проц backend_term();

        Инструкция2 asmSemantic(AsmStatement s, Scope* sc);

        проц toObjFile(ДСимвол ds, бул multiobj);

        /*extern(C++)*/ abstract class ObjcGlue
        {
            static проц initialize();
        }
    }
}
else version (IN_GCC)
{
     union tree_node;

    alias  tree_node Symbol;
    alias  tree_node code;
    alias  tree_node тип;

    
   public {
        Инструкция2 asmSemantic(AsmStatement s, Scope* sc);
    }

    // stubs
    /*extern(C++)*/ abstract class ObjcGlue
    {
        static проц initialize() {}
    }
}
else
    static assert(нет, "Unsupported compiler backend");
