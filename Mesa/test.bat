dinrus
goto b
dmd -oftestdll.dll dll.d testdll.d mesa.def mesa.res
implib/system testdll.lib testdll.dll
dmd  test testdll.lib


:b
dmd -g -debug -ofDinrus.Mesa.dll dll.d mesa.d mesa.def mesa.res .\mesa.lib 
implib/system DinrusMesaDLL.lib Dinrus.Mesa.dll
dmd -g -debug aaindex .\import\mesa.d DinrusMesaDLL.lib
del *.obj *.map
pause
