﻿/**
 * Copyright: Copyright (C) Thomas Dixon 2009. все rights reserved.
 * License:   BSD стиль: $(LICENSE)
 * Authors:   Thomas Dixon
 */

module util.cipher.ChaCha;

private import util.cipher.Cipher;
private import util.cipher.Salsa20;

/** Implementation of ChaCha designed by Daniel J. Bernstein. */
class ChaCha : Salsa20
{
    ткст имя()
    {
        return "ChaCha";
    }
    
    this()
    {
        i0 = 12;
        i1 = 13;
    }

    protected проц keySetup()
    {
        бцел смещение;
        ббайт[] constants;
        
        состояние[4] = БайтКонвертер.LittleEndian.в_!(бцел)(workingKey[0..4]);
        состояние[5] = БайтКонвертер.LittleEndian.в_!(бцел)(workingKey[4..8]);
        состояние[6] = БайтКонвертер.LittleEndian.в_!(бцел)(workingKey[8..12]);
        состояние[7] = БайтКонвертер.LittleEndian.в_!(бцел)(workingKey[12..16]);
        
        if (workingKey.length == 32)
        {
            constants = сигма;
            смещение = 16;
        } else
            constants = tau;
            
        состояние[ 8] = БайтКонвертер.LittleEndian.в_!(бцел)(workingKey[смещение..смещение+4]);
        состояние[ 9] = БайтКонвертер.LittleEndian.в_!(бцел)(workingKey[смещение+4..смещение+8]);
        состояние[10] = БайтКонвертер.LittleEndian.в_!(бцел)(workingKey[смещение+8..смещение+12]);
        состояние[11] = БайтКонвертер.LittleEndian.в_!(бцел)(workingKey[смещение+12..смещение+16]);
        состояние[ 0] = БайтКонвертер.LittleEndian.в_!(бцел)(constants[0..4]);
        состояние[ 1] = БайтКонвертер.LittleEndian.в_!(бцел)(constants[4..8]);
        состояние[ 2] = БайтКонвертер.LittleEndian.в_!(бцел)(constants[8..12]);
        состояние[ 3] = БайтКонвертер.LittleEndian.в_!(бцел)(constants[12..16]);
    }
    
    protected проц ivSetup()
    {
        состояние[12] = состояние[13] = 0;
        состояние[14] = БайтКонвертер.LittleEndian.в_!(бцел)(workingIV[0..4]);
        состояние[15] = БайтКонвертер.LittleEndian.в_!(бцел)(workingIV[4..8]);
    }
    
    protected проц salsa20WordToByte(бцел[] ввод, ref ббайт[] вывод)
    {
        бцел[] x = new бцел[16];
        x[] = ввод;
          
        цел i;
        for (i = 0; i < 4; i++)
        {
            x[ 0] += x[ 4]; x[12] = Побитно.rotateLeft(x[12]^x[ 0], 16u);
            x[ 8] += x[12]; x[ 4] = Побитно.rotateLeft(x[ 4]^x[ 8], 12u);
            x[ 0] += x[ 4]; x[12] = Побитно.rotateLeft(x[12]^x[ 0],  8u);
            x[ 8] += x[12]; x[ 4] = Побитно.rotateLeft(x[ 4]^x[ 8],  7u);
            x[ 1] += x[ 5]; x[13] = Побитно.rotateLeft(x[13]^x[ 1], 16u);
            x[ 9] += x[13]; x[ 5] = Побитно.rotateLeft(x[ 5]^x[ 9], 12u);
            x[ 1] += x[ 5]; x[13] = Побитно.rotateLeft(x[13]^x[ 1],  8u);
            x[ 9] += x[13]; x[ 5] = Побитно.rotateLeft(x[ 5]^x[ 9],  7u);
            x[ 2] += x[ 6]; x[14] = Побитно.rotateLeft(x[14]^x[ 2], 16u);
            x[10] += x[14]; x[ 6] = Побитно.rotateLeft(x[ 6]^x[10], 12u);
            x[ 2] += x[ 6]; x[14] = Побитно.rotateLeft(x[14]^x[ 2],  8u);
            x[10] += x[14]; x[ 6] = Побитно.rotateLeft(x[ 6]^x[10],  7u);
            x[ 3] += x[ 7]; x[15] = Побитно.rotateLeft(x[15]^x[ 3], 16u);
            x[11] += x[15]; x[ 7] = Побитно.rotateLeft(x[ 7]^x[11], 12u);
            x[ 3] += x[ 7]; x[15] = Побитно.rotateLeft(x[15]^x[ 3],  8u);
            x[11] += x[15]; x[ 7] = Побитно.rotateLeft(x[ 7]^x[11],  7u);
            x[ 0] += x[ 5]; x[15] = Побитно.rotateLeft(x[15]^x[ 0], 16u);
            x[10] += x[15]; x[ 5] = Побитно.rotateLeft(x[ 5]^x[10], 12u);
            x[ 0] += x[ 5]; x[15] = Побитно.rotateLeft(x[15]^x[ 0],  8u);
            x[10] += x[15]; x[ 5] = Побитно.rotateLeft(x[ 5]^x[10],  7u);
            x[ 1] += x[ 6]; x[12] = Побитно.rotateLeft(x[12]^x[ 1], 16u);
            x[11] += x[12]; x[ 6] = Побитно.rotateLeft(x[ 6]^x[11], 12u);
            x[ 1] += x[ 6]; x[12] = Побитно.rotateLeft(x[12]^x[ 1],  8u);
            x[11] += x[12]; x[ 6] = Побитно.rotateLeft(x[ 6]^x[11],  7u);
            x[ 2] += x[ 7]; x[13] = Побитно.rotateLeft(x[13]^x[ 2], 16u);
            x[ 8] += x[13]; x[ 7] = Побитно.rotateLeft(x[ 7]^x[ 8], 12u);
            x[ 2] += x[ 7]; x[13] = Побитно.rotateLeft(x[13]^x[ 2],  8u);
            x[ 8] += x[13]; x[ 7] = Побитно.rotateLeft(x[ 7]^x[ 8],  7u);
            x[ 3] += x[ 4]; x[14] = Побитно.rotateLeft(x[14]^x[ 3], 16u);
            x[ 9] += x[14]; x[ 4] = Побитно.rotateLeft(x[ 4]^x[ 9], 12u);
            x[ 3] += x[ 4]; x[14] = Побитно.rotateLeft(x[14]^x[ 3],  8u);
            x[ 9] += x[14]; x[ 4] = Побитно.rotateLeft(x[ 4]^x[ 9],  7u);
        }
        
        for (i = 0; i < 16; i++)
            x[i] += ввод[i];
            
        цел j;    
        for (i = j = 0; i < x.length; i++,j+=цел.sizeof)
            вывод[j..j+цел.sizeof] = БайтКонвертер.LittleEndian.из_!(бцел)(x[i]);
    }
    
