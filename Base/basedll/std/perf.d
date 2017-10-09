module std.perf;


scope
 class МасштабСчётчикаПроизводительности(T)
{
    public:
	this(T счётчик)
	in
	{
	    assert(null !is счётчик);
	}
	body
	{
	    м_счётчик = счётчик;

	    м_счётчик.старт();
	}
	~this()	{	    м_счётчик.стоп();	}
	проц стоп()	{ м_счётчик.стоп();}
	T счётчик()	{	    return м_счётчик;	}
    private:
	T   м_счётчик;

    private:
	this(МасштабСчётчикаПроизводительности rhs);
}


 export extern (D)
  class СчётчикВысокойПроизводительности
 {

    private:
	alias   дол    epoch_type;
    public:

	alias   дол    т_интервал;
	alias МасштабСчётчикаПроизводительности!(СчётчикВысокойПроизводительности)  scope_type;

    export:
	static this()
	{
	    if(!ОпросиЧастотуПроизводительности(&sm_freq))
	    {
		sm_freq = 0x7fffffffffffffffL;
	    }
	}

	проц старт()
		{
			    ОпросиСчётчикПроизводительности(&m_start);	
			}

	проц стоп()
		{	
		    ОпросиСчётчикПроизводительности(&m_end);	
		}

	т_интервал счётПериодов()
	{
	 return m_end - m_start;
		}

	т_интервал секунды()
		{	
		    return счётПериодов() / sm_freq;
		    	}

	т_интервал миллисекунды()
	{
	    т_интервал   результат;
	    т_интервал   count   =   счётПериодов();

	    if(count < 0x20C49BA5E353F7L)
	    {
		результат = (count * 1000) / sm_freq;
	    }
	    else
	    {
		результат = (count / sm_freq) * 1000;
	    }

	    return результат;
	}

	т_интервал микросекунды()
	{
	    т_интервал   результат;
	    т_интервал   count   =   счётПериодов();

	    if(count < 0x8637BD05AF6L)
	    {
		результат = (count * 1000000) / sm_freq;
	    }
	    else
	    {
		результат = (count / sm_freq) * 1000000;
	    }

	    return результат;
	}

    private:
	epoch_type              m_start;    // старт of measurement период
	epoch_type              m_end;      // End of measurement период
	static т_интервал    sm_freq;    // Frequency

 }

 export extern (D) 
 class СчётчикТиков
    {

    private:
	alias   дол    epoch_type;
    export:

	alias   дол    т_интервал;

	alias МасштабСчётчикаПроизводительности!(СчётчикТиков) scope_type;
    export:

    export:

	проц старт()
		{	
		    m_start = win.ДайСчётТиков();
		    	}
	проц стоп()
		{	
		    m_end = win.ДайСчётТиков();
		    	}

    export:

	т_интервал счётПериодов()
		{	
		    return m_end - m_start;
		    	}

	т_интервал секунды()
		{	
		    return счётПериодов() / 1000;
		    	}

	т_интервал миллисекунды()
		{	 
		   return счётПериодов();
		   	}

	т_интервал микросекунды()
		{	
		    return счётПериодов() * 1000;	
		}

    private:
	бцел    m_start;    // старт of measurement период
	бцел    m_end;      // End of measurement период
    /// @}
    }

