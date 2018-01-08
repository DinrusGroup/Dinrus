//Автор Кристофер Миллер. Переработано для Динрус Виталием Кулич.
//Библиотека визуальных конпонентов VIZ (первоначально DFL).


module viz.x.com;
import win;

private import viz.x.winapi, viz.x.wincom, viz.x.dlib;


version(VIZ_TANGO_SEEK_COMPAT)
{
}
else
{
	version = VIZ_TANGO_NO_SEEK_COMPAT;
}


// Importing viz.application here causes the compiler to crash.
//import viz.application;
private extern(C)
{
	т_мера C_refCountInc(ук p);
	т_мера C_refCountDec(ук p);
}


// Won't be killed by GC if not referenced in D and the refcount is > 0.
class ВизКомОбъект: ComObject // package
{
	extern(Windows):
	
	override ULONG AddRef()
	{
		//эхо("AddRef `%.*s`\n", cast(цел)вТкст().length, вТкст().ptr);
		return C_refCountInc(cast(проц*)this);
	}
	
	override ULONG Release()
	{
		//эхо("Release `%.*s`\n", cast(цел)вТкст().length, вТкст().ptr);
		return C_refCountDec(cast(проц*)this);
	}
}


class ПотокВИПоток: ВизКомОбъект, winapi.IStream
{
	this(Поток sourceStream)
	{
		this.stm = sourceStream;
	}
	
	
	extern(Windows):
	
