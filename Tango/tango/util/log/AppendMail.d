﻿/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)
      
        version:        Initial release: May 2004
        
        author:         Kris

*******************************************************************************/

module util.log.AppendMail;

private import  util.log.Log;

private import  io.stream.Buffered;

private import  net.device.Socket,
                net.InternetAddress;

/*******************************************************************************

        Добавщик for Отправкаing formatted вывод в_ a Mail сервер. Thanks
        в_ BCS for posting как в_ do this.

*******************************************************************************/

public class ДобВПочту : Добавщик
{
        private ткст          в_,
                                из_,
                                subj;
        private маска            mask_;
        private АдресИнтернета сервер;

        /***********************************************************************
                
                Create with the given выкладка and сервер адрес

        ***********************************************************************/

        this (АдресИнтернета сервер, ткст из_, ткст в_, ткст subj, Добавщик.Выкладка как = пусто)
        {
                выкладка (как);

                this.в_ = в_;
                this.из_ = из_;
                this.subj = subj;
                this.сервер = сервер;

                // Get a unique fingerprint for this добавщик
                mask_ = регистрируй (в_ ~ subj);
        }

        /***********************************************************************
                
                Отправка an событие в_ the mail сервер
                 
        ***********************************************************************/

        final synchronized проц добавь (СобытиеЛога событие)
        {
                auto провод = new Сокет;
                scope (exit)
                       провод.закрой;

                провод.подключись (сервер);
                auto излей = new Бвыв (провод);

                излей.добавь ("HELO Неук@anon.org\r\nMAIL FROM:<") 
                    .добавь (из_) 
                    .добавь (">\r\nRCPT TO:<") 
                    .добавь (в_) 
                    .добавь (">\r\nDATA\r\nSubject: ") 
                    .добавь (subj) 
                    .добавь ("\r\nContent-Type: text/plain; charset=us-аски\r\n\r\n");
                
                выкладка.форматируй (событие, &излей.пиши);
                излей.добавь ("\r\n.\r\nQUIT\r\n");
                излей.слей;
        }

        /***********************************************************************
                
                Возвращает фингерпринт для данного класса

        ***********************************************************************/

        final Маска маска ()
        {
                return mask_;
        }

        /***********************************************************************
                
                Вернуть имя данного класса

        ***********************************************************************/

        final ткст имя ()
        {
                return this.classinfo.имя;
        }
}
