/*******************************************************************************

        copyright:      Copyright (c) 2005 John Chapman. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: 2005

        author:         John Chapman

        Contains classes that provопрe information about locales, such as 
        the language and calendars, as well as cultural conventions used 
        for formatting dates, currency and numbers. Use these classes when 
        writing applications for an international audience.

******************************************************************************/

/**
 * $(MEMBERTABLE
 * $(TR
 * $(TH Interface)
 * $(TH DescrИПtion)
 * )
 * $(TR
 * $(TD $(LINK2 #ИСлужбаФормата, ИСлужбаФормата))
 * $(TD Retrieves an объект в_ control formatting.)
 * )
 * )
 *
 * $(MEMBERTABLE
 * $(TR
 * $(TH Class)
 * $(TH DescrИПtion)
 * )
 * $(TR
 * $(TD $(LINK2 #Calendar, Calendar))
 * $(TD Represents время in week, месяц and год divisions.)
 * )
 * $(TR
 * $(TD $(LINK2 #Культура, Культура))
 * $(TD Provопрes information about a культура, such as its имя, calendar and дата and число форматируй образцы.)
 * )
 * $(TR
 * $(TD $(LINK2 #ФорматДатыВремени, ФорматДатыВремени))
 * $(TD Determines как $(LINK2 #Время, Время) values are formatted, depending on the культура.)
 * )
 * $(TR
 * $(TD $(LINK2 #DaylightSavingTime, DaylightSavingTime))
 * $(TD Represents a период of daylight-saving время.)
 * )
 * $(TR
 * $(TD $(LINK2 #Gregorian, Gregorian))
 * $(TD Represents the Gregorian calendar.)
 * )
 * $(TR
 * $(TD $(LINK2 #Hebrew, Hebrew))
 * $(TD Represents the Hebrew calendar.)
 * )
 * $(TR
 * $(TD $(LINK2 #Hijri, Hijri))
 * $(TD Represents the Hijri calendar.)
 * )
 * $(TR
 * $(TD $(LINK2 #Japanese, Japanese))
 * $(TD Represents the Japanese calendar.)
 * )
 * $(TR
 * $(TD $(LINK2 #Korean, Korean))
 * $(TD Represents the Korean calendar.)
 * )
 * $(TR
 * $(TD $(LINK2 #ФорматЧисла, ФорматЧисла))
 * $(TD Determines как numbers are formatted, according в_ the current культура.)
 * )
 * $(TR
 * $(TD $(LINK2 #Регион, Регион))
 * $(TD Provопрes information about a region.)
 * )
 * $(TR
 * $(TD $(LINK2 #Taiwan, Taiwan))
 * $(TD Represents the Taiwan calendar.)
 * )
 * $(TR
 * $(TD $(LINK2 #ThaiBuddhist, ThaiBuddhist))
 * $(TD Represents the Thai Buddhist calendar.)
 * )
 * )
 *
 * $(MEMBERTABLE
 * $(TR
 * $(TH Struct)
 * $(TH DescrИПtion)
 * )
 * $(TR
 * $(TD $(LINK2 #Время, Время))
 * $(TD Represents время expressed as a дата and время of день.)
 * )
 * $(TR
 * $(TD $(LINK2 #ИнтервалВремени, ИнтервалВремени))
 * $(TD Represents a время интервал.)
 * )
 * )
 */

module text.locale.Core;

private import  exception;

private import  text.locale.Data;

private import  time.Time;

private import  time.chrono.Hijri,
                time.chrono.Korean,
                time.chrono.Taiwan,
                time.chrono.Hebrew,
                time.chrono.Calendar,
                time.chrono.Japanese,
                time.chrono.Gregorian,
                time.chrono.ThaiBuddhist;
        
version (Windows)
         private import text.locale.Win32;

version (Posix)
         private import text.locale.Posix;


// Initializes an Массив.
private template массивИз(T) {
  private T[] массивИз(T[] params ...) {
    return params.dup;
  }
}


/**
 * Defines the типы of cultures that can be retrieved из_ Культура.дайКультуры.
 */
public enum ТипыКультур {
  Нейтральный = 1,             /// Refers в_ cultures that are associated with a language but not specific в_ a country or region.
  Особый = 2,            /// Refers в_ cultures that are specific в_ a country or region.
  все = Нейтральный | Особый /// Refers в_ все cultures.
}


/**
 * $(ANCHOR _IFormatService)
 * Retrieves an объект в_ control formatting.
 * 
 * A class реализует $(LINK2 #IFormatService_getFormat, дайФормат) в_ retrieve an объект that provопрes форматируй information for the implementing тип.
 * Remarks: ИСлужбаФормата is implemented by $(LINK2 #Культура, Культура), $(LINK2 #ФорматЧисла, ФорматЧисла) and $(LINK2 #ФорматДатыВремени, ФорматДатыВремени) в_ provопрe locale-specific formatting of
 * numbers and дата and время values.
 */
public interface ИСлужбаФормата {

  /**
   * $(ANCHOR IFormatService_getFormat)
   * Retrieves an объект that supports formatting for the specified _тип.
   * Возвращает: The current экземпляр if тип is the same _тип as the current экземпляр; otherwise, пусто.
   * Параметры: тип = An объект that specifies the _тип of formatting в_ retrieve.
   */
  Объект дайФормат(ИнфОТипе тип);

}

/**
 * $(ANCHOR _Culture)
 * Provопрes information about a культура, such as its имя, calendar and дата and число форматируй образцы.
 * Remarks: text.locale adopts the RFC 1766 стандарт for культура names in the форматируй &lt;language&gt;"-"&lt;region&gt;. 
 * &lt;language&gt; is a lower-case two-letter код defined by ISO 639-1. &lt;region&gt; is an upper-case 
 * two-letter код defined by ISO 3166. For example, "en-GB" is UK English.
 * $(BR)$(BR)There are three типы of культура: invariant, neutral and specific. The invariant культура is not tied в_
 * any specific region, although it is associated with the English language. A neutral культура is associated with
 * a language, but not with a region. A specific культура is associated with a language and a region. "es" is a neutral 
 * культура. "es-MX" is a specific культура.
 * $(BR)$(BR)Instances of $(LINK2 #ФорматДатыВремени, ФорматДатыВремени) and $(LINK2 #ФорматЧисла, ФорматЧисла) cannot be создан for neutral cultures.
 * Examples:
 * ---
 * import io.Stdout, text.locale.Core;
 *
 * проц main() {
 *   Культура культура = new Культура("it-IT");
 *
 *   Стдвыв.форматнс("englishName: {}", культура.englishName);
 *   Стдвыв.форматнс("nativeName: {}", культура.nativeName);
 *   Стдвыв.форматнс("имя: {}", культура.имя);
 *   Стдвыв.форматнс("предок: {}", культура.предок.имя);
 *   Стдвыв.форматнс("isNeutral: {}", культура.isNeutral);
 * }
 *
 * // Produces the following вывод:
 * // englishName: Italian (Italy)
 * // nativeName: italiano (Italia)
 * // имя: it-IT
 * // предок: it
 * // isNeutral: нет
 * ---
 */
public class Культура : ИСлужбаФормата {

  private const цел LCID_INVARIANT = 0x007F;

  private static Культура[ткст] namedCultures;
  private static Культура[цел] idCultures;
  private static Культура[ткст] ietfCultures;

  private static Культура currentCulture_;
  private static Культура userDefaultCulture_; // The пользователь's default культура (GetUserDefaultLCID).
  private static Культура invariantCulture_; // The invariant культура is associated with the English language.
  private Calendar calendar_;
  private Культура parent_;
  private ДанныеОКультуре* cultureData_;
  private бул isReadOnly_;
  private ФорматЧисла numberFormat_;
  private ФорматДатыВремени dateTimeFormat_;

  static this() {
    invariantCulture_ = new Культура(LCID_INVARIANT);
    invariantCulture_.isReadOnly_ = да;

    userDefaultCulture_ = new Культура(nativeMethods.getUserCulture());
    if (userDefaultCulture_ is пусто)
      // Fallback
      userDefaultCulture_ = инвариантнаяКультура;
    else
      userDefaultCulture_.isReadOnly_ = да;
  }

  static ~this() {
    namedCultures = пусто;
    idCultures = пусто;
    ietfCultures = пусто;
  }

  /**
   * Initializes a new Культура экземпляр из_ the supplied имя.
   * Параметры: названиеКультуры = The имя of the Культура.
   */
  public this(ткст названиеКультуры) {
    cultureData_ = ДанныеОКультуре.дайДанныеИзНазванияКультуры(названиеКультуры);
  }

  /**
   * Initializes a new Культура экземпляр из_ the supplied культура определитель.
   * Параметры: идКультуры = The опрentifer (LCID) of the Культура.
   * Remarks: Культура определители correspond в_ a Windows LCID.
   */
  public this(цел идКультуры) {
    cultureData_ = ДанныеОКультуре.дайДанныеИзИДКультуры(идКультуры);
  }

  /**
   * Retrieves an объект defining как в_ форматируй the specified тип.
   * Параметры: тип = The ИнфОТипе of the resulting formatting объект.
   * Возвращает: If тип is typeid($(LINK2 #ФорматЧисла, ФорматЧисла)), the значение of the $(LINK2 #Culture_numberFormat, форматЧисла) property. If тип is typeid($(LINK2 #ФорматДатыВремени, ФорматДатыВремени)), the
   * значение of the $(LINK2 #Culture_dateTimeFormat, форматДатыВремени) property. Otherwise, пусто.
   * Remarks: Implements $(LINK2 #IFormatService_getFormat, ИСлужбаФормата.дайФормат).
   */
  public Объект дайФормат(ИнфОТипе тип) {
    if (тип is typeid(ФорматЧисла))
      return форматЧисла;
    else if (тип is typeid(ФорматДатыВремени))
      return форматДатыВремени;
    return пусто;
  }

version (Clone)
{
  /**
   * Copies the current Культура экземпляр.
   * Возвращает: A копируй of the current Культура экземпляр.
   * Remarks: The values of the $(LINK2 #Culture_numberFormat, форматЧисла), $(LINK2 #Culture_dateTimeFormat, форматДатыВремени) and $(LINK2 #Culture_calendar, calendar) свойства are copied also.
   */
  public Объект clone() {
    Культура культура = cast(Культура)клонируйОбъект(this);
    if (!культура.isNeutral) {
      if (dateTimeFormat_ !is пусто)
        культура.dateTimeFormat_ = cast(ФорматДатыВремени)dateTimeFormat_.clone();
      if (numberFormat_ !is пусто)
        культура.numberFormat_ = cast(ФорматЧисла)numberFormat_.clone();
    }
    if (calendar_ !is пусто)
      культура.calendar_ = cast(Calendar)calendar_.clone();
    return культура;
  }
}

