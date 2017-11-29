/*******************************************************************************

        copyright:      Copyright (c) 2005 John Chapman. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Mопр 2005: Initial release
                        Apr 2007: reshaped                        

        author:         John Chapman, Kris

******************************************************************************/

module time.chrono.ThaiBuddhist;

private import time.chrono.GregorianBased;


/**
 * $(ANCHOR _ThaiBuddhist)
 * Represents the Thai Buddhist Календарь.
 */
public class ThaiBuddhist : ГрегорианВОснове {
  /**
   * $(I Property.) Overrопрden. Retrieves the определитель associated with the текущ Календарь.
   * Возвращает: An целое representing the определитель of the текущ Календарь.
   */
  public override бцел опр() {
    return ТАИ;
  }

}
