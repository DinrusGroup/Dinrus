/*******************************************************************************

        copyright:      Copyright (c) 2008 Jeff Davey. все rights reserved

        license:        BSD стиль: $(LICENSE)

        author:         Jeff Davey <j@submersion.com>

*******************************************************************************/

module lib.OpenSSL;

private import sys.SharedLib;

private import rt.core.stdc.stdio;
private import stringz;
private import rt.core.stdc.config: c_long,c_ulong;

private import io.Stdout;
private import io.FileSystem;

private import thread;
private import sync;
private import core.sync.ReadWriteMutex;

private import Целое = text.convert.Integer;

/*******************************************************************************

    This module содержит все of the dynamic привязки needed в_ the
    OpenSSL libraries (libssl.so/libssl32.dll and libcrypto.so/libeay32.dll) 

*******************************************************************************/

/*
   XXX TODO XXX

   A lot of unsigned longs and longs were преобразованый в_ бцел and цел

   These will need в_ be reversed в_ support 64bit drTango
   (should use c_long and c_ulong из_ rt.core.stdc.config)

   XXX TODO XXX
*/


version(linux)
{
    version(build)
    {
        pragma(link, "dl");
    }
}

const бцел BYTES_ENTROPY = 2048; // default байты of entropy в_ загрузи on startup.
private CRYPTO_dynlock_value *последний = пусто;
Стопор _dynLocksMutex = пусто;
extern (C)
{
    const цел NID_sha1 = 64;
    const цел NID_md5 = 4;
    const цел RSA_PKCS1_OAEP_PADDING = 4;
    const цел RSA_PKCS1_PADDING = 1;
    const цел BIO_C_SET_NBIO = 102;
    const цел SHA_DIGEST_LENGTH = 20;
    const цел SSL_CTRL_SET_SESS_CACHE_MODE = 44;
    const цел MBSTRING_FLAG = 0x1000;
    const цел MBSTRING_ASC = MBSTRING_FLAG | 1;
    const цел EVP_PKEY_RSA = 6;
    const цел RSA_F4 = 0x1001;
    const цел SSL_SENT_SHUTDOWN = 1;
    const цел SSL_ПриёмD_SHUTDOWN = 2;
    const цел BIO_C_GET_SSL = 110;
    const цел BIO_CTRL_RESET = 1;
    const цел BIO_CTRL_INFO = 3;
    const цел BIO_FLAGS_READ = 0x01;
    const цел BIO_FLAGS_WRITE = 0x02;
    const цел BIO_FLAGS_IO_SPECIAL = 0x04;
    const цел BIO_FLAGS_SHOULD_RETRY = 0x08;
    const цел BIO_CLOSE = 0x00;
    const цел BIO_NOCLOSE = 0x01;
    const цел ASN1_STRFLGS_ESC_CTRL = 2;
    const цел ASN1_STRFLGS_ESC_MSB = 4;
    const цел XN_FLAG_SEP_MULTILINE = (4 << 16);
    const цел XN_FLAG_SPC_EQ = (1 << 23);
    const цел XN_FLAG_FN_LN = (1 << 21);
    const цел XN_FLAG_FN_ALIGN = (1 << 25);
    const цел XN_FLAG_MULTILINE = ASN1_STRFLGS_ESC_CTRL | ASN1_STRFLGS_ESC_MSB | XN_FLAG_SEP_MULTILINE | XN_FLAG_SPC_EQ | XN_FLAG_FN_LN | XN_FLAG_FN_ALIGN;

    const сим* PEM_STRING_EVP_PKEY = "ANY PRIVATE KEY";
    const сим* PEM_STRING_X509 = "CERTIFICATE";   
    const сим* PEM_STRING_RSA_PUBLIC = "RSA PUBLIC KEY";    

    const цел SSL_CTRL_OPTIONS = 32;

    const цел SSL_OP_ALL = 0x00000FFFL;
    const цел SSL_OP_NO_SSLv2 = 0x01000000L;

    const цел CRYPTO_LOCK = 1;
    const цел CRYPTO_UNLOCK = 2;
    const цел CRYPTO_READ = 4;
    const цел CRYPTO_WRITE = 8;

    const цел ERR_TXT_STRING = 0x02;

    const цел MD5_CBLOCK = 64;
    const цел MD5_LBLOCK = MD5_CBLOCK / 4;
    const цел MD5_DIGEST_LENGTH = 16;

    const цел EVP_MAX_BLOCK_LENGTH = 32;
    const цел EVP_MAX_IV_LENGTH = 16;

    struct MD5_CTX
    {
        бцел A;
        бцел B;
        бцел C;
        бцел D;
        бцел Nl;
        бцел Nh;
        бцел[MD5_LBLOCK] данные;
        бцел num;
    };

    struct EVP_CИПHER_CTX
    {
        проц *cИПher;
        проц *engine;
        цел зашифруй;
        цел buf_len;

        ббайт[EVP_MAX_IV_LENGTH] oiv;
        ббайт[EVP_MAX_IV_LENGTH] iv;
        ббайт буф[EVP_MAX_BLOCK_LENGTH];
        цел num;

        проц *ap_data;
        цел key_len;
        c_ulong флаги;
        проц *cИПher_data;
        цел final_used;
        цел block_mask;
        ббайт[EVP_MAX_BLOCK_LENGTH] finalv;
    };
    
    // fallback for OpenSSL 0.9.7l 28 Sep 2006 that defines only macros
    цел EVP_CИПHER_CTX_block_size_097l(EVP_CИПHER_CTX *e){
        return *((cast(цел*)e.cИПher)+1);
    }

    struct BIO 
    {
        BIO_METHOD *метод;
        цел function(BIO *b, цел a, сим *c, цел d, цел e, цел f) обрвызов;
        сим *cb_arg;
        цел init;
        цел глуши;
        цел флаги;
        // yдобавьa yдобавьa
    };

    typedef BIO* function(цел сок, цел close_flag) tBIO_new_СОКЕТ;
    typedef BIO* function(SSL_CTX *ctx, цел клиент) tBIO_new_ssl;
    typedef проц function(BIO *bio) tBIO_free_all;
    typedef BIO* function(BIO *b, BIO *добавь) tBIO_push;

    struct SSL_CTX {};
    struct SSL {};
    struct SSL_METHOD {};
    struct EVP_PKEY 
    {
        цел тип;
        цел save_type;
        цел references;
        проц *pkey;
        // yдобавьa yдобавьa ...        
    };
    struct X509_STORE_CTX {};
    struct EVP_CИПHER {};
    struct X509_ALGOR {};
    struct ASN1_INTEGER {};
    struct EVP_MD {};

    struct ASN1_STRING
    {
        цел length;
        цел тип;
        сим *данные;
        цел флаги;
    }

    typedef ASN1_STRING ASN1_GENERALIZEDTIME;
    typedef ASN1_STRING ASN1_TIME;

    struct X509_STORE {};
    struct X509_VAL
    {
        ASN1_TIME *notBefore;
        ASN1_TIME *notAfter;
    }
    struct X509_CINF  // being lazy here, only doing the first peices up в_ what I need
    {
        ASN1_INTEGER *vers;
        ASN1_INTEGER *серийныйНомер;
        X509_ALGOR *сигнатура;
        X509_NAME *issuer;
        X509_VAL *validity;
        // yдобавьa yдобавьa
    }

    struct X509  // ditto X509_CINF
    {
        X509_CINF *cert_info; 
        // yдобавьa yдобавьa
    };
    struct X509_NAME {};
    struct RSA {};
    struct BIO_METHOD {};

    typedef цел function(сим *буф, цел размер, цел rwflag, проц *userdata) pem_password_cb;
    typedef сим *function() d2i_of_voопр;
    typedef цел function() i2d_of_voопр;
    typedef SSL_CTX* function(SSL_METHOD *meth) tSSL_CTX_new;
    typedef SSL_METHOD* function() tSSLv23_method;
    typedef EVP_PKEY* function(цел тип, EVP_PKEY **a, ббайт **pp, цел length) td2i_PrivateKey;
    typedef цел function(SSL_CTX *ctx, EVP_PKEY *pkey) tSSL_CTX_use_PrivateKey;
    typedef проц function(SSL_CTX *ctx, цел режим, цел function(цел, X509_STORE_CTX *) обрвызов) tSSL_CTX_set_verify;
    typedef проц function(EVP_PKEY *pkey) tEVP_PKEY_free;
    typedef цел function(SSL_CTX *ctx, цел cmd, цел larg, проц *parg) tSSL_CTX_ctrl;
    typedef цел function(SSL_CTX *ctx, сим *ткт) tSSL_CTX_set_cИПher_list;
    typedef проц function(SSL_CTX *) tSSL_CTX_free;
    typedef проц function() tSSL_load_error_strings;
    typedef проц function() tSSL_library_init;
    typedef проц function() tOpenSSL_добавь_all_digests;
    typedef цел function(сим *файл, цел max_bytes) tRAND_load_file;
    typedef цел function() tCRYPTO_num_locks;
    typedef проц function(бцел function() ов) tCRYPTO_set_опр_callback;
    typedef проц function(проц function(цел режим, цел тип, сим *файл, цел строка) ов) tCRYPTO_set_locking_callback;
    typedef проц function(CRYPTO_dynlock_value *function(сим *файл, цел строка) ов) tCRYPTO_set_dynlock_create_callback;    
    typedef проц function(проц function(цел режим, CRYPTO_dynlock_value *блокируй, сим *файл, цел lineNo) ов) tCRYPTO_set_dynlock_lock_callback;
    typedef проц function(проц function(CRYPTO_dynlock_value *блокируй, сим *файл, цел строка) ов) tCRYPTO_set_dynlock_destroy_callback;
    typedef бцел function(сим **файл, цел *строка, сим **данные, цел *флаги) tERR_get_error_line_data;
    typedef проц function(бцел пид) tERR_remove_state;
    typedef проц function() tRAND_cleanup;
    typedef проц function() tERR_free_strings;
    typedef проц function() tEVP_cleanup;
    typedef проц function() tOBJ_cleanup;
    typedef проц function() tX509V3_EXT_cleanup;
    typedef проц function() tCRYPTO_cleanup_all_ex_data;
    typedef цел function(BIO *b, проц *данные, цел длин) tBIO_write;
    typedef цел function(BIO *b, проц *данные, цел длин) tBIO_read;
    typedef цел function(SSL_CTX *ctx) tSSL_CTX_check_private_key;
    typedef EVP_PKEY* function(BIO *bp, EVP_PKEY **x, pem_password_cb *ов, проц *u) tPEM_read_bio_PrivateKey;
    typedef BIO* function(сим *имяф, сим *режим) tBIO_new_file;
    typedef цел function() tERR_Просмотр_error;
    typedef цел function(BIO *b, цел флаги) tBIO_test_flags;
    typedef цел function(BIO *b, цел cmd, цел larg, проц *parg) tBIO_ctrl; 
    typedef проц function(SSL *ssl, цел режим) tSSL_set_shutdown;
    typedef цел function(SSL *ssl) tSSL_get_shutdown;
    typedef цел function(SSL_CTX *ctx, X509 *x) tSSL_CTX_use_certificate;
    typedef проц function(SSL_CTX *CTX, X509_STORE *сохрани) tSSL_CTX_set_cert_store;
    typedef цел function(SSL_CTX *ctx, сим *CAfile, сим *CApath) tSSL_CTX_load_verify_locations;
    typedef X509* function(X509_STORE_CTX *ctx) tX509_STORE_CTX_get_current_cert;
    typedef цел function(X509_STORE_CTX *ctx) tX509_STORE_CTX_get_error;
    typedef цел function(X509_STORE_CTX *ctx) tX509_STORE_CTX_get_error_depth;
    typedef X509_STORE* function() tX509_STORE_new;
    typedef проц function(X509_STORE *v) tX509_STORE_free;
    typedef цел function(X509_STORE *сохрани, X509 *x) tX509_STORE_добавь_cert;
//    typedef цел function(X509_STORE *сохрани, цел depth) tX509_STORE_set_depth;
    typedef BIO* function(проц *buff, цел длин) tBIO_new_mem_buf;
    typedef RSA* function(цел биты, бцел e, проц function(цел a, цел b, проц *c) обрвызов, проц *cb_arg) tRSA_generate_key;
    typedef EVP_PKEY* function() tEVP_PKEY_new;
    typedef цел function(EVP_PKEY *pkey, цел тип, сим *ключ) tEVP_PKEY_assign;
    typedef проц function(RSA *r) tRSA_free;
    typedef BIO* function(BIO_METHOD *тип) tBIO_new;
    typedef BIO_METHOD* function() tBIO_s_mem;
    typedef цел function(BIO *bp, EVP_PKEY *x, EVP_CИПHER *cИПher, сим *kstr, цел klen, pem_password_cb, проц *) tPEM_write_bio_PKCS8PrivateKey;
    typedef EVP_CИПHER* function() tEVP_aes_256_cbc;
    typedef ук  function(d2i_of_voопр d2i, сим *имя, BIO *bp, проц **x, pem_password_cb ов, проц *u) tPEM_ASN1_read_bio;
    typedef X509* function() tX509_new;
    typedef проц function(X509 *x) tX509_free;
    typedef цел function(X509 *x, цел ver) tX509_set_version;
    typedef цел function(ASN1_INTEGER *a, цел v) tASN1_INTEGER_set;
    typedef ASN1_INTEGER* function(X509 *x) tX509_get_serialNumber;
    typedef цел function(ASN1_INTEGER *a) tASN1_INTEGER_get;
    typedef ASN1_TIME* function(ASN1_TIME *s, цел adj) tX509_gmtime_adj;
    typedef цел function(X509 *x, EVP_PKEY *pkey) tX509_set_pubkey;
    typedef X509_NAME* function(X509 *x) tX509_get_subject_name;
    typedef цел function(BIO *b, X509_NAME *nm, цел indent, бцел флаги) tX509_NAME_print_ex;
    typedef цел function(X509 *x, X509_NAME *имя) tX509_set_issuer_name;
    typedef цел function(X509 *x, EVP_PKEY *pkey, EVP_MD *md) tX509_sign;
    typedef EVP_MD* function() tEVP_sha1;
    typedef X509_STORE_CTX* function() tX509_STORE_CTX_new;
    typedef цел function(X509_STORE_CTX *ctx, X509_STORE *сохрани, X509 *x509, проц *shizzle) tX509_STORE_CTX_init;
    typedef цел function(X509_STORE_CTX *ctx) tX509_verify_cert;
    typedef проц function(X509_STORE_CTX *ctx) tX509_STORE_CTX_free;
    typedef цел function(i2d_of_voопр i2d, сим *имя, BIO *bp, сим *x, EVP_CИПHER *enc, сим *kstr, цел klen, pem_password_cb ов, проц *u) tPEM_ASN1_write_bio;
    typedef цел function(X509_NAME *имя, сим* field, цел тип, сим *байты, цел длин, цел loc, цел установи) tX509_NAME_добавь_entry_by_txt;
    typedef цел function(SSL_CTX *ctx, ббайт *опр, бцел длин) tSSL_CTX_set_session_опр_context;
    typedef цел function(EVP_PKEY *a, EVP_PKEY *b) tEVP_PKEY_cmp_parameters;
    typedef цел function(X509 *a, X509 *b) tX509_cmp;
    typedef проц function() tOPENSSL_добавь_all_algorithms_noconf;
    typedef ASN1_GENERALIZEDTIME *function(ASN1_TIME *t, ASN1_GENERALIZEDTIME **outTime) tASN1_TIME_to_generalizedtime;
    typedef проц function(ASN1_STRING *a) tASN1_STRING_free;
    typedef цел function() tRAND_poll;
    typedef цел function(RSA *rsa) tRSA_size;
    typedef цел function(цел flen, ббайт *из_, ббайт *в_, RSA *rsa, цел паддинг) tRSA_public_encrypt;
    typedef цел function(цел flen, ббайт *из_, ббайт *в_, RSA *rsa, цел паддинг) tRSA_private_decrypt;
    typedef цел function(цел flen, ббайт *из_, ббайт *в_, RSA *rsa, цел паддинг) tRSA_private_encrypt;
    typedef цел function(цел flen, ббайт *из_, ббайт *в_, RSA *rsa, цел паддинг) tRSA_public_decrypt;
    typedef цел function(цел тип, ббайт *m, бцел m_length, ббайт *sigret, бцел *siglen, RSA *rsa) tRSA_sign;
    typedef цел function(цел тип, ббайт *m, бцел m_length, ббайт *sigbuf, бцел siglen, RSA *rsa) tRSA_verify;
    typedef проц function(MD5_CTX *c) tMD5_Init;
    typedef проц function(MD5_CTX *c, проц *данные, т_мера длин) tMD5_Update;
    typedef проц function(ббайт *md, MD5_CTX *c) tMD5_Final;
    typedef цел function(EVP_CИПHER_CTX *ctx, EVP_CИПHER *тип, проц *impl, ббайт *ключ, ббайт *iv) tEVP_EncryptInit_ex;
    typedef цел function(EVP_CИПHER_CTX *ctx, EVP_CИПHER *тип, проц *impl, ббайт *ключ, ббайт*iv) tEVP_DecryptInit_ex;
    typedef цел function(EVP_CИПHER_CTX *ctx, ббайт *outv, цел *outl, ббайт *inv, цел inl) tEVP_EncryptUpdate;
    typedef цел function(EVP_CИПHER_CTX *ctx, ббайт *outv, цел *outl, ббайт *inv, цел inl) tEVP_DecryptUpdate;
    typedef цел function(EVP_CИПHER_CTX *ctx, ббайт *outv, цел *outl) tEVP_EncryptFinal_ex;
    typedef цел function(EVP_CИПHER_CTX *ctx, ббайт *outv, цел *outl) tEVP_DecryptFinal_ex;
    typedef цел function(EVP_CИПHER_CTX *ctx) tEVP_CИПHER_CTX_block_size;
    typedef EVP_CИПHER *function() tEVP_aes_128_cbc;
    typedef цел function(EVP_CИПHER_CTX *ctx) tEVP_CИПHER_CTX_cleanup;

    struct CRYPTO_dynlock_value
    {
        ReadWriteMutex блокируй;
        CRYPTO_dynlock_value *следщ;
        CRYPTO_dynlock_value *prev;
    }

    бцел идНитиССЛ()
    {
        return cast(бцел)cast(проц*)Нить.getThis;
    }
    проц статичЗамокССЛ(цел режим, цел индекс, сим *sourceFile, цел lineNo)
    {
        if (_locks)
        {
            if (режим & CRYPTO_LOCK)
            {
                if (режим & CRYPTO_READ)
                    _locks[индекс].читатель.блокируй();
                else
                    _locks[индекс].писатель.блокируй();
            }
            else
            {
                if (режим & CRYPTO_READ)
                    _locks[индекс].читатель.разблокируй();
                else
                    _locks[индекс].писатель.разблокируй();
            }

        } 
    }
    бцел ablah = 0;
    CRYPTO_dynlock_value *создайДинамичЗамокССЛ(сим *sourceFile, цел lineNo)
    {
        auto rtn = new CRYPTO_dynlock_value;
        rtn.блокируй = new ReadWriteMutex;
        synchronized
        {
            if (последний is пусто)
                последний = rtn;
            else
            {
                rtn.prev = последний;
                последний.следщ = rtn;
                последний = rtn;
            }        
        }
        return rtn; 
    }

    проц закройДинамичЗамокССЛ(цел режим, CRYPTO_dynlock_value *блокируй, сим *sourceFile, цел lineNo)
    {
        if (блокируй && блокируй.блокируй)
        {
            if (режим & CRYPTO_LOCK)
            {
                if (режим & CRYPTO_READ)
                    блокируй.блокируй.читатель.блокируй();
                else
                    блокируй.блокируй.писатель.блокируй();
            }
            else
            {
                if (режим & CRYPTO_READ)
                    блокируй.блокируй.читатель.разблокируй();
                else
                    блокируй.блокируй.писатель.разблокируй();
            }
        } 
    }

    проц удалиДинамичЗамокССЛ(CRYPTO_dynlock_value *блокируй, сим *sourceFile, цел lineNo)
    {
        synchronized
        {
            if (блокируй.prev)
                блокируй.prev.следщ = блокируй.следщ;
            if (блокируй.следщ)
                блокируй.следщ.prev = блокируй.prev;    
            if (блокируй is последний)
                последний = блокируй.prev;
            блокируй = блокируй.следщ = блокируй.prev = пусто;
        }
    }

}
private бул _bioTestFlags = да;
tBIO_test_flags BIO_test_flags;
tBIO_new_СОКЕТ BIO_new_socket;
tBIO_new_ssl BIO_new_ssl;
tBIO_free_all BIO_free_all;
tBIO_push BIO_push;
tBIO_read BIO_read;
tBIO_write BIO_write;
tSSL_CTX_new SSL_CTX_new;
tSSLv23_method SSLv23_method;
td2i_PrivateKey d2i_PrivateKey;
tSSL_CTX_use_PrivateKey SSL_CTX_use_PrivateKey;
tSSL_CTX_set_verify SSL_CTX_set_verify;
tEVP_PKEY_free EVP_PKEY_free;
tSSL_CTX_ctrl SSL_CTX_ctrl;
tSSL_CTX_set_cИПher_list SSL_CTX_set_cИПher_list;
tSSL_CTX_free SSL_CTX_free;
tSSL_load_error_strings SSL_load_error_strings;
tSSL_library_init SSL_library_init;
tRAND_load_file RAND_load_file;
tCRYPTO_num_locks CRYPTO_num_locks;
tCRYPTO_set_опр_callback CRYPTO_set_опр_callback;
tCRYPTO_set_locking_callback CRYPTO_set_locking_callback;
tCRYPTO_set_dynlock_create_callback CRYPTO_set_dynlock_create_callback;
tCRYPTO_set_dynlock_lock_callback CRYPTO_set_dynlock_lock_callback;
tCRYPTO_set_dynlock_destroy_callback CRYPTO_set_dynlock_destroy_callback;
tERR_get_error_line_data ERR_get_error_line_data;
tERR_remove_state ERR_remove_state;
tRAND_cleanup RAND_cleanup;
tERR_free_strings ERR_free_strings;
tEVP_cleanup EVP_cleanup;
tOBJ_cleanup OBJ_cleanup;
tX509V3_EXT_cleanup X509V3_EXT_cleanup;
tCRYPTO_cleanup_all_ex_data CRYPTO_cleanup_all_ex_data;
tSSL_CTX_check_private_key SSL_CTX_check_private_key;
tPEM_read_bio_PrivateKey PEM_read_bio_PrivateKey;
tBIO_new_file BIO_new_file;
tERR_Просмотр_error ERR_Просмотр_error;
tBIO_ctrl BIO_ctrl;
tSSL_get_shutdown SSL_get_shutdown;
tSSL_set_shutdown SSL_set_shutdown;
tSSL_CTX_use_certificate SSL_CTX_use_certificate;
tSSL_CTX_set_cert_store SSL_CTX_set_cert_store;
tSSL_CTX_load_verify_locations SSL_CTX_load_verify_locations;
tX509_STORE_CTX_get_current_cert X509_STORE_CTX_get_current_cert;
tX509_STORE_CTX_get_error_depth X509_STORE_CTX_get_error_depth;
tX509_STORE_CTX_get_error X509_STORE_CTX_get_error;
tX509_STORE_new X509_STORE_new;
tX509_STORE_free X509_STORE_free;
tX509_STORE_добавь_cert X509_STORE_добавь_cert;
//tX509_STORE_set_depth X509_STORE_set_depth;
tBIO_new_mem_buf BIO_new_mem_buf;
tRSA_generate_key RSA_generate_key;
tEVP_PKEY_new EVP_PKEY_new;
tEVP_PKEY_assign EVP_PKEY_assign;
tRSA_free RSA_free;
tBIO_new BIO_new;
tBIO_s_mem BIO_s_mem;
tPEM_write_bio_PKCS8PrivateKey PEM_write_bio_PKCS8PrivateKey;
tEVP_aes_256_cbc EVP_aes_256_cbc;
tPEM_ASN1_read_bio PEM_ASN1_read_bio;
d2i_of_voопр d2i_X509;
d2i_of_voопр d2i_RSAPublicKey;
tX509_new X509_new;
tX509_free X509_free;
tX509_set_version X509_set_version;
tASN1_INTEGER_set ASN1_INTEGER_set;
tX509_get_serialNumber X509_get_serialNumber;
tASN1_INTEGER_get ASN1_INTEGER_get;
tX509_gmtime_adj X509_gmtime_adj;
tX509_set_pubkey X509_set_pubkey;
tX509_get_subject_name X509_get_subject_name;
tX509_NAME_print_ex X509_NAME_print_ex;
tX509_set_issuer_name X509_set_issuer_name;
tX509_sign X509_sign;
tEVP_sha1 EVP_sha1;
tX509_STORE_CTX_new X509_STORE_CTX_new;
tX509_STORE_CTX_init X509_STORE_CTX_init;
tX509_verify_cert X509_verify_cert;
tX509_STORE_CTX_free X509_STORE_CTX_free;
tPEM_ASN1_write_bio PEM_ASN1_write_bio;
i2d_of_voопр i2d_X509;
i2d_of_voопр i2d_RSAPublicKey;
tX509_NAME_добавь_entry_by_txt X509_NAME_добавь_entry_by_txt;
tSSL_CTX_set_session_опр_context SSL_CTX_set_session_опр_context;
tEVP_PKEY_cmp_parameters EVP_PKEY_cmp_parameters;
tX509_cmp X509_cmp;
tOPENSSL_добавь_all_algorithms_noconf OPENSSL_добавь_all_algorithms_noconf;
tASN1_TIME_to_generalizedtime ASN1_TIME_to_generalizedtime;
tASN1_STRING_free ASN1_STRING_free;
tRAND_poll RAND_poll;
tRSA_size RSA_size;
tRSA_public_encrypt RSA_public_encrypt;
tRSA_private_decrypt RSA_private_decrypt;
tRSA_private_encrypt RSA_private_encrypt;
tRSA_public_decrypt RSA_public_decrypt;
tRSA_sign RSA_sign;
tRSA_verify RSA_verify;
tMD5_Init MD5_Init;
tMD5_Update MD5_Update;
tMD5_Final MD5_Final;
tEVP_EncryptInit_ex EVP_EncryptInit_ex;
tEVP_DecryptInit_ex EVP_DecryptInit_ex;
tEVP_EncryptUpdate EVP_EncryptUpdate;
tEVP_DecryptUpdate EVP_DecryptUpdate;
tEVP_EncryptFinal_ex EVP_EncryptFinal_ex;
tEVP_DecryptFinal_ex EVP_DecryptFinal_ex;
tEVP_aes_128_cbc EVP_aes_128_cbc;
tEVP_CИПHER_CTX_block_size EVP_CИПHER_CTX_block_size;
tEVP_CИПHER_CTX_cleanup EVP_CИПHER_CTX_cleanup;