  /**
   * Returns a читай-only экземпляр of a культура using the specified культура определитель.
   * Параметры: идКультуры = The определитель of the культура.
   * Возвращает: A читай-only культура экземпляр.
   * Remarks: Instances returned by this метод are cached.
   */
  public static Культура дайКультуру(цел идКультуры) {
    Культура культура = дайКультуруВнутр(идКультуры, пусто);

version (Posix) {
    if (культура is пусто)
        ошибка ("Культура не найден - if this was not tried установи by the application, Dinrus\n"
            ~ "will expect that a locale is установи via environment variables LANG or LC_ALL.");
}

    return культура;
  }

  /**
   * Returns a читай-only экземпляр of a культура using the specified культура имя.
   * Параметры: названиеКультуры = The имя of the культура.
   * Возвращает: A читай-only культура экземпляр.
   * Remarks: Instances returned by this метод are cached.
   */
  public static Культура дайКультуру(ткст названиеКультуры) {
    if (названиеКультуры is пусто)
       ошибка("Значение не может быть пустым.");
    Культура культура = дайКультуруВнутр(0, названиеКультуры);
    if (культура is пусто)
      ошибка("Культура имя " ~ названиеКультуры ~ " is not supported.");
    return культура;
  }

  /**
    * Returns a читай-only экземпляр using the specified имя, as defined by the RFC 3066 стандарт and maintained by the IETF.
    * Параметры: имя = The имя of the language.
    * Возвращает: A читай-only культура экземпляр.
    */
  public static Культура дайКультуруПоТегуЯзыкаИЕТФ(ткст имя) {
    if (имя is пусто)
      ошибка("Значение не может быть пустым.");
    Культура культура = дайКультуруВнутр(-1, имя);
    if (культура is пусто)
      ошибка("Культура IETF имя " ~ имя ~ " is not a known IETF имя.");
    return культура;
  }

  private static Культура дайКультуруВнутр(цел идКультуры, ткст cname) {
    // If идКультуры is - 1, имя is an IETF имя; if it's 0, имя is a культура имя; otherwise, it's a valid LCID.
    ткст имя = cname; 
    foreach (i, c; cname)
       if (c is '_') {
         имя = cname.dup;
         имя[i] = '-';
         break;
       }

    // Look up tables first.
    if (идКультуры == 0) {
      if (Культура* культура = имя in namedCultures)
        return *культура;
    }
    else if (идКультуры > 0) {
      if (Культура* культура = идКультуры in idCultures)
        return *культура;
    }
    else if (идКультуры == -1) {
      if (Культура* культура = имя in ietfCultures)
        return *культура;
    }

    // Nothing найдено, создай a new экземпляр.
    Культура культура;

    try {
      if (идКультуры == -1) {
        имя = ДанныеОКультуре.getCultureNameFromIetfName(имя);
        if (имя is пусто)
          return пусто;
      }
      else if (идКультуры == 0)
        культура = new Культура(имя);
      else if (userDefaultCulture_ !is пусто && userDefaultCulture_.опр == идКультуры) {
        культура = userDefaultCulture_;
      }
      else
        культура = new Культура(идКультуры);
    }
    catch (LocaleException) {
      return пусто;
    }

    культура.isReadOnly_ = да;

    // Сейчас cache the new экземпляр in все tables.
    ietfCultures[культура.ietfLanguageTag] = культура;
    namedCultures[культура.имя] = культура;
    idCultures[культура.опр] = культура;

    return культура;
  }

  /**
   * Returns a список of cultures filtered by the specified $(LINK2 constants.html#ТипыКультур, ТипыКультур).
   * Параметры: типы = A combination of ТипыКультур.
   * Возвращает: An Массив of Культура instances containing cultures specified by типы.
   */
  public static Культура[] дайКультуры(ТипыКультур типы) {
    бул includeSpecific = (типы & ТипыКультур.Особый) != 0;
    бул includeNeutral = (типы & ТипыКультур.Нейтральный) != 0;

    цел[] cultures;
    for (цел i = 0; i < ДанныеОКультуре.cultureDataTable.length; i++) {
      if ((ДанныеОКультуре.cultureDataTable[i].isNeutral && includeNeutral) || (!ДанныеОКультуре.cultureDataTable[i].isNeutral && includeSpecific))
        cultures ~= ДанныеОКультуре.cultureDataTable[i].lcid;
    }

    Культура[] результат = new Культура[cultures.length];
    foreach (цел i, цел идКультуры; cultures)
      результат[i] = new Культура(идКультуры);
    return результат;
  }

  /**
   * Returns the имя of the Культура.
   * Возвращает: A ткст containing the имя of the Культура in the форматируй &lt;language&gt;"-"&lt;region&gt;.
   */
  public override ткст вТкст() {
    return cultureData_.имя;
  }

  public override цел opEquals(Объект об) {
    if (об is this)
      return да;
    Культура другой = cast(Культура)об;
    if (другой is пусто)
      return нет;
    return другой.имя == имя; // This needs в_ be изменён so it's culturally aware.
  }

  /**
   * $(ANCHOR Culture_current)
   * $(I Property.) Retrieves the культура of the current пользователь.
   * Возвращает: The Культура экземпляр representing the пользователь's current культура.
   */
  public static Культура current() {
    if (currentCulture_ !is пусто)
      return currentCulture_;

    if (userDefaultCulture_ !is пусто) {
      // If the пользователь есть изменён their locale settings since последний we checked, invalidate our данные.
      if (userDefaultCulture_.опр != nativeMethods.getUserCulture())
        userDefaultCulture_ = пусто;
    }
    if (userDefaultCulture_ is пусто) {
      userDefaultCulture_ = new Культура(nativeMethods.getUserCulture());
      if (userDefaultCulture_ is пусто)
        userDefaultCulture_ = инвариантнаяКультура;
      else
        userDefaultCulture_.isReadOnly_ = да;
    }

    return userDefaultCulture_;
  }
  /**
   * $(I Property.) Assigns the культура of the _current пользователь.
   * Параметры: значение = The Культура экземпляр representing the пользователь's _current культура.
   * Examples:
   * The following examples shows как в_ change the _current культура.
   * ---
   * import io.stream.Format, text.locale.Common;
   *
   * проц main() {
   *   // Displays the имя of the current культура.
   *   Println("The current культура is %s.", Культура.current.englishName);
   *
   *   // Changes the current культура в_ el-GR.
   *   Культура.current = new Культура("el-GR");
   *   Println("The current культура is сейчас %s.", Культура.current.englishName);
   * }
   *
   * // Produces the following вывод:
   * // The current культура is English (United Kingdom).
   * // The current культура is сейчас Greek (Greece).
   * ---
   */
  public static проц current(Культура значение) {
    checkNeutral(значение);
    nativeMethods.setUserCulture(значение.опр);
    currentCulture_ = значение;
  }

  /**
   * $(I Property.) Retrieves the invariant Культура.
   * Возвращает: The Культура экземпляр that is invariant.
   * Remarks: The invariant культура is культура-independent. It is not tied в_ any specific region, but is associated
   * with the English language.
   */
  public static Культура инвариантнаяКультура() {
    return invariantCulture_;
  }

  /**
   * $(I Property.) Retrieves the определитель of the Культура.
   * Возвращает: The культура определитель of the current экземпляр.
   * Remarks: The культура определитель corresponds в_ the Windows locale определитель (LCID). It can therefore be used when 
   * interfacing with the Windows NLS functions.
   */
  public цел опр() {
    return cultureData_.lcid;
  }

  /**
   * $(ANCHOR Culture_name)
   * $(I Property.) Retrieves the имя of the Культура in the форматируй &lt;language&gt;"-"&lt;region&gt;.
   * Возвращает: The имя of the current экземпляр. For example, the имя of the UK English культура is "en-GB".
   */
  public ткст имя() {
    return cultureData_.имя;
  }

  /**
   * $(I Property.) Retrieves the имя of the Культура in the форматируй &lt;languagename&gt; (&lt;regionname&gt;) in English.
   * Возвращает: The имя of the current экземпляр in English. For example, the englishName of the UK English культура 
   * is "English (United Kingdom)".
   */
  public ткст englishName() {
    return cultureData_.englishName;
  }

  /**
   * $(I Property.) Retrieves the имя of the Культура in the форматируй &lt;languagename&gt; (&lt;regionname&gt;) in its исконный language.
   * Возвращает: The имя of the current экземпляр in its исконный language. For example, if Культура.имя is "de-DE", nativeName is 
   * "Deutsch (Deutschland)".
   */
  public ткст nativeName() {
    return cultureData_.nativeName;
  }

  /**
   * $(I Property.) Retrieves the two-letter language код of the культура.
   * Возвращает: The two-letter language код of the Культура экземпляр. For example, the twoLetterLanguageName for English is "en".
   */
  public ткст twoLetterLanguageName() {
    return cultureData_.isoLangName;
  }

  /**
   * $(I Property.) Retrieves the three-letter language код of the культура.
   * Возвращает: The three-letter language код of the Культура экземпляр. For example, the threeLetterLanguageName for English is "eng".
   */
  public ткст threeLetterLanguageName() {
    return cultureData_.isoLangName2;
  }

  /**
   * $(I Property.) Retrieves the RFC 3066 опрentification for a language.
   * Возвращает: A ткст representing the RFC 3066 language опрentification.
   */
  public final ткст ietfLanguageTag() {
    return cultureData_.ietfTag;
  }

  /**
   * $(I Property.) Retrieves the Культура representing the предок of the current экземпляр.
   * Возвращает: The Культура representing the предок of the current экземпляр.
   */
  public Культура предок() {
    if (parent_ is пусто) {
      try {
        цел parentCulture = cultureData_.предок;
        if (parentCulture == LCID_INVARIANT)
          parent_ = инвариантнаяКультура;
        else
          parent_ = new Культура(parentCulture);
      }
      catch {
        parent_ = инвариантнаяКультура;
      }
    }
    return parent_;
  }

