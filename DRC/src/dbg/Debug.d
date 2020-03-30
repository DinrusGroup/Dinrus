/**
 Common interfaces for the debugging package.

 Authors:
	Jeremie Pelletier
*/
module dbg.Debug;

interface IExecutableImage {
	бцел codeOffset() ;

	ISymbolicDebugInfo debugInfo();
}

interface ISymbolicDebugInfo {
	SymbolInfo ResolveSymbol(т_мера rva) ;
	FileLineInfo ResolveFileLine(т_мера rva) ;
}

struct SymbolInfo {
	ткст	имя;
	бцел	смещение;
}

struct FileLineInfo {
	ткст	файл;
	бцел	line;
}

проц SystemException()
{
	throw new Exception("SystemException");
}