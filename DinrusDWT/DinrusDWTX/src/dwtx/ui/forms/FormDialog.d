/*******************************************************************************
 * Copyright (c) 2006, 2007 IBM Corporation and others.
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
module dwtx.ui.forms.FormDialog;

import dwtx.ui.forms.IManagedForm;
import dwtx.ui.forms.ManagedForm;

import dwt.DWT;
import dwt.layout.GridData;
import dwt.widgets.Composite;
import dwt.widgets.Control;
import dwt.widgets.Label;
import dwt.widgets.Shell;
import dwtx.jface.dialogs.TrayDialog;
import dwtx.jface.window.IShellProvider;
import dwtx.ui.forms.widgets.FormToolkit;
import dwtx.ui.forms.widgets.ScrolledForm;
import dwtx.ui.internal.forms.Messages;

import dwt.dwthelper.utils;

/**
 * A general-purpose dialog that hosts a form. Clients should extend the class
 * and override <code>createFormContent(IManagedForm)</code> protected method.
 * <p>
 * Since forms with wrapped text typically don't have a preferred size, it is
 * important to set the initial dialog size upon creation:
 * <p>
 *
 * <pre>
 * MyFormDialog dialog = new MyFormDialog(shell);
 * dialog.create();
 * dialog.getShell().setSize(500, 500);
 * dialog.open();
 * </pre>
 *
 * <p>
 * Otherwise, the dialog may open very wide.
 * <p>
 *
 * @since 3.3
 */

public class FormDialog : TrayDialog {
    private FormToolkit toolkit;

    /**
     * Creates a new form dialog for a provided parent shell.
     *
     * @param shell
     *            the parent shell
     */
    public this(Shell shell) {
        super(shell);
        setShellStyle(getShellStyle() | DWT.RESIZE);
    }

    /**
     * Creates a new form dialog for a provided parent shell provider.
     *
     * @param parentShellProvider
     *            the parent shell provider
     */
    public this(IShellProvider parentShellProvider) {
        super(parentShellProvider);
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.dialogs.TrayDialog#close()
     */
    public bool close() {
        bool rcode = super.close();
        toolkit.dispose();
        return rcode;
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.dialogs.Dialog#createDialogArea(dwt.widgets.Composite)
     */
    protected Control createDialogArea(Composite parent) {
        toolkit = new FormToolkit(parent.getDisplay());
        ScrolledForm sform = toolkit.createScrolledForm(parent);
        sform.setLayoutData(new GridData(GridData.FILL_BOTH));
        ManagedForm mform = new ManagedForm(toolkit, sform);
        createFormContent(mform);
        applyDialogFont(sform.getBody());
        return sform;
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.dialogs.TrayDialog#createButtonBar(dwt.widgets.Composite)
     */
    protected Control createButtonBar(Composite parent) {
        GridData gd = new GridData(GridData.FILL_HORIZONTAL);
        //Composite sep = new Composite(parent, DWT.NULL);
        //sep.setBackground(parent.getDisplay().getSystemColor(DWT.COLOR_WIDGET_NORMAL_SHADOW));
        //gd.heightHint = 1;
        Label sep = new Label(parent, DWT.HORIZONTAL|DWT.SEPARATOR);
        sep.setLayoutData(gd);
        Control bar = super.createButtonBar(parent);
        return bar;
    }

    /**
     * Configures the dialog form and creates form content. Clients should
     * override this method.
     *
     * @param mform
     *            the dialog form
     */
    protected void createFormContent(IManagedForm mform) {
        mform.getForm().setText(Messages.FormDialog_defaultTitle);
    }
}
