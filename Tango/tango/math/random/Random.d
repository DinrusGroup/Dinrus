/*******************************************************************************
    Случай число generators
    
    This is an attempt at having a good flexible and easy в_ use random число
    generator.
    ease of use:
    $(UL
      $(LI  shared generator for быстро usage available through the "случ" объект
            ---
            цел i=случ.униформаР(10); // a random число из_ [0;10)
            ---
      )
      $(LI  simple Случай (non threadsafe) and СлучгенСинх (threadsafe) типы в_ 
            создай new generators (for heavy use a good опрea is one Случай объект per нить)
      )
      $(LI  several distributions can be requested like this
            ---
            случ.distributionD!(тип)(paramForDistribution)
            ---
            the тип can often be avoопрed if the параметры сделай it сотри.
            ОтКого it single numbers can be generated with .дайСлучайный(), and variables
            инициализован either with вызов стиль (var) or with .рандомируй(var).
            Utility functions в_ generate numbers directly are also available.
            The choice в_ помести все the distribution in a single объект that caches them
            есть made (for example) the gamma distribution very easy в_ implement.
      )
      $(LI  sample usage:
            ---
            auto r=new Случай();
            цел i; плав f; реал rv; реал[100] ar0; реал[] ar=ar0[];
            // инициализуй with униформа distribution
            i=r.униформа!(цел);
            f=r.униформа!(плав);
            rv=r.униформа!(реал);
            foreach (ref el;ar)
              el=r.униформа!(реал);
            // другой way в_ do все the previous in one go:
            r(i)(f)(rv)(ar);
            // unfortunetely one cannot use directly ar0...
            // униформа distribution 0..10
            i=r.униформаР(10);
            f=r.униформаР(10.0f);
            rv=r.униформаР(10.0L);
            foreach (ref el;ar)
              el=r.униформаР(10.0L);
            // другой way в_ do все the previous in one go:
            r.униформаРД(10)(i)(f)(r)(ar);
            // униформа numbers in [5;10)
            i=r.униформаР2(5,10);
            // униформа numbers in (5;10)
            f=r.униформаР2(5.0f,10.0f);
            rv=r.униформаР2(5.0L,10.0L);
            foreach (ref el;ar)
              el=r.униформаР2(5.0L,10.0L);
            // другой way в_ do все the previous in one go:
            r.униформаР2Д(5.0L,10.0L)(i)(f)(r)(ar);
            // униформа distribution -10..10
            i=r.униформаРСимм(10);
            // well you получи it...
            r.униформаРСиммД(10)(i)(f)(r)(ar);
            // any distribution can be stored
            auto r2=r.униформаРСиммД(10);
            // and used later
            r2(ar);
            // комплексное distributions (нормаль,эксп,gamma) are produced for the requested тип
            r.нормальныйИсточник!(плав)()(f);
            // with сигма=2
            r.нормальД(2.0f)(f);
            // and can be used also в_ инициализуй другой типы
            r.нормальныйИсточник!(плав)()(r)(ar);
            r.нормальД(2.0f)(r)(ar);
            // but this is different из_
            r.нормальныйИсточник!(реал)()(i)(r)(ar);
            r.нормальД(2.0L)(i)(r)(ar);
            // as the источник generates numbers of its тип that then are simply cast в_
            // the тип needed.
            // Uniform distribution (as its creation for different типы есть no overhead)
            // is never cast, so that (for example) bounds exclusion for floats is really
            // guaranteed.
            // For the другой distribution using a distribution of different тип than
            // the переменная should be готово with care, as недобор/перебор might ensue.
            //
            // Some utility functions are also available
            цел i2=r.униформа!(цел)();
            цел i2=r.рандомируй(i); // Всё i and i2 are инициализован в_ the same значение
            плав f2=r.нормальСигма(3.0f);
            ---
      )
    )
    flexibility:
    $(UL
      $(LI  easily свопpable basic источник
            ---
            // a random generator that uses the system provопрed random generator:
            auto r=СлуччисГ!(Urandom)();
            ---
            One could also build an engine that can be изменён at рантайм (that calls
            a delegate for example), but this добавьs a little overhead, and changing
            engine is not something готово often, so this is not часть of the library.
      )
      $(LI  ziggurat generator can be easily adapted в_ any decreasing derivable
            distribution, the hard parametrization (в_ найди xLast) can be готово
            automatically
      )
      $(LI  several distributions available "out of the box"
      )
      )
      Quality:
      $(UL
      $(LI  the default Source combines two surces that пароль все statistical tests 
            (KISS+CMWC)
            (P. L'Ecuyer and R. Simard, ACM Transactions on Mathematical Software (2007),
            33, 4, Article 22, for KISS, see CMWC engine for the другой)
      )
      $(LI  floating point униформа generator always initializes the full mantissa, the
            only flaw is a (*very* small) predilection of 0 as least important bit 
            (IEEE rounds в_ 0 in case of tie).
            Using a метод that initializes the full mantissa was shown в_ improve the
            quality of subsequntly производный нормаль distribued numbers
            (Thomas et al. Gaussian random число generators. Acm Comput Surv (2007)
            vol. 39 (4) pp. 11))
      )
      $(LI  Циггурат метод, a very fast and accurate метод was used for Всё Нормальный and
            эксп distributed numbers.
      )
      $(LI  gamma distribued numbers uses a метод recently proposed by Marsaglia and
            Tsang. The метод is very fast, and should be good.
            My (Fawzi's) feeling is that the transformation h(x)=(1+d*x)^3 might lose
            a couple of биты of точность in some cases, but it is unclear if this
            might become visible in (*very* extensive) tests or not.
      )
       the basic источник can be easily be изменён with something else
      Efficiency:
      $(LI  very fast methods have been used, and some effort есть been помести преобр_в
            optimizing some of them, but not все, but the interface есть been choosen
            so that закрой в_ optimal implementation can be provопрed through the same
            interface.
      )
      $(LI  Нормальный and Exp sources allocated only upon request: no память waste, but
            a (*very* small) скорость hit, that can be avoопрed by storing the источник in
            a переменная and using it (not going through the СлуччисГ)
      )
    )
    Annoyances:
    $(UL
      $(LI  I have добавьed two "следщ" methods в_ СлуччисГ for backward compatibility
            reasons, and the .экземпляр из_ Случай есть been
            replaced by the "случ" объект. The опрea behind this is that СлуччисГ is
            a template and случ it should be shared across все templates.
            If the имя случ is consопрered bad one could change it. 
            I kept .экземпляр static метод that returns случ, so this remain a dropin
            replacement of the old random.
      )
      $(LI You cannot инициализуй a static Массив directly, this because рандомируй is
          declared like this:
            ---
            U рандомируй(U)(ref U a) { }
            ---
            and a static Массив cannot be passed by reference. Removing the ref would
            сделай массивы инициализован, and scalar not, which is much worse.
      )
    )

        copyright:      Copyright (c) 2008. Fawzi Mohamed
        license:        BSD стиль: $(LICENSE)
        version:        Initial release: July 2008
        author:         Fawzi Mohamed

*******************************************************************************/
module math.random.Random;
import math.random.engines.URandom;
import math.random.engines.KissCmwc;
import math.random.engines.ArraySource;
import math.random.engines.Sync;
import math.random.engines.Twister;
import math.random.NormalSource;
import math.random.ExpSource;
import math.Math;
import core.Traits;

// ----- templateFu begin --------
/// компилируй время целое power
private T ctfe_powI(T)(T x,цел p){
    T xx=cast(T)1;
    if (p<0){
        p=-p;
        x=1/x;
    }
    for (цел i=0;i<p;++i)
        xx*=x;
    return xx;
}
// ----- templateFu конец --------

version (Win32) {
         private extern(Windows) цел QueryPerformanceCounter (бдол *);
}
version (Posix) {
    private import rt.core.stdc.posix.sys.время;
}

version(darwin) { version=has_urandom; }
version(linux)  { version=has_urandom; }
version(solaris){ version=has_urandom; }

/// if T is a плав
template плав_ли(T){
    static if(is(T==плав)||is(T==дво)||is(T==реал)){
        const бул плав_ли=да;
    } else {
        const бул плав_ли=нет;
    }
}

/// The default engine, a reasonably collision free, with good statistical свойства
/// not easy в_ invert, and with a relatively small ключ (but not too small)
alias KissCmwc_32_1 ДефолтныйДвижок;

