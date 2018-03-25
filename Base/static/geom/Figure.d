/*
	Copyright (c) 2011 Trogu Antonio Davide

	This program is free software: you can redistribute it и/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a копируй of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

module geom.Figure;

public import sys.WinStructs, stdrus: фм;

struct Прямоугольник
{	

private Точка исх, угол; 

	public union
	{
		struct
		{
			цел лево = 0;
			цел верх = 0;
			цел право = 0;
			цел низ = 0;
		}

		ПРЯМ прям;
	}

	public static Прямоугольник opCall(Точка pt, Размер sz)
	{
		return opCall(pt.x, pt.y, sz.ширина, sz.высота);
	}

	public static Прямоугольник opCall(цел x1, цел y1, цел x2, цел y2)
	{
		Прямоугольник r = void; //Viene inizializzata sotto.
		
	r.исх.ш = x1; r.исх.в = y1;
    r.угол.ш = x2; r.угол.в = y2;

		r.лево = x1;
		r.верх = y1;
		r.право = x1 + x2;
		r.низ = y1 + y2;

		return r;
	}
	
static Прямоугольник opCall(Точка org, Точка cor)
  {  
  Прямоугольник r = void;
  
    r.исх = org; 
    r.угол = cor; 
  
		r.лево = org.x;
		r.верх = org.y;
		r.право = r.лево + cor.x;
		r.низ = r.верх + cor.y;
		
    return r; 
  }
  
  static Прямоугольник opCall(Размер размер) { return opCall( Точка(0,0) , размер ); }
  
  static Прямоугольник opCall(Диапазон ш, Диапазон в)
  {
    Прямоугольник r; 
    r.лево = ш.н; r.верх = в.н;
    r.право = ш.в; r.низ = в.в;
	
	r.исх.ш = ш.н; r.исх.в = в.н;
    r.угол.ш = ш.в; r.угол.в = в.в;
	
    return r; 
  }
  /////

	public бул opEquals(Прямоугольник r)
	{
		return this.лево == r.лево && this.верх == r.верх && this.право == r.право && this.низ == r.низ;
	}
	
  цел       дайЛево()    { return лево; }
  цел       дайПраво()   { return право; }
  цел       дайВерх()     { return верх; }
  цел       дайНиз()  { return низ; }
/+
	public цел ш()
	{
		return this.лево;
	}

	public проц ш(цел newX)
	{
		цел w = this.ширина;

		this.лево = newX;
		this.право = newX + w;
	}

	public цел в()
	{
		return this.верх;
	}

	public проц в(цел newY)
	{
		цел в = this.высота;

		this.верх = newY;
		this.низ = newY + в;
	}
+/
	public цел ширина()
	{		
		return this.право - this.лево;
	}

	public проц ширина(цел w)
	{
		this.право = this.лево + w;
	}

	public цел высота()
	{
		return this.низ - this.верх;
	}

	public проц высота(цел в)
	{
		this.низ = this.верх + в;
	}

	public Точка положение()
	{
		return Точка(this.лево, this.верх);
	}

	public проц положение(Точка pt)
	{
		Размер sz = this.размер; //Copia dimensioni
		
		this.лево = pt.x;
		this.верх = pt.y;
		this.право = this.лево + sz.ширина;
		this.низ = this.верх + sz.высота;
	}

	public Размер размер()
	{
		return Размер(this.ширина, this.высота);
	}

	public проц размер(Размер sz)
	{
		this.право = this.лево + sz.ширина;
		this.низ = this.верх + sz.высота;
	}

	public бул пустой()
	{
		return this.ширина <= 0 && this.высота <= 0;
	}

	public static Прямоугольник изПРЯМа(ПРЯМ* pWinRect)
	{
		Прямоугольник r = void; //Inizializzata sotto

		r.прям = *pWinRect;
		return r;
	}
//............................	
  Диапазон     ш()       { return Диапазон(исх.ш,угол.ш); }
  Диапазон     в()       { return Диапазон(исх.в,угол.в); }
  Диапазон     ш(Диапазон rn)  { исх.ш = rn.н; угол.ш = rn.в; return ш(); }
  Диапазон     в(Диапазон rn)  { исх.в = rn.н; угол.в = rn.в; return в(); }
  бул      содержит(Точка p) { return ш().содержит(p.ш) && в().содержит(p.в); }
  бул      содержит(Прямоугольник r)  
  { 
    return (r.исх.ш >= исх.ш) &&
           (r.исх.в >= исх.в) &&
           (r.угол.ш <= угол.ш) &&
           (r.угол.в <= угол.в);
  }
  
   бул        накладывается(Прямоугольник r)   { return ш().накладывается(r.ш()) && в().накладывается(r.в()); }
  
  // in- or de- flate Прямоугольник
  // Прямоугольник rc;  rc >>= 2 - deflate all sides on 2
  Прямоугольник      opShlAssign /*<<=*/(цел a)    { исх += a; угол -= a; return *this; }
  Прямоугольник      opShrAssign /*>>=*/(цел a)    { исх -= a; угол += a; return *this; }
  Прямоугольник      opShlAssign /*<<=*/(Размер a)    { исх += a.ш; угол -= a.ш; return *this; }
  Прямоугольник      opShrAssign /*>>=*/(Размер a)    { исх -= a.в; угол += a.в; return *this; }
  Прямоугольник      opShlAssign /*<<=*/(Прямоугольник a)    { исх += a.исх; угол -= a.угол; return *this; }
  Прямоугольник      opShrAssign /*>>=*/(Прямоугольник a)    { исх -= a.исх; угол += a.угол; return *this; }

  Прямоугольник      opShl /*<<=*/(цел a)    { Прямоугольник r = *this; r <<= a; return r; }
  Прямоугольник      opShr /*>>=*/(цел a)    { Прямоугольник r = *this; r >>= a; return r; }
  Прямоугольник      opShl /*<<=*/(Размер a)    { Прямоугольник r = *this; r <<= a; return r; }
  Прямоугольник      opShr /*>>=*/(Размер a)    { Прямоугольник r = *this; r >>= a; return r; }
  Прямоугольник      opShl /*<<=*/(Прямоугольник a)    { Прямоугольник r = *this; r <<= a; return r; }
  Прямоугольник      opShr /*>>=*/(Прямоугольник a)    { Прямоугольник r = *this; r >>= a; return r; }

  // shift position
  Прямоугольник      opAddAssign /*+= */(цел a)    { исх += a; угол += a; return *this; }
  Прямоугольник      opSubAssign /*-= */(цел a)    { исх -= a; угол -= a; return *this; }
  Прямоугольник      opAddAssign /*+= */(Точка a)  { исх += a; угол += a; return *this; }
  Прямоугольник      opSubAssign /*-= */(Точка a)  { исх -= a; угол -= a; return *this; }
  Прямоугольник      opAddAssign /*+= */(Размер a)    { исх += a; угол += a; return *this; }
  Прямоугольник      opSubAssign /*-= */(Размер a)    { исх -= a; угол -= a; return *this; }

  Прямоугольник      opAdd /* r + p*/   (Точка a)  { return opCall(исх + a, угол + a); }
  Прямоугольник      opSub /* r - p*/   (Точка a)  { return opCall(исх - a, угол - a); }
  Прямоугольник      opAdd /* r + s*/   (Размер a)    { return opCall(исх + a, угол + a); }
  Прямоугольник      opSub /* r - s*/   (Размер a)    { return opCall(исх - a, угол - a); }

  //intersection of two rects is a Прямоугольник iself
  Прямоугольник      opAnd(Прямоугольник r)        { return opCall( ш() & r.ш(), в() & r.в()); }
  //union (well sort of) of two rects is a Прямоугольник outlining them
  Прямоугольник      opOr(Прямоугольник r)         { return opCall( ш() | r.ш(), в() | r.в()); }
  
   бул      пуст_ли()            { return ш().пуст_ли() || в().пуст_ли(); };

  static Прямоугольник empty()            { Прямоугольник r; r.очисть(); return r; }

  проц      установи(Точка o, Размер s) { исх = o; угол = o + s - 1; }
  // opCalls this Прямоугольник empty - having ширина or высота less than or equal to zero
  проц      очисть() { исх.ш = исх.в = 0; угол.ш = угол.в = -1; }
  
  // returns Точка of rectangle. for WHICH values see numbers on num keypad. 
  Точка     точкаУ(цел which)
  {
      switch(which) 
      {
        case 7: return исх;
        case 3: return угол;
        case 1: return Точка(исх.ш,угол.в);
        case 9: return Точка(угол.ш,исх.в);
        case 8: return Точка(исх.ш + ширина/2,исх.в);
        case 2: return Точка(исх.ш + ширина/2,угол.в);
        case 4: return Точка(исх.ш,исх.в + высота/2);
        case 6: return Точка(угол.ш,исх.в + высота/2);
        case 5: return Точка(исх.ш + ширина/2,исх.в + высота/2);
        default: 
          assert(false);
      }
      return Точка(0x00000BAD,0x00000BAD); 
  }
  // move the rectangle. for WHICH values see numbers on num keypad
  // and comments inside.
  проц точкаУ(цел which, Точка v)
  {
      switch(which) 
      {
        case 7: поз = v; break; // this top-left == v
        case 3: поз = v - дим; break; // this bottom-right == v
        case 1: поз = Точка(v.ш, v.в - высота + 1); break; // this bottom-left == v
        case 9: поз = Точка(v.ш - ширина + 1, v.в); break; // this top-right == v
        case 8: поз = Точка(v.ш - ширина / 2, v.в); break; // this top-middle == v
        case 2: поз = Точка(v.ш - ширина / 2, v.в - высота + 1); break; // this bottom-middle == v
        case 4: поз = Точка(v.ш, v.в - высота / 2); break; // this center-left == v
        case 6: поз = Точка(v.ш - ширина + 1 , v.в - высота / 2); break; // this center-right == v
        case 5: поз = Точка(v.ш - ширина / 2 , v.в - высота / 2); break; // this center-middle == v
        default: 
          assert(false);
      }
  }

  // position attribute
  Точка поз() { return исх; }
  Точка поз(Точка поз) 
  {
    угол.ш = поз.ш + угол.ш - исх.ш; 
    угол.в = поз.в + угол.в - исх.в;
    return исх = поз;
  }

  // dimension attribute
  Размер  дим() { return Размер(ширина(),высота()); }
  Размер  дим(Размер sz) 
  {
    угол = исх + sz - 1; 
    return Размер(ширина(),высота());  
  }


  // move this Прямоугольник to fit inside the border outline in full
  проц впиши(Прямоугольник border) 
  {
    Точка newpos = исх;
    Размер  sz = дим;
    Размер  bsz = border.дим;
    // check the dimension first
    if( sz.ш > bsz.ш ) 
      угол.ш = исх.ш + bsz.ш - 1;
    if( sz.в > bsz.в ) 
      угол.в = исх.в + bsz.в - 1;
    //move
    if( исх.ш < border.исх.ш ) 
      newpos.ш = border.исх.ш;
    else if ( угол.ш > border.угол.ш ) 
      newpos.ш = border.угол.ш - (угол.ш - исх.ш);
    if( исх.в < border.исх.в ) 
      newpos.в = border.исх.в;
    else if ( угол.в > border.угол.в ) 
      newpos.в = border.угол.в - (угол.в - исх.в);
    поз(newpos);
  }

  ткст вТкст() { return фм("{%d,%d,%d,%d}", исх.ш, исх.в, угол.ш, угол.в); }
	
}

