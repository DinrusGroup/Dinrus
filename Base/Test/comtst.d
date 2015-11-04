import dinrus, runtime;
import com, sys.activex;

проц main() {
IShellDispatch оболочка = Shell.создайКо!(IShellDispatch);
  высвободиПосле (оболочка, {

    // Get a reference to the Desktop folder.
    Folder папка;
    оболочка.NameSpace(вВар(ShellSpecialFolderConstants.ssfDESKTOP), папка);
    if (папка !is пусто) {
      высвободиПосле (папка, {

        // Get the collection of FolderItem objects.
        FolderItems элты;
        папка.Items(элты);
        if (элты !is пусто) {
          высвободиПосле (элты, {

            // Iterate through all the FolderItem objects.
            цел счёт;
            элты.get_Count(счёт);
            for (цел и = 0; и < счёт; и++) {
              FolderItem элемент;
              элты.Item(вВар(и), элемент);
              if (элемент !is пусто) {
                высвободиПосле (элемент, {

                  // Get the name of the элемент.
                  ушим bstrName;
                  элемент.get_Name(bstrName);

                  // Convert the BSTR to a UTF-8 string. bstr.toString frees the BSTR.
                  ткст name = бткстВТкст(bstrName);
                  // Display the результат.
                  _скажинс(name);
                });
              }
            }
          });
        }
      });
    }
  });
}