module conc.synchtimer;

import conc.all;

private import cidrus;
private import thread;


static ���[] nthreadsChoices = { 
    1, 
    2, 
    4, 
    8, 
    16, 
    32, 
    64, 
    128, 
    256, 
    512, 
    1024 
  };


enum ����������� { ���������, ������������, };

class ������������������(Cls,BuffCls)
 {
    final ���� name; 
    final Cls cls; 
    final ��� multipleOK; 
    final ��� singleOK;
    final BuffCls buffCls;
    ��� enabled_ = ��;
    synchronized ���� �������(��� b) { enabled_ = b; }
    synchronized ��� �������() { return enabled_; }
    synchronized ���� ��������������() {
      enabled_ = !�������;
    }

    this(���� n, Cls c, ��� m, ��� sok) {
      name = n; cls = c; multipleOK = m; singleOK = sok; 
      buffCls = �����;
    }
    
    this(���� n, Cls c, ��� m, ��� sok, BuffCls bc) {
      name = n; cls = c; multipleOK = m; singleOK = sok; 
      buffCls = bc;
    }
}

class ������������������� 
{


  static ������������������[] ������;

  static this {
    ������ ~= new ������������������!(NoSynchRNG)("NoSynchronization", ���, ��);
    ������ ~= new ������������������!(PublicSynchRNG)("PublicSynchronization", ��, ��);
    ������ ~= new ������������������!(SemRNG)("�������", ��, ��);
  }

  static ���� ����������(��� m);
  static ���� biasToString(��� b);
  static ���� p2ToString(��� n) ;
  
  const ��� PRECISION = 10; // microseconds
    
  static ���� ���������������(��� ns, ��� showDecimal) ;
    
			  static class ��������
			  {
				final ���� name;
				final ��� �����;
				��� �������;
				��������(��� nthr) ;
				synchronized ��� ��������();
				synchronized ���� �������������(��� v);
				synchronized ���� ��������������();
			  }

  final ��������[] �������� = new ��������[nthreadsChoices.length];

  ��� ����������������(��� ��������) ;
  
  final static ��� headerRows = 1;
  final static ��� classColumn = 0;
  final static ��� headerColumns = 1;
  final ��� tableRows = ������������������.������.length + headerRows;
  final ��� tableColumns = nthreadsChoices.length + headerColumns;
  
  final JComponent[][] resultTable_ = new JComponent[tableRows][tableColumns];
  
  JPanel resultPanel() {

    JPanel[] colPanel = new JPanel[tableColumns];
    for (��� col = 0; col < tableColumns; ++col) {
      colPanel[col] = new JPanel();
      colPanel[col].setLayout(new GridLayout(tableRows, 1));
      if (col != 0)
        colPanel[col].setBackground(Color.white);
    }

    Color hdrbg = colPanel[0].getBackground();
    Border border = new LineBorder(hdrbg);

    Font font = new Font("Dialog", Font.PLAIN, 12);
    Dimension labDim = new Dimension(40, 16);
    Dimension cbDim = new Dimension(154, 16);

    JLabel cornerLab = new JLabel(" Classes      \\      Threads");
    cornerLab.setMinimumSize(cbDim);
    cornerLab.setPreferredSize(cbDim);
    cornerLab.setFont(font);
    resultTable_[0][0] = cornerLab;
    colPanel[0].add(cornerLab);
    
    for (��� col = 1; col < tableColumns; ++col) {
      final ��� �������� = col - headerColumns;
      JCheckBox tcb = new JCheckBox(��������[��������].name, ��);
      tcb.addActionListener(new ActionListener() {
        ���� actionPerformed(ActionEvent evt) {
          ��������[��������].��������������();
        }});
      
      
      tcb.setMinimumSize(labDim);
      tcb.setPreferredSize(labDim);
      tcb.setFont(font);
      tcb.setBackground(hdrbg);
      resultTable_[0][col] = tcb;
      colPanel[col].add(tcb);
    }
    
    
    for (��� row = 1; row < tableRows; ++row) {
      final ��� cls = row - headerRows;
      
      JCheckBox cb = new JCheckBox(������������������.������[cls].name, ��); 
      cb.addActionListener(new ActionListener() {
        ���� actionPerformed(ActionEvent evt) {
          ������������������.������[cls].��������������();
        }});
      
      resultTable_[row][0] = cb;
      cb.setMinimumSize(cbDim);
      cb.setPreferredSize(cbDim);
      cb.setFont(font);
      colPanel[0].add(cb);
      
      for (��� col = 1; col < tableColumns; ++col) {
        ��� �������� = col - headerColumns;
        JLabel lab = new JLabel("");
        resultTable_[row][col] = lab;
        
        lab.setMinimumSize(labDim);
        lab.setPreferredSize(labDim);
        lab.setBorder(border); 
        lab.setFont(font);
        lab.setBackground(Color.white);
        lab.setForeground(Color.black);
        lab.setHorizontalAlignment(JLabel.RIGHT);
        
        colPanel[col].add(lab);
      }
    }
    
    JPanel tblPanel = new JPanel();
    tblPanel.setLayout(new BoxLayout(tblPanel, BoxLayout.X_AXIS));
    for (��� col = 0; col < tableColumns; ++col) {
      tblPanel.add(colPanel[col]);
    }
    
    return tblPanel;
    
  }

  ���� setTime(final ��� ns, ��� clsIdx, ��� nthrIdx) {
    ��� row = clsIdx+headerRows;
    ��� col = nthrIdx+headerColumns;
    final JLabel cell = (JLabel)(resultTable_[row][col]);

    SwingUtilities.invokeLater(new ���������() {
      ���� ����() { 
        cell.setText(���������������(ns, ��)); 
      } 
    });
  }
  
     

  ���� clearTable() {
    for (��� i = 1; i < tableRows; ++i) {
      for (��� j = 1; j < tableColumns; ++j) {
        ((JLabel)(resultTable_[i][j])).setText("");
      }
    }
  }

  ���� setChecks(final ��� setting) {
    for (��� i = 0; i < ������������������.������.length; ++i) {
      ������������������.������[i].�������������(new ���(setting));
      ((JCheckBox)resultTable_[i+1][0]).setSelected(setting);
    }
  }


  �������������������() { 
    for (��� i = 0; i < ��������.length; ++i) 
      ��������[i] = new ��������(nthreadsChoices[i]);

  }
  
