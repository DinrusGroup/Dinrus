/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1994-1998 by Symantec
 *              Copyright (C) 2000-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/ос.d, backend/ос.d)
 */

/*
 * Operating system specific routines.
 * Placed here to avoid cluttering
 * up code with OS files.
 */

import cidrus;

version (Posix)
{
    import core.stdc.errno;
    import core.sys.posix.fcntl;
    import core.sys.posix.pthread;
    import core.sys.posix.sys.stat;
    import core.sys.posix.sys.types;
    import core.sys.posix.unistd;
    //#define GetLastError() errno
}
else version (Windows)
{
   // import win32.stat;
    import win32.winbase;
    import win32.windef;
}

version (CRuntime_Microsoft)
    const NEEDS_WIN32_NON_MS = нет;
else version (Win32)
    const NEEDS_WIN32_NON_MS = да;
else
    const NEEDS_WIN32_NON_MS = нет;

version (Win64)
    const NEEDS_WIN32_NOT_WIN64 = нет;
else version (Win32)
    const NEEDS_WIN32_NOT_WIN64 = да;
else
    const NEEDS_WIN32_NOT_WIN64 = нет;


/*extern(C++):*/



version (CRuntime_Microsoft)
{
    import core.stdc.stdlib;
}
//debug = printf;
version (Windows)
{
    ///*extern(C++)*/
	проц dll_printf( сим *format,...);
    alias  dll_printf printf;
}

цел file_createdirs(сим *имя);

/***********************************
 * Called when there is an error returned by the operating system.
 * This function does not return.
 */
проц os_error(цел line = __LINE__)
{
    version(Windows)
        debug(printf) printf("System error: %ldL\n", GetLastError());
    assert(0);
}