	override HRESULT QueryInterface(IID* riid, проц** ppv)
	{
		if(*riid == _IID_IStream)
		{
			*ppv = cast(проц*)cast(winapi.IStream)this;
			AddRef();
			return S_OK;
		}
		else if(*riid == _IID_ISequentialStream)
		{
			*ppv = cast(проц*)cast(winapi.ISequentialStream)this;
			AddRef();
			return S_OK;
		}
		else if(*riid == _IID_IUnknown)
		{
			*ppv = cast(проц*)cast(winapi.IUnknown)this;
			AddRef();
			return S_OK;
		}
		else
		{
			*ppv = пусто;
			return E_NOINTERFACE;
		}
	}
	
	
	HRESULT Read(ук pv, ULONG cb, ULONG* pcbRead)
	{
		ULONG read;
		HRESULT результат = S_OK;
		
		try
		{
			version(Tango)
			{
				read = stm.read(pv[0 .. cb]);
			}
			else
			{
				read = stm.readBlock(pv, cb);
			}
		}
		catch(Искл e)
		{
			результат = S_FALSE; // ?
		}
		
		if(pcbRead)
			*pcbRead = read;
		//if(!read)
		//	результат = S_FALSE;
		return результат;
	}
	
	
	HRESULT Write(ук pv, ULONG cb, ULONG* pcbWritten)
	{
		ULONG written;
		HRESULT результат = S_OK;
		
		try
		{
			version(Tango)
			{
				auto outstm = cast(ПотокВывода)stm;
				if(!outstm)
					return E_NOTIMPL;
				written = outstm.write(pv[0 .. cb]);
			}
			else
			{
				if(!stm.writeable)
					return E_NOTIMPL;
				written = stm.writeBlock(pv, cb);
			}
		}
		catch(Искл e)
		{
			результат = S_FALSE; // ?
		}
		
		if(pcbWritten)
			*pcbWritten = written;
		//if(!written)
		//	результат = S_FALSE;
		return результат;
	}
	
	
	version(VIZ_TANGO_NO_SEEK_COMPAT)
	{
	}
	else
	{
		long _fakepos = 0;
	}
	
	
	HRESULT Seek(LARGE_INTEGER dlibMove, DWORD dwOrigin, ULARGE_INTEGER* plibNewPosition)
	{
		HRESULT результат = S_OK;
		
		//эхо("seek перемещение=%u, origin=0x%ш\n", cast(бцел)dlibMove.QuadPart, dwOrigin);
		
		try
		{
			version(Tango)
			{
				long поз;
				auto stmseek = cast(DSeekStream)stm;
				if(!stmseek)
				{
					//return S_FALSE; // ?
					//return E_NOTIMPL; // ?
					version(VIZ_TANGO_NO_SEEK_COMPAT)
					{
						//return S_FALSE; // ?
						return E_NOTIMPL; // ?
					}
					else
					{
						switch(dwOrigin)
						{
							case STREAM_SEEK_SET:
								//return S_FALSE; // ?
								return E_NOTIMPL; // ?
							
							case STREAM_SEEK_CUR:
								поз = cast(long)dlibMove.QuadPart;
								if(поз < 0)
									return E_NOTIMPL; // ?
								if(поз)
								{
									byte[1] b1;
									for(; поз; поз--)
									{
										if(1 != stm.read(b1))
											break;
										_fakepos++;
									}
								}
								if(plibNewPosition)
									plibNewPosition.QuadPart = _fakepos;
								break;
							
							case STREAM_SEEK_END:
								//return S_FALSE; // ?
								return E_NOTIMPL; // ?
							
							default:
								результат = STG_E_INVALIDFUNCTION;
						}
					}
				}
				else
				{
					switch(dwOrigin)
					{
						case STREAM_SEEK_SET:
							поз = stmseek.seek(dlibMove.QuadPart, DSeekStream.Anchor.Begin);
							if(plibNewPosition)
								plibNewPosition.QuadPart = поз;
							break;
						
						case STREAM_SEEK_CUR:
							поз = stmseek.seek(dlibMove.QuadPart, DSeekStream.Anchor.Current);
							if(plibNewPosition)
								plibNewPosition.QuadPart = поз;
							break;
						
						case STREAM_SEEK_END:
							поз = stmseek.seek(dlibMove.QuadPart, DSeekStream.Anchor.End);
							if(plibNewPosition)
								plibNewPosition.QuadPart = поз;
							break;
						
						default:
							результат = STG_E_INVALIDFUNCTION;
					}
				}
			}
			else
			{
				if(!stm.seekable)
					//return S_FALSE; // ?
					return E_NOTIMPL; // ?
				
				ulong поз;
				switch(dwOrigin)
				{
					case STREAM_SEEK_SET:
						поз = stm.seekSet(dlibMove.QuadPart);
						if(plibNewPosition)
							plibNewPosition.QuadPart = поз;
						break;
					
					case STREAM_SEEK_CUR:
						поз = stm.seekCur(dlibMove.QuadPart);
						if(plibNewPosition)
							plibNewPosition.QuadPart = поз;
						break;
					
					case STREAM_SEEK_END:
						поз = stm.seekEnd(dlibMove.QuadPart);
						if(plibNewPosition)
							plibNewPosition.QuadPart = поз;
						break;
					
					default:
						результат = STG_E_INVALIDFUNCTION;
				}
			}
		}
		catch(Искл e)
		{
			результат = S_FALSE; // ?
		}
		
		return результат;
	}
	
	
	HRESULT SetSize(ULARGE_INTEGER libNewSize)
	{
		return E_NOTIMPL;
	}
	
	
	HRESULT CopyTo(winapi.IStream pstm, ULARGE_INTEGER cb, ULARGE_INTEGER* pcbRead, ULARGE_INTEGER* pcbWritten)
	{
		// TODO: implement.
		return E_NOTIMPL;
	}
	
	
	HRESULT Commit(DWORD grfCommitFlags)
	{
		// Ignore -grfCommitFlags- and just слей the stream..
		//stm.слей();
		version(Tango)
		{
			auto outstm = cast(ПотокВывода)stm;
			if(!outstm)
				return E_NOTIMPL;
			outstm.слей();
		}
		else
		{
			stm.слей();
		}
		return S_OK; // ?
	}
	
	
	HRESULT Revert()
	{
		return E_NOTIMPL; // ? S_FALSE ?
	}
	
	
	HRESULT LockRegion(ULARGE_INTEGER libOffset, ULARGE_INTEGER cb, DWORD dwLockType)
	{
		return E_NOTIMPL;
	}
	
	
	HRESULT UnlockRegion(ULARGE_INTEGER libOffset, ULARGE_INTEGER cb, DWORD dwLockType)
	{
		return E_NOTIMPL;
	}
	
	
	HRESULT Stat(STATSTG* pstatstg, DWORD grfStatFlag)
	{
		return E_NOTIMPL; // ?
	}
	
	
	HRESULT Clone(winapi.IStream* ppstm)
	{
		// Cloned stream needs its own seek положение.
		return E_NOTIMPL; // ?
	}
	
	
	extern(D):
	
	private:
	Поток stm;
}

version(Tango)
{
}
else
{
	alias ПотокВИПоток StdStreamToIStream; // deprecated
}


