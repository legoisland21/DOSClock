# Welcome to DOSClock!

DOSClock is a really small clock for DOS made in pure assembly (without AI).

It's meant to be compiled with the NASM compiler with the command:
`nasm main.asm -o main.com`

Only thing it needs is support for interrupt 15h service 86h (wait microseconds).

For usage you need the file COLORS.DAT.

### COLORS.DAT
COLORS.DAT contains the text/background colors for the clock
The file must be exactly 32 bytes, if you have unused space fill it with 0's
The format which the data it expects is hex with the color attributes, here are the basic color attributes (in hex):
0 = Black
1 = Blue
2 = Green
3 = Aqua
4 = Red
5 = Purple
6 = Yellow
7 = White
8 = Gray
9 = Light Blue
A = Light Green
B = Light Aqua
C = Light Red
D = Light Purple
E = Light Yellow
F = Bright White
First part of the byte is the background color while the other is the text color.

### Other info

If you want to change the color changing speed you will need to modify the values of CX and DX in lines 64-67, it is currently 1s.
To calculate the values you will need to convert the delay to microsecond then get it in hex and it will look something like this (ex. 1 second) 0xF4240.
To instert it there we put the last 4 characters in DX (4240h),
and the rest in CX (000Fh).

Have fun!
