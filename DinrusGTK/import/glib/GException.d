
module gtkD.glib.GException;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;




class GException : Exception
{
	ErrorG error;
	
	this(ErrorG error);
	
	string toString();
}

/**
 */

