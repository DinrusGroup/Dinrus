
module drc.lexer.IdentsGenerator;

/// Таблица предопределенных идентификаторов.
///
/// Формат ('#' начинает комментарии):
/// $(PRE
/// ПредопределенныйИдентификатор := ИмяИсхКода (":" ТекстИда)?
/// ИмяИсхКода := Идентификатор # Имя, которое будет использоваться в исходном коде.
/// ТекстИда := Пусто | Идентификатор # Действительный текст идентификатора.
/// Пусто := ""                  # ТекстИда может быть пустым.
/// Идентификатор := см. модуль $(MODLINK drc.lexer.Identifier).
/// )
/// Если ТекстИда не указан, то дефолтом является ИмяИсхКода.
private static const сим[][] предопрИденты = [
  // Специальный пустой идентификатор:
  "Пусто:",
  // Предопределенные идентификаторы версии:
  "DinrusGroup", "X86", "X86_64",
  /*"Windows", */"Win32", "Win64",
  "Linux:linux", "LittleEndian", "BigEndian",
  "D_Coverage", "D_InlineAsm_X86", "D_Version2",
  "none", "all",
  // Вариадические параметры:
  "Аргументы:_arguments", "Аргук:_argptr",
  // масштаб(Идентификатор):
  "выход", "успех", "сбой", "exit", "success", "failure",
  // Прагма:
  "сооб", "биб", "startaddress", "msg",
  // Компоновка:
  "C", "D", "Windows", "Pascal", "System",
  // Конструктор/Деструктор:
  "Ктор:__ctor", "Дтор:__dtor",
  // Методы new() и delete().
  "Нов:__new", "Удалить:__delete",
  // Юниттест и инвариант.
  "Юниттест:__unittest", "Инвариант:__invariant",
  // Методы перегрузки операторов:
  "opNeg", "opPos", "opCom",
  "opEquals", "opCmp",  "opAssign",
  "opAdd",  "opAdd_r",  "opAddAssign",
  "opSub",  "opSub_r",  "opSubAssign",
  "opMul",  "opMul_r",  "opMulAssign",
  "opDiv",  "opDiv_r",  "opDivAssign",
  "opMod",  "opMod_r",  "opModAssign",
  "opAnd",  "opAnd_r",  "opAndAssign",
  "opOr",   "opOr_r",   "opOrAssign",
  "opXor",  "opXor_r",  "opXorAssign",
  "opShl",  "opShl_r",  "opShlAssign",
  "opShr",  "opShr_r",  "opShrAssign",
  "opUShr", "opUShr_r", "opUShrAssign",
  "opCat",  "opCat_r",  "opCatAssign",
  "opIn",   "opIn_r",
  "opIndex", "opIndexAssign",
  "opSlice", "opSliceAssign",
  "opPostInc",
  "opPostDec",
  "opCall",
  "opCast",
  "opStar", // D2
  // foreach и foreach_reverse:
  "opApply", "opApplyReverse",
  // Функция входа:
  "main",
  // Идентификаторы ASM :
  "near", "far", "word", "dword", "qword",
  "ptr", "смещение", "seg", "__LOCAL_SIZE",
  "FS", "ST",
  "AL", "AH", "AX", "EAX",
  "BL", "BH", "BX", "EBX",
  "CL", "CH", "CX", "ECX",
  "DL", "DH", "DX", "EDX",
  "BP", "EBP", "SP", "ESP",
  "DI", "EDI", "SI", "ESI",
  "ES", "CS", "SS", "DS", "GS",
  "CR0", "CR2", "CR3", "CR4",
  "DR0", "DR1", "DR2", "DR3", "DR6", "DR7",
  "TR3", "TR4", "TR5", "TR6", "TR7",
  "MM0", "MM1", "MM2", "MM3",
  "MM4", "MM5", "MM6", "MM7",
  "XMM0", "XMM1", "XMM2", "XMM3",
  "XMM4", "XMM5", "XMM6", "XMM7",
];

сим[][] дайПару(ткст текстИда)
{
  foreach (i, с; текстИда)
    if (с == ':')
      return [текстИда[0..i], текстИда[i+1..текстИда.length]];
  return [текстИда, текстИда];
}

unittest
{
  static assert(
    дайПару("тест") == ["тест", "тест"] &&
    дайПару("тест:tset") == ["тест", "tset"] &&
    дайПару("empty:") == ["empty", ""]
  );
}

/++
  CTF для генерации членов структуры Идент.

  Результирующий текст выглядить примерно так:
  ---
  private struct Иды {static const:
    Идентификатор _Empty = {"", ТОК2.Идентификатор, ВИД.Пусто};
    Идентификатор _main = {"main", ТОК2.Идентификатор, ВИД.main};
    // и т.д.
  }
  Идентификатор* Пусто = &Иды._Empty;
  Идентификатор* main = &Иды._main;
  // и т.д.
  private Идентификатор*[] __всеИды = [
    Пусто,
    main,
    // и т.д.
  ];
  ---
+/
ткст генерируйЧленыИдент()
{
  ткст приват_члены = "private struct Иды {static const:";
  ткст публ_члены = "";
  ткст массив = "private Идентификатор*[] __всеИды = [";

  foreach (идент; предопрИденты)
  {
    сим[][] пара = дайПару(идент);
    // Идентификатор _Имя = {"имя", ТОК2.Идентификатор, ид.имя};
    приват_члены ~= "Идентификатор _"~пара[0]~` = {"`~пара[1]~`", ТОК2.Идентификатор, ВИД.`~пара[0]~"};\n";
    // Идентификатор* имя = &_Имя;
    публ_члены ~= "Идентификатор* "~пара[0]~" = &Иды._"~пара[0]~";\n";
    массив ~= пара[0]~",";
  }

  приват_члены ~= "}"; // Close private {
  массив ~= "];";

  return приват_члены ~ публ_члены ~ массив;
}

/// CTF для генерации членов перечня ВИД.
ткст генерируйЧленыИД()
{
  ткст члены;
  foreach (идент; предопрИденты)
    члены ~= дайПару(идент)[0] ~ ",\n";
  return члены;
}

// pragma(сооб, генерируйЧленыИдент());
// pragma(сооб, генерируйЧленыИД());
