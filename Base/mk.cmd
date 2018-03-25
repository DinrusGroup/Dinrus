:::This file was developed for Dinrus Programming Language by Vitaliy Kulich
:::Copyright is by Dinrus Group.

:back
:::Setting environment variables
@set this=%DINRUS%\..\dev\DINRUS\Base
@set R=%DINRUS%\..\imp\dinrus
@set LIBS=%DINRUS%\..\lib\sysimport
@set LDIR=%DINRUS%\..\lib
@set DMD=%DINRUS%\dmd.exe
@set DMC=%DINRUS%\dmc.exe
@set LIB=%DINRUS%\lib.exe
@set IMPLIB=%DINRUS%\implib.exe
@set ARCDIR=%this%\..\Arc
@set MINIDDIR=%this%\..\Minid
@set LS=%DINRUS%\ls2.exe
@set PACK=%DINRUS%\upx.exe

::goto Lib

:::Deleting previous objects
@del %LDIR%\Dinrus.lib
@del %LDIR%\Dinrus.bak
@del %this%\*.rsp
@del %this%\*.obj
@del %this%\*.map
@del %this%\*.dll
@del %this%\base\rt\*.obj
@del %this%\*.lib
@del %this%\*.exe

:::Files with staff that must be same in imports and base-making
::: just copied to imports immediately? without manual processing

:copy %this%\base\sys\WinConsts.d %this%\import\sys\WinConsts.d 
:copy %this%\base\sys\WinStructs.d %this%\import\sys\WinStructs.d 
:copy %this%\base\sys\WinTypes.d %this%\import\sys\WinTypes.d 
:copy %this%\base\sys\WinIfaces.d %this%\import\sys\WinIfaces.d 
:copy %this%\base\base.d %this%\import\base.d

:::Making dirs for di files in \imp\dinrus\
::: and copying imports from .\import folder to them

mkdir %R%
copy %this%\import\*.d  %R%\*.di 

mkdir %R%\std
copy %this%\import\std\*.d  %R%\std\*.di 

mkdir %R%\tpl
copy %this%\import\tpl\*.d  %R%\tpl\*.di

mkdir %R%\st
copy %this%\import\st\*.d  %R%\st\*.di

mkdir %R%\mesh
copy %this%\import\mesh\*.d  %R%\mesh\*.di

mkdir %R%\win32
mkdir %R%\win32\directx
copy %this%\..\win32\*.d  %R%\win32\*.di
copy %this%\..\win32\directx\*.d   %R%\win32\directx\*.di

mkdir %R%\def
copy %this%\..\win32\directx\*.def  %R%\def\*.def

mkdir %R%\sys
mkdir %R%\sys\inc
mkdir %R%\sys\COM
copy %this%\import\sys\*.d  %R%\sys\*.di
copy %this%\import\sys\inc\*.d  %R%\sys\inc\*.di
copy %this%\import\sys\COM\*.d  %R%\sys\COM\*.di

mkdir %R%\lib
copy %this%\import\lib\*.d  %R%\lib\*.di

mkdir %R%\col
mkdir %R%\col\model
copy %this%\import\col\*.d  %R%\col\*.di
copy %this%\import\col\model\*.d  %R%\col\model\*.di


mkdir %R%\linalg
copy %this%\import\linalg\*.d  %R%\linalg\*.di

mkdir %R%\geom
copy %this%\import\geom\*.d  %R%\geom\*.di

mkdir %R%\util
copy %this%\import\util\*.d  %R%\util\*.di

::mkdir %R%\io
::mkdir %R%\io\device
::mkdir %R%\io\stream
::copy %this%\import\io\*.d  %R%\io\*.di
::copy %this%\import\io\device\*.d  %R%\io\*.di
::copy %this%\import\io\stream\*.d  %R%\io\*.di

:::Compiling C code

%DMC% -c -o%this%\complex.obj %this%\base\rt\complex.c -I%DINRUS%\..\include
%DMC% -c  -o%this%\critical.obj %this%\base\rt\critical.c -I%DINRUS%\..\include
%DMC% -c  -o%this%\deh.obj %this%\base\rt\deh.c -I%DINRUS%\..\include
%DMC% -c  -o%this%\monitor.obj %this%\base\rt\monitor.c -I%DINRUS%\..\include

