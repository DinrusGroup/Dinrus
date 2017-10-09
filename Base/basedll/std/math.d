// Написано на языке программирования Динрус. Разработчик Виталий Кулич.


module std.x.math;

import std.x.math, std.x.math2;

креал син(креал x){return std.x.math.sin(x);}
вреал син(вреал x){return std.x.math.sin(x);}
реал абс(креал x){return std.x.math.abs(x);}
реал абс(вреал x){return std.x.math.abs(x);}
креал квкор(креал x){return std.x.math.sqrt(x);}
креал кос(креал x){return std.x.math.cos(x);}
креал конъюнк(креал y){return std.x.math.conj(y);}
вреал конъюнк(вреал y){return std.x.math.conj(y);}
реал кос(вреал x){return std.x.math.cos(x);}
реал степень(реал а, бцел н){return std.x.math.pow(а, н);}

цел квадрат(цел а){return std.x.math2.sqr(а);}
дол квадрат(цел а){return std.x.math2.sqr(а);}
цел сумма(цел[] ч){return std.x.math2.sum(ч);}
дол сумма(дол[] ч){return std.x.math2.sum(ч);}
цел меньш_из(цел[] ч){return std.x.math2.min(ч);}
дол меньш_из(дол[] ч){return std.x.math2.min(ч);}
цел меньш_из(цел а, цел б){return std.x.math2.min(а, б);}
дол меньш_из(дол а, дол б){return std.x.math2.min(а, б);}
цел больш_из(цел[] ч){return std.x.math2.max(ч);}
дол больш_из(дол[] ч){return std.x.math2.max(ч);}
цел больш_из(цел а, цел б){return std.x.math2.max(а, б);}
дол больш_из(дол а, дол б){return std.x.math2.max(а, б);}

реал абс(реал x){return std.x.math.abs(x);}
дол абс(дол x){return std.x.math.abs(x);}
цел абс(цел x){return std.x.math.abs(x);}
реал кос(реал x){return std.x.math.cos(x);}
реал син(реал x){return std.x.math.sin(x);}
реал тан(реал x){return std.x.math.tan(x);}
реал акос(реал x){return std.x.math.acos(x);}
реал асин(реал x){return std.x.math.asin(x);}
реал атан(реал x){return std.x.math.atan(x);}
реал атан2(реал y, реал x){return std.x.math.atan2(x, y);}
реал гкос(реал x){return std.x.math.cosh(x);}
реал гсин(реал x){return std.x.math.sinh(x);}
реал гтан(реал x){return std.x.math.tanh(x);}
реал гакос(реал x){return std.x.math.acosh(x);}
реал гасин(реал x){return std.x.math.asinh(x);}
реал гатан(реал x){return std.x.math.atanh(x);}
дол округливдол(реал x){return std.x.math.rndtol(x);}
реал округливближдол(реал x){return std.x.math.rndtonl(x);}
плав квкор(плав x){return std.x.math.sqrt(x);}
дво квкор(дво x){return std.x.math.sqrt(x);}
реал квкор(реал x){return std.x.math.sqrt(x);}
реал эксп(реал x){return std.x.math.exp(x);}
реал экспм1(реал x){return std.x.math.expm1(x);}
реал эксп2(реал x){return std.x.math.exp2(x);}
креал экспи(реал x){return std.x.math.expi(x);}
реал прэксп(реал знач, out цел эксп){return std.x.math.frexp(знач, эксп);}
цел илогб(реал x){return std.x.math.ilogb(x);}
реал лдэксп(реал н, цел эксп){return std.x.math.ldexp(н, эксп);}
реал лог(реал x){return std.x.math.log(x);}
реал лог10(реал x){return std.x.math.log10(x);}
реал лог1п(реал x){return std.x.math.log1p(x);}
реал лог2(реал x){return std.x.math.log2(x);}
реал логб(реал x){return std.x.math.logb(x);}
реал модф(реал x, inout реал y){return std.x.math.modf(x, y);}
реал скалбн(реал x, цел н){return std.x.math.scalbn(x,н);}
реал кубкор(реал x){return std.x.math.cbrt(x);}
реал фабс(реал x){return std.x.math.fabs(x);}
реал гипот(реал x, реал y){return std.x.math.hypot(x, y);}
реал фцош(реал x){return std.x.math.erf(x);}
реал лгамма(реал x){return std.x.math.lgamma(x);}
реал тгамма(реал x){return std.x.math.tgamma(x);}
реал потолок(реал x){return std.x.math.ceil(x);}
реал пол(реал x){return std.x.math.floor(x);}
реал ближцел(реал x){return std.x.math.nearbyint(x);}

