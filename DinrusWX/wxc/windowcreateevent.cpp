//-----------------------------------------------------------------------------
// wxD - windowcreateevent.cpp
// (C) 2005 bero <berobero.sourceforge.net>
// based on
// wx.NET - windowcreateevent.cxx
// 
// The wxWindowCreateEvent proxy interface.
//
// Written by Alexander Olk (xenomorph2@onlinehome.de)
// (C) 2004 by Alexander Olk
// Licensed under the wxWidgets license, see LICENSE.txt for details.
//
// $Id: windowcreateevent.cpp,v 1.9 2006/11/17 15:21:05 afb Exp $
//-----------------------------------------------------------------------------
/*
#include <wx/wx.h>
#include "common.h"
*/
#include "stdafx.h"
//-----------------------------------------------------------------------------

extern "C" WXEXPORT
wxWindowCreateEvent* wxWindowCreateEvent_ctor(wxWindow* win)
{
    return new wxWindowCreateEvent(win);
}

extern "C" WXEXPORT
wxWindow* wxWindowCreateEvent_GetWindow(wxWindowCreateEvent* self)
{
	return self->GetWindow();
}
