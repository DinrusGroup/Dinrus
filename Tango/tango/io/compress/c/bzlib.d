/* Converted в_ D из_ bzlib.h by htod */

module lib.bzlib;

/*-------------------------------------------------------------*/
/*--- Public заголовок файл for the library.                   ---*/
/*---                                               bzlib.h ---*/
/*-------------------------------------------------------------*/

/* ------------------------------------------------------------------
   This файл is часть of bzip2/libbzИП2, a program and library for
   lossless, block-sorting данные compression.

   bzip2/libbzИП2 version 1.0.4 of 20 December 2006
   Copyright (C) 1996-2006 Julian Seward <jseward@bzИП.org>

   Please читай the WARNING, DISCLAIMER and PATENTS sections in the 
   README файл.

   This program is released under the terms of the license contained
   in the файл LICENSE.
   ------------------------------------------------------------------ */

extern(C):

const BZ_RUN = 0;
const BZ_FLUSH = 1;
const BZ_FINISH = 2;

const BZ_OK = 0;
const BZ_RUN_OK = 1;
const BZ_FLUSH_OK = 2;
const BZ_FINISH_OK = 3;
const BZ_STREAM_END = 4;
const BZ_SEQUENCE_ERROR = -1;
const BZ_PARAM_ERROR = -2;
const BZ_MEM_ERROR = -3;
const BZ_DATA_ERROR = -4;
const BZ_DATA_ERROR_MAGIC = -5;
const BZ_IO_ERROR = -6;
const BZ_UNEXPECTED_EOF = -7;
const BZ_OUTBUFF_FULL = -8;
const BZ_CONFIG_ERROR = -9;

struct bz_stream
{
    ббайт *next_in;
    бцел avail_in;
    бцел total_in_lo32;
    бцел total_in_hi32;
    ббайт *next_out;
    бцел avail_out;
    бцел total_out_lo32;
    бцел total_out_hi32;
    проц *состояние;
    проц * function(проц *, цел , цел )bzalloc;
    проц  function(проц *, проц *)bzfree;
    проц *opaque;
}

import cidrus : FILE;

/*-- Core (low-уровень) library functions --*/

//C     BZ_EXTERN цел BZ_API(BZ2_bzCompressInit) ( 
//C           bz_stream* strm, 
//C           цел        blockSize100k, 
//C           цел        verbosity, 
//C           цел        workFactor 
//C        );
extern (System):
цел  BZ2_bzCompressInit(bz_stream *strm, цел blockSize100k, цел verbosity, цел workFactor);

//C     BZ_EXTERN цел BZ_API(BZ2_bzCompress) ( 
//C           bz_stream* strm, 
//C           цел action 
//C        );
цел  BZ2_bzCompress(bz_stream *strm, цел action);

//C     BZ_EXTERN цел BZ_API(BZ2_bzCompressEnd) ( 
//C           bz_stream* strm 
//C        );
цел  BZ2_bzCompressEnd(bz_stream *strm);

//C     BZ_EXTERN цел BZ_API(BZ2_bzDecompressInit) ( 
//C           bz_stream *strm, 
//C           цел       verbosity, 
//C           цел       small
//C        );
цел  BZ2_bzDecompressInit(bz_stream *strm, цел verbosity, цел small);

//C     BZ_EXTERN цел BZ_API(BZ2_bzDecompress) ( 
//C           bz_stream* strm 
//C        );
цел  BZ2_bzDecompress(bz_stream *strm);

//C     BZ_EXTERN цел BZ_API(BZ2_bzDecompressEnd) ( 
//C           bz_stream *strm 
//C        );
цел  BZ2_bzDecompressEnd(bz_stream *strm);



/*-- High(er) уровень library functions --*/

