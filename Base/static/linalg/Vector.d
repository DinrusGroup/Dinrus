//============================================================================
// Вектор.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
module linalg.Vector;

import stdrus, tpl.metastrings;

// ----------------------------------------------------------------------------

// Создаёт ткст, откатывающий данное выражение N раз, заменяя
// инд сим ('i' по умолчанию) всякий раз на номер цикла в выражении
ткст откат(цел N,цел i=0)(ткст выр, сим инд='i') {
    static if(i<N) {
        ткст подст_выр;
        foreach (c; выр) {
            if (c==инд) { 
                подст_выр ~= tpl.metastrings.ВТкст!(i); 
            } else {
                подст_выр ~= c;
            }
        }
        return подст_выр ~ "\n" ~ откат!(N,i+1)(выр,инд);
    }else{
    return "";}
}

private ткст _gen_zero_vector(цел N)(ткст класс_сохранения, ткст имя) {
    ткст возвр = класс_сохранения ~" Вектор "~имя~" = {[cast(Т)";
    for(цел столб=0; столб<N; ++столб) {
        возвр ~= "0,";
    }
    return возвр[0..$-1] ~ "]};";
}



private ткст _gen_member_aliases(цел N)(ткст буквы) {
    // This takes a ткст of буквы like "xyz" и makes them алиасы
    // for the N components using an anonymous struct.
    ткст возвр = "struct{";
    foreach(c; буквы) {
        возвр ~= "Скаляр " ~ c ~ ";";
    }
    возвр ~= "}";
    return возвр;
}



цел сравни(S,Т)(S a, Т b) {
    if (a==b) return 0;
    return (a<b)? -1 : 1;
} 

//== CLASS DEFINITION =========================================================


/** Значения N шаблонного типа Скаляр - единственные члены данных
    класса Вектор<Скаляр,N>. This guarantees 100% compatibility
    with arrays of type Скаляр и размер N, allowing us to define the
    cast operators to и from arrays и массив pointers.

    In addition, this class will be specialized for Век4п to be 16 bit
    aligned, so that aligned SSE instructions can be использован on these
    vectors.
*/
struct Вектор(Т, цел N)
{
    alias Т Скаляр;

private alias откат!(N) откат_;
public:

  //---------------------------------------------------------------- class info

    union {
        Скаляр[N] значения_ /*= void*/;
        static if(N<=4) {
            struct {
                static if(N>=1) {Скаляр x; }
                static if(N>=2) {Скаляр y; }
                static if(N>=3) {Скаляр z; }
                static if(N>=4) {Скаляр w; }
            }
        }
    }


    /// тип используемого в шаблоне скаляра
    alias Скаляр тип_значения;

    /// тип вектора
    alias Вектор!(Скаляр,N)  т_вектор;

    /// возвращает размер вектора
    static т_мера размер() { return N; }
	
	
    static const т_мера размер_ = N;
    static const т_мера длина = N;
	alias длина length;

    static if(is(typeof(Скаляр.nan))) {
        static const бул плав_ли = true;
    }        
    else {
        static const бул плав_ли = false;
    }

    //-------------------------------------------------------------- constructors
    /// Статические векторы времени компиляции со значениями, установленными в 0.
    // static Вектор ноль = {0,0,0...}
    // static const Вектор ноль = {0,0,0...}
    mixin(_gen_zero_vector!(N)("static", "zero"));
    mixin(_gen_zero_vector!(N)("static const", "czero"));

    /// default constructor creates uninitialized значения.
    static Вектор opCall() {
        Вектор M; with(M) {
        } return M;
    }

    /// special constructor  -- broadcasts the value to all элементы
    static Вектор opCall(/*const*/ Скаляр v) {
        Вектор M; with(M) {
            //     assert(N==1);
            //     значения_[0] = v0;
            векторизуй(v);
        } return M;
    }

    static if(N==2) {
    /// special constructor for 2D vectors
    static Вектор opCall(/*const*/ Скаляр v0, /*const*/ Скаляр v1) {
        assert(N==2);
        Вектор M; with(M) {
            значения_[0] = v0; значения_[1] = v1;
        } return M;
    }
    }

    static if(N==3) {
    /// special constructor for 3D vectors
    static Вектор opCall(/*const*/ Скаляр v0, /*const*/ Скаляр v1, 
                          /*const*/ Скаляр v2) 
    {
        assert(N==3);
        Вектор M; with(M) {
            значения_[0]=v0; значения_[1]=v1; значения_[2]=v2;
        } return M;
    }
    }

