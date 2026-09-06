/*
wojtek[at]bitologia.org

2021-02-09
2021-02-16 clean code
2021-02-17 export reduce24 as a header

vertical stripes moving horizontally

        $ gcc -Werror -o ASCII_FH ASCII_FH.c
	$ ./ASCII_FH GIMP_RAW_DATA_FILE.data OUT.ASM



*/




#include <stdio.h>
#include <stdlib.h>
#include <string.h>


#include "data_reduce24.h"
const int DATA_SIZE = 768000;

void prepare_DB(unsigned char*, char*);

int
main(int argc, char** argv)
{
    if (argc!=3)
    {
    	printf("\ninvalid arguments!\n\n");
    	return 1;
    }

    char *OUT_ASM = argv[2];
    unsigned char *DATA768, *DATA32_REDUCED;
    FILE *F = fopen(argv[1], "rb");

    DATA768 = (unsigned char*) malloc(sizeof(unsigned char) * DATA_SIZE);
    if (DATA768==NULL)
    {
        printf("OUT OF RAM!");
        exit(1);
    }
    fread(DATA768, DATA_SIZE, 1, F);
    fclose(F);
    DATA32_REDUCED = reduce24(DATA768);
    prepare_DB(DATA32_REDUCED, OUT_ASM);
   
    return 0;
}








void
prepare_DB(unsigned char *DATA32, char* OUT_ASM)
{
    unsigned char x, dx, y, j;
    unsigned short m, cx=0;
    char sys_cmd[32];

    strcpy(sys_cmd, "cp ASCII_FH.CORE ");
    strcat(sys_cmd, OUT_ASM);
    system(sys_cmd);

    FILE *F = fopen(OUT_ASM, "a");

	for (dx=1; dx<=8; dx++) {
		fprintf(F, "FRAME_%02d ", dx);
        for (y=1; y<=25; y++) // scan vertically each column
    	{
        	for (x=dx; x<=80; x+=8) // F1 = 1 9 17 25 33 41 49 57 65 73, F2 = 2, 10, ... 74, ... , F8 = 8, ..., 80
        	{
///printf("x=%d y=%d dx=%d\n", x,y, dx);
		fprintf(F, "DB ");
            	for (j=0; j<16; j++)
            	{
                	m = 1280 * (y - 1) + x + 80 * j;
               	fprintf(F, "%d", DATA32[m - 1]);
					if (j<15)
					{
					fprintf(F,",");
					}
            	}
			fprintf(F, "\n");
        	}
		//	printf("\n");
    	}
	}
fprintf(F, "end start\n");
    fclose(F);
    free(DATA32);
}




