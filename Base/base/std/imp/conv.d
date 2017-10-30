module std.conv;

version DinrusStd{
public import stdrus: вЦел,вБцел, вДол, вБдол, вКрат, вБкрат, вБайт, вБбайт, вПлав,  вДво, вРеал ;
pragma(lib, "DinrusStd.lib");
}
else
{
	
	extern(D)
	{

	    ///////////////////////////////////////////////////////
	    ткст0 вВин16н(ткст с, бцел кодСтр = 0);
	    ткст изВин16н(ткст0 с, цел кодСтр = 0);
	    цел вЦел(ткст т);
	    бцел вБцел(ткст т);
	    дол вДол(ткст т);
	    бдол вБдол(ткст т);
	    крат вКрат(ткст т);
	    бкрат вБкрат(ткст т);
	    байт вБайт(ткст т);
	    ббайт вБбайт(ткст т);
	    плав вПлав(ткст т);
	    дво вДво(ткст т);
	    реал вРеал(ткст т);
	}
}



alias вЦел toInt;
alias вБцел toUint;
alias вДол toLong;
alias вБдол toUlong;
alias вКрат toShort;
alias вБкрат toUshort;  
alias вБайт toByte;
alias вБбайт toUbyte; 
alias вПлав toFloat;   
alias вДво toDouble; 
alias вРеал toReal;