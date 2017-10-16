module std.process;

export extern(D)
{ 

    цел система (ткст команда)
    {
    return cast(цел) system(cast(ткст) команда);
    }
    alias система сис;

    цел пауза()
    {
        система("pause");
         return 0;
    }
    alias пауза пз;

    цел пускпрог(цел режим, ткст путь, ткст[] арги)
    {
    return cast(цел) spawnvp(cast(цел) режим, cast(ткст) путь, cast(ткст[]) арги);
    }

    цел выппрог(ткст путь, ткст[] арги)
    {
    return cast(цел)  execv(cast(ткст) путь, cast(ткст[]) арги);
    }

    цел выппрог(ткст путь, ткст[] арги, ткст[] перемср)
    {
    return cast(цел) execve(cast(ткст) путь, cast(ткст[]) арги, cast(ткст[]) перемср);
    }

    цел выппрогcp(ткст путь, ткст[] арги)
    {
    return cast(цел) execvp(cast(ткст) путь, cast(ткст[]) арги);
    }

    цел выппрогср(ткст путь, ткст[] арги, ткст[] перемср)
    {
    return cast(цел) execve(cast(ткст) путь, cast(ткст[]) арги, cast(ткст[]) перемср);
    }
}

//////////////////////////////////////
private import std.string;
private import cidrus;

extern(C)
{
    int spawnl(int, char *, char *,...);
    int spawnle(int, char *, char *,...);
    int spawnlp(int, char *, char *,...);
    int spawnlpe(int, char *, char *,...);
    int spawnv(int, char *, char **);
    int spawnve(int, char *, char **, char **);
    int spawnvp(int, char *, char **);
    int spawnvpe(int, char *, char **, char **);
    int execl(char *, char *,...);
int execle(char *, char *,...);
int execlp(char *, char *,...);
int execlpe(char *, char *,...);
int execv(char *, char **);
int execve(char *, char **, char **);
int execvp(char *, char **);
int execvpe(char *, char **, char **);
}
enum { _P_WAIT, _P_NOWAIT, _P_OVERLAY };


/**
 * Execute command in a _command shell.
 *
 * Returns: exit status of command
 */

int system(string command)
{
    return cidrus.система(command);
}

private void toAStringz(char[][] a, char**az)
{
    foreach(char[] s; a)
    {
        *az++ = toStringz(s);
    }
    *az = null;
}


/* ========================================================== */

//version (Windows)
//{
//    int spawnvp(int mode, string pathname, string[] argv)
//    {
//  char** argv_ = cast(char**)alloca((char*).sizeof * (1 + argv.length));
//
//  toAStringz(argv, argv_);
//
//  return spawnvp(mode, toStringz(pathname), argv_);
//    }
//}

// Incorporating idea (for spawnvp() on linux) from Dave Fladebo

alias _P_WAIT P_WAIT;
alias _P_NOWAIT P_NOWAIT;

int spawnvp(int mode, string pathname, string[] argv)
{
    auto argv_ = cast(char**)alloca((char*).sizeof * (1 + argv.length));

    toAStringz(argv, argv_);

    version (Posix)
    {
        return _spawnvp(mode, toStringz(pathname), argv_);
    }
    else
    {
        return spawnvp(mode, toStringz(pathname), argv_);
    }
}

