/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: January 2006
        
        author:         Kris

*******************************************************************************/

module net.http.HttpPost;

public import   net.Uri;

private import  io.model;

private import  net.http.HttpClient,
                net.http.HttpHeaders;

/*******************************************************************************

        Supports the basic needs of a клиент Отправкаing POST requests в_ a
        HTTP сервер. The following is a usage example:

        ---
        // открой a web-страница for posting (see ГетППГТ for simple reading)
        auto post = new ПостППГТ ("http://yourhost/yourpath");

        // шли, retrieve and display ответ
        Квывод (cast(ткст) post.пиши("posted данные", "текст/plain"));
        ---

*******************************************************************************/

class ПостППГТ : КлиентППГТ
{      
        /***********************************************************************
        
                Create a клиент for the given URL. The аргумент should be
                fully qualified with an "http:" or "https:" scheme, or an
                explicit порт should be provопрed.

        ***********************************************************************/

        this (ткст url)
        {
                this (new Уир(url));
        }

        /***********************************************************************
        
                Create a клиент with the provопрed Уир экземпляр. The Уир should 
                be fully qualified with an "http:" or "https:" scheme, or an
                explicit порт should be provопрed. 

        ***********************************************************************/

        this (Уир уир)
        {
                super (КлиентППГТ.Post, уир);

                // enable заголовок duplication
                дайЗаголовкиОтвета.retain (да);
        }

        /***********************************************************************
        
                Отправка запрос params only

        ***********************************************************************/

        проц[] пиши ()
        {
                return пиши (пусто);
        }

        /***********************************************************************
        
                Отправка необр данные via the provопрed помпа, and no запрос 
                params. You have full control over заголовки and so 
                on via this метод.

        ***********************************************************************/

        проц[] пиши (Помпа помпа)
        {
                auto буфер = super.открой (помпа);
                try {
                    // check return статус for validity
                    auto статус = super.дайСтатус;
                    if (статус is КодОтветаППГТ.ОК || 
                        статус is КодОтветаППГТ.Создано || 
                        статус is КодОтветаППГТ.Принято)
                        буфер.загрузи (дайЗаголовкиОтвета.получиЦел (ЗаголовокППГТ.ДлинаКонтента));
                    } finally {закрой;}

                return буфер.срез;
        }

        /***********************************************************************
        
                Отправка контент and no запрос params. The contentLength заголовок
                will be установи в_ match the provопрed контент, and contentType
                установи в_ the given тип.

        ***********************************************************************/

        проц[] пиши (проц[] контент, ткст тип)
        {
                auto заголовки = super.дайЗаголовкиЗапроса;

                заголовки.добавь    (ЗаголовокППГТ.ТипКонтента, тип);
                заголовки.добавьInt (ЗаголовокППГТ.ДлинаКонтента, контент.length);
                
                return пиши ((БуферВывода b){b.добавь(контент);});
        }
}

