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

%DMD% -lib -of%DEV%\bin\Release\CDinrus.lib %LDIR%\minit.obj %this%\complex.obj %this%\critical.obj %this%\deh.obj %this%\monitor.obj
del %this%\*.obj

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;
:Base

@REM Creating respond file
%LS% -d %BASE%\src\*.d %BASE%\src\tpl\*.d %BASE%\src\rt\*.d %BASE%\src\sys\*.d %BASE%\src\sys\inc\*.d %BASE%\src\std\*.d>>%this%\objs.rsp
@REM Make Dinrus.Base.dll
%DMD% -g -O -debug -of%DEV%\bin\Debug\Dinrus.Base_1803_dbg.dll @%this%\objs.rsp %BASE%\src\base.def %BASE%\src\base.res  %LDIR%\import.lib %DEV%\bin\Release\CDinrus.lib
::copy %this%\Dinrus.Base_1803_dbg.dll %DINRUS%

%DMD% -O -release -of%DEV%\bin\Release\Dinrus.Base_1803.dll @%this%\objs.rsp %BASE%\src\base.def %BASE%\src\base.res %LDIR%\import.lib %DEV%\bin\Release\CDinrus.lib
::copy %this%\Dinrus.Base_1803.dll %DINRUS%


%IMPLIB% /system %DEV%\bin\Debug\DinrusBaseDLL_dbg.lib %DEV%\bin\Debug\Dinrus.Base_1803_dbg.dll
::copy %this%\DinrusBaseDLL_dbg.lib %LDIR%


%IMPLIB% /system %DEV%\bin\Release\DinrusBaseDLL.lib %DEV%\bin\Release\Dinrus.Base_1803.dll
::copy %this%\DinrusBaseDLL.lib %LDIR%
@del %this%\*.obj %this%\*.rsp %this%\*.map

exit

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

copy %this%\DinrusBaseDLL.lib %this%\DinrusBaseDLL1.lib
copy %this%\DinrusBaseDLL_dbg.lib %this%\DinrusBaseDLL_dbg1.lib
ren DinrusBaseDLL1.lib Dinrus.lib
ren DinrusBaseDLL_dbg1.lib Dinrus_dbg.lib

%LIB% -p256 %this%\Dinrus.lib  %COMMON%\bin\Release\DinrusCommon.lib
%LIB% -p256 %this%\Dinrus.lib %LDIR%\import.lib 

%LIB% -p256 %this%\Dinrus_dbg.lib  %COMMON%\bin\Debug\DinrusCommon_dbg.lib
%LIB% -p256 %this%\Dinrus_dbg.lib %LDIR%\import.lib 

copy %this%\DinrusDbg.lib %LDIR%\
copy %this%\Dinrus.lib %LDIR%\

:::::::::::::::::::::::::::::::::::::::
::create folder %DINRUS%/../imp/dinrus
if not exist %IMP% mkdir %IMP%
::copy files from DinrusWin32
if not exist %IMP%\win32 mkdir %IMP%\win32
if not exist %IMP%\win32\directx mkdir %IMP%\win32\directx
del %IMP%\win32\*.di
copy %WIN32%\src\*.d  %IMP%\win32\*.di
del %IMP%\win32\directx\*.di
copy %WIN32%\src\directx\*.d   %IMP%\win32\directx\*.di
::copy files from DinrusBase
copy %BASE%\import\*.d  %IMP%\*.di 

if not exist %IMP%\std mkdir %IMP%\std
copy %BASE%\import\std\*.d  %IMP%\std\*.di 

if not exist  %IMP%\tpl mkdir %IMP%\tpl
copy %BASE%\import\tpl\*.d  %IMP%\tpl\*.di

if not exist %IMP%\st mkdir %IMP%\st
copy %COMMON%\import\st\*.d  %IMP%\st\*.di

if not exist %IMP%\mesh mkdir %IMP%\mesh
copy %COMMON%\import\mesh\*.d  %IMP%\mesh\*.di

if not exist %IMP%\def mkdir %IMP%\def
copy %BASE%\DinrusWin32\src\directx\*.def  %IMP%\def\*.def

if not exist %IMP%\sys mkdir %IMP%\sys
if not exist %IMP%\sys\inc mkdir %IMP%\sys\inc
if not exist %IMP%\sys\COM mkdir %IMP%\sys\COM
copy copy %BASE%\import\sys\*.d  %IMP%\sys\*.di
copy copy %BASE%\import\sys\inc\*.d  %IMP%\sys\inc\*.di
copy copy %BASE%\import\sys\COM\*.d  %IMP%\sys\COM\*.di

if not exist %IMP%\lib mkdir %IMP%\lib
copy %COMMON%\import\lib\*.d  %IMP%\lib\*.di

if not exist %IMP%\col mkdir %IMP%\col
if not exist %IMP%\col\model mkdir %IMP%\col\model
copy %COMMON%\import\col\*.d  %IMP%\col\*.di
copy %COMMON%\import\col\model\*.d  %IMP%\col\model\*.di

if not exist %IMP%\linalg mkdir %IMP%\linalg
copy %COMMON%\import\linalg\*.d  %IMP%\linalg\*.di

if not exist %IMP%\geom mkdir %IMP%\geom
copy %COMMON%\import\geom\*.d  %IMP%\geom\*.di

if not exist %IMP%\util mkdir %IMP%\util
copy %COMMON%\import\util\*.d  %IMP%\util\*.di