static if (NEEDS_WIN32_NOT_WIN64)
{

private  HANDLE hHeap;

проц *globalrealloc(проц *oldp,т_мера newsize)
{
static if (0)
{
    проц *p;

    // Initialize heap
    if (!hHeap)
    {   hHeap = HeapCreate(0,0x10000,0);
        if (!hHeap)
            os_error();
    }

    newsize = (newsize + 3) & ~3L;      // round up to dwords
    if (newsize == 0)
    {
        if (oldp && HeapFree(hHeap,0,oldp) == нет)
            os_error();
        p = NULL;
    }
    else if (!oldp)
    {
        p = newsize ? HeapAlloc(hHeap,0,newsize) : null;
    }
    else
        p = HeapReAlloc(hHeap,0,oldp,newsize);
}
else static if (1)
{
    MEMORY_BASIC_INFORMATION query;
    проц *p;
    BOOL bSuccess;

    if (!oldp)
        p = VirtualAlloc (null, newsize, MEM_COMMIT | MEM_RESERVE, PAGE_READWRITE);
    else
    {
        VirtualQuery (oldp, &query, query.sizeof);
        if (!newsize)
        {
            p = null;
            goto L1;
        }
        else
        {   newsize = (newsize + 0xFFFF) & ~0xFFFFL;

            if (query.RegionSize >= newsize)
                p = oldp;
            else
            {   p = VirtualAlloc(null,newsize,MEM_COMMIT | MEM_RESERVE,PAGE_READWRITE);
                if (p)
                    memcpy(p,oldp,query.RegionSize);
            L1:
                bSuccess = VirtualFree(oldp,query.RegionSize,MEM_DECOMMIT);
                if (bSuccess)
                    bSuccess = VirtualFree(oldp,0,MEM_RELEASE);
                if (!bSuccess)
                    os_error();
            }
        }
    }
}
else
{
    проц *p;

    if (!oldp)
        p = cast(проц *)GlobalAlloc (0, newsize);
    else if (!newsize)
    {   GlobalFree(oldp);
        p = null;
    }
    else
        p = cast(проц *)GlobalReAlloc(oldp,newsize,0);
}
    debug(printf) printf("globalrealloc(oldp = %p, size = x%x) = %p\n",oldp,newsize,p);
    return p;
}

/*****************************************
 * Functions to manage allocating a single virtual address space.
 */

проц *vmem_reserve(проц *ptr,бцел size)
{   проц *p;

version(none)
{
    p = VirtualAlloc(ptr,size,MEM_RESERVE,PAGE_READWRITE);
    debug(printf) printf("vmem_reserve(ptr = %p, size = x%lx) = %p\n",ptr,size,p);
}
else
{
    debug(printf) printf("vmem_reserve(ptr = %p, size = x%lx) = %p\n",ptr,size,p);
    p = VirtualAlloc(ptr,size,MEM_RESERVE,PAGE_READWRITE);
    if (!p)
        os_error();
}
    return p;
}

/*****************************************
 * Commit memory.
 * Возвращает:
 *      0       failure
 *      !=0     успех
 */

цел vmem_commit(проц *ptr, бцел size)
{   цел i;

    debug(printf) printf("vmem_commit(ptr = %p,size = x%lx)\n",ptr,size);
    i = cast(цел) VirtualAlloc(ptr,size,MEM_COMMIT,PAGE_READWRITE);
    if (i == 0)
        debug(printf) printf("failed to commit\n");
    return i;
}

проц vmem_decommit(проц *ptr,бцел size)
{
    debug(printf) printf("vmem_decommit(ptr = %p, size = x%lx)\n",ptr,size);
    if (ptr)
    {   if (!VirtualFree(ptr, size, MEM_DECOMMIT))
            os_error();
    }
}

проц vmem_release(проц *ptr, бцел size)
{
    debug(printf) printf("vmem_release(ptr = %p, size = x%lx)\n",ptr,size);
    if (ptr)
    {
        if (!VirtualFree(ptr, 0, MEM_RELEASE))
            os_error();
    }
}

/********************************************
 * Map файл for читай, копируй on пиши, into virtual address space.
 * Input:
 *      ptr             address to map файл to, if NULL then pick an address
 *      size            length of the файл
 *      флаг    0       читай / пиши
 *              1       читай / копируй on пиши
 *              2       читай only
 * Возвращает:
 *      NULL    failure
 *      ptr     pointer to start of mapped файл
 */

private  HANDLE hFile = INVALID_HANDLE_VALUE;
private  HANDLE hFileMap = null;
private  проц *pview;
private  проц *preserve;
private  т_мера preserve_size;

проц *vmem_mapfile(сим *имяф,проц *ptr, бцел size,цел флаг)
{
    OSVERSIONINFO OsVerInfo;

    OsVerInfo.dwOSVersionInfoSize = OsVerInfo.sizeof;
    GetVersionEx(&OsVerInfo);

    debug(printf) printf("vmem_mapfile(имяф = '%s', ptr = %p, size = x%lx, флаг = %d)\n",
                         имяф,ptr,size,флаг);

    hFile = CreateFileA(имяф, GENERIC_READ | GENERIC_WRITE,
                        FILE_SHARE_READ | FILE_SHARE_WRITE, null,
                        OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, null);
    if (hFile == INVALID_HANDLE_VALUE)
        goto L1;                        // failure
    debug(printf) printf(" файл created\n");

    // Windows 95 does not implement PAGE_WRITECOPY (unfortunately treating
    // it just like PAGE_READWRITE).
    if (флаг == 1 && OsVerInfo.dwPlatformId == 1)       // Windows 95, 98, ME
        hFileMap = null;
    else
        hFileMap = CreateFileMappingA(hFile,null,
                (флаг == 1) ? PAGE_WRITECOPY : PAGE_READWRITE,0,size,null);

    if (hFileMap == null)               // mapping failed
    {
version(all)
{
        // Win32s seems to always fail here.
        DWORD члобайт;

        debug(printf) printf(" mapping failed\n");
        // If it was NT failing, assert.
        assert(OsVerInfo.dwPlatformId != VER_PLATFORM_WIN32_NT);

        // To work around, just читай the файл into memory.
        assert(флаг == 1);
        preserve = vmem_reserve(ptr,size);
        if (!preserve)
            goto L2;
        if (!vmem_commit(preserve,size))
        {
            vmem_release(preserve,size);
            preserve = null;
            goto L2;
        }
        preserve_size = size;
        if (!ReadFile(hFile,preserve,size,&члобайт,null))
            os_error();
        assert(члобайт == size);
        if (CloseHandle(hFile) != да)
            os_error();
        hFile = INVALID_HANDLE_VALUE;
        return preserve;
}
else
{
        // Instead of working around, we should найди out why it failed.
        os_error();
}

    }
    else
    {
        debug(printf) printf(" mapping created\n");
        pview = MapViewOfFileEx(hFileMap,флаг ? FILE_MAP_COPY : FILE_MAP_WRITE,
                0,0,size,ptr);
        if (pview == null)                      // mapping view failed
        {   //os_error();
            goto L3;
        }
    }
    debug(printf) printf(" pview = %p\n",pview);

    return pview;

L3:
    if (CloseHandle(hFileMap) != да)
        os_error();
    hFileMap = null;
L2:
    if (CloseHandle(hFile) != да)
        os_error();
    hFile = INVALID_HANDLE_VALUE;
L1:
    return null;                        // failure
}

/*****************************
 * Set size of mapped файл.
 */

проц vmem_setfilesize(бцел size)
{
    if (hFile != INVALID_HANDLE_VALUE)
    {   if (SetFilePointer(hFile,size,null,FILE_BEGIN) == 0xFFFFFFFF)
            os_error();
        if (SetEndOfFile(hFile) == нет)
            os_error();
    }
}

/*****************************
 * Unmap previous файл mapping.
 */

проц vmem_unmapfile()
{
    debug(printf) printf("vmem_unmapfile()\n");

    vmem_decommit(preserve,preserve_size);
    vmem_release(preserve,preserve_size);
    preserve = null;
    preserve_size = 0;

version(none)
{
    if (pview)
    {   цел i;

        i = UnmapViewOfFile(pview);
        debug(printf) printf("i = x%x\n",i);
        if (i == нет)
            os_error();
    }
}
else
{
    // Note that under Windows 95, UnmapViewOfFile() seems to return random
    // values, not TRUE or FALSE.
    if (pview && UnmapViewOfFile(pview) == нет)
        os_error();
}
    pview = null;

    if (hFileMap != null && CloseHandle(hFileMap) != да)
        os_error();
    hFileMap = null;

    if (hFile != INVALID_HANDLE_VALUE && CloseHandle(hFile) != да)
        os_error();
    hFile = INVALID_HANDLE_VALUE;
}

/****************************************
 * Determine a base address that we can use for mapping files to.
 */

проц *vmem_baseaddr()
{
    OSVERSIONINFO OsVerInfo;
    проц *p;

    OsVerInfo.dwOSVersionInfoSize = OsVerInfo.sizeof;
    GetVersionEx(&OsVerInfo);

    // These values for the address were determined by trial and error.
    switch (OsVerInfo.dwPlatformId)
    {
        case VER_PLATFORM_WIN32s:               // Win32s
            // The fact that this is a different address than other
            // WIN32 implementations causes us a lot of grief.
            p = cast(проц *) 0xC0000000;
            break;

        case 1: //VER_PLATFORM_WIN32_WINDOWS:   // Windows 95
            // I've found 0x90000000..0xB work. All others fail.
        default:                                // unknown
            p = cast(проц *) 0x90000000;
            break;

        case VER_PLATFORM_WIN32_NT:             // Windows NT
            // Pick a значение that is not coincident with the base address
            // of any commonly используется system DLLs.
            p = cast(проц *) 0x38000000;
            break;
    }

    return p;
}

/********************************************
 * Calculate the amount of memory to резервируй, adjusting
 * *psize downwards.
 */

проц vmem_reservesize(бцел *psize)
{
    MEMORYSTATUS ms;
    OSVERSIONINFO OsVerInfo;

    бцел size;

    ms.dwLength = ms.sizeof;
    GlobalMemoryStatus(&ms);
    debug(printf) printf("dwMemoryLoad    x%lx\n",ms.dwMemoryLoad);
    debug(printf) printf("dwTotalPhys     x%lx\n",ms.dwTotalPhys);
    debug(printf) printf("dwAvailPhys     x%lx\n",ms.dwAvailPhys);
    debug(printf) printf("dwTotalPageFile x%lx\n",ms.dwTotalPageFile);
    debug(printf) printf("dwAvailPageFile x%lx\n",ms.dwAvailPageFile);
    debug(printf) printf("dwTotalVirtual  x%lx\n",ms.dwTotalVirtual);
    debug(printf) printf("dwAvailVirtual  x%lx\n",ms.dwAvailVirtual);


    OsVerInfo.dwOSVersionInfoSize = OsVerInfo.sizeof;
    GetVersionEx(&OsVerInfo);

    switch (OsVerInfo.dwPlatformId)
    {
        case VER_PLATFORM_WIN32s:               // Win32s
        case 1: //VER_PLATFORM_WIN32_WINDOWS:   // Windows 95
        default:                                // unknown
            size = (ms.dwAvailPageFile < ms.dwAvailVirtual)
                ? ms.dwAvailPageFile
                : ms.dwAvailVirtual;
            size = cast(бдол)size * 8 / 10;
            size &= ~0xFFFF;
            if (size < *psize)
                *psize = size;
            break;

        case VER_PLATFORM_WIN32_NT:             // Windows NT
            // NT can expand the paging файл
            break;
    }

}

/********************************************
 * Return amount of physical memory.
 */

бцел vmem_physmem()
{
    MEMORYSTATUS ms;

    ms.dwLength = ms.sizeof;
    GlobalMemoryStatus(&ms);
    return ms.dwTotalPhys;
}

//////////////////////////////////////////////////////////////

/***************************************************
 * Load library.
 */

private  HINSTANCE hdll;

проц os_loadlibrary(сим *dllname)
{
    hdll = LoadLibrary(cast(LPCTSTR) dllname);
    if (!hdll)
        os_error();
}

/*************************************************
 */

проц os_freelibrary()
{
    if (hdll)
    {
        if (FreeLibrary(hdll) != да)
            os_error();
        hdll = null;
    }
}

/*************************************************
 */

проц *os_getprocaddress( сим *funcname)
{   проц *fp;

    //printf("getprocaddress('%s')\n",funcname);
    assert(hdll);
    fp = cast(проц *)GetProcAddress(hdll,cast(LPCSTR)funcname);
    if (!fp)
        os_error();
    return fp;
}

//////////////////////////////////////////////////////////////


/*********************************
 */

проц os_term()
{
    if (hHeap)
    {   if (HeapDestroy(hHeap) == нет)
        {   hHeap = null;
            os_error();
        }
        hHeap = null;
    }
    os_freelibrary();
}

/***************************************************
 * Do our own storage allocator (being suspicious of the library one).
 */

version(all)
{
проц os_heapinit() { }
проц os_heapterm() { }

}
else
{
static HANDLE hHeap;

проц os_heapinit()
{
    hHeap = HeapCreate(0,0x10000,0);
    if (!hHeap)
        os_error();
}

проц os_heapterm()
{
    if (hHeap)
    {   if (HeapDestroy(hHeap) == нет)
            os_error();
    }
}

extern(Windows) проц * calloc(т_мера x,т_мера y)
{   т_мера size;

    size = x * y;
    return size ? HeapAlloc(hHeap,HEAP_ZERO_MEMORY,size) : null;
}

extern(Windows) проц free(проц *p)
{
    if (p && HeapFree(hHeap,0,p) == нет)
        os_error();
}

extern(Windows) проц * malloc(т_мера size)
{
    return size ? HeapAlloc(hHeap,0,size) : null;
}

extern(Windows) проц * realloc(проц *p,т_мера newsize)
{
    if (newsize == 0)
        free(p);
    else if (!p)
        p = malloc(newsize);
    else
        p = HeapReAlloc(hHeap,0,p,newsize);
    return p;
}

}

//////////////////////////////////////////
// Return a значение that will hopefully be unique every time
// we call it.

бцел os_unique()
{
    бдол x;

    QueryPerformanceCounter(cast(LARGE_INTEGER *)&x);
    return cast(бцел)x;
}

} // Win32

