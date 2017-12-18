//-----------------------------------------------------------------------------
// wxD - palettechangedevent.cpp
// (C) 2005 bero <berobero.sourceforge.net>
// based on
// wx.NET - palettechangedevent.cxx
// 
// The wxPaletteChangedEvent proxy interface.
//
// Written by Alexander Olk (xenomorph2@onlinehome.de)
// (C) 2004 by Alexander Olk
// Licensed under the wxWidgets license, see LICENSE.txt for details.
//
// $Id: palettechangedevent.cpp,v 1.9 2006/11/17 15:21:04 afb Exp $
//-----------------------------------------------------------------------------
/*
#include <wx/wx.h>
#include "common.h"
*/
#include "stdafx.h"
//-----------------------------------------------------------------------------

extern "C" WXEXPORT
wxPaletteChangedEvent* wxPaletteChangedEvent_ctor(wxWindowID winid)
{
    return new wxPaletteChangedEvent(winid);
}

extern "C" WXEXPORT
wxPaletteChangedEvent* wxPaletteChangedEvent_ctor2(wxEventType type)
{
    return new wxPaletteChangedEvent(type);
}

extern "C" WXEXPORT
void wxPaletteChangedEvent_SetChangedWindow(wxPaletteChangedEvent* self, wxWindow* win)
{
	self->SetChangedWindow(win);
}

extern "C" WXEXPORT
wxWindow* wxPaletteChangedEvent_GetChangedWindow(wxPaletteChangedEvent* self)
{
	return self->GetChangedWindow();
}