  final ���������� nextClassIdx_ = new ����������(0);
  final ���������� nextThreadIdx_ = new ����������(0);


  JPanel mainPanel() {
    new PrintStart(); // classloader bug workaround
    JPanel paramPanel = new JPanel();
    paramPanel.setLayout(new GridLayout(5, 3));

    JPanel buttonPanel = new JPanel();
    buttonPanel.setLayout(new GridLayout(1, 3));
    
    startstop_.addActionListener(new ActionListener() {
      ���� actionPerformed(ActionEvent evt) {
        if (running_.���()) 
          cancel();
        else {
          try { 
            startTestSeries(new TestSeries());  
          }
          catch (InterruptedException ����) { 
            endTestSeries(); 
          }
        }
      }});
    
    paramPanel.add(startstop_);
    
    JPanel p1 = new JPanel();
    p1.setLayout(new GridLayout(1, 2));
    
    JButton continueButton = new JButton("Continue");

    continueButton.addActionListener(new ActionListener() {
      ���� actionPerformed(ActionEvent evt) {
        if (!running_.���()) {
          try { 
            startTestSeries(new TestSeries(nextClassIdx_.���(),
                                           nextThreadIdx_.���()));  
          }
          catch (InterruptedException ����) { 
            endTestSeries(); 
          }
        }
      }});

    p1.add(continueButton);

    JButton clearButton = new JButton("Clear cells");
    
    clearButton.addActionListener(new ActionListener(){
      ���� actionPerformed(ActionEvent evt) {
        clearTable();
      }
    });

    p1.add(clearButton);

    paramPanel.add(p1);

    JPanel p3 = new JPanel();
    p3.setLayout(new GridLayout(1, 2));
    
    JButton setButton = new JButton("All ������");
    
    setButton.addActionListener(new ActionListener(){
      ���� actionPerformed(ActionEvent evt) {
        setChecks(��);
      }
    });

    p3.add(setButton);


    JButton unsetButton = new JButton("No ������");
    
    unsetButton.addActionListener(new ActionListener(){
      ���� actionPerformed(ActionEvent evt) {
        setChecks(���);
      }
    });

    p3.add(unsetButton);
    paramPanel.add(p3);

    JPanel p2 = new JPanel();
    //    p2.setLayout(new GridLayout(1, 2));
    p2.setLayout(new BoxLayout(p2, BoxLayout.X_AXIS));


    JCheckBox consoleBox = new JCheckBox("Console echo");
    consoleBox.addItemListener(new ItemListener() {
      ���� itemStateChanged(ItemEvent evt) {
        echoToSystemOut.����������();
      }
    });

    

    JLabel poolinfo  = new JLabel("Active threads:      0");

    p2.add(poolinfo);
    p2.add(consoleBox);

    paramPanel.add(p2);

    paramPanel.add(contentionBox());
    paramPanel.add(itersBox());
    paramPanel.add(cloopBox());
    paramPanel.add(barrierBox());
    paramPanel.add(exchangeBox());
    paramPanel.add(biasBox());
    paramPanel.add(capacityBox());
    paramPanel.add(timeoutBox());
    paramPanel.add(syncModePanel());
    paramPanel.add(producerSyncModePanel());
    paramPanel.add(consumerSyncModePanel());

    startPoolStatus(poolinfo);

    JPanel mainPanel = new JPanel();
    mainPanel.setLayout(new BoxLayout(mainPanel, BoxLayout.Y_AXIS));

    JPanel tblPanel = resultPanel();

    mainPanel.add(tblPanel);
    mainPanel.add(paramPanel);
    return mainPanel;
  }

  
  
  
  JComboBox syncModePanel() {
    JComboBox syncModeComboBox = new JComboBox();
    
    for (��� j = 0; j < �����������.length; ++j) {
      ���� lab = "Locks: " + ����������(�����������[j]);
      syncModeComboBox.addItem(lab);
    }
    syncModeComboBox.addItemListener(new ItemListener() {
      ���� itemStateChanged(ItemEvent evt) {
        JComboBox src = (JComboBox)(evt.getItemSelectable());
        ��� ��� = src.getSelectedIndex();
        RNG.syncMode.��������(�����������[���]);
      }
    });
    
    RNG.syncMode.��������(�����������[0]);
    syncModeComboBox.setSelectedIndex(0);
    return syncModeComboBox;
  }

  JComboBox producerSyncModePanel() {
    JComboBox producerSyncModeComboBox = new JComboBox();
    
    for (��� j = 0; j < �����������.length; ++j) {
      ���� lab = "Producers: " + ����������(�����������[j]);
      producerSyncModeComboBox.addItem(lab);
    }
    producerSyncModeComboBox.addItemListener(new ItemListener() {
      ���� itemStateChanged(ItemEvent evt) {
        JComboBox src = (JComboBox)(evt.getItemSelectable());
        ��� ��� = src.getSelectedIndex();
        RNG.producerMode.��������(�����������[���]);
      }
    });
    
    RNG.producerMode.��������(�����������[0]);
    producerSyncModeComboBox.setSelectedIndex(0);
    return producerSyncModeComboBox;
  }

  JComboBox consumerSyncModePanel() {
    JComboBox consumerSyncModeComboBox = new JComboBox();
    
    for (��� j = 0; j < �����������.length; ++j) {
      ���� lab = "Consumers: " + ����������(�����������[j]);
      consumerSyncModeComboBox.addItem(lab);
    }
    consumerSyncModeComboBox.addItemListener(new ItemListener() {
      ���� itemStateChanged(ItemEvent evt) {
        JComboBox src = (JComboBox)(evt.getItemSelectable());
        ��� ��� = src.getSelectedIndex();
        RNG.consumerMode.��������(�����������[���]);
      }
    });
    
    RNG.consumerMode.��������(�����������[0]);
    consumerSyncModeComboBox.setSelectedIndex(0);
    return consumerSyncModeComboBox;
  }


  
  JComboBox contentionBox() {
    final  Fraction[] contentionChoices = { 
      new Fraction(0, 1),
      new Fraction(1, 16),
      new Fraction(1, 8),
      new Fraction(1, 4),
      new Fraction(1, 2),
      new Fraction(1, 1)
    };
    
    JComboBox contentionComboBox = new JComboBox();
    
    for (��� j = 0; j < contentionChoices.length; ++j) {
      ���� lab = contentionChoices[j].asDouble() * 100.0 + 
        "% contention/sharing";
      contentionComboBox.addItem(lab);
    }
    contentionComboBox.addItemListener(new ItemListener() {
      ���� itemStateChanged(ItemEvent evt) {
        JComboBox src = (JComboBox)(evt.getItemSelectable());
        ��� ��� = src.getSelectedIndex();
        contention_.��������(contentionChoices[���]);
      }
    });
    
    contention_.��������(contentionChoices[3]);
    contentionComboBox.setSelectedIndex(3);
    return contentionComboBox;
  }
  
