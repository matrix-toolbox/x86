/*

wojtek[at]bitologia.org

2021-01-25 it works!
2021-01-27 proper DB formatting and full *.ASM file constructor
2021-01-29 debugging
2021-02-16 clean code
2021-02-17 export reduce24 as a header

static ASCII "graphics"
=======================
GIMP RAW data converter: prepares a table of [redefined] ASCII characters
to be displayed in the 0x03 DOS text mode. Works only for ["static"]
images that can be encoded using no more than 256 different ASCIIs.
For more complicated images one should try ASCII_*.c.
 
input:
	GIMP_RAW_DATA.data file (cf. documentation in ASCII_modification.html for details)

output:
	OUT.ASM -- assembly source code ready for compilation:
	C:\ASCII> TASM OUT.ASM || TLINK /t OUT.OBJ || OUT.COM

usage:
	$ gcc -Werror -o ASCII ASCII.c
	$ ./ASCII GIMP_RAW_DATA_FILE.data OUT.ASM
        > TASM OUT.ASM || TLINK /t OUT.OBJ || OUT.COM

there are two main subroutines:
  reduce24(...)
	= a replacement of GIMP_RGB_data_converter.sh
	it takes every 24 consecutive bytes of INPUT RAW DATA file
	and flattens every triplet to a single byte
	FF FF FF 00 00 00 .. 00 00 00 ---> FF 00 .. 00
	and finally
	converts 8 bytes in a sequence (treated as a binary string) to a single byte
  prepare_DB(...)
	= checks how many new ASCII characters are needed for a picture to be reproduced
	if there are at most 256 of them, a picture can be "drawn"
	and appropriate data is prepared two arrays: ASCII_NEW and ASCII_MAP
	otherwise it FAILs
*/




#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "data_reduce24.h"
const int DATA_SIZE = 768000;
const int DB_ROW = 16; // how many comma-separated data tokes are placed in an assembly DB row
                       // (cannot be too much of them, since old editors just die)

void prepare_DB(unsigned char*, char*);

int
main(int argc, char** argv)
{
    if (argc!=3)
    {
        printf("\nmissing arguments!\n\n$ ./ASCII INPUT_GIMP_RAW.data OUT.ASM\n\n");
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
    char sys_cmd[32];
    unsigned char T[16];
    unsigned char SCREEN[25][80]; // SCREEN ~~ MAPPING
    unsigned char x, y, j, strings_are_equal, *NEW_ASCII;
    unsigned short m, mm = 0, cx = 0, a_size = 0;
    unsigned short next_row;
    FILE *LOG_F=fopen("ASCII.LOG", "w"), *F;

    printf("--> prepare new ASCII table...................... ");

    for (y=1; y<=25; y++)
    {
        for (x=1; x<=80; x++)
        {
            cx++;
            fprintf(LOG_F, "\n");
            for (j=0; j<16; j++)
            {
                m = 1280*(y-1)+x+80*j; // watch the type of 'm'!
                fprintf(LOG_F, "%02x ", DATA32[m-1]);
                T[j] = DATA32[m-1];
            }
            fprintf(LOG_F, "number of ASCII=%04d, x=%02d, y=%02d cx=%d", a_size, x, y, cx);
            if (!a_size)
            { // initial step
                NEW_ASCII = (unsigned char*) malloc(sizeof(unsigned char) * ++a_size << 4);
                if (NEW_ASCII==NULL)
                {
                    printf("OUT OF RAM!");
                    exit(1);
                }
                for (j=0; j<16; j++)
                    NEW_ASCII[j] = T[j]; // TODO: strcpy instead of loop!
                SCREEN[y-1][x-1] = cx;
            }
            else
            {
                for (m=0; m<a_size; m++)
                {
                    strings_are_equal = 1;
                    for (j=0; j<16; j++)
                        if (NEW_ASCII[m*16+j] != T[j])
                            strings_are_equal = 0;
                        if (strings_are_equal == 1)
                            break;
                }
                if (!strings_are_equal)
                {
                    NEW_ASCII = realloc(NEW_ASCII, sizeof(unsigned char) * ++a_size << 4);
                    for (j=0; j<16; j++)
                    {
                        NEW_ASCII[(a_size-1)*16 + j] = T[j]; // TODO: strcpy...
                        if (NEW_ASCII==NULL)
                        {
                            printf("OUT OF RAM!");
                            exit(1);
                        }
                    }
                }
                else
                    fprintf(LOG_F, " used @[%04d]", m);
                mm = m;
            }
            SCREEN[y-1][x-1] = mm;
        }
    }
    fclose(LOG_F);
    free(DATA32);

    printf("done\n");
    printf("--> it is %d different ASCII characters to be redefined\n", a_size);
    if (a_size <= 256)
    {
         printf("----------------------\n");
         printf("-         OK         -\n");
         printf("----------------------\n\n");
    }
    else
    {
         printf("----------------------\n");
         printf("-        FAIL        -\n");
         printf("----------------------\n");
         free(NEW_ASCII);
         exit(2);
    }

    strcpy(sys_cmd, "cp ASCII.CORE ");
    strcat(sys_cmd, OUT_ASM);
    system(sys_cmd);


    F=fopen(OUT_ASM, "a");
    fprintf(F, "ASCII_MAP ");
    for (y=1; y<=25; y++)
    {
        for (x=1; x<=80; x++)
        {
            if (!((x-1) % DB_ROW))
            {
                if (y==1 && x==1) // because the first DB line cannot be broken!!
                    fprintf(F, "DB ");
                else
                {
                    fprintf(F, "\n\tDB ");
                    next_row = 0;
                }
            }
            printf("%02x", SCREEN[y-1][x-1]);
            fprintf(F, "%d", SCREEN[y-1][x-1]);
            if (next_row < DB_ROW - 1)
                fprintf(F, ", ");
            next_row++;
        }
        printf("\n");
    }
    fprintf(F, "\n");
    fclose(F);
    printf("\n--> saving ASCII_MAP array .................... done");



    // this array does not need additional alignment with DB_ROW
    // because it just have constant (16) value of elements in a row
    printf("\n--> saving ASCII_NEW array .................... ");
    F=fopen(OUT_ASM, "a");
    fprintf(F, "ASCII_NEW ");
    for (m=0; m<a_size; m++)
    {
        (m==0) ? fprintf(F, "DB ") : fprintf(F, "\tDB ");
        for (j=0; j<16; j++)
        {
            fprintf(F, "%d", NEW_ASCII[m*16+j]);
            if (j<15)
                fprintf(F, ", ");
        }
        fprintf(F, "\n");
    }

    fprintf(F, "end start\n");

    fclose(F);
    printf("done\n");
    printf("--> file %s is ready for assembling!\n\n", OUT_ASM);

    free(NEW_ASCII);
}



