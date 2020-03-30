@REM This file was developed for Dinrus Programming Language by Vitaly Kulich
@REM Copyright is by Dinrus Group.

:back
@REM Setting environment variables
@set DEV=%DINRUS%\..\dev\DINRUS
@set this=%DINRUS%\..\dev\DINRUS\DinrusBase
@set IMP=%DINRUS%\..\imp\dinrus
@set LIBS=%DINRUS%\..\lib\sysimport
@set LDIR=%DINRUS%\..\lib

@set DMD=%DINRUS%\dmd.exe
@set DMC=%DINRUS%\dmc.exe
@set LIB=%DINRUS%\dmlib.exe
@set IMPLIB=%DINRUS%\implib.exe
@set LS=%DINRUS%\ls2.exe
@set PACK=%DINRUS%\upx.exe

@set BASE=%this%
@set COMMON=%this%\..\DinrusCommon
@set WIN32=%this%\..\DinrusWin32

@REM Deleting previous objects
::@del %LDIR%\Dinrus.lib
::@del %LDIR%\Dinrus.bak
@del %this%\*.rsp
@del %this%\*.obj
@del %this%\*.map
@del %this%\*.dll
@del %this%\base\rt\*.obj
@del %this%\*.lib
@del %this%\*.exe



:Ccode
@REM Compiling C code
%DMC% -c -o%this%\complex.obj %BASE%\src\rt\complex.c -I%DINRUS%\..\include
%DMC% -c  -o%this%\critical.obj %BASE%\src\rt\critical.c -I%DINRUS%\..\include
%DMC% -c  -o%this%\deh.obj %BASE%\src\rt\deh.c -I%DINRUS%\..\include
%DMC% -c  -o%this%\monitor.obj %BASE%\src\rt\monitor.c -I%DINRUS%\..\include

%LIB% -p256 -c %DEV%\bin\CDinrus.lib %LDIR%\minit.obj %this%\complex.obj %this%\critical.obj %this%\deh.obj %this%\monitor.obj
del %this%\*.obj

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;
:Base

@REM Creating respond file
%LS% -d %BASE%\src\*.d %BASE%\src\tpl\*.d %BASE%\src\rt\*.d %BASE%\src\sys\*.d %BASE%\src\sys\inc\*.d %BASE%\src\std\*.d>>%this%\objs.rsp
@REM Make Dinrus.Base.dll
%DMD% -g -O -debug -of%DEV%\bin\Dinrus.Base.dll @%this%\objs.rsp %BASE%\src\base.def %BASE%\src\base.res  %LDIR%\import.lib %DEV%\bin\Release\CDinrus.lib
copy %DEV%\bin\Dinrus.Base.dll %DINRUS%

%IMPLIB% /system %DEV%\bin\DinrusBaseDLL.lib %DEV%\bin\Dinrus.Base.dll
copy %DEV%\bin\DinrusBaseDLL.lib %LDIR%

@del %this%\*.obj %this%\*.rsp %this%\*.map

exit

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

copy %DEV%\bin\DinrusBaseDLL.lib %DEV%\bin\Dinrus.lib

%LIB% -p256 %DEV%\bin\Dinrus.lib  %DEV%\bin\Release\CDinrus.lib
%LIB% -p256 %DEV%\bin\Dinrus.lib %LDIR%\import.lib 

copy %DEV%\bin\Dinrus.lib %LDIR%\Dinrus_NoStatics.lib
