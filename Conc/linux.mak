#DFLAGS=-O -release 
DFLAGS=-unittest -g 

CC=gcc
#DMD=/dmd/bin/dmd
DMD=dmd

OBJS = sync.o semaphore.o fairsemaphore.o mutex.o waitnotify.o \
	queuedsemaphore.o fifosemaphore.o \
	reentrantlock.o latch.o barrier.o rendezvous.o \
	countdown.o cyclicbarrier.o \
	boundedchannel.o \
	boundedlinkedqueue.o \
	channel.o \
	synchronouschannel.o \
	defaultchannelcapacity.o \
	directexecutor.o \
	executor.o \
	linkednode.o \
	linkedqueue.o \
	lockedexecutor.o \
	pooledexecutor.o \
	puttable.o \
	queuedexecutor.o \
	synchronizedint.o \
	synchronizedvariable.o \
	takable.o \
	threadedexecutor.o \
	threadfactory.o \
	threadfactoryuser.o \
	readwritelock.o \
	readwritelockutils.o


targets : libconcurrent.a

unittest : concurrent/unittest.d libconcurrent.a
	$(DMD) concurrent/unittest.d -g $(OBJS) -unittest

libconcurrent.a : $(OBJS)
	ar -r $@ $(OBJS)

clean:
	rm -rf $(OBJS) unittest unittest.o

# Synchronization files
sync.o : concurrent/sync.d
	$(DMD) -c $(DFLAGS) $<
semaphore.o : concurrent/semaphore.d
	$(DMD) -c $(DFLAGS) $<
fairsemaphore.o : concurrent/fairsemaphore.d
	$(DMD) -c $(DFLAGS) $<
queuedsemaphore.o : concurrent/queuedsemaphore.d
	$(DMD) -c $(DFLAGS) $<
fifosemaphore.o : concurrent/fifosemaphore.d
	$(DMD) -c $(DFLAGS) $<
mutex.o : concurrent/mutex.d
	$(DMD) -c $(DFLAGS) $<
waitnotify.o : concurrent/waitnotify.d
	$(DMD) -c $(DFLAGS) $<
reentrantlock.o : concurrent/reentrantlock.d
	$(DMD) -c $(DFLAGS) $<
latch.o : concurrent/latch.d
	$(DMD) -c $(DFLAGS) $<
countdown.o : concurrent/countdown.d
	$(DMD) -c $(DFLAGS) $<

# Barriers
barrier.o : concurrent/barrier.d
	$(DMD) -c $(DFLAGS) $<
cyclicbarrier.o : concurrent/cyclicbarrier.d
	$(DMD) -c $(DFLAGS) $<
rendezvous.o : concurrent/rendezvous.d
	$(DMD) -c $(DFLAGS) $<
readwritelock.o : concurrent/readwritelock.d
	$(DMD) -c $(DFLAGS) $<
readwritelockutils.o : concurrent/readwritelockutils.d
	$(DMD) -c $(DFLAGS) $<

# Channels
boundedchannel.o : concurrent/boundedchannel.d
	$(DMD) -c $(DFLAGS) $<
boundedlinkedqueue.o : concurrent/boundedlinkedqueue.d
	$(DMD) -c $(DFLAGS) $<
channel.o : concurrent/channel.d
	$(DMD) -c $(DFLAGS) $<
defaultchannelcapacity.o : concurrent/defaultchannelcapacity.d
	$(DMD) -c $(DFLAGS) $<
linkedqueue.o : concurrent/linkedqueue.d
	$(DMD) -c $(DFLAGS) $<
linkednode.o : concurrent/linkednode.d
	$(DMD) -c $(DFLAGS) $<
puttable.o : concurrent/puttable.d
	$(DMD) -c $(DFLAGS) $<
takable.o : concurrent/takable.d
	$(DMD) -c $(DFLAGS) $<
synchronouschannel.o : concurrent/synchronouschannel.d
	$(DMD) -c $(DFLAGS) $<

# Executors
directexecutor.o : concurrent/directexecutor.d
	$(DMD) -c $(DFLAGS) $<
executor.o : concurrent/executor.d
	$(DMD) -c $(DFLAGS) $<
lockedexecutor.o : concurrent/lockedexecutor.d
	$(DMD) -c $(DFLAGS) $<
queuedexecutor.o : concurrent/queuedexecutor.d
	$(DMD) -c $(DFLAGS) $<
threadedexecutor.o : concurrent/threadedexecutor.d
	$(DMD) -c $(DFLAGS) $<
threadfactory.o : concurrent/threadfactory.d
	$(DMD) -c $(DFLAGS) $<
threadfactoryuser.o : concurrent/threadfactoryuser.d
	$(DMD) -c $(DFLAGS) $<
pooledexecutor.o : concurrent/pooledexecutor.d
	$(DMD) -c $(DFLAGS) $<

# Synchronized variables 
synchronizedint.o : concurrent/synchronizedint.d
	$(DMD) -c $(DFLAGS) $<
synchronizedvariable.o : concurrent/synchronizedvariable.d
	$(DMD) -c $(DFLAGS) $<