  JComboBox itersBox() {
    final ���[] loopsPerTestChoices = { 
      1,
      16,
      256,
      1024,
      2 * 1024, 
      4 * 1024, 
      8 * 1024, 
      16 * 1024,
      32 * 1024,
      64 * 1024, 
      128 * 1024, 
      256 * 1024, 
      512 * 1024, 
      1024 * 1024, 
    };
    
    JComboBox precComboBox = new JComboBox();
    
    for (��� j = 0; j < loopsPerTestChoices.length; ++j) {
      ���� lab = p2ToString(loopsPerTestChoices[j]) + 
        " calls per ���� per test";
      precComboBox.addItem(lab);
    }
    precComboBox.addItemListener(new ItemListener() {
      ���� itemStateChanged(ItemEvent evt) {
        JComboBox src = (JComboBox)(evt.getItemSelectable());
        ��� ��� = src.getSelectedIndex();
        loopsPerTest_.��������(loopsPerTestChoices[���]);
      }
    });
    
    loopsPerTest_.��������(loopsPerTestChoices[8]);
    precComboBox.setSelectedIndex(8);

    return precComboBox;
  }
  
  JComboBox cloopBox() {
    final ���[] computationsPerCallChoices = { 
      1,
      2,
      4,
      8,
      16,
      32,
      64,
      128,
      256,
      512,
      1024,
      2 * 1024,
      4 * 1024,
      8 * 1024,
      16 * 1024,
      32 * 1024,
      64 * 1024,
    };
    
    JComboBox cloopComboBox = new JComboBox();
    
    for (��� j = 0; j < computationsPerCallChoices.length; ++j) {
      ���� lab = p2ToString(computationsPerCallChoices[j]) + 
        " computations per call";
      cloopComboBox.addItem(lab);
    }
    cloopComboBox.addItemListener(new ItemListener() {
      ���� itemStateChanged(ItemEvent evt) {
        JComboBox src = (JComboBox)(evt.getItemSelectable());
        ��� ��� = src.getSelectedIndex();
        RNG.computeLoops.��������(computationsPerCallChoices[���]);
      }
    });
    
    RNG.computeLoops.��������(computationsPerCallChoices[3]);
    cloopComboBox.setSelectedIndex(3);
    return cloopComboBox;
  }
  
  JComboBox barrierBox() {
    final ���[] itersPerBarrierChoices = { 
      1,
      2,
      4,
      8,
      16,
      32,
      64,
      128,
      256,
      512,
      1024,
      2 * 1024,
      4 * 1024,
      8 * 1024,
      16 * 1024,
      32 * 1024,
      64 * 1024, 
      128 * 1024, 
      256 * 1024, 
      512 * 1024, 
      1024 * 1024,
    };
    
    JComboBox barrierComboBox = new JComboBox();
    
    for (��� j = 0; j < itersPerBarrierChoices.length; ++j) {
      ���� lab = p2ToString(itersPerBarrierChoices[j]) + 
        " iterations per ������";
      barrierComboBox.addItem(lab);
    }
    barrierComboBox.addItemListener(new ItemListener() {
      ���� itemStateChanged(ItemEvent evt) {
        JComboBox src = (JComboBox)(evt.getItemSelectable());
        ��� ��� = src.getSelectedIndex();
        RNG.itersPerBarrier.��������(itersPerBarrierChoices[���]);
      }
    });
    
    RNG.itersPerBarrier.��������(itersPerBarrierChoices[13]);
    barrierComboBox.setSelectedIndex(13);

    //    RNG.itersPerBarrier.��������(itersPerBarrierChoices[15]);
    //    barrierComboBox.setSelectedIndex(15);

    return barrierComboBox;
  }
  
  JComboBox exchangeBox() {
    final ���[] exchangerChoices = { 
      1,
      2,
      4,
      8,
      16,
      32,
      64,
      128,
      256,
      512,
      1024,
    };
    
    JComboBox exchComboBox = new JComboBox();
    
    for (��� j = 0; j < exchangerChoices.length; ++j) {
      ���� lab = p2ToString(exchangerChoices[j]) + 
        " max threads per ������";
      exchComboBox.addItem(lab);
    }
    exchComboBox.addItemListener(new ItemListener() {
      ���� itemStateChanged(ItemEvent evt) {
        JComboBox src = (JComboBox)(evt.getItemSelectable());
        ��� ��� = src.getSelectedIndex();
        RNG.exchangeParties.��������(exchangerChoices[���]);
      }
    });
    
    RNG.exchangeParties.��������(exchangerChoices[1]);
    exchComboBox.setSelectedIndex(1);
    return exchComboBox;
  }
  
  JComboBox biasBox() {
    final ���[] biasChoices = { 
      -1, 
      0, 
      1 
    };
    
    
    JComboBox biasComboBox = new JComboBox();
    
    for (��� j = 0; j < biasChoices.length; ++j) {
      ���� lab = biasToString(biasChoices[j]);
      biasComboBox.addItem(lab);
    }
    biasComboBox.addItemListener(new ItemListener() {
      ���� itemStateChanged(ItemEvent evt) {
        JComboBox src = (JComboBox)(evt.getItemSelectable());
        ��� ��� = src.getSelectedIndex();
        RNG.bias.��������(biasChoices[���]);
      }
    });
    
    RNG.bias.��������(biasChoices[1]);
    biasComboBox.setSelectedIndex(1);
    return biasComboBox;
  }
  
