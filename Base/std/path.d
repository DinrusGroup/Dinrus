module std.path;
pragma(lib, "DinrusStd.lib");
private import stdrus, cidrus;

version(Posix)
{
    private import cidrus;
    private import os.posix;
    private import std.exception: OutOfMemoryException;
}

version(Windows)
{
    alias РАЗДПАП sep ;
    alias АЛЬТРАЗДПАП altsep;
    alias РАЗДПСТР pathsep;
    alias РАЗДСТР linesep; 
    alias ТЕКПАП curdir;	 
    alias РОДПАП pardir; 
}
version(Posix)
{
    const char[1] sep = "/";
    const char[0] altsep;
    const char[1] pathsep = ":";
    const char[1] linesep = "\n";
    const char[1] curdir = ".";	
    const char[2] pardir = "..";
}
version (Windows) alias stdrus.сравнлюб fcmp;

version (Posix) alias std.ткст.cmp fcmp;

alias  извлекиРасш getExt;
alias  дайИмяПути getName;
alias  извлекиПапку getDirName;
alias извлекиИмяПути getBaseName;
alias  извлекиМеткуДиска getDrive;
alias  устДефРасш defaultExt;
alias  добРасш addExt;
alias  абсПуть_ли isabs;
alias  слейПути join; 
alias сравниПути fncharmatch;
alias сравниПутьОбразец fnmatch;  
alias  разверниТильду expandTilde;


//module stdext.path;

//import std.path;
//import std.array;
import std.string;
//import std.conv;

ткст нормализуйПап(ткст пап)
{
	if(пап.length == 0)
		return ".\\";
	пап = replace(пап, "/", "\\");
	if(пап[$-1] == '\\')
		return пап;
	return пап ~ "\\";
}

S normalizePath(S)(S path)
{
	return replace(path, "/", "\\");
}

ткст canonicalPath(ткст path)
{
	return toLower(replace(path, "/", "\\"));
}

ткст makeFilenameAbsolute(ткст file, ткст workdir)
{
	if(!isAbsolute(file) && workdir.length)
	{
		if(file == ".")
			file = workdir;
		else
			file = нормализуйПап(workdir) ~ file;
	}
	return file;
}

void makeFilenamesAbsolute(ткст[] files, ткст workdir)
{
	foreach(ref file; files)
	{
		if(!isAbsolute(file) && workdir.length)
			file = makeFilenameAbsolute(file, workdir);
	}
}

ткст removeDotDotPath(ткст file)
{
	// assumes \\ used as path separator
	for( ; file.length >= 2; )
	{
		// remove duplicate back slashes
		auto pos = indexOf(file[1..$], "\\\\");
		if(pos < 0)
			break;
		file = file[0..pos+1] ~ file[pos + 2 .. $];
	}
	for( ; ; )
	{
		auto pos = indexOf(file, "\\..\\");
		if(pos < 0)
			break;
		auto lpos = lastIndexOf(file[0..pos], '\\');
		if(lpos < 0)
			break;
		file = file[0..lpos] ~ file[pos + 3 .. $];
	}
	for( ; ; )
	{
		auto pos = indexOf(file, "\\.\\");
		if(pos < 0)
			break;
		file = file[0..pos] ~ file[pos + 2 .. $];
	}
	return file;
}

ткст makeFilenameCanonical(ткст file, ткст workdir)
{
	file = makeFilenameAbsolute(file, workdir);
	file = normalizePath(file);
	file = removeDotDotPath(file);
	return file;
}

ткст makeDirnameCanonical(ткст пап, ткст workdir)
{
	пап = makeFilenameAbsolute(пап, workdir);
	пап = нормализуйПап(пап);
	пап = removeDotDotPath(пап);
	return пап;
}

void makeFilenamesCanonical(ткст[] files, ткст workdir)
{
	foreach(ref file; files)
		file = makeFilenameCanonical(file, workdir);
}

void makeDirnamesCanonical(ткст[] dirs, ткст workdir)
{
	foreach(ref пап; dirs)
		пап = makeDirnameCanonical(пап, workdir);
}

