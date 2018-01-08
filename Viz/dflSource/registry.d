//Автор Кристофер Миллер. Переработано для Динрус Виталием Кулич.
//Библиотека визуальных конпонентов VIZ (первоначально DFL).


// Not actually part of forms, but is handy.

module viz.registry;

private import viz.x.dlib;

private import viz.x.winapi, viz.base, viz.x.utf;


class DflRegistryException: ВизИскл // package
{
	this(Ткст сооб, цел errorCode = 0)
	{
		this.errorCode = errorCode;
		debug
		{
			if(errorCode)
				сооб = сооб ~ " (ошибка " ~ вТкст(errorCode) ~ ")"; // Dup.
		}
		super(сооб);
	}
	
	
	цел errorCode;
}


class Registry // docmain
{
	private this() {}
	
	
	static:
	
		RegistryKey classesRoot() // getter
	{
		if(!_classesRoot)
			_classesRoot = new RegistryKey(HKEY_CLASSES_ROOT, нет);
		return _classesRoot;
	}
	
	
	RegistryKey currentConfig() // getter
	{
		if(!_currentConfig)
			_currentConfig = new RegistryKey(HKEY_CURRENT_CONFIG, нет);
		return _currentConfig;
	}
	
	
	RegistryKey currentUser() // getter
	{
		if(!_currentUser)
			_currentUser = new RegistryKey(HKEY_CURRENT_USER, нет);
		return _currentUser;
	}
	
	
	RegistryKey dynData() // getter
	{
		if(!_dynData)
			_dynData = new RegistryKey(HKEY_DYN_DATA, нет);
		return _dynData;
	}
	
	
	RegistryKey localMachine() // getter
	{
		if(!_localMachine)
			_localMachine = new RegistryKey(HKEY_LOCAL_MACHINE, нет);
		return _localMachine;
	}
	
	
	RegistryKey performanceData() // getter
	{
		if(!_performanceData)
			_performanceData = new RegistryKey(HKEY_PERFORMANCE_DATA, нет);
		return _performanceData;
	}
	
	
	RegistryKey users() // getter
	{
		if(!_users)
			_users = new RegistryKey(HKEY_USERS, нет);
		return _users;
	}
	
	
	private:
	RegistryKey _classesRoot;
	RegistryKey _currentConfig;
	RegistryKey _currentUser;
	RegistryKey _dynData;
	RegistryKey _localMachine;
	RegistryKey _performanceData;
	RegistryKey _users;
	
	
	/+
	static this()
	{
		_classesRoot = new RegistryKey(HKEY_CLASSES_ROOT, нет);
		_currentConfig = new RegistryKey(HKEY_CURRENT_CONFIG, нет);
		_currentUser = new RegistryKey(HKEY_CURRENT_USER, нет);
		_dynData = new RegistryKey(HKEY_DYN_DATA, нет);
		_localMachine = new RegistryKey(HKEY_LOCAL_MACHINE, нет);
		_performanceData = new RegistryKey(HKEY_PERFORMANCE_DATA, нет);
		_users = new RegistryKey(HKEY_USERS, нет);
	}
	+/
}


private const бцел MAX_REG_BUFFER = 256;


abstract class RegistryValue
{
	DWORD valueType(); // getter
	Ткст вТкст();
	/+ package +/ protected LONG save(HKEY hkey, Ткст имя); // package
	package final RegistryValue _reg() { return this; }
}


class RegistryValueSz: RegistryValue
{
		Ткст значение;
	
	
		this(Ткст str)
	{
		this.значение = str;
	}
	
	
	this()
	{
	}
	
	
	override DWORD valueType() // getter
	{
		return REG_SZ;
	}
	
	
	Ткст вТкст()
	{
		return значение;
	}
	
	
	/+ package +/ protected override LONG save(HKEY hkey, Ткст имя) // package
	{
		auto valuez = небезопТкст0(значение);
		return RegSetValueExA(hkey, небезопТкст0(имя), 0, REG_SZ, cast(BYTE*)valuez, значение.length + 1);
	}
}


/+
// Extra.
class RegistryValueSzW: RegistryValue
{
		wDstring значение;
	
	
		this(wDstring str)
	{
		this.значение = str;
	}
	
	
	this()
	{
	}
	
	
	override DWORD valueType() // getter
	{
		return REG_SZ;
	}
	
	
	Ткст вТкст()
	{
		return вЮ8(значение);
	}
	
	
	/+ package +/ protected override LONG save(HKEY hkey, Ткст имя) // package
	{
		if(viz.x.utf.использоватьЮникод)
		{
			
		}
		else
		{
			
		}
	}
}
+/


