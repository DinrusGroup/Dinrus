/*
	Copyright (ктрл) 2011 Trogu Antonio Davide

	This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received а копируй of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

module dgui.registry;

pragma(lib, "advapi32.lib");

import std.string;
import dgui.core.idisposable;
import dgui.core.exception;
import dgui.core.handle;

enum RegistryValueType: uint
{
	BINARY = REG_BINARY,
	DWORD = REG_DWORD,
	QWORD = REG_QWORD,
	STRING = REG_SZ,
}

interface IRegistryValue
{
	public void write(RegistryKey owner, string name);
	public RegistryValueType valueType();
	public string toString();
}

abstract class RegistryValue(T): IRegistryValue
{
	private T _value;

	public this(T val)
	{
		this._value = val;
	}
	
	public abstract RegistryValueType valueType();
	public abstract string toString();
}

final class RegistryValueBinary: RegistryValue!(ббайт[])
{
	public this(ббайт[] с)
	{
		super(с);
	}
	
	public RegistryValueType valueType()
	{
		return RegistryValueType.BINARY;
	}

	public string toString()
	{
		string s;

		foreach(ббайт с; this._value)
		{
			s ~= format("%02X", с);
		}

		return s;
	}

	public void write(RegistryKey owner, string name)
	{
		ulong res = RegSetValueExA(owner.handle, toStringz(name), 0, REG_BINARY, cast(ббайт*)this._value.ptr, this._value.length);

		if(res != ERROR_SUCCESS)
		{
			debug
			{
				throw new RegistryException(format("RegSetValueEx failed, Key \"%s\"", name), __FILE__, __LINE__);
			}
			else
			{
				throw new RegistryException(format("RegSetValueEx failed, Key \"%s\"", name));
			}
		}
	}
}

final class RegistryValueString: RegistryValue!(string)
{
	public this(string s)
	{
		super(s);
	}
	
	public RegistryValueType valueType()
	{
		return RegistryValueType.STRING;
	}

	public string toString()
	{
		return this._value;
	}

	public void write(RegistryKey owner, string name)
	{
		ulong res = RegSetValueExA(owner.handle, toStringz(name), 0, REG_SZ, cast(ббайт*)this._value.ptr, this._value.length);

		if(res != ERROR_SUCCESS)
		{
			debug
			{
				throw new RegistryException(format("RegSetValueEx failed, Key \"%s\"", name), __FILE__, __LINE__);
			}
			else
			{
				throw new RegistryException(format("RegSetValueEx failed, Key \"%s\"", name));
			}
		}
	}
}

final class RegistryValueDword: RegistryValue!(uint)
{
	public this(uint i)
	{
		super(i);
	}
	
	public RegistryValueType valueType()
	{
		return RegistryValueType.DWORD;
	}

	public string toString()
	{
		return std.string.toString(this._value);
	}

	public void write(RegistryKey owner, string name)
	{
		ulong res = RegSetValueExA(owner.handle, toStringz(name), 0, REG_DWORD, cast(ббайт*)&this._value, uint.sizeof);

		if(res != ERROR_SUCCESS)
		{
			debug
			{
				throw new RegistryException(format("RegSetValueEx failed, Key \"%s\"", name), __FILE__, __LINE__);
			}
			else
			{
				throw new RegistryException(format("RegSetValueEx failed, Key \"%s\"", name));
			}
		}
	}
}

final class RegistryValueQword: RegistryValue!(ulong)
{
	public this(ulong l)
	{
		super(l);
	}
	
	public RegistryValueType valueType()
	{
		return RegistryValueType.QWORD;
	}

	public string toString()
	{
		return std.string.toString(this._value);
	}

	public void write(RegistryKey owner, string name)
	{
		ulong res = RegSetValueExA(owner.handle, toStringz(name), 0, REG_QWORD, cast(ббайт*)&this._value, ulong.sizeof);

		if(res != ERROR_SUCCESS)
		{
			debug
			{
				throw new RegistryException(format("RegSetValueEx failed, Key \"%s\"", name), __FILE__, __LINE__);
			}
			else
			{
				throw new RegistryException(format("RegSetValueEx failed, Key \"%s\"", name));
			}
		}
	}
}

final class RegistryKey: Handle!(HKEY), IDisposable
{
	private бул _owned;
	
	package this(HKEY hKey, бул owned = да)
	{
		this._handle = hKey;
		this._owned = owned;
	}

	public ~this()
	{
		this.dispose();
	}

	public void dispose()
	{
		if(this._owned)
		{
			RegCloseKey(this._handle);
			this._handle = пусто;
		}
	}

	private void doDeleteSubKey(HKEY hKey, string name)
	{
		const uint MAX_KEY_LENGTH = 0xFF;
		const uint MAX_VALUE_NAME = 0x3FFF;
			
		HKEY hDelKey;
		uint valuesCount, subKeysCount;
		сим[] keyName = new сим[MAX_KEY_LENGTH];
		сим[] valName = new сим[MAX_VALUE_NAME];
		
		if(RegOpenKeyExA(hKey, toStringz(name), 0, KEY_ALL_ACCESS, &hDelKey) != ERROR_SUCCESS)
		{
			debug
			{
				throw new RegistryException(format("Cannot open Key %s", std.string.toString(name.ptr)), __FILE__, __LINE__);
			}
			else
			{
				throw new RegistryException(format("Cannot open Key %s", std.string.toString(name.ptr)));
			}
		}
		
		if(RegQueryInfoKeyA(hDelKey, пусто, пусто, пусто, &subKeysCount, пусто, пусто, &valuesCount, пусто, пусто, пусто, пусто) != ERROR_SUCCESS)
		{
			debug
			{
				throw new RegistryException(format("Cannot query Key %s", std.string.toString(name.ptr)), __FILE__, __LINE__);
			}
			else
			{
				throw new RegistryException(format("Cannot query Key %s", std.string.toString(name.ptr)));
			}
		}

		for(int i = 0; i < subKeysCount; i++)
		{
			uint size = MAX_KEY_LENGTH;
				
			RegEnumKeyExA(hDelKey, 0, keyName.ptr, &size, пусто, пусто, пусто, пусто);
			this.doDeleteSubKey(hDelKey, std.string.toString(keyName.ptr));
		}

		for(int i = 0; i < valuesCount; i++)
		{
			uint size = MAX_VALUE_NAME;
				
			if(RegEnumValueA(hDelKey, 0, valName.ptr, &size, пусто, пусто, пусто, пусто) != ERROR_SUCCESS)
			{
				debug
				{
					throw new RegistryException(format("Cannot enumate значения from key %s", name), __FILE__, __LINE__);
				}
				else
				{
					throw new RegistryException(format("Cannot enumate значения from key %s", name));
				}
			}

			if(RegDeleteValueA(hDelKey, toStringz(valName)) != ERROR_SUCCESS)
			{
				debug
				{
					throw new RegistryException(format("Cannot delete Value %s", std.string.toString(valName.ptr)), __FILE__, __LINE__);
				}
				else
				{
					throw new RegistryException(format("Cannot delete Value %s", std.string.toString(valName.ptr)));
				}
			}
		}

		RegCloseKey(hDelKey);

		if(RegDeleteKeyA(hKey, toStringz(name)) != ERROR_SUCCESS)
		{
			debug
			{
				throw new RegistryException(format("Cannot delete Key %s", std.string.toString(name.ptr)), __FILE__, __LINE__);
			}
			else
			{
				throw new RegistryException(format("Cannot delete Key %s", std.string.toString(name.ptr)));
			}
		}
	}

	public RegistryKey createSubKey(string name)
	{
		HKEY hKey;
		uint disp;

		int res = RegCreateKeyExA(this._handle, toStringz(name), 0, пусто, 0, KEY_ALL_ACCESS, пусто, &hKey, &disp);
		printf("Res: %d\n", res);
		
		switch(res)
		{
			case ERROR_SUCCESS:
				return new RegistryKey(hKey);

			default:
				debug
					throw new RegistryException(format("Cannot create Key \"%s\"", name), __FILE__, __LINE__);
				else
					throw new RegistryException(format("Cannot create Key \"%s\"", name));
		}
	}

	public void deleteSubKey(string name)
	{
		this.doDeleteSubKey(this._handle, name);
	}

	public RegistryKey getSubKey(string name)
	{
		HKEY hKey;

		int res = RegOpenKeyExA(this._handle, toStringz(name), 0, KEY_ALL_ACCESS, &hKey);

		switch(res)
		{
			case ERROR_SUCCESS:
				return new RegistryKey(hKey);
			
			default:
				debug
					throw new RegistryException(format("Cannot retrieve Key \"%s\"", name), __FILE__, __LINE__);
				else
					throw new RegistryException(format("Cannot retrieve Key \"%s\"", name));
		}
	}

	public void setValue(string name, IRegistryValue val)
	{
		val.write(this, name);
	}

	public IRegistryValue дайЗначение(string name)
	{
		uint len;
		uint type;
		IRegistryValue ival = пусто;

		int res = RegQueryValueExA(this._handle, toStringz(name), пусто, &type, пусто, &len);

		if(res != ERROR_SUCCESS)
		{
			return пусто;
		}

		switch(type)
		{
			case REG_BINARY:
				ббайт[] val = new ббайт[len];
				RegQueryValueExA(this._handle, toStringz(name), пусто, &type, val.ptr, &len);
				ival = new RegistryValueBinary(val);
				break;

			case REG_DWORD:
				uint val;
				RegQueryValueExA(this._handle, toStringz(name), пусто, &type, cast(ббайт*)&val, &len);
				ival = new RegistryValueDword(val);
				break;

			case REG_QWORD:
				ulong val;
				RegQueryValueExA(this._handle, toStringz(name), пусто, &type, cast(ббайт*)&val, &len);
				ival = new RegistryValueQword(val);
				break;

			case REG_SZ:
				сим[] val = new сим[len];
				RegQueryValueExA(this._handle, toStringz(name), пусто, &type, cast(ббайт*)val.ptr, &len);
				ival = new RegistryValueString(val);
				break;

			default:
				debug
					throw new RegistryException("Unsupported Формат", __FILE__, __LINE__);
				else
					throw new RegistryException("Unsupported Формат");
		}

		return ival;
	}
}

final class Registry
{
	private static RegistryKey _classesRoot;
	private static RegistryKey _currentConfig;
	private static RegistryKey _currentUser;
	private static RegistryKey _dynData;
	private static RegistryKey _localMachine;
	private static RegistryKey _performanceData;
	private static RegistryKey _users;

	private this()
	{
		
	}

	public static RegistryKey classesRoot() 
	{
		if(!_classesRoot)
		{
			_classesRoot = new RegistryKey(HKEY_CLASSES_ROOT, нет);
		}
		
		return _classesRoot;
	}
	
	public static RegistryKey currentConfig() 
	{
		if(!_currentConfig)
		{
			_currentConfig = new RegistryKey(HKEY_CURRENT_CONFIG, нет);
		}
		
		return _currentConfig;
	}
	
	public static RegistryKey currentUser() 
	{
		if(!_currentUser)
		{
			_currentUser = new RegistryKey(HKEY_CURRENT_USER, нет);
		}
		
		return _currentUser;
	}
	
	public static RegistryKey dynData() 
	{
		if(!_dynData)
		{
			_dynData = new RegistryKey(HKEY_DYN_DATA, нет);
		}
		
		return _dynData;
	}
	
	public static RegistryKey localMachine() 
	{
		if(!_localMachine)
		{
			_localMachine = new RegistryKey(HKEY_LOCAL_MACHINE, нет);
		}
		
		return _localMachine;
	}
	
	public static RegistryKey performanceData() 
	{
		if(!_performanceData)
		{
			_performanceData = new RegistryKey(HKEY_PERFORMANCE_DATA, нет);
		}
		
		return _performanceData;
	}
	
	
	public static RegistryKey users() 
	{
		if(!_users)
		{
			_users = new RegistryKey(HKEY_USERS, нет);
		}
		
		return _users;
	}
}