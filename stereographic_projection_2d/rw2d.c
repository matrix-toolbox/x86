/*
        2020-11-15 wojtek [at] bitologia.org

        random walk transformed by 2D stereographic projection.
        https://en.wikipedia.org/wiki/Ulam_spiral

        based on the gfx library by Douglas Thain / CS 20211
        https://www3.nd.edu/~dthain/courses/cse20211/fall2013/gfx/

        compile:
            $ gcc rw2d.c gfx.c -o rw2d -lX11 -lm
            $ ./rw2d

        in case of problems:
            $ apt search Xlib.h
            $ sudo apt install libx11-dev
*/

#include <stdio.h>
#include "gfx.h"
#include <stdlib.h>
#include <time.h>
#include <math.h>

int window_ysize = 700;
int window_xsize = 700;
int stereographic_radius = 300;
int xc = 350; // screen center
int yc = 350;

int main() {
	char c;
        int R = stereographic_radius;
        int x, y, j, r, xx, yy;
        x = 0;
        y = 0;
        srand (time(NULL));
        gfx_open(window_xsize, window_ysize, "2D Random Walk");
        for (j=1;j<100000000;j++){
                r = rand() % 4 + 1;
                if (r==1) { x++; }
                if (r==2) { x--; }
                if (r==3) { y++; }
                if (r==4) { y--; }
                xx = ceil(1.0 * x * R / sqrt(x*x+y*y+R*R));
                yy = ceil(1.0 * y * R / sqrt(x*x+y*y+R*R));
                gfx_color(32,256-ceil(sqrt(xx*xx+yy*yy)*255.0/R), 0);
                gfx_line(xc+xx,yc+yy,xc+xx+1,yc+yy+1);
        }
        while(1) {
                c = gfx_wait();
                if(c == 'q')
                        break;
        }
        return 0;
}


