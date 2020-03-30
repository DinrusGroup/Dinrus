/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1994-1998 by Symantec
 *              Copyright (C) 2000-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/obj.d, backend/obj.d)
 */

module drc.backend.obj;

// Online documentation: https://dlang.org/phobos/dmd_backend_obj.html

/* Interface to объект файл format
 */

import drc.backend.cdef;
import drc.backend.cc;
import drc.backend.code;
import drc.backend.el;
import drc.backend.outbuf;

/*extern (C++):*/



version (Windows)
{
    version (SCPP)
    {
        version = OMF;
    }
    version (SPP)
    {
        version = OMF;
    }
    version (HTOD)
    {
        version = STUB;
    }
    version (Dinrus)
    {
        version = OMFandMSCOFF;
    }
}

version (Windows)
{
    Obj  OmfObj_init(Outbuffer *, ткст0 имяф, ткст0 csegname);
    проц OmfObj_initfile(ткст0 имяф, ткст0 csegname, ткст0 modname);
    проц OmfObj_termfile();
    проц OmfObj_term(ткст0 objfilename);
    т_мера OmfObj_mangle(Symbol *s,сим *dest);
    проц OmfObj_import(elem *e);
    проц OmfObj_linnum(Srcpos srcpos, цел seg, targ_т_мера смещение);
    цел  OmfObj_codeseg( сим *имя,цел suffix);
    проц OmfObj_dosseg();
    проц OmfObj_startaddress(Symbol *);
    бул OmfObj_includelib(ткст0 );
    бул OmfObj_linkerdirective(ткст0 );
    бул OmfObj_allowZeroSize();
    проц OmfObj_exestr(ткст0 p);
    проц OmfObj_user(ткст0 p);
    проц OmfObj_compiler();
    проц OmfObj_wkext(Symbol *,Symbol *);
    проц OmfObj_lzext(Symbol *,Symbol *);
    проц OmfObj_alias(ткст0 n1,ткст0 n2);
    проц OmfObj_theadr(ткст0 modname);
    проц OmfObj_segment_group(targ_т_мера codesize, targ_т_мера datasize, targ_т_мера cdatasize, targ_т_мера udatasize);
    проц OmfObj_staticctor(Symbol *s,цел dtor,цел seg);
    проц OmfObj_staticdtor(Symbol *s);
    проц OmfObj_setModuleCtorDtor(Symbol *s, бул isCtor);
    проц OmfObj_ehtables(Symbol *sfunc,бцел size,Symbol *ehsym);
    проц OmfObj_ehsections();
    проц OmfObj_moduleinfo(Symbol *scc);
    цел  OmfObj_comdat(Symbol *);
    цел  OmfObj_comdatsize(Symbol *, targ_т_мера symsize);
    цел  OmfObj_readonly_comdat(Symbol *s);
    проц OmfObj_setcodeseg(цел seg);
    seg_data* OmfObj_tlsseg();
    seg_data* OmfObj_tlsseg_bss();
    seg_data* OmfObj_tlsseg_data();
    цел  OmfObj_fardata(сим *имя, targ_т_мера size, targ_т_мера *poffset);
    проц OmfObj_export_symbol(Symbol *s, бцел argsize);
    проц OmfObj_pubdef(цел seg, Symbol *s, targ_т_мера смещение);
    проц OmfObj_pubdefsize(цел seg, Symbol *s, targ_т_мера смещение, targ_т_мера symsize);
    цел  OmfObj_external_def(ткст0 );
    цел  OmfObj_data_start(Symbol *sdata, targ_т_мера datasize, цел seg);
    цел  OmfObj_external(Symbol *);
    цел  OmfObj_common_block(Symbol *s, targ_т_мера size, targ_т_мера count);
    цел  OmfObj_common_block(Symbol *s, цел флаг, targ_т_мера size, targ_т_мера count);
    проц OmfObj_lidata(цел seg, targ_т_мера смещение, targ_т_мера count);
    проц OmfObj_write_zeros(seg_data *pseg, targ_т_мера count);
    проц OmfObj_write_byte(seg_data *pseg, бцел _byte);
    проц OmfObj_write_bytes(seg_data *pseg, бцел члобайт, проц *p);
    проц OmfObj_byte(цел seg, targ_т_мера смещение, бцел _byte);
    бцел OmfObj_bytes(цел seg, targ_т_мера смещение, бцел члобайт, проц *p);
    проц OmfObj_ledata(цел seg, targ_т_мера смещение, targ_т_мера данные, бцел lcfd, бцел idx1, бцел idx2);
    проц OmfObj_write_long(цел seg, targ_т_мера смещение, бцел данные, бцел lcfd, бцел idx1, бцел idx2);
    проц OmfObj_reftodatseg(цел seg, targ_т_мера смещение, targ_т_мера val, бцел targetdatum, цел flags);
    проц OmfObj_reftofarseg(цел seg, targ_т_мера смещение, targ_т_мера val, цел farseg, цел flags);
    проц OmfObj_reftocodeseg(цел seg, targ_т_мера смещение, targ_т_мера val);
    цел  OmfObj_reftoident(цел seg, targ_т_мера смещение, Symbol *s, targ_т_мера val, цел flags);
    проц OmfObj_far16thunk(Symbol *s);
    проц OmfObj_fltused();
    цел  OmfObj_data_readonly(сим *p, цел len, цел *pseg);
    цел  OmfObj_data_readonly(сим *p, цел len);
    цел  OmfObj_string_literal_segment(бцел sz);
    Symbol* OmfObj_sym_cdata(tym_t, сим *, цел);
    проц OmfObj_func_start(Symbol *sfunc);
    проц OmfObj_func_term(Symbol *sfunc);
    проц OmfObj_write_pointerRef(Symbol* s, бцел off);
    цел  OmfObj_jmpTableSegment(Symbol* s);
    Symbol* OmfObj_tlv_bootstrap();
    проц OmfObj_gotref(Symbol *s);
    цел  OmfObj_seg_debugT();           // where the symbolic debug тип данные goes

    Obj  MsCoffObj_init(Outbuffer *, ткст0 имяф, ткст0 csegname);
    проц MsCoffObj_initfile(ткст0 имяф, ткст0 csegname, ткст0 modname);
    проц MsCoffObj_termfile();
    проц MsCoffObj_term(ткст0 objfilename);
//    т_мера MsCoffObj_mangle(Symbol *s,сим *dest);
//    проц MsCoffObj_import(elem *e);
    проц MsCoffObj_linnum(Srcpos srcpos, цел seg, targ_т_мера смещение);
    цел  MsCoffObj_codeseg( сим *имя,цел suffix);
//    проц MsCoffObj_dosseg();
    проц MsCoffObj_startaddress(Symbol *);
    бул MsCoffObj_includelib(ткст0 );
    бул MsCoffObj_linkerdirective(ткст0 );
    бул MsCoffObj_allowZeroSize();
    проц MsCoffObj_exestr(ткст0 p);
    проц MsCoffObj_user(ткст0 p);
    проц MsCoffObj_compiler();
    проц MsCoffObj_wkext(Symbol *,Symbol *);
//    проц MsCoffObj_lzext(Symbol *,Symbol *);
    проц MsCoffObj_alias(ткст0 n1,ткст0 n2);
//    проц MsCoffObj_theadr(ткст0 modname);
//    проц MsCoffObj_segment_group(targ_т_мера codesize, targ_т_мера datasize, targ_т_мера cdatasize, targ_т_мера udatasize);
    проц MsCoffObj_staticctor(Symbol *s,цел dtor,цел seg);
    проц MsCoffObj_staticdtor(Symbol *s);
    проц MsCoffObj_setModuleCtorDtor(Symbol *s, бул isCtor);
    проц MsCoffObj_ehtables(Symbol *sfunc,бцел size,Symbol *ehsym);
    проц MsCoffObj_ehsections();
    проц MsCoffObj_moduleinfo(Symbol *scc);
    цел  MsCoffObj_comdat(Symbol *);
    цел  MsCoffObj_comdatsize(Symbol *, targ_т_мера symsize);
    цел  MsCoffObj_readonly_comdat(Symbol *s);
    проц MsCoffObj_setcodeseg(цел seg);
    seg_data* MsCoffObj_tlsseg();
    seg_data* MsCoffObj_tlsseg_bss();
    seg_data* MsCoffObj_tlsseg_data();
//    цел  MsCoffObj_fardata(сим *имя, targ_т_мера size, targ_т_мера *poffset);
    проц MsCoffObj_export_symbol(Symbol *s, бцел argsize);
    проц MsCoffObj_pubdef(цел seg, Symbol *s, targ_т_мера смещение);
    проц MsCoffObj_pubdefsize(цел seg, Symbol *s, targ_т_мера смещение, targ_т_мера symsize);
    цел  MsCoffObj_external_def(ткст0 );
    цел  MsCoffObj_data_start(Symbol *sdata, targ_т_мера datasize, цел seg);
    цел  MsCoffObj_external(Symbol *);
    цел  MsCoffObj_common_block(Symbol *s, targ_т_мера size, targ_т_мера count);
    цел  MsCoffObj_common_block(Symbol *s, цел флаг, targ_т_мера size, targ_т_мера count);
    проц MsCoffObj_lidata(цел seg, targ_т_мера смещение, targ_т_мера count);
    проц MsCoffObj_write_zeros(seg_data *pseg, targ_т_мера count);
    проц MsCoffObj_write_byte(seg_data *pseg, бцел _byte);
    проц MsCoffObj_write_bytes(seg_data *pseg, бцел члобайт, проц *p);
    проц MsCoffObj_byte(цел seg, targ_т_мера смещение, бцел _byte);
    бцел MsCoffObj_bytes(цел seg, targ_т_мера смещение, бцел члобайт, проц *p);
//    проц MsCoffObj_ledata(цел seg, targ_т_мера смещение, targ_т_мера данные, бцел lcfd, бцел idx1, бцел idx2);
//    проц MsCoffObj_write_long(цел seg, targ_т_мера смещение, бцел данные, бцел lcfd, бцел idx1, бцел idx2);
    проц MsCoffObj_reftodatseg(цел seg, targ_т_мера смещение, targ_т_мера val, бцел targetdatum, цел flags);
//    проц MsCoffObj_reftofarseg(цел seg, targ_т_мера смещение, targ_т_мера val, цел farseg, цел flags);
    проц MsCoffObj_reftocodeseg(цел seg, targ_т_мера смещение, targ_т_мера val);
    цел  MsCoffObj_reftoident(цел seg, targ_т_мера смещение, Symbol *s, targ_т_мера val, цел flags);
    проц MsCoffObj_far16thunk(Symbol *s);
    проц MsCoffObj_fltused();
    цел  MsCoffObj_data_readonly(сим *p, цел len, цел *pseg);
    цел  MsCoffObj_data_readonly(сим *p, цел len);
    цел  MsCoffObj_string_literal_segment(бцел sz);
    Symbol* MsCoffObj_sym_cdata(tym_t, сим *, цел);
    проц MsCoffObj_func_start(Symbol *sfunc);
    проц MsCoffObj_func_term(Symbol *sfunc);
    проц MsCoffObj_write_pointerRef(Symbol* s, бцел off);
    цел  MsCoffObj_jmpTableSegment(Symbol* s);
    Symbol* MsCoffObj_tlv_bootstrap();
//    проц MsCoffObj_gotref(Symbol *s);
    цел  MsCoffObj_seg_debugT();           // where the symbolic debug тип данные goes

    цел  MsCoffObj_getsegment(ткст0 sectname, бцел flags);
    цел  MsCoffObj_getsegment2( бцел shtidx);
    бцел MsCoffObj_addScnhdr(ткст0 scnhdr_name, бцел flags);
    проц MsCoffObj_addrel(цел seg, targ_т_мера смещение, Symbol *targsym,
                          бцел targseg, цел rtype, цел val);
    цел  MsCoffObj_seg_drectve();
    цел  MsCoffObj_seg_pdata();
    цел  MsCoffObj_seg_xdata();
    цел  MsCoffObj_seg_pdata_comdat(Symbol *sfunc);
    цел  MsCoffObj_seg_xdata_comdat(Symbol *sfunc);
    цел  MsCoffObj_seg_debugS();
    цел  MsCoffObj_seg_debugS_comdat(Symbol *sfunc);
}

