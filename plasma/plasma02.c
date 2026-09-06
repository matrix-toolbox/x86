// wojtek[at]bitologia.org
// 2020-08-27

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>

int main(int argc, char** argv) {

	const unsigned char L = 128;
	unsigned char plasma[L+1][L+1], step;
	unsigned char j, k, s;
	unsigned char noise = 128;
	time_t t;
    FILE *fp;
   
   	srand((unsigned) time(&t));


	for (j=0; j<L+1; j++) { for (k=0; k<L+1; k++) { plasma[j][k] = 0; }} // just to be sure...

	// initialize corners with random integers in [0..255]
	step = 0;
	plasma[0][0] = rand() % 256;
	plasma[0][L] = rand() % 256;
	plasma[L][0] = rand() % 256;
	plasma[L][L] = rand() % 256;


	unsigned int nR,lim, w, h, px, py;

	do {
		step++;
		nR = (int) pow(4.0, step-1.0);
		w = (int) (L / pow(2.0, step - 1.0));
		h = (int) (L / pow(2.0, step - 1.0));
		px = (int) (L / pow(2.0, step - 1.0));
		py = (int) (L / pow(2.0, step - 1.0));
		lim = (int) (pow(2.0, step-1.0)-1);
		
//		printf("#R: %d\tof size:(%f x %f)\t at pos:{%f x j, %f x k} for j and k in {0 .. %d}\n",nR, w,h,px,py,lim);
//		printf("diamond points:\n");
		for (j=0; j<=lim; j++) {
			for (k=0; k<=lim; k++) {
//				printf("(%f, %f) ", px * j + px/2.0, py * k+py/2.0);
				plasma[px*j+px/2][py*k+py/2] = (plasma[px*j][py*k] + plasma[px*j+px][py*k]+ plasma[px*j][py*k+py] + plasma[px*j+px][py*k+py]) / 4 + rand() % noise;
			}
		}
//		printf("\n\n");
//		printf("corner points:\n");
		for (j=0; j<=lim; j++) {
			for (k=0; k<=lim; k++) {
//				printf("(%d, %d) ", px*j+px/2, py*k);				
//				printf("(%d, %d) ", px*j+px/2, py*k+py);
//				printf("(%d, %d) ", px*j, py*k+py/2);
//				printf("(%d, %d) ", px*j+px, py*k+py/2);
				
				// no checking if already filled
				// upper
				plasma[px*j+px/2][py*k]=(plasma[px*j][py*k]+plasma[px*j+px][py*k]+plasma[px*j+px/2][py*k+py/2])/3+ rand() % noise;
				// lower
				plasma[px*j+px/2][py*k+py]=(plasma[px*j+px/2][py*k+py/2]+plasma[px*j][py*k+py]+plasma[px*j+px][py*k+py])/3+ rand() % noise;
				// left	
				plasma[px*j][py*k+py/2]=(plasma[px*j][py*k]+plasma[px*j][py*k+py]+plasma[px*j+px/2][py*k+py/2])/3+ rand() % noise;
				// right
				plasma[px*j+px][py*k+py/2]=(plasma[px*j+px][py*k]+plasma[px*j+px][py*k+py]+plasma[px*j+px/2][py*k+py/2])/3+ rand() % noise;
			}
		}
//		printf("\n\n");
		
		
	noise =noise/2;
	} while (px > 2); // loop runs up to the limit of resolution



 	fp = fopen("plasma02.dat", "w+");
	for (j=0; j<L+1; j++) {
		for (k=0; k<L+1; k++) {
			fprintf(fp, "%d %d %d\n", j, k, plasma[j][k]);
		}
	}
    fclose(fp);


	return 0;
}
