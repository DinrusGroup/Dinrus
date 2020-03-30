/*_ filespec.h   Fri Jul  8 1988   Modified by: bright */
/* Copyright (C) 1986-1987 by Northwest Software        */
/* All Rights Reserved                                  */
/* Written by Walter Bright                             */

import cidrus;

import drc.backend.mem;

/*extern (C++):*/



/*********************************
 * String compare of filenames.
 */

version (Windows)
{
    extern (C)
    {
        цел stricmp(сим*, сим*);
        цел memicmp(ук, ук, т_мера);
    }

    alias stricmp filespeccmp;
    alias memicmp filespecmemcmp;

    const DIRCHAR = '\\';

    бул ispathdelim(сим c) { return c == DIRCHAR || c == ':' || c == '/'; }
}
else
{
    import core.stdc.ткст : strcmp, memcmp;
    alias  strcmp filespeccmp;
    alias  memcmp filespecmemcmp;

    const DIRCHAR = '/';

    бул ispathdelim(сим c) { return c == DIRCHAR; }
}

/****************************
 * Combine path and имяф to form a filespec.
 * Input:
 *      path            Path, with or without trailing /
 *                      (can be NULL)
 *      имяф        Cannot be NULL
 * Возвращает:
 *      filespec        mem_malloc'd файл specification
 *      NULL            Out of memory
 */

сим *filespecaddpath(ткст0 path, ткст0 имяф)
{
    ткст0 filespec;
    т_мера pathlen;

    if (!path || (pathlen = strlen(path)) == 0)
        filespec = mem_strdup(имяф);
    else
    {
        filespec = cast(сим*) mem_malloc(pathlen + 1 + strlen(имяф) + 1);
        if (filespec)
        {
            strcpy(filespec,path);
version (Windows)
{
            if (!ispathdelim(filespec[pathlen - 1]))
                strcat(filespec,"\\");
}
else
{
            if (!ispathdelim(filespec[pathlen - 1]))
                strcat(filespec,"/");
}
            strcat(filespec,имяф);
        }
    }
    return filespec;
}

/******************************* filespecrootpath **************************
 * Purpose: To expand a relative path into an absolute path.
 *
 * Side Effects: mem_frees input ткст.
 *
 * Возвращает: mem_malloced ткст with absolute path.
 *          NULL if some failure.
 */

version (Windows)
    extern (C) ткст0 getcwd(сим*, т_мера);
else
{
    import core.sys.posix.unistd: getcwd;
}

сим *filespecrootpath(ткст0 filespec)
{
    сим *cwd;
    сим *cwd_t;
    сим *p;
    сим *p2;

    if (!filespec)
        return filespec;
version (Windows)
{
    // if already absolute (with \ or drive:) ...
    if (*filespec == DIRCHAR || (isalpha(*filespec) && *(filespec+1) == ':'))
        return filespec;        //      ... return input ткст
}
else
{
    if (*filespec == DIRCHAR)   // already absolute ...
        return filespec;        //      ... return input ткст
}

    // get current working directory path
version (Windows)
{
    сим[132] cwd_d = проц;
    if (getcwd(cwd_d.ptr, cwd_d.length))
       cwd_t = cwd_d.ptr;
    else
       cwd_t = null;
}
else
{
    cwd_t = cast(сим *)getcwd(null, 256);
}

    if (cwd_t == null)
    {
        mem_free(filespec);
        return null;    // error - path too long (more than 256 chars !)
    }
    cwd = mem_strdup(cwd_t);    // convert cwd to mem package
version (Windows)
{
}
else
{
    free(cwd_t);
}
    p = filespec;
    while (p != null)
    {
        p2 = cast(сим*)strchr(p, DIRCHAR);
        if (p2 != null)
        {
            *p2 = '\0';
            if (strcmp(p, "..") == 0)   // move up cwd
                // удали last directory from cwd
                *(cast(сим *)strrchr(cwd, DIRCHAR)) = '\0';
            else if (strcmp(p, ".") != 0) // not current directory
            {
                cwd_t = cwd;
                cwd = cast(сим *)mem_calloc(strlen(cwd_t) + 1 + strlen(p) + 1);
                sprintf(cwd, "%s%c%s", cwd_t, DIRCHAR, p);  // add relative directory
                mem_free(cwd_t);
            }
            // else if ".", then ignore - it means current directory
            *p2 = DIRCHAR;
            p2++;
        }
        else if (strcmp(p,"..") == 0)   // move up cwd
        {
            // удали last directory from cwd
            *(cast(сим *)strrchr(cwd, DIRCHAR)) = '\0';
        }
        else if (strcmp(p,".") != 0) // no more subdirectories ...
        {   // ... save remaining ткст
            cwd_t = cwd;
            cwd = cast(сим *)mem_calloc(strlen(cwd_t) + 1 + strlen(p) + 1);
            sprintf(cwd, "%s%c%s", cwd_t, DIRCHAR, p);  // add relative directory
            mem_free(cwd_t);
        }
        p = p2;
    }
    mem_free(filespec);

    return cwd;
}

