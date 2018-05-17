/*******************************************************************************
 * Copyright (c) 2000, 2007 IBM Corporation and others.
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
module examples.controlexample.DialogTab;



import dwt.DWT;
import dwt.events.SelectionAdapter;
import dwt.events.SelectionEvent;
import dwt.events.SelectionListener;
import dwt.graphics.FontData;
import dwt.graphics.RGB;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.printing.PrintDialog;
import dwt.printing.PrinterData;
import dwt.widgets.Button;
import dwt.widgets.ColorDialog;
import dwt.widgets.Combo;
import dwt.widgets.DirectoryDialog;
import dwt.widgets.FileDialog;
import dwt.widgets.FontDialog;
import dwt.widgets.Group;
import dwt.widgets.MessageBox;
import dwt.widgets.Text;
import dwt.widgets.Widget;

import examples.controlexample.Tab;
import examples.controlexample.ControlExample;
import tango.text.convert.Format;

class DialogTab : Tab {
    /* Example widgets and groups that contain them */
    Group dialogStyleGroup, resultGroup;
    Text textWidget;

    /* Style widgets added to the "Style" group */
    Combo dialogCombo;
    Button createButton;
    Button okButton, cancelButton;
    Button yesButton, noButton;
    Button retryButton;
    Button abortButton, ignoreButton;
    Button iconErrorButton, iconInformationButton, iconQuestionButton;
    Button iconWarningButton, iconWorkingButton, noIconButton;
    Button primaryModalButton, applicationModalButton, systemModalButton;
    Button saveButton, openButton, multiButton;

    static const char[] [] FilterExtensions   = ["*.txt", "*.bat", "*.doc", "*"];
    static char[] [] FilterNames;

    /**
     * Creates the Tab within a given instance of ControlExample.
     */
    this(ControlExample instance) {
        super(instance);
        if( FilterNames.length is 0 ){
            FilterNames = [ ControlExample.getResourceString("FilterName_0"),
                            ControlExample.getResourceString("FilterName_1"),
                            ControlExample.getResourceString("FilterName_2"),
                            ControlExample.getResourceString("FilterName_3")];
        }
    }

    /**
     * Handle a button style selection event.
     *
     * @param event the selection event
     */
    void buttonStyleSelected(SelectionEvent event) {
        /*
         * Only certain combinations of button styles are
         * supported for various dialogs.  Make sure the
         * control widget reflects only valid combinations.
         */
        bool ok = okButton.getSelection ();
        bool cancel = cancelButton.getSelection ();
        bool yes = yesButton.getSelection ();
        bool no = noButton.getSelection ();
        bool abort = abortButton.getSelection ();
        bool retry = retryButton.getSelection ();
        bool ignore = ignoreButton.getSelection ();

        okButton.setEnabled (!(yes || no || retry || abort || ignore));
        cancelButton.setEnabled (!(abort || ignore || (yes !is no)));
        yesButton.setEnabled (!(ok || retry || abort || ignore || (cancel && !yes && !no)));
        noButton.setEnabled (!(ok || retry || abort || ignore || (cancel && !yes && !no)));
        retryButton.setEnabled (!(ok || yes || no));
        abortButton.setEnabled (!(ok || cancel || yes || no));
        ignoreButton.setEnabled (!(ok || cancel || yes || no));

        createButton.setEnabled (
                !(ok || cancel || yes || no || retry || abort || ignore) ||
                ok ||
                (ok && cancel) ||
                (yes && no) ||
                (yes && no && cancel) ||
                (retry && cancel) ||
                (abort && retry && ignore));


    }

    /**
     * Handle the create button selection event.
     *
     * @param event org.eclipse.swt.events.SelectionEvent
     */
    void createButtonSelected(SelectionEvent event) {

        /* Compute the appropriate dialog style */
        int style = getDefaultStyle();
        if (okButton.getEnabled () && okButton.getSelection ()) style |= DWT.OK;
        if (cancelButton.getEnabled () && cancelButton.getSelection ()) style |= DWT.CANCEL;
        if (yesButton.getEnabled () && yesButton.getSelection ()) style |= DWT.YES;
        if (noButton.getEnabled () && noButton.getSelection ()) style |= DWT.NO;
        if (retryButton.getEnabled () && retryButton.getSelection ()) style |= DWT.RETRY;
        if (abortButton.getEnabled () && abortButton.getSelection ()) style |= DWT.ABORT;
        if (ignoreButton.getEnabled () && ignoreButton.getSelection ()) style |= DWT.IGNORE;
        if (iconErrorButton.getEnabled () && iconErrorButton.getSelection ()) style |= DWT.ICON_ERROR;
        if (iconInformationButton.getEnabled () && iconInformationButton.getSelection ()) style |= DWT.ICON_INFORMATION;
        if (iconQuestionButton.getEnabled () && iconQuestionButton.getSelection ()) style |= DWT.ICON_QUESTION;
        if (iconWarningButton.getEnabled () && iconWarningButton.getSelection ()) style |= DWT.ICON_WARNING;
        if (iconWorkingButton.getEnabled () && iconWorkingButton.getSelection ()) style |= DWT.ICON_WORKING;
        if (primaryModalButton.getEnabled () && primaryModalButton.getSelection ()) style |= DWT.PRIMARY_MODAL;
        if (applicationModalButton.getEnabled () && applicationModalButton.getSelection ()) style |= DWT.APPLICATION_MODAL;
        if (systemModalButton.getEnabled () && systemModalButton.getSelection ()) style |= DWT.SYSTEM_MODAL;
        if (saveButton.getEnabled () && saveButton.getSelection ()) style |= DWT.SAVE;
        if (openButton.getEnabled () && openButton.getSelection ()) style |= DWT.OPEN;
        if (multiButton.getEnabled () && multiButton.getSelection ()) style |= DWT.MULTI;

        /* Open the appropriate dialog type */
        char[] name = dialogCombo.getText ();

        if (name == ControlExample.getResourceString("ColorDialog")) {
            ColorDialog dialog = new ColorDialog (shell ,style);
            dialog.setRGB (new RGB (100, 100, 100));
            dialog.setText (ControlExample.getResourceString("Title"));
            RGB result = dialog.open ();
            textWidget.append (Format( ControlExample.getResourceString("ColorDialog")~"{}", Text.DELIMITER));
            textWidget.append (Format( ControlExample.getResourceString("Result")~"{}{}", result, Text.DELIMITER, Text.DELIMITER));
            return;
        }

        if (name == ControlExample.getResourceString("DirectoryDialog")) {
            DirectoryDialog dialog = new DirectoryDialog (shell, style);
            dialog.setMessage (ControlExample.getResourceString("Example_string"));
            dialog.setText (ControlExample.getResourceString("Title"));
            char[] result = dialog.open ();
            textWidget.append (ControlExample.getResourceString("DirectoryDialog") ~ Text.DELIMITER);
            textWidget.append (Format( ControlExample.getResourceString("Result"), result ) ~ Text.DELIMITER ~ Text.DELIMITER);
            return;
        }

        if (name== ControlExample.getResourceString("FileDialog")) {
            FileDialog dialog = new FileDialog (shell, style);
            dialog.setFileName (ControlExample.getResourceString("readme_txt"));
            dialog.setFilterNames (FilterNames);
            dialog.setFilterExtensions (FilterExtensions);
            dialog.setText (ControlExample.getResourceString("Title"));
            char[] result = dialog.open();
            textWidget.append (ControlExample.getResourceString("FileDialog") ~ Text.DELIMITER);
            textWidget.append (Format( ControlExample.getResourceString("Result"), result ) ~ Text.DELIMITER);
            if ((dialog.getStyle () & DWT.MULTI) !is 0) {
                char[] [] files = dialog.getFileNames ();
                for (int i=0; i<files.length; i++) {
                    textWidget.append ("\t" ~ files [i] ~ Text.DELIMITER);
                }
            }
            textWidget.append (Text.DELIMITER);
            return;
        }

        if (name == ControlExample.getResourceString("FontDialog")) {
            FontDialog dialog = new FontDialog (shell, style);
            dialog.setText (ControlExample.getResourceString("Title"));
            FontData result = dialog.open ();
            textWidget.append (ControlExample.getResourceString("FontDialog") ~ Text.DELIMITER);
            textWidget.append (Format( ControlExample.getResourceString("Result"), result ) ~ Text.DELIMITER ~ Text.DELIMITER);
            return;
        }

        if (name == ControlExample.getResourceString("PrintDialog")) {
            PrintDialog dialog = new PrintDialog (shell, style);
            dialog.setText(ControlExample.getResourceString("Title"));
            PrinterData result = dialog.open ();
            textWidget.append (ControlExample.getResourceString("PrintDialog") ~ Text.DELIMITER);
            textWidget.append (Format( ControlExample.getResourceString("Result"), result ) ~ Text.DELIMITER ~ Text.DELIMITER);
            return;
        }

        if (name == ControlExample.getResourceString("MessageBox")) {
            MessageBox dialog = new MessageBox (shell, style);
            dialog.setMessage (ControlExample.getResourceString("Example_string"));
            dialog.setText (ControlExample.getResourceString("Title"));
            int result = dialog.open ();
            textWidget.append (ControlExample.getResourceString("MessageBox") ~ Text.DELIMITER);
            /*
             * The resulting integer depends on the original
             * dialog style.  Decode the result and display it.
             */
            switch (result) {
                case DWT.OK:
                    textWidget.append (Format( ControlExample.getResourceString("Result"), "DWT.OK"));
                    break;
                case DWT.YES:
                    textWidget.append (Format( ControlExample.getResourceString("Result"), "DWT.YES"));
                    break;
                case DWT.NO:
                    textWidget.append (Format( ControlExample.getResourceString("Result"), "DWT.NO"));
                    break;
                case DWT.CANCEL:
                    textWidget.append (Format( ControlExample.getResourceString("Result"), "DWT.CANCEL"));
                    break;
                case DWT.ABORT:
                    textWidget.append (Format( ControlExample.getResourceString("Result"), "DWT.ABORT"));
                    break;
                case DWT.RETRY:
                    textWidget.append (Format( ControlExample.getResourceString("Result"), "DWT.RETRY"));
                    break;
                case DWT.IGNORE:
                    textWidget.append (Format( ControlExample.getResourceString("Result"), "DWT.IGNORE"));
                    break;
                default:
                    textWidget.append(Format( ControlExample.getResourceString("Result"), result));
                    break;
            }
            textWidget.append (Text.DELIMITER ~ Text.DELIMITER);
        }
    }

    /**
     * Creates the "Control" group.
     */
    void createControlGroup () {
        /*
         * Create the "Control" group.  This is the group on the
         * right half of each example tab.  It consists of the
         * style group, the display group and the size group.
         */
        controlGroup = new Group (tabFolderPage, DWT.NONE);
        GridLayout gridLayout= new GridLayout ();
        controlGroup.setLayout(gridLayout);
        gridLayout.numColumns = 2;
        gridLayout.makeColumnsEqualWidth = true;
        controlGroup.setLayoutData (new GridData (GridData.HORIZONTAL_ALIGN_FILL | GridData.VERTICAL_ALIGN_FILL));
        controlGroup.setText (ControlExample.getResourceString("Parameters"));

        /*
         * Create a group to hold the dialog style combo box and
         * create dialog button.
         */
        dialogStyleGroup = new Group (controlGroup, DWT.NONE);
        dialogStyleGroup.setLayout (new GridLayout ());
        GridData gridData = new GridData (GridData.HORIZONTAL_ALIGN_CENTER);
        gridData.horizontalSpan = 2;
        dialogStyleGroup.setLayoutData (gridData);
        dialogStyleGroup.setText (ControlExample.getResourceString("Dialog_Type"));
    }

    /**
     * Creates the "Control" widget children.
     */
    void createControlWidgets () {

        /* Create the combo */
        char[] [] strings = [
            ControlExample.getResourceString("ColorDialog"),
            ControlExample.getResourceString("DirectoryDialog"),
            ControlExample.getResourceString("FileDialog"),
            ControlExample.getResourceString("FontDialog"),
            ControlExample.getResourceString("PrintDialog"),
            ControlExample.getResourceString("MessageBox"),
        ];
        dialogCombo = new Combo (dialogStyleGroup, DWT.READ_ONLY);
        dialogCombo.setItems (strings);
        dialogCombo.setText (strings [0]);
        dialogCombo.setVisibleItemCount(strings.length);

        /* Create the create dialog button */
        createButton = new Button(dialogStyleGroup, DWT.NONE);
        createButton.setText (ControlExample.getResourceString("Create_Dialog"));
        createButton.setLayoutData (new GridData(GridData.HORIZONTAL_ALIGN_CENTER));

        /* Create a group for the various dialog button style controls */
        Group buttonStyleGroup = new Group (controlGroup, DWT.NONE);
        buttonStyleGroup.setLayout (new GridLayout ());
        buttonStyleGroup.setLayoutData (new GridData (GridData.HORIZONTAL_ALIGN_FILL | GridData.VERTICAL_ALIGN_FILL));
        buttonStyleGroup.setText (ControlExample.getResourceString("Button_Styles"));

        /* Create the button style buttons */
        okButton = new Button (buttonStyleGroup, DWT.CHECK);
        okButton.setText ("DWT.OK");
        cancelButton = new Button (buttonStyleGroup, DWT.CHECK);
        cancelButton.setText ("DWT.CANCEL");
        yesButton = new Button (buttonStyleGroup, DWT.CHECK);
        yesButton.setText ("DWT.YES");
        noButton = new Button (buttonStyleGroup, DWT.CHECK);
        noButton.setText ("DWT.NO");
        retryButton = new Button (buttonStyleGroup, DWT.CHECK);
        retryButton.setText ("DWT.RETRY");
        abortButton = new Button (buttonStyleGroup, DWT.CHECK);
        abortButton.setText ("DWT.ABORT");
        ignoreButton = new Button (buttonStyleGroup, DWT.CHECK);
        ignoreButton.setText ("DWT.IGNORE");

        /* Create a group for the icon style controls */
        Group iconStyleGroup = new Group (controlGroup, DWT.NONE);
        iconStyleGroup.setLayout (new GridLayout ());
        iconStyleGroup.setLayoutData (new GridData (GridData.HORIZONTAL_ALIGN_FILL | GridData.VERTICAL_ALIGN_FILL));
        iconStyleGroup.setText (ControlExample.getResourceString("Icon_Styles"));

        /* Create the icon style buttons */
        iconErrorButton = new Button (iconStyleGroup, DWT.RADIO);
        iconErrorButton.setText ("DWT.ICON_ERROR");
        iconInformationButton = new Button (iconStyleGroup, DWT.RADIO);
        iconInformationButton.setText ("DWT.ICON_INFORMATION");
        iconQuestionButton = new Button (iconStyleGroup, DWT.RADIO);
        iconQuestionButton.setText ("DWT.ICON_QUESTION");
        iconWarningButton = new Button (iconStyleGroup, DWT.RADIO);
        iconWarningButton.setText ("DWT.ICON_WARNING");
        iconWorkingButton = new Button (iconStyleGroup, DWT.RADIO);
        iconWorkingButton.setText ("DWT.ICON_WORKING");
        noIconButton = new Button (iconStyleGroup, DWT.RADIO);
        noIconButton.setText (ControlExample.getResourceString("No_Icon"));

        /* Create a group for the modal style controls */
        Group modalStyleGroup = new Group (controlGroup, DWT.NONE);
        modalStyleGroup.setLayout (new GridLayout ());
        modalStyleGroup.setLayoutData (new GridData (GridData.HORIZONTAL_ALIGN_FILL | GridData.VERTICAL_ALIGN_FILL));
        modalStyleGroup.setText (ControlExample.getResourceString("Modal_Styles"));

        /* Create the modal style buttons */
        primaryModalButton = new Button (modalStyleGroup, DWT.RADIO);
        primaryModalButton.setText ("DWT.PRIMARY_MODAL");
        applicationModalButton = new Button (modalStyleGroup, DWT.RADIO);
        applicationModalButton.setText ("DWT.APPLICATION_MODAL");
        systemModalButton = new Button (modalStyleGroup, DWT.RADIO);
        systemModalButton.setText ("DWT.SYSTEM_MODAL");

        /* Create a group for the file dialog style controls */
        Group fileDialogStyleGroup = new Group (controlGroup, DWT.NONE);
        fileDialogStyleGroup.setLayout (new GridLayout ());
        fileDialogStyleGroup.setLayoutData (new GridData (GridData.HORIZONTAL_ALIGN_FILL | GridData.VERTICAL_ALIGN_FILL));
        fileDialogStyleGroup.setText (ControlExample.getResourceString("File_Dialog_Styles"));

        /* Create the file dialog style buttons */
        openButton = new Button(fileDialogStyleGroup, DWT.RADIO);
        openButton.setText("DWT.OPEN");
        saveButton = new Button (fileDialogStyleGroup, DWT.RADIO);
        saveButton.setText ("DWT.SAVE");
        multiButton = new Button(fileDialogStyleGroup, DWT.CHECK);
        multiButton.setText("DWT.MULTI");

        /* Create the orientation group */
        if (RTL_SUPPORT_ENABLE) {
            createOrientationGroup();
        }

        /* Add the listeners */
        dialogCombo.addSelectionListener (new class() SelectionAdapter {
            public void widgetSelected (SelectionEvent event) {
                dialogSelected (event);
            }
        });
        createButton.addSelectionListener (new class() SelectionAdapter {
            public void widgetSelected (SelectionEvent event) {
                createButtonSelected (event);
            }
        });
        SelectionListener buttonStyleListener = new class() SelectionAdapter {
            public void widgetSelected (SelectionEvent event) {
                buttonStyleSelected (event);
            }
        };
        okButton.addSelectionListener (buttonStyleListener);
        cancelButton.addSelectionListener (buttonStyleListener);
        yesButton.addSelectionListener (buttonStyleListener);
        noButton.addSelectionListener (buttonStyleListener);
        retryButton.addSelectionListener (buttonStyleListener);
        abortButton.addSelectionListener (buttonStyleListener);
        ignoreButton.addSelectionListener (buttonStyleListener);

        /* Set default values for style buttons */
        okButton.setEnabled (false);
        cancelButton.setEnabled (false);
        yesButton.setEnabled (false);
        noButton.setEnabled (false);
        retryButton.setEnabled (false);
        abortButton.setEnabled (false);
        ignoreButton.setEnabled (false);
        iconErrorButton.setEnabled (false);
        iconInformationButton.setEnabled (false);
        iconQuestionButton.setEnabled (false);
        iconWarningButton.setEnabled (false);
        iconWorkingButton.setEnabled (false);
        noIconButton.setEnabled (false);
        saveButton.setEnabled (false);
        openButton.setEnabled (false);
        openButton.setSelection (true);
        multiButton.setEnabled (false);
        noIconButton.setSelection (true);
    }

    /**
     * Creates the "Example" group.
     */
    void createExampleGroup () {
        super.createExampleGroup ();
        exampleGroup.setLayoutData (new GridData (DWT.FILL, DWT.FILL, true, true));

        /*
         * Create a group for the text widget to display
         * the results returned by the example dialogs.
         */
        resultGroup = new Group (exampleGroup, DWT.NONE);
        resultGroup.setLayout (new GridLayout ());
        resultGroup.setLayoutData (new GridData (DWT.FILL, DWT.FILL, true, true));
        resultGroup.setText (ControlExample.getResourceString("Dialog_Result"));
    }

    /**
     * Creates the "Example" widgets.
     */
    void createExampleWidgets () {
        /*
         * Create a multi lined, scrolled text widget for output.
         */
        textWidget = new Text(resultGroup, DWT.H_SCROLL | DWT.V_SCROLL | DWT.BORDER);
        GridData gridData = new GridData (GridData.FILL_BOTH);
        textWidget.setLayoutData (gridData);
    }

    /**
     * The platform dialogs do not have DWT listeners.
     */
    void createListenersGroup () {
    }

    /**
     * Handle a dialog type combo selection event.
     *
     * @param event the selection event
     */
    void dialogSelected (SelectionEvent event) {

        /* Enable/Disable the buttons */
        char[] name = dialogCombo.getText ();
        bool isMessageBox = ( name == ControlExample.getResourceString("MessageBox"));
        bool isFileDialog = ( name == ControlExample.getResourceString("FileDialog"));
        okButton.setEnabled (isMessageBox);
        cancelButton.setEnabled (isMessageBox);
        yesButton.setEnabled (isMessageBox);
        noButton.setEnabled (isMessageBox);
        retryButton.setEnabled (isMessageBox);
        abortButton.setEnabled (isMessageBox);
        ignoreButton.setEnabled (isMessageBox);
        iconErrorButton.setEnabled (isMessageBox);
        iconInformationButton.setEnabled (isMessageBox);
        iconQuestionButton.setEnabled (isMessageBox);
        iconWarningButton.setEnabled (isMessageBox);
        iconWorkingButton.setEnabled (isMessageBox);
        noIconButton.setEnabled (isMessageBox);
        saveButton.setEnabled (isFileDialog);
        openButton.setEnabled (isFileDialog);
        multiButton.setEnabled (isFileDialog);

        /* Unselect the buttons */
        if (!isMessageBox) {
            okButton.setSelection (false);
            cancelButton.setSelection (false);
            yesButton.setSelection (false);
            noButton.setSelection (false);
            retryButton.setSelection (false);
            abortButton.setSelection (false);
            ignoreButton.setSelection (false);
        }
    }

    /**
     * Gets the "Example" widget children.
     */
    Widget [] getExampleWidgets () {
        return null;
    }

    /**
     * Gets the text for the tab folder item.
     */
    char[] getTabText () {
        return "Dialog";
    }

    /**
     * Recreates the "Example" widgets.
     */
    void recreateExampleWidgets () {
        if (textWidget is null) {
            super.recreateExampleWidgets ();
        }
    }
}
