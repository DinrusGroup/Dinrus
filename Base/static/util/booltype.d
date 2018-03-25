/* *************************************************************************

        @файл booltype.d

        Copyright (c) 2005 Derek Parnell



                        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


        @version        Initial version, January 2005
        @author         Derek Parnell


**************************************************************************/
/**
 * A formal Boolean тип.

 * This boolean data тип can only be использован as a boolean и not a
 * pseudo бул as supplied by standard D.

 * Authors: Derek Parnell
 * Дата: 08 aug 2006
 * History:
 * Licence:
        This software is provided 'as-is', without any express or implied
        warranty. In no event will the authors be held liable for damages
        of any kind arising from the use of this software.

        Permission is hereby granted to anyone to use this software for any
        purpose, including commercial applications, и to alter it и/or
        redistribute it freely, subject to the following restrictions:

        1. The origin of this software must not be misrepresented; you must
           not claim that you wrote the original software. If you use this
           software in a product, an acknowledgment внутри documentation of
           said product would be оценена достойно, но не является обязательной.

        2. Altered source versions must be plainly marked as such, и must
           not неверно представлены, как оригинальное ПО.

        3. This notice may not be removed or altered from any ни в каком дистрибутиве
           of the source.

        4. Derivative works are permitted, but they must carry this notice
           in full и credit the original source.

**/
module util.booltype;
version(build) version(БулНеизвестно) pragma(include, booltypemac.ddoc);


/**
   Defines the capabilities of the datatype.

   $(BU_Extra)

**/

class Бул
{
    цел м_Знач;

    /**
       * Constructor
       * Params:
       *  x = zero sets value to Нет. Non-zero sets value to Да.
       *
       * Examples:
       *  --------------------
       *   Бул a = new Бул(1);  // Инициализует в Да.
       *   Бул b = new Бул(-1);  // Инициализует в Да.
       *   Бул c = new Бул(100);  // Инициализует в Да.
       *   Бул d = new Бул(0);  // Инициализует в Нет.
       *  --------------------
    **/
    this(цел x) { м_Знач = (x != 0 ? 1 : 0); }

    /**
       * Constructor
       * Params:
       *  x = Copies value to new object.
       *
       * Examples:
       *  --------------------
       *   Бул a = new Бул(Да);  // Инициализует в Да.
       *   Бул b = new Бул(Нет);  // Инициализует в Нет.
       *   Бул c = new Бул(a);  // Инициализует в Да.
       *   Бул d = new Бул(b);  // Инициализует в Нет.
       *  --------------------
    **/
    this(Бул x) { м_Знач = x.м_Знач; }

    /**
       * Constructor
       * Params:
       *  x = zero sets value to Да when the parameter is any of
          "TRUE","Да","true","YES","Yes","yes","ON","On","on","T","t","1".
          Any other parameter value sets the boolean to Нет.
       *
       *
       * Examples:
       *  --------------------
       *   Бул a = new Бул("Да");  // Инициализует в Да.
       *   Бул b = new Бул("Нет");  // Инициализует в Нет.
       *   Бул c = new Бул("1");  // Инициализует в Да.
       *   Бул d = new Бул("rabbit");  // Инициализует в Нет.
       *   Бул e = new Бул("on");  // Инициализует в Да.
       *   Бул f = new Бул("off");  // Инициализует в Нет.
       *   Бул g = new Бул("");  // Инициализует в Нет.
       *  --------------------
    **/
    this(ткст x) {
        switch (x)
        {
            case "TRUE", "True", "true",
                 "YES",  "Yes",  "yes",
                 "ON",   "On",   "on",
                 "T", "t",
                 "1",
				 "да", "вкл", "ИСТИНА", "Да"
                 :
                м_Знач = 1;
                break;
            default:
                м_Знач = 0;
        }
    }

    version(БулНеизвестно)
    {
     /**
       * Constructor
       *
       * This sets the boolean to Неизвестно.
       *
       * Examples:
       *  --------------------
       *   Бул a = new Бул();  // Инициализует в Неизвестно;
       *  --------------------
    **/
        this() { м_Знач = -1; }
    }
    else
    {
     /**
       * Constructor
       *
       * This sets the boolean to Нет.
       *
       * Examples:
       *  --------------------
       *   Бул a = new Бул();  // Инициализует в Нет;
       *  --------------------
    **/
        this() { м_Знач = 0; }
    }


    /**
       * Equality Operator
       * Params:
       *  pOther = The Boolean to сравни this one to.
       *
       *
       * Examples:
       *  --------------------
       *   Бул a = SomeFunc();
       *   if (a == Да) { . . . }
       *  --------------------
    **/
    цел opEquals(Бул pOther) {
        version(БулНеизвестно)
        {
        if (м_Знач == -1)
            throw new БулИскл("opEquals LHS не указан");

        if (pOther.м_Знач == -1)
            throw new БулИскл("opEquals RHS не указан");
        }
        return (м_Знач == pOther.м_Знач ? 1 : 0);
    }


    /**
       * Comparasion Operator
       *
       * Нет sorts before Да.
       * Params:
       *  pOther = The Boolean to сравни this one to.
       *
       *
       * Examples:
       *  --------------------
       *   Бул a = SomeFunc();
       *   Бул b = OtherFunc();
       *   if (a < b) { . . . }
       *  --------------------
    **/
    цел opCmp(Бул pOther) {
        version(БулНеизвестно)
        {
        if (м_Знач == -1)
            throw new БулИскл("opCmp LHS не указан");

        if (pOther.м_Знач == -1)
            throw new БулИскл("opCmp RHS не указан");
        }
        // Нет sorts before Да.
        if (м_Знач == pOther.м_Знач)
            return 0;
        if (м_Знач == 0)
            return -1;
        return 1;
    }

