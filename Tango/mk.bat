:back
dinrus
:::Setting environment variables
@set TANGO=%DINRUS%\..\dev\DINRUS\Tango
@set IMPDIR=%DINRUS%\..\imp\dinrus
@set LIBS=%DINRUS%\..\lib\sysimport
@set LDIR=%DINRUS%\..\lib
@set DMD=%DINRUS%\dmd.exe
@set DMC=%DINRUS%\dmc.exe
@set LIB=%DINRUS%\lib.exe
@set IMPLIB=%DINRUS%\implib.exe
@set LS=%DINRUS%\ls2.exe
@set PACK=%DINRUS%\upx.exe
:::Deleting previous objects
del %TANGO%\*.rsp
del %TANGO%\*.obj %TANGO%\*.lib %TANGO%\*.dll
del %TANGO%\*.map

:core
mkdir %IMPDIR%\core
copy %TANGO%\import\core\*.d %IMPDIR%\core\*.di


:io
mkdir %IMPDIR%\io\
mkdir %IMPDIR%\io\vfs
mkdir %IMPDIR%\io\selector
mkdir %IMPDIR%\io\protocol
mkdir %IMPDIR%\io\stream
mkdir %IMPDIR%\io\device
copy %TANGO%\import\io\*.d  %IMPDIR%\io\*.di
copy %TANGO%\import\io\stream\*.d  %IMPDIR%\io\stream\*.di
copy %TANGO%\import\io\device\*.d  %IMPDIR%\io\device\*.di
copy %TANGO%\import\io\vfs\*.d  %IMPDIR%\io\vfs\*.di
copy %TANGO%\import\io\selector\*.d  %IMPDIR%\io\selector\*.di
copy %TANGO%\import\io\protocol\*.d  %IMPDIR%\io\protocol\*.di


:time
mkdir %IMPDIR%\time\
mkdir %IMPDIR%\time\chrono
copy %TANGO%\import\time\*.d  %IMPDIR%\time\*.di
copy %TANGO%\import\time\chrono\*.d  %IMPDIR%\time\chrono\*.di

:text
mkdir %IMPDIR%\text\
mkdir %IMPDIR%\text\json
mkdir %IMPDIR%\text\xml
mkdir %IMPDIR%\text\locale
mkdir %IMPDIR%\text\convert
copy %TANGO%\import\text\*.d  %IMPDIR%\text\*.di
copy %TANGO%\import\text\convert\*.d  %IMPDIR%\text\convert\*.di
copy %TANGO%\import\text\json\*.d  %IMPDIR%\text\json\*.di
copy %TANGO%\import\text\locale\*.d  %IMPDIR%\text\locale\*.di
copy %TANGO%\import\text\xml\*.d  %IMPDIR%\text\xml\*.di

:math
mkdir %IMPDIR%\math\
mkdir %IMPDIR%\math\internal\
mkdir %IMPDIR%\math\random\
mkdir %IMPDIR%\math\random\engines\
copy %TANGO%\import\math\*.d  %IMPDIR%\math\*.di
copy %TANGO%\import\math\internal\*.d  %IMPDIR%\math\internal\*.di
copy %TANGO%\import\math\random\*.d  %IMPDIR%\math\random\*.di
copy %TANGO%\import\math\random\engines\*.d  %IMPDIR%\math\random\engines\*.di

