module conc.synchtimer;

import conc.all;

private import cidrus;
private import thread;


static цел[] nthreadsChoices = { 
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


enum РежимыСинх { РежимБлок, РежимТаймаута, };

class ТестированныйКласс(Cls,BuffCls)
 {
    final ткст name; 
    final Cls cls; 
    final бул multipleOK; 
    final бул singleOK;
    final BuffCls buffCls;
    бул enabled_ = да;
    synchronized проц активен(Бул b) { enabled_ = b; }
    synchronized бул активен() { return enabled_; }
    synchronized проц переключијктив() {
      enabled_ = !активен;
    }

    this(ткст n, Cls c, бул m, бул sok) {
      name = n; cls = c; multipleOK = m; singleOK = sok; 
      buffCls = пусто;
    }
    
    this(ткст n, Cls c, бул m, бул sok, BuffCls bc) {
      name = n; cls = c; multipleOK = m; singleOK = sok; 
      buffCls = bc;
    }
}

class ТаймерСинхронизации 
{


  static ТестированныйКласс[] классы;

  static this {
    классы ~= new ТестированныйКласс!(NoSynchRNG)("NoSynchronization", нет, да);
    классы ~= new ТестированныйКласс!(PublicSynchRNG)("PublicSynchronization", да, да);
    классы ~= new ТестированныйКласс!(SemRNG)("Семафор", да, да);
  }

  static ткст режим¬“кст(цел m);
  static ткст biasToString(цел b);
  static ткст p2ToString(цел n) ;
  
  const цел PRECISION = 10; // microseconds
    
  static ткст форматируй¬ремя(дол ns, бул showDecimal) ;
    
			  static class ИнфОНити
			  {
				final ткст name;
				final цел число;
				Бул активен;
				ИнфОНити(цел nthr) ;
				synchronized Бул дайјктив();
				synchronized проц установијктив(Бул v);
				synchronized проц переключијктив();
			  }

  final ИнфОНити[] инфОНити = new ИнфОНити[nthreadsChoices.length];

  бул нитьјктивирована(цел члонитей) ;
  
  final static цел headerRows = 1;
  final static цел classColumn = 0;
  final static цел headerColumns = 1;
  final цел tableRows = ТестированныйКласс.классы.length + headerRows;
  final цел tableColumns = nthreadsChoices.length + headerColumns;
  
  final JComponent[][] resultTable_ = new JComponent[tableRows][tableColumns];
  
  JPanel resultPanel() {

    JPanel[] colPanel = new JPanel[tableColumns];
    for (цел col = 0; col < tableColumns; ++col) {
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
    
    for (цел col = 1; col < tableColumns; ++col) {
      final цел члонитей = col - headerColumns;
      JCheckBox tcb = new JCheckBox(инфОНити[члонитей].name, да);
      tcb.addActionListener(new ActionListener() {
        проц actionPerformed(ActionEvent evt) {
          инфОНити[члонитей].переключијктив();
        }});
      
      
      tcb.setMinimumSize(labDim);
      tcb.setPreferredSize(labDim);
      tcb.setFont(font);
      tcb.setBackground(hdrbg);
      resultTable_[0][col] = tcb;
      colPanel[col].add(tcb);
    }
    
    
    for (цел row = 1; row < tableRows; ++row) {
      final цел cls = row - headerRows;
      
      JCheckBox cb = new JCheckBox(ТестированныйКласс.классы[cls].name, да); 
      cb.addActionListener(new ActionListener() {
        проц actionPerformed(ActionEvent evt) {
          ТестированныйКласс.классы[cls].переключијктив();
        }});
      
      resultTable_[row][0] = cb;
      cb.setMinimumSize(cbDim);
      cb.setPreferredSize(cbDim);
      cb.setFont(font);
      colPanel[0].add(cb);
      
      for (цел col = 1; col < tableColumns; ++col) {
        цел члонитей = col - headerColumns;
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
    for (цел col = 0; col < tableColumns; ++col) {
      tblPanel.add(colPanel[col]);
    }
    
    return tblPanel;
    
  }

  проц setTime(final дол ns, цел clsIdx, цел nthrIdx) {
    цел row = clsIdx+headerRows;
    цел col = nthrIdx+headerColumns;
    final JLabel cell = (JLabel)(resultTable_[row][col]);

    SwingUtilities.invokeLater(new ѕускаемый() {
      проц пуск() { 
        cell.setText(форматируй¬ремя(ns, да)); 
      } 
    });
  }
  
     

  проц clearTable() {
    for (цел i = 1; i < tableRows; ++i) {
      for (цел j = 1; j < tableColumns; ++j) {
        ((JLabel)(resultTable_[i][j])).setText("");
      }
    }
  }

  проц setChecks(final бул setting) {
    for (цел i = 0; i < ТестированныйКласс.классы.length; ++i) {
      ТестированныйКласс.классы[i].установијктив(new Бул(setting));
      ((JCheckBox)resultTable_[i+1][0]).setSelected(setting);
    }
  }


  ТаймерСинхронизации() { 
    for (цел i = 0; i < инфОНити.length; ++i) 
      инфОНити[i] = new ИнфОНити(nthreadsChoices[i]);

  }
  
  final Синхрон÷ел nextClassIdx_ = new Синхрон÷ел(0);
  final Синхрон÷ел nextThreadIdx_ = new Синхрон÷ел(0);


  JPanel mainPanel() {
    new PrintStart(); // classloader bug workaround
    JPanel paramPanel = new JPanel();
    paramPanel.setLayout(new GridLayout(5, 3));

    JPanel buttonPanel = new JPanel();
    buttonPanel.setLayout(new GridLayout(1, 3));
    
    startstop_.addActionListener(new ActionListener() {
      проц actionPerformed(ActionEvent evt) {
        if (running_.дай()) 
          cancel();
        else {
          try { 
            startTestSeries(new TestSeries());  
          }
          catch (InterruptedException искл) { 
            endTestSeries(); 
          }
        }
      }});
    
    paramPanel.add(startstop_);
    
    JPanel p1 = new JPanel();
    p1.setLayout(new GridLayout(1, 2));
    
    JButton continueButton = new JButton("Continue");

    continueButton.addActionListener(new ActionListener() {
      проц actionPerformed(ActionEvent evt) {
        if (!running_.дай()) {
          try { 
            startTestSeries(new TestSeries(nextClassIdx_.дай(),
                                           nextThreadIdx_.дай()));  
          }
          catch (InterruptedException искл) { 
            endTestSeries(); 
          }
        }
      }});

    p1.add(continueButton);

    JButton clearButton = new JButton("Clear cells");
    
    clearButton.addActionListener(new ActionListener(){
      проц actionPerformed(ActionEvent evt) {
        clearTable();
      }
    });

    p1.add(clearButton);

    paramPanel.add(p1);

    JPanel p3 = new JPanel();
    p3.setLayout(new GridLayout(1, 2));
    
    JButton setButton = new JButton("All классы");
    
    setButton.addActionListener(new ActionListener(){
      проц actionPerformed(ActionEvent evt) {
        setChecks(да);
      }
    });

    p3.add(setButton);


    JButton unsetButton = new JButton("No классы");
    
    unsetButton.addActionListener(new ActionListener(){
      проц actionPerformed(ActionEvent evt) {
        setChecks(нет);
      }
    });

    p3.add(unsetButton);
    paramPanel.add(p3);

    JPanel p2 = new JPanel();
    //    p2.setLayout(new GridLayout(1, 2));
    p2.setLayout(new BoxLayout(p2, BoxLayout.X_AXIS));


    JCheckBox consoleBox = new JCheckBox("Console echo");
    consoleBox.addItemListener(new ItemListener() {
      проц itemStateChanged(ItemEvent evt) {
        echoToSystemOut.комплемент();
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
    
    for (цел j = 0; j < РежимыСинх.length; ++j) {
      ткст lab = "Locks: " + режим¬“кст(РежимыСинх[j]);
      syncModeComboBox.addItem(lab);
    }
    syncModeComboBox.addItemListener(new ItemListener() {
      проц itemStateChanged(ItemEvent evt) {
        JComboBox src = (JComboBox)(evt.getItemSelectable());
        цел инд = src.getSelectedIndex();
        RNG.syncMode.установи(РежимыСинх[инд]);
      }
    });
    
    RNG.syncMode.установи(РежимыСинх[0]);
    syncModeComboBox.setSelectedIndex(0);
    return syncModeComboBox;
  }

  JComboBox producerSyncModePanel() {
    JComboBox producerSyncModeComboBox = new JComboBox();
    
    for (цел j = 0; j < РежимыСинх.length; ++j) {
      ткст lab = "Producers: " + режим¬“кст(РежимыСинх[j]);
      producerSyncModeComboBox.addItem(lab);
    }
    producerSyncModeComboBox.addItemListener(new ItemListener() {
      проц itemStateChanged(ItemEvent evt) {
        JComboBox src = (JComboBox)(evt.getItemSelectable());
        цел инд = src.getSelectedIndex();
        RNG.producerMode.установи(РежимыСинх[инд]);
      }
    });
    
    RNG.producerMode.установи(РежимыСинх[0]);
    producerSyncModeComboBox.setSelectedIndex(0);
    return producerSyncModeComboBox;
  }

  JComboBox consumerSyncModePanel() {
    JComboBox consumerSyncModeComboBox = new JComboBox();
    
    for (цел j = 0; j < РежимыСинх.length; ++j) {
      ткст lab = "Consumers: " + режим¬“кст(РежимыСинх[j]);
      consumerSyncModeComboBox.addItem(lab);
    }
    consumerSyncModeComboBox.addItemListener(new ItemListener() {
      проц itemStateChanged(ItemEvent evt) {
        JComboBox src = (JComboBox)(evt.getItemSelectable());
        цел инд = src.getSelectedIndex();
        RNG.consumerMode.установи(РежимыСинх[инд]);
      }
    });
    
    RNG.consumerMode.установи(РежимыСинх[0]);
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
    
    for (цел j = 0; j < contentionChoices.length; ++j) {
      ткст lab = contentionChoices[j].asDouble() * 100.0 + 
        "% contention/sharing";
      contentionComboBox.addItem(lab);
    }
    contentionComboBox.addItemListener(new ItemListener() {
      проц itemStateChanged(ItemEvent evt) {
        JComboBox src = (JComboBox)(evt.getItemSelectable());
        цел инд = src.getSelectedIndex();
        contention_.установи(contentionChoices[инд]);
      }
    });
    
    contention_.установи(contentionChoices[3]);
    contentionComboBox.setSelectedIndex(3);
    return contentionComboBox;
  }
  
  JComboBox itersBox() {
    final цел[] loopsPerTestChoices = { 
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
    
    for (цел j = 0; j < loopsPerTestChoices.length; ++j) {
      ткст lab = p2ToString(loopsPerTestChoices[j]) + 
        " calls per нить per test";
      precComboBox.addItem(lab);
    }
    precComboBox.addItemListener(new ItemListener() {
      проц itemStateChanged(ItemEvent evt) {
        JComboBox src = (JComboBox)(evt.getItemSelectable());
        цел инд = src.getSelectedIndex();
        loopsPerTest_.установи(loopsPerTestChoices[инд]);
      }
    });
    
    loopsPerTest_.установи(loopsPerTestChoices[8]);
    precComboBox.setSelectedIndex(8);

    return precComboBox;
  }
  
  JComboBox cloopBox() {
    final цел[] computationsPerCallChoices = { 
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
    
    for (цел j = 0; j < computationsPerCallChoices.length; ++j) {
      ткст lab = p2ToString(computationsPerCallChoices[j]) + 
        " computations per call";
      cloopComboBox.addItem(lab);
    }
    cloopComboBox.addItemListener(new ItemListener() {
      проц itemStateChanged(ItemEvent evt) {
        JComboBox src = (JComboBox)(evt.getItemSelectable());
        цел инд = src.getSelectedIndex();
        RNG.computeLoops.установи(computationsPerCallChoices[инд]);
      }
    });
    
    RNG.computeLoops.установи(computationsPerCallChoices[3]);
    cloopComboBox.setSelectedIndex(3);
    return cloopComboBox;
  }
  
  JComboBox barrierBox() {
    final цел[] itersPerBarrierChoices = { 
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
    
    for (цел j = 0; j < itersPerBarrierChoices.length; ++j) {
      ткст lab = p2ToString(itersPerBarrierChoices[j]) + 
        " iterations per барьер";
      barrierComboBox.addItem(lab);
    }
    barrierComboBox.addItemListener(new ItemListener() {
      проц itemStateChanged(ItemEvent evt) {
        JComboBox src = (JComboBox)(evt.getItemSelectable());
        цел инд = src.getSelectedIndex();
        RNG.itersPerBarrier.установи(itersPerBarrierChoices[инд]);
      }
    });
    
    RNG.itersPerBarrier.установи(itersPerBarrierChoices[13]);
    barrierComboBox.setSelectedIndex(13);

    //    RNG.itersPerBarrier.установи(itersPerBarrierChoices[15]);
    //    barrierComboBox.setSelectedIndex(15);

    return barrierComboBox;
  }
  
  JComboBox exchangeBox() {
    final цел[] exchangerChoices = { 
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
    
    for (цел j = 0; j < exchangerChoices.length; ++j) {
      ткст lab = p2ToString(exchangerChoices[j]) + 
        " max threads per барьер";
      exchComboBox.addItem(lab);
    }
    exchComboBox.addItemListener(new ItemListener() {
      проц itemStateChanged(ItemEvent evt) {
        JComboBox src = (JComboBox)(evt.getItemSelectable());
        цел инд = src.getSelectedIndex();
        RNG.exchangeParties.установи(exchangerChoices[инд]);
      }
    });
    
    RNG.exchangeParties.установи(exchangerChoices[1]);
    exchComboBox.setSelectedIndex(1);
    return exchComboBox;
  }
  
  JComboBox biasBox() {
    final цел[] biasChoices = { 
      -1, 
      0, 
      1 
    };
    
    
    JComboBox biasComboBox = new JComboBox();
    
    for (цел j = 0; j < biasChoices.length; ++j) {
      ткст lab = biasToString(biasChoices[j]);
      biasComboBox.addItem(lab);
    }
    biasComboBox.addItemListener(new ItemListener() {
      проц itemStateChanged(ItemEvent evt) {
        JComboBox src = (JComboBox)(evt.getItemSelectable());
        цел инд = src.getSelectedIndex();
        RNG.bias.установи(biasChoices[инд]);
      }
    });
    
    RNG.bias.установи(biasChoices[1]);
    biasComboBox.setSelectedIndex(1);
    return biasComboBox;
  }
  
  JComboBox capacityBox() {
    
    final цел[] bufferCapacityChoices = {
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
    
    for (цел j = 0; j < bufferCapacityChoices.length; ++j) {
      ткст lab = p2ToString(bufferCapacityChoices[j]) + 
        " element bounded buffers";
      bcapComboBox.addItem(lab);
    }
    bcapComboBox.addItemListener(new ItemListener() {
      проц itemStateChanged(ItemEvent evt) {
        JComboBox src = (JComboBox)(evt.getItemSelectable());
        цел инд = src.getSelectedIndex();
        ƒефолтная®мкость анала.установи(bufferCapacityChoices[инд]);
      }
    });
    
    
    ƒефолтная®мкость анала.установи(bufferCapacityChoices[3]);
    bcapComboBox.setSelectedIndex(3);
    return bcapComboBox;
  }
  
  JComboBox timeoutBox() {
    
    
    final дол[] timeoutChoices = {
      0,
      1,
      10,
      100,
      1000,
      10000,
      100000,
    };
    
    
    JComboBox timeoutComboBox = new JComboBox();
    
    for (цел j = 0; j < timeoutChoices.length; ++j) {
      ткст lab = timeoutChoices[j] + " msec timeouts";
      timeoutComboBox.addItem(lab);
    }
    timeoutComboBox.addItemListener(new ItemListener() {
      проц itemStateChanged(ItemEvent evt) {
        JComboBox src = (JComboBox)(evt.getItemSelectable());
        цел инд = src.getSelectedIndex();
        RNG.таймаут.установи(timeoutChoices[инд]);
      }
    });
    
    RNG.таймаут.установи(timeoutChoices[3]);
    timeoutComboBox.setSelectedIndex(3);
    return timeoutComboBox;
  }

  ClockDaemon timeDaemon = new ClockDaemon();
  
  проц startPoolStatus(final JLabel status) {
    ѕускаемый updater = new ѕускаемый() {
      цел lastps = 0;
      проц пуск() {
        final цел ps = Threads.activeThreads.дай();
        if (lastps != ps) {
          lastps = ps;
          SwingUtilities.invokeLater(new ѕускаемый() {
            проц пуск() {
              status.setText("Active threads: " + ps);
            } } );
        }
      }
    };
    timeDaemon.executePeriodically(250, updater, нет);
  }

  private final SynchronizedRef contention_ = new SynchronizedRef(пусто);
  private final Синхрон÷ел loopsPerTest_ = new Синхрон÷ел(0);

  private final SynchronizedBool echoToSystemOut = 
      new SynchronizedBool(нет);


  private final JButton startstop_ = new JButton("Start");
  
  private WaitableInt testNumber_ = new WaitableInt(1);

  private проц runOneTest(ѕускаемый tst) { 
    цел nt = testNumber_.дай(); 
    Threads.pool.выполни(tst);
    testNumber_.whenNotEqual(nt, пусто);
  }

  private проц endOneTest() {
    testNumber_.increment();
  }

  private SynchronizedBool running_ = new SynchronizedBool(нет);

  проц cancel() { 
    //  not stable enough to cancel during construction
    synchronized (RNG.constructionLock) {
      try {
        Threads.pool.прерви¬се();
      }
      catch(»скл искл) {
        System.out.println("\nException during cancel:\n" + искл);
        return;
      }
    }
  }


  проц startTestSeries(ѕускаемый tst) {
    running_.установи(да);
    startstop_.setText("Stop");
    Threads.pool.выполни(tst);
  }

  // prevent odd class-gc problems on some VMs?
  class PrintStart : ѕускаемый {
    проц пуск() {
      startstop_.setText("Start");
    } 
  } 


  проц endTestSeries() {
    running_.установи(нет);
    SwingUtilities.invokeLater(new PrintStart());
  }

  /*
  проц old_endTestSeries() {
    running_.установи(нет);
    SwingUtilities.invokeLater(new ѕускаемый() {
      проц пуск() {
        startstop_.setText("Start");
      } } );
  }
  */

  class TestSeries : ѕускаемый {
    final цел firstclass;
    final цел firstnthreads;

    TestSeries() { 
      firstclass = 0;
      firstnthreads = 0;
    }

    TestSeries(final цел firstc, final цел firstnt) { 
      firstclass = firstc;
      firstnthreads = firstnt;
    }

    проц пуск() {
      Нить.дайЭту().setPriority(Нить.NORM_PRIORITY);

      try {
        цел t = firstnthreads; 
        цел c = firstclass;

        if (t < nthreadsChoices.length &&
            c < ТестированныйКласс.классы.length) {

          for (;;) {

            
            // these checks are duplicated in OneTest, but added here
            // to minimize unecessary нить construction, 
            // which can skew results

            if (нитьјктивирована(t)) {

              ТестированныйКласс entry = ТестированныйКласс.классы[c];
        
              цел члонитей = nthreadsChoices[t];
              цел iters = loopsPerTest_.дай();
              Fraction pshr = (Fraction)(contention_.дай());
        
              if (entry.isEnabled(члонитей, pshr)) {

                runOneTest(new OneTest(c, t));
              }
            }

            if (++c >= ТестированныйКласс.классы.length) {
              c = 0;
              if (++t >= nthreadsChoices.length) 
                break;
            }

            nextClassIdx_.установи(c);
            nextThreadIdx_.установи(t);
            
          }
        }

      }
      catch (InterruptedException искл) { 
        Нить.дайЭту().interrupt();
      }
      finally {
        endTestSeries();
      }
    }
  }

  static class BarrierTimer : ѕускаемый {
    private дол startTime_ = 0;
    private дол endTime_ = 0;

    synchronized дол getTime() {
      return endTime_ - startTime_;
    }

    synchronized проц пуск() {
      дол now = System.currentTimeMillis();
      if (startTime_ == 0) 
        startTime_ = now;
      else
        endTime_ = now;
    }
  }
      
  class OneTest : ѕускаемый {
    final цел clsIdx; 
    final цел nthreadsIdx; 

    OneTest(цел инд, цел t) {
      clsIdx = инд; 
      nthreadsIdx = t; 
    }

    проц пуск() {
      Нить.дайЭту().setPriority(Нить.NORM_PRIORITY-3);

      бул wasInterrupted = нет;

      final ТестированныйКласс entry = ТестированныйКласс.классы[clsIdx];

      final JLabel cell = (JLabel)(resultTable_[clsIdx+1][nthreadsIdx+1]);
      final Color oldfg =  cell.getForeground();

      try {


        if (Нить.interrupted()) return;
        if (!нитьјктивирована(nthreadsIdx)) return;
        
        цел члонитей = nthreadsChoices[nthreadsIdx];
        цел iters = loopsPerTest_.дай();
        Fraction pshr = (Fraction)(contention_.дай());
        
        if (!entry.isEnabled(члонитей, pshr))  return;

        BarrierTimer timer = new BarrierTimer();
        ÷иклическийЅарьер барьер = new ÷иклическийЅарьер(члонитей+1, timer);

        Class cls = entry.cls;
        Class chanCls = entry.buffCls;

        try {
          SwingUtilities.invokeAndWait(new ѕускаемый() {
            проц пуск() {
              cell.setForeground(Color.blue);
              cell.setText("RUN");
              cell.repaint();
            }
          });
        }
        catch (InvocationTargetException искл) {
          искл.printStackTrace();
          System.exit(-1);
        }
        synchronized (RNG.constructionLock) {
          RNG.reset(члонитей);

          if (chanCls == пусто) {
            RNG shared = (RNG)(cls.newInstance());
            for (цел k = 0; k < члонитей; ++k) {
              RNG pri = (RNG)(cls.newInstance());
              TestLoop l = new TestLoop(shared, pri, pshr, iters, барьер);
              Threads.pool.выполни(l.testLoop());
            }
          }
          else {
             анал shared = ( анал)(chanCls.newInstance());
            if (члонитей == 1) {
              ChanRNG single = (ChanRNG)(cls.newInstance());
              single.setSingle(да);
              PCTestLoop l = new PCTestLoop(single.getDelegate(), single, pshr,
                                            iters, барьер,
                                            shared, shared);
              Threads.pool.выполни(l.testLoop(да));
            }
            else if (члонитей % 2 != 0) 
              throw new Error("Must have even число of threads!");
            else {
              цел npairs = члонитей / 2;
              
              for (цел k = 0; k < npairs; ++k) {
                ChanRNG t = (ChanRNG)(cls.newInstance());
                t.setSingle(нет);
                 анал chan = ( анал)(chanCls.newInstance());
                
                PCTestLoop l = new PCTestLoop(t.getDelegate(), t, pshr, 
                                              iters, барьер,
                                              shared, chan);
                
                Threads.pool.выполни(l.testLoop(нет));
                Threads.pool.выполни(l.testLoop(да));
                
              }
            }
          }

          if (echoToSystemOut.дай()) {
            System.out.print(
                             entry.name + " " +
                             члонитей + "T " +
                             pshr + "S " +
                             RNG.computeLoops.дай() + "I " +
                             RNG.syncMode.дай() + "Lm " +
                             RNG.таймаут.дай() + "TO " +
                             RNG.producerMode.дай() + "Pm " +
                             RNG.consumerMode.дай() + "Cm " +
                             RNG.bias.дай() + "B " +
                             ƒефолтная®мкость анала.дай() + "C " +
                             RNG.exchangeParties.дай() + "Xp " +
                             RNG.itersPerBarrier.дай() + "Ib : "
                             );
          }

        }
        
        // Uncomment if AWT doesn't update right
        //        Нить.sleep(100);

        барьер.барьер(); // старт

        барьер.барьер(); // stop

        дол tm = timer.getTime();
        дол totalIters = члонитей * iters;
        double dns = tm * 1000.0 * PRECISION / totalIters;
        дол ns = Math.round(dns);

        setTime(ns, clsIdx, nthreadsIdx);

        if (echoToSystemOut.дай()) {
          System.out.println(форматируй¬ремя(ns, да));
        }

      }
      catch (»скл—ломанногоЅарьера искл) { 
        wasInterrupted = да;
      }
      catch (InterruptedException искл) {
        wasInterrupted = да;
        Нить.дайЭту().interrupt();
      }
      catch (»скл искл) { 
        искл.printStackTrace();
        System.out.println("Construction »скл?");
        System.exit(-1);
      }
      finally {
        final бул clear = wasInterrupted;
        SwingUtilities.invokeLater(new ѕускаемый() {
          проц пуск() {
            if (clear) cell.setText("");
            cell.setForeground(oldfg);
            cell.repaint();
          }
        });

        Нить.дайЭту().setPriority(Нить.NORM_PRIORITY);
        endOneTest();
      }
    }
  }

}

class Threads : ‘абрикаНитей {

  static final Синхрон÷ел activeThreads = new Синхрон÷ел(0);

  static final Threads фабрика = new Threads();

  static final  атушечный»сполнитель pool = new  атушечный»сполнитель();

  static { 
    pool.установи¬ремяјктивности(10000); 
    pool.установи‘абрикуНитей(фабрика);
  }

  static class MyThread : Нить {
    MyThread(ѕускаемый cmd) { 
      super(cmd); 
    }

    проц пуск() {
      activeThreads.increment();

      try {
        super.пуск();
      }
      finally {
        activeThreads.decrement();
      }
    }
  }

  Нить новаяНить(ѕускаемый cmd) {
    return new MyThread(cmd);
  }
}



class TestLoop {

  final RNG shared;
  final RNG primary;
  final цел iters;
  final Fraction pshared;
  final ÷иклическийЅарьер барьер;
  final бул[] useShared;
  final цел firstidx;

  TestLoop(RNG sh, RNG pri, Fraction pshr, цел it, ÷иклическийЅарьер br) {
    shared = sh; 
    primary = pri; 
    pshared = pshr; 
    iters = it; 
    барьер = br; 

    firstidx = (цел)(primary.дай());

    цел num = (цел)(pshared.numerator());
    цел denom = (цел)(pshared.denominator());

    if (num == 0 || primary == shared) {
      useShared = new бул[1];
      useShared[0] = нет;
    }
    else if (num >= denom) {
      useShared = new бул[1];
      useShared[0] = да;
    }
    else {
      // create бул array and randomize it.
      // This ensures that always same число of shared calls.

      // denom slots is too few. iters is too many. an arbitrary compromise is:
      цел xfactor = 1024 / denom;
      if (xfactor < 1) xfactor = 1;
      useShared = new бул[denom * xfactor];
      for (цел i = 0; i < num * xfactor; ++i) 
        useShared[i] = да;
      for (цел i = num * xfactor; i < denom  * xfactor; ++i) 
        useShared[i] = нет;

      for (цел i = 1; i < useShared.length; ++i) {
        цел j = ((цел) (shared.следщ() & 0x7FFFFFFF)) % (i + 1);
        бул tmp = useShared[i];
        useShared[i] = useShared[j];
        useShared[j] = tmp;
      }
    }
  }

  ѕускаемый testLoop() {
    return new ѕускаемый() {
      проц пуск() {
        цел itersPerBarrier = RNG.itersPerBarrier.дай();
        try {
          цел delta = -1;
          if (primary.getClass().equals(PrioritySemRNG.class)) {
            delta = 2 - (цел)((primary.дай() % 5));
          }
          Нить.дайЭту().setPriority(Нить.NORM_PRIORITY+delta);
          
          цел nshared = (цел)(iters * pshared.asDouble());
          цел nprimary = iters - nshared;
          цел инд = firstidx;
          
          барьер.барьер();
          
          for (цел i = iters; i > 0; --i) {
            ++инд;
            if (i % itersPerBarrier == 0)
              primary.exchange();
            else {
              
              RNG r;
              
              if (nshared > 0 && useShared[инд % useShared.length]) {
                --nshared;
                r = shared;
              }
              else {
                --nprimary;
                r = primary;
              }
              дол rnd = r.следщ();
              if (rnd % 2 == 0 && Нить.дайЭту().isInterrupted()) 
                break;
            }
          }
        }
        catch (»скл—ломанногоЅарьера искл) {
        }
        catch (InterruptedException искл) {
          Нить.дайЭту().interrupt();
        }
        finally {
          try {
            барьер.барьер();
          }
          catch (»скл—ломанногоЅарьера искл) { 
          }
          catch (InterruptedException искл) {
            Нить.дайЭту().interrupt();
          }
          finally {
            Нить.дайЭту().setPriority(Нить.NORM_PRIORITY);
          }

        }
      }
    };
  }
}

class PCTestLoop : TestLoop {
  final  анал primaryChannel;
  final  анал sharedChannel;

  PCTestLoop(RNG sh, RNG pri, Fraction pshr, цел it, 
    ÷иклическийЅарьер br,  анал shChan,  анал priChan) {
    super(sh, pri, pshr, it, br);
    sharedChannel = shChan;
    primaryChannel = priChan;
  }

  ѕускаемый testLoop(final бул isProducer) {
    return new ѕускаемый() {
      проц пуск() {
        цел delta = -1;
        Нить.дайЭту().setPriority(Нить.NORM_PRIORITY+delta);
        цел itersPerBarrier = RNG.itersPerBarrier.дай();
        try { 
          
          цел nshared = (цел)(iters * pshared.asDouble());
          цел nprimary = iters - nshared;
          цел инд = firstidx;
          
          барьер.барьер(); 
          
          ChanRNG target = (ChanRNG)(primary);
          
          for (цел i = iters; i > 0; --i) {
            ++инд;
            if (i % itersPerBarrier == 0)
              primary.exchange();
            else {
               анал c;
            
              if (nshared > 0 && useShared[инд % useShared.length]) {
                --nshared;
                c = sharedChannel;
              }
              else {
                --nprimary;
                c = primaryChannel;
              }
              
              дол rnd;
              if (isProducer) 
                rnd = target.producerNext(c);
              else 
                rnd = target.consumerNext(c);
              
              if (rnd % 2 == 0 && Нить.дайЭту().isInterrupted()) 
                break;
            }
          }
        }
        catch (»скл—ломанногоЅарьера искл) {
        }
        catch (InterruptedException искл) {
          Нить.дайЭту().interrupt();
        }
        finally {
          try {
            барьер.барьер();
          }
          catch (InterruptedException искл) {
            Нить.дайЭту().interrupt();
          }
          catch (»скл—ломанногоЅарьера искл) { 
          }
          finally {
            Нить.дайЭту().setPriority(Нить.NORM_PRIORITY);
          }
        }
      }
    };
  }
}

// -------------------------------------------------------------


abstract class RNG {
  const цел firstSeed = 4321;
  const цел rmod = 2147483647;
  const цел rmul = 16807;

  const цел lastSeed = firstSeed;
  const цел smod = 32749;
  const цел smul = 3125;

  const Объект constructionLock = RNG.class;

  // Use construction замок for all params to disable
  // changes in midst of construction of test объекты.

  const Синхрон÷ел computeLoops = 
    new Синхрон÷ел(16, constructionLock);
  const Синхрон÷ел syncMode = 
    new Синхрон÷ел(0, constructionLock);
  const Синхрон÷ел producerMode = 
    new Синхрон÷ел(0, constructionLock);
  const Синхрон÷ел consumerMode = 
    new Синхрон÷ел(0, constructionLock);
  const Синхрон÷ел bias = 
    new Синхрон÷ел(0, constructionLock);
  const SynchronizedLong таймаут = 
    new SynchronizedLong(100, constructionLock);
  const Синхрон÷ел exchangeParties = 
    new Синхрон÷ел(1, constructionLock);
  const Синхрон÷ел sequenceNumber = 
    new Синхрон÷ел(0, constructionLock);
  const Синхрон÷ел itersPerBarrier = 
    new Синхрон÷ел(0, constructionLock);

  static –андеву[] exchangers_;

  static проц reset(цел члонитей) {
    synchronized(constructionLock) {
      sequenceNumber.установи(-1);
      цел участники = exchangeParties.дай();
      if (члонитей < участники) участники = члонитей;
      if (члонитей % участники != 0) 
        throw new Error("need even multiple of участники");
      exchangers_ = new –андеву[члонитей / участники];
      for (цел i = 0; i < exchangers_.length; ++i) {
        exchangers_[i] = new –андеву(участники);
      }
    }
  }

  static дол nextSeed() {
    synchronized(constructionLock) {
      дол s = lastSeed;
      lastSeed = (lastSeed * smul) % smod;
      if (lastSeed == 0) 
        lastSeed = (цел)(clock());
      return s;
    }
  }

  final цел cloops = computeLoops.дай();
  final цел pcBias = bias.дай();
  final цел smode = syncMode.дай();
  final цел pmode = producerMode.дай();
  final цел cmode = consumerMode.дай();
  final дол времяОжидания = таймаут.дай();
  –андеву exchanger_ = пусто;

  synchronized –андеву getExchanger() {
    if (exchanger_ == пусто) {
      synchronized (constructionLock) {
        цел инд = sequenceNumber.increment();
        exchanger_ = exchangers_[инд % exchangers_.length];
      }
    }
    return exchanger_;
  }

  проц exchange() {
    –андеву искл = getExchanger(); 
    ѕускаемый r = (ѕускаемый)(искл.рандеву(new UpdateCommand(this)));
    if (r != пусто) r.пуск();
  }

  цел compareTo(Объект другое) {
    цел h1 = hashCode();
    цел h2 = другое.hashCode();
    if (h1 < h2) return -1;
    else if (h1 > h2) return 1;
    else return 0;
  }

  protected final дол compute(дол l) { 
    цел loops = (цел)((l & 0x7FFFFFFF) % (cloops * 2)) + 1;
    for (цел i = 0; i < loops; ++i) l = (l * rmul) % rmod;
    return (l == 0)? firstSeed : l; 
  }

  abstract protected проц установи(дол l);
  abstract protected дол internalGet();
  abstract protected проц internalUpdate();

  дол дай()    { return internalGet(); }
  проц update() { internalUpdate();  }
  дол следщ()   { internalUpdate(); return internalGet(); }
}


class UpdateCommand {
  private final RNG obj_;
  final дол cmpVal;
  UpdateCommand(RNG o) { 
    obj_ = o; 
    cmpVal = o.дай();
  }

  цел пуск() { obj_.update(); return 0;} 

  цел compareTo(Объект x) {
    UpdateCommand u = (UpdateCommand)x;
    if (cmpVal < u.cmpVal) return -1;
    else if (cmpVal > u.cmpVal) return 1;
    else return 0;
  }
}


class GetFunction : Callable {
  private final RNG obj_;
  GetFunction(RNG o) { obj_ = o;  }
  Объект call() { return new Long(obj_.дай()); } 
}

class NextFunction : Callable {
  private final RNG obj_;
  NextFunction(RNG o) { obj_ = o;  }
  Объект call() { return new Long(obj_.следщ()); } 
}


class NoSynchRNG : RNG {
  protected дол current_ = nextSeed();

  protected проц установи(дол l) { current_ = l; }
  protected дол internalGet() { return current_; }  
  protected проц internalUpdate() { установи(compute(internalGet())); }
}

class PublicSynchRNG : NoSynchRNG {
  synchronized дол дай() { return internalGet(); }  
  synchronized проц update() { internalUpdate();  }
  synchronized дол следщ() { internalUpdate(); return internalGet(); }
}

class AllSynchRNG : PublicSynchRNG {
  protected synchronized проц установи(дол l) { current_ = l; }
  protected synchronized дол internalGet() { return current_; }
  protected synchronized проц internalUpdate() { установи(compute(internalGet())); }
}


class AClongRNG : RNG {
  protected final SynchronizedLong acurrent_ = 
    new SynchronizedLong(nextSeed());

  protected проц установи(дол l) { throw new Error("No установи allowed"); }
  protected дол internalGet() { return acurrent_.дай(); }

  protected проц internalUpdate() { 
    цел retriesBeforeSleep = 100;
    цел maxSleepTime = 100;
    цел retries = 0;
    for (;;) {
      дол v = internalGet();
      дол n = compute(v);
      if (acurrent_.commit(v, n))
        return;
      else if (++retries >= retriesBeforeSleep) {
        try {
          Нить.sleep(n % maxSleepTime);
        }
        catch (InterruptedException искл) {
          Нить.дайЭту().interrupt();
        }
        retries = 0;
      }
    }        
  }
  
}

class SynchLongRNG : RNG {
  protected final SynchronizedLong acurrent_ = 
    new SynchronizedLong(nextSeed());

  protected проц установи(дол l) { acurrent_.установи(l); }
  protected дол internalGet() { return acurrent_.дай(); }
  protected проц internalUpdate() { установи(compute(internalGet())); }
  
}

abstract class DelegatedRNG : RNG  {
  protected RNG delegate_ = пусто;
  synchronized проц setDelegate(RNG d) { delegate_ = d; }
  protected synchronized RNG getDelegate() { return delegate_; }

  дол дай() { return getDelegate().дай(); }
  проц update() { getDelegate().update(); }
  дол следщ() { return getDelegate().следщ(); }

  protected проц установи(дол l) { throw new Error(); }
  protected дол internalGet() { throw new Error(); }
  protected проц internalUpdate() { throw new Error(); }

}

class SDelegatedRNG : DelegatedRNG {
  SDelegatedRNG() { setDelegate(new NoSynchRNG()); }
  synchronized дол дай() { return getDelegate().дай(); }
  synchronized проц update() { getDelegate().update(); }
  synchronized дол следщ() { return getDelegate().следщ(); }
}


class SyncDelegatedRNG : DelegatedRNG {
  protected final Синх cond_;
  SyncDelegatedRNG(Синх c) { 
    cond_ = c; 
    setDelegate(new NoSynchRNG());
  }


  protected final проц обрети() {
    if (smode == 0) {
      cond_.обрети();
    }
    else {
      while (!cond_.пытайся(времяОжидания)) {}
    }
  }
      
  дол следщ() { 
    try {
      обрети();

      getDelegate().update();
      дол l = getDelegate().дай();
      cond_.отпусти(); 
      return l;
    }
    catch(InterruptedException x) { 
      Нить.дайЭту().interrupt(); 
      return 0;
    }
  }

  дол дай()  { 
    try {
      обрети();
      дол l = getDelegate().дай();
      cond_.отпусти(); 
      return l;
    }
    catch(InterruptedException x) { 
      Нить.дайЭту().interrupt(); 
      return 0;
    }
  }

  проц update()  { 
    try {
      обрети();
      getDelegate().update();
      cond_.отпусти(); 
    }
    catch(InterruptedException x) { 
      Нить.дайЭту().interrupt(); 
    }
  }


}

class MutexRNG : SyncDelegatedRNG {
  MutexRNG() { super(new ћютекс()); }
}


class SemRNG : SyncDelegatedRNG {
  SemRNG() { super(new Семафор(1)); }
}

class WpSemRNG : SyncDelegatedRNG {
  WpSemRNG() { super(new WaiterPreferenceSemaphore(1)); }
}

class FifoRNG : SyncDelegatedRNG {
  FifoRNG() { super(new Семафорѕ¬ѕ¬(1)); }
}

class PrioritySemRNG : SyncDelegatedRNG {
  PrioritySemRNG() { super(new СемафорПриоритетов(1)); }
}

class RlockRNG : SyncDelegatedRNG {
  RlockRNG() { super(new ¬озобновляемый«амок()); }
}


class RWLockRNG : NoSynchRNG {
  protected final ЧЗЗамок замок_;
  RWLockRNG(ЧЗЗамок l) { 
    замок_ = l; 
  }
      
  protected final проц acquireR() {
    if (smode == 0) {
      замок_.замокЧтения().обрети();
    }
    else {
      while (!замок_.замокЧтения().пытайся(времяОжидания)) {}
    }
  }

  protected final проц acquireW() {
    if (smode == 0) {
      замок_.замокЗаписи().обрети();
    }
    else {
      while (!замок_.замокЗаписи().пытайся(времяОжидания)) {}
    }
  }


  дол следщ() { 
    дол l = 0;
    try {
      acquireR();
      l = current_;
      замок_.замокЧтения().отпусти(); 
    }
    catch(InterruptedException x) { 
      Нить.дайЭту().interrupt(); 
      return 0;
    }

    l = compute(l);

    try {
      acquireW();
      установи(l);
      замок_.замокЗаписи().отпусти(); 
      return l;
    }
    catch(InterruptedException x) { 
      Нить.дайЭту().interrupt(); 
      return 0;
    }
  }


  дол дай()  { 
    try {
      acquireR();
      дол l = current_;
      замок_.замокЧтения().отпусти(); 
      return l;
    }
    catch(InterruptedException x) { 
      Нить.дайЭту().interrupt(); 
      return 0;
    }
  }

  проц update()  { 
    дол l = 0;

    try {
      acquireR();
      l = current_;
      замок_.замокЧтения().отпусти(); 
    }
    catch(InterruptedException x) { 
      Нить.дайЭту().interrupt(); 
      return;
    }

    l = compute(l);

    try {
      acquireW();
      установи(l);
      замок_.замокЗаписи().отпусти(); 
    }
    catch(InterruptedException x) { 
      Нить.дайЭту().interrupt(); 
    }
  }

}

class WpRWlockRNG : RWLockRNG {
  WpRWlockRNG() { super(new ЧЗЗамокѕредпочтенияѕисателя()); }
}

class ReaderPrefRWlockRNG : RWLockRNG {
  ReaderPrefRWlockRNG() { 
    super(new ЧЗЗамокѕредпочтения„итателя()); 
  }


}

class FIFORWlockRNG : RWLockRNG {
  FIFORWlockRNG() { super(new ЧЗЗамокѕ¬ѕ¬()); }
}


class ReentrantRWlockRNG : RWLockRNG {
  ReentrantRWlockRNG() { 
    super(new ¬озобновляемыйЧЗЗамокѕредпочтенияѕисателя()); 
  }

  проц update()  {  // use embedded acquires
    дол l = 0;

    try {
      acquireW();

      try {
        acquireR();
        l = current_;
        замок_.замокЧтения().отпусти(); 
      }
      catch(InterruptedException x) { 
        Нить.дайЭту().interrupt(); 
        return;
      }

      l = compute(l);

      установи(l);
      замок_.замокЗаписи().отпусти(); 
    }
    catch(InterruptedException x) { 
      Нить.дайЭту().interrupt(); 
    }
  }

}


abstract class ExecutorRNG : DelegatedRNG {
  »сполнитель executor_;


  synchronized проц setExecutor(»сполнитель e) { executor_ = e; }
  synchronized »сполнитель getExecutor() { return executor_; }

  ѕускаемый delegatedUpdate_ = пусто;
  Callable delegatedNext_ = пусто;

  synchronized ѕускаемый delegatedUpdateCommand() {
    if (delegatedUpdate_ == пусто)
      delegatedUpdate_ = new UpdateCommand(getDelegate());
    return delegatedUpdate_;
  }

  synchronized Callable delegatedNextFunction() {
    if (delegatedNext_ == пусто)
      delegatedNext_ = new NextFunction(getDelegate());
    return delegatedNext_;
  }

  проц update() { 
    try {
      getExecutor().выполни(delegatedUpdateCommand()); 
    }
    catch (InterruptedException искл) {
      Нить.дайЭту().interrupt();
    }
  }

  // Each call to следщ gets result of previous future 
  FutureResult nextResult_ = пусто;

  synchronized дол следщ() { 
    дол res = 0;
    try {
      if (nextResult_ == пусто) { // direct call первое время through
        nextResult_ = new FutureResult();
        nextResult_.установи(new Long(getDelegate().следщ()));
      }
      FutureResult currentResult = nextResult_;

      nextResult_ = new FutureResult();
      ѕускаемый r = nextResult_.setter(delegatedNextFunction());
      getExecutor().выполни(r); 

      res =  ((Long)(currentResult.дай())).longValue();

    }
    catch (InterruptedException искл) {
      Нить.дайЭту().interrupt();
    }
    catch (InvocationTargetException искл) {
      искл.printStackTrace();
      throw new Error("Bad Callable?");
    }
    return res;
  }
}

class DirectExecutorRNG : ExecutorRNG {
  DirectExecutorRNG() { 
    setDelegate(new PublicSynchRNG()); 
    setExecutor(new ѕрямой»сполнитель()); 
  }
}

class LockedSemRNG : ExecutorRNG {
  LockedSemRNG() { 
    setDelegate(new NoSynchRNG()); 
    setExecutor(new Ѕлокированный»сполнитель(new Семафор(1))); 
  }
}

class QueuedExecutorRNG : ExecutorRNG {
  const Очередной»сполнитель exec = new Очередной»сполнитель();
  static { exec.установи‘абрикуНитей(Threads.фабрика); }
  QueuedExecutorRNG() { 
    setDelegate(new PublicSynchRNG()); 
    setExecutor(exec); 
  }
}

class ForcedStartRunnable : ѕускаемый {
  protected final ўеколда latch_ = new ўеколда();
  protected final ѕускаемый command_;

  ForcedStartRunnable(ѕускаемый команда) { command_ = команда; }

  ўеколда started() { return latch_; }

  проц пуск() {
    latch_.отпусти();
    command_.пуск();
  }
}


class ForcedStartThreadedExecutor : ѕоточный»сполнитель {
  проц выполни(ѕускаемый команда) {
    ForcedStartRunnable wrapped = new ForcedStartRunnable(команда);
    super.выполни(wrapped);
    wrapped.started().обрети();
  }
}

class ThreadedExecutorRNG : ExecutorRNG {
  const ѕоточный»сполнитель exec = new ѕоточный»сполнитель();
  static { exec.установи‘абрикуНитей(Threads.фабрика); }

  ThreadedExecutorRNG() { 
    setDelegate(new PublicSynchRNG()); 
    setExecutor(exec); 
  }
}


class PooledExecutorRNG : ExecutorRNG {
  const  атушечный»сполнитель exec = Threads.pool;

  PooledExecutorRNG() { 
    setDelegate(new PublicSynchRNG()); 
    setExecutor(exec); 
  }
}


class ChanRNG : DelegatedRNG {

  бул single_;

  ChanRNG() {
    setDelegate(new PublicSynchRNG());
  }

  synchronized проц setSingle(бул s) { single_ = s; }
  synchronized бул isSingle() { return single_; }

  дол producerNext( анал c) {
    RNG r = getDelegate();
    if (isSingle()) {
      c.помести(r);
      r = (RNG)(c.возьми());
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
        c.помести(r);
      }
      else {
        while (!(c.предложи(r, времяОжидания))) {}
      }
    }
    return r.дай();
  }

  дол consumerNext( анал c) {
    RNG r = пусто;
    if (cmode == 0) {
      r =  (RNG)(c.возьми());
    }
    else {
      while (r == пусто) r = (RNG)(c.запроси(времяОжидания));
    }
    
    if (pcBias == 0) {
      r.update();
    }
    else if (pcBias > 0) {
      r.update();
      r.update();
    }
    return r.дай();
  }
}

/** Start up this application **/
цел 
main(char[][] args) {
  new ТаймерСинхронизации();
  return 0;
}