цел PEM_write_bio_RSAPublicKey(BIO *bp, RSA *x)
{
    return PEM_ASN1_write_bio(i2d_RSAPublicKey, PEM_STRING_RSA_PUBLIC, bp, cast(сим*)x, пусто, пусто, 0, пусто, пусто);
}

RSA *PEM_read_bio_RSAPublicKey(BIO *bp, RSA **x, pem_password_cb ов, проц *u)
{
    return cast(RSA *)PEM_ASN1_read_bio(d2i_RSAPublicKey, PEM_STRING_RSA_PUBLIC, bp, cast(проц **)x, ов, u);
}

цел PEM_write_bio_X509(BIO *b, X509 *x)
{
    return PEM_ASN1_write_bio(i2d_X509, PEM_STRING_X509, b,cast(сим *)x, пусто, пусто, 0, пусто, пусто);
}

ASN1_TIME *X509_get_notBefore(X509 *x)
{
    return x.cert_info.validity.notBefore;
}

ASN1_TIME *X509_get_notAfter(X509 *x)
{
    return x.cert_info.validity.notAfter;
}

цел EVP_PKEY_assign_RSA(EVP_PKEY *ключ, RSA *rsa)
{
    return EVP_PKEY_assign(ключ, EVP_PKEY_RSA, cast(сим*)rsa);
}

