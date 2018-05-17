/*******************************************************************************
 * Copyright (c) 2000, 2007 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *     Konstantin Scheglov <scheglov_ke@nlmk.ru > - Fix for bug 41172
 *     [Dialogs] Bug with Image in TitleAreaDialog
 *     Sebastian Davids <sdavids@gmx.de> - Fix for bug 82064
 *     [Dialogs] TitleAreaDialog#setTitleImage cannot be called before open()
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module dwtx.jface.dialogs.TitleAreaDialog;

import dwtx.jface.dialogs.IDialogConstants;
import dwtx.jface.dialogs.TrayDialog;
import dwtx.jface.dialogs.IMessageProvider;

import dwt.DWT;
import dwt.events.DisposeEvent;
import dwt.events.DisposeListener;
import dwt.graphics.Color;
import dwt.graphics.Image;
import dwt.graphics.Point;
import dwt.graphics.RGB;
import dwt.layout.FormAttachment;
import dwt.layout.FormData;
import dwt.layout.FormLayout;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Composite;
import dwt.widgets.Control;
import dwt.widgets.Display;
import dwt.widgets.Label;
import dwt.widgets.Shell;
import dwt.widgets.Text;
import dwtx.jface.resource.JFaceColors;
import dwtx.jface.resource.JFaceResources;

import dwt.dwthelper.utils;

/**
 * A dialog that has a title area for displaying a title and an image as well as
 * a common area for displaying a description, a message, or an error message.
 * <p>
 * This dialog class may be subclassed.
 */
public class TitleAreaDialog : TrayDialog {
    /**
     * Image registry key for error message image.
     */
    public static const String DLG_IMG_TITLE_ERROR = DLG_IMG_MESSAGE_ERROR;

    /**
     * Image registry key for banner image (value
     * <code>"dialog_title_banner_image"</code>).
     */
    public static const String DLG_IMG_TITLE_BANNER = "dialog_title_banner_image";//$NON-NLS-1$

    /**
     * Message type constant used to display an info icon with the message.
     *
     * @since 2.0
     * @deprecated
     */
    public const static String INFO_MESSAGE = "INFO_MESSAGE"; //$NON-NLS-1$

    /**
     * Message type constant used to display a warning icon with the message.
     *
     * @since 2.0
     * @deprecated
     */
    public const static String WARNING_MESSAGE = "WARNING_MESSAGE"; //$NON-NLS-1$

    // Space between an image and a label
    private static const int H_GAP_IMAGE = 5;

    // Minimum dialog width (in dialog units)
    private static const int MIN_DIALOG_WIDTH = 350;

    // Minimum dialog height (in dialog units)
    private static const int MIN_DIALOG_HEIGHT = 150;

    private Label titleLabel;

    private Label titleImageLabel;

    private Label bottomFillerLabel;

    private Label leftFillerLabel;

    private RGB titleAreaRGB;

    Color titleAreaColor;

    private String message = ""; //$NON-NLS-1$

    private String errorMessage;

    private Text messageLabel;

    private Composite workArea;

    private Label messageImageLabel;

    private Image messageImage;

    private bool showingError = false;

    private bool titleImageLargest = true;

    private int messageLabelHeight;

    private Image titleAreaImage;

    /**
     * Instantiate a new title area dialog.
     *
     * @param parentShell
     *            the parent DWT shell
     */
    public this(Shell parentShell) {
        super(parentShell);
    }

    /*
     * @see Dialog.createContents(Composite)
     */
    protected override Control createContents(Composite parent) {
        // create the overall composite
        Composite contents = new Composite(parent, DWT.NONE);
        contents.setLayoutData(new GridData(GridData.FILL_BOTH));
        // initialize the dialog units
        initializeDialogUnits(contents);
        FormLayout layout = new FormLayout();
        contents.setLayout(layout);
        // Now create a work area for the rest of the dialog
        workArea = new Composite(contents, DWT.NONE);
        GridLayout childLayout = new GridLayout();
        childLayout.marginHeight = 0;
        childLayout.marginWidth = 0;
        childLayout.verticalSpacing = 0;
        workArea.setLayout(childLayout);
        Control top = createTitleArea(contents);
        resetWorkAreaAttachments(top);
        workArea.setFont(JFaceResources.getDialogFont());
        // initialize the dialog units
        initializeDialogUnits(workArea);
        // create the dialog area and button bar
        dialogArea = createDialogArea(workArea);
        buttonBar = createButtonBar(workArea);
        return contents;
    }

