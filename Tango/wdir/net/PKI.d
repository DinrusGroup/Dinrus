/*******************************************************************************

        copyright:      Copyright (c) 2008 Jeff Davey. все rights reserved

        license:        BSD стиль: $(LICENSE)

        author:         Jeff Davey <j@submersion.com>

*******************************************************************************/

module net.PKI;

private import time.Time;

private import stringz;

private import lib.OpenSSL;

/*******************************************************************************

  PKI предоставляет инфраструктуру Public Key. 

  Он предоставляет особые возможности:

  - Создавать X509 Сертификат (SSL Сертификат)

  - Создавать Public и Private пару ключей

  -Определять валидность X509 Сертификата у Сертификат Authority

  - Генерировать КонтекстССЛ для SSLСОКЕТConduit и СерверСокетССЛ

  - Wrap a SSLVerifyCallback so that retrieving the peer серт is easier

  PKI требуется библиотека OpenSSL,- испольуется динамическая привязка к ней.
  Её можно найти на сайте http://www.openssl.org и Win32 specific порте
  на http://www.slproweb.com/products/Win32OpenSSL.html.

*******************************************************************************/


/*******************************************************************************

  Do not проверь the peer сертификат. Nor краш if it's not provопрed (сервер 
  only).

*******************************************************************************/

const цел SSL_VERIFY_NONE = 0x00;

/*******************************************************************************

  Ask for a peer сертификат, but do not краш if it is not provопрed.

*******************************************************************************/

const цел SSL_VERIFY_PEER = 0x01;

/*******************************************************************************

  Ask for a peer сертификат, however, краш if it is not provопрed

*******************************************************************************/

const цел SSL_VERIFY_FAIL_IF_NO_PEER_CERT = 0x02;

/*******************************************************************************

  Only оцени once, do not re-оцени during handshake renegotiation.

*******************************************************************************/

const цел SSL_VERIFY_CLIENT_ONCE = 0x04;

const цел SSL_SESS_CACHE_SERVER = 0x0002;

/*******************************************************************************

  SSLVerifyCallback is passed преобр_в КонтекстССЛ and is called during handshake
  when OpenSSL is doing сертификат validation.

  Wrapping the X509_STORE_CTX in the КонтекстХраненияСертификатов utility class
  gives the ability в_ access the peer сертификат, and резон for ошибка.

*******************************************************************************/

extern (C) typedef цел function(цел, X509_STORE_CTX *ctx) SSLVerifyCallback;


/*******************************************************************************

    КонтекстССЛ is provопрed в_ SSLСОКЕТConduit and СерверСокетССЛ.

    It содержит the public/private keypair, and some добавьitional options that
    control как the SSL Потокs work.

    Example
    ---
    auto серт = new Сертификат(cast(ткст)Файл("public.pem").читай);
    auto pkey = new ЧастныйКлюч(cast(ткст)Файл("private.pem").читай);;
    auto ctx = new КонтекстССЛ();
    ctx.сертификат = серт;
    ctx.pkey = pkey;
    ctx.проверьКлюч();
    ---

*******************************************************************************/

class КонтекстССЛ
{
    package SSL_CTX *_ctx = пусто;
    private Сертификат _cert = пусто;
    private ЧастныйКлюч _key = пусто;
    private ХранилищеСертификатов _store = пусто;

    /*******************************************************************************

        Creates a new КонтекстССЛ supporting SSLv3 and TLSv1 methods.

    *******************************************************************************/

    this()
    {
        if ((_ctx = SSL_CTX_new(SSLv23_method())) is пусто)
            выдайОшибкуОпенССЛ();
    }

    ~this()
    {
        if (_ctx)
        {
            SSL_CTX_free(_ctx);
            _ctx = пусто;
        }
        _cert = пусто;
        _key = пусто;
        _store = пусто;
    }

    /*******************************************************************************

        Assigns a X509 Сертификат в_ the КонтекстССЛ.

        This is required for SSL
        
    *******************************************************************************/

    КонтекстССЛ сертификат(Сертификат серт)
    {
        if (SSL_CTX_use_certificate(_ctx, серт._cert))
            _cert = серт;
        else
            выдайОшибкуОпенССЛ();
        return this;
    }

    /*******************************************************************************

        Assigns a ЧастныйКлюч (public/private keypair в_ the КонтекстССЛ.

        This is required for SSL.
                
    *******************************************************************************/


    КонтекстССЛ частныйКлюч(ЧастныйКлюч ключ)
    {
        if (SSL_CTX_use_PrivateKey(_ctx, ключ._evpKey))
            _key = ключ;
        else
            выдайОшибкуОпенССЛ();
        return this;
    }

    /*******************************************************************************

        Valопрates that the X509 сертификат was signed with the provопрed
        public/private keypair. Throws an исключение if this is not the case.
                
    *******************************************************************************/

    КонтекстССЛ проверьКлюч()
    {
        if (!SSL_CTX_check_private_key(_ctx))
            выдайОшибкуОпенССЛ();
        return this;
    }