цел BIO_get_mem_data(BIO *b, сим **данные)
{
    return BIO_ctrl(b, BIO_CTRL_INFO, 0, данные);
}

проц BIO_get_ssl(BIO *b, SSL **об)
{
    BIO_ctrl(b, BIO_C_GET_SSL, 0, об);
}

цел SSL_CTX_set_options(SSL_CTX *ctx, цел larg)
{
    return SSL_CTX_ctrl(ctx, SSL_CTRL_OPTIONS, larg, пусто);
}

цел SSL_CTX_set_session_cache_mode(SSL_CTX *ctx, цел режим)
{
    return SSL_CTX_ctrl(ctx, SSL_CTRL_SET_SESS_CACHE_MODE, режим, пусто);
}

цел BIO_reset(BIO *b)
{
    return BIO_ctrl(b, BIO_CTRL_RESET, 0, пусто);
}

бул BIO_should_retry(BIO *b)
{
    if (_bioTestFlags)
        return cast(бул)BIO_test_flags(b, BIO_FLAGS_SHOULD_RETRY);
    return cast(бул)(b.флаги & BIO_FLAGS_SHOULD_RETRY);
}

бул BIO_should_io_special(BIO *b)
{
    if (_bioTestFlags)
        return cast(бул)BIO_test_flags(b, BIO_FLAGS_IO_SPECIAL);
    return cast(бул)(b.флаги & BIO_FLAGS_IO_SPECIAL);
}