class RegistryValueMultiSz: RegistryValue
{
		Ткст[] значение;
	
	
		this(Ткст[] strs)
	{
		this.значение = strs;
	}
	
	
	this()
	{
	}
	
	
	override DWORD valueType() // getter
	{
		return REG_MULTI_SZ;
	}
	
	
	Ткст вТкст()
	{
		Ткст результат;
		foreach(Ткст str; значение)
		{
			результат ~= str ~ \r\n;
		}
		if(результат.length)
			результат = результат[0 .. результат.length - 2]; // Exclude last \r\n.
		return результат;
	}
	
	
	/+ package +/ protected override LONG save(HKEY hkey, Ткст имя) // package
	{
		сим[] multi;
		бцел i;
		
		i = значение.length + 1; // Each NUL and the extra terminating NUL.
		foreach(Ткст s; значение)
		{
			i += s.length;
		}
		
		multi = new сим[i];
		foreach(Ткст s; значение)
		{
			if(!s.length)
				throw new DflRegistryException("Empty strings are not allowed in multi_sz registry значения");
			
			multi[i .. i + s.length] = s;
			i += s.length;
			multi[i++] = 0;
		}
		multi[i++] = 0;
		assert(i == multi.length);
		
		return RegSetValueExA(hkey, небезопТкст0(имя), 0, REG_MULTI_SZ, cast(BYTE*)multi, multi.length);
	}
}


class RegistryValueExpandSz: RegistryValue
{
		Ткст значение;
	
	
		this(Ткст str)
	{
		this.значение = str;
	}
	
	
	this()
	{
	}
	
	
	override DWORD valueType() // getter
	{
		return REG_EXPAND_SZ;
	}
	
	
	Ткст вТкст()
	{
		return значение;
	}
	
	
	/+ package +/ protected override LONG save(HKEY hkey, Ткст имя) // package
	{
		auto valuez = небезопТкст0(значение);
		return RegSetValueExA(hkey, небезопТкст0(имя), 0, REG_EXPAND_SZ, cast(BYTE*)valuez, значение.length + 1);
	}
}


private Ткст dwordToString(DWORD dw)
out(результат)
{
	assert(результат.length == 10);
	assert(результат[0 .. 2] == "0x");
	foreach(сим ch; результат[2 .. результат.length])
	{
		assert(_цифраикс_ли(ch));
	}
}
body
{
	сим[] результат;
	Ткст stmp;
	бцел ntmp;
	
	stmp = бцелВГексТкст(dw);
	assert(stmp.length <= 8);
	ntmp = 8 - stmp.length + 2; // Plus 0x.
	результат = new сим[ntmp + stmp.length];
	результат[0 .. 2] = "0x";
	результат[2 .. ntmp] = '0';
	результат[ntmp .. результат.length] = stmp;
	
	//return результат;
	return cast(Ткст)результат; // Needed in D2.
}


unittest
{
	assert(dwordToString(0x8934) == "0x00008934");
	assert(dwordToString(0xF00BA2) == "0x00F00BA2");
	assert(dwordToString(0xBADBEEF0) == "0xBADBEEF0");
	assert(dwordToString(0xCAFEBEEF) == "0xCAFEBEEF");
	assert(dwordToString(0x09090BB) == "0x009090BB");
	assert(dwordToString(0) == "0x00000000");
}


class RegistryValueDword: RegistryValue
{
		DWORD значение;
	
	
		this(DWORD dw)
	{
		this.значение = dw;
	}
	
	
	this()
	{
	}
	
	
	override DWORD valueType() // getter
	{
		return REG_DWORD;
	}
	
	
	Ткст вТкст()
	{
		return dwordToString(значение);
	}
	
	
	/+ package +/ protected override LONG save(HKEY hkey, Ткст имя) // package
	{
		return RegSetValueExA(hkey, небезопТкст0(имя), 0, REG_DWORD, cast(BYTE*)&значение, DWORD.sizeof);
	}
}


alias RegistryValueDword RegistryValueDwordLittleEndian;


class RegistryValueDwordBigEndian: RegistryValue
{
		DWORD значение;
	
	
		this(DWORD dw)
	{
		this.значение = dw;
	}
	
	
	this()
	{
	}
	
	
	override DWORD valueType() // getter
	{
		return REG_DWORD_BIG_ENDIAN;
	}
	
	
	Ткст вТкст()
	{
		return dwordToString(значение);
	}
	
	
	/+ package +/ protected override LONG save(HKEY hkey, Ткст имя) // package
	{
		return RegSetValueExA(hkey, небезопТкст0(имя), 0, REG_DWORD_BIG_ENDIAN, cast(BYTE*)&значение, DWORD.sizeof);
	}
}


