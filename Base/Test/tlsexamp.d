module tlsexamp;
import dinrus;
pragma(lib, "dinrus.lib");

const ЧЛОНИТ = 15; 
бцел индНлх;
бцел номерФции =1;
бцел номерНити =1; 
 
проц ОбщаяФункцияНлх() 
{ 
   ук данные; 
 
// Retrieve a data pointer for the current thread. 
 
   данные = ДайЗначениеНлх(индНлх); 
   if ((данные == cast(ук) 0) && (ДайПоследнююОшибку() != ПОшибка.Успех)) 
      ошибка("ошибка функции ДайЗначениеНлх"); 
 
// Use the data stored for the current thread. 
 
   скажифнс("ОбщаяФункцияНлх%d: нить %d: данные=%x\n", номерФции, cast(цел) ДайИдТекущейНити(), данные); 
   номерФции++;
 
   Спи(5000); 
} 
 
extern(Windows) бцел ФункцНити(ук данные) 
{ 
   
 
// Initialize the НЛХ index for this thread. 
 
   данные = cast(ук) РазместиЛок(ППамять.Лук, 256); 
   if (! УстановиЗначениеНлх(индНлх, данные)) 
      ошибка("ошибка функции УстановиЗначениеНлх"); 
 
   скажифнс("ФункцНити%d:нить %d: данные=%x\n", номерНити, ДайИдТекущейНити(), данные); 
   номерНити++;
   
 
   ОбщаяФункцияНлх(); 
 
// Release the dynamic memory before the thread returns. 
 
   данные = ДайЗначениеНлх(индНлх); 
   if (данные != cast(ук) 0) 
      ОсвободиЛок(cast(лук) данные); 
 
   return 0; 
} 
 
цел main() 
{ 
   бцел ИДНити; 
   ук нить[ЧЛОНИТ]; 
   int и; 
 //смОтключи();
 
// Allocate a НЛХ index. 
 
   if ((индНлх = РазместиНлх()) == ПОшибка.НЛХВнеИндексов) 
      ошибка("ошибка функции РазместиНлх"); 
 
// Create multiple threads. 
 
   for (и = 0; и < ЧЛОНИТ; и++) 
   { 
      нить[и] = СоздайНить(cast(БЕЗАТРЫ*) пусто, // default security attributes 
         0,                           // use default stack size 
         &ФункцНити, // thread function 
         пусто,                    // no thread function argument 
         cast(ПФлагСоздПроц) 0,                       // use default creation flags 
         &ИДНити);              // returns thread identifier 
 
   // Check the return value for success. 
      if (нить[и] == пусто) 
         ошибка("ошибка функции СоздайНить"); 
   } 
 
   for (и = 0; и < ЧЛОНИТ; и++) 
      ЖдиОдинОбъект(нить[и], БЕСК); 
 
   ОсвободиНлх(индНлх);
//смВключи();
   return 0; 
} 
 /*
проц ошибка (LPTSTR lpszMessage) 
{ 
   fprintf(stderr, "%s\n", lpszMessage); 
   ExitProcess(0); 
}
*/