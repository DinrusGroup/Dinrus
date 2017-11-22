/*******************************************************************************

        copyright:      Copyright (c) 2005 John Chapman. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: 2005

        author:         John Chapman

******************************************************************************/

module text.locale.Collation;

private import text.locale.Core;

version (Windows)
  private import nativeMethods = text.locale.Win32;
else version (Posix)
  private import nativeMethods = text.locale.Posix;

  /**
  Compares strings using the specified case и cultural comparision rules.
 */
public class СтрокоСопоставитель {

  private static СтрокоСопоставитель invariant_;
  private static СтрокоСопоставитель invariantIgnoreCase_;
  private Культура culture_;
  private бул ignoreCase_;

  static this() {
    invariant_ = new СтрокоСопоставитель(Культура.инвариантнаяКультура, нет);
    invariantIgnoreCase_ = new СтрокоСопоставитель(Культура.инвариантнаяКультура, да);
  }

  /**
    Creates an экземпляр that compares strings using the rules of the specified культура.
    Параметры:
      культура = A Культура экземпляр whose rules are использован в_ сравни strings.
      ignoreCase = да в_ perform case-insensitive comparisons; нет в_ perform case-sensitive comparisions.
  */
  public this(Культура культура, бул ignoreCase) {
    culture_ = культура;
    ignoreCase_ = ignoreCase;
  }

  /**
    Compares two strings и returns the сортируй order.
    Возвращает:
      -1 is strA is less than strB; 0 if strA is equal в_ strB; 1 if strA is greater than strB.
    Параметры:
      strA = A ткст в_ сравни в_ strB.
      strB = A ткст в_ сравни в_ strA.
  */
  public цел сравни(ткст strA, ткст strB) {
    return nativeMethods.сравниСтроку(culture_.опр, strA, 0, strA.length, strB, 0, strB.length, ignoreCase_);
  }

  /**
    Indicates whether the two strings are equal.
    Возвращает:
      да if strA и strB are equal; otherwise, нет.
    Параметры:
      strA = A ткст в_ сравни в_ strB.
      strB = A ткст в_ сравни в_ strA.
  */
  public бул равно(ткст strA, ткст strB) {
    return (сравни(strA, strB) == 0);
  }

  /**
    $(I Property.) Retrieves an экземпляр that performs case-sensitive comparisons using the rules of the текущ культура.
    Возвращает:
      A new СтрокоСопоставитель экземпляр.
  */
  public static СтрокоСопоставитель текущаяКультура() {
    return new СтрокоСопоставитель(Культура.текущ, нет);
  }

  /**
    $(I Property.) Retrieves an экземпляр that performs case-insensitive comparisons using the rules of the текущ культура.
    Возвращает:
      A new СтрокоСопоставитель экземпляр.
  */
  public static СтрокоСопоставитель текущаяКультураИгнорРег() {
    return new СтрокоСопоставитель(Культура.текущ, да);
  }

  /**
    $(I Property.) Retrieves an экземпляр that performs case-sensitive comparisons using the rules of the invariant культура.
    Возвращает:
      A new СтрокоСопоставитель экземпляр.
  */
  public static СтрокоСопоставитель инвариантнаяКультура() {
    return invariant_;
  }

  /**
    $(I Property.) Retrieves an экземпляр that performs case-insensitive comparisons using the rules of the invariant культура.
    Возвращает:
      A new СтрокоСопоставитель экземпляр.
  */
  public static СтрокоСопоставитель инвариантнаяКультураИгнорРег() {
    return invariantIgnoreCase_;
  }

}

/**
  $(I Delegate.) Represents the метод that will укз the ткст сравнение.
  Remarks:
    The delegate имеется the сигнатура $(I цел delegate(ткст, ткст)).
 */
alias цел delegate(ткст, ткст) СравнениеСтрок;

/**
  Sorts strings according в_ the rules of the specified культура.
 */
