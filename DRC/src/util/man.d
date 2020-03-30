/**
 * Compiler implementation of the D programming language
 * http://dlang.org
 *
 * Copyright: Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:   Walter Bright, http://www.digitalmars.com
 * License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:    $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/root/man.d, root/_man.d)
 * Documentation:  https://dlang.org/phobos/dmd_root_man.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/root/man.d
 */

module util.man;

import cidrus;
version(Posix)
import core.sys.posix.unistd;
else{
import win32.shellapi;
import win32.winuser;
}

version (Windows)
{
     проц browse(ткст0 url)  
    in
    {
        assert(strncmp(url, "http://", 7) == 0 || strncmp(url, "https://", 8) == 0);
    }
    body
    {
        ShellExecuteA(null, "open", url, null, null, SW_SHOWNORMAL);
    }
}
else version (OSX)
{
     проц browse(ткст0 url)  
    in
    {
        assert(strncmp(url, "http://", 7) == 0 || strncmp(url, "https://", 8) == 0);
    }
    body
    {
        pid_t childpid;
        сим*[5] args;
        ткст0 browser = getenv("BROWSER");
        if (browser)
        {
            browser = strdup(browser);
            args[0] = browser;
            args[1] = url;
            args[2] = null;
        }
        else
        {
            args[0] = "open";
            args[1] = url;
            args[2] = null;
        }
        childpid = fork();
        if (childpid == 0)
        {
            execvp(args[0], cast(сим**)args);
            perror(args[0]); // failed to execute
            return;
        }
    }
}
else version (Posix)
{
     проц browse(ткст0 url)  
    in
    {
        assert(strncmp(url, "http://", 7) == 0 || strncmp(url, "https://", 8) == 0);
    }
    body
    {
        pid_t childpid;
        сим*[3] args;
        ткст0 browser = getenv("BROWSER");
        if (browser)
            browser = strdup(browser);
        else
            browser = "xdg-open";
        args[0] = browser;
        args[1] = url;
        args[2] = null;
        childpid = fork();
        if (childpid == 0)
        {
            execvp(args[0], cast(сим**)args);
            perror(args[0]); // failed to execute
            return;
        }
    }
}
