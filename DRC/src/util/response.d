/**
 * Compiler implementation of the D programming language
 * http://dlang.org
 * This файл is not shared with other compilers which use the DMD front-end.
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 *              Some portions copyright (c) 1994-1995 by Symantec
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/root/response.d, root/_response.d)
 * Documentation:  https://dlang.org/phobos/dmd_root_response.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/root/response.d
 */

module util.response;

import util.file;
import util.filename;

///
alias  responseExpandFrom!(lookupInEnvironment) responseExpand;

/*********************************
 * Expand any response files in command line.
 * Response files are arguments that look like:
 *   @NAME
 * The имена are resolved by calling the 'lookup' function passed as a template
 * параметр. That function is expected to first check the environment and then
 * the файл system.
 * Arguments are separated by spaces, tabs, or newlines. These can be
 * imbedded within arguments by enclosing the argument in "".
 * Backslashes can be используется to эскапируй a ".
 * A line коммент can be started with #.
 * Recursively expands nested response files.
 *
 * To use, put the arguments in a Strings объект and call this on it.
 *
 * Digital Mars's MAKE program can be notified that a program can прими
 * long command строки via environment variables by preceding the rule
 * line for the program with a *.
 *
 * Параметры:
 *     lookup = alias to a function that is called to look up response файл
 *              arguments in the environment. It is expected to прими a null-
 *              terminated ткст and return a mutable ткст that ends with
 *              a null-terminator or null if the response файл could not be
 *              resolved.
 *     args = массив containing arguments as null-terminated strings
 *
 * Возвращает:
 *     да on успех, нет if a response файл could not be expanded.
 */
бул responseExpandFrom(alias lookup)(ref Strings args) 
{
    ткст0 cp;
    бул recurse = нет;

    // i is updated by insertArgumentsFromResponse, so no foreach
    for (т_мера i = 0; i < args.dim;)
    {
        cp = args[i];
        if (cp[0] != '@')
        {
            ++i;
            continue;
        }
        args.удали(i);
        auto буфер = lookup(&cp[1]);
        if (!буфер) {
            /* error         */
            /* BUG: any файл buffers are not free'd   */
            return нет;
        }

        recurse = insertArgumentsFromResponse(буфер, args, i) || recurse;
    }
    if (recurse)
    {
        /* Recursively expand @имяф   */
        if (!responseExpandFrom!(lookup)(args))
            /* error         */
            /* BUG: any файл buffers are not free'd   */
            return нет;
    }
    return да; /* успех         */
}

unittest
{
    ткст testEnvironment(ткст0 str)  
        {
       // import core.stdc.ткст: strlen;
       // import util.string : вТкстД;
        switch (str.вТкстД())
        {
        case "Foo":
            return "foo @Bar #\0".dup;
        case "Bar":
            return "bar @Nil\0".dup;
        case "Error":
            return "@phony\0".dup;
        case "Nil":
            return "\0".dup;
        default:
            return null;
        }
    }
}

unittest
{
    auto args = Strings(4);
    args[0] = "first";
    args[1] = "@Foo";
    args[2] = "@Bar";
    args[3] = "last";

    assert(responseExpand!(testEnvironment)(args));
    assert(args.length == 5);
    assert(args[0][0 .. 6] == "first\0");
    assert(args[1][0 .. 4] == "foo\0");
    assert(args[2][0 .. 4] == "bar\0");
    assert(args[3][0 .. 4] == "bar\0");
    assert(args[4][0 .. 5] == "last\0");
}

unittest
{
    auto args = Strings(2);
    args[0] = "@phony";
    args[1] = "dummy";
    assert(!responseExpand!(testEnvironment)(args));
}

unittest
{
    auto args = Strings(2);
    args[0] = "@Foo";
    args[1] = "@Error";
    assert(!responseExpand!(testEnvironment)(args));
}

/*********************************
 * Take the contents of a response-файл 'буфер', parse it and put the результатing
 * arguments in 'args' at 'argIndex'. 'argIndex' will be updated to point just
 * after the inserted arguments.
 * The logic of this should match that in setargv()
 *
 * Параметры:
 *     буфер = mutable ткст containing the response файл
 *     args = list of arguments
 *     argIndex = position in 'args' where response arguments are inserted
 *
 * Возвращает:
 *     да if another response argument was found
 */
