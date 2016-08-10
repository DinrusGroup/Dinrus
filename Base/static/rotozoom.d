
module lib.rotozoom; 

import lib.sdl, cidrus, stdrus; 

const float ПИ = 3.1415926535897931;

private
{
   const float VALUE_LIMIT = 0.001;
   
   struct tColorRGBA
   {
      Uint8 r;
      Uint8 g;
      Uint8 b;
      Uint8 a;
   }
   
   struct tColorY
   {
      Uint8 y;
   }
   
   // return the greater of two value
   real MAX(real a, real b) { if (a > b) return a; return b; }
}

/* 

32bit Zoomer with optional anti-aliasing by bilinear interpolation.

Zoomes 32bit RGBA/ABGR 'src' surface to 'приёмник' surface.

*/
extern(C):

цел зумПоверхностиКЗСА (SDL_Surface * src, SDL_Surface * приёмник, цел smooth)
{
 /*  цел x, y, sx, sy, *sax, *say, *csax, *csay, csx, csy, ex, ey, t1, t2, sstep;
   tColorRGBA *c00, *c01, *c10, *c11;
   tColorRGBA *sp, *csp, *dp;*/

   цел x, y, sx, sy;
   цел csx, csy, ex, ey, t1, t2, sstep;
   цел * sax, say, csax, csay;
   tColorRGBA * c00, c01, c10, c11;
   tColorRGBA * sp, csp, dp;

   цел sgap, dgap, orderRGBA;
   
   /* Variable setup */
   if (smooth)
      {
         /* For interpolation: assume source dimension is one pixel */
         /* smaller to avoid overflow on right и bottom edge.     */
         sx = cast(цел) (65536.0 * cast(float) (src.w - 1) / cast(float) приёмник.w);
         sy = cast(цел) (65536.0 * cast(float) (src.h - 1) / cast(float) приёмник.h);
      }
   else
      {
         sx = cast(цел) (65536.0 * cast(float) src.w / cast(float) приёмник.w);
         sy = cast(цел) (65536.0 * cast(float) src.h / cast(float) приёмник.h);
      }
   
   /* Allocate memory for ряд increments */
   if ((sax = cast(цел *) празмести ((приёмник.w + 1) * Uint32.sizeof)) is пусто)
      {
         return (-1);
      }
   if ((say = cast(цел *) празмести ((приёмник.h + 1) * Uint32.sizeof)) is пусто)
      {
         освободи (sax);
         return (-1);
      }
   
   /* Precalculate ряд increments */
   csx = 0;
   csax = sax;
   for (x = 0; x <= приёмник.w; x++)
      {
         *csax = csx;
         csax++;
         csx &= 0xffff;
         csx += sx;
      }
   csy = 0;
   csay = say;
   for (y = 0; y <= приёмник.h; y++)
      {
         *csay = csy;
         csay++;
         csy &= 0xffff;
         csy += sy;
      }
   
   /* Pointer setup */
   sp = csp = cast(tColorRGBA *) src.pixels;
   dp = cast(tColorRGBA *) приёмник.pixels;
   sgap = src.pitch - src.w * 4;
   dgap = приёмник.pitch - приёмник.w * 4;
   orderRGBA = (src.format.Rmask == 0x000000ff);
   
   /* Switch between interpolating и non-interpolating код */
   if (smooth)
      {
   
         /* Interpolating Zoom */
   
         /* Scan приёмник */
         csay = say;
         for (y = 0; y < приёмник.h; y++)
      {
      /* Setup color source pointers */
      c00 = csp;
      c01 = csp;
      c01++;
      c10 = cast(tColorRGBA *) (cast(Uint8 *) csp + src.pitch);
      c11 = c10;
      c11++;
      csax = sax;
      for (x = 0; x < приёмник.w; x++)
         {
            /* ABGR ordering */
            /* Interpolate colors */
            ex = (*csax & 0xffff);
            ey = (*csay & 0xffff);
            t1 = ((((c01.r - c00.r) * ex) >> 16) + c00.r) & 0xff;
            t2 = ((((c11.r - c10.r) * ex) >> 16) + c10.r) & 0xff;
            dp.r = (((t2 - t1) * ey) >> 16) + t1;
            t1 = ((((c01.g - c00.g) * ex) >> 16) + c00.g) & 0xff;
            t2 = ((((c11.g - c10.g) * ex) >> 16) + c10.g) & 0xff;
            dp.g = (((t2 - t1) * ey) >> 16) + t1;
            t1 = ((((c01.b - c00.b) * ex) >> 16) + c00.b) & 0xff;
            t2 = ((((c11.b - c10.b) * ex) >> 16) + c10.b) & 0xff;
            dp.b = (((t2 - t1) * ey) >> 16) + t1;
            t1 = ((((c01.a - c00.a) * ex) >> 16) + c00.a) & 0xff;
            t2 = ((((c11.a - c10.a) * ex) >> 16) + c10.a) & 0xff;
            dp.a = (((t2 - t1) * ey) >> 16) + t1;
            /* Advance source pointers */
            csax++;
            sstep = (*csax >> 16);
            c00 += sstep;
            c01 += sstep;
            c10 += sstep;
            c11 += sstep;
            /* Advance приёмник pointer */
            dp++;
         }
      /* Advance source pointer */
      csay++;
      csp = cast(tColorRGBA *) (cast(Uint8 *) csp + (*csay >> 16) * src.pitch);
      /* Advance приёмник pointers */
      dp = cast(tColorRGBA *) (cast(Uint8 *) dp + dgap);
      }
   
      }
   else
      {
   
         /* Non-Interpolating Zoom */
   
         csay = say;
         for (y = 0; y < приёмник.h; y++)
      {
      sp = csp;
      csax = sax;
      for (x = 0; x < приёмник.w; x++)
         {
            /* Draw */
            *dp = *sp;
            /* Advance source pointers */
            csax++;
            sp += (*csax >> 16);
            /* Advance приёмник pointer */
            dp++;
         }
      /* Advance source pointer */
      csay++;
      csp = cast(tColorRGBA *) (cast(Uint8 *) csp + (*csay >> 16) * src.pitch);
      /* Advance приёмник pointers */
      dp = cast(tColorRGBA *) (cast(Uint8 *) dp + dgap);
      }
   
      }
   
   /* Remove temp arrays */
   освободи (sax);
   освободи (say);
   
   return (0);
}

