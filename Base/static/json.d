/**
 * LibDJSON содержит функции и классы для чтения, парсинга и записи
 * документов JSON.
 *
 * Copyright:	(c) 2009 William K. Moore, III (nyphbl8d (at) gmail (dot) com, opticron on freeузел)
 * Authors:	William K. Moore, III
 * License:	Boost Software License - Version 1.0 - August 17th, 2003
 */

module json;

import stdrus:tostring=вТкст, убери, уберисправа, уберислева, разбей, замени, найди, сравни, сравнлюб, ткствцел,ткствдробь;
import stdrus: межбукв_ли, подставь, РегВыр, скажиф;

/// This is the interface implemented by all classes that represent JSON objects.
interface ТипДжейСОН {

	ткст вТкст();
	ткст вФТкст(ткст отступ);
	/// The парсируй method of this interface should ALWAYS be destructive, removing things from the front of исток as it parses.
	проц парсируй(ref ткст исток);
	/// Функция преобразования в ОбъектДжейСОН.
	/// Returns: The casted reference or пусто on a failed cast.
	ОбъектДжейСОН вОбъектДжейСОН();
	/// Функция преобразования в МассивДжейСОН.
	/// Returns: The casted reference or пусто on a failed cast.
	МассивДжейСОН вМассивДжейСОН();
	/// Функция преобразования в ТкстДжейСОН.
	/// Returns: The casted reference or пусто on a failed cast.
	ТкстДжейСОН вТкстДжейСОН();
	/// Функция преобразования в БулДжейСОН.
	/// Returns: The casted reference or пусто on a failed cast.
	БулДжейСОН вБулДжейСОН();
	/// Функция преобразования в ЧислоДжейСОН.
	/// Returns: The casted reference or пусто on a failed cast.
	ЧислоДжейСОН вЧислоДжейСОН();
	/// Функция преобразования в НуллДжейСОН.
	/// Returns: The casted reference or пусто on a failed cast.
	НуллДжейСОН вНуллДжейСОН();
	/// Associative массив index function for objects describing associative массив-like attributes.
	/// Returns: The chosen index or a пусто reference if the index does not exist.
	ТипДжейСОН opIndex(ткст ключ);
	/// Allow foreach over the object with ткст ключ.
	цел opApply(цел delegate(ткст,ТипДжейСОН) дг);
	/// Allow foreach over the object with ткст ключ и ref value.
	цел opApply(цел delegate(ткст,ref ТипДжейСОН) дг);
	/// Array index function for objects describing массив-like attributes.
	/// Returns: The chosen index or a пусто reference if the index does not exist.
	ТипДжейСОН opIndex(цел ключ);
	/// Allow foreach over the object with integer ключ.
	цел opApply(цел delegate(цел,ТипДжейСОН) дг);
	/// Allow foreach over the object with integer ключ и ref value.
	цел opApply(цел delegate(цел,ref ТипДжейСОН) дг);
	/// Convenience function for iteration that apply to both AA и массив тип operations
	цел opApply(цел delegate(ТипДжейСОН) дг);
	/// Convenience function for iteration that apply to both AA и массив тип operations with ref value
	цел opApply(цел delegate(ref ТипДжейСОН) дг);
}

extern(D):

	ткст регпредст(ткст ввод,ткст образец,ткст delegate(ткст) транслятор) {
		ткст tmpdel(РегВыр m) {
		m = new РегВыр(образец);
			return транслятор(m.сверь(0));
		}
		return подставь(ввод,образец,&tmpdel,"g");
	}


/**
 * Считывает весь ткст в дерево JSON.
 * Пример:
 * --------------------------------
 * auto root = new ОбъектДжейСОН();
 * auto arr = new МассивДжейСОН();
 * arr ~= new ТкстДжейСОН("da blue teeths!\"\\");
 * root["что is that on your ear?"] = arr;
 * root["my pants"] = new ТкстДжейСОН("are on fire");
 * root["i am this many"] = new ЧислоДжейСОН(10.253);
 * ткст jstr = root.вТкст;
 * writef("Unit Test libDJSON JSON creation...\n");
 * writef("Generated JSON ткст: ");writef(jstr);writef("\n");
 * writef("Regenerated JSON ткст: ");writef(читайДжейСОН(jstr).вТкст);writef("\n");
 * --------------------------------
 * Returns: A ОбъектДжейСОН with no имя that is the root of the document that was read.
 * Throws: ОшибкаДжейСОН on any parsing errors.
 */
