/* \file syncutils.d
 * \brief Utility ������ for ���� �������
 */

/*
  Originally written by Doug Lea and released into the public domain.
  This may be used for any purposes whatsoever without acknowledgment.
  Thanks for the assistance and support of Sun Microsystems Labs,
  and everyone contributing, testing, and using this code.
  Translated to D by Ben Hinkle 2004.
*/

module conc.syncutils;

import conc.sync;


/** \class ��������
 * \brief A No-Op implementation of ����. 
 *
 * Acquire never blocks,
 * Attempt always succeeds, Release has no effect.
 * The methods are synchronized, so preserve memory ������ properties
 * of Syncs.
 * <p>
 * NullSyncs can be useful in optimizing ������ when
 * it is found that locking is not strictly necesssary.
 */
class �������� : ���� {

  synchronized ���� ������() {}

  synchronized ��� �������(��� ����) {
    return ��;
  }

  synchronized ���� �������() {}
}


/** \class �����������
 * \brief A sync where all calls have timeouts.
 *
 *  A ����������� is an adaptor class that transforms all
 * calls to ������ to instead invoke ������� with a predetermined
 * ������� ��������.
 */
class ����������� : ���� {

  protected final ���� ����_;     // the adapted sync
  protected final ��� �������_;  // ������� ��������

  /** 
   * Create a ����������� using the given ���� object, and
   * using the given ������� �������� for all calls to ������.
   */
  this(���� sync, ��� �������) {
    ����_ = sync;
    �������_ = �������;
  }

  /** Destroy ����������� and ������� system resources */
  ~this() {
    delete ����_;
  }

  ���� ������() {
    if (!����_.�������(�������_)) throw new ������������(�������_);
  }

  ��� �������(��� ����) {
    return ����_.�������(����);
  }

  ���� �������() {
    ����_.�������();
  }
}

/** \class �����������
 * \brief A class that can be used to compose Syncs.
 *
 * A ����������� object manages two ������ ���� �������,
 * <em>�������</em> and <em>����������</em>. The ������ operation
 * invokes <em>�������</em>.������() followed by <em>����������</em>.������(),
 * but backing out of ������� (via �������) upon an exception in ����������.
 * The ������ methods work similarly.
 * <p>
 * LayeredSyncs can be used to compose arbitrary chains
 * by arranging that either of the managed Syncs be another
 * �����������.
 *
 */
class ����������� : ���� {

  protected final ���� �������_;
  protected final ���� ����������_;

  /** 
   * Create a ����������� managing the given ������� and ���������� ����
   * �������
   */
  this(���� �������, ���� ����������) {
    �������_ = �������;
    ����������_ = ����������;
  }

  /** Destroy ����������� and ������� system resources */
  ~this() {
    delete �������_;
    delete ����������_;
  }

  ���� ������() {
    �������_.������();
    try {
      ����������_.������();
    }
    catch (������������ ����) {
      �������_.�������();
      throw ����;
    }
  }

  ��� �������(��� ����) {

    ��� ����� = (���� <= 0)? 0 : clock();
    ��� ������������� = ����;

    if (�������_.�������(�������������)) {
      try {
        if (���� > 0)
          ������������� = ���� - (clock() - �����);
        if (����������_.�������(�������������))
          return ��;
        else {
          �������_.�������();
          return ���;
        }
      }
      catch (������������ ����) {
        �������_.�������();
        throw ����;
      }
    }
    else
      return ���;
  }

  public ���� �������() {
    ����������_.�������();
    �������_.�������();
  }

}
