/*******************************************************************************

        copyright:      Copyright (c) 2007 Peter Triller. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: Sept 2007

        authors:        Peter

        Provопрes case маппинг Functions for Unicode Strings. As of сейчас it is
        only 99 % complete, because it does not возьми преобр_в account Conditional
        case mappings. This means the Greek Letter Sigma will not be correctly
        case mapped at the конец of a Word, и the Locales Lithuanian, Turkish
        и Azeri are not taken преобр_в account during Case Mappings. This means
        все in все around 12 Characters will not be mapped correctly under
        some circumstances.

        ICU4j also does not укз these cases at the moment.

        Unittests are записано against вывод из_ ICU4j

        This Module tries в_ minimize Memory allocation и usage. You can
        always пароль the вывод буфер that should be использован в_ the case маппинг
        function, which will be resized if necessary.

*******************************************************************************/

module text.Unicode;

private import text.UnicodeData;
private import text.convert.Utf;



/**
 * Преобразовать Строку Utf8 в Верхний регистр
 *
 * Параметры:
 *     ввод = Строка to be case mapped
 *     вывод = this вывод буфер will be использован unless too small
 * Возвращает: the case mapped ткст
 */
deprecated ткст блокВЗаг(ткст ввод, ткст вывод = пусто, дим[] working = пусто) {

    // ?? How much preallocation ?? This is worst case allocation
    if (working is пусто)
        working.length = ввод.length;

    бцел produced = 0;
    бцел ate;
    бцел oprod = 0;
    foreach(дим ch; ввод) {
        // TODO Conditional Case Mapping
        ДанныеЮникод *d = дайДанныеЮникод(ch);
        if(d !is пусто && (d.общаяКатегория & ДанныеЮникод.ОбщаяКатегория.СпецМаппинг)) {
            СпецДанныеРегистра *s = дайСпецДанныеРегистра(ch);
            debug {
                assert(s !is пусто);
            }
            if(s.загМаппинг !is пусто) {
                // To скорость up, use worst case for память prealocation
                // since the length of an UpperCaseMapping список is at most 4
                // Make sure no relocation is made in the вТкст Метод
                // better allocation algorithm ?
                цел длин = s.загМаппинг.length;
                if(produced + длин >= working.length)
                    working.length = working.length + working.length / 2 +  длин;
                oprod = produced;
                produced += длин;
                working[oprod..produced] = s.загМаппинг;
                continue;
            }
        }
        // Make sure no relocation is made in the вТкст Метод
        if(produced + 1 >= вывод.length)
            working.length = working.length + working.length / 2 + 1;
        working[produced++] =  d is пусто ? ch:d.простойЗагМаппинг;
    }
    return вТкст(working[0..produced],вывод);
}



/**
 * Converts an Utf8 Строка в_ Upper case
 *
 * Параметры:
 *     ввод = Строка в_ be case mapped
 *     вывод = this вывод буфер will be использован unless too small
 * Возвращает: the case mapped ткст
 */
ткст вЗаг(ткст ввод, ткст вывод = пусто) {

    дим[1] буф;
    // assume most common case: Строка stays the same length
    if (вывод.length < ввод.length)
        вывод.length = ввод.length;

    бцел produced = 0;
    бцел ate;
    foreach(дим ch; ввод) {
        // TODO Conditional Case Mapping
        ДанныеЮникод *d = дайДанныеЮникод(ch);
        if(d !is пусто && (d.общаяКатегория & ДанныеЮникод.ОбщаяКатегория.СпецМаппинг)) {
            СпецДанныеРегистра *s = дайСпецДанныеРегистра(ch);
            debug {
                assert(s !is пусто);
            }
            if(s.загМаппинг !is пусто) {
                // To скорость up, use worst case for память prealocation
                // since the length of an UpperCaseMapping список is at most 4
                // Make sure no relocation is made in the вТкст Метод
                // better allocation algorithm ?
                if(produced + s.загМаппинг.length * 4 >= вывод.length)
                        вывод.length = вывод.length + вывод.length / 2 +  s.загМаппинг.length * 4;
                ткст рез = вТкст(s.загМаппинг, вывод[produced..вывод.length], &ate);
                debug {
                    assert(ate == s.загМаппинг.length);
                    assert(рез.ptr == вывод[produced..вывод.length].ptr);
                }
                produced += рез.length;
                continue;
            }
        }
        // Make sure no relocation is made in the вТкст Метод
        if(produced + 4 >= вывод.length)
            вывод.length = вывод.length + вывод.length / 2 + 4;
        буф[0] = d is пусто ? ch:d.простойЗагМаппинг;
        ткст рез = вТкст(буф, вывод[produced..вывод.length], &ate);
        debug {
            assert(ate == 1);
            assert(рез.ptr == вывод[produced..вывод.length].ptr);
        }
        produced += рез.length;
    }
    return вывод[0..produced];
}