/*******************************************
 * Return !=0 if файл exists.
 *      0:      файл doesn't exist
 *      1:      normal файл
 *      2:      directory
 */

цел os_file_exists( сим *имя)
{
version(Windows)
{
    DWORD dw;
    цел результат;

    dw = GetFileAttributesA(имя);
    if (dw == -1L)
        результат = 0;
    else if (dw & FILE_ATTRIBUTE_DIRECTORY)
        результат = 2;
    else
        результат = 1;
    return результат;
}
else version(Posix)
{
    stat_t буф;

    return stat(имя,&буф) == 0;        /* файл exists if stat succeeded */

}
else
{
    return filesize(имя) != -1L;
}
}

/**************************************
 * Get файл size of open файл. Return -1L on error.
 */

static if(NEEDS_WIN32_NON_MS)
{
    extern extern (C) ук[] _osfhnd;
}

long os_file_size(цел fd)
{
    static if (NEEDS_WIN32_NON_MS)
    {
        return GetFileSize(_osfhnd[fd],null);
    }
    else
    {
        version(Windows)
        {
            return GetFileSize(cast(ук)_get_osfhandle(fd),null);
        }
        else
        {
            stat_t буф;
            return (fstat(fd,&буф)) ? -1L : буф.st_size;
        }
    }
}