    /*******************************************************************************

        Sets a SSLVerifyCallback function using the SSL_VERIFY_(Неук|PEER|etc) флаги
        в_ control как verification is handled.
                
    *******************************************************************************/

    КонтекстССЛ настройВерификацию(цел флаги, SSLVerifyCallback ов)
    {
        SSL_CTX_set_verify(_ctx, флаги, ов);
        return this;
    }

    /*******************************************************************************

        Sets a ХранилищеСертификатов of certs that are valid and trust Сертификат
        Authorities during verification.
                
    *******************************************************************************/


    КонтекстССЛ сохрани(ХранилищеСертификатов сохрани) // warning this will free the existing one.. not sure if it frees on закрой yet ( so don't установи it twice! ?!)
    {
        SSL_CTX_set_cert_store(_ctx, сохрани._store);
        _store = сохрани;
        return this;
    }

    /*******************************************************************************

        Loads valid Сертификат Authorities из_ the specified путь.

        ОтКого the SSL_CTX_load_verify_locations manpage:

        Each файл must contain only one CA сертификат. Also, the файлы are
        looked up by the CA субъект имя hash значение, which must be available. If
        ещё than one CA сертификат with the same имя hash значение есть_ли, the
        extension must be different. (ie: 9d66eef0.0, 9d66eef0.1, etc). The search 
        is performed in the ordering of the extension, regardless of другой свойства
        of the certificates. Use the c_rehash utility в_ создай the necessary symlinks
                
    *******************************************************************************/

    КонтекстССЛ путьКСертСА(ткст путь)
    {
        if (!SSL_CTX_load_verify_locations(_ctx, пусто, вТкст0(путь)))
            выдайОшибкуОпенССЛ();
        return this;
    }

    // TODO need в_ финиш добавим Session handling functionality
/*    проц sessionCacheMode(цел режим)
    {
        if (!SSL_CTX_set_session_cache_mode(_ctx, режим))
            выдайОшибкуОпенССЛ();
    }

    проц sessionId(ббайт[] опр)
    {
        if (!SSL_CTX_set_session_опр_context(_ctx, опр.ptr, опр.length))
            выдайОшибкуОпенССЛ();
    } */
	
	    SSL_CTX* исконный()
    {   
        return _ctx;
    }
}

/*******************************************************************************

    The КонтекстХраненияСертификатов is a wrapper в_ the SSLVerifyCallback X509_STORE_CTX
    parameter.

    It allows retrieving the peer сертификат, and examining any ошибки during
    validation.


    The following example will probably change sometime soon.

    Example
    ---
    extern (C)
    {
        цел myCallback(цел код, X509_STORE_CTX *ctx)
        {
            auto myCtx = new КонтекстХраненияСертификатов(ctx);
            Сертификат серт = myCtx.серт;
            Стдвыв(серт.субъект).нс;
            return 0; // BAD CERT! (1 is good)
        }
    }
    ---

*******************************************************************************/

class КонтекстХраненияСертификатов
{
    private X509_STORE_CTX *_ctx = пусто;

    /*******************************************************************************

        This constructor takes a X509_STORE_CTX as provопрed by the SSLVerifyCallback
        function.
                
    *******************************************************************************/

    this(X509_STORE_CTX *ctx)
    {
        _ctx = ctx;
    }

    /*******************************************************************************

        Returns the peer сертификат.
                
    *******************************************************************************/

    Сертификат серт()
    {
        X509 *серт = X509_STORE_CTX_get_current_cert(_ctx);
        if (серт is пусто)
            выдайОшибкуОпенССЛ();
        return new Сертификат(серт);
    }

    // TODO need ещё research on what used for
    цел ошибка()
    {
        return X509_STORE_CTX_get_error(_ctx);
    }

    // TODO need ещё research on what used for
    цел глубинаОшибки()
    {
        return X509_STORE_CTX_get_error_depth(_ctx);
    }

}

/*******************************************************************************

    ХранилищеСертификатов stores numerous X509 Certificates for use in CRL lists,
    CA lists, etc.

    Example
    ---
    auto сохрани = new ХранилищеСертификатов();
    auto caCert = new Сертификат(cast(ткст)Файл("cacert.pem").читай);
    сохрани.добавь(caCert);
    auto untrustedCert = new Сертификат(cast(ткст)Файл("серт.pem").читай);
    if (untrustedCert.проверь(сохрани))
        Стдвыв("The untrusted серт was signed by our caCert and is valid.").нс;
    else
        Стдвыв("The untrusted серт was expired, or not signed by the caCert").нс;
    ---
            
*******************************************************************************/

class ХранилищеСертификатов
{
    package X509_STORE *_store = пусто;
    Сертификат[] _certs;


    this()
    {
        if ((_store = X509_STORE_new()) is пусто)
            выдайОшибкуОпенССЛ();
    }

    ~this()
    {
        if (_store)
        {
            X509_STORE_free(_store);
            _store = пусто;
        }
    }