:util
mkdir %IMPDIR%\util\container
mkdir %IMPDIR%\util\container\more
mkdir %IMPDIR%\util\container\model
mkdir %IMPDIR%\util\collection\
mkdir %IMPDIR%\util\collection\model
mkdir %IMPDIR%\util\collection\iterator
mkdir %IMPDIR%\util\collection\impl
mkdir %IMPDIR%\util\compress
mkdir %IMPDIR%\util\cipher
mkdir %IMPDIR%\util\digest
mkdir %IMPDIR%\util\encode
mkdir %IMPDIR%\util\log
mkdir %IMPDIR%\util\log\model
mkdir %IMPDIR%\util\uuid
copy %TANGO%\import\util\*.d %IMPDIR%\util\*.di
copy %TANGO%\import\util\container\*.d %IMPDIR%\util\container\*.di
copy %TANGO%\import\util\compress\*.d %IMPDIR%\util\compress\*.di
copy %TANGO%\import\util\cipher\*.d %IMPDIR%\util\cipher\*.di
copy %TANGO%\import\util\digest\*.d %IMPDIR%\util\digest\*.di
copy %TANGO%\import\util\encode\*.d %IMPDIR%\util\encode\*.di
copy %TANGO%\import\util\log\*.d %IMPDIR%\util\log\*.di
copy %TANGO%\import\util\log\model\*.d %IMPDIR%\util\log\model\*.di
copy %TANGO%\import\util\container\more\*.d %IMPDIR%\util\container\more\*.di
copy %TANGO%\import\util\container\model\*.d %IMPDIR%\util\container\model\*.di
copy %TANGO%\import\util\compress\*.d %IMPDIR%\util\compress\*.di
copy %TANGO%\import\util\uuid\*.d %IMPDIR%\util\uuid\*.di
copy %TANGO%\import\util\collection\*.d %IMPDIR%\util\collection\*.di
copy %TANGO%\import\util\collection\model\*.d %IMPDIR%\util\collection\model\*.di
copy %TANGO%\import\util\collection\iterator\*.d %IMPDIR%\util\collection\iterator\*.di
copy %TANGO%\import\util\collection\impl\*.d %IMPDIR%\util\collection\impl\*.di


:sys
mkdir %IMPDIR%\sys\consts
mkdir %IMPDIR%\sys\win32
mkdir %IMPDIR%\sys\win32\consts
copy %TANGO%\import\sys\consts\*.d %IMPDIR%\sys\consts\*.di
copy %TANGO%\import\sys\win32\*.d %IMPDIR%\sys\win32\*.di
copy %TANGO%\import\sys\win32\consts\*.d %IMPDIR%\sys\win32\consts\*.di
copy %TANGO%\import\sys\*.d %IMPDIR%\sys\*.di

:net
mkdir %IMPDIR%\net
mkdir %IMPDIR%\net\device
mkdir %IMPDIR%\net\ftp
mkdir %IMPDIR%\net\http
mkdir %IMPDIR%\net\http\model
mkdir %IMPDIR%\net\model
copy %TANGO%\import\net\*.d %IMPDIR%\net\*.di
copy %TANGO%\import\net\device\*.d  %IMPDIR%\net\device\*.di
copy %TANGO%\import\net\ftp\*.d  %IMPDIR%\net\ftp\*.di
copy %TANGO%\import\net\http\*.d  %IMPDIR%\net\http\*.di
copy %TANGO%\import\net\http\model\*.d %IMPDIR%\net\http\model\*.di
copy %TANGO%\import\net\model\*.d %IMPDIR%\net\model\*.di



:lib
copy %TANGO%\import\lib\*.d  %IMPDIR%\lib\*.di
cls


:Sys
%LS% -d %TANGO%\wdir\sys\*.d %TANGO%\wdir\sys\consts\*.d %TANGO%\wdir\sys\win32\*.d %TANGO%\wdir\sys\win32\consts\*.d>>%TANGO%\sys.rsp
%DMD% -lib  -d -of%TANGO%\DinrusTango.lib @%TANGO%\sys.rsp
if exist %TANGO%\DinrusTango.lib del %TANGO%\sys.rsp
if exist %TANGO%\DinrusTango.lib goto Time
if not exist %TANGO%\DinrusTango.lib pause
del %TANGO%\sys.rsp
cls
goto Sys