  /**
   * $(I Property.) Retrieves a значение indicating whether the current экземпляр is a neutral культура.
   * Возвращает: да is the current Культура represents a neutral культура; otherwise, нет.
   * Examples:
   * The following example displays which cultures using Chinese are neutral.
   * ---
   * import io.stream.Format, text.locale.Common;
   *
   * проц main() {
   *   foreach (c; Культура.дайКультуры(ТипыКультур.все)) {
   *     if (c.twoLetterLanguageName == "zh") {
   *       Print(c.englishName);
   *       if (c.isNeutral)
   *         Println("neutral");
   *       else
   *         Println("specific");
   *     }
   *   }
   * }
   *
   * // Produces the following вывод:
   * // Chinese (Simplified) - neutral
   * // Chinese (Taiwan) - specific
   * // Chinese (People's Republic of China) - specific
   * // Chinese (Hong Kong S.A.R.) - specific
   * // Chinese (Singapore) - specific
   * // Chinese (Macao S.A.R.) - specific
   * // Chinese (Traditional) - neutral
   * ---
   */
  public бул isNeutral() {
    return cultureData_.isNeutral;
  }

  /**
   * $(I Property.) Retrieves a значение indicating whether the экземпляр is читай-only.
   * Возвращает: да if the экземпляр is читай-only; otherwise, нет.
   * Remarks: If the культура is читай-only, the $(LINK2 #Culture_dateTimeFormat, форматДатыВремени) and $(LINK2 #Culture_numberFormat, форматЧисла) свойства return 
   * читай-only instances.
   */
  public final бул толькоЧтен_ли() {
    return isReadOnly_;
  }

  /**
   * $(ANCHOR Culture_calendar)
   * $(I Property.) Retrieves the calendar used by the культура.
   * Возвращает: A Calendar экземпляр respresenting the calendar used by the культура.
   */
  public Calendar calendar() {
    if (calendar_ is пусто) {
      calendar_ = getCalendarInstance(cultureData_.типКалендаря, isReadOnly_);
    }
    return calendar_;
  }

  /**
   * $(I Property.) Retrieves the список of calendars that can be used by the культура.
   * Возвращает: An Массив of тип Calendar representing the calendars that can be used by the культура.
   */
  public Calendar[] optionalCalendars() {
    Calendar[] cals = new Calendar[cultureData_.optionalCalendars.length];
    foreach (цел i, цел calID; cultureData_.optionalCalendars)
      cals[i] = getCalendarInstance(calID);
    return cals;
  }

  /**
   * $(ANCHOR Culture_numberFormat)
   * $(I Property.) Retrieves a ФорматЧисла defining the culturally appropriate форматируй for displaying numbers and currency.
   * Возвращает: A ФорматЧисла defining the culturally appropriate форматируй for displaying numbers and currency.
  */
  public ФорматЧисла форматЧисла() {
    checkNeutral(this);
    if (numberFormat_ is пусто) {
      numberFormat_ = new ФорматЧисла(cultureData_);
      numberFormat_.isReadOnly_ = isReadOnly_;
    }
    return numberFormat_;
  }
  /**
   * $(I Property.) Assigns a ФорматЧисла defining the culturally appropriate форматируй for displaying numbers and currency.
   * Параметры: values = A ФорматЧисла defining the culturally appropriate форматируй for displaying numbers and currency.
   */
  public проц форматЧисла(ФорматЧисла значение) {
    checkReadOnly();
    numberFormat_ = значение;
  }

  /**
   * $(ANCHOR Culture_dateTimeFormat)
   * $(I Property.) Retrieves a ФорматДатыВремени defining the culturally appropriate форматируй for displaying dates and times.
   * Возвращает: A ФорматДатыВремени defining the culturally appropriate форматируй for displaying dates and times.
   */
  public ФорматДатыВремени форматДатыВремени() {
    checkNeutral(this);
    if (dateTimeFormat_ is пусто) {
      dateTimeFormat_ = new ФорматДатыВремени(cultureData_, calendar);
      dateTimeFormat_.isReadOnly_ = isReadOnly_;
    }
    return dateTimeFormat_;
  }
  /**
   * $(I Property.) Assigns a ФорматДатыВремени defining the culturally appropriate форматируй for displaying dates and times.
   * Параметры: values = A ФорматДатыВремени defining the culturally appropriate форматируй for displaying dates and times.
   */
  public проц форматДатыВремени(ФорматДатыВремени значение) {
    checkReadOnly();
    dateTimeFormat_ = значение;
  }

  private static проц checkNeutral(Культура культура) {
    if (культура.isNeutral)
      ошибка("Культура '" ~ культура.имя ~ "' is a neutral культура. It cannot be used in formatting and therefore cannot be установи as the current культура.");
  }

  private проц checkReadOnly() {
    if (isReadOnly_)
      ошибка("Instance is читай-only.");
  }

  private static Calendar getCalendarInstance(цел типКалендаря, бул readOnly=нет) {
    switch (типКалендаря) {
      case Calendar.ЯПОНСКИЙ:
        return new Japanese();
      case Calendar.ТАЙВАНЬСКИЙ:
        return new Taiwan();
      case Calendar.КОРЕЙСКИЙ:
        return new Korean();
      case Calendar.ХИДЖРИ:
        return new Hijri();
      case Calendar.ТАИ:
        return new ThaiBuddhist();
      case Calendar.ЕВРЕЙСКИЙ:
        return new Hebrew;
      case Calendar.GREGORIAN_US:
      case Calendar.ГРЕГОРИАН_СВ_ФРАНЦ:
      case Calendar.ГРЕГОРИАН_АРАБ:
      case Calendar.ГРЕГОРИАН_ТРАНСЛИТ_АНГЛ:
      case Calendar.ГРЕГОРИАН_ТРАНСЛИТ_ФРАНЦ:
        return new Gregorian(cast(Gregorian.Тип) типКалендаря);
      default:
        break;
    }
    return new Gregorian();
  }

}

/**
 * $(ANCHOR _Region)
 * Provопрes information about a region.
 * Remarks: Регион does not represent пользователь preferences. It does not depend on the пользователь's language or культура.
 * Examples:
 * The following example displays some of the свойства of the Регион class:
 * ---
 * import io.stream.Format, text.locale.Common;
 *
 * проц main() {
 *   Регион region = new Регион("en-GB");
 *   Println("имя:              %s", region.имя);
 *   Println("englishName:       %s", region.englishName);
 *   Println("isMetric:          %s", region.isMetric);
 *   Println("currencySymbol:    %s", region.currencySymbol);
 *   Println("isoCurrencySymbol: %s", region.isoCurrencySymbol);
 * }
 *
 * // Produces the following вывод.
 * // имя:              en-GB
 * // englishName:       United Kingdom
 * // isMetric:          да
 * // currencySymbol:    £
 * // isoCurrencySymbol: GBP
 * ---
 */
public class Регион {

  private ДанныеОКультуре* cultureData_;
  private static Регион currentRegion_;
  private ткст name_;

  /**
   * Initializes a new Регион экземпляр based on the region associated with the specified культура определитель.
   * Параметры: идКультуры = A культура indentifier.
   * Remarks: The имя of the Регион экземпляр is установи в_ the ISO 3166 two-letter код for that region.
   */
  public this(цел идКультуры) {
    cultureData_ = ДанныеОКультуре.дайДанныеИзИДКультуры(идКультуры);
    if (cultureData_.isNeutral)
        ошибка ("Cannot use a neutral культура в_ создай a region.");
    name_ = cultureData_.regionName;
  }

  /**
   * $(ANCHOR Region_ctor_name)
   * Initializes a new Регион экземпляр based on the region specified by имя.
   * Параметры: имя = A two-letter ISO 3166 код for the region. Or, a культура $(LINK2 #Culture_name, _name) consisting of the language and region.
   */
  public this(ткст имя) {
    cultureData_ = ДанныеОКультуре.getDataFromRegionName(имя);
    name_ = имя;
    if (cultureData_.isNeutral)
        ошибка ("The region имя " ~ имя ~ " corresponds в_ a neutral культура and cannot be used в_ создай a region.");
  }

  package this(ДанныеОКультуре* данныеОКультуре) {
    cultureData_ = данныеОКультуре;
    name_ = данныеОКультуре.regionName;
  }

  /**
   * $(I Property.) Retrieves the Регион used by the current $(LINK2 #Культура, Культура).
   * Возвращает: The Регион экземпляр associated with the current Культура.
   */
  public static Регион current() {
    if (currentRegion_ is пусто)
      currentRegion_ = new Регион(Культура.current.cultureData_);
    return currentRegion_;
  }

  /**
   * $(I Property.) Retrieves a unique определитель for the geographical location of the region.
   * Возвращает: An $(B цел) uniquely опрentifying the geographical location.
   */
  public цел geoID() {
    return cultureData_.geoId;
  }

  /**
   * $(ANCHOR Region_name)
   * $(I Property.) Retrieves the ISO 3166 код, or the имя, of the current Регион.
   * Возвращает: The значение specified by the имя parameter of the $(LINK2 #Region_ctor_name, Регион(ткст)) constructor.
   */
  public ткст имя() {
    return name_;
  }

  /**
   * $(I Property.) Retrieves the full имя of the region in English.
   * Возвращает: The full имя of the region in English.
   */
  public ткст englishName() {
    return cultureData_.englishCountry;
  }

  /**
   * $(I Property.) Retrieves the full имя of the region in its исконный language.
   * Возвращает: The full имя of the region in the language associated with the region код.
   */
  public ткст nativeName() {
    return cultureData_.nativeCountry;
  }

  /**
   * $(I Property.) Retrieves the two-letter ISO 3166 код of the region.
   * Возвращает: The two-letter ISO 3166 код of the region.
   */
  public ткст twoLetterRegionName() {
    return cultureData_.regionName;
  }

  /**
   * $(I Property.) Retrieves the three-letter ISO 3166 код of the region.
   * Возвращает: The three-letter ISO 3166 код of the region.
   */
  public ткст threeLetterRegionName() {
    return cultureData_.isoRegionName;
  }

