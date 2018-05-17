/*******************************************************************************
 * Copyright (c) 2000, 2008 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module dwtx.jface.text.contentassist.PopupCloser;

import dwtx.jface.text.contentassist.ContentAssistEvent; // packageimport
import dwtx.jface.text.contentassist.Helper; // packageimport
import dwtx.jface.text.contentassist.IContentAssistant; // packageimport
import dwtx.jface.text.contentassist.CompletionProposal; // packageimport
import dwtx.jface.text.contentassist.ICompletionProposalExtension5; // packageimport
import dwtx.jface.text.contentassist.IContextInformationValidator; // packageimport
import dwtx.jface.text.contentassist.IContentAssistListener; // packageimport
import dwtx.jface.text.contentassist.ICompletionProposalExtension6; // packageimport
import dwtx.jface.text.contentassist.ICompletionListener; // packageimport
import dwtx.jface.text.contentassist.ICompletionProposalExtension2; // packageimport
import dwtx.jface.text.contentassist.IContentAssistantExtension4; // packageimport
import dwtx.jface.text.contentassist.ContextInformation; // packageimport
import dwtx.jface.text.contentassist.ICompletionProposalExtension3; // packageimport
import dwtx.jface.text.contentassist.ContextInformationValidator; // packageimport
import dwtx.jface.text.contentassist.ICompletionProposal; // packageimport
import dwtx.jface.text.contentassist.IContentAssistProcessor; // packageimport
import dwtx.jface.text.contentassist.AdditionalInfoController; // packageimport
import dwtx.jface.text.contentassist.IContextInformationPresenter; // packageimport
import dwtx.jface.text.contentassist.ICompletionProposalExtension4; // packageimport
import dwtx.jface.text.contentassist.ICompletionListenerExtension; // packageimport
import dwtx.jface.text.contentassist.ContextInformationPopup; // packageimport
import dwtx.jface.text.contentassist.IContextInformationExtension; // packageimport
import dwtx.jface.text.contentassist.IContentAssistantExtension2; // packageimport
import dwtx.jface.text.contentassist.ContentAssistSubjectControlAdapter; // packageimport
import dwtx.jface.text.contentassist.CompletionProposalPopup; // packageimport
import dwtx.jface.text.contentassist.ICompletionProposalExtension; // packageimport
import dwtx.jface.text.contentassist.IContextInformation; // packageimport
import dwtx.jface.text.contentassist.IContentAssistantExtension3; // packageimport
import dwtx.jface.text.contentassist.ContentAssistant; // packageimport
import dwtx.jface.text.contentassist.IContentAssistantExtension; // packageimport
import dwtx.jface.text.contentassist.JFaceTextMessages; // packageimport


import dwt.dwthelper.utils;



import dwt.DWT;
import dwt.events.FocusEvent;
import dwt.events.FocusListener;
import dwt.events.SelectionEvent;
import dwt.events.SelectionListener;
import dwt.events.ShellAdapter;
import dwt.events.ShellEvent;
import dwt.widgets.Control;
import dwt.widgets.Display;
import dwt.widgets.Event;
import dwt.widgets.Listener;
import dwt.widgets.ScrollBar;
import dwt.widgets.Shell;
import dwt.widgets.Table;
import dwtx.jface.internal.text.DelayedInputChangeListener;
import dwtx.jface.internal.text.InformationControlReplacer;
import dwtx.jface.text.IDelayedInputChangeProvider;
import dwtx.jface.text.IInformationControl;
import dwtx.jface.text.IInformationControlExtension5;
import dwtx.jface.text.IInputChangedListener;


/**
 * A generic closer class used to monitor various
 * interface events in order to determine whether
 * a content assistant should be terminated and all
 * associated windows be closed.
 */
class PopupCloser : ShellAdapter , FocusListener, SelectionListener, Listener {

