/**
 * Этот модуль предоставляет реализацию классической модели нить-обоймы (катушки).
 *
 * Copyright: Copyright (C) 2007-2008 Anders Halager. Все права защищены.
 * License:   BSD стиль: $(LICENSE)
 * Author:    Anders Halager
 */

module core.ThreadPool;

private import thread, sync;

private import  cidrus: memmove;

private version = Queued;


/**
 * Катушка - это способ обработки нескольких задач (jobs) параллельно, без создания
 * на каждую задачу новой нити. Таким образом, создание нити происходит только раз,
 * но не один раз на каждое "дело" и можно ограничить максимальное
 * число активных нитей в любой момент.
 *
 * В этом случае "дело" - просто делегат и некоторые параметры, с которыми этот делегат
 * будет вызываться,  после того как он добавлен в очередь обойм нитей.
 *
 * Пример:
 * --------------------
 * // создать новую обойму с двумя нитями
 * auto обойма = new Катушка!(цел)(2);
 * проц delegate(цел) f = (цел x) { Журнал(x); };
 *
 * // Сейчас есть три способа сообщить обойме о выполнении наших задач.
 * // Во-первых, можно сообщить, что задача должна быть готова в точку чуть позднее
 * обойма.добавь(f, 1);
 * // Во-вторых, сообщить, чтобы задача была готова как можно скорее, блокирую
 * // пока она не пущена какой-то нитью
 * обойма.присвой(f, 2);
 * // Наконец, сообщить, что она должно быть немедленно сделана или не сделана вообще
 * if (обойма.пробуйПрисвоить(f, 3))
 *     Журнал("Кто-то взялся за дело!");
 * else
 *     Журнал("Никто не смог выполнить работу прямо сейчас");
 * // После задания обойме работёнок, надо дать ей шанс завершить,
 * // поэтому можно сделать что-то из двух вещей.
 * // Выбор номер 1 - завершить всё, что уже задано нитям,
 * // но игнорировать любые оставшиеся в очереди задачи
 * //   обойма.глуши();
 * // Другой выбор - завершить все выполняемые работы или находящиеся в очереди:
 * обойма.финиш();
 * --------------------
 *
 * Если добавь не вызывается, то дополнительного размещения в куче не будет
 * после её инициализации.
 */

class Катушка(Арги...)
{

private
{
    // Наш список нитей -- используется только при стартапе и глуши
    Нить[] обойма;
	
    struct Дело
    {
        ДДела дг;
        Арги арги;
    }
    // Used for storing queued jobs that will be executed eventually
    Дело[] q;

    // This is в_ сохрани a single дело for immediate execution, which hopefully
    // means that any program using only присвой and пробуйПрисвоить wont need any
    // куча allocations after startup.
    Дело* приоритетное_дело;

    // This should be used when accessing the дело queue
    Стопор m;

    // Notify is called on this condition whenever we have activity in the обойма
    // that the трудяги might want в_ know about.
    Условие активностьПула;

    // Worker threads вызов сообщи on this when they are готово with a дело or are
    // completely готово.
    // This allows a graceful shut down and is necessary since присвой есть в_
    // жди for a дело в_ become available
    Условие активностьТрудяги;

    // Are we in the глуши phase?
    бул готово;

    // Counter for the число of jobs currently being calculated
    т_мера активные_дела;

    // Нить delegate:
    проц делДело()
    {
        while (!флагДай(готово))
        {
            m.блокируй();
            while (q.length == 0 && флагДай(приоритетное_дело) is пусто && !флагДай(готово))
                активностьПула.жди();
            if (флагДай(готово)) {
                m.разблокируй(); // not using scope(exit), need в_ manually разблокируй
                break;
            }
            Дело дело;
            Дело *делУк = флагДай(приоритетное_дело);
            if (делУк !is пусто)
            {
                дело = *делУк;
                флагУст(приоритетное_дело, cast(Дело*)пусто);
                активностьТрудяги.уведоми();
            }
            else
            {
                version (Queued) // #1896
                        {
                        дело = q[0];
                        memmove(q.ptr, q.ptr + 1, (q.length - 1) * typeof(*q).sizeof);
                        q.length = q.length - 1;
                        }
                     else
                        {
                        // A stack -- should be a queue
                        дело = q[$ - 1];
                        q.length = q.length - 1;
                        }
            }

            // Make sure we разблокируй before we старт doing the calculations
            m.разблокируй();

            // Do the actual дело
            флагДоб!(т_мера)(активные_дела, 1);
            try {
                дело.дг(дело.арги);
            } catch (Исключение ex) { }
            флагДоб!(т_мера)(активные_дела, -1);

            // Tell the обойма that we are готово with something
            m.блокируй();
            активностьТрудяги.уведоми();
            m.разблокируй();
        }
        // Tell the обойма that we are сейчас готово
        m.блокируй();
        активностьТрудяги.уведоми();
        m.разблокируй();
    }
}

