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
module dwtx.jface.dialogs.StatusDialog;

import dwtx.jface.dialogs.Dialog;
import dwtx.jface.dialogs.TrayDialog;
import dwtx.jface.dialogs.IDialogConstants;

import dwt.DWT;
import dwt.custom.CLabel;
import dwt.graphics.Color;
import dwt.graphics.Image;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Button;
import dwt.widgets.Composite;
import dwt.widgets.Control;
import dwt.widgets.Shell;
import dwtx.core.runtime.IStatus;
import dwtx.core.runtime.Status;
import dwtx.jface.resource.JFaceColors;
import dwtx.jface.resource.JFaceResources;
import dwtx.jface.util.Policy;
import dwtx.jface.util.Util;

import dwt.dwthelper.utils;

/**
 * An abstract base class for dialogs with a status bar and OK/CANCEL buttons.
 * The status message is specified in an IStatus which can be of severity ERROR,
 * WARNING, INFO or OK. The OK button is enabled or disabled depending on the
 * status.
 *
 * @since 3.1
 */
public abstract class StatusDialog : TrayDialog {

    private Button fOkButton;

    private MessageLine fStatusLine;

    private IStatus fLastStatus;

    private String fTitle;

    private Image fImage;

    private bool fStatusLineAboveButtons = true;

    /**
     * A message line displaying a status.
     */
    private class MessageLine : CLabel {

        private Color fNormalMsgAreaBackground;

        /**
         * Creates a new message line as a child of the given parent.
         *
         * @param parent
         */
        public this(Composite parent) {
            this(parent, DWT.LEFT);
        }

        /**
         * Creates a new message line as a child of the parent and with the
         * given DWT stylebits.
         *
         * @param parent
         * @param style
         */
        public this(Composite parent, int style) {
            super(parent, style);
            fNormalMsgAreaBackground = getBackground();
        }

        /**
         * Find an image assocated with the status.
         *
         * @param status
         * @return Image
         */
        private Image findImage(IStatus status) {
            if (status.isOK()) {
                return null;
            } else if (status.matches(IStatus.ERROR)) {
                return JFaceResources.getImage(Dialog.DLG_IMG_MESSAGE_ERROR);
            } else if (status.matches(IStatus.WARNING)) {
                return JFaceResources.getImage(Dialog.DLG_IMG_MESSAGE_WARNING);
            } else if (status.matches(IStatus.INFO)) {
                return JFaceResources.getImage(Dialog.DLG_IMG_MESSAGE_INFO);
            }
            return null;
        }

        /**
         * Sets the message and image to the given status.
         *
         * @param status
         *            IStatus or <code>null</code>. <code>null</code> will
         *            set the empty text and no image.
         */
        public void setErrorStatus(IStatus status) {
            if (status !is null && !status.isOK()) {
                String message = status.getMessage();
                if (message !is null && message.length > 0) {
                    setText(message);
                    // unqualified call of setImage is too ambiguous for
                    // Foundation 1.0 compiler
                    // see https://bugs.eclipse.org/bugs/show_bug.cgi?id=140576
                    this.outer.setImage(findImage(status));
                    setBackground(JFaceColors.getErrorBackground(getDisplay()));
                    return;
                }
            }
            setText(""); //$NON-NLS-1$
            // unqualified call of setImage is too ambiguous for Foundation 1.0
            // compiler
            // see https://bugs.eclipse.org/bugs/show_bug.cgi?id=140576
            this.outer.setImage(null);
            setBackground(fNormalMsgAreaBackground);
        }
    }

    /**
     * Creates an instance of a status dialog.
     *
     * @param parent
     *            the parent Shell of the dialog
     */
    public this(Shell parent) {
        super(parent);
        fLastStatus = new Status(IStatus.OK, Policy.JFACE, IStatus.OK,
                Util.ZERO_LENGTH_STRING, null);
    }

    /**
     * Specifies whether status line appears to the left of the buttons
     * (default) or above them.
     *
     * @param aboveButtons
     *            if <code>true</code> status line is placed above buttons; if
     *            <code>false</code> to the right
     */
    public void setStatusLineAboveButtons(bool aboveButtons) {
        fStatusLineAboveButtons = aboveButtons;
    }

