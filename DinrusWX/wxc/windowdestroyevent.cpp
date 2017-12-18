//-----------------------------------------------------------------------------
// wxD - windowdestroyevent.cpp
// (C) 2005 bero <berobero.sourceforge.net>
// based on
// wx.NET - windowdestroyevent.cxx
// 
// The wxWindowDestroyEvent proxy interface.
//
// Written by Alexander Olk (xenomorph2@onlinehome.de)
// (C) 2004 by Alexander Olk
// Licensed under the wxWidgets license, see LICENSE.txt for details.
//
// $Id: windowdestroyevent.cpp,v 1.9 2006/11/17 15:21:05 afb Exp $
//-----------------------------------------------------------------------------
/*
#include <wx/wx.h>
#include "common.h"
*/
#include "stdafx.h"
//-----------------------------------------------------------------------------

extern "C" WXEXPORT
wxWindowDestroyEvent* wxWindowDestroyEvent_ctor(wxWindow* win)
{
    return new wxWindowDestroyEvent(win);
}

extern "C" WXEXPORT
wxWindow* wxWindowDestroyEvent_GetWindow(wxWindowDestroyEvent* self)
{
	return self->GetWindow();
}