/**
 * Converts an Utf16 Строка в_ Upper case
 *
 * Параметры:
 *     ввод = Строка в_ be case mapped
 *     вывод = this вывод буфер will be использован unless too small
 * Возвращает: the case mapped ткст
 */
шим[] вЗаг(шим[] ввод, шим[] вывод = пусто) {

    дим[1] буф;
    // assume most common case: Строка stays the same length
    if (вывод.length < ввод.length)
        вывод.length = ввод.length;

    бцел produced = 0;
    бцел ate;
    foreach(дим ch; ввод) {
        // TODO Conditional Case Mapping
        ДанныеЮникод *d = дайДанныеЮникод(ch);
        if(d !is пусто && (d.общаяКатегория & ДанныеЮникод.ОбщаяКатегория.СпецМаппинг)) {
            СпецДанныеРегистра *s = дайСпецДанныеРегистра(ch);
            debug {
                assert(s !is пусто);
            }
            if(s.загМаппинг !is пусто) {
                // To скорость up, use worst case for память prealocation
                // Make sure no relocation is made in the вТкст16 Метод
                // better allocation algorithm ?
                if(produced + s.загМаппинг.length * 2 >= вывод.length)
                    вывод.length = вывод.length + вывод.length / 2 +  s.загМаппинг.length * 3;
                шим[] рез = вТкст16(s.загМаппинг, вывод[produced..вывод.length], &ate);
                debug {
                    assert(ate == s.загМаппинг.length);
                    assert(рез.ptr == вывод[produced..вывод.length].ptr);
                }
                produced += рез.length;
                continue;
            }
        }
        // Make sure no relocation is made in the вТкст16 Метод
        if(produced + 4 >= вывод.length)
            вывод.length = вывод.length + вывод.length / 2 + 3;
        буф[0] = d is пусто ? ch:d.простойЗагМаппинг;
        шим[] рез = вТкст16(буф, вывод[produced..вывод.length], &ate);
        debug {
            assert(ate == 1);
            assert(рез.ptr == вывод[produced..вывод.length].ptr);
        }
        produced += рез.length;
    }
    return вывод[0..produced];
}

/**
 * Converts an Utf32 Строка в_ Upper case
 *
 * Параметры:
 *     ввод = Строка в_ be case mapped
 *     вывод = this вывод буфер will be использован unless too small
 * Возвращает: the case mapped ткст
 */
дим[] вЗаг(дим[] ввод, дим[] вывод = пусто) {

    // assume most common case: Строка stays the same length
    if (ввод.length > вывод.length)
        вывод.length = ввод.length;

    бцел produced = 0;
    if (ввод.length)
        foreach(дим orig; ввод) {
            // TODO Conditional Case Mapping
            ДанныеЮникод *d = дайДанныеЮникод(orig);
            if(d !is пусто && (d.общаяКатегория & ДанныеЮникод.ОбщаяКатегория.СпецМаппинг)) {
                СпецДанныеРегистра *s = дайСпецДанныеРегистра(orig);
                debug {
                    assert(s !is пусто);
                }
                if(s.загМаппинг !is пусто) {
                    // Better перемерь strategy ???
                    if(produced + s.загМаппинг.length  > вывод.length)
                        вывод.length = вывод.length + вывод.length / 2 + s.загМаппинг.length;
                    foreach(ch; s.загМаппинг) {
                        вывод[produced++] = ch;
                    }
                }
                continue;
            }
            if(produced >= вывод.length)
                вывод.length = вывод.length + вывод.length / 2;
            вывод[produced++] = d is пусто ? orig:d.простойЗагМаппинг;
        }
    return вывод[0..produced];
}


