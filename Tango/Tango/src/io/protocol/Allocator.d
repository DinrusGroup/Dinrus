/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: October 2004      
                        Outback release: December 2006
        
        author:         Kris

        Allocators в_ use in conjunction with the Читатель class. These are
        intended в_ manage Массив allocation for a variety of Читатель.получи()
        methods

*******************************************************************************/

module io.protocol.Allocator;

private import  io.protocol.model;


/*******************************************************************************

        Simple разместитель, copying преобр_в the куча for each Массив requested:
        this is the default behaviour for Читатель экземпляры
        
*******************************************************************************/

class КопияКучи : ИРазместитель
{



        private ИПротокол protocol_;

        /***********************************************************************
        
        ***********************************************************************/

        this (ИПротокол протокол)
        {
                protocol_ = протокол;
        }

        /***********************************************************************
        
        ***********************************************************************/

        final ИПротокол протокол ()
        {
                return protocol_;
        }

        /***********************************************************************
        
        ***********************************************************************/

        final проц сбрось ()
        {
        }
        
        /***********************************************************************
        
        ***********************************************************************/

        final проц[] размести (ИПротокол.Читатель читатель, бцел байты, ИПротокол.Тип тип)
        {
                return читатель ((new проц[байты]).ptr, байты, тип);
        }
}


/*******************************************************************************

        Размести из_ внутри a private куча пространство. This supports reading
        данные as 'records', reusing the same чанк of память for each record
        загружен. The ctor takes an аргумент defining the начальное allocation
        made, и this will be increased as necessary в_ accomodate larger
        records. Use the сбрось() метод в_ indicate конец of record (reuse
        память for subsequent requests), or установи the autoreset флаг в_ reuse
        upon each Массив request.
        
*******************************************************************************/

class СрезКучи : ИРазместитель
{



        private бцел            использован;
        private проц[]          буфер;
        private ИПротокол       protocol_;
        private бул            autoreset;

        /***********************************************************************
        
        ***********************************************************************/

        this (ИПротокол протокол, бцел width=4096, бул autoreset=нет)
        {
                protocol_ = протокол;
                буфер = new проц[width];
                this.autoreset = autoreset;
        }

        /***********************************************************************
        
        ***********************************************************************/

        final ИПротокол протокол ()
        {
                return protocol_;
        }

        /***********************************************************************
        
                Reset контент length в_ zero

        ***********************************************************************/

        final проц сбрось ()
        {
                использован = 0;
        }

        /***********************************************************************
        
                No allocation: копируй преобр_в a reserved arena.

                With СрезКучи, it is нормаль в_ размести пространство large
                enough в_ contain, say, a record of данные. The reserved
                пространство will grow в_ accomodate larger records. A сбрось()
                вызов should be made between each record читай, в_ ensure
                the пространство is being reused.
                
        ***********************************************************************/

        final проц[] размести (ИПротокол.Читатель читатель, бцел байты, ИПротокол.Тип тип)
        {
                if (autoreset)
                    использован = 0;
                
                if ((использован + байты) > буфер.length)
                     буфер.length = (использован + байты) * 2;
                
                auto ptr = &буфер[использован];
                использован += байты;
                
                return читатель (ptr, байты, тип);
        }
}


/*******************************************************************************

        Alias directly из_ the буфер instead of allocating из_ the куча.
        This avoопрs Всё куча activity и copying, but требует some care
        in terms of usage. See methods размести() for details
        
*******************************************************************************/

class СрезБуфера : ИРазместитель
{


        private ИПротокол protocol_;

        /***********************************************************************
        
        ***********************************************************************/

        this (ИПротокол протокол)
        {
                protocol_ = протокол;
        }

        /***********************************************************************
        
        ***********************************************************************/

        final ИПротокол протокол ()
        {
                return protocol_;
        }

        /***********************************************************************

                Move все unconsumed данные в_ the front of the буфер, freeing
                up пространство for ещё
                
        ***********************************************************************/

        final проц сбрось ()
        {
                протокол.буфер.сожми;
        }
        
        /***********************************************************************
        
                No размести or копируй: alias directly из_ буфер. While this is
                very efficient (no куча activity) it should be использован only in
                scenarios where контент is known в_ fit внутри a буфер, и
                there is no conversion of saопр контент e.g. возьми care when
                using with ПротоколЭндиан since it will преобразуй внутри the
                буфер, potentially confusing добавьitional буфер clients.

                With СрезБуфера, it is consопрered нормаль в_ создай a Буфер
                large enough в_ contain, say, a файл и subsequently срез
                все strings/массивы directly из_ this буфер. Smaller Buffers
                can be использован in a record-oriented manner similar в_ СрезКучи:
                invoke сбрось() before each record is processed в_ ensure here
                is sufficient пространство available in the буфер в_ house a complete
                record. БуферРоста could be использован in the latter case, в_ ensure
                the largest record width is always accomodated.

                A good use of this is in handling of network traffic, where
                incoming данные is often transient и of a known протяженность. For
                другой potential use, consider the quantity of distinct текст
                массивы generated by an XML парсер -- would be convenient в_
                срез все of them из_ a single allocation instead
               
        ***********************************************************************/

        final проц[] размести (ИПротокол.Читатель читатель, бцел байты, ИПротокол.Тип тип)
        {
                return protocol_.буфер.срез (байты);
        }
}
