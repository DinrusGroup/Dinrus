module std.demangle;

version DinrusStd
{
	
pragma(lib, "DinrusStd.lib");
public import stdrus: разманглируй;

}
else
{

extern (D)
 ткст разманглируй(ткст имя);

}

alias разманглируй demangle;