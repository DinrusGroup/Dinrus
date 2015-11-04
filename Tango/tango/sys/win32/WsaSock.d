module sys.win32.WsaSock;
//pragma(lib,"drTango");
public import sys.Common;
struct Guid
{
        бцел     g1;
        бкрат   g2,
                 g3;
        ббайт[8] g4;
}

enum 
{
        ДЛИНА_ВСАОПИСАНИЯ = 256,
        ДЛИНА_ВСАСИС_СТАТУСА = 128,
        WSAEWOULDBLOCK =  10035,
        WSAEINTR =        10004,
}

struct WSABUF
{
        бцел    длин;
        ук    буф;
}

struct ВИНСОКДАН
{
        WORD версия;
        WORD хВерсия;
        сим описание[ДЛИНА_ВСАОПИСАНИЯ+1];
        сим сисСтатус[ДЛИНА_ВСАСИС_СТАТУСА+1];
        бкрат макЧлоСок;
        бкрат максДгПпд;
        сим* инфОПроизв;
}

enum 
{
        SIO_GET_EXTENSION_FUNCTION_POINTER = 0x40000000 | 0x80000000 | 0x08000000 | 6,
        SO_UPDATE_CONNECT_CONTEXT = 0x7010,
        SO_UPDATE_ACCEPT_CONTEXT = 0x700B
}

extern (Windows)
{
        цел WSACleanup();
        цел ВСАДайПоследнююОшибку ();
        цел WSAStartup(WORD wVersionRequested, ВИНСОКДАН* lpWSAData);
        цел WSAGetOverlappedResult (HANDLE, OVERLAPPED*, DWORD*, BOOL, DWORD*);
        цел WSAIoctl (HANDLE s, DWORD op, LPVOID inBuf, DWORD cbIn, LPVOID outBuf, DWORD cbOut, DWORD* результат, LPOVERLAPPED, проц*);
        цел WSARecv (HANDLE, WSABUF*, DWORD, DWORD*, DWORD*, OVERLAPPED*, проц*);
        цел WSASend (HANDLE, WSABUF*, DWORD, DWORD*, DWORD, OVERLAPPED*, проц*);
}