/**
 * Converts an Utf8 Строка в_ Lower case
 *
 * Параметры:
 *     ввод = Строка в_ be case mapped
 *     вывод = this вывод буфер will be использован unless too small
 * Возвращает: the case mapped ткст
 */
ткст вПроп(ткст ввод, ткст вывод = пусто) {

    дим[1] буф;
    // assume most common case: Строка stays the same length
    if (вывод.length < ввод.length)
        вывод.length = ввод.length;

    бцел produced = 0;
    бцел ate;
    foreach(дим ch; ввод) {
        // TODO Conditional Case Mapping
        ДанныеЮникод *d = дайДанныеЮникод(ch);
        if(d !is пусто && (d.общаяКатегория & ДанныеЮникод.ОбщаяКатегория.СпецМаппинг)) {
            СпецДанныеРегистра *s = дайСпецДанныеРегистра(ch);
            debug {
                assert(s !is пусто);
            }
            if(s.пропМаппинг !is пусто) {
                // To скорость up, use worst case for память prealocation
                // since the length of an LowerCaseMapping список is at most 4
                // Make sure no relocation is made in the вТкст Метод
                // better allocation algorithm ?
                if(produced + s.пропМаппинг.length * 4 >= вывод.length)
                        вывод.length = вывод.length + вывод.length / 2 +  s.пропМаппинг.length * 4;
                ткст рез = вТкст(s.пропМаппинг, вывод[produced..вывод.length], &ate);
                debug {
                    assert(ate == s.пропМаппинг.length);
                    assert(рез.ptr == вывод[produced..вывод.length].ptr);
                }
                produced += рез.length;
                continue;
            }
        }
        // Make sure no relocation is made in the вТкст Метод
        if(produced + 4 >= вывод.length)
            вывод.length = вывод.length + вывод.length / 2 + 4;
        буф[0] = d is пусто ? ch:d.простойПропМаппинг;
        ткст рез = вТкст(буф, вывод[produced..вывод.length], &ate);
        debug {
            assert(ate == 1);
            assert(рез.ptr == вывод[produced..вывод.length].ptr);
        }
        produced += рез.length;
    }
    return вывод[0..produced];
}


/**
 * Converts an Utf16 Строка в_ Lower case
 *
 * Параметры:
 *     ввод = Строка в_ be case mapped
 *     вывод = this вывод буфер will be использован unless too small
 * Возвращает: the case mapped ткст
 */
шим[] вПроп(шим[] ввод, шим[] вывод = пусто) {

    дим[1] буф;
    // assume most common case: Строка stays the same length
    if (вывод.length < ввод.length)
        вывод.length = ввод.length;

    бцел produced = 0;
    бцел ate;
    foreach(дим ch; ввод) {
        // TODO Conditional Case Mapping
        ДанныеЮникод *d = дайДанныеЮникод(ch);
        if(d !is пусто && (d.общаяКатегория & ДанныеЮникод.ОбщаяКатегория.СпецМаппинг)) {
            СпецДанныеРегистра *s = дайСпецДанныеРегистра(ch);
            debug {
                assert(s !is пусто);
            }
            if(s.пропМаппинг !is пусто) {
                // To скорость up, use worst case for память prealocation
                // Make sure no relocation is made in the вТкст16 Метод
                // better allocation algorithm ?
                if(produced + s.пропМаппинг.length * 2 >= вывод.length)
                    вывод.length = вывод.length + вывод.length / 2 +  s.пропМаппинг.length * 3;
                шим[] рез = вТкст16(s.пропМаппинг, вывод[produced..вывод.length], &ate);
                debug {
                    assert(ate == s.пропМаппинг.length);
                    assert(рез.ptr == вывод[produced..вывод.length].ptr);
                }
                produced += рез.length;
                continue;
            }
        }
        // Make sure no relocation is made in the вТкст16 Метод
        if(produced + 4 >= вывод.length)
            вывод.length = вывод.length + вывод.length / 2 + 3;
        буф[0] = d is пусто ? ch:d.простойПропМаппинг;
        шим[] рез = вТкст16(буф, вывод[produced..вывод.length], &ate);
        debug {
            assert(ate == 1);
            assert(рез.ptr == вывод[produced..вывод.length].ptr);
        }
        produced += рез.length;
    }
    return вывод[0..produced];
}


