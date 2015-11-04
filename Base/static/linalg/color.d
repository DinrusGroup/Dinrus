/**
Модуль из классов и функций для работы со значениями цвета.

В нём есть структуры для представления Красно-Зелёно-Синего цвета (Цвет3),
цвета КЗС+Альфа  (Цвет4) и триады Hue Saturation Luminance (ХСЛ).

All components of those structs are плав значения, not integers.
Rationale is that under different circumstances it is necessary to
work with different standards of integer representation. Frequently
one байт-wise integer layout needed for one API и another for секунда.
One can require АКЗС порядок, another СЗКА. So it'с better to operate with
floats и to convert them to integer just when it is necessary.

Normal диапазон for плав components' значения is [0; 1]. Normal диапазон for integer
значения is [0; 255] for Цвет3 и Цвет4, и [0; 240] for ХСЛ. Each struct
имеется several methods to convert native плав representation to integer и
back.

Authors:
    Victor Nakoryakov, nail-mail[at]mail.ru
*/

module linalg.color;

 import linalg.basic,
               linalg.config;

/** Defines байты orders for плав to бцел conversions. */
enum ПорядокБайтов
{
    АКЗС,        ///
    АСЗК,        /// описано
    КЗСА,        /// описано
    СЗКА
}

/**
Wrapper template to provide possibility to use different плав types
in implemented structs и routines.
*/
 template Цвет(т_плав)
{
     alias linalg.basic.закрепиПод  закрепиПод;
     alias linalg.basic.закрепиНад  закрепиНад;
     alias linalg.basic.закрепи       закрепи;
     alias linalg.basic.равны       равны;

     alias .Цвет!(плав).ХСЛ      ХСЛп;
     alias .Цвет!(плав).Цвет3   Цвет3п;
     alias .Цвет!(плав).Цвет4   Цвет4п;

     alias .Цвет!(дво).ХСЛ     ХСЛд;
     alias .Цвет!(дво).Цвет3  Цвет3д;
     alias .Цвет!(дво).Цвет4  Цвет4д;

     alias .Цвет!(реал).ХСЛ       ХСЛр;
     alias .Цвет!(реал).Цвет3    Цвет3р;
     alias .Цвет!(реал).Цвет4    Цвет4р;

     static const т_плав кзсК = 255;
     static const т_плав хслК = 240;

    /************************************************************************************
    Hue, Saturation, Luminance triple.
    *************************************************************************************/
    struct ХСЛ
    {
        т_плав х; /// Hue.
        т_плав с; /// Saturation.
        т_плав л; /// Luminance.

        /**
        Method to construct struct in C-like syntax.

        Примеры:
        ------------
        ХСЛ hsl = ХСЛ(0.1, 0.2, 0.3);
        ------------
        */
        static ХСЛ opCall(т_плав х, т_плав с, т_плав л)
        {
            ХСЛ hsl;
            hsl.установи(х, с, л);
            return hsl;
        }

        /** Sets components to значения of passed аргументы. */
        проц установи(т_плав х, т_плав с, т_плав л)
        {
            this.х = х;
            this.с = с;
            this.л = л;
        }

        /** Возвращает: Integer value of corresponding component in диапазон [0; 240]. */
        бцел хц()
        {
            return cast(бцел)(х * хслК);
        }

        /** описано */
        бцел сц()
        {
            return cast(бцел)(с * хслК);
        }

        /** описано */
        бцел лц()
        {
            return cast(бцел)(л * хслК);
        }

        /**
        Set components to значения of passed аргументы. It is assumed that значения of
        аргументы are in диапазон [0; 240].
        */
        проц хц(бцел х)
        {
            this.х = cast(т_плав)х / хслК;
        }

        /** описано */
        проц сц(бцел с)
        {
            this.с = cast(т_плав)с / хслК;
        }

        /** описано */
        проц лц(бцел л)
        {
            this.л = cast(т_плав)л / хслК;
        }

        /** Component-wise equality operator. */
        бул opEquals(ХСЛ hsl)
        {
            return х == hsl.х && с == hsl.с && л == hsl.л;
        }

        /** Возвращает: Цвет3 representing the same color as this triple. */
        Цвет3 вЦвет3()
        {
            const крат кзсMax = cast(крат)кзсК;
            const крат hslMax = cast(крат)хслК;
            крат HueToRGB(крат n1, крат n2, крат hue)
            {
                // диапазон проверь: note значения passed add/subtract thirds of диапазон
                if (hue < 0)
                    hue += hslMax;

                if (hue > hslMax)
                    hue -= hslMax;

                // return к,з, or с value from this tridrant
                if (hue < hslMax / 6)
                    return n1 + ((n2 - n1) * hue + hslMax / 12) / (hslMax / 6);
                if (hue < hslMax / 2)
                    return n2;
                if (hue < hslMax * 2 / 3)
                    return n1 + ((n2 - n1) * ((hslMax * 2/3) - hue) + (hslMax / 12)) / (hslMax / 6);
                else
                    return n1;
            }

            крат hue = cast(крат)хц;
            крат lum = cast(крат)лц;
            крат sat = cast(крат)сц;
            крат magic1, magic2; // calculated magic numbers

            Цвет3 возвр;

            if (sat == 0) // achromatic case
            {
                возвр.установи(л, л, л);
            }
            else // chromatic case
            {
                // установи up magic numbers
                if (lum <= hslMax / 2)
                    magic2 = (lum * (hslMax + sat) + hslMax / 2) / hslMax;
                else
                    magic2 = lum + sat - (lum * sat + hslMax / 2) / hslMax;

                magic1 = 2 * lum - magic2;

                // дай RGB, change units from hslMax to [0; 1] диапазон
                возвр.к = cast(т_плав)(HueToRGB(magic1, magic2, hue + (hslMax / 3)) * кзсMax + hslMax / 2) / хслК / кзсК;
                возвр.з = cast(т_плав)(HueToRGB(magic1, magic2, hue) * кзсMax + hslMax / 2) / хслК / кзсК;
                возвр.с = cast(т_плав)(HueToRGB(magic1, magic2, hue - (hslMax / 3)) * кзсMax + hslMax / 2) / хслК / кзсК;
            }

            return возвр;
        }
    }

    /**
    Approximate equality function.
    Params:
        отнпрец, абспрец = Parameters passed to равны function while calculations.
                           Have the same meaning as in равны function.
    */
    бул равны(ХСЛ а, ХСЛ с, цел отнпрец = дефотнпрец, цел абспрец = дефабспрец)
    {
        ХСЛ c;
        c.установи(а.х - с.х, а.с - с.с, а.л - с.л);
        return .равны(c.х * c.х + c.с * c.с + c.л * c.л, 0, отнпрец, абспрец);
    }

    /************************************************************************************
    Red, Green, Blue triple.
    *************************************************************************************/
    struct Цвет3
    {
        align(1)
        {
            т_плав к; /// Red.
            т_плав з; /// Green.
            т_плав с; /// Blue.
        }

        /// Цвет3 with all components seted to NaN.
        static Цвет3 нч = { т_плав.nan, т_плав.nan, т_плав.nan };

        /**
        Method to construct color in C-like syntax.

        Примеры:
        ------------
        Цвет3 c = Цвет3(0.1, 0.2, 0.3);
        ------------
        */
        static Цвет3 opCall(т_плав к, т_плав з, т_плав с)
        {
            Цвет3 v;
            v.установи(к, з, с);
            return v;
        }

        /**
        Method to construct color in C-like syntax from value specified
        in бцел parameter.

        Params:
            ист     = бцел to выкинь value from.
            порядок   = specifies байт-wise _order in ист.

        Примеры:
        ------------
        Цвет3 c = Цвет3(0x00FFEEDD, ПорядокБайтов.АКЗС);
        ------------
        */
        static Цвет3 opCall(бцел ист, ПорядокБайтов порядок)
        {
            Цвет3 v;
            v.установи(ист, порядок);
            return v;
        }

        /** Sets components to значения of passed аргументы. */
        проц установи(т_плав к, т_плав з, т_плав с)
        {
            this.к = к;
            this.з = з;
            this.с = с;
        }

        /**
        Sets components according to color packed in ист бцел аргумент.

        Params:
            ист     = бцел to выкинь value from.
            порядок   = specifies байт-wise component layout in ист.
        */
        проц установи(бцел ист, ПорядокБайтов порядок = ПорядокБайтов.АКЗС)
        {
            switch (порядок)
            {
                case ПорядокБайтов.АКЗС:
                    кц = (ист & 0x00FF0000) >> 16;
                    зц = (ист & 0x0000FF00) >> 8;
                    сц = (ист & 0x000000FF) >> 0;
                    break;

                case ПорядокБайтов.АСЗК:
                    сц = (ист & 0x00FF0000) >> 16;
                    зц = (ист & 0x0000FF00) >> 8;
                    кц = (ист & 0x000000FF) >> 0;
                    break;

                case ПорядокБайтов.КЗСА:
                    кц = (ист & 0xFF000000) >>> 24;
                    зц = (ист & 0x00FF0000) >>> 16;
                    сц = (ист & 0x0000FF00) >>> 8;
                    break;

                case ПорядокБайтов.СЗКА:
                    сц = (ист & 0xFF000000) >>> 24;
                    зц = (ист & 0x00FF0000) >>> 16;
                    кц = (ист & 0x0000FF00) >>> 8;
                    break;
            }
        }

        /** Возвращает: Whether all components are нормализованный numbers. */
        бул нормален_ли()
        {
            return stdrus.нормален_ли(к) && stdrus.нормален_ли(з) && stdrus.нормален_ли(с);
        }

        /**
        Возвращает: Integer value of corresponding component.

        Float value 0 is mapped to integer 0. Float value 1 is mapped to
        integer 255.
        */
        цел кц()
        {
            return cast(цел)(к * кзсК);
        }

        /** описано */
        цел зц()
        {
            return cast(цел)(з * кзсК);
        }

        /** описано */
        цел сц()
        {
            return cast(цел)(с * кзсК);
        }

        /**
        Sets corresponding component value to mapped value of passed аргумент.

        Integer value 0 is mapped to плав 0. Integer value 255 is mapped to
        плав 1.
        */
        проц кц(цел к)
        {
            this.к = cast(т_плав)к / кзсК;
        }

        /** описано */
        проц зц(цел з)
        {
            this.з = cast(т_плав)з / кзсК;
        }

        /** описано */
        проц сц(цел с)
        {
            this.с = cast(т_плав)с / кзсК;
        }

        /**
        Возвращает:
            This color packed to бцел.
        Params:
            порядок = specifies байт-wise component layout in ист.
        Throws:
            AssertError if any component is out of диапазон [0; 1] и module was
            compiled with asserts.
        */
        бцел вБцел(ПорядокБайтов порядок)
        {
            assert(кц >= 0 && кц < 256);
            assert(зц >= 0 && зц < 256);
            assert(сц >= 0 && сц < 256);

            switch (порядок)
            {
                case ПорядокБайтов.АКЗС: return (кц << 16) | (зц <<  8) | (сц << 0);
                case ПорядокБайтов.АСЗК: return (сц << 16) | (зц <<  8) | (кц << 0);
                case ПорядокБайтов.КЗСА: return (кц << 24) | (зц << 16) | (сц << 8);
                case ПорядокБайтов.СЗКА: return (сц << 24) | (зц << 16) | (кц << 8);
            }

            return 0;
        }

        /**
        Возвращает:
            ХСЛ triple representing same color as this.
        */
        ХСЛ вХСЛ()
        {
            const крат hslMax = cast(крат)хслК;
            const крат кзсMax = cast(крат)кзсК;

            ббайт х, с, л;
            ббайт cMax, cMin;                // макс и мин RGB значения
            крат rDelta, gDelta, bDelta;    // intermediate value: % of spread from макс

            // дай R, G, и B out of DWORD
            крат к = кц;
            крат з = зц;
            крат син = сц;

            // calculate lightness
            cMax = макс(макс(к, з), син);
            cMin = мин(мин(к, з), син);
            л = ((cMax + cMin) * hslMax + кзсMax) / (2 * кзсMax);

            if (cMax == cMin)                // к = з = с --> achromatic case
            {
                х = с = 0;
            }
            else
            {                                // chromatic case
                // saturation
                if (л <= hslMax / 2)
                    с = ((cMax - cMin) * hslMax + (cMax + cMin) / 2) / (cMax + cMin);
                else
                    с = ((cMax - cMin) * hslMax + (2 * кзсMax - cMax - cMin) / 2) / (2 * кзсMax - cMax - cMin);

                // hue
                rDelta = ((cMax - к) * (hslMax / 6) + (cMax - cMin) / 2) / (cMax - cMin);
                gDelta = ((cMax - з) * (hslMax / 6) + (cMax - cMin) / 2) / (cMax - cMin);
                bDelta = ((cMax - с) * (hslMax / 6) + (cMax - cMin) / 2) / (cMax - cMin);

                if (к == cMax)
                    х = bDelta - gDelta;
                else if (з == cMax)
                    х = (hslMax / 3) + rDelta - bDelta;
                else // B == cMax
                    х = (2 * hslMax) / 3 + gDelta - rDelta;

                if(х < 0)
                    х += hslMax;

                if(х > hslMax)
                    х -= hslMax;
            }

            ХСЛ возвр;
            возвр.хц = х;
            возвр.сц = с;
            возвр.лц = л;
            return возвр;
        }

        /** Возвращает: т_плав pointer to к component of this color. It'с like а _ptr method for arrays. */
        т_плав* укз()
        {
            return cast(т_плав*)this;
        }

        /**
        Standard operators that have meaning exactly the same as for Вектор3, i.e. do
        component-wise operations.

        Note that division operators do no cheks of value of k, so in case of division
        by 0 result вектор will have infinity components. You can проверь this with нормален_ли()
        method.
        */
        бул opEquals(Цвет3 v)
        {
            return к == v.к && з == v.з && с == v.с;
        }

        /** описано */
        Цвет3 opNeg()
        {
            return Цвет3(-к, -з, -с);
        }

        /** описано */
        Цвет3 opAdd(Цвет3 v)
        {
            return Цвет3(к + v.к, з + v.з, с + v.с);
        }

        /** описано */
        проц opAddAssign(Цвет3 v)
        {
            к += v.к;
            з += v.з;
            с += v.с;
        }

        /** описано */
        Цвет3 opSub(Цвет3 v)
        {
            return Цвет3(к - v.к, з - v.з, с - v.с);
        }

        /** описано */
        проц opSubAssign(Цвет3 v)
        {
            к -= v.к;
            з -= v.з;
            с -= v.с;
        }

        /** описано */
        Цвет3 opMul(реал k)
        {
            return Цвет3(к * k, з * k, с * k);
        }

        /** описано */
        проц opMulAssign(реал k)
        {
            к *= k;
            з *= k;
            с *= k;
        }

        /** описано */
        Цвет3 opMulr(реал k)
        {
            return Цвет3(к * k, з * k, с * k);
        }

        /** описано */
        Цвет3 opDiv(реал k)
        {
            return Цвет3(к / k, з / k, с / k);
        }

        /** описано */
        проц opDivAssign(реал k)
        {
            к /= k;
            з /= k;
            с /= k;
        }

        /** Sets all components меньше than беск to беск. */
        проц закрепиПод(т_плав беск = 0)
        {
            .закрепиПод(к, беск);
            .закрепиПод(з, беск);
            .закрепиПод(с, беск);
        }

        /** Возвращает: Copy of this color with all components меньше than беск seted to беск. */
        Цвет3 закреплённыйПод(т_плав беск = 0)
        {
            Цвет3 возвр = *this;
            возвр.закрепиПод(беск);
            return возвр;
        }

        /** Sets all components больше than sup to sup. */
        проц закрепиНад(т_плав sup = 1)
        {
            .закрепиНад(к, sup);
            .закрепиНад(з, sup);
            .закрепиНад(с, sup);
        }

        /** Возвращает: Copy of this color with all components больше than sup seted to sup. */
        Цвет3 закреплённыйНад(т_плав sup = 1)
        {
            Цвет3 возвр = *this;
            возвр.закрепиПод(sup);
            return возвр;
        }

        /**
        Sets all components меньше than беск to беск и
        all components больше than sup to sup.
        */
        проц закрепи(т_плав беск = 0, т_плав sup = 1)
        {
            закрепиПод(беск);
            закрепиНад(sup);
        }

        /**
        Возвращает:
            Copy of this color with all components меньше than беск seted to беск
            и all components больше than sup seted to sup.
        */
        Цвет3 закреплённый(т_плав беск = 0, т_плав sup = 1)
        {
            Цвет3 возвр = *this;
            возвр.закрепи(беск, sup);
            return возвр;
        }

        /** Возвращает: Copy of this color with плав type components. */
        Цвет3п вЦвет3п()
        {
            return Цвет3п(cast(плав)к, cast(плав)з, cast(плав)с);
        }

        /** Возвращает: Copy of this color with дво type components. */
        Цвет3д вЦвет3д()
        {
            return Цвет3д(cast(дво)к, cast(дво)з, cast(дво)с);
        }

        /** Возвращает: Copy of this color with реал type components. */
        Цвет3р вЦвет3р()
        {
            return Цвет3р(cast(реал)к, cast(реал)з, cast(реал)с);
        }

        /**
        Routines known as swizzling.
        Возвращает:
            Нов color constructed from this one и having component значения
            that correspond to method имя.
        */
        Цвет4 кзс0()    { return Цвет4(к, з, с, 0); }
        Цвет4 кзс1()    { return Цвет4(к, з, с, 1); } /// описано
    }

    /**
    Approximate equality function.
    Params:
        отнпрец, абспрец = Parameters passed to равны function while calculations.
                           Have the same meaning as in равны function.
    */
    бул равны(Цвет3 а, Цвет3 с, цел отнпрец = дефотнпрец, цел абспрец = дефабспрец)
    {
        Цвет3 c = а - с;
        return .равны(c.к * c.к + c.з * c.з + c.с * c.с, 0, отнпрец, абспрец);
    }

    alias Лининтерп!(Цвет3).лининтерп лининтерп; /// Introduces linear interpolation function for Цвет3.


    /************************************************************************************
    Red, Green, Blue triple with additional Alpha component.
    *************************************************************************************/
    struct Цвет4
    {
        align(1)
        {
            т_плав к; /// Red.
            т_плав з; /// Green.
            т_плав с; /// Blue.
            т_плав а; /// Alpha.
        }

        /// Цвет4 with all components seted to NaN.
        static Цвет4 нч = { т_плав.nan, т_плав.nan, т_плав.nan, т_плав.nan };

        /**
        Methods to construct color in C-like syntax.

        Примеры:
        ------------
        Цвет4 c1 = Цвет4(0.1, 0.2, 0.3, 1);
        Цвет3 кзс = Цвет3(0, 0, 0.5);
        Цвет4 c2 = Цвет4(кзс, 1);
        ------------
        */
        static Цвет4 opCall(т_плав к, т_плав з, т_плав с, т_плав а)
        {
            Цвет4 v;
            v.установи(к, з, с, а);
            return v;
        }

        /** описано */
        static Цвет4 opCall(Цвет3 кзс, т_плав а = 1)
        {
            Цвет4 v;
            v.установи(кзс, а);
            return v;
        }


        /**
        Method to construct color in C-like syntax from value specified
        in бцел parameter.

        Params:
            ист     = бцел to выкинь value from.
            порядок   = specifies байт-wise _order in ист.

        Примеры:
        ------------
        Цвет4 c = Цвет4(0x99FFEEDD, ПорядокБайтов.АКЗС);
        ------------
        */
        static Цвет4 opCall(бцел ист, ПорядокБайтов порядок)
        {
            Цвет4 v;
            v.установи(ист, порядок);
            return v;
        }


        /** Set components to значения of passed аргументы. */
        проц установи(т_плав к, т_плав з, т_плав с, т_плав а)
        {
            this.к = к;
            this.з = з;
            this.с = с;
            this.а = а;
        }

        /** описано */
        проц установи(Цвет3 кзс, т_плав а)
        {
            this.кзс = кзс;
            this.а = а;
        }


        /**
        Sets components according to color packed in ист бцел аргумент.

        Params:
            ист     = бцел to выкинь value from.
            порядок   = specifies байт-wise layout in ист.
        */
        проц установи(бцел ист, ПорядокБайтов порядок = ПорядокБайтов.АКЗС)
        {
            switch (порядок)
            {
                case ПорядокБайтов.АКЗС:
                    ац = (ист & 0xFF000000) >>> 24;
                    кц = (ист & 0x00FF0000) >>> 16;
                    зц = (ист & 0x0000FF00) >>> 8;
                    сц = (ист & 0x000000FF) >>> 0;
                    break;

                case ПорядокБайтов.АСЗК:
                    ац = (ист & 0xFF000000) >>> 24;
                    сц = (ист & 0x00FF0000) >>> 16;
                    зц = (ист & 0x0000FF00) >>> 8;
                    кц = (ист & 0x000000FF) >>> 0;
                    break;

                case ПорядокБайтов.КЗСА:
                    кц = (ист & 0xFF000000) >>> 24;
                    зц = (ист & 0x00FF0000) >>> 16;
                    сц = (ист & 0x0000FF00) >>> 8;
                    ац = (ист & 0x000000FF) >>> 0;
                    break;

                case ПорядокБайтов.СЗКА:
                    сц = (ист & 0xFF000000) >>> 24;
                    зц = (ист & 0x00FF0000) >>> 16;
                    кц = (ист & 0x0000FF00) >>> 8;
                    ац = (ист & 0x000000FF) >>> 0;
                    break;
            }
        }

        /** Возвращает: Whether all components are нормализованный numbers. */
        бул нормален_ли()
        {
            return stdrus.нормален_ли(к) && stdrus.нормален_ли(з) && stdrus.нормален_ли(с) && stdrus.нормален_ли(а);
        }

        /**
        Возвращает: Integer value of corresponding component.

        Float value 0 is mapped to integer 0. Float value 1 is mapped to
        integer 255.
        */
        цел кц()
        {
            return cast(цел)(к * кзсК);
        }

        /** описано */
        цел зц()
        {
            return cast(цел)(з * кзсК);
        }

        /** описано */
        цел сц()
        {
            return cast(цел)(с * кзсК);
        }

        /** описано */
        цел ац()
        {
            return cast(цел)(а * кзсК);
        }

        /**
        Sets corresponding component value to mapped value of passed аргумент.

        Integer value 0 is mapped to плав 0. Integer value 255 is mapped to
        плав 1.
        */
        проц кц(цел к)
        {
            this.к = cast(т_плав)к / кзсК;
        }

        /** описано */
        проц зц(цел з)
        {
            this.з = cast(т_плав)з / кзсК;
        }

        /** описано */
        проц сц(цел с)
        {
            this.с = cast(т_плав)с / кзсК;
        }

        /** описано */
        проц ац(цел а)
        {
            this.а = cast(т_плав)а / кзсК;
        }

        /**
        Возвращает:
            This color packed to бцел.
        Params:
            порядок = specifies байт-wise component layout in ист.
        Throws:
            AssertError if any component is out of диапазон [0; 1] и
            module was compiled with asserts.
        */
        бцел вБцел(ПорядокБайтов порядок)
        {
            assert(кц >= 0 && кц < 256);
            assert(зц >= 0 && зц < 256);
            assert(сц >= 0 && сц < 256);
            assert(ац >= 0 && ац < 256);

            switch (порядок)
            {
                case ПорядокБайтов.АКЗС: return (ац << 24) | (кц << 16) | (зц <<  8) | (сц << 0);
                case ПорядокБайтов.АСЗК: return (ац << 24) | (сц << 16) | (зц <<  8) | (кц << 0);
                case ПорядокБайтов.КЗСА: return (кц << 24) | (зц << 16) | (сц <<  8) | (ац << 0);
                case ПорядокБайтов.СЗКА: return (сц << 24) | (зц << 16) | (кц <<  8) | (ац << 0);
            }

            return 0;
        }

        /**
        Возвращает:
            ХСЛ triple representing same color as this.

        Alpha value is ignored.
        */
        ХСЛ вХСЛ()
        {
            return кзс.вХСЛ();
        }

        /** Возвращает: т_плав pointer to к component of this color. It'с like а _ptr method for arrays. */
        т_плав* укз()
        {
            return cast(т_плав*)this;
        }


        /**
        Standard operators that have meaning exactly the same as for Вектор4, i.e. do
        component-wise operations. So alpha component equaly in rights takes place in all
        operations, to affect just RGB part use swizzling operations.

        Note that division operators do no cheks of value of k, so in case of division
        by 0 result вектор will have infinity components. You can проверь this with нормален_ли()
        method.
        */
        бул opEquals(Цвет4 v)
        {
            return к == v.к && з == v.з && с == v.с && а == v.а;
        }

        /** описано */
        Цвет4 opNeg()
        {
            return Цвет4(-к, -з, -с, -а);
        }

        /** описано */
        Цвет4 opAdd(Цвет4 v)
        {
            return Цвет4(к + v.к, з + v.з, с + v.с, а + v.а);
        }

        /** описано */
        проц opAddAssign(Цвет4 v)
        {
            к += v.к;
            з += v.з;
            с += v.с;
            а += v.а;
        }

        /** описано */
        Цвет4 opSub(Цвет4 v)
        {
            return Цвет4(к - v.к, з - v.з, с - v.с, а - v.а);
        }

        /** описано */
        проц opSubAssign(Цвет4 v)
        {
            к -= v.к;
            з -= v.з;
            с -= v.с;
            а -= v.а;
        }

        /** описано */
        Цвет4 opMul(реал k)
        {
            return Цвет4(к * k, з * k, с * k, а * k);
        }

        /** описано */
        проц opMulAssign(реал k)
        {
            к *= k;
            з *= k;
            с *= k;
            а *= k;
        }

        /** описано */
        Цвет4 opMulr(реал k)
        {
            return Цвет4(к * k, з * k, с * k, а * k);
        }

        /** описано */
        Цвет4 opDiv(реал k)
        {
            return Цвет4(к / k, з / k, с / k, а / k);
        }

        /** описано */
        проц opDivAssign(реал k)
        {
            к /= k;
            з /= k;
            с /= k;
            а /= k;
        }

        /** Sets all components меньше than беск to беск. */
        проц закрепиПод(т_плав беск = 0)
        {
            .закрепиПод(к, беск);
            .закрепиПод(з, беск);
            .закрепиПод(с, беск);
            .закрепиПод(а, беск);
        }

        /** Возвращает: Copy of this color with all components меньше than беск seted to беск. */
        Цвет4 закреплённыйПод(т_плав беск = 0)
        {
            Цвет4 возвр = *this;
            возвр.закрепиПод(беск);
            return возвр;
        }

        /** Sets all components больше than sup to sup. */
        проц закрепиНад(т_плав sup = 1)
        {
            .закрепиНад(к, sup);
            .закрепиНад(з, sup);
            .закрепиНад(с, sup);
            .закрепиНад(а, sup);
        }

        /** Возвращает: Copy of this color with all components больше than sup seted to sup. */
        Цвет4 закреплённыйНад(т_плав sup = 1)
        {
            Цвет4 возвр = *this;
            возвр.закрепиПод(sup);
            return возвр;
        }

        /**
        Sets all components меньше than беск to беск и
        all components больше than sup to sup.
        */
        проц закрепи(т_плав беск = 0, т_плав sup = 1)
        {
            закрепиПод(беск);
            закрепиНад(sup);
        }

        /**
        Возвращает:
            Copy of this color with all components меньше than беск seted to беск
            и all components больше than sup seted to sup.
        */
        Цвет4 закреплённый(т_плав беск = 0, т_плав sup = 1)
        {
            Цвет4 возвр = *this;
            возвр.закрепи(беск, sup);
            return возвр;
        }

        /** Возвращает: Copy of this color with плав type components. */
        Цвет4п вЦвет4п()
        {
            return Цвет4п(cast(плав)к, cast(плав)з, cast(плав)с, cast(плав)а);
        }

        /** Возвращает: Copy of this color with дво type components. */
        Цвет4д вЦвет4д()
        {
            return Цвет4д(cast(дво)к, cast(дво)з, cast(дво)с, cast(дво)а);
        }

        /** Возвращает: Copy of this color with реал type components. */
        Цвет4р вЦвет4р()
        {
            return Цвет4р(cast(реал)к, cast(реал)з, cast(реал)с, cast(реал)а);
        }

        /**
        Routine known as swizzling.
        Возвращает:
            Цвет3 representing RGB part of this color.
        */
        Цвет3 кзс()
        {
            return Цвет3(к, з, с);
        }

        /**
        Routine known as swizzling.
        Sets RGB part components to значения of passed _кзс аргумент'с components.
        */
        проц кзс(Цвет3 кзс)
        {
            к = кзс.к;
            з = кзс.з;
            с = кзс.с;
        }
    }

    /**
    Approximate equality function.
    Params:
        отнпрец, абспрец = Parameters passed to равны function while calculations.
                           Have the same meaning as in равны function.
    */
    бул равны(Цвет4 а, Цвет4 с, цел отнпрец = дефотнпрец, цел абспрец = дефабспрец)
    {
        Цвет4 c = а - с;
        return .равны(c.к * c.к + c.з * c.з + c.с * c.с + c.а * c.а, 0, отнпрец, абспрец);
    }

    alias Лининтерп!(Цвет4).лининтерп лининтерп; /// Introduces linear interpolation function for Цвет4.
}

