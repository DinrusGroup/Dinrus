/** \file �����������������.d
 * \brief ������� granting requests based on ���� priority
 */

/*
 *  TODO: thread doesn't implement ���������().
 */

/*
  Originally written by Doug Lea and released into the public domain.
  This may be used for any purposes whatsoever without acknowledgment.
  Thanks for the assistance and support of Sun Microsystems Labs,
  and everyone contributing, testing, and using this code.
  Translated to D by Ben Hinkle 2004.
*/

module conc.prioritysemaphore;

import conc.queuedsemaphore;

private import conc.waitnotify;
private import cidrus;

private import thread; // for unittest


/** \class �����������������
 * \brief ������� that grants requests to threads with higher
 * ���� priority rather than lower priority when there is
 * contention. 
 *
 * Ordering of requests with the same priority is approximately FIFO.
 * Priorities are based on ����.���������.
 * Changing the priority of an already-������ ���� does NOT 
 * change its ordering. This class also does not specially deal with priority
 * inversion --  when a new high-priority ���� enters
 * while a low-priority ���� is currently running, their
 * priorities are <em>not</em> artificially manipulated.
 */

class ����������������� : ��������������� {

  /** 
   * Create a ������� with the given initial ����� of �����.
   * Using a seed of one makes the semaphore act as a mutual exclusion �����.
   * Negative seeds are also allowed, in which case no acquires will proceed
   * until the ����� of releases has pushed the ����� of ����� past 0.
  */
  this(��� ��������������) { 
    super(new �����������������������(), ��������������);
  }

  protected class ����������������������� : ������������� {

    /** An array of ��� queues, one per priority */
    protected final �����������.�����������������[] ������_ = 
      new �����������.�����������������[����.��������� -
                                     ����.�������� + 1];

    /**
     * The ������ of the highest priority cell that may need to be ���������,
     * or -1 if none. Used to minimize array traversal.
    */

    protected ��� ����������_ = -1;

    protected �����������������������() { 
      for (��� i = 0; i < ������_.length; ++i) 
        ������_[i] = new �����������.�����������������();
    }

    protected ���� ������(���������� w) {
      ��� ��� = ����.������().���������() - ����.��������;
      ������_[���].������(w); 
      if (��� > ����������_) ����������_ = ���;
    }

    protected ���������� �������() {
      for (;;) {
        ��� ��� = ����������_;
        if (��� < 0) 
          return �����;
        ���������� w = ������_[���].�������();
        if (w != �����) 
          return w;
        else
          --����������_;
      }
    }
  }





}
