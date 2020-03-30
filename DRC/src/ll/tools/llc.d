module llc;
import common;

extern (C) цел ЛЛВхоФункцЛЛКомпилятора(inout сим** argv);
extern(C) ткст[] дайАргиКС();

цел main(ткст[] арги)
{
auto арги_ = дайАргиКС();
	if(арги_.length == 2)
	{
		арги_ ~= "--help";
	}
auto ксарги = cast(сим**) арги_;
return ЛЛВхоФункцЛЛКомпилятора(ксарги);
}
