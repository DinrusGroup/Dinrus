module dwtx.dwtxhelper.Bean;

import dwt.dwthelper.utils;
static import tango.core.Array;

class PropertyChangeEvent : EventObject {
    private String propertyName;
    private Object oldValue;
    private Object newValue;
    private Object propagationId;

    this( Object source, String propertyName, Object oldValue, Object newValue) {
        super( source );
        this.propertyName = propertyName;
        this.oldValue = oldValue;
        this.newValue = newValue;
    }
    Object getNewValue(){
        return newValue;
    }
    Object getOldValue(){
        return oldValue;
    }
    Object getPropagationId(){
        return propagationId;
    }
    String getPropertyName(){
        return propertyName;
    }
    void setPropagationId(Object propagationId){
        this.propagationId = propagationId;
    }
    public override String toString() {
        return this.classinfo.name ~ "[source=" ~ source.toString() ~ "]";
    }
}

interface PropertyChangeListener {
    void   propertyChange(PropertyChangeEvent evt);
}

class PropertyChangeSupport {
    PropertyChangeListener[][ String ] listeners;
    Object obj;
    this(Object obj){
        this.obj = obj;
    }
    void addPropertyChangeListener(PropertyChangeListener listener){
        addPropertyChangeListener( "", listener );
    }
    void addPropertyChangeListener(String propertyName, PropertyChangeListener listener){
        PropertyChangeListener[] list;
        if( auto l = propertyName in listeners ){
            list = *l;
        }
        list ~= listener;
        listeners[ propertyName.dup ] = list;
    }
    void firePropertyChange(String propertyName, bool oldValue, bool newValue){
        firePropertyChange( propertyName, Boolean.valueOf(oldValue), Boolean.valueOf(newValue) );
    }
    void firePropertyChange(String propertyName, int oldValue, int newValue){
        firePropertyChange( propertyName, new Integer(oldValue), new Integer(newValue) );
    }
    void firePropertyChange(String propertyName, Object oldValue, Object newValue){
        PropertyChangeListener[] list;
        if( auto l = propertyName in listeners ){
            list = *l;
        }
        auto evt = new PropertyChangeEvent( obj, propertyName, oldValue, newValue );
        foreach( listener; list ){
            if( listener ){
                listener.propertyChange( evt );
            }
        }
    }
    void removePropertyChangeListener(PropertyChangeListener listener){
        removePropertyChangeListener( "", listener );
    }
    void removePropertyChangeListener(String propertyName, PropertyChangeListener listener){
        if( auto list = propertyName in listeners ){
            list.length = tango.core.Array.remove( *list, listener );
            if( list.length > 0 ){
                listeners[ propertyName.dup ] = *list;
            }
            else{
                listeners.remove( propertyName );
            }
        }
    }
}


