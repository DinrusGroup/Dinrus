// Написано на языке программирования Динрус. Разработчик Виталий Кулич.
module std.file;
import std.string,std.regexp, std.path, sys.WinStructs,cidrus: getenv;

export extern(D)
{

    проц[] читайФайл(ткст имяф){return read(имяф);}
    проц пишиФайл(ткст имяф, проц[] буф){write(имяф, буф);}
    проц допишиФайл(ткст имяф, проц[] буф){append(имяф, буф);}
    проц переименуйФайл(ткст из, ткст в){rename(из, в);}
    проц удалиФайл(ткст имяф){remove(имяф);}
    бдол дайРазмерФайла(ткст имяф){return getSize(имяф);}
    проц дайВременаФайла(ткст имяф, out т_время фтц, out т_время фта, out т_время фтм){getTimes(имяф, фтц, фта, фтм);}
    бул естьФайл(ткст имяф){return cast(бул) exists(имяф);}
    бцел дайАтрибутыФайла(ткст имяф){return getAttributes(имяф);}
    бул файл_ли(ткст имяф){return cast(бул) isfile(имяф);}
    бул папка_ли(ткст имяп){return cast(бул) isdir(имяп);}
    проц сменипап(ткст имяп){chdir(имяп);}
    проц сделайпап(ткст имяп){mkdir(имяп);}
    проц удалипап(ткст имяп){rmdir(имяп);}
    ткст дайтекпап(){return getcwd();}
    ткст[] списпап(ткст имяп){return listdir(имяп);}
    ткст[] списпап(ткст имяп, ткст образец){return listdir(имяп, образец);}
    проц копируйФайл(ткст из, ткст в){copy(из, в);}
    

        struct Папка
        {
            private
            {
                ткст м_имяп;

            }

        export:

            проц opCall(ткст имяп)
            {
                м_имяп = имяп;
            }

            ткст текущая()
            {
                return м_имяп = дайтекпап();
            }
            alias текущая opCall;

            проц перейди(ткст имяп)
            {
                сменипап(имяп);
                 м_имяп = имяп;
            }

            проц создай(ткст имяп)
            {
                сделайпап(имяп);
                м_имяп = имяп;
            }

            проц удали()
            {
                удалипап(м_имяп);
            }

            ткст[] список()
            {
                return списпап(м_имяп);
            }

            ткст[] список(ткст образец)
            {
                return списпап(м_имяп, образец);
            }

        }




        struct Файл
        {
            private
            {
                 ткст м_имяф = ткст.init;

                 т_время м_времяСоздания,
                            м_времяДоступа,
                                м_времяИзменения;

                проц дайВремена()
                {
                    getTimes(м_имяф, м_времяСоздания, м_времяДоступа, м_времяИзменения);
                    
                }

            }

        export:

            проц opCall(ткст имяф)
            {
                м_имяф = имяф;
            }


            проц[] читай()
            {

             return read(м_имяф);
            }

            ткст имя()
            {
                return м_имяф;
            }

            проц допиши(проц[] буф)
            {

                append(м_имяф, буф);
            }


            проц пиши( проц[] буф)
            {
                write(м_имяф, буф);

            }

            проц переименуй(ткст в)
            {
                rename(м_имяф, в);
            }

            проц удали()
            {
              remove(м_имяф);
            }

            бдол размер()
            {
                    return getSize(м_имяф);
            }


            бул существует()
            {
                return cast(бул) exists(м_имяф);
            }

            бцел атрибуты()
            {
                return getAttributes(м_имяф);
            }

            бул действительноФайл()
            {
                return cast(бул) isfile(м_имяф);
            }

            т_время времяСоздания()
            {
                дайВремена();
                 return м_времяСоздания;
             }

            т_время времяДоступа()
            {
                дайВремена();
                return м_времяДоступа;
            }

            т_время времяИзменения()
            {
                дайВремена();
                return м_времяИзменения;
            }


            проц копируй(ткст в)
            {
                copy(м_имяф, в);
            }



        }


        /** Get an environment variable D-ly */
        ткст дайПеремСреды(ткст пер)
        {
                сим[10240] буфер;
                буфер[0] = '\0';
                GetEnvironmentVariableA(
                        std.string.вТкст0(пер),
                        буфер.ptr,
                        10240);
                return std.string.вТкст(буфер.ptr);

        }

        /** Set an environment variable D-ly */
        проц устПеремСреды(ткст пер, ткст знач)
        {
                SetEnvironmentVariableA(
                    std.string.вТкст0(пер),
                    std.string.вТкст0(знач));

        }

        /** Get the system PATH */
        ткст[] дайПуть()
        {
            return std.regexp.разбей(std.string.вТкст(getenv("PATH")), РАЗДПСТР);
        }

        /** From args[0], figure out our путь.  Returns 'нет' on failure */
        бул гдеЯ(ткст argvz, inout ткст пап, inout ткст bname)
        {
            // split it
            bname = извлекиИмяПути(argvz);
            пап = извлекиПапку(argvz);

            // on Windows, this is a .exe
            version (Windows) {
                bname = устДефРасш(bname, "exe");
            }

            // is this a directory?
            if (пап != "") {
                if (!абсПуть_ли(пап)) {
                    // make it absolute
                    пап = дайтекпап() ~ РАЗДПАП ~ пап;
                }
                return да;
            }

            version (Windows) {
                // is it in cwd?
                char[] cwd = дайтекпап();
                if (естьФайл(cwd ~ РАЗДПАП ~ bname)) {
                    пап = cwd;
                    return да;
                }
            }

            // rifle through the путь
            char[][] путь = дайПуть();
            foreach (pe; путь) {
                char[] fullname = pe ~ РАЗДПАП ~ bname;
                if (естьФайл(fullname)) {
                    version (Windows) {
                        пап = pe;
                        return да;
                    } else {
                        if (дайАтрибутыФайла(fullname) & 0100) {
                            пап = pe;
                            return да;
                        }
                    }
                }
            }

            // bad
            return нет;
        }

        /// Return a canonical pathname
        ткст канонПуть(ткст исхПуть)
        {
            char[] возвр;

            version (Windows) {
                // replace any altsep with sep
                if (АЛЬТРАЗДПАП.length) {
                    возвр = замени(исхПуть, АЛЬТРАЗДПАП, "\\\\");
                } else {
                    возвр = исхПуть.dup;
                }
            } else {
                возвр = исхПуть.dup;
            }

            // expand tildes
            возвр = разверниТильду(возвр);

            // get rid of any duplicate separatoрс
            for (int i = 0; i < возвр.length; i++) {
                if (возвр[i .. (i + 1)] == РАЗДПАП) {
                    // drop the duplicate separator
                    i++;
                    while (i < возвр.length &&
                           возвр[i .. (i + 1)] == РАЗДПАП) {
                        возвр = возвр[0 .. i] ~ возвр[(i + 1) .. $];
                    }
                }
            }

            // make sure we don't miss a .. element
            if (возвр.length > 3 && возвр[($-3) .. $] == РАЗДПАП ~ "..") {
                возвр ~= РАЗДПАП;
            }

            // or a . element
            if (возвр.length > 2 && возвр[($-2) .. $] == РАЗДПАП ~ ".") {
                возвр ~= РАЗДПАП;
            }

            // search for .. elements
            for (int i = 0; возвр.length > 4 && i <= возвр.length - 4; i++) {
                if (возвр[i .. (i + 4)] == РАЗДПАП ~ ".." ~ РАЗДПАП) {
                    // drop the previous путь element
                    int j;
                    for (j = i - 1; j > 0 && возвр[j..(j+1)] != РАЗДПАП; j--) {}
                    if (j > 0) {
                        // cut
                        if (возвр[j..j+2] == "/.") {
                            j = i + 2; // skip it
                        } else {
                            возвр = возвр[0..j] ~ возвр[(i + 3) .. $];
                        }
                    } else {
                        // can't cut
                        j = i + 2;
                    }
                    i = j - 1;
                }
            }

            // search for . elements
            for (int i = 0; возвр.length > 2 && i <= возвр.length - 3; i++) {
                if (возвр[i .. (i + 3)] == РАЗДПАП ~ "." ~ РАЗДПАП) {
                    // drop this путь element
                    возвр = возвр[0..i] ~ возвр[(i + 2) .. $];
                    i--;
                }
            }

            // get rid of any introductory ./'т
            while (возвр.length > 2 && возвр[0..2] == "." ~ РАЗДПАП) {
                возвр = возвр[2..$];
            }

            // finally, get rid of any trailing separatoрс
            while (возвр.length &&
                   возвр[($ - 1) .. $] == РАЗДПАП) {
                возвр = возвр[0 .. ($ - 1)];
            }

            return возвр;
        }

        /** Make a directory and all parent directories */
        проц сделпапР(ткст пап)
        {
            пап = канонПуть(пап);
            version (Windows) {
                пап = std.string.замени(пап, "/", "\\\\");
            }

            // split it into elements
            char[][] элтыпап = std.regexp.разбей(пап, "\\\\");

            char[] текпап;

            // check for root пап
            if (элтыпап.length &&
                элтыпап[0] == "") {
                текпап = РАЗДПАП;
                элтыпап = элтыпап[1..$];
            }

            // then go piece-by-piece, making directories
            foreach (элтпап; элтыпап) {
                if (текпап.length) {
                    текпап ~= РАЗДПАП ~ элтпап;
                } else {
                    текпап ~= элтпап;
                }

                if (!естьФайл(текпап)) {
                    сделайпап(текпап);
                }
            }
        }

        /** Remove a file or directory and all of its children */
        проц удалиРек(ткст имя)
        {
            // can only delete writable files on Windows
            version (Windows) {
                SetFileAttributesA(toStringz(имя),
                                   GetFileAttributesA(toStringz(имя)) &
                                   ~0x00000001);
            }

            if (isdir(имя)) {
                foreach (элем; listdir(имя)) {
                    // don't delete . or ..
                    if (элем == "." ||
                        элем == "..") continue;
                    удалиРек(имя ~ РАЗДПАП ~ элем);
                }

                // remove the directory itself
                rmdir(имя);
            } else {
                remove(имя);
            }
        }


        private{
            бул[ткст] спСущФайлов;
        }

        // --------------------------------------------------
        бул естьФайлВКэш(ткст имяФ)
        {
            if (имяФ in спСущФайлов)
            {
                return да;
            }
            try {
            if(файл_ли(имяФ) && естьФайл(имяФ))
            {
                спСущФайлов[имяФ] = да;
                return да;
            }
            } catch { };
            return нет;
        }

        // --------------------------------------------------
        проц удалиКэшСущФайлов()
        {
            ткст[] спКлюч;

            спКлюч = спСущФайлов.keys.dup;
            foreach(ткст спФайл; спКлюч)
            {
                спСущФайлов.remove(спФайл);
            }
        }

}


