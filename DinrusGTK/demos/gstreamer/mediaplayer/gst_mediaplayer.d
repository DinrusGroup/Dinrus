/*
 * gst_mediaplayer is placed in the
 * public domain.
 */

module gst_mediaplayer;

//Tango imports
import tango.util.log.Trace;//Thread safe console output.
import Util = tango.text.Util;
import Integer = tango.text.convert.Integer;
import tango.util.collection.LinkSeq;
import Stringz = tango.stdc.stringz;

import tango.io.FilePath;
import PathUtil = tango.util.PathUtil;//for normalize, which didn't remove ../
import tango.io.FileSystem;

//gtkD imports:
import gtkD.gtk.Main;
import gtkD.gtk.MainWindow;

import gtkD.gtk.Widget;
import gtkD.gdk.Drawable;
import gtkD.gdk.Window;
import gtkD.gdk.Event;
import gtkD.gtk.DrawingArea;
import gtkD.gtk.AspectFrame;

import gtkD.gtk.FileChooserDialog;

import gtkD.gdk.X11;//Needed for XOverlay

import gtkD.gtk.VBox;
import gtkD.gtk.HBox;
import gtkD.gtk.Button;
import gtkD.gtk.ComboBox;

import gtkD.gobject.Value;

//gstreamerD imports:

import gtkD.gstreamer.gstreamer;

import gtkD.gobject.ObjectG;
import gtkD.gstreamer.Element;
import gtkD.gstreamer.Bin;
import gtkD.gstreamer.Pipeline;
import gtkD.gstreamer.ElementFactory;
import gtkD.gstreamer.Pad;
import gtkD.gstreamer.Message;
import gtkD.gstreamer.Structure;
import gtkD.gstreamer.Bus;

import gtkD.gstreamerc.gstreamertypes;
import gtkD.gstreamerc.gstreamer;

import gtkD.gstreamerc.gstinterfacestypes;//For GstXOverlay*

import gtkD.gstinterfaces.XOverlay;

import gtkD.gtkc.glib;
import gtkD.gtkc.gobject;


class MonitorOverlay : public DrawingArea
{
public:
	
	this()
	{
		debug(MonitorOverlay) Trace.formatln("Monitor.this() START.");
		debug(MonitorOverlay) scope(exit) Trace.formatln("Monitor.this() END.");
		
		setAppPaintable( true );
		
		//For some reason this does more harm than good?
		//addOnExpose( &onExpose );
	}
	
	/*
	//For some reason this does more harm than good?
	int onExpose(GdkEventExpose* event, Widget widget)
	{
		if( xoverlay !is null )
		{
			//Trace.formatln("And we even have an xoverlay");
			xoverlay.expose();//For some reason this does more harm than good?
		}
		return false;//?
	}
	*/
	
	public XOverlay xoverlay() { return m_xoverlay; }
	/**
	* Give this method an XOverlay that you've created from
	* a videoSink. like: monitorOverlay.xoverlay = new XOverlay( videoSink );
	*/
	public XOverlay xoverlay(XOverlay set)
	{
		debug(MonitorOverlay) Trace.formatln("Monitor.xoverlay(set) START.");
		debug(MonitorOverlay) scope(exit) Trace.formatln("Monitor.xoverlay(set) END.");
		m_xoverlay = set;
		
		debug(MonitorOverlay) Trace.formatln("Monitor.xoverlay(set) xoverlay set. Now setting XwindowId.");
		m_xoverlay.setXwindowId( X11.drawableGetXid( getWindow() ) );
		
		debug(MonitorOverlay) Trace.formatln("X11.drawableGetXid: {}", X11.drawableGetXid( getWindow() ) );
		
		return m_xoverlay;
	}
	protected XOverlay m_xoverlay;
	
}


class GstMediaPlayer : public MainWindow
{
public:

	GstBusSyncReply createXOverlayWindowCb( Message msg )
	{
		// ignore anything but 'prepare-xwindow-id' element messages
		if( msg.type() != GstMessageType.ELEMENT )
		//if (GST_MESSAGE_TYPE (message) != GST_MESSAGE_ELEMENT)
			return GstBusSyncReply.PASS;
		
		/*GstMessageType typ = msg.type();
		Stdout("The message type is: ")( cast(int)typ ).newline;
		
		ObjectGst obu = msg.src();
		Stdout("The message source is named: ")( obu.getName() ).newline;
		*/
		Structure str = msg.structure();
		if( str.hasName("prepare-xwindow-id") == false )
		//if (!gst_structure_has_name (message->structure, "prepare-xwindow-id"))
			return GstBusSyncReply.PASS;
		
		debug(MonitorOverlay) Trace.formatln("Now we should create the X window.");
		
		monitorOverlay.xoverlay = new XOverlay( videosink );
		
		debug(MonitorOverlay) Trace.formatln("Created an xoverlay.");
		
		return GstBusSyncReply.DROP;
	}

