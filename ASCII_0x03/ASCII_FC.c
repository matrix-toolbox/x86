/*
wojtek[at]bitologia.org

2021-02-08
2021-02-09 RGB-cube metrics
2021-02-16 clean code
2021-02-17 export reduce24 as a header

successor of ASCII_F.c
handling 16-colour pallette


1. prepare 640x400 file
2. rescale to 80x25 with 16 colors --> export as *_c.data
3. go back to 640x400, reduce using appropriate dithering and export as *.data
4a. gcc -Werror -o ASCII_FC ASCII_FC.c -lm
4b. $ ./ASCII_FC <file>.data <file>_c.data OUT.ASM
5. C:/> TASM OUT.ASM || TLINK /T OUT.OBJ || OUT.COM
*/




#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include "data_reduce24.h"
const int DATA_SIZE = 768000;
const int RGB_C_SIZE = 6000; // size of *_c.data file with 16 RGB colours

void prepare_DB(unsigned char*, char*); // 3 lines by default
void reduce3c(unsigned char*, char*);
unsigned char get_c(unsigned char, unsigned char, unsigned char);

unsigned char VGA_color[16][3] = {
	{0x00, 0x00, 0x00}, //  0 black
	{0x00, 0x00, 0x80}, //  1 navy
	{0x00, 0x80, 0x00}, //  2 green
	{0x00, 0x80, 0x80}, //  3 teal
	{0x80, 0x00, 0x00}, //  4 maroon
	{0x80, 0x00, 0x80}, //  5 purple
	{0x80, 0x80, 0x00}, //  6 olive
	{0xc0, 0xc0, 0xc0}, //  7 silver
	{0x80, 0x80, 0x80}, //  8 gray
	{0x00, 0x00, 0xff}, //  9 blue
	{0x00, 0xff, 0x00}, // 10 lime
	{0x00, 0xff, 0xff}, // 11 aqua/cyan
	{0xff, 0x00, 0x00}, // 12 red
	{0xff, 0x00, 0xff}, // 13 fuchsia/magenta
	{0xff, 0xff, 0x00}, // 14 yellow
	{0xff, 0xff, 0xff}  // 15 white
};

////////////////////////////////////////////////////////////////////////////////////
int
main(int argc, char** argv)
{
    if (argc!=4)
    {
    	printf("\ninvalid arguments!\n\n");
    	return 1;
    }

    char *OUT_ASM = argv[3];
    unsigned char *DATA768, *DATA32_REDUCED,*RGB_C;
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
  

//  prepare color map
    RGB_C = (unsigned char*) malloc(sizeof(unsigned char) * RGB_C_SIZE);
    if (RGB_C==NULL)
    {
    	printf("OUT OF RAM!");
    	return 3;
    }
    F = fopen(argv[2], "rb");
    fread(RGB_C, RGB_C_SIZE, 1, F);
    fclose(F);
    reduce3c(RGB_C, OUT_ASM);
    free(RGB_C);
    
    return 0;
}




void
prepare_DB(unsigned char *DATA32, char* OUT_ASM)
{
    unsigned char x, y, j;
    unsigned short m, cx=0;
    char sys_cmd[32];

    strcpy(sys_cmd, "cp ASCII_FC.CORE ");
    strcat(sys_cmd, OUT_ASM);
    system(sys_cmd);

    FILE *F = fopen(OUT_ASM, "a");
    for (y=1; y<=25; y++)
    {
        fprintf(F, "\nLINE_%02d ",y);
        for (x=1; x<=80; x++)
        {
            if (x == 1)
            {
                fprintf(F, "DB ");
            }
            for (j=0; j<16; j++)
            {
                if (x != 1 && j == 0)
                {
                    fprintf(F, "\tDB ");
                }
                m = 1280 * (y - 1) + x + 80 * j;
                fprintf(F, "%d", DATA32[m - 1]);
                if (j<16-1)
                {
                    fprintf(F, ",");
                }
            }
            fprintf(F, "\n");
        }
    }
    fclose(F);
    free(DATA32);
}



void
reduce3c(unsigned char * RGB_C, char * OUT_ASM) // color map
{
    unsigned char j, k = 0, f, n = 0;
    unsigned short m, cx=0;
    unsigned int c[16], rgb;
    
    for (j=0; j<16; c[j++] = 0) {} // reset color map

    FILE *F = fopen(OUT_ASM, "a");
    fprintf(F, "cmap DB ");

    for (m=0; m<RGB_C_SIZE; m+=3)
    {
        rgb = (RGB_C[m]<<16) + (RGB_C[m+1]<<8) + RGB_C[m+2];
        f = 0;
        j = 0;
        while (j < k && f != 1)
        {
            if (c[j] == rgb)
            {
                f = 1;
                break;
            }
            j++;
        }
        if (j==k)
        {
            c[k++] = rgb;
///*DEBUG*/ printf("RGB:%x \t k:%d\n", rgb, k);
        }
        if (m>0 && !(m % 16))
        {
            fprintf(F, "\n DB ");
        }

//		printf("%d ", get_c(RGB_C[m], RGB_C[m+1], RGB_C[m+2]));
        fprintf(F, "%d", get_c(RGB_C[m], RGB_C[m+1], RGB_C[m+2]));
        n++;
        (n < 16) ? fprintf(F, ", ") : (n = 0);
    }
    fprintf(F, "\nend start\n");
}


unsigned char
get_c(unsigned char R, unsigned char G, unsigned char B) 
{
	unsigned char c, c_opt;
	unsigned short d_opt;
	float d;
	d_opt = 0xffff;
	for (c=0; c<16; c++)
	{
	//TODO : shift it since they are all integers!
		d = sqrt(pow(R-VGA_color[c][0], 2.0) + pow(G-VGA_color[c][1], 2.0) + pow(B-VGA_color[c][2], 2.0));
		if (d < d_opt)
		{
			d_opt = d;
			c_opt = c;
		}
	}
	return c_opt;
}


