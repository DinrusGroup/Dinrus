
module ll.Remarks;
import ll.Types;

extern (C){

/**
 * @defgroup LLVMCREMARKS Remarks
 * @ingroup LLVMC
 *
 * @{
 */

const REMARKS_API_VERSION = 0;

/**
 * The тип of the emitted remark.
 */
enum LLVMRemarkType {
  Unknown,
  Passed,
  Missed,
  Analysis,
  AnalysisFPCommute,
  AnalysisAliasing,
  Failure
};

/**
 * текст containing a буфер and a length. The буфер is not guaranteed to be
 * нуль-terminated.
 *
 * \since REMARKS_API_VERSION=0
 */
struct LLVMRemarkOpaqueтекст;
alias LLVMRemarkOpaqueтекст *ЛЛТкстРемарки;

/**
 * Возвращает the буфер holding the ткст.
 *
 * \since REMARKS_API_VERSION=0
 */
 ткст0 ЛЛТкстРемарки_ДайДанные(ЛЛТкстРемарки текст);

/**
 * Возвращает the size of the ткст.
 *
 * \since REMARKS_API_VERSION=0
 */
 uint32_t ЛЛТкстРемарки_ДайДлину(ЛЛТкстРемарки текст);

/**
 * DebugLoc containing Файл, Line and Column.
 *
 * \since REMARKS_API_VERSION=0
 */
struct LLVMRemarkOpaqueDebugLoc;
alias LLVMRemarkOpaqueDebugLoc *ЛЛОтладЛокРемарки;

/**
 * Return the path to the source файл for a debug location.
 *
 * \since REMARKS_API_VERSION=0
 */
 ЛЛТкстРемарки
ЛЛОтладЛокРемарки_ДайПутьКИсходнику(ЛЛОтладЛокРемарки DL);

/**
 * Return the line in the source файл for a debug location.
 *
 * \since REMARKS_API_VERSION=0
 */
 uint32_t ЛЛОтладЛокРемарки_ДайСтрокуИсходника(ЛЛОтладЛокРемарки DL);

/**
 * Return the column in the source файл for a debug location.
 *
 * \since REMARKS_API_VERSION=0
 */
 uint32_t ЛЛОтладЛокРемарки_ДайСтолбецИсходника(ЛЛОтладЛокРемарки DL);

/**
 * Element of the "арги" list. The ключ might give more information about what
 * the semantics of the знач are, e.g. "Callee" will tell you that the знач
 * is a symbol that имена a function.
 *
 * \since REMARKS_API_VERSION=0
 */
struct LLVMRemarkOpaqueArg{}
alias LLVMRemarkOpaqueArg *ЛЛАргРемарки;

/**
 * Возвращает the ключ of an argument. The ключ defines what the знач is, and the
 * same ключ can appear multiple times in the list of arguments.
 *
 * \since REMARKS_API_VERSION=0
 */
 ЛЛТкстРемарки ЛЛАргРемарки_ДайКлюч(ЛЛАргРемарки арг);

/**
 * Возвращает the знач of an argument. This is a ткст that can contain newlines.
 *
 * \since REMARKS_API_VERSION=0
 */
 ЛЛТкстРемарки ЛЛАргРемарки_ДайЗначение(ЛЛАргРемарки арг);

/**
 * Возвращает the debug location that is attached to the знач of this argument.
 *
 * If there is no debug location, the return знач will be `NULL`.
 *
 * \since REMARKS_API_VERSION=0
 */
 ЛЛОтладЛокРемарки ЛЛАргРемарки_ДайОтладЛок(ЛЛАргРемарки арг);

/**
 * атр remark emitted by the compiler.
 *
 * \since REMARKS_API_VERSION=0
 */
struct LLVMRemarkOpaqueEntry{}
alias LLVMRemarkOpaqueEntry *ЛЛЗаписьРемарки;

/**
 * Free the resources используется by the remark entry.
 *
 * \since REMARKS_API_VERSION=0
 */
 проц ЛЛЗаписьРемарки_Вымести(ЛЛЗаписьРемарки Remark);

/**
 * The тип of the remark. For example, it can allow users to only keep the
 * missed optimizations from the compiler.
 *
 * \since REMARKS_API_VERSION=0
 */
 LLVMRemarkType ЛЛЗаписьРемарки_ДайТип(ЛЛЗаписьРемарки Remark);

/**
 * Get the имя of the pass that emitted this remark.
 *
 * \since REMARKS_API_VERSION=0
 */
 ЛЛТкстРемарки
ЛЛЗаписьРемарки_ДайИмяПроходки(ЛЛЗаписьРемарки Remark);

/**
 * Get an идентификатор of the remark.
 *
 * \since REMARKS_API_VERSION=0
 */
 ЛЛТкстРемарки
ЛЛЗаписьРемарки_ДайИмяРемарки(ЛЛЗаписьРемарки Remark);

/**
 * Get the имя of the function being processed when the remark was emitted.
 *
 * \since REMARKS_API_VERSION=0
 */
 ЛЛТкстРемарки
ЛЛЗаписьРемарки_ДайИмяФункции(ЛЛЗаписьРемарки Remark);

/**
 * Возвращает the debug location that is attached to this remark.
 *
 * If there is no debug location, the return знач will be `NULL`.
 *
 * \since REMARKS_API_VERSION=0
 */
 ЛЛОтладЛокРемарки
ЛЛЗаписьРемарки_ДайОтладЛок(ЛЛЗаписьРемарки Remark);

/**
 * Return the hotness of the remark.
 *
 * атр hotness of `0` means this знач is not set.
 *
 * \since REMARKS_API_VERSION=0
 */
 дол ЛЛЗаписьРемарки_ДайАктуальность(ЛЛЗаписьРемарки Remark);

/**
 * The number of arguments the remark holds.
 *
 * \since REMARKS_API_VERSION=0
 */
 uint32_t ЛЛЗаписьРемарки_ДайЧлоАргов(ЛЛЗаписьРемарки Remark);

/**
 * Get a new iterator to iterate over a remark's argument.
 *
 * If there are no arguments in \p Remark, the return знач will be `NULL`.
 *
 * The lifetime of the returned знач is bound to the lifetime of \p Remark.
 *
 * \since REMARKS_API_VERSION=0
 */
 ЛЛАргРемарки ЛЛЗаписьРемарки_ДайПервАрг(ЛЛЗаписьРемарки Remark);

/**
 * Get the следщ argument in \p Remark from the position of \p It.
 *
 * Возвращает `NULL` if there are no more arguments доступно.
 *
 * The lifetime of the returned знач is bound to the lifetime of \p Remark.
 *
 * \since REMARKS_API_VERSION=0
 */
 ЛЛАргРемарки ЛЛЗаписьРемарки_ДайСледщАрг(ЛЛАргРемарки It,
                                                  ЛЛЗаписьРемарки Remark);

struct LLVMRemarkOpaqueпарсер;
alias LLVMRemarkOpaqueпарсер *ЛЛПарсерРемарок;

/**
 * Creates a remark parser that can be используется to parse the буфер located in \p
 * Buf of size \p разм bytes.
 *
 * \p Buf cannot be `NULL`.
 *
 * This function should be paired with LLVMRemarkпарсерDispose() to avoid
 * leaking resources.
 *
 * \since REMARKS_API_VERSION=0
 */
 ЛЛПарсерРемарок ЛЛПарсерРемарок_СоздайЙАМЛ(ук Buf,
                                                      дол разм);

/**
 * Возвращает the следщ remark in the файл.
 *
 * The знач pointed to by the return знач needs to be disposed using a call to
 * LLVMRemarkEntryDispose().
 *
 * All the entries in the returned знач that are of ЛЛТкстРемарки тип
 * will become invalidated once a call to LLVMRemarkпарсерDispose is made.
 *
 * If the parser reaches the end of the буфер, the return знач will be `NULL`.
 *
 * In the case of an error, the return знач will be `NULL`, and:
 *
 * 1) LLVMRemarkпарсерHasError() will return `1`.
 *
 * 2) LLVMRemarkпарсерGetErrorMessage() will return a descriptive error
 *    message.
 *
 * An error may occur if:
 *
 * 1) An argument is invalid.
 *
 * 2) There is a parsing error. This can occur on things like malformed YAML.
 *
 * 3) There is a Remark semantic error. This can occur on well-formed files with
 *    missing or extra fields.
 *
 * Here is a quick example of the использование:
 *
 * ```
 * ЛЛПарсерРемарок парсер = LLVMRemarkParserCreateYAML(Buf, разм);
 * ЛЛЗаписьРемарки Remark = NULL;
 * while ((Remark = LLVMRemarkParserGetNext(парсер))) {
 *    // use Remark
 *    LLVMRemarkEntryDispose(Remark); // Release memory.
 * }
 * бул HasError = LLVMRemarkParserHasError(парсер);
 * LLVMRemarkParserDispose(парсер);
 * ```
 *
 * \since REMARKS_API_VERSION=0
 */
 ЛЛЗаписьРемарки ЛЛПарсерРемарок_ДайСледщ(ЛЛПарсерРемарок парсер);

/**
 * Возвращает `1` if the parser encountered an error while parsing the буфер.
 *
 * \since REMARKS_API_VERSION=0
 */
 ЛЛБул ЛЛПарсерРемарок_ЕстьОш_ли(ЛЛПарсерРемарок парсер);

/**
 * Возвращает a null-terminated ткст containing an error message.
 *
 * In case of no error, the результат is `NULL`.
 *
 * The memory of the ткст is bound to the lifetime of \p парсер. If
 * LLVMRemarkпарсерDispose() is called, the memory of the ткст will be
 * released.
 *
 * \since REMARKS_API_VERSION=0
 */
 ткст0 ЛЛПарсерРемарок_ДайОшСооб(ЛЛПарсерРемарок парсер);

/**
 * Releases all the resources используется by \p парсер.
 *
 * \since REMARKS_API_VERSION=0
 */
 проц ЛЛПарсерРемарок_Вымести(ЛЛПарсерРемарок парсер);

}
