//-----------------------------------------------------------------------------
// wxD - childfocusevent.cpp
// (C) 2005 bero <berobero.sourceforge.net>
// based on
// wx.NET - childfocusevent.cxx
// 
// The wxChildFocusEvent proxy interface.
//
// Written by Alexander Olk (xenomorph2@onlinehome.de)
// (C) 2004 by Alexander Olk
// Licensed under the wxWidgets license, see LICENSE.txt for details.
//
// $Id: childfocusevent.cpp,v 1.9 2006/11/17 15:21:02 afb Exp $
//-----------------------------------------------------------------------------
/*
#include <wx/wx.h>
#include "common.h"
*/
#include "stdafx.h"

//-----------------------------------------------------------------------------

extern "C" WXEXPORT
wxChildFocusEvent* wxChildFocusEvent_ctor(wxWindow* win)
{
    return new wxChildFocusEvent(win);
}

extern "C" WXEXPORT
wxWindow* wxChildFocusEvent_GetWindow(wxChildFocusEvent* self)
{
	return self->GetWindow();
}
