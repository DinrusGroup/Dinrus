/*******************************************************************************

        copyright:      Copyright (c) 2005 John Chapman. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: 2005

        author:         John Chapman

        Contains classes that provопрe information about locales, such as 
        the language и Календарьs, as well as cultural conventions использован 
        for formatting dates, currency и numbers. Use these classes when 
        writing applications for an international audience.

******************************************************************************/

/**
 * $(MEMBERTABLE
 * $(TR
 * $(TH Interface)
 * $(TH Description)
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
 * $(TH Description)
 * )
 * $(TR
 * $(TD $(LINK2 #Календарь, Календарь))
 * $(TD Represents время in week, месяц и год divisions.)
 * )
 * $(TR
 * $(TD $(LINK2 #Культура, Культура))
 * $(TD Provопрes information about a культура, such as its имя, Календарь и дата и число форматируй образцы.)
 * )
 * $(TR
 * $(TD $(LINK2 #ФорматДатыВремени, ФорматДатыВремени))
 * $(TD Determines как $(LINK2 #Время, Время) значения are formatted, depending on the культура.)
 * )
 * $(TR
 * $(TD $(LINK2 #DaylightSavingTime, DaylightSavingTime))
 * $(TD Represents a период of daylight-saving время.)
 * )
 * $(TR
 * $(TD $(LINK2 #Грегориан, Грегориан))
 * $(TD Represents the Грегориан Календарь.)
 * )
 * $(TR
 * $(TD $(LINK2 #Hebrew, Hebrew))
 * $(TD Represents the Hebrew Календарь.)
 * )
 * $(TR
 * $(TD $(LINK2 #Hijri, Hijri))
 * $(TD Represents the Hijri Календарь.)
 * )
 * $(TR
 * $(TD $(LINK2 #Japanese, Japanese))
 * $(TD Represents the Japanese Календарь.)
 * )
 * $(TR
 * $(TD $(LINK2 #Korean, Korean))
 * $(TD Represents the Korean Календарь.)
 * )
 * $(TR
 * $(TD $(LINK2 #ФорматЧисла, ФорматЧисла))
 * $(TD Determines как numbers are formatted, according в_ the текущ культура.)
 * )
 * $(TR
 * $(TD $(LINK2 #Регион, Регион))
 * $(TD Provопрes information about a region.)
 * )
 * $(TR
 * $(TD $(LINK2 #Taiwan, Taiwan))
 * $(TD Represents the Taiwan Календарь.)
 * )
 * $(TR
 * $(TD $(LINK2 #ThaiBuddhist, ThaiBuddhist))
 * $(TD Represents the Thai Buddhist Календарь.)
 * )
 * )
 *
 * $(MEMBERTABLE
 * $(TR
 * $(TH Struct)
 * $(TH Description)
 * )
 * $(TR
 * $(TD $(LINK2 #Время, Время))
 * $(TD Represents время expressed as a дата и время of день.)
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
         private import nativeMethods = text.locale.Win32;

version (Posix)
         private import nativeMethods = text.locale.Posix;


// Initializes an Массив.
private template массивИз(T) {
  private T[] массивИз(T[] парамы ...) {
    return парамы.dup;
  }
}

  private проц ошибка(ткст сооб) {
     throw new ИсклЛокали (сооб);
  }
  
/**
 * Defines the типы of cultures that can be retrieved из_ Культура.дайКультуры.
 */
public enum ТипыКультур {
  Нейтральный = 1,             /// Refers в_ cultures that are associated with a language but not specific в_ a country or region.
  Особый = 2,            /// Refers в_ cultures that are specific в_ a country or region.
  Все = Нейтральный | Особый /// Refers в_ все cultures.
}


/**
 * $(ANCHOR _IFormatService)
 * Retrieves an объект в_ control formatting.
 * 
 * A class реализует $(LINK2 #IFormatService_getFormat, дайФормат) в_ retrieve an объект that provопрes форматируй information for the implementing тип.
 * Remarks: ИСлужбаФормата is implemented by $(LINK2 #Культура, Культура), $(LINK2 #ФорматЧисла, ФорматЧисла) и $(LINK2 #ФорматДатыВремени, ФорматДатыВремени) в_ provопрe локаль-specific formatting of
 * numbers и дата и время значения.
 */
public interface ИСлужбаФормата {

  /**
   * $(ANCHOR IFormatService_getFormat)
   * Retrieves an объект that supports formatting for the specified _тип.
   * Возвращает: The текущ экземпляр if тип is the same _тип as the текущ экземпляр; otherwise, пусто.
   * Параметры: тип = An объект that specifies the _тип of formatting в_ retrieve.
   */
  Объект дайФормат(ИнфОТипе тип);

}