class RegistryValueBinary: RegistryValue
{
		проц[] значение;
	
	
		this(проц[] val)
	{
		this.значение = val;
	}
	
	
	this()
	{
	}
	
	
	override DWORD valueType() // getter
	{
		return REG_BINARY;
	}
	
	
	Ткст вТкст()
	{
		return "Binary";
	}
	
	
	/+ package +/ protected override LONG save(HKEY hkey, Ткст имя) // package
	{
		return RegSetValueExA(hkey, небезопТкст0(имя), 0, REG_BINARY, cast(BYTE*)значение, значение.length);
	}
}


class RegistryValueLink: RegistryValue
{
		проц[] значение;
	
	
		this(проц[] val)
	{
		this.значение = val;
	}
	
	
	this()
	{
	}
	
	
	override DWORD valueType() // getter
	{
		return REG_LINK;
	}
	
	
	Ткст вТкст()
	{
		return "Symbolic Link";
	}
	
	
	/+ package +/ protected override LONG save(HKEY hkey, Ткст имя) // package
	{
		return RegSetValueExA(hkey, небезопТкст0(имя), 0, REG_LINK, cast(BYTE*)значение, значение.length);
	}
}


class RegistryValueResourceList: RegistryValue
{
		проц[] значение;
	
	
		this(проц[] val)
	{
		this.значение = val;
	}
	
	
	this()
	{
	}
	
	
	override DWORD valueType() // getter
	{
		return REG_RESOURCE_LIST;
	}
	
	
	Ткст вТкст()
	{
		return "Resource List";
	}
	
	
	/+ package +/ protected override LONG save(HKEY hkey, Ткст имя) // package
	{
		return RegSetValueExA(hkey, небезопТкст0(имя), 0, REG_RESOURCE_LIST, cast(BYTE*)значение, значение.length);
	}
}


class RegistryValueNone: RegistryValue
{
		проц[] значение;
	
	
		this(проц[] val)
	{
		this.значение = val;
	}
	
	
	this()
	{
	}
	
	
	override DWORD valueType() // getter
	{
		return REG_NONE;
	}
	
	
	Ткст вТкст()
	{
		return "None";
	}
	
	
	/+ package +/ protected override LONG save(HKEY hkey, Ткст имя) // package
	{
		return RegSetValueExA(hkey, небезопТкст0(имя), 0, REG_NONE, cast(BYTE*)значение, значение.length);
	}
}


enum RegistryHive: т_мера
{
	/+
	// DMD 0.98:
	// ктрл:\dm\..\src\phobos\std\ктрл\windows\windows.d(493): cast(HKEY)(2147483648) is not an expression
	// ...
	CLASSES_ROOT = cast(т_мера)HKEY_CLASSES_ROOT,
	CURRENT_CONFIG = cast(т_мера)HKEY_CURRENT_CONFIG,
	CURRENT_USER = cast(т_мера)HKEY_CURRENT_USER,
	DYN_DATA = cast(т_мера)HKEY_DYN_DATA,
	LOCAL_MACHINE = cast(т_мера)HKEY_LOCAL_MACHINE,
	PERFORMANCE_DATA = cast(т_мера)HKEY_PERFORMANCE_DATA,
	USERS = cast(т_мера)HKEY_USERS,
	+/
	
	CLASSES_ROOT = 0x80000000, 	CURRENT_CONFIG = 0x80000005, 
	CURRENT_USER = 0x80000001, 
	DYN_DATA = 0x80000006, 
	LOCAL_MACHINE = 0x80000002, 
	PERFORMANCE_DATA = 0x80000004, 
	USERS = 0x80000003, 
}


