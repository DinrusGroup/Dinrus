module mailform;
import os.win.gui.all;


class ПочтоваяФорма: os.win.gui.form.Form
{

private import os.win.com.core, os.win.com.client;
	// Do not modify or move this block of variables.
	//~Entice Designer variables begin here.
	os.win.gui.label.Label label1;
	os.win.gui.textbox.TextBox textBox1;
	os.win.gui.label.Label label2;
	os.win.gui.textbox.TextBox textBox2;
	os.win.gui.label.Label label3;
	os.win.gui.textbox.TextBox textBox3;
	os.win.gui.richtextbox.RichTextBox richTextBox1;
	os.win.gui.label.Label label4;
	//~Entice Designer variables end here.
	
	
	this()
	{
		initializeПочтоваяФорма();
		
		//@  Other ПочтоваяФорма initialization код here.
		
	}
	
	
	private проц initializeПочтоваяФорма()
	{
		// Do not manually modify this function.
		//~Entice Designer 0.8.5.02 код begins here.
		//~DFL Form
		text = "Электронное Сообщение";
		clientSize = Size(520, 454);
		//~DFL os.win.gui.label.Label=label1
		label1 = new os.win.gui.label.Label();
		label1.name = "label1";
		label1.backColor = Color(0, 255, 64);
		label1.font = new Font("Microsoft Sans Serif", 12f, cast(FontStyle)(FontStyle.BOLD | FontStyle.ITALIC));
		label1.text = "Тема";
		label1.bounds = Rect(16, 16, 60, 23);
		label1.parent = this;
		//~DFL os.win.gui.textbox.TextBox=textBox1
		textBox1 = new os.win.gui.textbox.TextBox();
		textBox1.name = "textBox1";
		textBox1.text = "Введите здесь тему сообщения";
		textBox1.bounds = Rect(96, 16, 392, 23);
		textBox1.parent = this;
		//~DFL os.win.gui.label.Label=label2
		label2 = new os.win.gui.label.Label();
		label2.name = "label2";
		label2.backColor = Color(0, 255, 64);
		label2.font = new Font("Microsoft Sans Serif", 12f, cast(FontStyle)(FontStyle.BOLD | FontStyle.ITALIC));
		label2.text = "От кого";
		label2.bounds = Rect(16, 48, 100, 23);
		label2.parent = this;
		//~DFL os.win.gui.textbox.TextBox=textBox2
		textBox2 = new os.win.gui.textbox.TextBox();
		textBox2.name = "textBox2";
		textBox2.text = "vit_klich@list.ru";
		textBox2.bounds = Rect(128, 48, 280, 24);
		textBox2.parent = this;
		//~DFL os.win.gui.label.Label=label3
		label3 = new os.win.gui.label.Label();
		label3.name = "label3";
		label3.backColor = Color(0, 255, 64);
		label3.font = new Font("Microsoft Sans Serif", 12f, cast(FontStyle)(FontStyle.BOLD | FontStyle.ITALIC));
		label3.text = "Кому";
		label3.bounds = Rect(16, 80, 100, 23);
		label3.parent = this;
		//~DFL os.win.gui.textbox.TextBox=textBox3
		textBox3 = new os.win.gui.textbox.TextBox();
		textBox3.name = "textBox3";
		textBox3.text = "Введите здесь e_mail получателя";
		textBox3.bounds = Rect(128, 80, 280, 24);
		textBox3.parent = this;
		//~DFL os.win.gui.richtextbox.RichTextBox=richTextBox1
		richTextBox1 = new os.win.gui.richtextbox.RichTextBox();
		richTextBox1.name = "richTextBox1";
		richTextBox1.text = "Текст сообщения:";
		richTextBox1.bounds = Rect(8, 152, 496, 296);
		richTextBox1.parent = this;
		//~DFL os.win.gui.label.Label=label4
		label4 = new os.win.gui.label.Label();
		label4.name = "label4";
		label4.backColor = Color(0, 255, 255);
		label4.font = new Font("Microsoft Sans Serif", 12f, cast(FontStyle)(FontStyle.BOLD | FontStyle.ITALIC));
		label4.text = "Сообщение";
		label4.useMnemonic = нет;
		label4.bounds = Rect(216, 120, 100, 23);
		label4.parent = this;
		//~Entice Designer 0.8.5.02 код ends here.
		Button sendButton;
		with(sendButton = new Button)
		{
			sendButton.name = "sendButton";
			sendButton.text = "Отправить";
			sendButton.bounds = Rect(32, 120, 75, 23);
			sendButton.parent = this;			
			click ~= &this.send;
		}
	}

private проц send(Object sender, EventArgs ea)
	{
	this.sendMessage();
	}

цел sendMessage(){
	if(textBox3.text == ""){
		ОкноСооб( null, "Введите адрес получателя!", "Ошибка", ПСооб.Ок|ПСооб.Стоп);
		return 0;
		}
	if(textBox1.text == ""){
		ОкноСооб( null, "Введите тему сообщения!", "Ошибка", ПСооб.Ок|ПСооб.Стоп);
		return 0;
		}
	// Create an instance of the Message object
	 scope сообщение = new ОбъектДепеша("CDO.Message");

	 // Build the mail сообщение
	 сообщение.установи("Subject", textBox1.text);
	 сообщение.установи("TextBody", richTextBox1.text);
	 сообщение.установи("From", textBox2.text); // Replace 'me@home.com' with your email address
	 сообщение.установи("To", textBox3.text); // Replace 'world@large.com' with the recipient'т email address

	 // Configure CDOSYS to send via a remote SMTP server
	 scope config = сообщение.дай("Configuration");
	 // Set the appropriate значues
	 config.установи("Fields", "http://schemas.microsoft.com/cdo/configuration/sendusing", 2); // cdoSendUsingPort = 2
	 config.установи("Fields", "http://schemas.microsoft.com/cdo/configuration/smtpserverport", 25);
	 config.установи("Fields", "http://schemas.microsoft.com/cdo/configuration/smtpserver", "smtp.list.ru"); // Replace 'mail.remote.com' with your remote server'т address
	 config.установи("Fields", "http://schemas.microsoft.com/cdo/configuration/smtpauthenticate", 1); // cdoBasic = 1
	 config.установи("Fields", "http://schemas.microsoft.com/cdo/configuration/sendusername", textBox2.text); // Replace 'username' with your account'т user name
	 config.установи("Fields", "http://schemas.microsoft.com/cdo/configuration/sendpassword", "friday"); // Replace 'password' with your account'т password

	 scope fields = config.дай("Fields");
	 fields.вызови("Update");

	 сообщение.вызови("Send");
	 ОкноСооб( null, "Сообщение отправлено!", "Инфо", ПСооб.Ок|ПСооб.Рука);
	 return 0;
 }
}

export цел почтоваяФорма()
{
	цел результат = 0;
	
	try
	{
		Application.enableVisualStyles();
		
		//@  Other application initialization код here.
		
		Application.пуск(new ПочтоваяФорма());
	}
	catch(Object o)
	{
		msgBox(o.toString(), "Fatal Error", MsgBoxButtons.OK, MsgBoxIcon.ERROR);
		
		результат = 1;
	}
	
	return результат;
}

