module util.env;

import cidrus;
version(Posix)
import core.sys.posix.stdlib;
import dmd.globals;
import util.array;
import util.rmem;
import util.string;

version (Windows)
    private extern (C) цел putenv(сим*);

/**
Construct a variable from `имя` and `значение` and put it in the environment while saving
the previous значение of the environment variable into a глоб2 list so it can be restored later.
Параметры:
    имя = the имя of the variable
    значение = the значение of the variable
Возвращает:
    да on error, нет on успех
*/
бул putenvRestorable(ткст имя, ткст значение)
{
    saveEnvVar(имя);
    const nameValue = allocNameValue(имя, значение);
    const результат = putenv(cast(сим*)nameValue.ptr);
    version (Windows)
        mem.xfree(cast(ук)nameValue.ptr);
    else
    {
        if (результат)
            mem.xfree(cast(ук)nameValue.ptr);
    }
    return результат ? да : нет;
}

/**
Allocate a new variable via xmalloc that can be added to the глоб2 environment. The
результатing ткст will be null-terminated immediately after the end of the массив.
Параметры:
    имя = имя of the variable
    значение = значение of the variable
Возвращает:
    a newly allocated variable that can be added to the глоб2 environment
*/
ткст allocNameValue(ткст имя, ткст значение)
{
    const length = имя.length + 1 + значение.length;
    auto str = (cast(сим*)mem.xmalloc(length + 1))[0 .. length];
    str[0 .. имя.length] = имя[];
    str[имя.length] = '=';
    str[имя.length + 1 .. length] = значение[];
    str.ptr[length] = '\0';
    return cast(ткст)str;
}

/// Holds the original values of environment variables when they are overwritten.
private  ткст[ткст] envNameValues;

/// Restore the original environment.
проц restoreEnvVars()
{
    foreach (var; envNameValues.values)
    {
        if (putenv(cast(сим*)var.ptr))
            assert(0);
    }
}

/// Save the environment variable `имя` if not saved already.
проц saveEnvVar(ткст имя)
{
    if (!(имя in envNameValues))
    {
        envNameValues[имя.idup] = allocNameValue(имя, имя.toCStringThen!(/*n =>*/ getenv(n.ptr)).вТкстД);
    }
}
