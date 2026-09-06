/*
 wojtek[at]bitologia.org

2021-02-16 clean code
2021-02-17 export reduce24 as a header

        $ gcc -Werror -o ASCII_FM ASCII_FM.c
	$ ./ASCII_FM GIMP_RAW_DATA_FILE.data OUT.ASM


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
    unsigned char x, y, j;
    unsigned short m, cx=0;
    char sys_cmd[32];

    strcpy(sys_cmd, "cp ASCII_FM.CORE ");
    strcat(sys_cmd, OUT_ASM);
    system(sys_cmd);

    FILE *F = fopen(OUT_ASM, "a");
    for (y=1; y<=25; y++)
    {    
        printf("\nLINE_%02d ",y);
        fprintf(F, "\nLINE_%02d ",y);
        for (x=1; x<=80; x++)
        {
            // /*DEBUG*/ printf("row=%d\tcol=%d\t#ASCII=%d\n", y, x, ++cx);
            if (x == 1)
            {
                printf("DB ");
                fprintf(F, "DB ");
            }
            for (j=0; j<16; j++)
            {
                if (x != 1 && j == 0)
                {
                    printf("\tDB ");
                    fprintf(F, "\tDB ");
                }
                m = 1280 * (y - 1) + x + 80 * j;
                printf("%d", DATA32[m - 1]);
                fprintf(F, "%d", DATA32[m - 1]);
                if (j<16-1)
                {
                    printf(",");
                    fprintf(F, ",");
                }
            }
            printf("\n");
            fprintf(F, "\n");
        }
    }
    printf("done!\n");
    fprintf(F, "end start\n");
    fclose(F);
    free(DATA32);
}




