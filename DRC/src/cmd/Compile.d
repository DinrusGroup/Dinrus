/// Author: Aziz Köksal
/// License: GPL3
/// $(Maturity low)
module cmd.Compile;

import drc.semantic.Module,
       drc.semantic.Package,
       drc.semantic.Pass1,
       drc.semantic.Pass2,
       drc.semantic.Symbols;
import drc.doc.Doc;
import drc.Compilation;
import drc.Diagnostics;
import drc.ModuleManager;
import common;

/// Команда компилировать.
struct КомандаКомпилировать
{
  ткст[] путиКФайлам; /// Явно указанные модули (в командной строке.)
  бул вывестиДеревоСимволов = да; /// Выводить ли дерево символов.
  бул вывестиДеревоМодулей = да; /// Выводить ли дерево модулей.
  МодульМенеджер модульМен;
  СемантическаяПроходка1[] проходки1;

  КонтекстКомпиляции контекст;
  Диагностика диаг;

  /// Выполняет команду компилировать.
  проц  пуск()
  {
    модульМен = new МодульМенеджер(контекст.путиИмпорта, диаг);
    foreach (путьКФайлу; путиКФайлам)
    {
      auto модуль = модульМен.загрузиФайлМодуля(путьКФайлу);
      пускПроходки1(модуль);	  
      if (вывестиДеревоСимволов)
        выведиТаблицуСимволов(модуль, "");
    }

    // foreach (модуль; модульМен.загруженныеМодули)
    // {
    //   auto pass2 = new СемантическаяПроходка2(модуль);
    //   pass2.пуск();
    // }

    if (вывестиДеревоМодулей)
      выведиДеревоМ(модульМен.корневойПакет, "");
	  
	  выдай("Компиляция всё ещё невозможна.");
  }

  проц  выведиДеревоМ(Пакет пкт, ткст отступ)
  {
    выдай(отступ)(пкт.имяПкт)("/").нс;
    foreach (p; пкт.пакеты) // TODO: sort пакеты alphabetically by имя?
      выведиДеревоМ(p, отступ ~ "  ");
    foreach (m; пкт.модули) // TODO: sort модули alphabetically by имя?
      выдай(отступ ~ "  ")(m.имяМодуля)(".")(m.расширениеФайла()).нс;
  }

  /// Запускает первую проходку в модуле.
  проц  пускПроходки1(Модуль модуль)
  {
    if (модуль.естьОшибки || модуль.семантическийПроходка != 0)
      return;
    auto проходка1 = new СемантическаяПроходка1(модуль, контекст);
    проходка1.импортируйМодуль = &импортируйМодуль;
    проходка1.пуск();
    проходки1 ~= проходка1;
  }

  /// Импортируе модуль и запускает первую проходку по нему.
  Модуль импортируйМодуль(ткст путьПоПКНМодуля)
  {
    auto модуль = модульМен.загрузиМодуль(путьПоПКНМодуля);
    модуль && пускПроходки1(модуль);
    return модуль;
  }

  /// Рекурсивно выводит все символы (для отладки.)
  static проц  выведиТаблицуСимволов(СимволМасштаба симМасшт, ткст отступ)
  {
    foreach (член; симМасшт.члены)
    {
      auto семы = УтилитыДДок.дайСемыДокум(член.узел);
      ткст текстДок;
      foreach (сема; семы)
        текстДок ~= сема.исхТекст;
      выдай(отступ).форматнс("Ид:{}, Символ:{}, ДокТекст:{}",
                              член.имя.ткт, член.classinfo.имя,
                              текстДок);
      if (auto s = cast(СимволМасштаба)член)
        выведиТаблицуСимволов(s, отступ ~ "→ ");
    }
  }
}
