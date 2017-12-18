// stdafx.h: включаемый файл дл€ стандартных системных включаемых файлов
// или включаемых файлов дл€ конкретного проекта, которые часто используютс€, но
// не часто измен€ютс€
//

#pragma once

#include "targetver.h"
#define WIN32_LEAN_AND_MEAN             // »сключите редко используемые компоненты из заголовков Windows
// ‘айлы заголовков Windows:
#include <windows.h>
#include <stdio.h>
#include <string.h>


#define _CRT_SECURE_NO_WARNINGS
#define WXUSINGUNIV 1



#pragma warning( push )
#pragma warning (disable : 4996)


// TODO: ”становите здесь ссылки на дополнительные заголовки, требующиес€ дл€ программы
#include <wx/config.h>
#include <wx/string.h>
#include <wx/event.h>
#include <wx/wx.h>
#include <wx/button.h>
#include <wx/bmpbuttn.h>
#include <wx/bitmap.h>
#include <wx/image.h>
#include <wx/artprov.h>
#include <wx/control.h>
#include <wx/combobox.h>
#include <wx/colordlg.h>
#include <wx/clipbrd.h>
#include <wx/textctrl.h>
#include <wx/choicdlg.h>
#include <wx/choice.h>
#include <wx/caret.h>
#include <wx/calctrl.h>
//#include <wx/generic/calctrlg.h>
#include <wx/tglbtn.h>
#include <wx/calctrl.h>
#include <wx/fdrepdlg.h>
#include <wx/treectrl.h>
#include <wx/listctrl.h>
#include <wx/notebook.h>
#include <wx/listbook.h>
#include <wx/grid.h>
#include <wx/sashwin.h>
#include <wx/laywin.h>
#include <wx/display.h>
#include <wx/dirdlg.h>
#include <wx/dataobj.h>
#include <wx/msw/dc.h>
#include <wx/msw/dcclient.h>
#include <wx/dcclient.h>
#include <wx/docview.h>
#include <wx/dnd.h>
#include <wx/filedlg.h>
#include <wx/fdrepdlg.h>
#include <wx/sizer.h>
#include <wx/font.h>
#include <wx/fontdlg.h>
#include <wx/fontmap.h>
#include <wx/encconv.h>
#include <wx/fontenum.h>
#include <wx/gauge.h>
#include <wx/gdicmn.h>
#include <wx/glcanvas.h>
#include <wx/window.h>
#include <wx/busyinfo.h>
#include <wx/grid.h>
#include <wx/generic/gridctrl.h>
#include <wx/gbsizer.h>
#include <wx/grid.h>
#include <wx/generic/gridctrl.h>
#include <wx/sizer.h>
#include <wx/html/htmlwin.h>
#include <wx/html/htmlproc.h>
#include <wx/html/htmprint.h>
#include <wx/html/helpctrl.h>
#include <wx/html/htmlcell.h>
#include <wx/htmllbox.h>
#include <wx/image.h>
#include <wx/mstream.h>
#include <wx/imaglist.h>
#include <wx/laywin.h>
#include <wx/listbox.h>
#include <wx/checklst.h>
//#include <wx/univ/listbox.h>
//#include <wx/univ/checklst.h>
#include <wx/listctrl.h>
#include <wx/log.h>
#include <wx/minifram.h>
#include <wx/mdi.h>
#include <wx/dcbuffer.h>
#include <wx/dcmemory.h>
#include <wx/minifram.h>
#include <wx/notebook.h>
#include <wx/sizer.h>
#include <wx/numdlg.h>
#include <wx/checklst.h>
#include <wx/palette.h>
#include <wx/panel.h>
#include <wx/cmndata.h>
#include <wx/generic/prntdlgg.h>
#include <wx/printdlg.h>
#include <wx/print.h>
#include <wx/progdlg.h>
#include <wx/radiobut.h>
#include <wx/region.h>
#include <wx/sashwin.h>
#include <wx/scrolbar.h>
#include <wx/scrolwin.h>
#include <wx/slider.h>
#include <wx/sound.h>
#include <wx/event.h>
#include <wx/spinbutt.h>
#include <wx/spinctrl.h>
#include <wx/splash.h>
#include <wx/splitter.h>
#include <wx/statbmp.h>
#include <wx/statbox.h>
#include <wx/statline.h>
//#include <wx/stc/stc.h>
#include <wx/settings.h>
//#include <wx/tabctrl.h>
#include <wx/taskbar.h>
#include <wx/textctrl.h>
#include <wx/textdlg.h>
#include <wx/thread.h>
#include <wx/timer.h>
#include <wx/tipdlg.h>
#include <wx/tipwin.h>
#include <wx/tglbtn.h>
#include <wx/toolbar.h>
#include <wx/tooltip.h>
#include <wx/treectrl.h>
#include <wx/validate.h>
#include <wx/vlbox.h>
#include <wx/vscroll.h>
#include <wx/wizard.h>
#include <wx/datetime.h>
#include <wx/platform.h>
#include <wx/utils.h>
#include <wx/version.h>
#include <wx/xrc/xmlres.h>
#include <wx/fontenum.h>
#include <wx/fs_mem.h>
#include <wx/aui/aui.h>
#include <wx/imagbmp.h>
#include <wx/wx.h>
#include "common.h"
#include "local_events.h"
#include <stdio.h>
#include <wx/menuitem.h>
#include <wx/renderer.h>
#include <wx/checklst.h>
#include <wx/listbox.h>

#define wxUSE_OWNER_DRAWN 1
#define  wxUSE_CHECKLISTBOX 1
//included from wx/msw
#include <wx/msw/checklst.h>
#include <wx/msw/listbox.h>

/*
#ifndef __WXGTK__
#include <wx/tabctrl.h>
#endif
*/