    /*******************************************************************************

        Добавь a Сертификат в_ the сохрани.
            
    *******************************************************************************/

    ХранилищеСертификатов добавь(Сертификат серт)
    {
        if (X509_STORE_add_cert(_store, серт._cert))
            _certs ~= серт; // just in case it gets СМ'd?
        else
            выдайОшибкуОпенССЛ();
        return this;
    }
}

/*******************************************************************************

    ПубличныйКлюч содержит the RSA public ключ из_ a private/public keypair.

    It also allows extraction of the public ключ из_ a keypair.

    This is useful for encryption, you can зашифруй данные with someone's public ключ
    and they can расшифруй it with their private ключ.

    Example
    ---
    auto public = new ПубличныйКлюч(cast(ткст)Файл("public.pem").читай);
    auto encrypted = public.зашифруй(cast(ббайт[])"Hello, как are you today?");
    auto pemData = public.вФорматПЕМ;
    ---

*******************************************************************************/

class ПубличныйКлюч
{
    package RSA *_evpKey = пусто;
    private ЧастныйКлюч _existingKey = пусто;

    /*******************************************************************************

        Generate a ПубличныйКлюч объект из_ the passed PEM formatted данные

        Параметры:
            publicPemData = pem кодирован данные containing the public ключ 
            
    *******************************************************************************/
    this (ткст publicPemData)
    {
        BIO *bp = BIO_new_mem_buf(publicPemData.ptr, publicPemData.length);
        if (bp)
        {
            _evpKey = PEM_read_bio_RSAPublicKey(bp, пусто, пусто, пусто);
            BIO_free_all(bp);
        }

        if (_evpKey is пусто)
            выдайОшибкуОпенССЛ();
    }
    package this(ЧастныйКлюч ключ) 
    {        
        this._evpKey = cast(RSA *)ключ._evpKey.pkey;
        this._existingKey = ключ;
    }

    ~this()
    {
        if (_existingKey !is пусто)
        {
            _existingKey = пусто;
            _evpKey = пусто;
        }
        else if (_evpKey)
        {
            RSA_free(_evpKey);
            _evpKey = пусто;
        }
    }

    /*******************************************************************************

        Возвращает ПубличныйКлюч в PEM формате.
            
    *******************************************************************************/

    ткст вФорматПЕМ()
    {
        ткст rtn = пусто;
        BIO *bp = BIO_new(BIO_s_mem());
        if (bp)
        {
            if (PEM_write_bio_RSAPublicKey(bp, _evpKey))
            {
                сим *pemData = пусто;
                цел pemSize = BIO_get_mem_data(bp, &pemData);
                rtn = pemData[0..pemSize].dup;
            }
            BIO_free_all(bp);
        }
        if (rtn is пусто)
            выдайОшибкуОпенССЛ();
        return rtn;
    }

    /*******************************************************************************

        Verify the данные passed was signed with the public ключ.

        Параметры:
        данные = the данные в_ проверь
        сигнатура = the digital сигнатура
    *******************************************************************************/

    бул проверь(ббайт[] данные, ббайт[] сигнатура)
    {
        ббайт[MD5_DIGEST_LENGTH] дайджест;
        MD5_CTX c;
        MD5_Init(&c);
        MD5_Update(&c, данные.ptr, данные.length);
        MD5_Final(дайджест.ptr, &c);
        
        if (RSA_verify(NID_md5, дайджест.ptr, MD5_DIGEST_LENGTH, сигнатура.ptr, сигнатура.length, _evpKey))
            return да;
        return нет;
    }

    /*******************************************************************************

        Encrypt the passed данные using the ПубличныйКлюч 
        
        Notes:
        This is размер limited based off the ключ
        Not recommended for general encryption, use RSA for encrypting a 
        random ключ instead and switch в_ a block cipher.

        Параметры:
        данные = the данные в_ зашифруй
            
    *******************************************************************************/

    ббайт[] зашифруй(ббайт[] данные)
    {
        ббайт[] rtn;

        бцел maxSize = RSA_size(_evpKey);
        if (данные.length > maxSize)
            throw new Исключение("Заданные данные больше размера шифрации данного публичного ключа.");
        ббайт[] tmpRtn = new ббайт[maxSize];
        цел numBytes = RSA_public_encrypt(данные.length, данные.ptr, tmpRtn.ptr, _evpKey, RSA_PKCS1_OAEP_PADDING);
        if (numBytes >= 0)
            rtn = tmpRtn[0..numBytes];
        if (rtn is пусто)
            выдайОшибкуОпенССЛ();
        return rtn;
    }

     /*******************************************************************************

        Decrypts данные previously encrypted with the совпадают ЧастныйКлюч

        Please see the зашифруй notes.

        Parmas:
            данные = the данные в_ зашифруй

    *******************************************************************************/
       