бул insertArgumentsFromResponse(ткст буфер, ref Strings args, ref т_мера argIndex) 
{
    бул recurse = нет;
    бул коммент = нет;

    for (т_мера p = 0; p < буфер.length; p++)
    {
        //ткст0 d;
        т_мера d = 0;
        сим c, lastc;
        бул instring;
        цел numSlashes, nonSlashes;
        switch (буфер[p])
        {
        case 26:
            /* ^Z marks end of файл      */
            return recurse;
        case '\r':
        case '\n':
            коммент = нет;
            goto case;
        case 0:
        case ' ':
        case '\t':
            continue;
            // scan to start of argument
        case '#':
            коммент = да;
            continue;
        case '@':
            if (коммент)
            {
                continue;
            }
            recurse = да;
            goto default;
        default:
            /* start of new argument   */
            if (коммент)
            {
                continue;
            }
            args.вставь(argIndex, &буфер[p]);
            ++argIndex;
            instring = нет;
            c = 0;
            numSlashes = 0;
            for (d = p; 1; p++)
            {
                lastc = c;
                if (p >= буфер.length)
                {
                    буфер[d] = '\0';
                    return recurse;
                }
                c = буфер[p];
                switch (c)
                {
                case '"':
                    /*
                    Yes this looks strange,but this is so that we are
                    MS Compatible, tests have shown that:
                    \\\\"foo bar"  gets passed as \\foo bar
                    \\\\foo  gets passed as \\\\foo
                    \\\"foo gets passed as \"foo
                    and \"foo gets passed as "foo in VC!
                    */
                    nonSlashes = numSlashes % 2;
                    numSlashes = numSlashes / 2;
                    for (; numSlashes > 0; numSlashes--)
                    {
                        d--;
                        буфер[d] = '\0';
                    }
                    if (nonSlashes)
                    {
                        буфер[d - 1] = c;
                    }
                    else
                    {
                        instring = !instring;
                    }
                    break;
                case 26:
                    буфер[d] = '\0'; // terminate argument
                    return recurse;
                case '\r':
                    c = lastc;
                    continue;
                    // ignore
                case ' ':
                case '\t':
                    if (!instring)
                    {
                    case '\n':
                    case 0:
                        буфер[d] = '\0'; // terminate argument
                        goto Lnextarg;
                    }
                    goto default;
                default:
                    if (c == '\\')
                        numSlashes++;
                    else
                        numSlashes = 0;
                    буфер[d++] = c;
                    break;
                }
            }
        }    
    }
    Lnextarg:
    return recurse;
}

unittest
{
    auto args = Strings(4);
    args[0] = "arg0";
    args[1] = "arg1";
    args[2] = "arg2";

    ткст testData = "".dup;
    т_мера index = 1;
    assert(insertArgumentsFromResponse(testData, args, index) == нет);
    assert(index == 1);

    testData = (`\\\\"foo bar" \\\\foo \\\"foo \"foo "\"" # @коммент`~'\0').dup;
    assert(insertArgumentsFromResponse(testData, args, index) == нет);
    assert(index == 6);

    assert(args[1][0 .. 9] == `\\foo bar`);
    assert(args[2][0 .. 7] == `\\\\foo`);
    assert(args[3][0 .. 5] == `\"foo`);
    assert(args[4][0 .. 4] == `"foo`);
    assert(args[5][0 .. 1] == `"`);

    index = 7;
    testData = "\t@recurse # коммент\r\ntab\t\"@recurse\"\x1A after end\0".dup;
    assert(insertArgumentsFromResponse(testData, args, index) == да);
    assert(index == 10);
    assert(args[7][0 .. 8] == "@recurse");
    assert(args[8][0 .. 3] == "tab");
    assert(args[9][0 .. 8] == "@recurse");
}

unittest
{
    auto args = Strings(0);

    ткст testData = "\x1A".dup;
    т_мера index = 0;
    assert(insertArgumentsFromResponse(testData, args, index) == нет);
    assert(index == 0);

    testData = "@\r".dup;
    assert(insertArgumentsFromResponse(testData, args, index) == да);
    assert(index == 1);
    assert(args[0][0 .. 2] == "@\0");

    testData = "ä&#\0".dup;
    assert(insertArgumentsFromResponse(testData, args, index) == нет);
    assert(index == 2);
    assert(args[1][0 .. 5] == "ä&#\0");

    testData = "one@\"word \0".dup;
    assert(insertArgumentsFromResponse(testData, args, index) == нет);
    args[0] = "one@\"word";
}

/*********************************
 * Try to resolve the null-terminated ткст cp to a null-terminated ткст.
 *
 * The имя is first searched for in the environment. If it is not
 * there, it is searched for as a файл имя.
 *
 * Параметры:
 *     cp = null-terminated ткст to look resolve
 *
 * Возвращает:
 *     a mutable, manually allocated массив containing the contents of the environment
 *     variable or файл, ending with a null-terminator.
 *     The null-terminator is inside the bounds of the массив.
 *     If cp could not be resolved, null is returned.
 */
private ткст lookupInEnvironment(ткст0 cp)  {

   // import core.stdc.stdlib: getenv;
   // import core.stdc.ткст: strlen;
   // import util.rmem: mem;

    if (auto p = getenv(cp))
    {
        ткст0 буфер = mem.xstrdup(p);
        return буфер[0 .. strlen(буфер) + 1]; // include null-terminator
    }
    else
    {
        auto readрезультат = Файл.читай(cp);
        if (!readрезультат.успех)
            return null;
        // take ownership of буфер (leaking)
        return cast(ткст) readрезультат.extractDataZ();
    }
}