    static if (N==4) {
    /// special constructor for 4D vectors
    static Вектор opCall(/*const*/ Скаляр v0, /*const*/ Скаляр v1,
                          /*const*/ Скаляр v2, /*const*/ Скаляр v3) 
    {
        assert(N==4);
        Вектор M; with(M) {
            значения_[0]=v0; значения_[1]=v1; значения_[2]=v2; значения_[3]=v3;
        } return M;
    }
    }

    static if (N==5) {
    /// special constructor for 5D vectors
    static Вектор opCall(/*const*/ Скаляр v0, /*const*/ Скаляр v1,
                          /*const*/ Скаляр v2, /*const*/ Скаляр v3,
                          /*const*/ Скаляр v4) 
    {
        assert(N==5);
        Вектор M; with(M) {
            значения_[0]=v0; значения_[1]=v1;
            значения_[2]=v2; значения_[3]=v3; значения_[4]=v4;
        } return M;
    } 
    }

    static if (N==6) {
    /// special constructor for 6D vectors
    static Вектор opCall(/*const*/ Скаляр v0, /*const*/ Скаляр v1, /*const*/ Скаляр v2,
                          /*const*/ Скаляр v3, /*const*/ Скаляр v4, /*const*/ Скаляр v5) 
    {
        assert(N==6);
        Вектор M; with(M) {
            значения_[0]=v0; значения_[1]=v1; значения_[2]=v2;
            значения_[3]=v3; значения_[4]=v4; значения_[5]=v5;
        } return M;
    }
    }

/+
    /// construct from a value массив
    // This doesn't coexist nicely with the dynamic Скаляр[] version below
    // which is a shame because this version is compile-time проверьed but 
    // doesn't work with dynamic arrays, while the dynamic version works with
    // all arrays, but имеется to do runtime проверьing.
    static Вектор opCall(/*const*/ Скаляр[N] _значения) {
        assert( _значения.длина == N );
        Вектор M; with(M) {
            значения_[] = _значения;
        } return M;
    }
+/
    /// construct from a dynamic value массив
    static Вектор opCall(/*const*/ Скаляр[] _значения) {
        assert( _значения.length == N );
        Вектор M;
        M.значения_[] = _значения;
        return M;
    }

    /// копируй & cast constructor (явный)
    /+
     // Currently конфликтует with non-template version, but 
     // not needed since plain value копируй и opAssign handle these cases ok.
    static Вектор opCall(otherScalarType)(/*const*/ ref Вектор!(otherScalarType,N) _rhs) {
        Вектор M; M = _rhs;
        return M;
    }
    +/



    //--------------------------------------------------------------------- casts

    /// cast from вектор with a different скаляр type
    //void opAssign(otherScalarType)(/*const*/ ref Вектор!(otherScalarType,N) _rhs) {
    void opAssign(ВекТип)(/*const*/ ВекТип _rhs) {
        static if(!is(typeof(_rhs.length))) { 
            pragma(msg,__FILE__~"(): Внимание0: в Вектор.opAssign присваиваемый тип, "
                   ~ВекТип.stringof~", не имеет свойства .length.");
        }
        else { assert(_rhs.length == N, "Вектор.opAssign: rhs неправильной длины"); }
        const ткст выр = "значения_[i] = cast(Скаляр)_rhs[i];";
        mixin( откат_(выр) );
        //return *this
    }

    /// cast to Скаляр массив
    Скаляр* укз() { return значения_.ptr; }
alias укз ptr;
    /// cast to const Скаляр массив
    // /*const*/ Скаляр* ptr() /*const*/ { return значения_.ptr; }




    //----------------------------------------------------------- элемент доступ

    /// дай i'th элемент read-only
    Скаляр opIndex(т_мера _i) {
        assert(_i<N,"v["~stdrus.вТкст(_i)~"]: индекс вне диапазона"); return значения_[_i];
    }
    /// дай i'th элемент write-only
    void opIndexAssign(Скаляр v, т_мера _i) {
        assert(_i<N); значения_[_i] = v;
    }
    цел opApply(цел delegate(ref Скаляр) цикл) {
        foreach(ref x; значения_) {
            цел возвр = цикл(x);
            if (возвр) return возвр;
        }
        return 0;
    }
    цел opApply(цел delegate(ref т_мера, ref Скаляр) цикл) {
        foreach(i, ref x; значения_) {
            цел возвр = цикл(i,x);
            if (возвр) return возвр;
        }
        return 0;
    }
    цел opApplyReverse(цел delegate(ref Скаляр) цикл) {
        foreach_reverse(ref x; значения_) {
            цел возвр = цикл(x);
            if (возвр) return возвр;
        }
        return 0;
    }
    цел opApplyReverse(цел delegate(ref т_мера, ref Скаляр) цикл) {
        foreach_reverse(i, ref x; значения_) {
            цел возвр = цикл(i,x);
            if (возвр) return возвр;
        }
        return 0;
    }


