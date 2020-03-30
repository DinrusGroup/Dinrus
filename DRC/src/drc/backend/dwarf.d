/* Dwarf debug
 *
 * Source: $(DMDSRC backend/_dwarf.d)
 */

module drc.backend.dwarf;

import drc.backend.cc;
import drc.backend.cdef;
import drc.backend.outbuf;
import drc.backend.тип;

/*extern (C++):*/



const DWARF_VERSION = 3;

проц dwarf_initfile(сим *имяф);
проц dwarf_termfile();
проц dwarf_initmodule(сим *имяф, сим *modulename);
проц dwarf_termmodule();
проц dwarf_func_start(Symbol *sfunc);
проц dwarf_func_term(Symbol *sfunc);
бцел dwarf_typidx(тип *t);
бцел dwarf_abbrev_code(ббайт *данные, т_мера члобайт);

цел dwarf_regno(цел reg);

проц dwarf_addrel(цел seg, targ_т_мера смещение, цел targseg, targ_т_мера val = 0);
цел dwarf_reftoident(цел seg, targ_т_мера смещение, Symbol *s, targ_т_мера val);
проц dwarf_except_gentables(Funcsym *sfunc, бцел startoffset, бцел retoffset);
проц genDwarfEh(Funcsym *sfunc, цел seg, Outbuffer *et, бул scancode, бцел startoffset, бцел retoffset);
цел dwarf_eh_frame_fixup(цел seg, targ_т_мера смещение, Symbol *s, targ_т_мера val, Symbol *seh);
