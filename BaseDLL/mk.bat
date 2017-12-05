@REM This file was developed for Dinrus Programming Language by Vitaliy Kulich
@REM Copyright is by Dinrus Group.

:back
@REM Setting environment variables
@set this=%DINRUS%\..\dev\DINRUS\BaseDLL
@set R=%DINRUS%\..\imp\dinrus
@set LIBS=%DINRUS%\..\lib\sysimport
@set LDIR=%DINRUS%\..\lib
@set DMD=%DINRUS%\dmd.exe
@set DMC=%DINRUS%\dmc.exe
@set LIB=%DINRUS%\dmlib.exe
@set IMPLIB=%DINRUS%\implib.exe
@set ARCDIR=%this%\..\Arc
@set MINIDDIR=%this%\..\Minid
@set LS=%DINRUS%\ls2.exe
@set PACK=%DINRUS%\upx.exe

::goto Lib

@REM Deleting previous objects
@del %LDIR%\Dinrus.lib
@del %LDIR%\Dinrus.bak
@del %this%\*.rsp
@del %this%\*.obj
@del %this%\*.map
@del %this%\*.dll
@del %this%\base\rt\*.obj
@del %this%\*.lib
@del %this%\*.exe


:Ccode
@REM Compiling C code
%DMC% -c -o%this%\complex.obj %this%\basedll\rt\complex.c -I%DINRUS%\..\include
%DMC% -c  -o%this%\critical.obj %this%\basedll\rt\critical.c -I%DINRUS%\..\include
%DMC% -c  -o%this%\deh.obj %this%\basedll\rt\deh.c -I%DINRUS%\..\include
%DMC% -c  -o%this%\monitor.obj %this%\basedll\rt\monitor.c -I%DINRUS%\..\include

%DMD% -lib -of%this%\Cdinr.lib %this%\complex.obj %this%\critical.obj %this%\deh.obj %this%\monitor.obj

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;
:Base
@REM Make Dinrus.Base.dll


@REM Creating respond file
@REM %this%\base\io\*d %this%\base\io\device\*.d %this%\base\io\stream\*.d
@REM %LS% -d %this%\base\io\*d %this%\base\io\device\*.d %this%\base\io\stream\*.d 
%LS% -d %this%\basedll\*.d %this%\basedll\tpl\*.d %this%\basedll\rt\*.d %this%\basedll\sys\*.d %this%\basedll\sys\inc\*.d %this%\basedll\std\*.d>>%this%\objs.rsp

@if exist %DINRUS%\dinrus.exe %DINRUS%\dinrus.exe

%DMD% -g -O -debug -of%this%\Dinrus.Base_1711_dbg.dll @%this%\objs.rsp %this%\base.def %this%\base.res %LDIR%\minit.obj %LDIR%\import.lib %this%\Cdinr.lib
copy %this%\Dinrus.Base_1711_dbg.dll %DINRUS%

%DMD% -O -release -of%this%\Dinrus.Base_1711.dll @%this%\objs.rsp %this%\base.def %this%\base.res %LDIR%\minit.obj %LDIR%\import.lib %this%\Cdinr.lib
copy %this%\Dinrus.Base_1711.dll %DINRUS%


%IMPLIB% /system %this%\DinrusBaseDLL_dbg.lib %this%\Dinrus.Base_1711_dbg.dll
copy %this%\DinrusBaseDLL_dbg.lib %LDIR%


%IMPLIB% /system %this%\DinrusBaseDLL.lib %this%\Dinrus.Base_1711.dll
copy %this%\DinrusBaseDLL.lib %LDIR%
@del %this%\*.obj %this%\*.rsp %this%\*.map