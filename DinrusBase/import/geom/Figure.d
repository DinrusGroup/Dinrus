module geom.Figure;

 import base, sys.WinStructs;

 const Прямоугольник НульПрям = Прямоугольник.init;
 const Точка НульТчк = Точка.init;
 const Размер НульРазм = Размер.init;

struct Прямоугольник
{
	 union
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

	 static Прямоугольник opCall(Точка pt, Размер sz);
	 static Прямоугольник opCall(Точка org, Точка cor);
	 static Прямоугольник opCall(цел x1, цел y1, цел x2, цел y2);
	 static Прямоугольник opCall(Размер размер);
	 static Прямоугольник opCall(Диапазон ш, Диапазон в);
	цел       дайЛево() ;
    цел       дайПраво() ;
    цел       дайВерх() ;
    цел       дайНиз() ;
	 бул opEquals(Прямоугольник r);
	 цел ширина();
	 проц ширина(цел w);
	 цел высота();
	 проц высота(цел h);
	 Точка положение();
	 проц положение(Точка pt);
	 Размер размер();
	 проц размер(Размер sz);
	 бул пустой();
	 static Прямоугольник изПРЯМа(ПРЯМ* pWinRect);
  Диапазон     ш() ;
  Диапазон     в();
  Диапазон     ш(Диапазон rn);
  Диапазон     в(Диапазон rn);
  бул      содержит(Точка p);
  бул      содержит(Прямоугольник r);
  бул        накладывается(Прямоугольник r) ;
  Прямоугольник      opShlAssign /*<<=*/(цел a);
  Прямоугольник      opShrAssign /*>>=*/(цел a) ;
  Прямоугольник      opShlAssign /*<<=*/(Размер a) ;
  Прямоугольник      opShrAssign /*>>=*/(Размер a)  ;
  Прямоугольник      opShlAssign /*<<=*/(Прямоугольник a)  ;
  Прямоугольник      opShrAssign /*>>=*/(Прямоугольник a) ;
  Прямоугольник      opShl /*<<=*/(цел a) ;
  Прямоугольник      opShr /*>>=*/(цел a)  ;
  Прямоугольник      opShl /*<<=*/(Размер a)  ;
  Прямоугольник      opShr /*>>=*/(Размер a) ;
  Прямоугольник      opShl /*<<=*/(Прямоугольник a) ;
  Прямоугольник      opShr /*>>=*/(Прямоугольник a)  ;
  Прямоугольник      opAddAssign /*+= */(цел a) ;
  Прямоугольник      opSubAssign /*-= */(цел a) ;
  Прямоугольник      opAddAssign /*+= */(Точка a);
  Прямоугольник      opSubAssign /*-= */(Точка a) ;
  Прямоугольник      opAddAssign /*+= */(Размер a);
  Прямоугольник      opSubAssign /*-= */(Размер a);

  Прямоугольник      opAdd /* r + p*/   (Точка a);
  Прямоугольник      opSub /* r - p*/   (Точка a);
  Прямоугольник      opAdd /* r + s*/   (Размер a) ;
  Прямоугольник      opSub /* r - s*/   (Размер a);
  Прямоугольник      opAnd(Прямоугольник r);
  Прямоугольник      opOr(Прямоугольник r);
  бул      пуст_ли()  ;
  static Прямоугольник пустой() ;
  проц      установи(Точка o, Размер s) ;
  проц      очисть() ;
  Точка     точкаУ(цел which);
  проц точкаУ(цел which, Точка v);
  Точка поз();
  Точка поз(Точка поз);
  Размер  дим();
  Размер  дим(Размер sz) ;
  проц впиши(Прямоугольник border) ;
  ткст вТкст();

}

бул накладывается(Прямоугольник r1, Прямоугольник r2);


struct Точка
{
	 union
	{
		struct
		{
			цел x = 0; alias x ш, ширина;
			цел y = 0; alias y в, высота;
		}

		ТОЧКА точка;
	}

   бул opEquals(Точка pt);
   static Точка opCall(цел x, цел y);
  проц          установи( цел x, цел y );
  Точка         opAdd(цел i);
  Точка         opAdd_r(цел i) ;
  Точка         opAdd(Точка p) ;
  Точка         opAdd(Размер s);
  Точка         opSub(цел i);
  Точка         opSub_r(цел i);
  Точка         opSub(Точка p) ;
  Точка         opSub(Размер s);
  Точка         opMul(цел i) ;
  Точка         opMul_r(цел i);
  Точка         opMul(Точка p) ;
  Точка         opMul(Размер s);
  Точка         opDiv(цел i) ;
  Точка         opDiv_r(цел i);
  Точка         opDiv(Точка p);
  Точка         opDiv(Размер s);
  Точка         opNeg()  ;
  Точка         opAddAssign(цел i) ;
  Точка         opAddAssign(Точка p);
  Точка         opAddAssign(Размер s) ;
  Точка         opSubAssign(цел i)   ;
  Точка         opSubAssign(Точка p);
  Точка         opSubAssign(Размер s);
  Точка         opMulAssign(цел i) ;
  Точка         opMulAssign(Точка p) ;
  Точка         opMulAssign(Размер s)  ;
  Точка         opDivAssign(цел i)  ;
  Точка         opDivAssign(Точка p) ;
  Точка         opDivAssign(Размер s)  ;
  ткст вТкст();
}

struct Размер
{
	 union
	{
		struct
		{
			цел ширина = 0; alias ширина x, cx, дш;
			цел высота = 0; alias высота y, cy, дв;
		}

		РАЗМЕР размер;
	}

   бул opEquals(Размер sz);
   static Размер opCall(цел w, цел h);
  Размер         opAdd(цел i);
  Размер         opAdd_r(цел i) ;
  Размер         opAdd(Размер s);
  Размер         opSub(цел i) ;
  Размер         opSub_r(цел i) ;
  Размер         opSub(Размер s) ;
  Размер         opMul_r(цел i);
  Размер         opMul(Размер s);
  Размер         opDiv(цел i);
  Размер         opDiv_r(цел i);
  Размер         opDiv(Размер s) ;
  Размер         opNeg()  ;
  Размер         opAddAssign(цел i);
  Размер         opAddAssign(Размер s) ;
  Размер         opSubAssign(цел i) ;
  Размер         opSubAssign(Размер s);
  Размер         opMulAssign(цел i) ;
  Размер         opMulAssign(Размер s) ;
  Размер         opDivAssign(цел i);
  Размер         opDivAssign(Размер s);
  ткст вТкст();
}

struct Диапазон
{
  цел н, в; // низ и верх

  static Диапазон  opCall( цел низ, цел верх );
  static Диапазон  opCall( цел низ_и_верх ) ;
  бул  пуст_ли() ;
  цел   длина();
  бул  накладывается(Диапазон r) ;
  бул  opEquals(Диапазон b) ;
  бул  содержит(цел i)  ;
  Диапазон opAnd(Диапазон r);
  Диапазон opOr(Диапазон r) ;
  Диапазон opAddAssign(цел i);
  Диапазон opSubAssign(цел i) ;
  Диапазон opAndAssign(Диапазон a) ;
  Диапазон opOrAssign(Диапазон b) ;
  static Диапазон пустой() ;
  ткст вТкст() ;
};