version(BZ_NO_STDIO){}else{

const BZ_MAX_UNUSED = 5000;
alias проц BZFILE;

//C     BZ_EXTERN BZFILE* BZ_API(BZ2_bzReadOpen) ( 
//C           цел*  bzerror,   
//C           FILE* f, 
//C           цел   verbosity, 
//C           цел   small,
//C           ук  unused,    
//C           цел   nUnused 
//C        );
extern (System):
BZFILE * BZ2_bzReadOpen(цел *bzerror, FILE *f, цел verbosity, цел small, проц *unused, цел nUnused);

//C     BZ_EXTERN проц BZ_API(BZ2_bzReadClose) ( 
//C           цел*    bzerror, 
//C           BZFILE* b 
//C        );
проц  BZ2_bzReadClose(цел *bzerror, BZFILE *b);

//C     BZ_EXTERN проц BZ_API(BZ2_bzReadGetUnused) ( 
//C           цел*    bzerror, 
//C           BZFILE* b, 
//C           проц**  unused,  
//C           цел*    nUnused 
//C        );
проц  BZ2_bzReadGetUnused(цел *bzerror, BZFILE *b, проц **unused, цел *nUnused);

//C     BZ_EXTERN цел BZ_API(BZ2_bzRead) ( 
//C           цел*    bzerror, 
//C           BZFILE* b, 
//C           ук    буф, 
//C           цел     длин 
//C        );
цел  BZ2_bzRead(цел *bzerror, BZFILE *b, проц *буф, цел длин);

//C     BZ_EXTERN BZFILE* BZ_API(BZ2_bzWriteOpen) ( 
//C           цел*  bzerror,      
//C           FILE* f, 
//C           цел   blockSize100k, 
//C           цел   verbosity, 
//C           цел   workFactor 
//C        );
BZFILE * BZ2_bzWriteOpen(цел *bzerror, FILE *f, цел blockSize100k, цел verbosity, цел workFactor);

//C     BZ_EXTERN проц BZ_API(BZ2_bzWrite) ( 
//C           цел*    bzerror, 
//C           BZFILE* b, 
//C           ук    буф, 
//C           цел     длин 
//C        );
проц  BZ2_bzWrite(цел *bzerror, BZFILE *b, проц *буф, цел длин);

//C     BZ_EXTERN проц BZ_API(BZ2_bzWriteClose) ( 
//C           цел*          bzerror, 
//C           BZFILE*       b, 
//C           цел           abandon, 
//C           unsigned цел* nbytes_in, 
//C           unsigned цел* nbytes_out 
//C        );
проц  BZ2_bzWriteClose(цел *bzerror, BZFILE *b, цел abandon, бцел *nbytes_in, бцел *nbytes_out);

//C     BZ_EXTERN проц BZ_API(BZ2_bzWriteClose64) ( 
//C           цел*          bzerror, 
//C           BZFILE*       b, 
//C           цел           abandon, 
//C           unsigned цел* nbytes_in_lo32, 
//C           unsigned цел* nbytes_in_hi32, 
//C           unsigned цел* nbytes_out_lo32, 
//C           unsigned цел* nbytes_out_hi32
//C        );
проц  BZ2_bzWriteClose64(цел *bzerror, BZFILE *b, цел abandon, бцел *nbytes_in_lo32, бцел *nbytes_in_hi32, бцел *nbytes_out_lo32, бцел *nbytes_out_hi32);

}

/*-- Utility functions --*/

//C     BZ_EXTERN цел BZ_API(BZ2_bzBuffToBuffCompress) ( 
//C           сим*         приёмник, 
//C           unsigned цел* destLen,
//C           сим*         источник, 
//C           unsigned цел  sourceLen,
//C           цел           blockSize100k, 
//C           цел           verbosity, 
//C           цел           workFactor 
//C        );
цел  BZ2_bzBuffToBuffCompress(сим *приёмник, бцел *destLen, сим *источник, бцел sourceLen, цел blockSize100k, цел verbosity, цел workFactor);

//C     BZ_EXTERN цел BZ_API(BZ2_bzBuffToBuffDecompress) ( 
//C           сим*         приёмник, 
//C           unsigned цел* destLen,
//C           сим*         источник, 
//C           unsigned цел  sourceLen,
//C           цел           small, 
//C           цел           verbosity 
//C        );
цел  BZ2_bzBuffToBuffDecompress(сим *приёмник, бцел *destLen, сим *источник, бцел sourceLen, цел small, цел verbosity);


/*--
   Code contributed by Yoshioka Tsuneo (tsuneo@rr.iij4u.or.jp)
   в_ support better zlib compatibility.
   This код is not _officially_ часть of libbzИП2 (yet);
   I haven't tested it, documented it, or consопрered the
   threading-safeness of it.
   If this код breaks, please contact Всё Yoshioka and me.
--*/

//C     BZ_EXTERN const сим * BZ_API(BZ2_bzlibVersion) (
//C           проц
//C        );
сим * BZ2_bzlibVersion();

version(BZ_NO_STDIO){}else{

//C     BZ_EXTERN BZFILE * BZ_API(BZ2_bzopen) (
//C           const сим *путь,
//C           const сим *режим
//C        );
BZFILE * BZ2_bzopen(сим *путь, сим *режим);

//C     BZ_EXTERN BZFILE * BZ_API(BZ2_bzdopen) (
//C           цел        fd,
//C           const сим *режим
//C        );
BZFILE * BZ2_bzdopen(цел fd, сим *режим);
         
//C     BZ_EXTERN цел BZ_API(BZ2_bzread) (
//C           BZFILE* b, 
//C           ук  буф, 
//C           цел длин 
//C        );
цел  BZ2_bzread(BZFILE *b, проц *буф, цел длин);

//C     BZ_EXTERN цел BZ_API(BZ2_bzwrite) (
//C           BZFILE* b, 
//C           ук    буф, 
//C           цел     длин 
//C        );
цел  BZ2_bzwrite(BZFILE *b, проц *буф, цел длин);

//C     BZ_EXTERN цел BZ_API(BZ2_bzflush) (
//C           BZFILE* b
//C        );
цел  BZ2_bzflush(BZFILE *b);

//C     BZ_EXTERN проц BZ_API(BZ2_bzclose) (
//C           BZFILE* b
//C        );
проц  BZ2_bzclose(BZFILE *b);

//C     BZ_EXTERN const сим * BZ_API(BZ2_bzerror) (
//C           BZFILE *b, 
//C           цел    *errnum
//C        );
сим * BZ2_bzerror(BZFILE *b, цел *errnum);

}

/*-------------------------------------------------------------*/
/*--- конец                                           bzlib.h ---*/
/*-------------------------------------------------------------*/