    ббайт[] расшифруй(ббайт[] данные)
    {
        ббайт[] rtn;

        бцел maxSize = RSA_size(_evpKey);
        ббайт[] tmpRtn = new ббайт[maxSize];
        цел numBytes = RSA_public_decrypt(данные.length, данные.ptr, tmpRtn.ptr, _evpKey, RSA_PKCS1_PADDING);
        if (numBytes >= 0)
            rtn = tmpRtn[0..numBytes];
        if (rtn is пусто)
            выдайОшибкуОпенССЛ();
        return rtn;
    }

}

/*******************************************************************************

    Generates a RSA public/private ключ pair for use with X509 Certificates
    and другой applications search as S/MIME, DomainKeys, etc.

    Example
    ---
    auto newPkey = new ЧастныйКлюч(2048); // создай new keypair
    Стдвыв(newPkey.вФорматПЕМ("пароль")); // dumps in вФорматПЕМ with encryption
    Стдвыв(newPkey.вФорматПЕМ()); // dumps in вФорматПЕМ without encryption
    Стдвыв(newPkey.публичныйКлюч.вФорматПЕМ); // dump out just the public ключ portion
    auto данные = newPkey.расшифруй(someData); // расшифруй данные encrypted with public Key
    ---

*******************************************************************************/

class ЧастныйКлюч
{
    package EVP_PKEY *_evpKey = пусто;

    /*******************************************************************************

        Reads in the provопрed PEM данные, with an optional пароль в_ расшифруй
        the private ключ.

        Параметры:
            privatePemData = the PEM кодирован данные of the private ключ
            certPass = an optional пароль в_ расшифруй the ключ.
        
    *******************************************************************************/

    this (ткст privatePemData, ткст certPass = пусто)
    {
        BIO *bp = BIO_new_mem_buf(privatePemData.ptr, privatePemData.length);
        if (bp)
        {
            _evpKey = PEM_read_bio_PrivateKey(bp, пусто, пусто, certPass ? вТкст0(certPass) : пусто);
            BIO_free_all(bp);
        }

        if (_evpKey is пусто)
            выдайОшибкуОпенССЛ();
    }

    /*******************************************************************************

        Generates a new private/public ключ at the specified bit leve.

        Параметры:
            биты = Число of биты в_ use, 2048 is a good число for this.
        
    *******************************************************************************/


    this(цел биты)
    {
        RSA *rsa = RSA_generate_key(биты, RSA_F4, пусто, пусто);
        if (rsa)
        {
            if ((_evpKey = EVP_PKEY_new()) !is пусто)
                EVP_PKEY_assign_RSA(_evpKey, rsa);
            if (_evpKey is пусто)
                RSA_free(rsa);
        }

        if (_evpKey is пусто)
            выдайОшибкуОпенССЛ();
    }
    
    ~this()
    {
        if (_evpKey)
        {
            EVP_PKEY_free(_evpKey);
            _evpKey = пусто;
        }
    }

    /*******************************************************************************

        Compares two ЧастныйКлюч classes в_ see if the internal structures are 
        the same.
        
    *******************************************************************************/
    override цел opEquals(Объект об)
    {
        auto pk = cast(ЧастныйКлюч)об;
        if (pk !is пусто)
            return EVP_PKEY_cmp_parameters(pk._evpKey, this._evpKey);
        return 0;
    }

    /*******************************************************************************

        Returns the underlying public/private ключ pair in PEM форматируй.

        Параметры:
            пароль = If this is provопрed, the private ключ will be encrypted using
            AES 256bit encryption, with this as the ключ.
        
    *******************************************************************************/
    ткст вФорматПЕМ(ткст пароль = пусто)
    {
        ткст rtn = пусто;
        BIO *bp = BIO_new(BIO_s_mem());
        if (bp)
        {
            if (PEM_write_bio_PKCS8PrivateKey(bp, _evpKey, пароль ? EVP_aes_256_cbc() : пусто, пусто, 0, пусто, пароль ? вТкст0(пароль) : пусто))
            {
                сим *pemData = пусто;
                цел pemSize = BIO_get_mem_data(bp, &pemData);
                rtn = pemData[0..pemSize].dup;
            }
            BIO_free_all(bp);
        }
        if (rtn is пусто)
            выдайОшибкуОпенССЛ();
        return rtn;
    }

    /*******************************************************************************

        Returns the underlying ПубличныйКлюч

    *******************************************************************************/

    ПубличныйКлюч публичныйКлюч()
    {
        auto rtn = new ПубличныйКлюч(this);
        return rtn;
    }

    /*******************************************************************************
        Sign the given данные with the private ключ

        Параметры:
        данные = the данные в_ подпиши
        sigbuf = the буфер в_ сохрани the сигнатура in
        
        Returns a срез of the сигнатура or пусто

    *******************************************************************************/