/* 

8bit Zoomer without smoothing.

Zoomes 8bit palette/Y 'src' surface to 'приёмник' surface.

*/

цел зумПоверхностиВ (SDL_Surface * src, SDL_Surface * приёмник)
   {
   /*Uint32 x, y, sx, sy, *sax, *say, *csax, *csay, csx, csy;
   Uint8 *sp, *dp, *csp;*/

   Uint32 x, y, sx, sy;
   Uint32 *sax, say, csax, csay;
   Uint32 csx, csy;
   Uint8 *sp, dp, csp;

   цел dgap;
   
   /* Variable setup */
   sx = cast(Uint32) (65536.0 * cast(float) src.w / cast(float) приёмник.w);
   sy = cast(Uint32) (65536.0 * cast(float) src.h / cast(float) приёмник.h);
   
   /* Allocate memory for ряд increments */
   if ((sax = cast(Uint32 *) празмести (приёмник.w * Uint32.sizeof)) is пусто)
      {
         return (-1);
      }
   if ((say = cast(Uint32 *) празмести (приёмник.h * Uint32.sizeof)) is пусто)
      {
         if (sax != пусто)
         {
            освободи (sax);
         }
         return (-1);
      }
   
   /* Precalculate ряд increments */
   csx = 0;
   csax = sax;
   for (x = 0; x < приёмник.w; x++)
      {
         csx += sx;
         *csax = (csx >> 16);
         csx &= 0xffff;
         csax++;
      }
   csy = 0;
   csay = say;
   for (y = 0; y < приёмник.h; y++)
      {
         csy += sy;
         *csay = (csy >> 16);
         csy &= 0xffff;
         csay++;
      }
   
   csx = 0;
   csax = sax;
   for (x = 0; x < приёмник.w; x++)
      {
         csx += (*csax);
         csax++;
      }
   csy = 0;
   csay = say;
   for (y = 0; y < приёмник.h; y++)
      {
         csy += (*csay);
         csay++;
      }
   
   /* Pointer setup */
   sp = csp = cast(Uint8 *) src.pixels;
   dp = cast(Uint8 *) приёмник.pixels;
   dgap = приёмник.pitch - приёмник.w;
   
   /* Draw */
   csay = say;
   for (y = 0; y < приёмник.h; y++)
      {
         csax = sax;
         sp = csp;
         for (x = 0; x < приёмник.w; x++)
      {
      /* Draw */
      *dp = *sp;
      /* Advance source pointers */
      sp += (*csax);
      csax++;
      /* Advance приёмник pointer */
      dp++;
      }
         /* Advance source pointer (for ряд) */
         csp += ((*csay) * src.pitch);
         csay++;
         /* Advance приёмник pointers */
         dp += dgap;
      }
   
   /* Remove temp arrays */
   освободи (sax);
   освободи (say);
   
   return (0);
}

