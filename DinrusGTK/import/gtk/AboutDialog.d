module gtkD.gtk.AboutDialog;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gdk.Pixbuf;
private import gtkD.gtk.Window;



private import gtkD.gtk.Dialog;

/**
 * Description
 * The GtkAboutDialog offers a simple way to display information about
 * a program like its logo, name, copyright, website and license. It is
 * also possible to give credits to the authors, documenters, translators
 * and artists who have worked on the program. An about dialog is typically
 * opened when the user selects the About option from
 * the Help menu. All parts of the dialog are optional.
 * About dialog often contain links and email addresses. GtkAboutDialog
 * supports this by offering global hooks, which are called when the user
 * clicks on a link or email address, see gtk_about_dialog_set_email_hook()
 * and gtk_about_dialog_set_url_hook(). Email addresses in the
 * authors, documenters and artists properties are recognized by looking for
 * <user@host>, URLs are
 * recognized by looking for http://url, with
 * url extending to the next space, tab or line break.
 * Since 2.18 GtkAboutDialog provides default website and email hooks that use
 * gtk_show_uri().
 * If you want provide your own hooks overriding the default ones, it is important
 * to do so before setting the website and email URL properties, like this:
 * gtk_about_dialog_set_url_hook (GTK_ABOUT_DIALOG (dialog), launch_url, NULL, NULL);
 * gtk_about_dialog_set_website (GTK_ABOUT_DIALOG (dialog), app_url);
 * To disable the default hooks, you can pass NULL as the hook func. Then,
 * the GtkAboutDialog widget will not display the website or the
 * email addresses as clickable.
 * To make constructing a GtkAboutDialog as convenient as possible, you can
 * use the function gtk_show_about_dialog() which constructs and shows a dialog
 * and keeps it around so that it can be shown again.
 * Note that GTK+ sets a default title of _("About %s")
 * on the dialog window (where %s is replaced by the name of the
 * application, but in order to ensure proper translation of the title,
 * applications should set the title property explicitly when constructing
 * a GtkAboutDialog, as shown in the following example:
 * gtk_show_about_dialog (NULL,
 *  "program-name", "ExampleCode",
 *  "logo", example_logo,
 *  "title" _("About ExampleCode"),
 *  NULL);
 * Note that prior to GTK+ 2.12, the "program-name" property
 * was called "name". This was changed to avoid the conflict with the
 * "name" property.
 */
public class AboutDialog : Dialog
{
	
