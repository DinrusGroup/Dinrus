module geom.Plane3d;
import linalg.Vector;


//== CLASS DEFINITION =========================================================

	      
/** \class Plane3d Plane3d.hh <OpenMesh/Tools/VDPM/Plane3d.hh>

    ax + by + cz + d = 0
*/


struct Плоскость3м
{
public:

    alias Век3п       т_вектор;
    alias т_вектор.тип_значения   т_знач;

public:

    static Плоскость3м opCall()
    {
        Плоскость3м M; with(M) {
            d_ = 0;
        } return M;
    }

    static Плоскость3м opCall(ref т_вектор _dir, ref т_вектор _pnt)
    { 
        Плоскость3м M; with (M) {
            n_ = _dir;
            n_.нормализуй();
            d_ = -точка(n_,_pnt);
        } return M;
    }

    т_знач дистанцияСоЗнаком( ref Век3п _p)
    {
        return  точка(n_ , _p) + d_;
    }

public:

    т_вектор n_;
    т_знач  d_;

}

unittest {
    Плоскость3м p;
    auto q = Плоскость3м( Век3п(0,1,0), Век3п(1,0,1) );

    p.дистанцияСоЗнаком( Век3п(1,1,1) );

}