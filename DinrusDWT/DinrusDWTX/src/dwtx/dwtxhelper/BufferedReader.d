module dwtx.dwtxhelper.BufferedReader;

import dwt.dwthelper.utils;

class BufferedReader : Reader {
    this(Reader reader){
        implMissing(__FILE__,__LINE__);
    }
    public override int read(char[] cbuf, int off, int len){
        implMissing(__FILE__,__LINE__);
        return 0;
    }
    public override void  close(){
        implMissing(__FILE__,__LINE__);
    }
    public String  readLine() {
        implMissing(__FILE__,__LINE__);
        return null;
    }
}



