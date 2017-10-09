module std.utf;
import std.x.utf;

export extern(D):

	бул дим_ли(дим д){return std.x.utf.isValidDchar(д);}
	бцел байтЮ(ткст т, т_мера и)
		{
		бцел б = std.x.utf.stride(т, и);
		if(б == 0xFF)
			{ win.скажинс("бцел байтЮ(ткст т, т_мера и): ткт[индкс] не является началом последовательности UTF-8");
			}
		return б;
		}

	бцел байтЮ(шткст т, т_мера и)
		{
		бцел б = std.x.utf.stride(т, и);
		if(б == 0xFF)
			{ win.скажинс("бцел байтЮ(шткст т, т_мера и): ткт[индкс] не является началом последовательности UTF-16");
			}
		return б;
		}

	бцел байтЮ(юткст т, т_мера и)
		{
		бцел б = std.x.utf.stride(т, и);
		if(б == 0xFF)
			{ win.скажинс("бцел байтЮ(юткст т, т_мера и): ткт[индкс] не является началом последовательности UTF-32");
			}
		return б;
		}

	т_мера доИндексаУНС(ткст т, т_мера и){return std.x.utf.toUCSindex(т, и);}
	т_мера доИндексаУНС(шткст т, т_мера и){return std.x.utf.toUCSindex(т, и);}
	т_мера доИндексаУНС(юткст т, т_мера и){return std.x.utf.toUCSindex(т, и);}
	т_мера вИндексЮ(ткст т, т_мера и){return std.x.utf.toUCSindex(т, и);}
	т_мера вИндексЮ(шткст т, т_мера и){return std.x.utf.toUCSindex(т, и);}
	т_мера вИндексЮ(юткст т, т_мера и){return std.x.utf.toUCSindex(т, и);}
	дим раскодируйЮ(ткст т, inout т_мера инд){return std.x.utf.decode(т, инд);}
	дим раскодируйЮ(шткст т, inout т_мера инд){return std.x.utf.decode(т, инд);}
	дим раскодируйЮ(юткст т, inout т_мера инд){return std.x.utf.decode(т, инд);}
	проц кодируйЮ(inout ткст т, дим с){std.x.utf.encode(т, с);}
	проц кодируйЮ(inout шткст т, дим с){std.x.utf.encode(т, с);}
	проц кодируйЮ(inout юткст т, дим с){std.x.utf.encode(т, с);}
	проц оцениЮ(ткст т){std.x.utf.validate(т);}
	проц оцениЮ(шткст т){std.x.utf.validate(т);}
	проц оцениЮ(юткст т){std.x.utf.validate(т);}
	ткст вЮ8(сим[4] буф, дим с){return std.x.utf.toUTF8(буф, с);}
	ткст вЮ8(ткст т){return std.x.utf.toUTF8(т);}
	ткст вЮ8(шткст т){return std.x.utf.toUTF8(т);}
	ткст вЮ8(юткст т){return std.x.utf.toUTF8(т);}
	шткст вЮ16(шим[2] буф, дим с){return std.x.utf.toUTF16(буф, с);}
	шткст вЮ16(ткст т){return std.x.utf.toUTF16(т);}
	шим* вЮ16н(ткст т){return std.x.utf.toUTF16z(т);}
	шткст вЮ16(шткст т){return std.x.utf.toUTF16(т);}
	шткст вЮ16(юткст т){return std.x.utf.toUTF16(т);}
	юткст вЮ32(ткст т){return std.x.utf.toUTF32(т);}
	юткст вЮ32(шткст т){return std.x.utf.toUTF32(т);}
	юткст вЮ32(юткст т){return std.x.utf.toUTF32(т);}