/// Class that represents генератор случайных чисел.
/// Normally you should получи random numbers either with вызов-like interface:
///   auto r=new Случай(); r(i)(j)(k);
/// or with рандомируй
///   r.рандомируй(i); r.рандомируй(j); r.рандомируй(k);
/// if you use this you should be able в_ easily switch distribution later,
/// as все distributions support this interface, and can be built on the top of СлуччисГ
///   auto r2=r.НормальныйИсточник!(плав)(); r2(i)(j)(k);
/// there are utility methods within random for the cases in which you do not
/// want в_ build a special distribution for just a few numbers
final class СлуччисГ(ТИсток=ДефолтныйДвижок)
{
    // униформа random источник
    ТИсток источник;
    // нормаль distributed sources
    НормальныйИсточник!(СлуччисГ,плав)  нормалПлав;
    НормальныйИсточник!(СлуччисГ,дво) нормалДво;
    НормальныйИсточник!(СлуччисГ,реал)   нормалРеал;
    // эксп distributed sources
    ЭкспИсточник!(СлуччисГ,плав)  экспПлав;
    ЭкспИсточник!(СлуччисГ,дво) экспДво;
    ЭкспИсточник!(СлуччисГ,реал)   экспРеал;

    /// Creates and seeds a new generator
    this (бул randomInit=да)
    {
        if (randomInit)
            this.сей;
    }
    
    /// if источник.можноСеять seeds the generator using the shared случ generator
    /// (use urandom directly if available?)
    СлуччисГ сей ()
    {
        static if(источник.можноСеять){
            источник.сей(&случ.униформа!(бцел));
        }
        return this;
    }
    /// if источник.можноСеять seeds the generator using the given источник of бцелs
    СлуччисГ сей (бцел delegate() семяИсток)
    {
        static if(источник.можноСеять){
            источник.сей(семяИсток);
        }
        return this;
    }
    
    /// compatibility with old Случай, deprecate??
    бцел следщ(){
        return униформа!(бцел)();
    }
    /// ditto
    бцел следщ(бцел в_){
        return униформаР!(бцел)(в_);
    }
    /// ditto
    бцел следщ(бцел из_,бцел в_){
        return униформаР2!(бцел)(из_,в_);
    }
    /// ditto
    static СлуччисГ!(Sync!(ДефолтныйДвижок)) экземпляр(){
        return случ;
    }
    //-------- Utility functions в_ quickly получи a uniformly distributed random число -----------

    /// униформа distribution on the whole range of целое типы, and on
    /// the (0;1) range for floating point типы. Floating point guarantees the initialization
    /// of the full mantissa, but due в_ rounding effects it might have *very* small
    /// dependence due в_ rounding effects on the least significant bit (in case of tie 0 is favored).
    /// if проверкаГраниц is нет in the floating point case bounds might be included (but with a
    /// lower propability than другой numbers)
    T униформа(T,бул проверкаГраниц=да)(){
        static if(is(T==бцел)) {
            return источник.следщ;
        } else static if (is(T==цел) || is(T==крат) || is(T==бкрат)|| is(T==сим) || is(T==байт) || is(T==ббайт)){
            union Uint2A{
                T t;
                бцел u;
            }
            Uint2A a;
            a.u=источник.следщ;
            return a.t;
        } else static if (is(T==дол) || is (T==бдол)){
            return cast(T)источник.следщД;
        } else static if (is(T==бул)){
            return cast(бул)(источник.следщ & 1u); // check lowest bit
        } else static if (is(T==плав)||is(T==дво)||is(T==реал)){
            static if (T.mant_dig<30) {
                const T полТ=(cast(T)1)/(cast(T)2);
                const T факт32=ctfe_powI(полТ,32);
                const бцел minV=1u<<(T.mant_dig-1);
                бцел nV=источник.следщ;
                if (nV>=minV) {
                    T рез=nV*факт32;
                    static if (проверкаГраниц){
                        if (рез!=cast(T)1) return рез;
                        // 1 due в_ rounding (<3.e-8), 0 impossible
                        return униформа!(T,проверкаГраниц)();
                    } else {
                        return рез;
                    }
                } else { // probability 0.00390625 for 24 bit mantissa
                    T шкала=факт32;
                    while (nV==0){ // probability 2.3283064365386963e-10
                        nV=источник.следщ;
                        шкала*=факт32;
                    }
                    T рез=nV*шкала+источник.следщ*шкала*факт32;
                    static if (проверкаГраниц){
                        if (рез!=cast(T)0) return рез;
                        return униформа!(T,проверкаГраниц)(); // 0 due в_ недобор (<1.e-38), 1 impossible
                    } else {
                        return рез;
                    }
                }
            } else static if (T.mant_dig<62) {
                const T полТ=(cast(T)1)/(cast(T)2);
                const T факт64=ctfe_powI(полТ,64);
                const бдол minV=1UL<<(T.mant_dig-1);
                бдол nV=источник.следщД;
                if (nV>=minV) {
                    T рез=nV*факт64;
                    static if (проверкаГраниц){
                        if (рез!=cast(T)1) return рез;
                        // 1 due в_ rounding (<1.e-16), 0 impossible
                        return униформа!(T,проверкаГраниц)();
                    } else {
                        return рез;
                    }
                } else { // probability 0.00048828125 for 53 bit mantissa
                    const T факт32=ctfe_powI(полТ,32);
                    const бдол minV2=1UL<<(T.mant_dig-33);
                    if (nV>=minV2){
                        return ((cast(T)nV)+(cast(T)источник.следщ)*факт32)*факт64;
                    } else { // probability 1.1368683772161603e-13 for 53 bit mantissa
                        T шкала=факт64;
                        while (nV==0){
                            nV=источник.следщД;
                            шкала*=факт64;
                        }
                        T рез=шкала*((cast(T)nV)+(cast(T)источник.следщД)*факт64);
                        static if (проверкаГраниц){
                            if (рез!=cast(T)0) return рез;
                            // 0 due в_ недобор (<1.e-307)
                            return униформа!(T,проверкаГраниц)();
                        } else {
                            return рез;
                        }
                    }
                }
            } else static if (T.mant_dig<=64){
                const T полТ=(cast(T)1)/(cast(T)2);
                const T факт8=ctfe_powI(полТ,8);
                const T факт72=ctfe_powI(полТ,72);
                ббайт nB=источник.следщБ;
                if (nB!=0){
                    T рез=nB*факт8+источник.следщД*факт72;
                    static if (проверкаГраниц){
                        if (рез!=cast(T)1) return рез;
                        // 1 due в_ rounding (<1.e-16), 0 impossible
                        return униформа!(T,проверкаГраниц)();
                    } else {
                        return рез;
                    }
                } else { // probability 0.00390625
                    const T факт64=ctfe_powI(полТ,64);
                    T шкала=факт8;
                    while (nB==0){
                        nB=источник.следщБ;
                        шкала*=факт8;
                    }
                    T рез=((cast(T)nB)+(cast(T)источник.следщД)*факт64)*шкала;
                    static if (проверкаГраниц){
                        if (рез!=cast(T)0) return рез;
                        // 0 due в_ недобор (<1.e-4932), 1 impossible
                        return униформа!(T,проверкаГраниц)();
                    } else {
                        return рез;
                    }
                }
            } else {
                // (T.mant_dig > 64 биты), not so optimized, but works for any размер
                const T полТ=(cast(T)1)/(cast(T)2);
                const T факт32=ctfe_powI(полТ,32);
                бцел nL=источник.следщ;
                T fact=факт32;
                while (nL==0){
                    fact*=факт32;
                    nL=источник.следщ;
                }
                T рез=nL*fact;
                for (цел rBits=T.mant_dig-1;rBits>0;rBits-=32) {
                    fact*=факт32;
                    рез+=источник.следщ()*fact;
                }
                static if (проверкаГраниц){
                    if (рез!=cast(T)0 && рез !=cast(T)1) return рез;
                    return униформа!(T,проверкаГраниц)(); // really unlikely...
                } else {
                    return рез;
                }
            }
        } else static if (is(T==кплав)||is(T==кдво)||is(T==креал)){
            return cast(T)(униформа!(реальныйТип!(T))()+1i*униформа!(реальныйТип!(T))());
        } else static if (is(T==вплав)||is(T==вдво)||is(T==вреал)){
            return cast(T)(1i*униформа!(реальныйТип!(T))());
        } else static assert(0,T.stringof~" unsupported тип for униформа distribution");
    }
    