struct Точка
{	
	public union
	{
		struct
		{
			цел x = 0; alias x ш;
			цел y = 0; alias y в;
		}

		ТОЧКА точка;
	}

	public бул opEquals(Точка pt)
	{
		return this.x == pt.x && this.y == pt.y;
	}

	public static Точка opCall(цел x, цел y)
	{
		Точка pt = void; //Viene inizializzata sotto.
		
		pt.x = x;
		pt.y = y;
		return pt;
	}
	
  проц          установи( цел x, цел y ) { this.x = x; this.y = y; }

  // geometry arithmetics

  // Точка = Точка + цел; Точка = цел + Точка; Точка = Точка + Точка
  Точка         opAdd(цел i)    { return opCall(x + i, y + i); }
  Точка         opAdd_r(цел i)  { return opCall(x + i, y + i); }
  Точка         opAdd(Точка p)  { return opCall(x + p.x, y + p.y); }
  Точка         opAdd(Размер s)   { return opCall(x + s.x, y + s.y); }

  // Точка = Точка - цел; Точка = цел - Точка; Размер = Точка - Точка
  Точка         opSub(цел i)    { return opCall(x - i, y - i); }
  Точка         opSub_r(цел i)  { return opCall(i - x, i - y); }
  Точка         opSub(Точка p)  { return opCall(x - p.x, y - p.y); }
  Точка         opSub(Размер s)   { return opCall(x - s.x, y - s.y); }

