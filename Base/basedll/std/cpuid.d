module std.cpuid;

import std.x.cpuid:mmx,fxsr,sse,sse2,sse3,ssse3,amd3dnow,amd3dnowExt,amdMmx,ia64,amd64,hyperThreading, vendor, processor,family,model,stepping,threadsPerCPU,coresPerCPU;

export extern(D) struct Процессор
{
    export:

    ткст производитель()    {return std.x.cpuid.vendor();}
    ткст название()         {return std.x.cpuid.processor();}
    бул поддержкаММЭкс()    {return std.x.cpuid.mmx();}
    бул поддержкаФЭксСР()   {return std.x.cpuid.fxsr();}
    бул поддержкаССЕ()      {return std.x.cpuid.sse();}
    бул поддержкаССЕ2()     {return std.x.cpuid.sse2();}
    бул поддержкаССЕ3()     {return std.x.cpuid.sse3();}
    бул поддержкаСССЕ3()    {return std.x.cpuid.ssse3();}
    бул поддержкаАМД3ДНау() {return std.x.cpuid.amd3dnow();}
    бул поддержкаАМД3ДНауЭкст(){return std.x.cpuid.amd3dnowExt();}
    бул поддержкаАМДММЭкс() {return std.x.cpuid.amdMmx();}
    бул являетсяИА64()      {return std.x.cpuid.ia64();}
    бул являетсяАМД64()     {return std.x.cpuid.amd64();}
    бул поддержкаГиперПоточности(){return std.x.cpuid.hyperThreading();}
    бцел потоковНаЦПБ()     {return std.x.cpuid.threadsPerCPU();}
    бцел ядерНаЦПБ()        {return std.x.cpuid.coresPerCPU();}
    бул являетсяИнтел()     {return std.x.cpuid.intel();}
    бул являетсяАМД()       {return std.x.cpuid.amd();}
    бцел поколение()        {return std.x.cpuid.stepping();}
    бцел модель()           {return std.x.cpuid.model();}
    бцел семейство()        {return std.x.cpuid.family();}
    ткст вТкст()            {return о_ЦПУ();}
}

ткст о_ЦПУ(){

    ткст feats;
    if (mmx)            feats ~= "MMX ";
    if (fxsr)           feats ~= "FXSR ";
    if (sse)            feats ~= "SSE ";
    if (sse2)           feats ~= "SSE2 ";
    if (sse3)           feats ~= "SSE3 ";
    if (ssse3)          feats ~= "SSSE3 ";
    if (amd3dnow)           feats ~= "3DNow! ";
    if (amd3dnowExt)        feats ~= "3DNow!+ ";
    if (amdMmx)         feats ~= "MMX+ ";
    if (ia64)           feats ~= "IA-64 ";
    if (amd64)          feats ~= "AMD64 ";
    if (hyperThreading)     feats ~= "HTT";

    ткст цпу = фм(
        "\t\tИНФОРМАЦИЯ О ЦПУ ДАННОГО КОМПЬЮТЕРА\n\t**************************************************************\n\t"~
        " Производитель   \t|   %s                                 \n\t"~"--------------------------------------------------------------\n\t", vendor(),
        " Процессор       \t|   %s                                 \n\t"~"--------------------------------------------------------------\n\t", processor(),
        " Сигнатура     \t| Семейство %d | Модель %d | Поколение %d \n\t"~"--------------------------------------------------------------\n\t", family(), model(), stepping(),
        " Функции         \t|   %s                                 \n\t"~"--------------------------------------------------------------\n\t", feats,
        " Многопоточность \t|  %d-поточный / %d-ядерный            \n\t"~"**************************************************************", threadsPerCPU(), coresPerCPU());
    return цпу;

    }