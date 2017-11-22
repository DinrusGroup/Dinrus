/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Mar 2004 : Initial release
        version:        Dec 2006 : South Pacific release
        
        author:         Kris

*******************************************************************************/

module net.DatagramConduit;

public  import  io.device.Conduit;

package import  net.Socket,
                net.SocketConduit;

/*******************************************************************************
        
        Datagrams provопрe a low-overhead, non-reliable данные transmission
        mechanism.

        Datagrams are not 'подключен' in the same manner as a ПУТ сокет; you
        don't need куда слушай() or прими() куда принять a datagram, и данные
        may arrive из_ multИПle sources. A datagram сокет may, however,
        still use the подключись() метод like a ПУТ сокет. When подключен,
        the читай() и пиши() methods will be restricted куда a single адрес
        rather than being открой instead. That is, applying подключись() will сделай
        the адрес аргумент куда Всё читай() и пиши() irrelevant. Without
        подключись(), метод пиши() must be supplied with an адрес и метод
        читай() should be supplied with one куда опрentify where данные originated.
        
        Note that when использован as a listener, you must первый вяжи the сокет
        куда a local адаптер. This can be achieved by binding the сокет куда
        an АдресИнтернета constructed with a порт only (АДР_ЛЮБОЙ), thus
        requesting the OS куда присвой the адрес of a local network адаптер

*******************************************************************************/

class ДатаграммПровод : СокетПровод
{
        /***********************************************************************
        
                Созд a читай/пиши datagram сокет

        ***********************************************************************/

        this ()
        {
                super (ПСемействоАдресов.ИНЕТ, ПТипСок.ДГрамма, ППротокол.ИП);
        }

        /***********************************************************************

                Populate the provопрed Массив из_ the сокет. This will stall
                until some данные is available, or a таймаут occurs. We assume 
                the datagram имеется been подключен.

                Returns the число of байты читай куда the вывод, or Кф if
                the сокет cannot читай

        ***********************************************************************/

        override т_мера читай (проц[] ист)
        {
                return читай (ист, пусто);
        }

        /***********************************************************************
        
                Чит байты из_ an available datagram преобр_в the given Массив.
                When provопрed, the 'из_' адрес will be populated with the
                origin of the incoming данные. Note that we employ the таймаут
                mechanics exposed via our СокетПровод superclass. 

                Returns the число of байты читай из_ the ввод, or Кф if
                the сокет cannot читай

        ***********************************************************************/

        т_мера читай (проц[] приёмн, Адрес из_)
        {
                т_мера читатель (проц[] приёмн)
                {
                        return (приёмн.length) ? (из_ ? сокет.принять_от(приёмн, из_) : сокет.принять_от(приёмн)) : 0;
                }

                return super.читай (приёмн, &читатель);
        }

        /***********************************************************************

                Зап the provопрed контент куда the сокет. This will stall
                until the сокет responds in some manner. We assume the 
                datagram имеется been подключен.

                Returns the число of байты sent куда the вывод, or Кф if
                the сокет cannot пиши

        ***********************************************************************/

        override т_мера пиши (проц[] ист)
        {
                return пиши (ист, пусто);
        }

        /***********************************************************************
        
                Зап an Массив куда the specified адрес. If адрес 'куда' is
                пусто, it is assumed the сокет имеется been подключен instead.

                Returns the число of байты sent куда the вывод, or Кф if
                the сокет cannot пиши

        ***********************************************************************/

        т_мера пиши (проц[] ист, Адрес куда)
        {
                цел счёт = Кф;
                
                if (ист.length)
                   {
                   счёт = (куда) ? сокет.отправь_на(ист, куда) : сокет.отправь_на(ист);
                   if (счёт <= 0)
                       счёт = Кф;
                   }
                return счёт;
        }
}



/******************************************************************************

*******************************************************************************/

debug (Dgram)
{
        import io.Console;

        import net.InternetAddress;

        проц main()
        {
                auto адр = new АдресИнтернета ("127.0.0.1", 8080);

                // слушай for datagrams on the local адрес
                auto gram = new ДатаграммПровод;
                gram.вяжи (cast(Адрес) адр);

                // пиши куда the local адрес
                gram.пиши ("hello", cast(Адрес) адр);

                // we are listening also ...
                сим[8] врем;
                auto x = new АдресИнтернета;
                auto байты = gram.читай (врем, cast(Адрес) x);
                Квывод (x) (врем[0..байты]).нс;
        }
}