    /**
     * Update the dialog's status line to reflect the given status. It is safe
     * to call this method before the dialog has been opened.
     *
     * @param status
     *            the status to set
     */
    protected void updateStatus(IStatus status) {
        fLastStatus = status;
        if (fStatusLine !is null && !fStatusLine.isDisposed()) {
            updateButtonsEnableState(status);
            fStatusLine.setErrorStatus(status);
        }
    }

    /**
     * Returns the last status.
     *
     * @return IStatus
     */
    public IStatus getStatus() {
        return fLastStatus;
    }

    /**
     * Updates the status of the ok button to reflect the given status.
     * Subclasses may override this method to update additional buttons.
     *
     * @param status
     *            the status.
     */
    protected void updateButtonsEnableState(IStatus status) {
        if (fOkButton !is null && !fOkButton.isDisposed()) {
            fOkButton.setEnabled(!status.matches(IStatus.ERROR));
        }
    }

    /*
     * @see Window#create(Shell)
     */
    protected override void configureShell(Shell shell) {
        super.configureShell(shell);
        if (fTitle !is null) {
            shell.setText(fTitle);
        }
    }

    /*
     * @see Window#create()
     */
    public override void create() {
        super.create();
        if (fLastStatus !is null) {
            // policy: dialogs are not allowed to come up with an error message
            if (fLastStatus.matches(IStatus.ERROR)) {
                // remove the message
                fLastStatus = new Status(IStatus.ERROR,
                        fLastStatus.getPlugin(), fLastStatus.getCode(),
                        "", fLastStatus.getException()); //$NON-NLS-1$
            }
            updateStatus(fLastStatus);
        }
    }

    /*
     * @see Dialog#createButtonsForButtonBar(Composite)
     */
    protected override void createButtonsForButtonBar(Composite parent) {
        fOkButton = createButton(parent, IDialogConstants.OK_ID,
                IDialogConstants.OK_LABEL, true);
        createButton(parent, IDialogConstants.CANCEL_ID,
                IDialogConstants.CANCEL_LABEL, false);
    }

    /*
     * @see Dialog#createButtonBar(Composite)
     */
    protected override Control createButtonBar(Composite parent) {
        Composite composite = new Composite(parent, DWT.NULL);
        GridLayout layout = new GridLayout();

        if (fStatusLineAboveButtons) {
            layout.numColumns = 1;
        } else {
            layout.numColumns = 2;
        }

        layout.marginHeight = 0;
        layout.marginLeft = convertHorizontalDLUsToPixels(IDialogConstants.HORIZONTAL_MARGIN);
        layout.marginWidth = 0;
        composite.setLayout(layout);
        composite.setLayoutData(new GridData(GridData.FILL_HORIZONTAL));

        if (!fStatusLineAboveButtons && isHelpAvailable()) {
            createHelpControl(composite);
        }
        fStatusLine = new MessageLine(composite);
        fStatusLine.setAlignment(DWT.LEFT);
        GridData statusData = new GridData(GridData.FILL_HORIZONTAL);
        fStatusLine.setErrorStatus(null);
        if (fStatusLineAboveButtons && isHelpAvailable()) {
            statusData.horizontalSpan = 2;
            createHelpControl(composite);
        }
        fStatusLine.setLayoutData(statusData);
        applyDialogFont(composite);

        /*
         * Create the rest of the button bar, but tell it not to create a help
         * button (we've already created it).
         */
        bool helpAvailable = isHelpAvailable();
        setHelpAvailable(false);
        super.createButtonBar(composite);
        setHelpAvailable(helpAvailable);
        return composite;
    }

    /**
     * Sets the title for this dialog.
     *
     * @param title
     *            the title.
     */
    public void setTitle(String title) {
        fTitle = title !is null ? title : ""; //$NON-NLS-1$
        Shell shell = getShell();
        if ((shell !is null) && !shell.isDisposed()) {
            shell.setText(fTitle);
        }
    }

    /**
     * Sets the image for this dialog.
     *
     * @param image
     *            the image.
     */
    public void setImage(Image image) {
        fImage = image;
        Shell shell = getShell();
        if ((shell !is null) && !shell.isDisposed()) {
            shell.setImage(fImage);
        }
    }

}
