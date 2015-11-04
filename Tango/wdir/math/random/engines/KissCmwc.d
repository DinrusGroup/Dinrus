/*******************************************************************************
        copyright:      Copyright (c) 2008. Fawzi Mohamed
        license:        BSD стиль: $(LICENSE)
        version:        Initial release: July 2008
        author:         Fawzi Mohamed
*******************************************************************************/
module math.random.engines.KissCmwc;
private import Целое = text.convert.Integer;

/+ CMWC и KISS random число generators combined, for extra security wrt. plain CMWC и
+ Marisaglia, Journal of Modern Applied Statistical Methods (2003), vol.2,No.1,p 2-13
+ a simple safe и fast RNG that проходки все statistical tests, имеется a large сей, и is reasonably fast
+ This is the движок, *never* use it directly, always use it though a СлуччисГ class
+/
struct KissCmwc(бцел cmwc_r=1024U,бдол cmwc_a=987769338UL){
    бцел[cmwc_r] cmwc_q=void;
    бцел cmwc_i=cmwc_r-1u;
    бцел cmwc_c=123;
    private бцел kiss_x = 123456789;
    private бцел kiss_y = 362436000;
    private бцел kiss_z = 521288629;
    private бцел kiss_c = 7654321;
    бцел nBytes = 0;
    бцел restB  = 0;

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
        const бцел rMask=cmwc_r-1u;
        static assert((rMask&cmwc_r)==0,"cmwc_r должен быть кратен 2"); // помести a ещё stringent тест?
        const бцел m=0xFFFF_FFFE;
        cmwc_i=(cmwc_i+1)&rMask;
        бдол t=cmwc_a*cmwc_q[cmwc_i]+cmwc_c;
        cmwc_c=cast(бцел)(t>>32);
        бцел x=cast(бцел)t+cmwc_c;
        if (x<cmwc_c) {
            ++x; ++cmwc_c;
        }
        const бдол a = 698769069UL;
        бдол k_t;
        kiss_x = 69069*kiss_x+12345;
        kiss_y ^= (kiss_y<<13); kiss_y ^= (kiss_y>>17); kiss_y ^= (kiss_y<<5);
        k_t = a*kiss_z+kiss_c; kiss_c = cast(бцел)(k_t>>32);
        kiss_z=cast(бцел)k_t;
        return (cmwc_q[cmwc_i]=m-x)+kiss_x+kiss_y+kiss_z; // xor в_ avoопр перебор?
    }
    
    бдол следщД(){
        return ((cast(бдол)следщ)<<32)+cast(бдол)следщ;
    }
    
    проц сей(бцел delegate() слСемя){
        cmwc_i=cmwc_r-1u; // рандомируй also this?
        for (цел ii=0;ii<10;++ii){
            for (бцел i=0;i<cmwc_r;++i){
                cmwc_q[i]=слСемя();
            }
            бцел nV=слСемя();
            бцел в_=(бцел.max/cmwc_a)*cmwc_a;
            for (цел i=0;i<10;++i){
                if (nV<в_) break;
                nV=слСемя();
            }
            cmwc_c=cast(бцел)(nV%cmwc_a);
            nBytes = 0;
            restB=0;
            if (cmwc_c==0){
                for (бцел i=0;i<cmwc_r;++i)
                    if (cmwc_q[i]!=0) return;
            } else if (cmwc_c==cmwc_a-1){
                for (бцел i=0;i<cmwc_r;++i)
                    if (cmwc_q[i]!=0xFFFF_FFFF) return;
            } else return;
        }
        cmwc_c=1;
        kiss_x = слСемя();
        for (цел i=0;i<100;++i){
            kiss_y=слСемя();
            if (kiss_y!=0) break;
        }
        if (kiss_y==0) kiss_y=362436000;
        kiss_z=слСемя();
        /* Don’t really need в_ сей c as well (is сбрось after a следщ),
           but doing it allows в_ completely restore a given internal состояние */
        kiss_c = слСемя() % 698769069; /* Should be less than 698769069 */
    }
    /// записывает текущ статус в ткст
    ткст вТкст(){
        ткст рез=new сим[11+16+(cmwc_r+9)*9];
        цел i=0;
        рез[i..i+11]="CMWC+KISS99";
        i+=11;
        Целое.форматируй(рез[i..i+16],cmwc_a,"x16");
        i+=16;
        рез[i]='_';
        ++i;
        Целое.форматируй(рез[i..i+8],cmwc_r,"x8");
        i+=8;
        foreach (знач;cmwc_q){
            рез[i]='_';
            ++i;
            Целое.форматируй(рез[i..i+8],знач,"x8");
            i+=8;
        }
        foreach (знач;[cmwc_i,cmwc_c,nBytes,restB,kiss_x,kiss_y,kiss_z,kiss_c]){
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
        сим[16] tmpC;
        т_мера i=0;
        assert(s[i..i+11]=="CMWC+KISS99","неожиданный вид, ожидался CMWC+KISS99");
        i+=11;
        assert(s[i..i+16]==Целое.форматируй(tmpC,cmwc_a,"x16"),"неожиданный cmwc_a");
        i+=16;
        assert(s[i]=='_',"неожиданный формат, ожидался _");
        i++;
        assert(s[i..i+8]==Целое.форматируй(tmpC,cmwc_r,"x8"),"неожиданный cmwc_r");
        i+=8;
        foreach (ref знач;cmwc_q){
            assert(s[i]=='_',"не найден сепаратор _ ");
            ++i;
            бцел ate;
            знач=cast(бцел)Целое.преобразуй(s[i..i+8],16,&ate);
            assert(ate==8,"неожиданный считанный размер");
            i+=8;
        }
        foreach (знач;[&cmwc_i,&cmwc_c,&nBytes,&restB,&kiss_x,&kiss_y,&kiss_z,&kiss_c]){
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

/// some variations of the CMWC часть, the первый имеется a период of ~10^39461
/// the первый число (r) is basically the размер of the сей и storage (и все bit образцы
/// of that размер are guarenteed в_ crop up in the период), the период is (2^32-1)^r*a
alias KissCmwc!(4096U,18782UL)     KissCmwc_4096_1;
alias KissCmwc!(2048U,1030770UL)   KissCmwc_2048_1;
alias KissCmwc!(2048U,1047570UL)   KissCmwc_2048_2;
alias KissCmwc!(1024U,5555698UL)   KissCmwc_1024_1;
alias KissCmwc!(1024U,987769338UL) KissCmwc_1024_2;
alias KissCmwc!(512U,123462658UL)  KissCmwc_512_1;
alias KissCmwc!(512U,123484214UL)  KissCmwc_512_2;
alias KissCmwc!(256U,987662290UL)  KissCmwc_256_1;
alias KissCmwc!(256U,987665442UL)  KissCmwc_256_2;
alias KissCmwc!(128U,987688302UL)  KissCmwc_128_1;
alias KissCmwc!(128U,987689614UL)  KissCmwc_128_2;
alias KissCmwc!(64U ,987651206UL)  KissCmwc_64_1;
alias KissCmwc!(64U ,987657110UL)  KissCmwc_64_2;
alias KissCmwc!(32U ,987655670UL)  KissCmwc_32_1;
alias KissCmwc!(32U ,987655878UL)  KissCmwc_32_2;
alias KissCmwc!(16U ,987651178UL)  KissCmwc_16_1;
alias KissCmwc!(16U ,987651182UL)  KissCmwc_16_2;
alias KissCmwc!(8U  ,987651386UL)  KissCmwc_8_1;
alias KissCmwc!(8U  ,987651670UL)  KissCmwc_8_2;
alias KissCmwc!(4U  ,987654366UL)  KissCmwc_4_1;
alias KissCmwc!(4U  ,987654978UL)  KissCmwc_4_2;
alias KissCmwc_1024_2 KissCmwc_default;