    ббайт[] подпиши(ббайт[] данные, ббайт[] sigbuf)
    {
        бцел maxSize = RSA_size(cast(RSA *)_evpKey.pkey);
        if (sigbuf.length < maxSize)
            throw new Исключение("Буфер сигнатуры не вмещает сигнатуру для этого ключа.");
        ббайт[MD5_DIGEST_LENGTH] дайджест;

        MD5_CTX c;
        MD5_Init(&c);
        MD5_Update(&c, данные.ptr, данные.length);
        MD5_Final(дайджест.ptr, &c);

        бцел длин = sigbuf.length;
        if (RSA_sign(NID_md5, дайджест.ptr, дайджест.length, sigbuf.ptr, &длин, cast(RSA *)_evpKey.pkey))
            return sigbuf[0..длин];
        else
            выдайОшибкуОпенССЛ;
        return пусто;
    }

    /*******************************************************************************

        Encrypt the passed данные using the ЧастныйКлюч
        
        Notes:
        This is размер limited based off the ключ
        Not recommended for general encryption, use RSA for encrypting a 
        random ключ instead and switch в_ a block cipher.

        Параметры:
        данные = the данные в_ зашифруй
            
    *******************************************************************************/

    ббайт[] зашифруй(ббайт[] данные)
    {
        ббайт[] rtn;

        бцел maxSize = RSA_size(cast(RSA *)_evpKey.pkey);
        if (данные.length > maxSize)
            throw new Исключение("Заданные данные превышают размер шифрации для этого публичного ключа.");
        ббайт[] tmpRtn = new ббайт[maxSize];
        цел numBytes = RSA_private_encrypt(данные.length, данные.ptr, tmpRtn.ptr, cast(RSA *)_evpKey.pkey, RSA_PKCS1_PADDING);
        if (numBytes >= 0)
            rtn = tmpRtn[0..numBytes];
        if (rtn is пусто)
            выдайОшибкуОпенССЛ();
        return rtn;
    }

     /*******************************************************************************

        Decrypts данные previously encrypted with the совпадают ПубличныйКлюч

        Please see the зашифруй notes.

        Parmas:
            данные = the данные в_ зашифруй

    *******************************************************************************/
       
    ббайт[] расшифруй(ббайт[] данные)
    {
        ббайт[] rtn;

        бцел maxSize = RSA_size(cast(RSA *)_evpKey.pkey);
        ббайт[] tmpRtn = new ббайт[maxSize];
        цел numBytes = RSA_private_decrypt(данные.length, данные.ptr, tmpRtn.ptr, cast(RSA *)_evpKey.pkey, RSA_PKCS1_OAEP_PADDING);
        if (numBytes >= 0)
            rtn = tmpRtn[0..numBytes];
        if (rtn is пусто)
            выдайОшибкуОпенССЛ();
        return rtn;
    }

}

/*******************************************************************************

    Сертификат provопрes necessary functionality в_ создай and читай X509 
    Certificates.

    Note, once a Сертификат есть been signed, it is immutable, and cannot
    be изменён.

    X509 Certificates are sometimes called SSL Certificates.

    Example
    ---
    auto newPkey = new ЧастныйКлюч(2048); // создай new keypair
    auto серт = new Сертификат();
    серт.частныйКлюч = newPkey;
    серт.серийныйНомер = 1;
    серт.смещениеКДатеДо = ИнтервалВремени.zero;
    серт.смещениеКДатеПосле = ИнтервалВремени.дни(365); // серт is valid for one год
    серт.установиСубъект("US", "Состояние", "City", "Organization", "CN", "Organizational Unit", "Email");
    серт.подпиши(серт, newPkey); // сам signed серт
    Стдвыв(newPkey.вФорматПЕМ).нс;
    Стдвыв(серт.вФорматПЕМ).нс;
    ---

*******************************************************************************/

class Сертификат
{
    package X509 *_cert = пусто;
    private бул readOnly = да;
    private бул freeIt = да;

    // used with X509_STORE_CTX
    package this (X509 *серт)
    {
        _cert = серт;
        freeIt = нет;
    }

    /*******************************************************************************

        Parses a X509 Сертификат из_ the provопрed PEM кодирован данные.
            
    *******************************************************************************/
    this(ткст publicPemData)
    {
        BIO *данные = BIO_new_mem_buf(publicPemData.ptr, publicPemData.length);
        if (данные)
        {
            _cert = PEM_read_bio_X509(данные, пусто, пусто, пусто);
            BIO_free_all(данные);
        }
        if (_cert is пусто)
            выдайОшибкуОпенССЛ();
    }

    /*******************************************************************************

        Creates a new and un-signed (пустой) X509 сертификат. Useful for generating
        X509 certificates programatically.
            
    *******************************************************************************/
    this()
    {
        if ((_cert = X509_new()) !is пусто)
        {
            if (!X509_set_version(_cert, 2)) // 2 == Версия 3
            {
                X509_free(_cert);
                _cert = пусто;
            }
            else
                readOnly = нет;
        }
        if (_cert is пусто)
            выдайОшибкуОпенССЛ();
    }

    ~this()
    {
        if (_cert && freeIt)
        {
            X509_free(_cert);
            _cert = пусто;
        }
    }

    /*******************************************************************************

        Sets the serial число of the new unsigned сертификат.

        Note, this serial число should be unique for все certificates signed
        by the provопрed сертификат authority. Having two Certificates with the
        same serial число can cause problems with web browsers and другой apps
        because they will be different certificates.
            
    *******************************************************************************/