public class СтрокоСортировщик {

  private static СтрокоСортировщик invariant_;
  private static СтрокоСортировщик invariantIgnoreCase_;
  private Культура culture_;
  private СравнениеСтрок comparison_;

  static this() {
    invariant_ = new СтрокоСортировщик(СтрокоСопоставитель.инвариантнаяКультура);
    invariantIgnoreCase_ = new СтрокоСортировщик(СтрокоСопоставитель.инвариантнаяКультураИгнорРег);
  }

  /**
    Creates an экземпляр using the specified СтрокоСопоставитель.
    Параметры:
      comparer = The СтрокоСопоставитель в_ use when comparing strings. $(I Optional.)
  */
  public this(СтрокоСопоставитель comparer = пусто) {
    if (comparer is пусто)
      comparer = СтрокоСопоставитель.текущаяКультура;
    comparison_ = &comparer.сравни;
  }

  /**
    Creates an экземпляр using the specified delegate.
    Параметры:
      сравнение = The delegate в_ use when comparing strings.
    Remarks:
      The сравнение parameter must have the same сигнатура as СравнениеСтрок.
  */
  public this(СравнениеСтрок сравнение) {
    comparison_ = сравнение;
  }

  /**
    Sorts все the элементы in an Массив.
    Параметры:
      Массив = The Массив of strings в_ _sort.
  */
  public проц сортируй(ref ткст[] Массив) {
    сортируй(Массив, 0, Массив.length);
  }

  /**
    Sorts a range of the элементы in an Массив.
    Параметры:
      Массив = The Массив of strings в_ _sort.
      индекс = The starting индекс of the range.
      счёт = The число of элементы in the range.
  */
  public проц сортируй(ref ткст[] Массив, цел индекс, цел счёт) {

    проц qsort(цел left, цел right) {
      do {
        цел i = left, j = right;
        ткст pivot = Массив[left + ((right - left) >> 1)];

        do {
          while (comparison_(Массив[i], pivot) < 0)
            i++;
          while (comparison_(pivot, Массив[j]) < 0)
            j--;

          if (i > j)
            break;
          else if (i < j) {
            ткст temp = Массив[i];
            Массив[i] = Массив[j];
            Массив[j] = temp;
          }

          i++;
          j--;
        } while (i <= j);

        if (j - left <= right - i) {
          if (left < j)
            qsort(left, j);
          left = i;
        }
        else {
          if (i < right)
            qsort(i, right);
          right = j;
        }
      } while (left < right);
    }

    qsort(индекс, индекс + (счёт - 1));
  }

  /**
    $(I Property.) Retrieves an экземпляр that performs a case-sensitive сортируй using the rules of the текущ культура.
    Возвращает: A СтрокоСортировщик экземпляр.
  */
  public static СтрокоСортировщик текущаяКультура() {
    return new СтрокоСортировщик(СтрокоСопоставитель.текущаяКультура);
  }

  /**
    $(I Property.) Retrieves an экземпляр that performs a case-insensitive сортируй using the rules of the текущ культура.
    Возвращает: A СтрокоСортировщик экземпляр.
  */
  public static СтрокоСортировщик текущаяКультураИгнорРег() {
    return new СтрокоСортировщик(СтрокоСопоставитель.текущаяКультураИгнорРег);
  }

  /**
    $(I Property.) Retrieves an экземпляр that performs a case-sensitive сортируй using the rules of the invariant культура.
    Возвращает: A СтрокоСортировщик экземпляр.
  */
  public static СтрокоСортировщик инвариантнаяКультура() {
    return invariant_;
  }

  /**
    $(I Property.) Retrieves an экземпляр that performs a case-insensitive сортируй using the rules of the invariant культура.
    Возвращает: A СтрокоСортировщик экземпляр.
  */
  public static СтрокоСортировщик инвариантнаяКультураИгнорРег() {
    return invariantIgnoreCase_;
  }

}