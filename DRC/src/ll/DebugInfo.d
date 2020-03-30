/// Этот файл декларирует точки Си API для генерации отладочной информации DWARF
///
module ll.DebugInfo;
import ll.Core, ll.Types;

extern (C){
/**
 * Флаги отладочной информации.
 */
enum ЛЛФлагиОИ {
  Нуль = 0,
  Приват = 1,
  Протект = 2,
  Публик = 3,
  ФорварДекл = 1 << 2,
  БлокЭпл = 1 << 3,
  СтруктБлокПоССыл = 1 << 4,
  Виртуал = 1 << 5,
  Искуственный = 1 << 6,
  Явный = 1 << 7,
  Прототипированный = 1 << 8,
  ГотовОбджСиКласс = 1 << 9,
  УкзНаОбъ = 1 << 10,
  Вектор = 1 << 11,
  СтатическЧлен = 1 << 12,
  СсылкаНаЛевЗнач = 1 << 13,
  СсылкаНаПравЗнач = 1 << 14,
  Резерв = 1 << 15,
  ЕдиничноеНаследование = 1 << 16,
  МножественноеНаследование = 2 << 16,
  ВиртуальноеНаследование = 3 << 16,
  ВведенныйВиртуал = 1 << 18,
  БитПоле = 1 << 19,
  БезВозврата = 1 << 20,
  ПередачаТипаПоЗнач = 1 << 22,
  ПередачаТипаПоСсыл = 1 << 23,
  КлассПеречня = 1 << 24,
  ФиксированнПеречень = КлассПеречня, // Deprecated.
  Thunk = 1 << 25,
  Нетривиал = 1 << 26,
  БигЭндиан = 1 << 27,
  ЛитлЭндиан = 1 << 28,
  НепрямаяВиртуальнаяБаза = (1 << 2) | (1 << 5),
  Доступность = Приват | Протект | Публик,
  УкНаПредстЧлена = ЕдиничноеНаследование |
                             МножественноеНаследование |
                             ВиртуальноеНаследование
} ;

/**
 * Исходные языки, известные DWARF.
 */
enum LLVMDWARFSourceLanguage {
  C89,
  C,
  Ada83,
  C_plus_plus,
  Cobol74,
  Cobol85,
  Fortran77,
  Fortran90,
  Pascal83,
  Modula2,
  // нов в DWARF v3:
  Java,
  C99,
  Ada95,
  Fortran95,
  PLI,
  ObjC,
  ObjC_plus_plus,
  UPC,
  D,
  // нов в DWARF v4:
  Python,
  // нов в DWARF v5:
  OpenCL,
  Go,
  Modula3,
  Haskell,
  C_plus_plus_03,
  C_plus_plus_11,
  OCaml,
  Rust,
  C11,
  Swift,
  Julia,
  Dylan,
  C_plus_plus_14,
  Fortran03,
  Fortran08,
  RenderScript,
  BLISS,
  // Vendor extensions:
  Mips_Assembler,
  GOOGLE_RenderScript,
  BORLAND_Delphi
} ;

/**
 * Количество выдаваемой отладочной информации.
 */
enum LLVMDWARFEmissionKind {
    None = 0,
    Full,
    LineTablesOnly
} ;

/**
 * Род узлов метаданных.
 */
enum {
  LLVMMDString,
  LLVMConstantAsMetadata,
  LLVMLocalAsMetadata,
  LLVMDistinctMDOperandPlaceholder,
  LLVMMDTuple,
  LLVMDILocation,
  LLVMDIВыражение,
  LLVMDIGlobalVariableВыражение,
  LLVMGenericDINode,
  LLVMDISubrange,
  LLVMDIEnumerator,
  LLVMDIBasicType,
  LLVMDIDerivedType,
  LLVMDICompositeType,
  LLVMDISubroutineType,
  LLVMDIFile,
  LLVMDICompileUnit,
  LLVMDISubprogram,
  LLVMDILexicalBlock,
  LLVMDILexicalBlockFile,
  LLVMDINamespace,
  LLVMDIModule,
  LLVMDITemplateTypeParameter,
  LLVMDITemplateValueParameter,
  LLVMDIGlobalVariable,
  LLVMDILocalVariable,
  LLVMDILabel,
  LLVMDIObjCProperty,
  LLVMDIImportedEntity,
  LLVMDIMacro,
  LLVMDIMacroFile,
  LLVMDICommonBlock
};
alias бцел ЛЛРодМетаданных;

/**
 * Кодировка типа LLVM DWARF.
 */
alias бцел ЛЛКодировкаТипаДВАРФ;

/**
 * Текущая версия отладочных метаданных.
 */
бцел ЛЛВерсияОтладМетадан();

/**
 * Версия отладочныхъ метаданных, присутствующих в предоставленном \конст Модуле.
 */
бцел ЛЛДайВерсиюМодуляОтладМетадан(ЛЛМодуль Module);

/**
 * Strip debug info in the module if it exists.
 * To do this, we удали all calls to the debugger intrinsics and any named
 * metadata for debugging. We also удали debug locations for instructions.
 * Return да if module is modified.
 */
ЛЛБул ЛЛУдалиОтладИнфоВМодуле(ЛЛМодуль Module);

/**
 * Construct a построитель for a module, and do not allow for unresolved nodes
 * attached to the module.
 */
ЛЛПостроительОИ ЛЛСоздайПостроительОИЗапрНеразр(ЛЛМодуль M);

/**
 * Construct a построитель for a module and collect unresolved nodes attached
 * to the module in order to resolve cycles during a call to
 * \конст LLVMDIBuilderFinalize.
 */
ЛЛПостроительОИ ЛЛСоздайПостроительОИ(ЛЛМодуль M);

/**
 * Deallocates the \конст DIBuilder and everything it owns.
 * @note You must call \конст LLVMDIBuilderFinalize before this
 */
проц ЛЛВыместиПостроительОИ(ЛЛПостроительОИ построитель);

/**
 * Construct any deferred debug info descriptors.
 */
проц ЛЛПостроительОИ_Финализуй(ЛЛПостроительОИ построитель);

/**
 * атр CompileUnit provides an anchor for all debugging
 * information generated during this instance of compilation.
 * \param Lang          Source programming language, eg.
 *                      \конст LLVMDWARFSourceLanguageC99
 * \param FileRef       файл info.
 * \param Producer      Identify the producer of debugging information
 *                      and code.  Usually this is a compiler
 *                      version ткст.
 * \param ProducerLen   The length of the к ткст passed to \конст Producer.
 * \param isOptimized   атр булean флаг which indicates whether optimization
 *                      is enabled or not.
 * \param Flags         This ткст lists command line опции. This
 *                      ткст is directly embedded in debug info
 *                      output which may be используется by a tool
 *                      analyzing generated debugging information.
 * \param FlagsLen      The length of the к ткст passed to \конст Flags.
 * \param RuntimeVer    This indicates runtime version for languages like
 *                      Objective-к.
 * \param SplitName     The имя of the файл that we'll split debug info
 *                      out into.
 * \param SplitNameLen  The length of the к ткст passed to \конст SplitName.
 * \param род          The вид of debug information to generate.
 * \param DWOId         The DWOId if this is a split skeleton compile unit.
 * \param SplitDebugInlining    Whether to emit inline debug info.
 * \param DebugInfoForProfiling Whether to emit extra debug info for
 *                              profile collection.
 */
ЛЛМетаданные ЛЛПостроительОИ_СоздайЕдиницуКомпиляции(
    ЛЛПостроительОИ построитель, LLVMDWARFSourceLanguage Lang,
    ЛЛМетаданные FileRef, ткст0 Producer, т_мера ProducerLen,
    ЛЛБул isOptimized, ткст0 Flags, т_мера FlagsLen,
    бцел RuntimeVer, ткст0 SplitName, т_мера SplitNameLen,
    LLVMDWARFEmissionKind род, бцел DWOId, ЛЛБул SplitDebugInlining,
    ЛЛБул DebugInfoForProfiling);

/**
 * Create a файл descriptor to hold debugging information for a файл.
 * \param построитель      The \конст DIBuilder.
 * \param имяФ     файл имя.
 * \param FilenameLen  The length of the к ткст passed to \конст имяФ.
 * \param Directory    Directory.
 * \param DirectoryLen The length of the к ткст passed to \конст Directory.
 */
ЛЛМетаданные
ЛЛПостроительОИ_СоздайФайл(ЛЛПостроительОИ построитель, ткст0 имяФ,
                        т_мера FilenameLen, ткст0 Directory,
                        т_мера DirectoryLen);

/**
 * Creates a new descriptor for a module with the specified родитель scope.
 * \param построитель         The \конст DIBuilder.
 * \param ParentScope     The родитель scope containing this module declaration.
 * \param имя            Module имя.
 * \param длинаИм         The length of the к ткст passed to \конст имя.
 * \param ConfigMacros    атр space-separated shell-quoted list of -D macro
                          definitions as they would appear on a command line.
 * \param ConfigMacrosLen The length of the к ткст passed to \конст ConfigMacros.
 * \param IncludePath     The path to the module map файл.
 * \param IncludePathLen  The length of the к ткст passed to \конст IncludePath.
 * \param ISysRoot        The Clang system root (знач of -isysroot).
 * \param ISysRootLen     The length of the к ткст passed to \конст ISysRoot.
 */
ЛЛМетаданные
ЛЛПостроительОИ_СоздайМодуль(ЛЛПостроительОИ построитель, ЛЛМетаданные ParentScope,
                          ткст0 имя, т_мера длинаИм,
                          ткст0 ConfigMacros, т_мера ConfigMacrosLen,
                          ткст0 IncludePath, т_мера IncludePathLen,
                          ткст0 ISysRoot, т_мера ISysRootLen);

/**
 * Creates a new descriptor for a namespace with the specified родитель scope.
 * \param построитель          The \конст DIBuilder.
 * \param ParentScope      The родитель scope containing this module declaration.
 * \param имя             NameSpace имя.
 * \param длинаИм          The length of the к ткст passed to \конст имя.
 * \param ExportSymbols    Whether or not the namespace exports symbols, e.g.
 *                         this is да of C++ inline namespaces.
 */
ЛЛМетаданные
ЛЛПостроительОИ_СоздайПрострвоИмён(ЛЛПостроительОИ построитель,
                             ЛЛМетаданные ParentScope,
                             ткст0 имя, т_мера длинаИм,
                             ЛЛБул ExportSymbols);

/**
 * Create a new descriptor for the specified subprogram.
 * \param построитель         The \конст DIBuilder.
 * \param Scope           Function scope.
 * \param имя            Function имя.
 * \param длинаИм         длина of enumeration имя.
 * \param LinkageName     Mangled function имя.
 * \param LinkageNameLen  длина of компонаж имя.
 * \param файл            файл where this variable is defined.
 * \param LineNo          строка number.
 * \param тип              Function тип.
 * \param IsLocalToUnit   True if this function is not externally visible.
 * \param IsDefinition    True if this is a function definition.
 * \param ScopeLine       Set to the beginning of the scope this starts
 * \param Flags           E.g.: \конст LLVMDIFlagLValueReference. These flags are
 *                        используется to emit dwarf attributes.
 * \param IsOptimized     True if optimization is ON.
 */
ЛЛМетаданные ЛЛПостроительОИ_СоздайФункц(
    ЛЛПостроительОИ построитель, ЛЛМетаданные Scope, ткст0 имя,
    т_мера длинаИм, ткст0 LinkageName, т_мера LinkageNameLen,
    ЛЛМетаданные файл, бцел LineNo, ЛЛМетаданные тип,
    ЛЛБул IsLocalToUnit, ЛЛБул IsDefinition,
    бцел ScopeLine, ЛЛФлагиОИ Flags, ЛЛБул IsOptimized);

/**
 * Create a descriptor for a lexical блок with the specified родитель context.
 * \param построитель      The \конст DIBuilder.
 * \param Scope        Parent lexical блок.
 * \param файл         Source файл.
 * \param строка         The line in the source файл.
 * \param Column       The column in the source файл.
 */
ЛЛМетаданные ЛЛПостроительОИ_СоздайЛексичБлок(
    ЛЛПостроительОИ построитель, ЛЛМетаданные Scope,
    ЛЛМетаданные файл, бцел строка, бцел Column);

/**
 * Create a descriptor for a lexical блок with a new файл attached.
 * \param построитель        The \конст DIBuilder.
 * \param Scope          Lexical блок.
 * \param файл           Source файл.
 * \param Discriminator  DWARF path discriminator знач.
 */
ЛЛМетаданные
ЛЛПостроительОИ_СоздайФайлЛексичБлока(ЛЛПостроительОИ построитель,
                                    ЛЛМетаданные Scope,
                                    ЛЛМетаданные файл,
                                    бцел Discriminator);

/**
 * Create a descriptor for an imported namespace. Suitable for e.g. C++
 * using declarations.
 * \param построитель    The \конст DIBuilder.
 * \param Scope      The scope this module is imported into
 * \param файл       файл where the declaration is located.
 * \param строка       строка number of the declaration.
 */
ЛЛМетаданные
ЛЛПостроительОИ_СоздайИмпортирМодульИзПрострваИмён(ЛЛПостроительОИ построитель,
                                               ЛЛМетаданные Scope,
                                               ЛЛМетаданные NS,
                                               ЛЛМетаданные файл,
                                               бцел строка);

/**
 * Create a descriptor for an imported module that ники another
 * imported entity descriptor.
 * \param построитель        The \конст DIBuilder.
 * \param Scope          The scope this module is imported into
 * \param ImportedEntity Previous imported entity to alias.
 * \param файл           файл where the declaration is located.
 * \param строка           строка number of the declaration.
 */
ЛЛМетаданные
ЛЛПостроительОИ_СоздайИмпортирМодульИзАлиаса(ЛЛПостроительОИ построитель,
                                           ЛЛМетаданные Scope,
                                           ЛЛМетаданные ImportedEntity,
                                           ЛЛМетаданные файл,
                                           бцел строка);

/**
 * Create a descriptor for an imported module.
 * \param построитель    The \конст DIBuilder.
 * \param Scope      The scope this module is imported into
 * \param M          The module being imported here
 * \param файл       файл where the declaration is located.
 * \param строка       строка number of the declaration.
 */
ЛЛМетаданные
ЛЛПостроительОИ_СоздайИмпортирМодульИзМодуля(ЛЛПостроительОИ построитель,
                                            ЛЛМетаданные Scope,
                                            ЛЛМетаданные M,
                                            ЛЛМетаданные файл,
                                            бцел строка);

/**
 * Create a descriptor for an imported function, тип, or variable.  Suitable
 * for e.g. FORTRAN-style USE declarations.
 * \param построитель    The DIBuilder.
 * \param Scope      The scope this module is imported into.
 * \param Decl       The declaration (or definition) of a function, тип,
                     or variable.
 * \param файл       файл where the declaration is located.
 * \param строка       строка number of the declaration.
 * \param имя       атр имя that uniquely identifies this imported declaration.
 * \param длинаИм    The length of the к ткст passed to \конст имя.
 */
ЛЛМетаданные
ЛЛПостроительОИ_СоздайИмпортирДекларацию(ЛЛПостроительОИ построитель,
                                       ЛЛМетаданные Scope,
                                       ЛЛМетаданные Decl,
                                       ЛЛМетаданные файл,
                                       бцел строка,
                                       ткст0 имя, т_мера длинаИм);

/**
 * Creates a new DebugLocation that describes a source location.
 * \param строка The line in the source файл.
 * \param Column The column in the source файл.
 * \param Scope The scope in which the location resides.
 * \param InlinedAt The scope where this location was inlined, if at all.
 *                  (optional).
 * \note If the item to which this location is attached cannot be
 *       attributed to a source line, pass 0 for the line and column.
 */
ЛЛМетаданные
ЛЛПостроительОИ_СоздайЛокациюОтладки(ЛЛКонтекст кткст, бцел строка,
                                 бцел Column, ЛЛМетаданные Scope,
                                 ЛЛМетаданные InlinedAt);

/**
 * Get the line number of this debug location.
 * \param Location     The debug location.
 *
 * @see DILocation::getLine()
 */
бцел ЛЛЛокацОИ_ДайСтроку(ЛЛМетаданные Location);

/**
 * Get the column number of this debug location.
 * \param Location     The debug location.
 *
 * @see DILocation::getColumn()
 */
бцел ЛЛЛокацОИ_ДайСтолбец(ЛЛМетаданные Location);

/**
 * Get the local scope associated with this debug location.
 * \param Location     The debug location.
 *
 * @see DILocation::getScope()
 */
ЛЛМетаданные ЛЛЛокацОИ_ДайМасштаб(ЛЛМетаданные Location);

/**
 * Get the "inline at" location associated with this debug location.
 * \param Location     The debug location.
 *
 * @see DILocation::getInlinedAt()
 */
ЛЛМетаданные ЛЛЛокацОИ_ДайИнлайнУ(ЛЛМетаданные Location);

/**
 * Get the metadata of the файл associated with a given scope.
 * \param Scope     The scope объект.
 *
 * @see DIScope::getFile()
 */
ЛЛМетаданные ЛЛМасштабОИ_ДайФайл(ЛЛМетаданные Scope);

/**
 * Get the directory of a given файл.
 * \param файл     The файл объект.
 * \param Len      The length of the returned ткст.
 *
 * @see DIFile::getDirectory()
 */
ткст0 ЛЛФайлОИ_ДайПапку(ЛЛМетаданные файл, бцел *Len);

/**
 * Get the имя of a given файл.
 * \param файл     The файл объект.
 * \param Len      The length of the returned ткст.
 *
 * @see DIFile::getFilename()
 */
ткст0 ЛЛФайлОИ_ДайИмяФ(ЛЛМетаданные файл, бцел *Len);

/**
 * Get the source of a given файл.
 * \param файл     The файл объект.
 * \param Len      The length of the returned ткст.
 *
 * @see DIFile::getSource()
 */
ткст0 ЛЛФайлОИ_ДайИсходник(ЛЛМетаданные файл, бцел *Len);

/**
 * Create a тип массив.
 * \param построитель        The DIBuilder.
 * \param Data           The тип elements.
 * \param NumElements    Number of тип elements.
 */
ЛЛМетаданные ЛЛПостроительОИ_ДайИлиСоздайМассивТипа(ЛЛПостроительОИ построитель,
                                                  ЛЛМетаданные *Data,
                                                  т_мера NumElements);

/**
 * Create subroutine тип.
 * \param построитель        The DIBuilder.
 * \param файл            The файл in which the subroutine resides.
 * \param ParameterTypes  An массив of subroutine параметр types. This
 *                        includes return тип at 0th инд.
 * \param NumParameterTypes The number of параметр types in \конст ParameterTypes
 * \param Flags           E.g.: \конст LLVMDIFlagLValueReference.
 *                        These flags are используется to emit dwarf attributes.
 */
ЛЛМетаданные
ЛЛПостроительОИ_СоздайТипПодпроцедуры(ЛЛПостроительОИ построитель,
                                  ЛЛМетаданные файл,
                                  ЛЛМетаданные *ParameterTypes,
                                  бцел NumParameterTypes,
                                  ЛЛФлагиОИ Flags);

/**
 * Create debugging information entry for an enumerator.
 * @param построитель        The DIBuilder.
 * @param имя           Enumerator имя.
 * @param длинаИм        длина of enumerator имя.
 * @param знач          Enumerator знач.
 * @param IsUnsigned     True if the знач is бцел.
 */
ЛЛМетаданные ЛЛПостроительОИ_СоздайПеречислитель(ЛЛПостроительОИ построитель,
                                              ткст0 имя, т_мера длинаИм,
                                              int64_t знач,
                                              ЛЛБул IsUnsigned);

/**
 * Create debugging information entry for an enumeration.
 * \param построитель        The DIBuilder.
 * \param Scope          Scope in which this enumeration is defined.
 * \param имя           Enumeration имя.
 * \param длинаИм        длина of enumeration имя.
 * \param файл           файл where this member is defined.
 * \param LineNumber     строка number.
 * \param SizeInBits     Member size.
 * \param AlignInBits    Member alignment.
 * \param Elements       Enumeration elements.
 * \param NumElements    Number of enumeration elements.
 * \param ClassTy        Underlying тип of a C++11/ObjC fixed enum.
 */
ЛЛМетаданные ЛЛПостроительОИ_СоздайТипПеречисления(
    ЛЛПостроительОИ построитель, ЛЛМетаданные Scope, ткст0 имя,
    т_мера длинаИм, ЛЛМетаданные файл, бцел LineNumber,
    дол SizeInBits, uint32_t AlignInBits, ЛЛМетаданные *Elements,
    бцел NumElements, ЛЛМетаданные ClassTy);

/**
 * Create debugging information entry for a union.
 * \param построитель      The DIBuilder.
 * \param Scope        Scope in which this union is defined.
 * \param имя         Union имя.
 * \param длинаИм      длина of union имя.
 * \param файл         файл where this member is defined.
 * \param LineNumber   строка number.
 * \param SizeInBits   Member size.
 * \param AlignInBits  Member alignment.
 * \param Flags        Flags to encode member attribute, e.g. private
 * \param Elements     Union elements.
 * \param NumElements  Number of union elements.
 * \param RunTimeLang  Optional параметр, Objective-к runtime version.
 * \param UniqueId     атр unique идентификатор for the union.
 * \param UniqueIdLen  длина of unique идентификатор.
 */
ЛЛМетаданные ЛЛПостроительОИ_СоздайТипСоюз(
    ЛЛПостроительОИ построитель, ЛЛМетаданные Scope, ткст0 имя,
    т_мера длинаИм, ЛЛМетаданные файл, бцел LineNumber,
    дол SizeInBits, uint32_t AlignInBits, ЛЛФлагиОИ Flags,
    ЛЛМетаданные *Elements, бцел NumElements, бцел RunTimeLang,
    ткст0 UniqueId, т_мера UniqueIdLen);


/**
 * Create debugging information entry for an массив.
 * \param построитель      The DIBuilder.
 * \param разм         МассивДРК size.
 * \param AlignInBits  Alignment.
 * \param тип           Element тип.
 * \param Subscripts   Subscripts.
 * \param NumSubscripts Number of subscripts.
 */
ЛЛМетаданные
ЛЛПостроительОИ_СоздайТипМассив(ЛЛПостроительОИ построитель, дол разм,
                             uint32_t AlignInBits, ЛЛМетаданные тип,
                             ЛЛМетаданные *Subscripts,
                             бцел NumSubscripts);

/**
 * Create debugging information entry for a vector тип.
 * \param построитель      The DIBuilder.
 * \param разм         Vector size.
 * \param AlignInBits  Alignment.
 * \param тип           Element тип.
 * \param Subscripts   Subscripts.
 * \param NumSubscripts Number of subscripts.
 */
ЛЛМетаданные
ЛЛПостроительОИ_СоздайТипВектор(ЛЛПостроительОИ построитель, дол разм,
                              uint32_t AlignInBits, ЛЛМетаданные тип,
                              ЛЛМетаданные *Subscripts,
                              бцел NumSubscripts);

/**
 * Create a DWARF unspecified тип.
 * \param построитель   The DIBuilder.
 * \param имя      The unspecified тип's имя.
 * \param длинаИм   длина of тип имя.
 */
ЛЛМетаданные
ЛЛПостроительОИ_СоздайНеукТип(ЛЛПостроительОИ построитель, ткст0 имя,
                                   т_мера длинаИм);

/**
 * Create debugging information entry for a basic
 * тип.
 * \param построитель     The DIBuilder.
 * \param имя        Тип имя.
 * \param длинаИм     длина of тип имя.
 * \param SizeInBits  разм of the тип.
 * \param Encoding    DWARF encoding code, e.g. \конст LLVMDWARFTypeEncoding_float.
 * \param Flags       Flags to encode optional attribute like endianity
 */
ЛЛМетаданные
ЛЛПостроительОИ_СоздайБазовыйТип(ЛЛПостроительОИ построитель, ткст0 имя,
                             т_мера длинаИм, дол SizeInBits,
                             ЛЛКодировкаТипаДВАРФ Encoding,
                             ЛЛФлагиОИ Flags);

/**
 * Create debugging information entry for a pointer.
 * \param построитель     The DIBuilder.
 * \param PointeeTy         Тип pointed by this pointer.
 * \param SizeInBits        разм.
 * \param AlignInBits       Alignment. (optional, pass 0 to ignore)
 * \param адрПрострво      DWARF address space. (optional, pass 0 to ignore)
 * \param имя              указатель тип имя. (optional)
 * \param длинаИм           длина of pointer тип имя. (optional)
 */
ЛЛМетаданные ЛЛПостроительОИ_СоздайТипУказатель(
    ЛЛПостроительОИ построитель, ЛЛМетаданные PointeeTy,
    дол SizeInBits, uint32_t AlignInBits, бцел адрПрострво,
    ткст0 имя, т_мера длинаИм);

/**
 * Create debugging information entry for a struct.
 * \param построитель     The DIBuilder.
 * \param Scope        Scope in which this struct is defined.
 * \param имя         Struct имя.
 * \param длинаИм      Struct имя length.
 * \param файл         файл where this member is defined.
 * \param LineNumber   строка number.
 * \param SizeInBits   Member size.
 * \param AlignInBits  Member alignment.
 * \param Flags        Flags to encode member attribute, e.g. private
 * \param Elements     Struct elements.
 * \param NumElements  Number of struct elements.
 * \param RunTimeLang  Optional параметр, Objective-к runtime version.
 * \param VTableHolder The объект containing the vtable for the struct.
 * \param UniqueId     атр unique идентификатор for the struct.
 * \param UniqueIdLen  длина of the unique идентификатор for the struct.
 */
ЛЛМетаданные ЛЛПостроительОИ_СоздайТипСтрукт(
    ЛЛПостроительОИ построитель, ЛЛМетаданные Scope, ткст0 имя,
    т_мера длинаИм, ЛЛМетаданные файл, бцел LineNumber,
    дол SizeInBits, uint32_t AlignInBits, ЛЛФлагиОИ Flags,
    ЛЛМетаданные DerivedFrom, ЛЛМетаданные *Elements,
    бцел NumElements, бцел RunTimeLang, ЛЛМетаданные VTableHolder,
    ткст0 UniqueId, т_мера UniqueIdLen);

/**
 * Create debugging information entry for a member.
 * \param построитель      The DIBuilder.
 * \param Scope        Member scope.
 * \param имя         Member имя.
 * \param длинаИм      длина of member имя.
 * \param файл         файл where this member is defined.
 * \param LineNo       строка number.
 * \param SizeInBits   Member size.
 * \param AlignInBits  Member alignment.
 * \param OffsetInBits Member смещение.
 * \param Flags        Flags to encode member attribute, e.g. private
 * \param тип           Parent тип.
 */
ЛЛМетаданные ЛЛПостроительОИ_СоздайТипЧлен(
    ЛЛПостроительОИ построитель, ЛЛМетаданные Scope, ткст0 имя,
    т_мера длинаИм, ЛЛМетаданные файл, бцел LineNo,
    дол SizeInBits, uint32_t AlignInBits, дол OffsetInBits,
    ЛЛФлагиОИ Flags, ЛЛМетаданные тип);

/**
 * Create debugging information entry for a
 * C++ static данные member.
 * \param построитель      The DIBuilder.
 * \param Scope        Member scope.
 * \param имя         Member имя.
 * \param длинаИм      длина of member имя.
 * \param файл         файл where this member is declared.
 * \param LineNumber   строка number.
 * \param Тип         Тип of the static member.
 * \param Flags        Flags to encode member attribute, e.g. private.
 * \param констЗнач  Const инициализатор of the member.
 * \param AlignInBits  Member alignment.
 */
ЛЛМетаданные
ЛЛПостроительОИ_СоздайТипСтатичЧлен(
    ЛЛПостроительОИ построитель, ЛЛМетаданные Scope, ткст0 имя,
    т_мера длинаИм, ЛЛМетаданные файл, бцел LineNumber,
    ЛЛМетаданные Тип, ЛЛФлагиОИ Flags, ЛЛЗначение констЗнач,
    uint32_t AlignInBits);

/**
 * Create debugging information entry for a pointer to member.
 * \param построитель      The DIBuilder.
 * \param PointeeType  Тип pointed to by this pointer.
 * \param ClassType    Тип for which this pointer points to члены of.
 * \param SizeInBits   разм.
 * \param AlignInBits  Alignment.
 * \param Flags        Flags.
 */
ЛЛМетаданные
ЛЛПостроительОИ_СоздайТипУкзНаЧлен(ЛЛПостроительОИ построитель,
                                     ЛЛМетаданные PointeeType,
                                     ЛЛМетаданные ClassType,
                                     дол SizeInBits,
                                     uint32_t AlignInBits,
                                     ЛЛФлагиОИ Flags);
/**
 * Create debugging information entry for Objective-к instance variable.
 * \param построитель      The DIBuilder.
 * \param имя         Member имя.
 * \param длинаИм      The length of the к ткст passed to \конст имя.
 * \param файл         файл where this member is defined.
 * \param LineNo       строка number.
 * \param SizeInBits   Member size.
 * \param AlignInBits  Member alignment.
 * \param OffsetInBits Member смещение.
 * \param Flags        Flags to encode member attribute, e.g. private
 * \param тип           Parent тип.
 * \param PropertyNode Property associated with this ivar.
 */
ЛЛМетаданные
ЛЛПостроительОИ_СоздайЦВарОбджСи(ЛЛПостроительОИ построитель,
                            ткст0 имя, т_мера длинаИм,
                            ЛЛМетаданные файл, бцел LineNo,
                            дол SizeInBits, uint32_t AlignInBits,
                            дол OffsetInBits, ЛЛФлагиОИ Flags,
                            ЛЛМетаданные тип, ЛЛМетаданные PropertyNode);

/**
 * Create debugging information entry for Objective-к property.
 * \param построитель            The DIBuilder.
 * \param имя               Property имя.
 * \param длинаИм            The length of the к ткст passed to \конст имя.
 * \param файл               файл where this property is defined.
 * \param LineNo             строка number.
 * \param GetterName         имя of the Objective к property getter selector.
 * \param GetterNameLen      The length of the к ткст passed to \конст GetterName.
 * \param SetterName         имя of the Objective к property setter selector.
 * \param SetterNameLen      The length of the к ткст passed to \конст SetterName.
 * \param PropertyAttributes Objective к property attributes.
 * \param тип                 Тип.
 */
ЛЛМетаданные
ЛЛПостроительОИ_СоздайСвойствоОбджСи(ЛЛПостроительОИ построитель,
                                ткст0 имя, т_мера длинаИм,
                                ЛЛМетаданные файл, бцел LineNo,
                                ткст0 GetterName, т_мера GetterNameLen,
                                ткст0 SetterName, т_мера SetterNameLen,
                                бцел PropertyAttributes,
                                ЛЛМетаданные тип);

/**
 * Create a uniqued DIType* clone with FlagObjectPointer and FlagArtificial set.
 * \param построитель   The DIBuilder.
 * \param Тип      The underlying тип to which this pointer points.
 */
ЛЛМетаданные
ЛЛПостроительОИ_СоздайТипУкзНаОбъект(ЛЛПостроительОИ построитель,
                                     ЛЛМетаданные Тип);

/**
 * Create debugging information entry for a qualified
 * тип, e.g. 'const цел'.
 * \param построитель     The DIBuilder.
 * \param тэг         тэг identifying тип,
 *                    e.g. LLVMDWARFTypeQualifier_volatile_type
 * \param Тип        Base Тип.
 */
ЛЛМетаданные
ЛЛПостроительОИ_СоздайКвалифицированныйТип(ЛЛПостроительОИ построитель, бцел тэг,
                                 ЛЛМетаданные Тип);

/**
 * Create debugging information entry for a конст++
 * style reference or rvalue reference тип.
 * \param построитель   The DIBuilder.
 * \param тэг       тэг identifying тип,
 * \param Тип      Base Тип.
 */
ЛЛМетаданные
ЛЛПостроительОИ_СоздайСсылочныйТип(ЛЛПостроительОИ построитель, бцел тэг,
                                 ЛЛМетаданные Тип);

/**
 * Create C++11 nullptr тип.
 * \param построитель   The DIBuilder.
 */
ЛЛМетаданные
ЛЛПостроительОИ_СоздайТипНуллУкз(ЛЛПостроительОИ построитель);

/**
 * Create debugging information entry for a alias.
 * \param построитель    The DIBuilder.
 * \param Тип       Original тип.
 * \param имя       Typedef имя.
 * \param файл       файл where this тип is defined.
 * \param LineNo     строка number.
 * \param Scope      The surrounding context for the alias.
 */
ЛЛМетаданные
ЛЛПостроительОИ_СоздайТипдеф(ЛЛПостроительОИ построитель, ЛЛМетаданные Тип,
                           ткст0 имя, т_мера длинаИм,
                           ЛЛМетаданные файл, бцел LineNo,
                           ЛЛМетаданные Scope);

/**
 * Create debugging information entry to establish inheritance relationship
 * between two types.
 * \param построитель       The DIBuilder.
 * \param тип            Original тип.
 * \param BaseTy        Base тип. тип is inherits from base.
 * \param BaseOffset    Base смещение.
 * \param VBPtrOffset  Virtual base pointer смещение.
 * \param Flags         Flags to describe inheritance attribute, e.g. private
 */
ЛЛМетаданные
ЛЛПостроительОИ_СоздайНаследование(ЛЛПостроительОИ построитель,
                               ЛЛМетаданные тип, ЛЛМетаданные BaseTy,
                               дол BaseOffset, uint32_t VBPtrOffset,
                               ЛЛФлагиОИ Flags);

/**
 * Create a permanent forward-declared тип.
 * \param построитель             The DIBuilder.
 * \param тэг                 атр unique tag for this тип.
 * \param имя                Тип имя.
 * \param длинаИм             длина of тип имя.
 * \param Scope               Тип scope.
 * \param файл                файл where this тип is defined.
 * \param строка                строка number where this тип is defined.
 * \param RuntimeLang         Indicates runtime version for languages like
 *                            Objective-к.
 * \param SizeInBits          Member size.
 * \param AlignInBits         Member alignment.
 * \param уникИд    атр unique идентификатор for the тип.
 * \param длнУникИд длина of the unique идентификатор.
 */
ЛЛМетаданные ЛЛПостроительОИ_СоздайФорвардДекл(
    ЛЛПостроительОИ построитель, бцел тэг, ткст0 имя,
    т_мера длинаИм, ЛЛМетаданные Scope, ЛЛМетаданные файл, бцел строка,
    бцел RuntimeLang, дол SizeInBits, uint32_t AlignInBits,
    ткст0 уникИд, т_мера длнУникИд);

/**
 * Create a temporary forward-declared тип.
 * \param построитель             The DIBuilder.
 * \param тэг                 атр unique tag for this тип.
 * \param имя                Тип имя.
 * \param длинаИм             длина of тип имя.
 * \param Scope               Тип scope.
 * \param файл                файл where this тип is defined.
 * \param строка                строка number where this тип is defined.
 * \param RuntimeLang         Indicates runtime version for languages like
 *                            Objective-к.
 * \param SizeInBits          Member size.
 * \param AlignInBits         Member alignment.
 * \param Flags               Flags.
 * \param уникИд    атр unique идентификатор for the тип.
 * \param длнУникИд длина of the unique идентификатор.
 */
ЛЛМетаданные
ЛЛПостроительОИ_СоздайПеремещаемыйСоставнойТип(
    ЛЛПостроительОИ построитель, бцел тэг, ткст0 имя,
    т_мера длинаИм, ЛЛМетаданные Scope, ЛЛМетаданные файл, бцел строка,
    бцел RuntimeLang, дол SizeInBits, uint32_t AlignInBits,
    ЛЛФлагиОИ Flags, ткст0 уникИд,
    т_мера длнУникИд);

/**
 * Create debugging information entry for a bit field member.
 * \param построитель             The DIBuilder.
 * \param Scope               Member scope.
 * \param имя                Member имя.
 * \param длинаИм             длина of member имя.
 * \param файл                файл where this member is defined.
 * \param LineNumber          строка number.
 * \param SizeInBits          Member size.
 * \param OffsetInBits        Member смещение.
 * \param StorageOffsetInBits Member storage смещение.
 * \param Flags               Flags to encode member attribute.
 * \param Тип                Parent тип.
 */
ЛЛМетаданные
ЛЛПостроительОИ_СоздайТипЧленПоля(ЛЛПостроительОИ построитель,
                                      ЛЛМетаданные Scope,
                                      ткст0 имя, т_мера длинаИм,
                                      ЛЛМетаданные файл, бцел LineNumber,
                                      дол SizeInBits,
                                      дол OffsetInBits,
                                      дол StorageOffsetInBits,
                                      ЛЛФлагиОИ Flags, ЛЛМетаданные Тип);

/**
 * Create debugging information entry for a class.
 * \param Scope               Scope in which this class is defined.
 * \param имя                класс имя.
 * \param длинаИм             The length of the к ткст passed to \конст имя.
 * \param файл                файл where this member is defined.
 * \param LineNumber          строка number.
 * \param SizeInBits          Member size.
 * \param AlignInBits         Member alignment.
 * \param OffsetInBits        Member смещение.
 * \param Flags               Flags to encode member attribute, e.g. private.
 * \param DerivedFrom         Debug info of the base class of this тип.
 * \param Elements            класс члены.
 * \param NumElements         Number of class elements.
 * \param VTableHolder        Debug info of the base class that содержит vtable
 *                            for this тип. This is используется in
 *                            DW_AT_containing_type. See DWARF documentation
 *                            for more info.
 * \param TemplateParamsNode  Template тип parameters.
 * \param уникИд    атр unique идентификатор for the тип.
 * \param длнУникИд длина of the unique идентификатор.
 */
ЛЛМетаданные ЛЛПостроительОИ_СоздайТипКласс(ЛЛПостроительОИ построитель,
    ЛЛМетаданные Scope, ткст0 имя, т_мера длинаИм,
    ЛЛМетаданные файл, бцел LineNumber, дол SizeInBits,
    uint32_t AlignInBits, дол OffsetInBits, ЛЛФлагиОИ Flags,
    ЛЛМетаданные DerivedFrom,
    ЛЛМетаданные *Elements, бцел NumElements,
    ЛЛМетаданные VTableHolder, ЛЛМетаданные TemplateParamsNode,
    ткст0 уникИд, т_мера длнУникИд);

/**
 * Create a uniqued DIType* clone with FlagArtificial set.
 * \param построитель     The DIBuilder.
 * \param Тип        The underlying тип.
 */
ЛЛМетаданные
ЛЛПостроительОИ_СоздайТипАртифициал(ЛЛПостроительОИ построитель,
                                  ЛЛМетаданные Тип);

/**
 * Get the имя of this DIType.
 * \param DType     The DIType.
 * \param длина    The length of the returned ткст.
 *
 * @see DIType::getName()
 */
ткст0 ЛЛТипОИ_ДайИмя(ЛЛМетаданные DType, т_мера *длина);

/**
 * Get the size of this DIType in bits.
 * \param DType     The DIType.
 *
 * @see DIType::getSizeInBits()
 */
дол ЛЛТипОИ_ДайРазмВБитах(ЛЛМетаданные DType);

/**
 * Get the смещение of this DIType in bits.
 * \param DType     The DIType.
 *
 * @see DIType::getOffsetInBits()
 */
дол ЛЛТипОИ_ДайСмещениеВБитах(ЛЛМетаданные DType);

/**
 * Get the alignment of this DIType in bits.
 * \param DType     The DIType.
 *
 * @see DIType::getAlignInBits()
 */
uint32_t ЛЛТипОИ_ДайРаскладкуВБитах(ЛЛМетаданные DType);

/**
 * Get the source line where this DIType is declared.
 * \param DType     The DIType.
 *
 * @see DIType::getLine()
 */
бцел ЛЛТипОИ_ДайСтроку(ЛЛМетаданные DType);

/**
 * Get the flags associated with this DIType.
 * \param DType     The DIType.
 *
 * @see DIType::getFlags()
 */
ЛЛФлагиОИ ЛЛТипОИ_ДайФлаги(ЛЛМетаданные DType);

/**
 * Create a descriptor for a знач range.
 * \param построитель    The DIBuilder.
 * \param LowerBound Lower bound of the subrange, e.g. 0 for к, 1 for Fortran.
 * \param чло      чло of elements in the subrange.
 */
ЛЛМетаданные ЛЛПостроительОИ_ДайИлиСоздайПоддиапазон(ЛЛПостроительОИ построитель,
                                                 int64_t LowerBound,
                                                 int64_t чло);

/**
 * Create an массив of диагИнфо Nodes.
 * \param построитель        The DIBuilder.
 * \param Data           The диагИнфо узел elements.
 * \param NumElements    Number of диагИнфо узел elements.
 */
ЛЛМетаданные ЛЛПостроительОИ_ДайИлиСоздайМассив(ЛЛПостроительОИ построитель,
                                              ЛЛМетаданные *Data,
                                              т_мера NumElements);

/**
 * Create a new descriptor for the specified variable which has a complex
 * address Выражение for its address.
 * \param построитель     The DIBuilder.
 * \param Addr        An массив of complex address operations.
 * \param длина      длина of the address operation массив.
 */
ЛЛМетаданные ЛЛПостроительОИ_СоздайВыражение(ЛЛПостроительОИ построитель,
                                              int64_t *Addr, т_мера длина);

/**
 * Create a new descriptor for the specified variable that does not have an
 * address, but does have a constant знач.
 * \param построитель     The DIBuilder.
 * \param знач       The constant знач.
 */
ЛЛМетаданные
ЛЛПостроительОИ_СОздайВыражениеКонстЗначения(ЛЛПостроительОИ построитель,
                                           int64_t знач);

/**
 * Create a new descriptor for the specified variable.
 * \param Scope       Variable scope.
 * \param имя        имя of the variable.
 * \param длинаИм     The length of the к ткст passed to \конст имя.
 * \param компоновка     Mangled  имя of the variable.
 * \param LinkLen     The length of the к ткст passed to \конст компоновка.
 * \param файл        файл where this variable is defined.
 * \param LineNo      строка number.
 * \param тип          Variable Тип.
 * \param LocalToUnit Boolean флаг indicate whether this variable is
 *                    externally visible or not.
 * \param Expr        The location of the глоб2 relative to the attached
 *                    GlobalVariable.
 * \param Decl        Reference to the corresponding declaration.
 *                    variables.
 * \param AlignInBits Variable alignment(or 0 if no alignment attr was
 *                    specified)
 */
ЛЛМетаданные ЛЛПостроительОИ_СоздайВыражениеГлобПеременной(
    ЛЛПостроительОИ построитель, ЛЛМетаданные Scope, ткст0 имя,
    т_мера длинаИм, ткст0 компоновка, т_мера LinkLen, ЛЛМетаданные файл,
    бцел LineNo, ЛЛМетаданные тип, ЛЛБул LocalToUnit,
    ЛЛМетаданные Expr, ЛЛМетаданные Decl, uint32_t AlignInBits);

/**
 * Retrieves the \конст DIVariable associated with this глоб2 variable Выражение.
 * \param GVE    The глоб2 variable Выражение.
 *
 * @see llvm::DIGlobalVariableВыражение::getVariable()
 */
ЛЛМетаданные ЛЛВыражениеГлобПеременной_ДайПеременную(ЛЛМетаданные GVE);

/**
 * Retrieves the \конст DIВыражение associated with this глоб2 variable Выражение.
 * \param GVE    The глоб2 variable Выражение.
 *
 * @see llvm::DIGlobalVariableВыражение::getВыражение()
 */
ЛЛМетаданные ЛЛВыражениеГлобПеременной_ДайВыражение(
    ЛЛМетаданные GVE);

/**
 * Get the metadata of the файл associated with a given variable.
 * \param Var     The variable объект.
 *
 * @see DIVariable::getFile()
 */
ЛЛМетаданные ЛЛПеременнаяОИ_ДайФайл(ЛЛМетаданные Var);

/**
 * Get the metadata of the scope associated with a given variable.
 * \param Var     The variable объект.
 *
 * @see DIVariable::getScope()
 */
ЛЛМетаданные ЛЛПеременнаяОИ_ДайМасштаб(ЛЛМетаданные Var);

/**
 * Get the source line where this \конст DIVariable is declared.
 * \param Var     The DIVariable.
 *
 * @see DIVariable::getLine()
 */
бцел ЛЛПеременнаяОИ_ДайСтроку(ЛЛМетаданные Var);

/**
 * Create a new temporary \конст MDNode.  Suitable for use in constructing cyclic
 * \конст MDNode structures. атр temporary \конст MDNode is not uniqued, may be RAUW'd,
 * and must be manually deleted with \конст LLVMDisposeTemporaryMDNode.
 * \param кткст            The context in which to construct the temporary узел.
 * \param Data           The metadata elements.
 * \param NumElements    Number of metadata elements.
 */
ЛЛМетаданные ЛЛВременныйУзелМД(ЛЛКонтекст кткст, ЛЛМетаданные *Data,
                                    т_мера NumElements);

/**
 * Deallocate a temporary узел.
 *
 * Calls \конст replaceAllUsesWith(nullptr) before deleting, so any remaining
 * references will be сбрось.
 * \param TempNode    The temporary metadata узел.
 */
проц ЛЛВыместиВременныйУзелМД(ЛЛМетаданные TempNode);

/**
 * Replace all uses of temporary metadata.
 * \param TempTargetMetadata    The temporary metadata узел.
 * \param Replacement           The replacement metadata узел.
 */
проц ЛЛМетаданные_ЗамениВсеИспользованияНа(ЛЛМетаданные TempTargetMetadata,
                                    ЛЛМетаданные Replacement);

/**
 * Create a new descriptor for the specified глоб2 variable that is temporary
 * and meant to be RAUWed.
 * \param Scope       Variable scope.
 * \param имя        имя of the variable.
 * \param длинаИм     The length of the к ткст passed to \конст имя.
 * \param компоновка     Mangled  имя of the variable.
 * \param LnkLen      The length of the к ткст passed to \конст компоновка.
 * \param файл        файл where this variable is defined.
 * \param LineNo      строка number.
 * \param тип          Variable Тип.
 * \param LocalToUnit Boolean флаг indicate whether this variable is
 *                    externally visible or not.
 * \param Decl        Reference to the corresponding declaration.
 * \param AlignInBits Variable alignment(or 0 if no alignment attr was
 *                    specified)
 */
ЛЛМетаданные ЛЛПостроительОИ_СоздайВремФорвардДеклГлобПерем(
    ЛЛПостроительОИ построитель, ЛЛМетаданные Scope, ткст0 имя,
    т_мера длинаИм, ткст0 компоновка, т_мера LnkLen, ЛЛМетаданные файл,
    бцел LineNo, ЛЛМетаданные тип, ЛЛБул LocalToUnit,
    ЛЛМетаданные Decl, uint32_t AlignInBits);

/**
 * Insert a new llvm.dbg.declare intrinsic call before the given instruction.
 * \param построитель     The DIBuilder.
 * \param Storage     The storage of the variable to declare.
 * \param VarInfo     The variable's debug info descriptor.
 * \param Expr        атр complex location Выражение for the variable.
 * \param DebugLoc    Debug info location.
 * \param инстр       Instruction acting as a location for the new intrinsic.
 */
ЛЛЗначение ЛЛПостроительОИ_ВставьДекларПеред(
  ЛЛПостроительОИ построитель, ЛЛЗначение Storage, ЛЛМетаданные VarInfo,
  ЛЛМетаданные Expr, ЛЛМетаданные DebugLoc, ЛЛЗначение инстр);

/**
 * Insert a new llvm.dbg.declare intrinsic call at the end of the given basic
 * блок. If the basic блок has a terminator instruction, the intrinsic is
 * inserted before that terminator instruction.
 * \param построитель     The DIBuilder.
 * \param Storage     The storage of the variable to declare.
 * \param VarInfo     The variable's debug info descriptor.
 * \param Expr        атр complex location Выражение for the variable.
 * \param DebugLoc    Debug info location.
 * \param блок       Basic блок acting as a location for the new intrinsic.
 */
ЛЛЗначение ЛЛПостроительОИ_ВставьДекларВКонце(
    ЛЛПостроительОИ построитель, ЛЛЗначение Storage, ЛЛМетаданные VarInfo,
    ЛЛМетаданные Expr, ЛЛМетаданные DebugLoc, ЛЛБазовыйБлок блок);

/**
 * Insert a new llvm.dbg.знач intrinsic call before the given instruction.
 * \param построитель     The DIBuilder.
 * \param знач         The знач of the variable.
 * \param VarInfo     The variable's debug info descriptor.
 * \param Expr        атр complex location Выражение for the variable.
 * \param DebugLoc    Debug info location.
 * \param инстр       Instruction acting as a location for the new intrinsic.
 */
ЛЛЗначение ЛЛПостроительОИ_ВставьОтладЗначениеПеред(ЛЛПостроительОИ построитель,
                                               ЛЛЗначение знач,
                                               ЛЛМетаданные VarInfo,
                                               ЛЛМетаданные Expr,
                                               ЛЛМетаданные DebugLoc,
                                               ЛЛЗначение инстр);

/**
 * Insert a new llvm.dbg.знач intrinsic call at the end of the given basic
 * блок. If the basic блок has a terminator instruction, the intrinsic is
 * inserted before that terminator instruction.
 * \param построитель     The DIBuilder.
 * \param знач         The знач of the variable.
 * \param VarInfo     The variable's debug info descriptor.
 * \param Expr        атр complex location Выражение for the variable.
 * \param DebugLoc    Debug info location.
 * \param блок       Basic блок acting as a location for the new intrinsic.
 */
ЛЛЗначение ЛЛПостроительОИ_ВставьОтладЗначениеВКонце(ЛЛПостроительОИ построитель,
                                              ЛЛЗначение знач,
                                              ЛЛМетаданные VarInfo,
                                              ЛЛМетаданные Expr,
                                              ЛЛМетаданные DebugLoc,
                                              ЛЛБазовыйБлок блок);

/**
 * Create a new descriptor for a local auto variable.
 * \param построитель         The DIBuilder.
 * \param Scope           The local scope the variable is declared in.
 * \param имя            Variable имя.
 * \param длинаИм         длина of variable имя.
 * \param файл            файл where this variable is defined.
 * \param LineNo          строка number.
 * \param тип              Metadata describing the тип of the variable.
 * \param AlwaysPreserve  If да, this descriptor will survive optimizations.
 * \param Flags           Flags.
 * \param AlignInBits     Variable alignment.
 */
ЛЛМетаданные ЛЛПостроительОИ_СоздайАвтоПеременную(
    ЛЛПостроительОИ построитель, ЛЛМетаданные Scope, ткст0 имя,
    т_мера длинаИм, ЛЛМетаданные файл, бцел LineNo, ЛЛМетаданные тип,
    ЛЛБул AlwaysPreserve, ЛЛФлагиОИ Flags, uint32_t AlignInBits);

/**
 * Create a new descriptor for a function параметр variable.
 * \param построитель         The DIBuilder.
 * \param Scope           The local scope the variable is declared in.
 * \param имя            Variable имя.
 * \param длинаИм         длина of variable имя.
 * \param ArgNo           Unique argument number for this variable; starts at 1.
 * \param файл            файл where this variable is defined.
 * \param LineNo          строка number.
 * \param тип              Metadata describing the тип of the variable.
 * \param AlwaysPreserve  If да, this descriptor will survive optimizations.
 * \param Flags           Flags.
 */
ЛЛМетаданные ЛЛПостроительОИ_СоздайПеременнуюПараметра(
    ЛЛПостроительОИ построитель, ЛЛМетаданные Scope, ткст0 имя,
    т_мера длинаИм, бцел ArgNo, ЛЛМетаданные файл, бцел LineNo,
    ЛЛМетаданные тип, ЛЛБул AlwaysPreserve, ЛЛФлагиОИ Flags);

/**
 * Get the metadata of the subprogram attached to a function.
 *
 * @see llvm::Function::getSubprogram()
 */
ЛЛМетаданные ЛЛДайПодпрограмму(ЛЛЗначение функц);

/**
 * Set the subprogram attached to a function.
 *
 * @see llvm::Function::setSubprogram()
 */
проц ЛЛУстПодпрограмму(ЛЛЗначение функц, ЛЛМетаданные SP);

/**
 * Get the line associated with a given subprogram.
 * \param подпрог     The subprogram объект.
 *
 * @see DISubprogram::getLine()
 */
бцел ЛЛПодпрогаОИ_ДайСтроку(ЛЛМетаданные подпрог);

/**
 * Get the debug location for the given instruction.
 *
 * @see llvm::Instruction::getDebugLoc()
 */
ЛЛМетаданные ЛЛИнструкция_ДайОтладЛок(ЛЛЗначение инстр);

/**
 * Set the debug location for the given instruction.
 *
 * To clear the location metadata of the given instruction, pass NULL to \p лок.
 *
 * @see llvm::Instruction::setDebugLoc()
 */
проц ЛЛИнструкция_УстОтладЛок(ЛЛЗначение инстр, ЛЛМетаданные лок);

/**
 * Obtain the enumerated тип of a Metadata instance.
 *
 * @see llvm::Metadata::getMetadataID()
 */
ЛЛРодМетаданных ЛЛДайРодМетаданных(ЛЛМетаданные Metadata);

} 