    /// униформа distribution on the range [0;в_) for целое типы, and on
    /// the (0;в_) range for floating point типы. Same caveat as униформа(T) apply
    T униформаР(T,бул проверкаГраниц=да)(T в_)
    in { assert(в_>0,"пустой range");}
    body {
        static if (is(T==бцел) || is(T==цел) || is(T==крат) || is(T==бкрат) 
            || is(T==сим) || is(T==байт) || is(T==ббайт))
        {
            бцел d=бцел.max/cast(бцел)в_,dTo=в_*d;
            бцел nV=источник.следщ;
            if (nV>=dTo){
                for (цел i=0;i<1000;++i) {
                    nV=источник.следщ;
                    if (nV<dTo) break;
                }
                assert(nV<dTo,"this is less probable than 1.e-301, something is wrong with the random число generator");
            }
            return cast(T)(nV%в_);
        } else static if (is(T==бдол) || is(T==дол)){
            бдол d=бдол.max/cast(бдол)в_,dTo=в_*d;
            бдол nV=источник.следщД;
            if (nV>=dTo){
                for (цел i=0;i<1000;++i) {
                    nV=источник.следщД;
                    if (nV<dTo) break;
                }
                assert(nV<dTo,"this is less probable than 1.e-301, something is wrong with the random число generator");
            }
            return cast(T)(nV%в_);
        } else static if (is(T==плав)|| is(T==дво)||is(T==реал)){
            T рез=униформа!(T,нет)*в_;
            static if (проверкаГраниц){
                if (рез!=cast(T)0 && рез!=в_) return рез;
                return униформаР(в_);
            } else {
                return рез;
            }
        } else static assert(0,T.stringof~" unsupported тип for униформаР distribution");
    }
    /// униформа distribution on the range (-в_;в_) for целое типы, and on
    /// the (-в_;0)(0;в_) range for floating point типы if проверкаГраниц is да.
    /// If проверкаГраниц=нет the range changes в_ [-в_;0)u(0;в_] with a slightly
    /// lower propability at the bounds for floating point numbers.
    /// исключитьНоль controls if 0 is excluded or not (by default плав exclude it,
    /// ints no). Please note that the probability of 0 in floats is very small due
    //  в_ the high density of floats закрой в_ 0.
    /// Cannot be used on unsigned типы.
    ///
    /// In here there is probably one of the few cases where c handling of modulo of negative
    /// numbers is handy
    T униформаРСимм(T,бул проверкаГраниц=да, бул исключитьНоль=плав_ли!(T))(T в_,цел итер=2000)
    in { assert(в_>0,"пустой range");}
    body {
        static if (is(T==цел)|| is(T==крат) || is(T==байт)){
            цел d=цел.max/в_,dTo=в_*d;
            цел nV=cast(цел)источник.следщ;
            static if (исключитьНоль){
                цел isIn=nV<dTo&&nV>-dTo&&nV!=0;
            } else {
                цел isIn=nV<dTo&&nV>-dTo;
            }
            if (isIn){
                return cast(T)(nV%в_);
            } else {
                for (цел i=0;i<1000;++i) {
                    nV=cast(цел)источник.следщ;
                    if (nV<dTo && nV>-dTo) break;
                }
                assert(nV<dTo && nV>-dTo,"this is less probable than 1.e-301, something is wrong with the random число generator");
                return cast(T)(nV%в_);
            }
        } else static if (is(T==дол)){
            дол d=дол.max/в_,dTo=в_*d;
            дол nV=cast(дол)источник.следщД;
            static if (исключитьНоль){
                цел isIn=nV<dTo&&nV>-dTo&&nV!=0;
            } else {
                цел isIn=nV<dTo&&nV>-dTo;
            }
            if (isIn){
                return nV%в_;
            } else {
                for (цел i=0;i<1000;++i) {
                    nV=источник.следщД;
                    if (nV<dTo && nV>-dTo) break;
                }
                assert(nV<dTo && nV>-dTo,"this is less probable than 1.e-301, something is wrong with the random число generator");
                return nV%в_;
            }
        } else static if (is(T==плав)||is(T==дво)||is(T==реал)){
            static if (T.mant_dig<30){
                const T полТ=(cast(T)1)/(cast(T)2);
                const T факт32=ctfe_powI(полТ,32);
                const бцел minV=1u<<T.mant_dig;
                бцел nV=источник.следщ;
                if (nV>=minV) {
                    T рез=nV*факт32*в_;
                    static if (проверкаГраниц){
                        if (рез!=в_) return (1-2*cast(цел)(nV&1u))*рез;
                        // в_ due в_ rounding (~3.e-8), 0 impossible with нормаль в_ values
                        assert(итер>0,"ошибка with the generator, probability < 10^(-8*2000)");
                        return униформаРСимм(в_,итер-1);
                    } else {
                        return (1-2*cast(цел)(nV&1u))*рез;
                    }
                } else { // probability 0.008 for 24 bit mantissa
                    T шкала=факт32;
                    while (nV==0){ // probability 2.3283064365386963e-10
                        nV=источник.следщ;
                        шкала*=факт32;
                    }
                    бцел nV2=источник.следщ;
                    T рез=(cast(T)nV+cast(T)nV2*факт32)*шкала*в_;
                    static if (исключитьНоль){
                        if (рез!=cast(T)0) return (1-2*cast(цел)(nV&1u))*рез;
                        assert(итер>0,"ошибка with the generator, probability < 10^(-8*2000)");
                        return униформаРСимм(в_,итер-1); // 0 due в_ недобор (<1.e-38), 1 impossible
                    } else {
                        return (1-2*cast(цел)(nV&1u))*рез;
                    }
                }
            } else static if (T.mant_dig<62) {
                const T полТ=(cast(T)1)/(cast(T)2);
                const T факт64=ctfe_powI(полТ,64);
                const бдол minV=1UL<<(T.mant_dig);
                бдол nV=источник.следщД;
                if (nV>=minV) {
                    T рез=nV*факт64*в_;
                    static if (проверкаГраниц){
                        if (рез!=в_) return (1-2*cast(цел)(nV&1UL))*рез;
                        // в_ due в_ rounding (<1.e-16), 0 impossible with нормаль в_ values
                        assert(итер>0,"ошибка with the generator, probability < 10^(-16*2000)");
                        return униформаРСимм(в_,итер-1);
                    } else {
                        return (1-2*cast(цел)(nV&1UL))*рез;
                    }
                } else { // probability 0.00048828125 for 53 bit mantissa
                    const T факт32=ctfe_powI(полТ,32);
                    const бдол minV2=1UL<<(T.mant_dig-32);
                    if (nV>=minV2){
                        бцел nV2=источник.следщ;
                        T рез=((cast(T)nV)+(cast(T)nV2)*факт32)*факт64*в_;
                        return (1-2*cast(цел)(nV2&1UL))*рез; // cannot be 0 or в_ with нормаль в_ values
                    } else { // probability 1.1368683772161603e-13 for 53 bit mantissa
                        T шкала=факт64;
                        while (nV==0){
                            nV=источник.следщД;
                            шкала*=факт64;
                        }
                        бдол nV2=источник.следщД;
                        T рез=в_*шкала*((cast(T)nV)+(cast(T)nV2)*факт64);
                        static if (исключитьНоль){
                            if (рез!=cast(T)0) return (1-2*cast(цел)(nV2&1UL))*рез;
                            // 0 due в_ недобор (<1.e-307)
                            assert(итер>0,"ошибка with the generator, probability < 10^(-16*2000)");
                            return униформаРСимм(в_,итер-1);
                        } else {
                            return (1-2*cast(цел)(nV2&1UL))*рез;
                        }
                    }
                }
            } else static if (T.mant_dig<=64) {
                const T полТ=(cast(T)1)/(cast(T)2);
                const T факт8=ctfe_powI(полТ,8);
                const T факт72=ctfe_powI(полТ,72);
                ббайт nB=источник.следщБ;
                if (nB!=0){
                    бдол nL=источник.следщД;
                    T рез=в_*(nB*факт8+nL*факт72);
                    static if (проверкаГраниц){
                        if (рез!=в_) return (1-2*cast(цел)(nL&1UL))*рез;
                        // 1 due в_ rounding (<1.e-16), 0 impossible with нормаль в_ values
                        assert(итер>0,"ошибка with the generator, probability < 10^(-16*2000)");
                        return униформаРСимм(в_,итер-1);
                    } else {
                        return (1-2*cast(цел)(nL&1UL))*рез;
                    }
                } else { // probability 0.00390625
                    const T факт64=ctfe_powI(полТ,64);
                    T шкала=факт8;
                    while (nB==0){
                        nB=источник.следщБ;
                        шкала*=факт8;
                    }
                    бдол nL=источник.следщД;
                    T рез=((cast(T)nB)+(cast(T)nL)*факт64)*шкала*в_;
                    static if (исключитьНоль){
                        if (рез!=cast(T)0) return ((nL&1UL)?рез:-рез);
                        // 0 due в_ недобор (<1.e-4932), 1 impossible
                        assert(итер>0,"ошибка with the generator, probability < 10^(-16*2000)");
                        return униформаРСимм(в_,итер-1);
                    } else {
                        return ((nL&1UL)?рез:-рез);
                    }
                }
            } else {
                // (T.mant_dig > 64 биты), not so optimized, but works for any размер
                const T полТ=(cast(T)1)/(cast(T)2);
                const T факт32=ctfe_powI(полТ,32);
                бцел nL=источник.следщ;
                T fact=факт32;
                while (nL==0){
                    fact*=факт32;
                    nL=источник.следщ;
                }
                T рез=nL*fact;
                for (цел rBits=T.mant_dig;rBits>0;rBits-=32) {
                    fact*=факт32;
                    nL=источник.следщ();
                    рез+=nL*fact;
                }
                static if (проверкаГраниц){
                    if (рез!=в_ && рез!=cast(T)0) return ((nL&1UL)?рез:-рез);
                    // 1 due в_ rounding (<1.e-16), 0 impossible with нормаль в_ values
                    assert(итер>0,"ошибка with the generator, probability < 10^(-16*2000)");
                    return униформаРСимм(в_,итер-1);
                } else {
                    return ((nL&1UL)?рез:-рез);
                }
            }
        } else static assert(0,T.stringof~" unsupported тип for униформаРСимм distribution");
    }
    /// униформа distribution [из_;в_) for целыйs, and (из_;в_) for floating point numbers.
    /// if проверкаГраниц is нет the bounds are included in the floating point число distribution.
    /// the range for цел and дол is limited в_ only half the possible range
    /// (it could be worked around using дол aritmethic for цел, and doing a carry by hand for дол,
    /// but I think it is seldomly needed, for цел you are better off using дол when needed)
    T униформаР2(T,бул проверкаГраниц=да)(T из_,T в_)
    in {
        assert(в_>из_,"empy range in униформаР2");
        static if (is(T==цел) || is(T==дол)){
            assert(из_>T.min/2&&в_<T.max/2," из_..в_ range too big");
        }
    }
    body {
        static if (is(T==цел)||is(T==дол)||is(T==бцел)||is(T==бдол)){
            return из_+униформаР(в_-из_);
        } else static if (is(T==сим) || is(T==байт) || is(T==ббайт) || is(T==крат) || is(T==бкрат)){
            цел d=cast(цел)в_-cast(цел)из_;
            цел nV=униформаР!(цел)(d);
            return cast(T)(nV+cast(цел)из_);
        } else static if (is(T==плав) || is(T==дво) || is(T==реал)){
            T рез=из_+(в_-из_)*униформа!(T,нет);
            static if (проверкаГраниц){
                if (рез!=из_ && рез!=в_) return рез;
                return униформаР2(из_,в_);
            } else {
                return рез;
            }
        } else static assert(0,T.stringof~" unsupported тип for униформаР2 distribution");
    }
    /// returns a random element of the given Массив (which must be non пустой)
    T униформЭлт(T)(T[] масс){
        assert(масс.length>0,"Массив есть в_ be non пустой");
        return масс[униформаР(масс.length)];
    }
    /// randomizes the given Массив and returns it (for some типы this is potentially
    /// ещё efficient, Всё из_ the use of random numbers and speedwise)
    U рандомируйУниформу(U,бул проверкаГраниц)(ref U a){
        static if (is(U S:S[])){
            alias БазТипМассивов!(U) T;
            static if (is(T==байт)||is(T==ббайт)||is(T==сим)){
                бцел знач=источник.следщ; /// begin without значение?
                цел rest=4;
                for (т_мера i=0;i<a.length;++i) {
                    if (rest!=0){
                        a[i]=cast(T)(0xFFu&знач);
                        знач>>=8;
                        --rest;
                    } else {
                        знач=источник.следщ;
                        a[i]=cast(T)(0xFFu&знач);
                        знач>>=8;
                        rest=3;
                    }
                }
            } else static if (is(T==бцел)||is(T==цел)){
                T* aEnd=a.ptr+a.length;
                for (T* aPtr=a.ptr;aPtr!=aEnd;++aPtr)
                    *aPtr=cast(T)(источник.следщ);
            } else static if (is(T==бдол)||is(T==дол)){
                T* aEnd=a.ptr+a.length;
                for (T* aPtr=a.ptr;aPtr!=aEnd;++aPtr)
                    *aPtr=cast(T)(источник.следщД);
            } else static if (is(T==плав)|| is(T==дво)|| is(T==реал)) {
                // оптимизируй ещё? not so easy with guaranteed full mantissa initialization
                T* aEnd=a.ptr+a.length;
                for (T* aPtr=a.ptr;aPtr!=aEnd;++aPtr){
                    *aPtr=униформа!(T,проверкаГраниц)();
                }
            } else static assert(T.stringof~" тип not supported by рандомируйУниформу");
        } else {
            a=униформа!(U,проверкаГраниц)();
        }
        return a;
    }
    