export extern (D) 
class СчётчикВремениНити
    {

    private:
	alias   дол    epoch_type;
    export:

	alias   дол    т_интервал;
	alias МасштабСчётчикаПроизводительности!(СчётчикВремениНити)  scope_type;

    export:

	this(){	    m_thread = ДайТекущуюНить();	}


	проц старт()
	{
	    ФВРЕМЯ    creationTime;
	    ФВРЕМЯ    exitTime;

	    ДайВременаНити(m_thread, &creationTime, &exitTime, cast(ФВРЕМЯ*)&m_kernelStart, cast(ФВРЕМЯ*)&m_userStart);
	}

	проц стоп()
	{
	    ФВРЕМЯ    creationTime;
	    ФВРЕМЯ    exitTime;

	    ДайВременаНити(m_thread, &creationTime, &exitTime, cast(ФВРЕМЯ*)&m_kernelEnd, cast(ФВРЕМЯ*)&m_userEnd);
	}

    export:

	т_интервал счётПериодаЯдра()
		{	
		    return m_kernelEnd - m_kernelStart;	
		}

	т_интервал секундыЯдра()
		{
			    return счётПериодаЯдра() / 10000000;
			    	}

	т_интервал миллисекундыЯдра()
		{	    return счётПериодаЯдра() / 10000;	}

	т_интервал микросекундыЯдра()
		{	    return счётПериодаЯдра() / 10;	}

	т_интервал счётПользовательскогоПериода()
		{	    return m_userEnd - m_userStart;	}

	т_интервал секундыПользователя()
		{	    return счётПользовательскогоПериода() / 10000000;	}

	т_интервал миллисекундыПользователя()
		{	    return счётПользовательскогоПериода() / 10000;	}

	т_интервал микросекундыПользователя()
		{	    return счётПользовательскогоПериода() / 10;	}

	т_интервал счётПериодов()
		{	    return счётПериодаЯдра() + счётПользовательскогоПериода();	}

	т_интервал секунды()
		{	    return счётПериодов() / 10000000;	}

	т_интервал миллисекунды()
		{	    return счётПериодов() / 10000;	}

	т_интервал микросекунды()
		{	    return счётПериодов() / 10;	}

    private:
	epoch_type  m_kernelStart;
	epoch_type  m_kernelEnd;
	epoch_type  m_userStart;
	epoch_type  m_userEnd;
	ук      m_thread;

    }


export extern (D) 
class СчётчикВремениПроцесса
    {
    private:
	alias   дол    epoch_type;
    export:
	alias   дол    т_интервал;
	alias МасштабСчётчикаПроизводительности!(СчётчикВремениПроцесса) scope_type;

	static this()
	{
	    sm_process = ДайТекущийПроцесс();
	}

    export:

	проц старт()
	{
	    ФВРЕМЯ    creationTime;
	    ФВРЕМЯ    exitTime;

	    ДайВременаПроцесса(sm_process, &creationTime, &exitTime, cast(ФВРЕМЯ*)&m_kernelStart, cast(ФВРЕМЯ*)&m_userStart);
	}

	проц стоп()
	{
	    ФВРЕМЯ    creationTime;
	    ФВРЕМЯ    exitTime;

	    ДайВременаПроцесса(sm_process, &creationTime, &exitTime, cast(ФВРЕМЯ*)&m_kernelEnd, cast(ФВРЕМЯ*)&m_userEnd);
	}

    export:

	т_интервал счётПериодаЯдра()
		{	    return m_kernelEnd - m_kernelStart;	}

	т_интервал секундыЯдра()
		{	    return счётПериодаЯдра() / 10000000;	}

	т_интервал миллисекундыЯдра()
		{	    return счётПериодаЯдра() / 10000;	}

	т_интервал микросекундыЯдра()
		{	    return счётПериодаЯдра() / 10;	}

	т_интервал счётПользовательскогоПериода()
		{	    return m_userEnd - m_userStart;	}

	т_интервал секундыПользователя()
		{	    return счётПользовательскогоПериода() / 10000000;	}

	т_интервал миллисекундыПользователя()
		{	    return счётПользовательскогоПериода() / 10000;	}

	т_интервал микросекундыПользователя()
		{	    return счётПользовательскогоПериода() / 10;	}

	т_интервал счётПериодов()
		{	    return счётПериодаЯдра() + счётПользовательскогоПериода();	}

	т_интервал секунды()
		{	    return счётПериодов() / 10000000;	}

	т_интервал миллисекунды()
		{	    return счётПериодов() / 10000;	}

	т_интервал микросекунды()
		{	    return счётПериодов() / 10;	}

    private:
	epoch_type      m_kernelStart;
	epoch_type      m_kernelEnd;
	epoch_type      m_userStart;
	epoch_type      m_userEnd;
	static ук   sm_process;
    }