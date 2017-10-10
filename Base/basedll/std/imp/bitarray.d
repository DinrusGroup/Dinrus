
module std.bitarray;
private import std.intrinsic;

export extern(D) struct МассивБит
{
    т_мера длин;
    бцел* укз;

	alias  укз ptr;

	export т_мера разм();
    т_мера dim();
	export т_мера длина();
    т_мера length();
	export проц длина(т_мера новдлин);
    проц length(т_мера новдлин);
  export  бул opIndex(т_мера i);
   export бул opIndexAssign(бул b, т_мера i);
	export МассивБит дубль();
    МассивБит dup();
   export цел opApply(цел delegate(inout бул) дг);
   export цел opApply(цел delegate(inout т_мера, inout бул) дг);
	export МассивБит реверсни();
    МассивБит reverse();
	export МассивБит сортируй();
    МассивБит sort();
    export цел opEquals(МассивБит a2);
   export цел opCmp(МассивБит a2);
	export проц иниц(бул[] бм);
    проц init(бул[] ba);
	export проц иниц(проц[] в, т_мера члобит);
    проц init(проц[] v, т_мера numbits);
  export  проц[] opCast();
  export  МассивБит opCom();
  export  МассивБит opAnd(МассивБит e2);
    export МассивБит opOr(МассивБит e2);
   export МассивБит opXor(МассивБит e2);
  export  МассивБит opSub(МассивБит e2);
   export МассивБит opAndAssign(МассивБит e2);
   export МассивБит opOrAssign(МассивБит e2);
   export МассивБит opXorAssign(МассивБит e2);
   export МассивБит opSubAssign(МассивБит e2);
    export МассивБит opCatAssign(бул b);
   export МассивБит opCatAssign(МассивБит b);
   export МассивБит opCat(бул b);
   export МассивБит opCat_r(бул b);
  export  МассивБит opCat(МассивБит b);

}

alias МассивБит BitArray ;

alias МассивБит.длин len;
alias МассивБит.ук ptr;
alias МассивБит.разм dim;
alias МассивБит.длина length;
alias МассивБит.дубль dup;
alias МассивБит.реверсни reverse;
alias МассивБит.сортируй sort;
alias МассивБит.иниц init;
	