﻿/*******************************************************************************

        copyright:      Copyright (c) 2007 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Jan 2007 : начальное release
        
        author:         Kris 

*******************************************************************************/

module io.protocol.PickleProtocol;

/*******************************************************************************

*******************************************************************************/

version (БигЭндиан)
        {
        private import io.protocol.NativeProtocol;
        public alias ПротоколНатив ПротоколПикл;
        }
     else
        {
        private import io.protocol.EndianProtocol;
        public alias ПротоколЭндиан ПротоколПикл;
        }


/*******************************************************************************

*******************************************************************************/

debug (UnitTest)
{
        import io.device.Array;

        unittest
        {
                цел тест = 0xcc55ff00;
                
                auto протокол = new ПротоколПикл (new Массив(32));
                протокол.пиши (&тест, тест.sizeof, протокол.Тип.Int);

                auto ptr = протокол.буфер.срез (тест.sizeof, нет).ptr;
                протокол.читай  (&тест, тест.sizeof, протокол.Тип.Int);
                
                assert (тест == 0xcc55ff00);
                
                version (LittleEndian)
                         assert (*cast(цел*) ptr == 0x00ff55cc);
        }
}