    Сертификат серийныйНомер(бцел serial)
    {
        проверьФлаг();
        if (!ASN1_INTEGER_set(X509_get_serialNumber(_cert), serial))
            выдайОшибкуОпенССЛ();
        return this;
    }
    /*******************************************************************************

        Returns the serial число of the Сертификат
            
    *******************************************************************************/

    бцел серийныйНомер()
    {
        if (!X509_get_serialNumber(_cert))
            выдайОшибкуОпенССЛ();
        return ASN1_INTEGER_get(X509_get_serialNumber(_cert));
    }

    /*******************************************************************************

        If the current дата is "before" the дата установи here, the сертификат will be
        не_годится.

        Параметры:
            t = A ИнтервалВремени representing the earliest время the Сертификат will be valid

        Example:
            серт.смещениеКДатеДо = ИнтервалВремени.сек(-86400); // Сертификат is не_годится before yesterday
            
    *******************************************************************************/

    Сертификат смещениеКДатеДо(ИнтервалВремени t)
    {
        проверьФлаг();
        if (!X509_gmtime_adj(X509_get_notBefore(_cert), cast(цел)t.сек))
            выдайОшибкуОпенССЛ();
        return this;
    }

    /*******************************************************************************

        If the current дата is "after" the дата установи here, the сертификат will be
        не_годится.

        Параметры:
            t = A ИнтервалВремени representing the amount of время из_ сейчас that the
            Сертификат will be valid. This must be larger than датаДо

        Example:
            серт.смещениеКДатеПосле = ИнтервалВремени.сек(86400 * 365); // Сертификат is valid up в_ one год из_ сейчас
            
    *******************************************************************************/

    Сертификат смещениеКДатеПосле(ИнтервалВремени t)
    {
        проверьФлаг();
        if (!X509_gmtime_adj(X509_get_notAfter(_cert), cast(цел)t.сек))
            выдайОшибкуОпенССЛ();
        return this;
    }

    
    /*******************************************************************************

        Returns the датаПосле field of the сертификат in ASN1_GENERALIZEDTIME.

        Note, this will eventually befome a ДатаВремя struct.
            
    *******************************************************************************/

    ткст датаПосле()
    {
        ткст rtn;
        ASN1_GENERALIZEDTIME *genTime = ASN1_TIME_to_generalizedtime(X509_get_notAfter(_cert), пусто);
        if (genTime)
        {
            rtn = genTime.data[0..genTime.length].dup;
            ASN1_STRING_free(cast(ASN1_STRING*)genTime);
        }

        return rtn;
    }

    /*******************************************************************************

        Returns the датаДо field of the сертификат in ASN1_GENERALIZEDTIME.

        Note, this will eventually befome a ДатаВремя struct.
            
    *******************************************************************************/

    ткст датаДо()    
    {
        ткст rtn;
        ASN1_GENERALIZEDTIME *genTime = ASN1_TIME_to_generalizedtime(X509_get_notBefore(_cert), пусто);
        if (genTime)
        {
            rtn = genTime.data[0..genTime.length].dup;
            ASN1_STRING_free(cast(ASN1_STRING*)genTime);
        }
        return rtn;
    }

    /*******************************************************************************

        Sets the public/private keypair of an unsigned сертификат.
            
    *******************************************************************************/

    Сертификат частныйКлюч(ЧастныйКлюч ключ)
    {
        проверьФлаг();
        if (ключ)
        {
            if (!X509_set_pubkey(_cert, ключ._evpKey))
                выдайОшибкуОпенССЛ();
        }
        return this;
    }

    /*******************************************************************************

        Sets the субъект (who this сертификат is for) of an unsigned сертификат.

        The country код must be a valid two-letter country код (ie: CA, US, etc)

        Параметры:
        country = the two letter country код of the субъект
        stateProvince = the состояние or province of the субъект
        city = the city the субъект belong в_
        organization = the organization the субъект belongs в_
        cn = the cn of the субъект. For websites, this should be the website url
        or a wildcard version of it (ie: *.dsource.org)
        organizationUnit = the optional orgnizationalUnit of the субъект
        email = the optional email адрес of the субъект

    *******************************************************************************/

    // this kinda sucks.. but it есть в_ be готово in a certain order..
    Сертификат установиСубъект(ткст country, ткст stateProvince, ткст city, ткст organization, ткст cn, ткст organizationalUnit = пусто, ткст email = пусто)
    in
    {
        assert(country);
        assert(stateProvince);
        assert(organization);
        assert(cn);
    }
    body
    {
        проверьФлаг();
        X509_NAME *имя = X509_get_subject_name(_cert);
        if (имя)
        {
            добавьЗаписьИмени(имя, "C", country);
            добавьЗаписьИмени(имя, "ST", stateProvince);
            добавьЗаписьИмени(имя, "L", city);
            добавьЗаписьИмени(имя, "O", organization);
            if (organizationalUnit !is пусто)
                добавьЗаписьИмени(имя, "OU", organizationalUnit);
            if (email) // this might have в_ go after the CN
                добавьЗаписьИмени(имя, "emailaddress", email);
            добавьЗаписьИмени(имя, "CN", cn);
        }
        else
            выдайОшибкуОпенССЛ();
        return this;
    }

