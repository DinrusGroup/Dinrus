module std.base64;
pragma(lib, "DinrusStd.lib");


version DinrusStd{

pragma(lib, "DinrusStd.lib");
public import stdrus: кодируйДлину64, кодируй64, раскодируйДлину64, раскодируй64;
}
else
{

	extern(D)
	{

	бцел кодируйДлину64(бцел сдлин);
	ткст кодируй64(ткст стр, ткст буф = ткст.init);
	бцел раскодируйДлину64(бцел кдлин);
	ткст раскодируй64(ткст кстр, ткст буф = ткст.init);
    }
}

alias кодируйДлину64 encodeLength;
alias кодируй64 encode;
alias раскодируйДлину64 decodeLength;		
alias раскодируй64 decode;
