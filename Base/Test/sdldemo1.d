module sdldemo1;
import lib.sdl;

void main()
{
    auto дисп = сдлУстановиВидеоРежим(640,480,0,SDL_HWSURFACE|SDL_DOUBLEBUF);
    auto прям = ПрямоугСДЛ(0,190,100,100);
    auto карт = сдлКартируйКЗСА(дисп.format,255,100,0,255);
    while (прям.x < дисп.w-100)
	{
        сдлЗаполниПрямоуг(дисп, null, 0);
        сдлЗаполниПрямоуг(дисп, &прям, карт);
        сдлФлип(дисп);
        прям.x++;
    }
}