//////////////////////////////////////////////////////
private import cidrus, exception:ФайлИскл, СисОш;
private import std.path;
private import std.string;
private import std.regexp;
private import runtime;

/* =========================== Win32 ======================= */

version (Win32)
{

private import sys.WinFuncs;
private import std.utf;
private import rt.syserror;
private import rt.charset;
private import std.date;

alias rt.charset.toMBSz toMBSz;

int useWfuncs = 1;

//extern(C) int      wcscmp(in wchar_t* s1, in wchar_t* s2);
/*
static this()
{
    // Win 95, 98, ME do not implement the W functions
    useWfuncs = (GetVersion() < 0x80000000);
}
*/

/********************************************
 * Read file name[], return array of bytes read.
 * Throws:
 *  ФайлИскл on error.
 */

void[] read(char[] name)
{
    DWORD numread;
    HANDLE h;

    if (useWfuncs)
    {
    wchar* namez = std.utf.toUTF16z(name);
    h = CreateFileW(namez,ППраваДоступа.ГенерноеЧтение,ПФайл.СЧ,null,ПРежСоздФайла.ОткрытьСущ,
        ПФайл.Нормальный | ПФайл.ПоследоватСкан,cast(HANDLE)null);
    }
    else
    {
    char* namez = toMBSz(name);
    h = CreateFileA(namez,ППраваДоступа.ГенерноеЧтение,ПФайл.СЧ,null,ПРежСоздФайла.ОткрытьСущ,
        ПФайл.Нормальный | ПФайл.ПоследоватСкан,cast(HANDLE)null);
    }

    if (h == cast(HANDLE) НЕВЕРНХЭНДЛ)
    goto err1;

    auto size = GetFileSize(h, null);
    if (size == НЕВЕРНРАЗМФАЙЛА)
    goto err2;

    auto buf = runtime.malloc(size);
    if (buf)
    runtime.hasNoPointers(buf.ptr);

    if (ReadFile(h,buf.ptr,size,&numread,null) != 1)
    goto err2;

    if (numread != size)
    goto err2;

    if (!CloseHandle(h))
    goto err;

    return buf[0 .. size];

err2:
    CloseHandle(h);
err:
    delete buf;
err1:
    throw new ФайлИскл(name, GetLastError());
}

/*********************************************
 * Write buffer[] to file name[].
 * Throws: ФайлИскл on error.
 */

void write(char[] name, void[] buffer)
{
    HANDLE h;
    DWORD numwritten;

    if (useWfuncs)
    {
    wchar* namez = std.utf.toUTF16z(name);
    h = CreateFileW(namez,ППраваДоступа.ГенернаяЗапись,0,null,ПРежСоздФайла.СоздатьВсегда,
        ПФайл.Нормальный | ПФайл.ПоследоватСкан,cast(HANDLE)null);
    }
    else
    {
    char* namez = toMBSz(name);
    h = CreateFileA(namez,ППраваДоступа.ГенернаяЗапись,0,null,ПРежСоздФайла.СоздатьВсегда,
        ПФайл.Нормальный | ПФайл.ПоследоватСкан,cast(sys.WinFuncs.HANDLE)null);
    }
    if (h == cast(HANDLE) НЕВЕРНХЭНДЛ)
    goto err;

    if (sys.WinFuncs.WriteFile(h,buffer.ptr,buffer.length,&numwritten,null) != 1)
    goto err2;

    if (buffer.length != numwritten)
    goto err2;

    if (!CloseHandle(h))
    goto err;
    return;

err2:
    CloseHandle(h);
err:
    throw new ФайлИскл(name, GetLastError());
}


/*********************************************
 * Append buffer[] to file name[].
 * Throws: ФайлИскл on error.
 */

void append(char[] name, void[] buffer)
{
    HANDLE h;
    DWORD numwritten;

    if (useWfuncs)
    {
    wchar* namez = std.utf.toUTF16z(name);
    h = CreateFileW(namez,ППраваДоступа.ГенернаяЗапись,0,null,ПРежСоздФайла.ОткрытьВсегда,
        ПФайл.Нормальный | ПФайл.ПоследоватСкан,cast(HANDLE)null);
    }
    else
    {
    char* namez = toMBSz(name);
    h = CreateFileA(namez,ППраваДоступа.ГенернаяЗапись,0,null,ПРежСоздФайла.ОткрытьВсегда,
        ПФайл.Нормальный | ПФайл.ПоследоватСкан,cast(sys.WinFuncs.HANDLE)null);
    }
    if (h == cast(HANDLE) НЕВЕРНХЭНДЛ)
    goto err;

    SetFilePointer(h, 0, null, ПФайл.Кон);

    if (sys.WinFuncs.WriteFile(h,buffer.ptr,buffer.length,&numwritten,null) != 1)
    goto err2;

    if (buffer.length != numwritten)
    goto err2;

    if (!CloseHandle(h))
    goto err;
    return;

err2:
    CloseHandle(h);
err:
    throw new ФайлИскл(name, GetLastError());
}


/***************************************************
 * Rename file from[] to to[].
 * Throws: ФайлИскл on error.
 */

void rename(char[] from, char[] to)
{
    BOOL результат;

    if (useWfuncs)
    результат = MoveFileW(std.utf.toUTF16z(from), std.utf.toUTF16z(to));
    else
    результат = MoveFileA(toMBSz(from), toMBSz(to));
    if (!результат)
    throw new ФайлИскл(to, GetLastError());
}


/***************************************************
 * Delete file name[].
 * Throws: ФайлИскл on error.
 */

void remove(char[] name)
{
    BOOL результат;

    if (useWfuncs)
    результат = УдалиФайл(вЮ16(name));
    else
    результат = УдалиФайлА(name);
    if (!результат)
    throw new ФайлИскл(name, GetLastError());
}


/***************************************************
 * Get size of file name[].
 * Throws: ФайлИскл on error.
 */

ulong getSize(char[] name)
{
    HANDLE findhndl;
    uint resulth;
    uint resultl;

    if (useWfuncs)
    {
    WIN32_FIND_DATAW filefindbuf;

    findhndl = FindFirstFileW(std.utf.toUTF16z(name), &filefindbuf);
    resulth = filefindbuf.nFileSizeHigh;
    resultl = filefindbuf.nFileSizeLow;
    }
    else
    {
    WIN32_FIND_DATA filefindbuf;

    findhndl = FindFirstFileA(toMBSz(name), &filefindbuf);
    resulth = filefindbuf.nFileSizeHigh;
    resultl = filefindbuf.nFileSizeLow;
    }

    if (findhndl == cast(HANDLE)-1)
    {
    throw new ФайлИскл(name, GetLastError());
    }
    FindClose(findhndl);
    return (cast(ulong)resulth << 32) + resultl;
}

/*************************
 * Get creation/access/modified times of file name[].
 * Throws: ФайлИскл on error.
 */

void getTimes(char[] name, out т_время ftc, out т_время fta, out т_время ftm)
{
    HANDLE findhndl;

    ПДАН filefindbuf;
    findhndl = НайдиПервыйФайл(std.utf.toUTF16(name), &filefindbuf);
    ftc = std.date.FILETIME2d_time(&filefindbuf.времяСоздания);
    fta = std.date.FILETIME2d_time(&filefindbuf.времяПоследнегоДоступа);
    ftm = std.date.FILETIME2d_time(&filefindbuf.времяПоследнейЗаписи);
    
    if (findhndl == cast(ук)-1)
    {
    throw new ФайлИскл(name, ДайПоследнююОшибку());
    }
    НайдиЗакрой(findhndl);
}


/***************************************************
 * Does file name[] (or directory) exist?
 * Return 1 if it does, 0 if not.
 */

int exists(char[] name)
{
 uint результат = GetFileAttributesW(std.utf.toUTF16z(name));
    return результат != 0xFFFFFFFF;
}

/***************************************************
 * Get file name[] attributes.
 * Throws: ФайлИскл on error.
 */

uint getAttributes(string name)
{  
    бцел результат = GetFileAttributesW(std.utf.toUTF16z(name));
    if ( результат == 0xFFFFFFFF)
    {
    throw new ФайлИскл(name, GetLastError());
    }
    return результат;
}

/****************************************************
 * Is name[] a file?
 * Throws: ФайлИскл if name[] doesn't exist.
 */

int isfile(char[] name)
{
    return (getAttributes(name) & ПФайл.Папка) == 0;
}

/****************************************************
 * Is name[] a directory?
 * Throws: ФайлИскл if name[] doesn't exist.
 */

int isdir(char[] name)
{
    return (getAttributes(name) & ПФайл.Папка) != 0;
}

/****************************************************
 * Change directory to pathname[].
 * Throws: ФайлИскл on error.
 */

void chdir(char[] pathname)
{  

    if (!SetCurrentDirectoryW(std.utf.toUTF16z(pathname)))
    {
    throw new ФайлИскл(pathname, GetLastError());
    }
}

/****************************************************
 * Make directory pathname[].
 * Throws: ФайлИскл on error.
 */

void mkdir(char[] pathname)
{
    if (! CreateDirectoryW(std.utf.toUTF16z(pathname), null))
    {
    throw new ФайлИскл(pathname, GetLastError());
    }
}

/****************************************************
 * Remove directory pathname[].
 * Throws: ФайлИскл on error.
 */

void rmdir(char[] pathname)
{  
    if (!RemoveDirectoryW(std.utf.toUTF16z(pathname)))
    {
    throw new ФайлИскл(pathname, GetLastError());
    }
}

/****************************************************
 * Get current directory.
 * Throws: ФайлИскл on error.
 */

char[] getcwd()
{
   
    wchar c;

    auto len = GetCurrentDirectoryW(0, &c);
    if (!len)
        goto Lerr;
    auto dir = new wchar[len];
    len = GetCurrentDirectoryW(len, dir.ptr);
    if (!len)
        goto Lerr;
    return std.utf.toUTF8(dir[0 .. len]); // leave off terminating 0
    
Lerr:
    throw new ФайлИскл("getcwd", GetLastError());
}

/***************************************************
 * Directory Entry
 */

struct DirEntry
{


    alias name имя; 
    alias size размер;
    alias creationTime датаСозд;    
    alias lastAccessTime последВремяДост;
    alias lastWriteTime последнВремяЗап;
    alias attributes атрибуты;  
    alias init иниц;
    alias isdir папка_ли;  
    alias isfile файл_ли;
    
    string name;            /// file or directory name
    ulong size = ~0UL;          /// size of file in bytes
    т_время creationTime = т_время_нч;   /// time of file creation
    т_время lastAccessTime = т_время_нч; /// time file was last accessed
    т_время lastWriteTime = т_время_нч;  /// time file was last written to
    uint attributes;        // Windows file attributes OR'd together

    void init(string path, ПДАН_А *fd)
    {
    wchar[] wbuf;
    size_t clength;
    size_t wlength;
    size_t n;

    clength = cidrus.strlen(fd.имяФайла.ptr);

    // Convert cFileName[] to unicode
    wlength = sys.WinFuncs.MultiByteToWideChar(0,0,fd.имяФайла.ptr,clength,null,0);
    if (wlength > wbuf.length)
        wbuf.length = wlength;
    n = sys.WinFuncs.MultiByteToWideChar(0,0,fd.имяФайла.ptr,clength,cast(wchar*)wbuf,wlength);
    assert(n == wlength);
    // toUTF8() returns a new buffer
    name = std.path.join(path, std.utf.toUTF8(wbuf[0 .. wlength]));

    size = (cast(ulong)fd.размерФайлаВ << 32) | fd.размерФайлаН;
    creationTime = std.date.FILETIME2d_time(&fd.времяСоздания);
    lastAccessTime = std.date.FILETIME2d_time(&fd.времяПоследнегоДоступа);
    lastWriteTime = std.date.FILETIME2d_time(&fd.времяПоследнейЗаписи);
    attributes = fd.атрибутыФайла;
    }

    void init(string path, ПДАН *fd)
    {
    size_t clength = wcslen(fd.имяФайла.ptr);
    name = std.path.join(path, std.utf.toUTF8(fd.имяФайла[0 .. clength]));
    size = (cast(ulong)fd.размерФайлаВ << 32) | fd.размерФайлаН;
    creationTime = std.date.FILETIME2d_time(&fd.времяСоздания);
    lastAccessTime = std.date.FILETIME2d_time(&fd.времяПоследнегоДоступа);
    lastWriteTime = std.date.FILETIME2d_time(&fd.времяПоследнейЗаписи);
    attributes = fd.атрибутыФайла;
    }

    /****
     * Return !=0 if DirEntry is a directory.
     */
    uint isdir()
    {
    return attributes & ПФайл.Папка;
    }

    /****
     * Return !=0 if DirEntry is a file.
     */
    uint isfile()
    {
    return !(attributes & ПФайл.Папка);
    }
}


/***************************************************
 * Return contents of directory pathname[].
 * The names in the contents do not include the pathname.
 * Throws: ФайлИскл on error
 * Example:
 *  This program lists all the files and subdirectories in its
 *  path argument.
 * ----
 * import std.io;
 * import std.file;
 *
 * void main(string[] args)
 * {
 *    auto dirs = listdir(args[1]);
 *
 *    foreach (d; dirs)
 *  writefln(d);
 * }
 * ----
 */

string[] listdir(string pathname)
{
    string[] результат;

    bool listing(string filename)
    {
    результат ~= filename;
    return true; // continue
    }

    listdir(pathname, &listing);
    return результат;
}


/*****************************************************
 * Return all the files in the directory and its subdirectories
 * that match pattern or regular expression r.
 * Параметры:
 *  pathname = Directory name
 *  pattern = String with wildcards, such as $(RED "*.d"). The supported
 *      wildcard strings are described under fnmatch() in
 *      $(LINK2 std_path.html, std.path).
 *  r = Regular expression, for more powerful _pattern matching.
 * Example:
 *  This program lists all the files with a "d" extension in
 *  the path passed as the first argument.
 * ----
 * import std.io;
 * import std.file;
 *
 * void main(string[] args)
 * {
 *    auto d_source_files = listdir(args[1], "*.d");
 *
 *    foreach (d; d_source_files)
 *  writefln(d);
 * }
 * ----
 * A regular expression version that searches for all files with "d" or
 * "объ" extensions:
 * ----
 * import std.io;
 * import std.file;
 * import std.regexp;
 *
 * void main(string[] args)
 * {
 *    auto d_source_files = listdir(args[1], РегВыр(r"\.(d|объ)$"));
 *
 *    foreach (d; d_source_files)
 *  writefln(d);
 * }
 * ----
 */

string[] listdir(string pathname, string pattern)
{   string[] результат;

    bool callback(DirEntry* de)
    {
    if (de.isdir)
        listdir(de.name, &callback);
    else
    {   if (std.path.fnmatch(de.name, pattern))
        результат ~= de.name;
    }
    return true; // continue
    }

    listdir(pathname, &callback);
    return результат;
}

/** Ditto */

string[] listdir(string pathname, РегВыр r)
{   string[] результат;

    bool callback(DirEntry* de)
    {
    if (de.isdir)
        listdir(de.name, &callback);
    else
    {   if (r.проверь(de.name))
        результат ~= de.name;
    }
    return true; // continue
    }

    listdir(pathname, &callback);
    return результат;
}

/******************************************************
 * For each file and directory name in pathname[],
 * pass it to the callback delegate.
 * Параметры:
 *  callback =  Delegate that processes each
 *          filename in turn. Returns true to
 *          continue, false to stop.
 * Example:
 *  This program lists all the files in its
 *  path argument, including the path.
 * ----
 * import std.io;
 * import std.path;
 * import std.file;
 *
 * void main(string[] args)
 * {
 *    auto pathname = args[1];
 *    string[] результат;
 *
 *    bool listing(string filename)
 *    {
 *      результат ~= std.path.join(pathname, filename);
 *      return true; // continue
 *    }
 *
 *    listdir(pathname, &listing);
 *
 *    foreach (name; результат)
 *      writefln("%s", name);
 * }
 * ----
 */

void listdir(string pathname, bool delegate(string filename) callback)
{
    bool listing(DirEntry* de)
    {
    return callback(std.path.getBaseName(de.name));
    }

    listdir(pathname, &listing);
}

/******************************************************
 * For each file and directory DirEntry in pathname[],
 * pass it to the callback delegate.
 * Параметры:
 *  callback =  Delegate that processes each
 *          DirEntry in turn. Returns true to
 *          continue, false to stop.
 * Example:
 *  This program lists all the files in its
 *  path argument and all subdirectories thereof.
 * ----
 * import std.io;
 * import std.file;
 *
 * void main(string[] args)
 * {
 *    bool callback(DirEntry* de)
 *    {
 *      if (de.isdir)
 *        listdir(de.name, &callback);
 *      else
 *        writefln(de.name);
 *      return true;
 *    }
 *
 *    listdir(args[1], &callback);
 * }
 * ----
 */

void listdir(string pathname, bool delegate(DirEntry* de) callback)
{
    string c;
    ук h;
    DirEntry de;

    c = std.path.join(pathname, "*.*");
    if (useWfuncs)
    {
    ПДАН fileinfo;

    h = НайдиПервыйФайл(std.utf.toUTF16(c), &fileinfo);
    if (h != cast(ук) НЕВЕРНХЭНДЛ)
    {
        try
        {
        do
        {
            // Skip "." and ".."
            if (wcscmp(fileinfo.имяФайла.ptr, ".") == 0 ||
            wcscmp(fileinfo.имяФайла.ptr, "..") == 0)
            continue;

            de.init(pathname, &fileinfo);
            if (!callback(&de))
            break;
        } while (НайдиСледующийФайл(cast(ук)h,&fileinfo) != ЛОЖЬ);
        }
        finally
        {
        НайдиЗакрой(h);
        }
    }
    }
    else
    {
    ПДАН_А fileinfo;

    h = НайдиПервыйФайлА(c, &fileinfo);
    if (h != cast(ук) НЕВЕРНХЭНДЛ)  // should we throw exception if invalid?
    {
        try
        {
        do
        {
            // Skip "." and ".."
            if (cidrus.strcmp(fileinfo.имяФайла.ptr, ".") == 0 ||
            cidrus.strcmp(fileinfo.имяФайла.ptr, "..") == 0)
            continue;

            de.init(pathname, &fileinfo);
            if (!callback(&de))
            break;
        } while (НайдиСледующийФайлА(h,&fileinfo) != ЛОЖЬ);
        }
        finally
        {
        НайдиЗакрой(h);
        }
    }
    }
}

void copy(string from, string to)
{
    BOOL результат;

    if (useWfuncs)
    результат = CopyFileW(std.utf.toUTF16z(from), std.utf.toUTF16z(to), false);
    else
    результат = CopyFileA(toMBSz(from), toMBSz(to), false);
    if (!результат)
         throw new ФайлИскл(to, GetLastError());
}


}