    //---------------------------------------------------------------- comparsion
    /// component-wise comparison
    цел opEquals(/*const*/ ref т_вектор _rhs) /*const*/ {
        const ткст выр = "if(значения_[z]!=_rhs.значения_[z]) return 0;";
        mixin( откат_(выр,'z') );
        return 1;
    }

    //---------------------------------------------------------- скаляр operators

    /// component-wise self-multiplication with скаляр
    void opMulAssign(/*const*/ Скаляр _s) {
        const ткст выр = "значения_[i] *= _s;";
        mixin( откат_(выр) );
        //return *this;
    }

    /** component-wise self-division by скаляр
        \attention v *= (1/_s) is much faster than this  */
    void opDivAssign(/*const*/ Скаляр _s) {
        static if(is(typeof(Скаляр.nan))) { // it's an fp type
            Скаляр recp = (cast(Скаляр)1) / _s; 
            const ткст выр = "значения_[i] *= recp;";
        } else {
            const ткст выр = "значения_[i] /= _s;";
        }
        //pragma(msg,откат_(выр,'i'));
        mixin( откат_(выр) );
        //return *this;
    }

    /// component-wise multiplication with скаляр
    т_вектор opMul(/*const*/ Скаляр _s) /*const*/ {
        version(all) {
            auto M = *this;
            M *= _s;
            return M;
        } else {
            //const ткст выр = "значения_[i] * _s;";
            //pragma(msg,откат_(выр,'i'));
            //return т_вектор(unroll_csv(выр));
        }
    }
    /// component-wise division by with скаляр
    т_вектор opDiv(/*const*/ Скаляр _s) /*const*/ {
        version(all) {
            auto M = *this;
            M /= _s;
            return M;
        } else {
            //const ткст выр = "значения_[i] / _s;"
            //return т_вектор(unroll_csv(выр));
        }
    }


    //---------------------------------------------------------- вектор operators

    /// component-wise self-multiplication
    void opMulAssign(/*const*/ ref т_вектор _rhs) {
        const ткст выр = "значения_[i] *= _rhs[i];";
        //pragma(msg,откат_(выр,'i'));
        mixin( откат_(выр) );
        //return *this;
    }

    /// component-wise self-division
    void opDivAssign(/*const*/ ref т_вектор _rhs) {
        const ткст выр = "значения_[i] /= _rhs[i];";
        //pragma(msg,откат_(выр,'i'));
        mixin( откат_(выр) );
        //return *this;
    }


    /// вектор difference from this
    void opSubAssign(/*const*/ ref т_вектор _rhs) {
        const ткст выр = "значения_[i] -= _rhs[i];";
        //pragma(msg,откат_(выр,'i'));
        mixin( откат_(выр) );
        //return *this;
    }

    /// вектор self-addition
    void opAddAssign(/*const*/ ref т_вектор _rhs) {
        const ткст выр = "значения_[i] += _rhs[i];";
        //pragma(msg,откат_(выр,'i'));
        mixin( откат_(выр) );
        //return *this;
    }


    /// component-wise вектор multiplication
    т_вектор opMul(/*const*/ ref т_вектор _v) /*const*/ {
        auto M = *this; 
        M *= _v; 
        return M;
    }

    /// component-wise вектор division
    т_вектор opDiv(/*const*/ ref т_вектор _v) /*const*/ {
        auto M = *this; 
        M /= _v; 
        return M;
    }      


    /// component-wise вектор addition
    т_вектор opAdd(/*const*/ ref т_вектор _v) /*const*/ {
        auto M = *this; 
        M += _v; 
        return M;
    }

    /// component-wise вектор difference
    т_вектор opSub(/*const*/ ref т_вектор _v) /*const*/ {
        auto M = *this; 
        M -= _v; 
        return M;
    }

    /// unary minus
    т_вектор opNeg() /*const*/ {
        т_вектор v = void;
        const ткст выр = "v.значения_[i] = -значения_[i];";
        //pragma(msg,откат_(выр,'i'));
        mixin( откат_(выр) );
        return v;
    }