    /// randomizes the given Массив and returns it (for some типы this is potentially
    /// ещё efficient, Всё из_ the use of random numbers and speedwise)
    U рандомируйУниформуР(U,V,бул проверкаГраниц=да)(ref U a,V в_)
    in { assert((cast(БазТипМассивов!(U))в_)>0,"пустой range");}
    body {
        alias БазТипМассивов!(U) T;
        static assert(is(V:T),"incompatible a and в_ тип "~U.stringof~" "~V.stringof);
        static if (is(U S:S[])){
            static if (is(T==бцел) || is(T==цел) || is(T==сим) || is(T==байт) || is(T==ббайт)){
                бцел d=бцел.max/cast(бцел)в_,dTo=(cast(бцел)в_)*d;
                T* aEnd=a.ptr+a.length;
                for (T* aPtr=a.ptr;aPtr!=aEnd;++aPtr){
                    бцел nV=источник.следщ;
                    if (nV<dTo){
                        *aPtr=cast(T)(nV % cast(бцел)в_);
                    } else {
                        for (цел i=0;i<1000;++i) {
                            nV=источник.следщ;
                            if (nV<dTo) break;
                        }
                        assert(nV<dTo,"this is less probable than 1.e-301, something is wrong with the random число generator");
                        *aPtr=cast(T)(nV % cast(бцел)в_);
                    }
                }
            } else static if (is(T==бдол) || is(T==дол)){
                бдол d=бдол.max/cast(бдол)в_,dTo=(cast(бдол)в_)*d;
                T* aEnd=a.ptr+a.length;
                for (T* aPtr=a.ptr;aPtr!=aEnd;++aPtr){
                    бдол nV=источник.следщД;
                    if (nV<dTo){
                        el=cast(T)(nV % cast(бдол)в_);
                    } else {
                        for (цел i=0;i<1000;++i) {
                            nV=источник.следщД;
                            if (nV<dTo) break;
                        }
                        assert(nV<dTo,"this is less probable than 1.e-301, something is wrong with the random число generator");
                        el=cast(T)(nV% cast(бдол)в_);
                    }
                }
            } else static if (is(T==плав) || is(T==дво) || is(T==реал)){
                T* aEnd=a.ptr+a.length;
                for (T* aPtr=a.ptr;aPtr!=aEnd;++aPtr){
                    *aPtr=униформаР!(T,проверкаГраниц)(cast(T)в_);
                }
            } else static assert(0,T.stringof~" unsupported тип for униформаР distribution");
        } else {
            a=униформаР!(T,проверкаГраниц)(cast(T)в_);
        }
        return a;
    }
    /// randomizes the given переменная and returns it (for some типы this is potentially
    /// ещё efficient, Всё из_ the use of random numbers and speedwise)
    U рандомируйУниформуР2(U,V,W,бул проверкаГраниц=да)(ref U a,V из_, W в_)
    in {
        alias БазТипМассивов!(U) T;
        assert((cast(T)в_)>(cast(T)из_),"empy range in униформаР2");
        static if (is(T==цел) || is(T==дол)){
            assert(из_>T.min/2&&в_<T.max/2," из_..в_ range too big");
        }
    }
    body {
        alias БазТипМассивов!(U) T;
        static assert(is(V:T),"incompatible a and из_ тип "~U.stringof~" "~V.stringof);
        static assert(is(W:T),"incompatible a and в_ тип "~U.stringof~" "~W.stringof);
        static if (is(U S:S[])){
            static if (is(T==бцел)||is(T==бдол)){
                T d=cast(T)в_-cast(T)из_;
                T* aEnd=a.ptr+a.length;
                for (T* aPtr=a.ptr;aPtr!=aEnd;++aPtr){
                    *aPtr=из_+униформаР!(d)();
                }
            } else if (is(T==сим) || is(T==байт) || is(T==ббайт)){
                цел d=cast(цел)в_-cast(цел)из_;
                T* aEnd=a.ptr+a.length;
                for (T* aPtr=a.ptr;aPtr!=aEnd;++aPtr){
                    *aPtr=cast(T)(униформаР!(d)+cast(цел)из_);
                }
            } else static if (is(T==плав) || is(T==дво) || is(T==реал)){
                T* aEnd=a.ptr+a.length;
                for (T* aPtr=a.ptr;aPtr!=aEnd;++aPtr){
                    T рез=cast(T)из_+(cast(T)в_-cast(T)из_)*униформа!(T,нет);
                    static if (проверкаГраниц){
                        if (рез!=cast(T)из_ && рез!=cast(T)в_){
                            *aPtr=рез;
                        } else {
                            *aPtr=униформаР2!(T,проверкаГраниц)(cast(T)из_,cast(T)в_);
                        }
                    } else {
                        *aPtr=рез;
                    }
                }
            } else static assert(0,T.stringof~" unsupported тип for униформаР2 distribution");
        } else {
            a=униформаР2!(T,проверкаГраниц)(из_,в_);
        }
        return a;
    }
    /// randomizes the given переменная like униформаРСимм and returns it
    /// (for some типы this is potentially ещё efficient, Всё из_ the use of
    /// random numbers and speedwise)
    U рандомируйУниформуРСимм(U,V,бул проверкаГраниц=да, бул исключитьНоль=плав_ли!(БазТипМассивов!(U)))
        (ref U a,V в_)
    in { assert((cast(БазТипМассивов!(U))в_)>0,"пустой range");}
    body {
        alias БазТипМассивов!(U) T;
        static assert(is(V:T),"incompatible a and в_ тип "~U.stringof~" "~V.stringof);
        static if (is(U S:S[])){
            static if (is(T==цел)|| is(T==байт)){
                цел d=цел.max/cast(цел)в_,dTo=(cast(цел)в_)*d;
                T* aEnd=a.ptr+a.length;
                for (T* aPtr=a.ptr;aPtr!=aEnd;++aPtr){
                    цел nV=cast(цел)источник.следщ;
                    static if (исключитьНоль){
                        цел isIn=nV<dTo&&nV>-dTo&&nV!=0;
                    } else {
                        цел isIn=nV<dTo&&nV>-dTo;
                    }
                    if (isIn){
                        *aPtr=cast(T)(nV% cast(цел)в_);
                    } else {
                        for (цел i=0;i<1000;++i) {
                            nV=cast(цел)источник.следщ;
                            if (nV<dTo&&nV>-dTo) break;
                        }
                        assert(nV<dTo && nV>-dTo,"this is less probable than 1.e-301, something is wrong with the random число generator");
                        *aPtr=cast(T)(nV% cast(цел)в_);
                    }
                }
            } else static if (is(T==дол)){
                дол d=дол.max/cast(T)в_,dTo=(cast(T)в_)*d;
                дол nV=cast(дол)источник.следщД;
                T* aEnd=a.ptr+a.length;
                for (T* aPtr=a.ptr;aPtr!=aEnd;++aPtr){
                    static if (исключитьНоль){
                        цел isIn=nV<dTo&&nV>-dTo&&nV!=0;
                    } else {
                        цел isIn=nV<dTo&&nV>-dTo;
                    }
                    if (isIn){
                        *aPtr=nV% cast(T)в_;
                    } else {
                        for (цел i=0;i<1000;++i) {
                            nV=источник.следщД;
                            if (nV<dTo && nV>-dTo) break;
                        }
                        assert(nV<dTo && nV>-dTo,"this is less probable than 1.e-301, something is wrong with the random число generator");
                        *aPtr=nV% cast(T)в_;
                    }
                }
            } else static if (is(T==плав)||is(T==дво)||is(T==реал)){
                T* aEnd=a.ptr+a.length;
                for (T* aPtr=a.ptr;aPtr!=aEnd;++aPtr){
                    *aPtr=униформаРСимм!(T,проверкаГраниц,исключитьНоль)(cast(T)в_);
                }
            } else static assert(0,T.stringof~" unsupported тип for униформаРСимм distribution");
        } else {
            a=униформаРСимм!(T,проверкаГраниц,исключитьНоль)(cast(T)в_);
        }
        return a;
    }
    
