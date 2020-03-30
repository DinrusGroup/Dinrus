/**
 * Windows API header module
 *
 * Translated from MinGW Windows headers
 *
 * Authors: Ellery Newcomer, John Colvin
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source: $(DRUNTIMESRC src/core/sys/windows/_security.d)
 */
module core.sys.windows.security;
version (Windows):

enum : SECURITY_STATUS
{
    SEC_E_OK = 0x00000000,
    SEC_E_INSUFFICIENT_MEMORY = 0x80090300,
    SEC_E_INVALID_HANDLE = 0x80090301,
    SEC_E_UNSUPPORTED_FUNCTION = 0x80090302,
    SEC_E_TARGET_UNKNOWN = 0x80090303,
    SEC_E_INTERNAL_ERROR = 0x80090304,
    SEC_E_SECPKG_NOT_FOUND = 0x80090305,
    SEC_E_NOT_OWNER = 0x80090306,
    SEC_E_CANNOT_INSTALL = 0x80090307,
    SEC_E_INVALID_TOKEN = 0x80090308,
    SEC_E_CANNOT_PACK = 0x80090309,
    SEC_E_QOP_NOT_SUPPORTED = 0x8009030A,
    SEC_E_NO_IMPERSONATION = 0x8009030B,
    SEC_E_LOGON_DENIED = 0x8009030C,
    SEC_E_UNKNOWN_CREDENTIALS = 0x8009030D,
    SEC_E_NO_CREDENTIALS = 0x8009030E,
    SEC_E_MESSAGE_ALTERED = 0x8009030F,
    SEC_E_OUT_OF_SEQUENCE = 0x80090310,
    SEC_E_NO_AUTHENTICATING_AUTHORITY = 0x80090311,
    SEC_E_BAD_PKGID = 0x80090316,
    SEC_E_CONTEXT_EXPIRED = 0x80090317,
    SEC_E_INCOMPLETE_MESSAGE = 0x80090318,
    SEC_E_INCOMPLETE_CREDENTIALS = 0x80090320,
    SEC_E_BUFFER_TOO_SMALL = 0x80090321,
    SEC_E_WRONG_PRINCIPAL = 0x80090322,
    SEC_E_TIME_SKEW = 0x80090324,
    SEC_E_UNTRUSTED_ROOT = 0x80090325,
    SEC_E_ILLEGAL_MESSAGE = 0x80090326,
    SEC_E_CERT_UNKNOWN = 0x80090327,
    SEC_E_CERT_EXPIRED = 0x80090328,
    SEC_E_ENCRYPT_FAILURE = 0x80090329,
    SEC_E_DECRYPT_FAILURE = 0x80090330,
    SEC_E_ALGORITHM_MISMATCH = 0x80090331,
    SEC_E_SECURITY_QOS_FAILED = 0x80090332,
    SEC_E_UNFINISHED_CONTEXT_DELETED = 0x80090333,
    SEC_E_NO_TGT_REPLY = 0x80090334,
    SEC_E_NO_IP_ADDRESSES = 0x80090335,
    SEC_E_WRONG_CREDENTIAL_HANDLE = 0x80090336,
    SEC_E_CRYPTO_SYSTEM_INVALID = 0x80090337,
    SEC_E_MAX_REFERRALS_EXCEEDED = 0x80090338,
    SEC_E_MUST_BE_KDC = 0x80090339,
    SEC_E_STRONG_CRYPTO_NOT_SUPPORTED = 0x8009033A,
    SEC_E_TOO_MANY_PRINCIPALS = 0x8009033B,
    SEC_E_NO_PA_DATA = 0x8009033C,
    SEC_E_PKINIT_NAME_MISMATCH = 0x8009033D,
    SEC_E_SMARTCARD_LOGON_REQUIRED = 0x8009033E,
    SEC_E_SHUTDOWN_IN_PROGRESS = 0x8009033F,
    SEC_E_KDC_INVALID_REQUEST = 0x80090340,
    SEC_E_KDC_UNABLE_TO_REFER = 0x80090341,
    SEC_E_KDC_UNKNOWN_ETYPE = 0x80090342,
    SEC_E_UNSUPPORTED_PREAUTH = 0x80090343,
    SEC_E_DELEGATION_REQUIRED = 0x80090345,
    SEC_E_BAD_BINDINGS = 0x80090346,
    SEC_E_MULTIPLE_ACCOUNTS = 0x80090347,
    SEC_E_NO_KERB_KEY = 0x80090348,
    SEC_E_CERT_WRONG_USAGE = 0x80090349,
    SEC_E_DOWNGRADE_DETECTED = 0x80090350,
    SEC_E_SMARTCARD_CERT_REVOKED = 0x80090351,
    SEC_E_ISSUING_CA_UNTRUSTED = 0x80090352,
    SEC_E_REVOCATION_OFFLINE_C = 0x80090353,
    SEC_E_PKINIT_CLIENT_FAILURE = 0x80090354,
    SEC_E_SMARTCARD_CERT_EXPIRED = 0x80090355,
    SEC_E_NO_S4U_PROT_SUPPORT = 0x80090356,
    SEC_E_CROSSREALM_DELEGATION_FAILURE = 0x80090357,
    SEC_E_REVOCATION_OFFLINE_KDC = 0x80090358,
    SEC_E_ISSUING_CA_UNTRUSTED_KDC = 0x80090359,
    SEC_E_KDC_CERT_EXPIRED = 0x8009035A,
    SEC_E_KDC_CERT_REVOKED = 0x8009035B,
    SEC_E_INVALID_PARAMETER = 0x8009035D,
    SEC_E_DELEGATION_POLICY = 0x8009035E,
    SEC_E_POLICY_NLTM_ONLY = 0x8009035F,
    SEC_E_NO_CONTEXT = 0x80090361,
    SEC_E_PKU2U_CERT_FAILURE = 0x80090362,
    SEC_E_MUTUAL_AUTH_FAILED = 0x80090363,
    SEC_E_ONLY_HTTPS_ALLOWED = 0x80090365,
    SEC_E_APPLICATION_PROTOCOL_MISMATCH = 0x80090367,
    SEC_E_INVALID_UPN_NAME = 0x80090369,
    SEC_E_EXT_BUFFER_TOO_SMALL = 0x8009036A,
    SEC_E_INSUFFICIENT_BUFFERS = 0x8009036B,
    SEC_E_NO_SPM = SEC_E_INTERNAL_ERROR,
    SEC_E_NOT_SUPPORTED = SEC_E_UNSUPPORTED_FUNCTION
}
enum : SECURITY_STATUS
{
    SEC_I_CONTINUE_NEEDED = 0x00090312,
    SEC_I_COMPLETE_NEEDED = 0x00090313,
    SEC_I_COMPLETE_AND_CONTINUE = 0x00090314,
    SEC_I_LOCAL_LOGON = 0x00090315,
    SEC_I_GENERIC_EXTENSION_RECEIVED = 0x00090316,
    SEC_I_CONTEXT_EXPIRED = 0x00090317,
    SEC_I_INCOMPLETE_CREDENTIALS = 0x00090320,
    SEC_I_RENEGOTIATE = 0x00090321,
    SEC_I_NO_LSA_CONTEXT = 0x00090323,
    SEC_I_SIGNATURE_NEEDED = 0x0009035C,
    SEC_I_NO_RENEGOTIATION = 0x00090360,
    SEC_I_MESSAGE_FRAGMENT = 0x00090364,
    SEC_I_CONTINUE_NEEDED_MESSAGE_OK = 0x00090366,
    SEC_I_ASYNC_CALL_PENDING = 0x00090368,
}

/* always a char */
alias char SEC_CHAR;
alias  wchar SEC_WCHAR;

alias  int SECURITY_STATUS;