%DMD% -lib -of%this%\Cdinr.lib %this%\complex.obj %this%\critical.obj %this%\deh.obj %this%\monitor.obj


:Base
:::Creating respond file
:::%this%\base\io\*d %this%\base\io\device\*.d %this%\base\io\stream\*.d
:::%LS% -d %this%\base\io\*d %this%\base\io\device\*.d %this%\base\io\stream\*.d 
%LS% -d %this%\base\std\*.d %this%\base\*.d %this%\base\tpl\*.d %this%\base\rt\*.d %this%\base\sys\*.d %this%\base\sys\inc\*.d>>%this%\objs.rsp

:::Make Dinrus.Base.dll

@if exist %DINRUS%\dinrus.exe %DINRUS%\dinrus.exe

%DMD% -g -O -debug -of%this%\Dinrus.Base.dll %this%\static\dll.d @%this%\objs.rsp %this%\base.def %this%\base.res %LDIR%\minit.obj %LDIR%\import.lib %this%\Cdinr.lib

@if not exist %this%\Dinrus.Base.dll pause
@if exist %this%\Dinrus.Base.dll goto nextStep
@del %this%\objs.rsp
@goto Base

:nextStep
:::Make its import lib
%IMPLIB% /system %this%\Dinrus.lib %this%\Dinrus.Base.dll
%IMPLIB% /system %this%\DinrusBaseDLL.lib %this%\Dinrus.Base.dll
copy %this%\DinrusBaseDLL.lib %LDIR%
::copy %this%\Dinrus.Base.dll %DINRUS%
::copy %this%\Dinrus.Base.dll c:\Windows\system32

:::To compress
:%PACK% %this%\Dinrus.Base.dll

:::Clean
@del %this%\*.obj

:::Compiling imports into static part of dinrus.lib

%DMD%  -c -O  -g -of%this%\cidrus.obj %this%\import\cidrus.d -I%R%
%DMD%  -c -O  -g -of%this%\stdrus.obj %this%\import\stdrus.d -I%R%
%DMD%  -c -O  -g -of%this%\runtime.obj %this%\import\runtime.d -I%R%
%DMD%  -c -O  -g -of%this%\object.obj %this%\import\object.d -I%R%
%DMD%  -c -O  -g -of%this%\gc.obj %this%\import\gc.d -I%R%
%DMD%  -c -O  -g -of%this%\thread.obj %this%\import\thread.d -I%R%
%DMD%  -c -O  -g -of%this%\sync.obj %this%\import\sync.d -I%R%
:%DMD%  -c -O  -g %this%\import\tracer.d
%DMD%  -c -O  -g -of%this%\ini.obj %this%\static\ini.d -I%R%
%DMD%  -c -O  -g -of%this%\stringz.obj %this%\import\stringz.d -I%R%

%DMD%  -c -O  -g -of%this%\win.obj %this%\import\win.d -I%R%
%DMD%  -c -O  -g -of%this%\wincom.obj %this%\import\com.d -I%R%
%DMD%  -c -O  -g -of%this%\dinrus.obj %this%\import\dinrus.d -I%R%
%DMD%  -c -O  -g -of%this%\exception.obj %this%\import\exception.d -I%R%
:::%DMD%  -c -O  -g %this%\import\openrj.d

%DMD%  -c -O  -g -of%this%\rotozoom.obj %this%\static\rotozoom.d -I%R%
%DMD%  -c -O  -g -of%this%\msscript.obj %this%\static\msscript.d DRwin32.lib -I%R%
%DMD%  -c -O  -g -of%this%\activex.obj %this%\static\activex.d DRwin32.lib -I%R%
%DMD%  -c -O  -g -of%this%\json.obj %this%\static\json.d -I%R%

::Special configuration items
%DMD%  -c -O  -g -of%this%\base.obj %this%\static\base.d -I%R%
%DMD%  -c -O  -g -of%this%\exeMain.obj %this%\static\exeMain.d -I%R%




:%DMD%  -c -O  -g exef.d

%DMD%  -c -O  -g -of%this%\winapi.obj %this%\import\winapi.d -I%R%
%DMD%  -c -O  -g -of%this%\global.obj %this%\import\global.d -I%R%

