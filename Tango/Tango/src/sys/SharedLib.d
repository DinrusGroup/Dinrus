/**
 * The shared library module provопрes a basic layer around the исконный functions
 * used в_ загрузи symbols из_ shared libraries.
 *
 * Copyright: Copyright (C) 2007 Tomasz Stachowiak
 * License:   BSD стиль: $(LICENSE)
 * Authors:   Tomasz Stachowiak, Anders Bergh
 */

module sys.SharedLib;


private {
    import stringz : изТкст0;

    version (Windows) {
        import sys.Common : СисОш;
        import base : HINSTANCE, HMODULE, BOOL;

        extern (Windows) {
            ук  GetProcAddress(HINSTANCE, сим*);
            BOOL FreeLibrary(HMODULE);

            version (Win32SansUnicode)
                     HINSTANCE LoadLibraryA(сим*);
                else {
                   enum {CP_UTF8 = 65001}
                   HINSTANCE LoadLibraryW(шим*);
                   цел MultiByteToWideChar(бцел, бцел, сим*, цел, шим*, цел);
                }
        }
    }
    else version (Posix) {
        import rt.core.stdc.posix.dlfcn;
    }
    else {
        static assert (нет, "Для данной платформы не поддерживается");
    }

    version (SharedLibVerbose) import util.log.Trace;
}

version (Posix) {
    version (freebsd) { } else { pragma (lib, "dl"); }
}


/**
    Длл is an interface в_ system-specific shared libraries, such
    as ".dll", ".so" or ".dylib" файлы. It provопрes a simple interface в_ obtain
    symbol адресes (such as function pointers) из_ these libraries.

    Example:
    ----

    проц main() {
        if (auto lib = Длл.загрузи(`c:\windows\system32\opengl32.dll`)) {
            След.форматнс("Library successfully загружен");

            ук  ptr = lib.дайСимвол("glClear");
            if (ptr) {
                След.форматнс("Symbol glClear найдено. адрес = 0x{:x}", ptr);
            } else {
                След.форматнс("Symbol glClear не найден");
            }

            lib.выгрузи();
        } else {
            След.форматнс("Could not загрузи the library");
        }

        assert (0 == Длл.члоЗагруженыхБибл);
    }

    ----

    This implementation uses reference counting, thus a library is not загружен
    again if it есть been загружен before and not unloaded by the пользователь.
    Unloading a Длл decreases its reference счёт. When it reaches 0,
    the shared library associated with it is unloaded and the Длл экземпляр
    is deleted. Please do not delete Длл instances manually, выгрузи() will
    take care of it.

    Note:
    Длл is нить-safe.
  */
 
final class Длл {



    /// Mapped из_ RTLD_NOW, RTLD_LAZY, RTLD_GLOBAL and RTLD_LOCAL
    enum ПРежимЗагрузки {
        Сейчас = 0b1,
        Отложенный = 0b10,
        Глобальный = 0b100,
        Локальный = 0b1000
    }


    /**
        Loads an OS-specific shared library.

        Note:
        Please use this function instead of the constructor, which is private.

        Параметры:
            путь = The путь в_ a shared library в_ be загружен
            режим = Library loading режим. See ПРежимЗагрузки

        Возвращает:
            A Длл экземпляр being a укз в_ the library, or throws
            ИсклДлл if it could not be загружен
      */
    static Длл загрузи(ткст путь, ПРежимЗагрузки режим = ПРежимЗагрузки.Сейчас | ПРежимЗагрузки.Глобальный) {
    	return loadImpl(путь, режим, да);
    }



    /**
        Loads an OS-specific shared library.

        Note:
        Please use this function instead of the constructor, which is private.

        Параметры:
            путь = The путь в_ a shared library в_ be загружен
            режим = Library loading режим. See ПРежимЗагрузки

        Возвращает:
            A Длл экземпляр being a укз в_ the library, or пусто if it
            could not be загружен
      */
    static Длл загрузиБезИскл(ткст путь, ПРежимЗагрузки режим = ПРежимЗагрузки.Сейчас | ПРежимЗагрузки.Глобальный) {
    	return loadImpl(путь, режим, нет);
    }