/**************************************************
 * For 16 bit programs, we need the 16 bit имяф.
 * Возвращает:
 *      malloc'd ткст, NULL if none
 */

version(Windows)
{
сим *file_8dot3name( сим *имяф)
{
    HANDLE h;
    WIN32_FIND_DATAA fileinfo;
    сим *буф;
    т_мера i;

    h = FindFirstFileA(имяф,&fileinfo);
    if (h == INVALID_HANDLE_VALUE)
        return null;
    if (fileinfo.cAlternateFileName[0])
    {
        for (i = strlen(имяф); i > 0; i--)
            if (имяф[i] == '\\' || имяф[i] == ':')
            {   i++;
                break;
            }
        буф = cast(сим *) malloc(i + 14);
        if (буф)
        {
            memcpy(буф,имяф,i);
            strcpy(буф + i,fileinfo.cAlternateFileName.ptr);
        }
    }
    else
        буф = strdup(имяф);
    FindClose(h);
    return буф;
}
}

/**********************************************
 * Write a файл.
 * Возвращает:
 *      0       успех
 */

цел file_write(сим *имя, проц *буфер, бцел len)
{
version(Posix)
{
    цел fd;
    sт_мера numwritten;

    fd = open(имя, O_CREAT | O_WRONLY | O_TRUNC,
            S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP);
    if (fd == -1)
        goto err;

    numwritten = .пиши(fd, буфер, len);
    if (len != numwritten)
        goto err2;

    if (close(fd) == -1)
        goto err;

    return 0;

err2:
    close(fd);
err:
    return 1;
}
else version(Windows)
{
    HANDLE h;
    DWORD numwritten;

    h = CreateFileA(cast(LPCSTR)имя,GENERIC_WRITE,0,null,CREATE_ALWAYS,
        FILE_ATTRIBUTE_NORMAL | FILE_FLAG_SEQUENTIAL_SCAN,null);
    if (h == INVALID_HANDLE_VALUE)
    {
        if (GetLastError() == ERROR_PATH_NOT_FOUND)
        {
            if (!file_createdirs(имя))
            {
                h = CreateFileA(cast(LPCSTR)имя, GENERIC_WRITE, 0, null, CREATE_ALWAYS,
                    FILE_ATTRIBUTE_NORMAL | FILE_FLAG_SEQUENTIAL_SCAN,null);
                if (h != INVALID_HANDLE_VALUE)
                    goto Lok;
            }
        }
        goto err;
    }

Lok:
    if (WriteFile(h,буфер,len,&numwritten,null) != да)
        goto err2;

    if (len != numwritten)
        goto err2;

    if (!CloseHandle(h))
        goto err;
    return 0;

err2:
    CloseHandle(h);
err:
    return 1;
}
}

