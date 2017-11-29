module conc.prioritysemaphore;

import conc.queuedsemaphore,conc.fifosemaphore;
private import conc.waitnotify;


class СемафорПриоритетов : СемафорВОчереди
 {

  this(дол начальныеПрава);

			  protected class ЖдущаяПриоритетаОчередь : ЖдущаяОчередь
			  {

				protected final СемафорПВПВ.ЖдущаяОчередьФИФО[] Ячейки_ =
				  new СемафорПВПВ.ЖдущаяОчередьФИФО[Нить.МАКСПРИОР -
												 Нить.МИНПРИОР + 1];

				protected цел максИндекс_ = -1;

				protected this();
				protected проц вставь(ЖдущийУзел w);
				protected ЖдущийУзел извлеки();
			  }

}