    /**
     * Creates and returns the contents of the upper part of this dialog (above
     * the button bar).
     * <p>
     * The <code>Dialog</code> implementation of this framework method creates
     * and returns a new <code>Composite</code> with no margins and spacing.
     * Subclasses should override.
     * </p>
     *
     * @param parent
     *            The parent composite to contain the dialog area
     * @return the dialog area control
     */
    protected override Control createDialogArea(Composite parent) {
        // create the top level composite for the dialog area
        Composite composite = new Composite(parent, DWT.NONE);
        GridLayout layout = new GridLayout();
        layout.marginHeight = 0;
        layout.marginWidth = 0;
        layout.verticalSpacing = 0;
        layout.horizontalSpacing = 0;
        composite.setLayout(layout);
        composite.setLayoutData(new GridData(GridData.FILL_BOTH));
        composite.setFont(parent.getFont());
        // Build the separator line
        Label titleBarSeparator = new Label(composite, DWT.HORIZONTAL
                | DWT.SEPARATOR);
        titleBarSeparator.setLayoutData(new GridData(GridData.FILL_HORIZONTAL));
        return composite;
    }

    /**
     * Creates the dialog's title area.
     *
     * @param parent
     *            the DWT parent for the title area widgets
     * @return Control with the highest x axis value.
     */
    private Control createTitleArea(Composite parent) {

        // add a dispose listener
        parent.addDisposeListener(new class DisposeListener {
            public void widgetDisposed(DisposeEvent e) {
                if (titleAreaColor !is null) {
                    titleAreaColor.dispose();
                }
            }
        });
        // Determine the background color of the title bar
        Display display = parent.getDisplay();
        Color background;
        Color foreground;
        if (titleAreaRGB !is null) {
            titleAreaColor = new Color(display, titleAreaRGB);
            background = titleAreaColor;
            foreground = null;
        } else {
            background = JFaceColors.getBannerBackground(display);
            foreground = JFaceColors.getBannerForeground(display);
        }

        parent.setBackground(background);
        int verticalSpacing = convertVerticalDLUsToPixels(IDialogConstants.VERTICAL_SPACING);
        int horizontalSpacing = convertHorizontalDLUsToPixels(IDialogConstants.HORIZONTAL_SPACING);
        // Dialog image @ right
        titleImageLabel = new Label(parent, DWT.CENTER);
        titleImageLabel.setBackground(background);
        if (titleAreaImage is null)
            titleImageLabel.setImage(JFaceResources
                    .getImage(DLG_IMG_TITLE_BANNER));
        else
            titleImageLabel.setImage(titleAreaImage);

        FormData imageData = new FormData();
        imageData.top = new FormAttachment(0, 0);
        // Note: do not use horizontalSpacing on the right as that would be a
        // regression from
        // the R2.x style where there was no margin on the right and images are
        // flush to the right
        // hand side. see reopened comments in 41172
        imageData.right = new FormAttachment(100, 0); // horizontalSpacing
        titleImageLabel.setLayoutData(imageData);
        // Title label @ top, left
        titleLabel = new Label(parent, DWT.LEFT);
        JFaceColors.setColors(titleLabel, foreground, background);
        titleLabel.setFont(JFaceResources.getBannerFont());
        titleLabel.setText(" ");//$NON-NLS-1$
        FormData titleData = new FormData();
        titleData.top = new FormAttachment(0, verticalSpacing);
        titleData.right = new FormAttachment(titleImageLabel);
        titleData.left = new FormAttachment(0, horizontalSpacing);
        titleLabel.setLayoutData(titleData);
        // Message image @ bottom, left
        messageImageLabel = new Label(parent, DWT.CENTER);
        messageImageLabel.setBackground(background);
        // Message label @ bottom, center
        messageLabel = new Text(parent, DWT.WRAP | DWT.READ_ONLY);
        JFaceColors.setColors(messageLabel, foreground, background);
        messageLabel.setText(" \n "); // two lines//$NON-NLS-1$
        messageLabel.setFont(JFaceResources.getDialogFont());
        messageLabelHeight = messageLabel.computeSize(DWT.DEFAULT, DWT.DEFAULT).y;
        // Filler labels
        leftFillerLabel = new Label(parent, DWT.CENTER);
        leftFillerLabel.setBackground(background);
        bottomFillerLabel = new Label(parent, DWT.CENTER);
        bottomFillerLabel.setBackground(background);
        setLayoutsForNormalMessage(verticalSpacing, horizontalSpacing);
        determineTitleImageLargest();
        if (titleImageLargest)
            return titleImageLabel;
        return messageLabel;
    }