/* 

32bit Rotozoomer with optional anti-aliasing by bilinear interpolation.

Rotates и zoomes 32bit RGBA/ABGR 'src' surface to 'приёмник' surface.

*/

void трансформПоверхностиКЗСА (SDL_Surface * src, SDL_Surface * приёмник, цел cx, цел cy,
            цел isin, цел icos, цел smooth)
{
   цел x, y, t1, t2, dx, dy, xd, yd, sdx, sdy, ax, ay, ex, ey, sw, sh;
   tColorRGBA c00, c01, c10, c11;
   //tColorRGBA *pc, *sp;
   tColorRGBA *pc, sp;
   цел gap, orderRGBA;
   
   /* Variable setup */
   xd = ((src.w - приёмник.w) << 15);
   yd = ((src.h - приёмник.h) << 15);
   ax = (cx << 16) - (icos * cx);
   ay = (cy << 16) - (isin * cx);
   sw = src.w - 1;
   sh = src.h - 1;
   pc = cast(tColorRGBA *)приёмник.pixels;
   gap = приёмник.pitch - приёмник.w * 4;
   orderRGBA = (src.format.Rmask == 0x000000ff);
   
   /* Switch between interpolating и non-interpolating код */
   if (smooth)
      {
         for (y = 0; y < приёмник.h; y++)
      {
      dy = cy - y;
      sdx = (ax + (isin * dy)) + xd;
      sdy = (ay - (icos * dy)) + yd;
      for (x = 0; x < приёмник.w; x++)
         {
            dx = (sdx >> 16);
            dy = (sdy >> 16);
            if ((dx >= -1) && (dy >= -1) && (dx < src.w) && (dy < src.h))
         {
         if ((dx >= 0) && (dy >= 0) && (dx < sw) && (dy < sh))
            {
               sp =
            cast(tColorRGBA *) (cast(Uint8 *) src.pixels +
                  src.pitch * dy);
               sp += dx;
               c00 = *sp;
               sp += 1;
               c01 = *sp;
               sp = cast(tColorRGBA *) (cast(Uint8 *) sp + src.pitch);
               sp -= 1;
               c10 = *sp;
               sp += 1;
               c11 = *sp;
            }
         else if ((dx == sw) && (dy == sh))
            {
               sp =
            cast(tColorRGBA *) (cast(Uint8 *) src.pixels +
                  src.pitch * dy);
               sp += dx;
               c00 = *sp;
               c01 = *pc;
               c10 = *pc;
               c11 = *pc;
            }
         else if ((dx == -1) && (dy == -1))
            {
               sp = cast(tColorRGBA *) (src.pixels);
               c00 = *pc;
               c01 = *pc;
               c10 = *pc;
               c11 = *sp;
            }
         else if ((dx == -1) && (dy == sh))
            {
               sp = cast(tColorRGBA *) (src.pixels);
               sp =
            cast(tColorRGBA *) (cast(Uint8 *) src.pixels +
                  src.pitch * dy);
               c00 = *pc;
               c01 = *sp;
               c10 = *pc;
               c11 = *pc;
            }
         else if ((dx == sw) && (dy == -1))
            {
               sp = cast(tColorRGBA *) (src.pixels);
               sp += dx;
               c00 = *pc;
               c01 = *pc;
               c10 = *sp;
               c11 = *pc;
            }
         else if (dx == -1)
            {
               sp =
            cast(tColorRGBA *) (cast(Uint8 *) src.pixels +
                  src.pitch * dy);
               c00 = *pc;
               c01 = *sp;
               c10 = *pc;
               sp = cast(tColorRGBA *) (cast(Uint8 *) sp + src.pitch);
               c11 = *sp;
            }
         else if (dy == -1)
            {
               sp = cast(tColorRGBA *) (src.pixels);
               sp += dx;
               c00 = *pc;
               c01 = *pc;
               c10 = *sp;
               sp += 1;
               c11 = *sp;
            }
         else if (dx == sw)
            {
               sp =
            cast(tColorRGBA *) (cast(Uint8 *) src.pixels +
                  src.pitch * dy);
               sp += dx;
               c00 = *sp;
               c01 = *pc;
               sp = cast(tColorRGBA *) (cast(Uint8 *) sp + src.pitch);
               c10 = *sp;
               c11 = *pc;
            }
         else if (dy == sh)
            {
               sp =
            cast(tColorRGBA *) (cast(Uint8 *) src.pixels +
                  src.pitch * dy);
               sp += dx;
               c00 = *sp;
               sp += 1;
               c01 = *sp;
               c10 = *pc;
               c11 = *pc;
            }
         /* Interpolate colors */
         ex = (sdx & 0xffff);
         ey = (sdy & 0xffff);
         t1 = ((((c01.r - c00.r) * ex) >> 16) + c00.r) & 0xff;
         t2 = ((((c11.r - c10.r) * ex) >> 16) + c10.r) & 0xff;
         pc.r = (((t2 - t1) * ey) >> 16) + t1;
         t1 = ((((c01.g - c00.g) * ex) >> 16) + c00.g) & 0xff;
         t2 = ((((c11.g - c10.g) * ex) >> 16) + c10.g) & 0xff;
         pc.g = (((t2 - t1) * ey) >> 16) + t1;
         t1 = ((((c01.b - c00.b) * ex) >> 16) + c00.b) & 0xff;
         t2 = ((((c11.b - c10.b) * ex) >> 16) + c10.b) & 0xff;
         pc.b = (((t2 - t1) * ey) >> 16) + t1;
         t1 = ((((c01.a - c00.a) * ex) >> 16) + c00.a) & 0xff;
         t2 = ((((c11.a - c10.a) * ex) >> 16) + c10.a) & 0xff;
         pc.a = (((t2 - t1) * ey) >> 16) + t1;
   
         }
            sdx += icos;
            sdy += isin;
            pc++;
         }
      pc = cast(tColorRGBA *) (cast(Uint8 *) pc + gap);
      }
      }
   else
      {
         for (y = 0; y < приёмник.h; y++)
      {
      dy = cy - y;
      sdx = (ax + (isin * dy)) + xd;
      sdy = (ay - (icos * dy)) + yd;
      for (x = 0; x < приёмник.w; x++)
         {
            dx = cast(крат) (sdx >> 16);
            dy = cast(крат) (sdy >> 16);
            if ((dx >= 0) && (dy >= 0) && (dx < src.w) && (dy < src.h))
         {
         sp =
            cast(tColorRGBA *) (cast(Uint8 *) src.pixels + src.pitch * dy);
         sp += dx;
         *pc = *sp;
         }
            sdx += icos;
            sdy += isin;
            pc++;
         }
      pc = cast(tColorRGBA *) (cast(Uint8 *) pc + gap);
      }
      }
}

