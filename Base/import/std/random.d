module std.random;

extern(D):

    проц случсей(бцел семя, бцел индекс);
    бцел случайно();
    бцел случген(бцел семя, бцел индекс, реал члоциклов);

alias случсей rand_seed;
alias случайно rand;
alias случген randomGen;
		