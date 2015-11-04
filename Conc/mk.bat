@set R=%DINRUS%\..\imp\dinrus
@set LDIR=%DINRUS%\..\lib
@set this=%DINRUS%\..\dev\Dinrus\Conc
cd %this%
copy %this%\include\*.d %R%\conc\*.di
%DINRUS%\dinrusex
%DINRUS%\dmmake -f %this%\win32.mak
if exist %this%\DinrusConc.lib copy  %this%\DinrusConc.lib %LDIR%\DinrusConc.lib
mkdir %R%\conc
del %this%\*.obj
pause