/* 

8bit Rotozoomer without smoothing

Rotates и zoomes 8bit palette/Y 'src' surface to 'приёмник' surface.

*/

проц трансформПоверхностиВ (SDL_Surface * src, SDL_Surface * приёмник, цел cx, цел cy,
         цел isin, цел icos)
   {
   цел x, y, dx, dy, xd, yd, sdx, sdy, ax, ay, sw, sh;
   //tColorY *pc, *sp;
   tColorY *pc, sp;
   цел gap;
   
   /* Variable setup */
   xd = ((src.w - приёмник.w) << 15);
   yd = ((src.h - приёмник.h) << 15);
   ax = (cx << 16) - (icos * cx);
   ay = (cy << 16) - (isin * cx);
   sw = src.w - 1;
   sh = src.h - 1;
   pc = cast(tColorY *)приёмник.pixels;
   gap = приёмник.pitch - приёмник.w;
   /* Clear surface to colorkey */
   memset (pc, cast(ubyte) (src.format.colorkey & 0xff),
      приёмник.pitch * приёмник.h);
   /* Iterate through приёмник surface */
   for (y = 0; y < приёмник.h; y++)
      {
         dy = cy - y;
         sdx = (ax + (isin * dy)) + xd;
         sdy = (ay - (icos * dy)) + yd;
         for (x = 0; x < приёмник.w; x++)
      {
      dx = cast(крат) (sdx >> 16);
      dy = cast(крат) (sdy >> 16);
      if ((dx >= 0) && (dy >= 0) && (dx < src.w) && (dy < src.h))
         {
            sp = cast(tColorY *) (src.pixels);
            sp += (src.pitch * dy + dx);
            *pc = *sp;
         }
      sdx += icos;
      sdy += isin;
      pc++;
      }
         pc += gap;
      }
}