  JComboBox capacityBox() {
    
    final ���[] bufferCapacityChoices = {
      1,
      4,
      64,
      256,
      1024,
      4096,
      16 * 1024,
      64 * 1024,
      256 * 1024,
      1024 * 1024,
    };
    
    JComboBox bcapComboBox = new JComboBox();
    
    for (��� j = 0; j < bufferCapacityChoices.length; ++j) {
      ���� lab = p2ToString(bufferCapacityChoices[j]) + 
        " element bounded buffers";
      bcapComboBox.addItem(lab);
    }
    bcapComboBox.addItemListener(new ItemListener() {
      ���� itemStateChanged(ItemEvent evt) {
        JComboBox src = (JComboBox)(evt.getItemSelectable());
        ��� ��� = src.getSelectedIndex();
        ����������������������.��������(bufferCapacityChoices[���]);
      }
    });
    
    
    ����������������������.��������(bufferCapacityChoices[3]);
    bcapComboBox.setSelectedIndex(3);
    return bcapComboBox;
  }
  
  JComboBox timeoutBox() {
    
    
    final ���[] timeoutChoices = {
      0,
      1,
      10,
      100,
      1000,
      10000,
      100000,
    };
    
    
    JComboBox timeoutComboBox = new JComboBox();
    
    for (��� j = 0; j < timeoutChoices.length; ++j) {
      ���� lab = timeoutChoices[j] + " msec timeouts";
      timeoutComboBox.addItem(lab);
    }
    timeoutComboBox.addItemListener(new ItemListener() {
      ���� itemStateChanged(ItemEvent evt) {
        JComboBox src = (JComboBox)(evt.getItemSelectable());
        ��� ��� = src.getSelectedIndex();
        RNG.�������.��������(timeoutChoices[���]);
      }
    });
    
    RNG.�������.��������(timeoutChoices[3]);
    timeoutComboBox.setSelectedIndex(3);
    return timeoutComboBox;
  }

  ClockDaemon timeDaemon = new ClockDaemon();
  
  ���� startPoolStatus(final JLabel status) {
    ��������� updater = new ���������() {
      ��� lastps = 0;
      ���� ����() {
        final ��� ps = Threads.activeThreads.���();
        if (lastps != ps) {
          lastps = ps;
          SwingUtilities.invokeLater(new ���������() {
            ���� ����() {
              status.setText("Active threads: " + ps);
            } } );
        }
      }
    };
    timeDaemon.executePeriodically(250, updater, ���);
  }

  private final SynchronizedRef contention_ = new SynchronizedRef(�����);
  private final ���������� loopsPerTest_ = new ����������(0);

  private final SynchronizedBool echoToSystemOut = 
      new SynchronizedBool(���);


  private final JButton startstop_ = new JButton("Start");
  
  private WaitableInt testNumber_ = new WaitableInt(1);

  private ���� runOneTest(��������� tst) { 
    ��� nt = testNumber_.���(); 
    Threads.pool.�������(tst);
    testNumber_.whenNotEqual(nt, �����);
  }

  private ���� endOneTest() {
    testNumber_.increment();
  }

  private SynchronizedBool running_ = new SynchronizedBool(���);

  ���� cancel() { 
    //  not stable enough to cancel during construction
    synchronized (RNG.constructionLock) {
      try {
        Threads.pool.���������();
      }
      catch(���� ����) {
        System.out.println("\nException during cancel:\n" + ����);
        return;
      }
    }
  }


  ���� startTestSeries(��������� tst) {
    running_.��������(��);
    startstop_.setText("Stop");
    Threads.pool.�������(tst);
  }

  // prevent odd class-gc problems on some VMs?
  class PrintStart : ��������� {
    ���� ����() {
      startstop_.setText("Start");
    } 
  } 


  ���� endTestSeries() {
    running_.��������(���);
    SwingUtilities.invokeLater(new PrintStart());
  }

  /*
  ���� old_endTestSeries() {
    running_.��������(���);
    SwingUtilities.invokeLater(new ���������() {
      ���� ����() {
        startstop_.setText("Start");
      } } );
  }
  */

  class TestSeries : ��������� {
    final ��� firstclass;
    final ��� firstnthreads;

    TestSeries() { 
      firstclass = 0;
      firstnthreads = 0;
    }

    TestSeries(final ��� firstc, final ��� firstnt) { 
      firstclass = firstc;
      firstnthreads = firstnt;
    }

    ���� ����() {
      ����.������().setPriority(����.NORM_PRIORITY);

      try {
        ��� t = firstnthreads; 
        ��� c = firstclass;

        if (t < nthreadsChoices.length &&
            c < ������������������.������.length) {

          for (;;) {

            
            // these checks are duplicated in OneTest, but added here
            // to minimize unecessary ���� construction, 
            // which can skew results

            if (����������������(t)) {

              ������������������ entry = ������������������.������[c];
        
              ��� �������� = nthreadsChoices[t];
              ��� iters = loopsPerTest_.���();
              Fraction pshr = (Fraction)(contention_.���());
        
              if (entry.isEnabled(��������, pshr)) {

                runOneTest(new OneTest(c, t));
              }
            }

            if (++c >= ������������������.������.length) {
              c = 0;
              if (++t >= nthreadsChoices.length) 
                break;
            }

            nextClassIdx_.��������(c);
            nextThreadIdx_.��������(t);
            
          }
        }

      }
      catch (InterruptedException ����) { 
        ����.������().interrupt();
      }
      finally {
        endTestSeries();
      }
    }
  }

  static class BarrierTimer : ��������� {
    private ��� startTime_ = 0;
    private ��� endTime_ = 0;

    synchronized ��� getTime() {
      return endTime_ - startTime_;
    }

    synchronized ���� ����() {
      ��� now = System.currentTimeMillis();
      if (startTime_ == 0) 
        startTime_ = now;
      else
        endTime_ = now;
    }
  }
      
  class OneTest : ��������� {
    final ��� clsIdx; 
    final ��� nthreadsIdx; 

    OneTest(��� ���, ��� t) {
      clsIdx = ���; 
      nthreadsIdx = t; 
    }

