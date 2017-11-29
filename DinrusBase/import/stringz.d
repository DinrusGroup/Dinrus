﻿module stringz;

extern(D):

    /*********************************
     * Преобразует массив символов в строку в стиле Си с нулевым окончанием.
     * При предоставлении врм этот буфер будет по возможности использован
     * вместо того, чтобы использовать размещение в куче.
     */

    сим* вТкст0 (ткст s, ткст врм=null);

    /*********************************
     * Преобразует серию ткст в строки в стиле Си с нулевым окончанием,
     * врм используется как рабочее пространство, а прм как место,
     * куда помещается результат.
     * Предназначено для эффективного одновременного конвертирования нескольких строк.
     *
     * Возвращает заполненный срез прм
     *
     * Since: 0.99.7
     */

    сим*[] вТкст0 (ткст врм, сим*[] прм, ткст[] строки...);

    /*********************************
     * Преобразует строку с нулевым окончанием в стиле Си в массив типа сим
     */

    ткст изТкст0 (сим* s);

    /*********************************
     * ПЯреобразует массив типа шткст s[] в строку нулевого окончания в стиле Си.
     */

    шим* вТкст16н (шткст s);

    /*********************************
     * Преобразует строку с нулевым окончанием в стиле Си в массив шим
     */

    шткст изТкст16н (шим* s);

    /*********************************
     * Преобразует массив типа юткст s[] в строку нулевого окончания в стиле Си.
     */

    дим* вТкст32н (юткст s);

    /*********************************
     * Преобразует строку нулевого окончания в стиле Си в массив типа дим
     */

    юткст изТкст32н (дим* s);

    /*********************************
     * портабельный strlen
     */

    т_мера длинтекс0(T) (T* s)
{
    т_мера i;

    if (s)
        while (*s++)
            ++i;
    return i;
}

