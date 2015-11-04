module linalg.Quadric;
import linalg.Vector;
import stdrus;

//== CLASS DEFINITION =========================================================


/** /class Квадрик Квадрик.hh <OSG/Geometry/Types/Квадрик.hh>

    Сохраняет квадрик как симметричную матрицу 4x4. Used by the
    ошибка quadric based mesh decimation algorithms.
**/

struct Квадрик(Скаляр)
{
public:
    alias Скаляр           тип_значения;
    alias Квадрик!(Скаляр) тип;
    alias Квадрик!(Скаляр) Сам;
    //   alias VectorInterface<Скаляр, VecStorage3<Скаляр> > Vec3;
    //   alias VectorInterface<Скаляр, VecStorage4<Скаляр> > Vec4;
    //alias Vector3Elem      Vec3;
    //alias Vector4Elem      Vec4;

    /// construct with upper triangle of symmetrix 4x4 matrix
    static Квадрик opCall(Скаляр _a, Скаляр _b, Скаляр _c, Скаляр _d,
                           /*      */ Скаляр _e, Скаляр _f, Скаляр _g,
                           /*                 */ Скаляр _h, Скаляр _i,
                           /*                            */ Скаляр _j)
    {
        Квадрик M; with(M) {
            a_=(_a), b_=(_b), c_=(_c), d_=(_d),
                e_=(_e), f_=(_f), g_=(_g),
                h_=(_h), i_=(_i),
                j_=(_j);
        } return M;
    }


    /// constructor from given plane equation: ax+by+cz+d_=0
    static Квадрик opCall( Скаляр _a=0.0, Скаляр _b=0.0, Скаляр _c=0.0, Скаляр _d=0.0 )
    {
        Квадрик M; with(M) {
            a_=(_a*_a), b_=(_a*_b),  c_=(_a*_c),  d_=(_a*_d),
                e_=(_b*_b),  f_=(_b*_c),  g_=(_b*_d),
                h_=(_c*_c),  i_=(_c*_d),
                j_=(_d*_d);
        } return M;
    }

    /// constructor from given plane equation: ax+by+cz+d_=0
    ///          or from distance to a point: x,y,z
    ///          or from upper triangle of 4x4 symmetric matrix.
    static Квадрик opCall( Скаляр[] v )
    {
        if (v.length == 10) {
            return Квадрик(v[0],v[1],v[2],v[3],
                            /**/ v[4],v[5],v[6],
                            /**/      v[7],v[8],
                            /**/           v[9]);
        }
        else if (v.length == 4) {
            return Квадрик(v[0],v[1],v[2],v[3]);
        }
        else if (v.length == 3) {
            return из_точки(Вектор!(Скаляр,3)(v));
        }
        assert(false, "Число элементов должно быть 3,4 или 10");
    }


   static Квадрик из_точки(_Point)(ref _Point _pt)
    {
        Квадрик M; with(M) {
            уст_расстояние_к_точке(_pt);
        } return M;
    }


 
    static Квадрик из_нормали_и_точки(_Normal,_Point)( ref _Normal _n, ref _Point _p)
    {
        Квадрик M; with(M) {
            уст_расстояние_к_плоскости(_n,_p);
        } return M;
    }

    //установи operator
    проц установи(Скаляр _a, Скаляр _b, Скаляр _c, Скаляр _d,
             Скаляр _e, Скаляр _f, Скаляр _g,
             Скаляр _h, Скаляр _i,
             Скаляр _j)
    {
        a_ = _a; b_ = _b; c_ = _c; d_ = _d;
        e_ = _e; f_ = _f; g_ = _g;
        h_ = _h; i_ = _i;
        j_ = _j;
    }

    //sets the quadric representing the squared distance to _pt
    проц уст_расстояние_к_точке(_Point)( ref _Point _pt)
    {
        установи(1, 0, 0, -_pt[0],
            1, 0, -_pt[1],
            1, -_pt[2],
            точка(_pt,_pt));
    }

    //sets the quadric representing the squared distance to the plane [_a,_b,_c,_d]
    проц уст_расстояние_к_плоскости(T=void)(Скаляр _a, Скаляр _b, Скаляр _c, Скаляр _d)
    {
        a_ = _a*_a; b_ = _a*_b; c_ = _a*_c;  d_ = _a*_d;
        /*       */ e_ = _b*_b; f_ = _b*_c;  g_ = _b*_d;
        /**/                    h_ = _c*_c;  i_ = _c*_d;
        /**/                                 j_ = _d*_d;
    }

    //sets the quadric representing the squared distance to the plane
    //determined by the normal _n и the point _p
    проц уст_расстояние_к_плоскости(_Normal,_Point)( ref _Normal  _n,ref _Point _p)
    {
        уст_расстояние_к_плоскости(_n[0], _n[1], _n[2], -точка(_n,_p));
    }