alias Цвет!(плав).ХСЛ         ХСЛп;
alias Цвет!(плав).Цвет3      Цвет3п;
alias Цвет!(плав).Цвет4      Цвет4п;
alias Цвет!(плав).равны       равны;
alias Цвет!(плав).лининтерп        лининтерп;

alias Цвет!(дво).ХСЛ        ХСЛд;
alias Цвет!(дво).Цвет3     Цвет3д;
alias Цвет!(дво).Цвет4     Цвет4д;
alias Цвет!(дво).равны      равны;
alias Цвет!(дво).лининтерп       лининтерп;

alias Цвет!(реал).ХСЛ          ХСЛр;
alias Цвет!(реал).Цвет3       Цвет3р;
alias Цвет!(реал).Цвет4       Цвет4р;
alias Цвет!(реал).равны        равны;
alias Цвет!(реал).лининтерп         лининтерп;

alias Цвет!(linalg.config.т_плав).ХСЛ     ХСЛ;
alias Цвет!(linalg.config.т_плав).Цвет3  Цвет3;
alias Цвет!(linalg.config.т_плав).Цвет4  Цвет4;

unittest
{
    Цвет4 а;
    а.установи(0.1, 0.3, 0.9, 0.6);
    Цвет3 с = а.кзс;
    бцел au = а.вБцел(ПорядокБайтов.КЗСА);
    assert( равны( Цвет3(au, ПорядокБайтов.КЗСА), с ) );
    assert(0);
}