бул BIO_should_read(BIO *b)
{
    if (_bioTestFlags)
        return cast(бул)BIO_test_flags(b, BIO_FLAGS_READ);
    return cast(бул)(b.флаги & BIO_FLAGS_READ);
}

бул BIO_should_write(BIO *b)
{
    if (_bioTestFlags)
        return cast(бул)BIO_test_flags(b, BIO_FLAGS_WRITE);
    return cast(бул)(b.флаги & BIO_FLAGS_WRITE);
}

X509* PEM_read_bio_X509(BIO *b, X509 **x, pem_password_cb ов, проц *u)
{
    return cast(X509 *)PEM_ASN1_read_bio(d2i_X509, PEM_STRING_X509, b, cast(проц**)x, ов, u);
}


private проц bindFunc(T)(inout T func, ткст funcName, Длл lib)
in
{
    assert(funcName);
    assert(lib);
}
body
{
    проц *funcPtr = lib.дайСимвол(вТкст0(funcName));
    if (funcPtr)
    {
        проц **point = cast(проц **)&func;
        *point = funcPtr;
    }
    else
        throw new Исключение("Could not загрузи symbol: " ~ funcName);
}

static Длл ssllib = пусто;
version(Win32)
{
    static Длл eaylib = пусто;
}
version(darwin){
    static Длл cryptolib = пусто;
}
static ReadWriteMutex[] _locks = пусто;


