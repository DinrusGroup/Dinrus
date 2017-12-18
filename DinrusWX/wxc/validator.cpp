//-----------------------------------------------------------------------------
// wxD - validator.cpp
// (C) 2005 bero <berobero.sourceforge.net>
// based on
// wx.NET - validator.cxx
//
// The wxValidator proxy interface
//
// Written by Alexander Olk (xenomorph2@onlinehome.de)
// (C) 2004 by Alexander Olk
// Licensed under the wxWidgets license, see LICENSE.txt for details.
//
// $Id: validator.cpp,v 1.9 2006/11/17 15:21:05 afb Exp $
//-----------------------------------------------------------------------------
/*
#include <wx/wx.h>
#include "common.h"
#include <wx/validate.h>
*/
#include "stdafx.h"

extern "C" WXEXPORT
wxValidator* wxValidator_ctor()
{
	return new wxValidator();
}

extern "C" WXEXPORT
const wxValidator* wxDefaultValidator_Get()
{
	return &wxDefaultValidator;
}