/* 

ротозумПоверхности()

Rotates и zoomes a 32bit or 8bit 'src' surface to newly created 'приёмник' surface.
'angle' is the rotation in degrees. 'zoom' a scaling factor. If 'smooth' is 1
then the приёмник 32bit surface is anti-есть_алиас. If the surface is not 8bit
or 32bit RGBA/ABGR it will be converted into a 32bit RGBA format on the fly.

*/


SDL_Surface *ротозумПоверхности (SDL_Surface * src, double angle, double zoom, цел smooth)
   {
   SDL_Surface *rz_src;
   SDL_Surface *rz_dst;
   double zoominv;
   double radangle, sanglezoom, canglezoom, sanglezoominv, canglezoominv;
   цел dstwidthhalf, dstwidth, dstheighthalf, dstheight;
   double x, y, cx, cy, sx, sy;
   цел is32bit;
   цел i, src_converted;
   
   /* Sanity проверь */
   if (src is пусто)
      return (пусто);
   
   /* Determine if source surface is 32bit or 8bit */
   is32bit = (src.format.BitsPerPixel == 32);
   if ((is32bit) || (src.format.BitsPerPixel == 8))
      {
         /* Use source surface 'as is' */
         rz_src = src;
         src_converted = 0;
      }
   else
      {
         /* Нов source surface is 32bit with a defined RGBA ordering */
         rz_src =
      сдлСоздайКЗСПоверхность (SDL_SWSURFACE, src.w, src.h, 32, 0x000000ff,
                  0x0000ff00, 0x00ff0000, 0xff000000);
         сдлВерхнийБлит (src, пусто, rz_src, пусто);
         src_converted = 1;
         is32bit = 1;
      }
   
   /* Sanity проверь zoom factor */
   if (zoom < VALUE_LIMIT)
      {
         zoom = VALUE_LIMIT;
      }
   zoominv = 65536.0 / zoom;
   
   /* Check if we have a rotozoom or just a zoom */
   if (stdrus.фабс (angle) > VALUE_LIMIT)
      {
   
         /* Angle!=0: full rotozoom */
         /* ----------------------- */
   
         /* Calculate target factors from sin/cos и zoom */
         radangle = angle * (ПИ / 180.0);
         sanglezoom = sanglezoominv = cidrus.син (radangle);
         canglezoom = canglezoominv = cidrus.кос (radangle);
         sanglezoom *= zoom;
         canglezoom *= zoom;
         sanglezoominv *= zoominv;
         canglezoominv *= zoominv;
   
         /* Determine приёмник width и height by rotating a centered source box */
         x = rz_src.w / 2;
         y = rz_src.h / 2;
         cx = canglezoom * x;
         cy = canglezoom * y;
         sx = sanglezoom * x;
         sy = sanglezoom * y;
         dstwidthhalf = cast(цел)
      MAX (
         ceil (MAX
            (MAX
            (MAX (stdrus.фабс (cx + sy), stdrus.фабс (cx - sy)), stdrus.фабс (-cx + sy)),
            stdrus.фабс (-cx - sy))), 1);
   
         dstheighthalf = cast(цел)
   
      MAX (
         ceil (MAX
            (MAX
            (MAX (stdrus.фабс (sx + cy), stdrus.фабс (sx - cy)), stdrus.фабс (-sx + cy)),
            stdrus.фабс (-sx - cy))), 1);
         dstwidth = 2 * dstwidthhalf;
         dstheight = 2 * dstheighthalf;
   
         /* Размест space to completely contain the rotated surface */
         rz_dst = пусто;
         if (is32bit)
      {
      /* Target surface is 32bit with source RGBA/ABGR ordering */
      rz_dst =
         сдлСоздайКЗСПоверхность (SDL_SWSURFACE, dstwidth, dstheight, 32,
               rz_src.format.Rmask,
               rz_src.format.Gmask,
               rz_src.format.Bmask,
               rz_src.format.Amask);
      }
         else
      {
      /* Target surface is 8bit */
      rz_dst =
         сдлСоздайКЗСПоверхность (SDL_SWSURFACE, dstwidth, dstheight, 8, 0, 0,
               0, 0);
      }
   
         /* Lock source surface */
         сдлБлокируйПоверхность (rz_src);
         /* Check which kind of surface we have */
         if (is32bit)
      {
      /* Call the 32bit transformation routine to do the rotation (using alpha) */
      трансформПоверхностиКЗСА (rz_src, rz_dst, dstwidthhalf, dstheighthalf,
               cast(цел) (sanglezoominv),
               cast(цел) (canglezoominv), smooth);
      /* Turn on source-alpha support */
      сдлУстановиАльфу (rz_dst, SDL_SRCALPHA, 255);
      }
         else
      {
      /* Copy palette и colorkey info */
      for (i = 0; i < rz_src.format.palette.ncolors; i++)
         {
            rz_dst.format.palette.colors[i] =
         rz_src.format.palette.colors[i];
         }
      rz_dst.format.palette.ncolors = rz_src.format.palette.ncolors;
      /* Call the 8bit transformation routine to do the rotation */
      трансформПоверхностиВ (rz_src, rz_dst, dstwidthhalf, dstheighthalf,
               cast(цел) (sanglezoominv), cast(цел) (canglezoominv));
      сдлУстановиКлючЦвета (rz_dst, SDL_SRCCOLORKEY | SDL_RLEACCEL,
               rz_src.format.colorkey);
      }
         /* Unlock source surface */
         сдлРазблокируйПоверхность (rz_src);
   
      }
   else
      {
   
         /* Angle=0: Just a zoom */
         /* -------------------- */
   
         /* Calculate target размер и установи rect */
         dstwidth = cast(цел) (cast(double) rz_src.w * zoom);
         dstheight = cast(цел) (cast(double) rz_src.h * zoom);
         if (dstwidth < 1)
      {
      dstwidth = 1;
      }
         if (dstheight < 1)
      {
      dstheight = 1;
      }
   
         /* Размест space to completely contain the zoomed surface */
         rz_dst = пусто;
         if (is32bit)
      {
      /* Target surface is 32bit with source RGBA/ABGR ordering */
      rz_dst =
         сдлСоздайКЗСПоверхность (SDL_SWSURFACE, dstwidth, dstheight, 32,
               rz_src.format.Rmask,
               rz_src.format.Gmask,
               rz_src.format.Bmask,
               rz_src.format.Amask);
      }
         else
      {
      /* Target surface is 8bit */
      rz_dst =
         сдлСоздайКЗСПоверхность (SDL_SWSURFACE, dstwidth, dstheight, 8, 0, 0,
               0, 0);
      }
   
         /* Lock source surface */
         сдлБлокируйПоверхность (rz_src);
         /* Check which kind of surface we have */
         if (is32bit)
      {
      /* Call the 32bit transformation routine to do the zooming (using alpha) */
      зумПоверхностиКЗСА (rz_src, rz_dst, smooth);
      /* Turn on source-alpha support */
      сдлУстановиАльфу (rz_dst, SDL_SRCALPHA, 255);
      }
         else
      {
      /* Copy palette и colorkey info */
      for (i = 0; i < rz_src.format.palette.ncolors; i++)
         {
            rz_dst.format.palette.colors[i] =
         rz_src.format.palette.colors[i];
         }
      rz_dst.format.palette.ncolors = rz_src.format.palette.ncolors;
      /* Call the 8bit transformation routine to do the zooming */
      зумПоверхностиВ (rz_src, rz_dst);
      сдлУстановиКлючЦвета (rz_dst, SDL_SRCCOLORKEY | SDL_RLEACCEL,
               rz_src.format.colorkey);
      }
         /* Unlock source surface */
         сдлРазблокируйПоверхность (rz_src);
      }
   
   /* Cleanup temp surface */
   if (src_converted)
      {
         сдлОсвободиПоверхность (rz_src);
      }
   
   /* Return приёмник surface */
   return (rz_dst);
}