ОбъектДжейСОН читайДжейСОН(ткст ист) {
	ткст pointcpy = ист;
	auto root = new ОбъектДжейСОН();
	try {
		root.парсируй(ист);
	} catch (ОшибкаДжейСОН e) {
		скажиф("Исключение при вводе текста: \n" ~ pointcpy ~ "\n");
		throw e;
	}
	return root;
}

/// An exception thrown on JSON parsing errors.
class ОшибкаДжейСОН : Исключение {

	// Throws an exception with an ошибка message.
	this(ткст msg) {
		super(msg);
	}
}

// everything needs these for ease of use
const ткст конвфункции = 
"
/// Функция преобразования в ОбъектДжейСОН
/// Returns: The casted object or пусто if the cast fails
ОбъектДжейСОН вОбъектДжейСОН(){return cast(ОбъектДжейСОН)this;}
/// Функция преобразования в МассивДжейСОН
/// Returns: The casted object or пусто if the cast fails
МассивДжейСОН вМассивДжейСОН(){return cast(МассивДжейСОН)this;}
/// Функция преобразования в ТкстДжейСОН
/// Returns: The casted object or пусто if the cast fails
ТкстДжейСОН вТкстДжейСОН(){return cast(ТкстДжейСОН)this;}
/// Функция преобразования в БулДжейСОН
/// Returns: The casted object or пусто if the cast fails
БулДжейСОН вБулДжейСОН(){return cast(БулДжейСОН)this;}
/// Функция преобразования в ЧислоДжейСОН
/// Returns: The casted object or пусто if the cast fails
ЧислоДжейСОН вЧислоДжейСОН(){return cast(ЧислоДжейСОН)this;}
/// Функция преобразования в НуллДжейСОН
/// Returns: The casted object or пусто if the cast fails
НуллДжейСОН вНуллДжейСОН(){return cast(НуллДжейСОН)this;}";
// only non-arrays need this
const ткст конвфункцииМ = 
"
/// Dummy function for types that don't implement integer indexing.  Throws an exception.
ТипДжейСОН opIndex(цел ключ) {throw new ОшибкаДжейСОН(typeof(this).stringof ~\" не поддерживает целочисленного индексирования, проверьте свою структуру JSON.\");}
/// Dummy function for types that don't implement integer indexing.  Throws an exception.
цел opApply(цел delegate(цел,ТипДжейСОН) дг) {throw new ОшибкаДжейСОН(typeof(this).stringof ~\" не поддерживает числового индекса foreach, проверьте свою структуру JSON.\");}
/// Dummy function for types that don't implement integer indexing.  Throws an exception.
цел opApply(цел delegate(цел,ref ТипДжейСОН) дг) {throw new ОшибкаДжейСОН(typeof(this).stringof ~\" не поддерживает числового индекса foreach, проверьте свою структуру JSON.\");}
";
// only non-AAs need this
const ткст конвфункцииАМ = 
"
/// Dummy function for types that don't implement ткст indexing.  Throws an exception.
ТипДжейСОН opIndex(ткст ключ) {throw new ОшибкаДжейСОН(typeof(this).stringof ~\" does not support ткст indexing, проверь your JSON structure.\");}
/// Dummy function for types that don't implement ткст indexing.  Throws an exception.
цел opApply(цел delegate(ткст,ТипДжейСОН) дг) {throw new ОшибкаДжейСОН(typeof(this).stringof ~\" does not support ткст index foreach, проверь your JSON structure.\");}
/// Dummy function for types that don't implement ткст indexing.  Throws an exception.
цел opApply(цел delegate(ткст,ref ТипДжейСОН) дг) {throw new ОшибкаДжейСОН(typeof(this).stringof ~\" does not support ткст index foreach, проверь your JSON structure.\");}
";
// neither arrays nor AAs need this
const ткст конвфункцииМАМ = 
"
/// Dummy function for types that don't implement any тип of indexing.  Throws an exception.
цел opApply(цел delegate(ТипДжейСОН) дг) {throw new ОшибкаДжейСОН(typeof(this).stringof ~\" does not support foreach, проверь your JSON structure.\");}
/// Dummy function for types that don't implement any тип of indexing.  Throws an exception.
цел opApply(цел delegate(ref ТипДжейСОН) дг) {throw new ОшибкаДжейСОН(typeof(this).stringof ~\" does not support foreach, проверь your JSON structure.\");}
";
/**
 * ОбъектДжейСОН represents a single JSON object узел и имеется methods for 
 * adding children.  All methods that make changes modify this
 * ОбъектДжейСОН rather than making a копируй, unless otherwise noted.  Many methods
 * return a self reference to allow cascaded calls.
 */
class ОбъектДжейСОН:ТипДжейСОН {

	/// Nothing to see here except for the boring constructor, move along.
	this(){}
	protected ТипДжейСОН[ткст] _ветви;
	/// Operator overload for установиting ключи in the AA.
	проц opIndexAssign(ТипДжейСОН тип,ткст ключ) {
		_ветви[ключ] = тип;
	}
	/// Operator overload for accessing значения already in the AA.
	/// Returns: The ветвь узел if it exists, otherwise пусто.
	ТипДжейСОН opIndex(ткст ключ) {
		return (ключ in _ветви)?_ветви[ключ]:пусто;
	}
	/// Allow the user to дай the number of элементы in this object
	/// Returns: The number of ветвь узелs contained внутри this ОбъектДжейСОН
	цел длина() {return _ветви.length;}
	/// Operator overload for foreach iteration through the object with значения only
	цел opApply(цел delegate(ТипДжейСОН) дг) {
		цел рез;
		foreach(ветвь;_ветви) {
			рез = дг(ветвь);
			if (рез) return рез;
		}
		return 0;
	}
	/// Operator overload for foreach iteration through the object with значения only и allow modification of the reference
	цел opApply(цел delegate(ref ТипДжейСОН) дг) {
		цел рез;
		foreach(ref ветвь;_ветви) {
			рез = дг(ветвь);
			if (рез) return рез;
		}
		return 0;
	}
	/// Operator overload for foreach iteration through the object with ключ и value
	цел opApply(цел delegate(ткст,ТипДжейСОН) дг) {
		цел рез;
		foreach(ключ,ветвь;_ветви) {
			рез = дг(ключ,ветвь);
			if (рез) return рез;
		}
		return 0;
	}
	/// Operator overload for foreach iteration through the object with ключ и value и allow modification of the reference
	цел opApply(цел delegate(ткст,ref ТипДжейСОН) дг) {
		цел рез;
		foreach(ключ,ref ветвь;_ветви) {
			рез = дг(ключ,ветвь);
			if (рез) return рез;
		}
		return 0;
	}

	/// A method to convert this ОбъектДжейСОН to a user-readable format.
	/// Returns: A JSON ткст representing this object и it's contents.
	override ткст вТкст() {
		ткст возвр;
		возвр ~= "{";
		foreach (ключ,знач;_ветви) {
			возвр ~= "\""~кодируйДжейСОН(ключ)~"\":"~знач.вТкст~",";
		}
		// rip off the trailing comma, we don't need it
		if (_ветви.length) возвр = возвр[0..$-1];
		возвр ~= "}";
		return возвр;
	}

	/// A method to convert this ОбъектДжейСОН to a formatted, user-readable format.
	/// Returns: A JSON ткст representing this object и it's contents.
	ткст вФТкст(ткст отступ=пусто) {
		ткст возвр;
		возвр ~= "{\n";
		foreach (ключ,знач;_ветви) {
			возвр ~= отступ~"	\""~кодируйДжейСОН(ключ)~"\":"~знач.вФТкст(отступ~"	")~",\n";
		}
		// rip off the trailing comma, we don't need it
		if (_ветви.length) возвр = возвр[0..$-2]~"\n";
		возвр ~= отступ~"}";
		return возвр;
	}

	/// This function parses a ОбъектДжейСОН out of a ткст
	проц парсируй(ref ткст исток) {
		// make sure the первый byte is {
		if (исток[0] != '{') throw new ОшибкаДжейСОН("Отсутствует открывающая скобка '{' в начале ОбъектДжейСОН: "~исток);
		// rip off the leading {
		исток = уберислева(исток[1..$]);
		while (исток[0] != '}') {
			if (исток[0] != '"') throw new ОшибкаДжейСОН("Отсутствует открывающая кавычка для ключа элемента перед: "~исток);
			// use ТкстДжейСОН class to помощь us out here (read, I'm lazy :D)
			auto jstr = new ТкстДжейСОН();
			jstr.парсируй(исток);
			исток = уберислева(исток);
			if (исток[0] != ':') throw new ОшибкаДжейСОН("Missing ':' after keystring in object before: "~исток);
			исток = уберислева(исток[1..$]);
			_ветви[jstr.дай] = помПарсинга(исток);
			исток = уберислева(исток);
			// handle end cases
			if (исток[0] == '}') continue;
			if (исток[0] != ',') throw new ОшибкаДжейСОН("Missing continuation via ',' or end of JSON object via '}' before "~исток);
			// rip the , in preparation for the next loop
			исток = уберислева(исток[1..$]);
			// make sure we don't have a ",}", since I'm assuming it's not allowed
			if (исток[0] == '}') throw new ОшибкаДжейСОН("Empty массив элементы (',' followed by '}') are not allowed. Fill the space or remove the comma.\nThis ошибка occurred before: "~исток);
		}
		// rip off the } и be done with it
		исток = уберислева(исток[1..$]);
	}
	mixin(конвфункции);
	mixin(конвфункцииМ);
}

/// МассивДжейСОН represents a single JSON массив, capable of being heterogenous
class МассивДжейСОН:ТипДжейСОН {

	/// Nothing to see here, move along.
	this(){}
	ТипДжейСОН[] _ветви;
	/// Operator overload to allow addition of children
	проц opCatAssign(ТипДжейСОН ветвь) {
	ТипДжейСОН в = ветвь;
		_ветви ~= в;
	}
	/// Operator overload to allow доступ of children
	/// Returns: The ветвь узел if it exists, otherwise пусто.
	ТипДжейСОН opIndex(цел ключ) {
		return _ветви[ключ];
	}
	/// Allow the user to дай the number of элементы in this object
	/// Returns: The number of ветвь узелs contained внутри this ОбъектДжейСОН
	цел длина() {return _ветви.length;}
	/// Operator overload for foreach iteration through the массив with значения only
	цел opApply(цел delegate(ТипДжейСОН) дг) {
		цел рез;
		foreach(ветвь;_ветви) {
			рез = дг(ветвь);
			if (рез) return рез;
		}
		return 0;
	}
	/// Operator overload for foreach iteration through the массив with значения only и allow modification of the reference
	цел opApply(цел delegate(ref ТипДжейСОН) дг) {
		цел рез;
		foreach(ref ветвь;_ветви) {
			рез = дг(ветвь);
			if (рез) return рез;
		}
		return 0;
	}
	/// Operator overload for foreach iteration through the массив with ключ и value
	цел opApply(цел delegate(цел,ТипДжейСОН) дг) {
		цел рез;
		foreach(ключ,ветвь;_ветви) {
			рез = дг(ключ,ветвь);
			if (рез) return рез;
		}
		return 0;
	}
	/// Operator overload for foreach iteration through the массив with ключ и value и allow modification of the reference
	цел opApply(цел delegate(цел,ref ТипДжейСОН) дг) {
		цел рез;
		foreach(ключ,ref ветвь;_ветви) {
			рез = дг(ключ,ветвь);
			if (рез) return рез;
		}
		return 0;
	}

	/// A method to convert this МассивДжейСОН to a user-readable format.
	/// Returns: A JSON ткст representing this object и it's contents.
	override ткст вТкст() {
		ткст возвр;
		возвр ~= "[";
		foreach (знач;_ветви) {
			возвр ~= знач.вТкст~",";
		}
		// rip off the trailing comma, we don't need it
		if (_ветви.length) возвр = возвр[0..$-1];
		возвр ~= "]";
		return возвр;
	}

	/// A method to convert this МассивДжейСОН to a formatted, user-readable format.
	/// Returns: A JSON ткст representing this object и it's contents.
	ткст вФТкст(ткст отступ=пусто) {
		ткст возвр;
		возвр ~= "[\n";
		foreach (знач;_ветви) {
			возвр ~= отступ~"	"~знач.вФТкст(отступ~"	")~",\n";
		}
		// rip off the trailing comma, we don't need it
		if (_ветви.length) возвр = возвр[0..$-2]~"\n";
		возвр ~= отступ~"]";
		return возвр;
	}

	/// This function parses a МассивДжейСОН out of a ткст
	проц парсируй(ref ткст исток) {
		if (исток[0] != '[') throw new ОшибкаДжейСОН("Missing открой brace '[' at start of МассивДжейСОН парсируй: "~исток);
		// rip off the leading [
		исток = уберислева(исток[1..$]);
		while (исток[0] != ']') {
			_ветви ~= помПарсинга(исток);
			исток = уберислева(исток);
			// handle end cases
			if (исток[0] == ']') continue;
			if (исток[0] != ',') throw new ОшибкаДжейСОН("Missing continuation via ',' or end of JSON массив via ']' before "~исток);
			// rip the , in preparation for the next loop
			исток = уберислева(исток[1..$]);
			// make sure we don't have a ",]", since I'm assuming it's not allowed
			if (исток[0] == ']') throw new ОшибкаДжейСОН("Empty массив элементы (',' followed by ']') are not allowed. Fill the space or remove the comma.\nThis ошибка occurred before: "~исток);
		}
		// rip off the ] и be done with it
		исток = уберислева(исток[1..$]);
	}
	mixin(конвфункции);
	mixin(конвфункцииАМ);
}

/// ТкстДжейСОН represents a JSON ткст.  Internal representation is escaped for faster parsing и JSON generation.
class ТкстДжейСОН:ТипДжейСОН {

	/// The boring default constructor.
	this(){}
	/// The ever so slightly more interesting initializing constructor.
	this(ткст данные) {установи(данные);}
	protected ткст _данные;
	/// Allow the данные to be установи so the object can be reused.
	проц установи(ткст данные) {_данные = кодируйДжейСОН(данные);}
	/// Allow the данные to be retreived.
	ткст дай() {return раскодируйДжейСОН(_данные);}

	/// A method to convert this ТкстДжейСОН to a user-readable format.
	/// Returns: A JSON ткст representing this object и it's contents.
	override ткст вТкст() {
		return "\""~_данные~"\"";
	}

	/// A method to convert this ТкстДжейСОН to a formatted, user-readable format.
	/// Returns: A JSON ткст representing this object и it's contents.
	ткст вФТкст(ткст отступ=пусто) {
		return вТкст;
	}

	/// This function parses a МассивДжейСОН out of a ткст и eats characters as it goes, hence the ref ткст parameter.
	проц парсируй(ref ткст исток) {
		if (исток[0] != '"') throw new ОшибкаДжейСОН("Отсутствует открывающая кавычка '\"' в начале массиваДжейСОН: "~исток);
		// rip off the leading [
		исток = исток[1..$];
		// scan to найди the closing quote
		цел bscount = 0;
		цел sliceloc = -1;
		for(цел i = 0;i<исток.length;i++) {
			switch(исток[i]) {
			case '\\':
				bscount++;
				continue;
			case '"':
				// if the count is even, backslashes cancel и we have the end of the ткст, otherwise cascade
				if (bscount%2 == 0) {
					break;
				}
			default:
				bscount = 0;
				continue;
			}
			// we have reached the terminating case! huzzah!
			sliceloc = i;
			break;
		}
		// возьми care of failure to найди the end of the ткст
		if (sliceloc == -1) throw new ОшибкаДжейСОН("Не удалось найти конец текста JSON,\n начинающегося с: "~исток);
		_данные = исток[0..sliceloc];
		// eat the " that is known to be there
		исток = уберислева(исток[sliceloc+1..$]);
	}
	mixin(конвфункции);
	mixin(конвфункцииМ);
	mixin(конвфункцииАМ);
	mixin(конвфункцииМАМ);
}

/// БулДжейСОН represents a JSON булean value.
class БулДжейСОН:ТипДжейСОН {

	/// The boring constructor, again.
	this(){}
	/// Only a bit of ввод for this constructor.
	this(бул данные) {_данные = данные;}
	/// Allow установиting of the hidden bit.
	проц установи(бул данные) {_данные = данные;}
	/// Allow the bit to be retreived.
	бул дай() {return _данные;}
	protected бул _данные;

	/// A method to convert this БулДжейСОН to a user-readable format.
	/// Returns: A JSON ткст representing this object и it's contents.
	override ткст вТкст() {
		if (_данные) return "true";
		return "false";
	}

	/// A method to convert this БулДжейСОН to a formatted, user-readable format.
	/// Returns: A JSON ткст representing this object и it's contents.
	ткст вФТкст(ткст отступ=пусто) {
		return вТкст;
	}

	/// This function parses a БулДжейСОН out of a ткст и eats characters as it goes, hence the ref ткст parameter.
	проц парсируй(ref ткст исток) {
		if (исток[0..4] == "true") {
			исток = уберислева(исток[4..$]);
		} else if (исток[0..5] == "false") {
			исток = уберислева(исток[5..$]);
		} else throw new ОшибкаДжейСОН("Не удаётся парсировать булеву переменную JSON из: "~исток);
	}
	mixin(конвфункции);
	mixin(конвфункцииМ);
	mixin(конвфункцииАМ);
	mixin(конвфункцииМАМ);
}

/// НуллДжейСОН represents a JSON пусто value.
class НуллДжейСОН:ТипДжейСОН {

	/// You're forced to use the boring constructor here.
	this(){}

	/// A method to convert this НуллДжейСОН to a user-readable format.
	/// Returns: "пусто". Always. Forever.
	override ткст вТкст() {
		return "null";
	}

	/// A method to convert this НуллДжейСОН to a formatted, user-readable format.
	/// Returns: "null". Always. Forever.
	ткст вФТкст(ткст отступ=пусто) {
		return вТкст;
	}

	/// This function parses a НуллДжейСОН out of a ткст.  Really, it just rips "пусто" off the beginning of the ткст и eats whitespace.
	проц парсируй(ref ткст исток) in { assert(исток[0..4] == "null"); } body {
		исток = уберислева(исток[4..$]);
	}
	mixin(конвфункции);
	mixin(конвфункцииМ);
	mixin(конвфункцииАМ);
	mixin(конвфункцииМАМ);
}

/// ЧислоДжейСОН represents any JSON numeric value.
class ЧислоДжейСОН:ТипДжейСОН {

	/// Another boring constructor...
	this(){}
	/// ...и its slightly less boring sibling.
	this(real данные) {_данные = данные;}
	/// Allow установиting of the hidden number.
	проц установи(real данные) {_данные = данные;}
	/// Allow the number to be retreived.
	real дай() {return _данные;}
	protected real _данные;

	/// A method to convert this ЧислоДжейСОН to a user-readable format.
	/// Returns: A JSON ткст representing this number.
	override ткст вТкст() {
		return tostring(_данные);
	}

	/// A method to convert this ЧислоДжейСОН to a formatted, user-readable format.
	/// Returns: A JSON ткст representing this number.
	ткст вФТкст(ткст отступ=пусто) {
		return вТкст;
	}

	/// This function parses a ЧислоДжейСОН out of a ткст и eats characters as it goes, hence the ref ткст parameter.
	проц парсируй(ref ткст исток) {
		// this parser sucks...
		цел i = 0;
		// проверь for leading minus знак
		if (исток[i] == '-') i++;
		// sift through whole numerics
		if (исток[i] == '0') {
			i++;
		} else if (исток[i] <= '9' && исток[i] >= '1') {
			while (исток[i] >= '0' && исток[i] <= '9') i++;
		} else throw new ОшибкаДжейСОН("Произошла ошибка парсинга числа при парсировании числа,\n начинающегося с: "~исток);
		// if the next сим is not a '.', we know we're done with fractional parts 
		if (исток[i] == '.') {
			i++;
			while (исток[i] >= '0' && исток[i] <= '9') i++;
		}
		// if the next сим is e or Е, we're poking at an exponential
		if (исток[i] == 'e' || исток[i] == 'Е') {
			i++;
			if (исток[i] == '-' || исток[i] == '+') i++;
			while (исток[i] >= '0' && исток[i] <= '9') i++;
		}
		_данные = ткствдробь(исток[0..i]);
		исток = уберислева(исток[i..$]);
	}
	mixin(конвфункции);
	mixin(конвфункцииМ);
	mixin(конвфункцииАМ);
	mixin(конвфункцииМАМ);
}

private ТипДжейСОН помПарсинга(ref ткст исток) {
	ТипДжейСОН возвр;
	switch(исток[0]) {
	case '{':
		возвр = new ОбъектДжейСОН();
		break;
	case '[':
		возвр = new МассивДжейСОН();
		break;
	case '"':
		возвр = new ТкстДжейСОН();
		break;
	case '-','0','1','2','3','4','5','6','7','8','9':
		возвр = new ЧислоДжейСОН();
		break;
	default:
		// you need at least 5 characters for true or пусто и a closing character, this makes the slice for false safe
		if (исток.length < 5) throw new ОшибкаДжейСОН("Проблема с парсингом остатка текста, начиная со следующей точки: "~исток);
		if (исток[0..4] == "null") возвр = new НуллДжейСОН();
		else if (исток[0..4] == "true" || исток[0..5] == "false") возвр = new БулДжейСОН();
		else throw new ОшибкаДжейСОН("Не удаётся определить тип следующего элемента, начинающегося с: "~исток);
		break;
	}
	возвр.парсируй(исток);
	return возвр;
}

/// Perform JSON escapes on a ткст
/// Returns: A JSON encoded ткст
ткст кодируйДжейСОН(ткст ист) {
	ткст времСтр;
        времСтр = замени(ист    , "\\", "\\\\");
        времСтр = замени(времСтр, "\"", "\\\"");
        return времСтр;
}

/// Unescape a JSON ткст
/// Returns: A decoded ткст.
ткст раскодируйДжейСОН(ткст ист) {
	ткст времСтр;
        времСтр = замени(ист    , "\\\\", "\\");
        времСтр = замени(времСтр, "\\\"", "\"");
        времСтр = замени(времСтр, "\\/", "/");
        времСтр = замени(времСтр, "\\n", "\n");
        времСтр = замени(времСтр, "\\r", "\r");
        времСтр = замени(времСтр, "\\f", "\f");
        времСтр = замени(времСтр, "\\t", "\t");
        времСтр = замени(времСтр, "\\b", "\b");
	// возьми care of hex character entities
	// XXX regex is broken in tango 0.99.9 which means this doesn't work right when numbers enter the mix
	времСтр = регпредст(времСтр,"\\u[0-9a-fA-F]{4};",(ткст m) {
		auto cnum = m[3..$-1];
		дим dnum = гексвдим(cnum[1..$]);
		return быстрЮ8(dnum);
	});
        return времСтр;
}

/// This probably needs documentation.  It looks like it converts a дим to the necessary length ткст of chars.
ткст быстрЮ8(дим dachar) {
	ткст возвр;
	if (dachar <= 0x7F) {
		возвр.length = 1;
		возвр[0] = cast(сим) dachar;
	} else if (dachar <= 0x7FF) {
		возвр.length = 2;
		возвр[0] = cast(сим)(0xC0 | (dachar >> 6));
		возвр[1] = cast(сим)(0x80 | (dachar & 0x3F));
	} else if (dachar <= 0xFFFF) {
		возвр.length = 3;
		возвр[0] = cast(сим)(0xE0 | (dachar >> 12));
		возвр[1] = cast(сим)(0x80 | ((dachar >> 6) & 0x3F));
		возвр[2] = cast(сим)(0x80 | (dachar & 0x3F));
	} else if (dachar <= 0x10FFFF) {
		возвр.length = 4;
		возвр[0] = cast(сим)(0xF0 | (dachar >> 18));
		возвр[1] = cast(сим)(0x80 | ((dachar >> 12) & 0x3F));
		возвр[2] = cast(сим)(0x80 | ((dachar >> 6) & 0x3F));
		возвр[3] = cast(сим)(0x80 | (dachar & 0x3F));
	} else {
	    assert(0);
	}
	return cast(ткст)возвр;
}
private дим гексвдим (ткст hex) {
	дим рез;
	foreach(цифра;hex) {
		рез <<= 4;
		рез |= вГЗнач(цифра);
	}
	return рез;
}

private дим вГЗнач(сим цифра) {
	if (цифра >= '0' && цифра <= '9') {
		return цифра-'0';
	}
	if (цифра >= 'a' && цифра <= 'f') {
		return цифра-'a';
	}
	if (цифра >= 'A' && цифра <= 'F') {
		return цифра-'A';
	}
	return 0;
}

unittest {
	auto root = new ОбъектДжейСОН();
	auto arr = new МассивДжейСОН();
	arr ~= new ТкстДжейСОН("da blue teeths!\"\\");
	root["что is that on your ear?"] = arr;
	root["my pants"] = new ТкстДжейСОН("are on fire");
	root["i am this many"] = new ЧислоДжейСОН(10.253);
	root["blank"] = new ОбъектДжейСОН();
	ткст jstr = root.вТкст;
	writef("Unit Test libDJSON JSON creation...\n");
	writef("Generated JSON ткст: " ~ jstr ~ "\n");
	writef("Regenerated JSON ткст: " ~ читайДжейСОН(jstr).вТкст ~ "\n");
	writef("Output using вФТкст:\n"~root.вФТкст~"\nEnd pretty output\n");
	assert(jstr == читайДжейСОН(jstr).вТкст);
	writef("Unit Test libDJSON JSON parsing...\n");
	jstr = "{\"firstName\": \"John\",\"lastName\": \"Smith\",\"address\": {\"streetAddress\": \"21 2nd Street\",\"city\": \"Нов York\",\"state\": \"NY\",\"postalCode\": 10021},\"phoneNumbers\": [{ \"тип\": \"home\", \"number\": \"212 555-1234\" },{ \"тип\": \"fax\", \"number\": \"646 555-4567\" }],\"newSubscription\": false,\"companyName\": пусто }";
	writef("Sample JSON ткст: " ~ jstr ~ "\n");
	jstr = jstr.читайДжейСОН().вТкст;
	writef("Parsed JSON ткст: " ~ jstr ~ "\n");
	writef("Output using вФТкст:\n"~jstr.читайДжейСОН().вФТкст~"\nEnd pretty output\n");
	// ensure that the ткст doesn't измени after a секунда reading, it shouldn't
	assert(jstr.читайДжейСОН().вТкст == jstr);
	// ensure that pretty output still parses properly и doesn't измени
	jstr = jstr.читайДжейСОН().вФТкст;
	assert(jstr.читайДжейСОН().вФТкст == jstr);
	writef("Unit Test libDJSON JSON доступ...\n");
	writef("Got первый имя:" ~ jstr.читайДжейСОН()["firstName"].вТкстДжейСОН.дай ~ "\n");
	writef("Got последний имя:" ~ jstr.читайДжейСОН()["lastName"].вТкстДжейСОН.дай ~ "\n");
	writef("Unit Test libDJSON opApply interface...\n");
	foreach(объ;jstr.читайДжейСОН()["phoneNumbers"]) {
		writef("Got " ~ объ["тип"].вТкстДжейСОН.дай ~ " phone number:" ~ объ["number"].вТкстДжейСОН.дай ~ "\n");
	}
	writef("Unit Test libDJSON opIndex interface to ensure breakage where incorrectly использован...\n");
	try {
		jstr.читайДжейСОН()[5];
		assert(false,"An exception should have been thrown on the line above.");
	} catch (Исключение e) {/*shazam! program flow should дай here, it is a correct thing*/}
}

version(JSON_main) {
	проц main(){}
}
