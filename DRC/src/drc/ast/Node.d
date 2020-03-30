module drc.ast.Node;

import common;

public import drc.lexer.Token;
public import drc.ast.NodesEnum;
import cidrus:strlen;
import drc.ast.Visitor;

 //*********************
//Модуль dmd.rootobject;
//**********************
    enum ДИНКАСТ : цел
	{
		объект,
		выражение,
		дсимвол,
		тип,
		идентификатор,
		кортеж,
		параметр,
		инструкция,
		условие,
		шаблонпараметр,
	}
/**
    Если наследование идёт изначально от класса Объект,
    то класс КорневойОбъект должен переписывать метод "вТкст"
    у основного Объекта. Таким образом, в dmd мы находим массу
    лишнего?!!

    extern (D) class Object

	{
	проц dispose();
	проц вымести();

    проц print();
    проц выведи();	

    ткст toString();	
	ткст вТкст();

	hash_t toHash();
	т_хэш вХэш();

	int opCmp(Object o);
	int opEquals(Object o) ;

	interface Monitor
    {
	проц lock();		alias lock блокируй;
	проц unlock();		alias unlock разблокируй;
    }
	alias Monitor Монитор;

	final проц notifyRegister(проц delegate(Object) дг);
	final проц уведомиРег(проц delegate(Объект) дг);

	final проц notifyUnRegister(проц delegate(Object) дг);
	final проц уведомиОтрег(проц delegate(Объект) дг);

    static Object factory(ткст classname);	
	static Объект фабрика(ткст имякласса);

}
	alias Object Объект;
	alias Object.Monitor        IMonitor, ИМонитор;
	*/
	class КорневойОбъект
	{
		this()    
		{
		}

		бул равен(КорневойОбъект o) 
		{
			return o is this;
		}

		ткст0 вТкст0()
		{
			assert(0);
		}

		///
		ткст вТкст() 
		{
			auto p = this.вТкст0();
			return p[0 .. strlen(p)];
		}

		ДИНКАСТ динкаст()   
		{
			return ДИНКАСТ.объект;
		}
	}

/// Корневой класс всех элементов синтаксического древа Динрус.
abstract class Узел : КорневойОбъект
{
  КатегорияУзла категория; /// Категория данного узла.
  ВидУзла вид; /// Вид данного узла.
  Узел[] отпрыски; // Когда-нибудь, кажется, будет удалён.
  Сема* начало, конец; /// Семы в начале и конце данного узла.

  /// Строит объект Узел.
  this(КатегорияУзла категория)
  {
    assert(категория != КатегорияУзла.Неопределённый);
    this.категория = категория;
  }

  проц  установиСемы(Сема* начало, Сема* конец)
  {
    this.начало = начало;
    this.конец = конец;
  }

  Класс устСемы(Класс)(Класс узел)
  {
    узел.установиСемы(this.начало, this.конец);
    return узел;
  }

  проц  добавьОтпрыск(Узел отпрыск)
  {
    assert(отпрыск !is пусто, "ошибка в " ~ this.classinfo.имя);
    this.отпрыски ~= отпрыск;
  }

  проц  добавьОпцОтпрыск(Узел отпрыск)
  {
    отпрыск is пусто || добавьОтпрыск(отпрыск);
  }

  проц  добавьОтпрыски(Узел[] отпрыски)
  {
    assert(отпрыски !is пусто && delegate{
      foreach (отпрыск; отпрыски)
        if (отпрыск is пусто)
          return нет;
      return да; }(),
      "ошибка в " ~ this.classinfo.имя
    );
    this.отпрыски ~= отпрыски;
  }

  проц  добавьОпцОтпрыски(Узел[] отпрыски)
  {
    отпрыски is пусто || добавьОтпрыски(отпрыски);
  }

  /// Возвращает референцию на Класс, если узел можно преобразовать в него.
  Класс Является(Класс)()
  {
    if (вид == mixin("ВидУзла." ~ Класс.stringof))
      return cast(Класс)cast(ук)this;
    return пусто;
  }

  /// Преобразует данный узел в Класс.
  Класс в(Класс)()
  {
    return cast(Класс)cast(ук)this;
  }

  /// Возвращает глубокую (deep) копию этого узла.
  abstract Узел копируй();

  /// Возвращает поверхностную (shallow)  копию этого объекта.
  final Узел dup()
  {
    // Найти размер этого объекта.
    alias typeof(this.classinfo.иниц[0]) т_байт;
    т_мера размер = this.classinfo.init.length;
    // Скопировать данные этого объекта.
    т_байт[] данные = (cast(т_байт*)this)[0..размер].dup;
    return cast(Узел)данные.ptr;
  }
  
  	/**
	* Посещает данный узел AST, используя заданный визитор.
	*
	* Параметры:
	*  v = используемый при посещении данного узла визитор.
	*/
	abstract проц прими(Визитор2 v);

  /// Этот ткст миксирован в конструктор класса, наследующего
  /// от Узел. Устанавливает вид члена.
  const ткст установить_вид = `this.вид = mixin("ВидУзла." ~ typeof(this).stringof);`;
}
/**
* В данном классе объединено два разных варианта узла АСТ:
* первый вариант исходный, второй взят от DMD2.
* Данный алиас оставлен для поддержки совместимости.
* Во второй версии у класса Узел присутствует наследование от КорневойОбъект и
* единственный абстрактный метод void прими(Визитор2 v);
*
*/
 alias Узел УзелАСД;



