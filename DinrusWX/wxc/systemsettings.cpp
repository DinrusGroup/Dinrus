//-----------------------------------------------------------------------------
// wxD - systemsettings.cpp
// (C) 2005 bero <berobero.sourceforge.net>
// based on
// wx.NET - systemsettings.cxx
//
// The wxSystemSettings proxy interface.
//
// Written by Bryan Bulten (bryan@bulten.ca)
// (C) 2003 by Bryan Bulten
// Licensed under the wxWidgets license, see LICENSE.txt for details.
//
// $Id: systemsettings.cpp,v 1.10 2007/01/15 11:55:39 afb Exp $
//-----------------------------------------------------------------------------
/*
#include <wx/wx.h>
#include "common.h"
#include <wx/settings.h>
*/
#include "stdafx.h"
//-----------------------------------------------------------------------------

extern "C" WXEXPORT
wxColour* wxSystemSettings_GetColour(wxSystemColour index)
{
    return new wxColour(wxSystemSettings::GetColour(index));
}

//-----------------------------------------------------------------------------

extern "C" WXEXPORT
wxFont* wxSystemSettings_GetFont(wxSystemFont index)
{
    return new wxFont(wxSystemSettings::GetFont(index));
}

//-----------------------------------------------------------------------------

extern "C" WXEXPORT
int wxSystemSettings_GetMetric(wxSystemMetric index)
{
    return wxSystemSettings::GetMetric(index);
}

//-----------------------------------------------------------------------------

extern "C" WXEXPORT
wxc_bool wxSystemSettings_HasFeature(wxSystemFeature index)
{
    return wxSystemSettings::HasFeature(index)?1:0;
}

//-----------------------------------------------------------------------------

extern "C" WXEXPORT
wxSystemScreenType wxSystemSettings_GetScreenType()
{
    return wxSystemSettings::GetScreenType();
}

//-----------------------------------------------------------------------------

extern "C" WXEXPORT
void wxSystemSettings_SetScreenType(wxSystemScreenType screen)
{
    wxSystemSettings::SetScreenType(screen);
}