/* =========================== Posix ======================= */

version (Posix)
{

private import std.date;
private import os.posix;
private import cidrus;

/***********************************
 */

class ФайлИскл : Exception
{
    uint errno;         // operating system error code

    this(string name)
    {
    this(name, "ввод-вывод файла");
    }

    this(string name, string message)
    {
    super(name ~ ": " ~ message);
    }

    this(string name, uint errno)
    {
        char[1024] buf = void;
    auto s = strerror_r(errno, buf.ptr, buf.length);
    this(name, std.string.toString(s).dup);
    this.errno = errno;
    }
}

/********************************************
 * Read a file.
 * Returns:
 *  array of bytes read
 */

void[] read(string name)
{
    struct_stat statbuf;

    auto namez = toStringz(name);
    //эхо("file.read('%s')\n",namez);
    auto fd = os.posix.open(namez, O_RDONLY);
    if (fd == -1)
    {
        //эхо("\topen error, errno = %d\n",getErrno());
        goto err1;
    }

    //эхо("\tfile opened\n");
    if (os.posix.fstat(fd, &statbuf))
    {
        //эхо("\tfstat error, errno = %d\n",getErrno());
        goto err2;
    }
    auto size = statbuf.st_size;
    if (size > int.max)
    goto err2;

    void[] buf;
    if (size == 0)
    {   /* The size could be 0 if the file is a device or a procFS file,
     * so we just have to try reading it.
     */
    int readsize = 1024;
    while (1)
    {
        buf = runtime.realloc(buf.ptr, cast(int)size + readsize);

        auto toread = readsize;
        while (toread)
        {
        auto numread = os.posix.read(fd, buf.ptr + size, toread);
        if (numread == -1)
            goto err2;
        size += numread;
        if (numread == 0)
        {   if (size == 0)          // it really was 0 size
            delete buf;         // don't need the buffer
            else
            runtime.hasNoPointers(buf.ptr);
            goto Leof;              // end of file
        }
        toread -= numread;
        }
    }
    }
    else
    {
    buf = runtime.malloc(cast(int)size);
    if (buf.ptr)
        runtime.hasNoPointers(buf.ptr);

    auto numread = os.posix.read(fd, buf.ptr, cast(int)size);
    if (numread != size)
    {
        //эхо("\tread error, errno = %d\n",getErrno());
        goto err2;
    }
    }

  Leof:
    if (os.posix.close(fd) == -1)
    {
    //эхо("\tclose error, errno = %d\n",getErrno());
        goto err;
    }

    return buf[0 .. cast(size_t)size];

err2:
    os.posix.close(fd);
err:
    delete buf;

err1:
    throw new ФайлИскл(name, getErrno());
}

unittest
{
    version (linux)
    {   // A file with "zero" length that doesn't have 0 length at all
    char[] s = cast(char[])read("/proc/sys/kernel/osrelease");
    assert(s.length > 0);
    //writefln("'%s'", s);
    }
}

/*********************************************
 * Write a file.
 */

void write(string name, void[] buffer)
{
    int fd;
    int numwritten;
    char *namez;

    namez = toStringz(name);
    fd = os.posix.open(namez, O_CREAT | O_WRONLY | O_TRUNC, 0660);
    if (fd == -1)
        goto err;

    numwritten = os.posix.write(fd, buffer.ptr, buffer.length);
    if (buffer.length != numwritten)
        goto err2;

    if (os.posix.close(fd) == -1)
        goto err;

    return;

err2:
    os.posix.close(fd);
err:
    throw new ФайлИскл(name, getErrno());
}


/*********************************************
 * Append to a file.
 */

void append(string name, void[] buffer)
{
    int fd;
    int numwritten;
    char *namez;

    namez = toStringz(name);
    fd = os.posix.open(namez, O_APPEND | O_WRONLY | O_CREAT, 0660);
    if (fd == -1)
        goto err;

    numwritten = os.posix.write(fd, buffer.ptr, buffer.length);
    if (buffer.length != numwritten)
        goto err2;

    if (os.posix.close(fd) == -1)
        goto err;

    return;

err2:
    os.posix.close(fd);
err:
    throw new ФайлИскл(name, getErrno());
}


/***************************************************
 * Rename a file.
 */

void rename(string from, string to)
{
    char *fromz = toStringz(from);
    char *toz = toStringz(to);

    if (cidrus.rename(fromz, toz) == -1)
    throw new ФайлИскл(to, getErrno());
}


/***************************************************
 * Delete a file.
 */

void remove(string name)
{
    if (cidrus.remove(toStringz(name)) == -1)
    throw new ФайлИскл(name, getErrno());
}


/***************************************************
 * Get file size.
 */

ulong getSize(string name)
{
    int fd;
    struct_stat statbuf;
    char *namez;

    namez = toStringz(name);
    //эхо("file.getSize('%s')\n",namez);
    fd = os.posix.open(namez, O_RDONLY);
    if (fd == -1)
    {
        //эхо("\topen error, errno = %d\n",getErrno());
        goto err1;
    }

    //эхо("\tfile opened\n");
    if (os.posix.fstat(fd, &statbuf))
    {
        //эхо("\tfstat error, errno = %d\n",getErrno());
        goto err2;
    }
    auto size = statbuf.st_size;

    if (os.posix.close(fd) == -1)
    {
    //эхо("\tclose error, errno = %d\n",getErrno());
        goto err;
    }

    return cast(ulong)size;

err2:
    os.posix.close(fd);
err:
err1:
    throw new ФайлИскл(name, getErrno());
}


/***************************************************
 * Get file attributes.
 */

uint getAttributes(string name)
{
    struct_stat statbuf;
    char *namez;

    namez = toStringz(name);
    if (os.posix.stat(namez, &statbuf))
    {
    throw new ФайлИскл(name, getErrno());
    }

    return statbuf.st_mode;
}

/*************************
 * Get creation/access/modified times of file name[].
 * Throws: ФайлИскл on error.
 */

void getTimes(string name, out т_время ftc, out т_время fta, out т_время ftm)
{
    struct_stat statbuf;
    char *namez;

    namez = toStringz(name);
    if (os.posix.stat(namez, &statbuf))
    {
    throw new ФайлИскл(name, getErrno());
    }

    version (linux)
    {
    ftc = cast(т_время)statbuf.st_ctime * std.date.TicksPerSecond;
    fta = cast(т_время)statbuf.st_atime * std.date.TicksPerSecond;
    ftm = cast(т_время)statbuf.st_mtime * std.date.TicksPerSecond;
    }
    else version (OSX)
    {   // BUG: should add in tv_nsec field
    ftc = cast(т_время)statbuf.st_ctimespec.tv_sec * std.date.TicksPerSecond;
    fta = cast(т_время)statbuf.st_atimespec.tv_sec * std.date.TicksPerSecond;
    ftm = cast(т_время)statbuf.st_mtimespec.tv_sec * std.date.TicksPerSecond;
    }
    else version (FreeBSD)
    {   // BUG: should add in tv_nsec field
    ftc = cast(т_время)statbuf.st_ctimespec.tv_sec * std.date.TicksPerSecond;
    fta = cast(т_время)statbuf.st_atimespec.tv_sec * std.date.TicksPerSecond;
    ftm = cast(т_время)statbuf.st_mtimespec.tv_sec * std.date.TicksPerSecond;
    }
    else version (Solaris)
    {  // BUG: should add in *nsec fields
       ftc = cast(т_время)statbuf.st_ctime * std.date.TicksPerSecond;
       fta = cast(т_время)statbuf.st_atime * std.date.TicksPerSecond;
       ftm = cast(т_время)statbuf.st_mtime * std.date.TicksPerSecond;
    }
    else
    {
    static assert(0);
    }
}


/****************************************************
 * Does file/directory exist?
 */

int exists(char[] name)
{
    return access(toStringz(name),0) == 0;

/+
    struct_stat statbuf;
    char *namez;

    namez = toStringz(name);
    if (os.posix.stat(namez, &statbuf))
    {
    return 0;
    }
    return 1;
+/
}

unittest
{
    assert(exists("."));
}

/****************************************************
 * Is name a file?
 */

int isfile(string name)
{
    return (getAttributes(name) & S_IFMT) == S_IFREG;   // regular file
}

/****************************************************
 * Is name a directory?
 */

int isdir(string name)
{
    return (getAttributes(name) & S_IFMT) == S_IFDIR;
}

/****************************************************
 * Change directory.
 */

void chdir(string pathname)
{
    if (os.posix.chdir(toStringz(pathname)))
    {
    throw new ФайлИскл(pathname, getErrno());
    }
}

/****************************************************
 * Make directory.
 */

void mkdir(char[] pathname)
{
    if (os.posix.mkdir(toStringz(pathname), 0777))
    {
    throw new ФайлИскл(pathname, getErrno());
    }
}

/****************************************************
 * Remove directory.
 */

void rmdir(string pathname)
{
    if (os.posix.rmdir(toStringz(pathname)))
    {
    throw new ФайлИскл(pathname, getErrno());
    }
}

/****************************************************
 * Get current directory.
 */

string getcwd()
{
    auto p = os.posix.getcwd(null, 0);
    if (!p)
    {
    throw new ФайлИскл("cannot get cwd", getErrno());
    }

    auto len = cidrus.strlen(p);
    auto buf = new char[len];
    buf[] = p[0 .. len];
    cidrus.free(p);
    return buf;
}

/***************************************************
 * Directory Entry
 */

alias DirEntry ПапЗапись;
struct DirEntry
{
alias isfile файл_ли;
alias isdir папка_ли;
alias init иниц;
alias attributes атрибуты;
alias lastWriteTime последнВремяЗап;
alias lastAccessTime последВремяДост;
alias creationTime датаСозд;
alias size размер;
alias name имя;

    string name;            /// file or directory name
    ulong _size = ~0UL;         // size of file in bytes
    т_время _creationTime = т_время_нч;  // time of file creation
    т_время _lastAccessTime = т_время_нч; // time file was last accessed
    т_время _lastWriteTime = т_время_нч; // time file was last written to
    ubyte d_type;
    ubyte didstat;          // done lazy evaluation of stat()

    void init(string path, dirent *fd)
    {   size_t len = cidrus.strlen(fd.d_name.ptr);
    name = std.path.join(path, fd.d_name[0 .. len]);
    d_type = fd.d_type;
       // Some platforms, like Solaris, don't have this member.
       // TODO: Bug: d_type is never set on Solaris (see bugzilla 2838 for fix.)
       static if (is(fd.d_type))
           d_type = fd.d_type;
    didstat = 0;
    }

    int isdir()
    {
    return d_type & DT_DIR;
    }

    int isfile()
    {
    return d_type & DT_REG;
    }

    ulong size()
    {
    if (!didstat)
        doStat();
    return _size;
    }

    т_время creationTime()
    {
    if (!didstat)
        doStat();
    return _creationTime;
    }

    т_время lastAccessTime()
    {
    if (!didstat)
        doStat();
    return _lastAccessTime;
    }

    т_время lastWriteTime()
    {
    if (!didstat)
        doStat();
    return _lastWriteTime;
    }

    /* This is to support lazy evaluation, because doing stat's is
     * expensive and not always needed.
     */

    void doStat()
    {
    int fd;
    struct_stat statbuf;
    char* namez;

    namez = toStringz(name);
    if (os.posix.stat(namez, &statbuf))
    {
        //эхо("\tstat error, errno = %d\n",getErrno());
        return;
    }
    _size = cast(ulong)statbuf.st_size;
    version (linux)
    {
        _creationTime = cast(т_время)statbuf.st_ctime * std.date.TicksPerSecond;
        _lastAccessTime = cast(т_время)statbuf.st_atime * std.date.TicksPerSecond;
        _lastWriteTime = cast(т_время)statbuf.st_mtime * std.date.TicksPerSecond;
    }
    else version (OSX)
    {
        _creationTime =   cast(т_время)statbuf.st_ctimespec.tv_sec * std.date.TicksPerSecond;
        _lastAccessTime = cast(т_время)statbuf.st_atimespec.tv_sec * std.date.TicksPerSecond;
        _lastWriteTime =  cast(т_время)statbuf.st_mtimespec.tv_sec * std.date.TicksPerSecond;
    }
    else version (FreeBSD)
    {
        _creationTime =   cast(т_время)statbuf.st_ctimespec.tv_sec * std.date.TicksPerSecond;
        _lastAccessTime = cast(т_время)statbuf.st_atimespec.tv_sec * std.date.TicksPerSecond;
        _lastWriteTime =  cast(т_время)statbuf.st_mtimespec.tv_sec * std.date.TicksPerSecond;
    }
    else version (Solaris)
    {
        _creationTime   = cast(т_время)statbuf.st_ctime * std.date.TicksPerSecond;
        _lastAccessTime = cast(т_время)statbuf.st_atime * std.date.TicksPerSecond;
        _lastWriteTime  = cast(т_время)statbuf.st_mtime * std.date.TicksPerSecond;
    }
    else
    {
        static assert(0);
    }

    didstat = 1;
    }
}


/***************************************************
 * Return contents of directory.
 */

string[] listdir(string pathname)
{
    string[] результат;
    bool listing(string filename)
    {
    результат ~= filename;
    return true; // continue
    }

    listdir(pathname, &listing);
    return результат;
}

string[] listdir(string pathname, string pattern)
{   string[] результат;
    bool callback(DirEntry* de)
    {
    if (de.isdir)
        listdir(de.name, &callback);
    else
    {   if (std.path.fnmatch(de.name, pattern))
        результат ~= de.name;
    }
    return true; // continue
    }
    
    listdir(pathname, &callback);
    return результат;
}

string[] listdir(string pathname, РегВыр r)
{   string[] результат;

    bool callback(DirEntry* de)
    {
    if (de.isdir)
        listdir(de.name, &callback);
    else
    {   if (r.test(de.name))
        результат ~= de.name;
    }
    return true; // continue
    }

    listdir(pathname, &callback);
    return результат;
}

void listdir(string pathname, bool delegate(string filename) callback)
{
    bool listing(DirEntry* de)
    {
    return callback(std.path.getBaseName(de.name));
    }

    listdir(pathname, &listing);
}

void listdir(string pathname, bool delegate(DirEntry* de) callback)
{
    DIR* h;
    dirent* fdata;
    DirEntry de;

    h = opendir(toStringz(pathname));
    if (h)
    {
    try
    {
        while((fdata = readdir(h)) != null)
        {
        // Skip "." and ".."
        if (!cidrus.strcmp(fdata.d_name.ptr, ".") ||
            !cidrus.strcmp(fdata.d_name.ptr, ".."))
            continue;

        de.init(pathname, fdata);
        if (!callback(&de))     
            break;
        }
    }
    finally
    {
        closedir(h);
    }
    }
    else
    {
        throw new ФайлИскл(pathname, getErrno());
    }
}


/***************************************************
 * Copy a file. File timestamps are preserved.
 */

void copy(string from, string to)
{
  version (all)
  {
    struct_stat statbuf;

    char* fromz = toStringz(from);
    char* toz = toStringz(to);
    //эхо("file.copy(from='%s', to='%s')\n", fromz, toz);

    int fd = os.posix.open(fromz, O_RDONLY);
    if (fd == -1)
    {
        //эхо("\topen error, errno = %d\n",getErrno());
        goto err1;
    }

    //эхо("\tfile opened\n");
    if (os.posix.fstat(fd, &statbuf))
    {
        //эхо("\tfstat error, errno = %d\n",getErrno());
        goto err2;
    }

    int fdw = os.posix.open(toz, O_CREAT | O_WRONLY | O_TRUNC, 0660);
    if (fdw == -1)
    {
        //эхо("\topen error, errno = %d\n",getErrno());
        goto err2;
    }

    size_t BUFSIZ = 4096 * 16;
    void* buf = cidrus.malloc(BUFSIZ);
    if (!buf)
    {   BUFSIZ = 4096;
    buf = cidrus.malloc(BUFSIZ);
    }
    if (!buf)
    {
        //эхо("\topen error, errno = %d\n",getErrno());
        goto err4;
    }

    for (auto size = statbuf.st_size; size; )
    {   size_t toread = (size > BUFSIZ) ? BUFSIZ : cast(size_t)size;

    auto n = os.posix.read(fd, buf, toread);
    if (n != toread)
    {
        //эхо("\tread error, errno = %d\n",getErrno());
        goto err5;
    }
    n = os.posix.write(fdw, buf, toread);
    if (n != toread)
    {
        //эхо("\twrite error, errno = %d\n",getErrno());
        goto err5;
    }
    size -= toread;
    }

    cidrus.free(buf);

    if (os.posix.close(fdw) == -1)
    {
    //эхо("\tclose error, errno = %d\n",getErrno());
        goto err2;
    }

    utimbuf utim = void;
    version (linux)
    {
    utim.actime = cast(__time_t)statbuf.st_atime;
    utim.modtime = cast(__time_t)statbuf.st_mtime;
    }
    else version (OSX)
    {
    utim.actime = cast(__time_t)statbuf.st_atimespec.tv_sec;
    utim.modtime = cast(__time_t)statbuf.st_mtimespec.tv_sec;
    }
    else version (FreeBSD)
    {
    utim.actime = cast(__time_t)statbuf.st_atimespec.tv_sec;
    utim.modtime = cast(__time_t)statbuf.st_mtimespec.tv_sec;
    }
    else version (Solaris)
    {
       utim.actime = cast(__time_t)statbuf.st_atime;
       utim.modtime = cast(__time_t)statbuf.st_mtime;
    }
    else
    {
    static assert(0);
    }
    if (utime(toz, &utim) == -1)
    {
    //эхо("\tutime error, errno = %d\n",getErrno());
    goto err3;
    }

    if (os.posix.close(fd) == -1)
    {
    //эхо("\tclose error, errno = %d\n",getErrno());
        goto err1;
    }

    return;

err5:
    cidrus.free(buf);
err4:
    os.posix.close(fdw);
err3:
    cidrus.remove(toz);
err2:
    os.posix.close(fd);
err1:
    throw new ФайлИскл(from, getErrno());
  }
  else
  {
    void[] buffer;

    buffer = read(from);
    write(to, buffer);
    delete buffer;
  }
}



}

unittest
{
    //эхо("unittest\n");
    void[] buf;

    buf = new void[10];
    (cast(byte[])buf)[] = 3;
    write("unittest_write.tmp", buf);
    void buf2[] = read("unittest_write.tmp");
    assert(buf == buf2);

    copy("unittest_write.tmp", "unittest_write2.tmp");
    buf2 = read("unittest_write2.tmp");
    assert(buf == buf2);

    remove("unittest_write.tmp");
    if (exists("unittest_write.tmp"))
    assert(0);
    remove("unittest_write2.tmp");
    if (exists("unittest_write2.tmp"))
    assert(0);
}

unittest
{
    listdir (".", delegate bool (DirEntry * de)
    {
    auto s = std.string.format("%s : c %s, w %s, a %s", de.name,
        toUTCString (de.creationTime),
        toUTCString (de.lastWriteTime),
        toUTCString (de.lastAccessTime));
    return true;
    }
    );
}