    /// An alias for the тип of delegates this нить обойма consопрers a дело
    alias проц delegate(Арги) ДДела;

    /**
     * Create a new Катушка.
     *
     * Параметры:
     *   трудяги = The amount of threads в_ spawn
     *   q_size  = The ожидалось размер of the queue (как many elements are
     *   preallocated)
     */
    this(т_мера трудяги, т_мера q_size = 0)
    {
        // pre-размести память for q_size jobs in the queue
        q.length = q_size;
        q.length = 0;

        m = new Стопор;
        активностьПула = new Условие(m);
        активностьТрудяги = new Условие(m);

        флагУст(приоритетное_дело, cast(Дело*) пусто);
        флагУст(активные_дела, cast(т_мера) 0);
        флагУст(готово, нет);

        for (т_мера i = 0; i < трудяги; i++)
        {
            auto нить = new Нить(&делДело);
            // Разрешить the OS в_ затуши the threads if we exit the program without
            // handling them our selves
            нить.демон_ли = да;
            нить.старт();
            обойма ~= нить;
        }
    }

    /**
      Assign the given дело в_ a нить immediately or block until one is
      available
     */
    проц присвой(ДДела дело, Арги арги)
    {
        if(this.обойма.length == 0)
        {
            throw new Исключение("Нет доступных рабочих потоков!");
        }

        m.блокируй();
        scope(exit) m.разблокируй();
        auto j = Дело(дело, арги);
        флагУст(приоритетное_дело, &j);
        активностьПула.уведоми();
        // Wait until someone есть taken the дело
        while (флагДай(приоритетное_дело) !is пусто)
            активностьТрудяги.жди();
    }

    /**
      Assign the given дело в_ a нить immediately or return нет if Неук is
      available. (Returns да if one was available)
     */
    бул пробуйПрисвоить(ДДела дело, Арги арги)
    {
        if (флагДай(активные_дела) >= обойма.length)
            return нет;
        присвой(дело, арги);
        return да;
    }

    /**
      Put a дело преобр_в the обойма for eventual execution.

      Предупреждение: Acts as a stack, not a queue as you would expect
     */
    проц добавь(ДДела дело, Арги арги)
    {
        if(this.обойма.length == 0)
        {
            throw new Исключение("Нет доступных рабочих потоков!");        
        }

        m.блокируй();
        q ~= Дело(дело, арги);
        m.разблокируй();
        активностьПула.уведоми();
    }

    /// Get the число of jobs waiting в_ be executed
    т_мера ждущиеДела()
    {
        m.блокируй(); scope(exit) m.разблокируй();
        return q.length;
    }

    /// Get the число of jobs being executed
    т_мера активныеДела()
    {
        return флагДай(активные_дела);
    }

    /// Block until все pending jobs complete, but do not shut down.  This allows ещё tasks в_ be добавьed later.
    проц жди()
    {    
        m.блокируй();
        while (q.length > 0 || флагДай(активные_дела) > 0)
               активностьТрудяги.жди();
        m.разблокируй();
    } 

    /// Finish currently executing jobs and drop все pending.
    проц глуши()
    {
        флагУст(готово, да);
        m.блокируй();
        q.length = 0;
        m.разблокируй();
        активностьПула.уведомиВсе();
        foreach (нить; обойма)
            нить.присоедини();

        обойма.length = 0;

        m.блокируй();
        m.разблокируй();
    }

    /// Complete все pending jobs and глуши.
    проц финиш()
    {
        жди();
        глуши();
    }
}



/*******************************************************************************

        Invoke as "threadpool 1 2 3 4 5 6 7 10 20" or similar

*******************************************************************************/

debug (Pool)
{
        import util.log.Trace;
        import Целое = text.convert.Integer;

        проц main(ткст[] арги)
        {
                дол дело(дол знач)
                {
                        // a 'big дело'
                        Нить.спи (3.0/знач);
                        return знач;
                }

                проц hashJob(ткст файл)
                {
                        // If we don't catch exceptions the нить-обойма will still
                        // work, but the дело will краш silently
                        try {
                            дол n = Целое.разбор(файл);
                            След.форматнс("дело({}) = {}", n, дело(n));
                            } catch (Исключение ex) {
                                    След.форматнс("Исключение: {}", ex.сооб);
                                    }
                }

                // Create new нить обойма with one трудяга нить per файл given
                auto катушка = new Катушка!(ткст)(арги.length - 1);

                Нить.спи(1);
                След.форматнс ("starting");

                foreach (файл; арги[1 .. арги.length])
                         катушка.присвой(&hashJob, файл);

                катушка.финиш();
        }
}