	bool busCall( Message msg )
	{
		debug(gstreamer) Trace.formatln("GstMediaPlayer.busCall(msg) START.");
		debug(gstreamer) scope(exit) Trace.formatln("GstMediaPlayer.busCall(msg) END.");

		switch( msg.type )
		{
			case GstMessageType.UNKNOWN:
				Trace.formatln("Unknown message type.");
			break;
			case GstMessageType.EOS:
				Trace.formatln("End-of-stream. Looping from the start.");
				//Main.quit();
				onSeekToStart(null);
			break;

			case GstMessageType.ERROR:
			{
				string  dbug;
				GError* err;
				msg.parseError(err, dbug);
				//g_free (dbug);
				Trace.formatln("Error: {} dbug: {}", Stringz.fromStringz(err.message), dbug );
				//g_error_free (err);
				Main.quit();
			break;
			}
			default:
			break;
		}

		return true;
	}

	char[] g_appDir;

	this(char[][] args)
	{

		super("GstMediaPlayer");
		
		setSizeRequest(600, 400);
		
		vbox = new VBox(false,0);
		
		monitorOverlay = new MonitorOverlay();
		monitorAspectFrame = new AspectFrame("", 0.5, 0.5, 16.0/9.0, false );
		
		monitorAspectFrame.add( monitorOverlay );
		monitorAspectFrame.setShadowType( GtkShadowType.NONE );
		monitorAspectFrame.setLabelWidget( null );//Yes! This get's rid of that stupid label on top of the aspectframe! More room for the monitor.
		monitorAspectFrame.setBorderWidth(0);//No effect. Trying to get rid of that one pixel border...
		monitorAspectFrame.setSizeRequest(360, -1);//No effect. Why?
		
		vbox.packStart( monitorAspectFrame, true, true, 0 );
		
		buttonsHBox = new HBox(false,0);
		
		openButton = new Button("Open...");
		openButton.addOnClicked( &onOpen );
		buttonsHBox.packStart( openButton, false, false, 0 );
		
		playButton = new Button("Play");
		playButton.addOnClicked( &onPlay );
		buttonsHBox.packStart( playButton, false, false, 0 );
		
		aspectComboBox = new ComboBox(true);//Create a new text ComboBox.
		aspectComboBox.appendText("16:9");
		aspectComboBox.appendText("4:3");
		aspectComboBox.setActiveText("16:9");
		aspectComboBox.addOnChanged( &onAspectComboBoxChanged );
		
		buttonsHBox.packStart( aspectComboBox, false, false, 0 );
		
		quitButton = new Button(StockID.QUIT);
		quitButton.addOnClicked( &onQuit );
		buttonsHBox.packStart( quitButton, false, false, 0 );
		
		vbox.packStart( buttonsHBox, false, false, 0 );
		
		add( vbox );
		
		showAll();

		scope mypath = new FilePath( args[0] );
		
		bool remove_trailing_dotslash = false;
		
		g_appDir = mypath.path();
		
		Trace.formatln("g_appDir before: {}", g_appDir );
		
		if( g_appDir == "./" )
		{
			remove_trailing_dotslash = true;
		}
		
		bool starts_with_two_dots = false;
		if( args[0][0] == '.' && args[0][1] == '.' )
			starts_with_two_dots = true;
		
		mypath = FileSystem.toAbsolute( mypath );//This will add /home/user...
		if( starts_with_two_dots )
			g_appDir = PathUtil.normalize( mypath.path() );//This will get rid of the trailing /../
		else g_appDir = mypath.path();
		
		if( remove_trailing_dotslash == true )
		{
			//This will get rid of the trailing ./
			g_appDir = g_appDir[0..length-2];
		}
		
		Trace.formatln("g_appDir after: {}", g_appDir );
		
		if (args.length > 1)
		{
			mediaFileUri = args[1];
		
			//This will construct the filename to be a URI, but it will only
			//work for files in the same directory.
			if( mediaFileUri[0..7] != "file://" && mediaFileUri[0..7] != "http://" )
				mediaFileUri = "file://" ~ g_appDir ~ mediaFileUri;
		}
		
		/*
		// check input arguments
		if (args.length > 1)
		{
			for( uint i = 0; i < args.length; i++ )
			{
				char[] ar = args[i];
				
				if( ar == "--help" )
				{
					Trace.formatln("Usage: {} <mediafilename>", args[0]);
					return -1;
				}
			}
		}
		*/

		if( mediaFileUri != "" )
			playMediaFile(mediaFileUri);
		
	}
	
