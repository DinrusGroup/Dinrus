//-----------------------------------------------------------------------------
// wxD - icon.cpp
// (C) 2005 bero <berobero.sourceforge.net>
// based on
// wx.NET - icon.cxx
//
// The wxIcon proxy interface.
//
// Written by Jason Perkins (jason@379.com)
// (C) 2003 by 379, Inc.
// Licensed under the wxWidgets license, see LICENSE.txt for details.
//
// $Id: icon.cpp,v 1.10 2007/01/15 11:55:37 afb Exp $
//-----------------------------------------------------------------------------
/*
#include <wx/wx.h>
#include "common.h"
*/
#include "stdafx.h"
//-----------------------------------------------------------------------------

extern "C" WXEXPORT
wxIcon* wxIcon_ctor()
{
	return new wxIcon();
}

//-----------------------------------------------------------------------------

extern "C" WXEXPORT
void wxIcon_CopyFromBitmap(wxIcon* self, const wxBitmap* bitmap)
{
	self->CopyFromBitmap(*bitmap);
}

//-----------------------------------------------------------------------------

extern "C" WXEXPORT
wxc_bool wxIcon_LoadFile(wxIcon* self, wxc_string name, wxBitmapType type)
{
	return self->LoadFile(wxstr(name), type)?1:0;
}