/* 

зумПоверхности()

Zoomes a 32bit or 8bit 'src' surface to newly created 'приёмник' surface.
'zoomx' и 'zoomy' are scaling factors for width и height. If 'smooth' is 1
then the приёмник 32bit surface is anti-есть_алиас. If the surface is not 8bit
or 32bit RGBA/ABGR it will be converted into a 32bit RGBA format on the fly.

*/

SDL_Surface *зумПоверхности (SDL_Surface * src, double zoomx, double zoomy, цел smooth)
   {
   SDL_Surface *rz_src;
   SDL_Surface *rz_dst;
   цел dstwidth, dstheight;
   цел is32bit;
   цел i, src_converted;
   
   /* Sanity проверь */
   if (src is пусто)
      return (пусто);
   
   /* Determine if source surface is 32bit or 8bit */
   is32bit = (src.format.BitsPerPixel == 32);
   if ((is32bit) || (src.format.BitsPerPixel == 8))
      {
         /* Use source surface 'as is' */
         rz_src = src;
         src_converted = 0;
      }
   else
      {
         /* Нов source surface is 32bit with a defined RGBA ordering */
         rz_src =
      сдлСоздайКЗСПоверхность (SDL_SWSURFACE, src.w, src.h, 32, 0x000000ff,
                  0x0000ff00, 0x00ff0000, 0xff000000);
         сдлВерхнийБлит (src, пусто, rz_src, пусто);
         src_converted = 1;
         is32bit = 1;
      }
   
   /* Sanity проверь zoom factors */
   if (zoomx < VALUE_LIMIT)
      {
         zoomx = VALUE_LIMIT;
      }
   if (zoomy < VALUE_LIMIT)
      {
         zoomy = VALUE_LIMIT;
      }
   
   /* Calculate target размер и установи rect */
   dstwidth = cast(цел) (cast(double) rz_src.w * zoomx);
   dstheight = cast(цел) (cast(double) rz_src.h * zoomy);
   if (dstwidth < 1)
      {
         dstwidth = 1;
      }
   if (dstheight < 1)
      {
         dstheight = 1;
      }
   
   /* Размест space to completely contain the zoomed surface */
   rz_dst = пусто;
   if (is32bit)
      {
         /* Target surface is 32bit with source RGBA/ABGR ordering */
         rz_dst =
      сдлСоздайКЗСПоверхность (SDL_SWSURFACE, dstwidth, dstheight, 32,
                  rz_src.format.Rmask, rz_src.format.Gmask,
                  rz_src.format.Bmask, rz_src.format.Amask);
      }
   else
      {
         /* Target surface is 8bit */
         rz_dst =
      сдлСоздайКЗСПоверхность (SDL_SWSURFACE, dstwidth, dstheight, 8, 0, 0, 0,
                  0);
      }
   
   /* Lock source surface */
   сдлБлокируйПоверхность (rz_src);
   /* Check which kind of surface we have */
   if (is32bit)
      {
         /* Call the 32bit transformation routine to do the zooming (using alpha) */
         зумПоверхностиКЗСА (rz_src, rz_dst, smooth);
         /* Turn on source-alpha support */
         сдлУстановиАльфу (rz_dst, SDL_SRCALPHA, 255);
      }
   else
      {
         /* Copy palette и colorkey info */
         for (i = 0; i < rz_src.format.palette.ncolors; i++)
      {
      rz_dst.format.palette.colors[i] =
         rz_src.format.palette.colors[i];
      }
         rz_dst.format.palette.ncolors = rz_src.format.palette.ncolors;
         /* Call the 8bit transformation routine to do the zooming */
         зумПоверхностиВ (rz_src, rz_dst);
         сдлУстановиКлючЦвета (rz_dst, SDL_SRCCOLORKEY | SDL_RLEACCEL,
               rz_src.format.colorkey);
      }
   /* Unlock source surface */
   сдлРазблокируйПоверхность (rz_src);
   
   /* Cleanup temp surface */
   if (src_converted)
      {
         сдлОсвободиПоверхность (rz_src);
      }
   
   /* Return приёмник surface */
   return (rz_dst);
}

