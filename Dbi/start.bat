
%DINRUS%\dinrusex
:again
%DINRUS%\dsss build -full
%DINRUS%\lib DinrusDbi.lib mSql.lib
copy DinrusDbi.lib %DINRUS%\..\lib
pause
del *.obj
::::goto again