    /**
     * Determine if the title image is larger than the title message and message
     * area. This is used for layout decisions.
     */
    private void determineTitleImageLargest() {
        int titleY = titleImageLabel.computeSize(DWT.DEFAULT, DWT.DEFAULT).y;
        int verticalSpacing = convertVerticalDLUsToPixels(IDialogConstants.VERTICAL_SPACING);
        int labelY = titleLabel.computeSize(DWT.DEFAULT, DWT.DEFAULT).y;
        labelY += verticalSpacing;
        labelY += messageLabelHeight;
        labelY += verticalSpacing;
        titleImageLargest = titleY > labelY;
    }

    /**
     * Set the layout values for the messageLabel, messageImageLabel and
     * fillerLabel for the case where there is a normal message.
     *
     * @param verticalSpacing
     *            int The spacing between widgets on the vertical axis.
     * @param horizontalSpacing
     *            int The spacing between widgets on the horizontal axis.
     */
    private void setLayoutsForNormalMessage(int verticalSpacing,
            int horizontalSpacing) {
        FormData messageImageData = new FormData();
        messageImageData.top = new FormAttachment(titleLabel, verticalSpacing);
        messageImageData.left = new FormAttachment(0, H_GAP_IMAGE);
        messageImageLabel.setLayoutData(messageImageData);
        FormData messageLabelData = new FormData();
        messageLabelData.top = new FormAttachment(titleLabel, verticalSpacing);
        messageLabelData.right = new FormAttachment(titleImageLabel);
        messageLabelData.left = new FormAttachment(messageImageLabel,
                horizontalSpacing);
        messageLabelData.height = messageLabelHeight;
        if (titleImageLargest)
            messageLabelData.bottom = new FormAttachment(titleImageLabel, 0,
                    DWT.BOTTOM);
        messageLabel.setLayoutData(messageLabelData);
        FormData fillerData = new FormData();
        fillerData.left = new FormAttachment(0, horizontalSpacing);
        fillerData.top = new FormAttachment(messageImageLabel, 0);
        fillerData.bottom = new FormAttachment(messageLabel, 0, DWT.BOTTOM);
        bottomFillerLabel.setLayoutData(fillerData);
        FormData data = new FormData();
        data.top = new FormAttachment(messageImageLabel, 0, DWT.TOP);
        data.left = new FormAttachment(0, 0);
        data.bottom = new FormAttachment(messageImageLabel, 0, DWT.BOTTOM);
        data.right = new FormAttachment(messageImageLabel, 0);
        leftFillerLabel.setLayoutData(data);
    }

    /**
     * The <code>TitleAreaDialog</code> implementation of this
     * <code>Window</code> methods returns an initial size which is at least
     * some reasonable minimum.
     *
     * @return the initial size of the dialog
     */
    protected override Point getInitialSize() {
        Point shellSize = super.getInitialSize();
        return new Point(Math.max(
                convertHorizontalDLUsToPixels(MIN_DIALOG_WIDTH), shellSize.x),
                Math.max(convertVerticalDLUsToPixels(MIN_DIALOG_HEIGHT),
                        shellSize.y));
    }

    /**
     * Retained for backward compatibility.
     *
     * Returns the title area composite. There is no composite in this
     * implementation so the shell is returned.
     *
     * @return Composite
     * @deprecated
     */
    protected Composite getTitleArea() {
        return getShell();
    }

    /**
     * Returns the title image label.
     *
     * @return the title image label
     */
    protected Label getTitleImageLabel() {
        return titleImageLabel;
    }

