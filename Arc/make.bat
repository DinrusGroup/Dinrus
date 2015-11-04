::: !!!!!!!!!!!NB: использовать для компиляции Руладу версии 2 
@set this=%DINRUS%\..\dev\DINRUS\Arc
del %this%\*.obj %this%\*.dll %this%\*.map
rulada
dmd -of%this%\Dinrus.Arc.dll %this%\dll.d %this%\arc.d %this%\arcus.def %this%\arcus.res derelict.lib arc.lib
implib /system %this%\arc2.lib %this%\Dinrus.Arc.dll
dinrus
pause