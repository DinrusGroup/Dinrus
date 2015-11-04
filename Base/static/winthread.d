module winthread;
import dinrus, time.Time;

alias HANDLE Handle;
extern(Windows)
{

struct SECURITY_ATTRIBUTES {
  uint nLength;
  void* lpSecurityDescriptor;
  int bInheritHandle;
}

const uint INFINITE = 0xFFFFFFFF;

enum : uint {
  WAIT_OBJECT_0 = 0,
  WAIT_ABANDONED = 0x80,
  WAIT_ABANDONED_0 = 0x80,
  WAIT_TIMEOUT = 258,
  SYNCHRONIZE                     = 0x00100000,
  ERROR_ACCESS_DENIED           = 5,
}

uint GetLastError();

uint WaitForSingleObject(Handle hHandle, uint dwMilliseconds);

uint WaitForSingleObjectEx(Handle hHandle, uint dwMilliseconds, BOOL bAlertable);

uint WaitForMultipleObjects(uint nCount, in Handle* lpHandles, BOOL bWaitAll, uint dwMilliseconds);

uint WaitForMultipleObjectsEx(uint nCount, in Handle* lpHandles, BOOL bWaitAll, uint dwMilliseconds, BOOL bAlertable);

uint SignalObjectAndWait(Handle hObjectToSignal, Handle hObjectToWaitOn, uint dwMilliseconds, BOOL bAlertable);

void Sleep(uint dwMilliseconds);

uint SleepEx(uint dwMilliseconds, int bAlertable);

uint TlsAlloc();

int TlsFree(uint dwTlsIndex);

void* TlsGetValue(uint dwTlsIndex);

int TlsSetValue(uint dwTlsIndex, void* lpTlsValue);

Handle CreateEventW(SECURITY_ATTRIBUTES* lpEventAttributes, int bManualReset, int bInitialState, in wchar* lpName);
alias CreateEventW CreateEvent;

int SetEvent(Handle hEvent);

int ResetEvent(Handle hEvent);

Handle CreateMutexW(SECURITY_ATTRIBUTES* lpMutexAttributes, int bInitialOwner, in wchar* lpName);
alias CreateMutexW CreateMutex;

enum : uint {
  MUTEX_MODIFY_STATE = 0x0001
}
Handle OpenMutexW(uint dwDesiredAccess, int bInheritHandle, in wchar* lpName);
alias OpenMutexW OpenMutex;

int ReleaseMutex(Handle hMutex);

Handle CreateSemaphoreW(SECURITY_ATTRIBUTES* lpSemaphoreAttributes, int lInitialCount, int lMaximumCount, in wchar* lpName);
alias CreateSemaphoreW CreateSemaphore;

int ReleaseSemaphore(Handle hSemaphore, int lReleaseCount, out int lpPreviousCount);

int CloseHandle(Handle hObject);
}

class ВинНитьЛок(Т) {


  private struct ДанныеНлх {
    Т значение;
  }

  private бцел слот_;
  private Т дефЗначение_;

  /**
   * Initializes a new instance.
   */
  this(lazy Т дефЗначение = Т.init) {
    дефЗначение_ = cast(Т)дефЗначение();
    слот_ = TlsAlloc();
  }

  ~this() {
    if (auto данныеНлх = cast(ДанныеНлх*)TlsGetValue(слот_))
      удалиКорень(данныеНлх);

    TlsFree(слот_);
    слот_ = cast(бцел)-1;
  }

  /**
   * Gets the значение in the current thread's copy of this instance.
   * Возвращает: The current thread's copy of this instance.
   */
  final Т дай() {
    if (auto данныеНлх = cast(ДанныеНлх*)TlsGetValue(слот_))
      return данныеНлх.значение;
    return дефЗначение_;
  }

  /**
   * Sets the current thread's copy of this instance to the specified _value.
   * Параметры: значение = The _value to be stored in the current thread's copy of this instance.
   */
  final проц установи(Т значение) {
    auto данныеНлх = cast(ДанныеНлх*)TlsGetValue(слот_);
    if (данныеНлх is null) {
      данныеНлх = new ДанныеНлх;
      добавьКорень(данныеНлх);

      TlsSetValue(слот_, данныеНлх);
    }
    данныеНлх.значение = значение;
  }

}


/**
 * Suspends the current thread for a specified time.
 * Параметры: миллисек = The number of _milliseconds for which the thread is blocked. Specify -1 to block the thread indefinitely.
 */
проц спи(бцел миллисек) {
  .Sleep(миллисек);
}

/**
 * Suspends the current thread for a specified time.
 * Параметры: таймаут = The amount of time for which the thread is blocked. Specify -1 to block the thread indefinitely.
 */
проц спи(ИнтервалВремени таймаут) {
  .Sleep(cast(бцел)таймаут.всегоМиллисек);
}