ткст quoteFilename(ткст fname)
{
	if(fname.length >= 2 && fname[0] == '\"' && fname[$-1] == '\"')
		return fname;
	if(fname.indexOf('$') >= 0 || indexOf(fname, ' ') >= 0)
		fname = "\"" ~ fname ~ "\"";
	return fname;
}

void quoteFilenames(ткст[] files)
{
	foreach(ref file; files)
	{
		file = quoteFilename(file);
	}
}

ткст quoteNormalizeFilename(ткст fname)
{
	return quoteFilename(normalizePath(fname));
}

ткст getNameWithoutExt(ткст fname)
{
	ткст bname = baseName(fname);
	ткст name = stripExtension(bname);
	if(name.length == 0)
		name = bname;
	return name;
}

ткст safeFilename(ткст fname, ткст rep = "-") // - instead of _ to not possibly be part of a module name
{
	ткст safefile = fname;
	foreach(char ch; ":\\/")
		safefile = replace(safefile, to!ткст(ch), rep);
	return safefile;
}

ткст makeRelative(ткст file, ткст path)
{
	if(!isAbsolute(file))
		return file;
	if(!isAbsolute(path))
		return file;

	file = replace(file, "/", "\\");
	path = replace(path, "/", "\\");
	if(path[$-1] != '\\')
		path ~= "\\";

	ткст lfile = toLower(file);
	ткст lpath = toLower(path);

	int posfile = 0;
	for( ; ; )
	{
		auto idxfile = indexOf(lfile, '\\');
		auto idxpath = indexOf(lpath, '\\');
		assert(idxpath >= 0);

		if(idxfile < 0 || idxfile != idxpath || lfile[0..idxfile] != lpath[0 .. idxpath])
		{
			if(posfile == 0)
				return file;

			// path longer than file path or different subdirs
			ткст res;
			while(idxpath >= 0)
			{
				res ~= "..\\";
				lpath = lpath[idxpath + 1 .. $];
				idxpath = indexOf(lpath, '\\');
			}
			return res ~ file[posfile .. $];
		}

		lfile = lfile[idxfile + 1 .. $];
		lpath = lpath[idxpath + 1 .. $];
		posfile += idxfile + 1;

		if(lpath.length == 0)
		{
			// file longer than path
			return file[posfile .. $];
		}
	}
}

unittest
{
	ткст file = "c:\\a\\bc\\def\\ghi.d";
	ткст path = "c:\\a\\bc\\x";
	ткст res = makeRelative(file, path);
	assert(res == "..\\def\\ghi.d");

	file = "c:\\a\\bc\\def\\ghi.d";
	path = "c:\\a\\bc\\def";
	res = makeRelative(file, path);
	assert(res == "ghi.d");

	file = "c:\\a\\bc\\def\\Ghi.d";
	path = "c:\\a\\bc\\Def\\ggg\\hhh\\iii";
	res = makeRelative(file, path);
	assert(res == "..\\..\\..\\Ghi.d");

	file = "d:\\a\\bc\\Def\\ghi.d";
	path = "c:\\a\\bc\\def\\ggg\\hhh\\iii";
	res = makeRelative(file, path);
	assert(res == file);
}

ткст commonParentDir(ткст path1, ткст path2)
{
	if (path1.length == 0 || path2.length == 0)
		return null;
	ткст p1 = toLower(нормализуйПап(path1));
	ткст p2 = toLower(нормализуйПап(path2));

	while(p2.length)
	{
		if (p1.startsWith(p2))
			return path1[0 .. p2.length]; // preserve case
		ткст q2 = dirName(p2);
		q2 = нормализуйПап(q2);
		if(q2 == p2)
			return null;
		p2 = q2;
	}
	return null;
}

unittest
{
	ткст path1 = "c:\\A\\bc\\def\\ghi.d";
	ткст path2 = "c:\\a/bc\\x";
	ткст res = commonParentDir(path1, path2);
	assert(res == "c:\\A\\bc\\");
}
