/*******************************************************************************
        copyright:      Copyright (c) 2008. Fawzi Mohamed
        license:        BSD стиль: $(LICENSE)
        version:        Initial release: July 2008
        author:         Fawzi Mohamed
*******************************************************************************/
module math.random.engines.CMWC;
private import Целое=text.convert.Integer;

/+ CMWC генератор случайных чисел,
+ Marisaglia, Journal of Modern Applied Statistical Methods (2003), vol.2,No.1,p 2-13
+ a simple и fast RNG that проходки все statistical tests, имеется a large сей, и is very fast
+ By default ComplimentaryMultИПlyWithCarry with r=1024, a=987769338, b=2^32-1, период a*b^r>10^9873
+ This is the движок, *never* use it directly, always use it though a СлуччисГ class
+/
struct CMWC(бцел cmwc_r=1024U,бдол cmwc_a=987769338UL){
    бцел[cmwc_r] cmwc_q=void;
    бцел cmwc_i=cmwc_r-1u;
    бцел cmwc_c=123;
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
        static assert((rMask&cmwc_r)==0,"cmwc_r предполагается кратным 2"); // помести a ещё stringent тест?
        const бцел m=0xFFFF_FFFE;
        cmwc_i=(cmwc_i+1)&rMask;
        бдол t=cmwc_a*cmwc_q[cmwc_i]+cmwc_c;
        cmwc_c=cast(бцел)(t>>32);
        бцел x=cast(бцел)t+cmwc_c;
        if (x<cmwc_c) {
            ++x; ++cmwc_c;
        }
        return (cmwc_q[cmwc_i]=m-x);
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
    }
    /// записывает текущ статус в ткст
    ткст вТкст(){
        ткст рез=new сим[4+16+(cmwc_r+5)*9];
        цел i=0;
        рез[i..i+4]="CMWC";
        i+=4;
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
        foreach (знач;[cmwc_i,cmwc_c,nBytes,restB]){
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
        assert(s[i..i+4]=="CMWC","неожиданный вид, ожидался CMWC");
        i+=4;
        assert(s[i..i+16]==Целое.форматируй(tmpC,cmwc_a,"x16"),"неожиданный cmwc_a");
        i+=16;
        assert(s[i]=='_',"неожиданный формат, ожидался _");
        i++;
        assert(s[i..i+8]==Целое.форматируй(tmpC,cmwc_r,"x8"),"неожиданный cmwc_r");
        i+=8;
        foreach (ref знач;cmwc_q){
            assert(s[i]=='_',"не найден разделитель  _ ");
            ++i;
            бцел ate;
            знач=cast(бцел)Целое.преобразуй(s[i..i+8],16,&ate);
            assert(ate==8,"неожиданный размер чтения");
            i+=8;
        }
        foreach (знач;[&cmwc_i,&cmwc_c,&nBytes,&restB]){
            assert(s[i]=='_',"не найден разделитель  _ ");
            ++i;
            бцел ate;
            *знач=cast(бцел)Целое.преобразуй(s[i..i+8],16,&ate);
            assert(ate==8,"неожиданный размер чтения");
            i+=8;
        }
        return i;
    }
}

/// some variations, the первый имеется a период of ~10^39461, the первый число (r) is basically the размер of the сей
/// (и все bit образцы of that размер are guarenteed в_ crop up in the период), the период is 2^(32*r)*a
alias CMWC!(4096U,18782UL)     CMWC_4096_1;
alias CMWC!(2048U,1030770UL)   CMWC_2048_1;
alias CMWC!(2048U,1047570UL)   CMWC_2048_2;
alias CMWC!(1024U,5555698UL)   CMWC_1024_1;
alias CMWC!(1024U,987769338UL) CMWC_1024_2;
alias CMWC!(512U,123462658UL)  CMWC_512_1;
alias CMWC!(512U,123484214UL)  CMWC_512_2;
alias CMWC!(256U,987662290UL)  CMWC_256_1;
alias CMWC!(256U,987665442UL)  CMWC_256_2;
alias CMWC!(128U,987688302UL)  CMWC_128_1;
alias CMWC!(128U,987689614UL)  CMWC_128_2;
alias CMWC!(64U ,987651206UL)  CMWC_64_1;
alias CMWC!(64U ,987657110UL)  CMWC_64_2;
alias CMWC!(32U ,987655670UL)  CMWC_32_1;
alias CMWC!(32U ,987655878UL)  CMWC_32_2;
alias CMWC!(16U ,987651178UL)  CMWC_16_1;
alias CMWC!(16U ,987651182UL)  CMWC_16_2;
alias CMWC!(8U  ,987651386UL)  CMWC_8_1;
alias CMWC!(8U  ,987651670UL)  CMWC_8_2;
alias CMWC!(4U  ,987654366UL)  CMWC_4_1;
alias CMWC!(4U  ,987654978UL)  CMWC_4_2;
alias CMWC_1024_2 CMWC_default;