    private static Длл loadImpl(ткст путь, ПРежимЗагрузки режим, бул выводИсключений) {
        Длл рез;

        synchronized (стопор) {
            auto lib = путь in loadedLibs;
            if (lib) {
                version (SharedLibVerbose) След.форматнс("Длл найдено in the hashmap");
                рез = *lib;
            }
            else {
                version (SharedLibVerbose) След.форматнс("Creating a new экземпляр of Длл");
                рез = new Длл(путь);
                loadedLibs[путь] = рез;
            }

            ++рез.refCnt;
        }

        бул delRes = нет;
        Исключение exc;

        synchronized (рез) {
            if (!рез.загружен) {
                version (SharedLibVerbose) След.форматнс("Loading the Длл");
                try {
                    рез.load_(режим, выводИсключений);
                } catch (Исключение e) {
                    exc = e;
                }
            }

            if (рез.загружен) {
                version (SharedLibVerbose) След.форматнс("Длл successfully загружен, returning");
                return рез;
            } else {
                synchronized (стопор) {
                    if (путь in loadedLibs) {
                        version (SharedLibVerbose) След.форматнс("Removing the Длл из_ the hashmap");
                        loadedLibs.remove(путь);
                    }
                }
            }

            // сделай sure that only one нить will delete the объект
            if (0 == --рез.refCnt) {
                delRes = да;
            }
        }

        if (delRes) {
            version (SharedLibVerbose) След.форматнс("Deleting the Длл");
            delete рез;
        }

        if (exc !is пусто) {
            throw exc;
        }

        version (SharedLibVerbose) След.форматнс("Длл not загружен, returning пусто");
        return пусто;
    }


    /**
        Unloads the OS-specific shared library associated with this Длл экземпляр.

        Note:
        It's не_годится в_ use the объект after выгрузи() есть been called, as выгрузи()
        will delete it if it's not referenced any ещё.

        Throws ИсклДлл on failure. In this case, the Длл объект is not deleted.
      */
    проц выгрузи() {
    	return unloadImpl(да);
    }


    /**
        Unloads the OS-specific shared library associated with this Длл экземпляр.

        Note:
        It's не_годится в_ use the объект after выгрузи() есть been called, as выгрузи()
        will delete it if it's not referenced any ещё.
      */
    проц выгрузиБезИскл() {
    	return unloadImpl(нет);
    }


    private проц unloadImpl(бул выводИсключений) {
        бул deleteThis = нет;

        synchronized (this) {
            assert (загружен);
            assert (refCnt > 0);

            synchronized (стопор) {
                if (--refCnt <= 0) {
                    version (SharedLibVerbose) След.форматнс("Unloading the Длл");
                    try {
                        unload_(выводИсключений);
                    } catch (Исключение e) {
                        ++refCnt;
                        throw e;
                    }

                    assert ((путь in loadedLibs) !is пусто);
                    loadedLibs.remove(путь);

                    deleteThis = да;
                }
            }
        }
        if (deleteThis) {
            version (SharedLibVerbose) След.форматнс("Deleting the Длл");
            delete this;
        }
    }


    /**
        Returns the путь в_ the OS-specific shared library associated with this объект.
      */
    ткст путь() {
        return this.path_;
    }


    /**
        Obtains the адрес of a symbol within the shared library

        Параметры:
            имя = The имя of the symbol; must be a пусто-terminated C ткст

        Возвращает:
            A pointer в_ the symbol or throws ИсклДлл if it's
            not present in the library.
      */
    ук  дайСимвол(сим* имя) {
    	return getSymbolImpl(имя, да);
    }


    /**
        Obtains the адрес of a symbol within the shared library

        Параметры:
            имя = The имя of the symbol; must be a пусто-terminated C ткст

        Возвращает:
            A pointer в_ the symbol or пусто if it's not present in the library.
      */
    ук  дайСимволБезИскл(сим* имя) {
    	return getSymbolImpl(имя, нет);
    }


    private ук  getSymbolImpl(сим* имя, бул выводИсключений) {
        assert (загружен);
        return getSymbol_(имя, выводИсключений);
    }



