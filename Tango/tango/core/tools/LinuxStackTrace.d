﻿/**
 *   Linux Stacktracing
 *
 *   Functions в_ разбор the ELF форматируй and создай a symbolic след
 *
 *   The core Elf handling was taken из_ Thomas Kühne flectioned,
 *   with some minor pieces taken из_ winterwar/wm4
 *   But the routines and flow have been (sometime heavily) изменён
 *
 *  Copyright: 2009 Fawzi, Thomas Kühne, wm4
 *  License:   drTango license
 *  Authors:   Fawzi Mohamed
 */
module core.tools.LinuxStackTrace;

version(linux){
    import rt.core.stdc.stdlib;
    import rt.core.stdc.stdio : FILE, fopen, fread, fseek, fclose, SEEK_SET, fgets, sscanf;
    import cidrus : strcmp, strlen,memcmp;
    import stringz : изТкст0;
    import rt.core.stdc.signal;
    import cidrus: errno, EFAULT;
    import rt.core.stdc.posix.unistd: access;
    import text.Util : delimit;
    import core.Array : найди, найдрек;
    import runtime;

    class SymbolException:Исключение {
        this(ткстсооб,ткстфайл,дол lineNr,Исключение следщ=пусто){
            super(сооб,файл,lineNr,следщ);
        }
    }
    бул may_read(т_мера адр){
        setErrno(0);
        access(cast(сим*)адр, 0);
        return дайНомОш() != EFAULT;
    }

    private extern(C){
        alias бкрат Elf32_Half;
        alias бкрат Elf64_Half;
        alias бцел Elf32_Word;
        alias цел Elf32_Sword;
        alias бцел Elf64_Word;
        alias цел Elf64_Sword;
        alias бдол Elf32_Xword;
        alias дол Elf32_Sxword;
        alias бдол Elf64_Xword;
        alias дол Elf64_Sxword;
        alias бцел Elf32_Addr;
        alias бдол Elf64_Addr;
        alias бцел Elf32_Off;
        alias бдол Elf64_Off;
        alias бкрат Elf32_Section;
        alias бкрат Elf64_Section;
        alias Elf32_Half Elf32_Versym;
        alias Elf64_Half Elf64_Versym;

        struct Elf32_Sym{
            Elf32_Word  st_name;
            Elf32_Addr  st_value;
            Elf32_Word  st_size;
            ббайт st_info;
            ббайт st_other;
            Elf32_Section   st_shndx;
        }

        struct Elf64_Sym{
            Elf64_Word  st_name;
            ббайт       st_info;
            ббайт       st_other;
            Elf64_Section   st_shndx;
            Elf64_Addr  st_value;
            Elf64_Xword st_size;
        }

        struct Elf32_Phdr{
            Elf32_Word  p_type;
            Elf32_Off   p_offset;
            Elf32_Addr  p_vAddr;
            Elf32_Addr  p_pAddr;
            Elf32_Word  p_filesz;
            Elf32_Word  p_memsz;
            Elf32_Word  p_flags;
            Elf32_Word  p_align;
        }

        struct Elf64_Phdr{
            Elf64_Word  p_type;
            Elf64_Word  p_flags;
            Elf64_Off   p_offset;
            Elf64_Addr  p_vAddr;
            Elf64_Addr  p_pAddr;
            Elf64_Xword p_filesz;
            Elf64_Xword p_memsz;
            Elf64_Xword p_align;
        }

        struct Elf32_Dyn{
            Elf32_Sword d_tag;
            union{
                Elf32_Word d_val;
                Elf32_Addr d_ptr;
            }
        }

        struct Elf64_Dyn{
            Elf64_Sxword    d_tag;
            union{
                Elf64_Xword d_val;
                Elf64_Addr d_ptr;
            }
        }
        enum { EI_NIDENT = 16 }

        struct Elf32_Ehdr{
            сим        e_опрent[EI_NIDENT]; /* Magic число and другой инфо */
            Elf32_Half  e_type;         /* Объект файл тип */
            Elf32_Half  e_machine;      /* Architecture */
            Elf32_Word  e_version;      /* Объект файл version */
            Elf32_Addr  e_entry;        /* Запись point virtual адрес */
            Elf32_Off   e_phoff;        /* Program заголовок table файл смещение */
            Elf32_Off   e_shoff;        /* Section заголовок table файл смещение */
            Elf32_Word  e_flags;        /* Processor-specific флаги */
            Elf32_Half  e_ehsize;       /* ELF заголовок размер in байты */
            Elf32_Half  e_phentsize;        /* Program заголовок table Запись размер */
            Elf32_Half  e_phnum;        /* Program заголовок table Запись счёт */
            Elf32_Half  e_shentsize;        /* Section заголовок table Запись размер */
            Elf32_Half  e_shnum;        /* Section заголовок table Запись счёт */
            Elf32_Half  e_shstrndx;     /* Section заголовок ткст table индекс */
        }

        struct Elf64_Ehdr{
            сим        e_опрent[EI_NIDENT]; /* Magic число and другой инфо */
            Elf64_Half  e_type;         /* Объект файл тип */
            Elf64_Half  e_machine;      /* Architecture */
            Elf64_Word  e_version;      /* Объект файл version */
            Elf64_Addr  e_entry;        /* Запись point virtual адрес */
            Elf64_Off   e_phoff;        /* Program заголовок table файл смещение */
            Elf64_Off   e_shoff;        /* Section заголовок table файл смещение */
            Elf64_Word  e_flags;        /* Processor-specific флаги */
            Elf64_Half  e_ehsize;       /* ELF заголовок размер in байты */
            Elf64_Half  e_phentsize;        /* Program заголовок table Запись размер */
            Elf64_Half  e_phnum;        /* Program заголовок table Запись счёт */
            Elf64_Half  e_shentsize;        /* Section заголовок table Запись размер */
            Elf64_Half  e_shnum;        /* Section заголовок table Запись счёт */
            Elf64_Half  e_shstrndx;     /* Section заголовок ткст table индекс */
        }

        struct Elf32_Shdr{
            Elf32_Word  sимя;        /* Section имя (ткст tbl индекс) */
            Elf32_Word  sh_type;        /* Section тип */
            Elf32_Word  sh_flags;       /* Section флаги */
            Elf32_Addr  sадр;        /* Section virtual адр at execution */
            Elf32_Off   sh_offset;      /* Section файл смещение */
            Elf32_Word  sh_size;        /* Section размер in байты */
            Elf32_Word  sh_link;        /* Link в_ другой section */
            Elf32_Word  sh_info;        /* добавьitional section information */
            Elf32_Word  sадрalign;       /* Section alignment */
            Elf32_Word  sh_entsize;     /* Запись размер if section holds table */
        }

        struct Elf64_Shdr{
            Elf64_Word  sимя;        /* Section имя (ткст tbl индекс) */
            Elf64_Word  sh_type;        /* Section тип */
            Elf64_Xword sh_flags;       /* Section флаги */
            Elf64_Addr  sадр;        /* Section virtual адр at execution */
            Elf64_Off   sh_offset;      /* Section файл смещение */
            Elf64_Xword sh_size;        /* Section размер in байты */
            Elf64_Word  sh_link;        /* Link в_ другой section */
            Elf64_Word  sh_info;        /* добавьitional section information */
            Elf64_Xword sадрalign;       /* Section alignment */
            Elf64_Xword sh_entsize;     /* Запись размер if section holds table */
        }

        enum{
            PT_DYNAMIC  = 2,
            DT_STRTAB   = 5,
            DT_SYMTAB   = 6,
            DT_STRSZ    = 10,
            DT_DEBUG    = 21,
            SHT_SYMTAB  = 2,
            SHT_STRTAB  = 3,
            STB_LOCAL   = 0,
        }
        
    }

    ббайт ELF32_ST_BIND(бдол инфо){
        return  cast(ббайт)((инфо & 0xF0) >> 4);
    }

    static if(4 == (проц*).sizeof){
        alias Elf32_Sym Elf_Sym;
        alias Elf32_Dyn Elf_Dyn;
        alias Elf32_Addr Elf_Addr;
        alias Elf32_Phdr Elf_Phdr;
        alias Elf32_Half Elf_Half;
        alias Elf32_Ehdr Elf_Ehdr;
        alias Elf32_Shdr Elf_Shdr;
    }else static if(8 == (проц*).sizeof){
        alias Elf64_Sym Elf_Sym;
        alias Elf64_Dyn Elf_Dyn;
        alias Elf64_Addr Elf_Addr;
        alias Elf64_Phdr Elf_Phdr;
        alias Elf64_Half Elf_Half;
        alias Elf64_Ehdr Elf_Ehdr;
        alias Elf64_Shdr Elf_Shdr;
    }else{
        static assert(0);
    }

    struct StaticSectionInfo{
        Elf_Ehdr заголовок;
        ткст stringTable;
        Elf_Sym[] sym;
        ббайт[] debugLine;   //contents of the .debug_line section, if available
        ткст имяф;
        ук  mmapBase;
        т_мера mmapLen;
        /// initalizer
        static StaticSectionInfo opCall(Elf_Ehdr заголовок, ткст stringTable, Elf_Sym[] sym,
            ббайт[] debugLine, ткст имяф, ук  mmapBase=пусто, т_мера mmapLen=0) {
            StaticSectionInfo newV;
            newV.заголовок=заголовок;
            newV.stringTable=stringTable;
            newV.sym=sym;
            newV.debugLine = debugLine;
            newV.имяф=имяф;
            newV.mmapBase=mmapBase;
            newV.mmapLen=mmapLen;
            return newV;
        }
        
        // stores the global sections
        const MAX_SECTS=5;
        static StaticSectionInfo[MAX_SECTS] _gSections;
        static т_мера _nGSections,_nFileBuf;
        static сим[MAX_SECTS*256] _fileNameBuf;
        
        /// loops on the global sections
        static цел opApply(цел delegate(ref StaticSectionInfo) loop){
            for (т_мера i=0;i<_nGSections;++i){
                auto рез=loop(_gSections[i]);
                if (рез) return рез;
            }
            return 0;
        }
        /// loops on the static symbols
        static цел opApply(цел delegate(ref ткстsNameP,ref т_мера startAddr,
            ref т_мера endAddr, ref бул pub) loop){
            for (т_мера isect=0;isect<_nGSections;++isect){
                StaticSectionInfo *sec=&(_gSections[isect]);
                for (т_мера isym=0;isym<sec.sym.length;++isym) {
                    auto symb=sec.sym[isym];
                    if(!symb.st_name || !symb.st_value){
                        // anonymous || undefined
                        continue;
                    }

                    бул isPublic = да;
                    if(STB_LOCAL == ELF32_ST_BIND(symb.st_info)){
                        isPublic = нет;
                    }
                    сим *sName;
                    if (symb.st_name<sec.stringTable.length) {
                        sName=&(sec.stringTable[symb.st_name]);
                    } else {
                        debug(elf) printf("symbol имя out of bounds %p\n",symb.st_value);
                    }
                    ткст symbName=sName[0..(sName?strlen(sName):0)];
                    т_мера endAddr=symb.st_value+symb.st_size;
                    auto рез=loop(symbName,symb.st_value,endAddr,isPublic);
                    if (рез) return рез;
                }
            }
            return 0;
        }
        /// returns a new section в_ заполни out
        static StaticSectionInfo *добавьGSection(Elf_Ehdr заголовок,ткст stringTable, Elf_Sym[] sym,
            ббайт[] debugLine, ткст имяф,проц *mmapBase=пусто, т_мера mmapLen=0){
            if (_nGSections>=MAX_SECTS){
                throw new Исключение("too many static sections",__FILE__,__LINE__);
            }
            auto длин=имяф.length;
            ткст newFileName;
            if (_fileNameBuf.length< _nFileBuf+длин) {
                newFileName=имяф[0..длин].dup;
            } else {
                _fileNameBuf[_nFileBuf.._nFileBuf+длин]=имяф[0..длин];
                newFileName=_fileNameBuf[_nFileBuf.._nFileBuf+длин];
                _nFileBuf+=длин;
            }
            _gSections[_nGSections]=StaticSectionInfo(заголовок,stringTable,sym,debugLine,newFileName,
                                                      mmapBase,mmapLen);
            _nGSections++;
            return &(_gSections[_nGSections-1]);
        }

        static проц resolveLineNumber(ref Исключение.ИнфОКадре инфо) {
            foreach (ref section; _gSections[0.._nGSections]) {
                //dwarf stores the дир component of filenames separately
                //dmd doesn't care, and дир components are in the имяф
                //linked in gcc produced файлы still use them
                ткст Пап;
                //assumption: if точныйАдрес=нет, it's a return адрес
                if (find_line_number(section.debugLine, инфо.адрес, !инфо.точныйАдрес, Пап, инфо.файл, инфо.строка))
                    break;
            }
        }
    }

    private проц scan_static(сим *файл){
        // should try в_ use mmap,for this резон the "original" форматируй is kept
        // if copying (as сейчас) one could discard the unused strings, and pack the symbols in
        // a platform independent форматируй, but the mmap approach is probably better
        /+auto fdesc=открой(файл,O_RDONLY);
        ptr_diff_t some_offset=0;
        т_мера длин=lseek(fdesc,0,SEEK_END);
        lseek(fdesc,0,SEEK_SET);
        адрес = mmap(0, длин, PROT_READ, MAP_PRIVATE, fdesc, some_offset);+/
        FILE * fd=fopen(файл,"r");
        бул first_symbol = да;
        Elf_Ehdr заголовок;
        Elf_Shdr section;
        Elf_Sym sym;

        проц читай(ук  ptr, т_мера размер){
            auto readB=fread(ptr, 1, размер,fd);
            if(readB != размер){
                throw new SymbolException("читай failure in файл "~файл[0..strlen(файл)],__FILE__,__LINE__);
            }
        }

        проц сместись(т_дельтаук смещение){
            if(fseek(fd, смещение, SEEK_SET) == -1){
                throw new SymbolException("сместись failure",__FILE__,__LINE__);
            }
        }

        /* читай elf заголовок */
        читай(&заголовок, заголовок.sizeof);
        if(заголовок.e_shoff == 0){
            return;
        }
        const бул useShAddr=нет;
        ткст sectionStrs;
        for(т_дельтаук i = заголовок.e_shnum - 1; i > -1; i--){
            сместись(заголовок.e_shoff + i * заголовок.e_shentsize);
            читай(&section, section.sizeof);
            debug(Неук) printf("[%i] %i\n", i, section.sh_type);

            if (section.sh_type == SHT_STRTAB) {
                /* читай ткст table */
                debug(elf) printf("looking for .shstrtab, [%i] is STRING (размер:%i)\n", i, section.sh_size);
                сместись(section.sh_offset);
                if (section.sимя<section.sh_size) {
                    if (useShAddr && section.sадр) {
                        if (!may_read(cast(т_мера)section.sадр)){
                            stdrus.дош("section '");
                            stdrus.дош(i);
                            stdrus.дош("' есть не_годится адрес, relocated?\n");
                        } else {
                            sectionStrs=(cast(сим*)section.sадр)[0..section.sh_size];
                        }
                    }
                    sectionStrs.length = section.sh_size;
                    читай(sectionStrs.ptr, sectionStrs.length);
                    сим* p=&(sectionStrs[section.sимя]);
                    if (strcmp(p,".shstrtab")==0) break;
                }
            }
        }
        if (sectionStrs) {
            сим* p=&(sectionStrs[section.sимя]);
            if (strcmp(p,".shstrtab")!=0) {
                sectionStrs="\0";
            } else {
                debug(elf) printf("найдено .shstrtab\n");
            }
        } else {
            sectionStrs="\0";
        }

  
        /* найди sections */
        ткст string_table;
        Elf_Sym[] symbs;
        ббайт[] debug_line;
        for(т_дельтаук i = заголовок.e_shnum - 1; i > -1; i--){
            сместись(заголовок.e_shoff + i * заголовок.e_shentsize);
            читай(&section, section.sizeof);
            debug(Неук) printf("[%i] %i\n", i, section.sh_type);

            if (section.sимя>=sectionStrs.length) {
                stdrus.дош("could not найди имя for ELF section at ");
                stdrus.дош(section.sимя);
                stdrus.дош("\n");
                continue;
            }
            debug(elf) printf("Elf section %s\n",sectionStrs.ptr+section.sимя);
            if (section.sh_type == SHT_STRTAB && !string_table) {
                /* читай ткст table */
                debug(elf) printf("[%i] is STRING (размер:%i)\n", i, section.sh_size);
                if  (strcmp(sectionStrs.ptr+section.sимя,".strtab")==0){
                    сместись(section.sh_offset);
                    if (useShAddr && section.sадр){
                        if (!may_read(cast(т_мера)section.sадр)){
                            stdrus.дош("section '");
                            stdrus.дош(изТкст0(&(sectionStrs[section.sимя])));
                            stdrus.дош("' есть не_годится адрес, relocated?\n");
                        } else {
                            string_table=(cast(сим*)section.sадр)[0..section.sh_size];
                        }
                    } else {
                        string_table.length = section.sh_size;
                        читай(string_table.ptr, string_table.length);
                    }
                }
            } else if(section.sh_type == SHT_SYMTAB) {
                /* читай symtab */
                debug(elf) printf("[%i] is SYMTAB (размер:%i)\n", i, section.sh_size);
                if (strcmp(sectionStrs.ptr+section.sимя,".symtab")==0 && !symbs) {
                    if (useShAddr && section.sадр){
                        if (!may_read(cast(т_мера)section.sадр)){
                            stdrus.дош("section '");
                            stdrus.дош(изТкст0(&(sectionStrs[section.sимя])));
                            stdrus.дош("' есть не_годится адрес, relocated?\n");
                        } else {
                            symbs=(cast(Elf_Sym*)section.sадр)[0..section.sh_size/Elf_Sym.sizeof];
                        }
                    } else {
                        if(section.sh_offset == 0){
                            continue;
                        }
                        auto p=malloc(section.sh_size);
                        if (p is пусто)
                            throw new Исключение("неудачно alloc",__FILE__,__LINE__);
                        symbs=(cast(Elf_Sym*)p)[0..section.sh_size/Elf_Sym.sizeof];
                        сместись(section.sh_offset);
                        читай(symbs.ptr,symbs.length*Elf_Sym.sizeof);
                    }
                }
            } else if (strcmp(sectionStrs.ptr+section.sимя,".debug_line")==0 && !debug_line) {
                сместись(section.sh_offset);
                if (useShAddr && section.sадр){
                    if (!may_read(cast(т_мера)section.sадр)){
                        stdrus.дош("section '");
                        stdrus.дош(изТкст0(&(sectionStrs[section.sимя])));
                        stdrus.дош("' есть не_годится адрес, relocated?\n");
                    } else {
                        debug_line=(cast(ббайт*)section.sадр)[0..section.sh_size];
                    }
                } else {
                    auto p=malloc(section.sh_size);
                    if (p is пусто)
                        throw new Исключение("неудачно alloc",__FILE__,__LINE__);
                    debug_line=(cast(ббайт*)p)[0..section.sh_size];
                    сместись(section.sh_offset);
                    читай(debug_line.ptr,debug_line.length);
                }
            }
        }

        if (string_table.ptr && symbs.ptr) {
            StaticSectionInfo.добавьGSection(заголовок,string_table,symbs,debug_line,файл[0..strlen(файл)]);
            string_table=пусто;
            symbs=пусто;
            debug_line=пусто;
        }
    }

    private проц find_symbols(){
        // static symbols
        find_static();
        // dynamic symbols handled with dlAddr
    }

    private проц find_static(){
        FILE* maps;
        сим[4096] буфер;

        maps = fopen("/proc/сам/maps", "r");
        if(maps is пусто){
            debug{
                throw new SymbolException("couldn't читай '/proc/сам/maps'",__FILE__,__LINE__);
            }else{
                return;
            }
        }
        scope(exit) fclose(maps);

        буфер[] = 0;
        while(fgets(буфер.ptr, буфер.length - 1, maps)){
            scope(exit){
                буфер[] = 0;
            }
            ткст врем;
            cleanEnd: for(т_мера i = буфер.length - 1; i >= 0; i--){
                switch(буфер[i]){
                    case 0, '\r', '\n':
                        буфер[i] = 0;
                        break;
                    default:
                        врем = буфер[0 .. i+1];
                        break cleanEnd;
                }
            }

Lsplit:
            static if(is(typeof(разбей(""c)) == ткст[])){
                ткст[] tok = разбей(врем);
                if(tok.length != 6){
                    // no источник файл
                    continue;
                }
            }else{
                ткст[] tok = delimit(врем, " \t");
                if(tok.length < 6){
                    // no источник файл
                    continue;
                }
                const tok_len = 33;
            }
            if(найди(tok[$-1], "[") == 0){
                // pseudo источник
                continue;
            }
            if(найдрек(tok[$-1], ".so") == tok[$-1].length - 3){
                // dynamic lib
                continue;
            }
            if(найдрек(tok[$-1], ".so.") != tok[$-1].length ){
                // dynamic lib
                continue;
            }
            if(найди(tok[1], "r") == -1){
                // no читай
                continue;
            }
            if(найди(tok[1], "x") == -1){
                // no выполни
                continue;
            }
            ткст адр = tok[0] ~ "\u0000";
            ткст источник = tok[$-1] ~ "\u0000";
            const ткст marker = "\x7FELF"c;

            ук  старт, конец;
            if(2 != sscanf(адр.ptr, "%zX-%zX", &старт, &конец)){
                continue;
            }
            if(cast(т_мера)конец - cast(т_мера)старт < 4){
                continue;
            }
            if(!may_read(cast(т_мера)старт)){
                stdrus.дош("got не_годится старт ptr из_ '");
                stdrus.дош(изТкст0(источник.ptr));
                stdrus.дош("'\n");
                stdrus.дош("ignoring ошибка in ");
                stdrus.дош(__FILE__);
                stdrus.дош(":");
                stdrus.дош(__FILE__);
                stdrus.дош("\n");
                return;
            }
            if(memcmp(старт, marker.ptr, marker.length) != 0){
                // not an ELF файл
                continue;
            }
            try{
                scan_static(источник.ptr);
                debug(elfTable){
                    printf("XX symbols\n");
                    foreach(sName,startAddr,endAddr,pub;StaticSectionInfo){
                        printf("%p %p %d %*s\n",startAddr,endAddr,pub,sName.length,sName.ptr);
                    }
                    printf("XX symbols конец\n");
                }
            } catch (Исключение e) {
                stdrus.дош("неудачно reading symbols из_ '");
                stdrus.дош(изТкст0(источник.ptr));
                stdrus.дош("'\n");
                stdrus.дош("ignoring ошибка in ");
                stdrus.дош(__FILE__);
                stdrus.дош(":");
                stdrus.дош(__FILE__);
                stdrus.дош("\n");
                e.выведи((ткстs){ stdrus.дош(s); });
                return;
            }
                
        }
    }

    static this() {
        find_symbols();
    }


    private проц dwarf_error(ткст сооб) {
        stdrus.дош("Dinrus stacktracer DWARF ошибка: ");
        stdrus.дош(сооб);
        stdrus.дош("\n");
    }

    alias крат uhalf;

    struct DwarfЧитатель {
        ббайт[] данные;
        т_мера read_pos;
        бул is_dwarf_64;

        т_мера left() {
            return данные.length - read_pos;
        }

        ббайт следщ() {
            ббайт r = данные[read_pos];
            read_pos++;
            return r;
        }

        //читай the length field, and установи the is_dwarf_64 flag accordingly
        //return 0 on ошибка
        т_мера read_initial_length() {
            //64 bit applications normally use 32 bit DWARF information
            //this means on 64 bit, we have в_ укз Всё 32 bit and 64 bit infos
            //the 64 bit version seems в_ be rare, though
            //independent из_ this, 32 bit DWARF still uses some 64 bit типы in
            //64 bit executables (at least the DW_LNE_set_адрес opcode does)
            auto initlen = читай!(бцел)();
            is_dwarf_64 = (initlen == 0xff_ff_ff_ff);
            if (is_dwarf_64) {
                //--can укз this, but need testing (this форматируй seems в_ be uncommon)
                //--удали the following 2 lines в_ see if it works, and fix the код if needed
                dwarf_error("dwarf 64 detected, aborting");
                abort();
                //--
                static if (т_мера.sizeof > 4) {
                    dwarf_error("64 bit DWARF in a 32 bit excecutable?");
                    return 0;
                }
                return читай!(бдол)();
            } else {
                if (initlen >= 0xff_ff_ff_00) {
                    //see dwarf spec 7.5.1
                    dwarf_error("corrupt debugging information?");
                }
                return initlen;
            }
        }

        //adapted из_ example код in dwarf spec. appendix c
        //defined max. размер is 128 bit; we provопрe up в_ 64 bit
        private бдол do_read_leb(бул sign_ext) {
            бдол рез;
            цел shift;
            ббайт b;
            do {
                b = следщ();
                рез = рез | ((b & 0x7f) << shift);
                shift += 7;
            } while (b & 0x80);
            if (sign_ext && shift < бдол.sizeof*8 && (b & 0x40))
                рез = рез - (1L << shift);
            return рез;
        }
        бдол uleb128() {
            return do_read_leb(нет);
        }
        дол sleb128() {
            return do_read_leb(да);
        }

        T читай(T)() {
            T r = *cast(T*)данные[read_pos..read_pos+T.sizeof].ptr;
            read_pos += T.sizeof;
            return r;
        }

        т_мера read_header_length() {
            if (is_dwarf_64) {
                return читай!(бдол)();
            } else {
                return читай!(бцел)();
            }
        }

        //пусто terminated ткст
        ткст ткт() {
            сим* старт = cast(сим*)&данные[read_pos];
            т_мера длин = strlen(старт);
            read_pos += длин + 1;
            return старт[0..длин];
        }
    }

    unittest {
        //examples из_ dwarf spec section 7.6
        ббайт[] байты = [2,127,0x80,1,0x81,1,0x82,1,57+0x80,100,2,0x7e,127+0x80,0,
            0x81,0x7f,0x80,1,0x80,0x7f,0x81,1,0x7f+0x80,0x7e];
        бдол[] u = [2, 127, 128, 129, 130, 12857];
        дол[] s = [2, -2, 127, -127, 128, -128, 129, -129];
        auto rd = DwarfЧитатель(байты);
        foreach (x; u)
            assert(rd.uleb128() == x);
        foreach (x; s)
            assert(rd.sleb128() == x);
    }

    //debug_line = contents of the .debug_line section
    //is_return_адрес = да if адрес is a return адрес (найдено by stacktrace)
    бул find_line_number(ббайт[] debug_line, т_мера адрес, бул is_return_адрес,
        ref ткст out_directory, ref ткст out_file, ref дол out_line)
    {
        DwarfЧитатель rd = DwarfЧитатель(debug_line);


        //NOTE:
        //  - instead of saving the filenames when the debug infos are first разобрано,
        //    we only save a reference в_ the debug infos (with FileRef), and
        //    reparse the debug infos when we need the actual filenames
        //  - the same код is used for skИПping over the debug infos, and for
        //    getting the filenames later
        //  - this is just for avoопрing память allocation

        struct FileRef {
            цел файл;           //файл число
            т_мера directories; //смещение в_ дир инфо
            т_мера filenames;   //смещение в_ имяф инфо
        }

        //include_directories
        проц reparse_dirs(проц delegate(цел инд, ткст d) Запись) {
            цел инд = 1;
            for (;;) {
                auto s = rd.ткт();
                if (!s.length)
                    break;
                if (Запись)
                    Запись(инд, s);
                инд++;
            }
        }
        //file_names
        проц reparse_files(проц delegate(цел инд, цел Пап, ткст фн) Запись) {
            цел инд = 1;
            for (;;) {
                auto s = rd.ткт();
                if (!s.length)
                    break;
                цел Пап = rd.uleb128(); //дир индекс
                rd.uleb128();           //последний modification время (unused)
                rd.uleb128();           //length of файл (unused)
                if (Запись)
                    Запись(инд, Пап, s);
                инд++;
            }
        }

        //associated with the найдено Запись
        FileRef found_file;
        бул найдено = нет;

        //the section is made up of independent blocks of строка число programs
        blocks: while (rd.left > 0) {
            т_мера unit_length = rd.read_initial_length();

            if (unit_length == 0)
                return нет;

            т_мера старт = rd.read_pos;
            т_мера конец = старт + unit_length;

            auto ver = rd.читай!(uhalf)();
            auto header_length = rd.read_header_length();

            т_мера header_start = rd.read_pos;

            auto min_instr_len = rd.читай!(ббайт)();
            auto def_is_stmt = rd.читай!(ббайт)();
            auto line_base = rd.читай!(байт)();
            auto line_range = rd.читай!(ббайт)();
            auto opcode_base = rd.читай!(ббайт)();
            ббайт[256] sol_store; //в_ avoопр куча allocation
            ббайт[] standard_opcode_lengths = sol_store[0..opcode_base-1];
            foreach (ref x; standard_opcode_lengths) {
                x = rd.читай!(ббайт)();
            }

            т_мера dirs_offset = rd.read_pos;
            reparse_dirs(пусто);
            т_мера files_offset = rd.read_pos;
            reparse_files(пусто);

            rd.read_pos = header_start + header_length;

            //состояние machine registers
            struct LineRegs {
                бул valid() { return адрес != 0; }
                цел файл = 1;               //файл индекс
                цел строка = 1;               //строка число
                т_мера адрес = 0;         //абсолютный адрес
                бул end_sequence = нет;  //последний row in a block
            }

            LineRegs regs;      //current row
            LineRegs regs_prev; //row before

            //добавь row в_ virtual строка число table, using current регистрируй contents
            //NOTE: reg_адрес is supposed в_ be increased only (within  a block)
            //      reg_line can be increased or decreased randomly
            проц добавь() {
                if (regs_prev.valid()) {
                    if (is_return_адрес) {
                        if (адрес >= regs_prev.адрес && адрес <= regs.адрес)
                            найдено = да;
                    } else {
                        //some special case *shrug*
                        if (regs_prev.адрес == адрес)
                            найдено = да;
                        //not special case
                        if (адрес >= regs_prev.адрес && адрес < regs.адрес)
                            найдено = да;
                    }

                    if (найдено) {
                        out_line = regs_prev.строка;
                        found_file.файл = regs_prev.файл;
                        found_file.directories = dirs_offset;
                        found_file.filenames = files_offset;
                    }
                }

                regs_prev = regs;
            }

            //actual строка число program
            loop: while (rd.read_pos < конец) {
                ббайт тек = rd.следщ();

                if (найдено)
                    break blocks;

                //"special opcodes"
                if (тек >= opcode_base) {
                    цел adj = тек - opcode_base;
                    дол Addr_inc = (adj / line_range) * min_instr_len;
                    дол line_inc = line_base + (adj % line_range);
                    regs.адрес += Addr_inc;
                    regs.строка += line_inc;
                    добавь();
                    continue loop;
                }

                //стандарт opcodes
                switch (тек) {
                case 1: //DW_LNS_copy
                    добавь();
                    continue loop;
                case 2: //DW_LNS_advance_pc
                    regs.адрес += rd.uleb128() * min_instr_len;
                    continue loop;
                case 3: //DW_LNS_advance_line
                    regs.строка += rd.sleb128();
                    continue loop;
                case 4: //DW_LNS_set_file
                    regs.файл = rd.uleb128();
                    continue loop;
                case 8: //DW_LNS_const_добавь_pc
                    //добавь адрес инкремент according в_ special opcode 255
                    //sorry logic duplicated из_ special opcode handling above
                    regs.адрес += ((255-opcode_base)/line_range)*min_instr_len;
                    continue loop;
                case 9: //DW_LNS_fixed_advance_pc
                    regs.адрес += rd.читай!(uhalf)();
                    continue loop;
                default:
                }

                //"неизвестное"/unhandled стандарт opcode, пропусти
                if (тек != 0) {
                    //пропусти параметры
                    auto счёт = standard_opcode_lengths[тек-1];
                    while (счёт--) {
                        rd.uleb128();
                    }
                    continue loop;
                }

                //extended opcodes
                т_мера instr_len = rd.uleb128(); //length of this instruction
                тек = rd.следщ();
                switch (тек) {
                case 1: //DW_LNE_end_sequence
                    regs.end_sequence = да;
                    добавь();
                    //сбрось
                    regs = LineRegs.init;
                    regs_prev = LineRegs.init;
                    continue loop;
                case 2: //DW_LNE_set_адрес
                    regs.адрес = rd.читай!(т_мера)();
                    continue loop;
                case 3: //DW_LNE_define_file
                    //can't укз this lol
                    //would need в_ добавь the файл в_ the файл table, but в_ avoопр
                    //память allocation, we don't копируй out and сохрани the нормаль файл
                    //table; only a pointer в_ the original dwarf файл записи
                    //solutions:
                    //  - give up and pre-разбор debugging infos on program startup
                    //  - give up and размести куча память (but: signal handlers?)
                    //  - use alloca or a static Массив on the stack
                    dwarf_error("can't укз DW_LNE_define_file yet");
                    return нет;
                default:
                }

                //неизвестное extended opcode, пропусти
                rd.read_pos += instr_len;
                continue loop;
            }

            //ensure correct старт of следщ block (?)
            assert(rd.read_pos == конец);
        }

        if (!найдено)
            return нет;

        //разреши found_file в_ the actual имяф & дир strings
        цел Пап;
        rd.read_pos = found_file.filenames;
        reparse_files((цел инд, цел a_dir, ткст a_file) {
            if (инд == found_file.файл) {
                Пап = a_dir;
                out_file = a_file;
            }
        });
        rd.read_pos = found_file.directories;
        reparse_dirs((цел инд, ткст a_dir) {
            if (инд == Пап) {
                out_directory = a_dir;
            }
        });

        return да;
    }

}