class RegistryKey // docmain
{
	private:
	HKEY hkey;
	бул owned = да;
	
	
	public:
	final:
	/+
	// An absolute key path.
	// This doesn't work.
	final Ткст имя() // getter
	{
		Ткст buf;
		DWORD buflen;
		
		buf = new сим[MAX_REG_BUFFER];
		buflen = buf.length;
		if(ERROR_SUCCESS != RegQueryInfoKeyA(hkey, buf, &buflen, пусто, пусто,
			пусто, пусто, пусто, пусто, пусто, пусто, пусто))
			infoErr();
		
		return buf[0 .. buflen];
	}
	+/
	
	
		final цел subKeyCount() // getter
	{
		DWORD count;
		
		LONG rr = RegQueryInfoKeyA(hkey, пусто, пусто, пусто, &count,
			пусто, пусто, пусто, пусто, пусто, пусто, пусто);
		if(ERROR_SUCCESS != rr)
			infoErr(rr);
		
		return count;
	}
	
	
		final цел valueCount() // getter
	{
		DWORD count;
		
		LONG rr = RegQueryInfoKeyA(hkey, пусто, пусто, пусто, пусто,
			пусто, пусто, &count, пусто, пусто, пусто, пусто);
		if(ERROR_SUCCESS != rr)
			infoErr(rr);
		
		return count;
	}
	
	
		final проц закрой()
	{
		//if(!owned)
			RegCloseKey(hkey);
	}
	
	
		final RegistryKey createSubKey(Ткст имя)
	{
		HKEY newHkey;
		DWORD cdisp;
		
		LONG rr = RegCreateKeyExA(hkey, небезопТкст0(имя), 0, пусто, 0, KEY_ALL_ACCESS, пусто, &newHkey, &cdisp);
		if(ERROR_SUCCESS != rr)
			throw new DflRegistryException("Unable to create registry key", rr);
		
		return new RegistryKey(newHkey);
	}
	
	
		final проц deleteSubKey(Ткст имя, бул throwIfMissing)
	{
		HKEY openHkey;
		
		if(!имя.length || !имя[0])
			throw new DflRegistryException("Unable to delete subkey");
		
		auto namez = небезопТкст0(имя);
		
		LONG opencode = RegOpenKeyExA(hkey, namez, 0, KEY_ALL_ACCESS, &openHkey);
		if(ERROR_SUCCESS == opencode)
		{
			DWORD count;
			
			LONG querycode = RegQueryInfoKeyA(openHkey, пусто, пусто, пусто, &count,
				пусто, пусто, пусто, пусто, пусто, пусто, пусто);
			if(ERROR_SUCCESS == querycode)
			{
				RegCloseKey(openHkey);
				
				LONG delcode;
				if(!count)
				{
					delcode = RegDeleteKeyA(hkey, namez);
					if(ERROR_SUCCESS == delcode)
						return; // ОК.
					
					throw new DflRegistryException("Unable to delete subkey", delcode);
				}
				
				throw new DflRegistryException("Cannot delete registry key with subkeys");
			}
			
			RegCloseKey(openHkey);
			
			throw new DflRegistryException("Unable to delete registry key", querycode);
		}
		else
		{
			if(!throwIfMissing)
			{
				switch(opencode)
				{
					case ERROR_FILE_NOT_FOUND:
						return;
					
					default: ;
				}
			}
			
			throw new DflRegistryException("Unable to delete registry key", opencode);
		}
	}
	
	
	final проц deleteSubKey(Ткст имя)
	{
		deleteSubKey(имя, да);
	}
	
	
		final проц deleteSubKeyTree(Ткст имя)
	{
		_deleteSubKeyTree(hkey, имя);
	}
	
	
	// Note: имя is not written to! it's just not "invariant".
	private static проц _deleteSubKeyTree(HKEY shkey, Ткст имя)
	{
		HKEY openHkey;
		
		auto namez = небезопТкст0(имя);
		
		if(ERROR_SUCCESS == RegOpenKeyExA(shkey, namez, 0, KEY_ALL_ACCESS, &openHkey))
		{
			проц ouch(LONG why = 0)
			{
				throw new DflRegistryException("Unable to delete entire subkey tree", why);
			}
			
			
			DWORD count;
			
			LONG querycode = RegQueryInfoKeyA(openHkey, пусто, пусто, пусто, &count,
				пусто, пусто, пусто, пусто, пусто, пусто, пусто);
			if(ERROR_SUCCESS == querycode)
			{
				if(!count)
				{
					del_me:
					RegCloseKey(openHkey);
					LONG delcode = RegDeleteKeyA(shkey, namez);
					if(ERROR_SUCCESS == delcode)
						return; // ОК.
					
					ouch(delcode);
				}
				else
				{
					try
					{
						// deleteSubKeyTree on все subkeys.
						
						сим[MAX_REG_BUFFER] skn;
						DWORD len;
						
						next_subkey:
						len = skn.length;
						LONG enumcode = RegEnumKeyExA(openHkey, 0, skn.ptr, &len, пусто, пусто, пусто, пусто);
						switch(enumcode)
						{
							case ERROR_SUCCESS:
								//_deleteSubKeyTree(openHkey, skn[0 .. len]);
								_deleteSubKeyTree(openHkey, cast(Ткст)skn[0 .. len]); // Needed in D2. WARNING: NOT REALLY INVARIANT.
								goto next_subkey;
							
							case ERROR_NO_MORE_ITEMS:
								// Done!
								break;
							
							default:
								ouch(enumcode);
						}
						
						// Now go back to delete the origional key.
						goto del_me;
					}
					finally
					{
						RegCloseKey(openHkey);
					}
				}
			}
			else
			{
				ouch(querycode);
			}
		}
	}
	
	
		final проц deleteValue(Ткст имя, бул throwIfMissing)
	{
		LONG rr = RegDeleteValueA(hkey, небезопТкст0(имя));
		switch(rr)
		{
			case ERROR_SUCCESS:
				break;
			
			case ERROR_FILE_NOT_FOUND:
				if(!throwIfMissing)
					break;
			default:
				throw new DflRegistryException("Unable to delete registry значение", rr);
		}
	}
	
	
	final проц deleteValue(Ткст имя)
	{
		deleteValue(имя, да);
	}
	
	
	override т_рав opEquals(Объект o)
	{
		RegistryKey rk;
		
		rk = cast(RegistryKey)o;
		if(!rk)
			return нет;
		return opEquals(rk);
	}
	
	
	т_рав opEquals(RegistryKey rk)
	{
		return hkey == rk.hkey;
	}
	
	
		final проц слей()
	{
		RegFlushKey(hkey);
	}
	
	
		final Ткст[] getSubKeyNames()
	{
		сим[MAX_REG_BUFFER] buf;
		DWORD len;
		DWORD idx;
		Ткст[] результат;
		
		key_names:
		for(idx = 0;; idx++)
		{
			len = buf.length;
			LONG rr = RegEnumKeyExA(hkey, idx, buf.ptr, &len, пусто, пусто, пусто, пусто);
			switch(rr)
			{
				case ERROR_SUCCESS:
					//результат ~= buf[0 .. len].dup;
					//результат ~= buf[0 .. len].idup; // Needed in D2. Doesn't work in D1.
					результат ~= cast(Ткст)buf[0 .. len].dup; // Needed in D2.
					break;
				
				case ERROR_NO_MORE_ITEMS:
					// Done!
					break key_names;
				
				default:
					throw new DflRegistryException("Unable to obtain subkey names", rr);
			}
		}
		
		return результат;
	}
	
	
		final RegistryValue дайЗначение(Ткст имя, RegistryValue defaultValue)
	{
		DWORD тип;
		DWORD len;
		ббайт[] данные;
		
		len = 0;
		LONG querycode = RegQueryValueExA(hkey, небезопТкст0(имя), пусто, &тип, пусто, &len);
		switch(querycode)
		{
			case ERROR_SUCCESS:
				// Good.
				break;
			
			case ERROR_FILE_NOT_FOUND:
				// значение doesn't exist.
				return defaultValue;
			
			default: errquerycode:
				throw new DflRegistryException("Unable to get registry значение", querycode);
		}
		
		данные = new ббайт[len];
		// Note: reusing querycode here and above.
		querycode = RegQueryValueExA(hkey, небезопТкст0(имя), пусто, &тип, данные.ptr, &len);
		if(ERROR_SUCCESS != querycode)
			goto errquerycode;
		
		switch(тип)
		{
			case REG_SZ:
				with(new RegistryValueSz)
				{
					assert(!данные[данные.length - 1]);
					значение = cast(Ткст)данные[0 .. данные.length - 1];
					defaultValue = _reg;
				}
				break;
			
			case REG_DWORD: // REG_DWORD_LITTLE_ENDIAN
				with(new RegistryValueDword)
				{
					assert(данные.length == DWORD.sizeof);
					значение = *(cast(DWORD*)cast(проц*)данные);
					defaultValue = _reg;
				}
				break;
				
			case REG_EXPAND_SZ:
				with(new RegistryValueExpandSz)
				{
					assert(!данные[данные.length - 1]);
					значение = cast(Ткст)данные[0 .. данные.length - 1];
					defaultValue = _reg;
				}
				break;
			
			case REG_MULTI_SZ:
				with(new RegistryValueMultiSz)
				{
					Ткст s;
					
					next_sz:
					s = вТкст(cast(ткст0)данные);
					if(s.length)
					{
						значение ~= s;
						данные = данные[s.length + 1 .. данные.length];
						goto next_sz;
					}
					
					defaultValue = _reg;
				}
				break;
			
			case REG_BINARY:
				with(new RegistryValueBinary)
				{
					значение = данные;
					defaultValue = _reg;
				}
				break;
			
			case REG_DWORD_BIG_ENDIAN:
				with(new RegistryValueDwordBigEndian)
				{
					assert(данные.length == DWORD.sizeof);
					значение = *(cast(DWORD*)cast(проц*)данные);
					defaultValue = _reg;
				}
				break;
			
			case REG_LINK:
				with(new RegistryValueLink)
				{
					значение = данные;
					defaultValue = _reg;
				}
				break;
			
			case REG_RESOURCE_LIST:
				with(new RegistryValueResourceList)
				{
					значение = данные;
					defaultValue = _reg;
				}
				break;
			
			case REG_NONE:
				with(new RegistryValueNone)
				{
					значение = данные;
					defaultValue = _reg;
				}
				break;
			
			default:
				throw new DflRegistryException("Unknown тип for registry значение");
		}
		
		return defaultValue;
	}
	
	
	final RegistryValue дайЗначение(Ткст имя)
	{
		return дайЗначение(имя, пусто);
	}
	
	
		final Ткст[] getValueNames()
	{
		сим[MAX_REG_BUFFER] buf;
		DWORD len;
		DWORD idx;
		Ткст[] результат;
		
		value_names:
		for(idx = 0;; idx++)
		{
			len = buf.length;
			LONG rr = RegEnumValueA(hkey, idx, buf.ptr, &len, пусто, пусто, пусто, пусто);
			switch(rr)
			{
				case ERROR_SUCCESS:
					//результат ~= buf[0 .. len].dup;
					//результат ~= buf[0 .. len].idup; // Needed in D2. Doesn't work in D1.
					результат ~= cast(Ткст)buf[0 .. len].dup; // Needed in D2.
					break;
				
				case ERROR_NO_MORE_ITEMS:
					// Done!
					break value_names;
				
				default:
					throw new DflRegistryException("Unable to obtain значение names", rr);
			}
		}
		
		return результат;
	}
	
	
		static RegistryKey openRemoteBaseKey(RegistryHive hhive, Ткст имяМашины)
	{
		HKEY openHkey;
		
		LONG rr = RegConnectRegistryA(небезопТкст0(имяМашины), cast(HKEY)hhive, &openHkey);
		if(ERROR_SUCCESS != rr)
			throw new DflRegistryException("Unable to open remote base key", rr);
		
		return new RegistryKey(openHkey);
	}
	
	
		// Returns пусто on ошибка.
	final RegistryKey openSubKey(Ткст имя, бул writeAccess)
	{
		HKEY openHkey;
		
		if(ERROR_SUCCESS != RegOpenKeyExA(hkey, небезопТкст0(имя), 0,
			writeAccess ? KEY_READ | KEY_WRITE : KEY_READ, &openHkey))
			return пусто;
		
		return new RegistryKey(openHkey);
	}
	
	
	final RegistryKey openSubKey(Ткст имя)
	{
		return openSubKey(имя, нет);
	}
	
	
		final проц setValue(Ткст имя, RegistryValue значение)
	{
		LONG rr = значение.save(hkey, имя);
		if(ERROR_SUCCESS != rr)
			throw new DflRegistryException("Unable to установи registry значение", rr);
	}
	
	
	// Shortcut.
	final проц setValue(Ткст имя, Ткст значение)
	{
		scope rv = new RegistryValueSz(значение);
		setValue(имя, rv);
	}
	
	
	// Shortcut.
	final проц setValue(Ткст имя, Ткст[] значение)
	{
		scope rv = new RegistryValueMultiSz(значение);
		setValue(имя, rv);
	}
	
	
	// Shortcut.
	final проц setValue(Ткст имя, DWORD значение)
	{
		scope rv = new RegistryValueDword(значение);
		setValue(имя, rv);
	}
	
	
		// Used internally.
	final HKEY указатель() // getter
	{
		return hkey;
	}
	
	
	// Used internally.
	this(HKEY hkey, бул owned = да)
	{
		this.hkey = hkey;
		this.owned = owned;
	}
	
	
	~this()
	{
		if(owned)
			RegCloseKey(hkey);
	}
	
	
	private проц infoErr(LONG why)
	{
		throw new DflRegistryException("Unable to obtain registry информация", why);
	}
}

