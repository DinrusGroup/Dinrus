dinrus
set this=%DINRUS%\..\dev\DINRUS\Base\Exe
%DINRUS%\dmd -release %this%\dinrus.d %this%\scConfig.d %this%\Resources\dinrus.res
%DINRUS%\upx dinrus.exe
%DINRUS%\dmd -release %this%\dinrusex.d %this%\scConfig.d %this%\Resources\dinrus.res
%DINRUS%\upx dinrusex.exe
%DINRUS%\dmd -release %this%\dgui.d %this%\scConfig.d %this%\Resources\dinrus.res
%DINRUS%\upx dgui.exe
%DINRUS%\dmd -release %this%\rulada.d  %this%\scConfig.d %this%\Resources\dinrus.res
%DINRUS%\upx rulada.exe
%DINRUS%\dmd -release %this%\ruladaex.d %this%\scConfig.d %this%\Resources\dinrus.res
%DINRUS%\upx ruladaex.exe
%DINRUS%\dmd -release %this%\rgui.d %this%\scConfig.d %this%\Resources\dinrus.res
%DINRUS%\upx rgui.exe
%DINRUS%\dmd -release %this%\libproc.d %this%\Resources\dinrus.res
%DINRUS%\upx libproc.exe
copy %this%\*.exe %DINRUS%
del %this%\*.map %this%\*.obj %this%\*.exe