/********************************
 * Create directories up to имяф.
 * Input:
 *      имя    path/имяф
 * Возвращает:
 *      0       успех
 *      !=0     failure
 */

цел file_createdirs(сим *имя)
{
version(Posix)
{
    return 1;
}
else version(Windows)
{
    auto len = strlen(имя);
    сим *path = cast(сим *)alloca(len + 1);
    сим *p;

    memcpy(path, имя, len + 1);

    for (p = path + len; ; p--)
    {
        if (p == path)
            goto Lfail;
        switch (*p)
        {
            case ':':
            case '/':
            case '\\':
                *p = 0;
                if (!CreateDirectory(cast(LPTSTR)path, null))
                {   // Failed
                    if (file_createdirs(path))
                        goto Lfail;
                    if (!CreateDirectory(cast(LPTSTR)path, null))
                        goto Lfail;
                }
                return 0;
            default:
                continue;
        }
    }

Lfail:
    return 1;
}
}

/***********************************
 * Возвращает:
 *   результат of C library clock()
 */

цел os_clock()
{
    return cast(цел) clock();
}

/***********************************
 * Return size of OS critical section.
 * NOTE: can't use the sizeof() calls directly since cross compiling is
 * supported and would end up using the host sizes rather than the target
 * sizes.
 */