version (Posix)
{
    Obj Obj_init(Outbuffer *, ткст0 имяф, ткст0 csegname);
    проц Obj_initfile(ткст0 имяф, ткст0 csegname, ткст0 modname);
    проц Obj_termfile();
    проц Obj_term(ткст0 objfilename);
    проц Obj_compiler();
    проц Obj_exestr(ткст0 p);
    проц Obj_dosseg();
    проц Obj_startaddress(Symbol *);
    бул Obj_includelib(ткст0 );
    бул Obj_linkerdirective(ткст0 p);
    т_мера Obj_mangle(Symbol *s,сим *dest);
    проц Obj_alias(ткст0 n1,ткст0 n2);
    проц Obj_user(ткст0 p);

    проц Obj_import(elem *e);
    проц Obj_linnum(Srcpos srcpos, цел seg, targ_т_мера смещение);
    цел Obj_codeseg( сим *имя,цел suffix);
    бул Obj_allowZeroSize();
    проц Obj_wkext(Symbol *,Symbol *);
    проц Obj_lzext(Symbol *,Symbol *);
    проц Obj_theadr(ткст0 modname);
    проц Obj_segment_group(targ_т_мера codesize, targ_т_мера datasize, targ_т_мера cdatasize, targ_т_мера udatasize);
    проц Obj_staticctor(Symbol *s,цел dtor,цел seg);
    проц Obj_staticdtor(Symbol *s);
    проц Obj_setModuleCtorDtor(Symbol *s, бул isCtor);
    проц Obj_ehtables(Symbol *sfunc,бцел size,Symbol *ehsym);
    проц Obj_ehsections();
    проц Obj_moduleinfo(Symbol *scc);
    цел Obj_comdat(Symbol *);
    цел Obj_comdatsize(Symbol *, targ_т_мера symsize);
    цел Obj_readonly_comdat(Symbol *s);
    проц Obj_setcodeseg(цел seg);
    seg_data* Obj_tlsseg();
    seg_data* Obj_tlsseg_bss();
    seg_data* Obj_tlsseg_data();
    цел Obj_fardata(сим *имя, targ_т_мера size, targ_т_мера *poffset);
    проц Obj_export_symbol(Symbol *s, бцел argsize);
    проц Obj_pubdef(цел seg, Symbol *s, targ_т_мера смещение);
    проц Obj_pubdefsize(цел seg, Symbol *s, targ_т_мера смещение, targ_т_мера symsize);
    цел Obj_external_def(ткст0 );
    цел Obj_data_start(Symbol *sdata, targ_т_мера datasize, цел seg);
    цел Obj_external(Symbol *);
    цел Obj_common_block(Symbol *s, targ_т_мера size, targ_т_мера count);
    цел Obj_common_block(Symbol *s, цел флаг, targ_т_мера size, targ_т_мера count);
    проц Obj_lidata(цел seg, targ_т_мера смещение, targ_т_мера count);
    проц Obj_write_zeros(seg_data *pseg, targ_т_мера count);
    проц Obj_write_byte(seg_data *pseg, бцел _byte);
    проц Obj_write_bytes(seg_data *pseg, бцел члобайт, проц *p);
    проц Obj_byte(цел seg, targ_т_мера смещение, бцел _byte);
    бцел Obj_bytes(цел seg, targ_т_мера смещение, бцел члобайт, проц *p);
    проц Obj_ledata(цел seg, targ_т_мера смещение, targ_т_мера данные, бцел lcfd, бцел idx1, бцел idx2);
    проц Obj_write_long(цел seg, targ_т_мера смещение, бцел данные, бцел lcfd, бцел idx1, бцел idx2);
    проц Obj_reftodatseg(цел seg, targ_т_мера смещение, targ_т_мера val, бцел targetdatum, цел flags);
    проц Obj_reftofarseg(цел seg, targ_т_мера смещение, targ_т_мера val, цел farseg, цел flags);
    проц Obj_reftocodeseg(цел seg, targ_т_мера смещение, targ_т_мера val);
    цел Obj_reftoident(цел seg, targ_т_мера смещение, Symbol *s, targ_т_мера val, цел flags);
    проц Obj_far16thunk(Symbol *s);
    проц Obj_fltused();
    цел Obj_data_readonly(сим *p, цел len, цел *pseg);
    цел Obj_data_readonly(сим *p, цел len);
    цел Obj_string_literal_segment(бцел sz);
    Symbol* Obj_sym_cdata(tym_t, сим *, цел);
    проц Obj_func_start(Symbol *sfunc);
    проц Obj_func_term(Symbol *sfunc);
    проц Obj_write_pointerRef(Symbol* s, бцел off);
    цел Obj_jmpTableSegment(Symbol* s);

    Symbol* Obj_tlv_bootstrap();

    проц Obj_gotref(Symbol *s);

    бцел Obj_addstr(Outbuffer *strtab, ткст0 );
    Symbol* Obj_getGOTsym();
    проц Obj_refGOTsym();

    version (OSX)
    {
        цел Obj_getsegment(ткст0 sectname, ткст0 segname,
                              цел  _align, цел flags);
        проц Obj_addrel(цел seg, targ_т_мера смещение, Symbol *targsym,
                           бцел targseg, цел rtype, цел val = 0);
    }
    else
    {
        цел Obj_getsegment(ткст0 имя, ткст0 suffix,
                              цел тип, цел flags, цел  _align);
        проц Obj_addrel(цел seg, targ_т_мера смещение, бцел тип,
                           бцел symidx, targ_т_мера val);
        т_мера Obj_writerel(цел targseg, т_мера смещение, бцел тип,
                               бцел symidx, targ_т_мера val);
    }
}