    /// returns другой (mostly indИПendent, depending on сей размер) random generator
    СлучГ spawn(СлучГ=СлуччисГ)(){
        СлучГ рез=new СлучГ(нет);
        synchronized(this){
            рез.сей(&униформа!(бцел));
        }
        return рез;
    }
    
    // ------- structs for униформа distributions -----
    /// униформа distribution on the whole range for целыйs, and on (0;1) for floats
    /// with проверкаГраниц=да this is equivalent в_ r itself, here just for completness
    struct УниформнаяДистрибуция(T,бул проверкаГраниц){
        СлуччисГ r;
        static УниформнаяДистрибуция создай(СлуччисГ r){
            УниформнаяДистрибуция рез;
            рез.r=r;
            return рез;
        }
        /// chainable вызов стиль initialization of variables (thorugh a вызов в_ рандомируй)
        УниформнаяДистрибуция opCall(U,S...)(ref U a,S арги){
            рандомируй(a,арги);
            return *this;
        }
        /// returns a random число
        T дайСлучайный(){
            return r.униформа!(T,проверкаГраниц)();
        }
        /// инициализуй el
        U рандомируй(U)(ref U a){
            return r.рандомируйУниформу!(U,проверкаГраниц)(a);
        }    
    }

    /// униформа distribution on the subrange [0;в_) for целыйs, (0;в_) for floats
    struct УниформнаяРДистрибуция(T,бул проверкаГраниц){
        T в_;
        СлуччисГ r;
        /// initializes the probability distribution
        static УниформнаяРДистрибуция создай(СлуччисГ r,T в_){
            УниформнаяРДистрибуция рез;
            рез.r=r;
            рез.в_=в_;
            return рез;
        }
        /// chainable вызов стиль initialization of variables (thorugh a вызов в_ рандомируй)
        УниформнаяРДистрибуция opCall(U)(ref U a){
            рандомируй(a);
            return *this;
        }
        /// returns a random число
        T дайСлучайный(){
            return r.униформаР!(T,проверкаГраниц)(в_);
        }
        /// инициализуй el
        U рандомируй(U)(ref U a){
            return r.рандомируйУниформуР!(U,T,проверкаГраниц)(a,в_);
        }
    }

    /// униформа distribution on the subrange (-в_;в_) for целыйs, (-в_;0)u(0;в_) for floats
    /// исключитьНоль controls if the zero should be excluded, проверкаГраниц if the boundary should
    /// be excluded for floats
    struct УниформнаяРСиммДистрибуция(T,бул проверкаГраниц=да,бул исключитьНоль=плав_ли!(T)){
        T в_;
        СлуччисГ r;
        /// initializes the probability distribution
        static УниформнаяРСиммДистрибуция создай(СлуччисГ r,T в_){
            УниформнаяРСиммДистрибуция рез;
            рез.r=r;
            рез.в_=в_;
            return рез;
        }
        /// chainable вызов стиль initialization of variables (thorugh a вызов в_ рандомируй)
        УниформнаяРСиммДистрибуция opCall(U)(ref U a){
            рандомируй(a);
            return *this;
        }
        /// returns a random число
        T дайСлучайный(){
            return r.униформаРСимм!(T,проверкаГраниц,исключитьНоль)(в_);
        }
        /// инициализуй el
        U рандомируй(U)(ref U a){
            return r.рандомируйУниформуРСимм!(U,T,проверкаГраниц)(a,в_);
        }
    }