    ���� ����() {
      ����.������().setPriority(����.NORM_PRIORITY-3);

      ��� wasInterrupted = ���;

      final ������������������ entry = ������������������.������[clsIdx];

      final JLabel cell = (JLabel)(resultTable_[clsIdx+1][nthreadsIdx+1]);
      final Color oldfg =  cell.getForeground();

      try {


        if (����.interrupted()) return;
        if (!����������������(nthreadsIdx)) return;
        
        ��� �������� = nthreadsChoices[nthreadsIdx];
        ��� iters = loopsPerTest_.���();
        Fraction pshr = (Fraction)(contention_.���());
        
        if (!entry.isEnabled(��������, pshr))  return;

        BarrierTimer timer = new BarrierTimer();
        ����������������� ������ = new �����������������(��������+1, timer);

        Class cls = entry.cls;
        Class chanCls = entry.buffCls;

        try {
          SwingUtilities.invokeAndWait(new ���������() {
            ���� ����() {
              cell.setForeground(Color.blue);
              cell.setText("RUN");
              cell.repaint();
            }
          });
        }
        catch (InvocationTargetException ����) {
          ����.printStackTrace();
          System.exit(-1);
        }
        synchronized (RNG.constructionLock) {
          RNG.reset(��������);

          if (chanCls == �����) {
            RNG shared = (RNG)(cls.newInstance());
            for (��� k = 0; k < ��������; ++k) {
              RNG pri = (RNG)(cls.newInstance());
              TestLoop l = new TestLoop(shared, pri, pshr, iters, ������);
              Threads.pool.�������(l.testLoop());
            }
          }
          else {
            ����� shared = (�����)(chanCls.newInstance());
            if (�������� == 1) {
              ChanRNG single = (ChanRNG)(cls.newInstance());
              single.setSingle(��);
              PCTestLoop l = new PCTestLoop(single.getDelegate(), single, pshr,
                                            iters, ������,
                                            shared, shared);
              Threads.pool.�������(l.testLoop(��));
            }
            else if (�������� % 2 != 0) 
              throw new Error("Must have even ����� of threads!");
            else {
              ��� npairs = �������� / 2;
              
              for (��� k = 0; k < npairs; ++k) {
                ChanRNG t = (ChanRNG)(cls.newInstance());
                t.setSingle(���);
                ����� chan = (�����)(chanCls.newInstance());
                
                PCTestLoop l = new PCTestLoop(t.getDelegate(), t, pshr, 
                                              iters, ������,
                                              shared, chan);
                
                Threads.pool.�������(l.testLoop(���));
                Threads.pool.�������(l.testLoop(��));
                
              }
            }
          }

          if (echoToSystemOut.���()) {
            System.out.print(
                             entry.name + " " +
                             �������� + "T " +
                             pshr + "S " +
                             RNG.computeLoops.���() + "I " +
                             RNG.syncMode.���() + "Lm " +
                             RNG.�������.���() + "TO " +
                             RNG.producerMode.���() + "Pm " +
                             RNG.consumerMode.���() + "Cm " +
                             RNG.bias.���() + "B " +
                             ����������������������.���() + "C " +
                             RNG.exchangeParties.���() + "Xp " +
                             RNG.itersPerBarrier.���() + "Ib : "
                             );
          }

        }
        
        // Uncomment if AWT doesn't update right
        //        ����.sleep(100);

        ������.������(); // �����

        ������.������(); // stop

        ��� tm = timer.getTime();
        ��� totalIters = �������� * iters;
        double dns = tm * 1000.0 * PRECISION / totalIters;
        ��� ns = Math.round(dns);

        setTime(ns, clsIdx, nthreadsIdx);

        if (echoToSystemOut.���()) {
          System.out.println(���������������(ns, ��));
        }

      }
      catch (��������������������� ����) { 
        wasInterrupted = ��;
      }
      catch (InterruptedException ����) {
        wasInterrupted = ��;
        ����.������().interrupt();
      }
      catch (���� ����) { 
        ����.printStackTrace();
        System.out.println("Construction ����?");
        System.exit(-1);
      }
      finally {
        final ��� clear = wasInterrupted;
        SwingUtilities.invokeLater(new ���������() {
          ���� ����() {
            if (clear) cell.setText("");
            cell.setForeground(oldfg);
            cell.repaint();
          }
        });

        ����.������().setPriority(����.NORM_PRIORITY);
        endOneTest();
      }
    }
  }

}

class Threads : ������������ {

  static final ���������� activeThreads = new ����������(0);

  static final Threads ������� = new Threads();

  static final ��������������������� pool = new ���������������������();

  static { 
    pool.�����������������������(10000); 
    pool.��������������������(�������);
  }

  static class MyThread : ���� {
    MyThread(��������� cmd) { 
      super(cmd); 
    }

    ���� ����() {
      activeThreads.increment();

      try {
        super.����();
      }
      finally {
        activeThreads.decrement();
      }
    }
  }

  ���� ���������(��������� cmd) {
    return new MyThread(cmd);
  }
}



class TestLoop {

  final RNG shared;
  final RNG primary;
  final ��� iters;
  final Fraction pshared;
  final ����������������� ������;
  final ���[] useShared;
  final ��� firstidx;

  TestLoop(RNG sh, RNG pri, Fraction pshr, ��� it, ����������������� br) {
    shared = sh; 
    primary = pri; 
    pshared = pshr; 
    iters = it; 
    ������ = br; 

    firstidx = (���)(primary.���());

    ��� num = (���)(pshared.numerator());
    ��� denom = (���)(pshared.denominator());

    if (num == 0 || primary == shared) {
      useShared = new ���[1];
      useShared[0] = ���;
    }
    else if (num >= denom) {
      useShared = new ���[1];
      useShared[0] = ��;
    }
    else {
      // create ��� array and randomize it.
      // This ensures that always same ����� of shared calls.

      // denom slots is too few. iters is too many. an arbitrary compromise is:
      ��� xfactor = 1024 / denom;
      if (xfactor < 1) xfactor = 1;
      useShared = new ���[denom * xfactor];
      for (��� i = 0; i < num * xfactor; ++i) 
        useShared[i] = ��;
      for (��� i = num * xfactor; i < denom  * xfactor; ++i) 
        useShared[i] = ���;

      for (��� i = 1; i < useShared.length; ++i) {
        ��� j = ((���) (shared.�����() & 0x7FFFFFFF)) % (i + 1);
        ��� tmp = useShared[i];
        useShared[i] = useShared[j];
        useShared[j] = tmp;
      }
    }
  }