    static if(N==3) {
        /// кросс product: only defined for Vec3* as specialization
        /// See_Also: auxd.OpenMesh.кросс
        Вектор кросс(/*const*/ ref Вектор _rhs) /*const*/
        {
            Вектор M;
            M.значения_[0] = значения_[1]*_rhs.значения_[2]-значения_[2]*_rhs.значения_[1];
            M.значения_[1] = значения_[2]*_rhs.значения_[0]-значения_[0]*_rhs.значения_[2];
            M.значения_[2] = значения_[0]*_rhs.значения_[1]-значения_[1]*_rhs.значения_[0];
            return M;
        }
    }

    static if(N==2) {
        /// кросс product: only defined for Vec2* as specialization
        /// See_Also: auxd.OpenMesh.кросс
        Скаляр кросс(/*const*/ ref Вектор _rhs) /*const*/
        {
            return (значения_[0]*_rhs.значения_[1]-значения_[1]*_rhs.значения_[0]);
        }
    }

    /// compute скаляр product
    /// See_Also: auxd.OpenMesh.точка
    Скаляр точка(/*const*/ ref т_вектор _rhs) /*const*/ {
        Скаляр p = 0;
        const ткст выр = "p += значения_[i] * _rhs.значения_[i];";
        //pragma(msg,откат_(выр,'i'));
        mixin( откат_(выр) );
        return p;
    }



    //------------------------------------------------------------ euclidean нормаль

    static if (т_вектор.плав_ли) {
        /// Compute Euclidean (L2) нормаль
        Скаляр нормаль() /*const*/ { 
            return cast(Скаляр)квкор(квнорм());
        }

        /// Compute squared Euclidean (L2) нормаль
        Скаляр квнорм() /*const*/ 
        {
            Скаляр s = 0;
            const ткст выр = "s += значения_[i] * значения_[i];";
            mixin( откат_(выр) );
            return s;
        }

        /// Return the one-нормаль of the вектор (sum of элементы' absolute значения)
        Скаляр норм1() {
            Скаляр возвр=0;
            foreach(v; значения_) возвр += абс(v);
            return возвр;
        }

        /// Return the infinity-нормаль of the вектор (макс элемент std.math.absolute value)
        Скаляр бескнорм() {
            Скаляр возвр= -Скаляр.max;
            foreach(v; значения_) {
                v = абс(v);
                if (v>возвр) возвр = v;
            }
            return возвр;
        }


        /** нормализуй вектор in place, return original length
         */
        Скаляр нормализуй() 
        {
            Скаляр длин = this.нормаль();
            *this /= длин;
            return длин;
        }
  
        /** Return нормализованный копируй of вектор
         */
        Вектор нормализованный()  /*const*/
        {
            return *this / this.нормаль();
        }
  
        /** нормализуй вектор avoiding div by ноль 
         *  returns original length.
         */
        Скаляр нормализуй_усл()
        {
            Скаляр n = нормаль();
            if (n != cast(Скаляр)0.0)
            {
                *this /= n;
            }
            return n;
        }
        /** Return нормализованный копируй of вектор avoiding div by ноль 
         *  returns original new вектор.
         */
        Вектор нормализованный_усл() /*const*/
        {
            Скаляр n = нормаль();
            if (n != cast(Скаляр)0.0)
            {
                return *this / n;
            }
            return *this;
        }
    }

    //------------------------------------------------------------ макс, мин, среднеариф

    /// return the maximal component
    Скаляр макс() /*const*/ 
    {
        Скаляр m = значения_[0];
        const ткст выр = "if(значения_[z]>m) m=значения_[z];";
        mixin( откат!(N,1)(выр,'z') );
        return m;
    }

    /// return the minimal component
    Скаляр мин() /*const*/ 
    {
        Скаляр m = значения_[0];
        const ткст выр = "if(значения_[z]<m) m=значения_[z];";
        mixin( откат!(N,1)(выр,'z') );
        return m;
    }

    static if (т_вектор.плав_ли) {
        /// return arithmetic среднеариф
        Скаляр среднеариф() /*const*/ 
        {
            Скаляр m = значения_[0];
            const ткст выр = "m+=значения_[i];";
            mixin( откат!(N,1)(выр) );
            return m/cast(Скаляр)(N);
        }
    }

    /// минимируй значения: same as *this = мин(*this, _rhs), but faster
    т_вектор минимируй(/*const*/ ref т_вектор _rhs) {
        const ткст выр = "if (_rhs[z] < значения_[z]) значения_[z] = _rhs[z];";
        mixin( откат_(выр,'z') );
        return *this;
    }

