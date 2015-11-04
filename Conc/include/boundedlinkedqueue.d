module conc.boundedlinkedqueue;

import cidrus, conc.channel;
import conc.boundedchannel;
import conc.defaultchannelcapacity;
import conc.linkednode;
import conc.sync;
import conc.waitnotify;

class ОграниченнаяЛинкованнаяОчередь(T) : ОбъектЖдиУведомиВсех, ОграниченныйКанал!(T), Канал!(T)
 {


	protected alias ЛинкованныйУзел!(T) тип_узла;
	protected тип_узла голова_;
	protected тип_узла последний_;
	protected final Объект стражПомещения_;
	protected final ОбъектЖдиУведомиВсех стражВзятия_;
	protected цел ёмкость_;
	protected цел putSidePutPermits_; 
	protected цел takeSidePutPermits_ = 0;

	public this(цел ёмкость);
	public this() ;
	protected final цел reconcilePutPermits() ;
	public synchronized цел ёмкость() ;
	public synchronized цел размер() ;
	public проц установиЁмкость(цел новаяЁмкость);

	protected synchronized T извлеки() {
		synchronized(голова_) {
			T x = пусто;
			тип_узла первое = голова_.следщ;
			if (первое !is пусто) {
				x = первое.значение;
				первое.значение = пусто;
				голова_ = первое; 
				++takeSidePutPermits_;
				// TODO: this should be a уведоми() but a dual уведоми/уведомиВсех
				// needs to be implemented on win32 первое
				уведомиВсех();
			}
			return x;
		}
	}

	public T подбери() {
		synchronized(голова_) {
			тип_узла первое = голова_.следщ;
			if (первое !is пусто) 
				return первое.значение;
			else
				return пусто;
		}
	}

	public T возьми() {
		T x = извлеки();
		if (x !is пусто) 
			return x;
		else {
			synchronized(стражВзятия_) {
				for (;;) {
					x = извлеки();
					if (x !is пусто) {
						return x;
					}
					else {
						стражВзятия_.жди(); 
					}
				}
			}
		}
	}

	public T запроси(дол мсек)
		in {
			assert(мсек >= 0);
		} body {
			T x = извлеки();
			if (x !is пусто) 
				return x;
			else {
				synchronized(стражВзятия_) {
					дол времяОжидания = мсек;
					дол старт = (мсек <= 0)? 0: clock();
					for (;;) {
						x = извлеки();
						if (x !is пусто || времяОжидания <= 0) {
							return x;
						}
						else {
							стражВзятия_.жди(времяОжидания); 
							времяОжидания = мсек - (clock() - старт);
						}
					}
				}
			}
		}

	protected final проц разрешиВзять() ;

	protected проц вставь(T x)
		in {
			assert(x !is пусто);
		} body { 
			--putSidePutPermits_;
			тип_узла p = new тип_узла(x);
			synchronized(последний_) {
				последний_.следщ = p;
				последний_ = p;
			}
		}


	public проц помести(T x)
		in {
			assert(x !is пусто);
		} body {
			synchronized(стражПомещения_) {
				if (putSidePutPermits_ <= 0) { // жди for permit. 
					synchronized(this) {
						if (reconcilePutPermits() <= 0) {
							try
							{
								for(;;) {
									жди();
									if (reconcilePutPermits() > 0) {
										break;
									}
								}
							} catch (ИсклОжидания искл) {
								уведомиВсех();
								throw искл;
							}
						}
					}
				}
				вставь(x);
			}
			// call outside of замок to loosen помести/возьми coupling
			разрешиВзять();
		}

	public бул предложи(T x, дол мсек) 
		in
		{
			assert(x !is пусто);
			assert(мсек >= 0);
		} body {
			synchronized(стражПомещения_) {

				if (putSidePutPermits_ <= 0) {
					synchronized(this) {
						if (reconcilePutPermits() <= 0) {
							if (мсек <= 0)
								return нет;
							else {
								try
								{
									дол времяОжидания = мсек;
									дол старт = clock();

									for(;;) {
										жди(времяОжидания);
										if (reconcilePutPermits() > 0) {
											break;
										}
										else {
											времяОжидания = мсек - (clock() - старт);
											if (времяОжидания <= 0) {
												return нет;
											}
										}
									}
								} catch (ИсклОжидания искл) {
								  уведомиВсех();
									throw искл;
								}
							}
						}
					}
				}

				вставь(x);
			}

			разрешиВзять();
			return да;
		}

	public бул пуст_ли() ; 
}
