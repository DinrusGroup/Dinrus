set R=%DINRUS%\..\imp\dinrus
set this=%DINRUS%\..\dev\DINRUS\Viz
dinrus
:go
del *.rsp *.lib
ls2 -d vizW/*.d>>win32.rsp
:::dmd -inline -O  -g -debug -version=Unicode -lib -ofViz.lib @win32.rsp
dmd -g -debug -d -O -ofDinrus.Viz.dll %this%\dll2 @win32.rsp %this%\viz.def %this%\viz.res import.lib
:dindll.lib
:dmd -g -debug -O -lib -ofviz_stat.lib @win32.rsp
implib /system Viz.lib Dinrus.Viz.dll
ls2 -d viz_import/*.d>>viz.rsp
mkdir %R%\viz
copy viz_import\*.d %R%\viz\*.di 
dmd -O  -g -lib -ofviz2.lib @viz.rsp
%DINRUS%\lib -p256 Viz.lib viz2.lib
dmd -g -debug form Viz.lib import.lib
:dmd -g -debug -ofform2.exe form ofviz_stat.lib import.lib
form.exe
del *.rsp
pause
goto go