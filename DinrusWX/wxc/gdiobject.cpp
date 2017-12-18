//-----------------------------------------------------------------------------
// wxD - gdiobject.cpp
// (C) 2005 bero <berobero.sourceforge.net>
// based on
// wx.NET - gdiobject.cxx
//
// The wxGDIObject proxy interface.
//
// Written by Jason Perkins (jason@379.com)
// (C) 2003 by 379, Inc.
// Licensed under the wxWidgets license, see LICENSE.txt for details.
//
// $Id: gdiobject.cpp,v 1.9 2006/11/17 15:21:03 afb Exp $
//-----------------------------------------------------------------------------
/*
#include <wx/wx.h>
#include "common.h"
*/
#include "stdafx.h"
//-----------------------------------------------------------------------------

extern "C" WXEXPORT
void wxGDIObj_dtor(wxGDIObject* self)
{
	delete self;
}


