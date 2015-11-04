#DFLAGS=-O -release
DFLAGS= -g


DMD=$(DINRUS)\dmd.exe
LIB=$(DINRUS)\lib.exe
this=$(DINRUS)\..\dev\Dinrus\Conc

OBJS = all.obj sync.obj semaphore.obj fairsemaphore.obj mutex.obj waitnotify.obj \
	queuedsemaphore.obj fifosemaphore.obj \
	reentrantlock.obj latch.obj barrier.obj rendezvous.obj \
	countdown.obj cyclicbarrier.obj \
	boundedchannel.obj \
	boundedlinkedqueue.obj \
	channel.obj \
	defaultchannelcapacity.obj \
	directexecutor.obj \
	queuedexecutor.obj \
	executor.obj \
	linkednode.obj \
	linkedqueue.obj \
	lockedexecutor.obj \
	pooledexecutor.obj \
	puttable.obj \
	synchronizedint.obj \
	synchronizedvariable.obj \
	synchronouschannel.obj \
	takable.obj \
	threadedexecutor.obj \
	threadfactory.obj \
	threadfactoryuser.obj \
	readwritelock.obj \
	readwritelockutils.obj

targets : DinrusConc.lib

DinrusConc.lib : $(OBJS)
	$(LIB) -c -p256 DinrusConc.lib $(OBJS)

clean:
	del $(OBJS)

all.obj : $(this)\conc\all.d
	$(DMD) -c $(DFLAGS) $(this)\conc\$<d
# Basic wait/notify and wait/notifyAll

waitnotify.obj : $(this)\conc\waitnotify.d
	$(DMD) -c $(DFLAGS) $(this)\conc\$<d

# Sync and Barrier
sync.obj : $(this)\conc\sync.d
	$(DMD) -c $(DFLAGS) $(this)\conc\$<d
semaphore.obj : $(this)\conc\semaphore.d
	$(DMD) -c $(DFLAGS) $(this)\conc\$<d
fairsemaphore.obj : $(this)\conc\fairsemaphore.d
	$(DMD) -c $(DFLAGS) $(this)\conc\$<d
queuedsemaphore.obj : $(this)\conc\queuedsemaphore.d
	$(DMD) -c $(DFLAGS) $(this)\conc\$<d
fifosemaphore.obj : $(this)\conc\fifosemaphore.d
	$(DMD) -c $(DFLAGS) $(this)\conc\$<d
mutex.obj : $(this)\conc\mutex.d
	$(DMD) -c $(DFLAGS) $(this)\conc\$<d
reentrantlock.obj : $(this)\conc\reentrantlock.d
	$(DMD) -c $(DFLAGS) $(this)\conc\$<d
latch.obj : $(this)\conc\latch.d
	$(DMD) -c $(DFLAGS) $(this)\conc\$<d
countdown.obj : $(this)\conc\countdown.d
	$(DMD) -c $(DFLAGS) $(this)\conc\$<d
barrier.obj : $(this)\conc\barrier.d
	$(DMD) -c $(DFLAGS) $(this)\conc\$<d
cyclicbarrier.obj : $(this)\conc\cyclicbarrier.d
	$(DMD) -c $(DFLAGS) $(this)\conc\$<d
rendezvous.obj : $(this)\conc\rendezvous.d
	$(DMD) -c $(DFLAGS) $(this)\conc\$<d
readwritelock.obj : $(this)\conc\readwritelock.d
	$(DMD) -c $(DFLAGS) $(this)\conc\$<d
readwritelockutils.obj : $(this)\conc\readwritelockutils.d
	$(DMD) -c $(DFLAGS) $(this)\conc\$<d

# Channel
boundedchannel.obj : $(this)\conc\boundedchannel.d
	$(DMD) -c $(DFLAGS) $(this)\conc\$<d
boundedlinkedqueue.obj : $(this)\conc\boundedlinkedqueue.d
	$(DMD) -c $(DFLAGS) $(this)\conc\$<d
channel.obj : $(this)\conc\channel.d
	$(DMD) -c $(DFLAGS) $(this)\conc\$<d
defaultchannelcapacity.obj : $(this)\conc\defaultchannelcapacity.d
	$(DMD) -c $(DFLAGS) $(this)\conc\$<d
linkedqueue.obj : $(this)\conc\linkedqueue.d
	$(DMD) -c $(DFLAGS) $(this)\conc\$<d
linkednode.obj : $(this)\conc\linkednode.d
	$(DMD) -c $(DFLAGS) $(this)\conc\$<d
lockedexecutor.obj : $(this)\conc/lockedexecutor.d
	$(DMD) -c $(DFLAGS) $(this)\conc\$<d
puttable.obj : $(this)\conc/puttable.d
	$(DMD) -c $(DFLAGS) $(this)\conc\$<d
synchronizedint.obj : $(this)\conc\synchronizedint.d
	$(DMD) -c $(DFLAGS) $(this)\conc\$<d
synchronizedvariable.obj : $(this)\conc\synchronizedvariable.d
	$(DMD) -c $(DFLAGS) $(this)\conc\$<d
takable.obj : $(this)\conc\takable.d
	$(DMD) -c $(DFLAGS) $(this)\conc\$<d
synchronouschannel.obj : $(this)\conc\synchronouschannel.d
	$(DMD) -c $(DFLAGS) $(this)\conc\$<d

# Executors
directexecutor.obj : $(this)\conc\directexecutor.d
	$(DMD) -c $(DFLAGS) $(this)\conc\$<d
executor.obj : $(this)\conc\executor.d
	$(DMD) -c $(DFLAGS) $(this)\conc\$<d
lockedexecutor.obj : $(this)\conc\lockedexecutor.d
	$(DMD) -c $(DFLAGS) $(this)\conc\$<d
pooledexecutor.obj : $(this)\conc\pooledexecutor.d
	$(DMD) -c $(DFLAGS) $(this)\conc\$<d
queuedexecutor.obj : $(this)\conc\queuedexecutor.d
	$(DMD) -c $(DFLAGS) $(this)\conc\$<d
threadedexecutor.obj : $(this)\conc\threadedexecutor.d
	$(DMD) -c $(DFLAGS) $(this)\conc\$<d
threadfactory.obj : $(this)\conc\threadfactory.d
	$(DMD) -c $(DFLAGS) $(this)\conc\$<d
threadfactoryuser.obj : $(this)\conc\threadfactoryuser.d
	$(DMD) -c $(DFLAGS) $(this)\conc\$<d
