
module drc.lexer.ключwords;

import drc.lexer.Token,
       drc.lexer.Identifier;

/// Таблица резервированных идентификаторов.
static const Идентификатор[] g_reservedIds = [
  {"abstract", TOK.Абстрактный},
  {"абстрактный", TOK.Абстрактный},
  {"alias", TOK.Алиас},
  {"иной", TOK.Алиас},
  {"align", TOK.Расклад},
  {"расклад", TOK.Расклад},
  {"asm", TOK.Асм},
  {"асм", TOK.Асм},
  {"assert", TOK.Подтвердить},
  {"подтверди", TOK.Подтвердить},
  {"auto", TOK.Авто},
  {"авто", TOK.Авто},
  {"body", TOK.Тело},
  {"тело", TOK.Тело},
  {"bool", TOK.Бул},
  {"бул", TOK.Бул},
  {"break", TOK.Всё},
  {"всё", TOK.Всё},
  {"byte", TOK.Байт},
  {"байт", TOK.Байт},
  {"case", TOK.Реле},
  {"реле", TOK.Реле},
  {"cast", TOK.Каст},
  {"catch", TOK.Кэтч},
  {"cdouble", TOK.Кдво},
  {"кдво", TOK.Кдво},
  {"cent", TOK.Цент},
  {"цент", TOK.Цент},
  {"cfloat", TOK.Кплав},
  {"кплав", TOK.Кплав},
  {"char", TOK.Сим},
  {"сим", TOK.Сим},
  {"class", TOK.Класс},
  {"класс", TOK.Класс},
  {"const", TOK.Конст},
  {"конст", TOK.Конст},
  {"continue", TOK.Далее},
  {"далее", TOK.Далее},
  {"creal", TOK.Креал},
  {"креал", TOK.Креал},
  {"dchar", TOK.Дим},
  {"дим", TOK.Дим},
  {"debug", TOK.Отладка},
  {"отладка", TOK.Отладка},
  {"default", TOK.Дефолт},
  {"дефолт", TOK.Дефолт},
  {"delegate", TOK.Делегат},
  {"делегат", TOK.Делегат},
  {"delete", TOK.Удалить},
  {"удали", TOK.Удалить},
  {"deprecated", TOK.Устаревший},
  {"устаревший", TOK.Устаревший},
  {"do", TOK.Делай},
  {"делай", TOK.Делай},
  {"double", TOK.Дво},
  {"дво", TOK.Дво},
  {"else", TOK.Иначе},
  {"иначе", TOK.Иначе},
  {"enum", TOK.Перечень},
  {"перечень", TOK.Перечень},
  {"export", TOK.Экспорт},
  {"экспорт", TOK.Экспорт},
  {"extern", TOK.Экстерн},
  {"экстерн", TOK.Экстерн},
  {"false", TOK.Ложь},
  {"нет", TOK.Ложь},
  {"final", TOK.Окончательный},
  {"окончательный", TOK.Окончательный},
  {"finally", TOK.Finally},
  {"наконец", TOK.Finally},
  {"float", TOK.Плав},
  {"плав", TOK.Плав},
  {"for", TOK.При},
  {"при", TOK.При},
  {"foreach", TOK.Длявсех},
  {"длявсех", TOK.Длявсех},
  {"foreach_reverse", TOK.Длявсех_реверс},
  {"длявсехрев", TOK.Длявсех_реверс},
  {"function", TOK.Функция},
  {"функ", TOK.Функция},
  {"goto", TOK.Переход},
  {"переход_на", TOK.Переход},
  {"idouble", TOK.Вдво},
  {"вдво", TOK.Вдво},
  {"if", TOK.Если},
  {"если", TOK.Если},
  {"ifloat", TOK.Вплав},
  {"вплав", TOK.Вплав},
  {"import", TOK.Импорт},
  {"импорт", TOK.Импорт},
  {"in", TOK.Вхо},
  {"вхо", TOK.Вхо},
  {"inout", TOK.Вховых},
  {"вховых", TOK.Вховых},
  {"int", TOK.Цел},
  {"цел", TOK.Цел},
  {"interface", TOK.Интерфейс},
  {"интерфейс", TOK.Интерфейс},
  {"invariant", TOK.Инвариант},
  {"инвариант", TOK.Инвариант},
  {"ireal", TOK.Вреал},
  {"вреал", TOK.Вреал},
  {"is", TOK.Является},
  {"есть", TOK.Является},
  {"lazy", TOK.Отложенный},
  {"отложеный", TOK.Отложенный},
  {"long", TOK.Дол},
  {"дол", TOK.Дол},
  {"macro", TOK.Макрос}, // D2.0
  {"макро", TOK.Макрос},
  {"mixin", TOK.Смесь},
  {"впиши", TOK.Смесь},
  {"module", TOK.Модуль},
  {"модуль", TOK.Модуль},
  {"new", TOK.Нов},
  {"нов", TOK.Нов},
  {"nothrow", TOK.Nothrow}, // D2.0
  {"null", TOK.Нуль},
  {"пусто", TOK.Нуль},
  {"out", TOK.Вых},
  {"вых", TOK.Вых},
  {"override", TOK.Перепись},
  {"перепись", TOK.Перепись},
  {"package", TOK.Пакет},
  {"пакет", TOK.Пакет},
  {"pragma", TOK.Прагма},
  {"прагма", TOK.Прагма},
  {"private", TOK.Приватный},
  {"protected", TOK.Защищённый},
  {"public", TOK.Публичный},
  {"pure", TOK.Pure}, // D2.0
  {"real", TOK.Реал},
  {"реал", TOK.Реал},
  {"ref", TOK.Реф},
  {"return", TOK.Итог},
  {"итог", TOK.Итог},
  {"scope", TOK.Масштаб},
  {"short", TOK.Крат},
  {"крат", TOK.Крат},
  {"static", TOK.Статический},
  {"struct", TOK.Структура},
  {"структ", TOK.Структура},
  {"super", TOK.Супер},
  {"супер", TOK.Супер},
  {"switch", TOK.Щит},
  {"щит", TOK.Щит},
  {"synchronized", TOK.Синхронизованный},
  {"синхронно", TOK.Синхронизованный},
  {"template", TOK.Шаблон},
  {"шаблон", TOK.Шаблон},
  {"this", TOK.Этот},
  {"этот", TOK.Этот},
  {"throw", TOK.Брось},
  {"брось", TOK.Брось},
  {"__traits", TOK.Трэтс}, // D2.0
  {"true", TOK.Истина},
  {"да", TOK.Истина},
  {"try", TOK.Пробуй},
  {"пробуй", TOK.Пробуй},
  {"typedef", TOK.Типдеф},
  {"typeid", TOK.Идтипа},
  {"typeof", TOK.Типа},
  {"ubyte", TOK.Ббайт},
  {"ббайт", TOK.Ббайт},
  {"ucent", TOK.Бцент},
  {"бцент", TOK.Бцент},
  {"uint", TOK.Бцел},
  {"бцел", TOK.Бцел},
  {"ulong", TOK.Бдол},
  {"бдол", TOK.Бдол},
  {"union", TOK.Союз},
  {"союз", TOK.Союз},
  {"unittest", TOK.Юниттест},
  {"ushort", TOK.Бкрат},
  {"бкрат", TOK.Бкрат},
  {"version", TOK.Версия},
  {"версия", TOK.Версия},
  {"void", TOK.Проц},
  {"проц", TOK.Проц},
  {"volatile", TOK.Волатайл},
  {"wchar", TOK.Шим},
  {"шим", TOK.Шим},
  {"while", TOK.Пока},
  {"пока", TOK.Пока},
  {"with", TOK.Для},
  {"для", TOK.Для},
  // Специальные семы:
  {"__FILE__", TOK.ФАЙЛ},
  {"__ФАЙЛ__", TOK.ФАЙЛ},
  {"__LINE__", TOK.СТРОКА},
  {"__СТРОКА__", TOK.СТРОКА},
  {"__DATE__", TOK.ДАТА},
  {"__ДАТА__", TOK.ДАТА},
  {"__TIME__", TOK.ВРЕМЯ},
  {"__ВРЕМЯ__", TOK.ВРЕМЯ},
  {"__TIMESTAMP__", TOK.ШТАМПВРЕМЕНИ},
  {"__ШТАМПВРЕМЕНИ__", TOK.ШТАМПВРЕМЕНИ},
  {"__VENDOR__", TOK.ПОСТАВЩИК},
  {"__ПОСТАВЩИК__", TOK.ПОСТАВЩИК},
  {"__VERSION__", TOK.ВЕРСИЯ},
  {"__ВЕРСИЯ__", TOK.ВЕРСИЯ},
  {"__EOF__", TOK.КФ}, // D2.0
  {"__КФ__", TOK.КФ},
];