проц выдайОшибкуОпенССЛ()
{
    if (ERR_Просмотр_error())
    {
        ткст exceptionString;

        цел флаги, строка;
        сим *данные;
        сим *файл;
        бцел код;

        код = ERR_get_error_line_data(&файл, &строка, &данные, &флаги);
        while (код != 0)
        {
            if (данные && (флаги & ERR_TXT_STRING))
                exceptionString ~= Стдвыв.выкладка.преобразуй("ssl ошибка код: {} {}:{} - {}\r\n", код, изТкст0(файл), строка, изТкст0(данные));
            else
                exceptionString ~= Стдвыв.выкладка.преобразуй("ssl ошибка код: {} {}:{}\r\n", код, изТкст0(файл), строка); 
            код = ERR_get_error_line_data(&файл, &строка, &данные, &флаги);
        }
        throw new Исключение(exceptionString);
    }
    else
        throw new Исключение("Unknown OpenSSL ошибка.");
}

проц _initOpenSSL()
{
    SSL_load_error_strings();
    SSL_library_init();
    OPENSSL_добавь_all_algorithms_noconf();
    version(Posix)
        RAND_load_file("/dev/urandom", BYTES_ENTROPY);
    version(Win32)
    {
        RAND_poll();
    }

    бцел numLocks = CRYPTO_num_locks();
    if ((_locks = new ReadWriteMutex[numLocks]) !is пусто)
    {
        бцел i = 0;
        for (; i < numLocks; i++)
        {
            if((_locks[i] = new ReadWriteMutex()) is пусто)
                break;
        }
        if (i == numLocks)
        {
            CRYPTO_set_опр_callback(&идНитиССЛ);
            CRYPTO_set_locking_callback(&статичЗамокССЛ);

            CRYPTO_set_dynlock_create_callback(&создайДинамичЗамокССЛ);
            CRYPTO_set_dynlock_lock_callback(&закройДинамичЗамокССЛ);
            CRYPTO_set_dynlock_destroy_callback(&удалиДинамичЗамокССЛ);

        }
    } 
}