    /**
     * Display the given error message. The currently displayed message is saved
     * and will be redisplayed when the error message is set to
     * <code>null</code>.
     *
     * @param newErrorMessage
     *            the newErrorMessage to display or <code>null</code>
     */
    public void setErrorMessage(String newErrorMessage) {
        // Any change?
        if (errorMessage is null ? newErrorMessage is null : errorMessage
                .equals(newErrorMessage))
            return;
        errorMessage = newErrorMessage;

        // Clear or set error message.
        if (errorMessage is null) {
            if (showingError) {
                // we were previously showing an error
                showingError = false;
            }
            // show the message
            // avoid calling setMessage in case it is overridden to call
            // setErrorMessage,
            // which would result in a recursive infinite loop
            if (message is null) // this should probably never happen since
                // setMessage does this conversion....
                message = ""; //$NON-NLS-1$
            updateMessage(message);
            messageImageLabel.setImage(messageImage);
            setImageLabelVisible(messageImage !is null);
        } else {
            // Add in a space for layout purposes but do not
            // change the instance variable
            String displayedErrorMessage = " " ~ errorMessage; //$NON-NLS-1$
            updateMessage(displayedErrorMessage);
            if (!showingError) {
                // we were not previously showing an error
                showingError = true;
                messageImageLabel.setImage(JFaceResources
                        .getImage(DLG_IMG_TITLE_ERROR));
                setImageLabelVisible(true);
            }
        }
        layoutForNewMessage();
    }

    /**
     * Re-layout the labels for the new message.
     */
    private void layoutForNewMessage() {
        int verticalSpacing = convertVerticalDLUsToPixels(IDialogConstants.VERTICAL_SPACING);
        int horizontalSpacing = convertHorizontalDLUsToPixels(IDialogConstants.HORIZONTAL_SPACING);
        // If there are no images then layout as normal
        if (errorMessage is null && messageImage is null) {
            setImageLabelVisible(false);
            setLayoutsForNormalMessage(verticalSpacing, horizontalSpacing);
        } else {
            messageImageLabel.setVisible(true);
            bottomFillerLabel.setVisible(true);
            leftFillerLabel.setVisible(true);
            /**
             * Note that we do not use horizontalSpacing here as when the
             * background of the messages changes there will be gaps between the
             * icon label and the message that are the background color of the
             * shell. We add a leading space elsewhere to compendate for this.
             */
            FormData data = new FormData();
            data.left = new FormAttachment(0, H_GAP_IMAGE);
            data.top = new FormAttachment(titleLabel, verticalSpacing);
            messageImageLabel.setLayoutData(data);
            data = new FormData();
            data.top = new FormAttachment(messageImageLabel, 0);
            data.left = new FormAttachment(0, 0);
            data.bottom = new FormAttachment(messageLabel, 0, DWT.BOTTOM);
            data.right = new FormAttachment(messageImageLabel, 0, DWT.RIGHT);
            bottomFillerLabel.setLayoutData(data);
            data = new FormData();
            data.top = new FormAttachment(messageImageLabel, 0, DWT.TOP);
            data.left = new FormAttachment(0, 0);
            data.bottom = new FormAttachment(messageImageLabel, 0, DWT.BOTTOM);
            data.right = new FormAttachment(messageImageLabel, 0);
            leftFillerLabel.setLayoutData(data);
            FormData messageLabelData = new FormData();
            messageLabelData.top = new FormAttachment(titleLabel,
                    verticalSpacing);
            messageLabelData.right = new FormAttachment(titleImageLabel);
            messageLabelData.left = new FormAttachment(messageImageLabel, 0);
            messageLabelData.height = messageLabelHeight;
            if (titleImageLargest)
                messageLabelData.bottom = new FormAttachment(titleImageLabel,
                        0, DWT.BOTTOM);
            messageLabel.setLayoutData(messageLabelData);
        }
        // Do not layout before the dialog area has been created
        // to avoid incomplete calculations.
        if (dialogArea !is null)
            workArea.getParent().layout(true);
    }

    /**
     * Set the message text. If the message line currently displays an error,
     * the message is saved and will be redisplayed when the error message is
     * set to <code>null</code>.
     * <p>
     * Shortcut for <code>setMessage(newMessage, IMessageProvider.NONE)</code>
     * </p>
     * This method should be called after the dialog has been opened as it
     * updates the message label immediately.
     *
     * @param newMessage
     *            the message, or <code>null</code> to clear the message
     */
    public void setMessage(String newMessage) {
        setMessage(newMessage, IMessageProvider.NONE);
    }

