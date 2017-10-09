
module std.random;
import std.x.random;

export extern(D):

    проц случсей(бцел семя, бцел индекс){std.x.random.rand_seed(cast(бцел) семя, cast(бцел) индекс);}
    бцел случайно(){return cast(бцел) std.x.random.rand();}
    бцел случген(бцел семя, бцел индекс, реал члоциклов)
        {
        return cast(бцел) std.x.random.randomGen(cast(бцел) семя, cast(бцел) индекс, cast(бцел) члоциклов);
        }
