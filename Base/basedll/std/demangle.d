module std.demangle;

import std.x.demangle;

/*****************************
 * Demangle D mangled names.
 *
 * If it is not a D mangled name, it returns its argument name.
 * Example:
 *	This program reads standard in and writes it to standard out,
 *	pretty-printing any found D mangled names.
-------------------
import std.io;
import std.ctype;
import std.demangle;

int main()
{   char[] buffer;
    bool inword;
    int c;

    while ((c = fgetc(stdin)) != EOF)
    {
	if (inword)
	{
	    if (c == '_' || isalnum(c))
		buffer ~= cast(char) c;
	    else
	    {
		inword = false;
		writef(demangle(buffer), cast(char) c);
	    }
	}
	else
	{   if (c == '_' || isalpha(c))
	    {	inword = true;
		buffer.length = 0;
		buffer ~= cast(char) c;
	    }
	    else
		writef(cast(char) c);
	}
    }
    if (inword)
	writef(demangle(buffer));
    return 0;
}
-------------------
 */



export extern (D):

 ткст разманглируй(ткст имя){return std.x.demangle.demangle(имя);}





unittest
{
    debug(demangle) эхо("demangle.demangle.unittest\n");

    static string[2][] table =
    [
	[ "эхо",	"эхо" ],
	[ "_foo",	"_foo" ],
	[ "_D88",	"_D88" ],
	[ "_D4test3fooAa", "char[] test.foo"],
	[ "_D8demangle8demangleFAaZAa", "char[] demangle.demangle(char[])" ],
	[ "_D6object6Object8opEqualsFC6ObjectZi", "int object.Object.opEquals(class Object)" ],
	[ "_D4test2dgDFiYd", "double delegate(int, ...) test.дг" ],
	[ "_D4test58__T9factorialVde67666666666666860140VG5aa5_68656c6c6fVPvnZ9factorialf", "float test.factorial!(double 4.2, char[5] \"hello\"c, void* null).factorial" ],
	[ "_D4test101__T9factorialVde67666666666666860140Vrc9a999999999999d9014000000000000000c00040VG5aa5_68656c6c6fVPvnZ9factorialf", "float test.factorial!(double 4.2, cdouble 6.8+3i, char[5] \"hello\"c, void* null).factorial" ],
	[ "_D4test34__T3barVG3uw3_616263VG3wd3_646566Z1xi", "int test.bar!(wchar[3] \"abc\"w, dchar[3] \"def\"d).x" ],
	[ "_D8demangle4testFLC6ObjectLDFLiZiZi", "int demangle.test(lazy class Object, lazy int delegate(lazy int))"],
	[ "_D8demangle4testFAiXi", "int demangle.test(int[] ...)"],
	[ "_D8demangle4testFLAiXi", "int demangle.test(lazy int[] ...)"]
    ];

    foreach (i, name; table)
    {
	string r = demangle(name[0]);
        assert(r == name[1],
            "table entry #" ~ toString(i) ~ ": '" ~ name[0] ~ "' demangles as '" ~ r ~ "' but is expected to be '" ~ name[1] ~ "'");

    }
}




