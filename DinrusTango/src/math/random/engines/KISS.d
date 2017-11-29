/*******************************************************************************
        copyright:      Copyright (c) 2008. Fawzi Mohamed
        license:        BSD стиль: $(LICENSE)
        version:        Initial release: July 2008
        author:         Fawzi Mohamed
*******************************************************************************/
module math.random.engines.KISS;
private import Целое = text.convert.Integer;

/+ Kiss99 random число generator, by Marisaglia
+ a simple RNG that проходки все statistical tests
+ This is the движок, *never* use it directly, always use it though a СлуччисГ class
+/
struct Kiss99{
    private бцел kiss_x = 123456789;
    private бцел kiss_y = 362436000;
    private бцел kiss_z = 521288629;
    private бцел kiss_c = 7654321;
    private бцел nBytes = 0;
    private бцел restB  = 0;
    
    const цел canCheckpoint=да;
    const цел можноСеять=да;
    
    проц пропусти(бцел n){
        for (цел i=n;i!=n;--i){
            следщ;
        }
    }
    ббайт следщБ(){
        if (nBytes>0) {
            ббайт рез=cast(ббайт)(restB & 0xFF);
            restB >>= 8;
            --nBytes;
            return рез;
        } else {
            restB=следщ;
            ббайт рез=cast(ббайт)(restB & 0xFF);
            restB >>= 8;
            nBytes=3;
            return рез;
        }
    }
    бцел следщ(){
        const бдол a = 698769069UL;
        бдол t;
        kiss_x = 69069*kiss_x+12345;
        kiss_y ^= (kiss_y<<13); kiss_y ^= (kiss_y>>17); kiss_y ^= (kiss_y<<5);
        t = a*kiss_z+kiss_c; kiss_c = cast(бцел)(t>>32);
        kiss_z=cast(бцел)t;
        return kiss_x+kiss_y+kiss_z;
    }
    бдол следщД(){
        return ((cast(бдол)следщ)<<32)+cast(бдол)следщ;
    }
    
    проц сей(бцел delegate() r){
        kiss_x = r();
        for (цел i=0;i<100;++i){
            kiss_y=r();
            if (kiss_y!=0) break;
        }
        if (kiss_y==0) kiss_y=362436000;
        kiss_z=r();
        /* Don’t really need в_ сей c as well (is сбрось after a следщ),
           but doing it allows в_ completely restore a given internal состояние */
        kiss_c = r() % 698769069; /* Should be less than 698769069 */
        nBytes = 0;
        restB=0;
    }
    /// записывает текущ статус в ткст
    ткст вТкст(){
        ткст рез=new сим[6+6*9];
        цел i=0;
        рез[i..i+6]="KISS99";
        i+=6;
        foreach (знач;[kiss_x,kiss_y,kiss_z,kiss_c,nBytes,restB]){
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
        т_мера i=0;
        assert(s[i..i+4]=="KISS","неожиданный вид, ожидался KISS");
        assert(s[i+4..i+7]=="99_","неожиданная версия, ожидалась 99");
        i+=6;
        foreach (знач;[&kiss_x,&kiss_y,&kiss_z,&kiss_c,&nBytes,&restB]){
            assert(s[i]=='_',"не найден разделитель _ ");
            ++i;
            бцел ate;
            *знач=cast(бцел)Целое.преобразуй(s[i..i+8],16,&ate);
            assert(ate==8,"неожиданный считанный размер");
            i+=8;
        }
        return i;
    }
}
