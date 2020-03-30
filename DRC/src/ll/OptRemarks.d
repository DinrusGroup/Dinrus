/*===-- llvm-c/OptRemarks.h - OptRemarks Публичный Си интерфейс----*- С -*-===*\
|*                                                                            *|
|*                     Компиляторная Инфраструктура LLVM                      *|
|*                                                                            *|
|* This файл is distributed under the University of Illinois Open Source      *|
|* License. See LICENSE.TXT for details.                                      *|
|*                                                                            *|
|*===----------------------------------------------------------------------===*|
|*                                                                            *|
|* Этот заголовок предоставляет публичный интерфейс к библиотеке opt-remark.  *|
|* LLVM обеспечивает реализацию данного интерфейса.                           *|
|*                                                                            *|
\*===----------------------------------------------------------------------===*/

module ll.OptRemarks;
import ll.Core, ll.Types;

extern (C){

/**
 * @defgroup LLVMCOPTREMARKS OptRemarks
 * @ingroup LLVMC
 *
 * @{
 */

const OPT_REMARKS_API_VERSION = 0;

/**
 * Строка, содержащая буфер и длину. Буфер не гарантировано завершается
 * нулём.
 *
 * \since OPT_REMARKS_API_VERSION=0
 */
struct LLVMOptRemarkStringRef{
  ткст0 текст;
  uint32_t Len;
} ;

/**
 * DebugLoc containing Файл, Line and Column.
 *
 * \since OPT_REMARKS_API_VERSION=0
 */
struct LLVMOptRemarkDebugLoc{
  // Файл:
  LLVMOptRemarkStringRef SourceFile;
  // Line:
  uint32_t SourceLineNumber;
  // Column:
  uint32_t SourceColumnNumber;
} ;

/**
 * Элемент списка "арги". The ключ might give more information about what
 * are the semantics of the вал, e.g. "Callee" will tell you that the çíà÷
 * is a symbol that имена a function.
 *
 * \since OPT_REMARKS_API_VERSION=0
 */
struct LLVMOptRemarkArg {
  // e.g. "Callee"
  LLVMOptRemarkStringRef ключ;
  // e.g. "malloc"
  LLVMOptRemarkStringRef знач;

  // "DebugLoc": Optional
  LLVMOptRemarkDebugLoc DebugLoc;
} ;

/**
 * One remark entry.
 *
 * \since OPT_REMARKS_API_VERSION=0
 */
struct LLVMOptRemarkEntry {
  // e.g. !Missed, !Passed
  LLVMOptRemarkStringRef RemarkType;
  // "Pass": Required
  LLVMOptRemarkStringRef PassName;
  // "Name": Required
  LLVMOptRemarkStringRef RemarkName;
  // "Function": Required
  LLVMOptRemarkStringRef FunctionName;

  // "DebugLoc": Optional
  LLVMOptRemarkDebugLoc DebugLoc;
  // "Hotness": Optional
  uint32_t Hotness;
  // "арги": Optional. It is an массив of `num_args` elements.
  uint32_t члоАргов;
  LLVMOptRemarkArg *арги;
} ;

struct LLVMOptRemarkOpaqueParser;
alias LLVMOptRemarkOpaqueParser *LLVMOptRemarkParserRef;

/**
 * Создаёт парсер ремарок, который может использоваться для чтения и разбора
 * буфера, расположенного в \p Buf размером \p разм.
 *
 * \p Но не может быть NULL.
 *
 * This function should be paired with LLVMOptRemarkParserDispose() to avoid
 * leaking resources.
 *
 * \since OPT_REMARKS_API_VERSION=0
 */
extern LLVMOptRemarkParserRef LLVMOptRemarkParserCreate(ук Buf,
                                                        дол разм);

/**
 * Возвращает the следщ remark in the файл.
 *
 * Значение, на которое указывает возвратное значение, is invalidated by the следщ call to
 * LLVMOptRemarkParserGetNext().
 *
 * Если парсер достиг конца буфера, возвратное значение будет NULL.
 *
 * В случае ошибки, возвратное значение будет NULL, и:
 *
 * 1) LLVMOptRemarkParserHasError() вернёт `1`.
 *
 * 2) LLVMOptRemarkParserGetErrorMessage() вернёт описательное сообщение
 *    об ошибке.
 *
 * Ошибка может произойти, если:
 *
 * 1) Аргумент инвалиден.
 *
 * 2) Имеется ошибка разбока YAML. This тип of error aborts parsing
 *    immediately and returns `1`. It can occur on malformed YAML.
 *
 * 3) Remark parsing error. If this тип of error occurs, the parser won't call
 *    the handler and will continue to the следщ one. It can occur on malformed
 *    remarks, like missing or extra fields in the файл.
 *
 * Here is a quick example of the использование:
 *
 * ```
 *  LLVMOptRemarkParserRef Parser = LLVMOptRemarkParserCreate(буф, разм);
 *  LLVMOptRemarkEntry *Remark = NULL;
 *  while ((Remark == LLVMOptRemarkParserGetNext(Parser))) {
 *    // use Remark
 *  }
 *  бул HasError = LLVMOptRemarkParserHasError(Parser);
 *  LLVMOptRemarkParserDispose(Parser);
 * ```
 *
 * \since OPT_REMARKS_API_VERSION=0
 */
extern LLVMOptRemarkEntry *
LLVMOptRemarkParserGetNext(LLVMOptRemarkParserRef Parser);

/**
 * Возвращает `1` if the parser encountered an error while parsing the буфер.
 *
 * \since OPT_REMARKS_API_VERSION=0
 */
extern ЛЛБул LLVMOptRemarkParserHasError(LLVMOptRemarkParserRef Parser);

/**
 * Возвращает a null-terminated ткст containing an error message.
 *
 * In case of no error, the результат is `NULL`.
 *
 * The memory of the ткст is bound to the lifetime of \p Parser. If
 * LLVMOptRemarkParserDispose() is called, the memory of the ткст will be
 * released.
 *
 * \since OPT_REMARKS_API_VERSION=0
 */
extern ткст0 
LLVMOptRemarkParserGetErrorMessage(LLVMOptRemarkParserRef Parser);

/**
 * Releases all the resources используется by \p Parser.
 *
 * \since OPT_REMARKS_API_VERSION=0
 */
extern проц LLVMOptRemarkParserDispose(LLVMOptRemarkParserRef Parser);

/**
 * Возвращает the version of the opt-remarks dylib.
 *
 * \since OPT_REMARKS_API_VERSION=0
 */
extern uint32_t LLVMOptRemarkVersion();

/**
 * @} // endgoup LLVMCOPTREMARKS
 */


}
