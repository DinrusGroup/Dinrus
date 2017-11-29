module scrshot;
import dinrus;
pragma(lib, "DinrusCaptureScreenDLL.lib");

extern(C) int capture_screen(int x, int y, int cx, int cy, char *filename);

проц захватЭкрана(цел ш, цел в, цел дш, цел дв, сим* имяф)
{
capture_screen(ш, в, дш, дв, имяф);
}


void main()
{
 захватЭкрана(0, 0, 800, 800, "sshot.gif");
 инфо("Снимок экрана записан"); 
 сис("sshot.gif");
 выход(0);
}