    /**
        Returns the total число of libraries currently загружен by Длл
      */
    static бцел члоЗагруженыхБибл() {
        return loadedLibs.keys.length;
    }


    private {
        version (Windows) {
            HMODULE укз;

            проц load_(ПРежимЗагрузки режим, бул выводИсключений) {
                version (Win32SansUnicode)
                         укз = LoadLibraryA((this.path_ ~ \0).ptr);
                    else {
                         шим[1024] врем =void;
                         auto i = MultiByteToWideChar (CP_UTF8, 0,
                                                       путь.ptr, путь.length,
                                                       врем.ptr, врем.length-1);
                         if (i > 0)
                            {
                            врем[i] = 0;
                            укз = LoadLibraryW (врем.ptr);
                            }
                    }
                if (укз is пусто && выводИсключений) {
                    throw new ИсклДлл("Не удаётся загрузить динамическую библиотеку '" ~ this.path_ ~ "' : " ~ СисОш.последнСооб);
                }
            }

            ук  getSymbol_(сим* имя, бул выводИсключений) {
                // MSDN: "MultИПle threads do not overwrite each другой's последний-ошибка код."
                auto рез = GetProcAddress(укз, имя);
                if (рез is пусто && выводИсключений) {
                    throw new ИсклДлл("Не удалось загрузить символ '" ~ изТкст0(имя) ~ "' из динамической библиотеки '" ~ this.path_ ~ "' : " ~ СисОш.последнСооб);
                } else {
                    return рез;
                }
            }

            проц unload_(бул выводИсключений) {
                if (0 == FreeLibrary(укз) && выводИсключений) {
                    throw new ИсклДлл("Не удалось выгрузить динамическую библиотеку '" ~ this.path_ ~ "' : " ~ СисОш.последнСооб);
                }
            }
        }
        else version (Posix) {
            ук  укз;

            проц load_(ПРежимЗагрузки режим, бул выводИсключений) {
                цел mode_;
                if (режим & ПРежимЗагрузки.Сейчас) mode_ |= RTLD_NOW;
                if (режим & ПРежимЗагрузки.Отложенный) mode_ |= RTLD_LAZY;
                if (режим & ПРежимЗагрузки.Глобальный) mode_ |= RTLD_GLOBAL;
                if (режим & ПРежимЗагрузки.Локальный) mode_ |= RTLD_LOCAL;

                укз = dlopen((this.path_ ~ \0).ptr, mode_);
                if (укз is пусто && выводИсключений) {
                    throw new ИсклДлл("Не удалось загрузить динамическую библиотеку: " ~ изТкст0(dlerror()));
                }
            }

            ук  getSymbol_(сим* имя, бул выводИсключений) {
                if (выводИсключений) {
                    synchronized (typeof(this).classinfo) { // dlerror need not be reentrant
                        auto err = dlerror();               // сотри previous ошибка condition
                        auto рез = dlsym(укз, имя);     // результат of пусто does NOT indicate ошибка
                        
                        err = dlerror();                    // check for ошибка condition
                        if (err !is пусто) {
                            throw new ИсклДлл("Не удалось загрузить символ: " ~ изТкст0(err));
                        } else {
                            return рез;
                        }
                    }
                } else {
                    return dlsym(укз, имя);
                }
            }

            проц unload_(бул выводИсключений) {
                if (0 != dlclose(укз) && выводИсключений) {
                    throw new ИсклДлл("Не удалось выгрузить динамическую библиотеку: " ~ изТкст0(dlerror()));
                }
            }
        }
        else {
            static assert (нет, "Эта платформа не поддерживается");
        }


        ткст path_;
        цел refCnt = 0;


        бул загружен() {
            return укз !is пусто;
        }


        this(ткст путь) {
            this.path_ = путь.dup;
        }
    }


    private static {
        Длл[ткст] loadedLibs;
        Объект стопор;
    }


    static this() {
        стопор = new Объект;
    }
}


class ИсклДлл : Исключение {


    this (ткст сооб) {
        super(сооб);
    }
}




debug (Длл)
{
        проц main()
        {       
                auto lib = new Длл("foo");
        }
}
