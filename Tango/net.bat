@set TANGO=%DINRUS%\..\dev\DINRUS\Tango
@set LS=%DINRUS%\ls2.exe
@set DMD=%DINRUS%\dmd.exe
del %TANGO%\net.rsp
%LS% -d %TANGO%\wdir\net\*.d %TANGO%\wdir\net\device\*.d %TANGO%\wdir\net\ftp\*.d %TANGO%\wdir\net\http\*.d %TANGO%\wdir\net\http\model\*.d %TANGO%\wdir\net\model\*.d>>%TANGO%\net.rsp
%DMD% -lib -of%TANGO%\net.lib @%TANGO%\net.rsp
pause