// wojtek[at]bitologia.org
// 2020-08-29 recursive version of plasma02.c

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h> // sleep
#include <time.h>
#include <math.h>


const int L = 512 ;
int plasma[512 +1][512  +1];
int noise;// = 128  ;

void ds(int x1, int y1, int x2, int y2) {
//	sleep(1);

/*	int j, k;
	for (j=0; j<L+1; j++) {
	printf("\n");
		for (k=0; k<L+1; k++) {
			printf("%3d ", plasma[j][k]);
		}
	}
	printf("\n");*/
	
	
	int x = x2-x1;
	int y = y2-y1;
	if (x <2 && y <2) {
		return;
		}

	noise = x/2; //  = noise / 2;
//	printf("x1=%d y1=%d x2=%d y2=%d x=%d y=%d n=%d\n", x1, y1, x2, y2, x, y, noise);
	// d
	plasma[x1+x/2][y1+y/2] = (plasma[x1][y1]+plasma[x1][y2]+plasma[x2][y1]+plasma[x2][y2]) / 4 + rand() % noise;
	// s
	if (!plasma[x1][y1+y/2]) // prevent recalculation that makes the terrain discountinouous
		plasma[x1][y1+y/2] = (plasma[x1][y1] + plasma[x1+x/2][y1+y/2] + plasma[x1][y2]) / 3 + rand() % noise;
	if (!plasma[x1+x/2][y1])
		plasma[x1+x/2][y1] = (plasma[x1][y1] + plasma[x1+x/2][y1+y/2] + plasma[x2][y1]) / 3 + rand() % noise;

	if (!plasma[x2][y1+y/2])	
		plasma[x2][y1+y/2] = (plasma[x2][y1] + plasma[x1+x/2][y1+y/2] + plasma[x2][y2]) / 3 + rand() % noise;
	
	if (!plasma[x1+x/2][y2])
		plasma[x1+x/2][y2] = (plasma[x1][y2] + plasma[x1+x/2][y1+y/2] + plasma[x2][y2]) / 3 + rand() % noise;
	
	ds(x1, y1, x1+x/2, y1+y/2);
	ds(x1+x/2, y1, x2, y1+y/2);
	ds(x1, y1+y/2, x1+x/2, y2);
	ds(x1+x/2, y1+y/2, x2, y2);
	
    return;
}

int main(int argc, char** argv) {

	int j, k, s;
	time_t t;
    FILE *fp;
   
   	srand((unsigned) time(&t));

	for (j=0; j<L+1; j++) { for (k=0; k<L+1; k++) { plasma[j][k] = 0; }} // just to be sure...

	// initialize corners with random integers in [0..255]
	plasma[0][0] = rand() % 256;
	plasma[0][L] = rand() % 256;
	plasma[L][0] = rand() % 256;
	plasma[L][L] = rand() % 256;

	ds(0, 0, L, L);

 	fp = fopen("plasma03.dat", "w+");
	for (j=0; j<L+1; j++) {
		for (k=0; k<L+1; k++) {
			fprintf(fp, "%d %d %d\n", j, k, plasma[j][k]);
		}
	}
    fclose(fp);

	return 0;
}
