﻿module tpl.all;

public import	     tpl.args,
					tpl.alloc,	
					tpl.signal,
					tpl.metastrings,
					tpl.traits,
					tpl.typetuple,
					tpl.bind,
					tpl.minmax,
					tpl.box,
					tpl.singleton,
					 std.stream,
					 tpl.weakref
					 ;
					 
version(COM)
{
public import tpl.com;// Импортируется отдельно, если COM нужен.
}