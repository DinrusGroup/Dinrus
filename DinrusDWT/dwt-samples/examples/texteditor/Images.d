/*******************************************************************************
 * Copyright (c) 2000, 2005 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * Port to the D programming language:
 *     Thomas Graber <d4rkdragon@gmail.com>
 *******************************************************************************/
module examples.texteditor.Images;

import dwt.dwthelper.InputStream;

import dwt.graphics.Image;
import dwt.graphics.ImageData;
import dwt.widgets.Display;
import dwt.dwthelper.ByteArrayInputStream;

import tango.core.Exception;
import tango.io.Stdout;

public class Images {

    // Bitmap Images
    public Image Bold;
    public Image Italic;
    public Image Underline;
    public Image Strikeout;
    public Image Red;
    public Image Green;
    public Image Blue;
    public Image Erase;

    Image[] AllBitmaps;

    this () {
    }

    public void freeAll () {
        for (int i=0; i<AllBitmaps.length; i++) AllBitmaps [i].dispose ();
        AllBitmaps = null;
    }

    Image createBitmapImage(Display display, void[] iImage, void[] iMask) {
        InputStream sourceStream = new ByteArrayInputStream(cast(byte[]) iImage);
        InputStream maskStream  = new ByteArrayInputStream(cast(byte[])iMask );

        ImageData source = new ImageData (sourceStream);
        ImageData mask = new ImageData (maskStream);
        Image result = new Image (null, source, mask);
        try {
            sourceStream.close ();
            maskStream.close ();
        } catch (IOException e) {
            Stderr.formatln( "Stacktrace: {}", e.toString );
        }
        return result;
    }

    public void loadAll (Display display) {
        // Bitmap Images
        Bold = createBitmapImage (display, import( "examples.texteditor.bold.bmp" ), import( "examples.texteditor.bold_mask.bmp" ));
        Italic = createBitmapImage (display, import( "examples.texteditor.italic.bmp" ), import( "examples.texteditor.italic_mask.bmp" ));
        Underline = createBitmapImage (display, import( "examples.texteditor.underline.bmp" ), import( "examples.texteditor.underline_mask.bmp" ));
        Strikeout = createBitmapImage (display, import( "examples.texteditor.strikeout.bmp" ), import( "examples.texteditor.strikeout_mask.bmp" ));
        Red = createBitmapImage (display, import( "examples.texteditor.red.bmp" ), import( "examples.texteditor.red_mask.bmp" ));
        Green = createBitmapImage (display, import( "examples.texteditor.green.bmp" ), import( "examples.texteditor.green_mask.bmp" ));
        Blue = createBitmapImage (display, import( "examples.texteditor.blue.bmp" ), import( "examples.texteditor.blue_mask.bmp" ));
        Erase = createBitmapImage (display, import( "examples.texteditor.erase.bmp" ), import( "examples.texteditor.erase_mask.bmp" ));

        AllBitmaps = [ Bold,
                       Italic,
                       Underline,
                       Strikeout,
                       Red,
                       Green,
                       Blue,
                       Erase
                      ];
    }
}
