module dwtx.dwtxhelper.Random;

static import tango.math.random.Kiss;

class Random {
    tango.math.random.Kiss.Kiss kiss;

    public this(int seed ){
        kiss.seed(seed);
    }
    public bool  nextBoolean(){
        return kiss.toInt(2) is 0;
    }
}