/**
 * Converts an Utf32 Строка в_ Lower case
 *
 * Параметры:
 *     ввод = Строка в_ be case mapped
 *     вывод = this вывод буфер will be использован unless too small
 * Возвращает: the case mapped ткст
 */
дим[] вПроп(дим[] ввод, дим[] вывод = пусто) {

    // assume most common case: Строка stays the same length
    if (ввод.length > вывод.length)
        вывод.length = ввод.length;

    бцел produced = 0;
    if (ввод.length)
        foreach(дим orig; ввод) {
            // TODO Conditional Case Mapping
            ДанныеЮникод *d = дайДанныеЮникод(orig);
            if(d !is пусто && (d.общаяКатегория & ДанныеЮникод.ОбщаяКатегория.СпецМаппинг)) {
                СпецДанныеРегистра *s = дайСпецДанныеРегистра(orig);
                debug {
                    assert(s !is пусто);
                }
                if(s.пропМаппинг !is пусто) {
                    // Better перемерь strategy ???
                    if(produced + s.пропМаппинг.length  > вывод.length)
                        вывод.length = вывод.length + вывод.length / 2 + s.пропМаппинг.length;
                    foreach(ch; s.пропМаппинг) {
                        вывод[produced++] = ch;
                    }
                }
                continue;
            }
            if(produced >= вывод.length)
                вывод.length = вывод.length + вывод.length / 2;
            вывод[produced++] = d is пусто ? orig:d.простойПропМаппинг;
        }
    return вывод[0..produced];
}

/**
 * Converts an Utf8 Строка в_ Folding case
 * Folding case is использован for case insensitive comparsions.
 *
 * Параметры:
 *     ввод = Строка в_ be case mapped
 *     вывод = this вывод буфер will be использован unless too small
 * Возвращает: the case mapped ткст
 */
ткст вФолд(ткст ввод, ткст вывод = пусто) {

    дим[1] буф;
    // assume most common case: Строка stays the same length
    if (вывод.length < ввод.length)
        вывод.length = ввод.length;

    бцел produced = 0;
    бцел ate;
    foreach(дим ch; ввод) {
        FoldingCaseData *s = getFoldingCaseData(ch);
        if(s !is пусто) {
            // To скорость up, use worst case for память prealocation
            // since the length of an UpperCaseMapping список is at most 4
            // Make sure no relocation is made in the вТкст Метод
            // better allocation algorithm ?
            if(produced + s.маппинг.length * 4 >= вывод.length)
                вывод.length = вывод.length + вывод.length / 2 +  s.маппинг.length * 4;
            ткст рез = вТкст(s.маппинг, вывод[produced..вывод.length], &ate);
            debug {
                assert(ate == s.маппинг.length);
                assert(рез.ptr == вывод[produced..вывод.length].ptr);
            }
            produced += рез.length;
            continue;
        }
        // Make sure no relocation is made in the вТкст Метод
        if(produced + 4 >= вывод.length)
            вывод.length = вывод.length + вывод.length / 2 + 4;
        буф[0] = ch;
        ткст рез = вТкст(буф, вывод[produced..вывод.length], &ate);
        debug {
            assert(ate == 1);
            assert(рез.ptr == вывод[produced..вывод.length].ptr);
        }
        produced += рез.length;
    }
    return вывод[0..produced];
}

/**
 * Converts an Utf16 Строка в_ Folding case
 * Folding case is использован for case insensitive comparsions.
 *
 * Параметры:
 *     ввод = Строка в_ be case mapped
 *     вывод = this вывод буфер will be использован unless too small
 * Возвращает: the case mapped ткст
 */
