module drc.lexer.Identifier;

import drc.lexer.TokensEnum,
       drc.lexer.IdentsEnum;
import common;

/// Представляет идентификатор по определению в спецификации D.
///
/// $(PRE
///  Идентификатор := НачалоИд СимвИд*
///  НачалоИд := "_" | Буква
///  СимвИд := НачалоИд | "0"-"9"
///  Буква := ЮАльфа
/// )
/// See_Also:
///  Алфавитные символы Юникод определены в Юникод 5.0.0.
align(1)
struct Идентификатор
{
  ткст ткт; /// Идентификатор в ткст UTF-8.
  ТОК вид;   /// Вид семы.
  ВИД видИд; /// Только для предопределённых идентификаторов.

  static Идентификатор* opCall(ткст ткт, ТОК вид)
  {
    auto ид = new Идентификатор;
    ид.ткт = ткт;
    ид.вид = вид;
    return ид;
  }

  static Идентификатор* opCall(ткст ткт, ТОК вид, ВИД видИд)
  {
    auto ид = new Идентификатор;
    ид.ткт = ткт;
    ид.вид = вид;
    ид.видИд = видИд;
    return ид;
  }

  бцел вХэш()
  {
    бцел хэш;
    foreach(с; ткт) {
      хэш *= 11;
      хэш += с;
    }
    return хэш;
  }
}
// pragma(сооб, Идентификатор.sizeof.stringof);

//*******************
import cidrus;
import dmd.globals;
import drc.lexer.Id;
import util.outbuffer;
import drc.ast.Node;
import util.string;
import util.stringtable;
import drc.lexer.Tokens;
import util.utf;


/***********************************************************
*/
final class Идентификатор2 : КорневойОбъект
{
private:
    цел значение;
    ткст имя;

public:
    /**
	* Конструирует идентификатор из среза D
    * 
	* Note: Since `имя` needs to be `\0` terminated for `вТкст0`,
	* no slice overload is provided yet.
    * 
	* Парметры:
	* имя = имя идентификатора
	* There must be `'\0'` at `имя[length]`.
	* length = длина `имя`, исключая оканчивающее `'\0'`
	* значение = значение идентификатора (напр., `Id.unitTest`) или `ТОК2.идентификатор`
	*/
    this(ткст0 имя, т_мера length, цел значение) 
    {
        //printf("Идентификатор2('%s', %d)\n", имя, значение);
        this.имя = имя[0 .. length];
        this.значение = значение;
    }

    this(ткст имя, цел значение) 
    {
        //printf("Идентификатор2('%.*s', %d)\n", cast(цел)имя.length, имя.ptr, значение);
        this.имя = имя;
        this.значение = значение;
    }

    this(ткст0 имя) 
    {
        //printf("Идентификатор2('%s', %d)\n", имя, значение);
        this(имя.вТкстД(), ТОК2.идентификатор);
    }

    /// Sentinel for an анонимный идентификатор.
    static Идентификатор2 анонимный() 
    {
		Идентификатор2 анонимный;

        if (анонимный)
            return анонимный;

        return анонимный = new Идентификатор2("__anonymous", ТОК2.идентификатор);
    }

    static Идентификатор2 создай(ткст0 имя) 
    {
        return new Идентификатор2(имя);
    }


    override ткст0 вТкст0() 
    {
        return имя.ptr;
    }

    override ткст вТкст() 
    {
        return имя;
    }

    цел дайЗначение() 
    {
        return значение;
    }

    ткст0 toHChars2()
    {
        ткст0 p = null;
        if (this == Id.ctor)
            p = "this";
        else if (this == Id.dtor)
            p = "~this";
        else if (this == Id.unitTest)
            p = "unittest";
        else if (this == Id.dollar)
            p = "$";
        else if (this == Id.withSym)
            p = "with";
        else if (this == Id.результат)
            p = "результат";
        else if (this == Id.returnLabel)
            p = "return";
        else
        {
            p = вТкст0();
            if (*p == '_')
            {
                if (strncmp(p, "_staticCtor", 11) == 0)
                    p = "static this";
                else if (strncmp(p, "_staticDtor", 11) == 0)
                    p = "static ~this";
                else if (strncmp(p, "__invariant", 11) == 0)
                    p = "invariant";
            }
        }
        return p;
    }

    override ДИНКАСТ динкаст()
    {
        return ДИНКАСТ.идентификатор;
    }

    private ТаблицаСтрок!(Идентификатор2) stringtable;

    static Идентификатор2 генерируйИд(ткст префикс)
    {
		т_мера i;
        return генерируйИд(префикс, ++i);
    }

