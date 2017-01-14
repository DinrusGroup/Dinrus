set this=%DINRUS%\..\dev\DINRUS\Dbi
%DINRUS%\dinrusex
:again
dsss build -full
%DINRUS%\lib %this%\DinrusDbi.lib %this%\lib\mSql.lib
%DINRUS%\lib %this%\DinrusDbi.lib %this%\lib\libpq.lib
%DINRUS%\lib %this%\DinrusDbi.lib %this%\lib\odbc.lib
::%DINRUS%\lib %this%\DinrusDbi.lib %this%\lib\libct.lib
::%DINRUS%\lib %this%\DinrusDbi.lib %this%\lib\libcs.lib
copy %this%\DinrusDbi.lib %DINRUS%\..\lib
pause
del %this%\*.obj
::::goto again