/*****************************
 * Add extension onto filespec, if one isn't already there.
 * Input:
 *      filespec        Cannot be NULL
 *      ext             Extension (without the .)
 * Возвращает:
 *      mem_malloc'ed ткст (NULL if error)
 */

сим *filespecdefaultext(ткст0 filespec, ткст0 ext)
{
    сим *p;

    ткст0 pext = filespecdotext(filespec);
    if (*pext == '.')               /* if already got an extension  */
    {
        p = mem_strdup(filespec);
    }
    else
    {
        const n = pext - filespec;
        p = cast(сим *) mem_malloc(n + 1 + strlen(ext) + 1);
        if (p)
        {
            memcpy(p,filespec,n);
            p[n] = '.';
            strcpy(&p[n + 1],ext);
        }
    }
    return p;
}

/**********************
 * Return ткст that is the dot and extension.
 * The ткст returned is NOT mem_malloc'ed.
 * Return pointer to the 0 at the end of filespec if dot isn't found.
 * Return NULL if filespec is NULL.
 */

сим *filespecdotext(ткст0 filespec)
{
    auto p = filespec;
    if (p)
    {
        const len = strlen(p);
        p += len;
        while (1)
        {
            if (*p == '.')
                break;
            if (p <= filespec || ispathdelim(*p))
            {   p = filespec + len;
                break;
            }
            p--;
        }
    }
    return cast(сим*)p;
}

/*****************************
 * Force extension onto filespec.
 * Input:
 *      filespec        String that may or may not contain an extension
 *      ext             Extension that doesn't contain a .
 * Возвращает:
 *      mem_malloc'ed ткст (NULL if error)
 *      NULL if filespec is NULL
 *      If ext is NULL, return mem_strdup(filespec)
 */

сим *filespecforceext(ткст0 filespec, ткст0 ext)
{
    ткст0 p;

    if (ext && *ext == '.')
        ext++;
    if ((p = cast(сим *)filespec) != null)
    {
        ткст0 pext = filespecdotext(filespec);
        if (ext)
        {
            т_мера n = pext - filespec;
            p = cast(сим*) mem_malloc(n + 1 + strlen(ext) + 1);
            if (p)
            {
                memcpy(p, filespec, n);
                p[n] = '.';
                strcpy(&p[n + 1],ext);
            }
        }
        else
            p = mem_strdup(filespec);
    }
    return p;
}

/***********************
 * Get root имя of файл имя.
 * That is, return a mem_strdup()'d version of the имяф without
 * the .ext.
 */

сим *filespecgetroot(ткст0 имя)
{
    ткст0 p = filespecdotext(имя);
    const c = *p;
    *p = 0;
    ткст0 root = mem_strdup(имя);
    *p = c;
    return root;
}

/**********************
 * Return ткст that is the имяф plus dot and extension.
 * The ткст returned is NOT mem_malloc'ed.
 */

сим *filespecname(ткст0 filespec)
{
    ткст0 p;

    /* Start at end of ткст and back up till we найди the beginning
     * of the имяф or a path
     */
    for (p = filespec + strlen(filespec);
         p != filespec && !ispathdelim(*(p - 1));
         p--
        )
    { }
    return cast(сим *)p;
}

/************************************
 * If first character of filespec is a ~, perform tilde-expansion.
 * Output:
 *      Input filespec is mem_free'd.
 * Возвращает:
 *      mem_malloc'd ткст
 */

version (Windows)
{
    сим *filespectilde(сим *f) { return f; }
}
else
{
    сим *filespectilde(сим *);
}

/************************************
 * Expand all ~ in the given ткст.
 *
 * Output:
 *      Input filespec is mem_free'd.
 * Возвращает:
 *      mem_malloc'd ткст
 */

version (Windows)
{
    сим *filespecmultitilde(сим *f) { return f; }
}
else
{
    сим *filespecmultitilde(сим *);
}

/*****************************
 * Convert filespec into a backup имяф appropriate for the
 * operating system. For instance, under MS-DOS path\имяф.ext will
 * be converted to path\имяф.bak.
 * Input:
 *      filespec        String that may or may not contain an extension
 * Возвращает:
 *      mem_malloc'ed ткст (NULL if error)
 *      NULL if filespec is NULL
 */

сим *filespecbackup(ткст0 filespec)
{
version (Windows)
{
    return filespecforceext(filespec,"BAK");
}
else
{
    ткст0 p;
    ткст0 f;

    // Prepend .B to файл имя, if it isn't already there
    if (!filespec)
        return cast(сим *)filespec;
    p = filespecname(filespec);
    if (p[0] == '.' && p[1] == 'B')
        return mem_strdup(filespec);
    f = cast(сим *) mem_malloc(strlen(filespec) + 2 + 1);
    if (f)
    {   strcpy(f,filespec);
        strcpy(&f[p - filespec],".B");
        strcat(f,p);
    }
    return f;
}
}

