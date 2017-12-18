//-----------------------------------------------------------------------------
// wxD - mousecapturechangedevent.cpp
// (C) 2005 bero <berobero.sourceforge.net>
// based on
// wx.NET - mousecapturechangedevent.cxx
// 
// The wxMouseCaptureChangedEvent proxy interface.
//
// Written by Alexander Olk (xenomorph2@onlinehome.de)
// (C) 2004 by Alexander Olk
// Licensed under the wxWidgets license, see LICENSE.txt for details.
//
// $Id: mousecapturechangedevent.cpp,v 1.9 2006/11/17 15:21:04 afb Exp $
//-----------------------------------------------------------------------------
/*
#include <wx/wx.h>
#include "common.h"
*/
#include "stdafx.h"
//-----------------------------------------------------------------------------

extern "C" WXEXPORT
wxMouseCaptureChangedEvent* wxMouseCaptureChangedEvent_ctor(wxWindowID winid, wxWindow* gainedCapture)
{
    return new wxMouseCaptureChangedEvent(winid,gainedCapture);
}

extern "C" WXEXPORT
wxWindow* wxMouseCaptureChangedEvent_GetCapturedWindow(wxMouseCaptureChangedEvent* self)
{
	return self->GetCapturedWindow();
}
