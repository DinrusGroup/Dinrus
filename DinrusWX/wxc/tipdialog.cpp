//-----------------------------------------------------------------------------
// wxD - tipdialog.cpp
// (C) 2005 bero <berobero.sourceforge.net>
// based on
// wx.NET - tipdialog.cxx
//
// The wxTipProvider proxy interface.
//
// Written by Alexander Olk (xenomorph2@onlinehome.de)
// (C) 2003 by Alexander Olk
// Licensed under the wxWidgets license, see LICENSE.txt for details.
//
// $Id: tipdialog.cpp,v 1.10 2007/01/15 11:55:39 afb Exp $
//-----------------------------------------------------------------------------
/*
#include <wx/wx.h>
#include "common.h"
#include <wx/tipdlg.h>
#include "local_events.h"
*/
#include "stdafx.h"

static wxTipProvider* mpTipProvider = NULL;

//-----------------------------------------------------------------------------

extern "C" WXEXPORT
size_t wxTipProvider_GetCurrentTip()
{
    if ( mpTipProvider == NULL ) return 0;
    return mpTipProvider->GetCurrentTip();
}

//-----------------------------------------------------------------------------

extern "C" WXEXPORT
wxTipProvider* wxCreateFileTipProvider_func(wxc_string filename, size_t currentTip)
{
	if ( mpTipProvider != NULL)
	{
		delete mpTipProvider;
	}
	
	mpTipProvider = wxCreateFileTipProvider(wxstr(filename), currentTip);
	return mpTipProvider;
}

//-----------------------------------------------------------------------------

extern "C" WXEXPORT
wxc_bool wxShowTip_func(wxWindow* parent, wxTipProvider *tipProvider, wxc_bool showAtStartup)
{
	return wxShowTip(parent, tipProvider, showAtStartup)?1:0;
}

//-----------------------------------------------------------------------------







