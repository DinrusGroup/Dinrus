/**
 * The нить module provопрes support for нить creation and management.
 *
 * If AtomicSuspendCount is used for скорость reasons все signals are sent together.
 * When debugging gdb funnels все signals through one single handler, and if
 * the signals arrive quickly enough they will be coalesced in a single signal,
 * (discarding the сукунда) thus it is possible в_ loose signals, which blocks
 * the program. Thus when debugging it is better в_ use the slower SuspendOneAtTime
 * version.
 *
 * Copyright: Copyright (C) 2005-2006 Sean Kelly, Fawzi.  все rights reserved.
 * License:   BSD стиль: $(LICENSE)
 * Authors:   Sean Kelly, Fawzi Mohamed
 */
module thread;

public import thread;