static this()
{
    version(Win32)
        loadEAY32();
    loadOpenSSL();
}
// Though it would be nice в_ do this, it can't be закрыт until все the СОКЕТs and etc have been collected.. not sure как в_ do that.
/*static ~this()
{
    closeOpenSSL();
}*/


Длл loadLib(ткст[] loadPath)
{
    Длл rtn;
    foreach(путь; loadPath)
    {
        try
            rtn = Длл.загрузи(путь);
        catch (ИсклДлл ex)
        {
            ткст текрабпап = ФСистема.дайПапку();
            try
                rtn = Длл.загрузи(текрабпап ~ путь);
            catch (ИсклДлл ex)
            {}
        }
    }
    return rtn;
}

version (Win32)
{
    проц loadEAY32()
    {
        ткст[] loadPath = [ "libeay32.dll" ];
        if ((eaylib = loadLib(loadPath)) !is пусто)
        {
            вяжиКрипто(eaylib);    
        }
    }

}

проц вяжиКрипто(Длл ssllib)
{
    if (ssllib)
    {
        bindFunc(X509_cmp, "X509_cmp", ssllib);
        bindFunc(OPENSSL_добавь_all_algorithms_noconf, "OPENSSL_добавь_all_algorithms_noconf", ssllib);
        bindFunc(ASN1_TIME_to_generalizedtime, "ASN1_TIME_to_generalizedtime", ssllib);
        bindFunc(ASN1_STRING_free, "ASN1_STRING_free", ssllib);
        bindFunc(EVP_PKEY_cmp_parameters, "EVP_PKEY_cmp_parameters", ssllib);
        bindFunc(X509_STORE_CTX_get_current_cert, "X509_STORE_CTX_get_current_cert", ssllib);
        bindFunc(X509_STORE_CTX_get_error_depth, "X509_STORE_CTX_get_error_depth", ssllib);
        bindFunc(X509_STORE_CTX_get_error, "X509_STORE_CTX_get_error", ssllib);
        bindFunc(X509_STORE_new, "X509_STORE_new", ssllib);
        bindFunc(X509_STORE_free, "X509_STORE_free", ssllib);
        bindFunc(X509_STORE_добавь_cert, "X509_STORE_добавь_cert", ssllib);
//        bindFunc(X509_STORE_set_depth, "X509_STORE_set_depth", ssllib);
        bindFunc(BIO_new_mem_buf, "BIO_new_mem_buf", ssllib);
        bindFunc(RSA_generate_key, "RSA_generate_key", ssllib);
        bindFunc(EVP_PKEY_new, "EVP_PKEY_new", ssllib);
        bindFunc(EVP_PKEY_assign, "EVP_PKEY_assign", ssllib);
        bindFunc(RSA_free, "RSA_free", ssllib);
        bindFunc(BIO_new, "BIO_new", ssllib);
        bindFunc(BIO_s_mem, "BIO_s_mem", ssllib);
        bindFunc(PEM_write_bio_PKCS8PrivateKey, "PEM_write_bio_PKCS8PrivateKey", ssllib);
        bindFunc(EVP_aes_256_cbc, "EVP_aes_256_cbc", ssllib);
        bindFunc(PEM_ASN1_read_bio, "PEM_ASN1_read_bio", ssllib);
        bindFunc(d2i_X509, "d2i_X509", ssllib);
        bindFunc(d2i_RSAPublicKey, "d2i_RSAPublicKey", ssllib);
        bindFunc(X509_new, "X509_new", ssllib);
        bindFunc(X509_free, "X509_free", ssllib);
        bindFunc(X509_set_version, "X509_set_version", ssllib);
        bindFunc(ASN1_INTEGER_set, "ASN1_INTEGER_set", ssllib);
        bindFunc(X509_get_serialNumber, "X509_get_serialNumber", ssllib);
        bindFunc(ASN1_INTEGER_get, "ASN1_INTEGER_get", ssllib);
        bindFunc(X509_gmtime_adj, "X509_gmtime_adj", ssllib);
        bindFunc(X509_set_pubkey, "X509_set_pubkey", ssllib);
        bindFunc(X509_get_subject_name, "X509_get_subject_name", ssllib);
        bindFunc(X509_NAME_print_ex, "X509_NAME_print_ex", ssllib);
        bindFunc(X509_set_issuer_name, "X509_set_issuer_name", ssllib);
        bindFunc(X509_sign, "X509_sign", ssllib);
        bindFunc(EVP_sha1, "EVP_sha1", ssllib);
        bindFunc(X509_STORE_CTX_new, "X509_STORE_CTX_new", ssllib);
        bindFunc(X509_STORE_CTX_init, "X509_STORE_CTX_init", ssllib);
        bindFunc(X509_verify_cert, "X509_verify_cert", ssllib);
        bindFunc(X509_STORE_CTX_free, "X509_STORE_CTX_free", ssllib);
        bindFunc(PEM_ASN1_write_bio, "PEM_ASN1_write_bio", ssllib);
        bindFunc(i2d_X509, "i2d_X509", ssllib);
        bindFunc(i2d_RSAPublicKey, "i2d_RSAPublicKey", ssllib);
        bindFunc(X509_NAME_добавь_entry_by_txt, "X509_NAME_добавь_entry_by_txt", ssllib);
        bindFunc(PEM_read_bio_PrivateKey, "PEM_read_bio_PrivateKey", ssllib);
        bindFunc(BIO_new_file, "BIO_new_file", ssllib);
        bindFunc(ERR_Просмотр_error, "ERR_Просмотр_error", ssllib);
        try
            bindFunc(BIO_test_flags, "BIO_test_flags", ssllib); // 0.9.7 doesn't have this function, it access the struct directly
        catch (Исключение ex)
            _bioTestFlags = нет;
        bindFunc(BIO_ctrl, "BIO_ctrl", ssllib);
        bindFunc(RAND_load_file, "RAND_load_file", ssllib);
        bindFunc(CRYPTO_num_locks, "CRYPTO_num_locks", ssllib);
        bindFunc(CRYPTO_set_опр_callback, "CRYPTO_set_опр_callback", ssllib);
        bindFunc(CRYPTO_set_locking_callback, "CRYPTO_set_locking_callback", ssllib);
        bindFunc(CRYPTO_set_dynlock_create_callback, "CRYPTO_set_dynlock_create_callback", ssllib);
        bindFunc(CRYPTO_set_dynlock_lock_callback, "CRYPTO_set_dynlock_lock_callback", ssllib);
        bindFunc(CRYPTO_set_dynlock_lock_callback, "CRYPTO_set_dynlock_lock_callback", ssllib);
        bindFunc(CRYPTO_set_dynlock_destroy_callback, "CRYPTO_set_dynlock_destroy_callback", ssllib);
        bindFunc(ERR_get_error_line_data, "ERR_get_error_line_data", ssllib);
        bindFunc(ERR_remove_state, "ERR_remove_state", ssllib);
        bindFunc(RAND_cleanup, "RAND_cleanup", ssllib);
        bindFunc(ERR_free_strings, "ERR_free_strings", ssllib);
        bindFunc(EVP_cleanup, "EVP_cleanup", ssllib);
        bindFunc(OBJ_cleanup, "OBJ_cleanup", ssllib);
        bindFunc(X509V3_EXT_cleanup, "X509V3_EXT_cleanup", ssllib);
        bindFunc(CRYPTO_cleanup_all_ex_data, "CRYPTO_cleanup_all_ex_data", ssllib);
        bindFunc(BIO_read, "BIO_read", ssllib);
        bindFunc(BIO_write, "BIO_write", ssllib);
        bindFunc(EVP_PKEY_free, "EVP_PKEY_free", ssllib);
        bindFunc(d2i_PrivateKey, "d2i_PrivateKey", ssllib);    
        bindFunc(BIO_free_all, "BIO_free_all", ssllib);
        bindFunc(BIO_push, "BIO_push", ssllib);    
        bindFunc(BIO_new_socket, "BIO_new_socket", ssllib);
        bindFunc(RAND_poll, "RAND_poll", ssllib);
        bindFunc(RSA_size, "RSA_size", ssllib);
        bindFunc(RSA_public_encrypt, "RSA_public_encrypt", ssllib);
        bindFunc(RSA_private_decrypt, "RSA_private_decrypt", ssllib);
        bindFunc(RSA_private_encrypt, "RSA_private_encrypt", ssllib);
        bindFunc(RSA_public_decrypt, "RSA_public_decrypt", ssllib);
        bindFunc(RSA_sign, "RSA_sign", ssllib);
        bindFunc(RSA_verify, "RSA_verify", ssllib);
        bindFunc(MD5_Init, "MD5_Init", ssllib);
        bindFunc(MD5_Update, "MD5_Update", ssllib);
        bindFunc(MD5_Final, "MD5_Final", ssllib);
        bindFunc(EVP_EncryptInit_ex, "EVP_EncryptInit_ex", ssllib);
        bindFunc(EVP_DecryptInit_ex, "EVP_DecryptInit_ex", ssllib);
        bindFunc(EVP_EncryptUpdate, "EVP_EncryptUpdate", ssllib);
        bindFunc(EVP_DecryptUpdate,  "EVP_DecryptUpdate", ssllib);
        bindFunc(EVP_EncryptFinal_ex, "EVP_EncryptFinal_ex", ssllib);
        bindFunc(EVP_DecryptFinal_ex, "EVP_DecryptFinal_ex", ssllib);
        bindFunc(EVP_aes_128_cbc, "EVP_aes_128_cbc", ssllib);
        try {
            bindFunc(EVP_CИПHER_CTX_block_size, "EVP_CИПHER_CTX_block_size", ssllib);
        } catch (Исключение e){
            // openSSL 0.9.7l defines only macros, not the function
            EVP_CИПHER_CTX_block_size=&EVP_CИПHER_CTX_block_size_097l;
        }
        bindFunc(EVP_CИПHER_CTX_cleanup, "EVP_CИПHER_CTX_cleanup", ssllib);
    }
}

