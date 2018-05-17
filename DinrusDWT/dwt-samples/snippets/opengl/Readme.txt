opengl_test.d -- based on snippet195.java

Build dependencies:

* DerelictGL and DerelictGLU -- Install both of these with dsss OR have the derelict source in your include path using the "-I" command line flag. You may also have to add DerelictUtil to your include path.

* Import libraries provided via dwt-win projects wiki (www.dsource.org/project/dwt-win):
These will include glu32.lib and opengl32.lib (win32 version).  Place these in your library path, ie usually in <path_to_dmd>\dmd\lib

* Make sure that dwt library is either built and installed with dsss or that you have dwt source in your include path using the "-I" command line flag.

------------------------------------

If you have installed all required libraries with dsss, then you should be able to just do a "dsss build snippets\opengl_test1.d"



