﻿module sys.win32.consts.errno;

    const EPERM             = 1;        // Operation not permitted
    const ENOENT            = 2;        // No such файл or дир
    const ESRCH             = 3;        // No such process
    const EINTR             = 4;        // Interrupted system вызов
    const EIO               = 5;        // I/O ошибка
    const ENXIO             = 6;        // No such устройство or адрес
    const E2BIG             = 7;        // Аргумент список too дол
    const ENOEXEC           = 8;        // Exec форматируй ошибка
    const EBADF             = 9;        // Bad файл число
    const ECHILD            = 10;       // No ветвь processes
    const EAGAIN            = 11;       // Try again
    const ENOMEM            = 12;       // Out of память
    const EACCES            = 13;       // Permission denied
    const EFAULT            = 14;       // Bad адрес
    const EBUSY             = 16;       // Устройство or resource busy
    const EEXIST            = 17;       // Файл есть_ли
    const EXDEV             = 18;       // Cross-устройство link
    const ENODEV            = 19;       // No such устройство
    const ENOTDIR           = 20;       // Not a дир
    const EISDIR            = 21;       // Is a дир
    const EINVAL            = 22;       // Неверный аргумент
    const ENFILE            = 23;       // Файл table перебор
    const EMFILE            = 24;       // Too many открой файлы
    const ENOTTY            = 25;       // Not a typewriter
    const EFBIG             = 27;       // Файл too large
    const ENOSPC            = 28;       // No пространство left on устройство
    const ESPИПE            = 29;       // Illegal сместись
    const EROFS             = 30;       // Чтен-only файл system
    const EMLINK            = 31;       // Too many линки
    const EPИПE             = 32;       // Broken pipe
    const EDOM              = 33;       // Math аргумент out of домен of func
    const ERANGE            = 34;       // Math результат not representable
    const EDEADLK           = 36;       // Resource deadlock would occur
    const ENAMETOOLONG      = 38;       // Файл имя too дол
    const ENOLCK            = 39;       // No record locks available
    const ENOSYS            = 40;       // Function не реализован
    const ENOTEMPTY         = 41;       // Directory not пустой
    const EILSEQ            = 42;       // Illegal байт sequence
    const EDEADLOCK         = EDEADLK;