шим[] вФолд(шим[] ввод, шим[] вывод = пусто) {

    дим[1] буф;
    // assume most common case: Строка stays the same length
    if (вывод.length < ввод.length)
        вывод.length = ввод.length;

    бцел produced = 0;
    бцел ate;
    foreach(дим ch; ввод) {
        FoldingCaseData *s = getFoldingCaseData(ch);
        if(s !is пусто) {
            // To скорость up, use worst case for память prealocation
            // Make sure no relocation is made in the вТкст16 Метод
            // better allocation algorithm ?
            if(produced + s.маппинг.length * 2 >= вывод.length)
                вывод.length = вывод.length + вывод.length / 2 +  s.маппинг.length * 3;
            шим[] рез = вТкст16(s.маппинг, вывод[produced..вывод.length], &ate);
            debug {
                assert(ate == s.маппинг.length);
                assert(рез.ptr == вывод[produced..вывод.length].ptr);
            }
            produced += рез.length;
            continue;
        }
        // Make sure no relocation is made in the вТкст16 Метод
        if(produced + 4 >= вывод.length)
            вывод.length = вывод.length + вывод.length / 2 + 3;
        буф[0] = ch;
        шим[] рез = вТкст16(буф, вывод[produced..вывод.length], &ate);
        debug {
            assert(ate == 1);
            assert(рез.ptr == вывод[produced..вывод.length].ptr);
        }
        produced += рез.length;
    }
    return вывод[0..produced];
}

/**
 * Converts an Utf32 Строка в_ Folding case
 * Folding case is использован for case insensitive comparsions.
 *
 * Параметры:
 *     ввод = Строка в_ be case mapped
 *     вывод = this вывод буфер will be использован unless too small
 * Возвращает: the case mapped ткст
 */
дим[] вФолд(дим[] ввод, дим[] вывод = пусто) {

    // assume most common case: Строка stays the same length
    if (ввод.length > вывод.length)
        вывод.length = ввод.length;

    бцел produced = 0;
    if (ввод.length)
        foreach(дим orig; ввод) {
            FoldingCaseData *d = getFoldingCaseData(orig);
            if(d !is пусто ) {
                // Better перемерь strategy ???
                if(produced + d.маппинг.length  > вывод.length)
                    вывод.length = вывод.length + вывод.length / 2 + d.маппинг.length;
                foreach(ch; d.маппинг) {
                    вывод[produced++] = ch;
                }
                continue;
            }
            if(produced >= вывод.length)
                вывод.length = вывод.length + вывод.length / 2;
            вывод[produced++] = orig;
        }
    return вывод[0..produced];
}


/**
 * Determines if a character is a цифра. It returns да for decimal
 * цифры only.
 *
 * Параметры:
 *     ch = the character в_ be inspected
 */
бул цифра_ли(дим ch) {
    ДанныеЮникод *d = дайДанныеЮникод(ch);
    return (d !is пусто) && (d.общаяКатегория & ДанныеЮникод.ОбщаяКатегория.Nd);
}


/**
 * Determines if a character is a letter.
 *
 * Параметры:
 *     ch = the character в_ be inspected
 */
бул буква_ли(цел ch) {
    ДанныеЮникод *d = дайДанныеЮникод(ch);
    return (d !is пусто) && (d.общаяКатегория &
        ( ДанныеЮникод.ОбщаяКатегория.Lu
        | ДанныеЮникод.ОбщаяКатегория.Ll
        | ДанныеЮникод.ОбщаяКатегория.Lt
        | ДанныеЮникод.ОбщаяКатегория.Lm
        | ДанныеЮникод.ОбщаяКатегория.Lo));
}

/**
 * Determines if a character is a letter or a
 * decimal цифра.
 *
 * Параметры:
 *     ch = the character в_ be inspected
 */
бул букваИлиЦифра(цел ch) {
    ДанныеЮникод *d = дайДанныеЮникод(ch);
    return (d !is пусто) && (d.общаяКатегория &
        ( ДанныеЮникод.ОбщаяКатегория.Lu
        | ДанныеЮникод.ОбщаяКатегория.Ll
        | ДанныеЮникод.ОбщаяКатегория.Lt
        | ДанныеЮникод.ОбщаяКатегория.Lm
        | ДанныеЮникод.ОбщаяКатегория.Lo
        | ДанныеЮникод.ОбщаяКатегория.Nd));
}

