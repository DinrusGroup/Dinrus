/*===------- llvm-c/Error.h - llvm::Error class к Interface -------*- к -*-===*\
|*                                                                            *|
|* Part of the LLVM Project, under the Apache License v2.0 with LLVM          *|
|* Exceptions.                                                                *|
|* See https://llvm.org/LICENSE.txt for license information.                  *|
|* SPDX-License-Идентификатор2: Apache-2.0 WITH LLVM-exception                    *|
|*                                                                            *|
|*===----------------------------------------------------------------------===*|
|*                                                                            *|
|* This файл defines the к interface to LLVM's Error class.                   *|
|*                                                                            *|
\*===----------------------------------------------------------------------===*/

module ll.Error;
extern (C){


const LLVMErrorSuccess = 0;

/**
 * Opaque ссылка на экземпляр ошибки. Null serves as the 'успех' знач.
 */
struct LLVMOpaqueError;
alias LLVMOpaqueError *ЛЛОшибка;

/**
 * Error тип идентификатор.
 */
alias ук ЛЛИдТипаОшибки;

/**
 * Возвращает the тип ид for the given error instance, which must be a failure
 * знач (i.e. non-null).
 */
ЛЛИдТипаОшибки ЛЛДайИдТипаОшибки(ЛЛОшибка ош);

/**
 * Dispose of the given error without handling it. This operation consumes the
 * error, and the given ЛЛОшибка знач is not usable once this call returns.
 * Note: This method *only* needs to be called if the error is not being passed
 * to some other consuming operation, e.g. LLVMGetErrorMessage.
 */
проц ЛЛКонсуммируйОш(ЛЛОшибка ош);

/**
 * Возвращает the given ткст's error message. This operation consumes the error,
 * and the given ЛЛОшибка знач is not usable once this call returns.
 * The caller is responsible for disposing of the ткст by calling
 * LLVMDisposeErrorMessage.
 */
ткст0 ЛЛДайОшСооб(ЛЛОшибка ош);

/**
 * Dispose of the given error message.
 */
проц ЛЛВыместиОшСооб(ткст0 ошСооб);

/**
 * Возвращает the тип ид for llvm StringError.
 */
ЛЛИдТипаОшибки ЛЛДайТкстИдаТипаОш();


}

