/*******************************************************************************

        copyright:      Copyright (C) 1997--2004, Makoto Matsumoto,
                        Takuji Nishimura, и Eric Landry; все rights reserved
        

        license:        BSD стиль: $(LICENSE)

        version:        Jan 2008: Initial release

        author:         KeYeR (D interface) keyer@team0xf.com
                        fawzi (преобразованый в_ движок)
      
*******************************************************************************/

module math.random.engines.Twister;
private import Целое = text.convert.Integer;

/*******************************************************************************

        Wrapper for the Mersenne twister.
        
        The Mersenne twister is a pseudorandom число generator linked в_
        CR developed in 1997 by Makoto Matsumoto и Takuji Nishimura that
        is based on a matrix linear recurrence over a finite binary field
        F2. It provопрes for fast generation of very high quality pseudorandom
        numbers, having been designed specifically в_ rectify many of the 
        flaws найдено in older algorithms.
        
        Mersenne Твистер имеется the following desirable свойства:
        ---
        1. It was designed в_ have a период of 2^19937 - 1 (the creators
           of the algorithm proved this property).
           
        2. It имеется a very high order of dimensional equопрistribution.
           This implies that there is negligible serial correlation between
           successive значения in the вывод sequence.
           
        3. It проходки numerous tests for statistical randomness, включая
           the stringent Diehard tests.
           
        4. It is fast.
        ---

*******************************************************************************/

struct Твистер
{
    private enum : бцел {
        // Period параметры
        N          = 624,
        M          = 397,
        MATRIX_A   = 0x9908b0df,        // constant вектор a 
        UPPER_MASK = 0x80000000,        //  most significant w-r биты 
        LOWER_MASK = 0x7fffffff,        // least significant r биты
    }
    const цел canCheckpoint=да;
    const цел можноСеять=да;

    private бцел[N] mt;                     // the Массив for the состояние вектор  
    private бцел mti=mt.length+1;           // mti==mt.length+1 means mt[] is not инициализован 
    
    /// returns a random бцел
    бцел следщ ()
    {
        бцел y;
        static бцел mag01[2] =[0, MATRIX_A];

        if (mti >= mt.length) { 
            цел kk;

            for (kk=0;kk<mt.length-M;kk++)
            {
                y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
                mt[kk] = mt[kk+M] ^ (y >> 1) ^ mag01[y & 1U];
            }
            for (;kk<mt.length-1;kk++) {
                y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
                mt[kk] = mt[kk+(M-mt.length)] ^ (y >> 1) ^ mag01[y & 1U];
            }
            y = (mt[mt.length-1]&UPPER_MASK)|(mt[0]&LOWER_MASK);
            mt[mt.length-1] = mt[M-1] ^ (y >> 1) ^ mag01[y & 1U];

            mti = 0;
        }

        y = mt[mti++];

        y ^= (y >> 11);
        y ^= (y << 7)  &  0x9d2c5680UL;
        y ^= (y << 15) &  0xefc60000UL;
        y ^= (y >> 18);

        return y;
    }
    /// returns a random байт
    ббайт следщБ(){
        return cast(ббайт)(следщ() & 0xFF);
    }
    /// returns a random дол
    бдол следщД(){
        return ((cast(бдол)следщ)<<32)+cast(бдол)следщ;
    }
    
    /// initializes the generator with a бцел as сей
    проц сей (бцел s)
    {
        mt[0]= s & 0xffff_ffffU;  // this is very suspicious, was the previous строка incorrectly translated из_ C???
        for (mti=1; mti<mt.length; mti++){
            mt[mti] = cast(бцел)(1812433253UL * (mt[mti-1] ^ (mt[mti-1] >> 30)) + mti);
            mt[mti] &= 0xffff_ffffUL; // this is very suspicious, was the previous строка incorrectly translated из_ C???
        }
    }
    /// добавьs entropy в_ the generator
    проц добавьЭнтропию(бцел delegate() r){
        цел i, j, k;
        i=1;
        j=0;

        for (k = mt.length; k; k--)   {
            mt[i] = cast(бцел)((mt[i] ^ ((mt[i-1] ^ (mt[i-1] >> 30)) * 1664525UL))+ r() + j); 
            mt[i] &=  0xffff_ffffUL;  // this is very suspicious, was the previous строка incorrectly translated из_ C???
            i++;
            j++;

            if (i >= mt.length){
                    mt[0] = mt[mt.length-1];
                    i=1;
            }
        }

        for (k=mt.length-1; k; k--)     {
            mt[i] = cast(бцел)((mt[i] ^ ((mt[i-1] ^ (mt[i-1] >> 30)) * 1566083941UL))- i); 
            mt[i] &=  0xffffffffUL;  // this is very suspicious, was the previous строка incorrectly translated из_ C???
            i++;

            if (i>=mt.length){
                    mt[0] = mt[mt.length-1];
                    i=1;
            }
        }
        mt[0] |=  0x80000000UL; 
        mti=0;
    }
    /// seeds the generator
    проц сей(бцел delegate() r){
        сей (19650218UL);
        добавьЭнтропию(r);
    }
    /// записывает текущ статус в ткст
    ткст вТкст(){
        ткст рез=new сим[7+(N+1)*9];
        цел i=0;
        рез[i..i+7]="Твистер";
        i+=7;
        рез[i]='_';
        ++i;
        Целое.форматируй(рез[i..i+8],mti,"x8");
        i+=8;
        foreach (знач;mt){
            рез[i]='_';
            ++i;
            Целое.форматируй(рез[i..i+8],знач,"x8");
            i+=8;
        }
        assert(i==рез.length,"неожиданный размер");
        return рез;
    }
    /// считывает текущ статус в ткст (его следует обработать)
    /// возвращает число считанных символов
    т_мера изТкст(ткст s){
        т_мера i;
        assert(s[0..7]=="Твистер","неожиданный вид, ожидался Твистер");
        i+=7;
        assert(s[i]=='_',"не найден разделитель _");
        ++i;
        бцел ate;
        mti=cast(бцел)Целое.преобразуй(s[i..i+8],16,&ate);
        assert(ate==8,"неожиданный читай размер");
        i+=8;
        foreach (ref знач;mt){
            assert(s[i]=='_',"не найден разделитель _");
            ++i;
            знач=cast(бцел)Целое.преобразуй(s[i..i+8],16,&ate);
            assert(ate==8,"неожиданный считанный размер");
            i+=8;
        }
        return i;
    }
    
}