/**
 * Determines if a character is a lower case letter.
 * Параметры:
 *     ch = the character в_ be inspected
 */
бул проп_ли(дим ch) {
    ДанныеЮникод *d = дайДанныеЮникод(ch);
    return (d !is пусто) && (d.общаяКатегория & ДанныеЮникод.ОбщаяКатегория.Ll);
}

/**
 * Determines if a character is a титул case letter.
 * In case of combined letters, only the первый is upper и the секунда is lower.
 * Some of these special characters can be найдено in the croatian и greek language.
 * See_Also: http://en.wikИПedia.org/wiki/Capitalization
 * Параметры:
 *     ch = the character в_ be inspected
 */
бул титул_ли(дим ch) {
    ДанныеЮникод *d = дайДанныеЮникод(ch);
    return (d !is пусто) && (d.общаяКатегория & ДанныеЮникод.ОбщаяКатегория.Lt);
}

/**
 * Determines if a character is a upper case letter.
 * Параметры:
 *     ch = the character в_ be inspected
 */
бул заг_ли(дим ch) {
    ДанныеЮникод *d = дайДанныеЮникод(ch);
    return (d !is пусто) && (d.общаяКатегория & ДанныеЮникод.ОбщаяКатегория.Lu);
}

/**
 * Determines if a character is a Whitespace character.
 * Whitespace characters are characters in the
 * General Catetories Zs, Zl, Zp without the No Break
 * пробелы plus the control characters out of the ASCII
 * range, that are использован as пробелы:
 * TAB VT LF FF CR ФС GS RS US NL
 *
 * WARNING: look at пбел_ли, maybe that function does
 *          ещё что you expect.
 *
 * Параметры:
 *     ch = the character в_ be inspected
 */
бул пробел_ли(дим ch) {
    if((ch >= 0x0009 && ch <= 0x000D) || (ch >= 0x001C && ch <= 0x001F))
        return да;
    ДанныеЮникод *d = дайДанныеЮникод(ch);
    return (d !is пусто) && (d.общаяКатегория &
            ( ДанныеЮникод.ОбщаяКатегория.Zs
            | ДанныеЮникод.ОбщаяКатегория.Zl
            | ДанныеЮникод.ОбщаяКатегория.Zp))
            && ch != 0x00A0 // NBSP
            && ch != 0x202F // NARROW NBSP
            && ch != 0xFEFF; // ZERO WIDTH NBSP
}

/**
 * Detemines if a character is a Space character as
 * specified in the Unicode Standard.
 *
 * WARNING: look at пробел_ли, maybe that function does
 *          ещё что you expect.
 *
 * Параметры:
 *     ch = the character в_ be inspected
 */
бул пбел_ли(дим ch) {
    ДанныеЮникод *d = дайДанныеЮникод(ch);
    return (d !is пусто) && (d.общаяКатегория &
            ( ДанныеЮникод.ОбщаяКатегория.Zs
            | ДанныеЮникод.ОбщаяКатегория.Zl
            | ДанныеЮникод.ОбщаяКатегория.Zp));
}


/**
 * Detemines if a character is a printable character as
 * specified in the Unicode Standard.
 *
 * Параметры:
 *     ch = the character в_ be inspected
 */
бул печат_ли(дим ch) {
    ДанныеЮникод *d = дайДанныеЮникод(ch);
    return (d !is пусто) && !(d.общаяКатегория &
            ( ДанныеЮникод.ОбщаяКатегория.Cn
            | ДанныеЮникод.ОбщаяКатегория.Cc
            | ДанныеЮникод.ОбщаяКатегория.Cf
            | ДанныеЮникод.ОбщаяКатегория.Co
            | ДанныеЮникод.ОбщаяКатегория.Cs));
}

debug ( UnicodeTest ):
    проц main() {}