    /*******************************************************************************

        Returns the Сертификат субъект in a multi-строка ткст.
            
    *******************************************************************************/

    ткст субъект() // currently multi-строка, could be single-строка..
    {
        ткст rtn = пусто;
        X509_NAME *subjectName = X509_get_subject_name(_cert);
        if (subjectName)
        {
            BIO *subjectBIO = BIO_new(BIO_s_mem());
            if (subjectBIO)
            {
                if (X509_NAME_print_ex(subjectBIO, subjectName, 0, XN_FLAG_MULTILINE))
                {
                    сим *subjectPtr = пусто;
                    цел length = BIO_get_mem_data(subjectBIO, &subjectPtr);
                    rtn = subjectPtr ? subjectPtr[0..length].dup : пусто;
                }
                BIO_free_all(subjectBIO);
            }
        }
        if (rtn is пусто)
            выдайОшибкуОпенССЛ();
        return rtn;
    }

    /*******************************************************************************

        Signs the unsigned Сертификат with the specified CA X509 Сертификат and
        it's corresponding public/private keypair.

        Once the Сертификат is signed, it can no longer be изменён.
            
    *******************************************************************************/

    Сертификат подпиши(Сертификат caCert, ЧастныйКлюч caKey)
    in
    {
        assert(caCert);
        assert(caKey);
    }
    body
    {
        проверьФлаг();
        X509_NAME *issuer = X509_get_subject_name(caCert._cert);
        if (issuer)
        {
            if (X509_set_issuer_name(_cert, issuer))
            {
                if (X509_sign(_cert, caKey._evpKey, EVP_sha1()))
                    readOnly = да;
            }
        }

        if (!readOnly)
            выдайОшибкуОпенССЛ();
        return this;
    }

    /*******************************************************************************

        Checks if the underlying данные structur of the Сертификат is equal
            
    *******************************************************************************/

    override цел opEquals(Объект об)
    {
        auto c = cast(Сертификат)об;
        if (c !is пусто)
            return !X509_cmp(c._cert, this._cert);
        return 0;
    }

    /*******************************************************************************

        Verifies that the Сертификат was signed and issues by a CACert in the 
        passed ХранилищеСертификатов.

        This will also проверь the датаДо and датаПосле fields в_ see if the
        current дата falls between them.
            
    *******************************************************************************/

    бул проверь(ХранилищеСертификатов сохрани)
    {
        бул rtn = нет;
        X509_STORE_CTX *verifyCtx = X509_STORE_CTX_new();
        if (verifyCtx)
        {
            if (X509_STORE_CTX_init(verifyCtx, сохрани._store, _cert, пусто))
            {
                if (X509_verify_cert(verifyCtx))
                    rtn = да;
            }
            X509_STORE_CTX_free(verifyCtx);
        }

        return rtn;
    }

    /*******************************************************************************

        Returns the Сертификат in a PEM кодирован ткст.
            
    *******************************************************************************/

    ткст вФорматПЕМ()
    {
        ткст rtn = пусто;
        BIO *bp = BIO_new(BIO_s_mem());
        if (bp)
        {
            if (PEM_write_bio_X509(bp, _cert))
            {
                сим *pemData = пусто;
                цел pemSize = BIO_get_mem_data(bp, &pemData);
                rtn = pemData[0..pemSize].dup;
            }
            BIO_free_all(bp);
        }
        if (rtn is пусто)
            выдайОшибкуОпенССЛ();
        return rtn;    
    }

    private проц добавьЗаписьИмени(X509_NAME *имя, сим *тип, ткст значение)
    {
        if (!X509_NAME_add_entry_by_txt(имя, тип, MBSTRING_ASC, вТкст0(значение), значение.length, -1, 0))
            выдайОшибкуОпенССЛ();
    }

    private проц проверьФлаг()
    {
        if (readOnly)
            throw new Исключение("Сертификат уже подписан и не может быть изменён.");
    }
}


