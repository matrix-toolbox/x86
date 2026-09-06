/*

wojtek[at]bitologia.org


  reduce24(...)
	= a replacement of GIMP_RGB_data_converter.sh
	it takes every 24 consecutive bytes of INPUT RAW DATA file
	and flattens every triplet to a single byte
	FF FF FF 00 00 00 .. 00 00 00 ---> FF 00 .. 00
	and finally
	converts 8 bytes in a sequence (treated as a binary string) to a single byte
*/

const int DATA_SIZE_REDUCED = 32000;
extern const int DATA_SIZE;

unsigned char* reduce24(unsigned char*);

unsigned char*
reduce24(unsigned char *DATA768)
{
    unsigned char j, k, ASCII_VALUE, *DATA32_REDUCED;
    unsigned int m, i=0;

    DATA32_REDUCED = (unsigned char*) malloc(sizeof(unsigned char) * DATA_SIZE_REDUCED);
    if (DATA32_REDUCED==NULL)
    {
        printf("OUT OF RAM!");
        exit(1);
    }

    printf("\n--> reduce GIMP RAW DATA file to a binary form... ");
    for (m=0; m<DATA_SIZE; m+=24)
    {
        ASCII_VALUE = 0;
        k = 128;
        for (j=0; j<24; j+=3)
        {
            ASCII_VALUE += (DATA768[m+j]/255) * k;
            k >>= 1;
        }
        DATA32_REDUCED[i++] = ASCII_VALUE;
    }
    printf("done\n");
    free(DATA768);
    return DATA32_REDUCED; // the result should be reduced 24 times to 32000 bytes
}




