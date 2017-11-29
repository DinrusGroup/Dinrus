/**
 *   Stacktracing
 *
 *   Inclusion of this module activates traced exceptions using the drTango own tracers if possible
 *
 *  Copyright: 2009 Fawzi
 *  License:   drTango license, apache 2.0
 *  Authors:   Fawzi Mohamed
 */
module core.tools.TraceExceptions;
import core.tools.StackTrace;

extern (C) проц  rt_setTraceHandler( TraceHandler h );

static this(){
    rt_setTraceHandler(&basicTracer);
}
