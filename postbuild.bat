@IMPEM This file was developed for Dinrus Programming Language by Vitaliy Kulich
@IMPEM Copyright is by Dinrus Group.

:back
@IMPEM Setting environment variables
@set this=%DINRUS%\..\dev\DINRUS\
@set BaseLib=%DINRUS%\..\dev\DINRUS\BaseDLL
@set IMP=%DINRUS%\..\imp\dinrus
@set LIBS=%DINRUS%\..\lib\sysimport
@set LDIIMP=%DINRUS%\..\lib
@set DMD=%DINRUS%\dmd.exe
@set DMC=%DINRUS%\dmc.exe
@set LIB=%DINRUS%\dmlib.exe
@set IMPLIB=%DINRUS%\implib.exe
@set AIMPCDIIMP=%this%\..\Arc
@set MINIDDIIMP=%this%\..\Minid
@set LS=%DINRUS%\ls2.exe
@set PACK=%DINRUS%\upx.exe

::goto Lib

@IMPEM Deleting previous objects

@del %this%\*.rsp
@del %this%\*.obj
@del %this%\*.map
@del %this%\*.dll
@del %this%\*.lib
@del %this%\*.exe
:::::::::::::::::::::::::::::::::::::::
mkdir %IMP%
copy %this%\DinrusBase\import\*.d  %IMP%\*.di 

mkdir %IMP%\std
copy %this%\DinrusBase\import\std\*.d  %IMP%\std\*.di 

mkdir %IMP%\tpl
copy copy %this%\DinrusBase\import\tpl\*.d  %IMP%\tpl\*.di

mkdir %IMP%\st
copy %this%\import\st\*.d  %IMP%\st\*.di

mkdir %IMP%\mesh
copy %this%\import\mesh\*.d  %IMP%\mesh\*.di

mkdir %IMP%\win32
mkdir %IMP%\win32\directx
copy %this%\..\win32\*.d  %IMP%\win32\*.di
copy %this%\..\win32\directx\*.d   %IMP%\win32\directx\*.di

mkdir %IMP%\def
copy %this%\..\win32\directx\*.def  %IMP%\def\*.def

mkdir %IMP%\sys
mkdir %IMP%\sys\inc
mkdir %IMP%\sys\COM
copy copy %this%\DinrusBase\import\sys\*.d  %IMP%\sys\*.di
copy copy %this%\DinrusBase\import\sys\inc\*.d  %IMP%\sys\inc\*.di
copy copy %this%\DinrusBase\import\sys\COM\*.d  %IMP%\sys\COM\*.di

mkdir %IMP%\lib
copy %this%\import\lib\*.d  %IMP%\lib\*.di

mkdir %IMP%\col
mkdir %IMP%\col\model
copy %this%\import\col\*.d  %IMP%\col\*.di
copy %this%\import\col\model\*.d  %IMP%\col\model\*.di


mkdir %IMP%\linalg
copy %this%\import\linalg\*.d  %IMP%\linalg\*.di

mkdir %IMP%\geom
copy %this%\import\geom\*.d  %IMP%\geom\*.di

mkdir %IMP%\util
copy %this%\import\util\*.d  %IMP%\util\*.di




::::::::::::::::::::::::::::::::::::::::






::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;

%LIB% -p256 %this%\DinrusDbg.lib %this%\DinrusBase\bin\Debug\DinrusBaseDbg.lib|%LIB% -p256 %this%\DinrusDbg.lib %this%\DinrusCommon\bin\Debug\DinrusCommonDbg.lib|%LIB% -p256 %this%\DinrusDbg.lib %LDIIMP%\import.lib|%LIB% -p256 %this%\DinrusDbg.lib %LDIIMP%\minit.obj
copy %this%\DinrusDbg.lib %LDIIMP%\
pause

%LIB% -p256 %this%\Dinrus.lib %this%\DinrusBase\bin\IMPelease\DinrusBaseDbg.lib|%LIB% -p256 %this%\Dinrus.lib %this%\DinrusCommon\bin\IMPelease\DinrusCommonDbg.lib|%LIB% -p256 %this%\Dinrus.lib %LDIIMP%\import.lib|%LIB% -p256 %this%\Dinrus.lib %LDIIMP%\minit.obj
copy %this%\Dinrus.lib %LDIIMP%\
pause

