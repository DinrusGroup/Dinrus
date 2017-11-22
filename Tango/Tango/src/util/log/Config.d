/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)
      
        version:        Initial release: May 2004
        
        author:         Kris

*******************************************************************************/

module util.log.Config;

public  import  util.log.Log : Журнал;

private import  util.log.LayoutData,
                util.log.AppendConsole;

/*******************************************************************************

        Utility for initializing the basic behaviour of the default
        logging иерархия.

        добавьs a default console добавщик with a генерный выкладка в_ the 
        корень узел, и установи the activity уровень в_ be everything включен
                
*******************************************************************************/

static this ()
{
        Журнал.корень.добавь (new ДобВКонсоль (new ДанныеОВыкладке));
}

