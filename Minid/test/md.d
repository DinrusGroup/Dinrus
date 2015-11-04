module md;
import cidrus;
pragma(lib, "rminid.lib");

extern (C) цел мдКомпилятор(ткст arg = пусто);
extern (C) цел миниД(ткст[] args);


проц main( ткст[] арги)
{

	миниД(арги[1..length]);
	if(арги.length == 2)
		{
			мдКомпилятор(арги[1]);
		}
	выход(0);
}