    /** ChaCha тест vectors */
    debug (UnitTest)
    {
        unittest
        {
            static ткст[] test_keys = [
                "80000000000000000000000000000000", 
                "0053a6f94c9ff24598eb3e91e4378добавь",
                "00002000000000000000000000000000"~
                "00000000000000000000000000000000",
                "0f62b5085bae0154a7fa4da0f34699ec"~
                "3f92e5388bde3184d72a7dd02376c91c"
                
            ];
            
            static ткст[] test_ivs = [
                "0000000000000000",            
                "0d74db42a91077de",
                "0000000000000000",
                "288ff65dc42b92f9"
            ];
                 
            static ткст[] test_plaintexts = [
                "00000000000000000000000000000000"~
                "00000000000000000000000000000000"~
                "00000000000000000000000000000000"~
                "00000000000000000000000000000000",
                
                "00000000000000000000000000000000"~
                "00000000000000000000000000000000"~
                "00000000000000000000000000000000"~
                "00000000000000000000000000000000",
                
                "00000000000000000000000000000000"~
                "00000000000000000000000000000000"~
                "00000000000000000000000000000000"~
                "00000000000000000000000000000000",
                
                "00000000000000000000000000000000"~
                "00000000000000000000000000000000"~
                "00000000000000000000000000000000"~
                "00000000000000000000000000000000"
                
                
            ];
                 
            static ткст[] test_cИПhertexts = [
                "beb1e81e0f747e43ee51922b3e87fb38"~
                "d0163907b4ed49336032ab78b67c2457"~
                "9fe28f751bd3703e51d876c017faa435"~
                "89e63593e03355a7d57b2366f30047c5",
                         
                "509b267e7266355fa2dc0a25c023fce4"~
                "7922d03dd9275423d7cb7118b2aedf22"~
                "0568854bf47920d6fc0fd10526cfe7f9"~
                "de472835afc73c916b849e91eee1f529",
                 
                "653f4a18e3d27daf51f841a00b6c1a2b"~
                "d2489852d4ae0711e1a4a32ad166fa6f"~
                "881a2843238c7e17786ba5162bc019d5"~
                "73849c167668510ada2f62b4ff31ad04",
                
                "db165814f66733b7a8e34d1ffc123427"~
                "1256d3bf8d8da2166922e598acac70f4"~
                "12b3fe35a94190ad0ae2e8ec62134819"~
                "ab61добавьcccfe99d867ca3d73183fa3fd"
            ];

            ChaCha cc = new ChaCha();
            ббайт[] буфер = new ббайт[64];
            ткст результат;
            for (цел i = 0; i < test_keys.length; i++)
            {
                СимметричныйКлюч ключ = new СимметричныйКлюч(БайтКонвертер.hexDecode(test_keys[i]));
                ParametersWithIV params = new ParametersWithIV(ключ, БайтКонвертер.hexDecode(test_ivs[i]));
                
                // Encryption
                cc.init(да, params);
                cc.обнови(БайтКонвертер.hexDecode(test_plaintexts[i]), буфер);
                результат = БайтКонвертер.hexEncode(буфер);
                assert(результат == test_cИПhertexts[i],
                        cc.имя()~": ("~результат~") != ("~test_cИПhertexts[i]~")");           
                
                // Decryption
                cc.init(нет, params);
                cc.обнови(БайтКонвертер.hexDecode(test_cИПhertexts[i]), буфер);
                результат = БайтКонвертер.hexEncode(буфер);
                assert(результат == test_plaintexts[i],
                        cc.имя()~": ("~результат~") != ("~test_plaintexts[i]~")");
            }   
        }
    }
}
