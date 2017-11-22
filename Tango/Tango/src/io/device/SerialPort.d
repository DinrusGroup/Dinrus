/*******************************************************************************

        copyright:      Copyright (c) 2008 Robin Kreis. все rights reserved

        license:        BSD стиль: $(LICENSE)

        author:         Robin Kreis

*******************************************************************************/

module io.device.SerialPort;

private import  core.Array : сортируй;

private import  exception,
                io.device.Device,
               stringz,
                sys.Common;

version(Windows) 
{
private import Целое = text.convert.Integer;
} 
else 
version(Posix) 
{
private import  io.FilePath,
                rt.core.stdc.posix.termios;
}

/*******************************************************************************

        Enables applications в_ use a serial порт (aka COM-порт, ttyS).
        Usage is similar в_ that of Файл:
        ---
        auto serCond = new СерийныйПорт("ttyS0");
        serCond.скорость = 38400;
        serCond.пиши("Hello world!");
        serCond.закрой();
        ----

*******************************************************************************/


class СерийныйПорт : Устройство
{
    private ткст              ткт;
    private static ткст[]     _ports;
	

	
    /***************************************************************************
    
            Create a new СерийныйПорт экземпляр. The порт will be opened and 
            установи в_ необр режим with 9600-8N1.
            
            Параметры:
            порт = A ткст опрentifying the порт. On Posix, this must be a 
                   устройство файл like /dev/ttyS0. If the ввод doesn't begin 
                   with "/", "/dev/" is automatically prepended, so "ttyS0" 
                   is sufficent. On Windows, this must be a устройство имя like 
                   COM1
            
    ***************************************************************************/

    this (ткст порт)
    {
        создай (порт);
    }
    
    /***************************************************************************
    
            Returns a ткст describing this serial порт.
            For example: "ttyS0", "COM1", "cuad0"
    
    ***************************************************************************/

    override ткст вТкст ()
    {
        return ткт;
    }

    /***************************************************************************

            Sets the baud rate of this порт. Usually, the baud rate can 
            only be установи в_ fixed values (common values are 1200 * 2^n).

            Note that for Posix, the specification only mandates speeds up
            в_ 38400, excluding speeds such as 7200, 14400 and 28800.
            Most Posix systems have chosen в_ support at least higher speeds
            though.

            See also: maxSpeed

            Throws: ВВИскл if скорость is unsupported.

    ***************************************************************************/

    СерийныйПорт скорость (бцел скорость)
    {
        version(Posix) {
            speed_t *baud = скорость in baudRates;
            if(baud is пусто) {
                throw new ВВИскл("Неверный бод-рейт.");
            }
            
            termios options;
            tcgetattr(укз, &options);
            cfsetospeed(&options, *baud);
            tcsetattr(укз, TCSANOW, &options);
        }
        version(Win32) {
            DCB конфиг;
            GetCommState(вв.указатель, &конфиг);
            конфиг.BaudRate = скорость;
            if(!SetCommState(cast(HANDLE) вв.указатель, &конфиг)) ошибка();
        }
        return this;
    }
    
    /***************************************************************************
    
            Tries в_ enumerate все serial порты. While this usually works on
            Windows, it's ещё problematic on другой OS. Posix provопрes no way 
            в_ список serial порты, and the only опция is searching through 
            "/dev".
            
            Because there's no naming стандарт for the устройство файлы, this метод
            must be ported for each OS. This метод is also unreliable because
            the пользователь could have создан не_годится устройство файлы, or deleted them.
            
            Возвращает:
            A ткст Массив of все the serial порты that could be найдено, in
            alphabetical order. Every ткст is formatted as a valid аргумент 
            в_ the constructor, but the порт may not be accessible.
    
    ***************************************************************************/

