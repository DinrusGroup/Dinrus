import cidrus: cosl, sinl;
import win,stdrus: пауза;
import math.IEEE, math.Elliptic, math.Bracket, math.Math, math.BigInt, math.Bessel, math.GammaFunction;
//import stdrus;

void main() {

    assert(логб(реал.infinity)== реал.infinity);
    assert(идентичен_ли(логб(НЧ(0xFCD)), НЧ(0xFCD)));
    assert(логб(1.0)== 0.0);
    assert(логб(-65536) == 16);
    assert(логб(0.0)== -реал.infinity);
    assert(илогб(0.125*реал.min) == реал.min_exp-4);
	
    assert(илогб(1.0) == 0);
    assert(илогб(65536) == 16);
    assert(илогб(-65536) == 16);
    assert(илогб(1.0 / 65536) == -16);
    assert(илогб(реал.nan) == FP_ILOGBNAN);
    assert(илогб(0.0) == FP_ILOGB0);
    assert(илогб(-0.0) == FP_ILOGB0);
    // denormal
    assert(илогб(0.125 * реал.min) == реал.min_exp - 4);
    assert(илогб(реал.infinity) == FP_ILOGBINFINITY);
	
	 дво x = -0x1.234_567A_AAAA_AAp+250;
    дво y = разбейЗначимое(x);
    assert(x == -0x1.234_5678p+250);
    assert(y == -0x0.000_000A_AAAA_A8p+248);
    assert(x + y == -0x1.234_567A_AAAA_AAp+250);
	
    assert( ellipticF(1, 0)==1);
    assert(ellipticEComplete(0)==1);
    assert(ellipticEComplete(1)==ПИ_2);
    assert(отнравх(ellipticKComplete(1),ПИ_2)>= реал.mant_dig-1);
    assert(ellipticKComplete(0)==реал.infinity);
//    assert(ellipticKComplete(1)==0); //-реал.infinity);
    
    реал q=0.5653L;
    assert(ellipticKComplete(1-q) == ellipticF(ПИ_2, q) );
    assert(ellipticEComplete(1-q) == ellipticE(ПИ_2, q) );
	
	assert(!битзнака(плав.nan));
    assert(битзнака(-плав.nan));
    assert(!битзнака(168.1234));
    assert(битзнака(-168.1234));
    assert(!битзнака(0.0));
    assert(битзнака(-0.0));
	
	assert(скалбн(-реал.infinity, 5) == -реал.infinity);
    assert(идентичен_ли(скалбн(НЧ(0xABC),7), НЧ(0xABC)));
	
	assert(идентичен_ли(фдим(НЧ(0xABC), 58.2), НЧ(0xABC)));
	
    assert(идентичен_ли(фабс(НЧ(0xABC)), НЧ(0xABC)));
	
	assert(экспи(1.3e5L) == cidrus.cosl(1.3e5L) + cidrus.sinl(1.3e5L) * 1i);
    assert(экспи(0.0L) == 1L + 0.0Li);
		
    assert(нч_ли(плав.nan));
    assert(нч_ли(-дво.nan));
    assert(нч_ли(реал.nan));

    assert(!нч_ли(53.6));
    assert(!нч_ли(плав.infinity));

    плав f = 3;
    дво d = 500;
    реал e = 10e+48;

    assert(норм_ли(f));
    assert(норм_ли(d));
    assert(норм_ли(e));
    f=d=e=0;
    assert(!норм_ли(f));
    assert(!норм_ли(d));
    assert(!норм_ли(e));
    assert(!норм_ли(реал.infinity));
    assert(норм_ли(-реал.max));
    assert(!норм_ли(реал.min/4));

    assert(идентичен_ли(0.0, 0.0));
    assert(!идентичен_ли(0.0, -0.0));
    assert(идентичен_ли(НЧ(0xABC), НЧ(0xABC)));
    assert(!идентичен_ли(НЧ(0xABC), НЧ(218)));
    assert(идентичен_ли(1.234e56, 1.234e56));
    assert(нч_ли(НЧ(0x12345)));
    assert(идентичен_ли(3.1 + НЧ(0xDEF) * 1i, 3.1 + НЧ(0xDEF)*1i));
    assert(!идентичен_ли(3.1+0.0i, 3.1-0i));
    assert(!идентичен_ли(0.0i, 2.5e58i));


    f = -плав.min;
    assert(!субнорм_ли(f));
    f/=4;
    assert(субнорм_ли(f));	
	
	дво f1;

    for (f1 = 1; !субнорм_ли(f1); f1 /= 2)
    assert(f1 != 0);
	
	реал f2;

    for (f2 = 1; !субнорм_ли(f2); f2 /= 2)
    assert(f2 != 0);
	
    assert(ноль_ли(0.0));
    assert(ноль_ли(-0.0));
    assert(!ноль_ли(2.5));
    assert(!ноль_ли(реал.min / 1000));	
	
    assert(беск_ли(плав.infinity));
    assert(!беск_ли(плав.nan));
    assert(беск_ли(дво.infinity));
    assert(беск_ли(-реал.infinity));

    assert(беск_ли(-1.0 / 0.0));
	
 static if (реал.mant_dig == 64) {

  // Tests for 80-битные reals

    assert(идентичен_ли(следщВыше(НЧ(0xABC)), НЧ(0xABC)));
    // negative numbers
    assert( следщВыше(-реал.infinity) == -реал.max );
    assert( следщВыше(-1-реал.epsilon) == -1.0 );
    assert( следщВыше(-2) == -2.0 + реал.epsilon);
    // denormals и zero
    assert( следщВыше(-реал.min) == -реал.min*(1-реал.epsilon) );
    assert( следщВыше(-реал.min*(1-реал.epsilon) == -реал.min*(1-2*реал.epsilon)) );
    assert( идентичен_ли(-0.0L, следщВыше(-реал.min*реал.epsilon)) );
    assert( следщВыше(-0.0) == реал.min*реал.epsilon );
    assert( следщВыше(0.0) == реал.min*реал.epsilon );
    assert( следщВыше(реал.min*(1-реал.epsilon)) == реал.min );
    assert( следщВыше(реал.min) == реал.min*(1+реал.epsilon) );
    // positive numbers
    assert( следщВыше(1) == 1.0 + реал.epsilon );
    assert( следщВыше(2.0-реал.epsilon) == 2.0 );
    assert( следщВыше(реал.max) == реал.infinity );
    assert( следщВыше(реал.infinity)==реал.infinity );
 }

    assert(идентичен_ли(следщДвоВыше(НЧ(0xABC)), НЧ(0xABC)));
    // negative numbers
    assert( следщДвоВыше(-дво.infinity) == -дво.max );
    assert( следщДвоВыше(-1-дво.epsilon) == -1.0 );
    assert( следщДвоВыше(-2) == -2.0 + дво.epsilon);
    // denormals и zero

    assert( следщДвоВыше(-дво.min) == -дво.min*(1-дво.epsilon) );
    assert( следщДвоВыше(-дво.min*(1-дво.epsilon) == -дво.min*(1-2*дво.epsilon)) );
    assert( идентичен_ли(-0.0, следщДвоВыше(-дво.min*дво.epsilon)) );
    assert( следщДвоВыше(0.0) == дво.min*дво.epsilon );
    assert( следщДвоВыше(-0.0) == дво.min*дво.epsilon );
    assert( следщДвоВыше(дво.min*(1-дво.epsilon)) == дво.min );
    assert( следщДвоВыше(дво.min) == дво.min*(1+дво.epsilon) );
    // positive numbers
    assert( следщДвоВыше(1) == 1.0 + дво.epsilon );
    assert( следщДвоВыше(2.0-дво.epsilon) == 2.0 );
    assert( следщДвоВыше(дво.max) == дво.infinity );

    assert(идентичен_ли(следщПлавВыше(НЧ(0xABC)), НЧ(0xABC)));
    assert( следщПлавВыше(-плав.min) == -плав.min*(1-плав.epsilon) );
    assert( следщПлавВыше(1.0) == 1.0+плав.epsilon );
    assert( следщПлавВыше(-0.0) == плав.min*плав.epsilon);
    assert( следщПлавВыше(плав.infinity)==плав.infinity );

    assert(следщНиже(1.0+реал.epsilon)==1.0);
    assert(следщДвоНиже(1.0+дво.epsilon)==1.0);
    assert(следщПлавНиже(1.0+плав.epsilon)==1.0);
    assert(следщза(1.0+реал.epsilon, -реал.infinity)==1.0);
	
   // Exact equality
   assert(отнравх(реал.max,реал.max)==реал.mant_dig);
   assert(отнравх(0.0L,0.0L)==реал.mant_dig);
   assert(отнравх(7.1824L,7.1824L)==реал.mant_dig);
   assert(отнравх(реал.infinity,реал.infinity)==реал.mant_dig);

   // a few биты away это exact equality
   реал w=1;
   for (цел i=1; i<реал.mant_dig-1; ++i) {
      assert(отнравх(1+w*реал.epsilon,1.0L)==реал.mant_dig-i);
      assert(отнравх(1-w*реал.epsilon,1.0L)==реал.mant_dig-i);
      assert(отнравх(1.0L,1+(w-1)*реал.epsilon)==реал.mant_dig-i+1);
      w*=2;
   }
   assert(отнравх(1.5+реал.epsilon,1.5L)==реал.mant_dig-1);
   assert(отнравх(1.5-реал.epsilon,1.5L)==реал.mant_dig-1);
   assert(отнравх(1.5-реал.epsilon,1.5+реал.epsilon)==реал.mant_dig-2);
   
   assert(отнравх(реал.min/8,реал.min/17)==3);;
   
   // Numbers that are закрой
   assert(отнравх(0x1.Bp+84, 0x1.B8p+84)==5);
   assert(отнравх(0x1.8p+10, 0x1.Cp+10)==2);
   assert(отнравх(1.5*(1-реал.epsilon), 1.0L)==2);
   assert(отнравх(1.5, 1.0)==1);
   assert(отнравх(2*(1-реал.epsilon), 1.0L)==1);

   // Factors of 2
   assert(отнравх(реал.max,реал.infinity)==0);
   assert(отнравх(2*(1-реал.epsilon), 1.0L)==1);
   assert(отнравх(1.0, 2.0)==0);
   assert(отнравх(4.0, 1.0)==0);

   // Extreme inequality
   assert(отнравх(реал.nan,реал.nan)==0);
   assert(отнравх(0.0L,-реал.nan)==0);
   assert(отнравх(реал.nan,реал.infinity)==0);
   assert(отнравх(реал.infinity,-реал.infinity)==0);
   assert(отнравх(-реал.max,реал.infinity)==0);
   assert(отнравх(реал.max,-реал.max)==0);
   
   // floats
   assert(отнравх(2.1f, 2.1f)==плав.mant_dig);
   assert(отнравх(1.5f, 1.0f)==1);
   
    e = копируйзнак(21, 23.8);
    assert(e == 21);

    e = копируйзнак(-21, 23.8);
    assert(e == 21);

    e = копируйзнак(21, -23.8);
    assert(e == -21);

    e = копируйзнак(-21, -23.8);
    assert(e == -21);

    e = копируйзнак(реал.nan, -23.8);
    assert(нч_ли(e) && битзнака(e));
	
	
	assert(и3еСреднее(-0.0,-1e-20)<0);
    assert(и3еСреднее(0.0,1e-20)>0);

    assert(и3еСреднее(1.0L,4.0L)==2L);
    assert(и3еСреднее(2.0*1.013,8.0*1.013)==4*1.013);
    assert(и3еСреднее(-1.0L,-4.0L)==-2L);
    assert(и3еСреднее(-1.0,-4.0)==-2);
    assert(и3еСреднее(-1.0f,-4.0f)==-2f);
    assert(и3еСреднее(-1.0,-2.0)==-1.5);
    assert(и3еСреднее(-1*(1+8*реал.epsilon),-2*(1+8*реал.epsilon))==-1.5*(1+5*реал.epsilon));
    assert(и3еСреднее(0x1p60,0x1p-10)==0x1p25);
    static if (реал.mant_dig==64) { // x87, 80-битные reals
      assert(и3еСреднее(1.0L,реал.infinity)==0x1p8192L);
      assert(и3еСреднее(0.0L,реал.infinity)==1.5);
    }
    assert(и3еСреднее(0.5*реал.min*(1-4*реал.epsilon),0.5*реал.min)==0.5*реал.min*(1-2*реал.epsilon));
	
	  реал nan4 = НЧ(0x789_ABCD_EF12_3456);
  static if (реал.mant_dig == 64 || реал.mant_dig==113) {
      assert (getNaNPayload(nan4) == 0x789_ABCD_EF12_3456);
  } else {
      assert (getNaNPayload(nan4) == 0x1_ABCD_EF12_3456);
	  дво nan5 = nan4;
	  assert (getNaNPayload(nan5) == 0x1_ABCD_EF12_3456);
	  плав nan6 = nan4;
	  assert (getNaNPayload(nan6) == 0x12_3456);
	  nan4 = НЧ(0xFABCD);
	  assert (getNaNPayload(nan4) == 0xFABCD);
	  nan6 = nan4;
	  assert (getNaNPayload(nan6) == 0xFABCD);
	  nan5 = НЧ(0x100_0000_0000_3456);
	  assert(getNaNPayload(nan5) == 0x0000_0000_3456);
    }
	
	
	цел numcalls=-4;
    // Extremely well-behaved function.
    реал parab(реал bestx) {
        ++numcalls;
        return 3 * (bestx-7.14L) * (bestx-7.14L) + 18;
    }
    реал minval;
    реал minx;
    // Note, performs extremely poorly if we have an перебор, so that the
    // function returns infinity. It might be better на_это explicitly deal with 
    // that situation (все parabolic fits will fail whenever an infinity is
    // present).
    minx = найдиМинимум(&parab, -квкор(реал.max), квкор(реал.max), 
        cast(реал)(плав.max), minval);
    assert(minval==18);
    assert(отнравх(minx,7.14L)>=плав.mant_dig);
   
     // Problems это Jack Crenshaw's "World's Наилучший Root Finder"
    // http://www.embedded.com/columns/programmerstoolbox/9900609
   // This имеется a minimum of кубкор(0.5).
   реал crenshawcos(реал x) { return кос(2*ПИ*x*x*x); }
   minx = найдиМинимум(&crenshawcos, 0.0L, 1.0L, 0.1L, minval);
   assert(отнравх(minx*minx*minx, 0.5L)<=реал.mant_dig-4);
   
   
       // Radix conversion
    assert( БольшЦел("-1_234_567_890_123_456_789").вДесятичнТкст 
        == "-1234567890123456789");
    assert( БольшЦел("0x1234567890123456789").вГекс == "123_45678901_23456789");
    assert( БольшЦел("0x00000000000000000000000000000000000A234567890123456789").вГекс
        == "A23_45678901_23456789");
    assert( БольшЦел("0x000_00_000000_000_000_000000000000_000000_").вГекс == "0");
    
    assert(БольшЦел(-0x12345678).вЦел() == -0x12345678);
    assert(БольшЦел(-0x12345678).вДол() == -0x12345678);
    static if (реал.mant_dig == 32) assert(БольшЦел(0x1234_5678_9ABC_5A5AL).вДол() == 0x1234_5678_9ABC_5A5AL); 
    assert(БольшЦел(0xF234_5678_9ABC_5A5AL).вДол() == дол.max);
    assert(БольшЦел(-0x123456789ABCL).вЦел() == -цел.max);
	
	 // Wronksian тест for Bessel functions
    проц testWronksian(цел n, реал x)
    {
      реал Jnp1 = cylBessel_jn(n + 1, x);
      реал Jmn = cylBessel_jn(-n, x);
      реал Jn = cylBessel_jn(n, x);
      реал Jmnp1 = cylBessel_jn(-(n + 1), x);
      /* This should be trivially zero.  */
      assert( фабс(Jnp1 * Jmn + Jn * Jmnp1) == 0);
      if (x < 0.0) {
          x = -x;
          Jn = cylBessel_jn(n, x);
          Jnp1 = cylBessel_jn(n + 1, x);
      }
      реал Yn = cylBessel_yn(n, x);
      реал Ynp1 = cylBessel_yn(n + 1, x);
      /* The Wronksian.  */
      реал w1 = Jnp1 * Yn - Jn * Ynp1;
      /* What the Wronksian should be. */
      реал w2 = 2.0 / (ПИ * x);

      реал reldif = отнравх(w1, w2);
      assert(reldif >= реал.mant_dig-6);
    }

  реал delta;
  цел n, i, j;

  delta = 0.6 / ПИ;
  for (n = -30; n <= 30; n++) {
    реал x1 = -30.0;
    while (x1 < 30.0)    {
        testWronksian (n, x1);
        x1 += delta;
    }
    delta += .00123456;
  }
  assert(cylBessel_jn(20, 1e-80)==0);
  
      // НЧ propagation
    assert(идентичен_ли(cylBessel_i1(НЧ(0xDEF)), НЧ(0xDEF)));
    assert(идентичен_ли(cylBessel_i0(НЧ(0x846)), НЧ(0x846)));
	
	//Values это Excel's GammaInv(1-p, x, 1)
assert(фабс(gammaIncompleteComplInv(1, 0.5) - 0.693147188044814) < 0.00000005);
assert(фабс(gammaIncompleteComplInv(12, 0.99) - 5.42818075054289) < 0.00000005);
assert(фабс(gammaIncompleteComplInv(100, 0.8) - 91.5013985848288L) < 0.000005);

assert(гаммаНеполная(1, 0)==0);
assert(gammaIncompleteCompl(1, 0)==1);
assert(гаммаНеполная(4545, реал.infinity)==1);

// Values это Excel's (1-GammaDist(x, alpha, 1, TRUE))

assert(фабс(1.0L-gammaIncompleteCompl(0.5, 2) - 0.954499729507309L) < 0.00000005);
assert(фабс(гаммаНеполная(0.5, 2) - 0.954499729507309L) < 0.00000005);
// Fixed Cephes bug:
assert(gammaIncompleteCompl(384, реал.infinity)==0);
assert(gammaIncompleteComplInv(3, 0)==реал.infinity);

 // проверь НЧ propagation
  assert(идентичен_ли(бетаНеполная(НЧ(0xABC),2,3), НЧ(0xABC)));
  assert(идентичен_ли(бетаНеполная(7,НЧ(0xABC),3), НЧ(0xABC)));
  assert(идентичен_ли(бетаНеполная(7,15,НЧ(0xABC)), НЧ(0xABC)));
  assert(идентичен_ли(бетаНеполнаяИнв(НЧ(0xABC),1,17), НЧ(0xABC)));
  assert(идентичен_ли(бетаНеполнаяИнв(2,НЧ(0xABC),8), НЧ(0xABC)));
  assert(идентичен_ли(бетаНеполнаяИнв(2,3, НЧ(0xABC)), НЧ(0xABC)));

  assert(нч_ли(бетаНеполная(-1, 2, 3)));

  assert(бетаНеполная(1, 2, 0)==0);
  assert(бетаНеполная(1, 2, 1)==1);
  assert(нч_ли(бетаНеполная(1, 2, 3)));
  assert(бетаНеполнаяИнв(1, 1, 0)==0);
  assert(бетаНеполнаяИнв(1, 1, 1)==1);

  // Test some значения against Microsoft Excel 2003.

  assert(фабс(бетаНеполная(8, 10, 0.2) - 0.010_934_315_236_957_2L) < 0.000_000_000_5);
  assert(фабс(бетаНеполная(2, 2.5, 0.9) - 0.989_722_597_604_107L) < 0.000_000_000_000_5);
  assert(фабс(бетаНеполная(1000, 800, 0.5) - 1.17914088832798E-06L) < 0.000_000_05e-6);

  assert(фабс(бетаНеполная(0.0001, 10000, 0.0001) - 0.999978059369989L) < 0.000_000_000_05);

  assert(фабс(бетаНеполнаяИнв(5, 10, 0.2) - 0.229121208190918L) < 0.000_000_5L);
  assert(фабс(бетаНеполнаяИнв(4, 7, 0.8) - 0.483657360076904L) < 0.000_000_5L);

    // Coverage tests. I don't have correct значения for these tests, but
    // these значения cover most of the код, so they are useful for
    // regression testing.
    // Extensive testing failed на_это increase the coverage. It seems likely that about
    // half the код in this function is unnecessary; there is potential for
    // significant improvement over the original CEPHES код.

// Excel 2003 gives clearly erroneous results (betadist>1) when a и x are tiny и b is huge.
// The correct results are for these следщ tests are неизвестное.

//    реал testpoint1 = бетаНеполная(1e-10, 5e20, 8e-21);
//    assert(testpoint1 == 0x1.ffff_ffff_c906_404cp-1L);

    assert(бетаНеполная(0.01, 327726.7, 0.545113) == 1.0);
    assert(бетаНеполнаяИнв(0.01, 8e-48, 5.45464e-20)==1-реал.epsilon);
    assert(бетаНеполнаяИнв(0.01, 8e-48, 9e-26)==1-реал.epsilon);

    assert(бетаНеполная(0.01, 498.437, 0.0121433) == 0x1.ffff_8f72_19197402p-1);
    assert(1- бетаНеполная(0.01, 328222, 4.0375e-5) == 0x1.5f62926b4p-30);
    version(FailsOnLinux)  assert(бетаНеполнаяИнв(0x1.b3d151fbba0eb18p+1, 1.2265e-19, 2.44859e-18)==0x1.c0110c8531d0952cp-1);
    version(FailsOnLinux)  assert(бетаНеполнаяИнв(0x1.ff1275ae5b939bcap-41, 4.6713e18, 0.0813601)==0x1.f97749d90c7adba8p-63);
    реал a1;
    a1 = 3.40483;
    version(FailsOnLinux)  assert(бетаНеполнаяИнв(a1, 4.0640301659679627772e19L, 0.545113)== 0x1.ba8c08108aaf5d14p-109);
    реал b1;
    b1= 2.82847e-25;
    version(FailsOnLinux)  assert(бетаНеполнаяИнв(0.01, b1, 9e-26) == 0x1.549696104490aa9p-830);

    // --- Problematic cases ---
    // This is a situation where the series expansion fails на_это converge
    assert( нч_ли(бетаНеполнаяИнв(0.12167, 4.0640301659679627772e19L, 0.0813601)));
    // This следщ результат is almost certainly erroneous.
    assert(бетаНеполная(1.16251e20, 2.18e39, 5.45e-20)==-реал.infinity);
	
	
	assert(идентичен_ли(бета(НЧ(0xABC), 4), НЧ(0xABC)));
    assert(идентичен_ли(бета(2, НЧ(0xABC)), НЧ(0xABC)));
	
	    assert(идентичен_ли(логГаммы(НЧ(0xDEF)), НЧ(0xDEF)));
    assert(логГаммы(реал.infinity) == реал.infinity);
    assert(логГаммы(-1.0) == реал.infinity);
    assert(логГаммы(0.0) == реал.infinity);
    assert(логГаммы(-50.0) == реал.infinity);
    assert(идентичен_ли(0.0L, логГаммы(1.0L)));
    assert(идентичен_ли(0.0L, логГаммы(2.0L)));
    assert(логГаммы(реал.min*реал.epsilon) == реал.infinity);
    assert(логГаммы(-реал.min*реал.epsilon) == реал.infinity);

    // x, correct loggamma(x), correct d/dx loggamma(x).
    static реал[] testpoints = [
    8.0L,                    8.525146484375L      + 1.48766904143001655310E-5,   2.01564147795560999654E0L,
    8.99993896484375e-1L,    6.6375732421875e-2L  + 5.11505711292524166220E-6L, -7.54938684259372234258E-1,
    7.31597900390625e-1L,    2.2369384765625e-1   + 5.21506341809849792422E-6L, -1.13355566660398608343E0L,
    2.31639862060546875e-1L, 1.3686676025390625L  + 1.12609441752996145670E-5L, -4.56670961813812679012E0,
    1.73162841796875L,      -8.88214111328125e-2L + 3.36207740803753034508E-6L, 2.33339034686200586920E-1L,
    1.23162841796875L,      -9.3902587890625e-2L  + 1.28765089229009648104E-5L, -2.49677345775751390414E-1L,
    7.3786976294838206464e19L,   3.301798506038663053312e21L - 1.656137564136932662487046269677E5L,
                          4.57477139169563904215E1L,
    1.08420217248550443401E-19L, 4.36682586669921875e1L + 1.37082843669932230418E-5L,
                         -9.22337203685477580858E18L,
    1.0L, 0.0L, -5.77215664901532860607E-1L,
    2.0L, 0.0L, 4.22784335098467139393E-1L,
    -0.5L,  1.2655029296875L    + 9.19379714539648894580E-6L, 3.64899739785765205590E-2L,
    -1.5L,  8.6004638671875e-1L + 6.28657731014510932682E-7L, 7.03156640645243187226E-1L,
    -2.5L, -5.6243896484375E-2L + 1.79986700949327405470E-7,  1.10315664064524318723E0L,
    -3.5L,  -1.30902099609375L  + 1.43111007079536392848E-5L, 1.38887092635952890151E0L
    ];
   // TODO: тест derivatives as well.
    for (i=0; i<testpoints.length; i+=3) {
        assert( отнравх(логГаммы(testpoints[i]), testpoints[i+1]) > реал.mant_dig-5);
        if (testpoints[i]<МАКСГАММА) {
            assert( отнравх(лог(фабс(гамма(testpoints[i]))), testpoints[i+1]) > реал.mant_dig-5);
        }
    }
    assert(логГаммы(-50.2) == лог(фабс(гамма(-50.2))));
    assert(логГаммы(-0.008) == лог(фабс(гамма(-0.008))));
    assert(отнравх(логГаммы(-38.8),лог(фабс(гамма(-38.8)))) > реал.mant_dig-4);
    assert(отнравх(логГаммы(1500.0L),лог(гамма(1500.0L))) > реал.mant_dig-2);
	
	
	    // гамма(n) = factorial(n-1) if n is an целое.
    реал fact = 1.0L;
    for (i=1; fact<реал.max; ++i) {
        // Require exact equality for small factorials
        if (i<14) assert(гамма(i*1.0L) == fact);
        version(FailsOnLinux) assert(отнравх(гамма(i*1.0L), fact) > реал.mant_dig-15);
        fact *= (i*1.0L);
    }
    assert(гамма(0.0) == реал.infinity);
    assert(гамма(-0.0) == -реал.infinity);
    assert(нч_ли(гамма(-1.0)));
    assert(нч_ли(гамма(-15.0)));
    assert(идентичен_ли(гамма(НЧ(0xABC)), НЧ(0xABC)));
    assert(гамма(реал.infinity) == реал.infinity);
    assert(гамма(реал.max) == реал.infinity);
    assert(нч_ли(гамма(-реал.infinity)));
    assert(гамма(реал.min*реал.epsilon) == реал.infinity);
    assert(гамма(МАКСГАММА)< реал.infinity);
    assert(гамма(МАКСГАММА*2) == реал.infinity);

    // Test some high-precision значения (50 decimal цифры)
    const реал SQRT_PI = 1.77245385090551602729816748334114518279754945612238L;

    version(FailsOnLinux) assert(отнравх(гамма(0.5L), SQRT_PI) == реал.mant_dig);

    assert(отнравх(гамма(1.0/3.L),  2.67893853470774763365569294097467764412868937795730L) >= реал.mant_dig-2);
    assert(отнравх(гамма(0.25L),
        3.62560990822190831193068515586767200299516768288006L) >= реал.mant_dig-1);
    assert(отнравх(гамма(1.0/5.0L),
        4.59084371199880305320475827592915200343410999829340L) >= реал.mant_dig-1);
		
	
	assert(знакГаммы(5.0) == 1.0);
    assert(нч_ли(знакГаммы(-3.0)));
    assert(знакГаммы(-0.1) == -1.0);
    assert(знакГаммы(-55.1) == 1.0);
    assert(нч_ли(знакГаммы(-реал.infinity)));
    assert(идентичен_ли(знакГаммы(НЧ(0xABC)), НЧ(0xABC)));
	

	скажинс("Батюшки да родные - всё ничтяк!!!!! (Дошли да края без запинок.)");
	пауза;
	 }