    /// униформа distribution on the subrange (-в_;в_) for целыйs, (0;в_) for floats
    struct УниформнаяР2Дистрибуция(T,бул проверкаГраниц){
        T из_,в_;
        СлуччисГ r;
        /// initializes the probability distribution
        static УниформнаяРДистрибуция создай(СлуччисГ r,T из_, T в_){
            УниформнаяРДистрибуция рез;
            рез.r=r;
            рез.из_=из_;
            рез.в_=в_;
            return рез;
        }
        /// chainable вызов стиль initialization of variables (thorugh a вызов в_ рандомируй)
        УниформнаяРДистрибуция opCall(U,S...)(ref U a,S арги){
            рандомируй(a,арги);
            return *this;
        }
        /// returns a random число
        T дайСлучайный(){
            return r.униформаР2!(T,проверкаГраниц)(из_,в_);
        }
        /// инициализуй a
        U рандомируй(ref U a){
            return r.рандомируйУниформуР2!(U,T,T,проверкаГраниц)(a,из_,в_);
        }
    }

    // ---------- gamma distribution, перемести в_ a separate module? --------
    /// gamma distribution f=x^(альфа-1)*эксп(-x/тэта)/(gamma(альфа)*тэта^альфа)
    /// альфа есть в_ be bigger than 1, for альфа<1 use гаммаД(альфа)=гаммаД(альфа+1)*степ(r.униформа!(T),1/альфа)
    /// из_ Marsaglia and Tsang, ACM Transaction on Mathematical Software, Vol. 26, N. 3
    /// 2000, p 363-372
    struct ГаммаДистрибуция(T){
        СлуччисГ r;
        T альфа;
        T тэта;
        static ГаммаДистрибуция создай(СлуччисГ r,T альфа=cast(T)1,T тэта=cast(T)1){
            ГаммаДистрибуция рез;
            рез.r=r;
            рез.альфа=альфа;
            рез.тэта=тэта;
            assert(альфа>=cast(T)1,"implemented only for альфа>=1");
            return рез;
        }
        /// chainable вызов стиль initialization of variables (thorugh a вызов в_ рандомируй)
        ГаммаДистрибуция opCall(U,S...)(ref U a,S арги){
            рандомируй(a,арги);
            return *this;
        }
        /// returns a single random число
        T дайСлучайный(T a=альфа,T t=тэта)
        in { assert(a>=cast(T)1,"implemented only for альфа>=1"); }
        body {
            T d=a-(cast(T)1)/(cast(T)3);
            T c=(cast(T)1)/квкор(d*cast(T)9);
            auto n=r.нормальныйИсточник!(T)();
            for (;;) {
                do {
                    T x=n.дайСлучайный();
                    T v=c*x+cast(T)1;
                    v=v*v*v; // might недобор (in extreme situations) so it is in the loop
                } while (v<=0)
                T u=r.униформа!(T)();
                if (u<1-(cast(T)0.331)*(x*x)*(x*x)) return t*d*v;
                if (лог(u)< x*x/2+d*(1-v+лог(v))) return t*d*v;
            }
        }
        /// initializes b with gamma distribued random numbers
        U рандомируй(U)(ref U b,T a=альфа,T t=тэта){
            static if (is(U S:S[])) {
                alias БазТипМассивов!(U) T;
                T* bEnd=b.ptr+b.length;
                for (T* bPtr=b.ptr;bPtr!=bEnd;++bPtr){
                    *bPtr=cast(БазТипМассивов!(U)) дайСлучайный(a,t);
                }
            } else {
                b=cast(U) дайСлучайный(a,t);
            }
            return b;
        }
        /// maps op on random numbers (of тип T) and initializes b with it
        U рандомирОп(U,S)(S delegate(T)op, ref U b,T a=альфа, T t=тэта){
            static if(is(U S:S[])){
                alias БазТипМассивов!(U) T;
                T* bEnd=b.ptr+b.length;
                for (T* bPtr=b.ptr;bPtr!=bEnd;++bPtr){
                    *bPtr=cast(БазТипМассивов!(U))op(дайСлучайный(a,t));
                }
            } else {
                b=cast(U)op(дайСлучайный(a));
            }
            return b;
        }
    }
    
    //-------- various distributions available -----------
    
    /// generators of нормаль numbers (сигма=1,мю=0) of the given тип
    /// f=эксп(-x*x/(2*сигма^2))/(квкор(2 pi)*сигма)
    НормальныйИсточник!(СлуччисГ,T) нормальныйИсточник(T)(){
        static if(is(T==плав)){
            if (!нормалПлав) нормалПлав=new НормальныйИсточник!(СлуччисГ,T)(this);
            return нормалПлав;
        } else static if (is(T==дво)){
            if (!нормалДво) нормалДво=new НормальныйИсточник!(СлуччисГ,T)(this);
            return нормалДво;
        } else static if (is(T==реал)){
            if (!нормалРеал) нормалРеал=new НормальныйИсточник!(СлуччисГ,T)(this);
            return нормалРеал;
        } else static assert(0,T.stringof~" no нормаль источник implemented");
    }

    /// generators of эксп distribued numbers (beta=1) of the given тип
    /// f=1/beta*эксп(-x/beta)
    ЭкспИсточник!(СлуччисГ,T) экспИсточник(T)(){
        static if(is(T==плав)){
            if (!экспПлав) экспПлав=new ЭкспИсточник!(СлуччисГ,T)(this);
            return экспПлав;
        } else static if (is(T==дво)){
            if (!экспДво) экспДво=new ЭкспИсточник!(СлуччисГ,T)(this);
            return экспДво;
        } else static if (is(T==реал)){
            if (!экспРеал) экспРеал=new ЭкспИсточник!(СлуччисГ,T)(this);
            return экспРеал;
        } else static assert(0,T.stringof~" no эксп источник implemented");
    }
    
    /// generators of нормаль numbers with a different default сигма/мю
    /// f=эксп(-x*x/(2*сигма^2))/(квкор(2 pi)*сигма)
    НормальныйИсточник!(СлуччисГ,T).НормальнаяДистрибуция нормальД(T)(T сигма=cast(T)1,T мю=cast(T)0){
        return нормальныйИсточник!(T).нормальД(сигма,мю);
    }
    /// exponential distribued numbers with a different default beta
    /// f=1/beta*эксп(-x/beta)
    ЭкспИсточник!(СлуччисГ,T).ЭкспДистрибуция экспД(T)(T beta){
        return экспИсточник!(T).экспД(beta);
    }
    /// gamma distribued numbers with the given default альфа
    ГаммаДистрибуция!(T) гаммаД(T)(T альфа=cast(T)1,T тэта=cast(T)1){
        return ГаммаДистрибуция!(T).создай(this,альфа,тэта);
    }

    /// униформа distribution on the whole целое range, and on (0;1) for floats
    /// should return simply this??
    УниформнаяДистрибуция!(T,да) униформаД(T)(){
        return УниформнаяДистрибуция!(T,да).создай(this);
    }
    /// униформа distribution on the whole целое range, and on [0;1] for floats
    УниформнаяДистрибуция!(T,нет) униформаГраницыД(T)(){
        return УниформнаяДистрибуция!(T,нет).создай(this);
    }
    /// униформа distribution [0;в_) for ints, (0:в_) for reals
    УниформнаяРДистрибуция!(T,да) униформаРД(T)(T в_){
        return УниформнаяРДистрибуция!(T,да).создай(this,в_);
    }
    /// униформа distribution [0;в_) for ints, [0:в_] for reals
    УниформнаяРДистрибуция!(T,нет) униформаРГраницыД(T)(T в_){
        return УниформнаяРДистрибуция!(T,нет).создай(this,в_);
    }
    /// униформа distribution (-в_;в_) for ints and (-в_;0)u(0;в_) for reals
    УниформнаяРСиммДистрибуция!(T,да,плав_ли!(T)) униформаРСиммД(T)(T в_){
        return УниформнаяРСиммДистрибуция!(T,да,плав_ли!(T)).создай(this,в_);
    }
    /// униформа distribution (-в_;в_) for ints and [-в_;0)u(0;в_] for reals
    УниформнаяРСиммДистрибуция!(T,нет,плав_ли!(T)) униформаРСиммГраницыД(T)(T в_){
        return УниформнаяРСиммДистрибуция!(T,нет,плав_ли!(T)).создай(this,в_);
    }
    /// униформа distribution [из_;в_) fro ints and (из_;в_) for reals
    УниформнаяР2Дистрибуция!(T,да) униформаР2Д(T)(T из_, T в_){
        return УниформнаяР2Дистрибуция!(T,да).создай(this,из_,в_);
    }
    /// униформа distribution [из_;в_) for ints and [из_;в_] for reals
    УниформнаяР2Дистрибуция!(T,нет) униформаР2ГраницыД(T)(T из_, T в_){
        return УниформнаяР2Дистрибуция!(T,нет).создай(this,из_,в_);
    }
    
    // -------- Utility functions for другой distributions -------
    // добавь also the corresponding рандомируй functions?
    
