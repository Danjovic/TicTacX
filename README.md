# Tic Tac X

Tic Tac X is a portable color bar genarator designed to be provide the identification of VGA monitors that are able to operate with RS-170 (RGB 15.75KHz hsync).
The signals generated mimics the timing of syncrhonization pulses produced by TMS9128 (MSX1), V9938 (MSX2) and TK90X ULA (ZX Spectrum clone). A VGA mode is also provided to check the operational state of the monitor under native video signal. 


## Operation
The board provides a Jumper to turn on/off the board. As soon as the Jumper is inserted the board is powered and the VGA mode kicks in.

The board also provides a push button to change the signal mode. At every press it advances to the next mode until it returns to native (VGA) mode.

Those are the modes available:

1. VGA,  separated Hsync and Vsync 
2. NTSC, composite sync on Hsync pin
3. NTSC, separated Hsync and Vsync 
4. NTSC, sync on green
5. PAL,  composite sync on Hsync pin
6. PAL,  separated Hsync and Vsync 
7. PAL,  sync on green


All modes provide a colour bar pattern in the following sequene:

![Colour Bars](/doc/colorBars.png)

All modes, except VGA provide an horizontal bar atthe middle of the height of the screen that provides information about the mode being generated, type of synchronism signals and vertical frequency
 
![Colour Bars and Indication](/doc/colorBarsIndication.png)

*Modes:*
* MSX1 - TMS9128 compatible, 262/313 lines progressive
* MSX2 - V9938 compatible, 525/625 lines interlaced
* TK90 - (ZX spectrum clone)

*Synchronism type:*
* CSy - Composite sync on Hsync line
* HV  - Separate Hsync and Vsync
* SoG - Sync on Green


The color of such bar relates to the type of synchronism signals
* Yellow: Composite sync
* White:  Separate Hsync
* Green:  Sync on Green

*Vertical frequency:*
* 60 - NTSC
* 50 - PAL


## Battery Saving
After 1 minute without any press of the button the board enters in sleep mode to save the battery, but when the board is not in use the on/off jumper shall be off.

## Targets
The circuit is targetted for PIC microcontrollers with at least 14 pins, capable to operate at 20MHz. The current code requires at least 4kWords of flash and is targetted for PIC16F648A and 16F688A. 

## Limitations
The source code provides support for PAL (50Hz) operation, but the current implementation only provides the NTSC (60Hz) modes. 
There are at least two ways to implement support for PAL:
* Add 6 PAL modes cycling after (or in between) the existing;
* use the solder jumper under the board to provide the PAL modes instead of the NTSC modes;
* use the solder jumper under the board to provide the extra 6 PAL modes;
