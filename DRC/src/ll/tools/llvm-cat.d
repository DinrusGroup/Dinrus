module llvmCat;

extern (C) цел ЛЛВхоФункцЛЛКат(inout сим** argv);
extern(C) ткст[] дайАргиКС();

цел main(ткст[] арги)
{
	auto арги_ =cast(сим**) дайАргиКС();
	return ЛЛВхоФункцЛЛКат(арги_);
}