    /// returns a нормаль distribued число
    T нормаль(T)(){
        return нормальныйИсточник!(T).дайСлучайный();
    }
    /// returns a нормаль distribued число with the given сигма
    T нормальСигма(T)(T сигма){
        return нормальныйИсточник!(T).дайСлучайный(сигма);
    }
    /// returns a нормаль distribued число with the given сигма and мю
    T нормальСигмаМю(T)(T сигма,T мю){
        return нормальныйИсточник!(T).дайСлучайный(сигма,мю);
    }
    
    /// returns an эксп distribued число
    T эксп(T)(){
        return экспИсточник!(T).дайСлучайный();
    }
    /// returns an эксп distribued число with the given шкала beta
    T экспБета(T)(T beta){
        return экспИсточник!(T).дайСлучайный(beta);
    }
        
    /// returns a gamma distribued число
    /// из_ Marsaglia and Tsang, ACM Transaction on Mathematical Software, Vol. 26, N. 3
    /// 2000, p 363-372
    T gamma(T)(T альфа=cast(T)1,T сигма=cast(T)1)
    in { assert(альфа>=cast(T)1,"implemented only for альфа>=1"); }
    body {
        auto n=нормальныйИсточник!(T);
        T d=альфа-(cast(T)1)/(cast(T)3);
        T c=(cast(T)1)/квкор(d*cast(T)9);
        for (;;) {
            T x,v;
            do {
                x=n.дайСлучайный();
                v=c*x+cast(T)1;
                v=v*v*v; // might недобор (in extreme situations) so it is in the loop
            } while (v<=0)
            T u=униформа!(T)();
            if (u<1-(cast(T)0.331)*(x*x)*(x*x)) return сигма*d*v;
            if (лог(u)< x*x/2+d*(1-v+лог(v))) return сигма*d*v;
        }
    }
    // ---------------
    
    /// writes the current статус in a ткст
    ткст вТкст(){
        return источник.вТкст();
    }
    /// reads the current статус из_ a ткст (его следует обработать)
    /// возвращает число считанных символов
    т_мера fromString(ткст s){
        return источник.fromString(s);
    }
    
    // сделай this by default a uniformRandom число generator
    /// chainable вызов стиль initialization of variables (thorugh a вызов в_ рандомируй)
    СлуччисГ opCall(U)(ref U a){
        рандомируй(a);
        return this;
    }
    /// returns a random число
    T дайСлучайный(T)(){
        return униформа!(T,да)();
    }
    /// инициализуй el
    U рандомируй(U)(ref U a){
        return рандомируйУниформу!(U,да)(a);
    }
    
} // конец class СлуччисГ

/// сделай the default random число generator тип
/// (a non threadsafe random число generator) easily available
/// you can safely expect a new экземпляр of this в_ be indИПendent из_ все the другие
alias СлуччисГ!() Случай;
/// default threadsafe random число generator тип
alias СлуччисГ!(Sync!(ДефолтныйДвижок)) СлучгенСинх;

/// shared locked (threadsafe) random число generator
/// инициализован with urandom if available, with время otherwise
static СлучгенСинх случ;
static this ()
{
    случ = new СлучгенСинх(нет);
    version(has_urandom){
        URandom r;
        случ.сей(&r.следщ);
    } else {
        бдол s;
        version (Posix){
            значврем tv;
            gettimeofday (&tv, пусто);
            s = tv.микросек;
        } else version (Win32) {
             QueryPerformanceCounter (&s);
         }
        бцел[2] a;
        a[0]= cast(бцел)(s & 0xFFFF_FFFFUL);
        a[1]= cast(бцел)(s>>32);
        случ.сей(&(МассИсток(a).следщ));
    }
}

