//-----------------------------------------------------------------------------
// wxD - ncpaintevent.cpp
// (C) 2005 bero <berobero.sourceforge.net>
// based on
// wx.NET - ncpaintevent.cxx
// 
// The wxNcPaintEvent proxy interface.
//
// Written by Alexander Olk (xenomorph2@onlinehome.de)
// (C) 2004 by Alexander Olk
// Licensed under the wxWidgets license, see LICENSE.txt for details.
//
// $Id: ncpaintevent.cpp,v 1.9 2006/11/17 15:21:04 afb Exp $
//-----------------------------------------------------------------------------
/*
#include <wx/wx.h>
#include "common.h"
*/
#include "stdafx.h"
//-----------------------------------------------------------------------------

extern "C" WXEXPORT
wxNcPaintEvent* wxNcPaintEvent_ctor(int Id)
{
    return new wxNcPaintEvent(Id);
}