    /// максимируй значения: same as *this = макс(*this, _rhs), but faster
    т_вектор максимируй(/*const*/ ref т_вектор _rhs) {
        const ткст выр = "if (_rhs[z] > значения_[z]) значения_[z] = _rhs[z];";
        mixin( откат_(выр,'z') );
        return *this;
    }

    /// component-wise мин
    т_вектор мин(/*const*/ ref т_вектор _rhs) {
        auto M = *this;
        M.минимируй(_rhs);
        return M;
    }

    /// component-wise макс
    т_вектор макс(/*const*/ ref т_вектор _rhs) {
        auto M = *this;
        M.максимируй(_rhs);
        return M;
    }




    //------------------------------------------------------------ misc functions

    /// component-wise примени function object with Скаляр opCall(Скаляр).
    т_вектор примени(Функтор)(/*const*/ Функтор _func) /*const*/ {
        т_вектор result;
        const ткст выр = "result[i] = _func(значения_[i]);";
        mixin( откат_(выр) );
        return result;
    }

    /// store the same value in each component (e.g. to clear all entries)
    void векторизуй(/*const*/ Скаляр _s) {
        const ткст выр = "значения_[i] = _s;";
        mixin( откат_(выр) );
        //return *this;
    }


    /// store the same value in each component
    static т_вектор векторизованный(/*const*/ Скаляр _s) {
        auto возвр = т_вектор(); 
        возвр.векторизуй(_s);
        return возвр;
    }


    /// lexicographical comparison
    цел opCmp(/*const*/ т_вектор _rhs) /*const*/ {
        const ткст выр =
            "cmp=сравни(значения_[z],_rhs.значения_[z]);\n"
            "if (cmp!=0) return cmp;\n";
        цел cmp;
        mixin (откат_(выр,'z'));
        return false;
    }


    ткст вТкст() {
        ткст возвр = "[";
        for(цел i=0; i<N; i++) {
            возвр ~= фм(значения_[i]);
            возвр ~= i!=N-1 ? ", " : "]"; 
        }
        return возвр;
    }

}


/+
/// read the space-separated components of a вектор from a stream
template!(Скаляр, цел N)
std.ref istream
operator>>(ref istream is, Вектор<Скаляр,N>& vec)
{
const ткст выр = ""is >> vec[i];
  откат(выр);
  return is;
}


/// output a вектор by printing its space-separated compontens
template!(Скаляр, цел N)
std.ref ostream
operator<<(ref ostream os, /*const*/ Вектор<Скаляр,N>& vec)
{
#if N==N
  for(цел i=0; i<N-1; ++i) os << vec[i] << " ";
  os << vec[N-1];
#else
const ткст выр = ""vec[i]
  os << unroll_comb(выр, << " " <<);
#endif

  return os;
}
+/


//== GLOBAL FUNCTIONS =========================================================

/+
/// \relates auxd.OpenMesh.Вектор
/// скаляр * вектор
template< Скаляр,цел N>
inline Вектор<Скаляр,N> operator*(Скаляр _s, const Вектор<Скаляр,N>& _v) {
  return Вектор<Скаляр,N>(_v) *= _s;
}

+/

/// \relates auxd.OpenMesh.Вектор
/// symmetric version of the точка product
Скаляр 
точка(Скаляр, цел N)(/*const*/ ref Вектор!(Скаляр,N) _v1, 
                   /*const*/ ref Вектор!(Скаляр,N) _v2) 
{
    return (_v1.точка(_v2)); 
}


/// \relates auxd.OpenMesh.Вектор
/// symmetric version of the кросс product
template кросс( Скаляр, цел N)
{
    // This monstrosity is требуется to make D allow the
    // 2d и 3d versions of the template to coexist peacefully.
    // (should be 
    //   alias typeof(Вектор!(Скаляр,N)().кросс(Вектор!(Скаляр,N)())) RetT;
    // but that kills implicit instatiation.
    // Or should be two separate templates, but then DMD says they're ambiguous.
    typeof(Вектор!(Скаляр,N)().кросс(Вектор!(Скаляр,N)()))
    
    кросс(/*const*/ ref Вектор!(Скаляр,N) _v1, 
          /*const*/ ref Вектор!(Скаляр,N) _v2) 
    {
        return (_v1.кросс(_v2));
    }
}

