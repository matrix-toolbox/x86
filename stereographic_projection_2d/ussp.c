/*
        2020-11-15 wojtek [at] bitologia.org

        Ulam spiral transformed by 2D stereographic projection
        https://en.wikipedia.org/wiki/Ulam_spiral

        based on the gfx library by Douglas Thain / CS 20211
        https://www3.nd.edu/~dthain/courses/cse20211/fall2013/gfx/

        compile:
            $ gcc ussp.c gfx.c -o ussp -lX11 -lm
            $ ./ussp

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
int stereographic_radius = 350;
int xc = 350; // screen center
int yc = 350;

int is_prime(unsigned int);
void put_tp(unsigned int, int, int);

int main() {
        char c;
        unsigned int j;
        int x, y, r, t;
        x = 0;
        y = 0; // we start from the origin
        int du, dl, dd, dr;
        du = 1;
        dl = 1;
        dd = 2;
        dr = 2;

        srand (time(NULL));
        gfx_open(window_xsize, window_ysize, "Ulam Spiral");
	
        for (j=1;j<1000000000;){
                for (t=1; t<=du; t++){
                        j++;
                        y--;
                        put_tp(j, x, y);
                }
                for (t=1; t<=dl; t++){
                        j++;
                        x--;
                        put_tp(j, x, y);
                }
                for (t=1; t<=dd; t++){
                        j++;
                        y++;
                        put_tp(j, x, y);
                }
                for (t=1; t<=dr; t++){
                        j++;
                        x++;
                        put_tp(j, x, y);
                }
                du += 2;
                dl += 2;
                dd += 2;
                dr += 2;
        }
	
        while(1) {
                c = gfx_wait();
                if(c == 'q')
                        break;
        }
        return 0;
}


void put_tp(unsigned int j, int x, int y) {
        int R = stereographic_radius;
        int xx = ceil(1.0 * x * R / sqrt(x*x+y*y+R*R));
        int yy = ceil(1.0 * y * R / sqrt(x*x+y*y+R*R));
        int G = 256 - ceil(sqrt(xx*xx+yy*yy)*255.0/R);
        if (is_prime(j))
                gfx_color(0,0,0);
        else
                gfx_color(G,G,G);
        gfx_line(xc+xx, yc+yy, xc+xx+1, yc+yy+1); // put pixel
}

int is_prime(unsigned int p) {
        int d;
        for (d=2; d<= ceil(sqrt(p)); d++) {
                if ((int) (1.0 * p / d) == 1.0 * p / d)
                        return 1;
        }
        return 0; // negative logic to get a neat picture
}