    static Идентификатор2 генерируйИд(ткст префикс, т_мера i)
    {
        БуфВыв буф;
        буф.пиши(префикс);
        буф.print(i);
        return idPool(буф[]);
    }

    /***************************************
	* Generate deterministic named идентификатор based on a source location,
	* such that the имя is consistent across multiple compilations.
	* A new unique имя is generated. If the префикс+location is already in
	* the stringtable, an extra suffix is added (starting the count at "_1").
	*
	* Параметры:
	*      префикс      = first part of the идентификатор имя.
	*      место         = source location to use in the идентификатор имя.
	* Возвращает:
	*      Идентификатор2 (inside Идентификатор2.idPool) with deterministic имя based
	*      on the source location.
	*/
    static Идентификатор2 generateIdWithLoc(ткст префикс, ref Место место)
    {
        // generate `<префикс>_L<line>_C<col>`
        БуфВыв idBuf;
        idBuf.пишиСтр(префикс);
        idBuf.пишиСтр("_L");
        idBuf.print(место.номстр);
        idBuf.пишиСтр("_C");
        idBuf.print(место.имяс);

        /**
		* Make sure the identifiers are unique per имяф, i.e., per module/mixin
		* (`path/to/foo.d` and `path/to/foo.d-mixin-<line>`). See issues
		* https://issues.dlang.org/show_bug.cgi?ид=16995
		* https://issues.dlang.org/show_bug.cgi?ид=18097
		* https://issues.dlang.org/show_bug.cgi?ид=18111
		* https://issues.dlang.org/show_bug.cgi?ид=18880
		* https://issues.dlang.org/show_bug.cgi?ид=18868
		* https://issues.dlang.org/show_bug.cgi?ид=19058
		*/
        struct Ключ { Место место; ткст префикс; }
		бцел[Ключ] counters;

		/+   static if (__traits(compiles, counters.update(Ключ.init, () => 0u, (ref бцел a) => 0u)))
        {
		// 2.082+
		counters.update(Ключ(место, префикс),
		() => 1u,          // insertion
		(ref бцел counter) // update
		{
		idBuf.пишиСтр("_");
		idBuf.print(counter);
		return counter + 1;
		}
		);
        }
        else+/
		// {
		const ключ = Ключ(место, префикс);
		if (auto pCounter = ключ in counters)
		{
			idBuf.пишиСтр("_");
			idBuf.print((*pCounter)++);
		}
		else
			counters[ключ] = 1;
		// }

        return idPool(idBuf[]);
    }

    /********************************************
	* Create an идентификатор in the ткст table.
	*/
    static Идентификатор2 idPool(ткст0 s, бцел len)
    {
        return idPool(s[0 .. len]);
    }

    static Идентификатор2 idPool(ткст s)
    {
        auto sv = stringtable.update(s);
        auto ид = sv.значение;
        if (!ид)
        {
            ид = new Идентификатор2(sv.вТкст(), ТОК2.идентификатор);
            sv.значение = ид;
        }
        return ид;
    }

    static Идентификатор2 idPool(ткст0 s, т_мера len, цел значение)
    {
        return idPool(s[0 .. len], значение);
    }

    static Идентификатор2 idPool(ткст s, цел значение)
    {
        auto sv = stringtable.вставь(s, null);
        assert(sv);
        auto ид = new Идентификатор2(sv.вТкст(), значение);
        sv.значение = ид;
        return ид;
    }

    /**********************************
	* Determine if ткст is a valid Идентификатор2.
	* Параметры:
	*      str = ткст to check
	* Возвращает:
	*      нет for invalid
	*/
    static бул isValidIdentifier(ткст0 str)
    {
        return str && isValidIdentifier(str.вТкстД);
    }

    /**********************************
	* ditto
	*/
    static бул isValidIdentifier(ткст str)
    {
        if (str.length == 0 ||
            (str[0] >= '0' && str[0] <= '9')) // beware of isdigit() on signed chars
        {
            return нет;
        }

        т_мера idx = 0;
        while (idx < str.length)
        {
            dchar dc;
            const s = utf_decodeChar(str, idx, dc);
            if (s ||
                !((dc >= 0x80 && isUniAlpha(dc)) || isalnum(dc) || dc == '_'))
            {
                return нет;
            }
        }
        return да;
    }

    static Идентификатор2 lookup(ткст0 s, т_мера len)
    {
        return lookup(s[0 .. len]);
    }

    static Идентификатор2 lookup(ткст s)
    {
        auto sv = stringtable.lookup(s);
        if (!sv)
            return null;
        return sv.значение;
    }

    static проц initTable()
    {
        stringtable._иниц(28_000);
    }
}