version (OMF)
{
    class Obj
    {
      static
      {
        

        Obj init(Outbuffer* objbuf, ткст0 имяф, ткст0 csegname)
        {
            return OmfObj_init(objbuf, имяф, csegname);
        }

        проц initfile(ткст0 имяф, ткст0 csegname, ткст0 modname)
        {
            return OmfObj_initfile(имяф, csegname, modname);
        }

        проц termfile()
        {
            return OmfObj_termfile();
        }

        проц term(ткст0 objfilename)
        {
            return OmfObj_term(objfilename);
        }

        т_мера mangle(Symbol *s,сим *dest)
        {
            return OmfObj_mangle(s, dest);
        }

        проц _import(elem *e)
        {
            return OmfObj_import(e);
        }

        проц номстр(Srcpos srcpos, цел seg, targ_т_мера смещение)
        {
            return OmfObj_linnum(srcpos, seg, смещение);
        }

        цел codeseg( сим *имя,цел suffix)
        {
            return OmfObj_codeseg(имя, suffix);
        }

        проц dosseg()
        {
            return OmfObj_dosseg();
        }

        проц startaddress(Symbol *s)
        {
            return OmfObj_startaddress(s);
        }

        бул includelib(ткст0 имя)
        {
            return OmfObj_includelib(имя);
        }

        бул linkerdirective(ткст0 p)
        {
            return OmfObj_linkerdirective(p);
        }

        бул allowZeroSize()
        {
            return OmfObj_allowZeroSize();
        }

        проц exestr(ткст0 p)
        {
            return OmfObj_exestr(p);
        }

        проц user(ткст0 p)
        {
            return OmfObj_user(p);
        }

        проц compiler()
        {
            return OmfObj_compiler();
        }

        проц wkext(Symbol* s1, Symbol* s2)
        {
            return OmfObj_wkext(s1, s2);
        }

        проц lzext(Symbol* s1, Symbol* s2)
        {
            return OmfObj_lzext(s1, s2);
        }

        проц _alias(ткст0 n1,ткст0 n2)
        {
            return OmfObj_alias(n1, n2);
        }

        проц theadr(ткст0 modname)
        {
            return OmfObj_theadr(modname);
        }

        проц segment_group(targ_т_мера codesize, targ_т_мера datasize, targ_т_мера cdatasize, targ_т_мера udatasize)
        {
            return OmfObj_segment_group(codesize, datasize, cdatasize, udatasize);
        }

        проц staticctor(Symbol *s,цел dtor,цел seg)
        {
            return OmfObj_staticctor(s, dtor, seg);
        }

        проц staticdtor(Symbol *s)
        {
            return OmfObj_staticdtor(s);
        }

        проц setModuleCtorDtor(Symbol *s, бул isCtor)
        {
            return OmfObj_setModuleCtorDtor(s, isCtor);
        }

        проц ehtables(Symbol *sfunc,бцел size,Symbol *ehsym)
        {
            return OmfObj_ehtables(sfunc, size, ehsym);
        }

        проц ehsections()
        {
            return OmfObj_ehsections();
        }

        проц moduleinfo(Symbol *scc)
        {
            return OmfObj_moduleinfo(scc);
        }

        цел comdat(Symbol *s)
        {
            return OmfObj_comdat(s);
        }

        цел comdatsize(Symbol *s, targ_т_мера symsize)
        {
            return OmfObj_comdatsize(s, symsize);
        }

        цел readonly_comdat(Symbol *s)
        {
            return OmfObj_comdat(s);
        }

        проц setcodeseg(цел seg)
        {
            return OmfObj_setcodeseg(seg);
        }

        seg_data *tlsseg()
        {
            return OmfObj_tlsseg();
        }

        seg_data *tlsseg_bss()
        {
            return OmfObj_tlsseg_bss();
        }

        seg_data *tlsseg_data()
        {
            return OmfObj_tlsseg_data();
        }

        цел  fardata(сим *имя, targ_т_мера size, targ_т_мера *poffset)
        {
            return OmfObj_fardata(имя, size, poffset);
        }

        проц export_symbol(Symbol *s, бцел argsize)
        {
            return OmfObj_export_symbol(s, argsize);
        }

        проц pubdef(цел seg, Symbol *s, targ_т_мера смещение)
        {
            return OmfObj_pubdef(seg, s, смещение);
        }

        проц pubdefsize(цел seg, Symbol *s, targ_т_мера смещение, targ_т_мера symsize)
        {
            return OmfObj_pubdefsize(seg, s, смещение, symsize);
        }

        цел external_def(ткст0 имя)
        {
            return OmfObj_external_def(имя);
        }

        цел data_start(Symbol *sdata, targ_т_мера datasize, цел seg)
        {
            return OmfObj_data_start(sdata, datasize, seg);
        }

        цел external(Symbol *s)
        {
            return OmfObj_external(s);
        }

        цел common_block(Symbol *s, targ_т_мера size, targ_т_мера count)
        {
            return OmfObj_common_block(s, size, count);
        }

        цел common_block(Symbol *s, цел флаг, targ_т_мера size, targ_т_мера count)
        {
            return OmfObj_common_block(s, флаг, size, count);
        }

        проц lidata(цел seg, targ_т_мера смещение, targ_т_мера count)
        {
            return OmfObj_lidata(seg, смещение, count);
        }

        проц write_zeros(seg_data *pseg, targ_т_мера count)
        {
            return OmfObj_write_zeros(pseg, count);
        }

        проц write_byte(seg_data *pseg, бцел _byte)
        {
            return OmfObj_write_byte(pseg, _byte);
        }

        проц write_bytes(seg_data *pseg, бцел члобайт, проц *p)
        {
            return OmfObj_write_bytes(pseg, члобайт, p);
        }

        проц _byte(цел seg, targ_т_мера смещение, бцел _byte)
        {
            return OmfObj_byte(seg, смещение, _byte);
        }

        бцел bytes(цел seg, targ_т_мера смещение, бцел члобайт, проц *p)
        {
            return OmfObj_bytes(seg, смещение, члобайт, p);
        }

        проц ledata(цел seg, targ_т_мера смещение, targ_т_мера данные, бцел lcfd, бцел idx1, бцел idx2)
        {
            return OmfObj_ledata(seg, смещение, данные, lcfd, idx1, idx2);
        }

        проц write_long(цел seg, targ_т_мера смещение, бцел данные, бцел lcfd, бцел idx1, бцел idx2)
        {
            return OmfObj_write_long(seg, смещение, данные, lcfd, idx1, idx2);
        }

        проц reftodatseg(цел seg, targ_т_мера смещение, targ_т_мера val, бцел targetdatum, цел flags)
        {
            return OmfObj_reftodatseg(seg, смещение, val, targetdatum, flags);
        }

        проц reftofarseg(цел seg, targ_т_мера смещение, targ_т_мера val, цел farseg, цел flags)
        {
            return OmfObj_reftofarseg(seg, смещение, val, farseg, flags);
        }

        проц reftocodeseg(цел seg, targ_т_мера смещение, targ_т_мера val)
        {
            return OmfObj_reftocodeseg(seg, смещение, val);
        }

        цел reftoident(цел seg, targ_т_мера смещение, Symbol *s, targ_т_мера val, цел flags)
        {
            return OmfObj_reftoident(seg, смещение, s, val, flags);
        }

        проц far16thunk(Symbol *s)
        {
            return OmfObj_far16thunk(s);
        }

        проц fltused()
        {
            return OmfObj_fltused();
        }

        цел data_readonly(сим *p, цел len, цел *pseg)
        {
            return OmfObj_data_readonly(p, len, pseg);
        }

        цел data_readonly(сим *p, цел len)
        {
            return OmfObj_data_readonly(p, len);
        }

        цел string_literal_segment(бцел sz)
        {
            return OmfObj_string_literal_segment(sz);
        }

        Symbol *sym_cdata(tym_t ty, сим *p, цел len)
        {
            return OmfObj_sym_cdata(ty, p, len);
        }

        проц func_start(Symbol *sfunc)
        {
            return OmfObj_func_start(sfunc);
        }

        проц func_term(Symbol *sfunc)
        {
            return OmfObj_func_term(sfunc);
        }

        проц write_pointerRef(Symbol* s, бцел off)
        {
            return OmfObj_write_pointerRef(s, off);
        }

        цел jmpTableSegment(Symbol* s)
        {
            return OmfObj_jmpTableSegment(s);
        }

        Symbol *tlv_bootstrap()
        {
            return OmfObj_tlv_bootstrap();
        }

        проц gotref(Symbol *s)
        {
            return OmfObj_gotref(s);
        }

        цел seg_debugT()           // where the symbolic debug тип данные goes
        {
            return OmfObj_seg_debugT();
        }

      }
    }
}
else version (OMFandMSCOFF)
{
    class Obj
    {
      static
      {
        

        Obj init(Outbuffer* objbuf, ткст0 имяф, ткст0 csegname)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_init(objbuf, имяф, csegname)
                :    OmfObj_init(objbuf, имяф, csegname);
        }

        проц initfile(ткст0 имяф, ткст0 csegname, ткст0 modname)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_initfile(имяф, csegname, modname)
                :    OmfObj_initfile(имяф, csegname, modname);
        }

        проц termfile()
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_termfile()
                :    OmfObj_termfile();
        }

        проц term(ткст0 objfilename)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_term(objfilename)
                :    OmfObj_term(objfilename);
        }

        т_мера mangle(Symbol *s,сим *dest)
        {
            assert(config.objfmt == OBJ_OMF);
            return OmfObj_mangle(s, dest);
        }

        проц _import(elem *e)
        {
            assert(config.objfmt == OBJ_OMF);
            return OmfObj_import(e);
        }

        проц номстр(Srcpos srcpos, цел seg, targ_т_мера смещение)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_linnum(srcpos, seg, смещение)
                :    OmfObj_linnum(srcpos, seg, смещение);
        }

        цел codeseg(сим *имя,цел suffix)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_codeseg(имя, suffix)
                :    OmfObj_codeseg(имя, suffix);
        }

        проц dosseg()
        {
            assert(config.objfmt == OBJ_OMF);
            return OmfObj_dosseg();
        }

        проц startaddress(Symbol *s)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_startaddress(s)
                :    OmfObj_startaddress(s);
        }

        бул includelib(ткст0 имя)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_includelib(имя)
                :    OmfObj_includelib(имя);
        }

        бул linkerdirective(ткст0 p)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_linkerdirective(p)
                :    OmfObj_linkerdirective(p);
        }

        бул allowZeroSize()
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_allowZeroSize()
                :    OmfObj_allowZeroSize();
        }

        проц exestr(ткст0 p)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_exestr(p)
                :    OmfObj_exestr(p);
        }

        проц user(ткст0 p)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_user(p)
                :    OmfObj_user(p);
        }

        проц compiler()
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_compiler()
                :    OmfObj_compiler();
        }

        проц wkext(Symbol* s1, Symbol* s2)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_wkext(s1, s2)
                :    OmfObj_wkext(s1, s2);
        }

        проц lzext(Symbol* s1, Symbol* s2)
        {
            return config.objfmt == OBJ_MSCOFF
                ? assert(0)
                : OmfObj_lzext(s1, s2);
        }

        проц _alias(ткст0 n1,ткст0 n2)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_alias(n1, n2)
                :    OmfObj_alias(n1, n2);
        }

        проц theadr(ткст0 modname)
        {
            return config.objfmt == OBJ_MSCOFF
                ? assert(0)
                : OmfObj_theadr(modname);
        }

        проц segment_group(targ_т_мера codesize, targ_т_мера datasize, targ_т_мера cdatasize, targ_т_мера udatasize)
        {
            return config.objfmt == OBJ_MSCOFF
                ? assert(0)
                : OmfObj_segment_group(codesize, datasize, cdatasize, udatasize);
        }

        проц staticctor(Symbol *s,цел dtor,цел seg)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_staticctor(s, dtor, seg)
                :    OmfObj_staticctor(s, dtor, seg);
        }

        проц staticdtor(Symbol *s)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_staticdtor(s)
                :    OmfObj_staticdtor(s);
        }

        проц setModuleCtorDtor(Symbol *s, бул isCtor)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_setModuleCtorDtor(s, isCtor)
                :    OmfObj_setModuleCtorDtor(s, isCtor);
        }

        проц ehtables(Symbol *sfunc,бцел size,Symbol *ehsym)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_ehtables(sfunc, size, ehsym)
                :    OmfObj_ehtables(sfunc, size, ehsym);
        }

        проц ehsections()
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_ehsections()
                :    OmfObj_ehsections();
        }

        проц moduleinfo(Symbol *scc)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_moduleinfo(scc)
                :    OmfObj_moduleinfo(scc);
        }

        цел comdat(Symbol *s)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_comdat(s)
                :    OmfObj_comdat(s);
        }

        цел comdatsize(Symbol *s, targ_т_мера symsize)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_comdatsize(s, symsize)
                :    OmfObj_comdatsize(s, symsize);
        }

        цел readonly_comdat(Symbol *s)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_comdat(s)
                :    OmfObj_comdat(s);
        }

        проц setcodeseg(цел seg)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_setcodeseg(seg)
                :    OmfObj_setcodeseg(seg);
        }

        seg_data *tlsseg()
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_tlsseg()
                :    OmfObj_tlsseg();
        }

        seg_data *tlsseg_bss()
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_tlsseg_bss()
                :    OmfObj_tlsseg_bss();
        }

        seg_data *tlsseg_data()
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_tlsseg_data()
                :    OmfObj_tlsseg_data();
        }

        цел  fardata(сим *имя, targ_т_мера size, targ_т_мера *poffset)
        {
            assert(config.objfmt == OBJ_OMF);
            return OmfObj_fardata(имя, size, poffset);
        }

        проц export_symbol(Symbol *s, бцел argsize)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_export_symbol(s, argsize)
                :    OmfObj_export_symbol(s, argsize);
        }

        проц pubdef(цел seg, Symbol *s, targ_т_мера смещение)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_pubdef(seg, s, смещение)
                :    OmfObj_pubdef(seg, s, смещение);
        }

        проц pubdefsize(цел seg, Symbol *s, targ_т_мера смещение, targ_т_мера symsize)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_pubdefsize(seg, s, смещение, symsize)
                :    OmfObj_pubdefsize(seg, s, смещение, symsize);
        }

        цел external_def(ткст0 имя)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_external_def(имя)
                :    OmfObj_external_def(имя);
        }

        цел data_start(Symbol *sdata, targ_т_мера datasize, цел seg)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_data_start(sdata, datasize, seg)
                :    OmfObj_data_start(sdata, datasize, seg);
        }

        цел external(Symbol *s)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_external(s)
                :    OmfObj_external(s);
        }

        цел common_block(Symbol *s, targ_т_мера size, targ_т_мера count)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_common_block(s, size, count)
                :    OmfObj_common_block(s, size, count);
        }

        цел common_block(Symbol *s, цел флаг, targ_т_мера size, targ_т_мера count)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_common_block(s, флаг, size, count)
                :    OmfObj_common_block(s, флаг, size, count);
        }

        проц lidata(цел seg, targ_т_мера смещение, targ_т_мера count)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_lidata(seg, смещение, count)
                :    OmfObj_lidata(seg, смещение, count);
        }

        проц write_zeros(seg_data *pseg, targ_т_мера count)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_write_zeros(pseg, count)
                :    OmfObj_write_zeros(pseg, count);
        }

        проц write_byte(seg_data *pseg, бцел _byte)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_write_byte(pseg, _byte)
                :    OmfObj_write_byte(pseg, _byte);
        }

        проц write_bytes(seg_data *pseg, бцел члобайт, проц *p)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_write_bytes(pseg, члобайт, p)
                :    OmfObj_write_bytes(pseg, члобайт, p);
        }

        проц _byte(цел seg, targ_т_мера смещение, бцел _byte)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_byte(seg, смещение, _byte)
                :    OmfObj_byte(seg, смещение, _byte);
        }

        бцел bytes(цел seg, targ_т_мера смещение, бцел члобайт, проц *p)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_bytes(seg, смещение, члобайт, p)
                :    OmfObj_bytes(seg, смещение, члобайт, p);
        }

        проц ledata(цел seg, targ_т_мера смещение, targ_т_мера данные, бцел lcfd, бцел idx1, бцел idx2)
        {
            return config.objfmt == OBJ_MSCOFF
                ? assert(0)
                : OmfObj_ledata(seg, смещение, данные, lcfd, idx1, idx2);
        }

        проц write_long(цел seg, targ_т_мера смещение, бцел данные, бцел lcfd, бцел idx1, бцел idx2)
        {
            return config.objfmt == OBJ_MSCOFF
                ? assert(0)
                : OmfObj_write_long(seg, смещение, данные, lcfd, idx1, idx2);
        }

        проц reftodatseg(цел seg, targ_т_мера смещение, targ_т_мера val, бцел targetdatum, цел flags)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_reftodatseg(seg, смещение, val, targetdatum, flags)
                :    OmfObj_reftodatseg(seg, смещение, val, targetdatum, flags);
        }

        проц reftofarseg(цел seg, targ_т_мера смещение, targ_т_мера val, цел farseg, цел flags)
        {
            return config.objfmt == OBJ_MSCOFF
                ? assert(0)
                : OmfObj_reftofarseg(seg, смещение, val, farseg, flags);
        }

        проц reftocodeseg(цел seg, targ_т_мера смещение, targ_т_мера val)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_reftocodeseg(seg, смещение, val)
                :    OmfObj_reftocodeseg(seg, смещение, val);
        }

        цел reftoident(цел seg, targ_т_мера смещение, Symbol *s, targ_т_мера val, цел flags)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_reftoident(seg, смещение, s, val, flags)
                :    OmfObj_reftoident(seg, смещение, s, val, flags);
        }

        проц far16thunk(Symbol *s)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_far16thunk(s)
                :    OmfObj_far16thunk(s);
        }

        проц fltused()
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_fltused()
                :    OmfObj_fltused();
        }

        цел data_readonly(сим *p, цел len, цел *pseg)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_data_readonly(p, len, pseg)
                :    OmfObj_data_readonly(p, len, pseg);
        }

        цел data_readonly(сим *p, цел len)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_data_readonly(p, len)
                :    OmfObj_data_readonly(p, len);
        }

        цел string_literal_segment(бцел sz)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_string_literal_segment(sz)
                :    OmfObj_string_literal_segment(sz);
        }

        Symbol *sym_cdata(tym_t ty, сим *p, цел len)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_sym_cdata(ty, p, len)
                :    OmfObj_sym_cdata(ty, p, len);
        }

        проц func_start(Symbol *sfunc)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_func_start(sfunc)
                :    OmfObj_func_start(sfunc);
        }

        проц func_term(Symbol *sfunc)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_func_term(sfunc)
                :    OmfObj_func_term(sfunc);
        }

        проц write_pointerRef(Symbol* s, бцел off)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_write_pointerRef(s, off)
                :    OmfObj_write_pointerRef(s, off);
        }

        цел jmpTableSegment(Symbol* s)
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_jmpTableSegment(s)
                :    OmfObj_jmpTableSegment(s);
        }

        Symbol *tlv_bootstrap()
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_tlv_bootstrap()
                :    OmfObj_tlv_bootstrap();
        }

        проц gotref(Symbol *s)
        {
        }

        цел seg_debugT()           // where the symbolic debug тип данные goes
        {
            return config.objfmt == OBJ_MSCOFF
                ? MsCoffObj_seg_debugT()
                :    OmfObj_seg_debugT();
        }

        /*******************************************/

        цел  getsegment(ткст0 sectname, бцел flags)
        {
            assert(config.objfmt == OBJ_MSCOFF);
            return MsCoffObj_getsegment(sectname, flags);
        }

        цел  getsegment2(бцел shtidx)
        {
            assert(config.objfmt == OBJ_MSCOFF);
            return MsCoffObj_getsegment2(shtidx);
        }

        бцел addScnhdr(ткст0 scnhdr_name, бцел flags)
        {
            assert(config.objfmt == OBJ_MSCOFF);
            return MsCoffObj_addScnhdr(scnhdr_name, flags);
        }

        проц addrel(цел seg, targ_т_мера смещение, Symbol *targsym,
                              бцел targseg, цел rtype, цел val)
        {
            assert(config.objfmt == OBJ_MSCOFF);
            return MsCoffObj_addrel(seg, смещение, targsym, targseg, rtype, val);
        }

        цел  seg_drectve()
        {
            assert(config.objfmt == OBJ_MSCOFF);
            return MsCoffObj_seg_drectve();
        }

        цел  seg_pdata()
        {
            assert(config.objfmt == OBJ_MSCOFF);
            return MsCoffObj_seg_pdata();
        }

        цел  seg_xdata()
        {
            assert(config.objfmt == OBJ_MSCOFF);
            return MsCoffObj_seg_xdata();
        }

        цел  seg_pdata_comdat(Symbol *sfunc)
        {
            assert(config.objfmt == OBJ_MSCOFF);
            return MsCoffObj_seg_pdata_comdat(sfunc);
        }

        цел  seg_xdata_comdat(Symbol *sfunc)
        {
            assert(config.objfmt == OBJ_MSCOFF);
            return MsCoffObj_seg_xdata_comdat(sfunc);
        }

        цел  seg_debugS()
        {
            assert(config.objfmt == OBJ_MSCOFF);
            return MsCoffObj_seg_debugS();
        }

        цел  seg_debugS_comdat(Symbol *sfunc)
        {
            assert(config.objfmt == OBJ_MSCOFF);
            return MsCoffObj_seg_debugS_comdat(sfunc);
        }
      }
    }
}
else version (Posix)
{
    class Obj
    {
      static:
      
        Obj init(Outbuffer* objbuf, ткст0 имяф, ткст0 csegname)
        {
            return Obj_init(objbuf, имяф, csegname);
        }

        проц initfile(ткст0 имяф, ткст0 csegname, ткст0 modname)
        {
            return Obj_initfile(имяф, csegname, modname);
        }

        проц termfile()
        {
            return Obj_termfile();
        }

        проц term(ткст0 objfilename)
        {
            return Obj_term(objfilename);
        }

        /+т_мера mangle(Symbol *s,сим *dest)
        {
            return Obj_mangle(s, dest);
        }+/

        /+проц _import(elem *e)
        {
            return Obj_import(e);
        }+/

        проц номстр(Srcpos srcpos, цел seg, targ_т_мера смещение)
        {
            return Obj_linnum(srcpos, seg, смещение);
        }

        цел codeseg( сим *имя,цел suffix)
        {
            return Obj_codeseg(имя, suffix);
        }

        /+проц dosseg()
        {
            return Obj_dosseg();
        }+/

        проц startaddress(Symbol *s)
        {
            return Obj_startaddress(s);
        }

        бул includelib(ткст0 имя)
        {
            return Obj_includelib(имя);
        }

        бул linkerdirective(ткст0 p)
        {
            return Obj_linkerdirective(p);
        }

        бул allowZeroSize()
        {
            return Obj_allowZeroSize();
        }

        проц exestr(ткст0 p)
        {
            return Obj_exestr(p);
        }

        проц user(ткст0 p)
        {
            return Obj_user(p);
        }

        проц compiler()
        {
            return Obj_compiler();
        }

        проц wkext(Symbol* s1, Symbol* s2)
        {
            return Obj_wkext(s1, s2);
        }

        /+проц lzext(Symbol* s1, Symbol* s2)
        {
            return Obj_lzext(s1, s2);
        }+/

        проц _alias(ткст0 n1,ткст0 n2)
        {
            return Obj_alias(n1, n2);
        }

        /+проц theadr(ткст0 modname)
        {
            return Obj_theadr(modname);
        }+/

        /+проц segment_group(targ_т_мера codesize, targ_т_мера datasize, targ_т_мера cdatasize, targ_т_мера udatasize)
        {
            return Obj_segment_group(codesize, datasize, cdatasize, udatasize);
        }+/

        проц staticctor(Symbol *s,цел dtor,цел seg)
        {
            return Obj_staticctor(s, dtor, seg);
        }

        проц staticdtor(Symbol *s)
        {
            return Obj_staticdtor(s);
        }

        проц setModuleCtorDtor(Symbol *s, бул isCtor)
        {
            return Obj_setModuleCtorDtor(s, isCtor);
        }

        проц ehtables(Symbol *sfunc,бцел size,Symbol *ehsym)
        {
            return Obj_ehtables(sfunc, size, ehsym);
        }

        проц ehsections()
        {
            return Obj_ehsections();
        }

        проц moduleinfo(Symbol *scc)
        {
            return Obj_moduleinfo(scc);
        }

        цел comdat(Symbol *s)
        {
            return Obj_comdat(s);
        }

        цел comdatsize(Symbol *s, targ_т_мера symsize)
        {
            return Obj_comdatsize(s, symsize);
        }

        цел readonly_comdat(Symbol *s)
        {
            return Obj_comdat(s);
        }

        проц setcodeseg(цел seg)
        {
            return Obj_setcodeseg(seg);
        }

        seg_data *tlsseg()
        {
            return Obj_tlsseg();
        }

        seg_data *tlsseg_bss()
        {
            return Obj_tlsseg_bss();
        }

        seg_data *tlsseg_data()
        {
            return Obj_tlsseg_data();
        }

        /+цел fardata(сим *имя, targ_т_мера size, targ_т_мера *poffset)
        {
            return Obj_fardata(имя, size, poffset);
        }+/

        проц export_symbol(Symbol *s, бцел argsize)
        {
            return Obj_export_symbol(s, argsize);
        }

        проц pubdef(цел seg, Symbol *s, targ_т_мера смещение)
        {
            return Obj_pubdef(seg, s, смещение);
        }

        проц pubdefsize(цел seg, Symbol *s, targ_т_мера смещение, targ_т_мера symsize)
        {
            return Obj_pubdefsize(seg, s, смещение, symsize);
        }

        цел external_def(ткст0 имя)
        {
            return Obj_external_def(имя);
        }

        цел data_start(Symbol *sdata, targ_т_мера datasize, цел seg)
        {
            return Obj_data_start(sdata, datasize, seg);
        }

        цел external(Symbol *s)
        {
            return Obj_external(s);
        }

        цел common_block(Symbol *s, targ_т_мера size, targ_т_мера count)
        {
            return Obj_common_block(s, size, count);
        }

        цел common_block(Symbol *s, цел флаг, targ_т_мера size, targ_т_мера count)
        {
            return Obj_common_block(s, флаг, size, count);
        }

        проц lidata(цел seg, targ_т_мера смещение, targ_т_мера count)
        {
            return Obj_lidata(seg, смещение, count);
        }

        проц write_zeros(seg_data *pseg, targ_т_мера count)
        {
            return Obj_write_zeros(pseg, count);
        }

        проц write_byte(seg_data *pseg, бцел _byte)
        {
            return Obj_write_byte(pseg, _byte);
        }

        проц write_bytes(seg_data *pseg, бцел члобайт, проц *p)
        {
            return Obj_write_bytes(pseg, члобайт, p);
        }

        проц _byte(цел seg, targ_т_мера смещение, бцел _byte)
        {
            return Obj_byte(seg, смещение, _byte);
        }

        бцел bytes(цел seg, targ_т_мера смещение, бцел члобайт, проц *p)
        {
            return Obj_bytes(seg, смещение, члобайт, p);
        }

        /+проц ledata(цел seg, targ_т_мера смещение, targ_т_мера данные, бцел lcfd, бцел idx1, бцел idx2)
        {
            return Obj_ledata(seg, смещение, данные, lcfd, idx1, idx2);
        }+/

        /+проц write_long(цел seg, targ_т_мера смещение, бцел данные, бцел lcfd, бцел idx1, бцел idx2)
        {
            return Obj_write_long(seg, смещение, данные, lcfd, idx1, idx2);
        }+/

        проц reftodatseg(цел seg, targ_т_мера смещение, targ_т_мера val, бцел targetdatum, цел flags)
        {
            return Obj_reftodatseg(seg, смещение, val, targetdatum, flags);
        }

        /+проц reftofarseg(цел seg, targ_т_мера смещение, targ_т_мера val, цел farseg, цел flags)
        {
            return Obj_reftofarseg(seg, смещение, val, farseg, flags);
        }+/

        проц reftocodeseg(цел seg, targ_т_мера смещение, targ_т_мера val)
        {
            return Obj_reftocodeseg(seg, смещение, val);
        }

        цел reftoident(цел seg, targ_т_мера смещение, Symbol *s, targ_т_мера val, цел flags)
        {
            return Obj_reftoident(seg, смещение, s, val, flags);
        }

        проц far16thunk(Symbol *s)
        {
            return Obj_far16thunk(s);
        }

        проц fltused()
        {
            return Obj_fltused();
        }

        цел data_readonly(сим *p, цел len, цел *pseg)
        {
            return Obj_data_readonly(p, len, pseg);
        }

        цел data_readonly(сим *p, цел len)
        {
            return Obj_data_readonly(p, len);
        }

        цел string_literal_segment(бцел sz)
        {
            return Obj_string_literal_segment(sz);
        }

        Symbol *sym_cdata(tym_t ty, сим *p, цел len)
        {
            return Obj_sym_cdata(ty, p, len);
        }

        проц func_start(Symbol *sfunc)
        {
            return Obj_func_start(sfunc);
        }

        проц func_term(Symbol *sfunc)
        {
            return Obj_func_term(sfunc);
        }

        проц write_pointerRef(Symbol* s, бцел off)
        {
            return Obj_write_pointerRef(s, off);
        }

        цел jmpTableSegment(Symbol* s)
        {
            return Obj_jmpTableSegment(s);
        }

        Symbol *tlv_bootstrap()
        {
            return Obj_tlv_bootstrap();
        }

        проц gotref(Symbol *s)
        {
            return Obj_gotref(s);
        }

        бцел addstr(Outbuffer *strtab, ткст0 p)
        {
            return Obj_addstr(strtab, p);
        }

        Symbol *getGOTsym()
        {
            return Obj_getGOTsym();
        }

        проц refGOTsym()
        {
            return Obj_refGOTsym();
        }


        version (OSX)
        {
            цел getsegment(ткст0 sectname, ткст0 segname,
                                  цел align_, цел flags)
            {
                return Obj_getsegment(sectname, segname, align_, flags);
            }

            проц addrel(цел seg, targ_т_мера смещение, Symbol *targsym,
                               бцел targseg, цел rtype, цел val = 0)
            {
                return Obj_addrel(seg, смещение, targsym, targseg, rtype, val);
            }

        }
        else
        {
            цел getsegment(ткст0 имя, ткст0 suffix,
                                  цел тип, цел flags, цел  align_)
            {
                return Obj_getsegment(имя, suffix, тип, flags, align_);
            }

            проц addrel(цел seg, targ_т_мера смещение, бцел тип,
                               бцел symidx, targ_т_мера val)
            {
                return Obj_addrel(seg, смещение, тип, symidx, val);
            }

            т_мера writerel(цел targseg, т_мера смещение, бцел тип,
                                   бцел symidx, targ_т_мера val)
            {
                return Obj_writerel(targseg, смещение, тип, symidx, val);
            }

        }
    }
}
else version (STUB)
{
    public import stubobj;
}
else
    static assert(0, "unsupported version");


extern  Obj objmod;

