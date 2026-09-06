// 2005-01-26
// wojciech bruzda @ IFUJ
//
// Simple communication via COM port.

#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <dos.h>
#include <iostream.h>
#include <string.h>
#include <io.h>

#define _PORT 0x2F8 // COM_2 ADDRESS

typedef unsigned long int uL;

void cc_intro() {
    clrscr();
    textcolor(10);
    cprintf("RS FILE SENDING\r\n\n");
    textcolor(7);
}

unsigned long cc_send_data(char *data_str, unsigned long DATA_LENGTH) {
	unsigned char _DATA;
	for (unsigned long i = 0; i < DATA_LENGTH; i++) {
		delay(10);
		_DATA = data_str[i]; // byte by byte
		_asm {
			MOV AL, _DATA;
			MOV DX, _PORT;
			OUT DX, AL;
		}
	}
	return i; // amount of bytes to send
}

void cc_send_flag(char A) { // send single byte
	_asm {
		MOV AL, A;
		MOV DX, _PORT;
		OUT DX, AL;
	}
}

int main() {

	cc_intro();
	
	char RECEIVED = 0, *file_name;

	cout << "Enter file name" << endl; scanf("%[A-Za-z.]", file_name);

	FILE *F;

	if ((F = fopen(file_name, "r")) == NULL) {
		cout << "File not found!" << endl;
		getch();
		exit(1);
	}

	fseek(F, 0L, SEEK_END);
	unsigned long FILE_LENGTH = ftell(F);
	fseek(F, 0L, SEEK_SET);

	char *cc_buffer = (char *) malloc(FILE_LENGTH * sizeof(char));

	for (int j = 0; j < FILE_LENGTH; j++)
		cc_buffer[j] = getc(F);
	_asm {
		MOV AL, -1; // listening...
		MOV DX, _PORT;
		OUT DX, AL;
	}

	cout << "Sending data..." << endl;

	cc_send_data(cc_buffer, FILE_LENGTH);
	delay(10);

	_asm {
		MOV AL, -2; // EOT
		MOV DX, _PORT;
		OUT DX, AL;
	}

	RECEIVED = 0;

	while (RECEIVED != -4) { // status confirmed
		_asm {
			MOV DX, _PORT;
			IN AL, DX;
			MOV RECEIVED, AL;
		}
	}

	cout << "Data sent." << endl;

	fclose(F);

	free (cc_buffer);

	cc_send_flag(0); // reset all flags

	return 0;
}