  // Точка = Точка * цел; Точка = цел * Точка; Точка = Точка * Точка
  Точка         opMul(цел i)    { return opCall(x * i, y * i); }
  Точка         opMul_r(цел i)  { return opCall(x * i, y * i); }
  Точка         opMul(Точка p)  { return opCall(x * p.x, y * p.y); }
  Точка         opMul(Размер s)   { return opCall(x * s.x, y * s.y); }

  // Точка = Точка / цел; Точка = цел / Точка; Точка = Точка / Точка;
  // handling division on zero is a caller responsibility
  Точка         opDiv(цел i)    { return opCall(x / i, y / i); } 
  Точка         opDiv_r(цел i)  { return opCall(i / x, i / y); }
  Точка         opDiv(Точка p)  { return opCall(x / p.x, y / p.y); }
  Точка         opDiv(Размер s)   { return opCall(x / s.x, y / s.y); }

  Точка         opNeg()         { return opCall(-x, -y); }

  Точка         opAddAssign(цел i)    { return x += i, y += i, *this; } 
  Точка         opAddAssign(Точка p)  { return x += p.x, y += p.y, *this; } 
  Точка         opAddAssign(Размер s)   { return x += s.x, y += s.y, *this; } 

  Точка         opSubAssign(цел i)    { return x -= i, y -= i, *this; } 
  Точка         opSubAssign(Точка p)  { return x -= p.x, y -= p.y, *this; } 
  Точка         opSubAssign(Размер s)   { return x -= s.x, y -= s.y, *this; } 

