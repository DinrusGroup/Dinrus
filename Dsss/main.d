﻿module dsss.main;

import stdrus;
import cidrus;

import dsss.build;
import dsss.clean;
import dsss.conf;
import dsss.genconfig;
import dsss.install;
version(DSSS_Light) {} else {
    import dsss.net;
}
import dsss.uninstall;

const ткст ВЕРСИЯ_ДССС = "0.80";

private {
    /** Possible commands */
    enum т_кмнд {
        НЕТ,
            ПОСТРОЙКА,
            ОЧИСТКА,
            ДИСТОЧИСТКА,
            УСТАНОВКА,
            БИНУСТАНОВКА,
            ДЕИНСТАЛЛЯЦИЯ,
            УСТАНОВЛЕНО,
            СЕТЬ,
            ГЕНКОНФИГ
    }
    
    /** The команда in исп */
    т_кмнд команда;
}

цел main(ткст[] аргикс)
{
    бул командаЕсть = нет;
    
    /** Elements to постройка/инст/something */
    ткст[] стройЭлты;

    /** Overridden dsss.конф to исп */
    ткст использКонфДССС = пусто;

    ткст знач;
    
    // Now load in dsssrc
    ткст[] арги = аргикс ~читайДСССРС();
	ткст арг;
	скажи("Аргументы запуска DSSS: ");
 
    for (цел i = 1; i < арги.length; i++) {
        арг = арги[i];
		скажи(арг~" ");
        
        /** A simple function to check for any help-тип option */
        бул аргПомощь_ли() {
            return (арг == "-помощь" ||
					арг == "-пом" ||
					арг == "-п" ||
					арг == "--help" ||
                    арг == "-help" ||
                    арг == "-h" ||
                    арг == "/?");
        }
        
        /** Parse an argument */
        бул разборАрга(ткст арг, ткст ожидаемое, бул принимаетЗнач, char[]* знач = пусто) {
            if (принимаетЗнач) {
                if (арг.length > ожидаемое.length + 2 &&
                    арг[0 .. (ожидаемое.length + 3)] == "--" ~ ожидаемое ~ "=") {
                    *знач = арг[(ожидаемое.length + 3) .. $];
                    return да;
                } else if (арг.length > ожидаемое.length + 1 &&
                           арг[0 .. (ожидаемое.length + 2)] == "-" ~ ожидаемое ~ "=") {
                    *знач = арг[(ожидаемое.length + 2) .. $];
                    return да;
                }
                return нет;
            } else {
                if (арг == "--" ~ ожидаемое ||
                    арг == "-" ~ ожидаемое) return да;
                return нет;
            }
        }
        
        if (!командаЕсть) {
            // no команда set yet, DSSS options
            if (аргПомощь_ли()) {
                использование();
                return 0;

            } else if (разборАрга(арг, "конфиг", да, &знач)||разборАрга(арг, "config", да, &знач)) {
                использКонфДССС = знач.dup;
                
            } else if (арг == "build" || арг == "строй" ) {
                командаЕсть = да;
                команда = т_кмнд.ПОСТРОЙКА;
                
            } else if (арг == "очисть" || арг == "clean") {
                командаЕсть = да;
                команда = т_кмнд.ОЧИСТКА;
                
            } else if (арг == "дистчистка" || арг == "distclean") {
                командаЕсть = да;
                команда = т_кмнд.ДИСТОЧИСТКА;
                
            } else if (арг == "инст" || арг == "install") {
                командаЕсть = да;
                команда = т_кмнд.УСТАНОВКА;

            } else if (арг == "инстбин" || арг == "binstall") {
                командаЕсть = да;
                команда = т_кмнд.БИНУСТАНОВКА;
                
            } else if (арг == "деинст" || арг == "uninstall") {
                командаЕсть = да;
                команда = т_кмнд.ДЕИНСТАЛЛЯЦИЯ;
                
            } else if (арг == "списуст" || арг == "installed") {
                командаЕсть = да;
                команда = т_кмнд.УСТАНОВЛЕНО;
                
            } else if (арг == "сеть" || арг == "net") {
                version(DSSS_Light) {
                    скажифнс("Команда 'сеть' в DSSS Light не поддерживается");
                    выход(1);
                } else {
                    командаЕсть = да;
                    команда = т_кмнд.СЕТЬ;
                }
                
            } else if (арг == "генконф" || арг == "genconfig") {
                командаЕсть = да;
                команда = т_кмнд.ГЕНКОНФИГ;
				
			} 	
                
            else {
			
			командаЕсть = да;
            команда = т_кмнд.ПОСТРОЙКА;
                //скажифнс("\nНераспознанный аргумент: %s", арг);
                //выход(1);
            }
            
        } else {
            /* generic options */
            if (аргПомощь_ли()) {
                использование();
                return 0;
                
            } else if (разборАрга(арг, "исп", да, &знач)||разборАрга(арг, "use", да, &знач)) {
                // force a исп-папка
                использПапки ~= сделайАбс(знач);
                
            } else if (разборАрга(арг, "док", нет)||разборАрга(арг, "doc", нет)) {
                делДоки = да;				
                
            } else if (разборАрга(арг, "док-бины", нет)||разборАрга(арг, "doc-binaries", нет)) {
                делДоки = да;
                делДокБинари = да;

            } else if (разборАрга(арг, "отладка", нет)||разборАрга(арг, "debug", нет)) {
                строитьОтлад = да;

            } else if (разборАрга(арг, "п", нет)||разборАрга(арг, "v", нет)) {
                подробнРежим = да;

            } else if (разборАрга(арг, "пп", нет)||разборАрга(арг, "vv", нет)) {
                подробнРежим = да;
                дссс_опцииПостройки ~= "-п ";

            } else if (разборАрга(арг, "префикс", да, &знач)||разборАрга(арг, "prefix", да, &знач)) {
                // force a префикс
                форсПрефикс = сделайАбс(знач);
                
            } else if (разборАрга(арг, "оставь-респ-файлы", нет)||разборАрга(арг, "keep-responce-files", нет)) {
                удалитьРФайлы = нет;
                
            } else if (разборАрга(арг, "бинпапка", да, &знач)||разборАрга(арг, "bindir", да, &знач)) {
                бинПрефикс = сделайАбс(знач);    
				
            } else if (разборАрга(арг, "либпапка", да, &знач)||разборАрга(арг, "libdir", да, &знач)) {
                либПрефикс = сделайАбс(знач);
                
            } else if (разборАрга(арг, "инклюдпапка", да, &знач)||разборАрга(арг, "includedir", да, &знач)) {
                инклюдПрефикс = сделайАбс(знач);
                
            } else if (разборАрга(арг, "папдок", да, &знач)||разборАрга(арг, "docdir", да, &знач)) {
                докПрефикс = сделайАбс(знач);
                
            } else if (разборАрга(арг, "сисконфпапка", да, &знач)||разборАрга(арг, "sysconfdir", да, &знач)) {
                этцетераПрефикс = сделайАбс(знач);
                
            } else if (разборАрга(арг, "чернпапка", да, &знач)||разборАрга(арг, "scratchdir", да, &знач)) {
                черновойПрефикс = сделайАбс(знач);
                
            } else if (арг == "-arch" ||
                       арг == "-isysroot" ||
                       арг == "-framework") {
                // особый Mac OS X flags
                дссс_опцииПостройки ~= арг ~ " ";
                i++;
                if (i >= арги.length) {
                    скажифнс("Ожидался аргумент после %s", арг);
                    return 1;
                }
                дссс_опцииПостройки ~= арги[i] ~ " ";
                
            } else if (арг.length >= 1 &&
                       арг[0] == '-') {
                // perhaps specific to a команда
                if (команда == т_кмнд.ПОСТРОЙКА) {
                    if (разборАрга(арг, "тест", нет)||разборАрга(арг, "test", нет)) {
                        тестБибс = да;
                    } else {
                        дссс_опцииПостройки ~= арг ~ " ";
                    }

                } else if (команда == т_кмнд.СЕТЬ) {
                    version(DSSS_Light) {} else {
                        if (разборАрга(арг, "исток", да, &знач)||разборАрга(арг, "source", да, &знач)) {
                            форсЗеркало = знач;
                        } else {
                            дссс_опцииПостройки ~= арг ~ " ";
                        }
                    }
                    
                } else {
                    // pass through to постройка
                    дссс_опцииПостройки ~= арг ~ " ";
                }
                
            } else {
                // something to pass in
                стройЭлты ~= арг;
            }
            
            /* there are presently no specific options */
        }
    }
     		if (!арг)
				скажи("отсутствуют");
	 нс;  нс;
    if (!командаЕсть) {
        использование();
        return 0;
    }
    
    // Before running anything, get our префикс
    дайПрефикс(арги[0]);
    // add использПапки
    foreach (папка; использПапки) {
        ребилд ~= "-I" ~ папка ~ РАЗДПАП ~
            "imp" ~ РАЗДПАП ~"dinrus -S" ~ папка ~ РАЗДПАП ~
            "lib ";
    }

    // if a specific dsss.конф файл was requested, исп it
    ДСССКонф конф = пусто;
    if (использКонфДССС != "") {
        скажифнс("\nВНИМАНИЕ: Опция --конфиг рекомендуется только при тестировании, и НЕ должна быть");
        скажифнс("         частью процедуры общей постройки.");
        конф = читайКонфиг(стройЭлты, нет, использКонфДССС);
    }
    
    switch (команда) {
        case т_кмнд.ПОСТРОЙКА:
            return dsss.build.строй(стройЭлты, конф);
            break;
            
        case т_кмнд.ОЧИСТКА:
            return dsss.clean.очисть(конф);
            break;
            
        case т_кмнд.ДИСТОЧИСТКА:
            return dsss.clean.дистчистка(конф);
            break;
            
        case т_кмнд.УСТАНОВКА:
            return dsss.install.инсталлируй(стройЭлты, конф);
            break;

        case т_кмнд.БИНУСТАНОВКА:
        {
            цел bret = dsss.build.строй(стройЭлты, конф);
            if (bret) return bret;
            return dsss.install.инсталлируй(стройЭлты, конф);
            break;
        }
            
        case т_кмнд.ДЕИНСТАЛЛЯЦИЯ:
            return dsss.uninstall.деинсталлируй(стройЭлты);
            break;
            
        case т_кмнд.УСТАНОВЛЕНО:
            return dsss.uninstall.списуст();
            break;
            
        case т_кмнд.СЕТЬ:
            version(DSSS_Light) {} else {
                return dsss.net.сеть(стройЭлты);
            }
            break;
            
        case т_кмнд.ГЕНКОНФИГ:
            return dsss.genconfig.генконф(стройЭлты);
            break;
    }
    
    return 0;
}

