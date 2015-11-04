import dinrus, util.pathex, util.series;

проц main(){
    Серии a;
    assert( a.следщ == 0);
    assert( a.следщ == 1);
    assert( a.следщ == 2);
    assert( a.тек == 3);
    a.прирасти = 2;
    assert( a.следщ == 3);
    assert( a.следщ == 5);
    assert( a.предш == 5);
    a.следщ = 100;
    assert( a.тек == 100);
    assert( a.следщ == 100);
    assert( a.следщ == 102);
	скажинс("Серии проверены");
скажинс("Путь к программе: "~дайТекПап());
выход(0);
}