class ИПотокПамяти: ВизКомОбъект, winapi.IStream
{
	this(проц[] memory)
	{
		this.mem = memory;
	}
	
	
	extern(Windows):
	
	override HRESULT QueryInterface(IID* riid, проц** ppv)
	{
		if(*riid == _IID_IStream)
		{
			*ppv = cast(проц*)cast(winapi.IStream)this;
			AddRef();
			return S_OK;
		}
		else if(*riid == _IID_ISequentialStream)
		{
			*ppv = cast(проц*)cast(winapi.ISequentialStream)this;
			AddRef();
			return S_OK;
		}
		else if(*riid == _IID_IUnknown)
		{
			*ppv = cast(проц*)cast(winapi.IUnknown)this;
			AddRef();
			return S_OK;
		}
		else
		{
			*ppv = пусто;
			return E_NOINTERFACE;
		}
	}
	
	
	HRESULT Read(ук pv, ULONG cb, ULONG* pcbRead)
	{
		// Shouldn't happen unless the mem changes, which doesn't happen yet.
		if(seekpos > mem.length)
			return S_FALSE; // ?
		
		т_мера count = mem.length - seekpos;
		if(count > cb)
			count = cb;
		
		pv[0 .. count] = mem[seekpos .. seekpos + count];
		seekpos += count;
		
		if(pcbRead)
			*pcbRead = count;
		return S_OK;
	}
	
	
	HRESULT Write(ук pv, ULONG cb, ULONG* pcbWritten)
	{
		//return STG_E_ACCESSDENIED;
		return E_NOTIMPL;
	}
	
	
	HRESULT Seek(LARGE_INTEGER dlibMove, DWORD dwOrigin, ULARGE_INTEGER* plibNewPosition)
	{
		//эхо("seek перемещение=%u, origin=0x%ш\n", cast(бцел)dlibMove.QuadPart, dwOrigin);
		
		auto toPos = cast(long)dlibMove.QuadPart;
		switch(dwOrigin)
		{
			case STREAM_SEEK_SET:
				break;
			
			case STREAM_SEEK_CUR:
				toPos = cast(long)seekpos + toPos;
				break;
			
			case STREAM_SEEK_END:
				toPos = cast(long)mem.length - toPos;
				break;
			
			default:
				return STG_E_INVALIDFUNCTION;
		}
		
		if(впределах(toPos))
		{
			seekpos = cast(т_мера)toPos;
			if(plibNewPosition)
				plibNewPosition.QuadPart = seekpos;
			return S_OK;
		}
		else
		{
			return 0x80030005; //STG_E_ACCESSDENIED; // Seeking past end needs write access.
		}
	}
	
	
	HRESULT SetSize(ULARGE_INTEGER libNewSize)
	{
		return E_NOTIMPL;
	}
	
	
	HRESULT CopyTo(winapi.IStream pstm, ULARGE_INTEGER cb, ULARGE_INTEGER* pcbRead, ULARGE_INTEGER* pcbWritten)
	{
		// TODO: implement.
		return E_NOTIMPL;
	}
	
	
	HRESULT Commit(DWORD grfCommitFlags)
	{
		return S_OK; // ?
	}
	
	
	HRESULT Revert()
	{
		return E_NOTIMPL; // ? S_FALSE ?
	}
	
	
	HRESULT LockRegion(ULARGE_INTEGER libOffset, ULARGE_INTEGER cb, DWORD dwLockType)
	{
		return E_NOTIMPL;
	}
	
	
	HRESULT UnlockRegion(ULARGE_INTEGER libOffset, ULARGE_INTEGER cb, DWORD dwLockType)
	{
		return E_NOTIMPL;
	}
	
	
	HRESULT Stat(STATSTG* pstatstg, DWORD grfStatFlag)
	{
		return E_NOTIMPL; // ?
	}
	
	
	HRESULT Clone(winapi.IStream* ppstm)
	{
		// Cloned stream needs its own seek положение.
		return E_NOTIMPL; // ?
	}
	
	
	extern(D):
	
	private:
	проц[] mem;
	т_мера seekpos = 0;
	
	
	бул впределах(long поз)
	{
		if(поз < seekpos.min || поз > seekpos.max)
			return нет;
		// Note: it IS within границы if it's AT the end, it just can't read there.
		return cast(т_мера)поз <= mem.length;
	}
}