проц ОбработайСобытие ()
{
СобытиеСДЛ событие;

/* Check for events */
while (сдлСобПолл (&событие))
   {
      switch (событие.type)
      {
         case SDL_KEYDOWN:
         case SDL_QUIT:
         exit (0);
         break;
         default:
         break; 
      }
   }
}

проц ОчистиЭкран (ПоверхностьСДЛ * экран)
{
цел i;
/* Set the экран to black */
if (сдлБлокируйПоверхность (экран) == 0)
   {
      Uint32 black;
      Uint8 *pixels;
      black = сдлКартируйКЗС (экран.format, 0, 0, 0);
      pixels = cast(Uint8 *) экран.pixels;
      for (i = 0; i < экран.h; ++i)
   {
   memset (pixels, black, экран.w * экран.format.BytesPerPixel);
   pixels += экран.pitch;
   }
      сдлРазблокируйПоверхность (экран);
   }
}

проц ВращайКартинку (ПоверхностьСДЛ * экран, ПоверхностьСДЛ * картинка, цел rotate,
         цел smooth)
{
   ПоверхностьСДЛ *картинка_вращения;
   ПрямоугСДЛ dest;
   цел framecount, framemax, frameinc;
   float zoomf;
   
   /* Rotate и display the картинка */
   framemax = 4 * 360;
   frameinc = 1;
   for (framecount = 360; framecount < framemax; framecount += frameinc)
      {
         if ((framecount % 360) == 0)
      frameinc++;
         ОбработайСобытие ();
         ОчистиЭкран (экран);
         zoomf = cast(float) framecount / cast(float) framemax;
         zoomf = 1.5 * zoomf * zoomf;
         if ((картинка_вращения =
         ротозумПоверхности (картинка, framecount * rotate, zoomf,
               smooth)) != пусто)
      {
      dest.x = (экран.w - картинка_вращения.w) / 2;;
      dest.y = (экран.h - картинка_вращения.h) / 2;
      dest.w = картинка_вращения.w;
      dest.h = картинка_вращения.h;
      if (сдлВерхнийБлит (картинка_вращения, пусто, экран, &dest) < 0)
         {
            пишиф ( "Blit failed: %s\n", сдлДайОш ());
            break;
         }
      сдлОсвободиПоверхность (картинка_вращения);
      }
   
         /* Display by flipping screens */
         сдлОбновиПрямоуг (экран, 0, 0, 0, 0);
      }
   
   if (rotate)
      {
         /* Final display with angle=0 */
         ОбработайСобытие ();
         ОчистиЭкран (экран);
         if ((картинка_вращения =
         ротозумПоверхности (картинка, 0.01, zoomf, smooth)) != пусто)
      {
      dest.x = (экран.w - картинка_вращения.w) / 2;;
      dest.y = (экран.h - картинка_вращения.h) / 2;
      dest.w = картинка_вращения.w;
      dest.h = картинка_вращения.h;
      if (сдлВерхнийБлит (картинка_вращения, пусто, экран, &dest) < 0)
         {
            пишиф ( "Blit failed: %s\n", сдлДайОш ());
            return;
         }
      сдлОсвободиПоверхность (картинка_вращения);
      }
   
         /* Display by flipping screens */
         сдлОбновиПрямоуг (экран, 0, 0, 0, 0);
      }
   
   /* Pause for a sec */
   сдлЗадержка (1000);
}

