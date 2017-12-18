//-----------------------------------------------------------------------------
// wxD - contextmenuevent.cpp
// (C) 2005 bero <berobero.sourceforge.net>
// based on
// wx.NET - contextmenuevent.cxx
// 
// The wxContextMenuEvent proxy interface.
//
// Written by Alexander Olk (xenomorph2@onlinehome.de)
// (C) 2004 by Alexander Olk
// Licensed under the wxWidgets license, see LICENSE.txt for details.
//
// $Id: contextmenuevent.cpp,v 1.9 2006/11/17 15:21:03 afb Exp $
//-----------------------------------------------------------------------------
/*
#include <wx/wx.h>
#include "common.h"
*/
#include "stdafx.h"

//-----------------------------------------------------------------------------

extern "C" WXEXPORT
wxContextMenuEvent* wxContextMenuEvent_ctor(wxEventType type,wxWindowID winid,const wxPoint* pt)
{
    return new wxContextMenuEvent(type,winid,*pt);
}

extern "C" WXEXPORT
void wxContextMenuEvent_GetPosition(wxContextMenuEvent* self, wxPoint* inp)
{
	*inp = self->GetPosition();
}

extern "C" WXEXPORT
void wxContextMenuEvent_SetPosition(wxContextMenuEvent* self, wxPoint* inp)
{
	self->SetPosition(*inp);
}
