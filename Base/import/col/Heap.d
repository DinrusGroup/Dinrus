module col.Heap;
import util = tpl.Std;

/+ ИНТЕРФЕЙС:

struct ИнтерфейсКучиШ(ЗаписьКучи)
{
  бул меньше( ref ЗаписьКучи _e1, ref ЗаписьКучи _e2);
  бул больше( ref ЗаписьКучи _e1, ref ЗаписьКучи _e2);
  цел  дай_положение( ref ЗаписьКучи _e);
  проц установи_положение(ref ЗаписьКучи _e, цел _i);
}
 
struct Куча(ЗаписьКучи, ИнтерфейсКучи = ЗаписьКучи)
{
    static Куча opCall();
    static Куча opCall(ref ИнтерфейсКучи _интерфейс);
    проц очисть() ;
    бул пуста();
    бцел размер() ;
    бцел длина();
    проц резервируй(бцел _n) ;
    проц сбрось_положение(ЗаписьКучи _h);
    бул сохранена(ЗаписьКучи _h);
    проц вставь(ЗаписьКучи _h)  ;
    ЗаписьКучи первая();
    проц удали_первую();
    проц удали(ЗаписьКучи _h);
    проц обнови(ЗаписьКучи _h);
    бул проверь();

protected:  
    ИнтерфейсКучи интерфейс_;
    ЗаписьКучи[]            Основа;


}
+/

//== ОПРЕДЕЛЕНИЕ КЛАССА =========================================================


/** Этот класс демонстрирует интерфейс ИнтерфейсКучи.  * Если вы
 * хотите построить свою собственную кучу, вам нужно указать класс 
 * интерфейса кучи, и использовать его как шаблонный параметр для
 * класса Куча. * Этот клас определяет интерфейс, который этот интерфей
 * кучи должен реализовать.
 *   
 *  See_Also: Куча
 */
struct ИнтерфейсКучиШ(ЗаписьКучи)
{
  ///Сравнение двух ЗаписьКучи: строго меньше
  бул меньше( ref ЗаписьКучи _e1, ref ЗаписьКучи _e2);

  //////Сравнение двух ЗаписьКучи: строго больше
  бул больше( ref ЗаписьКучи _e1, ref ЗаписьКучи _e2);

  ///Получает позицию в куче ЗаписьКучи _e
  цел  дай_положение( ref ЗаписьКучи _e);

  ///Устанавливает позицию в куче ЗаписьКучи _e
  проц установи_положение(ref ЗаписьКучи _e, цел _i);
}



/**
 * Эффективная, высоко перенастраиваемая куча.
 *
 * Главное различие (и увеличение производительности) этой кучи в сравнении с
 * например, кучей STL, в том, что здесь позиция
 * элементов кучи доступна из самих элементов.
 * Таким образом, если изменить приоритет элемента,
 * придётся удалить и переустановить этот элемент, но можно просто вызвать
 * метод  обнови(ЗаписьКучи).
 *
 * Этот класс кучи параметрирован двумя шаблонными элементами: 
 *  $(UL
 *    $(LI класс \c ЗаписьКучи, которыя будет сохранён в куче)
 *    $(LI ИнтерфейсКучи, показывающий куче, как сравнивать записи кучи и
 *       как хранить позиции кучи в её записях.)
 *  )
 *
 * Как пример использования класса, смотрите объявление класса 
 *  Decimater.DecimaterT.
 *
 *  See_Also: ИнтерфейсКучиШ
 */
 
struct Куча(ЗаписьКучи, ИнтерфейсКучи = ЗаписьКучи)
{
public:

    /// Конструктор
    static Куча opCall() { Куча M; return M; }
  
    ///Построить с заданным \c HeapIterface. 
    static Куча opCall(ref ИнтерфейсКучи _интерфейс) 
    { 
        Куча M; with (M) {
            интерфейс_=(_интерфейс);
        } return M; 
    }

    /// очистить кучу
    проц очисть() { Основа.длина = 0; }

    /// куча пуста?
    бул пуста() { return Основа.длина == 0; }

    /// возвращает размер кучи
    бцел размер() { return Основа.длина; }
    бцел длина() { return Основа.длина; }

    /// резервирует пространство для _n записей
    проц резервируй(бцел _n) { util.резервируй(Основа,_n); }

    /// сбросить положение в куче в -1 (нет в куче)
    проц сбрось_положение(ЗаписьКучи _h)
    { интерфейс_.установи_положение(_h, -1); }
  
