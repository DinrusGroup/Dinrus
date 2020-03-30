/*===-- llvm-c/Object.h - Object Lib к Iface --------------------*- C++ -*-===*/
/*                                                                            */
/* Part of the LLVM Project, under the Apache License v2.0 with LLVM          */
/* Exceptions.                                                                */
/* See https://llvm.org/LICENSE.txt for license information.                  */
/* SPDX-License-Идентификатор2: Apache-2.0 WITH LLVM-exception                    */
/*                                                                            */
/*===----------------------------------------------------------------------===*/
/*                                                                            */
/* This header declares the к interface to libLLVMObject.a, which             */
/* implements объект файл reading and writing.                                */
/*                                                                            */
/* Many exotic languages can interoperate with к code but have a harder time  */
/* with C++ due to имя mangling. So in addition to к, this interface enables */
/* tools written in such languages.                                           */
/*                                                                            */
/*===----------------------------------------------------------------------===*/

module ll.Object;
import ll.Types;
//#include "llvm/Config/llvm-config.h"

extern (C){

/**
 * @defgroup LLVMCObject Object файл reading and writing
 * @ingroup LLVMC
 *
 * @{
 */
struct LLVMOpaqueSectionIterator{}
struct LLVMOpaqueSymbolIterator{}
struct LLVMOpaqueRelocationIterator{}
// Opaque тип wrappers
alias LLVMOpaqueSectionIterator *ЛЛИтераторСекций;
alias LLVMOpaqueSymbolIterator *ЛЛСимвИтератор;
alias LLVMOpaqueRelocationIterator *ЛЛИтераторРелокаций;

/** Deprecated: Use ЛЛБинарник instead. */
struct LLVMOpaqueObjectFile{}
alias LLVMOpaqueObjectFile *ЛЛФайлОбъекта;

enum LLVMBinaryType {
  Archive,                /**< Archive файл. */
  MachOUniversalBinary,   /**< Mach-O Universal Binary файл. */
  COFFImportFile,         /**< COFF Импорт файл. */
  IR,                     /**< LLVM IR. */
  WinRes,                 /**< Windows resource (.res) файл. */
  COFF,                   /**< COFF Object файл. */
  ELF32L,                 /**< ELF 32-bit, little endian. */
  ELF32B,                 /**< ELF 32-bit, big endian. */
  ELF64L,                 /**< ELF 64-bit, little endian. */
  ELF64B,                 /**< ELF 64-bit, big endian. */
  MachO32L,               /**< MachO 32-bit, little endian. */
  MachO32B,               /**< MachO 32-bit, big endian. */
  MachO64L,               /**< MachO 64-bit, little endian. */
  MachO64B,               /**< MachO 64-bit, big endian. */
  Wasm,                   /**< Web Assembly. */
} ;

/**
 * Create a binary файл from the given memory буфер.
 *
 * The exact тип of the binary файл will be inferred automatically, and the
 * appropriate implementation selected.  The context may be NULL except if
 * the результатing файл is an LLVM IR файл.
 *
 * The memory буфер is not consumed by this function.  It is the responsibilty
 * of the caller to free it with \конст LLVMDisposeMemoryBuffer.
 *
 * If NULL is returned, the \p ошСооб параметр is populated with the
 * error's description.  It is then the caller's responsibility to free this
 * message by calling \конст LLVMDisposeMessage.
 *
 * @see llvm::объект::createBinary
 */
ЛЛБинарник ЛЛСоздайБин(ЛЛБуферПамяти буфПам,
                               ЛЛКонтекст Context,
                               ткст0 *ошСооб);

/**
 * Dispose of a binary файл.
 *
 * The binary файл does not own its backing буфер.  It is the responsibilty
 * of the caller to free it with \конст LLVMDisposeMemoryBuffer.
 */
проц ЛЛВыместиБин(ЛЛБинарник BR);

/**
 * Retrieves a копируй of the memory буфер associated with this объект файл.
 *
 * The returned буфер is merely a shallow копируй and does not own the actual
 * backing буфер of the binary. Nevertheless, it is the responsibility of the
 * caller to free it with \конст LLVMDisposeMemoryBuffer.
 *
 * @see llvm::объект::getMemoryBufferRef
 */
ЛЛБуферПамяти ЛЛБИинКопируйБуфПам(ЛЛБинарник BR);

/**
 * Retrieve the specific тип of a binary.
 *
 * @see llvm::объект::Binary::getType
 */
LLVMBinaryType ЛЛБинДайТип(ЛЛБинарник BR);

/*
 * For a Mach-O universal binary файл, retrieves the объект файл corresponding
 * to the given architecture if it is present as a slice.
 *
 * If NULL is returned, the \p ошСооб параметр is populated with the
 * error's description.  It is then the caller's responsibility to free this
 * message by calling \конст LLVMDisposeMessage.
 *
 * It is the responsiblity of the caller to free the returned объект файл by
 * calling \конст LLVMDisposeBinary.
 */
ЛЛБинарник ЛЛМакхО_УнивБин_КопируйОбъДляАрх(ЛЛБинарник BR,
                                                        ткст0 Arch,
                                                        т_мера ArchLen,
                                                        ткст0 *ошСооб);

/**
 * Retrieve a копируй of the section iterator for this объект файл.
 *
 * If there are no секции, the результат is NULL.
 *
 * The returned iterator is merely a shallow копируй. Nevertheless, it is
 * the responsibility of the caller to free it with
 * \конст LLVMDisposeSectionIterator.
 *
 * @see llvm::объект::секции()
 */
ЛЛИтераторСекций ЛЛОбъФайл_КопируйИтераторВыборки(ЛЛБинарник BR);

/**
 * Возвращает whether the given section iterator is at the end.
 *
 * @see llvm::объект::section_end
 */
ЛЛБул ЛЛОбъФайл_ИтераторВыборкиВКонце_ли(ЛЛБинарник BR,
                                              ЛЛИтераторСекций SI);

/**
 * Retrieve a копируй of the symbol iterator for this объект файл.
 *
 * If there are no symbols, the результат is NULL.
 *
 * The returned iterator is merely a shallow копируй. Nevertheless, it is
 * the responsibility of the caller to free it with
 * \конст LLVMDisposeSymbolIterator.
 *
 * @see llvm::объект::symbols()
 */
ЛЛСимвИтератор ЛЛОбъФайл_КопируйСимвИтератор(ЛЛБинарник BR);

/**
 * Возвращает whether the given symbol iterator is at the end.
 *
 * @see llvm::объект::symbol_end
 */
ЛЛБул ЛЛОбъФайл_СимвИтераторВКонце_ли(ЛЛБинарник BR,
                                             ЛЛСимвИтератор SI);

проц ЛЛВыместиИтераторСекций(ЛЛИтераторСекций SI);

проц ЛЛПереместисьКСледщСекции(ЛЛИтераторСекций SI);
проц ЛЛПерместисьКСодержащСекции(ЛЛИтераторСекций Sect,
                                 ЛЛСимвИтератор Sym);

// флОбъ Symbol iterators
проц ЛЛВыместиСимвИтератор(ЛЛСимвИтератор SI);
проц ЛЛПереместисьКСледщСимволу(ЛЛСимвИтератор SI);

// SectionRef accessors
ткст0 ЛЛДайИмяСекции(ЛЛИтераторСекций SI);
дол ЛЛДАйРазмСекции(ЛЛИтераторСекций SI);
ткст0 ЛЛДайСодержимоеСекции(ЛЛИтераторСекций SI);
дол ЛЛДайАдресСекции(ЛЛИтераторСекций SI);
ЛЛБул ЛЛСодержитСекцияСимвол_ли(ЛЛИтераторСекций SI,
                                 ЛЛСимвИтератор Sym);

// секция Relocation iterators
ЛЛИтераторРелокаций ЛЛДайРелокации(ЛЛИтераторСекций секция);
проц ЛЛВыместиИтераторРелокаций(ЛЛИтераторРелокаций RI);
ЛЛБул ЛЛИтераторРелокацийВКонце_ли(ЛЛИтераторСекций секция,
                                       ЛЛИтераторРелокаций RI);
проц ЛЛПереместисьКСледщРелокации(ЛЛИтераторРелокаций RI);


// SymbolRef accessors
ткст0 ЛЛДайИмяСимвола(ЛЛСимвИтератор SI);
дол ЛЛДайАдресСимвола(ЛЛСимвИтератор SI);
дол ЛЛДайРазмСимвола(ЛЛСимвИтератор SI);

// RelocationRef accessors
дол ЛЛДайСмещениеРелокации(ЛЛИтераторРелокаций RI);
ЛЛСимвИтератор ЛЛДайСимволРелокации(ЛЛИтераторРелокаций RI);
дол ЛЛДайТипРелокации(ЛЛИтераторРелокаций RI);
// NOTE: Caller takes ownership of returned ткст of the two
// following functions.
ткст0 ЛЛДайИмяТипаРелокации(ЛЛИтераторРелокаций RI);
ткст0 ЛЛДайТкстЗначенияРелокации(ЛЛИтераторРелокаций RI);


/** Deprecated: Use LLVMCreateBinary instead. */
ЛЛФайлОбъекта ЛЛСоздайФайлОбъекта(ЛЛБуферПамяти буфПам);

/** Deprecated: Use LLVMDisposeBinary instead. */
проц ЛЛВыместиФайлОбъекта(ЛЛФайлОбъекта флОбъ);

/** Deprecated: Use LLVMObjectFileCopySectionIterator instead. */
ЛЛИтераторСекций ЛЛДайСекции(ЛЛФайлОбъекта флОбъ);

/** Deprecated: Use LLVMObjectFileIsSectionIteratorAtEnd instead. */
ЛЛБул ЛЛИтераторСекцииВКонце_ли(ЛЛФайлОбъекта флОбъ,
                                    ЛЛИтераторСекций SI);

/** Deprecated: Use LLVMObjectFileCopySymbolIterator instead. */
ЛЛСимвИтератор ЛЛДайСимволы(ЛЛФайлОбъекта флОбъ);

/** Deprecated: Use LLVMObjectFileIsSymbolIteratorAtEnd instead. */
ЛЛБул ЛЛСимвИтераторВКонце_ли(ЛЛФайлОбъекта флОбъ,
                                   ЛЛСимвИтератор SI);

}
