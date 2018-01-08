set R=%DINRUS%\..\imp\dinrus
set this=%DINRUS%\..\dev\OTHER\DINRUS_0\Viz\
dinrus
:go
del *.rsp *.lib
ls2 -d vizW/*.d>>win32.rsp
dmd -lib -ofDinrusViz.lib @win32.rsp 
ls2 -d viz_import/*.d>>viz.rsp
mkdir %R%\viz
copy viz_import\*.d %R%\viz\*.di 
pause
dmd -g -debug form DinrusViz.lib
:dmd -g -debug -ofform2.exe form ofviz_stat.lib import.lib
form.exe
del *.rsp
pause
goto go