  /**
   * $(I Property.) Retrieves the currency symbol of the region.
   * Возвращает: The currency symbol of the region.
   */
  public ткст currencySymbol() {
    return cultureData_.currency;
  }

  /**
   * $(I Property.) Retrieves the three-character currency symbol of the region.
   * Возвращает: The three-character currency symbol of the region.
   */
  public ткст isoCurrencySymbol() {
    return cultureData_.intlSymbol;
  }

  /**
   * $(I Property.) Retrieves the имя in English of the currency used in the region.
   * Возвращает: The имя in English of the currency used in the region.
   */
  public ткст currencyEnglishName() {
    return cultureData_.englishCurrency;
  }

  /**
   * $(I Property.) Retrieves the имя in the исконный language of the region of the currency used in the region.
   * Возвращает: The имя in the исконный language of the region of the currency used in the region.
   */
  public ткст currencyNativeName() {
    return cultureData_.nativeCurrency;
  }

  /**
   * $(I Property.) Retrieves a значение indicating whether the region uses the metric system for measurements.
   * Возвращает: да is the region uses the metric system; otherwise, нет.
   */
  public бул isMetric() {
    return cultureData_.isMetric;
  }

  /**
   * Returns a ткст containing the ISO 3166 код, or the $(LINK2 #Region_name, имя), of the current Регион.
   * Возвращает: A ткст containing the ISO 3166 код, or the имя, of the current Регион.
   */
  public override ткст вТкст() {
    return name_;
  }

}

/**
 * $(ANCHOR _NumberFormat)
 * Determines как numbers are formatted, according в_ the current культура.
 * Remarks: Numbers are formatted using форматируй образцы retrieved из_ a ФорматЧисла экземпляр.
 * This class реализует $(LINK2 #IFormatService_getFormat, ИСлужбаФормата.дайФормат).
 * Examples:
 * The following example shows как в_ retrieve an экземпляр of ФорматЧисла for a Культура
 * and use it в_ display число formatting information.
 * ---
 * import io.stream.Format, text.locale.Common;
 *
 * проц main(ткст[] арги) {
 *   foreach (c; Культура.дайКультуры(ТипыКультур.Особый)) {
 *     if (c.twoLetterLanguageName == "en") {
 *       ФорматЧисла фмт = c.форматЧисла;
 *       Println("The currency symbol for %s is '%s'", 
 *         c.englishName, 
 *         фмт.currencySymbol);
 *     }
 *   }
 * }
 *
 * // Produces the following вывод:
 * // The currency symbol for English (United States) is '$'
 * // The currency symbol for English (United Kingdom) is '£'
 * // The currency symbol for English (Australia) is '$'
 * // The currency symbol for English (Canada) is '$'
 * // The currency symbol for English (New Zealand) is '$'
 * // The currency symbol for English (Ireland) is '€'
 * // The currency symbol for English (South Africa) is 'R'
 * // The currency symbol for English (Jamaica) is 'J$'
 * // The currency symbol for English (Caribbean) is '$'
 * // The currency symbol for English (Belize) is 'BZ$'
 * // The currency symbol for English (Trinопрad and Tobago) is 'TT$'
 * // The currency symbol for English (Zimbabwe) is 'Z$'
 * // The currency symbol for English (Republic of the PhilИПpines) is 'Php'
 *---
 */
public class ФорматЧисла : ИСлужбаФормата {

  package бул isReadOnly_;
  private static ФорматЧисла invariantFormat_;

  private цел numberDecimalDigits_;
  private цел numberNegativePattern_;
  private цел currencyDecimalDigits_;
  private цел currencyNegativePattern_;
  private цел currencyPositivePattern_;
  private цел[] numberGroupSizes_;
  private цел[] currencyGroupSizes_;
  private ткст numberGroupSeparator_;
  private ткст numberDecimalSeparator_;
  private ткст currencyGroupSeparator_;
  private ткст currencyDecimalSeparator_;
  private ткст currencySymbol_;
  private ткст negativeSign_;
  private ткст positiveSign_;
  private ткст nanSymbol_;
  private ткст negativeInfinitySymbol_;
  private ткст positiveInfinitySymbol_;
  private ткст[] nativeDigits_;

  /**
   * Initializes a new, culturally independent экземпляр.
   *
   * Remarks: Modify the свойства of the new экземпляр в_ define custom formatting.
   */
  public this() {
    this(пусто);
  }

  package this(ДанныеОКультуре* данныеОКультуре) {
    // Initialize invariant данные.
    numberDecimalDigits_ = 2;
    numberNegativePattern_ = 1;
    currencyDecimalDigits_ = 2;
    numberGroupSizes_ = массивИз!(цел)(3);
    currencyGroupSizes_ = массивИз!(цел)(3);
    numberGroupSeparator_ = ",";
    numberDecimalSeparator_ = ".";
    currencyGroupSeparator_ = ",";
    currencyDecimalSeparator_ = ".";
    currencySymbol_ = "\u00A4";
    negativeSign_ = "-";
    positiveSign_ = "+";
    nanSymbol_ = "НЧ";
    negativeInfinitySymbol_ = "-Infinity";
    positiveInfinitySymbol_ = "Infinity";
    nativeDigits_ = массивИз!(ткст)("0", "1", "2", "3", "4", "5", "6", "7", "8", "9");

    if (данныеОКультуре !is пусто && данныеОКультуре.lcid != Культура.LCID_INVARIANT) {
      // Initialize культура-specific данные.
      numberDecimalDigits_ = данныеОКультуре.digits;
      numberNegativePattern_ = данныеОКультуре.negativeNumber;
      currencyDecimalDigits_ = данныеОКультуре.currencyDigits;
      currencyNegativePattern_ = данныеОКультуре.negativeCurrency;
      currencyPositivePattern_ = данныеОКультуре.positiveCurrency;
      numberGroupSizes_ = данныеОКультуре.grouping;
      currencyGroupSizes_ = данныеОКультуре.monetaryGrouping;
      numberGroupSeparator_ = данныеОКультуре.thousand;
      numberDecimalSeparator_ = данныеОКультуре.decimal;
      currencyGroupSeparator_ = данныеОКультуре.monetaryThousand;
      currencyDecimalSeparator_ = данныеОКультуре.monetaryDecimal;
      currencySymbol_ = данныеОКультуре.currency;
      negativeSign_ = данныеОКультуре.negativeSign;
      positiveSign_ = данныеОКультуре.positiveSign;
      nanSymbol_ = данныеОКультуре.nan;
      negativeInfinitySymbol_ = данныеОКультуре.negInfinity;
      positiveInfinitySymbol_ = данныеОКультуре.posInfinity;
      nativeDigits_ = данныеОКультуре.nativeDigits;
    }
  }

  /**
   * Retrieves an объект defining как в_ форматируй the specified тип.
   * Параметры: тип = The ИнфОТипе of the resulting formatting объект.
   * Возвращает: If тип is typeid($(LINK2 #ФорматЧисла, ФорматЧисла)), the current ФорматЧисла экземпляр. Otherwise, пусто.
   * Remarks: Implements $(LINK2 #IFormatService_getFormat, ИСлужбаФормата.дайФормат).
   */
  public Объект дайФормат(ИнфОТипе тип) {
    return (тип is typeid(ФорматЧисла)) ? this : пусто;
  }

version (Clone)
{
  /**
   * Creates a копируй of the экземпляр.
   */
  public Объект clone() {
    ФорматЧисла копируй = cast(ФорматЧисла)клонируйОбъект(this);
    копируй.isReadOnly_ = нет;
    return копируй;
  }
}

  /**
   * Retrieves the ФорматЧисла for the specified $(LINK2 #ИСлужбаФормата, ИСлужбаФормата).
   * Параметры: службаФормата = The ИСлужбаФормата used в_ retrieve ФорматЧисла.
   * Возвращает: The ФорматЧисла for the specified ИСлужбаФормата.
   * Remarks: The метод calls $(LINK2 #IFormatService_getFormat, ИСлужбаФормата.дайФормат) with typeof(ФорматЧисла). If службаФормата is пусто,
   * then the значение of the current property is returned.
   */
  public static ФорматЧисла дайЭкземпляр(ИСлужбаФормата службаФормата) {
    Культура культура = cast(Культура)службаФормата;
    if (культура !is пусто) {
      if (культура.numberFormat_ !is пусто)
        return культура.numberFormat_;
      return культура.форматЧисла;
    }
    if (ФорматЧисла форматЧисла = cast(ФорматЧисла)службаФормата)
      return форматЧисла;
    if (службаФормата !is пусто) {
      if (ФорматЧисла форматЧисла = cast(ФорматЧисла)(службаФормата.дайФормат(typeid(ФорматЧисла))))
        return форматЧисла;
    }
    return current;
  }

  /**
   * $(I Property.) Retrieves a читай-only ФорматЧисла экземпляр из_ the current культура.
   * Возвращает: A читай-only ФорматЧисла экземпляр из_ the current культура.
   */
  public static ФорматЧисла current() {
    return Культура.current.форматЧисла;
  }

  /**
   * $(ANCHOR NumberFormat_invariantFormat)
   * $(I Property.) Retrieves the читай-only, culturally independent ФорматЧисла экземпляр.
   * Возвращает: The читай-only, culturally independent ФорматЧисла экземпляр.
   */
  public static ФорматЧисла инвариантныйФормат() {
    if (invariantFormat_ is пусто) {
      invariantFormat_ = new ФорматЧисла;
      invariantFormat_.isReadOnly_ = да;
    }
    return invariantFormat_;
  }

  /**
   * $(I Property.) Retrieves a значение indicating whether the экземпляр is читай-only.
   * Возвращает: да if the экземпляр is читай-only; otherwise, нет.
   */
  public final бул толькоЧтен_ли() {
    return isReadOnly_;
  }