/** Make a папка absolute */
ткст сделайАбс(ткст путь)
{
    if (!абсПуть_ли(путь)) {
        return дайтекпап() ~ РАЗДПАП ~ путь;
    }
    return путь;
}

проц использование()
{
    if (команда == т_кмнд.НЕТ) {
        скажифнс(
`

Построитель бинарных файлов языка Динрус DSSS версии ` ~ ВЕРСИЯ_ДССС ~ `

Использование: dsss [опции дссс] <команда> [опции]

  Опции DSSS:
  
    -помощь |-пом |-п: Показать данную справку.
    --конфиг=<альтернативный файл dsss.conf>: Следует использовать только для тестирования.
	
  Команды:
  
    строй, build:     постройка всех или некоторых бинарных файлов и библиотек
    очисть, clean:     очистка файлов объектов после всех или некоторых построек
    дистчистка, distclean: очистка всех файлов после всех или некоторых построек
    инст, install:   инсталлировать все или некоторые бинарные файлы или библиотеки
    деинст, uninstall: деинсталлировать указанный исполнимый файл или библиотеку
    списуст, installed: список установленного программного обеспечения`);
        version(DSSS_Light) {} else {
            скажифнс(
`    сеть, net:       Установка и управление пакетами через Интернет`);
        }
        скажифнс(
`    генконф, genconfig: генерировать файл конфигурации`);
        
    } else if (команда == т_кмнд.ПОСТРОЙКА) {
        скажифнс(
`

Использование: dsss [опции дссс] строй [опции постройки] [исходники, бинарные файлы или пакеты]

  Опции постройки:
  
    --тест, --test: тест скомпилированных библиотек`
            );
        
    } else if (команда == т_кмнд.ОЧИСТКА) {
        скажифнс(
`

Использование: dsss [опции дссс] очисть [опции очистки] [исходники, бинарные файлы или пакеты]`
            );
        
    } else if (команда == т_кмнд.ДИСТОЧИСТКА) {
        скажифнс(
`

Использование: dsss [опции дссс] дистчистка [опции дистчистки] [исходники, бинарные файлы или пакеты]`
            );
        
    } else if (команда == т_кмнд.УСТАНОВКА) {
        скажифнс(
`

Использование: dsss [опции дссс] инст [опции инсталляции] [исходники, бинарные файлы или пакеты]`
            );
        
   } else if (команда == т_кмнд.БИНУСТАНОВКА) {
        скажифнс(
`

Использование: dsss [опции дссс] инстбин [опции бинсталляции] [исходники, бинарные файлы или пакеты]`
            );

   } else if (команда == т_кмнд.ДЕИНСТАЛЛЯЦИЯ) {
        скажифнс(
`

Использование: dsss [опции дссс] деинст [опции деинсталляции] <экзэ или библиотеки>`
            );
        
    } else if (команда == т_кмнд.УСТАНОВЛЕНО) {
        скажифнс(
`

Использование: dsss [опции дссс] списуст`
            );
        
    } else if (команда == т_кмнд.СЕТЬ) {
        скажифнс(
`

Использование: dsss [опции дссс] сеть <команда сети> [опции] <имя пакета>

  Сетевые команды:
  
    зависимости:    инсталлировать (из сетевого источника) зависимости текущего
			 пакета
    завсписок: список зависимостей, без их установки
    инст: инсталляция пакета через сетевой источник
    скачать:   получить, но не устанавливать или компилировать пакет
    список:    список всех установочных пакетов
    поиск:  найти по имени установочный пакет
	
  Сетевые опции:
  
    --исток=<УЛР>: Использовать указанный URL при запросе списка, а не запрашивать, или
				использовать ранее известный.`
            );

        
    } else if (команда == т_кмнд.ГЕНКОНФИГ) {
        скажифнс(
`

Использование: dsss [опции дссс] генконф [опции инсталляции] [исходники, бинарные файлы или пакеты]`
            );
        
    }
    
    скажифнс(
` 
 Основные опции (после команды):

    -помощь, -пом, -п: показать информацию об опциях
    --префикс=<префикс>: установить префикс инсталляции
    --док: Генерировать/установить документацию к библиотекам
    --док-бины: Генерировать/установить документацию к библиотекам и бинарникам.
        После этого будет сгенерирована масса бесполезной документации к требуемым
        бибилиотекам, посему не рекомендовано к использованию в обыденой практике.
    --исп=<папка с библиотекой импорта и прочими>
    --оставь-респ-файлы: Не удалять временные файлы инструмента rebuild

    --бинпапка=<папка> [по умолчанию <префикс>/bin]
    --либпапка=<папка> [по умолчанию <префикс>/lib]
    --инклюдпапка=<папка> [по умолчанию <префикс>/imp/dinrus]
    --папдок=<папка> [по умолчанию <префикс>/doc]
    --сисконфпапка=<папка> [по умолчанию <префикс>/etc]
    --чернпапка=<папка> [по умолчанию /tmp]

  Все прочие опции передаются непосредственно в rebuild, а от него компилятору.`);
        
}
