//-----------------------------------------------------------------------------
// wxD - iconizeevent.cpp
// (C) 2005 bero <berobero.sourceforge.net>
// based on
// wx.NET - iconizeevent.cxx
// 
// The wxIconizeEvent proxy interface.
//
// Written by Alexander Olk (xenomorph2@onlinehome.de)
// (C) 2004 by Alexander Olk
// Licensed under the wxWidgets license, see LICENSE.txt for details.
//
// $Id: iconizeevent.cpp,v 1.10 2007/01/15 11:55:37 afb Exp $
//-----------------------------------------------------------------------------
/*
#include <wx/wx.h>
#include "common.h"
*/
#include "stdafx.h"

//-----------------------------------------------------------------------------

extern "C" WXEXPORT
wxIconizeEvent* wxIconizeEvent_ctor(int winid, wxc_bool iconized)
{
    return new wxIconizeEvent(winid,iconized);
}

extern "C" WXEXPORT
wxc_bool wxIconizeEvent_Iconized(wxIconizeEvent* self)
{
	return self->Iconized()?1:0;
}
