/*******************************************************************************

        A Провод that ignores все that is записано в_ it
        
        copyright:      Copyright (c) 2008. Fawzi Mohamed
        
        license:        BSD стиль: $(LICENSE)
        
        version:        Initial release: July 2008
        
        author:         Fawzi Mohamed

*******************************************************************************/

module io.device.BitBucket;

private import io.device.Conduit;

/*******************************************************************************

        A Провод that ignores все that is записано в_ it and returns Кф
        when читай из_. Note that пиши() returns the length of what was
        handed в_ it, acting as a pure bit-bucket. Returning zero or Кф
        instead would not be appropriate in this контекст.

*******************************************************************************/

class BitBucket : Провод
{
        override ткст вТкст () {return "<bitbucket>";} 

        override т_мера размерБуфера () { return 0;}

        override т_мера читай (проц[] приёмн) { return Кф; }

        override т_мера пиши (проц[] ист) { return ист.length; }

        override проц открепи () { }
}



debug(UnitTest)
{
    unittest{
        auto a=new BitBucket;
        a.пиши("bla");
        a.слей();
        a.открепи();
        a.пиши("b"); // at the moment it works, disallow?
        бцел[4] b=0;
        a.читай(b);
        foreach (el;b)
            assert(el==0);
    }
}