    /// запись есть в куче?
    бул сохранена(ЗаписьКучи _h)
    { return интерфейс_.дай_положение(_h) != -1; }
  
    /// вставить запись _h
    проц вставь(ЗаписьКучи _h)  
    { 
        Основа ~= _h; 
        upheap(размер()-1); 
    }

    /// получить первую запись
    ЗаписьКучи первая()
    { 
        assert(!пуста()); 
        return запись(0); 
    }

    /// удалить первую запись
    проц удали_первую()
    {    
        assert(!пуста());
        сбрось_положение(запись(0));
        if (размер() > 1)
        {
            запись(0, запись(размер()-1));
            pop_back();
            downheap(0);
        }
        else
        {
            pop_back();
        }
    }

    /// удалить запись
    проц удали(ЗаписьКучи _h)
    {
        цел поз = интерфейс_.дай_положение(_h);
        сбрось_положение(_h);

        assert(поз != -1);
        assert(cast(бцел) поз < размер());
    
        // последний элемент?
        if (cast(бцел) поз == размер()-1)
        {
            pop_back();    
        }
        else 
        {
            запись(поз, запись(размер()-1)); // переметить последн элт в поз
            pop_back();
            downheap(поз);
            upheap(поз);
        }
    }

    /** Обновить запись: изменить ключ и обновить положение, чтобы
        * восстановить свойства кучи.
    */
    проц обнови(ЗаписьКучи _h)
    {
        цел поз = интерфейс_.дай_положение(_h);
        assert(поз != -1, "ЗаписьКучи не в куче (поз=-1)");
        assert(cast(бцел)поз < размер());
        downheap(поз);
        upheap(поз);
    }
  
    /// Проверить состояние кучи
    бул проверь()
    {
        бул ok = да;
        бцел i, j;
        for (i=0; i<размер(); ++i)
        {
            if (((j=left(i))<размер()) && интерфейс_.больше(запись(i), запись(j))) 
            {
                ошибка("Нарушение условий для Кучи");
                ok = нет;
            }
            if (((j=right(i))<размер()) && интерфейс_.больше(запись(i), запись(j)))
            {
                ошибка("Нарушение условий для Кучи");
                ok = нет;
            }
        }
        return ok;
    }

protected:  
    /// Экземпляр ИнтерфейсКучи
    ИнтерфейсКучи интерфейс_;
    ЗаписьКучи[]            Основа;
  

private:
    // typedef
    alias ЗаписьКучи[] ВекторКучи;

  
    проц pop_back() {
        assert(!пуста());
        Основа.длина = Основа.длина-1;
    }

    /// Вверх по куче. Установить свойство кучи.
    проц upheap(бцел _idx)
    {
        ЗаписьКучи     h = запись(_idx);
        бцел  parentIdx;

        while ((_idx>0) &&
               интерфейс_.меньше(h, запись(parentIdx=parent(_idx))))
        {
            запись(_idx, запись(parentIdx));
            _idx = parentIdx;    
        }
  
        запись(_idx, h);
    }

  
    /// Вниз по куче. Установить свойство кучи.
    проц downheap(бцел _idx)
    {
        ЗаписьКучи     h = запись(_idx);
        бцел  childIdx;
        бцел  s = размер();
  
        while(_idx < s)
        {
            childIdx = left(_idx);
            if (childIdx >= s) break;
    
            if ((childIdx+1 < s) &&
                (интерфейс_.меньше(запись(childIdx+1), запись(childIdx))))
                ++childIdx;
    
            if (интерфейс_.меньше(h, запись(childIdx))) break;

            запись(_idx, запись(childIdx));
            _idx = childIdx;
        }  

        запись(_idx, h);

    }

      ///Установить запись _h на index _idx и обновить положение кучи _h.
    проц запись(бцел _idx, ЗаписьКучи _h) 
    {
        assert(_idx < размер());
        Основа[_idx] = _h;
        интерфейс_.установи_положение(_h, _idx);
    }

  
    /// Получить запись по index _idx
    ЗаписьКучи запись(бцел _idx)
    {
        assert(_idx < размер());
        return (Основа[_idx]);
    }
  
    ///Получить указатель родителя
    бцел parent(бцел _i) { return (_i-1)>>1; }
    ///Получить указатель левого отпрыска
    бцел left(бцел _i)   { return (_i<<1)+1; }
    /// Получить указатель правого отпрыска
    бцел right(бцел _i)  { return (_i<<1)+2; }

}