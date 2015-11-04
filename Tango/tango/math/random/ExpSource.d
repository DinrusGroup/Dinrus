/*******************************************************************************
        copyright:      Copyright (c) 2008. Fawzi Mohamed
        license:        BSD стиль: $(LICENSE)
        version:        Initial release: July 2008
        author:         Fawzi Mohamed
*******************************************************************************/
module math.random.ExpSource;
private import Целое = text.convert.Integer;
import math.Math:эксп,лог;
import math.random.Ziggurat;
import core.Traits:типРеал_ли;

/// class that returns exponential distributed numbers (f=эксп(-x) for x>0, 0 otherwise)
final class ЭкспИсточник(СлучГ,T){
    static assert(типРеал_ли!(T),T.stringof~" not acceptable, only floating point variables supported");
    /// probability distribution
    static реал плотностьВерФ(реал x){ return эксп(-x); }
    /// inverse probability distribution
    static реал инвПлотностьВерФ(реал x){ return -лог(x); }
    /// complement of the cumulative density distribution (integral x..infinity плотностьВерФ)
    static реал кумПлотностьВерФКомпл(реал x){ return эксп(-x); }
    /// хвост for exponential distribution
    static T хвостГенератор(СлучГ r, T dMin) 
    { 
        return dMin-лог(r.униформа!(T));
    }
    alias Циггурат!(СлучГ,T,плотностьВерФ,хвостГенератор,нет) ТИсток;
    /// internal источник of эксп distribued numbers
    ТИсток источник;
    /// initializes the probability distribution
    this(СлучГ r){
        источник=ТИсток.создай!(инвПлотностьВерФ,кумПлотностьВерФКомпл)(r,0xf.64ec94bf5dc14bcp-1L);
    }
    /// chainable вызов стиль initialization of variables (thorugh a вызов в_ рандомируй)
    ЭкспИсточник opCall(U,S...)(ref U a,S арги){
        рандомируй(a,арги);
        return this;
    }
    /// returns a эксп distribued число
    T дайСлучайный(){
        return источник.дайСлучайный();
    }
    /// returns a эксп distribued число with the given beta (survival rate, average)
    /// f=1/beta*эксп(-x/beta)
    T дайСлучайный(T beta){
        return beta*источник.дайСлучайный();
    }
    /// initializes the given переменная with an exponentially distribued число
    U рандомируй(U)(ref U x){
        return источник.рандомируй(x);
    }
    /// initializes the given переменная with an exponentially distribued число with
    /// шкала parameter beta
    U рандомируй(U,V)(ref U x,V beta){
        return источник.рандомирОп((T el){ return el*cast(T)beta; },x);
    }
    /// initializes the given переменная with an exponentially distribued число and maps op on it
    U рандомирОп(U,S)(S delegate(T)op,ref U a){
        return источник.рандомирОп(op,a);
    }
    /// эксп distribution with different default шкала parameter beta
    /// f=1/beta*эксп(-x/beta) for x>0, 0 otherwise
    struct ЭкспДистрибуция{
        T beta;
        ЭкспИсточник источник; // does not use Циггурат directly в_ keep this struct small
        /// constructor
        static ЭкспДистрибуция создай()(ЭкспИсточник источник,T beta){
            ЭкспДистрибуция рез;
            рез.beta=beta;
            рез.источник=источник;
            return рез;
        }
        /// chainable вызов стиль initialization of variables (thorugh a вызов в_ рандомируй)
        ЭкспДистрибуция opCall(U,S...)(ref U a,S арги){
            рандомируй(a,арги);
            return *this;
        }
        /// returns a single число
        T дайСлучайный(){
            return beta*источник.дайСлучайный();
        }
        /// инициализуй a
        U рандомируй(U)(ref U a){
            return источник.рандомирОп((T x){return beta*x; },a);
        }
        /// инициализуй a
        U рандомируй(U,V)(ref U a,V b){
            return источник.рандомирОп((T x){return (cast(T)b)*x; },a);
        }
    }
    /// returns an эксп distribution with a different beta
    ЭкспДистрибуция экспД(T beta){
        return ЭкспДистрибуция.создай(this,beta);
    }
}
