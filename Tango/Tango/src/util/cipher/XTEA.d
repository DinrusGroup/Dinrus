/**
 * Copyright: Copyright (C) Thomas Dixon 2008. все rights reserved.
 * License:   BSD стиль: $(LICENSE)
 * Authors:   Thomas Dixon
 */

module util.cipher.XTEA;

private import util.cipher.Cipher;

/** Implementation of the XTEA cipher designed by
    David Wheeler и Roger Needham. */
class XTEA : ШифрБлок
{
    private
    {
        static const бцел ROUNDS = 32,
                          KEY_SIZE = 16,
                          BLOCK_SIZE = 8,
                          DELTA = 0x9e3779b9u;
        бцел[] subkeys,
               sum0,
               sum1;
    }
    
    final override проц сбрось(){}
    
    final override ткст имя()
    {
        return "XTEA";
    }
    
    final override бцел размерБлока()
    {
        return BLOCK_SIZE;
    }
    
    final проц init(бул зашифруй, СимметричныйКлюч keyParams)
    {
        _encrypt = зашифруй;
                    
        if (keyParams.ключ.length != KEY_SIZE)
            не_годится(имя()~": Неверный ключ length (требует 16 байты)");
        
        subkeys = new бцел[4];
        sum0 = new бцел[32];
        sum1 = new бцел[32];
        
        цел i, j;
        for (i = j = 0; i < 4; i++, j+=цел.sizeof)
            subkeys[i] = БайтКонвертер.БигЭндиан.в_!(бцел)(keyParams.ключ[j..j+цел.sizeof]);
            
        // Precompute the значения of sum + k[] в_ скорость up encryption
        for (i = j = 0; i < ROUNDS; i++)
        {
            sum0[i] = (j + subkeys[j & 3]);
            j += DELTA;
            sum1[i] = (j + subkeys[j >> 11 & 3]);
        }
        
        _initialized = да;
    }
    
    final override бцел обнови(проц[] input_, проц[] output_)
    {
        if (!_initialized)
            не_годится(имя()~": Шифр not инициализован");
            
        ббайт[] ввод = cast(ббайт[]) input_,
                вывод = cast(ббайт[]) output_;
                    
        if (ввод.length < BLOCK_SIZE)
            не_годится(имя()~": Ввод буфер too крат");
            
        if (вывод.length < BLOCK_SIZE)
            не_годится(имя()~": Вывод буфер too крат");
        
        бцел v0 = БайтКонвертер.БигЭндиан.в_!(бцел)(ввод[0..4]),
             v1 = БайтКонвертер.БигЭндиан.в_!(бцел)(ввод[4..8]);
             
        if (_encrypt)
        {
            for (цел i = 0; i < ROUNDS; i++)
            {
                v0 += ((v1 << 4 ^ v1 >> 5) + v1) ^ sum0[i];
                v1 += ((v0 << 4 ^ v0 >> 5) + v0) ^ sum1[i];
            }
        }
        else
        {
            for (цел i = ROUNDS-1; i >= 0; i--)
            {
                v1 -= (((v0 << 4) ^ (v0 >> 5)) + v0) ^ sum1[i];
                v0 -= (((v1 << 4) ^ (v1 >> 5)) + v1) ^ sum0[i];
            }
        }
        
        вывод[0..4] = БайтКонвертер.БигЭндиан.из_!(бцел)(v0);
        вывод[4..8] = БайтКонвертер.БигЭндиан.из_!(бцел)(v1);
        
        return BLOCK_SIZE;
    }
    
    /** Some XTEA тест vectors. */
    debug (UnitTest)
    {
        unittest
        {
            static ткст[] test_keys = [
                "00000000000000000000000000000000",
                "00000000000000000000000000000000",
                "0123456712345678234567893456789a",
                "0123456712345678234567893456789a",
                "00000000000000000000000000000001",
                "01010101010101010101010101010101",
                "0123456789abcdef0123456789abcdef",
                "0123456789abcdef0123456789abcdef",
                "00000000000000000000000000000000",
                "00000000000000000000000000000000"
            ];
                 
            static ткст[] test_plaintexts = [
                "0000000000000000",
                "0102030405060708",
                "0000000000000000",
                "0102030405060708",
                "0000000000000001",
                "0101010101010101",
                "0123456789abcdef",
                "0000000000000000",
                "0123456789abcdef",
                "4141414141414141"
            ];
                
            static ткст[] test_ciphertexts = [
                "dee9d4d8f7131ed9",
                "065c1b8975c6a816",
                "1ff9a0261ac64264",
                "8c67155b2ef91ead",
                "9f25fa5b0f86b758",
                "c2eca7cec9b7f992",
                "27e795e076b2b537",
                "5c8eddc60a95b3e1",
                "7e66c71c88897221",
                "ed23375a821a8c2d"
            ];
                
            XTEA t = new XTEA();
            foreach (бцел i, ткст test_key; test_keys)
            {
                ббайт[] буфер = new ббайт[t.размерБлока];
                ткст результат;
                СимметричныйКлюч ключ = new СимметричныйКлюч(БайтКонвертер.hexDecode(test_key));
                
                // Encryption
                t.init(да, ключ);
                t.обнови(БайтКонвертер.hexDecode(test_plaintexts[i]), буфер);
                результат = БайтКонвертер.hexEncode(буфер);
                assert(результат == test_ciphertexts[i],
                        t.имя~": ("~результат~") != ("~test_ciphertexts[i]~")");
    
                // Decryption
                t.init(нет, ключ);
                t.обнови(БайтКонвертер.hexDecode(test_ciphertexts[i]), буфер);
                результат = БайтКонвертер.hexEncode(буфер);
                assert(результат == test_plaintexts[i],
                        t.имя~": ("~результат~") != ("~test_plaintexts[i]~")");
            }
        }
    }
}

