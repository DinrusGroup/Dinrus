module std.base64;

import std.x.base64;

const ткст РМАССИВСИМ = "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЫЪЭЮЯабвгдеёжзийклмнопрстуфхцчшщьыъэюя0123456789+/";
const ткст МАССИВСИМ = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЫЪЭЮЯабвгдеёжзийклмнопрстуфхцчшщьыъэюя0123456789+/";

export extern(D):

	бцел кодируйДлину64(бцел сдлин)
		{
		return cast(бцел) std.x.base64.encodeLength(cast(бцел) сдлин);
		}

	ткст кодируй64(ткст стр, ткст буф = ткст.init)
		{
		if(буф)	return cast(ткст) std.x.base64.encode(cast(сим[]) стр, cast(сим[]) буф);
		else return cast(ткст) std.x.base64.encode(cast(сим[])стр);
		}

	бцел раскодируйДлину64(бцел кдлин)
		{
		return cast(бцел) decodeLength(cast(бцел) кдлин);
		}

	ткст раскодируй64(ткст кстр, ткст буф = ткст.init)
		{
		if(буф) return cast(ткст) std.x.base64.decode(cast(сим[]) кстр, cast(сим[]) буф);
		else return cast(ткст) std.x.base64.decode(cast(сим[]) кстр);
		}





