//-----------------------------------------------------------------------------
// wxD - displaychangedevent.cpp
// (C) 2005 bero <berobero.sourceforge.net>
// based on
// wx.NET - displaychangedevent.cxx
// 
// The wxDisplayChangedEvent proxy interface.
//
// Written by Alexander Olk (xenomorph2@onlinehome.de)
// (C) 2004 by Alexander Olk
// Licensed under the wxWidgets license, see LICENSE.txt for details.
//
// $Id: displaychangedevent.cpp,v 1.9 2006/11/17 15:21:03 afb Exp $
//-----------------------------------------------------------------------------
/*
#include <wx/wx.h>
#include "common.h"
*/
#include "stdafx.h"

//-----------------------------------------------------------------------------

extern "C" WXEXPORT
wxDisplayChangedEvent* wxDisplayChangedEvent_ctor()
{
    return new wxDisplayChangedEvent();
}
