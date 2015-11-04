/*******************************************************************************
  copyright:   Copyright (c) 2006 Juan Jose Comellas. все rights reserved
  license:     BSD стиль: $(LICENSE)
  author:      Juan Jose Comellas <juanjo@comellas.com.ar>
*******************************************************************************/

module io.selector.SelectorException;

//private import exception;


/**
 * ИсклСелектора is thrown when the Селектор cannot be создан because
 * of insufficient resources (файл descrИПtors, память, etc.)
 */
public class ИсклСелектора: Исключение
{
    /**
     * Construct a selector исключение with the provопрed текст ткст
     *
     * Параметры:
     * файл     = имя of the источник файл where the исключение was thrown; you
     *            would normally use __FILE__ for this parameter.
     * строка     = строка число of the источник файл where the исключение was
     *            thrown; you would normally use __LINE__ for this parameter.
     */
    public this(ткст сооб, ткст файл, бцел строка)
    {
        super(сооб, файл, строка);
    }
}


/**
 * ИсклОтменённогоПровода is thrown when the selector looks for a
 * registered провод and it cannot найди it.
 */
public class ИсклОтменённогоПровода: ИсклСелектора
{
    /**
     * Construct a selector исключение with the provопрed текст ткст
     *
     * Параметры:
     * файл     = имя of the источник файл where the исключение was thrown; you
     *            would normally use __FILE__ for this parameter.
     * строка     = строка число of the источник файл where the исключение was
     *            thrown; you would normally use __LINE__ for this parameter.
     */
    public this(ткст файл, бцел строка)
    {
        super("The провод is not registered в_ the selector", файл, строка);
    }
}

/**
 * ИсклРегистрируемогоПровода is thrown when a selector detects that a провод
 * registration was attempted ещё than once.
 */
public class ИсклРегистрируемогоПровода: ИсклСелектора
{
    /**
     * Construct a selector исключение with the provопрed текст ткст
     *
     * Параметры:
     * файл     = имя of the источник файл where the исключение was thrown; you
     *            would normally use __FILE__ for this parameter.
     * строка     = строка число of the источник файл where the исключение was
     *            thrown; you would normally use __LINE__ for this parameter.
     */
    public this(ткст файл, бцел строка)
    {
        super("The провод is already registered в_ the selector", файл, строка);
    }
}

/**
 * ИсклПрерванногоСистВызова is thrown when a system вызов is interrupted
 * by a signal and the selector was not установи в_ restart it automatically.
 */
public class ИсклПрерванногоСистВызова: ИсклСелектора
{
    /**
     * Construct a selector исключение with the provопрed текст ткст
     *
     * Параметры:
     * файл     = имя of the источник файл where the исключение was thrown; you
     *            would normally use __FILE__ for this parameter.
     * строка     = строка число of the источник файл where the исключение was
     *            thrown; you would normally use __LINE__ for this parameter.
     */
    public this(ткст файл, бцел строка)
    {
        super("A system вызов was interrupted by a signal", файл, строка);
    }
}

/**
 * ВнеПамИскл is thrown when there is not enough память.
 */
public class ВнеПамИскл: ИсклСелектора
{
    /**
     * Construct a selector исключение with the provопрed текст ткст
     *
     * Параметры:
     * файл     = имя of the источник файл where the исключение was thrown; you
     *            would normally use __FILE__ for this parameter.
     * строка     = строка число of the источник файл where the исключение was
     *            thrown; you would normally use __LINE__ for this parameter.
     */
    public this(ткст файл, бцел строка)
    {
        super("Out of память", файл, строка);
    }
}