/// \relates auxd.OpenMesh.Вектор
/// Linear interpolation between _v1 и _v2.
Вектор!(Скаляр,N) 
лининтерп( Скаляр, цел N)(Скаляр t,
                     /*const*/ ref Вектор!(Скаляр,N) _v1, 
                     /*const*/ ref Вектор!(Скаляр,N) _v2) 
{
    Вектор!(Скаляр,N) v = _v1;
    Скаляр s = 1.0-t;
    const ткст выр = "v.значения_[i] *= s; v.значения_[i] += t*_v2.значения_[i];";
    //pragma(msg,откат_(выр,'i'));
    mixin( откат!(N)(выр) );
    return v;
}


//== ALIASES =================================================================

// Just the most common алиасы.  The rest are in auxd.OpenMesh.Core.Geometry.VectorTypes

/** 2-ббайт вектор */
alias Вектор!(ббайт,2) Век2бб;
/** 2-плав вектор */
alias Вектор!(плав,2) Век2п;
/** 2-дво вектор */
alias Вектор!(дво,2) Век2д;
/** 3-ббайт вектор */
alias Вектор!(ббайт,3) Век3бб;
/** 3-плав вектор */
alias Вектор!(плав,3) Век3п;
/** 3-дво вектор */
alias Вектор!(дво,3) Век3д;
/** 4-ббайт вектор */
alias Вектор!(ббайт,4) Век4бб;
/** 4-плав вектор */
alias Вектор!(плав,4) Век4п;
/** 4-дво вектор */
alias Вектор!(дво,4) Век4д;

/*
template Вектор2(Т) { alias Вектор!(Т,2) Вектор2; }
template Вектор3(Т) { alias Вектор!(Т,3) Вектор3; }
template Вектор4(Т) { alias Вектор!(Т,4) Вектор4; }
template Vector5(Т) { alias Вектор!(Т,5) Vector5; }
template Vector6(Т) { alias Вектор!(Т,6) Vector6; }
template Vector7(Т) { alias Вектор!(Т,7) Vector7; }
template Vector8(Т) { alias Вектор!(Т,8) Vector8; }
*/


//=============================================================================


/** \имя Cast вектор type to another вектор type.
*/
//@{

//-----------------------------------------------------------------------------

проц копируй_вектор(т_исток,т_приёмник,бцел N, бцел i=0)(ref т_исток s, ref т_приёмник d)
{
    static if(i<N) {
        d[i] = cast(typeof(d[0])) s[i];
        копируй_вектор!(т_исток,т_приёмник,N,i+1)(s,d);
    }
}


//-----------------------------------------------------------------------------


template каст_вектор(т_приёмник) {
    т_приёмник каст_вектор(т_исток)(ref т_исток ист) { 
        static if (is(т_приёмник==т_исток)) {
            //pragma(msg, "trivial branch");
            return ист; 
        }
        else {
            //pragma(msg, "different types branch");
            static assert(т_исток.length == т_приёмник.length, 
                          "Длины векторных типов не совпадают");
            т_приёмник tmp;
            копируй_вектор!(т_исток, т_приёмник, т_исток.length)(ист, tmp);
            return tmp;
        }
    }
}


//=============================================================================


/** \имя Provide a standardized доступ to relevant information about a
     вектор type.
*/
//@{

//-----------------------------------------------------------------------------

/** Helper class providing information about a вектор type.
 *
 * If want to use a different вектор type than the one provided %OpenMesh
 * you need to supply a specialization of this class for the new вектор type.
 */
struct трэтс_вектора(T)
{
    /// Type of the вектор class
    alias T.т_вектор т_вектор;
    /// Type of the scalar value
    alias T.тип_значения  тип_значения;

    /// размер/dimension of the вектор
    static const т_мера размер_ = T.размер_;

    /// размер/dimension of the вектор
    static т_мера размер() { return размер_; }
}

//== TESTS =================================================================
unittest {
/*
    alias Вектор!(плав,3) Век3п;
    alias Вектор!(плав,2) Век2п;
    alias Вектор!(цел,2) Vec2i;
    alias Вектор!(цел,3) Век3ц;
    alias Вектор!(ббайт,10) Vec10ub;

    alias std.io.writefln writefln;

    Век3п a;
    Век3п b=  {8,9,10};
    дво[] dyn = [7.0,6.0,3.0];
    Вектор!(дво,3) af = dyn;
    Вектор!(цел,3) ai;
    ai = [1,2,3];
    a = [1,2,3];
    
    writefln("A=", a);
    writefln("Alen=", a.нормаль);
    writefln("ai=", ai);
    writefln("B=", b);

    a = af;
*/
}