%DMD%  -c -O  -g -of%this%\all.obj %this%\import\tpl\all.d -I%R%
%DMD%  -c -O  -g -of%this%\alloc.obj %this%\import\tpl\alloc.d -I%R%
%DMD%  -c -O  -g -of%this%\bind.obj %this%\import\tpl\bind.d -I%R%
%DMD%  -c -O  -g -of%this%\box.obj %this%\import\tpl\box.d -I%R%
%DMD%  -c -O  -g -of%this%\collection.obj %this%\import\tpl\collection.d -I%R%
%DMD%  -c -O  -g -of%this%\metastrings.obj %this%\import\tpl\metastrings.d -I%R%
%DMD%  -c -O  -g -of%this%\minmax.obj %this%\import\tpl\minmax.d -I%R%
%DMD%  -c -O  -g -of%this%\signal.obj %this%\import\tpl\signal.d -I%R%
%DMD%  -c -O  -g -of%this%\args.obj %this%\import\tpl\args.d -I%R%
%DMD%  -c -O  -g -of%this%\traits.obj %this%\import\tpl\traits.d -I%R%
%DMD%  -c -O  -g -of%this%\typetuple.obj %this%\import\tpl\typetuple.d -I%R%
%DMD%  -c -O  -g -of%this%\stream.obj %this%\import\tpl\stream.d  -I%R%
%DMD%  -c -O  -g -of%this%\singleton.obj %this%\import\tpl\singleton.d  -I%R%
%DMD%  -c -O  -g -of%this%\comtpl.obj %this%\import\tpl\com.d -I%R%
%DMD%  -c -O  -g  -of%this%\std.obj %this%\import\tpl\std.d -I%R%
%DMD%  -c -O  -g  -of%this%\weakref.obj %this%\import\tpl\weakref.d -I%R%
:pause
%DMD%  -c -O  -g -of%this%\WinStructs.obj %this%\import\sys\WinStructs.d -I%R%

%DMD%  -c -O  -g -of%this%\WinIfaces.obj %this%\import\sys\WinIfaces.d -I%R%
%DMD%  -c -O  -g -of%this%\WinConsts.obj %this%\import\sys\WinConsts.d -I%R%
%DMD%  -c -O  -g -of%this%\WinFuncs.obj %this%\import\sys\WinFuncs.d -I%R%
%DMD%  -c -O  -g -of%this%\WinProcess.obj %this%\import\sys\WinProcess.d -I%R%
%DMD%  -c -O  -g -of%this%\registry.obj %this%\import\sys\registry.d -I%R%

%DMD%  -c -O  -g -of%this%\kernel32.obj %this%\import\sys\inc\kernel32.d -I%R%

:%DMD%  -c -O  -g %this%\import\sys\en.d
%DMD%  -c -O  -g -of%this%\memory.obj %this%\import\sys\memory.d -I%R%
%DMD%  -c -O  -g -of%this%\uuid.obj %this%\import\sys\uuid.d -I%R%
%DMD%  -c -O  -g -of%this%\comsys.obj %this%\static\sys0\com.d -I%R%


%DMD%  -c -O  -g -of%this%\shell32.obj %this%\import\sys\COM\shell32.d -I%R%
%DMD%  -c -O  -g -of%this%\scomall.obj %this%\import\sys\COM\all.d -I%R%

:%DMD%  -c -O  -g  %this%\static\lib\mesa.d mesa.lib

:%DMD%  -c -O  -g %this%\import\stddinrus\base64.d

:%DMD%  -c -O  -g -ofrt.obj @dobjs.rsp


:::Making library with static content
:dinrus2