  /**
   * $(I Property.) Retrieves the число of decimal places used for numbers.
   * Возвращает: The число of decimal places used for numbers. For $(LINK2 #NumberFormat_invariantFormat, инвариантныйФормат), the default is 2.
   */
  public final цел члоДесятичнЦифр() {
    return numberDecimalDigits_;
  }
  /**
   * Assigns the число of decimal digits used for numbers.
   * Параметры: значение = The число of decimal places used for numbers.
   * Throws: Исключение if the property is being установи and the экземпляр is читай-only.
   * Examples:
   * The following example shows the effect of changing члоДесятичнЦифр.
   * ---
   * import io.stream.Format, text.locale.Common;
   *
   * проц main() {
   *   // Get the ФорматЧисла из_ the en-GB культура.
   *   ФорматЧисла фмт = (new Культура("en-GB")).форматЧисла;
   *
   *   // Display a значение with the default число of decimal digits.
   *   цел n = 5678;
   *   Println(Форматировщик.форматируй(фмт, "{0:N}", n));
   *
   *   // Display the значение with six decimal digits.
   *   фмт.члоДесятичнЦифр = 6;
   *   Println(Форматировщик.форматируй(фмт, "{0:N}", n));
   * }
   *
   * // Produces the following вывод:
   * // 5,678.00
   * // 5,678.000000
   * ---
   */
  public final проц члоДесятичнЦифр(цел значение) {
    checkReadOnly();
    numberDecimalDigits_ = значение;
  }

  /**
   * $(I Property.) Retrieves the форматируй образец for negative numbers.
   * Возвращает: The форматируй образец for negative numbers. For инвариантныйФормат, the default is 1 (representing "-n").
   * Remarks: The following table shows valid values for this property.
   *
   * <table class="definitionTable">
   * <tr><th>Значение</th><th>образец</th></tr>
   * <tr><td>0</td><td>(n)</td></tr>
   * <tr><td>1</td><td>-n</td></tr>
   * <tr><td>2</td><td>- n</td></tr>
   * <tr><td>3</td><td>n-</td></tr>
   * <tr><td>4</td><td>n -</td></tr>
   * </table>
   */
  public final цел члоОтрицатОбразцов() {
    return numberNegativePattern_;
  }
  /**
   * $(I Property.) Assigns the форматируй образец for negative numbers.
   * Параметры: значение = The форматируй образец for negative numbers.
   * Examples:
   * The following example shows the effect of the different образцы.
   * ---
   * import io.stream.Format, text.locale.Common;
   *
   * проц main() {
   *   ФорматЧисла фмт = new ФорматЧисла;
   *   цел n = -5678;
   *
   *   // Display the default образец.
   *   Println(Форматировщик.форматируй(фмт, "{0:N}", n));
   *
   *   // Display все образцы.
   *   for (цел i = 0; i <= 4; i++) {
   *     фмт.члоОтрицатОбразцов = i;
   *     Println(Форматировщик.форматируй(фмт, "{0:N}", n));
   *   }
   * }
   *
   * // Produces the following вывод:
   * // (5,678.00)
   * // (5,678.00)
   * // -5,678.00
   * // - 5,678.00
   * // 5,678.00-
   * // 5,678.00 -
   * ---
   */
  public final проц члоОтрицатОбразцов(цел значение) {
    checkReadOnly();
    numberNegativePattern_ = значение;
  }

  /**
   * $(I Property.) Retrieves the число of decimal places в_ use in currency values.
   * Возвращает: The число of decimal digits в_ use in currency values.
   */
  public final цел валютнДесятичнЦифры() {
    return currencyDecimalDigits_;
  }
  /**
   * $(I Property.) Assigns the число of decimal places в_ use in currency values.
   * Параметры: значение = The число of decimal digits в_ use in currency values.
   */
  public final проц валютнДесятичнЦифры(цел значение) {
    checkReadOnly();
    currencyDecimalDigits_ = значение;
  }

  /**
   * $(I Property.) Retrieves the formal образец в_ use for negative currency values.
   * Возвращает: The форматируй образец в_ use for negative currency values.
   */
  public final цел валютнОтрицатОбразец() {
    return currencyNegativePattern_;
  }
  /**
   * $(I Property.) Assigns the formal образец в_ use for negative currency values.
   * Параметры: значение = The форматируй образец в_ use for negative currency values.
   */
  public final проц валютнОтрицатОбразец(цел значение) {
    checkReadOnly();
    currencyNegativePattern_ = значение;
  }

  /**
   * $(I Property.) Retrieves the formal образец в_ use for positive currency values.
   * Возвращает: The форматируй образец в_ use for positive currency values.
   */
  public final цел валютнПоложитОбразец() {
    return currencyPositivePattern_;
  }
  /**
   * $(I Property.) Assigns the formal образец в_ use for positive currency values.
   * Возвращает: The форматируй образец в_ use for positive currency values.
   */
  public final проц валютнПоложитОбразец(цел значение) {
    checkReadOnly();
    currencyPositivePattern_ = значение;
  }

  /**
   * $(I Property.) Retrieves the число of digits цел each группа в_ the left of the decimal place in numbers.
   * Возвращает: The число of digits цел each группа в_ the left of the decimal place in numbers.
   */
  public final цел[] numberGroupSizes() {
    return numberGroupSizes_;
  }
  /**
   * $(I Property.) Assigns the число of digits цел each группа в_ the left of the decimal place in numbers.
   * Параметры: значение = The число of digits цел each группа в_ the left of the decimal place in numbers.
   */
  public final проц numberGroupSizes(цел[] значение) {
    checkReadOnly();
    numberGroupSizes_ = значение;
  }

  /**
   * $(I Property.) Retrieves the число of digits цел each группа в_ the left of the decimal place in currency values.
   * Возвращает: The число of digits цел each группа в_ the left of the decimal place in currency values.
   */
  public final цел[] currencyGroupSizes() {
    return currencyGroupSizes_;
  }
  /**
   * $(I Property.) Assigns the число of digits цел each группа в_ the left of the decimal place in currency values.
   * Параметры: значение = The число of digits цел each группа в_ the left of the decimal place in currency values.
   */
  public final проц currencyGroupSizes(цел[] значение) {
    checkReadOnly();
    currencyGroupSizes_ = значение;
  }

  /**
   * $(I Property.) Retrieves the ткст separating groups of digits в_ the left of the decimal place in numbers.
   * Возвращает: The ткст separating groups of digits в_ the left of the decimal place in numbers. For example, ",".
   */
  public final ткст разделительЧисловыхГрупп() {
    return numberGroupSeparator_;
  }
  /**
   * $(I Property.) Assigns the ткст separating groups of digits в_ the left of the decimal place in numbers.
   * Параметры: значение = The ткст separating groups of digits в_ the left of the decimal place in numbers.
   */
  public final проц разделительЧисловыхГрупп(ткст значение) {
    checkReadOnly();
    numberGroupSeparator_ = значение;
  }

  /**
   * $(I Property.) Retrieves the ткст used as the decimal разделитель in numbers.
   * Возвращает: The ткст used as the decimal разделитель in numbers. For example, ".".
   */
  public final ткст разделительЧисловыхДесятков() {
    return numberDecimalSeparator_;
  }
  /**
   * $(I Property.) Assigns the ткст used as the decimal разделитель in numbers.
   * Параметры: значение = The ткст used as the decimal разделитель in numbers.
   */
  public final проц разделительЧисловыхДесятков(ткст значение) {
    checkReadOnly();
    numberDecimalSeparator_ = значение;
  }

  /**
   * $(I Property.) Retrieves the ткст separating groups of digits в_ the left of the decimal place in currency values.
   * Возвращает: The ткст separating groups of digits в_ the left of the decimal place in currency values. For example, ",".
   */
  public final ткст currencyGroupSeparator() {
    return currencyGroupSeparator_;
  }
  /**
   * $(I Property.) Assigns the ткст separating groups of digits в_ the left of the decimal place in currency values.
   * Параметры: значение = The ткст separating groups of digits в_ the left of the decimal place in currency values.
   */
  public final проц currencyGroupSeparator(ткст значение) {
    checkReadOnly();
    currencyGroupSeparator_ = значение;
  }

  /**
   * $(I Property.) Retrieves the ткст used as the decimal разделитель in currency values.
   * Возвращает: The ткст used as the decimal разделитель in currency values. For example, ".".
   */
  public final ткст currencyDecimalSeparator() {
    return currencyDecimalSeparator_;
  }
  /**
   * $(I Property.) Assigns the ткст used as the decimal разделитель in currency values.
   * Параметры: значение = The ткст used as the decimal разделитель in currency values.
   */
  public final проц currencyDecimalSeparator(ткст значение) {
    checkReadOnly();
    currencyDecimalSeparator_ = значение;
  }

  /**
   * $(I Property.) Retrieves the ткст used as the currency symbol.
   * Возвращает: The ткст used as the currency symbol. For example, "£".
   */
  public final ткст currencySymbol() {
    return currencySymbol_;
  }
  /**
   * $(I Property.) Assigns the ткст used as the currency symbol.
   * Параметры: значение = The ткст used as the currency symbol.
   */
  public final проц currencySymbol(ткст значение) {
    checkReadOnly();
    currencySymbol_ = значение;
  }

  /**
   * $(I Property.) Retrieves the ткст denoting that a число is negative.
   * Возвращает: The ткст denoting that a число is negative. For example, "-".
   */
  public final ткст negativeSign() {
    return negativeSign_;
  }
  /**
   * $(I Property.) Assigns the ткст denoting that a число is negative.
   * Параметры: значение = The ткст denoting that a число is negative.
   */
  public final проц negativeSign(ткст значение) {
    checkReadOnly();
    negativeSign_ = значение;
  }

  /**
   * $(I Property.) Retrieves the ткст denoting that a число is positive.
   * Возвращает: The ткст denoting that a число is positive. For example, "+".
   */
  public final ткст positiveSign() {
    return positiveSign_;
  }
  /**
   * $(I Property.) Assigns the ткст denoting that a число is positive.
   * Параметры: значение = The ткст denoting that a число is positive.
   */
  public final проц positiveSign(ткст значение) {
    checkReadOnly();
    positiveSign_ = значение;
  }

  /**
   * $(I Property.) Retrieves the ткст representing the НЧ (not a число) значение.
   * Возвращает: The ткст representing the НЧ значение. For example, "НЧ".
   */
  public final ткст nanSymbol() {
    return nanSymbol_;
  }
  /**
   * $(I Property.) Assigns the ткст representing the НЧ (not a число) значение.
   * Параметры: значение = The ткст representing the НЧ значение.
   */
  public final проц nanSymbol(ткст значение) {
    checkReadOnly();
    nanSymbol_ = значение;
  }

