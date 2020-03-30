/**
 * Interface to the C linked list тип.
 *
 * List is a complete package of functions to deal with singly linked
 * lists of pointers or integers.
 * Features:
 *      1. Uses mem package.
 *      2. Has loop-back tests.
 *      3. Each item in the list can have multiple predecessors, enabling
 *         different lists to 'share' a common tail.
 *
 * Copyright:   Copyright (C) 1986-1990 by Northwest Software
 *              Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/dlist.d, backend/dlist.d)
 */

module drc.backend.dlist;

import cidrus;

/*extern (C++):*/


//
//{

/* **************** TYPEDEFS AND DEFINES ****************** */

struct LIST
{
        /* Do not access items in this struct directly, use the         */
        /* functions designed for that purpose.                         */
        LIST* следщ;             /* следщ element in list                 */
        цел count;              /* when 0, element may be deleted       */
        union
        {       ук ptr;      /* данные pointer                         */
                цел данные;
        }
}

alias  LIST* list_t;             /* pointer to a list entry              */

/* FPNULL is a null function pointer designed to be an argument to
 * list_free().
 */

alias проц function(ук) list_free_fp;

const FPNULL = cast(list_free_fp)null;

/* **************** PUBLIC VARIABLES ********************* */



    цел list_inited;         // != 0 if list package is initialized
    list_t list_freelist;
    цел nlist;


/* **************** PUBLIC FUNCTIONS ********************* */

/********************************
 * Create link to existing list, that is, share the list with
 * somebody else.
 *
 * Возвращает:
 *    pointer to that list entry.
 */

list_t list_link(list_t list)
{
    if (list)
        ++list.count;
    return list;
}

/********************************
 * Возвращает:
 *    pointer to следщ entry in list.
 */

list_t list_next(list_t list) { return list.следщ; }

/********************************
 * Возвращает:
 *    ptr from list entry.
 */

ук list_ptr(inout list_t list) { return list.ptr; }

/********************************
 * Возвращает:
 *    integer item from list entry.
 */

цел list_data(list_t list) { return list.данные; }

/********************************
 * Append integer item to list.
 */

проц list_appenddata(list_t* plist, цел d)
{
    list_append(plist, null).данные = d;
}

/********************************
 * Prepend integer item to list.
 */

проц list_prependdata(list_t *plist,цел d)
{
    list_prepend(plist, null).данные = d;
}

/**********************
 * Initialize list package.
 * Output:
 *      list_inited = 1
 */

проц list_init()
{
    if (list_inited == 0)
    {
        nlist = 0;
        list_inited++;
    }
}

/*******************
 * Terminate list package.
 * Output:
 *      list_inited = 0
 */

проц list_term()
{
    if (list_inited)
    {
        debug printf("Max # of lists = %d\n",nlist);
        while (list_freelist)
        {
            list_t list = list_next(list_freelist);
            list_delete(list_freelist);
            list_freelist = list;
            nlist--;
        }
        debug if (nlist)
            printf("nlist = %d\n",nlist);
        assert(nlist == 0);
        list_inited = 0;
    }
}


list_t list_alloc()
{
    list_t list;

    if (list_freelist)
    {
        list = list_freelist;
        list_freelist = list_next(list);
        //mem_setnewfileline(list,файл,line);
    }
    else
    {
        nlist++;
        list = list_new();
    }
    return list;
}

list_t list_alloc(ткст0 файл, цел line)
{
    return list_alloc();
}


list_t list_new() { return cast(list_t)malloc(LIST.sizeof); }
проц list_delete(list_t list) { free(list); }

/********************
 * Free list.
 * Параметры:
 *      plist =         Pointer to list to free
 *      freeptr =       Pointer to freeing function for the данные pointer
 *                      (use FPNULL if none)
 * Output:
 *      *plist is null
 */

проц list_free(list_t* plist, list_free_fp freeptr)
{
    list_t list = *plist;
    *plist = null;             // block any circular reference bugs
    while (list && --list.count == 0)
    {
        list_t listnext = list_next(list);
        if (freeptr)
            (*freeptr)(list_ptr(list));
        debug memset(list, 0, (*list).sizeof);
        list.следщ = list_freelist;
        list_freelist = list;
        list = listnext;
    }
}

проц list_free(list_t *l)
{
     list_free(l, FPNULL);
}

/***************************
 * Remove ptr from the list pointed to by *plist.
 * Output:
 *      *plist is updated to be the start of the new list
 * Возвращает:
 *      null if *plist is null
 *      otherwise ptr
 */

ук list_subtract(list_t* plist, ук ptr)
{
    list_t list;

    while ((list = *plist) != null)
    {
        if (list_ptr(list) == ptr)
        {
            if (--list.count == 0)
            {
                *plist = list_next(list);
                list.следщ = list_freelist;
                list_freelist = list;
            }
            return ptr;
        }
        else
            plist = &list.следщ;
    }
    return null;            // it wasn't in the list
}

/***************************
 * Remove first element in list pointed to by *plist.
 * Возвращает:
 *      First element, null if *plist is null
 */

ук list_pop(list_t* plist)
{
    return list_subtract(plist, list_ptr(*plist));
}

/*************************
 * Append ptr to *plist.
 * Возвращает:
 *      pointer to list item created.
 *      null if out of memory
 */

list_t list_append(list_t* plist, ук ptr)
{
    while (*plist)
        plist = &(*plist).следщ;   // найди end of list

    list_t list = list_alloc();
    if (list)
    {
        *plist = list;
        list.следщ = null;
        list.ptr = ptr;
        list.count = 1;
    }
    return list;
}