    /** The content assistant to be monitored. */
    private ContentAssistant fContentAssistant;
    /** The table of a selector popup opened by the content assistant. */
    private Table fTable;
    /** The scroll bar of the table for the selector popup. */
    private ScrollBar fScrollbar;
    /** Indicates whether the scroll bar thumb has been grabbed. */
    private bool fScrollbarClicked= false;
    /**
     * The shell on which some listeners are registered.
     * @since 3.1
     */
    private Shell fShell;
    /**
     * The display on which some filters are registered.
     * @since 3.4
     */
    private Display fDisplay;
    /**
     * The additional info controller, or <code>null</code>.
     * @since 3.4
     */
    private AdditionalInfoController fAdditionalInfoController;

    /**
     * Installs this closer on the given table opened by the given content assistant.
     *
     * @param contentAssistant the content assistant
     * @param table the table to be tracked
     */
    public void install(ContentAssistant contentAssistant, Table table) {
        install(contentAssistant, table, null);
    }

    /**
     * Installs this closer on the given table opened by the given content assistant.
     *
     * @param contentAssistant the content assistant
     * @param table the table to be tracked
     * @param additionalInfoController the additional info controller, or <code>null</code>
     * @since 3.4
     */
    public void install(ContentAssistant contentAssistant, Table table, AdditionalInfoController additionalInfoController) {
        fContentAssistant= contentAssistant;
        fTable= table;
        fAdditionalInfoController= additionalInfoController;

        if (Helper.okToUse(fTable)) {
            fShell= fTable.getShell();
            fDisplay= fShell.getDisplay();

            fShell.addShellListener(this);
            fTable.addFocusListener(this);
            fScrollbar= fTable.getVerticalBar();
            if (fScrollbar !is null)
                fScrollbar.addSelectionListener(this);

            fDisplay.addFilter(DWT.Activate, this);
            fDisplay.addFilter(DWT.MouseWheel, this);

            fDisplay.addFilter(DWT.Deactivate, this);

            fDisplay.addFilter(DWT.MouseUp, this);
        }
    }

    /**
     * Uninstalls this closer if previously installed.
     */
    public void uninstall() {
        fContentAssistant= null;
        if (Helper.okToUse(fShell))
            fShell.removeShellListener(this);
        fShell= null;
        if (Helper.okToUse(fScrollbar))
            fScrollbar.removeSelectionListener(this);
        if (Helper.okToUse(fTable))
            fTable.removeFocusListener(this);
        if (fDisplay !is null && ! fDisplay.isDisposed()) {
            fDisplay.removeFilter(DWT.Activate, this);
            fDisplay.removeFilter(DWT.MouseWheel, this);

            fDisplay.removeFilter(DWT.Deactivate, this);

            fDisplay.removeFilter(DWT.MouseUp, this);
        }
    }

    /*
     * @see dwt.events.SelectionListener#widgetSelected(dwt.events.SelectionEvent)
     */
    public void widgetSelected(SelectionEvent e) {
        fScrollbarClicked= true;
    }

    /*
     * @see dwt.events.SelectionListener#widgetDefaultSelected(dwt.events.SelectionEvent)
     */
    public void widgetDefaultSelected(SelectionEvent e) {
        fScrollbarClicked= true;
    }

    /*
     * @see dwt.events.FocusListener#focusGained(dwt.events.FocusEvent)
     */
    public void focusGained(FocusEvent e) {
    }

    /*
     * @see dwt.events.FocusListener#focusLost(dwt.events.FocusEvent)
     */
    public void focusLost(FocusEvent e) {
        fScrollbarClicked= false;
        Display d= fTable.getDisplay();
        d.asyncExec(dgRunnable((FocusEvent e_) {
            if (Helper.okToUse(fTable) && !fTable.isFocusControl() && !fScrollbarClicked && fContentAssistant !is null)
                fContentAssistant.popupFocusLost(e_);
        }, e ));
    }

    /*
     * @see dwt.events.ShellAdapter#shellDeactivated(dwt.events.ShellEvent)
     * @since 3.1
     */
    public void shellDeactivated(ShellEvent e) {
        if (fContentAssistant !is null && ! fContentAssistant.hasProposalPopupFocus())
            fContentAssistant.hide_package();
    }


    /*
     * @see dwt.events.ShellAdapter#shellClosed(dwt.events.ShellEvent)
     * @since 3.1
     */
    public void shellClosed(ShellEvent e) {
        if (fContentAssistant !is null)
            fContentAssistant.hide_package();
    }

