// 20120308
// wojciech bruzda
//
// $ gcc maze.c -o maze; ./maze 30 28
//
// Generate a 2D maze.
//
// The algorithm resembles classic "snake" game.
// It starts at any point of the lattice and then randomly walks until gets stuck.
// In the example below the procedure started at ">" and currently is at "^".
// If the next move would be rightward, it will soon end at "x".
//
//        +++++             +++++
//        + ^ +             + +++
//   >+++++ + + -----> >+++++ +++
//          + +               +x+
//          +++               +++
//
// To continue, it seeks for the previous position "p" that allows to move on. So it could look like "#":
//
//        +++++             +++++             +++++
//        + ^ +             + p++             +#+++
//   >+++++ + + -----> >+++++ +++ -----> >+++++#+++
//          + +               +x+            ###+++
//          +++               +++            #  +++
//
// The procedure repeats until the whole lattice is covered.

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

int main (int ac, char *av[]) {
    int Nx = atoi(av[1]);
    int Ny = atoi(av[2]);
    int M[Nx][Ny]; // maze
    int cM[Nx][Ny]; // auxiliary array used for a graphical plugin...
    int r, c, rr, cc, d, f, t = 1, n = 1, s = 11;

    for (r = 0; r < Nx; r++) {
        for (c = 0; c < Ny; c++) {
            cM[r][c] = M[r][c] = 0;
        }
    } 

    int seed = time(NULL);
    srand(seed);
    M[r = 5][c = 5] = n++; // no need to start at [0][0]

    // line_to(screen, r*1, c*1, r*1, c*1, color);

    while (t+1) {
        f = 0;
        if (r > 0 && !M[r - 1][c]) {
            f |= 1;
        }
        if (r < Nx - 1 && !M[r + 1][c]) {
            f |= 2;
        }
        if (c > 0 && !M[r][c - 1]) {
            f |= 4;
        }
        if (c < Ny - 1 && !M[r][c + 1]) {
            f |= 8;
        }

        while(f) {
            d = rand() % 4;
            if (d == 0 && f & 1) {
                M[--r][c] = n++;
                cM[r][c] |= 2;
                t = n;
                break;
            } // down
            if (d == 3 && f & 8) {
                cM[r][c] |= 1;
                M[r][++c] = n++;
                t = n;
                break;
            } // right
            if (d == 1 && f & 2) {
                cM[r][c] |= 2;
                M[++r][c] = n++;
                t = n;
                break;
            } // up
            if (d == 2 && f & 4) { 
                M[r][--c] = n++;
                cM[r][c] |= 1;
                t = n;
                break;
            } // left
        }
        t--;
        for (rr = 0; rr < Nx; rr++) {
            for (cc = 0; cc < Ny; cc ++) {
                if (M[rr][cc] == t) {
                    c = cc;
                    r = rr;
                    break;
                }
            }
        }
    }

    for (rr = 0; rr < Nx; rr++) {
        printf("\n");
        for (cc = 0; cc < Ny; cc++) {
            printf("%04d ", M[rr][cc]); // when in graphical mode just exchange this line with the following comments:
/*          if (cM[rr][cc] == 1) {
                line_to(screen, rr*s, cc*s, s+rr*s, cc*s, color);
            }
            if (cM[rr][cc] == 2) {
                line_to(screen, rr*s, cc*s, rr*s, s+cc*s, color);
            } 
            if (cM[rr][cc] == 3) {
                line_to(screen, rr*s, cc*s, s+rr*s, cc*s, color);
                line_to(screen, rr*s, cc*s, rr*s, s+cc*s, color);
            } */
        }
    }
    printf("\n");
    return 0;
}

