
import core.Array;

int main()
{

     проц basic( ткст буф )
        {
            if( буф.length < 2 )
                return;

            т_мера  поз = 0,
                    конец = буф.length - 1;

            while( поз <= ( конец - 1 ) / 2 )
            {
                assert( буф[поз] >= буф[2 * поз + 1] );
                if( 2 * поз + 1 < конец )
                {
                    assert( буф[поз] >= буф[2 * поз + 2] );
                }
                ++поз;
            }
        }

        проц тест( ткст буф )
        {
            сделайКучу( буф );
            basic( буф );
        }

        тест( "mkcvalsопрivjoaisjdvmzlksvdjioawmdsvmsdfefewv".dup );
        тест( "asdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdf".dup );
        тест( "the быстро brown fox jumped over the lazy dog".dup );
        тест( "abcdefghijklmnopqrstuvwxyz".dup );
        тест( "zyxwvutsrqponmlkjihgfedcba".dup );
        тест( "ba".dup );
        тест( "a".dup );
        тест( "".dup );      
    return 0;
}