/**
 * $(ANCHOR _Culture)
 * Provопрes information about a культура, such as its имя, Календарь и дата и число форматируй образцы.
 * Remarks: text.locale adopts the RFC 1766 стандарт for культура names in the форматируй &lt;language&gt;"-"&lt;region&gt;. 
 * &lt;language&gt; is a lower-case two-letter код defined by ISO 639-1. &lt;region&gt; is an upper-case 
 * two-letter код defined by ISO 3166. For example, "en-GB" is UK English.
 * $(BR)$(BR)There are three типы of культура: invariant, neutral и specific. The invariant культура is not tied в_
 * any specific region, although it is associated with the English language. A neutral культура is associated with
 * a language, but not with a region. A specific культура is associated with a language и a region. "es" is a neutral 
 * культура. "es-MX" is a specific культура.
 * $(BR)$(BR)Instances of $(LINK2 #ФорматДатыВремени, ФорматДатыВремени) и $(LINK2 #ФорматЧисла, ФорматЧисла) cannot be создан for neutral cultures.
 * Examples:
 * ---
 * import io.Stdout, text.locale.Core;
 *
 * проц main() {
 *   Культура культура = new Культура("it-IT");
 *
 *   Стдвыв.форматнс("англИмя: {}", культура.англИмя);
 *   Стдвыв.форматнс("исконноеИмя: {}", культура.исконноеИмя);
 *   Стдвыв.форматнс("имя: {}", культура.имя);
 *   Стдвыв.форматнс("предок: {}", культура.предок.имя);
 *   Стдвыв.форматнс("нейтрален_ли: {}", культура.нейтрален_ли);
 * }
 *
 * // Produces the following вывод:
 * // англИмя: Italian (Italy)
 * // исконноеИмя: italiano (Italia)
 * // имя: it-IT
 * // предок: it
 * // нейтрален_ли: нет
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
  private Календарь calendar_;
  private Культура parent_;
  private ДанныеОКультуре* cultureData_;
  private бул isReadOnly_;
  private ФорматЧисла numberFormat_;
  private ФорматДатыВремени dateTimeFormat_;

  static this() {
    invariantCulture_ = new Культура(LCID_INVARIANT);
    invariantCulture_.isReadOnly_ = да;

    userDefaultCulture_ = new Культура(nativeMethods.дайКультуруПользователя());
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
   * Copies the текущ Культура экземпляр.
   * Возвращает: A копируй of the текущ Культура экземпляр.
   * Remarks: The значения of the $(LINK2 #Culture_numberFormat, форматЧисла), $(LINK2 #Culture_dateTimeFormat, форматДатыВремени) и $(LINK2 #Culture_Календарь, Календарь) свойства are copied also.
   */
  public Объект клонируй() {
    Культура культура = cast(Культура)клонируйОбъект(this);
    if (!культура.нейтрален_ли) {
      if (dateTimeFormat_ !is пусто)
        культура.dateTimeFormat_ = cast(ФорматДатыВремени)dateTimeFormat_.клонируй();
      if (numberFormat_ !is пусто)
        культура.numberFormat_ = cast(ФорматЧисла)numberFormat_.клонируй();
    }
    if (calendar_ !is пусто)
      культура.calendar_ = cast(Календарь)calendar_.клонируй();
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
        ошибка ("Культура не найдена - если она не устанавливалась приложением, то\n"
            ~ "ожидается, что она установлена через переменную среды LANG или LC_ALL.");
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
      ошибка("Культура " ~ названиеКультуры ~ " не поддерживается.");
    return культура;
  }

  /**
    * Returns a читай-only экземпляр using the specified имя, as defined by the RFC 3066 стандарт и maintained by the IETF.
    * Параметры: имя = The имя of the language.
    * Возвращает: A читай-only культура экземпляр.
    */
  public static Культура дайКультуруПоТегуЯзыкаИЕТФ(ткст имя) {
    if (имя is пусто)
      ошибка("Значение не может быть пустым.");
    Культура культура = дайКультуруВнутр(-1, имя);
    if (культура is пусто)
      ошибка("Название IETF культуры " ~ имя ~ " неизвестно.");
    return культура;
  }

  private static Культура дайКультуруВнутр(цел идКультуры, ткст cname) {
    // If идКультуры is - 1, имя is an IETF имя; if it's 0, имя is a культура имя; otherwise, it's a действителен LCID.
    ткст имя = cname; 
    foreach (i, c; cname)
       if (c is '_') {
         имя = cname.dup;
         имя[i] = '-';
         break;
       }

    // Look up tables первый.
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

    // Сейчас кэш the new экземпляр in все tables.
    ietfCultures[культура.тэгЯзыкаИЕТФ] = культура;
    namedCultures[культура.имя] = культура;
    idCultures[культура.опр] = культура;

    return культура;
  }

  /**
   * Returns a список of cultures filtered by the specified $(LINK2 constants.html#ТипыКультур, ТипыКультур).
   * Параметры: типы = A combination of ТипыКультур.
   * Возвращает: An Массив of Культура экземпляры containing cultures specified by типы.
   */
  public static Культура[] дайКультуры(ТипыКультур типы) {
    бул includeSpecific = (типы & ТипыКультур.Особый) != 0;
    бул includeNeutral = (типы & ТипыКультур.Нейтральный) != 0;

    цел[] cultures;
    for (цел i = 0; i < ДанныеОКультуре.cultureDataTable.length; i++) {
      if ((ДанныеОКультуре.cultureDataTable[i].нейтрален_ли && includeNeutral) || (!ДанныеОКультуре.cultureDataTable[i].нейтрален_ли && includeSpecific))
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
   * $(I Property.) Retrieves the культура of the текущ пользователь.
   * Возвращает: The Культура экземпляр representing the пользователь's текущ культура.
   */
  public static Культура текущ() {
    if (currentCulture_ !is пусто)
      return currentCulture_;

    if (userDefaultCulture_ !is пусто) {
      // If the пользователь имеется изменён their локаль settings since последний we проверьed, invalidate our данные.
      if (userDefaultCulture_.опр != nativeMethods.дайКультуруПользователя())
        userDefaultCulture_ = пусто;
    }
    if (userDefaultCulture_ is пусто) {
      userDefaultCulture_ = new Культура(nativeMethods.дайКультуруПользователя());
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
   *   // Displays the имя of the текущ культура.
   *   Println("The текущ культура is %s.", Культура.текущ.англИмя);
   *
   *   // Changes the текущ культура в_ el-GR.
   *   Культура.текущ = new Культура("el-GR");
   *   Println("The текущ культура is сейчас %s.", Культура.текущ.англИмя);
   * }
   *
   * // Produces the following вывод:
   * // The текущ культура is English (United Kingdom).
   * // The текущ культура is сейчас Greek (Greece).
   * ---
   */
  public static проц текущ(Культура значение) {
    проверьНейтрал(значение);
    nativeMethods.установиКультуруПользователя(значение.опр);
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
   * Возвращает: The культура определитель of the текущ экземпляр.
   * Remarks: The культура определитель corresponds в_ the Windows локаль определитель (LCID). It can therefore be использован when 
   * interfacing with the Windows NLS functions.
   */
  public цел опр() {
    return cultureData_.lcid;
  }

  /**
   * $(ANCHOR Culture_name)
   * $(I Property.) Retrieves the имя of the Культура in the форматируй &lt;language&gt;"-"&lt;region&gt;.
   * Возвращает: The имя of the текущ экземпляр. For example, the имя of the UK English культура is "en-GB".
   */
  public ткст имя() {
    return cultureData_.имя;
  }

  /**
   * $(I Property.) Retrieves the имя of the Культура in the форматируй &lt;languagename&gt; (&lt;regionname&gt;) in English.
   * Возвращает: The имя of the текущ экземпляр in English. For example, the англИмя of the UK English культура 
   * is "English (United Kingdom)".
   */
  public ткст англИмя() {
    return cultureData_.англИмя;
  }

  /**
   * $(I Property.) Retrieves the имя of the Культура in the форматируй &lt;languagename&gt; (&lt;regionname&gt;) in its исконный language.
   * Возвращает: The имя of the текущ экземпляр in its исконный language. For example, if Культура.имя is "de-DE", исконноеИмя is 
   * "Deutsch (Deutschland)".
   */
  public ткст исконноеИмя() {
    return cultureData_.исконноеИмя;
  }

  /**
   * $(I Property.) Retrieves the two-letter language код of the культура.
   * Возвращает: The two-letter language код of the Культура экземпляр. For example, the имяЯзыкаИз2Букв for English is "en".
   */
  public ткст имяЯзыкаИз2Букв() {
    return cultureData_.isoLangName;
  }

  /**
   * $(I Property.) Retrieves the three-letter language код of the культура.
   * Возвращает: The three-letter language код of the Культура экземпляр. For example, the имяЯзыкаИз3Букв for English is "eng".
   */
  public ткст имяЯзыкаИз3Букв() {
    return cultureData_.isoLangName2;
  }

  /**
   * $(I Property.) Retrieves the RFC 3066 опрentification for a language.
   * Возвращает: A ткст representing the RFC 3066 language опрentification.
   */
  public final ткст тэгЯзыкаИЕТФ() {
    return cultureData_.ietfTag;
  }

  /**
   * $(I Property.) Retrieves the Культура representing the предок of the текущ экземпляр.
   * Возвращает: The Культура representing the предок of the текущ экземпляр.
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
   * $(I Property.) Retrieves a значение indicating whether the текущ экземпляр is a neutral культура.
   * Возвращает: да is the текущ Культура represents a neutral культура; otherwise, нет.
   * Examples:
   * The following example displays which cultures using Chinese are neutral.
   * ---
   * import io.stream.Format, text.locale.Common;
   *
   * проц main() {
   *   foreach (c; Культура.дайКультуры(ТипыКультур.все)) {
   *     if (c.имяЯзыкаИз2Букв == "zh") {
   *       Print(c.англИмя);
   *       if (c.нейтрален_ли)
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
  public бул нейтрален_ли() {
    return cultureData_.нейтрален_ли;
  }

  /**
   * $(I Property.) Retrieves a значение indicating whether the экземпляр is читай-only.
   * Возвращает: да if the экземпляр is читай-only; otherwise, нет.
   * Remarks: If the культура is читай-only, the $(LINK2 #Culture_dateTimeFormat, форматДатыВремени) и $(LINK2 #Culture_numberFormat, форматЧисла) свойства return 
   * читай-only экземпляры.
   */
  public final бул толькоЧтен_ли() {
    return isReadOnly_;
  }

  /**
   * $(ANCHOR Culture_Календарь)
   * $(I Property.) Retrieves the Календарь использован by the культура.
   * Возвращает: A Календарь экземпляр respresenting the Календарь использован by the культура.
   */
  public Календарь календарь() {
    if (calendar_ is пусто) {
      calendar_ = дайЭкземплярКалендаря(cultureData_.типКалендаря, isReadOnly_);
    }
    return calendar_;
  }

  /**
   * $(I Property.) Retrieves the список of Календарьs that can be использован by the культура.
   * Возвращает: An Массив of тип Календарь representing the Календарьs that can be использован by the культура.
   */
  public Календарь[] опциональныеКалендари() {
    Календарь[] cals = new Календарь[cultureData_.опциональныеКалендари.length];
    foreach (цел i, цел calID; cultureData_.опциональныеКалендари)
      cals[i] = дайЭкземплярКалендаря(calID);
    return cals;
  }

  /**
   * $(ANCHOR Culture_numberFormat)
   * $(I Property.) Retrieves a ФорматЧисла defining the culturally appropriate форматируй for displaying numbers и currency.
   * Возвращает: A ФорматЧисла defining the culturally appropriate форматируй for displaying numbers и currency.
  */
  public ФорматЧисла форматЧисла() {
    проверьНейтрал(this);
    if (numberFormat_ is пусто) {
      numberFormat_ = new ФорматЧисла(cultureData_);
      numberFormat_.isReadOnly_ = isReadOnly_;
    }
    return numberFormat_;
  }
  /**
   * $(I Property.) Assigns a ФорматЧисла defining the culturally appropriate форматируй for displaying numbers и currency.
   * Параметры: значения = A ФорматЧисла defining the culturally appropriate форматируй for displaying numbers и currency.
   */
  public проц форматЧисла(ФорматЧисла значение) {
    проверьТолькоЧтен();
    numberFormat_ = значение;
  }

  /**
   * $(ANCHOR Culture_dateTimeFormat)
   * $(I Property.) Retrieves a ФорматДатыВремени defining the culturally appropriate форматируй for displaying dates и times.
   * Возвращает: A ФорматДатыВремени defining the culturally appropriate форматируй for displaying dates и times.
   */
  public ФорматДатыВремени форматДатыВремени() {
    проверьНейтрал(this);
    if (dateTimeFormat_ is пусто) {
      dateTimeFormat_ = new ФорматДатыВремени(cultureData_, calendar_);
      dateTimeFormat_.isReadOnly_ = isReadOnly_;
    }
    return dateTimeFormat_;
  }
  /**
   * $(I Property.) Assigns a ФорматДатыВремени defining the culturally appropriate форматируй for displaying dates и times.
   * Параметры: значения = A ФорматДатыВремени defining the culturally appropriate форматируй for displaying dates и times.
   */
  public проц форматДатыВремени(ФорматДатыВремени значение) {
    проверьТолькоЧтен();
    dateTimeFormat_ = значение;
  }

  private static проц проверьНейтрал(Культура культура) {
    if (культура.нейтрален_ли)
      ошибка("Культура '" ~ культура.имя ~ "' является нейтральной. 
	  Её нельзя использовать при форматировании 
	  и она не может быть установлена как текущая культура.");
  }

  private проц проверьТолькоЧтен() {
    if (isReadOnly_)
      ошибка("Экземпляр только для чтения.");
  }

  private static Календарь дайЭкземплярКалендаря(цел типКалендаря, бул readOnly=нет) {
    switch (типКалендаря) {
      case Календарь.ЯПОНСКИЙ:
        return new Japanese();
      case Календарь.ТАЙВАНЬСКИЙ:
        return new Taiwan();
      case Календарь.КОРЕЙСКИЙ:
        return new Korean();
      case Календарь.ХИДЖРИ:
       // return new Hijri();
      case Календарь.ТАИ:
        return new ThaiBuddhist();
      case Календарь.ЕВРЕЙСКИЙ:
       // return new Hebrew();
      case Календарь.ГРЕГОРИАНСКИЙ_США:
      case Календарь.ГРЕГОРИАН_СВ_ФРАНЦ:
      case Календарь.ГРЕГОРИАН_АРАБ:
      case Календарь.ГРЕГОРИАН_ТРАНСЛИТ_АНГЛ:
      case Календарь.ГРЕГОРИАН_ТРАНСЛИТ_ФРАНЦ:
        return new Грегориан(cast(Грегориан.Тип) типКалендаря);
      default:
        break;
    }
    return new Грегориан();
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
 *   Println("англИмя:       %s", region.англИмя);
 *   Println("метрическ_ли:          %s", region.метрическ_ли);
 *   Println("символВалюты:    %s", region.символВалюты);
 *   Println("символВалютыИСО: %s", region.символВалютыИСО);
 * }
 *
 * // Produces the following вывод.
 * // имя:              en-GB
 * // англИмя:       United Kingdom
 * // метрическ_ли:          да
 * // символВалюты:    £
 * // символВалютыИСО: GBP
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
    if (cultureData_.нейтрален_ли)
        ошибка ("Нейтральная культура не может использоваться для создания региона.");
    name_ = cultureData_.regionName;
  }

  /**
   * $(ANCHOR Region_ctor_name)
   * Initializes a new Регион экземпляр based on the region specified by имя.
   * Параметры: имя = A two-letter ISO 3166 код for the region. Or, a культура $(LINK2 #Culture_name, _name) consisting of the language и region.
   */
  public this(ткст имя) {
    cultureData_ = ДанныеОКультуре.getDataFromRegionName(имя);
    name_ = имя;
    if (cultureData_.нейтрален_ли)
        ошибка ("Имя региона " ~ имя ~ " соответствует нейтральной культуре и не может
		использоваться при создании региона.");
  }

  package this(ДанныеОКультуре* данныеОКультуре) {
    cultureData_ = данныеОКультуре;
    name_ = данныеОКультуре.regionName;
  }

  /**
   * $(I Property.) Retrieves the Регион использован by the текущ $(LINK2 #Культура, Культура).
   * Возвращает: The Регион экземпляр associated with the текущ Культура.
   */
  public static Регион текущ() {
    if (currentRegion_ is пусто)
      currentRegion_ = new Регион(Культура.текущ.cultureData_);
    return currentRegion_;
  }

  /**
   * $(I Property.) Retrieves a unique определитель for the geographical location of the region.
   * Возвращает: An $(B цел) uniquely опрentifying the geographical location.
   */
  public цел геоИД() {
    return cultureData_.geoId;
  }

  /**
   * $(ANCHOR Region_name)
   * $(I Property.) Retrieves the ISO 3166 код, or the имя, of the текущ Регион.
   * Возвращает: The значение specified by the имя parameter of the $(LINK2 #Region_ctor_name, Регион(ткст)) constructor.
   */
  public ткст имя() {
    return name_;
  }

  /**
   * $(I Property.) Retrieves the full имя of the region in English.
   * Возвращает: The full имя of the region in English.
   */
  public ткст англИмя() {
    return cultureData_.englishCountry;
  }

  /**
   * $(I Property.) Retrieves the full имя of the region in its исконный language.
   * Возвращает: The full имя of the region in the language associated with the region код.
   */
  public ткст исконноеИмя() {
    return cultureData_.nativeCountry;
  }

  /**
   * $(I Property.) Retrieves the two-letter ISO 3166 код of the region.
   * Возвращает: The two-letter ISO 3166 код of the region.
   */
  public ткст имяРегионаИз2Букв() {
    return cultureData_.regionName;
  }

  /**
   * $(I Property.) Retrieves the three-letter ISO 3166 код of the region.
   * Возвращает: The three-letter ISO 3166 код of the region.
   */
  public ткст имяРегионаИз3Букв() {
    return cultureData_.isoRegionName;
  }

  /**
   * $(I Property.) Retrieves the currency symbol of the region.
   * Возвращает: The currency symbol of the region.
   */
  public ткст символВалюты() {
    return cultureData_.currency;
  }

  /**
   * $(I Property.) Retrieves the three-character currency symbol of the region.
   * Возвращает: The three-character currency symbol of the region.
   */
  public ткст символВалютыИСО() {
    return cultureData_.intlSymbol;
  }

  /**
   * $(I Property.) Retrieves the имя in English of the currency использован in the region.
   * Возвращает: The имя in English of the currency использован in the region.
   */
  public ткст англИмяВалюты() {
    return cultureData_.englishCurrency;
  }

  /**
   * $(I Property.) Retrieves the имя in the исконный language of the region of the currency использован in the region.
   * Возвращает: The имя in the исконный language of the region of the currency использован in the region.
   */
  public ткст исконноеИмяВалюты() {
    return cultureData_.nativeCurrency;
  }

  /**
   * $(I Property.) Retrieves a значение indicating whether the region uses the metric system for measurements.
   * Возвращает: да is the region uses the metric system; otherwise, нет.
   */
  public бул метрическ_ли() {
    return cultureData_.метрическ_ли;
  }

  /**
   * Returns a ткст containing the ISO 3166 код, or the $(LINK2 #Region_name, имя), of the текущ Регион.
   * Возвращает: A ткст containing the ISO 3166 код, or the имя, of the текущ Регион.
   */
  public override ткст вТкст() {
    return name_;
  }

}

/**
 * $(ANCHOR _NumberFormat)
 * Determines как numbers are formatted, according в_ the текущ культура.
 * Remarks: Numbers are formatted using форматируй образцы retrieved из_ a ФорматЧисла экземпляр.
 * This class реализует $(LINK2 #IFormatService_getFormat, ИСлужбаФормата.дайФормат).
 * Examples:
 * The following example shows как в_ retrieve an экземпляр of ФорматЧисла for a Культура
 * и use it в_ display число formatting information.
 * ---
 * import io.stream.Format, text.locale.Common;
 *
 * проц main(ткст[] арги) {
 *   foreach (c; Культура.дайКультуры(ТипыКультур.Особый)) {
 *     if (c.имяЯзыкаИз2Букв == "en") {
 *       ФорматЧисла фмт = c.форматЧисла;
 *       Println("The currency symbol for %s is '%s'", 
 *         c.англИмя, 
 *         фмт.символВалюты);
 *     }
 *   }
 * }
 *
 * // Produces the following вывод:
 * // The currency symbol for English (United States) is '$'
 * // The currency symbol for English (United Kingdom) is '£'
 * // The currency symbol for English (Australia) is '$'
 * // The currency symbol for English (Canada) is '$'
 * // The currency symbol for English (Нов Zealand) is '$'
 * // The currency symbol for English (Ireland) is '€'
 * // The currency symbol for English (South Africa) is 'R'
 * // The currency symbol for English (Jamaica) is 'J$'
 * // The currency symbol for English (Caribbean) is '$'
 * // The currency symbol for English (Belize) is 'BZ$'
 * // The currency symbol for English (Trinопрad и Tobago) is 'TT$'
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
      numberDecimalDigits_ = данныеОКультуре.цифры;
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
      negativeSign_ = данныеОКультуре.отрицатЗнак;
      positiveSign_ = данныеОКультуре.положитЗнак;
      nanSymbol_ = данныеОКультуре.nan;
      negativeInfinitySymbol_ = данныеОКультуре.negInfinity;
      positiveInfinitySymbol_ = данныеОКультуре.posInfinity;
      nativeDigits_ = данныеОКультуре.исконныеЦифры;
    }
  }

  /**
   * Retrieves an объект defining как в_ форматируй the specified тип.
   * Параметры: тип = The ИнфОТипе of the resulting formatting объект.
   * Возвращает: If тип is typeid($(LINK2 #ФорматЧисла, ФорматЧисла)), the текущ ФорматЧисла экземпляр. Otherwise, пусто.
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
  public Объект клонируй() {
    ФорматЧисла копируй = cast(ФорматЧисла)клонируйОбъект(this);
    копируй.isReadOnly_ = нет;
    return копируй;
  }
}

  /**
   * Retrieves the ФорматЧисла for the specified $(LINK2 #ИСлужбаФормата, ИСлужбаФормата).
   * Параметры: службаФормата = The ИСлужбаФормата использован в_ retrieve ФорматЧисла.
   * Возвращает: The ФорматЧисла for the specified ИСлужбаФормата.
   * Remarks: The метод calls $(LINK2 #IFormatService_getFormat, ИСлужбаФормата.дайФормат) with typeof(ФорматЧисла). If службаФормата is пусто,
   * then the значение of the текущ property is returned.
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
    return текущ;
  }

  /**
   * $(I Property.) Retrieves a читай-only ФорматЧисла экземпляр из_ the текущ культура.
   * Возвращает: A читай-only ФорматЧисла экземпляр из_ the текущ культура.
   */
  public static ФорматЧисла текущ() {
    return Культура.текущ.форматЧисла;
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
   * $(I Property.) Retrieves the число of decimal places использован for numbers.
   * Возвращает: The число of decimal places использован for numbers. For $(LINK2 #NumberFormat_invariantFormat, инвариантныйФормат), the default is 2.
   */
  public final цел члоДесятичнЦифр() {
    return numberDecimalDigits_;
  }
  /**
   * Assigns the число of decimal цифры использован for numbers.
   * Параметры: значение = The число of decimal places использован for numbers.
   * Throws: Исключение if the property is being установи и the экземпляр is читай-only.
   * Examples:
   * The following example shows the effect of changing члоДесятичнЦифр.
   * ---
   * import io.stream.Format, text.locale.Common;
   *
   * проц main() {
   *   // Get the ФорматЧисла из_ the en-GB культура.
   *   ФорматЧисла фмт = (new Культура("en-GB")).форматЧисла;
   *
   *   // Display a значение with the default число of decimal цифры.
   *   цел n = 5678;
   *   Println(Форматировщик.форматируй(фмт, "{0:N}", n));
   *
   *   // Display the значение with six decimal цифры.
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
    проверьТолькоЧтен();
    numberDecimalDigits_ = значение;
  }

  /**
   * $(I Property.) Retrieves the форматируй образец for негатив numbers.
   * Возвращает: The форматируй образец for негатив numbers. For инвариантныйФормат, the default is 1 (representing "-n").
   * Remarks: The following таблица shows действителен значения for this property.
   *
   * <таблица class="definitionTable">
   * <tr><th>Значение</th><th>образец</th></tr>
   * <tr><td>0</td><td>(n)</td></tr>
   * <tr><td>1</td><td>-n</td></tr>
   * <tr><td>2</td><td>- n</td></tr>
   * <tr><td>3</td><td>n-</td></tr>
   * <tr><td>4</td><td>n -</td></tr>
   * </таблица>
   */
  public final цел члоОтрицатОбразцов() {
    return numberNegativePattern_;
  }
  /**
   * $(I Property.) Assigns the форматируй образец for негатив numbers.
   * Параметры: значение = The форматируй образец for негатив numbers.
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
    проверьТолькоЧтен();
    numberNegativePattern_ = значение;
  }

  /**
   * $(I Property.) Retrieves the число of decimal places в_ use in currency значения.
   * Возвращает: The число of decimal цифры в_ use in currency значения.
   */
  public final цел валютнДесятичнЦифры() {
    return currencyDecimalDigits_;
  }
  /**
   * $(I Property.) Assigns the число of decimal places в_ use in currency значения.
   * Параметры: значение = The число of decimal цифры в_ use in currency значения.
   */
  public final проц валютнДесятичнЦифры(цел значение) {
    проверьТолькоЧтен();
    currencyDecimalDigits_ = значение;
  }

  /**
   * $(I Property.) Retrieves the formal образец в_ use for негатив currency значения.
   * Возвращает: The форматируй образец в_ use for негатив currency значения.
   */
  public final цел валютнОтрицатОбразец() {
    return currencyNegativePattern_;
  }
  /**
   * $(I Property.) Assigns the formal образец в_ use for негатив currency значения.
   * Параметры: значение = The форматируй образец в_ use for негатив currency значения.
   */
  public final проц валютнОтрицатОбразец(цел значение) {
    проверьТолькоЧтен();
    currencyNegativePattern_ = значение;
  }

  /**
   * $(I Property.) Retrieves the formal образец в_ use for positive currency значения.
   * Возвращает: The форматируй образец в_ use for positive currency значения.
   */
  public final цел валютнПоложитОбразец() {
    return currencyPositivePattern_;
  }
  /**
   * $(I Property.) Assigns the formal образец в_ use for positive currency значения.
   * Возвращает: The форматируй образец в_ use for positive currency значения.
   */
  public final проц валютнПоложитОбразец(цел значение) {
    проверьТолькоЧтен();
    currencyPositivePattern_ = значение;
  }

  /**
   * $(I Property.) Retrieves the число of цифры цел each группа в_ the left of the decimal place in numbers.
   * Возвращает: The число of цифры цел each группа в_ the left of the decimal place in numbers.
   */
  public final цел[] размерыЧисловыхГрупп() {
    return numberGroupSizes_;
  }
  /**
   * $(I Property.) Assigns the число of цифры цел each группа в_ the left of the decimal place in numbers.
   * Параметры: значение = The число of цифры цел each группа в_ the left of the decimal place in numbers.
   */
  public final проц размерыЧисловыхГрупп(цел[] значение) {
    проверьТолькоЧтен();
    numberGroupSizes_ = значение;
  }

  /**
   * $(I Property.) Retrieves the число of цифры цел each группа в_ the left of the decimal place in currency значения.
   * Возвращает: The число of цифры цел each группа в_ the left of the decimal place in currency значения.
   */
  public final цел[] размерыВалютныхГрупп() {
    return currencyGroupSizes_;
  }
  /**
   * $(I Property.) Assigns the число of цифры цел each группа в_ the left of the decimal place in currency значения.
   * Параметры: значение = The число of цифры цел each группа в_ the left of the decimal place in currency значения.
   */
  public final проц размерыВалютныхГрупп(цел[] значение) {
    проверьТолькоЧтен();
    currencyGroupSizes_ = значение;
  }

  /**
   * $(I Property.) Retrieves the ткст separating groups of цифры в_ the left of the decimal place in numbers.
   * Возвращает: The ткст separating groups of цифры в_ the left of the decimal place in numbers. For example, ",".
   */
  public final ткст разделительЧисловыхГрупп() {
    return numberGroupSeparator_;
  }
  /**
   * $(I Property.) Assigns the ткст separating groups of цифры в_ the left of the decimal place in numbers.
   * Параметры: значение = The ткст separating groups of цифры в_ the left of the decimal place in numbers.
   */
  public final проц разделительЧисловыхГрупп(ткст значение) {
    проверьТолькоЧтен();
    numberGroupSeparator_ = значение;
  }

  /**
   * $(I Property.) Retrieves the ткст использован as the decimal разделитель in numbers.
   * Возвращает: The ткст использован as the decimal разделитель in numbers. For example, ".".
   */
  public final ткст разделительЧисловыхДесятков() {
    return numberDecimalSeparator_;
  }
  /**
   * $(I Property.) Assigns the ткст использован as the decimal разделитель in numbers.
   * Параметры: значение = The ткст использован as the decimal разделитель in numbers.
   */
  public final проц разделительЧисловыхДесятков(ткст значение) {
    проверьТолькоЧтен();
    numberDecimalSeparator_ = значение;
  }

  /**
   * $(I Property.) Retrieves the ткст separating groups of цифры в_ the left of the decimal place in currency значения.
   * Возвращает: The ткст separating groups of цифры в_ the left of the decimal place in currency значения. For example, ",".
   */
  public final ткст разделительГруппыВалют() {
    return currencyGroupSeparator_;
  }
  /**
   * $(I Property.) Assigns the ткст separating groups of цифры в_ the left of the decimal place in currency значения.
   * Параметры: значение = The ткст separating groups of цифры в_ the left of the decimal place in currency значения.
   */
  public final проц разделительГруппыВалют(ткст значение) {
    проверьТолькоЧтен();
    currencyGroupSeparator_ = значение;
  }

  /**
   * $(I Property.) Retrieves the ткст использован as the decimal разделитель in currency значения.
   * Возвращает: The ткст использован as the decimal разделитель in currency значения. For example, ".".
   */
  public final ткст десятичнРазделительВалюты() {
    return currencyDecimalSeparator_;
  }
  /**
   * $(I Property.) Assigns the ткст использован as the decimal разделитель in currency значения.
   * Параметры: значение = The ткст использован as the decimal разделитель in currency значения.
   */
  public final проц десятичнРазделительВалюты(ткст значение) {
    проверьТолькоЧтен();
    currencyDecimalSeparator_ = значение;
  }

  /**
   * $(I Property.) Retrieves the ткст использован as the currency symbol.
   * Возвращает: The ткст использован as the currency symbol. For example, "£".
   */
  public final ткст символВалюты() {
    return currencySymbol_;
  }
  /**
   * $(I Property.) Assigns the ткст использован as the currency symbol.
   * Параметры: значение = The ткст использован as the currency symbol.
   */
  public final проц символВалюты(ткст значение) {
    проверьТолькоЧтен();
    currencySymbol_ = значение;
  }

  /**
   * $(I Property.) Retrieves the ткст denoting that a число is негатив.
   * Возвращает: The ткст denoting that a число is негатив. For example, "-".
   */
  public final ткст отрицатЗнак() {
    return negativeSign_;
  }
  /**
   * $(I Property.) Assigns the ткст denoting that a число is негатив.
   * Параметры: значение = The ткст denoting that a число is негатив.
   */
  public final проц отрицатЗнак(ткст значение) {
    проверьТолькоЧтен();
    negativeSign_ = значение;
  }

  /**
   * $(I Property.) Retrieves the ткст denoting that a число is positive.
   * Возвращает: The ткст denoting that a число is positive. For example, "+".
   */
  public final ткст положитЗнак() {
    return positiveSign_;
  }
  /**
   * $(I Property.) Assigns the ткст denoting that a число is positive.
   * Параметры: значение = The ткст denoting that a число is positive.
   */
  public final проц положитЗнак(ткст значение) {
    проверьТолькоЧтен();
    positiveSign_ = значение;
  }

  /**
   * $(I Property.) Retrieves the ткст representing the НЧ (not a число) значение.
   * Возвращает: The ткст representing the НЧ значение. For example, "НЧ".
   */
  public final ткст символНЧ() {
    return nanSymbol_;
  }
  /**
   * $(I Property.) Assigns the ткст representing the НЧ (not a число) значение.
   * Параметры: значение = The ткст representing the НЧ значение.
   */
  public final проц символНЧ(ткст значение) {
    проверьТолькоЧтен();
    nanSymbol_ = значение;
  }

  /**
   * $(I Property.) Retrieves the ткст representing негатив infinity.
   * Возвращает: The ткст representing негатив infinity. For example, "-Infinity".
   */
  public final ткст отрицатСимволБесконечности() {
    return negativeInfinitySymbol_;
  }
  /**
   * $(I Property.) Assigns the ткст representing негатив infinity.
   * Параметры: значение = The ткст representing негатив infinity.
   */
  public final проц отрицатСимволБесконечности(ткст значение) {
    проверьТолькоЧтен();
    negativeInfinitySymbol_ = значение;
  }

  /**
   * $(I Property.) Retrieves the ткст representing positive infinity.
   * Возвращает: The ткст representing positive infinity. For example, "Infinity".
   */
  public final ткст положитСимволБесконечности() {
    return positiveInfinitySymbol_;
  }
  /**
   * $(I Property.) Assigns the ткст representing positive infinity.
   * Параметры: значение = The ткст representing positive infinity.
   */
  public final проц положитСимволБесконечности(ткст значение) {
    проверьТолькоЧтен();
    positiveInfinitySymbol_ = значение;
  }

  /**
   * $(I Property.) Retrieves a ткст Массив of исконный equivalents of the цифры 0 в_ 9.
   * Возвращает: A ткст Массив of исконный equivalents of the цифры 0 в_ 9.
   */
  public final ткст[] исконныеЦифры() {
    return nativeDigits_;
  }
  /**
   * $(I Property.) Assigns a ткст Массив of исконный equivalents of the цифры 0 в_ 9.
   * Параметры: значение = A ткст Массив of исконный equivalents of the цифры 0 в_ 9.
   */
  public final проц исконныеЦифры(ткст[] значение) {
    проверьТолькоЧтен();
    nativeDigits_ = значение;
  }

  private проц проверьТолькоЧтен() {
    if (isReadOnly_)
        ошибка("Экземпляр ФорматЧисла предназначен только для чтения.");
  }

}

/**
 * $(ANCHOR _DateTimeFormat)
 * Determines как $(LINK2 #Время, Время) значения are formatted, depending on the культура.
 * Remarks: To создай a ФорматДатыВремени for a specific культура, создай a $(LINK2 #Культура, Культура) for that культура и
 * retrieve its $(LINK2 #Culture_dateTimeFormat, форматДатыВремени) property. To создай a ФорматДатыВремени for the пользователь's текущ 
 * культура, use the $(LINK2 #Culture_current, текущ) property.
 */
public class ФорматДатыВремени : ИСлужбаФормата {

  private const ткст rfc1123Pattern_ = "ddd, dd MMM yyyy HH':'mm':'ss 'GMT'";
  private const ткст sortableDateTimePattern_ = "yyyy'-'MM'-'dd'T'HH':'mm':'ss";
  private const ткст universalSortableDateTimePattern_ = "yyyy'-'MM'-'dd' 'HH':'mm':'ss'Z'";
  private const ткст allStandardFormats = [ 'd', 'D', 'f', 'F', 'g', 'G', 'm', 'M', 'r', 'R', 's', 't', 'T', 'u', 'U', 'y', 'Y' ];


  package бул isReadOnly_;
  private static ФорматДатыВремени invariantFormat_;
  private ДанныеОКультуре* cultureData_;

  private Календарь calendar_;
  private цел[] optionalКалендарьs_;
  private цел firstДеньНедели_ = -1;
  private цел КалендарьWeekRule_ = -1;
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

  private ткст ПолнаяДатаTimePattern_;
  private ткст generalShortTimePattern_;
  private ткст generalLongTimePattern_;

  private ткст[] shortTimePatterns_;
  private ткст[] shortDatePatterns_;
  private ткст[] longTimePatterns_;
  private ткст[] longDatePatterns_;
  private ткст[] yearMonthPatterns_;

  /**
   * $(ANCHOR DateTimeFormat_ctor)
   * Initializes an экземпляр that is записываемый и культура-independent.
   */
  package this() {
    // This ctor is использован by инвариантныйФормат so we can't установи the Календарь property.
    cultureData_ = Культура.инвариантнаяКультура.cultureData_;
    calendar_ = Грегориан.генерный;
    инициализуй();
  }

  package this(ДанныеОКультуре* данныеОКультуре, Календарь календарь) {
    cultureData_ = данныеОКультуре;
    this.calendar_ = календарь;
  }

  /**
   * $(ANCHOR DateTimeFormat_getFormat)
   * Retrieves an объект defining как в_ форматируй the specified тип.
   * Параметры: тип = The ИнфОТипе of the resulting formatting объект.
   * Возвращает: If тип is typeid(ФорматДатыВремени), the текущ ФорматДатыВремени экземпляр. Otherwise, пусто.
   * Remarks: Implements $(LINK2 #IFormatService_getFormat, ИСлужбаФормата.дайФормат).
   */
  public Объект дайФормат(ИнфОТипе тип) {
    return (тип is typeid(ФорматДатыВремени)) ? this : пусто;
  }

version(Clone)
{
  /**
   */
  public Объект клонируй() {
    ФорматДатыВремени другой = cast(ФорматДатыВремени)клонируйОбъект(this);
    другой.calendar_ = cast(Календарь)Календарь.клонируй();
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
   * Retrieves the стандарт образцы in which Время значения can be formatted.
   * Возвращает: An Массив of strings containing the стандарт образцы in which Время значения can be formatted.
   */
  public final ткст[] дайВсеОбразцыДатыВремени() {
    ткст[] результат;
    foreach (сим форматируй; ФорматДатыВремени.allStandardFormats)
      результат ~= дайВсеОбразцыДатыВремени(форматируй);
    return результат;
  }

  /**
   * $(ANCHOR DateTimeFormat_getAllDateTimePatterns_char)
   * Retrieves the стандарт образцы in which Время значения can be formatted using the specified форматируй character.
   * Возвращает: An Массив of strings containing the стандарт образцы in which Время значения can be formatted using the specified форматируй character.
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
        результат ~= образецДняМесяца;
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
        ошибка("Указанный формат был недействителен.");
    }
    return результат;
  }

  /**
   * $(ANCHOR DateTimeFormat_getAbbreviatedDayName)
   * Retrieves the abbreviated имя of the specified день of the week based on the культура of the экземпляр.
   * Параметры: ДеньНедели = A ДеньНедели значение.
   * Возвращает: The abbreviated имя of the день of the week represented by ДеньНедели.
   */
  public final ткст дайСокращённоеИмяДня(Календарь.ДеньНедели деньНедели) {
    return сокращённыеИменаДней[cast(цел)деньНедели];
  }

  /**
   * $(ANCHOR DateTimeFormat_getDayName)
   * Retrieves the full имя of the specified день of the week based on the культура of the экземпляр.
   * Параметры: ДеньНедели = A ДеньНедели значение.
   * Возвращает: The full имя of the день of the week represented by ДеньНедели.
   */
  public final ткст дайИмяДня(Календарь.ДеньНедели деньНедели) {
    return именаДней[cast(цел)деньНедели];
  }

  /**
   * $(ANCHOR DateTimeFormat_getAbbreviatedMonthName)
   * Retrieves the abbreviated имя of the specified месяц based on the культура of the экземпляр.
   * Параметры: месяц = An целое between 1 и 13 indicating the имя of the _month в_ return.
   * Возвращает: The abbreviated имя of the _month represented by месяц.
   */
  public final ткст дайСокращённоеИмяМесяца(цел месяц) {
    return сокращённыеИменаМесяцев[месяц - 1];
  }

  /**
   * $(ANCHOR DateTimeFormat_getMonthName)
   * Retrieves the full имя of the specified месяц based on the культура of the экземпляр.
   * Параметры: месяц = An целое between 1 и 13 indicating the имя of the _month в_ return.
   * Возвращает: The full имя of the _month represented by месяц.
   */
  public final ткст дайИмяМесяца(цел месяц) {
    return именаМесяцев[месяц - 1];
  }

  /**
   * $(ANCHOR DateTimeFormat_getInstance)
   * Retrieves the ФорматДатыВремени for the specified ИСлужбаФормата.
   * Параметры: службаФормата = The ИСлужбаФормата использован в_ retrieve ФорматДатыВремени.
   * Возвращает: The ФорматДатыВремени for the specified ИСлужбаФормата.
   * Remarks: The метод calls $(LINK2 #IFormatService_getFormat, ИСлужбаФормата.дайФормат) with typeof(ФорматДатыВремени). If службаФормата is пусто,
   * then the значение of the текущ property is returned.
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
    return текущ;
  }

  /**
   * $(ANCHOR DateTimeFormat_current)
   * $(I Property.) Retrieves a читай-only ФорматДатыВремени экземпляр из_ the текущ культура.
   * Возвращает: A читай-only ФорматДатыВремени экземпляр из_ the текущ культура.
   */
  public static ФорматДатыВремени текущ() {
    return Культура.текущ.форматДатыВремени;
  }

  /**
   * $(ANCHOR DateTimeFormat_invariantFormat)
   * $(I Property.) Retrieves a читай-only ФорматДатыВремени экземпляр that is culturally independent.
   * Возвращает: A читай-only ФорматДатыВремени экземпляр that is culturally independent.
   */
  public static ФорматДатыВремени инвариантныйФормат() {
    if (invariantFormat_ is пусто) {
      invariantFormat_ = new ФорматДатыВремени;
      invariantFormat_.calendar_ = new Грегориан();
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
   * $(I Property.) Retrieves the Календарь использован by the текущ культура.
   * Возвращает: The Календарь determining the Календарь использован by the текущ культура. For example, the Грегориан.
   */
  public final Календарь календарь() {
    assert(calendar_ !is пусто);
    return calendar_;
  }
  /**
   * $(ANCHOR DateTimeFormat_Календарь)
   * $(I Property.) Assigns the Календарь в_ be использован by the текущ культура.
   * Параметры: значение = The Календарь determining the Календарь в_ be использован by the текущ культура.
   * Exceptions: If значение is not действителен for the текущ культура, an Исключение is thrown.
   */
  public final проц календарь(Календарь значение) {
    проверьТолькоЧтен();
    if (значение !is calendar_) {
      for (цел i = 0; i < опциональныеКалендари.length; i++) {
        if (опциональныеКалендари[i] == значение.опр) {
          if (calendar_ !is пусто) {
            // Clear текущ свойства.
            shortDatePattern_ = пусто;
            longDatePattern_ = пусто;
            shortTimePattern_ = пусто;
            yearMonthPattern_ = пусто;
            monthDayPattern_ = пусто;
            generalShortTimePattern_ = пусто;
            generalLongTimePattern_ = пусто;
            ПолнаяДатаTimePattern_ = пусто;
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
      ошибка("Календарь для данной культуры недействителен.");
    }
  }

  /**
   * $(ANCHOR DateTimeFormat_firstДеньНедели)
   * $(I Property.) Retrieves the первый день of the week.
   * Возвращает: A ДеньНедели значение indicating the первый день of the week.
   */
  public final Календарь.ДеньНедели первыйДеньНед() {
    return cast(Календарь.ДеньНедели)firstДеньНедели_;
  }
  /**
   * $(I Property.) Assigns the первый день of the week.
   * Параметры: valie = A ДеньНедели значение indicating the первый день of the week.
   */
  public final проц первыйДеньНед(Календарь.ДеньНедели значение) {
    проверьТолькоЧтен();
    firstДеньНедели_ = значение;
  }

  /**
   * $(ANCHOR DateTimeFormat_КалендарьWeekRule)
   * $(I Property.) Retrieves the _value indicating the правило использован в_ determine the первый week of the год.
   * Возвращает: A правилоНеделиКалендаря _value determining the первый week of the год.
   */
  public final Календарь.ПравилоНедели правилоНеделиКалендаря() {
    return cast(Календарь.ПравилоНедели) КалендарьWeekRule_;
  }
  /**
   * $(I Property.) Assigns the _value indicating the правило использован в_ determine the первый week of the год.
   * Параметры: значение = A правилоНеделиКалендаря _value determining the первый week of the год.
   */
  public final проц правилоНеделиКалендаря(Календарь.ПравилоНедели значение) {
    проверьТолькоЧтен();
    КалендарьWeekRule_ = значение;
  }

  /**
   * $(ANCHOR DateTimeFormat_nativeКалендарьName)
   * $(I Property.) Retrieves the исконный имя of the Календарь associated with the текущ экземпляр.
   * Возвращает: The исконный имя of the Календарь associated with the текущ экземпляр.
   */
  public final ткст исконноеНазваниеКалендаря() {
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
    проверьТолькоЧтен();
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
    проверьТолькоЧтен();
    timeSeparator_ = значение;
  }

  /**
   * $(ANCHOR DateTimeFormat_amDesignator)
   * $(I Property.) Retrieves the ткст designator for часы before noon.
   * Возвращает: The ткст designator for часы before noon. For example, "AM".
   */
  public final ткст определительДоПолудня() {
    assert(amDesignator_ !is пусто);
    return amDesignator_;
  }
  /**
   * $(I Property.) Assigns the ткст designator for часы before noon.
   * Параметры: значение = The ткст designator for часы before noon.
   */
  public final проц определительДоПолудня(ткст значение) {
    проверьТолькоЧтен();
    amDesignator_ = значение;
  }

  /**
   * $(ANCHOR DateTimeFormat_pmDesignator)
   * $(I Property.) Retrieves the ткст designator for часы after noon.
   * Возвращает: The ткст designator for часы after noon. For example, "PM".
   */
  public final ткст определительПослеПолудня() {
    assert(pmDesignator_ !is пусто);
    return pmDesignator_;
  }
  /**
   * $(I Property.) Assigns the ткст designator for часы after noon.
   * Параметры: значение = The ткст designator for часы after noon.
   */
  public final проц определительПослеПолудня(ткст значение) {
    проверьТолькоЧтен();
    pmDesignator_ = значение;
  }

  /**
   * $(ANCHOR DateTimeFormat_shortDatePattern)
   * $(I Property.) Retrieves the форматируй образец for a крат дата значение.
   * Возвращает: The форматируй образец for a крат дата значение.
   */
  public final ткст краткийОбразецДаты() {
    assert(shortDatePattern_ !is пусто);
    return shortDatePattern_;
  }
  /**
   * $(I Property.) Assigns the форматируй образец for a крат дата _value.
   * Параметры: значение = The форматируй образец for a крат дата _value.
   */
  public final проц краткийОбразецДаты(ткст значение) {
    проверьТолькоЧтен();
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
  public final ткст краткийОбразецВремени() {
    if (shortTimePattern_ is пусто)
      shortTimePattern_ = cultureData_.shortTime;
    return shortTimePattern_;
  }
  /**
   * $(I Property.) Assigns the форматируй образец for a крат время _value.
   * Параметры: значение = The форматируй образец for a крат время _value.
   */
  public final проц краткийОбразецВремени(ткст значение) {
    проверьТолькоЧтен();
    shortTimePattern_ = значение;
    generalShortTimePattern_ = пусто;
  }

  /**
   * $(ANCHOR DateTimeFormat_longDatePattern)
   * $(I Property.) Retrieves the форматируй образец for a дол дата значение.
   * Возвращает: The форматируй образец for a дол дата значение.
   */
  public final ткст длинныйОбразецДаты() {
    assert(longDatePattern_ !is пусто);
    return longDatePattern_;
  }
  /**
   * $(I Property.) Assigns the форматируй образец for a дол дата _value.
   * Параметры: значение = The форматируй образец for a дол дата _value.
   */
  public final проц длинныйОбразецДаты(ткст значение) {
    проверьТолькоЧтен();
    if (longDatePatterns_ !is пусто)
      longDatePatterns_[0] = значение;
    longDatePattern_ = значение;
    ПолнаяДатаTimePattern_ = пусто;
  }

  /**
   * $(ANCHOR DateTimeFormat_longTimePattern)
   * $(I Property.) Retrieves the форматируй образец for a дол время значение.
   * Возвращает: The форматируй образец for a дол время значение.
   */
  public final ткст длинныйОбразецВремени() {
    assert(longTimePattern_ !is пусто);
    return longTimePattern_;
  }
  /**
   * $(I Property.) Assigns the форматируй образец for a дол время _value.
   * Параметры: значение = The форматируй образец for a дол время _value.
   */
  public final проц длинныйОбразецВремени(ткст значение) {
    проверьТолькоЧтен();
    longTimePattern_ = значение;
    ПолнаяДатаTimePattern_ = пусто;
  }

  /**
   * $(ANCHOR DateTimeFormat_monthDayPattern)
   * $(I Property.) Retrieves the форматируй образец for a месяц и день значение.
   * Возвращает: The форматируй образец for a месяц и день значение.
   */
  public final ткст образецДняМесяца() {
    if (monthDayPattern_ is пусто)
      monthDayPattern_ = cultureData_.monthDay;
    return monthDayPattern_;
  }
  /**
   * $(I Property.) Assigns the форматируй образец for a месяц и день _value.
   * Параметры: значение = The форматируй образец for a месяц и день _value.
   */
  public final проц образецДняМесяца(ткст значение) {
    проверьТолькоЧтен();
    monthDayPattern_ = значение;
  }

  /**
   * $(ANCHOR DateTimeFormat_yearMonthPattern)
   * $(I Property.) Retrieves the форматируй образец for a год и месяц значение.
   * Возвращает: The форматируй образец for a год и месяц значение.
   */
  public final ткст образецМесяцаГода() {
    assert(yearMonthPattern_ !is пусто);
    return yearMonthPattern_;
  }
  /**
   * $(I Property.) Assigns the форматируй образец for a год и месяц _value.
   * Параметры: значение = The форматируй образец for a год и месяц _value.
   */
  public final проц образецМесяцаГода(ткст значение) {
    проверьТолькоЧтен();
    yearMonthPattern_ = значение;
  }

  /**
   * $(ANCHOR DateTimeFormat_abbreviatedDayNames)
   * $(I Property.) Retrieves a ткст Массив containing the abbreviated names of the дни of the week.
   * Возвращает: A ткст Массив containing the abbreviated names of the дни of the week. For $(LINK2 #DateTimeFormat_invariantFormat, инвариантныйФормат),
   *   this содержит "Sun", "Mon", "Tue", "Wed", "Thu", "Fri" и "Sat".
   */
  public final ткст[] сокращённыеИменаДней() {
    if (abbreviatedDayNames_ is пусто)
      abbreviatedDayNames_ = cultureData_.abbrevDayNames;
    return abbreviatedDayNames_.dup;
  }
  /**
   * $(I Property.) Assigns a ткст Массив containing the abbreviated names of the дни of the week.
   * Параметры: значение = A ткст Массив containing the abbreviated names of the дни of the week.
   */
  public final проц сокращённыеИменаДней(ткст[] значение) {
    проверьТолькоЧтен();
    abbreviatedDayNames_ = значение;
  }

  /**
   * $(ANCHOR DateTimeFormat_dayNames)
   * $(I Property.) Retrieves a ткст Массив containing the full names of the дни of the week.
   * Возвращает: A ткст Массив containing the full names of the дни of the week. For $(LINK2 #DateTimeFormat_invariantFormat, инвариантныйФормат),
   *   this содержит "Воскресенье", "Понедельник", "Вторник", "Среда", "Четверг", "Пятница" и "Суббота".
   */
  public final ткст[] именаДней() {
    if (dayNames_ is пусто)
      dayNames_ = cultureData_.именаДней;
    return dayNames_.dup;
  }
  /**
   * $(I Property.) Assigns a ткст Массив containing the full names of the дни of the week.
   * Параметры: значение = A ткст Массив containing the full names of the дни of the week.
   */
  public final проц именаДней(ткст[] значение) {
    проверьТолькоЧтен();
    dayNames_ = значение;
  }

  /**
   * $(ANCHOR DateTimeFormat_abbreviatedMonthNames)
   * $(I Property.) Retrieves a ткст Массив containing the abbreviated names of the месяцы.
   * Возвращает: A ткст Массив containing the abbreviated names of the месяцы. For $(LINK2 #DateTimeFormat_invariantFormat, инвариантныйФормат),
   *   this содержит "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" и "".
   */
  public final ткст[] сокращённыеИменаМесяцев() {
    if (abbreviatedMonthNames_ is пусто)
      abbreviatedMonthNames_ = cultureData_.abbrevMonthNames;
    return abbreviatedMonthNames_.dup;
  }
  /**
   * $(I Property.) Assigns a ткст Массив containing the abbreviated names of the месяцы.
   * Параметры: значение = A ткст Массив containing the abbreviated names of the месяцы.
   */
  public final проц сокращённыеИменаМесяцев(ткст[] значение) {
    проверьТолькоЧтен();
    abbreviatedMonthNames_ = значение;
  }

  /**
   * $(ANCHOR DateTimeFormat_monthNames)
   * $(I Property.) Retrieves a ткст Массив containing the full names of the месяцы.
   * Возвращает: A ткст Массив containing the full names of the месяцы. For $(LINK2 #DateTimeFormat_invariantFormat, инвариантныйФормат),
   *   this содержит "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" и "".
   */
  public final ткст[] именаМесяцев() {
    if (monthNames_ is пусто)
      monthNames_ = cultureData_.именаМесяцев;
    return monthNames_.dup;
  }
  /**
   * $(I Property.) Assigns a ткст Массив containing the full names of the месяцы.
   * Параметры: значение = A ткст Массив containing the full names of the месяцы.
   */
  public final проц именаМесяцев(ткст[] значение) {
    проверьТолькоЧтен();
    monthNames_ = значение;
  }

  /**
   * $(ANCHOR DateTimeFormat_ПолнаяДатаTimePattern)
   * $(I Property.) Retrieves the форматируй образец for a дол дата и a дол время значение.
   * Возвращает: The форматируй образец for a дол дата и a дол время значение.
   */
  public final ткст полныйОбразецДатыВремени() {
    if (ПолнаяДатаTimePattern_ is пусто)
      ПолнаяДатаTimePattern_ = длинныйОбразецДаты ~ " " ~ длинныйОбразецВремени;
    return ПолнаяДатаTimePattern_;
  }
  /**
   * $(I Property.) Assigns the форматируй образец for a дол дата и a дол время _value.
   * Параметры: значение = The форматируй образец for a дол дата и a дол время _value.
   */
  public final проц полныйОбразецДатыВремени(ткст значение) {
    проверьТолькоЧтен();
    ПолнаяДатаTimePattern_ = значение;
  }

  /**
   * $(ANCHOR DateTimeFormat_rfc1123Pattern)
   * $(I Property.) Retrieves the форматируй образец based on the IETF RFC 1123 specification, for a время значение.
   * Возвращает: The форматируй образец based on the IETF RFC 1123 specification, for a время значение.
   */
  public final ткст образецРФС1123() {
    return rfc1123Pattern_;
  }

  /**
   * $(ANCHOR DateTimeFormat_sortableDateTimePattern)
   * $(I Property.) Retrieves the форматируй образец for a sortable дата и время значение.
   * Возвращает: The форматируй образец for a sortable дата и время значение.
   */
  public final ткст сортируемыйОбразецДатыВремени() {
    return sortableDateTimePattern_;
  }

  /**
   * $(ANCHOR DateTimeFormat_universalSortableDateTimePattern)
   * $(I Property.) Retrieves the форматируй образец for a universal дата и время значение.
   * Возвращает: The форматируй образец for a universal дата и время значение.
   */
  public final ткст универсальныйСортируемыйОбразецДатыВремени() {
    return universalSortableDateTimePattern_;
  }

  package ткст общКраткийОбразецВремени() {
    if (generalShortTimePattern_ is пусто)
      generalShortTimePattern_ = краткийОбразецДаты ~ " " ~ краткийОбразецВремени;
    return generalShortTimePattern_;
  }

  package ткст общДлинныйОбразецВремени() {
    if (generalLongTimePattern_ is пусто)
      generalLongTimePattern_ = краткийОбразецДаты ~ " " ~ длинныйОбразецВремени;
    return generalLongTimePattern_;
  }

  private проц проверьТолькоЧтен() {
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
    if (КалендарьWeekRule_ == -1)
      КалендарьWeekRule_ = cultureData_.firstDayOfYear;
  }

  private цел[] опциональныеКалендари() {
    if (optionalКалендарьs_ is пусто)
      optionalКалендарьs_ = cultureData_.опциональныеКалендари;
    return optionalКалендарьs_;
  }

}


