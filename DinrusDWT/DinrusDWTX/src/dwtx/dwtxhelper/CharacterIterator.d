module dwtx.dwtxhelper.CharacterIterator;

interface CharacterIterator {
    static const char DONE = '\u00FF';
    Object clone();
    char   current();
    char   first();
    int    getBeginIndex();
    int    getEndIndex();
    int    getIndex();
    char   last();
    char   next();
    char   previous();
    char   setIndex(int position);
}


