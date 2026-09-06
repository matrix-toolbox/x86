/*
2021-02-06 wojtek[at]bitologia.org


movie: 3 lines (240 ASCII chars) --> 92160 bytes of each frame

we have 13 files BF*.gif of size 640x48 that correspond
to 13 frames of size 80x3 in the 0x03 text mode
and
we have 13 data files BF*.data with RGB encoding
which serve as input for this script


simple arithmetics:
    92160 bytes of *.data = 240 characters x 3 RGB x 8x16 array

    or, equivalently:

    ........ 1  }
    ........ 2  }
    :           }
    ........ 16 } x 240 == three lines of 80 characters each



final check:
    $ feh -F BF*gif
and use arrows to animate :) (G is jumping "intentionally")

when everything is correct just:
    $ ./RUN
it should produce ready to compile file: B2.ASM


(B1.ASM refers to the first "static" BITOLOGIA printout)


*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


#define DATA_SIZE 92160
#define DATA_SIZE_REDUCED 3840

unsigned char* reduce24(unsigned char*); // TODO: reduced24 is in common with ASCII.c -- must be merged somehow!
void prepare_DB(unsigned char*, unsigned char);

int
main(int argc, char** argv)
{
    if (argc!=3)
    {
        printf("\ninvalid arguments!\n\n");
        return 1;
    }

    unsigned char *DATA, *DATA_REDUCED;
    FILE *FP;

    DATA = (unsigned char*) malloc(sizeof(unsigned char) * DATA_SIZE);
    if (DATA==NULL)
    {
        printf("OUT OF RAM!");
        return 3;
    }
    FP = fopen(argv[1], "rb");
    fread(DATA, DATA_SIZE, 1, FP);
    fclose(FP);
    DATA_REDUCED = reduce24(DATA);
    // TODO: is that freeing correct?
    prepare_DB(DATA_REDUCED, (unsigned char)atoi(argv[2]));
    free(DATA_REDUCED);
    return 0;
}

unsigned char*
reduce24(unsigned char *DATA)
{
    unsigned char j, k, ASCII_VALUE, *DATA_REDUCED;
    unsigned short i=0;
    unsigned int m;
    DATA_REDUCED = (unsigned char*) malloc(sizeof(unsigned char) * DATA_SIZE_REDUCED);
    if (DATA_REDUCED==NULL)
    {
        printf("OUT OF RAM!");
        return NULL;
    }
    for (m=0; m<DATA_SIZE; m+=24)
    {
        ASCII_VALUE = 0;
        k = 128;
        for (j=0; j<24; j+=3)
        {
            ASCII_VALUE += (DATA[m+j]/255) * k;
            k >>= 1;
        }
        DATA_REDUCED[i++] = ASCII_VALUE;
    }
    free(DATA);
    return DATA_REDUCED;
}



void
prepare_DB(unsigned char *DR, unsigned char frame_no)
{
    unsigned char x, y, j;
    unsigned short m;
    printf("\nFRAME_%02d ", frame_no);
    for (y=1; y<=3; y++)
    {
        for (x=1; x<=80; x++)
        {
            printf("DB ");
            for (j=0; j<16; j++)
            {
                m = 1280 * (y - 1) + x + 80 * j;
                printf("%d", DR[m - 1]);
                if (j<16-1)
                {
                    printf(",");
                }
            }
            printf("\n");
        }
    }
}