%DMD% -lib -of%this%\dinrus2.lib  %this%\base.obj  %this%\object.obj  %this%\cidrus.obj  %this%\stdrus.obj  %this%\dinrus.obj  %this%\win.obj  %this%\runtime.obj  %this%\gc.obj  %this%\thread.obj  %this%\sync.obj  %this%\stringz.obj   %this%\all.obj  %this%\bind.obj  %this%\box.obj  %this%\metastrings.obj  %this%\minmax.obj  %this%\signal.obj  %this%\args.obj  %this%\typetuple.obj  %this%\traits.obj  %this%\exception.obj %LDIR%\minit.obj  %this%\WinStructs.obj  %this%\WinIfaces.obj  %this%\WinConsts.obj  %this%\WinFuncs.obj  %this%\WinProcess.obj  %this%\comtpl.obj  %this%\wincom.obj  %this%\shell32.obj  %this%\stream.obj  %this%\memory.obj  %this%\msscript.obj  %this%\activex.obj  %this%\winapi.obj  %this%\singleton.obj  %this%\alloc.obj  %this%\collection.obj  %this%\kernel32.obj  %this%\ini.obj  %this%\Std.obj  %this%\exeMain.obj  %this%\uuid.obj  %this%\comsys.obj  %this%\rotozoom.obj  %this%\scomall.obj  %this%\global.obj  %this%\weakref.obj %this%\registry.obj %this%\Cdinr.lib
@if exist %this%\dinrus2.lib  goto Join
@if not exist %this%\dinrus2.lib pause
cls
@goto NextStep
:::Ading static libraries to Dinrus.lib
:Join
%LIB% -p256   %this%\Dinrus.lib  %this%\dinrus2.lib

:::Compiling codes from .\static folder

:Lib

%LS% -d %this%\import\lib\*.d >>%this%\lib.rsp
%DMD% -lib -of%this%\dlib.lib @%this%\lib.rsp
@if exist %this%\dlib.lib del %this%\lib.rsp
@if exist %this%\dlib.lib goto Col
@if not exist %this%\dlib.lib pause
@del %this%\col.rsp
cls
@goto Lib
pause

:Col
%LS% -d %this%\static\col\*.d  %this%\static\col\model\*.d>>%this%\col.rsp
%DMD% -lib -of%this%\col.lib @%this%\col.rsp
@if exist %this%\col.lib del %this%\col.rsp
@if exist %this%\col.lib goto Util
@if not exist %this%\col.lib pause
@del %this%\col.rsp
cls
@goto Col

:Util
%LS% -d %this%\static\util\*.d>>%this%\ut.rsp
%DMD% -lib -of%this%\util.lib @%this%\ut.rsp
@if exist %this%\util.lib del %this%\ut.rsp
@if exist %this%\util.lib goto LinALg
@if not exist %this%\util.lib pause
@del %this%\ut.rsp
cls
@goto Util

:LinAlg
%LS% -d %this%\static\linalg\*.d>>%this%\la.rsp
%DMD% -lib -of%this%\la.lib @%this%\la.rsp
@if exist %this%\la.lib del %this%\la.rsp
@if exist %this%\la.lib goto Mesh
@if not exist %this%\la.lib pause
@del %this%\la.rsp
cls
@goto LinAlg

:Mesh
%LS% -d %this%\static\mesh\*.d>>%this%\mesh.rsp
%DMD% -lib -of%this%\mesh.lib @%this%\mesh.rsp
@if exist %this%\mesh.lib del %this%\mesh.rsp
@if exist %this%\mesh.lib goto St
@if not exist %this%\mesh.lib pause
@del %this%\mesh.rsp
cls
@goto Mesh

:St
%LS% -d %this%\static\st\*.d>>%this%\st.rsp
%DMD% -lib -of%this%\st.lib @%this%\st.rsp
@if exist %this%\st.lib del %this%\st.rsp
@if exist %this%\st.lib goto Geom
@if not exist %this%\st.lib pause
@del %this%\st.rsp
cls
@goto St

:Geom
%LS% -d %this%\static\geom\*.d>>%this%\geom.rsp
%DMD% -lib -of%this%\geom.lib @%this%\geom.rsp
@if exist %this%\geom.lib del %this%\geom.rsp
@if exist %this%\geom.lib goto IO
@if not exist %this%\geom.lib pause
@del %this%\geom.rsp
cls
@goto Geom

:IO
goto finish
%LS% -d %this%\import\io\*.d %this%\import\io\device\*.d %this%\import\io\stream\*.d>>%this%\io.rsp
%DMD% -lib -of%this%\io.lib @%this%\io.rsp
@if exist %this%\io.lib del %this%\io.rsp
@if exist %this%\io.lib goto DRwin32
@if not exist %this%\io.lib pause
@del %this%\io.rsp
cls
@goto IO