debug(UnitTest){
    import math.random.engines.KISS;
    import math.random.engines.CMWC;
    import rt.core.stdc.stdio:printf;
    import io.Stdout;

    /// very simple statistal тест, mean within maxOffset, and maximum/minimum at least minmax/maxmin
    бул checkMean(T)(T[] a, реал maxmin, реал minmax, реал expectedMean, реал maxOffset,бул alwaysPrint=нет,бул checkB=нет){
        T minV,maxV;
        реал meanV=0.0L;
        if (a.length>0){
            minV=a[0];
            maxV=a[0];
            foreach (el;a){
                assert(!checkB || (cast(T)0<el && el<cast(T)1),"el out of bounds");
                if (el<minV) minV=el;
                if (el>maxV) maxV=el;
                meanV+=cast(реал)el;
            }
            meanV/=cast(реал)a.length;
            бул printM=нет;
            if (cast(реал)minV>maxmin) printM=да;
            if (cast(реал)maxV<minmax) printM=да;
            if (expectedMean-maxOffset>meanV || meanV>expectedMean+maxOffset) printM=да;
            if (printM){
                version (GNU){
                    printf("WARNING math.Random statistic is strange: %.*s[%d] %Lg %Lg %Lg\n\0",cast(цел)T.stringof.length,T.stringof.ptr,a.length,cast(реал)minV,meanV,cast(реал)maxV);
                } else {
                    printf("WARNING math.Random statistic is strange: %.*s[%d] %Lg %Lg %Lg\n\0",cast(цел)T.stringof.length,T.stringof.ptr,a.length,cast(реал)minV,meanV,cast(реал)maxV);
                }
            } else if (alwaysPrint) {
                version (GNU){
                    printf("math.Random statistic: %.*s[%d] %Lg %Lg %Lg\n\0",cast(цел)T.stringof.length,T.stringof.ptr,a.length,cast(реал)minV,meanV,cast(реал)maxV);
                } else {
                    printf("math.Random statistic: %.*s[%d] %Lg %Lg %Lg\n\0",cast(цел)T.stringof.length,T.stringof.ptr,a.length,cast(реал)minV,meanV,cast(реал)maxV);
                }
            }
            return printM;
        }
    }
    
    /// check a given generator Всё on the whole Массив, and on each element separately
    бул doTests(СлучГ,Arrays...)(СлучГ r,реал maxmin, реал minmax, реал expectedMean, реал maxOffset,бул alwaysPrint,бул checkB, Arrays arrs){
        бул gFail=нет;
        foreach (i,TA;Arrays){
            alias БазТипМассивов!(TA) T;
            // все together
            r(arrs[i]);
            бул краш=checkMean!(T)(arrs[i],maxmin,minmax,expectedMean,maxOffset,alwaysPrint,checkB);
            // one by one
            foreach (ref el;arrs[i]){
                r(el);
            }
            краш |= checkMean!(T)(arrs[i],maxmin,minmax,expectedMean,maxOffset,alwaysPrint,checkB);
            gFail |= краш;
        }
        return gFail;
    }
    
    проц testRandSource(RandS)(){
        auto r=new СлуччисГ!(RandS)();
        // r.fromString("KISS99_b66dda10_49340130_8f3bf553_224b7afa_00000000_00000000"); // в_ reproduce a given тест...
        ткст initialState=r.вТкст(); // so that you can reproduce things...
        бул allStats=нет; // установи this в_ да в_ show все statistics (helpful в_ track an ошибка)
        try{
            r.униформа!(бцел);
            r.униформа!(ббайт);
            r.униформа!(бдол);
            цел счёт=10_000;
            for (цел i=счёт;i!=0;--i){
                плав f=r.униформа!(плав);
                assert(0<f && f<1,"плав out of bounds");
                дво d=r.униформа!(дво);
                assert(0<d && d<1,"дво out of bounds");
                реал rr=r.униформа!(реал);
                assert(0<rr && rr<1,"дво out of bounds");
            }
            // checkpoint статус (ткт)
            ткст статус=r.вТкст();
            бцел tVal=r.униформа!(бцел);
            ббайт t2Val=r.униформа!(ббайт);
            бдол t3Val=r.униформа!(бдол);

            байт[1000]  barr;
            ббайт[1000] ubarr;
            бцел[1000]  uiarr;
            цел[1000]   iarr;
            плав[1000] farr;
            дво[1000]darr;
            реал[1000]  rarr;
            байт[]  barr2=barr[];
            ббайт[] ubarr2=ubarr[];
            бцел[]  uiarr2=uiarr[];
            цел[]   iarr2=iarr[];
            плав[] farr2=farr[];
            дво[]darr2=darr[];
            реал[]  rarr2=rarr[];
            
            бул краш=нет,gFail=нет;
            if (allStats) Стдвыв("Uniform").нс;
            краш =doTests(r,-100.0L,100.0L,0.0L,20.0L,allStats,нет,barr2);
            краш|=doTests(r,100.0L,155.0L,127.5L,20.0L,allStats,нет,ubarr2);
            краш|=doTests(r,0.25L*cast(реал)(бцел.max),0.75L*cast(реал)бцел.max,
                0.5L*бцел.max,0.2L*бцел.max,allStats,нет,uiarr2);
            краш|=doTests(r,0.5L*cast(реал)цел.min,0.5L*cast(реал)цел.max,
                0.0L,0.2L*бцел.max,allStats,нет,iarr2);
            краш|=doTests(r,0.2L,0.8L,0.5L,0.2L,allStats,да,farr2,darr2,rarr2);
            gFail|=краш;
            if (краш) Стдвыв("... with Uniform distribution");

            if (allStats) Стдвыв("UniformD").нс;
            краш =doTests(r.униформаД!(цел)(),-100.0L,100.0L,0.0L,20.0L,allStats,нет,barr2);
            краш|=doTests(r.униформаД!(цел)(),100.0L,155.0L,127.5L,20.0L,allStats,нет,ubarr2);
            краш|=doTests(r.униформаД!(цел)(),0.25L*cast(реал)(бцел.max),0.75L*cast(реал)бцел.max,
                0.5L*бцел.max,0.2L*бцел.max,allStats,нет,uiarr2);
            краш|=doTests(r.униформаД!(реал)(),0.5L*cast(реал)цел.min,0.5L*cast(реал)цел.max,
                0.0L,0.2L*бцел.max,allStats,нет,iarr2);
            краш|=doTests(r.униформаД!(реал)(),0.2L,0.8L,0.5L,0.2L,allStats,да,farr2,darr2,rarr2);
            gFail|=краш;
            if (краш) Стдвыв("... with UniformD distribution");

            if (allStats) Стдвыв("UniformBoundsD").нс;
            краш =doTests(r.униформаГраницыД!(цел)(),-100.0L,100.0L,0.0L,20.0L,allStats,нет,barr2);
            краш|=doTests(r.униформаГраницыД!(цел)(),100.0L,155.0L,127.5L,20.0L,allStats,нет,ubarr2);
            краш|=doTests(r.униформаГраницыД!(цел)(),0.25L*cast(реал)(бцел.max),0.75L*cast(реал)бцел.max,
                0.5L*бцел.max,0.2L*бцел.max,allStats,нет,uiarr2);
            краш|=doTests(r.униформаГраницыД!(цел)(),0.5L*cast(реал)цел.min,0.5L*cast(реал)цел.max,
                0.0L,0.2L*бцел.max,allStats,нет,iarr2);
            краш|=doTests(r.униформаГраницыД!(цел)(),0.2L,0.8L,0.5L,0.2L,allStats,нет,farr2,darr2,rarr2);
            gFail|=краш;
            if (краш) Стдвыв("... with UniformBoundsD distribution");

            if (allStats) Стдвыв("UniformRD").нс;
            краш =doTests(r.униформаРД(cast(байт)101),25.0L,75.0L,50.0L,15.0L,allStats,нет,barr2);
            краш|=doTests(r.униформаРД(cast(ббайт)201),50.0L,150.0L,100.0L,20.0L,allStats,нет,ubarr2);
            краш|=doTests(r.униформаРД(1001u),250.0L,750.0L,500.0L,100.0L,allStats,нет,uiarr2);
            краш|=doTests(r.униформаРД(1001 ),250.0L,750.0L,500.0L,100.0L,allStats,нет,iarr2);
            краш|=doTests(r.униформаРД(1000.0L),250.0L,750.0L,500.0L,100.0L,
                allStats,нет,farr2,darr2,rarr2);
            краш|=doTests(r.униформаРД(1.0L),0.2L,0.8L,0.5L,0.2L,allStats,да,farr2,darr2,rarr2);
            gFail|=краш;
            if (краш) Стдвыв("... with униформаРД distribution");
        
            if (allStats) Стдвыв("UniformRBoundsD").нс;
            краш =doTests(r.униформаРГраницыД(cast(байт)101),25.0L,75.0L,50.0L,15.0L,allStats,нет,barr2);
            краш|=doTests(r.униформаРГраницыД(cast(ббайт)201),50.0L,150.0L,100.0L,20.0L,allStats,нет,ubarr2);
            краш|=doTests(r.униформаРГраницыД(1001u),250.0L,750.0L,500.0L,100.0L,allStats,нет,uiarr2);
            краш|=doTests(r.униформаРГраницыД(1001 ),250.0L,750.0L,500.0L,100.0L,allStats,нет,iarr2);
            краш|=doTests(r.униформаРГраницыД(1000.0L),250.0L,750.0L,500.0L,100.0L,
                allStats,нет,farr2,darr2,rarr2);
            gFail|=краш;
            if (краш) Стдвыв("... with униформаРГраницыД distribution");
        
            if (allStats) Стдвыв("Rsymm").нс;
            краш =doTests(r.униформаРСиммД!(байт)(cast(байт)100),
                -40.0L,40.0L,0.0L,30.0L,allStats,нет,barr2);
            краш|=doTests(r.униформаРСиммД!(цел)(1000),
                -300.0L,300.0L,0.0L,200.0L,allStats,нет,iarr2);
            краш|=doTests(r.униформаРСиммД!(реал)(1.0L),
                -0.3L,0.3L,0.0L,0.3L,allStats,нет,farr2,darr2,rarr2);
            gFail|=краш;
            if (краш) Стдвыв("... with Rsymm distribution");

            if (allStats) Стдвыв("RsymmBounds").нс;
            краш =doTests(r.униформаРСиммГраницыД!(байт)(cast(байт)100),
                -40.0L,40.0L,0.0L,30.0L,allStats,нет,barr2);
            краш|=doTests(r.униформаРСиммГраницыД!(цел)(1000),
                -300.0L,300.0L,0.0L,200.0L,allStats,нет,iarr2);
            краш|=doTests(r.униформаРСиммГраницыД!(реал)(1.0L),
                -0.3L,0.3L,0.0L,0.3L,allStats,нет,farr2,darr2,rarr2);
            gFail|=краш;
            if (краш) Стдвыв("... with RsymmBounds distribution");
        
            if (allStats) Стдвыв("Norm").нс;
            краш =doTests(r.нормальныйИсточник!(плав)(),-0.5L,0.5L,0.0L,1.0L,
                allStats,нет,farr2,darr2,rarr2);
            краш|=doTests(r.нормальныйИсточник!(дво)(),-0.5L,0.5L,0.0L,1.0L,
                allStats,нет,farr2,darr2,rarr2);
            краш|=doTests(r.нормальныйИсточник!(реал)(),-0.5L,0.5L,0.0L,1.0L,
                allStats,нет,farr2,darr2,rarr2);
            краш|=doTests(r.нормальД!(реал)(0.5L,5.0L),4.5L,5.5L,5.0L,0.5L,
                allStats,нет,farr2,darr2,rarr2);
            gFail|=краш;
            if (краш) Стдвыв("... with Нормальный distribution");
        
            if (allStats) Стдвыв("Exp").нс;
            краш =doTests(r.экспИсточник!(плав)(),0.8L,2.0L,1.0L,1.0L,
                allStats,нет,farr2,darr2,rarr2);
            краш|=doTests(r.экспИсточник!(дво)(),0.8L,2.0L,1.0L,1.0L,
                allStats,нет,farr2,darr2,rarr2);
            краш|=doTests(r.экспИсточник!(реал)(),0.8L,2.0L,1.0L,1.0L,
                allStats,нет,farr2,darr2,rarr2);
            краш|=doTests(r.экспД!(реал)(5.0L),1.0L,7.0L,5.0L,1.0L,
                allStats,нет,farr2,darr2,rarr2);
            gFail|=краш;
            if (краш) Стдвыв("... with Exp distribution");
        
            r.fromString(статус);
            assert(r.униформа!(бцел)==tVal,"restoring of статус из_ ткт неудачно");
            assert(r.униформа!(ббайт)==t2Val,"restoring of статус из_ ткт неудачно");
            assert(r.униформа!(бдол)==t3Val,"restoring of статус из_ ткт неудачно");
            assert(!gFail,"Случай.d failure");
        } catch(Исключение e) {
            Стдвыв(initialState).нс;
            throw e;
        }
    }

    unittest {
        testRandSource!(Kiss99)();
        testRandSource!(CMWC_default)();
        testRandSource!(KissCmwc_default)();
        testRandSource!(Твистер)();
        testRandSource!(ДефолтныйДвижок)();
        testRandSource!(Sync!(ДефолтныйДвижок))();
    }

}
