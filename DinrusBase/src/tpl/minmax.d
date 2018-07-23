﻿module tpl.minmax;

protected import stdrus : нч;

/**
 * Возвращает наименьшее из двух чисел.
 * Параметры:
 *   знач1 = Первое сравниваемое число.
 *   знач2 = Второе сравниваемое число.
 * Возвращает: Параметр знач1 или знач2, в зависимости от того, который меньше.
 */
T мин(T)(T знач1, T знач2) {
  static if (is(T == ббайт) ||
    is(T == байт) ||
    is(T == бкрат) ||
    is(T == крат) ||
    is(T == бцел) ||
    is(T == цел) ||
    is(T == бдол) ||
    is(T == дол)) {
    return (знач1 > знач2) ? знач2 : знач1;
  }
  else static if (is(T == плав)
    || is(T == дво)) {
    return (знач1 < знач2) ? знач1 : нч(знач1) ? знач1 : знач2;
  }
  else
    static assert(нет);
}

/**
 * Возвращает наибольшее из двух чисел.
 * Параметры:
 *   знач1 = Первое сравниваемое число.
 *   знач2 = Второе сравниваемое число.
 * Возвращает: Параметр знач1 или знач2, в зависимости от того, который больше.
 */
T макс(T)(T знач1, T знач2) {
  static if (is(T == ббайт) ||
    is(T == байт) ||
    is(T == бкрат) ||
    is(T == крат) ||
    is(T == бцел) ||
    is(T == цел)||
    is(T == бдол) ||
    is(T == дол)) {
    return (знач1 < знач2) ? знач2 : знач1;
  }
  else static if (is(T == плав) 
    || is(T == дво)) {
    return (знач1 > знач2) ? знач1 : нч(знач1) ? знач1 : знач2;
  }
  else
    static assert(нет);
}

//module std2.functional

/**
   Предикат, который воозвращает $(D_PARAM a < b).
*/
бул меньше(T)(T a, T b) { return a < b; }

/**
   Предикат, который воозвращает $(D_PARAM a > b).
*/
бул больше(T)(T a, T b) { return a > b; }

/+
//module std2.math

/**
   Вычисляет, приблизительно равен ли $(D lhs)  $(D rhs),
   учитывая максимальную относительную разность $(D максОтнРазность) и
   максимальную абсолютную разность $(D максАбсРазность).
 */
бул приблизитРавны(T, U, V)(T lhs, U rhs, V максОтнРазность, V максАбсРазность = 0)
{
    static if (isArray!(T)) {
        final n = lhs.length;
        static if (isArray!(U)) {
            // Two arrays
            assert(n == rhs.length);
            for (бцел i = 0; i != n; ++i) {
                if (!приблизитРавны(lhs[i], rhs[i], максОтнРазность, максАбсРазность))
                    return нет;
            }
        } else {
            // lhs is массив, rhs is number
            for (бцел i = 0; i != n; ++i) {
                if (!приблизитРавны(lhs[i], rhs, максОтнРазность, максАбсРазность))
                    return нет;
            }
        }
        return да;
    } else {
        static if (isArray!(U)) {
            // lhs is number, rhs is массив
            return приблизитРавны(rhs, lhs, максОтнРазность);
        } else {
            // two numbers
            //static assert(is(T : real) && is(U : real));
            if (rhs == 0) {
                return (lhs == 0 ? 0 : 1) <= максОтнРазность;
            }
            return fabs((lhs - rhs) / rhs) <= максОтнРазность
                || максАбсРазность != 0 && fabs(lhs - rhs) < максАбсРазность;
        }
    }
}

/**
   Returns $(D приблизитРавны(lhs, rhs, 0.01)).
 */
бул приблизитРавны(T, U)(T lhs, U rhs) {
    return приблизитРавны(lhs, rhs, 0.01);
}
+/