цел окрвцел(реал x)
{
    //version(Naked_D_InlineAsm_X86)
   // {
        цел n;
        asm
        {
            fld x;
            fistp n;
        }
        return n;
  //  }
  //  else
  //  {
   //     return cidrus.lrintl(x);
   // }
}
реал окрвреал(реал x){return std.x.math.rint(x);}
дол окрвдол(реал x){return std.x.math.lrint(x);}
реал округли(реал x){return std.x.math.round(x);}
дол докругли(реал x){return std.x.math.lround(x);}
реал упрости(реал x){return std.x.math.trunc(x);}
реал остаток(реал x, реал y){return std.x.math.remainder(x, y);}
бул нч_ли(реал x){return cast(бул) std.x.math.isnan(x);}
бул конечен_ли(реал р){return cast(бул) std.x.math.isfinite(р);}

бул субнорм_ли(плав п){return cast(бул) std.x.math.issubnormal(п);}
бул субнорм_ли(дво п){return cast(бул) std.x.math.issubnormal(п);}
бул субнорм_ли(реал п){return cast(бул) std.x.math.issubnormal(п);}
бул беск_ли(реал р){return cast(бул) std.x.math.isinf(р);}
бул идентичен_ли(реал р, реал д){return std.x.math.isIdentical(р, д);}
бул битзнака(реал р){ if(1 == std.x.math.signbit(р)){return да;} return нет;}
реал копируйзнак(реал кому, реал у_кого){return std.x.math.copysign(кому, у_кого);}
реал нч(ткст тэгп){return std.x.math.nan(тэгп);}
реал следщБольш(реал р){return std.x.math.nextUp(р);}
дво следщБольш(дво р){return std.x.math.nextUp(р);}
плав следщБольш(плав р){return std.x.math.nextUp(р);}
реал следщМеньш(реал р){return std.x.math.nextUp(р);}
дво следщМеньш(дво р){return std.x.math.nextUp(р);}
плав следщМеньш(плав р){return std.x.math.nextUp(р);}
реал следщза(реал а, реал б){return std.x.math.nextafter(а, б);}
плав следщза(плав а, плав б){return std.x.math.nextafter(а, б);}
дво следщза(дво а, дво б){return std.x.math.nextafter(а, б);}
реал пдельта(реал а, реал б){return std.x.math.fdim(а, б);}
реал пбольш_из(реал а, реал б){return std.x.math.fmax(а, б);}
реал пменьш_из(реал а, реал б){return std.x.math.fmin(а, б);}

реал степень(реал а, цел н){return std.x.math.pow(а, н);}
реал степень(реал а, реал н){return std.x.math.pow(а, н);}

import std.x.math2;

бул правны(реал а, реал б){return std.x.math2.feq(а, б);}
бул правны(реал а, реал б, реал эпс){return std.x.math2.feq(а, б, эпс);}

реал квадрат(цел а){return std.x.math2.sqr(а);}
реал дробь(реал а){return std.x.math2.frac(а);}
цел знак(цел а){return std.x.math2.sign(а);}
цел знак(дол а){return std.x.math2.sign(а);}
цел знак(реал а){return std.x.math2.sign(а);}
реал цикл8градус(реал ц){return std.x.math2.cycle2deg(ц);}
реал цикл8радиан(реал ц){return std.x.math2.cycle2rad(ц);}
реал цикл8градиент(реал ц){return std.x.math2.cycle2grad(ц);}
реал градус8цикл(реал г){return std.x.math2.deg2cycle(г);}
реал градус8радиан(реал г){return std.x.math2.deg2rad(г);}
реал градус8градиент(реал г){return std.x.math2.deg2grad(г);}
реал радиан8градус(реал р){return std.x.math2.rad2deg(р);}
реал радиан8цикл(реал р){return std.x.math2.rad2cycle(р);}
реал радиан8градиент(реал р){return std.x.math2.rad2grad(р);}
реал градиент8градус(реал г){return std.x.math2.grad2deg(г);}
реал градиент8цикл(реал г){return std.x.math2.grad2cycle(г);}
реал градиент8радиан(реал г){return std.x.math2.grad2rad(г);}
реал сариф(реал[] ч){return std.x.math2.avg(ч);}
реал сумма(реал[] ч){return std.x.math2.sum(ч);}
реал меньш_из(реал[] ч){return std.x.math2.min(ч);}
реал меньш_из(реал а, реал б){return std.x.math2.min(а, б);}
реал больш_из(реал[] ч){return std.x.math2.max(ч);}
реал больш_из(реал а, реал б){return std.x.math2.max(а, б);}
реал акот(реал р){return std.x.math2.acot(р);}
реал асек(реал р){return std.x.math2.asec(р);}
реал акосек(реал р){return std.x.math2.acosec(р);}
реал кот(реал р){return std.x.math2.cot(р);}
реал сек(реал р){return std.x.math2.sec(р);}
реал косек(реал р){return std.x.math2.cosec(р);}
реал гкот(реал р){return std.x.math2.coth(р);}
реал гсек(реал р){return std.x.math2.sech(р);}
реал гкосек(реал р){return std.x.math2.cosech(р);}
реал гакот(реал р){return std.x.math2.acoth(р);}
реал гасек(реал р){return std.x.math2.asech(р);}
реал гакосек(реал р){return std.x.math2.acosech(р);}
реал ткст8реал(ткст т){return std.x.math2.atof(т);}