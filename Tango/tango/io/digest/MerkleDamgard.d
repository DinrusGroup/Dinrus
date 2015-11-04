/*******************************************************************************
        copyright:      Copyright (c) 2006 Dinrus. все rights reserved

        license:        BSD стиль: see doc/license.txt for details

        version:        Initial release: Feb 2006

        author:         Regan Heath, Oskar Linde

        This module реализует a generic Merkle-Damgard hash function

*******************************************************************************/

module util.digest.MerkleDamgard;

public  import core.ByteSwap;

public  import util.digest.Digest;

/*******************************************************************************

        Extending MerkleDamgard в_ создай a custom hash function requires 
        the implementation of a число of abstract methods. These include:
        ---
        public бцел digestSize();
        protected проц сбрось();
        protected проц создайДайджест(ббайт[] буф);
        protected бцел размерБлока();
        protected бцел добавьSize();
        protected проц padMessage(ббайт[] данные);
        protected проц трансформируй(ббайт[] данные);
        ---

        In добавьition there exist two further abstract methods; these methods
        have пустой default implementations since in some cases they are not 
        required:
        ---
        protected abstract проц padLength(ббайт[] данные, бдол length);
        protected abstract проц extend();
        ---

        The метод padLength() is required в_ implement the SHA series of
        Hash functions and also the Tiger algorithm. Метод extend() is 
        required only в_ implement the MD2 дайджест.

        The basic sequence of internal события is as follows:
        $(UL
        $(LI трансформируй(), 0 or ещё times)
        $(LI padMessage())
        $(LI padLength())
        $(LI трансформируй())
        $(LI extend())
        $(LI создайДайджест())
        $(LI сбрось())
        )
 
*******************************************************************************/