проц loadOpenSSL()
{
    version (linux)
    {
        ткст[] loadPath = [ "libssl.so.0.9.8", "libssl.so" ];
    }
    version (Win32)
    {
        ткст[] loadPath = [ "libssl32.dll" ];
    }
    version (darwin)
    {
        ткст[] loadPath = [ "/usr/lib/libssl.dylib", "libssl.dylib" ];
    }
    version (freebsd)
    {
        ткст[] loadPath = [ "libssl.so.5", "libssl.so" ];
    }
    version (solaris)
    {
        ткст[] loadPath = [ "libssl.so.0.9.8", "libssl.so" ];
    }
    if ((ssllib = loadLib(loadPath)) !is пусто)
    {

        bindFunc(BIO_new_ssl, "BIO_new_ssl", ssllib);
        bindFunc(SSL_CTX_free, "SSL_CTX_free", ssllib);
        bindFunc(SSL_CTX_new, "SSL_CTX_new", ssllib);
        bindFunc(SSLv23_method, "SSLv23_method", ssllib);
        bindFunc(SSL_CTX_use_PrivateKey, "SSL_CTX_use_PrivateKey", ssllib);
        bindFunc(SSL_CTX_set_verify, "SSL_CTX_set_verify", ssllib);
        bindFunc(SSL_CTX_ctrl, "SSL_CTX_ctrl", ssllib);
        bindFunc(SSL_CTX_set_cИПher_list, "SSL_CTX_set_cИПher_list", ssllib);
        bindFunc(SSL_load_error_strings, "SSL_load_error_strings", ssllib);
        bindFunc(SSL_library_init, "SSL_library_init", ssllib);
        bindFunc(SSL_CTX_check_private_key, "SSL_CTX_check_private_key", ssllib);
        bindFunc(SSL_get_shutdown, "SSL_get_shutdown", ssllib);
        bindFunc(SSL_set_shutdown, "SSL_set_shutdown", ssllib);
        bindFunc(SSL_CTX_use_certificate, "SSL_CTX_use_certificate", ssllib);
        bindFunc(SSL_CTX_set_cert_store, "SSL_CTX_set_cert_store", ssllib);
        bindFunc(SSL_CTX_load_verify_locations, "SSL_CTX_load_verify_locations", ssllib);
        bindFunc(SSL_CTX_set_session_опр_context, "SSL_CTX_set_session_опр_context", ssllib);
        version(Posix)
        {
            version(darwin){
                ткст[] loadPathCrypto = [ "/usr/lib/libcrypto.dylib", "libcrypto.dylib" ];
                cryptolib = loadLib(loadPathCrypto);
                if (cryptolib !is пусто) вяжиКрипто(cryptolib);
            } else {
                вяжиКрипто(ssllib);
            }
        }

        _initOpenSSL();
    }
    else
        throw new Исключение("Could not загрузи OpenSSL library.");
}

проц closeOpenSSL()
{
    CRYPTO_set_опр_callback(пусто);
    CRYPTO_set_locking_callback(пусто);
    CRYPTO_set_dynlock_create_callback(пусто);
    CRYPTO_set_dynlock_lock_callback(пусто);
    CRYPTO_set_dynlock_destroy_callback(пусто);
    ERR_remove_state(0);
    RAND_cleanup();
    ERR_free_strings();
    EVP_cleanup();
    OBJ_cleanup();
    X509V3_EXT_cleanup();
    CRYPTO_cleanup_all_ex_data();
    if (ssllib)
        ssllib.выгрузи();
    version(darwin){
        if (cryptolib)
            cryptolib.выгрузи();
    }
    version(Win32)
    {
        if (eaylib)
            eaylib.выгрузи();
    }
}
