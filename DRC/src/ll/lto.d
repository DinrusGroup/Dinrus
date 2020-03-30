
module ll.lto;
import ll.Types;


/**
 * @defgroup LLVMCLTO LTO
 * @ingroup LLVMC
 *
 * @{
 */

const LTO_API_VERSION = 24;

/**
 * \since prior to LTO_API_VERSION=3
 */
enum ЛЛАтрибутыСимволаОВК{
    ALIGNMENT_MASK              = 0x0000001F, /* log2 of alignment */
    PERMISSIONS_MASK            = 0x000000E0,
    PERMISSIONS_CODE            = 0x000000A0,
    PERMISSIONS_DATA            = 0x000000C0,
    PERMISSIONS_RODATA          = 0x00000080,
    DEFINITION_MASK             = 0x00000700,
    DEFINITION_REGULAR          = 0x00000100,
    DEFINITION_TENTATIVE        = 0x00000200,
    DEFINITION_WEAK             = 0x00000300,
    DEFINITION_UNDEFINED        = 0x00000400,
    DEFINITION_WEAKUNDEF        = 0x00000500,
    SCOPE_MASK                  = 0x00003800,
    SCOPE_INTERNAL              = 0x00000800,
    SCOPE_HIDDEN                = 0x00001000,
    SCOPE_PROTECTED             = 0x00002000,
    SCOPE_DEFAULT               = 0x00001800,
    SCOPE_DEFAULT_CAN_BE_HIDDEN = 0x00002800,
    COMDAT                      = 0x00004000,
    ALIAS                       = 0x00008000
} ;

/**
 * \since prior to LTO_API_VERSION=3
 */
enum ЛЛМодельОтладки{
    Нет         = 0,
    DWARF        = 1
} ;

/**
 * \since prior to LTO_API_VERSION=3
 */
enum ЛЛМодельОВККодген{
    Статическая         = 0,
    Динамическая        = 1,
    ДинамическаяБезПИК = 2,
    Дефолт        = 3
} ;

struct LLVMOpaqueLTOModule{}
/** opaque reference to a loaded объект модule */
alias LLVMOpaqueLTOModule *ЛЛОВКМодуль;

struct LLVMOpaqueLTOCodeGenerator{}
/** opaque reference to a code generator */
alias LLVMOpaqueLTOCodeGenerator *ЛЛОВККодГен;

struct LLVMOpaqueThinLTOCodeGenerator{}
/** opaque reference to a thin code generator */
alias LLVMOpaqueThinLTOCodeGenerator *ЛЛОВККодГен2;

