﻿/*******************************************************************************

        copyright:      Copyright (c) 2005 John Chapman. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Mопр 2005: Initial release
                        Apr 2007: reshaped                        

        author:         John Chapman, Kris

******************************************************************************/

module time.chrono.Japanese;

private import time.chrono.GregorianBased;


/**
 * $(ANCHOR _Japanese)
 * Represents the Japanese calendar.
 */
public class Japanese : ГрегорианВОснове 
{
  /**
   * $(I Property.) Overrопрden. Retrieves the определитель associated with the current calendar.
   * Возвращает: An целое representing the определитель of the current calendar.
   */
  public override бцел опр() {
    return ЯПОНСКИЙ;
  }

}