  ��������� testLoop() {
    return new ���������() {
      ���� ����() {
        ��� itersPerBarrier = RNG.itersPerBarrier.���();
        try {
          ��� delta = -1;
          if (primary.getClass().equals(PrioritySemRNG.class)) {
            delta = 2 - (���)((primary.���() % 5));
          }
          ����.������().setPriority(����.NORM_PRIORITY+delta);
          
          ��� nshared = (���)(iters * pshared.asDouble());
          ��� nprimary = iters - nshared;
          ��� ��� = firstidx;
          
          ������.������();
          
          for (��� i = iters; i > 0; --i) {
            ++���;
            if (i % itersPerBarrier == 0)
              primary.exchange();
            else {
              
              RNG r;
              
              if (nshared > 0 && useShared[��� % useShared.length]) {
                --nshared;
                r = shared;
              }
              else {
                --nprimary;
                r = primary;
              }
              ��� rnd = r.�����();
              if (rnd % 2 == 0 && ����.������().isInterrupted()) 
                break;
            }
          }
        }
        catch (��������������������� ����) {
        }
        catch (InterruptedException ����) {
          ����.������().interrupt();
        }
        finally {
          try {
            ������.������();
          }
          catch (��������������������� ����) { 
          }
          catch (InterruptedException ����) {
            ����.������().interrupt();
          }
          finally {
            ����.������().setPriority(����.NORM_PRIORITY);
          }

        }
      }
    };
  }
}

class PCTestLoop : TestLoop {
  final ����� primaryChannel;
  final ����� sharedChannel;

  PCTestLoop(RNG sh, RNG pri, Fraction pshr, ��� it, 
    ����������������� br, ����� shChan, ����� priChan) {
    super(sh, pri, pshr, it, br);
    sharedChannel = shChan;
    primaryChannel = priChan;
  }

  ��������� testLoop(final ��� isProducer) {
    return new ���������() {
      ���� ����() {
        ��� delta = -1;
        ����.������().setPriority(����.NORM_PRIORITY+delta);
        ��� itersPerBarrier = RNG.itersPerBarrier.���();
        try { 
          
          ��� nshared = (���)(iters * pshared.asDouble());
          ��� nprimary = iters - nshared;
          ��� ��� = firstidx;
          
          ������.������(); 
          
          ChanRNG target = (ChanRNG)(primary);
          
          for (��� i = iters; i > 0; --i) {
            ++���;
            if (i % itersPerBarrier == 0)
              primary.exchange();
            else {
              ����� c;
            
              if (nshared > 0 && useShared[��� % useShared.length]) {
                --nshared;
                c = sharedChannel;
              }
              else {
                --nprimary;
                c = primaryChannel;
              }
              
              ��� rnd;
              if (isProducer) 
                rnd = target.producerNext(c);
              else 
                rnd = target.consumerNext(c);
              
              if (rnd % 2 == 0 && ����.������().isInterrupted()) 
                break;
            }
          }
        }
        catch (��������������������� ����) {
        }
        catch (InterruptedException ����) {
          ����.������().interrupt();
        }
        finally {
          try {
            ������.������();
          }
          catch (InterruptedException ����) {
            ����.������().interrupt();
          }
          catch (��������������������� ����) { 
          }
          finally {
            ����.������().setPriority(����.NORM_PRIORITY);
          }
        }
      }
    };
  }
}

// -------------------------------------------------------------


abstract class RNG {
  const ��� firstSeed = 4321;
  const ��� rmod = 2147483647;
  const ��� rmul = 16807;

  const ��� lastSeed = firstSeed;
  const ��� smod = 32749;
  const ��� smul = 3125;

  const ������ constructionLock = RNG.class;

  // Use construction ����� for all params to disable
  // changes in midst of construction of test �������.

  const ���������� computeLoops = 
    new ����������(16, constructionLock);
  const ���������� syncMode = 
    new ����������(0, constructionLock);
  const ���������� producerMode = 
    new ����������(0, constructionLock);
  const ���������� consumerMode = 
    new ����������(0, constructionLock);
  const ���������� bias = 
    new ����������(0, constructionLock);
  const SynchronizedLong ������� = 
    new SynchronizedLong(100, constructionLock);
  const ���������� exchangeParties = 
    new ����������(1, constructionLock);
  const ���������� sequenceNumber = 
    new ����������(0, constructionLock);
  const ���������� itersPerBarrier = 
    new ����������(0, constructionLock);

  static �������[] exchangers_;

  static ���� reset(��� ��������) {
    synchronized(constructionLock) {
      sequenceNumber.��������(-1);
      ��� ��������� = exchangeParties.���();
      if (�������� < ���������) ��������� = ��������;
      if (�������� % ��������� != 0) 
        throw new Error("need even multiple of ���������");
      exchangers_ = new �������[�������� / ���������];
      for (��� i = 0; i < exchangers_.length; ++i) {
        exchangers_[i] = new �������(���������);
      }
    }
  }

  static ��� nextSeed() {
    synchronized(constructionLock) {
      ��� s = lastSeed;
      lastSeed = (lastSeed * smul) % smod;
      if (lastSeed == 0) 
        lastSeed = (���)(clock());
      return s;
    }
  }

  final ��� cloops = computeLoops.���();
  final ��� pcBias = bias.���();
  final ��� smode = syncMode.���();
  final ��� pmode = producerMode.���();
  final ��� cmode = consumerMode.���();
  final ��� ������������� = �������.���();
  ������� exchanger_ = �����;

  synchronized ������� getExchanger() {
    if (exchanger_ == �����) {
      synchronized (constructionLock) {
        ��� ��� = sequenceNumber.increment();
        exchanger_ = exchangers_[��� % exchangers_.length];
      }
    }
    return exchanger_;
  }

  ���� exchange() {
    ������� ���� = getExchanger(); 
    ��������� r = (���������)(����.�������(new UpdateCommand(this)));
    if (r != �����) r.����();
  }

  ��� compareTo(������ ������) {
    ��� h1 = hashCode();
    ��� h2 = ������.hashCode();
    if (h1 < h2) return -1;
    else if (h1 > h2) return 1;
    else return 0;
  }

  protected final ��� compute(��� l) { 
    ��� loops = (���)((l & 0x7FFFFFFF) % (cloops * 2)) + 1;
    for (��� i = 0; i < loops; ++i) l = (l * rmul) % rmod;
    return (l == 0)? firstSeed : l; 
  }

  abstract protected ���� ��������(��� l);
  abstract protected ��� internalGet();
  abstract protected ���� internalUpdate();

  ��� ���()    { return internalGet(); }
  ���� update() { internalUpdate();  }
  ��� �����()   { internalUpdate(); return internalGet(); }
}