	/** the main Gtk struct */
	protected GtkAboutDialog* gtkAboutDialog;
	
	
	public GtkAboutDialog* getAboutDialogStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkAboutDialog* gtkAboutDialog);
	
	/**
	 */
	
	/**
	 * Creates a new GtkAboutDialog.
	 * Since 2.6
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Warning
	 * gtk_about_dialog_get_name has been deprecated since version 2.12 and should not be used in newly-written code. Use gtk_about_dialog_get_program_name() instead.
	 * Returns the program name displayed in the about dialog.
	 * Since 2.6
	 * Returns: The program name. The string is owned by the about dialog and must not be modified.
	 */
	public override string getName();
	
	/**
	 * Warning
	 * gtk_about_dialog_set_name has been deprecated since version 2.12 and should not be used in newly-written code. Use gtk_about_dialog_set_program_name() instead.
	 * Sets the name to display in the about dialog.
	 * If this is not set, it defaults to g_get_application_name().
	 * Since 2.6
	 * Params:
	 * name =  the program name
	 */
	public override void setName(string name);
	
	/**
	 * Returns the program name displayed in the about dialog.
	 * Since 2.12
	 * Returns: The program name. The string is owned by the about dialog and must not be modified.
	 */
	public string getProgramName();
	
	/**
	 * Sets the name to display in the about dialog.
	 * If this is not set, it defaults to g_get_application_name().
	 * Since 2.12
	 * Params:
	 * name =  the program name
	 */
	public void setProgramName(string name);
	
	/**
	 * Returns the version string.
	 * Since 2.6
	 * Returns: The version string. The string is owned by the about dialog and must not be modified.
	 */
	public string getVersion();
	
	/**
	 * Sets the version string to display in the about dialog.
	 * Since 2.6
	 */
	public void setVersion(string versio);
	/**
	 * Returns the copyright string.
	 * Since 2.6
	 * Returns: The copyright string. The string is owned by the about dialog and must not be modified.
	 */
	public string getCopyright();
	
	/**
	 * Sets the copyright string to display in the about dialog.
	 * This should be a short string of one or two lines.
	 * Since 2.6
	 * Params:
	 * copyright =  the copyright string
	 */
	public void setCopyright(string copyright);
	
	/**
	 * Returns the comments string.
	 * Since 2.6
	 * Returns: The comments. The string is owned by the about dialog and must not be modified.
	 */
	public string getComments();
	
	/**
	 * Sets the comments string to display in the about
	 * dialog. This should be a short string of one or
	 * two lines.
	 * Since 2.6
	 * Params:
	 * comments =  a comments string
	 */
	public void setComments(string comments);
	
	/**
	 * Returns the license information.
	 * Since 2.6
	 * Returns: The license information. The string is owned by the about dialog and must not be modified.
	 */
	public string getLicense();

	/**
	 * Sets the license information to be displayed in the secondary
	 * license dialog. If license is NULL, the license button is
	 * hidden.
	 * Since 2.6
	 * Params:
	 * license =  the license information or NULL
	 */
	public void setLicense(string license);
	
	/**
	 * Returns whether the license text in about is
	 * automatically wrapped.
	 * Since 2.8
	 * Returns: TRUE if the license text is wrapped
	 */
	public int getWrapLicense();
	
	/**
	 * Sets whether the license text in about is
	 * automatically wrapped.
	 * Since 2.8
	 * Params:
	 * wrapLicense =  whether to wrap the license
	 */
	public void setWrapLicense(int wrapLicense);
	
	/**
	 * Returns the website URL.
	 * Since 2.6
	 * Returns: The website URL. The string is owned by the about dialog and must not be modified.
	 */
	public string getWebsite();
	
	/**
	 * Sets the URL to use for the website link.
	 * Note that that the hook functions need to be set up
	 * before calling this function.
	 * Since 2.6
	 * Params:
	 * website =  a URL string starting with "http://"
	 */
	public void setWebsite(string website);
	
	/**
	 * Returns the label used for the website link.
	 * Since 2.6
	 * Returns: The label used for the website link. The string is owned by the about dialog and must not be modified.
	 */
	public string getWebsiteLabel();
	
	/**
	 * Sets the label to be used for the website link.
	 * It defaults to the website URL.
	 * Since 2.6
	 * Params:
	 * websiteLabel =  the label used for the website link
	 */
	public void setWebsiteLabel(string websiteLabel);
	
	/**
	 * Returns the string which are displayed in the authors tab
	 * of the secondary credits dialog.
	 * Since 2.6
	 * Returns: A NULL-terminated string array containing the authors. The array is owned by the about dialog  and must not be modified.
	 */
	public string[] getAuthors();
	
	/**
	 * Sets the strings which are displayed in the authors tab
	 * of the secondary credits dialog.
	 * Since 2.6
	 * Params:
	 * authors =  a NULL-terminated array of strings
	 */
	public void setAuthors(string[] authors);
	
	/**
	 * Returns the string which are displayed in the artists tab
	 * of the secondary credits dialog.
	 * Since 2.6
	 * Returns: A NULL-terminated string array containing the artists. The array is owned by the about dialog  and must not be modified.
	 */
	public string[] getArtists();
	
	/**
	 * Sets the strings which are displayed in the artists tab
	 * of the secondary credits dialog.
	 * Since 2.6
	 * Params:
	 * artists =  a NULL-terminated array of strings
	 */
	public void setArtists(string[] artists);
	
	/**
	 * Returns the string which are displayed in the documenters
	 * tab of the secondary credits dialog.
	 * Since 2.6
	 * Returns: A NULL-terminated string array containing the documenters. The array is owned by the about dialog  and must not be modified.
	 */
	public string[] getDocumenters();
	
	/**
	 * Sets the strings which are displayed in the documenters tab
	 * of the secondary credits dialog.
	 * Since 2.6
	 * Params:
	 * documenters =  a NULL-terminated array of strings
	 */
	public void setDocumenters(string[] documenters);
	
	/**
	 * Returns the translator credits string which is displayed
	 * in the translators tab of the secondary credits dialog.
	 * Since 2.6
	 * Returns: The translator credits string. The string is owned by the about dialog and must not be modified.
	 */
	public string getTranslatorCredits();
	
	/**
	 * Sets the translator credits string which is displayed in
	 * the translators tab of the secondary credits dialog.
	 * The intended use for this string is to display the translator
	 * of the language which is currently used in the user interface.
	 * Using gettext(), a simple way to achieve that is to mark the
	 * Since 2.6
	 * Params:
	 * translatorCredits =  the translator credits
	 */
	public void setTranslatorCredits(string translatorCredits);
	
	/**
	 * Returns the pixbuf displayed as logo in the about dialog.
	 * Since 2.6
	 * Returns: the pixbuf displayed as logo. The pixbuf is owned by the about dialog. If you want to keep a reference to it, you have to call g_object_ref() on it.
	 */
	public Pixbuf getLogo();
	
	/**
	 * Sets the pixbuf to be displayed as logo in
	 * the about dialog. If it is NULL, the default
	 * window icon set with gtk_window_set_default_icon()
	 * will be used.
	 * Since 2.6
	 * Params:
	 * logo =  a GdkPixbuf, or NULL
	 */
	public void setLogo(Pixbuf logo);
	
	/**
	 * Returns the icon name displayed as logo in the about dialog.
	 * Since 2.6
	 * Returns: the icon name displayed as logo. The string is owned by the dialog. If you want to keep a reference to it, you have to call g_strdup() on it.
	 */
	public string getLogoIconName();
	
	/**
	 * Sets the pixbuf to be displayed as logo in
	 * the about dialog. If it is NULL, the default
	 * window icon set with gtk_window_set_default_icon()
	 * will be used.
	 * Since 2.6
	 * Params:
	 * iconName =  an icon name, or NULL
	 */
	public void setLogoIconName(string iconName);
	
	/**
	 * Installs a global function to be called whenever the user activates an
	 * email link in an about dialog.
	 * Since 2.18 there exists a default function which uses gtk_show_uri(). To
	 * deactivate it, you can pass NULL for func.
	 * Since 2.6
	 * Params:
	 * func =  a function to call when an email link is activated.
	 * data =  data to pass to func
	 * destroy =  GDestroyNotify for data
	 * Returns: the previous email hook.
	 */
	public static GtkAboutDialogActivateLinkFunc setEmailHook(GtkAboutDialogActivateLinkFunc func, void* data, GDestroyNotify destroy);
	
	/**
	 * Installs a global function to be called whenever the user activates a
	 * URL link in an about dialog.
	 * Since 2.18 there exists a default function which uses gtk_show_uri(). To
	 * deactivate it, you can pass NULL for func.
	 * Since 2.6
	 * Params:
	 * func =  a function to call when a URL link is activated.
	 * data =  data to pass to func
	 * destroy =  GDestroyNotify for data
	 * Returns: the previous URL hook.
	 */
	public static GtkAboutDialogActivateLinkFunc setUrlHook(GtkAboutDialogActivateLinkFunc func, void* data, GDestroyNotify destroy);
}