enum ПРежимСбросаСобытия {
  Авто,
  Ручной
}

abstract class УкОжидание {

  private Дескр дескр_ = cast(Дескр)НЕВЕРНХЭНДЛ;

  проц закрой() {
    if (дескр_ != Дескр.init) {
      CloseHandle(дескр_);
      дескр_ = Дескр.init;
    }
  }

  бул ждиОдин(бцел таймаутВМиллисек = INFINITE) {
    бцел r = WaitForSingleObjectEx(дескр_, таймаутВМиллисек, cast(BOOL)1);
    return (r != WAIT_ABANDONED && r != WAIT_TIMEOUT);
  }

  бул ждиОдин(ИнтервалВремени таймаут) {
    return ждиОдин(cast(бцел)таймаут.всегоМиллисек);
  }

  static бул ждиВсе(УкОжидание[] ждиуки, бцел таймаутВМиллисек = INFINITE) {
    Дескр[] handles = new Дескр[ждиуки.length];
    foreach (i, waitHandle; ждиуки) {
      handles[i] = waitHandle.дескр_;
    }

    бцел r = WaitForMultipleObjectsEx(handles.length, handles.ptr, cast(BOOL)1, таймаутВМиллисек, cast(BOOL)1);
    return (r != WAIT_ABANDONED && r != WAIT_TIMEOUT);
  }

  static бцел ждиЛюбой(УкОжидание[] ждиуки, бцел таймаутВМиллисек = INFINITE) {
    Дескр[] handles = new Дескр[ждиуки.length];
    foreach (i, waitHandle; ждиуки) {
      handles[i] = waitHandle.дескр_;
    }

    return WaitForMultipleObjectsEx(handles.length, handles.ptr, 0, таймаутВМиллисек, 1);
  }

  static бул сигнализируйИЖди(УкОжидание toSignal, УкОжидание toWaitOn, бцел таймаутВМиллисек = INFINITE) {
    бцел r = SignalObjectAndWait(toSignal.дескр_, toWaitOn.дескр_, таймаутВМиллисек, 1);
    return (r != WAIT_ABANDONED && r != WAIT_TIMEOUT);
  }

  static бул сигнализируйИЖди(УкОжидание toSignal, УкОжидание toWaitOn, ИнтервалВремени таймаут) {
    return сигнализируйИЖди(toSignal, toWaitOn, cast(бцел)таймаут.всегоМиллисек);
  }

  проц дескр(Дескр значение) {
    if (значение == Дескр.init)
      дескр_ = НЕВЕРНХЭНДЛ;
    else
      дескр_ = дескр;
  }
  Дескр дескр() {
    if (дескр_ == Дескр.init)
      return НЕВЕРНХЭНДЛ;
    return дескр_;
  }

}

class ДескрОжиданияСобытия : УкОжидание {

  this(бул начСостояние, ПРежимСбросаСобытия режим) {
    дескр_ = CreateEvent(null, (режим == ПРежимСбросаСобытия.Ручной) ? 1 : 0, начСостояние ? 1 : 0, null);
  }

  final бул установи() {
    return SetEvent(дескр_) != 0;
  }

  final бул сбрось() {
    return ResetEvent(дескр_) != 0;
  }

}

final class СобытиеАвтоСброса : ДескрОжиданияСобытия {

  this(бул начСостояние) {
    super(начСостояние, ПРежимСбросаСобытия.Авто);
  }

}

final class СобытиеРучногоСброса : ДескрОжиданияСобытия {

  this(бул начСостояние) {
    super(начСостояние, ПРежимСбросаСобытия.Ручной);
  }

}

final class ВинМютекс : УкОжидание {

  this(бул initiallyOwned = false, ткст имя = null) {
    Дескр hMutex = CreateMutex(null, (initiallyOwned ? 1 : 0), имя.вЮ16н());
    бцел error = GetLastError();

    if (error == ERROR_ACCESS_DENIED && (hMutex == Дескр.init || hMutex == НЕВЕРНХЭНДЛ))
      hMutex = OpenMutex(MUTEX_MODIFY_STATE | SYNCHRONIZE, 0, имя.вЮ16н());

    дескр_ = hMutex;
  }

  проц отпусти() {
    ReleaseMutex(дескр_);
  }

}

final class ВинСемафор : УкОжидание {

  this(цел начСчёт, цел максСчёт, ткст имя = пусто) {
    дескр_ = CreateSemaphore(null, начСчёт, максСчёт, имя.вЮ16н());
  }

  цел отпусти(цел релизСчёт = 1) {
    цел prevCount;
    if (!ReleaseSemaphore(дескр_, релизСчёт, prevCount))
      throw new Искл("Прибавление данного счёта к семафору приведёт к превышению максимального счёта.");
    return prevCount;
  }

}

