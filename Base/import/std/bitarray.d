
module std.bitarray;
private import std.intrinsic;

 extern(D) struct МассивБит
{
   бцел *укз();
	 т_мера разм();
    т_мера dim();
	 т_мера длина();
    т_мера length();
	 проц длина(т_мера новдлин);
    проц length(т_мера новдлин);
    бул opIndex(т_мера i);
    бул opIndexAssign(бул b, т_мера i);
	 МассивБит дубль();
    МассивБит dup();
    цел opApply(цел delegate(inout бул) дг);
    цел opApply(цел delegate(inout т_мера, inout бул) дг);
	 МассивБит реверсни();
    МассивБит reverse();
	 МассивБит сортируй();
    МассивБит sort();
     цел opEquals(МассивБит a2);
    цел opCmp(МассивБит a2);
	 проц иниц(бул[] бм);
    проц init(бул[] ba);
	 проц иниц(проц[] в, т_мера члобит);
    проц init(проц[] v, т_мера numbits);
    проц[] opCast();
    МассивБит opCom();
    МассивБит opAnd(МассивБит e2);
     МассивБит opOr(МассивБит e2);
    МассивБит opXor(МассивБит e2);
    МассивБит opSub(МассивБит e2);
    МассивБит opAndAssign(МассивБит e2);
    МассивБит opOrAssign(МассивБит e2);
    МассивБит opXorAssign(МассивБит e2);
    МассивБит opSubAssign(МассивБит e2);
     МассивБит opCatAssign(бул b);
    МассивБит opCatAssign(МассивБит b);
    МассивБит opCat(бул b);
    МассивБит opCat_r(бул b);
    МассивБит opCat(МассивБит b);

}
alias МассивБит BitArray ;


	