:DRwin32
:::Makin Dinrus_win32.lib
:if exist %LDIR%\DinrusWin32.lib goto skip
%LS% -d %this%\..\win32\*.d %this%\..\win32\directx\*.d %this%\..\win32\directx\*.def>>%this%\win32.rsp
%DMD% -O -release -version=Unicode -lib -of%this%\DinrusWin32.lib @%this%\win32.rsp
if exist %this%\win32.rsp del %this%\win32.rsp
if not exist %this%\DinrusWin32.lib pause
copy %this%\DinrusWin32.lib /b  %LDIR%\DinrusWin32.lib /b

::skip
goto finish

:Dinrus.Arc.dll
:::Making Dinrus.Arc.dll
cd %ARCDIR%
%DINRUS%\rulada
%DMD% -of%ARCDIR%\Dinrus.Arc.dll %ARCDIR%\dll.d %ARCDIR%\arc.d %ARCDIR%\arcus.def %ARCDIR%\arcus.res derelict.lib arc.lib
%IMPLIB% /system %ARCDIR%\DinrusArcDLL.lib %ARCDIR%\Dinrus.Arc.dll
copy %ARCDIR%\DinrusArcDLL.lib %LDIR%
%PACK% %ARCDIR%\Dinrus.Arc.dll
copy %ARCDIR%\Dinrus.Arc.dll %DINRUS%
del %ARCDIR%\*.dll %ARCDIR%\*.obj %ARCDIR%\*.rsp %ARCDIR%\*.map

:Dinrus.Minid.dll
cd %MINIDDIR%
%LS% -d %MINIDDIR%\*.d >>%MINIDDIR%\objs.rsp
%DMD% -g -O -cov -of%MINIDDIR%\Dinrus.Minid.dll @%MINIDDIR%\objs.rsp %MINIDDIR%\minid.def %MINIDDIR%\minid.res 
%IMPLIB% /system %MINIDDIR%\DinrusMinidDLL.lib %MINIDDIR%\Dinrus.Minid.dll
%PACK% %MINIDDIR%\Dinrus.Minid.dll
copy %MINIDDIR%\DinrusMinidDLL.lib %LDIR%
copy %MINIDDIR%\Dinrus.Minid.dll %DINRUS%
del %MINIDDIR%\*.dll %MINIDDIR%\*.obj %MINIDDIR%\*.rsp %MINIDDIR%\*.map
cd %this%
%DINRUS%\dinrus

:finish

%LIB% -p256  %this%\Dinrus.lib %this%\dlib.lib
%LIB% -p256  %this%\Dinrus.lib %this%\col.lib
%LIB% -p256  %this%\Dinrus.lib %this%\util.lib
%LIB% -p256  %this%\Dinrus.lib %this%\la.lib
%LIB% -p256  %this%\Dinrus.lib %this%\geom.lib
%LIB% -p256  %this%\Dinrus.lib %this%\mesh.lib
%LIB% -p256  %this%\Dinrus.lib %this%\st.lib
::%LIB% -p256  %this%\Dinrus.lib %this%\io.lib
%LIB% -p256  %this%\Dinrus.lib %ARCDIR%\arc2.lib
%LIB% -p256  %this%\Dinrus.lib %MINIDDIR%\rminid.lib

:::Adding system imports
::::%LIB% -p256  Dinrus.lib %LDIR%\import.lib

:::Copying Dinrus.lib to main Dinrus lib folder
:%LIB% -p256  Dinrus.lib %LDIR%\import.lib
copy %this%\Dinrus.lib %LDIR%
copy %this%\Dinrus.lib %LDIR%\Dinrus_dbg.lib

copy %this%\Dinrus.Base.dll %DINRUS%


%DMD%  -lib  -of%this%\DinrusSpecBuild.lib %this%\static\dllMain.d
copy %this%\DinrusSpecBuild.lib  %LDIR%

del %this%\*.lib %this%\*.obj

goto exes

:::Making DinrusStd.lib
cd .\std\mk
del *.obj
%DINRUS%\dmd -run compile.d
if exist DinrusStd.lib copy DinrusStd.lib  %LDIR%
if not exist DinrusStd.lib pause
if not exist %R%\std mkdir %R%\std
copy ..\*.d  %R%\std\*.di 
del *.lib *.exe *.map
cd %this%
:::Cleaning
%DMD% %this%\clean.d
%this%\clean
::: same with the Dll - to bin folder

:exes

::del *.lib *.dll
cd %this%\Exe
mk.bat
pause
exit

