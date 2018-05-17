module test;

import dwt.internal.gtk.c.cairo;
import tango.core.Traits;
import tango.io.Stdout;
import tango.stdc.stdio;

struct lock {
static void lock() { printf("lock\n");}
static void unlock() { printf("unlock\n");}
}

const static char[] mm = "Inside outer cairo_version";

template NameOfFunc(alias f) {
    // Note: highly dependent on the .stringof formatting
    // the value begins with "& " which is why the first two chars are cut off
    const char[] NameOfFunc = (&f).stringof[2 .. $];
}

template ForwardGtkOsCFunc( alias cFunc ) {
    alias ParameterTupleOf!(cFunc) P;
    alias ReturnTypeOf!(cFunc) R;
    mixin("public static R " ~ NameOfFunc!(cFunc) ~ "( P p ){
        lock.lock();
        scope(exit) lock.unlock();
        Stdout (mm).newline; 
        return cFunc(p);
    }");
}

public class OS  {
    mixin ForwardGtkOsCFunc!(cairo_version);
    mixin ForwardGtkOsCFunc!(cairo_version_string);
}

void main()
{
    Stdout ("calling cairo_version...").newline;
    int p = OS.cairo_version();
    int i = cairo_version();
    Stdout.formatln("OS.cairo_version() returns: {}    cairo_version() returns: {}", p, i ).newline;
    printf("OS.cairo_version_string returns: %s\n",  cairo_version_string() );
}