    /*
     * @see dwt.widgets.Listener#handleEvent(dwt.widgets.Event)
     * @since 3.4
     */
    public void handleEvent(Event event) {
        switch (event.type) {
            case DWT.Activate:
            case DWT.MouseWheel:
                if (fAdditionalInfoController is null)
                    return;
                if (event.widget is fShell || event.widget is fTable || event.widget is fScrollbar)
                    return;

                if (fAdditionalInfoController.getInternalAccessor().getInformationControlReplacer() is null)
                    fAdditionalInfoController.hideInformationControl_package();
                else if (!fAdditionalInfoController.getInternalAccessor().isReplaceInProgress()) {
                    IInformationControl infoControl= fAdditionalInfoController.getCurrentInformationControl2();
                    // During isReplaceInProgress(), events can come from the replacing information control
                    if (cast(Control)event.widget && cast(IInformationControlExtension5)infoControl ) {
                        Control control= cast(Control) event.widget;
                        IInformationControlExtension5 iControl5= cast(IInformationControlExtension5) infoControl;
                        if (!(iControl5.containsControl(control)))
                            fAdditionalInfoController.hideInformationControl_package();
                        else if (event.type is DWT.MouseWheel)
                            fAdditionalInfoController.getInternalAccessor().replaceInformationControl(false);
                    } else if (infoControl !is null && infoControl.isFocusControl()) {
                        fAdditionalInfoController.getInternalAccessor().replaceInformationControl(true);
                    }
                }
                break;

            case DWT.MouseUp:
                if (fAdditionalInfoController is null || fAdditionalInfoController.getInternalAccessor().isReplaceInProgress())
                    break;
                if (cast(Control)event.widget) {
                    Control control= cast(Control) event.widget;
                    IInformationControl infoControl= fAdditionalInfoController.getCurrentInformationControl2();
                    if ( cast(IInformationControlExtension5)infoControl ) {
                        final IInformationControlExtension5 iControl5= cast(IInformationControlExtension5) infoControl;
                        if (iControl5.containsControl(control)) {
                            if ( cast(IDelayedInputChangeProvider)infoControl ) {
                                final IDelayedInputChangeProvider delayedICP= cast(IDelayedInputChangeProvider) infoControl;
                                final IInputChangedListener inputChangeListener= new DelayedInputChangeListener(delayedICP, fAdditionalInfoController.getInternalAccessor().getInformationControlReplacer());
                                delayedICP.setDelayedInputChangeListener(inputChangeListener);
                                // cancel automatic input updating after a small timeout:
                                control.getShell().getDisplay().timerExec(1000, new class()  Runnable {
                                    public void run() {
                                        delayedICP.setDelayedInputChangeListener(null);
                                    }
                                });
                            }

                            // XXX: workaround for https://bugs.eclipse.org/bugs/show_bug.cgi?id=212392 :
                            control.getShell().getDisplay().asyncExec(new class()  Runnable {
                                public void run() {
                                    fAdditionalInfoController.getInternalAccessor().replaceInformationControl(true);
                                }
                            });
                        }
                    }
                }
                break;

            case DWT.Deactivate:
                if (fAdditionalInfoController is null)
                    break;
                InformationControlReplacer replacer= fAdditionalInfoController.getInternalAccessor().getInformationControlReplacer();
                if (replacer !is null && fContentAssistant !is null) {
                    IInformationControl iControl= replacer.getCurrentInformationControl2();
                    if (cast(Control)event.widget  && cast(IInformationControlExtension5)iControl ) {
                        Control control= cast(Control) event.widget;
                        IInformationControlExtension5 iControl5= cast(IInformationControlExtension5) iControl;
                        if (iControl5.containsControl(control)) {
                            control.getDisplay().asyncExec(new class()  Runnable {
                                public void run() {
                                    if (fContentAssistant !is null && ! fContentAssistant.hasProposalPopupFocus())
                                        fContentAssistant.hide_package();
                                }
                            });
                        }
                    }
                }
                break;
            default:
        }
    }
}
