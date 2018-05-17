module dwtx.dwtxhelper.regex;

import dwt.dwthelper.utils;

class Matcher {
    public Pattern pattern(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public String    group(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public String    group(int n){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public  String replaceFirst(String replacement) {
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public int start(){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    public int end(){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    public bool find(){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    public bool find(int start){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
}

class Pattern {
    public static const int MULTILINE;
    public static const int CASE_INSENSITIVE ;
    public static const int UNICODE_CASE ;

    public String pattern(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public int flags(){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    public static Pattern compile(String regex){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public static Pattern compile(String regex, int flags){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public Matcher matcher(CharSequence input){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public Matcher matcher(String input){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
}

class PatternSyntaxException : IllegalArgumentException {
    this(String desc, String regex, int index) {
        super(desc);
    }
}

