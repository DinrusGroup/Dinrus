module winMain;
pragma(lib,"DinrusTango.lib");
import sys.win32.UserGdi;
import sys.WinStructs: КЛАССОКДОП;

extern(C)	бул ртСтарт(ПередВходом передвхо = пусто, ОбработчикИсключения дг = пусто);
extern(C)	бул ртСтоп(ПередВыходом передвых = пусто, ОбработчикИсключения дг = пусто );
extern(Windows) LRESULT function(HWND, UINT, WPARAM, LPARAM) WindowProcedure;

extern (Windows)
цел WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, цел nCmdShow)
{
    цел рез;

    проц обрИскл(Исключение e)
    {
        throw e;
    }

    try
    {
				
       ртСтарт(пусто, &обрИскл);

        рез = myWinMain(hInstance, hPrevInstance, lpCmdLine, nCmdShow);

        ртСтоп(пусто, &обрИскл);
    }
    catch (Объект o)		// catch any uncaught exceptions
    {
       // MessageBoxA(null, вТкст0(o.вТкст()), "Ошибка", MB_OK | MB_ICONEXCLAMATION);
        рез = 0;		// failed
    }

    return рез;
}

сим* szClassName = "WindowsApp";

цел myWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, цел nCmdShow)
{
    /* ... insert user code here ... */
   

    HWND hwnd;               /* This is the handle for our window */
    MSG messages;            /* Here messages to the application are saved */
    КЛАССОКДОП клОк;  


    /* The Window structure */
    клОк.экземпляр = hInstance;
    клОк.имяКласса = szClassName;
    клОк.оконПроц = &myWindowProcedure;      /* This function is called by windows */
    клОк.стиль = CS_DBLCLKS;                 /* Catch double-clicks */
    клОк.размер = КЛАССОКДОП.sizeof;

    /* Use default icon and mouse-pointer */
    клОк.пиктограмма = LoadIconA (NULL, IDI_APPLICATION);
    клОк.пиктограммаМал = LoadIconA (NULL, IDI_APPLICATION);
    клОк.курсор = LoadCursorA (NULL, IDC_ARROW);
    клОк.имяМеню = NULL;                 /* No menu */
    клОк.упрэлтыЭкстра = 0;                      /* No extra bytes after the window class */
    клОк.окнаЭкстра = 0;                      /* structure or the window instance */
    /* Use Windows's default color as the background of the window */
    клОк.фон = cast(HBRUSH) COLOR_BACKGROUND;

    /* Register the window class, and if it fails quit the program */
    if (!RegisterClassExW (cast(WNDCLASSEX*) &клОк))
        return 0;

    /* The class is registered, let's create the program*/
    hwnd = CreateWindowExW (
           0,                   /* Extended possibilites for variation */
           cast(шим*) szClassName,         /* Classname */
           cast(шим*) "Приложение Windows",       /* Title Text */
           WS_OVERLAPPEDWINDOW, /* default window */
           CW_USEDEFAULT,       /* Windows decides the position */
           CW_USEDEFAULT,       /* where the window ends up on the screen */
           544,                 /* The programs width */
           375,                 /* and height in pixels */
           HWND_DESKTOP,        /* The window is a child-window to desktop */
           NULL,                /* No menu */
           hInstance,       /* Program Instance handler */
           NULL                 /* No Window Creation data */
           );

    /* Make the window visible on the screen */
    ShowWindow (hwnd, nCmdShow);

    /* Run the message loop. It will run until GetMessage() returns 0 */
    while (GetMessageW (&messages, NULL, 0, 0))
    {
        /* Translate virtual-key messages into character messages */
        TranslateMessage(&messages);
        /* Send message to WindowProcedure */
        DispatchMessageW(&messages);
    }

    /* The program return-value is 0 - The value that PostQuitMessage() gave */
    return messages.wParam;
}

/*  This function is called by the Windows function DispatchMessage()  */

extern(Windows) LRESULT myWindowProcedure (HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam)
{
    switch (message)                  /* handle the messages */
    {
        case WM_DESTROY:
            PostQuitMessage (0);       /* send a WM_QUIT to the message queue */
            break;
        default:                      /* for messages that we don't deal with */
            return DefWindowProcW (hwnd, message, wParam, lParam);
    }

    return 0;
}