    static ткст[] порты ()
    {
        if(_ports !is пусто) {
            return _ports;
        }
        version(Windows) {
            // try opening COM1...COM255
            auto pre = `\\.\COM`;
            сим[11] p =void;
            сим[3] num =void;
            p[0..pre.length] = pre;
            for(цел i = 1; i <= 255; ++i) {
                ткст portNum = Целое.форматируй(num, i);
                p[pre.length..pre.length + portNum.length] = portNum;
                p[pre.length + portNum.length] = '\0';
                HANDLE порт = CreateFileA(p.ptr, GENERIC_READ | GENERIC_WRITE, 0, пусто, OPEN_EXISTING, 0, пусто);
                if(порт != INVALID_HANDLE_VALUE) {
                    _ports ~= p[`\\.\`.length..$].dup; // cut the leading \\.\
                    CloseHandle(порт);
                }
            }
        } else version(Posix) {
            auto dev = ФПуть("/dev");
            ФПуть[] serPorts = dev.вСписок((ФПуть путь, бул папка_ли) {
                if(папка_ли) return нет;
                version(linux) {
                    auto r = rest(путь.имя, "ttyUSB");
                    if(r is пусто) r = rest(путь.имя, "ttyS");
                    if(r.length == 0) return нет;
                    return isInRange(r, '0', '9');
                } else version (darwin) { // untested
                    auto r = rest(путь.имя, "cu");
                    if(r.length == 0) return нет;
                    return да;
                } else version(freebsd) { // untested
                    auto r = rest(путь.имя, "cuaa");
                    if(r is пусто) r = rest(путь.имя, "cuad");
                    if(r.length == 0) return нет;
                    return isInRange(r, '0', '9');
                } else version(openbsd) { // untested
                    auto r = rest(путь.имя, "tty");
                    if(r.length != 2) return нет;
                    return isInRange(r, '0', '9');
                } else version(solaris) { // untested
                    auto r = rest(путь.имя, "tty");
                    if(r.length != 1) return нет;
                    return isInRange(r, 'a', 'z');
                } else {
                    return нет;
                }
            });
            _ports.length = serPorts.length;
            foreach(i, путь; serPorts) {
                _ports[i] = путь.имя;
            }
        }
        сортируй(_ports);
        return _ports;
    }
    
    version(Win32) {
        private проц создай (ткст порт)
        {
            ткт = порт;
            вв.указатель = cast(Дескр) CreateFileA((`\\.\` ~ порт).вТкст0(), GENERIC_READ | GENERIC_WRITE, 0, пусто, OPEN_EXISTING, 0, пусто);
            if(вв.указатель is INVALID_HANDLE_VALUE) {
                ошибка();
            }
            DCB конфиг;
            GetCommState(cast(HANDLE) вв.указатель, &конфиг);
            конфиг.BaudRate = 9600;
            конфиг.ByteSize = 8;
            конфиг.Parity = NOPARITY;
            конфиг.StopBits = ONESTOPBIT;
            конфиг.flag0 |= bm_DCB_fBinary | bm_DCB_fParity;
            if(!SetCommState(cast(HANDLE) вв.указатель, &конфиг)) ошибка();
        }
    }
    
    version(Posix) {
        private static speed_t[бцел] baudRates;
        
        static this()
        {
            baudRates[50] = B50;
            baudRates[75] = B75;
            baudRates[110] = B110;
            baudRates[134] = B134;
            baudRates[150] = B150;
            baudRates[200] = B200;
            baudRates[300] = B300;
            baudRates[600] = B600;
            baudRates[1200] = B1200;
            baudRates[1800] = B1800;
            baudRates[2400] = B2400;
            baudRates[9600] = B9600;
            baudRates[4800] = B4800;
            baudRates[19200] = B19200;
            baudRates[38400] = B38400;

            version( linux ) 
            { 
                baudRates[57600] = B57600; 
                baudRates[115200] = B115200; 
                baudRates[230400] = B230400; 
                baudRates[460800] = B460800; 
                baudRates[500000] = B500000; 
                baudRates[576000] = B576000; 
                baudRates[921600] = B921600; 
                baudRates[1000000] = B1000000; 
                baudRates[1152000] = B1152000; 
                baudRates[1500000] = B1500000; 
                baudRates[2000000] = B2000000; 
                baudRates[2500000] = B2500000; 
                baudRates[3000000] = B3000000; 
                baudRates[3500000] = B3500000; 
                baudRates[4000000] = B4000000; 
            } 
            else version( freebsd ) 
            { 
                baudRates[7200] = B7200; 
                baudRates[14400] = B14400; 
                baudRates[28800] = B28800; 
                baudRates[57600] = B57600; 
                baudRates[76800] = B76800; 
                baudRates[115200] = B115200; 
                baudRates[230400] = B230400; 
                baudRates[460800] = B460800; 
                baudRates[921600] = B921600; 
            } 
            else version( solaris ) 
            { 
                baudRates[57600] = B57600; 
                baudRates[76800] = B76800; 
                baudRates[115200] = B115200; 
                baudRates[153600] = B153600; 
                baudRates[230400] = B230400; 
                baudRates[307200] = B307200; 
                baudRates[460800] = B460800; 
            }
            else version ( darwin )
            {
                baudRates[7200] = B7200;
                baudRates[14400] = B14400; 
                baudRates[28800] = B28800; 
                baudRates[57600] = B57600; 
                baudRates[76800] = B76800; 
                baudRates[115200] = B115200; 
                baudRates[230400] = B230400; 
            }
        }
        
        private проц создай (ткст файл)
        {
            if(файл.length == 0) throw new ВВИскл("Название порта пусто");
            if(файл[0] != '/') файл = "/dev/" ~ файл;
            
            if(файл.length > 5 && файл[0..5] == "/dev/")
                ткт = файл[5..$];
            else
                ткт = "SerialPort@" ~ файл;
            
            укз = posix.открой(файл.вТкст0(), O_RDWR | O_NOCTTY | O_NONBLOCK);
            if(укз == -1) {
                ошибка();
            }
            if(posix.fcntl(укз, F_SETFL, 0) == -1) { // disable O_NONBLOCK
                ошибка();
            }
            
            termios options;
            if(tcgetattr(укз, &options) == -1) {
                ошибка();
            }
            cfsetispeed(&options, B0); // same as вывод baud rate
            cfsetospeed(&options, B9600);
            makeНеобр(&options); // disable echo and special characters
            tcsetattr(укз, TCSANOW, &options);
        }
        
        private проц makeНеобр (termios *options)
        {
            options.c_iflag &= ~(IGNBRK | BRKINT | PARMRK | ISTRИП
                    | INLCR | IGNCR | ICRNL | IXON);
            options.c_oflag &= ~OPOST;
            options.c_lflag &= ~(ECHO | ECHONL | ICANON | ISIG | IEXTEN);
            options.c_cflag &= ~(CSIZE | PARENB);
            options.c_cflag |= CS8;
        }


        private static ткст rest (ткст ткт, ткст префикс) {
            if(ткт.length < префикс.length) return пусто;
            if(ткт[0..префикс.length] != префикс) return пусто;
            return ткт[префикс.length..$];
        }
    
        private static бул isInRange (ткст ткт, сим lower, сим upper) {
            foreach(c; ткт) {
                if(c < lower || c > upper) return нет;
            }
            return да;
        }
    }    
}