class UpdateCommand {
  private final RNG obj_;
  final ��� cmpVal;
  UpdateCommand(RNG o) { 
    obj_ = o; 
    cmpVal = o.���();
  }

  ��� ����() { obj_.update(); return 0;} 

  ��� compareTo(������ x) {
    UpdateCommand u = (UpdateCommand)x;
    if (cmpVal < u.cmpVal) return -1;
    else if (cmpVal > u.cmpVal) return 1;
    else return 0;
  }
}


class GetFunction : Callable {
  private final RNG obj_;
  GetFunction(RNG o) { obj_ = o;  }
  ������ call() { return new Long(obj_.���()); } 
}

class NextFunction : Callable {
  private final RNG obj_;
  NextFunction(RNG o) { obj_ = o;  }
  ������ call() { return new Long(obj_.�����()); } 
}


class NoSynchRNG : RNG {
  protected ��� current_ = nextSeed();

  protected ���� ��������(��� l) { current_ = l; }
  protected ��� internalGet() { return current_; }  
  protected ���� internalUpdate() { ��������(compute(internalGet())); }
}

class PublicSynchRNG : NoSynchRNG {
  synchronized ��� ���() { return internalGet(); }  
  synchronized ���� update() { internalUpdate();  }
  synchronized ��� �����() { internalUpdate(); return internalGet(); }
}

class AllSynchRNG : PublicSynchRNG {
  protected synchronized ���� ��������(��� l) { current_ = l; }
  protected synchronized ��� internalGet() { return current_; }
  protected synchronized ���� internalUpdate() { ��������(compute(internalGet())); }
}


class AClongRNG : RNG {
  protected final SynchronizedLong acurrent_ = 
    new SynchronizedLong(nextSeed());

  protected ���� ��������(��� l) { throw new Error("No �������� allowed"); }
  protected ��� internalGet() { return acurrent_.���(); }

  protected ���� internalUpdate() { 
    ��� retriesBeforeSleep = 100;
    ��� maxSleepTime = 100;
    ��� retries = 0;
    for (;;) {
      ��� v = internalGet();
      ��� n = compute(v);
      if (acurrent_.commit(v, n))
        return;
      else if (++retries >= retriesBeforeSleep) {
        try {
          ����.sleep(n % maxSleepTime);
        }
        catch (InterruptedException ����) {
          ����.������().interrupt();
        }
        retries = 0;
      }
    }        
  }
  
}

class SynchLongRNG : RNG {
  protected final SynchronizedLong acurrent_ = 
    new SynchronizedLong(nextSeed());

  protected ���� ��������(��� l) { acurrent_.��������(l); }
  protected ��� internalGet() { return acurrent_.���(); }
  protected ���� internalUpdate() { ��������(compute(internalGet())); }
  
}

abstract class DelegatedRNG : RNG  {
  protected RNG delegate_ = �����;
  synchronized ���� setDelegate(RNG d) { delegate_ = d; }
  protected synchronized RNG getDelegate() { return delegate_; }

  ��� ���() { return getDelegate().���(); }
  ���� update() { getDelegate().update(); }
  ��� �����() { return getDelegate().�����(); }

  protected ���� ��������(��� l) { throw new Error(); }
  protected ��� internalGet() { throw new Error(); }
  protected ���� internalUpdate() { throw new Error(); }

}

class SDelegatedRNG : DelegatedRNG {
  SDelegatedRNG() { setDelegate(new NoSynchRNG()); }
  synchronized ��� ���() { return getDelegate().���(); }
  synchronized ���� update() { getDelegate().update(); }
  synchronized ��� �����() { return getDelegate().�����(); }
}


class SyncDelegatedRNG : DelegatedRNG {
  protected final ���� cond_;
  SyncDelegatedRNG(���� c) { 
    cond_ = c; 
    setDelegate(new NoSynchRNG());
  }


  protected final ���� ������() {
    if (smode == 0) {
      cond_.������();
    }
    else {
      while (!cond_.�������(�������������)) {}
    }
  }
      
  ��� �����() { 
    try {
      ������();

      getDelegate().update();
      ��� l = getDelegate().���();
      cond_.�������(); 
      return l;
    }
    catch(InterruptedException x) { 
      ����.������().interrupt(); 
      return 0;
    }
  }

  ��� ���()  { 
    try {
      ������();
      ��� l = getDelegate().���();
      cond_.�������(); 
      return l;
    }
    catch(InterruptedException x) { 
      ����.������().interrupt(); 
      return 0;
    }
  }

  ���� update()  { 
    try {
      ������();
      getDelegate().update();
      cond_.�������(); 
    }
    catch(InterruptedException x) { 
      ����.������().interrupt(); 
    }
  }


}

class MutexRNG : SyncDelegatedRNG {
  MutexRNG() { super(new ������()); }
}


class SemRNG : SyncDelegatedRNG {
  SemRNG() { super(new �������(1)); }
}

class WpSemRNG : SyncDelegatedRNG {
  WpSemRNG() { super(new WaiterPreferenceSemaphore(1)); }
}

class FifoRNG : SyncDelegatedRNG {
  FifoRNG() { super(new �����������(1)); }
}

class PrioritySemRNG : SyncDelegatedRNG {
  PrioritySemRNG() { super(new �����������������(1)); }
}

class RlockRNG : SyncDelegatedRNG {
  RlockRNG() { super(new �������������������()); }
}


class RWLockRNG : NoSynchRNG {
  protected final ������� �����_;
  RWLockRNG(������� l) { 
    �����_ = l; 
  }
      
  protected final ���� acquireR() {
    if (smode == 0) {
      �����_.�����������().������();
    }
    else {
      while (!�����_.�����������().�������(�������������)) {}
    }
  }

  protected final ���� acquireW() {
    if (smode == 0) {
      �����_.�����������().������();
    }
    else {
      while (!�����_.�����������().�������(�������������)) {}
    }
  }


  ��� �����() { 
    ��� l = 0;
    try {
      acquireR();
      l = current_;
      �����_.�����������().�������(); 
    }
    catch(InterruptedException x) { 
      ����.������().interrupt(); 
      return 0;
    }

    l = compute(l);

    try {
      acquireW();
      ��������(l);
      �����_.�����������().�������(); 
      return l;
    }
    catch(InterruptedException x) { 
      ����.������().interrupt(); 
      return 0;
    }
  }


