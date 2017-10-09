@set R=%DINRUS%\..\imp\dinrus
@set LDIR=%DINRUS%\..\lib
del *.obj
copy ..\*.d  %R%\std\*.di 
%DINRUS%\dmd -run compile.d
if exist DinrusStd.lib copy DinrusStd.lib  %LDIR%
pause