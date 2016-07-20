set this=%DINRUS%\..\dev\DINRUS\Dbi
%DINRUS%\dinrusex
:again
dsss build -full
%DINRUS%\lib %this%\DinrusDbi.lib %this%\mSql.lib
%DINRUS%\lib %this%\DinrusDbi.lib %this%\libpq.lib
%DINRUS%\lib %this%\DinrusDbi.lib %this%\odbc.lib
%DINRUS%\lib %this%\DinrusDbi.lib %this%\libct.lib
copy %this%\DinrusDbi.lib %DINRUS%\..\lib
pause
del %this%\*.obj
::::goto again