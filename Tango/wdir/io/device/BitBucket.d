module io.device.BitBucket;

private import io.device.Conduit;



class Битник : Провод
{


        override ткст вТкст () {return "<битник>";} 

        override т_мера размерБуфера () { return 0;}

        override т_мера читай (проц[] приёмн) { return Кф; }

        override т_мера пиши (проц[] ист) { return ист.length; }

        override проц открепи () { }
}



debug(UnitTest)
{
    unittest{
        auto a=new Битник;
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
