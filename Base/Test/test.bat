:::Compiling and executing some test programs
@set DMD=%DINRUS%\dmd.exe
@set this=%DINRUS%\..\dev\DINRUS\Base\Test

del %this%\*.exe

%DINRUS%\dinrusex
%DMD% -g -debug %this%\test2.d
::%DINRUS%\upx %this%\test2.exe
pause
%this%\test2.exe

%DMD% -g -debug %this%\test.d
::%DINRUS%\upx %this%\test.exe
pause
%this%\test.exe

%DMD% -g -debug %this%\testgc.d
::%DINRUS%\upx %this%\testgc.exe
pause
%this%\testgc.exe

%DMD% -g -debug %this%\fiber.d
::%DINRUS%\upx %this%\fiber.exe
pause
%this%\fiber.exe

:::%DMD% -run %this%\clean.d

exit