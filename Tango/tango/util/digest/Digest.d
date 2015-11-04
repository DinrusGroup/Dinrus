/******************************************************************************

        copyright:      Copyright (c) 2006 Dinrus. все rights reserved

        license:        BSD стиль: see doc/license.txt for details

        version:        Initial release: Feb 2006

        author:         Regan Heath, Oskar Linde

        This module defines the Дайджест interface. 

******************************************************************************/

module util.digest.Digest;

private import cidrus: alloca;

/*******************************************************************************

        The DigestTransform interface defines the interface of сообщение
        дайджест algorithms, such as MD5 and SHA. Message digests are
        безопасно hash functions that take a сообщение of arbitrary length
        and произведи a fix length дайджест as вывод.

        A объект implementing the DigestTransform should старт out инициализован.
        The данные is processed though calls в_ the обнови метод. Once все данные
        есть been sent в_ the algorithm, the дайджест is finalized and computed
        with the дайджест метод.

        The дайджест метод may only be called once. After the дайджест
        метод есть been called, the algorithm is сбрось в_ its начальное
        состояние.

        Using the обнови метод, данные may be processed piece by piece, 
        which is useful for cases involving Потокs of данные.

        For example:
        ---
        // создай an MD5 hash algorithm
        Md5 hash = new Md5();

        // process some данные
        hash.обнови("The быстро brown fox");

        // process some ещё данные
        hash.обнови(" jumps over the lazy dog");

        // conclude algorithm and произведи дайджест
        ббайт[] дайджест = hash.двоичныйДайджест();
        ---

******************************************************************************/

abstract class Дайджест 
{
        /*********************************************************************
     
               Processes данные
               
               Remarks:
                     Updates the hash algorithm состояние with new данные
                 
        *********************************************************************/
    
        abstract Дайджест обнови (проц[] данные);
    
        /********************************************************************

               Computes the дайджест and resets the состояние

               Параметры:
                   буфер = a буфер can be supplied for the дайджест в_ be
                            записано в_

               Remarks:
                   If the буфер is not large enough в_ hold the
                   дайджест, a new буфер is allocated and returned.
                   The algorithm состояние is always сбрось after a вызов в_
                   двоичныйДайджест. Use the digestSize метод в_ найди out как
                   large the буфер есть в_ be.
                   
        *********************************************************************/
    
        abstract ббайт[] двоичныйДайджест(ббайт[] буфер = пусто);
    
        /********************************************************************
     
               Returns the размер in байты of the дайджест
               
               Возвращает:
                 the размер of the дайджест in байты

               Remarks:
                 Returns the размер of the дайджест.
                 
        *********************************************************************/
    
        abstract бцел digestSize();
        
        /*********************************************************************
               
               Computes the дайджест as a hex ткст and resets the состояние
               
               Параметры:
                   буфер = a буфер can be supplied in which the дайджест
                            will be записано. It needs в_ be able в_ hold
                            2 * digestSize chars
            
               Remarks:
                    If the буфер is not large enough в_ hold the hex дайджест,
                    a new буфер is allocated and returned. The algorithm
                    состояние is always сбрось after a вызов в_ гексДайджест.
                    
        *********************************************************************/
        
        ткст гексДайджест (ткст буфер = пусто) 
        {
                бцел ds = digestSize();
            
                if (буфер.length < ds * 2)
                    буфер.length = ds * 2;
                
                version(darwin){
                    ббайт[] буф = new ббайт[ds]; // the whole alloca mess needs в_ be adressed better
                } else {
                    ббайт[] буф = (cast(ббайт *) alloca(ds))[0..ds];
                }
                ббайт[] ret = двоичныйДайджест(буф);
                assert(ret.ptr == буф.ptr);
            
                static ткст hexdigits = "0123456789abcdef";
                цел i = 0;
            
                foreach (b; буф) 
                        {
                        буфер[i++] = hexdigits[b >> 4];
                        буфер[i++] = hexdigits[b & 0xf];
                        }
            
                return буфер;
        }
}

