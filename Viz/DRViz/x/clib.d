// Public domain.


module viz.x.clib;


version(Tango)
{
	public import tango.stdc.stdlib,
		tango.stdc.string,
		tango.stdc.stdint,
		tango.stdc.stdio;
	
	alias tango.stdc.stdio.printf эхо;
}
else // Phobos
{
	public import stdrus;		
		
	
	alias эхо эхо;
}

