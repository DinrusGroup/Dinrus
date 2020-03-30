//===- llvm-cat.cpp - LLVM module concatenation utility -------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This program is for testing features that rely on multi-module bitcode files.
// It takes a list of input modules and uses them to create a multi-module
// bitcode file.
//
//===----------------------------------------------------------------------===//

#include "llvm/ADT/SmallVector.h"
#include "llvm/Bitcode/BitcodeReader.h"
#include "llvm/Bitcode/BitcodeWriter.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IRReader/IRReader.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Error.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/MemoryBuffer.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/raw_ostream.h"
#include <algorithm>
#include <memory>
#include <string>
#include <system_error>
#include <vector>

using namespace llvm;

cl::OptionCategory CatCategory("Опции llvm-cat");

static cl::opt<bool>
    BinaryCat("b", cl::desc("Выполнять ли бинарную конкатенацию"),
              cl::cat(CatCategory));

static cl::opt<std::string> OutputFilename("o", cl::Required,
                                           cl::desc("Выходной файл"),
                                           cl::value_desc("filename"),
                                           cl::cat(CatCategory));

static cl::list<std::string> InputFilenames(cl::Positional, cl::ZeroOrMore,
                                            cl::desc("<входные файлы>"),
                                            cl::cat(CatCategory));

extern "C" __declspec(dllexport) int ЛЛВхоФункцЛЛКат(char **args) {
  auto argn = (int)strlen((const char*)args);
  cl::HideUnrelatedOptions(CatCategory);
  cl::ParseCommandLineOptions(argn, args, "Конкатенация модулей");

  ExitOnError ExitOnErr("llvm-cat: ");
  LLVMContext Context;

  SmallVector<char, 0> Buffer;
  BitcodeWriter Writer(Buffer);
  if (BinaryCat) {
    for (const auto &InputFilename : InputFilenames) {
      std::unique_ptr<MemoryBuffer> MB = ExitOnErr(
          errorOrToExpected(MemoryBuffer::getFileOrSTDIN(InputFilename)));
      std::vector<BitcodeModule> Mods = ExitOnErr(getBitcodeModuleList(*MB));
      for (auto &BitcodeMod : Mods) {
        Buffer.insert(Buffer.end(), BitcodeMod.getBuffer().begin(),
                      BitcodeMod.getBuffer().end());
        Writer.copyStrtab(BitcodeMod.getStrtab());
      }
    }
  } else {
    // The string table does not own strings added to it, some of which are
    // owned by the modules; keep them alive until we write the string table.
    std::vector<std::unique_ptr<Module>> OwnedMods;
    for (const auto &InputFilename : InputFilenames) {
      SMDiagnostic Err;
      std::unique_ptr<Module> M = parseIRFile(InputFilename, Err, Context);
      if (!M) {
        Err.print(args[0], errs());
        return 1;
      }
      Writer.writeModule(*M);
      OwnedMods.push_back(std::move(M));
    }
    Writer.writeStrtab();
  }

  std::error_code EC;
  raw_fd_ostream OS(OutputFilename, EC, sys::fs::OpenFlags::F_None);
  if (EC) {
    errs() << args[0] << ": не удаётся открыть " << OutputFilename << " для записи: "
           << EC.message();
    return 1;
  }

  OS.write(Buffer.data(), Buffer.size());
  return 0;
}