  /**
   * $(I Property.) Retrieves the ткст representing negative infinity.
   * Возвращает: The ткст representing negative infinity. For example, "-Infinity".
   */
  public final ткст negativeInfinitySymbol() {
    return negativeInfinitySymbol_;
  }
  /**
   * $(I Property.) Assigns the ткст representing negative infinity.
   * Параметры: значение = The ткст representing negative infinity.
   */
  public final проц negativeInfinitySymbol(ткст значение) {
    checkReadOnly();
    negativeInfinitySymbol_ = значение;
  }

  /**
   * $(I Property.) Retrieves the ткст representing positive infinity.
   * Возвращает: The ткст representing positive infinity. For example, "Infinity".
   */
  public final ткст positiveInfinitySymbol() {
    return positiveInfinitySymbol_;
  }
  /**
   * $(I Property.) Assigns the ткст representing positive infinity.
   * Параметры: значение = The ткст representing positive infinity.
   */
  public final проц positiveInfinitySymbol(ткст значение) {
    checkReadOnly();
    positiveInfinitySymbol_ = значение;
  }

  /**
   * $(I Property.) Retrieves a ткст Массив of исконный equivalents of the digits 0 в_ 9.
   * Возвращает: A ткст Массив of исконный equivalents of the digits 0 в_ 9.
   */
  public final ткст[] nativeDigits() {
    return nativeDigits_;
  }
  /**
   * $(I Property.) Assigns a ткст Массив of исконный equivalents of the digits 0 в_ 9.
   * Параметры: значение = A ткст Массив of исконный equivalents of the digits 0 в_ 9.
   */
  public final проц nativeDigits(ткст[] значение) {
    checkReadOnly();
    nativeDigits_ = значение;
  }

  private проц checkReadOnly() {
    if (isReadOnly_)
        ошибка("ФорматЧисла экземпляр is читай-only.");
  }

}

/**
 * $(ANCHOR _DateTimeFormat)
 * Determines как $(LINK2 #Время, Время) values are formatted, depending on the культура.
 * Remarks: To создай a ФорматДатыВремени for a specific культура, создай a $(LINK2 #Культура, Культура) for that культура and
 * retrieve its $(LINK2 #Culture_dateTimeFormat, форматДатыВремени) property. To создай a ФорматДатыВремени for the пользователь's current 
 * культура, use the $(LINK2 #Culture_current, current) property.
 */
public class ФорматДатыВремени : ИСлужбаФормата {

  private const ткст rfc1123Pattern_ = "ddd, dd MMM yyyy HH':'mm':'ss 'GMT'";
  private const ткст sortableDateTimePattern_ = "yyyy'-'MM'-'dd'T'HH':'mm':'ss";
  private const ткст universalSortableDateTimePattern_ = "yyyy'-'MM'-'dd' 'HH':'mm':'ss'Z'";
  private const ткст allStandardFormats = [ 'd', 'D', 'f', 'F', 'g', 'G', 'm', 'M', 'r', 'R', 's', 't', 'T', 'u', 'U', 'y', 'Y' ];


  package бул isReadOnly_;
  private static ФорматДатыВремени invariantFormat_;
  private ДанныеОКультуре* cultureData_;

  private Calendar calendar_;
  private цел[] optionalCalendars_;
  private цел firstДеньНедели_ = -1;
  private цел calendarWeekRule_ = -1;
  private ткст dateSeparator_;
  private ткст timeSeparator_;
  private ткст amDesignator_;
  private ткст pmDesignator_;
  private ткст shortDatePattern_;
  private ткст shortTimePattern_;
  private ткст longDatePattern_;
  private ткст longTimePattern_;
  private ткст monthDayPattern_;
  private ткст yearMonthPattern_;
  private ткст[] abbreviatedDayNames_;
  private ткст[] dayNames_;
  private ткст[] abbreviatedMonthNames_;
  private ткст[] monthNames_;

  private ткст fullDateTimePattern_;
  private ткст generalShortTimePattern_;
  private ткст generalLongTimePattern_;

  private ткст[] shortTimePatterns_;
  private ткст[] shortDatePatterns_;
  private ткст[] longTimePatterns_;
  private ткст[] longDatePatterns_;
  private ткст[] yearMonthPatterns_;

  /**
   * $(ANCHOR DateTimeFormat_ctor)
   * Initializes an экземпляр that is записываемый and культура-independent.
   */
  package this() {
    // This ctor is used by инвариантныйФормат so we can't установи the calendar property.
    cultureData_ = Культура.инвариантнаяКультура.cultureData_;
    calendar_ = Gregorian.generic;
    инициализуй();
  }

  package this(ДанныеОКультуре* данныеОКультуре, Calendar calendar) {
    cultureData_ = данныеОКультуре;
    this.calendar = calendar;
  }

  /**
   * $(ANCHOR DateTimeFormat_getFormat)
   * Retrieves an объект defining как в_ форматируй the specified тип.
   * Параметры: тип = The ИнфОТипе of the resulting formatting объект.
   * Возвращает: If тип is typeid(ФорматДатыВремени), the current ФорматДатыВремени экземпляр. Otherwise, пусто.
   * Remarks: Implements $(LINK2 #IFormatService_getFormat, ИСлужбаФормата.дайФормат).
   */
  public Объект дайФормат(ИнфОТипе тип) {
    return (тип is typeid(ФорматДатыВремени)) ? this : пусто;
  }

version(Clone)
{
  /**
   */
  public Объект clone() {
    ФорматДатыВремени другой = cast(ФорматДатыВремени)клонируйОбъект(this);
    другой.calendar_ = cast(Calendar)calendar.clone();
    другой.isReadOnly_ = нет;
    return другой;
  }
}

  package ткст[] shortTimePatterns() {
    if (shortTimePatterns_ is пусто)
      shortTimePatterns_ = cultureData_.shortTimes;
    return shortTimePatterns_.dup;
  }

  package ткст[] shortDatePatterns() {
    if (shortDatePatterns_ is пусто)
      shortDatePatterns_ = cultureData_.shortDates;
    return shortDatePatterns_.dup;
  }

  package ткст[] longTimePatterns() {
    if (longTimePatterns_ is пусто)
      longTimePatterns_ = cultureData_.longTimes;
    return longTimePatterns_.dup;
  }

  package ткст[] longDatePatterns() {
    if (longDatePatterns_ is пусто)
      longDatePatterns_ = cultureData_.longDates;
    return longDatePatterns_.dup;
  }

  package ткст[] yearMonthPatterns() {
    if (yearMonthPatterns_ is пусто)
      yearMonthPatterns_ = cultureData_.yearMonths;
    return yearMonthPatterns_;
  }

  /**
   * $(ANCHOR DateTimeFormat_getAllDateTimePatterns)
   * Retrieves the стандарт образцы in which Время values can be formatted.
   * Возвращает: An Массив of strings containing the стандарт образцы in which Время values can be formatted.
   */
  public final ткст[] дайВсеОбразцыДатыВремени() {
    ткст[] результат;
    foreach (сим форматируй; ФорматДатыВремени.allStandardFormats)
      результат ~= дайВсеОбразцыДатыВремени(форматируй);
    return результат;
  }

  /**
   * $(ANCHOR DateTimeFormat_getAllDateTimePatterns_char)
   * Retrieves the стандарт образцы in which Время values can be formatted using the specified форматируй character.
   * Возвращает: An Массив of strings containing the стандарт образцы in which Время values can be formatted using the specified форматируй character.
   */
  public final ткст[] дайВсеОбразцыДатыВремени(сим форматируй) {

    ткст[] combinePatterns(ткст[] patterns1, ткст[] patterns2) {
      ткст[] результат = new ткст[patterns1.length * patterns2.length];
      for (цел i = 0; i < patterns1.length; i++) {
        for (цел j = 0; j < patterns2.length; j++)
          результат[i * patterns2.length + j] = patterns1[i] ~ " " ~ patterns2[j];
      }
      return результат;
    }

    // форматируй must be one of allStandardFormats.
    ткст[] результат;
    switch (форматируй) {
      case 'd':
        результат ~= shortDatePatterns;
        break;
      case 'D':
        результат ~= longDatePatterns;
        break;
      case 'f':
        результат ~= combinePatterns(longDatePatterns, shortTimePatterns);
        break;
      case 'F':
        результат ~= combinePatterns(longDatePatterns, longTimePatterns);
        break;
      case 'g':
        результат ~= combinePatterns(shortDatePatterns, shortTimePatterns);
        break;
      case 'G':
        результат ~= combinePatterns(shortDatePatterns, longTimePatterns);
        break;
      case 'm':
      case 'M':
        результат ~= monthDayPattern;
        break;
      case 'r':
      case 'R':
        результат ~= rfc1123Pattern_;
        break;
      case 's':
        результат ~= sortableDateTimePattern_;
        break;
      case 't':
        результат ~= shortTimePatterns;
        break;
      case 'T':
        результат ~= longTimePatterns;
        break;
      case 'u':
        результат ~= universalSortableDateTimePattern_;
        break;
      case 'U':
        результат ~= combinePatterns(longDatePatterns, longTimePatterns);
        break;
      case 'y':
      case 'Y':
        результат ~= yearMonthPatterns;
        break;
      default:
        ошибка("The specified форматируй was not valid.");
    }
    return результат;
  }

  /**
   * $(ANCHOR DateTimeFormat_getAbbreviatedDayName)
   * Retrieves the abbreviated имя of the specified день of the week based on the культура of the экземпляр.
   * Параметры: ДеньНедели = A ДеньНедели значение.
   * Возвращает: The abbreviated имя of the день of the week represented by ДеньНедели.
   */
  public final ткст getAbbreviatedDayName(Calendar.ДеньНедели ДеньНедели) {
    return abbreviatedDayNames[cast(цел)ДеньНедели];
  }

  /**
   * $(ANCHOR DateTimeFormat_getDayName)
   * Retrieves the full имя of the specified день of the week based on the культура of the экземпляр.
   * Параметры: ДеньНедели = A ДеньНедели значение.
   * Возвращает: The full имя of the день of the week represented by ДеньНедели.
   */
  public final ткст getDayName(Calendar.ДеньНедели ДеньНедели) {
    return dayNames[cast(цел)ДеньНедели];
  }

