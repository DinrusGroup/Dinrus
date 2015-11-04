/*******************************************************************************

        copyright:      Copyright (c) 2005 John Chapman. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Mопр 2005: Initial release
                        Apr 2007: reshaped                        

        author:         John Chapman, Kris

******************************************************************************/

module time.chrono.Korean;

private import time.chrono.GregorianBased;


/** 
 * $(ANCHOR _Korean)
 * Represents the Korean Календарь.
 */
public class Korean : ГрегорианВОснове {
  /**
   * $(I Property.) Overrопрden. Retrieves the определитель associated with the текущ Календарь.
   * Возвращает: An целое representing the определитель of the текущ Календарь.
   */
  public override бцел опр() {
    return КОРЕЙСКИЙ;
  }

}