version (Posix)
{
private import os.posix;
int _spawnvp(int mode, char *pathname, char **argv)
{
    int retval = 0;
    pid_t pid = fork();

    if(!pid)
    {   // child
        execvp(pathname, argv);
        goto Lerror;
    }
    else if(pid > 0)
    {   // parent
        if(mode == _P_NOWAIT)
        {
            retval = pid; // caller waits
        }
        else
        {
            while(1)
            {
                int status;
                pid_t wpid = waitpid(pid, &status, 0);
                if(exited(status))
                {
                    retval = exitstatus(status);
                    break;
                }
                else if(signaled(status))
                {
                    retval = -termsig(status);
                    break;
                }
                else if(stopped(status)) // ptrace support
                    continue;
                else
                    goto Lerror;
            }
        }

        return retval;
    }

Lerror:
    retval = getErrno;
    char[80] buf = void;
    throw new Exception(
        "Не удалось ответвить " ~ toString(pathname) ~ "; "
                      ~ toString(strerror_r(retval, buf.ptr, buf.length))
                      ~ " [ошном " ~ toString(retval) ~ "]");
}   // _spawnvp
private
{
bool stopped(int status)    { return cast(bool)((status & 0xff) == 0x7f); }
bool signaled(int status)   { return cast(bool)((cast(char)((status & 0x7f) + 1) >> 1) > 0); }
int  termsig(int status)    { return status & 0x7f; }
bool exited(int status)     { return cast(bool)((status & 0x7f) == 0); }
int  exitstatus(int status) { return (status & 0xff00) >> 8; }
}   // private
}   // version (Posix)

/* ========================================================== */

/**
 * Execute program specified by pathname, passing it the arguments (argv)
 * and the environment (envp), returning the exit status.
 * The 'p' versions of exec search the PATH environment variable
 * setting for the program.
 */
int execv(string pathname, string[] argv)
{
    auto argv_ = cast(char**)alloca((char*).sizeof * (1 + argv.length));

    toAStringz(argv, argv_);

    return execv(toStringz(pathname), argv_);
}

/** ditto */
int execve(string pathname, string[] argv, string[] envp)
{
    auto argv_ = cast(char**)alloca((char*).sizeof * (1 + argv.length));
    auto envp_ = cast(char**)alloca((char*).sizeof * (1 + envp.length));

    toAStringz(argv, argv_);
    toAStringz(envp, envp_);

    return execve(toStringz(pathname), argv_, envp_);
}

/** ditto */
int execvp(string pathname, string[] argv)
{
    auto argv_ = cast(char**)alloca((char*).sizeof * (1 + argv.length));

    toAStringz(argv, argv_);

    return execvp(toStringz(pathname), argv_);
}

/** ditto */
int execvpe(string pathname, string[] argv, string[] envp)
{
version (Posix)
{
    // Is pathname rooted?
    if(pathname[0] == '/')
    {
        // Yes, so just call execve()
        return execve(pathname, argv, envp);
    }
    else
    {
        // No, so must traverse PATHs, looking for first match
    string[]    envPaths    =   std.string.split(std.string.toString(cidrus.дайсреду("PATH")), ":");
        int         iRet        =   0;

        // Note: if any call to execve() succeeds, this process will cease 
        // execution, so there's no need to check the execve() результат through
        // the loop.

        foreach(string pathDir; envPaths)
        {
            string  composite   =  pathDir ~ "/" ~ pathname;

            iRet = execve(composite, argv, envp);
        }
        if(0 != iRet)
        {
            iRet = execve(pathname, argv, envp);
        }

        return iRet;
    }
}
else version(Windows)
{
    auto argv_ = cast(char**)alloca((char*).sizeof * (1 + argv.length));
    auto envp_ = cast(char**)alloca((char*).sizeof * (1 + envp.length));

    toAStringz(argv, argv_);
    toAStringz(envp, envp_);

    return execvpe(toStringz(pathname), argv_, envp_);
}
else
{
    static assert(0);
} // version
}

/* ////////////////////////////////////////////////////////////////////////// */

version(MainTest)
{
    int main(string[] args)
    {
        if(args.length < 2)
        {
            эхо("Must supply executable (and optional arguments)\n");

            return 1;
        }
        else
        {
            string[]    dummy_env;
            
            dummy_env ~= "VAL0=value";
            dummy_env ~= "VAL1=value";

/+
            foreach(string арг; args)
            {
                эхо("%.*s\n", арг);
            }
+/

//          int i = execv(args[1], args[1 .. args.length]);
//          int i = execvp(args[1], args[1 .. args.length]);
            int i = execvpe(args[1], args[1 .. args.length], dummy_env);

            эхо("exec??() has returned! Error code: %d; errno: %d\n", i, /* getErrno() */-1);

            return 0;
        }
    }
}