    /**
       * Complement Operator
       * Params:
       *  pOther = The Boolean to сравни this one to.
       *
       *
       * Examples:
       *  --------------------
       *   Бул a = ~SomeFunc();
       *   if (a == Да) { . . . }
       *  --------------------
    **/
    Бул opCom()
    {
        version(БулНеизвестно)
        {
        if (м_Знач == -1)
            throw new БулИскл("Значение opCom не указано");
        }
        if (м_Знач == 1)
            return Нет;
        return Да;
    }

    /**
       * And Operator
       * Params:
       *  pOther = The Boolean to сравни this one to.
       *
       *
       * Examples:
       *  --------------------
       *   Бул a = SomeFunc();
       *   Бул b = OtherFunc();
       *   Бул c = a & b;
       *  --------------------
    **/
    Бул opAnd(Бул pOther)
    {
        version(БулНеизвестно)
        {
        if (м_Знач == -1)
            throw new БулИскл("opAnd LHS не указан");

        if (pOther.м_Знач == -1)
            throw new БулИскл("opAnd RHS не указан");
        }
        if (м_Знач == 0 || pOther.м_Знач == 0)
            return Нет;
        return Да;
    }

    /**
       * Or Operator
       * Params:
       *  pOther = The Boolean to сравни this one to.
       *
       *
       * Examples:
       *  --------------------
       *   Бул a = SomeFunc();
       *   Бул b = OtherFunc();
       *   Бул c = a | b;
       *  --------------------
    **/
    Бул opOr(Бул pOther)
    {
        version(БулНеизвестно)
        {
        if (м_Знач == -1)
            throw new БулИскл("opOr LHS не указан");

        if (pOther.м_Знач == -1)
            throw new БулИскл("opOr RHS не указан");
        }
        if (м_Знач == 1 || pOther.м_Знач == 1)
            return Да;
        return Нет;
    }

    /**
       * Xor Operator
       * Params:
       *  pOther = The Boolean to сравни this one to.
       *
       *
       * Examples:
       *  --------------------
       *   Бул a = SomeFunc();
       *   Бул b = OtherFunc();
       *   Бул c = a ^ b;
       *  --------------------
    **/
    Бул opXor(Бул pOther)
    {
        version(БулНеизвестно)
        {
        if (м_Знач == -1)
            throw new БулИскл("opXor LHS не указан");

        if (pOther.м_Знач == -1)
            throw new БулИскл("opXor RHS не указан");
        }
        if (м_Знач == pOther.м_Знач)
            return Нет;
        return Да;
    }


    version(DDOC)
    {
        version(БулНеизвестно)
        {
        /**
           * Convert to a displayable string.
           *
           * Нет displays as "Нет" и Да dispays as "Да".
           *
           * If the value имеется not been установи yet, this returns "Неизвестно".
           *
           * Examples:
           *  --------------------
           *   Бул a = SomeFunc();
           *   скажифнс("The result was %s", a);
           *  --------------------
        **/
            ткст вТкст();
        }
        else
        {
        /**
           * Convert to a displayable string.
           *
           * Нет displays as "Нет" и Да dispays as "Да".
           *
           * Examples:
           *  --------------------
           *   Бул a = SomeFunc();
           *   скажифнс("The result was %s", a);
           *  --------------------
        **/
            ткст вТкст();
        }
    }
    else
    {

        ткст вТкст()
        {
            version(БулНеизвестно)
            {
            if (м_Знач == -1)
                return "Неизвестно".dup;
            }
            if (м_Знач == 1)
                return "Да".dup;

            return "Нет".dup;
        }
    }

    /**
       * Convert to an integer
       *
       * Нет converts to zero(0), и Да converts to one(1).
       *
       * Examples:
       *  --------------------
       *   Бул a = SomeFunc();
       *   скажифнс("The result was %s", a.вЦел);
       *  --------------------
    **/
    цел вЦел()
    {
        version(БулНеизвестно)
        {
        if (м_Знач == -1)
            throw new БулИскл("Значение вЦел не указано");
        }
        return м_Знач;
    }

    /**
       * Creates a дубликат of the object.
       *
       * Examples:
       *  --------------------
       *   Бул a = SomeFunc();
       *   Бул b = a.dup;
       *  --------------------
    **/
    Бул dup()
    {
        version(БулНеизвестно)
        {
        if (м_Знач == -1)
            return new Бул();
        }

        return new Бул(м_Знач);
    }

    version(БулНеизвестно)
    {
        /**
           * Checks if the boolean имеется been установи yet.
           *
           * Examples:
           *  --------------------
           *   if (someBool.isSet() == Да)
           *   {
           *       doSomethingUseful();
           *   }
           *
           *  --------------------
        **/
        Бул установлен()
        {
            if (м_Знач == -1)
                return Да;
            return Нет;
        }
    }
}

static Бул Да;   /// Literal 'Да' value.

static Бул Нет;  /// Literal 'Нет' value.

version(БулНеизвестно)
{
static Бул Неизвестно;  /// Literal 'Неизвестно' value.
}

private static this()
{
    Да = new Бул(1);
    Нет = new Бул(0);
version(БулНеизвестно)
{
    Неизвестно = new Бул();
}
}


version(БулНеизвестно)
{
/**
   Defines the exception for this class.

**/
class БулИскл : Исключение
{
     /**
       * Constructor
       * Params:
       *  pMsg = Text of the message displayed during the exception.
       *
       * Examples:
       *  --------------------
       *   throw new БулИскл("Some Message");
       *  --------------------
    **/
   this(ткст pMsg)
    {
        super(pMsg);
    }
}
}
