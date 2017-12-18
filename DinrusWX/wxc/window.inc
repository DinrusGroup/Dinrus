//-----------------------------------------------------------------------------
// wx.NET - window.inc
//
// The wxWindow virtual function dispatchers.
//
// Written by Jason Perkins (jason@379.com)
// (C) 2003 by 379, Inc.
// Licensed under the wxWidgets license, see LICENSE.txt for details.
//
// $Id: window.inc,v 1.9 2006/11/17 15:21:05 afb Exp $
//-----------------------------------------------------------------------------

virtual bool TransferDataFromWindow()
{
	FunctionEvent e(wxEVT_TRANSFERDATAFROMWINDOW);
	ProcessEvent(e);
	return (!e.GetSkipped());
}

virtual bool TransferDataToWindow()
{
	FunctionEvent e(wxEVT_TRANSFERDATATOWINDOW);
	ProcessEvent(e);
	return (!e.GetSkipped());
}