:Time
%LS% -d %TANGO%\wdir\time\*.d %TANGO%\wdir\time\chrono\*.d>>%TANGO%\time.rsp
%DMD% -lib  -d -of%TANGO%\time.lib @%TANGO%\time.rsp
if exist %TANGO%\time.lib del %TANGO%\time.rsp
if not exist %TANGO%\time.lib pause
%LIB% -p256  %TANGO%\DinrusTango.lib %TANGO%\time.lib
del time.lib
cls

:Math
%LS% -d %TANGO%\wdir\math\*.d %TANGO%\wdir\math\internal\*.d %TANGO%\wdir\math\random\*.d   %TANGO%\wdir\math\random\engines\*.d>>%TANGO%\math.rsp
%DMD% -lib  -d -of%TANGO%\math.lib @%TANGO%\math.rsp
if exist %TANGO%\math.lib del %TANGO%\math.rsp
if not exist %TANGO%\math.lib pause
%LIB% -p256  %TANGO%\DinrusTango.lib %TANGO%\math.lib
del math.lib
cls

:Core

%LS% -d %TANGO%\wdir\core\*.d>>%TANGO%\core.rsp
%DMD% -lib -d  -of%TANGO%\core.lib @%TANGO%\core.rsp
if exist %TANGO%\core.lib del %TANGO%\core.rsp
%LIB% -p256  %TANGO%\DinrusTango.lib %TANGO%\core.lib
if exist %TANGO%\core.lib del %this%\core.rsp
if not exist %TANGO%\core.lib pause
%LIB% -p256  %TANGO%\DinrusTango.lib %TANGO%\core.lib
del core.lib
cls

:Lib
%LS% -d %TANGO%\import\lib\*.d>>%TANGO%\libs.rsp
%DMD% -lib -d  -of%TANGO%\libs.lib @%TANGO%\libs.rsp
if exist %TANGO%\libs.lib del %TANGO%\libs.rsp
if not exist %TANGO%\libs.lib pause
%LIB% -p256  %TANGO%\DinrusTango.lib %TANGO%\libs.lib
del libs.lib
cls

:Util
%LS% -d %TANGO%\wdir\util\*.d %TANGO%\wdir\util\container\*.d %TANGO%\wdir\util\container\model\*.d %TANGO%\wdir\util\container\more\*.d %TANGO%\wdir\util\log\*.d %TANGO%\wdir\util\log\model\*.d %TANGO%\wdir\util\collection\model\*.d %TANGO%\wdir\util\collection\*.d %TANGO%\wdir\util\collection\impl\*.d %TANGO%\wdir\util\collection\iterator\*.d>>%TANGO%\ut.rsp
%DMD% -lib -d  -of%TANGO%\util.lib @%TANGO%\ut.rsp
if exist %TANGO%\util.lib del %TANGO%\ut.rsp
if not exist %TANGO%\util.lib pause
%LIB% -p256  %TANGO%\DinrusTango.lib %TANGO%\util.lib
del util.lib
cls

:Text
%LS% -d %TANGO%\wdir\text\*.d %TANGO%\wdir\text\convert\*.d  %TANGO%\wdir\text\json\*.d  %TANGO%\wdir\text\locale\*.d %TANGO%\wdir\text\xml\*.d>>%TANGO%\txt.rsp
%DMD% -lib -d  -of%TANGO%\txt.lib @%TANGO%\txt.rsp
if exist %TANGO%\txt.lib del %TANGO%\txt.rsp
if not exist %TANGO%\txt.lib pause
%LIB% -p256  %TANGO%\DinrusTango.lib %TANGO%\txt.lib
del txt.lib
cls

:Tangio

%LS% -d %TANGO%\wdir\*.d %TANGO%\wdir\io\*.d %TANGO%\wdir\io\stream\*.d %TANGO%\wdir\io\device\*.d %TANGO%\wdir\io\vfs\*.d %TANGO%\wdir\io\selector\*.d %TANGO%\wdir\io\protocol\*.d>>%TANGO%\tangio.rsp
%DMD% -lib  -d -of%TANGO%\tangio.lib @%TANGO%\tangio.rsp
if exist %TANGO%\tangio.lib del %TANGO%\tangio.rsp
if not exist %TANGO%\tangio.lib pause
%LIB% -p256  %TANGO%\DinrusTango.lib %TANGO%\tangio.lib
del tangio.lib
cls


