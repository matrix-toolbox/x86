// 2005-01-05
// wojciech bruzda @ IFUJ
//
// Read the signal from the wave generator connected to PC via 8535
// and display result on the screen.

#include <stdio.h>
#include <conio.h>
#include <iostream.h>
#include <stdlib.h>
#include <dos.h>
#include <graphics.h>
#include <math.h>

#define GA 0x300 // GATE A
#define GB 0x301 // GATE B
#define GC 0x302 // GATE C

//   decode the values

int _decode(unsigned char IA, unsigned char IB, unsigned char IC) {
     int D = 0;
//   declare three arrays for to the binary representation of the respective gate values
     int AT[8], BT[8], CT[8];
     int i;

     for (i = 0; i < 8; i++) AT[i] = BT[i] = CT[i] = 0;

//   deciimal to binary conversion
     i = 0; while(IA) { AT[i++] = IA % 2; IA /= 2; }
     i = 0; while(IB) { BT[i++] = IB % 2; IB /= 2; }
     i = 0; while(IC) { CT[i++] = IC % 2; IC /= 2; }

//   reconstruct the values from two gates using the arrays
     for (i = 0; i < 4; i++)
          if (AT[i]) D += ((int) pow(2.0, i) * 1000);

     for (i = 4; i < 8; i++)
          if (AT[i]) D += ((int) pow(2.0, i - 4) * 100);

     for (i = 0; i < 4; i++)
          if (BT[i]) D += ((int) pow(2.0, i) * 10);

     for (i = 4; i < 8; i++)
          if (BT[i]) D += ((int) pow(2.0, i - 4) * 1);

//   get the sign out of CT[7]
     if (CT[7]) D = -D;

//   normalize the results with respect to a given precision and display the info

     if (CT[1]) {
         D = D / 10.0;
         gotoxy(20, 1);
         printf("[100 mV]");
     }
     if (CT[2]) {
         D = D * 10.0;
         gotoxy(20, 1);
         printf("[1000 V]");
     }
     if (CT[3]) {
         D = D / 10.0;
         gotoxy(20, 1);
         printf("[10 V]");
     }
     if (CT[4]) {
         D = D / 100.0;
         gotoxy(20, 1);
         printf("[1 V]");
     }
     if (CT[5]) {
         D = D/1.0;
         gotoxy(20, 1);
         printf("[100 V]");
     }

     return D;
}
////////////////////////////////////////////////////////////////////////////

// Analog-Digital Converter switch

int _decode4ADC(unsigned char IA, unsigned char IB) {
    int D = 0;
    int AT[8], BT[8];
    int i;
    for (i = 0; i < 8; i++) AT[i] = BT[i] = 0;

    i = 0; while (IA) { AT[i++] = IA % 2; IA /= 2; }
    i = 0; while (IB) { BT[i++] = IB % 2; IB /= 2; }

    for (i = 0; i < 8; i++)
        if (AT[i]) D += ((int) pow(2.0, i));

    for (i = 0; i < 4; i++)
        if (BT[i]) D += ((int) pow(2.0, i + 8));

    return D / 10.0;
}

////////////////////////////////////////////////////////////////////////////
int main() {
    clrscr();

    int gdriver = DETECT, gmode, errorcode;
    initgraph(&gdriver, &gmode, "");
    errorcode = graphresult();
    if (errorcode != grOk) {
        printf("Graphics error: %s\n", grapherrormsg(errorcode));
        printf("Press any key to halt:");
        getch();
        exit(1);
    }

//  initiate the 8255 device
//  toggle direction: 0x98 = all gates (8255) open for a read mode
    outportb(0x303, 0x9B);

    int j = 0, KEY = 0x00, iA, iB, iC;

//  read the A, B and C gates until ESC pressed

    while (KEY != 27) {
        iA = inportb(GA);
        iB = inportb(GB);
        iC = inportb(GC); // turn off for ADC

        delay(20);
        putpixel((int)(j), 240 + (int)(_decode(iA, iB, iC)), GREEN);

//      axes...
        line(  0, 240, 640, 240);
        line( 10,   0,  10, 480);
        line( 12, 160,   8, 160);
        line( 12,  80,   8,  80);
        line( 12, 320,   8, 320);
        line( 12, 400,   8, 400);
        line( 80, 238,  80, 242);
        line(160, 238, 160, 242);
        line(240, 238, 240, 242);
        line(320, 238, 320, 242);
        line(400, 238, 400, 242);
        line(480, 238, 480, 242);
        line(560, 238, 560, 242);
//   ...and caption
        outtextxy(15, 7, "Voltage");

        j = (j + 1) % (640);

        if (j == 0) cleardevice();

        if (kbhit()) {
            KEY = getch();
        }
    }

    closegraph();

    return 0;
}
