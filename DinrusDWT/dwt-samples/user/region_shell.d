module user.region_shell;// image attached: region.gif
import dwt.DWT;

import dwt.widgets.Display;
import dwt.widgets.Shell;
import dwt.widgets.Button;
import dwt.widgets.Listener;
import dwt.widgets.Event;

import dwt.layout.GridLayout;

import dwt.dwthelper.ByteArrayInputStream;

import dwt.graphics.Image;
import dwt.graphics.ImageData;
import dwt.graphics.Region;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;

import tango.io.Stdout;

class RegionShell: Shell
{
    this(Display display, int style, Image image, bool moveable = true)
    {
        super(display, style);
        
        setShellRegion(image, moveable);
    }
    
    this(Display display, Image image, bool moveable = true)
    {
        this(display, DWT.NO_TRIM, image, moveable);
    }
    
    private void setShellRegion(Image image, bool moveable)
    {
        Region region = new Region();
        ImageData imageData = image.getImageData();
        
        if (imageData.alphaData != null)
        {
            Rectangle pixel = new Rectangle(0, 0, 1, 1);
            
            for (int y = 0; y < imageData.height; y++)
            {
                for (int x = 0; x < imageData.width; x++)
                {
                    if (imageData.getAlpha(x, y) == 255)
                    {
                        pixel.x = imageData.x + x;
                        pixel.y = imageData.y + y;
                        
                        region.add(pixel);
                    }
                }
            }
        }
        else
        {
            ImageData mask = imageData.getTransparencyMask();
            Rectangle pixel = new Rectangle(0, 0, 1, 1);
            for (int y = 0; y < mask.height; y++)
            {
                for (int x = 0; x < mask.width; x++)
                {
                    if (mask.getPixel(x, y) != 0)
                    {
                        pixel.x = imageData.x + x;
                        pixel.y = imageData.y + y;
                        
                        region.add(pixel);
                    }
                }
            }
        }
        
        this.setRegion(region);
        this.setSize(imageData.x + imageData.width, imageData.y + imageData.height);
        
        if (moveable)
        {
            setMoveable();
        }
    }
    
    private Shell getCurrent()
    {
        return this;
    }
    
    private void setMoveable()
    {
        Listener l = new class Listener {
            Point origin;
            
            public void handleEvent(Event e) {
                switch (e.type) {
                    case DWT.MouseDown:
                        origin = new Point(e.x, e.y);
                        break;
                    case DWT.MouseUp:
                        origin = null;
                        break;
                    case DWT.MouseMove:
                        if (origin !is null) {
                            Point p = display.map(getCurrent(), null, e.x, e.y);
                            getCurrent.setLocation(p.x - origin.x, p.y - origin.y);
                        }
                        break;
                }
            }
        };
        
        this.addListener(DWT.MouseDown, l);
        this.addListener(DWT.MouseUp, l);
        this.addListener(DWT.MouseMove, l);
    }
}

void main()
{
    Display display = new Display();
    Image image = new Image(display, new ImageData(new ByteArrayInputStream(cast(byte[]) import("region_shell.gif"))));
    RegionShell shell = new RegionShell(display, image);
    
    Button closeBtn = new Button(shell, DWT.PUSH);
    closeBtn.setText("Close");
    closeBtn.addListener(DWT.Selection, new class Listener {
        public void handleEvent(Event e) {
            shell.close();
        }
    });
    
    shell.setLayout(new GridLayout());
    shell.setBackgroundImage(image);
    shell.open();
    
    while (!shell.isDisposed())
    {
        if (!display.readAndDispatch())
        {
            display.sleep();
        }
    }
    
    image.dispose();
    display.dispose();
}