проц ЗумКартинки (ПоверхностьСДЛ * экран, ПоверхностьСДЛ * картинка, цел smooth)
   {
   ПоверхностьСДЛ *картинка_вращения;
   ПрямоугСДЛ dest;
   цел framecount, framemax, frameinc;
   float zoomxf, zoomyf;
   
   /* Zoom и display the картинка */
   framemax = 4 * 360;
   frameinc = 1;
   for (framecount = 360; framecount < framemax; framecount += frameinc)
      {
         if ((framecount % 360) == 0)
      frameinc++;
         ОбработайСобытие ();
         ОчистиЭкран (экран);
         zoomxf = cast(float) framecount / cast(float) framemax;
         zoomxf = 1.5 * zoomxf * zoomxf;
         zoomyf = 0.5 + stdrus.фабс (1.0 * sin (cast(double) framecount / 80.0));
         if ((картинка_вращения =
         зумПоверхности (картинка, zoomxf, zoomyf, smooth)) != пусто)
      {
      dest.x = (экран.w - картинка_вращения.w) / 2;;
      dest.y = (экран.h - картинка_вращения.h) / 2;
      dest.w = картинка_вращения.w;
      dest.h = картинка_вращения.h;
      if (сдлВерхнийБлит (картинка_вращения, пусто, экран, &dest) < 0)
         {
            пишиф ( "Blit failed: %s\n", сдлДайОш ());
            break;
         }
      сдлОсвободиПоверхность (картинка_вращения);
      }
   
         /* Display by flipping screens */
         сдлОбновиПрямоуг (экран, 0, 0, 0, 0);
      }
   
   /* Pause for a sec */
   сдлЗадержка (1000);
}