    /// установи all entries to zero
    проц очисть()  { a_ = b_ = c_ = d_ = e_ = f_ = g_ = h_ = i_ = j_ = 0.0; }

    /// add quadrics
    проц opAddAssign(ref Квадрик _q )
    {
        a_ += _q.a_;  b_ += _q.b_;  c_ += _q.c_;  d_ += _q.d_;
        /**/          e_ += _q.e_;  f_ += _q.f_;  g_ += _q.g_;
        /**/                        h_ += _q.h_;  i_ += _q.i_;
        /**/                                      j_ += _q.j_;
        //return *this;
    }


    /// multiply by scalar
    проц opMulAssign( Скаляр _s)
    {
        a_ *= _s;  b_ *= _s;  c_ *= _s;  d_ *= _s;
        /**/       e_ *= _s;  f_ *= _s;  g_ *= _s;
        /**/                  h_ *= _s;  i_ *= _s;
        /**/                             j_ *= _s;
        //return *this;
    }


    /// multiply 4D вектор from right: Q*v
    _Vec4 opMul(_Vec4)(ref _Vec4 _v)
    {
        Скаляр x=_v[0], y=_v[1], z=_v[2], w=_v[3];
        return _Vec4(x*a_ + y*b_ + z*c_ + w*d_,
                     x*b_ + y*e_ + z*f_ + w*g_,
                     x*c_ + y*f_ + z*h_ + w*i_,
                     x*d_ + y*g_ + z*i_ + w*j_);
    }

    /// расцени quadric Q at (3D or 4D) вектор v: v*Q*v
    //Скаляр opCall(_Vec)( ref _Vec _v) 
    Скаляр оцени(_Vec)(ref _Vec _v) 
    {
        return расцени!(_Vec,_Vec.размер_)(_v);
    }

    Скаляр a(){ return a_; }
    Скаляр b(){ return b_; }
    Скаляр c(){ return c_; }
    Скаляр d(){ return d_; }
    Скаляр e(){ return e_; }
    Скаляр f(){ return f_; }
    Скаляр g(){ return g_; }
    Скаляр h(){ return h_; }
    Скаляр i(){ return i_; }
    Скаляр j(){ return j_; }

    Скаляр xx(){ return a_; }
    Скаляр xy(){ return b_; }
    Скаляр xz(){ return c_; }
    Скаляр xw(){ return d_; }
    Скаляр yy(){ return e_; }
    Скаляр yz(){ return f_; }
    Скаляр yw(){ return g_; }
    Скаляр zz(){ return h_; }
    Скаляр zw(){ return i_; }
    Скаляр ww(){ return j_; }

    ткст вТкст() {
        return фм("[%s, %s, %s, %s;  %s, %s, %s;  %s, %s;  %s]",
                                 a_,b_,c_,d_,e_,f_,g_,h_,i_,j_);
    }
protected:

    /// расцени quadric Q at 3D вектор v: v*Q*v
    Скаляр расцени(_Vec3,бцел N)(ref _Vec3 _v) 
    {
        static if(N==3) {
            Скаляр x=_v[0], y=_v[1], z=_v[2];
            return a_*x*x + 2.0*b_*x*y + 2.0*c_*x*z + 2.0*d_*x
                /**/      +     e_*y*y + 2.0*f_*y*z + 2.0*g_*y
                /**/                   +     h_*z*z + 2.0*i_*z
                /**/                                +     j_;
        }
        else static if(N==4) {
            Скаляр x=_v[0], y=_v[1], z=_v[2], w=_v[3];
            return a_*x*x + 2.0*b_*x*y + 2.0*c_*x*z + 2.0*d_*x*w
                /**/      +     e_*y*y + 2.0*f_*y*z + 2.0*g_*y*w
                /**/                   +     h_*z*z + 2.0*i_*z*w
                /**/                                +     j_*w*w;
        }
        else {
            static assert(false, "Размер вектора должен быть 3 или 4");
        }
    }


private:

    Скаляр a_=0, b_=0, c_=0, d_=0,
        /**/     e_=0, f_=0, g_=0,
        /**/           h_=0, i_=0,
        /**/                 j_=0;
}


/// Quadric using floats
alias Квадрик!(плав) Квадрикп;

/// Quadric using double
alias Квадрик!(дво) Квадрикд;


import linalg.VectorTypes;

unittest
{
    Квадрикп qf;
    Квадрикд qd = [1,2,3,4];

    qf.оцени(Век3п(0,1,2));
    qd * Век4п(0,1,2,4);
	скажинс("окей");
}