:Net

%LS% -d %TANGO%\wdir\net\*.d %TANGO%\wdir\net\device\*.d %TANGO%\wdir\net\ftp\*.d %TANGO%\wdir\net\http\*.d %TANGO%\wdir\net\http\model\*.d %TANGO%\wdir\net\model\*.d>>%TANGO%\net.rsp
%DMD% -lib  -d -of%TANGO%\net.lib @%TANGO%\net.rsp
if exist %TANGO%\net.lib del %TANGO%\net.rsp
if not exist %TANGO%\net.lib pause
%LIB% -p256  %TANGO%\DinrusTango.lib %TANGO%\net.lib
del net.lib
cls

goto end
:DinrusTango
cd %TANGO%
%DINRUS%\dsss clean
%DINRUS%\dsss build -full
pause

:end
copy %TANGO%\DinrusTango.lib /b %LDIR%\DinrusTango.lib /b
exit
:DLL
del allobj.rsp
%LS% -d %TANGO%\wdir\net\*.d %TANGO%\wdir\net\device\*.d %TANGO%\wdir\net\ftp\*.d %TANGO%\wdir\net\http\*.d %TANGO%\wdir\net\http\model\*.d %TANGO%\wdir\net\model\*.d %TANGO%\wdir\io\*.d %TANGO%\wdir\io\stream\*.d %TANGO%\wdir\io\device\*.d %TANGO%\wdir\io\vfs\*.d %TANGO%\wdir\io\selector\*.d %TANGO%\wdir\io\protocol\*.d %TANGO%\wdir\text\*.d %TANGO%\wdir\text\convert\*.d  %TANGO%\wdir\text\json\*.d  %TANGO%\wdir\text\locale\*.d %TANGO%\wdir\text\xml\*.d %TANGO%\wdir\util\*.d %TANGO%\wdir\util\container\*.d %TANGO%\wdir\util\container\model\*.d %TANGO%\wdir\util\container\more\*.d %TANGO%\wdir\util\log\*.d %TANGO%\wdir\util\log\model\*.d %TANGO%\wdir\util\collection\model\*.d %TANGO%\wdir\util\collection\*.d %TANGO%\wdir\util\collection\impl\*.d %TANGO%\wdir\util\collection\iterator\*.d %TANGO%\import\lib\*.d %TANGO%\wdir\core\*.d %TANGO%\wdir\math\*.d %TANGO%\wdir\math\internal\*.d %TANGO%\wdir\math\random\*.d %TANGO%\wdir\math\random\engines\*.d %TANGO%\wdir\time\*.d %TANGO%\wdir\time\chrono\*.d %TANGO%\wdir\sys\*.d %TANGO%\wdir\sys\consts\*.d %TANGO%\wdir\sys\win32\*.d %TANGO%\wdir\sys\win32\consts\*.d>>%TANGO%\allobj.rsp
:::Make Dinrus.Tango.dll
%DINRUS%\dinrus
%DMD% -g -O -debug -d -version=DinrusTangoDLL -ofDinrus.Tango.dll @allobj.rsp %TANGO%\base.def %TANGO%\base.res DinrusTango.lib dinrus.lib import.lib

:::Make its import lib
%IMPLIB% /system %TANGO%\DinrusTangoDLL.lib %TANGO%\Dinrus.Tango.dll
copy %TANGO%\DinrusTangoDLL.lib /b %LDIR%\DinrusTangoDLL.lib /b
::: same with the Dll - to bin folder
copy Dinrus.Tango.dll %DINRUS%
:::Clean
pause
if not exist %TANGO%\Dinrus.Tango.dll goto DLL


:::Cleaning
del %TANGO%\*.obj
exit