unittest
{
    Цвет3 c = Цвет3( 0.2, 0.5, 1.0 );
    assert( равны(c.вХСЛ.вЦвет3(), c) );	
}

//============================
/*
Ниже идут импорты из OpenMesh, несовместимые с изложенными выше структурами,
поэтому они оставлены в английском варианте названия.
В дальнейшем нужно привести всё это в порядок и обеспечить совместимости типов
линейной алгебры и Меш.

*/
import linalg.VectorTypes;
import stdrus: пол;

alias Век3бб  Color3ub;
alias Век3п   Color3f;
alias Век3д   Color3d;


/** convert hsv color to rgb color 
   From: http://www.cs.rit.edu/~ncs/color/t_convert.html
   HSV и RGB components all on [0,1] interval.
*/
проц HSV_to_RGB(ref Color3f hsv,  Color3f* rgb)
{
    цел i;
    плав х = hsv[0]*6.0f; // х sector in [0.0, 6.0]
    плав с = hsv[1];
    плав v = hsv[2];
    if( с <= 0 ) {
        // achromatic (grey)
        (*rgb)[0]=v;
        (*rgb)[1]=v;
        (*rgb)[2]=v;
        return;
    }

    i = cast(цел)пол( х );
    плав f = х - i;          // fractional part of х
    плав p = v * ( 1 - с );
    плав q = v * ( 1 - с * f );
    плав t = v * ( 1 - с * ( 1 - f ) );

    плав r,g,b;
    switch( i ) {
    case 0:
        r = v;
        g = t;
        b = p;
        break;
    case 1:
        r = q;
        g = v;
        b = p;
        break;
    case 2:
        r = p;
        g = v;
        b = t;
        break;
    case 3:
        r = p;
        g = q;
        b = v;
        break;
    case 4:
        r = t;
        g = p;
        b = v;
        break;
    default:        // case 5:
        r = v;
        g = p;
        b = q;
        break;
    }
    (*rgb)[0]=r;
    (*rgb)[1]=g;
    (*rgb)[2]=b;
}

