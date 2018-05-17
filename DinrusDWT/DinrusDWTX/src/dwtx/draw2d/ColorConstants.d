/*******************************************************************************
 * Copyright (c) 2000, 2008 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module dwtx.draw2d.ColorConstants;

import dwt.dwthelper.utils;
import dwt.dwthelper.Runnable;
import tango.core.sync.Mutex;

import dwt.DWT;
import dwt.graphics.Color;
import dwt.widgets.Display;

/**
 * A collection of color-related constants.
 */
public struct ColorConstants {

    private static Color getColor(int which) {
        Display display = Display.getCurrent();
        if (display !is null)
            return display.getSystemColor(which);
        display = Display.getDefault();
        Color result;
        scope Mutex mutex = new Mutex;
        display.syncExec(dgRunnable( {
            synchronized (mutex) {
                result = Display.getCurrent().getSystemColor(which);
            }
        } ));
        synchronized (mutex) {
            return result;
        }
    }

/**
 * @see DWT#COLOR_WIDGET_HIGHLIGHT_SHADOW
 */
private static Color buttonLightest_;
public static Color buttonLightest(){
    if( buttonLightest_ is null ){
        synchronized( Display.classinfo ){
            if( buttonLightest_ is null ){
                buttonLightest_ = getColor(DWT.COLOR_WIDGET_HIGHLIGHT_SHADOW);
            }
        }
    }
    return buttonLightest_;
}
/**
 * @see DWT#COLOR_WIDGET_BACKGROUND
 */
private static Color button_;
public static Color button(){
    if( button_ is null ){
        synchronized( Display.classinfo ){
            if( button_ is null ){
                button_ = getColor(DWT.COLOR_WIDGET_BACKGROUND);
            }
        }
    }
    return button_;
}
/**
 * @see DWT#COLOR_WIDGET_NORMAL_SHADOW
 */
private static Color buttonDarker_;
public static Color buttonDarker(){
    if( buttonDarker_ is null ){
        synchronized( Display.classinfo ){
            if( buttonDarker_ is null ){
                buttonDarker_ = getColor(DWT.COLOR_WIDGET_NORMAL_SHADOW);
            }
        }
    }
    return buttonDarker_;
}
/**
 * @see DWT#COLOR_WIDGET_DARK_SHADOW
 */
private static Color buttonDarkest_;
public static Color buttonDarkest(){
    if( buttonDarkest_ is null ){
        synchronized( Display.classinfo ){
            if( buttonDarkest_ is null ){
                buttonDarkest_ = getColor(DWT.COLOR_WIDGET_DARK_SHADOW);
            }
        }
    }
    return buttonDarkest_;
}

/**
 * @see DWT#COLOR_LIST_BACKGROUND
 */
private static Color listBackground_;
public static Color listBackground(){
    if( listBackground_ is null ){
        synchronized( Display.classinfo ){
            if( listBackground_ is null ){
                listBackground_ = getColor(DWT.COLOR_LIST_BACKGROUND);
            }
        }
    }
    return listBackground_;
}
/**
 * @see DWT#COLOR_LIST_FOREGROUND
 */
private static Color listForeground_;
public static Color listForeground(){
    if( listForeground_ is null ){
        synchronized( Display.classinfo ){
            if( listForeground_ is null ){
                listForeground_ = getColor(DWT.COLOR_LIST_FOREGROUND);
            }
        }
    }
    return listForeground_;
}

/**
 * @see DWT#COLOR_WIDGET_BACKGROUND
 */
private static Color menuBackground_;
public static Color menuBackground(){
    if( menuBackground_ is null ){
        synchronized( Display.classinfo ){
            if( menuBackground_ is null ){
                menuBackground_ = getColor(DWT.COLOR_WIDGET_BACKGROUND);
            }
        }
    }
    return menuBackground_;
}
/**
 * @see DWT#COLOR_WIDGET_FOREGROUND
 */
private static Color menuForeground_;
public static Color menuForeground(){
    if( menuForeground_ is null ){
        synchronized( Display.classinfo ){
            if( menuForeground_ is null ){
                menuForeground_ = getColor(DWT.COLOR_WIDGET_FOREGROUND);
            }
        }
    }
    return menuForeground_;
}
/**
 * @see DWT#COLOR_LIST_SELECTION
 */
private static Color menuBackgroundSelected_;
public static Color menuBackgroundSelected(){
    if( menuBackgroundSelected_ is null ){
        synchronized( Display.classinfo ){
            if( menuBackgroundSelected_ is null ){
                menuBackgroundSelected_ = getColor(DWT.COLOR_LIST_SELECTION);
            }
        }
    }
    return menuBackgroundSelected_;
}
/**
 * @see DWT#COLOR_LIST_SELECTION_TEXT
 */
private static Color menuForegroundSelected_;
public static Color menuForegroundSelected(){
    if( menuForegroundSelected_ is null ){
        synchronized( Display.classinfo ){
            if( menuForegroundSelected_ is null ){
                menuForegroundSelected_ = getColor(DWT.COLOR_LIST_SELECTION_TEXT);
            }
        }
    }
    return menuForegroundSelected_;
}

/**
 * @see DWT#COLOR_TITLE_BACKGROUND
 */
private static Color titleBackground_;
public static Color titleBackground(){
    if( titleBackground_ is null ){
        synchronized( Display.classinfo ){
            if( titleBackground_ is null ){
                titleBackground_ = getColor(DWT.COLOR_TITLE_BACKGROUND);
            }
        }
    }
    return titleBackground_;
}
/**
 * @see DWT#COLOR_TITLE_BACKGROUND_GRADIENT
 */
private static Color titleGradient_;
public static Color titleGradient(){
    if( titleGradient_ is null ){
        synchronized( Display.classinfo ){
            if( titleGradient_ is null ){
                titleGradient_ = getColor(DWT.COLOR_TITLE_BACKGROUND_GRADIENT);
            }
        }
    }
    return titleGradient_;
}
/**
 * @see DWT#COLOR_TITLE_FOREGROUND
 */
private static Color titleForeground_;
public static Color titleForeground(){
    if( titleForeground_ is null ){
        synchronized( Display.classinfo ){
            if( titleForeground_ is null ){
                titleForeground_ = getColor(DWT.COLOR_TITLE_FOREGROUND);
            }
        }
    }
    return titleForeground_;
}
/**
 * @see DWT#COLOR_TITLE_INACTIVE_FOREGROUND
 */
private static Color titleInactiveForeground_;
public static Color titleInactiveForeground(){
    if( titleInactiveForeground_ is null ){
        synchronized( Display.classinfo ){
            if( titleInactiveForeground_ is null ){
                titleInactiveForeground_ = getColor(DWT.COLOR_TITLE_INACTIVE_FOREGROUND);
            }
        }
    }
    return titleInactiveForeground_;
}
/**
 * @see DWT#COLOR_TITLE_INACTIVE_BACKGROUND
 */
private static Color titleInactiveBackground_;
public static Color titleInactiveBackground(){
    if( titleInactiveBackground_ is null ){
        synchronized( Display.classinfo ){
            if( titleInactiveBackground_ is null ){
                titleInactiveBackground_ = getColor(DWT.COLOR_TITLE_INACTIVE_BACKGROUND);
            }
        }
    }
    return titleInactiveBackground_;
}
/**
 * @see DWT#COLOR_TITLE_INACTIVE_BACKGROUND_GRADIENT
 */
private static Color titleInactiveGradient_;
public static Color titleInactiveGradient(){
    if( titleInactiveGradient_ is null ){
        synchronized( Display.classinfo ){
            if( titleInactiveGradient_ is null ){
                titleInactiveGradient_ = getColor(DWT.COLOR_TITLE_INACTIVE_BACKGROUND_GRADIENT);
            }
        }
    }
    return titleInactiveGradient_;
}

/**
 * @see DWT#COLOR_INFO_FOREGROUND
 */
private static Color tooltipForeground_;
public static Color tooltipForeground(){
    if( tooltipForeground_ is null ){
        synchronized( Display.classinfo ){
            if( tooltipForeground_ is null ){
                tooltipForeground_ = getColor(DWT.COLOR_INFO_FOREGROUND);
            }
        }
    }
    return tooltipForeground_;
}
/**
 * @see DWT#COLOR_INFO_BACKGROUND
 */
private static Color tooltipBackground_;
public static Color tooltipBackground(){
    if( tooltipBackground_ is null ){
        synchronized( Display.classinfo ){
            if( tooltipBackground_ is null ){
                tooltipBackground_ = getColor(DWT.COLOR_INFO_BACKGROUND);
            }
        }
    }
    return tooltipBackground_;
}

/*
 * Misc. colors
 */
/** One of the pre-defined colors */
private static Color white_;
public static Color white(){
    if( white_ is null ){
        synchronized( Display.classinfo ){
            if( white_ is null ){
                white_ = new Color(null, 255, 255, 255);
            }
        }
    }
    return white_;
}
/** One of the pre-defined colors */
private static Color lightGray_;
public static Color lightGray(){
    if( lightGray_ is null ){
        synchronized( Display.classinfo ){
            if( lightGray_ is null ){
                lightGray_ = new Color(null, 192, 192, 192);
            }
        }
    }
    return lightGray_;
}
/** One of the pre-defined colors */
private static Color gray_;
public static Color gray(){
    if( gray_ is null ){
        synchronized( Display.classinfo ){
            if( gray_ is null ){
                gray_ = new Color(null, 128, 128, 128);
            }
        }
    }
    return gray_;
}
/** One of the pre-defined colors */
private static Color darkGray_;
public static Color darkGray(){
    if( darkGray_ is null ){
        synchronized( Display.classinfo ){
            if( darkGray_ is null ){
                darkGray_ = new Color(null,  64,  64,  64);
            }
        }
    }
    return darkGray_;
}
/** One of the pre-defined colors */
private static Color black_;
public static Color black(){
    if( black_ is null ){
        synchronized( Display.classinfo ){
            if( black_ is null ){
                black_ = new Color(null,   0,   0,   0);
            }
        }
    }
    return black_;
}
/** One of the pre-defined colors */
private static Color red_;
public static Color red(){
    if( red_ is null ){
        synchronized( Display.classinfo ){
            if( red_ is null ){
                red_ = new Color(null, 255,   0,   0);
            }
        }
    }
    return red_;
}
/** One of the pre-defined colors */
private static Color orange_;
public static Color orange(){
    if( orange_ is null ){
        synchronized( Display.classinfo ){
            if( orange_ is null ){
                orange_ = new Color(null, 255, 196,   0);
            }
        }
    }
    return orange_;
}
/** One of the pre-defined colors */
private static Color yellow_;
public static Color yellow(){
    if( yellow_ is null ){
        synchronized( Display.classinfo ){
            if( yellow_ is null ){
                yellow_ = new Color(null, 255, 255,   0);
            }
        }
    }
    return yellow_;
}
/** One of the pre-defined colors */
private static Color green_;
public static Color green(){
    if( green_ is null ){
        synchronized( Display.classinfo ){
            if( green_ is null ){
                green_ = new Color(null,   0, 255,   0);
            }
        }
    }
    return green_;
}
/** One of the pre-defined colors */
private static Color lightGreen_;
public static Color lightGreen(){
    if( lightGreen_ is null ){
        synchronized( Display.classinfo ){
            if( lightGreen_ is null ){
                lightGreen_ = new Color(null,  96, 255,  96);
            }
        }
    }
    return lightGreen_;
}
/** One of the pre-defined colors */
private static Color darkGreen_;
public static Color darkGreen(){
    if( darkGreen_ is null ){
        synchronized( Display.classinfo ){
            if( darkGreen_ is null ){
                darkGreen_ = new Color(null,   0, 127,   0);
            }
        }
    }
    return darkGreen_;
}
/** One of the pre-defined colors */
private static Color cyan_;
public static Color cyan(){
    if( cyan_ is null ){
        synchronized( Display.classinfo ){
            if( cyan_ is null ){
                cyan_ = new Color(null,   0, 255, 255);
            }
        }
    }
    return cyan_;
}
/** One of the pre-defined colors */
private static Color lightBlue_;
public static Color lightBlue(){
    if( lightBlue_ is null ){
        synchronized( Display.classinfo ){
            if( lightBlue_ is null ){
                lightBlue_ = new Color(null, 127, 127, 255);
            }
        }
    }
    return lightBlue_;
}
/** One of the pre-defined colors */
private static Color blue_;
public static Color blue(){
    if( blue_ is null ){
        synchronized( Display.classinfo ){
            if( blue_ is null ){
                blue_ = new Color(null,   0,   0, 255);
            }
        }
    }
    return blue_;
}
/** One of the pre-defined colors */
private static Color darkBlue_;
public static Color darkBlue(){
    if( darkBlue_ is null ){
        synchronized( Display.classinfo ){
            if( darkBlue_ is null ){
                darkBlue_ = new Color(null,   0,   0, 127);
            }
        }
    }
    return darkBlue_;
}

}


