
DWT-Win
=======

Requirements:
=============
Buildtool : DSSS 0.75
Compiler  : DMD 1.033
D Lib     : Tango release 0.99.7
Import libs
Please check also http://www.dsource.org/projects/dwt/wiki/Requirements

Import libs:
============
To link everything you need the import libs.
They are not included in the source repository, please use this archive

    http://downloads.dsource.org/projects/dwt/dwt-win-importlibs.zip

They don't contain any DWT code, only the import libraries to link to the windows system DLLs.


Building with dsss
===================
Per default dsss has the option 'oneatatime' enable.
This make dsss to compile one file at a time and building dwt take longer than 15 min.
Disable this option in the dsss/etc/rebuild/dmd-win-tango file.
Search for it (2 matches) and either delete those lines of change =on to =off.

In some situations, you may get linker errors when building the dwt examples.
Try adding the "-full" switch to the dsss command line to fix these errors.

Example:

dsss build -full simple

Subsystem linker option
=======================
For dmd linker 'optlink' there is the option SUBSYSTEM which defines if the executable
shall be a console or windows application and the minimum required windows version (4=win95,5=win2000,6=vista)
-L/SUBSYSTEM:windows:5
Without this option, DWT renderes some controls not correctly. Eg. table headers are not shown.


WinXP Theming and Controls
==========================
With WinXP it is required to make windows use a manifest.
There are several ways to make this manifest available.
1.) Place the manifest file in the same directory where the .exe is.
    E.g.
        application.exe
        application.exe.manifest
2.) Link the content of the manifest to the application as a windows resource.
3.) Have another program that uses resource injection to put the manifest into the application
4.) Let the application write the manifest to a an external file and load it.
    This had problems in the past, some applications on some machines did not load images.

1. .. 3.) Seems to work reliable.

 * Using 2.
   compile the dwt.rc/dwt.exe.manifest files with rcc.exe from the digitalmars to create the dwt.res.
     rcc dwt.rc
   link the resulting dwt.res with the -L/rc:dwt.res



