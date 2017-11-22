/*******************************************************************************
        copyright:      Copyright (c) 2008. Fawzi Mohamed
        license:        BSD стиль: $(LICENSE)
        version:        Initial release: July 2008
        author:         Fawzi Mohamed
*******************************************************************************/
module math.random.engines.URandom;
version(darwin) { version=has_urandom; }
version(linux)  { version=has_urandom; }
version(solaris){ version=has_urandom; }

version(has_urandom) {
    private import Целое = text.convert.Integer;
    import sync: Стопор;
    import io.device.File; // use stdc читай/пиши?

    /// basic источник that takes данные из_ system random устройство
    /// This is an движок, do not use directly, use СлуччисГ!(Urandom)
    /// should use stdc rad/пиши?
    struct URandom{
        static Файл.Стиль стильЧтен;
        static Стопор блокируй;
        static this(){
            стильЧтен.доступ=Файл.Доступ.Чит;
            стильЧтен.открой  =Файл.Открыть.Сущ;
            стильЧтен.совместно =Файл.Общ.Чит;
            стильЧтен.кэш =Файл.Кэш.Нет;

            блокируй=new Стопор();
        }
        const цел canCheckpoint=нет;
        const цел можноСеять=нет;
    
        проц пропусти(бцел n){ }
        ббайт следщБ(){
            union ВПроцА{
                ббайт i;
                проц[1] a;
            }
            ВПроцА el;
            synchronized(блокируй){
                auto фн = new Файл("/dev/urandom", стильЧтен); 
                if(фн.читай(el.a)!=el.a.length){
                    throw new Исключение("не удалось записать необходимые байты в urandom");
                }
                фн.закрой();
            }
            return el.i;
        }
        бцел следщ(){
            union ВПроцА{
                бцел i;
                проц[4] a;
            }
            ВПроцА el;
            synchronized(блокируй){
                auto фн = new Файл("/dev/urandom", стильЧтен); 
                if(фн.читай(el.a)!=el.a.length){
                    throw new Исключение("не удалось записать необходимые байты в urandom");
                }
                фн.закрой();
            }
            return el.i;
        }
        бдол следщД(){
            union ВПроцА{
                бдол l;
                проц[8] a;
            }
            ВПроцА el;
            synchronized(блокируй){
                auto фн = new Файл("/dev/urandom", стильЧтен); 
                if(фн.читай(el.a)!=el.a.length){
                    throw new Исключение("не удалось записать необходимые байты в urandom");
                }
                фн.закрой();
            }
            return el.l;
        }
        /// does nothing
        проц сей(бцел delegate() r) { }
        /// записывает текущ статус в ткст
        ткст вТкст(){
            return "URandom";
        }
        /// считывает текущ статус в ткст (его следует обработать)
        /// возвращает число считанных символов
        т_мера изТкст(ткст s){
            ткст r="URandom";
            assert(s[0.. r.length]==r,"неожидаемый ткст вместо URandom:"~s);
            return r.length;
        }
    }
}