version(Windows)
{
цел os_critsecsize32()
{
    return 24;  // sizeof(CRITICAL_SECTION) for 32 bit Windows
}

цел os_critsecsize64()
{
    return 40;  // sizeof(CRITICAL_SECTION) for 64 bit Windows
}
}
else version(linux)
{
цел os_critsecsize32()
{
    return 24; // sizeof(pthread_mutex_t) on 32 bit
}

цел os_critsecsize64()
{
    return 40; // sizeof(pthread_mutex_t) on 64 bit
}
}

else version(FreeBSD)
{
цел os_critsecsize32()
{
    return 4; // sizeof(pthread_mutex_t) on 32 bit
}

цел os_critsecsize64()
{
    return 8; // sizeof(pthread_mutex_t) on 64 bit
}
}

else version(OpenBSD)
{
цел os_critsecsize32()
{
    return 4; // sizeof(pthread_mutex_t) on 32 bit
}

цел os_critsecsize64()
{
    assert(0);
    return 8; // sizeof(pthread_mutex_t) on 64 bit
}
}
else version(DragonFlyBSD)
{
цел os_critsecsize32()
{
    return 4; // sizeof(pthread_mutex_t) on 32 bit
}

цел os_critsecsize64()
{
    return 8; // sizeof(pthread_mutex_t) on 64 bit
}
}

else version (OSX)
{
цел os_critsecsize32()
{
    version(X86_64)
    {
        assert(pthread_mutex_t.sizeof == 64);
    }
    else
    {
        assert(pthread_mutex_t.sizeof == 44);
    }
    return 44;
}

цел os_critsecsize64()
{
    return 64;
}
}

else version(Solaris)
{
цел os_critsecsize32()
{
    return sizeof(pthread_mutex_t);
}

цел os_critsecsize64()
{
    assert(0);
    return 0;
}
}

/* This is the magic program to get the size on Posix systems:

#if 0
#include <stdio.h>
#include <pthread.h>

цел main()
{
    printf("%d\n", (цел)sizeof(pthread_mutex_t));
    return 0;
}
#endif

#endif
*/