/** convert rgb color to hsv color 
 *   From: http://www.cs.rit.edu/~ncs/color/t_convert.html 
 *   х = [0,1], с = [0,1], v = [0,1]
 *		if с == 0, then х = -1 (undefined)
 */
проц RGB_to_HSV( ref Color3f rgb, Color3f *hsv)
{
	плав cmin = rgb[0]; 
    if (rgb[1]<cmin) { cmin = rgb[1]; }
    if (rgb[2]<cmin) { cmin = rgb[2]; }

	плав cmax = rgb[0]; 
    цел   imax = 0;
    if (rgb[1]>cmax) { cmax = rgb[1]; imax=1; }
    if (rgb[2]>cmax) { cmax = rgb[2]; imax=2; }

	(*hsv)[2] = cmax;				// v

	плав delta = cmax - cmin;

	if( cmax > 0 )
		(*hsv)[1] = delta / cmax;		// с
	else {
		// rgb = (0,0,0)		// с = 0, v is undefined
		(*hsv)[1] = 0;
		(*hsv)[0] = -1;
		return;
	}

    плав х;
	if( 0 == imax )
		х = ( rgb[1] - rgb[2] ) / delta;		// between yellow & magenta
	else if( 1 == imax )
		х = 2. + ( rgb[1] - rgb[0] ) / delta;	// between cyan & yellow
	else
		х = 4. + ( rgb[0] - rgb[1] ) / delta;	// between magenta & cyan

	х /= 6.0;				// [0,1] interval
	if( х < 0 )
		х += 1.0;

    (*hsv)[0] = х;
}