  /**
   * $(ANCHOR DateTimeFormat_getAbbreviatedMonthName)
   * Retrieves the abbreviated имя of the specified месяц based on the культура of the экземпляр.
   * Параметры: месяц = An целое between 1 and 13 indicating the имя of the _month в_ return.
   * Возвращает: The abbreviated имя of the _month represented by месяц.
   */
  public final ткст getAbbreviatedMonthName(цел месяц) {
    return abbreviatedMonthNames[месяц - 1];
  }

  /**
   * $(ANCHOR DateTimeFormat_getMonthName)
   * Retrieves the full имя of the specified месяц based on the культура of the экземпляр.
   * Параметры: месяц = An целое between 1 and 13 indicating the имя of the _month в_ return.
   * Возвращает: The full имя of the _month represented by месяц.
   */
  public final ткст getMonthName(цел месяц) {
    return monthNames[месяц - 1];
  }

  /**
   * $(ANCHOR DateTimeFormat_getInstance)
   * Retrieves the ФорматДатыВремени for the specified ИСлужбаФормата.
   * Параметры: службаФормата = The ИСлужбаФормата used в_ retrieve ФорматДатыВремени.
   * Возвращает: The ФорматДатыВремени for the specified ИСлужбаФормата.
   * Remarks: The метод calls $(LINK2 #IFormatService_getFormat, ИСлужбаФормата.дайФормат) with typeof(ФорматДатыВремени). If службаФормата is пусто,
   * then the значение of the current property is returned.
   */
  public static ФорматДатыВремени дайЭкземпляр(ИСлужбаФормата службаФормата) {
    Культура культура = cast(Культура)службаФормата;
    if (культура !is пусто) {
      if (культура.dateTimeFormat_ !is пусто)
        return культура.dateTimeFormat_;
      return культура.форматДатыВремени;
    }
    if (ФорматДатыВремени форматДатыВремени = cast(ФорматДатыВремени)службаФормата)
      return форматДатыВремени;
    if (службаФормата !is пусто) {
      if (ФорматДатыВремени форматДатыВремени = cast(ФорматДатыВремени)(службаФормата.дайФормат(typeid(ФорматДатыВремени))))
        return форматДатыВремени;
    }
    return current;
  }

  /**
   * $(ANCHOR DateTimeFormat_current)
   * $(I Property.) Retrieves a читай-only ФорматДатыВремени экземпляр из_ the current культура.
   * Возвращает: A читай-only ФорматДатыВремени экземпляр из_ the current культура.
   */
  public static ФорматДатыВремени current() {
    return Культура.current.форматДатыВремени;
  }

  /**
   * $(ANCHOR DateTimeFormat_invariantFormat)
   * $(I Property.) Retrieves a читай-only ФорматДатыВремени экземпляр that is culturally independent.
   * Возвращает: A читай-only ФорматДатыВремени экземпляр that is culturally independent.
   */
  public static ФорматДатыВремени инвариантныйФормат() {
    if (invariantFormat_ is пусто) {
      invariantFormat_ = new ФорматДатыВремени;
      invariantFormat_.calendar = new Gregorian();
      invariantFormat_.isReadOnly_ = да;
    }
    return invariantFormat_;
  }

  /**
   * $(ANCHOR DateTimeFormat_isReadOnly)
   * $(I Property.) Retrieves a значение indicating whether the экземпляр is читай-only.
   * Возвращает: да is the экземпляр is читай-only; otherwise, нет.
   */
  public final бул толькоЧтен_ли() {
    return isReadOnly_;
  }

  /**
   * $(I Property.) Retrieves the calendar used by the current культура.
   * Возвращает: The Calendar determining the calendar used by the current культура. For example, the Gregorian.
   */
  public final Calendar calendar() {
    assert(calendar_ !is пусто);
    return calendar_;
  }
  /**
   * $(ANCHOR DateTimeFormat_calendar)
   * $(I Property.) Assigns the calendar в_ be used by the current культура.
   * Параметры: значение = The Calendar determining the calendar в_ be used by the current культура.
   * Exceptions: If значение is not valid for the current культура, an Исключение is thrown.
   */
  public final проц calendar(Calendar значение) {
    checkReadOnly();
    if (значение !is calendar_) {
      for (цел i = 0; i < optionalCalendars.length; i++) {
        if (optionalCalendars[i] == значение.опр) {
          if (calendar_ !is пусто) {
            // Clear current свойства.
            shortDatePattern_ = пусто;
            longDatePattern_ = пусто;
            shortTimePattern_ = пусто;
            yearMonthPattern_ = пусто;
            monthDayPattern_ = пусто;
            generalShortTimePattern_ = пусто;
            generalLongTimePattern_ = пусто;
            fullDateTimePattern_ = пусто;
            shortDatePatterns_ = пусто;
            longDatePatterns_ = пусто;
            yearMonthPatterns_ = пусто;
            abbreviatedDayNames_ = пусто;
            abbreviatedMonthNames_ = пусто;
            dayNames_ = пусто;
            monthNames_ = пусто;
          }
          calendar_ = значение;
          инициализуй();
          return;
        }
      }
      ошибка("Not a valid calendar for the культура.");
    }
  }

  /**
   * $(ANCHOR DateTimeFormat_firstДеньНедели)
   * $(I Property.) Retrieves the first день of the week.
   * Возвращает: A ДеньНедели значение indicating the first день of the week.
   */
  public final Calendar.ДеньНедели первыйДеньНед() {
    return cast(Calendar.ДеньНедели)firstДеньНедели_;
  }
  /**
   * $(I Property.) Assigns the first день of the week.
   * Параметры: valie = A ДеньНедели значение indicating the first день of the week.
   */
  public final проц первыйДеньНед(Calendar.ДеньНедели значение) {
    checkReadOnly();
    firstДеньНедели_ = значение;
  }

  /**
   * $(ANCHOR DateTimeFormat_calendarWeekRule)
   * $(I Property.) Retrieves the _value indicating the правило used в_ determine the first week of the год.
   * Возвращает: A CalendarWeekRule _value determining the first week of the год.
   */
  public final Calendar.WeekRule calendarWeekRule() {
    return cast(Calendar.WeekRule) calendarWeekRule_;
  }
  /**
   * $(I Property.) Assigns the _value indicating the правило used в_ determine the first week of the год.
   * Параметры: значение = A CalendarWeekRule _value determining the first week of the год.
   */
  public final проц calendarWeekRule(Calendar.WeekRule значение) {
    checkReadOnly();
    calendarWeekRule_ = значение;
  }

  /**
   * $(ANCHOR DateTimeFormat_nativeCalendarName)
   * $(I Property.) Retrieves the исконный имя of the calendar associated with the current экземпляр.
   * Возвращает: The исконный имя of the calendar associated with the current экземпляр.
   */
  public final ткст nativeCalendarName() {
    return cultureData_.nativeCalName;
  }

  /**
   * $(ANCHOR DateTimeFormat_dateSeparator)
   * $(I Property.) Retrieves the ткст separating дата components.
   * Возвращает: The ткст separating дата components.
   */
  public final ткст разделительДаты() {
    if (dateSeparator_ is пусто)
      dateSeparator_ = cultureData_.дата;
    return dateSeparator_;
  }
  /**
   * $(I Property.) Assigns the ткст separating дата components.
   * Параметры: значение = The ткст separating дата components.
   */
  public final проц разделительДаты(ткст значение) {
    checkReadOnly();
    dateSeparator_ = значение;
  }

  /**
   * $(ANCHOR DateTimeFormat_timeSeparator)
   * $(I Property.) Retrieves the ткст separating время components.
   * Возвращает: The ткст separating время components.
   */
  public final ткст разделительВремени() {
    if (timeSeparator_ is пусто)
      timeSeparator_ = cultureData_.время;
    return timeSeparator_;
  }
  /**
   * $(I Property.) Assigns the ткст separating время components.
   * Параметры: значение = The ткст separating время components.
   */
  public final проц разделительВремени(ткст значение) {
    checkReadOnly();
    timeSeparator_ = значение;
  }

  /**
   * $(ANCHOR DateTimeFormat_amDesignator)
   * $(I Property.) Retrieves the ткст designator for часы before noon.
   * Возвращает: The ткст designator for часы before noon. For example, "AM".
   */
  public final ткст amDesignator() {
    assert(amDesignator_ !is пусто);
    return amDesignator_;
  }
  /**
   * $(I Property.) Assigns the ткст designator for часы before noon.
   * Параметры: значение = The ткст designator for часы before noon.
   */
  public final проц amDesignator(ткст значение) {
    checkReadOnly();
    amDesignator_ = значение;
  }

  /**
   * $(ANCHOR DateTimeFormat_pmDesignator)
   * $(I Property.) Retrieves the ткст designator for часы after noon.
   * Возвращает: The ткст designator for часы after noon. For example, "PM".
   */
  public final ткст pmDesignator() {
    assert(pmDesignator_ !is пусто);
    return pmDesignator_;
  }
  /**
   * $(I Property.) Assigns the ткст designator for часы after noon.
   * Параметры: значение = The ткст designator for часы after noon.
   */
  public final проц pmDesignator(ткст значение) {
    checkReadOnly();
    pmDesignator_ = значение;
  }

  /**
   * $(ANCHOR DateTimeFormat_shortDatePattern)
   * $(I Property.) Retrieves the форматируй образец for a крат дата значение.
   * Возвращает: The форматируй образец for a крат дата значение.
   */
  public final ткст shortDatePattern() {
    assert(shortDatePattern_ !is пусто);
    return shortDatePattern_;
  }
  /**
   * $(I Property.) Assigns the форматируй образец for a крат дата _value.
   * Параметры: значение = The форматируй образец for a крат дата _value.
   */
  public final проц shortDatePattern(ткст значение) {
    checkReadOnly();
    if (shortDatePatterns_ !is пусто)
      shortDatePatterns_[0] = значение;
    shortDatePattern_ = значение;
    generalLongTimePattern_ = пусто;
    generalShortTimePattern_ = пусто;
  }

  /**
   * $(ANCHOR DateTimeFormat_shortTimePattern)
   * $(I Property.) Retrieves the форматируй образец for a крат время значение.
   * Возвращает: The форматируй образец for a крат время значение.
   */
  public final ткст shortTimePattern() {
    if (shortTimePattern_ is пусто)
      shortTimePattern_ = cultureData_.shortTime;
    return shortTimePattern_;
  }
  /**
   * $(I Property.) Assigns the форматируй образец for a крат время _value.
   * Параметры: значение = The форматируй образец for a крат время _value.
   */
  public final проц shortTimePattern(ткст значение) {
    checkReadOnly();
    shortTimePattern_ = значение;
    generalShortTimePattern_ = пусто;
  }

