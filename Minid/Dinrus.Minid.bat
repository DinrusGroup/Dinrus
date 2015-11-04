del objs.rsp
%DINRUS%\ls2 -d *.d >>objs.rsp
%DINRUS%\dmd -g -O -cov -ofDinrus.Minid.dll @objs.rsp minid.def minid.res tango.lib
implib/system rminid.lib Dinrus.Minid.dll
copy .\rminid.lib .\test\
::copy .\rminid.lib /b ..\Base\rminid.lib /b
%DINRUS%\upx Dinrus.Minid.dll
copy Dinrus.Minid.dll %DINRUS%
pause
del *.obj *.rsp *.map
exit