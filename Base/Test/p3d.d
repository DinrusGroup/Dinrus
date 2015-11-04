import geom.Plane3d;
import linalg.Vector;

void main() {
    Плоскость3м p;
    auto q = Плоскость3м( Век3п(0,1,0), Век3п(1,0,1) );

    p.дистанцияСоЗнаком( Век3п(1,1,1) );
	эхо("OK");
	
}