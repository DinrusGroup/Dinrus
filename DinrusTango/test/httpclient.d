import io.Stdout;
import net.http.HttpClient;

//import io.device.Array;
import net.http.HttpConst;

void main()
        {

        // обрвызов for клиент читатель
        проц сток (проц[] контент)
        {
                Стдвыв (cast(ткст) контент);
        }


        // создай клиент for a GET request
        auto клиент = new КлиентППГТ (КлиентППГТ.Get, "http://www.google.com");

        // сделай request
        клиент.открой;

        // проверь return статус for validity
        if (клиент.ответОК_ли)
           {
           // display все returned заголовки
           foreach (заголовок; клиент.дайЗаголовкиОтвета)
                    Стдвыв.форматнс ("{} {}", заголовок.имя.значение, заголовок.значение);
        
           // выкинь контент length
		   auto обзор = клиент.дайЗаголовкиОтвета;
           auto length = обзор.получиЦел (ЗаголовокППГТ.ДлинаКонтента);
        
           // display остаток контент
           клиент.читай (&сток, length);
           }
        else
           Стдош (клиент.дайОтвет);

        клиент.закрой;
        }