list_t list_append_debug(list_t* plist, ук ptr, ткст0 файл, цел line)
{
    return list_append(plist, ptr);
}

/*************************
 * Prepend ptr to *plist.
 * Возвращает:
 *      pointer to list item created (which is also the start of the list).
 *      null if out of memory
 */

list_t list_prepend(list_t *plist, проц *ptr)
{
    list_t list = list_alloc();
    if (list)
    {
        list.следщ = *plist;
        list.ptr = ptr;
        list.count = 1;
        *plist = list;
    }
    return list;
}

/*************************
 * Count up and return number of items in list.
 * Возвращает:
 *      # of entries in list
 */

цел list_nitems(list_t list)
{
    цел n = 0;
    foreach (l; ListRange(list))
    {
        ++n;
    }
    return n;
}

/*************************
 * Возвращает:
 *    nth list entry in list.
 */

list_t list_nth(list_t list, цел n)
{
    for (цел i = 0; i < n; i++)
    {
        assert(list);
        list = list_next(list);
    }
    return list;
}

/***********************
 * Возвращает:
 *    last list entry in list.
 */

list_t list_last(list_t list)
{
    if (list)
        while (list_next(list))
            list = list_next(list);
    return list;
}

/********************************
 * Возвращает:
 *    pointer to previous item in list.
 */

list_t list_prev(list_t start, list_t list)
{
    if (start)
    {
        if (start == list)
            start = null;
        else
            while (list_next(start) != list)
            {
                start = list_next(start);
                assert(start);
            }
    }
    return start;
}

/***********************
 * Copy a list and return it.
 */

list_t list_copy(list_t list)
{
    list_t c = null;
    for (; list; list = list_next(list))
        list_append(&c,list_ptr(list));
    return c;
}

/************************
 * Compare two lists.
 * Возвращает:
 *      If they have the same ptrs, return 1 else 0.
 */

цел list_equal(list_t list1, list_t list2)
{
    while (list1 && list2)
    {
        if (list_ptr(list1) != list_ptr(list2))
            break;
        list1 = list_next(list1);
        list2 = list_next(list2);
    }
    return list1 == list2;
}

/************************
 * Compare two lists using the comparison function fp.
 * The comparison function is the same as используется for qsort().
 * Возвращает:
 *    If they compare equal, return 0 else значение returned by fp.
 */

цел list_cmp(list_t list1, list_t list2, цел function(ук, ук) fp)
{
    цел результат = 0;

    while (1)
    {
        if (!list1)
        {   if (list2)
                результат = -1;    /* list1 < list2        */
            break;
        }
        if (!list2)
        {   результат = 1;         /* list1 > list2        */
            break;
        }
        результат = (*fp)(list_ptr(list1),list_ptr(list2));
        if (результат)
            break;
        list1 = list_next(list1);
        list2 = list_next(list2);
    }
    return результат;
}

/*************************
 * Search for ptr in list.
 * Возвращает:
 *    If found, return list entry that it is, else null.
 */

list_t list_inlist(list_t list, ук ptr)
{
    foreach (l; ListRange(list))
        if (l.ptr == ptr)
            return l;
    return null;
}

/*************************
 * Concatenate two lists (l2 appended to l1).
 * Output:
 *      *pl1 updated to be start of concatenated list.
 * Возвращает:
 *      *pl1
 */

list_t list_cat(list_t *pl1, list_t l2)
{
    list_t *pl;
    for (pl = pl1; *pl; pl = &(*pl).следщ)
    { }
    *pl = l2;
    return *pl1;
}

/***************************************
 * Apply a function fp to each member of a list.
 */

проц list_apply(list_t* plist, проц function(ук)  fp)
{
    if (fp)
        foreach (l; ListRange(*plist))
        {
            (*fp)(list_ptr(l));
        }
}

/********************************************
 * Reverse a list in place.
 */

list_t list_reverse(list_t l)
{
    list_t r = null;
    while (l)
    {
        list_t ln = list_next(l);
        l.следщ = r;
        r = l;
        l = ln;
    }
    return r;
}


/**********************************************
 * Copy list of pointers into an массив of pointers.
 */

проц list_copyinto(list_t l, проц *pa)
{
    проц **ppa = cast(проц **)pa;
    for (; l; l = l.следщ)
    {
        *ppa = l.ptr;
        ++ppa;
    }
}

/**********************************************
 * Insert item into list at nth position.
 */

list_t list_insert(list_t *pl,проц *ptr,цел n)
{
    list_t list;

    while (n)
    {
        pl = &(*pl).следщ;
        n--;
    }
    list = list_alloc();
    if (list)
    {
        list.следщ = *pl;
        *pl = list;
        list.ptr = ptr;
        list.count = 1;
    }
    return list;
}

/********************************
 * Range for Lists.
 */
class ListRange
{

    this(list_t li)
    {
        this.li = li;
    }

    list_t front() { return li; }
    проц popFront() { li = li.следщ; }
    бул empty(){ return !li; }

  private:
    list_t li;
}

/* The following function should be  , too, but on
 * some platforms core.stdc.stdarg is not fully  .
 */

/*************************
 * Build a list out of the null-terminated argument list.
 * Возвращает:
 *      generated list
 */

list_t list_build(проц *p,...)
{
    va_list ap;

    list_t alist = null;
    list_t *pe = &alist;
    for (va_start(ap,p); p; p = va_arg!(ук)(ap))
    {
        list_t list = list_alloc();
        if (list)
        {
            list.следщ = null;
            list.ptr = p;
            list.count = 1;
            *pe = list;
            pe = &list.следщ;
        }
    }
    va_end(ap);
    return alist;
}