version (Test)
{
    import util.Test;
    import io.Stdout;

    auto t1 = ИнтервалВремени.zero;
    auto t2 = ИнтервалВремени.изДней(365); // can't установи this up in delegate ..??
	
  
        Test.Status _pkeyGenTest(inout ткст[] messages)
        {
            auto pkey = new ЧастныйКлюч(2048);
            ткст pem = pkey.вФорматПЕМ;
            auto pkey2 = new ЧастныйКлюч(pem);
            if (pkey == pkey2)
            {
                auto pkey3 = new ЧастныйКлюч(2048);
                ткст pem2 = pkey3.вФорматПЕМ("hello");
                try
                    auto pkey4 = new ЧастныйКлюч(pem2, "badpass");
                catch (Исключение ex)
                {
                    auto pkey4 = new ЧастныйКлюч(pem2, "hello");
                    return Test.Status.Success;
                }
            }
                
            return Test.Status.Failure;
        }

        Test.Status _certGenTest(inout ткст[] messages)
        {
            auto серт = new Сертификат();
            auto pkey = new ЧастныйКлюч(2048);
            серт.частныйКлюч(pkey).серийныйНомер(123).смещениеКДатеДо(t1).смещениеКДатеПосле(t2);
            серт.установиСубъект("CA", "Alberta", "Place", "Нет", "First Last", "no unit", "email@example.com").подпиши(серт, pkey);
            ткст pemData = серт.вФорматПЕМ;
            auto cert2 = new Сертификат(pemData);
//            Стдвыв.форматнс("{}\n{}\n{}\n{}", cert2.серийныйНомер, cert2.субъект, cert2.датаДо, cert2.датаПосле);
            if (cert2 == серт)
                return Test.Status.Success;
            return Test.Status.Failure;
        }

        Test.Status _chainValопрation(inout ткст[] messages)
        {
            auto caCert = new Сертификат();
            auto caPkey = new ЧастныйКлюч(2048);
            caCert.серийныйНомер = 1;
            caCert.частныйКлюч = caPkey;
            caCert.смещениеКДатеДо = t1;
            caCert.смещениеКДатеПосле = t2;
            caCert.установиСубъект("CA", "Alberta", "CA Place", "Super CACerts Anon", "CA Manager");
            caCert.подпиши(caCert, caPkey);
            auto сохрани = new ХранилищеСертификатов();
            сохрани.добавь(caCert);

            auto subCert = new Сертификат();
            auto subPkey = new ЧастныйКлюч(2048);
            subCert.серийныйНомер = 2;
            subCert.частныйКлюч = subPkey;
            subCert.смещениеКДатеДо = t1;
            subCert.смещениеКДатеПосле = t2;
            subCert.установиСубъект("US", "California", "Customer Place", "Penny-Pincher", "IT Director");
            subCert.подпиши(caCert, caPkey);

            if (subCert.проверь(сохрани))
            {
                auto fakeCert = new Сертификат();
                auto fakePkey = new ЧастныйКлюч(2048);
                fakeCert.серийныйНомер = 1;
                fakeCert.частныйКлюч = fakePkey;
                fakeCert.смещениеКДатеДо = t1;
                fakeCert.смещениеКДатеПосле = t2;
                fakeCert.установиСубъект("CA", "Alberta", "CA Place", "Super CACerts Anon", "CA Manager");
                fakeCert.подпиши(caCert, caPkey);
                auto store2 = new ХранилищеСертификатов();
                if (!subCert.проверь(store2))
                    return Test.Status.Success;
            }

            return Test.Status.Failure;
        }   

        Test.Status _rsaCrypto(inout ткст[] messages)
        {
            auto ключ = new ЧастныйКлюч(2048);
            ткст pemData = ключ.публичныйКлюч.вФорматПЕМ;
            auto pub = new ПубличныйКлюч(pemData);
            auto encrypted = pub.зашифруй(cast(ббайт[])"Hello, как are you today?");
            auto decrypted = ключ.расшифруй(encrypted);
            if (cast(ткст)decrypted == "Hello, как are you today?")
            {
                encrypted = ключ.зашифруй(cast(ббайт[])"Hello, как are you today, mister?");
                decrypted = pub.расшифруй(encrypted);
                if (cast(ткст)decrypted == "Hello, как are you today, mister?")
                    return Test.Status.Success;
            }
            return Test.Status.Failure;
        }

        Test.Status _rsaSignVerify(inout ткст[] messages)
        {
            auto ключ = new ЧастныйКлюч(1024);
            auto key2 = new ЧастныйКлюч(1024);
            ббайт[] данные = cast(ббайт[])"I am some special данные, да I am.";
            ббайт[512] sigBuf;
            ббайт[512] sigBuf2;
            auto sig1 = ключ.подпиши(данные, sigBuf);
            auto sig2 = key2.подпиши(данные, sigBuf2);
            if (ключ.публичныйКлюч.проверь(данные, sig1))
            {
                if (!ключ.публичныйКлюч.проверь(данные, sig2))
                {
                    if (key2.публичныйКлюч.проверь(данные, sig2))
                    {
                        if (!key2.публичныйКлюч.проверь(данные, sig1))
                            return Test.Status.Success;
                    }
                }
            }

            return Test.Status.Failure;
        }


 void main()
    {
	
        auto t = new Test("tetra.net.PKI");
        t["Public/Private Keypair"] = &_pkeyGenTest;
        t["Self-Signed Сертификат"] = &_certGenTest;
        t["Chain Valопрation"] = &_chainValопрation;
        t["RSA Crypto"] = &_rsaCrypto;
        t["RSA подпиши/проверь"] = &_rsaSignVerify;
        t.run();
    }
}