	void playMediaFile(char[] file)
	{
		if( source !is null )
		{
			fullStop();
			delete source;
		}
		if( videosink !is null )
			delete videosink;
	
		// create elements

		source = ElementFactory.make("playbin", "ourplaybin");
		//source = ElementFactory.make("playbin2", "ourplaybin");//playbin2 doesn't work,
		//correctly with XOverlay.
		videosink = ElementFactory.make("xvimagesink", "video-output-xvimagesink");
		//Only xvimagesink work (almost) correctly with XOverlay, but even it still
		//has some problems. It won't work with compositing enabled...
		//videosink = ElementFactory.make("autovideosink", "video-output-sink");
		//videosink = ElementFactory.make("fakesink", "video-sink");

		if( source is null )
		{
			Trace.formatln("PlayBin could not be created");
			throw new Exception("One or more gstreamerD elements could not be created.");
		}
		
		if( videosink is null )
		{
			Trace.formatln("videosink could not be created");
			throw new Exception("One or more gstreamerD elements could not be created.");
		}

		//add message handlers
		source.getBus().setSyncHandler( &createXOverlayWindowCb );
		source.getBus().addWatch( &busCall );

		//Some Value handling, to get our videosink C GstElement*
		//to be accepted by setProperty. This could propably made cleaner.
		//One idea is to add a Element.setProperty(char[], void*); method.
		
		Value val = new Value();
		//val.init(GType.POINTER);
		//val.setPointer( cast(void*)(videosink.getElementStruct()) );
		val.init(GType.OBJECT);
		//val.setObject( cast(GstElement*)videosink.getElementStruct() );
		val.setObject( videosink.getElementStruct() );
		source.setProperty( "video-sink", val );
	
		source.setProperty("uri", file);
		play();
	}
	

	~this()
	{
		fullStop();
	}

	void onPlay(Button button)
	{
		play();
	}
	
	void play()
	{
		if( isPlaying == false )
		{
			isPlaying = true;
			// Now set to playing and iterate.
			debug(1) Trace.formatln("Setting to PLAYING.");
			//pipeline.setState( GstState.PLAYING );
			source.setState( GstState.PLAYING );
			debug(1) Trace.formatln("Running.");
		}
		else
		{
			isPlaying = false;
			source.setState( GstState.PAUSED );
		}
	}
	
	void fullStop()
	{
		if( source !is null )
			source.setState( GstState.NULL );
		isPlaying = false;
	}
	
	void onSeekToStart(Button button)
	{
		//source.seek( 5 * GST_SECOND );//seek to 5 seconds.
		source.seek( 0 );//seek to start.
	}

	void onOpen(Button button)
	{
		runImportMaterialFileChooser();
	}
	
	void onQuit(Button button)
	{
		fullStop();
		Main.quit();
	}
	
	void onAspectComboBoxChanged( ComboBox combo )
	{
		char[] asp = combo.getActiveText();
		if( asp == "16:9" )
			monitorAspectFrame.set( 0.5, 0.5, 16.0/9.0, false );
		else //if( asp == "4:3" )
			monitorAspectFrame.set( 0.5, 0.5, 4.0/3.0, false );
			
	}
	
	void runImportMaterialFileChooser()
	{
		char[][] a;
		ResponseType[] r;
		a ~= "Play file";
		a ~= "Close";
		r ~= ResponseType.GTK_RESPONSE_APPLY;//GTK_RESPONSE_OK;
		r ~= ResponseType.GTK_RESPONSE_CANCEL;
		if ( importMaterialFileChooserDialog  is  null )
		{
			importMaterialFileChooserDialog = new FileChooserDialog("Play mediafile", this, FileChooserAction.OPEN, a, r);
		}
		
		if( importMaterialFileChooserDialog.run() != ResponseType.GTK_RESPONSE_CANCEL )
		{
			//mediaFileUri = importMaterialFileChooserDialog.getFilename();
			mediaFileUri = importMaterialFileChooserDialog.getUri();
			
			Trace.formatln( "file selected: {}", mediaFileUri );
			playMediaFile(mediaFileUri);
		}
		
		importMaterialFileChooserDialog.hide();
	}
	
protected:

	char[] mediaFileUri = "";

	Element source, videosink;
	
	VBox vbox;
	HBox buttonsHBox;
	Button openButton;
	Button playButton;
	bool isPlaying(bool set)
	{
		m_isPlaying = set;
		/*
		//For some reason enabling this change of playButton
		//label, from Play to Pause, will cause the XOverlay
		//not to show the picture while we're on Pause.
		//That's why it's disabled. XOverlay just doesn't work
		//properly...
		if( playButton !is null )
		{
			if( m_isPlaying == true )
			{
				playButton.setLabel("Pause");
			}
			else
			{
				playButton.setLabel("Play");
			}
		}
		*/
		return m_isPlaying;
	}
	bool isPlaying() { return m_isPlaying; }
	bool m_isPlaying = false;
	
	ComboBox aspectComboBox;
	Button quitButton;
	
	MonitorOverlay monitorOverlay;
	AspectFrame monitorAspectFrame;
	
	FileChooserDialog importMaterialFileChooserDialog;
}


int main(char[][] args)
{
	Trace.formatln("gstreamerD GstMediaPlayer");

	uint major, minor, micro, nano;

	Trace.formatln("Trying to init...");

	Main.init(args);
	GStreamer.init(args);

	Trace.formatln("Checking version of GStreamer...");
	GStreamer.versio(&major, &minor, &micro, &nano);
	Trace.formatln("The installed version of GStreamer is {}.{}.{}", major, minor, micro );

	GstMediaPlayer gstMediaPlayer = new GstMediaPlayer(args);

	//We must use the gtkD mainloop to run gstreamerD apps.
	Main.run();

	return 0;
}


