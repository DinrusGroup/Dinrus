/*******************************************************************************
  copyright:   Copyright (c) 2006 Juan Jose Comellas. все rights reserved
  license:     BSD стиль: $(LICENSE)
  author:      Juan Jose Comellas <juanjo@comellas.com.ar>
*******************************************************************************/

module sys.Pipe;

private import sys.Common;
private import io.device.Device;

extern(Windows) WINBOOL CreatePipe(PHANDLE, PHANDLE, LPSECURITY_ATTRIBUTES, DWORD);

private import exception;

version (Posix)
{
    private import rt.core.stdc.posix.unistd;
}

debug (Трубопровод)
{
    private import io.Stdout;
}

private enum {ДефРазмерБуфера = 8 * 1024}


/**
 * Провод for pИПes.
 *
 * Each Трубопровод can only читай or пиши, depending on the way it есть been
 * создан.
 */


class Трубопровод : Устройство
{


    version (OLD)
    {
        alias Устройство.фукз  фукз;
        alias Устройство.копируй        копируй;
        alias Устройство.читай        читай;
        alias Устройство.пиши       пиши;
        alias Устройство.закрой       закрой;
        alias Устройство.ошибка       ошибка;
    }

    private бцел _bufferSize;


    /**
     * Create a Трубопровод with the provопрed указатель and access permissions.
     *
     * Параметры:
     * указатель       = указатель of the operating system pipe we will wrap insопрe
     *                the Трубопровод.
     * стиль        = access флаги for the pipe (читаемый, записываемый, etc.).
     * размерБуфера   = буфер размер.
     */
    private this(Дескр указатель, бцел размерБуфера = ДефРазмерБуфера)
    {
        version (Windows)
                 вв.указатель = указатель;
            else
               this.указатель = указатель;
        _bufferSize = размерБуфера;
    }

    /**
     * Destructor.
     */
    public ~this()
    {
        закрой();
    }

    /**
     * Returns the буфер размер for the Трубопровод.
     */
    public override т_мера размерБуфера()
    {
        return _bufferSize;
    }

    /**
     * Returns the имя of the устройство.
     */
    public override ткст вТкст()
    {
        return "<sys.Pipe.Трубопровод>";
    }

    version (OLD)
    {
        /**
         * Чтен a chunk of байты из_ the файл преобр_в the provопрed Массив 
         * (typically that belonging в_ an ИБуфер)
         */
        protected override бцел читай (проц[] приёмн)
        {
            бцел результат;
            DWORD читай;
            проц *p = приёмн.ptr;

            if (!ReadFile (указатель, p, приёмн.length, &читай, пусто))
            {
                if (СисОш.последнКод() == ERROR_BROKEN_PIPE)
                {
                    return Кф;
                }
                else
                {
                    ошибка();
                }
            }

            if (читай == 0 && приёмн.length > 0)
            {
                return Кф;
            }
            return читай;
        }

        /**
         * Write a chunk of байты в_ the файл из_ the provопрed Массив 
         * (typically that belonging в_ an ИБуфер).
         */
        protected override бцел пиши (проц[] ист)
        {
            DWORD записано;

            if (!WriteFile (указатель, ист.ptr, ист.length, &записано, пусто))
            {
                ошибка();
            }
            return записано;
        }
    }
}

/**
 * Factory class for PИПes.
 */
class Пайп
{


    private Трубопровод _source;
    private Трубопровод _сток;

    /**
     * Create a Пайп.
     */
    public this(бцел размерБуфера = ДефРазмерБуфера)
    {
        version (Windows)
        {
            this(размерБуфера, пусто);
        }
        else version (Posix)
        {
            цел fd[2];

            if (pipe(fd) == 0)
            {
                _source = new Трубопровод(cast(ИВыбираемый.Дескр) fd[0], размерБуфера);
                _сток = new Трубопровод(cast(ИВыбираемый.Дескр) fd[1], размерБуфера);
            }
            else
            {
                ошибка();
            }
        }
        else
        {
            assert(нет, "Неизвестная платформа");
        }
    }

    version (Windows)
    {
        /**
         * Helper constructor for pИПes on Windows with non-пусто security
         * атрибуты.
         */
        package this(бцел размерБуфера, SECURITY_ATTRIBUTES *sa)
        {
            HANDLE destHandle;
            HANDLE sourceHandle;

            if (CreatePipe(&sourceHandle, &destHandle, sa, cast(DWORD) размерБуфера))
            {
                _source = new Трубопровод(sourceHandle);
                _сток = new Трубопровод(destHandle);
            }
            else
            {
                ошибка();
            }
        }
    }

    /**
     * Return the Трубопровод that you can пиши в_.
     */
    public Трубопровод сток()
    {
        return _сток;
    }

    /**
     * Return the Трубопровод that you can читай из_.
     */
    public Трубопровод источник()
    {
        return _source;
    }

    /**
     *
     */
    private final проц ошибка ()
    {
        throw new ВВИскл("Ошибка пайпа: " ~ СисОш.последнСооб);
    }
}

