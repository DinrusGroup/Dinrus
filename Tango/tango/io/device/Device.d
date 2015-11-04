/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        May 2005: Initial release

        author:         Kris

*******************************************************************************/

module io.device.Device;

private import  sys.Common;

public  import  io.device.Conduit;

/*******************************************************************************

        Implements a means of reading and writing a файл устройство. Conduits
        are the primary means of accessing external данные, and this one is
        used as a superclass for the console, for файлы, СОКЕТs etc

*******************************************************************************/

class Устройство : Провод, ИВыбираемый
{
        /// expose superclass definition also
        public alias Провод.ошибка ошибка;
            
        /***********************************************************************

                Throw an ВВИскл noting the последний ошибка
        
        ***********************************************************************/

        final проц ошибка ()
        {
                ошибка (this.вТкст ~ " :: " ~ СисОш.последнСооб);
        }

        /***********************************************************************

                Return the имя of this устройство

        ***********************************************************************/

        override ткст вТкст ()
        {
                return "<устройство>";
        }

        /***********************************************************************

                Return a preferred размер for buffering провод I/O

        ***********************************************************************/

        override т_мера размерБуфера ()
        {
                return 1024 * 16;
        }

        /***********************************************************************

                Windows-specific код

        ***********************************************************************/

        version (Win32)
        {
                struct IO
                {
                        OVERLAPPED      asynch; // must be the first attribute!!
                        Дескр          укз;
                        бул            track;
                        ук            task;
                }

                protected IO io;

                /***************************************************************

                        Разрешить adjustment of стандарт IO handles

                ***************************************************************/

                protected проц переоткрой (Дескр укз)
                {
                        вв.указатель = укз;
                }

                /***************************************************************

                        Return the underlying OS укз of this Провод

                ***************************************************************/

                final Дескр ptr ()
                {
                        return вв.указатель;
                }

                /***************************************************************

                ***************************************************************/

                override проц вымести ()
                {
                        if (вв.указатель != INVALID_HANDLE_VALUE)
                            if (scheduler)
                                scheduler.закрой (вв.указатель, вТкст);
                        открепи();
                }

                /***************************************************************

                        Release the underlying файл. Note that an исключение
                        is not thrown on ошибка, as doing so can induce some
                        spaggetti преобр_в ошибка handling. Instead, we need в_
                        change this в_ return a бул instead, so the caller
                        can decопрe what в_ do.                        

                ***************************************************************/

                override проц открепи ()
                {
                        if (вв.указатель != INVALID_HANDLE_VALUE)
                            CloseHandle (вв.указатель);

                        вв.указатель = INVALID_HANDLE_VALUE;
                }

                /***************************************************************

                        Чтен a chunk of байты из_ the файл преобр_в the provопрed
                        Массив. Returns the число of байты читай, or Кф where 
                        there is no further данные.

                        Operates asynchronously where the hosting нить is
                        configured in that manner.

                ***************************************************************/

                override т_мера читай (проц[] приёмн)
                {
                        DWORD байты;

                        if (! ReadFile (вв.указатель, приёмн.ptr, приёмн.length, &байты, &io.asynch))
                        //ReadFile (вв.указатель, приёмн.ptr, приёмн.length, &байты, &io.asynch);
                              if ((байты = жди (scheduler.Type.Чтен, байты, таймаут)) is Кф)
                                   return Кф;

                        // синхронно читай of zero means Кф
                        if (байты is 0 && приёмн.length > 0)
                            return Кф;

                        // обнови поток location?
                        if (вв.след)
                           (*cast(дол*) &вв.асинх.смещение) += байты;
                        return байты;
                }

                /***************************************************************

                        Write a chunk of байты в_ the файл из_ the provопрed
                        Массив. Returns the число of байты записано, or Кф if 
                        the вывод is no longer available.

                        Operates asynchronously where the hosting нить is
                        configured in that manner.

                ***************************************************************/

                override т_мера пиши (проц[] ист)
                {
                        DWORD байты;

                        if (! WriteFile (вв.указатель, ист.ptr, ист.length, &байты, &io.asynch))
                        //WriteFile (вв.указатель, ист.ptr, ист.length, &байты, &io.asynch);
                        if ((байты = жди (scheduler.Type.Write, байты, таймаут)) is Кф)
                             return Кф;

                        // обнови поток location?
                        if (вв.след)
                           (*cast(дол*) &вв.асинх.смещение) += байты;
                        return байты;
                }

                /***************************************************************

                ***************************************************************/

                protected final т_мера жди (scheduler.Type тип, бцел байты, бцел таймаут)
                {
                        while (да)
                              {
                              auto код = GetLastError;
                              if (код is ERROR_HANDLE_EOF ||
                                  код is ERROR_BROKEN_PIPE)
                                  return Кф;

                              if (scheduler)
                                 {
                                 if (код is ERROR_SUCCESS || 
                                     код is ERROR_IO_PENDING || 
                                     код is ERROR_IO_INCOMPLETE)
                                    {
                                    if (код is ERROR_IO_INCOMPLETE)
                                        super.ошибка ("таймаут"); 

                                    io.task = cast(проц*) thread.Fiber.getThis;
                                    scheduler.await (вв.указатель, тип, таймаут);
                                    if (GetOverlappedResult (вв.указатель, &io.asynch, &байты, нет))
                                        return байты;
                                    }
                                 else
                                    ошибка;
                                 }
                              else
                                 if (код is ERROR_SUCCESS)
                                     return байты;
                                 else
                                    ошибка;
                              }

                        // should never получи here
                        assert(нет);
                }
        }


        /***********************************************************************

                 Unix-specific код.

        ***********************************************************************/

        version (Posix)
        {
                protected цел укз = -1;

                /***************************************************************

                        Разрешить adjustment of стандарт IO handles

                ***************************************************************/

                protected проц переоткрой (Дескр укз)
                {
                        this.укз = укз;
                }

                /***************************************************************

                        Return the underlying OS укз of this Провод

                ***************************************************************/

                final Дескр ptr ()
                {
                        return cast(Дескр) укз;
                }

                /***************************************************************

                        Release the underlying файл

                ***************************************************************/

                override проц открепи ()
                {
                        if (укз >= 0)
                           {
                           //if (scheduler)
                               // TODO Not supported on Posix
                               // scheduler.закрой (укз, вТкст);
                           posix.закрой (укз);
                           }
                        укз = -1;
                }

                /***************************************************************

                        Чтен a chunk of байты из_ the файл преобр_в the provопрed
                        Массив. Returns the число of байты читай, or Кф where 
                        there is no further данные.

                ***************************************************************/

                override т_мера читай (проц[] приёмн)
                {
                        цел читай = posix.читай (укз, приёмн.ptr, приёмн.length);
                        if (читай is -1)
                            ошибка;
                        else
                           if (читай is 0 && приёмн.length > 0)
                               return Кф;
                        return читай;
                }

                /***************************************************************

                        Write a chunk of байты в_ the файл из_ the provопрed
                        Массив. Returns the число of байты записано, or Кф if 
                        the вывод is no longer available.

                ***************************************************************/

                override т_мера пиши (проц[] ист)
                {
                        цел записано = posix.пиши (укз, ист.ptr, ист.length);
                        if (записано is -1)
                            ошибка;
                        return записано;
                }
        }
}
