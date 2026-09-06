// 2005-05-11
// wojciech bruzda @ IFUJ
//
// Tomograph 2D; based on the step motor disassembled from FDD 5.25".

#include <stdio.h>
#include <graphics.h>
#include <conio.h>
#include <dos.h>
#include <stdlib.h>
#include <math.h>

#define LPT 0x378 // active LPT port address

int main() {
	int gdriver = DETECT, gmode, errorcode;
	initgraph(&gdriver, &gmode, "c:\bc311\bin");
	outtextxy(1, 1, "Wojciech Bruzda | Tomograf v0.1 :) --> ESC=Exit...");

	int F = 1;   // 1/0 : incoming/outcoming seat
	int R = 100; // radius of the envelopes being drawn
	int A = 200; // half a length of dashes
	int DR = 3;  // rotation delay
	int DT = 4;  // translation delay

	for (int j = 0; j < 20; j++) { // 20 is a full translation
		R -= 10;
		if (F) {
			delay(DT); outportb(LPT, 1); // sequences steering the motor
			delay(DT); outportb(LPT, 2);
			delay(DT); outportb(LPT, 4);
			delay(DT); outportb(LPT, 8);
		} else {
			delay(DT); outportb(LPT, 8);
			delay(DT); outportb(LPT, 4);
			delay(DT); outportb(LPT, 2);
			delay(DT); outportb(LPT, 1);
		}

		for (int i = 0; i < 25; i++) { // 25 is a full period of rotation
			delay(DR); outportb(LPT, 16);
			delay(DR); outportb(LPT, 32);
			delay(DR); outportb(LPT, 64);
			delay(DR); outportb(LPT, 128);

			if (kbhit())
			if (getch() == 27) exit(2); // terminates when ESC pressed

			if ((inportb(LPT + 0x01) & 32) != 32) { // check if there is some obstacle between the leds
				double alfa = 0.08 * i * M_PI;
				double ca = cos(alfa);
				double sa = sin(alfa);
				int x = 320 + (int) (R * ca);
				int y = 240 + (int) (R * sa);
				moveto(x, y); lineto(x + (int)(A * sa), y - (int)(A*ca));
				moveto(x, y); lineto(x - (int)(A * sa), y + (int)(A*ca));

			} // if ((inportb...
		} // for (int i...
	} // for (int j...

	outtextxy(1,11,"Scanning terminated. Press any key...");
	getch();
	closegraph();
	return 0;
}
