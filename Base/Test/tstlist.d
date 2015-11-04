import col.List, stdrus;

void main(){
    скажинс("----список tests----");

   Список!(цел) спис;// = new Список!(цел);
      assert(спис.пуст());

    спис.opCatAssign(1);
    assert(! спис.пуст());
    спис.приставь(2);
    спис ~= 3;
    спис.приставь(4);
    спис ~= 5;

    assert(! спис.пуст());

    char[] o;
    foreach(i; спис) {
        o ~= фм(i);
    }
    assert(o == "12345");
    o = пусто;
    foreach_reverse(i; спис) {
        o ~= фм(i);
    }
    assert(o == "54321");

         o=пусто;
        auto it=спис.начало(),конец=спис.конец();
        for(; it != конец; ++it) {
            o ~= фм(it.знач);
        }
        assert(o == "12345");

        o = пусто;
        auto it=спис.начало_рев(),конец=спис.конец_рев();
        for(; it != конец; ++it) {
            o ~= фм(it.знач);
        }
        assert(o == "54321");
        

    // opIn_r tests //

    for (цел i=1; i<=5; i++) {
        assert(i in спис);
    }
    assert(!(99 in спис));
    assert(!(0 in спис));

    assert(спис.последний == 5);
    assert(спис.первый == 1);

   auto it = спис.найди(99);
        assert(it==спис.конец());
        for (цел i=1; i<=5; i++) {
            it = спис.найди(i);
            assert(it!=спис.конец());
            assert(it.знач == i);
            assert(*it.укз == i);
        }

    скажинс("----список tests complete ----");
    }
