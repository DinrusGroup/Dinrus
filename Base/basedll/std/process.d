module std.process;
   import std.x.process;

export extern(D)
{ 

    цел система (ткст команда)
    {
    return cast(цел) std.x.process.system(cast(ткст) команда);
    }

    цел пауза()
    {
        система("pause");
         return 0;
    }

    цел пускпрог(цел режим, ткст путь, ткст[] арги)
    {
    return cast(цел) std.x.process.spawnvp(cast(цел) режим, cast(ткст) путь, cast(ткст[]) арги);
    }

    цел выппрог(ткст путь, ткст[] арги)
    {
    return cast(цел)  std.x.process.execv(cast(ткст) путь, cast(ткст[]) арги);
    }

    цел выппрог(ткст путь, ткст[] арги, ткст[] перемср)
    {
    return cast(цел) std.x.process.execve(cast(ткст) путь, cast(ткст[]) арги, cast(ткст[]) перемср);
    }

    цел выппрогcp(ткст путь, ткст[] арги)
    {
    return cast(цел) std.x.process.execvp(cast(ткст) путь, cast(ткст[]) арги);
    }

    цел выппрогср(ткст путь, ткст[] арги, ткст[] перемср)
    {
    return cast(цел) std.x.process.execve(cast(ткст) путь, cast(ткст[]) арги, cast(ткст[]) перемср);
    }
}