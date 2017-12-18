//-----------------------------------------------------------------------------
// wxD - moveevent.cpp
// (C) 2005 bero <berobero.sourceforge.net>
// based on
// wx.NET - moveevent.cxx
//
// The wxMoveEvent wrapper class.
//
// Written by Alexander Olk (xenomorph2@onlinehome.de)
// (C) 2004 by Alexander Olk
// Licensed under the wxWidgets license, see LICENSE.txt for details.
//
// $Id: moveevent.cpp,v 1.9 2006/11/17 15:21:04 afb Exp $
//-----------------------------------------------------------------------------
/*
#include <wx/wx.h>
#include "common.h"
*/
#include "stdafx.h"
//-----------------------------------------------------------------------------

extern "C" WXEXPORT
wxMoveEvent* wxMoveEvent_ctor()
{
    return new wxMoveEvent();
}

extern "C" WXEXPORT
void wxMoveEvent_GetPosition(wxMoveEvent* self, wxPoint* point)
{
    *point=self->GetPosition();
}
