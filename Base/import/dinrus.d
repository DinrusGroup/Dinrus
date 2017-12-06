module dinrus;

/** Динамическая версия русского диалекта языка программирования Ди.
**********************************************************
ПРОЕКТ "ДИНРУС"

Идея данного проекта заключается в создании универсального
языка программирования на основе языка D, разрабатываемого
американской компанией Digital Mars.

Автором языка D является Уолтер Брайт (Walter Bright), известный
 как разработчик серии компиляторов языка C для компании Simantec (SC).
Опыт Брайта по созданию компиляторов выразился в намерении
создать новый, более мощный язык системного программирования.

Брайт создал две версии компилятора DMD.

Проект Динрус рассчитан на использование первой из них (v 1.065).

Динрус основан на собственной переработанной версии рантайма,
 в которой основные элементы библиотеки существенно отличаются, и
несовместимы с другими версиями.

Задача Динрус - обеспечить возможность одновременного
программирования как на английском, так и на русском языках.

Русский язык является основным приоритетом.

Дальнейшая переработка системных библиотек позволит обеспечить
быстрое и доступное системное программирование на родном
(русском) языке.

 Автор и Разработчик : Виталий Кулич
***************************************/
//=====================================================================
/**************************
Конфигурационный файл основной библиотеки языка программирования Динрус.
Целевое назначение: сообщать системе о том, где располагаются перечни
констант, структур, функций и других операционных элементов для той или
иной системы, в зависимости от вида трансляции и вида системных устройств
и самой ОС(если ОС = Windows, ОС = Linux и т.п.)

Это единственный файл, который импортируется модулем object.
Так как указанный модуль содержит важные сведения о типах языка и загружается
компилятором ранее других, данные системные настройки становятся общими для
всех модулей языка и поэтому отпадает необходимость переопределения констант
или структур в явном виде, либо в затруднительном поиске таковых по всем модулям.

Кроме того, этим обеспечивается главная цель: единство языковых определений и
отсутствие захламляющих языковую среду переопределений одних и тех же элементов.
Таким образом, язык становится более прогрессивным в плане чистоты, качества,
единства и скорости своего развития.

Так как язык Динрус в своём будущем нацелен на портируемость и компактность,
в нём предусмотрена конфигурационная версиональность, обеспечиваемая статическими
если(static if) и переключателями версии (version). Главные определения и переключатели
должны всегда располагаться в этом модуле.

Пакеты для той или иной системы могут распространятся отдельно или добавляться в
последующем; они должны так же строго структурироваться и содержать такие же
основные модули, как в данном случае, предназначенном для ОС i386 (Windows).

Конфигурированные здесь настройки могут включаться при импорте тех или иных модулей,
например, когда импортируется модуль sys.com, он устанавливает version = ОМО.
Так как он импортирует dinrus, то с импортом модуля sys.com или с установкой версии ОМО
автоматически происходит активация и подключение (инициализация) к системным
библиотекам, и программисту более не требуется об этом заботиться вообще.

Одним словом, вам остаётся лишь выбрать здесь версию и написать version = X в вашем файле,
ознакомиться с тем, что предоставляется данной версией, чтобы ... продолжить
развитие данного языка или написать соответствующий модуль для своей собственной
программы.
*************************/
version = Dinrus;

public import object,
       gc,
//base,
       //В этом модуле находятся важнейшие настройки для языка Динрус:
       //например, определения основных глобальных типов или
       //список импортируемых языковой средой функций и классов.
       sync, thread, stdrus, tpl.all, runtime, exception, global, win;
/+
Модуль win содержит открытый доступ к модулям:

sys.WinConsts,
//В этом модуле: константы (их перчни) для API ОС.
sys.uuid,
sys.WinIfaces,
//Интерфейсы API данной операционной системы.
sys.WinStructs,
//Здесь искать: структуры API для данной системы.
sys.WinFuncs;
//Здесь: функции и процедуры, предоставляемые API ОС.

Кроме того, в нём находятся основные рычаги управления консольным вводом-выводом.
+/

/*********************************************************************
Модуль cidrus содержит руссифицированный интерфейс к функциям языка Си,
которые переработаны в модуле stdrus и других под Динрус.
При использовании этого модуля появляются накладки.
**********************************************************************/
version(PlusC)
{
    public import cidrus;
}

version(COM)//ОБЩАЯ МОДЕЛЬ ОБЪЕКТА (COM)
{
    public import com;
}