    /**
     * Sets the message for this dialog with an indication of what type of
     * message it is.
     * <p>
     * The valid message types are one of <code>NONE</code>,
     * <code>INFORMATION</code>,<code>WARNING</code>, or
     * <code>ERROR</code>.
     * </p>
     * <p>
     * Note that for backward compatibility, a message of type
     * <code>ERROR</code> is different than an error message (set using
     * <code>setErrorMessage</code>). An error message overrides the current
     * message until the error message is cleared. This method replaces the
     * current message and does not affect the error message.
     * </p>
     *
     * @param newMessage
     *            the message, or <code>null</code> to clear the message
     * @param newType
     *            the message type
     * @since 2.0
     */
    public void setMessage(String newMessage, int newType) {
        Image newImage = null;
        if (newMessage !is null) {
            switch (newType) {
            case IMessageProvider.NONE:
                break;
            case IMessageProvider.INFORMATION:
                newImage = JFaceResources.getImage(DLG_IMG_MESSAGE_INFO);
                break;
            case IMessageProvider.WARNING:
                newImage = JFaceResources.getImage(DLG_IMG_MESSAGE_WARNING);
                break;
            case IMessageProvider.ERROR:
                newImage = JFaceResources.getImage(DLG_IMG_MESSAGE_ERROR);
                break;
            default:
            }
        }
        showMessage(newMessage, newImage);
    }

    /**
     * Show the new message and image.
     *
     * @param newMessage
     * @param newImage
     */
    private void showMessage(String newMessage, Image newImage) {
        // Any change?
        if (message.equals(newMessage) && messageImage is newImage) {
            return;
        }
        message = newMessage;
        if (message is null)
            message = "";//$NON-NLS-1$
        // Message string to be shown - if there is an image then add in
        // a space to the message for layout purposes
        String shownMessage = (newImage is null) ? message : " " ~ message; //$NON-NLS-1$
        messageImage = newImage;
        if (!showingError) {
            // we are not showing an error
            updateMessage(shownMessage);
            messageImageLabel.setImage(messageImage);
            setImageLabelVisible(messageImage !is null);
            layoutForNewMessage();
        }
    }

    /**
     * Update the contents of the messageLabel.
     *
     * @param newMessage
     *            the message to use
     */
    private void updateMessage(String newMessage) {
        messageLabel.setText(newMessage);
    }

    /**
     * Sets the title to be shown in the title area of this dialog.
     *
     * @param newTitle
     *            the title show
     */
    public void setTitle(String newTitle) {
        if (titleLabel is null)
            return;
        String title = newTitle;
        if (title is null)
            title = "";//$NON-NLS-1$
        titleLabel.setText(title);
    }

    /**
     * Sets the title bar color for this dialog.
     *
     * @param color
     *            the title bar color
     */
    public void setTitleAreaColor(RGB color) {
        titleAreaRGB = color;
    }

    /**
     * Sets the title image to be shown in the title area of this dialog.
     *
     * @param newTitleImage
     *            the title image to be shown
     */
    public void setTitleImage(Image newTitleImage) {

        titleAreaImage = newTitleImage;
        if (titleImageLabel !is null) {
            titleImageLabel.setImage(newTitleImage);
            titleImageLabel.setVisible(newTitleImage !is null);
            if (newTitleImage !is null) {
                determineTitleImageLargest();
                Control top;
                if (titleImageLargest)
                    top = titleImageLabel;
                else
                    top = messageLabel;
                resetWorkAreaAttachments(top);
            }
        }
    }

    /**
     * Make the label used for displaying error images visible depending on
     * bool.
     *
     * @param visible
     *            If <code>true</code> make the image visible, if not then
     *            make it not visible.
     */
    private void setImageLabelVisible(bool visible) {
        messageImageLabel.setVisible(visible);
        bottomFillerLabel.setVisible(visible);
        leftFillerLabel.setVisible(visible);
    }

    /**
     * Reset the attachment of the workArea to now attach to top as the top
     * control.
     *
     * @param top
     */
    private void resetWorkAreaAttachments(Control top) {
        FormData childData = new FormData();
        childData.top = new FormAttachment(top);
        childData.right = new FormAttachment(100, 0);
        childData.left = new FormAttachment(0, 0);
        childData.bottom = new FormAttachment(100, 0);
        workArea.setLayoutData(childData);
    }
}