  Точка         opMulAssign(цел i)    { return x *= i, y *= i, *this; } 
  Точка         opMulAssign(Точка p)  { return x *= p.x, y *= p.y, *this; } 
  Точка         opMulAssign(Размер s)   { return x *= s.x, y *= s.y, *this; } 

  Точка         opDivAssign(цел i)    { return x /= i, y /= i, *this; } 
  Точка         opDivAssign(Точка p)  { return x /= p.x, y /= p.y, *this; } 
  Точка         opDivAssign(Размер s)   { return x /= s.x, y /= s.y, *this; } 

  ткст вТкст() { return фм("{%d,%d}", x, y); }
}

struct Размер
{	
	public union
	{
		struct
		{
			цел ширина = 0; alias ширина x, ш;
			цел высота = 0; alias высота y, в;
		}

		РАЗМЕР размер;
	}

	public бул opEquals(Размер sz)
	{
		return this.ширина == sz.ширина && this.высота == sz.высота;
	}

	public static Размер opCall(цел w, цел в)
	{
		Размер sz = void;
		
		sz.ширина = w;
		sz.высота = в;
		return sz;
	}
	
  Размер         opAdd(цел i)    { return opCall(ширина + i, высота + i); }
  Размер         opAdd_r(цел i)  { return opCall(ширина + i, высота + i); }
  Размер         opAdd(Размер s)   { return opCall(ширина + s.ширина, высота + s.высота); }

  // Размер = Размер - цел; Размер = цел - Размер; Размер = Размер - Размер
  Размер         opSub(цел i)    { return opCall(ширина - i, высота - i); }
  Размер         opSub_r(цел i)  { return opCall(i - ширина, i - высота); }
  Размер         opSub(Размер s)   { return opCall(ширина - s.ширина, высота - s.высота); }

