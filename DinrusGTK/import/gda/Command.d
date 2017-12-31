module gtkD.gda.Command;

public  import gtkD.gdac.gdatypes;

private import gtkD.gdac.gda;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gda.Transaction;




/**
 * Description
 *  The GdaCommand structure holds data needed to issue a command to the
 *  providers.
 *  Applications usually create a GdaCommand (via gda_command_new), set its
 *  properties (via the gda_command_set_* functions) and pass it over to the
 *  database using the GdaConnection functions.
 *  One interesting thing about GdaCommand's is that they can be reused over
 *  and over. That is, applications don't need to create a command every time
 *  they want to run something on the connected database. Moreover, the ability
 *  to create command strings with placeholders allows the use of parameters to
 *  specify the values for those placeholders. Thus, an application can create a
 *  command of the form:
 *  INSERT INTO employees VALUES (id, name, address, salary)
 *  and reuse the same command over and over, just using different values for the
 *  placeholders.
 *  The value for the placeholders is specified when sending the GdaCommand to a
 *  database connection, which is done via the gda_connection_execute function.
 */
public class Command
{
	
	/** the main Gtk struct */
	protected GdaCommand* gdaCommand;
	
	
	public GdaCommand* getCommandStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdaCommand* gdaCommand);
	
	/**
	 */
	
	/**
	 * Returns:
	 */
	public static GType getType();
	
	/**
	 * Creates a new GdaCommand from the parameters that should be freed by
	 * calling gda_command_free.
	 * If there are conflicting options, this will set options to
	 * GDA_COMMAND_OPTION_DEFAULT.
	 * Params:
	 * text =  the text of the command.
	 * type =  a GdaCommandType value.
	 * options =  a GdaCommandOptions value.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string text, GdaCommandType type, GdaCommandOptions options);
	
	/**
	 * Frees the resources allocated by gda_command_new.
	 */
	public void free();
	
	/**
	 * Creates a new GdaCommand from an existing one.
	 * Returns: a newly allocated GdaCommand with a copy of the data in cmd.
	 */
	public Command copy();
	
	/**
	 * Gets the command text held by cmd.
	 * Returns: the command string of cmd.
	 */
	public string getText();
	
	/**
	 * Sets the command text of cmd.
	 * Params:
	 * text =  the command text.
	 */
	public void setText(string text);
	
	/**
	 * Gets the command type of cmd.
	 * Returns: the command type of cmd.
	 */
	public GdaCommandType getCommandType();
	
	/**
	 * Sets the command type of cmd.
	 * Params:
	 * type =  the command type.
	 */
	public void setCommandType(GdaCommandType type);
	
	/**
	 * Gets the command options of cmd.
	 * Returns: the command options of cmd.
	 */
	public GdaCommandOptions getOptions();
	
	/**
	 * Sets the command options of cmd. If there conflicting options, it will just
	 * leave the value as before.
	 * Params:
	 * options =  the command options.
	 */
	public void setOptions(GdaCommandOptions options);
	
	/**
	 * Gets the GdaTransaction associated with the given GdaCommand.
	 * Returns: the transaction for the command.
	 */
	public Transaction getTransaction();
	
	/**
	 * Sets the GdaTransaction associated with the given GdaCommand.
	 * Params:
	 * xaction =  a GdaTransaction object.
	 */
	public void setTransaction(Transaction xaction);
}