debug (UnitTest) {

unittest {


    // 1) No Буфер passed, no перемерь, no SpecialCase

    ткст testString1utf8 = "\u00E4\u00F6\u00FC";
    шим[] testString1utf16 = "\u00E4\u00F6\u00FC";
    дим[] testString1utf32 = "\u00E4\u00F6\u00FC";
    ткст refString1utf8 = "\u00C4\u00D6\u00DC";
    шим[] refString1utf16 = "\u00C4\u00D6\u00DC";
    дим[] refString1utf32 = "\u00C4\u00D6\u00DC";
    ткст resultString1utf8 = вЗаг(testString1utf8);
    assert(resultString1utf8 == refString1utf8);
    шим[] resultString1utf16 = вЗаг(testString1utf16);
    assert(resultString1utf16 == refString1utf16);
    дим[] resultString1utf32 = вЗаг(testString1utf32);
    assert(resultString1utf32 == refString1utf32);

    // 2) Буфер passed, no перемерь, no SpecialCase
    сим[60] buffer1utf8;
    шим[30] buffer1utf16;
    дим[30] buffer1utf32;
    resultString1utf8 = вЗаг(testString1utf8,buffer1utf8);
    assert(resultString1utf8.ptr == buffer1utf8.ptr);
    assert(resultString1utf8 == refString1utf8);
    resultString1utf16 = вЗаг(testString1utf16,buffer1utf16);
    assert(resultString1utf16.ptr == buffer1utf16.ptr);
    assert(resultString1utf16 == refString1utf16);
    resultString1utf32 = вЗаг(testString1utf32,buffer1utf32);
    assert(resultString1utf32.ptr == buffer1utf32.ptr);
    assert(resultString1utf32 == refString1utf32);

    // 3/ Буфер passed, перемерь necessary, no Special case

    сим[5] buffer2utf8;
    шим[2] buffer2utf16;
    дим[2] buffer2utf32;
    resultString1utf8 = вЗаг(testString1utf8,buffer2utf8);
    assert(resultString1utf8.ptr != buffer2utf8.ptr);
    assert(resultString1utf8 == refString1utf8);
    resultString1utf16 = вЗаг(testString1utf16,buffer2utf16);
    assert(resultString1utf16.ptr != buffer2utf16.ptr);
    assert(resultString1utf16 == refString1utf16);
    resultString1utf32 = вЗаг(testString1utf32,buffer2utf32);
    assert(resultString1utf32.ptr != buffer2utf32.ptr);
    assert(resultString1utf32 == refString1utf32);

    // 4) Буфер passed, перемерь necessary, extensive SpecialCase


    ткст testString2utf8 = "\uFB03\uFB04\uFB05";
    шим[] testString2utf16 = "\uFB03\uFB04\uFB05";
    дим[] testString2utf32 = "\uFB03\uFB04\uFB05";
    ткст refString2utf8 = "\u0046\u0046\u0049\u0046\u0046\u004C\u0053\u0054";
    шим[] refString2utf16 = "\u0046\u0046\u0049\u0046\u0046\u004C\u0053\u0054";
    дим[] refString2utf32 = "\u0046\u0046\u0049\u0046\u0046\u004C\u0053\u0054";
    resultString1utf8 = вЗаг(testString2utf8,buffer2utf8);
    assert(resultString1utf8.ptr != buffer2utf8.ptr);
    assert(resultString1utf8 == refString2utf8);
    resultString1utf16 = вЗаг(testString2utf16,buffer2utf16);
    assert(resultString1utf16.ptr != buffer2utf16.ptr);
    assert(resultString1utf16 == refString2utf16);
    resultString1utf32 = вЗаг(testString2utf32,buffer2utf32);
    assert(resultString1utf32.ptr != buffer2utf32.ptr);
    assert(resultString1utf32 == refString2utf32);

}


unittest {


    // 1) No Буфер passed, no перемерь, no SpecialCase

    ткст testString1utf8 = "\u00C4\u00D6\u00DC";
    шим[] testString1utf16 = "\u00C4\u00D6\u00DC";
    дим[] testString1utf32 = "\u00C4\u00D6\u00DC";
    ткст refString1utf8 = "\u00E4\u00F6\u00FC";
    шим[] refString1utf16 = "\u00E4\u00F6\u00FC";
    дим[] refString1utf32 = "\u00E4\u00F6\u00FC";
    ткст resultString1utf8 = вПроп(testString1utf8);
    assert(resultString1utf8 == refString1utf8);
    шим[] resultString1utf16 = вПроп(testString1utf16);
    assert(resultString1utf16 == refString1utf16);
    дим[] resultString1utf32 = вПроп(testString1utf32);
    assert(resultString1utf32 == refString1utf32);

    // 2) Буфер passed, no перемерь, no SpecialCase
    сим[60] buffer1utf8;
    шим[30] buffer1utf16;
    дим[30] buffer1utf32;
    resultString1utf8 = вПроп(testString1utf8,buffer1utf8);
    assert(resultString1utf8.ptr == buffer1utf8.ptr);
    assert(resultString1utf8 == refString1utf8);
    resultString1utf16 = вПроп(testString1utf16,buffer1utf16);
    assert(resultString1utf16.ptr == buffer1utf16.ptr);
    assert(resultString1utf16 == refString1utf16);
    resultString1utf32 = вПроп(testString1utf32,buffer1utf32);
    assert(resultString1utf32.ptr == buffer1utf32.ptr);
    assert(resultString1utf32 == refString1utf32);

    // 3/ Буфер passed, перемерь necessary, no Special case

    сим[5] buffer2utf8;
    шим[2] buffer2utf16;
    дим[2] buffer2utf32;
    resultString1utf8 = вПроп(testString1utf8,buffer2utf8);
    assert(resultString1utf8.ptr != buffer2utf8.ptr);
    assert(resultString1utf8 == refString1utf8);
    resultString1utf16 = вПроп(testString1utf16,buffer2utf16);
    assert(resultString1utf16.ptr != buffer2utf16.ptr);
    assert(resultString1utf16 == refString1utf16);
    resultString1utf32 = вПроп(testString1utf32,buffer2utf32);
    assert(resultString1utf32.ptr != buffer2utf32.ptr);
    assert(resultString1utf32 == refString1utf32);

    // 4) Буфер passed, перемерь necessary, extensive SpecialCase

    ткст testString2utf8 = "\u0130\u0130\u0130";
    шим[] testString2utf16 = "\u0130\u0130\u0130";
    дим[] testString2utf32 = "\u0130\u0130\u0130";
    ткст refString2utf8 = "\u0069\u0307\u0069\u0307\u0069\u0307";
    шим[] refString2utf16 = "\u0069\u0307\u0069\u0307\u0069\u0307";
    дим[] refString2utf32 = "\u0069\u0307\u0069\u0307\u0069\u0307";
    resultString1utf8 = вПроп(testString2utf8,buffer2utf8);
    assert(resultString1utf8.ptr != buffer2utf8.ptr);
    assert(resultString1utf8 == refString2utf8);
    resultString1utf16 = вПроп(testString2utf16,buffer2utf16);
    assert(resultString1utf16.ptr != buffer2utf16.ptr);
    assert(resultString1utf16 == refString2utf16);
    resultString1utf32 = вПроп(testString2utf32,buffer2utf32);
    assert(resultString1utf32.ptr != buffer2utf32.ptr);
    assert(resultString1utf32 == refString2utf32);
}

unittest {
    ткст testString1utf8 = "?!Mädchen \u0390\u0390,;";
    ткст testString2utf8 = "?!MÄDCHEN \u03B9\u0308\u0301\u03B9\u0308\u0301,;";
    assert(вФолд(testString1utf8) == вФолд(testString2utf8));
    шим[] testString1utf16 = "?!Mädchen \u0390\u0390,;";;
    шим[] testString2utf16 = "?!MÄDCHEN \u03B9\u0308\u0301\u03B9\u0308\u0301,;";
    assert(вФолд(testString1utf16) == вФолд(testString2utf16));
    шим[] testString1utf32 = "?!Mädchen \u0390\u0390,;";
    шим[] testString2utf32 = "?!MÄDCHEN \u03B9\u0308\u0301\u03B9\u0308\u0301,;";
    assert(вФолд(testString1utf32) == вФолд(testString2utf32));
}

}
