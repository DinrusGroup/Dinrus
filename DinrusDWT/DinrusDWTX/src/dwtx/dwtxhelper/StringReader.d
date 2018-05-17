module dwtx.dwtxhelper.StringReader;

import dwt.dwthelper.utils;

class StringReader : Reader {
    String str;
    this( String str ){
        implMissing(__FILE__,__LINE__);
        this.str = str;
    }
    public override int read(char[] cbuf, int off, int len){
        cbuf[ off .. off+len ] = str[ 0 .. len ];
        str = str[ len .. $ ];
        return len;
    }
    public override void  close(){
    }
}