  /**
   * $(ANCHOR DateTimeFormat_longDatePattern)
   * $(I Property.) Retrieves the форматируй образец for a дол дата значение.
   * Возвращает: The форматируй образец for a дол дата значение.
   */
  public final ткст longDatePattern() {
    assert(longDatePattern_ !is пусто);
    return longDatePattern_;
  }
  /**
   * $(I Property.) Assigns the форматируй образец for a дол дата _value.
   * Параметры: значение = The форматируй образец for a дол дата _value.
   */
  public final проц longDatePattern(ткст значение) {
    checkReadOnly();
    if (longDatePatterns_ !is пусто)
      longDatePatterns_[0] = значение;
    longDatePattern_ = значение;
    fullDateTimePattern_ = пусто;
  }

  /**
   * $(ANCHOR DateTimeFormat_longTimePattern)
   * $(I Property.) Retrieves the форматируй образец for a дол время значение.
   * Возвращает: The форматируй образец for a дол время значение.
   */
  public final ткст longTimePattern() {
    assert(longTimePattern_ !is пусто);
    return longTimePattern_;
  }
  /**
   * $(I Property.) Assigns the форматируй образец for a дол время _value.
   * Параметры: значение = The форматируй образец for a дол время _value.
   */
  public final проц longTimePattern(ткст значение) {
    checkReadOnly();
    longTimePattern_ = значение;
    fullDateTimePattern_ = пусто;
  }

  /**
   * $(ANCHOR DateTimeFormat_monthDayPattern)
   * $(I Property.) Retrieves the форматируй образец for a месяц and день значение.
   * Возвращает: The форматируй образец for a месяц and день значение.
   */
  public final ткст monthDayPattern() {
    if (monthDayPattern_ is пусто)
      monthDayPattern_ = cultureData_.monthDay;
    return monthDayPattern_;
  }
  /**
   * $(I Property.) Assigns the форматируй образец for a месяц and день _value.
   * Параметры: значение = The форматируй образец for a месяц and день _value.
   */
  public final проц monthDayPattern(ткст значение) {
    checkReadOnly();
    monthDayPattern_ = значение;
  }

  /**
   * $(ANCHOR DateTimeFormat_yearMonthPattern)
   * $(I Property.) Retrieves the форматируй образец for a год and месяц значение.
   * Возвращает: The форматируй образец for a год and месяц значение.
   */
  public final ткст yearMonthPattern() {
    assert(yearMonthPattern_ !is пусто);
    return yearMonthPattern_;
  }
  /**
   * $(I Property.) Assigns the форматируй образец for a год and месяц _value.
   * Параметры: значение = The форматируй образец for a год and месяц _value.
   */
  public final проц yearMonthPattern(ткст значение) {
    checkReadOnly();
    yearMonthPattern_ = значение;
  }

  /**
   * $(ANCHOR DateTimeFormat_abbreviatedDayNames)
   * $(I Property.) Retrieves a ткст Массив containing the abbreviated names of the дни of the week.
   * Возвращает: A ткст Массив containing the abbreviated names of the дни of the week. For $(LINK2 #DateTimeFormat_invariantFormat, инвариантныйФормат),
   *   this содержит "Sun", "Mon", "Tue", "Wed", "Thu", "Fri" and "Sat".
   */
  public final ткст[] abbreviatedDayNames() {
    if (abbreviatedDayNames_ is пусто)
      abbreviatedDayNames_ = cultureData_.abbrevDayNames;
    return abbreviatedDayNames_.dup;
  }
  /**
   * $(I Property.) Assigns a ткст Массив containing the abbreviated names of the дни of the week.
   * Параметры: значение = A ткст Массив containing the abbreviated names of the дни of the week.
   */
  public final проц abbreviatedDayNames(ткст[] значение) {
    checkReadOnly();
    abbreviatedDayNames_ = значение;
  }

  /**
   * $(ANCHOR DateTimeFormat_dayNames)
   * $(I Property.) Retrieves a ткст Массив containing the full names of the дни of the week.
   * Возвращает: A ткст Массив containing the full names of the дни of the week. For $(LINK2 #DateTimeFormat_invariantFormat, инвариантныйФормат),
   *   this содержит "Воскресенье", "Понедельник", "Вторник", "Среда", "Четверг", "Пятница" and "Суббота".
   */
  public final ткст[] dayNames() {
    if (dayNames_ is пусто)
      dayNames_ = cultureData_.dayNames;
    return dayNames_.dup;
  }
  /**
   * $(I Property.) Assigns a ткст Массив containing the full names of the дни of the week.
   * Параметры: значение = A ткст Массив containing the full names of the дни of the week.
   */
  public final проц dayNames(ткст[] значение) {
    checkReadOnly();
    dayNames_ = значение;
  }

  /**
   * $(ANCHOR DateTimeFormat_abbreviatedMonthNames)
   * $(I Property.) Retrieves a ткст Массив containing the abbreviated names of the месяцы.
   * Возвращает: A ткст Массив containing the abbreviated names of the месяцы. For $(LINK2 #DateTimeFormat_invariantFormat, инвариантныйФормат),
   *   this содержит "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" and "".
   */
  public final ткст[] abbreviatedMonthNames() {
    if (abbreviatedMonthNames_ is пусто)
      abbreviatedMonthNames_ = cultureData_.abbrevMonthNames;
    return abbreviatedMonthNames_.dup;
  }
  /**
   * $(I Property.) Assigns a ткст Массив containing the abbreviated names of the месяцы.
   * Параметры: значение = A ткст Массив containing the abbreviated names of the месяцы.
   */
  public final проц abbreviatedMonthNames(ткст[] значение) {
    checkReadOnly();
    abbreviatedMonthNames_ = значение;
  }

  /**
   * $(ANCHOR DateTimeFormat_monthNames)
   * $(I Property.) Retrieves a ткст Массив containing the full names of the месяцы.
   * Возвращает: A ткст Массив containing the full names of the месяцы. For $(LINK2 #DateTimeFormat_invariantFormat, инвариантныйФормат),
   *   this содержит "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" and "".
   */
  public final ткст[] monthNames() {
    if (monthNames_ is пусто)
      monthNames_ = cultureData_.monthNames;
    return monthNames_.dup;
  }
  /**
   * $(I Property.) Assigns a ткст Массив containing the full names of the месяцы.
   * Параметры: значение = A ткст Массив containing the full names of the месяцы.
   */
  public final проц monthNames(ткст[] значение) {
    checkReadOnly();
    monthNames_ = значение;
  }

  /**
   * $(ANCHOR DateTimeFormat_fullDateTimePattern)
   * $(I Property.) Retrieves the форматируй образец for a дол дата and a дол время значение.
   * Возвращает: The форматируй образец for a дол дата and a дол время значение.
   */
  public final ткст fullDateTimePattern() {
    if (fullDateTimePattern_ is пусто)
      fullDateTimePattern_ = longDatePattern ~ " " ~ longTimePattern;
    return fullDateTimePattern_;
  }
  /**
   * $(I Property.) Assigns the форматируй образец for a дол дата and a дол время _value.
   * Параметры: значение = The форматируй образец for a дол дата and a дол время _value.
   */
  public final проц fullDateTimePattern(ткст значение) {
    checkReadOnly();
    fullDateTimePattern_ = значение;
  }

  /**
   * $(ANCHOR DateTimeFormat_rfc1123Pattern)
   * $(I Property.) Retrieves the форматируй образец based on the IETF RFC 1123 specification, for a время значение.
   * Возвращает: The форматируй образец based on the IETF RFC 1123 specification, for a время значение.
   */
  public final ткст rfc1123Pattern() {
    return rfc1123Pattern_;
  }

  /**
   * $(ANCHOR DateTimeFormat_sortableDateTimePattern)
   * $(I Property.) Retrieves the форматируй образец for a sortable дата and время значение.
   * Возвращает: The форматируй образец for a sortable дата and время значение.
   */
  public final ткст sortableDateTimePattern() {
    return sortableDateTimePattern_;
  }

  /**
   * $(ANCHOR DateTimeFormat_universalSortableDateTimePattern)
   * $(I Property.) Retrieves the форматируй образец for a universal дата and время значение.
   * Возвращает: The форматируй образец for a universal дата and время значение.
   */
  public final ткст universalSortableDateTimePattern() {
    return universalSortableDateTimePattern_;
  }

  package ткст generalShortTimePattern() {
    if (generalShortTimePattern_ is пусто)
      generalShortTimePattern_ = shortDatePattern ~ " " ~ shortTimePattern;
    return generalShortTimePattern_;
  }

  package ткст generalLongTimePattern() {
    if (generalLongTimePattern_ is пусто)
      generalLongTimePattern_ = shortDatePattern ~ " " ~ longTimePattern;
    return generalLongTimePattern_;
  }

  private проц checkReadOnly() {
    if (isReadOnly_)
        ошибка("ФорматДатыВремени экземпляр is читай-only.");
  }

  private проц инициализуй() {
    if (longTimePattern_ is пусто)
      longTimePattern_ = cultureData_.longTime;
    if (shortDatePattern_ is пусто)
      shortDatePattern_ = cultureData_.shortDate;
    if (longDatePattern_ is пусто)
      longDatePattern_ = cultureData_.longDate;
    if (yearMonthPattern_ is пусто)
      yearMonthPattern_ = cultureData_.yearMonth;
    if (amDesignator_ is пусто)
      amDesignator_ = cultureData_.am;
    if (pmDesignator_ is пусто)
      pmDesignator_ = cultureData_.pm;
    if (firstДеньНедели_ is -1)
      firstДеньНедели_ = cultureData_.первыйДеньНед;
    if (calendarWeekRule_ == -1)
      calendarWeekRule_ = cultureData_.firstDayOfYear;
  }

  private цел[] optionalCalendars() {
    if (optionalCalendars_ is пусто)
      optionalCalendars_ = cultureData_.optionalCalendars;
    return optionalCalendars_;
  }

  private проц ошибка(ткст сооб) {
     throw new LocaleException (сооб);
  }

}