  // Размер = Размер * цел; Размер = цел * Размер; Размер = Размер * Размер
  Размер         opMul(цел i)    { return opCall(ширина * i, высота * i); }
  Размер         opMul_r(цел i)  { return opCall(ширина * i, высота * i); }
  Размер         opMul(Размер s)   { return opCall(ширина * s.ширина, высота * s.высота); }

  // Размер = Размер / цел; Размер = цел / Размер; Размер = Размер / Размер;
  // handling division on zero is a caller responsibility
  Размер         opDiv(цел i)    { return opCall(ширина / i, высота / i); } 
  Размер         opDiv_r(цел i)  { return opCall(i / ширина, i / высота); }
  Размер         opDiv(Размер s)   { return opCall(ширина / s.ширина, высота / s.высота); }

  Размер         opNeg()         { return opCall(-ширина, -высота); }

  Размер         opAddAssign(цел i)    { return ширина += i, высота += i, *this; } 
  Размер         opAddAssign(Размер s)   { return ширина += s.ширина, высота += s.высота, *this; } 

  Размер         opSubAssign(цел i)    { return ширина -= i, высота -= i, *this; } 
  Размер         opSubAssign(Размер s)   { return ширина -= s.ширина, высота -= s.высота, *this; } 

  Размер         opMulAssign(цел i)    { return ширина *= i, высота *= i, *this; } 
  Размер         opMulAssign(Размер s)   { return ширина *= s.ширина, высота *= s.высота, *this; } 

  Размер         opDivAssign(цел i)    { return ширина /= i, высота /= i, *this; } 
  Размер         opDivAssign(Размер s)   { return ширина /= s.ширина, высота /= s.высота, *this; } 

  ткст вТкст() { return фм("{%d,%d}", ширина,высота); }
}

template min(T)
{
  T min(in T p1, in T p2) { return p1<p2?p1:p2; }
}
template max(T)
{
  T max(in T p1, in T p2) { return p1>p2?p1:p2; }
}

struct Диапазон 
{
  цел н,в; // низ and верх 
  
  static Диапазон  opCall( цел низ, цел верх ) { Диапазон r; r.н = низ; r.в = верх; return r; }
  static Диапазон  opCall( цел низ_и_верх ) { Диапазон r; r.н = низ_и_верх; r.в = низ_и_верх; return r; }
  
  бул  пуст_ли()   { return (н > в); }
  цел   длина()     { return (н <= в)? в - н + 1 : 0; }

  бул  накладывается(Диапазон r)      { return (max!(цел)(н,r.н)) <= (min!(цел)(в,r.в)); }

  бул  opEquals(Диапазон b)      { return (н == b.н) && (в == b.в); }
  // check if 'i' is inside the Диапазон
  бул  содержит(цел i)       { return (i >= н) && (i <= в); }
  // intersection of two ranges r3 = r1 & r2;
  Диапазон opAnd(Диапазон r)        { return opCall( max!(цел)(н,r.н), min!(цел)(в,r.в)); }
  // union of two ranges r3 = r1 | r2;
  Диапазон opOr(Диапазон r)         { return opCall( min!(цел)(н,r.н), max!(цел)(в,r.в)); }

  Диапазон opAddAssign(цел i)    { return н += i, в += i, *this; } 
  Диапазон opSubAssign(цел i)    { return н -= i, в -= i, *this; } 

  // inplace intersection r1 &= r2;
  Диапазон opAndAssign(Диапазон a)  { return н = max!(цел)(н,a.н), в = min!(цел)(в,a.в), *this; } 
  // inplace union r1 |= r2;
  Диапазон opOrAssign(Диапазон b)   { if(пуст_ли()) *this = b; 
                                else if(!b.пуст_ли()) { н = min!(цел)(н,b.н); в = max!(цел)(в,b.в); } 
                                return *this; } 
  static Диапазон пустой()        { Диапазон r; r.н = 0; r.в = -1; return r; }

  ткст вТкст() { return фм("{%d,%d}", н,в); }
};

public const Прямоугольник НульПрям = Прямоугольник.init;
public const Точка НульТчк = Точка.init;
public const Размер НульРазм = Размер.init;

бул накладывается(Прямоугольник r1, Прямоугольник r2) { return r1.ш().накладывается(r2.ш()) && r1.в().накладывается(r2.в()); }