package class MerkleDamgard : Дайджест
{
        private бцел    байты;
        private ббайт[] буфер;

        /***********************************************************************

                Constructs the дайджест

                Параметры:
                буф = a буфер with enough пространство в_ hold the дайджест

                Remarks:
                Constructs the дайджест.

        ***********************************************************************/

        protected abstract проц создайДайджест(ббайт[] буф);

        /***********************************************************************

                Дайджест block размер

                Возвращает:
                the block размер

                Remarks:
                Specifies the размер (in байты) of the block of данные в_ пароль в_
                each вызов в_ трансформируй().

        ***********************************************************************/

        protected abstract бцел размерБлока();

        /***********************************************************************

                Length паддинг размер

                Возвращает:
                the length паддинг размер

                Remarks:
                Specifies the размер (in байты) of the паддинг which
                uses the length of the данные which есть been fed в_ the
                algorithm, this паддинг is carried out by the
                padLength метод.

        ***********************************************************************/

        protected abstract бцел добавьSize();

        /***********************************************************************

                Pads the дайджест данные

                Параметры:
                данные = a срез of the дайджест буфер в_ заполни with паддинг

                Remarks:
                Fills the passed буфер срез with the appropriate
                паддинг for the final вызов в_ трансформируй(). This
                паддинг will заполни the сообщение данные буфер up в_
                размерБлока()-добавьSize().

        ***********************************************************************/

        protected abstract проц padMessage(ббайт[] данные);

        /***********************************************************************

                Performs the length паддинг

                Параметры:
                данные   = the срез of the дайджест буфер в_ заполни with паддинг
                length = the length of the данные which есть been processed

                Remarks:
                Fills the passed буфер срез with добавьSize() байты of паддинг
                based on the length in байты of the ввод данные which есть been
                processed.

        ***********************************************************************/

        protected проц padLength(ббайт[] данные, бдол length) {}

        /***********************************************************************

                Performs the дайджест on a block of данные

                Параметры:
                данные = the block of данные в_ дайджест

                Remarks:
                The actual дайджест algorithm is carried out by this метод on
                the passed block of данные. This метод is called for every
                размерБлока() байты of ввод данные and once ещё with the remaining
                данные псеп_в_конце в_ размерБлока().

        ***********************************************************************/

        protected abstract проц трансформируй(ббайт[] данные);

        /***********************************************************************

                Final processing of дайджест.

                Remarks:
                This метод is called after the final трансформируй just prior в_
                the creation of the final дайджест. The MD2 algorithm requires
                an добавьitional step at this stage. Future digests may or may not
                require this метод.

        ***********************************************************************/

        protected проц extend() {} 

        /***********************************************************************

                Construct a дайджест

                Remarks:
                Constructs the internal буфер for use by the дайджест, the буфер
                размер (in байты) is defined by the abstract метод размерБлока().

        ***********************************************************************/

        this()
        {
                буфер = new ббайт[размерБлока()];
                сбрось();
        }

        /***********************************************************************

                Initialize the дайджест

                Remarks:
                Returns the дайджест состояние в_ its начальное значение

        ***********************************************************************/

        protected проц сбрось()
        {
                байты = 0;
        }

        /***********************************************************************

                Дайджест добавьitional данные

                Параметры:
                ввод = the данные в_ дайджест

                Remarks:
                Continues the дайджест operation on the добавьitional данные.

        ***********************************************************************/

        MerkleDamgard обнови (проц[] ввод)
        {
                auto block = размерБлока();
                бцел i = байты & (block-1);
                ббайт[] данные = cast(ббайт[]) ввод;

                байты += данные.length;

                if (данные.length+i < block) 
                    буфер[i..i+данные.length] = данные[];
                else
                   {
                   буфер[i..block] = данные[0..block-i];
                   трансформируй (буфер);

                   for (i=block-i; i+block-1 < данные.length; i += block)
                        трансформируй(данные[i..i+block]);

                   буфер[0..данные.length-i] = данные[i..данные.length];
                   }
                return this;
        }

        /***********************************************************************

                Complete the дайджест

                Возвращает:
                the completed дайджест

                Remarks:
                Concludes the algorithm producing the final дайджест.

        ***********************************************************************/

        ббайт[] двоичныйДайджест (ббайт[] буф = пусто)
        {
                auto block = размерБлока();
                бцел i = байты & (block-1);

                if (i < block-добавьSize)
                    padMessage (буфер[i..block-добавьSize]);
                else 
                   {
                   padMessage (буфер[i..block]);
                   трансформируй (буфер);
                   буфер[] = 0;
                   }

                padLength (буфер[block-добавьSize..block], байты);
                трансформируй (буфер);

                extend ();

                if (буф.length < digestSize())
                    буф.length = digestSize();

                создайДайджест (буф);
                
                сбрось ();
                return буф;
        }

        /***********************************************************************

                Converts 8 bit в_ 32 bit Литл Endian

                Параметры:
                ввод  = the источник Массив
                вывод = the destination Массив

                Remarks:
                Converts an Массив of ббайт[] преобр_в бцел[] in Литл Endian байт order.

        ***********************************************************************/

        static protected final проц littleEndian32(ббайт[] ввод, бцел[] вывод)
        {
                assert(вывод.length == ввод.length/4);
                вывод[] = cast(бцел[]) ввод;

                version (БигЭндиан)
                         ПерестановкаБайт.своп32 (вывод.ptr, вывод.length * бцел.sizeof);
        }

        /***********************************************************************

                Converts 8 bit в_ 32 bit Биг Endian

                Параметры:
                ввод  = the источник Массив
                вывод = the destination Массив

                Remarks:
                Converts an Массив of ббайт[] преобр_в бцел[] in Биг Endian байт order.

        ***********************************************************************/

        static protected final проц bigEndian32(ббайт[] ввод, бцел[] вывод)
        {
                assert(вывод.length == ввод.length/4);
                вывод[] = cast(бцел[]) ввод;

                version(LittleEndian)
                        ПерестановкаБайт.своп32 (вывод.ptr, вывод.length *  бцел.sizeof);
        }

        /***********************************************************************

                Converts 8 bit в_ 64 bit Литл Endian

                Параметры:
                ввод  = the источник Массив
                вывод = the destination Массив

                Remarks:
                Converts an Массив of ббайт[] преобр_в бдол[] in Литл Endian байт order.

        ***********************************************************************/

        static protected final проц littleEndian64(ббайт[] ввод, бдол[] вывод)
        {
                assert(вывод.length == ввод.length/8);
                вывод[] = cast(бдол[]) ввод;

                version (БигЭндиан)
                         ПерестановкаБайт.своп64 (вывод.ptr, вывод.length * бдол.sizeof);
        }

        /***********************************************************************

                Converts 8 bit в_ 64 bit Биг Endian

                Параметры: ввод  = the источник Массив
                вывод = the destination Массив

                Remarks:
                Converts an Массив of ббайт[] преобр_в бдол[] in Биг Endian байт order.

        ***********************************************************************/

        static protected final проц bigEndian64(ббайт[] ввод, бдол[] вывод)
        {
                assert(вывод.length == ввод.length/8);
                вывод[] = cast(бдол[]) ввод;

                version (LittleEndian)
                         ПерестановкаБайт.своп64 (вывод.ptr, вывод.length * бдол.sizeof);
        }

        /***********************************************************************

                Rotate left by n

                Параметры:
                x = the значение в_ rotate
                n = the amount в_ rotate by

                Remarks:
                Rotates a 32 bit значение by the specified amount.

        ***********************************************************************/

        static protected final бцел rotateLeft(бцел x, бцел n)
        {
               /+version (D_InlineAsm_X86)
                        version (DigitalMars)
                        {
                        asm {
                            naked;
                            mov ECX,EAX;
                            mov EAX,4[ESP];
                            rol EAX,CL;
                            ret 4;
                            }
                        }
                     else
                        return (x << n) | (x >> (32-n));
            else +/
                   return (x << n) | (x >> (32-n));
        }
}