extern (C){


/**
 * Возвращает a printable ткст.
 *
 * \since prior to LTO_API_VERSION=3
 */
 ткст0 ЛЛОВК_ДайВерсию();

/**
 * Возвращает the last error ткст or NULL if last operation was successful.
 *
 * \since prior to LTO_API_VERSION=3
 */
 ткст0 ЛЛОВК_ДайОшСооб();

/**
 * Checks if a файл is a loadable объект файл.
 *
 * \since prior to LTO_API_VERSION=3
 */
 бул ЛЛОВКМодуль_ФайлОбъект_ли(ткст0 путь);

/**
 * Checks if a файл is a loadable объект compiled for requested target.
 *
 * \since prior to LTO_API_VERSION=3
 */
 бул ЛЛОВКМодуль_ФайлОбъектДляЦели_ли(ткст0 путь,
                                     ткст0 префиксТриадыЦели);

/**
 * Return да if \p Buffer содержит a bitcode файл with ObjC code (category
 * or class) in it.
 *
 * \since LTO_API_VERSION=20
 */
 бул ЛЛОВКМодуль_ЕстьКатегорияОБджСи_ли(ук пам, т_мера длина);

/**
 * Checks if a буфер is a loadable объект файл.
 *
 * \since prior to LTO_API_VERSION=3
 */
 бул ЛЛОВКМодуль_ФайлОбъектВПамяти_ли(ук пам,
                                                      т_мера длина);

/**
 * Checks if a буфер is a loadable объект compiled for requested target.
 *
 * \since prior to LTO_API_VERSION=3
 */
 бул ЛЛОВКМодуль_ФайлОбъектВПамятиДляЦели_ли(ук пам, т_мера длина, ткст0 префиксТриадыЦели);

/**
 * Loads an объект файл from disk.
 * Возвращает NULL on error (check lto_get_error_message() for details).
 *
 * \since prior to LTO_API_VERSION=3
 */
 ЛЛОВКМодуль ЛЛОВКМодуль_Создай(ткст0 путь);

/**
 * Loads an объект файл from memory.
 * Возвращает NULL on error (check lto_get_error_message() for details).
 *
 * \since prior to LTO_API_VERSION=3
 */
 ЛЛОВКМодуль ЛЛОВКМодуль_СоздайИзПамяти(ук пам, т_мера длина);

/**
 * Loads an объект файл from memory with an extra путь argument.
 * Возвращает NULL on error (check lto_get_error_message() for details).
 *
 * \since LTO_API_VERSION=9
 */
 ЛЛОВКМодуль ЛЛОВКМодуль_СоздайИзПамятиСПутём(ук пам, т_мера длина, ткст0 путь);

/**
 * Loads an объект файл in its own context.
 *
 * Loads an объект файл in its own LLVMContext.  This function call is
 * thread-safe.  However, модules created this way should not be merged into an
 * ЛЛОВККодГен using \a lto_codegen_add_модule().
 *
 * Возвращает NULL on error (check lto_get_error_message() for details).
 *
 * \since LTO_API_VERSION=11
 */
 ЛЛОВКМодуль ЛЛОВКМодуль_СоздайВЛокКонтексте(ук пам, т_мера длина, ткст0 путь);

/**
 * Loads an объект файл in the codegen context.
 *
 * Loads an объект файл into the same context as \конст кг.  The модule is safe to
 * add using \a lto_codegen_add_модule().
 *
 * Возвращает NULL on error (check lto_get_error_message() for details).
 *
 * \since LTO_API_VERSION=11
 */
 ЛЛОВКМодуль ЛЛОВКМодуль_СоздайВКонтекстеКодГена(ук пам, т_мера длина, ткст0 путь, ЛЛОВККодГен кг);

/**
 * Loads an объект файл from disk. The seek point of фд is not preserved.
 * Возвращает NULL on error (check lto_get_error_message() for details).
 *
 * \since LTO_API_VERSION=5
 */
 ЛЛОВКМодуль ЛЛОВКМодуль_СоздайИзФД(цел фд, ткст0 путь, т_мера фразм);

/**
 * Loads an объект файл from disk. The seek point of фд is not preserved.
 * Возвращает NULL on error (check lto_get_error_message() for details).
 *
 * \since LTO_API_VERSION=5
 */
 ЛЛОВКМодуль ЛЛОВКМодуль_СоздайИзФДПоСмещению(цел фд, ткст0 путь, т_мера фразм, т_мера map_size, off_t смещение);

/**
 * Frees all memory internally allocated by the модule.
 * Upon return the ЛЛОВКМодуль is no longer valid.
 *
 * \since prior to LTO_API_VERSION=3
 */
 проц ЛЛОВКМодуль_Вымести(ЛЛОВКМодуль мод);

/**
 * Возвращает триада ткст which the объект модule was compiled under.
 *
 * \since prior to LTO_API_VERSION=3
 */
 ткст0 ЛЛОВКМодуль_ДайТриадуЦели(ЛЛОВКМодуль мод);

/**
 * Sets триада ткст with which the объект will be codegened.
 *
 * \since LTO_API_VERSION=4
 */
 проц ЛЛОВКМодуль_УстТриадуЦели(ЛЛОВКМодуль мод, ткст0 триада);

/**
 * Возвращает the number of символs in the объект модule.
 *
 * \since prior to LTO_API_VERSION=3
 */
 бцел ЛЛОВКМодуль_ДайЧлоСимволов(ЛЛОВКМодуль мод);

/**
 * Возвращает the имя of the ith символ in the объект модule.
 *
 * \since prior to LTO_API_VERSION=3
 */
 ткст0 ЛЛОВКМодуль_ДайИмяСимвола(ЛЛОВКМодуль мод, бцел инд);

/**
 * Возвращает the attributes of the ith символ in the объект модule.
 *
 * \since prior to LTO_API_VERSION=3
 */
 ЛЛАтрибутыСимволаОВК ЛЛОВКМодуль_ДайАтрибутыСимвола(ЛЛОВКМодуль мод, бцел инд);

/**
 * Возвращает the модule's linker опции.
 *
 * The linker опции may consist of multiple flags. It is the linker's
 * responsibility to split the flags using a platform-specific mechanism.
 *
 * \since LTO_API_VERSION=16
 */
 ткст0 ЛЛОВКМодуль_ДайОпцииКомпоновщика(ЛЛОВКМодуль мод);

/**
 * Diagnostic severity.
 *
 * \since LTO_API_VERSION=7
 */
enum ЛЛОВККодГенДиагностичСтрогость {
  LTO_DS_ERROR = 0,
  LTO_DS_WARNING = 1,
  LTO_DS_REMARK = 3, // Added in LTO_API_VERSION=10.
  LTO_DS_NOTE = 2
} ;

/**
 * Diagnostic handler тип.
 * \p severity defines the severity.
 * \p diag is the actual diagnostic.
 * The diagnostic is not prefixed by any of severity keyword, e.g., 'error: '.
 * \p ctxt is используется to pass the context set with the diagnostic handler.
 *
 * \since LTO_API_VERSION=7
 */
alias проц function(ЛЛОВККодГенДиагностичСтрогость строгость, ткст0 diag, ук ctxt)
	lto_diagnostic_handler_t;

/**
 * Set a diagnostic handler and the related context (ук ).
 * This is more general than lto_get_error_message, as the diagnostic handler
 * can be called at anytime within lto.
 *
 * \since LTO_API_VERSION=7
 */
 проц ЛЛОВККодГен_УстОбработчикДиагностики(ЛЛОВККодГен,
                                               lto_diagnostic_handler_t,
                                               ук );

/**
 * Instantiates a code generator.
 * Возвращает NULL on error (check lto_get_error_message() for details).
 *
 * All модules added using \a lto_codegen_add_модule() must have been created
 * in the same context as the codegen.
 *
 * \since prior to LTO_API_VERSION=3
 */
 ЛЛОВККодГен ЛЛОВККодГен_Создай();

/**
 * Instantiate a code generator in its own context.
 *
 * Instantiates a code generator in its own context.  Modules added via \a
 * lto_codegen_add_модule() must have all been created in the same context,
 * using \a lto_модule_create_in_codegen_context().
 *
 * \since LTO_API_VERSION=11
 */
 ЛЛОВККодГен ЛЛОВККодГен_СоздайВЛокКонтексте();

/**
 * Frees all code generator and all memory it internally allocated.
 * Upon return the ЛЛОВККодГен is no longer valid.
 *
 * \since prior to LTO_API_VERSION=3
 */
 проц ЛЛОВККодГен_Вымести(ЛЛОВККодГен);

/**
 * Add an объект модule to the set of модules for which code will be generated.
 * Возвращает да on error (check lto_get_error_message() for details).
 *
 * \конст кг and \конст мод must both be in the same context.  See \a
 * lto_codegen_create_in_local_context() and \a
 * lto_модule_create_in_codegen_context().
 *
 * \since prior to LTO_API_VERSION=3
 */
 бул ЛЛОВККодГен_ДобавьМодуль(ЛЛОВККодГен кг, ЛЛОВКМодуль мод);

/**
 * Sets the объект модule for code generation. This will transfer the ownership
 * of the модule to the code generator.
 *
 * \конст кг and \конст мод must both be in the same context.
 *
 * \since LTO_API_VERSION=13
 */
 проц ЛЛОВККодГен_УстМодуль(ЛЛОВККодГен кг, ЛЛОВКМодуль мод);

/**
 * Sets if debug info should be generated.
 * Возвращает да on error (check lto_get_error_message() for details).
 *
 * \since prior to LTO_API_VERSION=3
 */
 бул ЛЛОВККодГен_УстМодельОтладки(ЛЛОВККодГен кг, ЛЛМодельОтладки);

/**
 * Sets which PIC code модel to generated.
 * Возвращает да on error (check lto_get_error_message() for details).
 *
 * \since prior to LTO_API_VERSION=3
 */
 бул ЛЛОВККодГен_УстМодельПИК(ЛЛОВККодГен кг, ЛЛМодельОВККодген);

/**
 * Sets the цпб to generate code for.
 *
 * \since LTO_API_VERSION=4
 */
 проц ЛЛОВККодГен_УстЦПБ(ЛЛОВККодГен кг, ткст0 цпб);

/**
 * Sets the location of the assembler tool to run. If not set, libLTO
 * will use gcc to invoke the assembler.
 *
 * \since LTO_API_VERSION=3
 */
 проц ЛЛОВККодГен_УстАсмПуть(ЛЛОВККодГен кг, ткст0 путь);

/**
 * Sets extra arguments that libLTO should pass to the assembler.
 *
 * \since LTO_API_VERSION=4
 */
 проц ЛЛОВККодГен_УстАсмАрги(ЛЛОВККодГен кг, ткст0 *args, цел члоАрг);

/**
 * Adds to a list of all глоб2 символs that must exist in the final generated
 * code. If a function is not listed there, it might be inlined into every использование
 * and optimized away.
 *
 * \since prior to LTO_API_VERSION=3
 */
 проц ЛЛОВККодГен_ДобавьСимволМастПрезерв(ЛЛОВККодГен кг, ткст0 символ);

/**
 * Writes a new объект файл at the specified путь that содержит the
 * merged contents of all модules added so far.
 * Возвращает да on error (check lto_get_error_message() for details).
 *
 * \since LTO_API_VERSION=5
 */
 бул ЛЛОВККодГен_ПишиСлитноМодуль(ЛЛОВККодГен кг, ткст0 путь);

/**
 * Generates code for all added модules into one native объект файл.
 * This calls lto_codegen_optimize then lto_codegen_compile_optimized.
 *
 * On успех returns a pointer to a generated mach-o/ELF буфер and
 * длина set to the буфер size.  The буфер is owned by the
 * ЛЛОВККодГен and will be freed when lto_codegen_dispose()
 * is called, or lto_codegen_compile() is called again.
 * On failure, returns NULL (check lto_get_error_message() for details).
 *
 * \since prior to LTO_API_VERSION=3
 */
 ук ЛЛОВККодГен_Компилируй(ЛЛОВККодГен кг, т_мера* длина);

/**
 * Generates code for all added модules into one native объект файл.
 * This calls lto_codegen_optimize then lto_codegen_compile_optimized (instead
 * of returning a generated mach-o/ELF буфер, it writes to a файл).
 *
 * The имя of the файл is written to имя. Возвращает да on error.
 *
 * \since LTO_API_VERSION=5
 */
 бул ЛЛОВККодГен_КомпилируйВФайл(ЛЛОВККодГен кг, ткст0* имя);

/**
 * Runs optimization for the merged модule. Возвращает да on error.
 *
 * \since LTO_API_VERSION=12
 */
 бул ЛЛОВККодГен_Оптимизируй(ЛЛОВККодГен кг);

/**
 * Generates code for the optimized merged модule into one native объект файл.
 * It will not run any IR optimizations on the merged модule.
 *
 * On успех returns a pointer to a generated mach-o/ELF буфер and длина set
 * to the буфер size.  The буфер is owned by the ЛЛОВККодГен and will be
 * freed when lto_codegen_dispose() is called, or
 * lto_codegen_compile_optimized() is called again. On failure, returns NULL
 * (check lto_get_error_message() for details).
 *
 * \since LTO_API_VERSION=12
 */
 ук ЛЛОВККодГен_КомпилируйОптимиз(ЛЛОВККодГен кг, т_мера* длина);

/**
 * Возвращает the runtime API version.
 *
 * \since LTO_API_VERSION=12
 */
 бцел ЛЛОВКАПИВерсия();

/**
 * Sets опции to help debug codegen bugs.
 *
 * \since prior to LTO_API_VERSION=3
 */
 проц ЛЛОВККодГен_ОпцииОтладки(ЛЛОВККодГен кг, ткст0 );

/**
 * Initializes LLVM disassemblers.
 * FIXME: This doesn't really belong here.
 *
 * \since LTO_API_VERSION=5
 */
 проц ЛЛОВК_ИницДизасм();

/**
 * Sets if we should run internalize pass during optimization and code
 * generation.
 *
 * \since LTO_API_VERSION=14
 */
 проц ЛЛОВККодГен_УстСледуетИнтернализовать(ЛЛОВККодГен кг, бул интернализовать_ли);

/**
 * Set whether to embed uselists in bitcode.
 *
 * Sets whether \a lto_codegen_write_merged_модules() should embed uselists in
 * output bitcode.  This should be turned on for all -save-temps output.
 *
 * \since LTO_API_VERSION=15
 */
 проц ЛЛОВККодГен_УстСледуетВнедритьСписокИспользований(ЛЛОВККодГен кг, бул ShouldEmbedUselists);

/**
 * @} // endgoup LLVMCLTO
 * @defgroup LLVMCTLTO ThinLTO
 * @ingroup LLVMC
 *
 * @{
 */

/**
 * Тип to wrap a single объект returned by ThinLTO.
 *
 * \since LTO_API_VERSION=18
 */
struct БуферОбъектовОВК {
  ткст0 буфер;
  т_мера разм;
} ;

/**
 * Instantiates a ThinLTO code generator.
 * Возвращает NULL on error (check lto_get_error_message() for details).
 *
 *
 * The ThinLTOCodeGenerator is not intended to be reuse for multiple
 * compilation: the модel is that the client adds модules to the generator and
 * ask to perform the ThinLTO optimizations / codegen, and finally destroys the
 * codegenerator.
 *
 * \since LTO_API_VERSION=18
 */
 ЛЛОВККодГен2 ЛЛОВК2_СоздайКодГен();

/**
 * Frees the generator and all memory it internally allocated.
 * Upon return the ЛЛОВККодГен2 is no longer valid.
 *
 * \since LTO_API_VERSION=18
 */
 проц ЛЛОВК2_ВыместиКодГен(ЛЛОВККодГен2 кг);

/**
 * Add a модule to a ThinLTO code generator. Идентификатор2 has to be unique among
 * all the модules in a code generator. The данные буфер stays owned by the
 * client, and is expected to be доступно for the entire lifetime of the
 * ЛЛОВККодГен2 it is added to.
 *
 * On failure, returns NULL (check lto_get_error_message() for details).
 *
 *
 * \since LTO_API_VERSION=18
 */
 проц ЛЛОВК2_ДобавьМодуль(ЛЛОВККодГен2 кг,
                                       ткст0 идентификатор, ткст0 данные, цел длина);

/**
 * Optimize and codegen all the модules added to the codegenerator using
 * ThinLTO. результатing objects are accessible using thinlto_модule_get_object().
 *
 * \since LTO_API_VERSION=18
 */
 проц ЛЛОВК2КодГен_Обработай(ЛЛОВККодГен2 кг);

/**
 * Возвращает the number of объект files produced by the ThinLTO CodeGenerator.
 *
 * It usually matches the number of input files, but this is not a guarantee of
 * the API and may change in future implementation, so the client should not
 * assume it.
 *
 * \since LTO_API_VERSION=18
 */
 бцел ЛЛОВК2Модуль_ДайЧлоОбъектов(ЛЛОВККодГен2 кг);

/**
 * Возвращает a reference to the ith объект файл produced by the ThinLTO
 * CodeGenerator.
 *
 * Client should use \p thinlto_модule_get_num_objects() to get the number of
 * доступно objects.
 *
 * \since LTO_API_VERSION=18
 */
 БуферОбъектовОВК ЛЛОВК2Модуль_ДайОбъект(ЛЛОВККодГен2 кг, бцел инд);

/**
 * Возвращает the number of объект files produced by the ThinLTO CodeGenerator.
 *
 * It usually matches the number of input files, but this is not a guarantee of
 * the API and may change in future implementation, so the client should not
 * assume it.
 *
 * \since LTO_API_VERSION=21
 */
бцел ЛЛОВК2Модуль_ДайЧлоОбъектФайлов(ЛЛОВККодГен2 кг);

/**
 * Возвращает the путь to the ith объект файл produced by the ThinLTO
 * CodeGenerator.
 *
 * Client should use \p thinlto_модule_get_num_object_files() to get the number
 * of доступно objects.
 *
 * \since LTO_API_VERSION=21
 */
ткст0 ЛЛОВК2Модуль_ДайОбъектФайл(ЛЛОВККодГен2 кг, бцел инд);

/**
 * Sets which PIC code модel to generate.
 * Возвращает да on error (check lto_get_error_message() for details).
 *
 * \since LTO_API_VERSION=18
 */
 бул ЛЛОВК2КодГен_УстМодельПИК(ЛЛОВККодГен2 кг, ЛЛМодельОВККодген модель);

/**
 * Sets the путь to a directory to use as a storage for temporary bitcode files.
 * The intention is to make the bitcode files доступно for debugging at various
 * stage of the pipeline.
 *
 * \since LTO_API_VERSION=18
 */
 проц ЛЛОВК2КодГен_УстПапкуВремХран(ЛЛОВККодГен2 кг, ткст0 времХранПап);

/**
 * Set the путь to a directory where to save generated объект files. This
 * путь can be используется by a linker to request on-disk files instead of in-memory
 * buffers. When set, результатs are доступно through
 * thinlto_модule_get_object_file() instead of thinlto_модule_get_object().
 *
 * \since LTO_API_VERSION=21
 */
проц ЛЛОВК2КодГен_УстПапкуСгенОбъектов(ЛЛОВККодГен2 кг, ткст0 времХранПап);

/**
 * Sets the цпб to generate code for.
 *
 * \since LTO_API_VERSION=18
 */
 проц ЛЛОВК2КодГен_УстЦПБ(ЛЛОВККодГен2 кг, ткст0 цпб);

/**
 * Disable CodeGen, only run the stages till codegen and stop. The output will
 * be bitcode.
 *
 * \since LTO_API_VERSION=19
 */
 проц ЛЛОВК2КодГен_ОтключиКодГен(ЛЛОВККодГен2 кг, бул отключить_ли);

/**
 * Perform CodeGen only: disable all other stages.
 *
 * \since LTO_API_VERSION=19
 */
 проц ЛЛОВК2КодГен_УстТолькоКодГен(ЛЛОВККодГен2 кг, бул codegen_only);

/**
 * Parse -mllvm style debug опции.
 *
 * \since LTO_API_VERSION=18
 */
 проц ЛЛОВК2_ОпцииОтладки(ткст0 *опции, цел number);

/**
 * Test if a модule has support for ThinLTO linking.
 *
 * \since LTO_API_VERSION=18
 */
 бул ЛЛОВКМодуль_ОВК2_ли(ЛЛОВКМодуль мод);

/**
 * Adds a символ to the list of глоб2 символs that must exist in the final
 * generated code. If a function is not listed there, it might be inlined into
 * every использование and optimized away. For every single модule, the functions
 * referenced from code outside of the ThinLTO модules need to be added here.
 *
 * \since LTO_API_VERSION=18
 */
 проц ЛЛОВК2КодГен_ДобавьСимволМастПрезерв(ЛЛОВККодГен2 кг,
                                                     ткст0 имя,
                                                     цел длина);

/**
 * Adds a символ to the list of глоб2 символs that are cross-referenced between
 * ThinLTO files. If the ThinLTO CodeGenerator can ensure that every
 * references from a ThinLTO модule to this символ is optimized away, then
 * the символ can be discarded.
 *
 * \since LTO_API_VERSION=18
 */
 проц ЛЛОВК2КодГен_ДобавьКроссРефСимвол(ЛЛОВККодГен2 кг,
                                                        ткст0 имя,
                                                        цел длина);

/**
 * @} // endgoup LLVMCTLTO
 * @defgroup LLVMCTLTO_CACHING ThinLTO Cache Control
 * @ingroup LLVMCTLTO
 *
 * These entry points control the ThinLTO cache. The cache is intended to
 * support incremental builds, and thus needs to be persistent across builds.
 * The client enables the cache by supplying a путь to an existing directory.
 * The code generator will use this to store objects files that may be reused
 * during a subsequent построй.
 * To avoid filling the disk space, a few knobs are provided:
 *  - The pruning interval limits the frequency at which the garbage collector
 *    will try to scan the cache directory to prune expired entries.
 *    Setting to a negative number disables the pruning.
 *  - The pruning expiration time indicates to the garbage collector how old an
 *    entry needs to be to be removed.
 *  - Finally, the garbage collector can be instructed to prune the cache until
 *    the occupied space goes below a threshold.
 * @{
 */

/**
 * Sets the путь to a directory to use as a cache storage for incremental построй.
 * Setting this activates caching.
 *
 * \since LTO_API_VERSION=18
 */
 проц ЛЛОВК2КодГен_УстПапкуКэша(ЛЛОВККодГен2 кг,
                                          ткст0 cache_dir);

/**
 * Sets the cache pruning interval (in seconds). атр negative знач disables the
 * pruning. An unspecified default знач will be applied, and a знач of 0 will
 * force prunning to occur.
 *
 * \since LTO_API_VERSION=18
 */
 проц ЛЛОВК2КодГен_УстИнтервалПрюнингаКэша(ЛЛОВККодГен2 кг,
                                                       цел interval);

/**
 * Sets the maximum cache size that can be persistent across построй, in terms of
 * percentage of the доступно space on the disk. Set to 100 to indicate
 * no limit, 50 to indicate that the cache size will not be left over half the
 * доступно space. атр знач over 100 will be reduced to 100, a знач of 0 will
 * be ignored. An unspecified default знач will be applied.
 *
 * The formula looks like:
 *  AvailableSpace = FreeSpace + ExistingCacheSize
 *  NewCacheSize = AvailableSpace * P/100
 *
 * \since LTO_API_VERSION=18
 */
 проц ЛЛОВК2КодГен_УстФинальнРазКэшаОтносительноДоступнПрострву(
    ЛЛОВККодГен2 кг, бцел percentage);

/**
 * Sets the expiration (in seconds) for an entry in the cache. An unspecified
 * default знач will be applied. атр знач of 0 will be ignored.
 *
 * \since LTO_API_VERSION=18
 */
 проц ЛЛОВК2КодГен_УстЭкспирациюЗаписиКэша(ЛЛОВККодГен2 кг,
                                                       бцел expiration);

/**
 * Sets the maximum size of the cache directory (in bytes). атр знач over the
 * amount of доступно space on the disk will be reduced to the amount of
 * доступно space. An unspecified default знач will be applied. атр знач of 0
 * will be ignored.
 *
 * \since LTO_API_VERSION=22
 */
 проц ЛЛОВК2КодГен_УстРазмКэшаВБайтах(ЛЛОВККодГен2 кг,
                                                 бцел max_size_bytes);

/**
 * Same as thinlto_codegen_set_cache_size_bytes, except the maximum size is in
 * megabytes (2^20 bytes).
 *
 * \since LTO_API_VERSION=23
 */
 проц ЛЛОВК2КодГен_УстРазмКэшаВМегаБайтах(ЛЛОВККодГен2 кг,
                                         бцел max_size_megabytes);

/**
 * Sets the maximum number of files in the cache directory. An unspecified
 * default знач will be applied. атр знач of 0 will be ignored.
 *
 * \since LTO_API_VERSION=22
 */
 проц ЛЛОВК2КодГен_УстРазмКэшаВФайлах(ЛЛОВККодГен2 кг, бцел max_size_files);

struct LLVMOpaqueLTOInput{}
/** Opaque reference to an LTO input файл */
alias LLVMOpaqueLTOInput *ЛЛОВКВвод;

/**
  * Creates an LTO input файл from a буфер. The путь
  * argument is используется for diagnotics as this function
  * otherwise does not know which файл the given буфер
  * is associated with.
  *
  * \since LTO_API_VERSION=24
  */
 ЛЛОВКВвод ЛЛОВКВвод_Создай(ук буф, т_мера размБуф, ткст0 путь);

/**
  * Frees all memory internally allocated by the LTO input файл.
  * Upon return the ЛЛОВКМодуль is no longer valid.
  *
  * \since LTO_API_VERSION=24
  */
 проц ЛЛОВКВвод_Вымести(ЛЛОВКВвод ввод);

/**
  * Возвращает the number of dependent library specifiers
  * for the given LTO input файл.
  *
  * \since LTO_API_VERSION=24
  */
 бцел ЛЛОВКВвод_ДайЧлоЗависимыхБиб(ЛЛОВКВвод ввод);

/**
  * Возвращает the ith dependent library specifier
  * for the given LTO input файл. The returned
  * ткст is not null-terminated.
  *
  * \since LTO_API_VERSION=24
  */
 ткст0  ЛЛОВКВвод_ДайЗависимБиб(ЛЛОВКВвод input, т_мера инд,т_мера *разм);


}