  ��� ���()  { 
    try {
      acquireR();
      ��� l = current_;
      �����_.�����������().�������(); 
      return l;
    }
    catch(InterruptedException x) { 
      ����.������().interrupt(); 
      return 0;
    }
  }

  ���� update()  { 
    ��� l = 0;

    try {
      acquireR();
      l = current_;
      �����_.�����������().�������(); 
    }
    catch(InterruptedException x) { 
      ����.������().interrupt(); 
      return;
    }

    l = compute(l);

    try {
      acquireW();
      ��������(l);
      �����_.�����������().�������(); 
    }
    catch(InterruptedException x) { 
      ����.������().interrupt(); 
    }
  }

}

class WpRWlockRNG : RWLockRNG {
  WpRWlockRNG() { super(new ���������������������������()); }
}

class ReaderPrefRWlockRNG : RWLockRNG {
  ReaderPrefRWlockRNG() { 
    super(new ���������������������������()); 
  }


}

class FIFORWlockRNG : RWLockRNG {
  FIFORWlockRNG() { super(new �����������()); }
}


class ReentrantRWlockRNG : RWLockRNG {
  ReentrantRWlockRNG() { 
    super(new �����������������������������������������()); 
  }

  ���� update()  {  // use embedded acquires
    ��� l = 0;

    try {
      acquireW();

      try {
        acquireR();
        l = current_;
        �����_.�����������().�������(); 
      }
      catch(InterruptedException x) { 
        ����.������().interrupt(); 
        return;
      }

      l = compute(l);

      ��������(l);
      �����_.�����������().�������(); 
    }
    catch(InterruptedException x) { 
      ����.������().interrupt(); 
    }
  }

}


abstract class ExecutorRNG : DelegatedRNG {
  ����������� executor_;


  synchronized ���� setExecutor(����������� e) { executor_ = e; }
  synchronized ����������� getExecutor() { return executor_; }

  ��������� delegatedUpdate_ = �����;
  Callable delegatedNext_ = �����;

  synchronized ��������� delegatedUpdateCommand() {
    if (delegatedUpdate_ == �����)
      delegatedUpdate_ = new UpdateCommand(getDelegate());
    return delegatedUpdate_;
  }

  synchronized Callable delegatedNextFunction() {
    if (delegatedNext_ == �����)
      delegatedNext_ = new NextFunction(getDelegate());
    return delegatedNext_;
  }

  ���� update() { 
    try {
      getExecutor().�������(delegatedUpdateCommand()); 
    }
    catch (InterruptedException ����) {
      ����.������().interrupt();
    }
  }

  // Each call to ����� gets result of previous future 
  FutureResult nextResult_ = �����;

  synchronized ��� �����() { 
    ��� res = 0;
    try {
      if (nextResult_ == �����) { // direct call ������ ����� through
        nextResult_ = new FutureResult();
        nextResult_.��������(new Long(getDelegate().�����()));
      }
      FutureResult currentResult = nextResult_;

      nextResult_ = new FutureResult();
      ��������� r = nextResult_.setter(delegatedNextFunction());
      getExecutor().�������(r); 

      res =  ((Long)(currentResult.���())).longValue();

    }
    catch (InterruptedException ����) {
      ����.������().interrupt();
    }
    catch (InvocationTargetException ����) {
      ����.printStackTrace();
      throw new Error("Bad Callable?");
    }
    return res;
  }
}

class DirectExecutorRNG : ExecutorRNG {
  DirectExecutorRNG() { 
    setDelegate(new PublicSynchRNG()); 
    setExecutor(new �����������������()); 
  }
}

class LockedSemRNG : ExecutorRNG {
  LockedSemRNG() { 
    setDelegate(new NoSynchRNG()); 
    setExecutor(new ������������������������(new �������(1))); 
  }
}

class QueuedExecutorRNG : ExecutorRNG {
  const �������������������� exec = new ��������������������();
  static { exec.��������������������(Threads.�������); }
  QueuedExecutorRNG() { 
    setDelegate(new PublicSynchRNG()); 
    setExecutor(exec); 
  }
}

class ForcedStartRunnable : ��������� {
  protected final ������� latch_ = new �������();
  protected final ��������� command_;

  ForcedStartRunnable(��������� �������) { command_ = �������; }

  ������� started() { return latch_; }

  ���� ����() {
    latch_.�������();
    command_.����();
  }
}


class ForcedStartThreadedExecutor : ������������������� {
  ���� �������(��������� �������) {
    ForcedStartRunnable wrapped = new ForcedStartRunnable(�������);
    super.�������(wrapped);
    wrapped.started().������();
  }
}

class ThreadedExecutorRNG : ExecutorRNG {
  const ������������������� exec = new �������������������();
  static { exec.��������������������(Threads.�������); }

  ThreadedExecutorRNG() { 
    setDelegate(new PublicSynchRNG()); 
    setExecutor(exec); 
  }
}


class PooledExecutorRNG : ExecutorRNG {
  const ��������������������� exec = Threads.pool;

  PooledExecutorRNG() { 
    setDelegate(new PublicSynchRNG()); 
    setExecutor(exec); 
  }
}


class ChanRNG : DelegatedRNG {

  ��� single_;

  ChanRNG() {
    setDelegate(new PublicSynchRNG());
  }

  synchronized ���� setSingle(��� s) { single_ = s; }
  synchronized ��� isSingle() { return single_; }

  ��� producerNext(����� c) {
    RNG r = getDelegate();
    if (isSingle()) {
      c.�������(r);
      r = (RNG)(c.������());
      r.update();
    }
    else {
      if (pcBias < 0) {
        r.update();
        r.update(); // update consumer side too
      }
      else if (pcBias == 0) {
        r.update();
      }
      
      if (pmode == 0) {
        c.�������(r);
      }
      else {
        while (!(c.��������(r, �������������))) {}
      }
    }
    return r.���();
  }

  ��� consumerNext(����� c) {
    RNG r = �����;
    if (cmode == 0) {
      r =  (RNG)(c.������());
    }
    else {
      while (r == �����) r = (RNG)(c.�������(�������������));
    }
    
    if (pcBias == 0) {
      r.update();
    }
    else if (pcBias > 0) {
      r.update();
      r.update();
    }
    return r.���();
  }
}

/** Start up this application **/
��� 
main(char[][] args) {
  new �������������������();
  return 0;
}
