/*******************************************************************************
 * Copyright (c) 2000, 2006 IBM Corporation and others.
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
module examples.controlexample.ShellTab;



import dwt.DWT;
import dwt.events.SelectionAdapter;
import dwt.events.SelectionEvent;
import dwt.events.SelectionListener;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Button;
import dwt.widgets.Event;
import dwt.widgets.Group;
import dwt.widgets.Listener;
import dwt.widgets.Shell;

import examples.controlexample.Tab;
import examples.controlexample.ControlExample;

import dwt.dwthelper.utils;

import tango.util.Convert;

class ShellTab : Tab {
    /* Style widgets added to the "Style" groups, and "Other" group */
    Button noParentButton, parentButton;
    Button noTrimButton, closeButton, titleButton, minButton, maxButton, borderButton, resizeButton, onTopButton, toolButton;
    Button createButton, closeAllButton;
    Button modelessButton, primaryModalButton, applicationModalButton, systemModalButton;
    Button imageButton;
    Group parentStyleGroup, modalStyleGroup;

    /* Variables used to track the open shells */
    int shellCount = 0;
    Shell [] shells;

    /**
     * Creates the Tab within a given instance of ControlExample.
     */
    this(ControlExample instance) {
        super(instance);
    }

    /**
     * Close all the example shells.
     */
    void closeAllShells() {
        for (int i = 0; i<shellCount; i++) {
            if (shells[i] !is null & !shells [i].isDisposed ()) {
                shells [i].dispose();
            }
        }
        shellCount = 0;
    }

    /**
     * Handle the Create button selection event.
     *
     * @param event org.eclipse.swt.events.SelectionEvent
     */
    public void createButtonSelected(SelectionEvent event) {

        /*
         * Remember the example shells so they
         * can be disposed by the user.
         */
        if (shellCount >= shells.length) {
            Shell [] newShells = new Shell [shells.length + 4];
            System.arraycopy (shells, 0, newShells, 0, shells.length);
            shells = newShells;
        }

        /* Compute the shell style */
        int style = DWT.NONE;
        if (noTrimButton.getSelection()) style |= DWT.NO_TRIM;
        if (closeButton.getSelection()) style |= DWT.CLOSE;
        if (titleButton.getSelection()) style |= DWT.TITLE;
        if (minButton.getSelection()) style |= DWT.MIN;
        if (maxButton.getSelection()) style |= DWT.MAX;
        if (borderButton.getSelection()) style |= DWT.BORDER;
        if (resizeButton.getSelection()) style |= DWT.RESIZE;
        if (onTopButton.getSelection()) style |= DWT.ON_TOP;
        if (toolButton.getSelection()) style |= DWT.TOOL;
        if (modelessButton.getSelection()) style |= DWT.MODELESS;
        if (primaryModalButton.getSelection()) style |= DWT.PRIMARY_MODAL;
        if (applicationModalButton.getSelection()) style |= DWT.APPLICATION_MODAL;
        if (systemModalButton.getSelection()) style |= DWT.SYSTEM_MODAL;

        /* Create the shell with or without a parent */
        if (noParentButton.getSelection ()) {
            shells [shellCount] = new Shell (style);
        } else {
            shells [shellCount] = new Shell (shell, style);
        }
        Shell currentShell = shells [shellCount];
        Button button = new Button(currentShell, DWT.PUSH);
        button.setBounds(20, 20, 120, 30);
        Button closeButton = new Button(currentShell, DWT.PUSH);
        closeButton.setBounds(160, 20, 120, 30);
        closeButton.setText(ControlExample.getResourceString("Close"));
        closeButton.addListener(DWT.Selection, new class(currentShell) Listener {
            Shell s;
            this( Shell s ){ this.s = s; }
            public void handleEvent(Event event) {
                s.dispose();
            }
        });

        /* Set the size, title, and image, and open the shell */
        currentShell.setSize (300, 100);
        currentShell.setText (ControlExample.getResourceString("Title") ~ to!(char[])(shellCount));
        if (imageButton.getSelection()) currentShell.setImage(instance.images[ControlExample.ciTarget]);
        if (backgroundImageButton.getSelection()) currentShell.setBackgroundImage(instance.images[ControlExample.ciBackground]);
        hookListeners (currentShell);
        currentShell.open ();
        shellCount++;
    }

    /**
     * Creates the "Control" group.
     */
    void createControlGroup () {
        /*
         * Create the "Control" group.  This is the group on the
         * right half of each example tab.  It consists of the
         * style group, the 'other' group and the size group.
         */
        controlGroup = new Group (tabFolderPage, DWT.NONE);
        controlGroup.setLayout (new GridLayout (2, true));
        controlGroup.setLayoutData (new GridData (GridData.HORIZONTAL_ALIGN_FILL | GridData.VERTICAL_ALIGN_FILL));
        controlGroup.setText (ControlExample.getResourceString("Parameters"));

        /* Create a group for the decoration style controls */
        styleGroup = new Group (controlGroup, DWT.NONE);
        styleGroup.setLayout (new GridLayout ());
        styleGroup.setLayoutData (new GridData (DWT.FILL, DWT.FILL, false, false, 1, 3));
        styleGroup.setText (ControlExample.getResourceString("Decoration_Styles"));

        /* Create a group for the modal style controls */
        modalStyleGroup = new Group (controlGroup, DWT.NONE);
        modalStyleGroup.setLayout (new GridLayout ());
        modalStyleGroup.setLayoutData (new GridData(GridData.HORIZONTAL_ALIGN_FILL | GridData.VERTICAL_ALIGN_FILL));
        modalStyleGroup.setText (ControlExample.getResourceString("Modal_Styles"));

        /* Create a group for the 'other' controls */
        otherGroup = new Group (controlGroup, DWT.NONE);
        otherGroup.setLayout (new GridLayout ());
        otherGroup.setLayoutData (new GridData(DWT.FILL, DWT.FILL, false, false));
        otherGroup.setText (ControlExample.getResourceString("Other"));

        /* Create a group for the parent style controls */
        parentStyleGroup = new Group (controlGroup, DWT.NONE);
        parentStyleGroup.setLayout (new GridLayout ());
        GridData gridData = new GridData(GridData.HORIZONTAL_ALIGN_FILL);
        parentStyleGroup.setLayoutData (gridData);
        parentStyleGroup.setText (ControlExample.getResourceString("Parent"));
    }

    /**
     * Creates the "Control" widget children.
     */
    void createControlWidgets () {

        /* Create the parent style buttons */
        noParentButton = new Button (parentStyleGroup, DWT.RADIO);
        noParentButton.setText (ControlExample.getResourceString("No_Parent"));
        parentButton = new Button (parentStyleGroup, DWT.RADIO);
        parentButton.setText (ControlExample.getResourceString("Parent"));

        /* Create the decoration style buttons */
        noTrimButton = new Button (styleGroup, DWT.CHECK);
        noTrimButton.setText ("DWT.NO_TRIM");
        closeButton = new Button (styleGroup, DWT.CHECK);
        closeButton.setText ("DWT.CLOSE");
        titleButton = new Button (styleGroup, DWT.CHECK);
        titleButton.setText ("DWT.TITLE");
        minButton = new Button (styleGroup, DWT.CHECK);
        minButton.setText ("DWT.MIN");
        maxButton = new Button (styleGroup, DWT.CHECK);
        maxButton.setText ("DWT.MAX");
        borderButton = new Button (styleGroup, DWT.CHECK);
        borderButton.setText ("DWT.BORDER");
        resizeButton = new Button (styleGroup, DWT.CHECK);
        resizeButton.setText ("DWT.RESIZE");
        onTopButton = new Button (styleGroup, DWT.CHECK);
        onTopButton.setText ("DWT.ON_TOP");
        toolButton = new Button (styleGroup, DWT.CHECK);
        toolButton.setText ("DWT.TOOL");

        /* Create the modal style buttons */
        modelessButton = new Button (modalStyleGroup, DWT.RADIO);
        modelessButton.setText ("DWT.MODELESS");
        primaryModalButton = new Button (modalStyleGroup, DWT.RADIO);
        primaryModalButton.setText ("DWT.PRIMARY_MODAL");
        applicationModalButton = new Button (modalStyleGroup, DWT.RADIO);
        applicationModalButton.setText ("DWT.APPLICATION_MODAL");
        systemModalButton = new Button (modalStyleGroup, DWT.RADIO);
        systemModalButton.setText ("DWT.SYSTEM_MODAL");

        /* Create the 'other' buttons */
        imageButton = new Button (otherGroup, DWT.CHECK);
        imageButton.setText (ControlExample.getResourceString("Image"));
        backgroundImageButton = new Button(otherGroup, DWT.CHECK);
        backgroundImageButton.setText(ControlExample.getResourceString("BackgroundImage"));

        /* Create the "create" and "closeAll" buttons */
        createButton = new Button (controlGroup, DWT.NONE);
        GridData gridData = new GridData (GridData.HORIZONTAL_ALIGN_END);
        createButton.setLayoutData (gridData);
        createButton.setText (ControlExample.getResourceString("Create_Shell"));
        closeAllButton = new Button (controlGroup, DWT.NONE);
        gridData = new GridData (GridData.HORIZONTAL_ALIGN_BEGINNING);
        closeAllButton.setText (ControlExample.getResourceString("Close_All_Shells"));
        closeAllButton.setLayoutData (gridData);

        /* Add the listeners */
        createButton.addSelectionListener(new class() SelectionAdapter {
            public void widgetSelected(SelectionEvent e) {
                createButtonSelected(e);
            }
        });
        closeAllButton.addSelectionListener(new class() SelectionAdapter {
            public void widgetSelected(SelectionEvent e) {
                closeAllShells ();
            }
        });
        SelectionListener decorationButtonListener = new class() SelectionAdapter {
            public void widgetSelected(SelectionEvent event) {
                decorationButtonSelected(event);
            }
        };
        noTrimButton.addSelectionListener (decorationButtonListener);
        closeButton.addSelectionListener (decorationButtonListener);
        titleButton.addSelectionListener (decorationButtonListener);
        minButton.addSelectionListener (decorationButtonListener);
        maxButton.addSelectionListener (decorationButtonListener);
        borderButton.addSelectionListener (decorationButtonListener);
        resizeButton.addSelectionListener (decorationButtonListener);
        applicationModalButton.addSelectionListener (decorationButtonListener);
        systemModalButton.addSelectionListener (decorationButtonListener);

        /* Set the default state */
        noParentButton.setSelection (true);
        modelessButton.setSelection (true);
        backgroundImageButton.setSelection(false);
    }

    /**
     * Handle a decoration button selection event.
     *
     * @param event org.eclipse.swt.events.SelectionEvent
     */
    public void decorationButtonSelected(SelectionEvent event) {

        /* Make sure if the modal style is DWT.APPLICATION_MODAL or
         * DWT.SYSTEM_MODAL the style DWT.CLOSE is also selected.
         * This is to make sure the user can close the shell.
         */
        Button widget = cast(Button) event.widget;
        if (widget is applicationModalButton || widget is systemModalButton) {
            if (widget.getSelection()) {
                closeButton.setSelection (true);
                noTrimButton.setSelection (false);
            }
            return;
        }
        if (widget is closeButton) {
            if (applicationModalButton.getSelection() || systemModalButton.getSelection()) {
                closeButton.setSelection (true);
            }
        }
        /*
         * Make sure if the No Trim button is selected then
         * all other decoration buttons are deselected.
         */
        if (widget.getSelection() && widget !is noTrimButton) {
            noTrimButton.setSelection (false);
            return;
        }
        if (widget.getSelection() && widget is noTrimButton) {
            if (applicationModalButton.getSelection() || systemModalButton.getSelection()) {
                noTrimButton.setSelection (false);
                return;
            }
            closeButton.setSelection (false);
            titleButton.setSelection (false);
            minButton.setSelection (false);
            maxButton.setSelection (false);
            borderButton.setSelection (false);
            resizeButton.setSelection (false);
            return;
        }
    }

    /**
     * Gets the text for the tab folder item.
     */
    char[] getTabText () {
        return "Shell";
    }
}
