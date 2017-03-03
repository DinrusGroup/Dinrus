// Bugzilla 11309 - std.concurrency: OwnerTerminated message doesn't work
// We need to assure that the thread dtors of parent threads run before the thread dtors of the child threads.
import thread, sync;

Семафор sem;

static ~this()
{
    if (sem !is null) sem.уведоми();
}

void main()
{
    sem = new Семафор;
    auto thr = new Нить({assert(sem.жди(1000));});
    thr.старт();
}
