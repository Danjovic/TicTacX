;**********************************************************************
;            _____ _   _____          ___ ___ ___                     *
;           |_   _(_)_|_   _|_ _ __  | _ \ __|   \                    *
;             | | | / _|| |/ _` / _| |   / _|| |) |                   *
;             |_| |_\__||_|\__,_\__| |_|_\___|___/                    *
;                                                                     *
;                                                                     *
;   This program generates color bars at 15KHz horizontal frequency   *
;   in order to identify modern LCD monitors that can operate with    *  
;   80's computers like MSX and ZX Spectrum                           *
;   The video sync timing is based on TMS9918 operating manual as     *
;   well as measurements from TK90X ULA (brazilian Spectrum Clone)    *
;                                                                     *
;   The program also generates a 640x480p/60Hz signal for checking    *
;   if the monitor is working while driven by a known standard        *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Filename:	    main.asm                                          *
;    Version 0.1   December 31st 2014                                 *
;    - Basic release                                                  * 
;    Version 0.2    January  8th 2015                                 *
;    - Support PIC16F628/648                                          * 
;    - Energy Saving by Biasing Red/Blue signals with PortA pins      *
;    Version 0.3    February  14th 2015                               *
;    - Bug Correction                                                 * 
;    - MSX1 Border generation correction                              *
;    Version 0.4    March     14th 2015                               *
;    - Bug Correction in Vsync levels for TK90X mode                  * 
;    Version 0.5    March     14th 2015                               *
;    - Added Graphics routines to show Machine, Sync and Freq         *
;    Version 0.6    March     24th 2015                               *
;    - Bug Correction in background color on graphics area for TK90X  *
;    Version 0.7    April      3th 2015                               *
;    - Bug Correction in RGB/MSX2 timimg                              *
;    Version 0.8    April     22th 2015                               *
;    - Even/Odd displacement correction in RGB/MSX2                   *
;                                                                     *
;    Author:  Daniel Jose Viana                                       *
;    Company:  http://danjovic.blogspot.com                           *
;                                                                     * 
;                                                                     *
;**********************************************************************
;          ___ __  __ ___  ___  ___ _____ _   _  _ _____ _            *
;         |_ _|  \/  | _ \/ _ \| _ \_   _/_\ | \| |_   _| |           *
;          | || |\/| |  _/ (_) |   / | |/ _ \| .` | | | |_|           *
;         |___|_|  |_|_|  \___/|_|_\ |_/_/ \_\_|\_| |_| (_)           *
;                                                                     *
;    DEFINE THE CHIP USED IN CONFIGURE->SELECT DEVICE ON MPLAB        *
;                                                                     *
;**********************************************************************
;         ASCII titles by http://patorjk.com/software/taag/           *
;**********************************************************************
#ifdef __16F688
;  ___ ___ ___ _  __ ___ __  ___  ___ 
; | _ \_ _/ __/ |/ /| __/ / ( _ )( _ )
; |  _/| | (__| / _ \ _/ _ \/ _ \/ _ \
; |_| |___\___|_\___/_|\___/\___/\___/
;                                     
;
	list	 p=16f688		; list directive to define processor
	#include <P16F688.inc>	; processor specific variable definitions
	__CONFIG    _CP_OFF & _CPD_OFF & _BOD_OFF & _PWRTE_ON & _WDT_OFF & _HS_OSC & _MCLRE_ON & _FCMEN_OFF & _IESO_OFF	

#define PORT_RGB PORTC
#define TRIS_RGB TRISC
#define _CMCON CMCON0

; Pins from PORT A - Board revision C, female connector
_RED_BIAS  EQU 1  
_BLUE_BIAS EQU 2
_50HZ      EQU 0  ; 50Hz Selection

; Pins from PORT C - Board revision C, female connector
_RD       EQU 0 ; Red Pin
_GR       EQU 1 ; Green Pin
_BL       EQU 3 ; Blue Pin
_SOG      EQU 2 ; Green BIAS for Sync on Green
_HSYNC    EQU 4 ; Horizontal Sync
_VSYNC    EQU 5 ; Vertical Sync

#endif 

;**********************************************************************
;#ifdef __16F628A
;  ___ ___ ___ _  __ ___ __ ___ ___   _   
; | _ \_ _/ __/ |/ /| __/ /|_  | _ ) /_\  
; |  _/| | (__| / _ \ _/ _ \/ // _ \/ _ \ 
; |_| |___\___|_\___/_|\___/___\___/_/ \_\                                        
;                                    
;    list	 p=16f628A		; list directive to define processor
;    #include <P16F628A.inc>	; processor specific variable definitions
;    __CONFIG    _CP_OFF & _CPD_OFF & _BODEN_OFF & _PWRTE_ON & _LVP_OFF & _WDT_OFF & _HS_OSC & _MCLRE_ON 

;#define PORT_RGB PORTB
;#define TRIS_RGB TRISB
;#define _CMCON CMCON

; Pins from PORT A
;_RED_BIAS  EQU 0  
;_BLUE_BIAS EQU 1
;_50HZ      EQU 4  ; 50Hz Selection

; Pins from PORT B
;_RD       EQU 0 ; Red Pin
;_GR       EQU 5 ; Green Pin
;_BL       EQU 3 ; Blue Pin
;_SOG      EQU 4 ; Green BIAS for Sync on Green
;_HSYNC    EQU 2 ; Horizontal Sync
;_VSYNC    EQU 1 ; Vertical Sync

;#endif

;**********************************************************************
#ifdef __16F648A
;  ___ ___ ___ _  __ ___ __ _ _  ___ 
; | _ \_ _/ __/ |/ /| __/ /| | |( _ )
; |  _/| | (__| / _ \ _/ _ \_  _/ _ \
; |_| |___\___|_\___/_|\___/ |_|\___/
;                                    
    list	 p=16f648A		; list directive to define processor
    #include <P16F648A.inc>	; processor specific variable definitions
    __CONFIG    _CP_OFF & _CPD_OFF & _BODEN_OFF & _PWRTE_ON & _LVP_OFF & _WDT_OFF & _HS_OSC & _MCLRE_ON 

#define PORT_RGB PORTB
#define TRIS_RGB TRISB
#define _CMCON CMCON

; Pins from PORT A
_RED_BIAS  EQU 0  
_BLUE_BIAS EQU 1
_50HZ      EQU 4  ; 50Hz Selection

; Pins from PORT B
_RD       EQU 0 ; Red Pin
_GR       EQU 5 ; Green Pin
_BL       EQU 3 ; Blue Pin
_SOG      EQU 4 ; Green BIAS for Sync on Green
_HSYNC    EQU 2 ; Horizontal Sync
_VSYNC    EQU 1 ; Vertical Sync

#endif  


;**********************************************************************
;  ___       __ _      _ _   _             
; |   \ ___ / _(_)_ _ (_) |_(_)___ _ _  ___
; | |) / -_)  _| | ' \| |  _| / _ \ ' \(_-<
; |___/\___|_| |_|_||_|_|\__|_\___/_||_/__/
;                                          
;**********************************************************************

; Macros
#define  _bank0  bcf STATUS,RP0
#define  _bank1  bsf STATUS,RP0

; Pins from PORT A
;_RED_BIAS  EQU 1  
;_BLUE_BIAS EQU 2

; Pins from PORT C
;_SOG      EQU 0
;_HSYNC    EQU 1
;_VSYNC    EQU 2
;_RD       EQU 3 ; Red Pin
;_BL       EQU 4 ; Green Pin
;_GR       EQU 5 ; Blue Pin

; VGA sync levels definition - Separate sync only
_VGA_SHELF     EQU ( (1<<_SOG) | (1<<_HSYNC) | (1<<_VSYNC) ) ; R,G,B at black, Syncs at High (inactive)
_VGA_HSYNC     EQU ( (1<<_SOG) |               (1<<_VSYNC) ) ; R,G,B at black, HSync Active (Low)
_VGA_VSHELF    EQU ( (1<<_SOG) | (1<<_HSYNC)               ) ; R,G,B at black, VSync Active (Low)
_VGA_VSYNC     EQU ( (1<<_SOG)                             ) ; R,G,B at black, HSync and VSync both Active (Low)

; RGB sync levels definition - Separate, Composite and Sync on Green
_RGBHV_HSYNC   EQU ( (1<<_SOG) |               (1<<_VSYNC) ) ; R,G,B at black, HSync Active (Low)
_RGBHV_HSHELF  EQU ( (1<<_SOG) | (1<<_HSYNC) | (1<<_VSYNC) ) ; R,G,B at black, Syncs at High (inactive)
_RGBHV_vSYNC   EQU ( (1<<_SOG)                             ) ; R,G,B at black, HSync and VSync both Active (Low)
_RGBHV_vSHELF  EQU ( (1<<_SOG) | (1<<_HSYNC)               ) ; R,G,B at black, VSync Active (Low)

_RGBCS_HSYNC   EQU ( (1<<_SOG) |               (1<<_VSYNC) ) ; R,G,B at black, HSync Active (Low)
_RGBCS_HSHELF  EQU ( (1<<_SOG) | (1<<_HSYNC) | (1<<_VSYNC) ) ; R,G,B at black, Syncs at High (inactive)
_RGBCS_vSYNC   EQU ( (1<<_SOG) |               (1<<_VSYNC) ) ; R,G,B at black, HSync and VSync both Active (Low)
_RGBCS_vSHELF  EQU ( (1<<_SOG) | (1<<_HSYNC) | (1<<_VSYNC) ) ; R,G,B at black, VSync Active (Low)

_RGBSOG_HSYNC  EQU (             (1<<_HSYNC) | (1<<_VSYNC) ) ; R,G,B at black, HSync Active (Low)
_RGBSOG_HSHELF EQU ( (1<<_SOG) | (1<<_HSYNC) | (1<<_VSYNC) ) ; R,G,B at black, Syncs at High (inactive)
_RGBSOG_vSYNC  EQU (             (1<<_HSYNC) | (1<<_VSYNC) ) ; R,G,B at black, HSync and VSync both Active (Low)
_RGBSOG_vSHELF EQU ( (1<<_SOG) | (1<<_HSYNC) | (1<<_VSYNC) ) ; R,G,B at black, VSync Active (Low)


; Colors definition - same for VGA and RGB
_WHITE       EQU ( _VGA_SHELF | (1<<_RD) |(1<<_GR) |(1<<_BL) )
_YELLOW      EQU ( _VGA_SHELF | (1<<_RD) |(1<<_GR)           )
_CYAN        EQU ( _VGA_SHELF |           (1<<_GR) |(1<<_BL) )
_GREEN       EQU ( _VGA_SHELF |           (1<<_GR)           )
_MAGENTA     EQU ( _VGA_SHELF | (1<<_RD) |          (1<<_BL) )
_RED         EQU ( _VGA_SHELF | (1<<_RD)                     )
_BLUE        EQU ( _VGA_SHELF |                     (1<<_BL) )
_BLACK       EQU ( _VGA_SHELF                                )



; Timing definitions for NTSC / PAL
_NTSC_TOP_BORDER      EQU .27
_NTSC_BOTTOM_BORDER   EQU .24 ; for MSX1 discount 1 line for checking timeout

_PAL_TOP_BORDER      EQU .57
_PAL_BOTTOM_BORDER   EQU .45 ; for MSX1 discount 1 line for checking timeout


_TK90_NTSC_TOP_BORDER      EQU .15
_TK90_NTSC_BOTTOM_BORDER   EQU .22 

_TK90_PAL_TOP_BORDER      EQU .33
_TK90_PAL_BOTTOM_BORDER   EQU .54 

 



;**********************************************************************
; __   __        _      _    _        
; \ \ / /_ _ _ _(_)__ _| |__| |___ ___
;  \ V / _` | '_| / _` | '_ \ / -_|_-<
;   \_/\__,_|_| |_\__,_|_.__/_\___/__/
;                                     
;**********************************************************************

 udata
OPMode      res 1 ; Operating mode 
Conta       res 1
Temp        res 1
GRPCOUNT    res 1 ; Graphics line counter
RGB_HSYNC   res 1 ; hold HSYNC level for RGB modes
RGB_SHELF   res 1 ; hold SHELF level for RGB modes
RGB_VSYNC   res 1 ; hold VSYNC level for RGB modes
RGB_VSHELF  res 1 ; hold VSYNC SHELF level for RGB modes
RGB_TBORDER res 1 ; hold RGB Top border counter for RGB modes
RGB_BBORDER res 1 ; hold RGB Top border counter for RGB modes
                  ; NTSC = 262 lines, top/bottom borders are 27/24 lines
                  ; PAL  = 313 lines, top/bottom borders are 57/45 lines
SLPTIMERL   res 1 ; Sleep Timer Low byte
SLPTIMERH   res 1 ; Sleep Timer High byte
SLP_TOUT    res 1 ; Sleep Timer high limit

MACHINE     res 1 ; Machine definition 0=TK90 1=MSX1 2=MSX2
FREQ        res 1 ; Vertical frequency 0=60Hz 1=50Hz
SYNCMODE    res 1 ; Sync mode 0=Sync on Green, 1=Separate Sync, 2=Composite Sync

RGB_BORDCLR res 1 ; Border Color
RGB_FGCOLOR res 1 ; Foreground Color indicator of Sync type in RGB modes
RGB_BGCOLOR res 1 ; Background Color indicator of Sync type in RGB modes

w_temp	    res 1  ; variable used for context saving
status_temp res 1  ; variable used for context saving
pclath_temp res 1  ; variable used for context saving




;**********************************************************************
;  ___ _            _             
; / __| |_ __ _ _ _| |_ _  _ _ __ 
; \__ \  _/ _` | '_|  _| || | '_ \
; |___/\__\__,_|_|  \__|\_,_| .__/
;                           |_|   
;**********************************************************************


	ORG		0x000			; processor reset vector
   	goto		main			; go to beginning of program


	ORG		0x004			; interrupt vector location
	movwf		w_temp			; save off current W register contents
	movf		STATUS,w		; move status register into W register
	movwf		status_temp		; save off contents of STATUS register
	movf		PCLATH,w		; move pclath register into W register
	movwf		pclath_temp		; save off contents of PCLATH register

; isr code can go here or be located as a call subroutine elsewhere
 
	movf		pclath_temp,w		; retrieve copy of PCLATH register
	movwf		PCLATH			; restore pre-isr PCLATH register contents	
	movf		status_temp,w		; retrieve copy of STATUS register
	movwf		STATUS			; restore pre-isr STATUS register contents
	swapf		w_temp,f
	swapf		w_temp,w		; restore pre-isr W register contents
	retfie					; return from interrupt


;**********************************************************************
;  __  __      _        ___             _   _          
; |  \/  |__ _(_)_ _   | __|  _ _ _  __| |_(_)___ _ _  
; | |\/| / _` | | ' \  | _| || | ' \/ _|  _| / _ \ ' \ 
; |_|  |_\__,_|_|_||_| |_| \_,_|_||_\__|\__|_\___/_||_|
;                                                      
;**********************************************************************

 
main

; Configure IO Ports
	bcf STATUS,RP0           ;Select Bank 0
	clrf    PORT_RGB ;C            ;Set all pins on Port C

    clrf SLPTIMERL           ; clear auto poweroff timeout variable
    clrf SLPTIMERH           ;  

    movlw   b'00000111'        
    movwf   _CMCON           ; disable analog comparators to save power


	bsf STATUS,RP0           ;Select Bank 1

	clrf    TRISA            ;Set all PortA pins as outputs 
                             
    movlw ~( 1<<_SOG | 1<<_HSYNC | 1<<_VSYNC | 1<<_RD | 1<<_BL | 1<<_GR ) 
	movwf   TRIS_RGB         ;Set all pins used for video generation as outputs

    
    movlw   b'10000000'
    movwf   VRCON              ;Turn off CVref to save power



;**********************************************************************
;  _____ ___ ___ _____   ___          _   _             
; |_   _| __/ __|_   _| | _ \___ _  _| |_(_)_ _  ___ ___
;   | | | _|\__ \ | |   |   / _ \ || |  _| | ' \/ -_|_-<
;   |_| |___|___/ |_|   |_|_\___/\_,_|\__|_|_||_\___/__/
;                                                       
;**********************************************************************
;include <test_routines.asm>

;**********************************************************************
;  __  __         _       ___      _        _   _          
; |  \/  |___  __| |___  / __| ___| |___ __| |_(_)___ _ _  
; | |\/| / _ \/ _` / -_) \__ \/ -_) / -_) _|  _| / _ \ ' \ 
; |_|  |_\___/\__,_\___| |___/\___|_\___\__|\__|_\___/_||_|
;                                                          
;**********************************************************************
   

; Choose Operating Mode
	btfsc PCON,NOT_POR       ; Check the source of reset.
	goto Select_Mode         ; If /POR  bit is set it was a button press
	                         ; otherwise initialize OPMode variable
	bsf PCON,NOT_POR         ; set /POR to indicate that this is not a POWERON Reset



FirstRun:
	bcf STATUS,RP0
	clrf OPMode              ; Mode=0 -> is VGA Mode



Select_Mode:        ; Now check which mode to operate
	bcf STATUS,RP0      ; bank 0

    movlw   _BLACK
    movwf RGB_FGCOLOR


	movf OPMode,w
	xorlw 0      
	btfsc STATUS,Z      ; Was zero?
	goto MakeMODE0      ; Yes, make first mode

	xorlw 0^1
	btfsc STATUS,Z      ; Was 1
	goto MakeMODE1      ; Yes, make 2nd mode

	xorlw 1^2
	btfsc STATUS,Z      ; Was 2
	goto MakeMODE2      ; Yes, make 3rd mode

	xorlw 2^3
	btfsc STATUS,Z      ; Was 3
	goto MakeMODE3      ; Yes, make 4th mode

 	xorlw 3^4
	btfsc STATUS,Z      ; Was 4
	goto MakeMODE4      ; Yes, make 5th mode

  	xorlw 4^5
	btfsc STATUS,Z      ; Was 5
	goto MakeMODE5      ; Yes, make 6th mode

   	xorlw 5^6
	btfsc STATUS,Z      ; Was 6
	goto MakeMODE6      ; Yes, make 7th mode 

   	xorlw 6^7
	btfsc STATUS,Z      ; Was 7
	goto MakeMODE7      ; Yes, make 8th mode 
	
	xorlw 7^8
	btfsc STATUS,Z      ; Was 8
	goto MakeMODE8      ; Yes, make 9th mode 
	
   	xorlw 8^9
	btfsc STATUS,Z      ; Was 9
	goto MakeMODE9      ; Yes, make 10th mode 
	
	goto FirstRun       ; Was none of them, consider it the first mode



;**********************************************************************
; Operating Modes
;**********************************************************************
;** MODE 0: VGA 640x480 60Hz  
MakeMODE0:
	incf OPMode,f ; Update MODE for next time
	goto DO_VGA

;** MODE 1: MSX1 NTSC Composite Sync  ******************************** 
MakeMODE1:
	incf OPMode,f ; Update MODE for next time
    call MakeRGB_CS
    call Make_MSX_NTSC   
    goto DO_MSX1
    
;** MODE 2: MSX1 NTSC Separate Sync  
MakeMODE2:
	incf OPMode,f ; Update MODE for next time
    call MakeRGB_HV
    call Make_MSX_NTSC
    goto DO_MSX1

;** MODE 3: MSX1 NTSC Sync on Green   
MakeMODE3:
	incf OPMode,f ; Update MODE for next time
    call MakeRGB_SOG
    call Make_MSX_NTSC
    goto DO_MSX1
       
;** MODE 4: MSX2 NTSC Composite Sync ********************************
MakeMODE4:
	incf OPMode,f ; Update MODE for next time
    call MakeRGB_CS
    call Make_MSX_NTSC
    goto DO_MSX2

;** MODE 5: MSX2 NTSC Separate Sync  
MakeMODE5:
	incf OPMode,f ; Update MODE for next time
    call MakeRGB_HV
    call Make_MSX_NTSC
    goto DO_MSX2
    
;** MODE 6: MSX2 Sync on Green    
MakeMODE6: 
	incf OPMode,f ; Update MODE for next time
    call MakeRGB_SOG
    call Make_MSX_NTSC
    goto DO_MSX2


;** MODE 7: TK90X NTSC Composite Sync ********************************   
MakeMODE7:
	incf OPMode,f ; Update MODE for next time
    call MakeRGB_CS
    call Make_TK90X_NTSC
    goto DO_TK90X

;** MODE 8: TK90X NTSC Separate Sync   
MakeMODE8:
	incf OPMode,f ; Update MODE for next time
    call MakeRGB_HV
    call Make_TK90X_NTSC
    goto DO_TK90X

;** MODE 9: TK90X NTSC Sync on Green   
MakeMODE9:
    clrf OPMode ; Update MODE for next time = 0 for the last mode
    call MakeRGB_SOG
    call Make_TK90X_NTSC
    goto DO_TK90X



;**********************************************************************
; Prepare Sync Modes
;**********************************************************************	
MakeRGB_CS: ; Composite Sync
	movlw _RGBCS_HSYNC
 	movwf  RGB_HSYNC

	movlw _RGBCS_HSHELF  
	movwf RGB_SHELF

	movlw _RGBCS_vSYNC
	movwf RGB_VSYNC

	movlw _RGBCS_vSHELF 
	movwf RGB_VSHELF
	
	movlw _YELLOW
	movwf RGB_BGCOLOR
	
	clrf SYNCMODE ; for graphics display routine
    return

MakeRGB_HV: ; Separate Sync
	movlw _RGBHV_HSYNC
 	movwf  RGB_HSYNC

	movlw _RGBHV_HSHELF
	movwf RGB_SHELF

	movlw _RGBHV_vSYNC
	movwf RGB_VSYNC

	movlw _RGBHV_vSHELF
	movwf RGB_VSHELF
	
	movlw _WHITE
	movwf RGB_BGCOLOR
	
	movlw .1
	movwf SYNCMODE ; for graphics display routine
    return

MakeRGB_SOG: ; Sync on Green
	movlw _RGBSOG_HSYNC
 	movwf  RGB_HSYNC

	movlw _RGBSOG_HSHELF
	movwf RGB_SHELF

	movlw _RGBSOG_vSYNC
	movwf RGB_VSYNC

	movlw _RGBSOG_vSHELF
	movwf RGB_VSHELF
	
	movlw _GREEN
	movwf RGB_BGCOLOR

	movlw .2
	movwf SYNCMODE ; for graphics display routine	
	
    return


;**********************************************************************
; Prepare Timing Modes for Top/Bottom Borders
;**********************************************************************	
Make_MSX_NTSC: ; 60Hz
	movlw _NTSC_TOP_BORDER
	movwf RGB_TBORDER

	movlw _NTSC_BOTTOM_BORDER
	movwf RGB_BBORDER

    movlw 0x0f
    movwf SLP_TOUT  ; sleep after 0f00h lines = 3840/60 s = 64 seconds
    
    clrf FREQ ; for graphics display routine
    return

Make_MSX_PAL: ; 50Hz
	movlw _PAL_TOP_BORDER
	movwf RGB_TBORDER

	movlw _PAL_BOTTOM_BORDER
	movwf RGB_BBORDER

    movlw 0x0c
    movwf SLP_TOUT  ; sleep after 0c00h lines = 3072/50 s = 61,4 seconds
    
    movlw .1
    movwf FREQ ; for graphics display routine
    return

Make_TK90X_NTSC: ;60Hz
	movlw _TK90_NTSC_TOP_BORDER
	movwf RGB_TBORDER

	movlw _TK90_NTSC_BOTTOM_BORDER
	movwf RGB_BBORDER

    movlw 0x0f
    movwf SLP_TOUT  ; sleep after 0f00h lines = 3840/60 s = 64 seconds
    
    clrf FREQ ; for graphics display routine
    return

Make_TK90X_PAL: ;50Hz
	movlw _TK90_PAL_TOP_BORDER
	movwf RGB_TBORDER

	movlw _TK90_PAL_BOTTOM_BORDER
	movwf RGB_BBORDER

    movlw 0x0c
    movwf SLP_TOUT  ; sleep after 0c00h lines = 3072/50 s = 61,4 seconds
    
    movlw .1
    movwf FREQ ; for graphics display routine       
    return



;**********************************************************************
; __   _____   _     ___          _   _             
; \ \ / / __| /_\   | _ \___ _  _| |_(_)_ _  ___ ___
;  \ V / (_ |/ _ \  |   / _ \ || |  _| | ' \/ -_|_-<
;   \_/ \___/_/ \_\ |_|_\___/\_,_|\__|_|_||_\___/__/
;                                                   
;**********************************************************************

; ** Render a VGA Frame
DO_VGA:
	movlw 2 ; Initialize amount of Vsync Lines

VGA_Frame:
	movwf Conta 
Vsync_loop:
	call Vsync_line
	movlw .33         ; amount of lines for next loop. Was placed here to 
	decfsz Conta,f   ; equalize timing of all loops that make the frame
	goto Vsync_loop  ; each loop takes exactly 8 cycles + call time
                   ; at 20Mhz we have 159 cycles per VGA line (31.8us)
VBackPorch:
	movwf Conta      ; 25lines backporch plus 8 lines top border
VBackPorch_Loop:
	call Blank_line
	movlw .240        ; first half of vilible lines
	decfsz Conta,f
	goto VBackPorch_Loop

First_half:
	movwf Conta      ; 240 lines
VFirst_Visible_Loop:
	call Visible_line
	movlw .240        ; second half of vilible lines
	decfsz Conta,f
	goto VFirst_Visible_Loop

Second_half:
	movwf Conta      ; 240 lines
VSecond_Visible_Loop:
	call Visible_line
	movlw .9       ; last 10 blank lines minus one
	decfsz Conta,f
	goto VSecond_Visible_Loop

VFront_Porch
	movwf Conta      ; 8 lines bottom plus 2 frontporch 
VFrontPorch_Loop:  ; minus one to equalize timing
	call Blank_line
	movlw .2        ;  dummy
	decfsz Conta,f
	goto VFrontPorch_Loop

                     
	nop
	call VGA_Last_line  ; Last line is called outside a loop 
	movlw .2         ; dummy for equalize timing

	goto VGA_Frame ;



 
;**********************************************************************
; INFO:
; VGA Horizontal Lines. It takes 8 cycles for performing the loop
; including the last return. only 151 cycles remain
; PINs from PORTC
;**********************************************************************


;**********************************************************************
; Generate one visible line (Color Bar)
;**********************************************************************

Visible_line: 
    ; Begin is similar to Blank Line
    ; drop Vsync      ;cy acumulado
    movlw _VGA_HSYNC  ;1  
    movwf PORT_RGB;C       ;1   
    movlw .5           ;1  1  (19 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
Vis1:
    decfsz Temp,f      ;1
    goto   Vis1        ;2  (3*5 -1)14 -> 16
    movlw _VGA_SHELF  ;1  17
    nop               ;1  18
    nop               ;1  19
    movwf PORT_RGB;C       ;1
   ; 22 cycles up to here. 129 to the end

;**********************************************************************
; INFO:
; We have to consider that we should have to reduce the visible area 
; in order to fit the PIC clock timing. 
; From the standard we should still have 135 clock cycles until the
; front Porch. Thus we are lacking 6 clock cycles and we should 
; compensate in the left border
; From here to start of visible we have 9 clocks, plus 6 clocks for the
; left border, thus we have 15clocks for the backporch 
; and 126-6-6 = 114 cycles for visible content
;**********************************************************************

; Backporch 15+1 cycles. extra cycle is to adjust timing
    movlw .4          ;1
    movwf Temp        ;1
BPrch1:
    decfsz Temp,f     ;1
    goto BPrch1       ;2 (3*4-1) 11
    nop               ;1
    movlw _WHITE      ;1    - color for the next stripe
    movwf PORT_RGB;C       ;1

; White Stripe 16 cycles
    movlw .4          ;1
    movwf Temp        ;1
WhStrp1:
    decfsz Temp,f       ;1
    goto WhStrp1      ;2 (3*4-1) 11
    nop               ;1
    movlw _YELLOW     ;1    - color for the next stripe
    movwf PORT_RGB;C       ;1

; Yellow Stripe 16 cycles
    movlw .4          ;1
    movwf Temp        ;1
YeStrp1:
    decfsz Temp,f       ;1
    goto YeStrp1      ;2 (3*4-1) 11
    nop               ;1
    movlw _CYAN       ;1    - color for the next stripe
    movwf PORT_RGB;C       ;1

; Cyan Stripe 16 cycles
    movlw .4          ;1
    movwf Temp        ;1
CyStrp1:
    decfsz Temp,f       ;1
    goto CyStrp1      ;2 (3*4-1) 11
    nop               ;1
    movlw _GREEN      ;1    - color for the next stripe
    movwf PORT_RGB;C       ;1

; Green Stripe 16 cycles
    movlw .4          ;1
    movwf Temp        ;1
GrStrp1:
    decfsz Temp,f       ;1
    goto GrStrp1      ;2 (3*4-1) 11
    nop               ;1
    movlw _MAGENTA    ;1    - color for the next stripe
    movwf PORT_RGB;C       ;1

; Magenta Stripe 16 cycles
    movlw .4          ;1
    movwf Temp        ;1
MgStrp1:
    decfsz Temp,f       ;1
    goto MgStrp1      ;2 (3*4-1) 11
    nop               ;1
    movlw _RED        ;1    - color for the next stripe
    movwf PORT_RGB;C       ;1

; Red Stripe 16 cycles
    movlw .4          ;1
    movwf Temp        ;1
RdStrp1:
    decfsz Temp,f       ;1
    goto RdStrp1      ;2 (3*4-1) 11
    nop               ;1
    movlw _BLUE       ;1    - color for the next stripe
    movwf PORT_RGB;C       ;1

; Blue Stripe 16 cycles
    movlw .4          ;1
    movwf Temp        ;1
BlStrp1:
    decfsz Temp,f       ;1
    goto BlStrp1      ;2 (3*4-1) 11
    nop               ;1
    movlw _VGA_SHELF  ;1    - color for the next stripe
    movwf PORT_RGB;C       ;1      shelf is Black
	nop               ;1    Last cycle, to equalize timing

	return ; already taken into acconunt


;**********************************************************************
; Generate one Vertical Sync line
;**********************************************************************
; INFO:
; During a vertical sync line a HSync pulse is generated while the 
; VSync line is kept low
;**********************************************************************
Vsync_line:
    ; drop Vsync       ;cy acumulado
    movlw _VGA_VSYNC  ;1
    movwf PORT_RGB;C     ;1   
    movlw .5          ;1  1  (19 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
VL1:
    decfsz Temp,f       ;1
    goto   VL1        ;2  (3*5 -1)14 -> 16
    movlw _VGA_VSHELF ;1  17
    nop               ;1  18
    nop               ;1  19
    movwf PORT_RGB;C       ;1  
    ; 22 cycles up to here. 129 to the end
    movlw .42         ;1  42 is the answer!
    movwf Temp        ;1
VL2:
    decfsz Temp,f       ;1
    goto VL2          ;2 (3*42-1) 125
    nop               ;1
    nop               ;1

	return ; already taken into acconunt


;**********************************************************************
; Generate a Blank Line (only one HSync pulse)
;**********************************************************************
Blank_line:
    ; drop Vsync      ;cy acumulado
    movlw _VGA_HSYNC  ;1  
    movwf PORT_RGB;C       ;1   
    movlw .5           ;1  1  (19 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
BL1:
    decfsz Temp,f       ;1  
    goto   BL1        ;2  (3*5 -1)14 -> 16
    movlw _VGA_SHELF  ;1  17
    nop               ;1  18
    nop               ;1  19
    movwf PORT_RGB;C       ;1  
    ; 22 cycles up to here. 129 to the end
    movlw .42         ;1  42 is the answer!
    movwf Temp        ;1
BL2:
    decfsz Temp,f     ;1
    goto BL2          ;2 (3*42-1) 125
    nop               ;1
    nop               ;1

	return ; already taken into acconunt

;**********************************************************************
; Generate a Blank Line and check for timeout timer
;**********************************************************************
; INFO:
; Once this line is called once in a frame and sleeps the PIC after
; 0xf00 calls which means roughly 64 seconds
;**********************************************************************
VGA_Last_line:
    ; drop Vsync      ;cy acumulado
    movlw _VGA_HSYNC  ;1  
    movwf PORT_RGB;C       ;1   
    movlw .5          ;1  1  (19 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
VLastL1:
    decfsz Temp,f     ;1
    goto   VLastL1    ;2  (3*5 -1)14 -> 16
    movlw _VGA_SHELF  ;1  17
    nop               ;1  18
    nop               ;1  19
    movwf PORT_RGB;C       ;1  
    ; 22 cycles up to here. 129 to the end

     ; Check for Auto Power-Off
    incf SLPTIMERH,f   ;1
    incfsz SLPTIMERL,f ;1
    decf SLPTIMERH,f   ;1

    movf SLPTIMERH,w  ;1
    xorlw 0fh         ;1  Timeout?
    btfss STATUS,Z    ;1
    goto VGALLCont    ;2  No, continue
    
    goto PutToSleep   ;   yes, go to sleep

VGALLCont:  ; 30 cycles up to here. 121 to the end

    movlw .40         ;1
    movwf Temp        ;1
VLastL2:
    decfsz Temp,f     ;1  (3*40-1) 119   ->121
    goto VLastL2      ;2
;    nop               ;1
;    nop               ;1

    return ; already taken into account





;**********************************************************************
;  ___  ___ ___   ___          _   _             
; | _ \/ __| _ ) | _ \___ _  _| |_(_)_ _  ___ ___
; |   / (_ | _ \ |   / _ \ || |  _| | ' \/ -_|_-<
; |_|_\\___|___/ |_|_\___/\_,_|\__|_|_||_\___/__/
;                                                
;**********************************************************************
; RGB lines lasts 318 cycles = 63,6us each
;**********************************************************************


;**********************************************************************
;  __  __ _____  __  _   ___
; |  \/  / __\ \/ / / | | __| _ __ _ _ __  ___
; | |\/| \__ \>  <  | | | _| '_/ _` | '  \/ -_)
; |_|  |_|___/_/\_\ |_| |_||_| \__,_|_|_|_\___|
;
;**********************************************************************
; INFO:                                                               *
; MSX1 Frame format TMS9918/NTSC (9919/PAL)                           *
; lines                                                               *
;   3      Blank  - tVFB = 191,1us   = 3 lines of 63,7us              *
;                                                                     *
;   1      Vser1  - tVS  = 191,1us   = 3 lines                        *
;   2      Vser2  -                                                   *
;                                                                     *
;   3      Blank  - tVBB = 828us     = 13 lines                       *
;  10      Top Blanking                                               *
;                                                                     *
;  27 (57) Top Border                                                 *
; 192      Vertical Active Disp  92+8+92                              *
;  24 (45) Bottom Border                                              *
;-----                                                                *
; 262 (313) lines total (313)                                         *
;                                                                     *
;**********************************************************************

DO_MSX1:
    movlw .1
    movwf MACHINE ; gor graphics display routine

    movlw _WHITE
    movwf RGB_BORDCLR ; top and bottom border lines color.
    
	movlw 3 ; Amount of Initial Blank (equalization) Lines

MSX1_Frame:
; First set of horizontal equalization lines
	movwf Conta   ; w=3

MSX1_Heq1_loop:
	call MSX1_Blank_line
	movlw .1          ; amount of repeats of next cycle (only one)
	decfsz Conta,f    ;
	goto MSX1_Heq1_loop

;Vertical serration lines
;**********************************************************************
;INFO:
; First Vertical serration is an Hsync pulse followed by a 550ns 
; positive pulse, then a low level until the end of the line
;**********************************************************************
 	movwf Conta   ;  w=1, First Vertical serration
MSX1_First_Vser_loop:
	call MSX1_Vser1_line
	movlw .2
	decfsz Conta,f
    goto MSX1_First_Vser_loop

	movwf Conta ; w=2
MSX1_Vser_Loop:
	call MSX1_Vser2_line
	movlw .13        ; next 2 Horizontal equalization lines
	decfsz Conta,f
	goto MSX1_Vser_Loop

; Second set of horizontal equalization lines

; Video Blanking lines
	movwf Conta ; w=13
MSX1_VBlank_loop:
	call MSX1_Blank_line
	movf RGB_TBORDER,w   ; next amount lines of top border
	decfsz Conta,f
	goto MSX1_VBlank_loop


; Top Border lines
	movwf Conta ; w=TBorder->27/57 lines
MSX1_Top_Border_loop:
	call MSX1_White_line ; TODO - create BORDER line content
	movlw .92            ; next 92+8+92 lines of active video
	decfsz Conta,f
	goto MSX1_Top_Border_loop

; Video Active lines, part one
	movwf Conta  ; w=92
MSX1_Active_loop_part1:
	call MSX1_Visible_line
	movlw .1   ; next lines will be colored line
	decfsz Conta,f
	goto MSX1_Active_loop_part1

;@@

; Show Active machine, sync mode and frequency

; Colored Line above graphics
	movwf Conta ; w=1
    ;
	call MSX1_Colored_line
	movlw .6            ; next 6 lines will be graphics
	decfsz Conta,f
	goto $-3

; Colored Lines
	movwf Conta ; w=8
    ;
	call MSX1_Graphics_line
	movlw .1            ; next lines will be colored line
	decfsz Conta,f
	goto $-3

; Colored Line below graphics
	movwf Conta ; w=1
    ;
	call MSX1_Colored_line
	movlw .92            ; next 92 lines will be active video
	decfsz Conta,f
	goto $-3

;@@

; Video Active lines, part two
	movwf Conta ; w=92
MSX1_Active_loop_part2:
	call MSX1_Visible_line
	movf RGB_BBORDER,w   ; next amount lines of bottom border
	decfsz Conta,f
	goto MSX1_Active_loop_part2


; Bottom Border lines minus one
	movwf Conta  ; w=Bottom Border->24/45 lines
MSX1_Bottom_Border_loop:
	call MSX1_White_line ; TODO - create BORDER line content
	movlw .3             ; dummy
	decfsz Conta,f
	goto MSX1_Bottom_Border_loop
	


	nop                  ; check Auto power off in first line of next vertical blanking interval
	call MSX1_Last_Line  ; put to sleep after 64 seconds
	movlw .2             ; 2 more lines of vertical front porch
 
	goto MSX1_Frame ;
; end of MSX1 Frame





;**********************************************************************
;  __  __ _____  __  ___   ___                                        
; |  \/  / __\ \/ / |_  ) | __| _ __ _ _ __  ___                      
; | |\/| \__ \>  <   / /  | _| '_/ _` | '  \/ -_)                     
; |_|  |_|___/_/\_\ /___| |_||_| \__,_|_|_|_\___|                     
;                                                                     
;**********************************************************************                                               
; INFO:                                                               *
; MSX2 Frame format is standard RS343 RGB Format                      *
;                                                                     *
; == ODD FRAME, 262,5 lines ==                                        *
; lines                                                               *
;   3      Heq   - Horizontal Equalization Lines                      *
;   3      Vser  - Vertical Serration Lines                           *
;   3      Heq   - Horizontal Equalization Lines                      *
;  10      Blank - Top Blanking lines                                 *
;  26      TBord - Top Border lines                                   *
; 192      Vis   - Visible lines, field 1     92+8+92                 *
;  25      BBord - Bottom Border lines                                *
; 1/2      half1 - first half line (half blank line)                  *
;                                                                     *
; == EVEN FRAME, 262,5 lines ==                                       *
;   3      Heq   - Horizontal Equalization Lines                      *
;   3      Vser  - Vertical Serration Lines                           *
;   3      Heq   - Horizontal Equalization Lines                      *
; 1/2      half2 - second half line (shelf)                           *
;   9      Blank - Top Blanking lines                                 *
;  26      TBord - Top Border lines                                   *
; 192      Vis   - Visible lines, field 2     92+8+92                 *
;  25      BBord - Bottom Border lines                                *
;   1      Blank - Last Blanking line                                 *
;------                                                               *
; 525 lines                                                           *
;                                                                     *
;**********************************************************************


DO_MSX2:
DO_RGB:
    movlw .2
    movwf MACHINE ; gor graphics display routine
   
	movlw .3 ; Amount of Horizontal Equalization Lines

RGB_Frame:

; == Odd Frame ==
; First set of horizontal equalization lines
	movwf Conta
Heq1_loop:
	call RGB_Heq_line
	movlw .3          ; amount of lines for next loop. Was placed here to
	decfsz Conta,f    ; equalize timing of all loops that make the frame
	goto Heq1_loop   ; each loop takes exactly 8 cycles + call time

;Vertical serration lines
	movwf Conta      ; 3
Vser_Loop:
	call RGB_Vser_line
	movlw .3        ; next 3 Horizontal equalization lines
	decfsz Conta,f
	goto Vser_Loop
	
; Second set of horizontal equalization lines
	movwf Conta
Heq2_loop:
	call RGB_Heq_line
	movlw .10          ; next 10 lines of blanling
	decfsz Conta,f
	goto Heq2_loop

; Video Blanking lines
	movwf Conta
VBlank_loop:
	call RGB_Blank_line
	movf RGB_TBORDER,w   ; next amount lines of top border
	decfsz Conta,f
	goto VBlank_loop

; Top Border lines
	movwf Conta
Top_Border_loop:
	call RGB_Blank_line ; TODO - create BORDER line content
	movlw .92            ; next 92+8+92 lines of active video
	decfsz Conta,f
	goto Top_Border_loop

; Video Active lines, part one
	movwf Conta
RGB_Active_loop_part1:
	call RGB_Visible_line
	movlw .1   ; next line will be colored line
	decfsz Conta,f
	goto RGB_Active_loop_part1

; Show Active machine, sync mode and frequency
; Colored Line above graphics
	movwf Conta ; w=1
    ;
	call RGB_Colored_line
	movlw .6            ; next 6 lines will be graphics
	decfsz Conta,f
	goto $-3

; Colored Lines
	movwf Conta ; w=6
    ;
	call RGB_Graphics_line
	movlw .1            ; next lines will be colored line
	decfsz Conta,f
	goto $-3

; Colored Line below graphics
	movwf Conta ; w=1
    ;
	call RGB_Colored_line
	movlw .92            ; next 92 lines will be active video
	decfsz Conta,f
	goto $-3

; Video Active lines, part two
	movwf Conta
RGB_Active_loop_part2:
	call RGB_Visible_line
	movf RGB_BBORDER,w   ; next amount lines of bottom border minus one
	decfsz Conta,f
	goto RGB_Active_loop_part2

; Bottom Border lines 
	movwf Conta
RGB_Bottom_Border_loop:
	call RGB_Blank_line ; TODO - create BORDER line content
	movlw .1             ; First Half Line 
	decfsz Conta,f
	goto RGB_Bottom_Border_loop

;	movwf Conta
;RGB_Half_Line1_loop:
;	call RGB_Blank_line ; TODO - create BORDER line content
;	movlw .1             ; for next 3 Horizontal Equalization lines
;	decfsz Conta,f
;	goto RGB_Half_Line1_loop

; last line of odd frame is a half line
	movwf Conta
First_Half_line_loop: 
	call RGB_Half_line1  ; generate half line (with hsync)
	movlw .3           ; for next 3 Horizontal Equalization lines
	decfsz Conta,f
	goto First_Half_line_loop



; == Even Frame ==
; First set of horizontal equalization lines

	movwf Conta   ; w=3
Heq1_loop_even:
	call RGB_Heq_line
	movlw .3          ; amount of lines for next loop. Was placed here to
	decfsz Conta,f    ; equalize timing of all loops that make the frame
	goto Heq1_loop_even   ; each loop takes exactly 8 cycles + call time

;Vertical serration lines
	movwf Conta      ; w=3
Vser_Loop_even:
	call RGB_Vser_line
	movlw .3        ; next 3 Horizontal equalization lines
	decfsz Conta,f
	goto Vser_Loop_even
	
; Second set of horizontal equalization lines
	movwf Conta
Heq2_loop_even:
	call RGB_Heq_line
	movlw .1          ; next lines is a half line
	decfsz Conta,f
	goto Heq2_loop_even
	

; Second half line is a shelf line
	movwf Conta
Shelf_Half_line_loop:
	call RGB_Half_line2
	movlw .9          ; next 9 lines of blanling
	decfsz Conta,f
	goto Shelf_Half_line_loop
	
	
	

; Video Blanking lines
	movwf Conta
VBlank_loop_even:
	call RGB_Blank_line
	movf RGB_TBORDER,w   ; next amount lines of top border
	decfsz Conta,f
	goto VBlank_loop_even

; Top Border lines
	movwf Conta
Top_Border_loop_even:
	call RGB_Blank_line ; TODO - create BORDER line content
	movlw .92            ; next 92+8+92 lines of active video
	decfsz Conta,f
	goto Top_Border_loop_even

; Video Active lines, part one
	movwf Conta
RGB_Active_loop_part1_even:
	call RGB_Visible_line
	movlw .1   ; ; next line will be colored line
	decfsz Conta,f
	goto RGB_Active_loop_part1_even

; Show Active machine, sync mode and frequency

; Colored Line above graphics
	movwf Conta ; w=1
    ;
	call RGB_Colored_line
	movlw .6            ; next 6 lines will be graphics
	decfsz Conta,f
	goto $-3

; Colored Lines
	movwf Conta ; w=6
    ;
	call RGB_Graphics_line
	movlw .1            ; next lines will be colored line
	decfsz Conta,f
	goto $-3

; Colored Line below graphics
	movwf Conta ; w=1
    ;
	call RGB_Colored_line
	movlw .92            ; next 92 lines will be active video
	decfsz Conta,f
	goto $-3


; Colored Lines
;	movwf Conta
;RGB_Active_loop_even:
;	call RGB_Colored_line
;	movlw .92            ; next 92 lines will be active video
;	decfsz Conta,f
;	goto RGB_Active_loop_even


; Video Active lines, part two
	movwf Conta
RGB_Active_loop_part2_even:
	call RGB_Visible_line
	movf RGB_BBORDER,w   ; next amount lines of bottom border minus one
	decfsz Conta,f
	goto RGB_Active_loop_part2_even

; Bottom Border lines 
	movwf Conta
RGB_Bottom_Border_loop_even:
	call RGB_Blank_line ; TODO - create BORDER line content
	movlw .1             ; First Half Line 
	decfsz Conta,f
	goto RGB_Bottom_Border_loop_even

;	movwf Conta
;RGB_Half_Line1_loop_even:
;	call RGB_Blank_line ; TODO - create BORDER line content
;	movlw .3             ; for next 3 Horizontal Equalization lines
;	decfsz Conta,f
;	goto RGB_Half_Line1_loop_even

; Last Blanking line. Placed here to compensate start of drawing 1 line later due 
; to the two half lines between odd and even frame
    movwf Conta
RGB_Last_Blank_line:
    call RGB_Blank_line
    movlw .1
	decfsz Conta,f
	goto RGB_Last_Blank_line    

    ; first line of the next frame is called outside a loop for equalize timing
	nop                  
	call RGB_Heq_line   
	movlw .2            ; 
 
	goto RGB_Frame ;
; end of RGB Frame

;**********************************************************************
; RGB Horizontal Lines
;**********************************************************************
;INFO:
; Each Hline loop takes exactly 8 cycles + call time
; at 20Mhz we have 318 cycles per VGA line (63,692us)
; thus each line shall take exactly 310 cycles
;
;**********************************************************************


;**********************************************************************
; Generate a White Line (BORDCLR)
;**********************************************************************
MSX1_White_line:
    ; drop Vsync      ;cy acumulado
    movf RGB_HSYNC,w  ;1
    movwf PORT_RGB;C       ;1
    movlw .7          ;1  1  (24 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
MSXBdCl1:
    decfsz Temp,f     ;1  (3*7 -1) 20 -> 22
    goto   MSXBdCl1    ;2
    movf RGB_SHELF,w  ;1  23
    movwf PORT_RGB;C       ;1  24
    ; 26 cycles up to here. 284 to the end

; Backporch 22+13 =35 cycles.
    movlw .10         ;1
    movwf Temp        ;1
MSXBdCl2:
    decfsz Temp,f     ;1 (3*10-1) 29-> 31
    goto MSXBdCl2      ;2
    nop               ;1  32
    nop               ;1  33
    movf RGB_BORDCLR,w ;1  34  - color for the line
    movwf PORT_RGB;C         ;1  35


; Colored Stripe 34 * 7  =  238 cycles
    movlw .78         ;1  1
    movwf Temp        ;1  2
MSXBdCl3:
    decfsz Temp,f     ;1 (3*78-1) 233->235
    goto MSXBdCl3      ;2
    nop               ;1 236
    movf RGB_SHELF,w  ;1 237   - return to shelf (black)
    movwf PORT_RGB;C       ;1 238

    ; 35+238=273  cycles from drop
    ; 273 + 26 from start = 299 cycles. 11 Cycles to the end (310)
    movlw .3          ;1
    movwf Temp        ;1
MSXBdCl4:
    decfsz Temp,f     ;1  (3*3-1) 8->10
    goto   MSXBdCl4    ;2
    nop               ;1 11  

    return ; already taken into account


;**********************************************************************
; Generate a Blank Line (only one HSync pulse)
;**********************************************************************
MSX1_Blank_line:
RGB_Blank_line:
    ; drop Vsync      ;cy acumulado
    movf RGB_HSYNC,w  ;1
    movwf PORT_RGB;C       ;1
    movlw .7          ;1  1  (24 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
RGBL1:
    decfsz Temp,f     ;1  (3*7 -1) 20 -> 22
    goto   RGBL1      ;2  
    movf RGB_SHELF,w  ;1  23
    movwf PORT_RGB;C       ;1  24
    ; 26 cycles up to here. 284 to the end
    movlw .94         ;1  1
    movwf Temp        ;1  2
RGBL2:
    decfsz Temp,f     ;1  (3*94-1) 281->283
    goto RGBL2        ;2
    nop               ;1  284
;
    return ; already taken into account


;**********************************************************************
; Generate one Horizontal Equalization Line as in RS-170 Standard
;**********************************************************************
RGB_Heq_line:
    ; drop Vsync      ;cy acumulado
    movf RGB_HSYNC,w  ;1
    movwf PORT_RGB;C       ;1
    movlw .7          ;1  1  (24 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
RGBHeq1:
    decfsz Temp,f       ;1
    goto   RGBHeq1    ;2  (3*7 -1)20 -> 22
    movf RGB_SHELF,w  ;1  23
    nop               ;1  24
    movwf PORT_RGB;C       ;1
    ; 27 cycles up to here. 283 to the end 


    ; count 134 up to next drop sync
    nop               ;1   1
    nop               ;1   2
    movlw .43         ;1   3
    movwf Temp        ;1   4
RGBHeq2:
    decfsz Temp,f       ;1  (3*43-1) 128   132
    goto RGBHeq2      ;2
    
    movf RGB_HSYNC,w  ;1   133 second drop sync
    movwf PORT_RGB;C       ;1   134
    ; 27+134=161 cycles up to here. 149 to the end

    movlw .7          ;1  1  (24 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
RGBHeq3:
    decfsz Temp,f       ;1
    goto   RGBHeq3    ;2  (3*7 -1)20 -> 22
    movf RGB_SHELF,w  ;1  23
    nop               ;1  24
    movwf PORT_RGB;C       ;1
    ; 161 plus 24 cycles up to here-> 186. 124 more cycles until end

    movlw .41         ;1   1
    movwf Temp        ;1   2
RGBHeq4:
    decfsz Temp,f       ;1  (3*41-1) 122   124
    goto RGBHeq4      ;1   122
;    nop              ;1   123
;    nop
;
	return ; already taken into account


;**********************************************************************
; Generate one Vertical Serration Line as in RS-170 Standard
;**********************************************************************
RGB_Vser_line:        ;Vertical Serration
    ; drop Vsync      ;cy acumulado
    movf RGB_VSYNC,w  ;1
    movwf PORT_RGB;C       ;1
    movlw .48         ;1  1  (147 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
RGBVser1:
    decfsz Temp,f     ;1  (3*48 -1) 143 -> 145
    goto   RGBVser1   ;2  
    movf RGB_VSHELF,w ;1  146


    movwf PORT_RGB;C       ;1  147
    movlw .3          ;1  1    ; count 12 cycles up to next drop sync  
    movwf Temp        ;1  2                                            
RGBVser2:
    decfsz Temp,f     ;1  (3*3-1) 8->10   
    goto RGBVser2     ;2
    movf RGB_VSYNC,w  ;1 11  second drop sync    
    movwf PORT_RGB;C       ;1 12                      
    ;  2+147+12 161 cycles from start up to here. 149 to the end

    movlw .48         ;1  1  (147 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
RGBVser3:
    decfsz Temp,f     ;1
    goto   RGBVser3   ;2  (3*48 -1) 143 -> 145
    movf RGB_VSHELF,w  ;1  146
    movwf PORT_RGB;C       ;1  147

    ; 161+147 = 308 cycles up to here. 2 more cycles until end
    nop ; 1
    clrf  GRPCOUNT;    nop ; 1  Waste 1 cycle clearing GRPCOUNT
    return ; already taken into account





;**********************************************************************
; Generate one Visible Line (Color Bars)
;**********************************************************************
MSX1_Visible_line:
RGB_Visible_line:
    ; drop Vsync      ;cy acumulado
    movf RGB_HSYNC,w  ;1
    movwf PORT_RGB;C       ;1
    movlw .7          ;1  1  (24 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
RGBVis1:
    decfsz Temp,f     ;1  (3*7 -1) 20 -> 22
    goto   RGBVis1    ;2
    movf RGB_SHELF,w  ;1  23
    movwf PORT_RGB;C       ;1  24
    ; 26 cycles up to here. 284 to the end

; Backporch 22+13 =35 cycles.
    movlw .10         ;1
    movwf Temp        ;1
RGBPrch1:
    decfsz Temp,f     ;1 (3*10-1) 29-> 31
    goto RGBPrch1     ;2
    nop               ;1  32
    nop               ;1  33
    movlw _WHITE      ;1  34  - color for the next stripe
    movwf PORT_RGB;C       ;1  35


; White Stripe 34 cycles
    movlw .10         ;1  1
    movwf Temp        ;1  2
RGBWhStrp1:
    decfsz Temp,f     ;1 (3*10-1) 29->31
    goto RGBWhStrp1   ;2 
    nop               ;1 32
    movlw _YELLOW     ;1 33   - color for the next stripe
    movwf PORT_RGB;C       ;1 34

; Yellow Stripe 34 cycles
    movlw .10         ;1  1
    movwf Temp        ;1  2
RGBYeStrp1:
    decfsz Temp,f     ;1 (3*10-1) 29->31
    goto RGBYeStrp1   ;2
    nop               ;1 32
    movlw _CYAN       ;1 33   - color for the next stripe
    movwf PORT_RGB;C       ;1 34

; Cyan Stripe 34 cycles
    movlw .10         ;1  1
    movwf Temp        ;1  2
RGBCyStrp1:         
    decfsz Temp,f     ;1 (3*10-1) 29->31
    goto RGBCyStrp1   ;2
    nop               ;1 32
    movlw _GREEN      ;1 33   - color for the next stripe
    movwf PORT_RGB;C       ;1 34

; Green Stripe 34 cycles
    movlw .10         ;1  1
    movwf Temp        ;1  2 
RGBGrStrp1:          
    decfsz Temp,f     ;1 (3*10-1) 29->31 
    goto RGBGrStrp1   ;2  
    nop               ;1 32 
    movlw _MAGENTA    ;1 33   - color for the next stripe 
    movwf PORT_RGB;C       ;1 34 

; Magenta Stripe 34 cycles
    movlw .10         ;1  1
    movwf Temp        ;1  2
RGBMgStrp1:            
    decfsz Temp,f     ;1 (3*10-1) 29->31
    goto RGBMgStrp1   ;2
    nop               ;1 32
    movlw _RED        ;1 33   - color for the next stripe
    movwf PORT_RGB;C       ;1 34

; Red Stripe 34 cycles
    movlw .10         ;1  1
    movwf Temp        ;1  2
RGBRdStrp1:           
    decfsz Temp,f     ;1 (3*10-1) 29->31
    goto RGBRdStrp1   ;2
    nop               ;1 32
    movlw _BLUE       ;1 33   - color for the next stripe
    movwf PORT_RGB;C       ;1 34

; Blue Stripe 34 cycles
    movlw .10         ;1  1
    movwf Temp        ;1  2
RGBBlStrp1:           
    decfsz Temp,f     ;1 (3*10-1) 29->31
    goto RGBBlStrp1   ;2
    nop               ;1 32
    movf RGB_SHELF,w  ;1 33   - color for the next stripe
    movwf PORT_RGB;C       ;1 34

    ; 35 + 7*4 = 273 cycles from drop
    ; 273 + 26 from start = 299 cycles. 11 Cycles to the end (310)
    movlw .3          ;1
    movwf Temp        ;1
RGBVisEnd:
    decfsz Temp,f     ;1  (3*3-1) 8->10 
    goto   RGBVisEnd  ;2
    nop               ;1 11  

    return ; already taken into account


;**********************************************************************
; Generate one solid color line, defined by variable RGB_BGCOLOR
;**********************************************************************
MSX1_Colored_line:
RGB_Colored_line:
    ; drop Vsync      ;cy acumulado
    movf RGB_HSYNC,w  ;1
    movwf PORT_RGB;C       ;1
    movlw .7          ;1  1  (24 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
RGBCol1:
    decfsz Temp,f     ;1  (3*7 -1) 20 -> 22
    goto   RGBCol1    ;2
    movf RGB_SHELF,w  ;1  23
    movwf PORT_RGB;C       ;1  24
    ; 26 cycles up to here. 284 to the end

; Backporch 22+13 =35 cycles.
    movlw .10         ;1
    movwf Temp        ;1
RGBCol2:
    decfsz Temp,f     ;1 (3*10-1) 29-> 31
    goto RGBCol2      ;2
    nop               ;1  32
    nop               ;1  33
    movf RGB_BGCOLOR,w ;1  34  - color for the line
    movwf PORT_RGB;C         ;1  35


; Colored Stripe 34 * 7  =  238 cycles
    movlw .78         ;1  1
    movwf Temp        ;1  2
RGBCol3:
    decfsz Temp,f     ;1 (3*78-1) 233->235
    goto RGBCol3      ;2
    nop               ;1 236
    movf RGB_SHELF,w  ;1 237   - return to shelf (black)
    movwf PORT_RGB;C       ;1 238

    ; 35+238=273  cycles from drop
    ; 273 + 26 from start = 299 cycles. 11 Cycles to the end (310)
    movlw .3          ;1
    movwf Temp        ;1
RGBCol4:
    decfsz Temp,f     ;1  (3*3-1) 8->10
    goto   RGBCol4    ;2
    nop               ;1 11  

    return ; already taken into account



;**********************************************************************
; Generate one RGB/MSX1 graphics line BLACK/RGB_BGCOLOR
;**********************************************************************
MSX1_Graphics_line:
RGB_Graphics_line:
    ; drop Vsync      ;cy acumulado
    movf RGB_HSYNC,w  ;1
    movwf PORT_RGB;C       ;1
    movlw .7          ;1  1  (24 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
;
    decfsz Temp,f     ;1  (3*7 -1) 20 -> 22
    goto   $-1    ;2
    movf RGB_SHELF,w  ;1  23
    movwf PORT_RGB;C       ;1  24
    ; 26 cycles up to here. 284 to the end

; Backporch 22+13 =35 cycles.
    movlw .10          ;1
    movwf Temp         ;1
;
    decfsz Temp,f      ;1 (3*10-1) 29-> 31
    goto $-1           ;2
    nop                ;1  32
    nop                ;1  33
    movf RGB_BGCOLOR,w ;1  34  - color for the line
    movwf PORT_RGB     ;C  35
    ;26+35 = 61 cycles up to here.


    ; 35 cycles until start of graphics
    movlw .11         ;1
    movwf Temp        ;1
    decfsz Temp,f     ;1 (3*11-1) 32 32
    goto $-1          ;2
    nop               ;1
    ;61+35=96 cycles up to here


    pagesel Make_Graphics  ;1
    call Make_Graphics     ;158
    pagesel main           ;1     96+160=256 cycles up to here

    movlw .13         ;1  1   (44 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
    decfsz Temp,f       ;1  (3*13-1) 38-> 40
    goto $-1            ;2
    nop                 ;   41
    movf RGB_SHELF,w    ;1  42
    movwf PORT_RGB      ;1  43  Write Border color again
    ; 43+256=299 cycles up to here. 11 Cycles to the end (310)

    movlw .3          ;1
    movwf Temp        ;1
;
    decfsz Temp,f     ;1  (3*3-1) 8->10
    goto   $-1    ;2
    nop               ;1 11  

    return ; already taken into account










;**********************************************************************
; Generate a Blank Line and check for timeout timer
;**********************************************************************
; INFO:
; Once this line is called once in a frame and sleeps the PIC after
; 0xf00 calls for NTSC which means roughly 64 seconds, or after 0xd00
; calls which means roughly 60 seconds for PAL (50Hz)
;**********************************************************************
MSX1_Last_Line:
RGB_Last_line:        ; same as blank line but check for timeout and 
                      ; enter to sleep
    ; drop Vsync      ;cy acumulado
    movf RGB_HSYNC,w  ;1
    movwf PORT_RGB;C       ;1
    movlw .7          ;1  1  (24 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
RGBLastL1:
    decfsz Temp,f     ;1  (3*7 -1) 20 -> 22
    goto   RGBLastL1  ;2  
    movf RGB_SHELF,w  ;1  23
    movwf PORT_RGB; C       ;1  24
    ; 26 cycles up to here. 284 to the end

    ; Check for Auto Power-Off
    incf SLPTIMERH,f   ;1
    incfsz SLPTIMERL,f ;1
    decf SLPTIMERH,f   ;1

    
    movf SLPTIMERH,w  ;1
    xorwf SLP_TOUT,W      ;1
;    xorlw 0fh         ;1
    btfss STATUS,Z    ;1
    goto RGBLLCont    ;2
    
    goto PutToSleep   ; go to sleep


RGBLLCont:  ; 34 cycles up to here. 276 to the end
    

    movlw .91         ;1  1
    movwf Temp        ;1  2
RGBLastL2:
    decfsz Temp,f     ;1  (3*91-1) 272->274
    goto RGBLastL2    ;2
    nop               ;1  275
    nop               ;1  276
;
    return ; already taken into account


;**********************************************************************
; Generate first Half of a line
;**********************************************************************
; INFO:
; Similar to a blank line but lasts only half of the time. Also incre-
; ment the timeout counter and check for auto power off
;**********************************************************************
RGB_Half_line1:
    ; drop Vsync      ;cy acumulado
    movf RGB_HSYNC,w  ;1
    movwf PORT_RGB;C  ;1
    movlw .7          ;1  1  (24 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
RGBHalf1_1:
    decfsz Temp,f     ;1  (3*7 -1) 20 -> 22
    goto   RGBHalf1_1 ;2
    movf RGB_SHELF,w  ;1  23
    movwf PORT_RGB    ;1  24
    ; 26 cycles up to here. 125 to the end (284-159)

    ; Check for Auto Power-Off
    incf SLPTIMERH,f   ;1 ; 16 bit increment of SLPTIMERH/L
    incfsz SLPTIMERL,f ;1
    decf SLPTIMERH,f   ;1

    movf SLPTIMERH,w  ;1
    xorwf SLP_TOUT,W  ;1
    btfss STATUS,Z    ;1 timeout?
    goto RGBHalf1_2   ;2  no, continue
    goto PutToSleep   ; yes, go to sleep


RGBHalf1_2:  ; 34 cycles up to here. 117 to the end (276-159)

    movlw .38         ;1  1
    movwf Temp        ;1  2
RGBHalf1_3:
    decfsz Temp,f     ;1  (3*38-1) 113->115
    goto RGBHalf1_3   ;2
    nop               ;1  116
    nop               ;1  117
;
    return ; already taken into account


;**********************************************************************
; Generate second Half of a line
;**********************************************************************
; INFO:
; only a shelf line 
;**********************************************************************
RGB_Half_line2:
    ; shelf           ;cy acumulado
    movf RGB_SHELF,w  ;1
    movwf PORT_RGB;C  ;1
    ; 2 cycles up to here, 149 to the end (308-159)

    movlw .49         ;1  1
    movwf Temp        ;1  2
RGBHalf2_1:
    decfsz Temp,f     ;1  (3*49-1) 147->149
    goto RGBHalf2_1   ;2
     nop               ;1  116
;    nop               ;1  117
;
    return ; already taken into account




;******************************************************************
; Common for RGB and VGA. Put the chip to sleep
;******************************************************************
; INFO:
; This deactivates all the used pins, including the BIAS for RED
; and BLUE while keeps the open (not used) pins as outputs in order
; to save power 
;******************************************************************
PutToSleep:

    clrf SLPTIMERL   
    clrf SLPTIMERH 
    clrf OPMode

    bsf STATUS,RP0  ; bank1
   
    movlw ( 1<<_SOG | 1<<_HSYNC | 1<<_VSYNC | 1<<_RD | 1<<_BL | 1<<_GR )
    movwf TRIS_RGB  ; Set all used pins as inputs for saving power
 
    movlw ( 1<<_RED_BIAS | 1<< _BLUE_BIAS)
    movwf TRISA     ; Set BIAS pins as inputs for saving power
    
    
    bcf STATUS,RP0  ; bank0
 
    ; check wether the 50/60Hz selection jumper is either open or close
    ; if close (50Hz) program pin as output, otherwise set it as input
    ;btfsc PORTA,_50Hz
 

    sleep           ; go to sleep. Wake up on Reset vector
    goto main       ; just in case :)








;**********************************************************************
;  __  __ _____  __  _   ___              _  __ _    
; |  \/  / __\ \/ / / | / __|_ __  ___ __(_)/ _(_)__ 
; | |\/| \__ \>  <  | | \__ \ '_ \/ -_) _| |  _| / _|
; |_|  |_|___/_/\_\ |_| |___/ .__/\___\__|_|_| |_\__|
;                           |_|                      
;**********************************************************************


;**********************************************************************
; Generate a MSX first Vertical Serration line
;**********************************************************************
MSX1_Vser1_line:
    ; drop Vsync      ;cy acumulado
    movf RGB_VSYNC,w  ;1
    movwf PORT_RGB    ;1
    movlw .7          ;1  1  (24 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
MSXVSer1_1:
    decfsz Temp,f      ;1  (3*7 -1) 20 -> 22
    goto   MSXVSer1_1  ;2
    movf RGB_VSHELF,w  ;1  23
    movwf PORT_RGB     ;1  24
    ; 26 cycles up to here.

    movf RGB_VSYNC,w   ; 1  short pulse of 600ns
    nop                ; 1
    movwf PORT_RGB     ; 1

    ; 29 cycles up to here, 281 to the end
    movlw .93         ;1  1
    movwf Temp        ;1  2
MSXVSer1_2:
    decfsz Temp,f     ;1  (3*93-1) 278->280
    goto MSXVSer1_2        ;2
    nop               ;1  281
;
    return ; already taken into account


;**********************************************************************
; Generate a MSX second Vertical Serration line
;**********************************************************************
; INFO:
; This is only low level line. Sync level is dropped at beginning and
; does not return to shelf
;**********************************************************************
MSX1_Vser2_line:
    ; drop Vsync      ;cy acumulado
    movf RGB_VSYNC,w  ;1
    movwf PORT_RGB    ;1
    ; 2 cycles up to here, 308 to the end

    movlw .102        ;1
    movwf Temp        ;1
MSXVSer2_1:
    decfsz Temp,f      ;1  (3*102 -1) 305 -> 307
    goto   MSXVSer2_1  ;2
    clrf  GRPCOUNT ;   ;1  308 waste 1 cycle clearing GRPCOUNT
;
    return ; already taken into account




;**********************************************************************
;  _____ _  _____  ____  __  ___              _  __ _    
; |_   _| |/ / _ \/  \ \/ / / __|_ __  ___ __(_)/ _(_)__ 
;   | | | ' <\_, / () >  <  \__ \ '_ \/ -_) _| |  _| / _|
;   |_| |_|\_\/_/ \__/_/\_\ |___/ .__/\___\__|_|_| |_\__|
;                               |_|                      
;**********************************************************************


;**********************************************************************
;  _____ _  _____  ____  __  ___
; |_   _| |/ / _ \/  \ \/ / | __| _ __ _ _ __  ___
;   | | | ' <\_, / () >  <  | _| '_/ _` | '  \/ -_)
;   |_| |_|\_\/_/ \__/_/\_\ |_||_| \__,_|_|_|_\___|
;
;
;**********************************************************************
; INFO:                                                               *
; TK90X ULA Frame format                                              *
; lines                                                               *
;   1      Heq1                                                       *
;   3      Vser                                                       *
;   1      Heq2                                                       *
;  20      White                                                      *
;  15(33)  Top Border                                                 *
; 192      Active Display 90 color bars + 8 sync mode + 90 color bars *
;  22(54)  Bottom Border                                              *
;   8      White                                                      *
;-----                                                                *
; 262 (312) lines total                                               *
;                                                                     *
;**********************************************************************

DO_TK90X:
    clrf MACHINE ; for graphics routine 
    movlw _WHITE       ; 
    movwf RGB_BORDCLR  ; Border Color 
	movlw 1 ; One line of Horizontal Equalization

TK90X_Frame:
; First horizontal equalization line


	movwf Conta   ; w=1
TK90X_Heq1_loop:
	call TK90X_Heq1_line
	movlw .3          ; amount of repeats of next cycle  
	decfsz Conta,f    ;
	goto TK90X_Heq1_loop

;Vertical serration lines (a whole low level line)
 	movwf Conta   ;  w=3, First Vertical serration
TK90X_Vser_loop:
	call TK90X_Vser_line
	movlw .1      ; amount of repeats of next cycle (only one)
	decfsz Conta,f
    goto TK90X_Vser_loop

; Second set of horizontal equalization lines
	movwf Conta   ; w=1
TK90X_Heq2_loop:
	call TK90X_Heq2_line
	movlw .20   ; amount of repeats of next cycle
	decfsz Conta,f    ;
	goto TK90X_Heq2_loop

; Video Blanking lines
	movwf Conta ; w=20
TK90X_VBlank_loop:
	call TK90X_White_line
	movf RGB_TBORDER,w   ; next amount lines of top border
	decfsz Conta,f
	goto TK90X_VBlank_loop

; Top Border lines
	movwf Conta ; w=TBorder->15/33 lines    NTSC/PAL
TK90X_Top_Border_loop:
	call TK90X_Border_line ; TODO - create BORDER line content
	movlw .92            ; next 92+8+92 lines of active video
	decfsz Conta,f
	goto TK90X_Top_Border_loop

; Video Active lines, part one
	movwf Conta  ; w=92
TK90X_Active_loop_part1:
	call TK90X_Visible_line
	movlw .1   ; next lines will be colored line
	decfsz Conta,f
	goto TK90X_Active_loop_part1


; Show Active machine, sync mode and frequency

; Colored Line above graphics
	movwf Conta ; w=1
    ;
	call TK90X_Colored_line
	movlw .6            ; next 6 lines will be graphics
	decfsz Conta,f
	goto $-3

; Colored Lines
	movwf Conta ; w=8
    ;
	call TK90X_Graphics_line
	movlw .1            ; next lines will be colored line
	decfsz Conta,f
	goto $-3

; Colored Line below graphics
	movwf Conta ; w=1
    ;
	call TK90X_Colored_line
	movlw .92            ; next 92 lines will be active video
	decfsz Conta,f
	goto $-3




; Video Active lines, part two
	movwf Conta ; w=92
TK90X_Active_loop_part2:
	call TK90X_Visible_line
	movf RGB_BBORDER,w   ; next amount lines of bottom border minus one
	decfsz Conta,f
	goto TK90X_Active_loop_part2


; Bottom Border lines
	movwf Conta  ; w=Bottom Border->22/54 lines
TK90X_Bottom_Border_loop:
	call TK90X_Border_line ; TODO - create BORDER line content
	movlw .7             ; dummy
	decfsz Conta,f
	goto TK90X_Bottom_Border_loop

    movwf Conta
TK90X_Bottom_VBlank_loop:
	call TK90X_White_line ; TODO - create BORDER line content
	movlw .1             ; dummy
	decfsz Conta,f
	goto TK90X_Bottom_VBlank_loop


	nop                 ; Last line is called outside a loop for equalize timing
	call TK90X_Last_line  ; check Auto power off in last line. put to sleep after 64 seconds
	movlw .1            ; dummy for equalize timing
 
	goto TK90X_Frame ;
; end of TK90X1 Frame






;**********************************************************************
; Generate a TK90X first Horizontal Equalization line
;**********************************************************************
TK90X_Heq1_line: ;318
    ; drop Vsync      ;cy acumulado
    movf RGB_HSYNC,w  ;1 
    movwf PORT_RGB    ;1
    movlw .6          ;1  1  (22 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
TK90XHeq1_1:
    decfsz Temp,f        ;1  (3*6 -1) 17 -> 19
    goto   TK90XHeq1_1    ;2
    nop                ;1  20
    movf RGB_SHELF,w  ;1  21;        
    movwf PORT_RGB     ;1  22
    ; 24 cycles up to here

    movlw .10         ;1  1  (34 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
TK90XHeq1_2:
    decfsz Temp,f        ;1  (3*10 -1) 29 -> 31
    goto  TK90XHeq1_2    ;2
    nop               ;1  32
    movlw _WHITE      ;1  33
    movwf PORT_RGB    ;1  34
    ; 24 + 34 = 58 cycles up to here


    movlw .66         ;1  1  (201 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
TK90XHeq1_3:
    decfsz Temp,f        ;1  (3*66 -1) 197 -> 199
    goto  TK90XHeq1_3    ;2

    movf RGB_VSYNC,w  ;1  200


    movwf PORT_RGB    ;1  201
    ; 58 + 201 = 259 cycles up to here, 51 to the end

    movlw .16         ;1  1
    movwf Temp        ;1  2
TK90XHeq1_4:
    decfsz Temp,f     ;1  (3*16-1) 47-> 49
    goto TK90XHeq1_4        ;2
    nop               ;1  50
    nop               ;1  51
;
    return ; already taken into account



;**********************************************************************
; Generate a TK90X second Vertical Serration line
;**********************************************************************
; INFO:
; This is only low level line. Sync level is dropped at beginning and
; does not return to shelf
;**********************************************************************
TK90X_Vser_line:
    ; drop Vsync      ;cy acumulado
    movf RGB_VSYNC,w  ;1
    movwf PORT_RGB    ;1
    ; 2 cycles up to here, 308 to the end

    movlw .102        ;1
    movwf Temp        ;1
TK90XVSer_1:
    decfsz Temp,f      ;1  (3*102 -1) 305 -> 307
    goto   TK90XVSer_1  ;2
    nop               ;1  308
;
    return ; already taken into account




;**********************************************************************
; Generate a TK90X Second Horizontal Equalization line
;**********************************************************************
TK90X_Heq2_line: ;318
    ; drop Vsync      ;cy acumulado
    movf RGB_VSYNC,w  ;1  certify that level is Vsync
    movwf PORT_RGB    ;1
    movlw .84          ;1  1  (257 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
TK90XHeq2_1:
    decfsz Temp,f        ;1  (3*84 -1) 252 -> 254
    goto  TK90XHeq2_1    ;2
    nop                ;1  255
    movlw _WHITE       ;1  256
    movwf PORT_RGB     ;1  257
    ; 257 cycles up to here, 53 to the end

    movlw .17         ;1  1
    movwf Temp        ;1  2
TK90XHeq2_2:
    decfsz Temp,f     ;1  (3*17-1) 50-> 52
    goto TK90XHeq2_2  ;2
;    nop               ;1  50
;    nop               ;1  51
;
    return ; already taken into account


;**********************************************************************
; Generate a TK90X Colored line RGB_BORDCLR / RGB_BGCOLOR
;**********************************************************************
TK90X_Colored_line: ;318
    ; drop Vsync      ;cy acumulado
    movf RGB_HSYNC,w  ;1
    movwf PORT_RGB    ;1
    movlw .6          ;1  1  (22 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
TK90XColor_1:
    decfsz Temp,f        ;1  (3*6 -1) 17 -> 19
    goto  TK90XColor_1   ;2
    nop                ;1  20
    movf RGB_SHELF,w   ;1  21
    movwf PORT_RGB     ;1  22
    ; 24 cycles up to here

    movlw .10         ;1  1  (34 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
TK90XColor_2:
    decfsz Temp,f         ;1  (3*10 -1) 29 -> 31
    goto  TK90XColor_2    ;2
    nop                ;1  32
    movf RGB_BORDCLR,w ;1  33
    movwf PORT_RGB     ;1  34  Write Border color
    ; 24 + 34 = 58 cycles up to here


    movlw .8          ;1  1  (29 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
TK90XColor_3:
    decfsz Temp,f        ;1  (3*8 -1) 23 -> 25
    goto  TK90XColor_3    ;2
    movf RGB_BGCOLOR,w ; 1  26
    clrf  GRPCOUNT    ; 1  27   waste 1 cycle zeroing GRaPhics line COUNTer
    nop               ; 1  28   it is necessary for graphics conditional calls
    movwf PORT_RGB     ;1  29
    ; 58 + 29 = 87 cycles up to here, 223 to the end

    movlw .59         ;1  1   (182 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
TK90XColor_4:
    decfsz Temp,f     ;1  (3*16-1) 176-> 178
    goto TK90XColor_4        ;2
    nop                ;1  179 
    nop                ;1  180
    movf RGB_BORDCLR,w ;1  181
    movwf PORT_RGB     ;1  182  Write Border color again
    ; 87+182 = 269 cycles up to here, 41 to the end


    movlw .8          ;1  1   (29 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
TK90XColor_5:
    decfsz Temp,f       ;1  (3*8-1) 23-> 25
    goto TK90XColor_5   ;2
    nop                ;1  26
    nop                ;1  27
    movf RGB_SHELF,w     ;1  28
    movwf PORT_RGB     ;1  29  Write Border color again
    ; 269 + 29 =  298 cycles up to here, 12 to the end

    movlw .3          ;1  1
    movwf Temp        ;1  2
TK90XColor_6:
    decfsz Temp,f       ;1  (3*3-1) 8-> 10
    goto TK90XColor_6   ;2
    nop                ;1  11
    nop                ;1  12
    return ; already taken into account


;**********************************************************************
; Generate a TK90X Visible Line
;**********************************************************************
TK90X_Visible_line: ;318
    ; drop Vsync      ;cy acumulado
    movf RGB_HSYNC,w  ;1
    movwf PORT_RGB    ;1
    movlw .6          ;1  1  (22 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
TK90XVisible_1:
    decfsz Temp,f        ;1  (3*6 -1) 17 -> 19
    goto  TK90XVisible_1   ;2
    nop                ;1  20
    movf RGB_SHELF,w   ;1  21
    movwf PORT_RGB     ;1  22
    ; 24 cycles up to here

    movlw .10         ;1  1  (34 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
TK90XVisible_2:
    decfsz Temp,f         ;1  (3*10 -1) 29 -> 31
    goto  TK90XVisible_2    ;2
    nop                ;1  32
    movf RGB_BORDCLR,w ;1  33
    movwf PORT_RGB     ;1  34  Write Border color
    ; 24 + 34 = 58 cycles up to here


    movlw .8          ;1  1  (29 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
TK90XVisible_3:
    decfsz Temp,f        ;1  (3*8 -1) 23 -> 25
    goto  TK90XVisible_3    ;2
    movlw _WHITE      ; 1  26  First color is white
    nop               ; 1  27
    nop               ; 1  28
    movwf PORT_RGB     ;1  29
    ; 58 + 29 = 87 cycles up to here, 223 to the end


;white stripe
    movlw .7          ;1  1   (26 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
TK90XVisible_WH:
    decfsz Temp,f              ;1  (3*7-1) 20-> 22
    goto TK90XVisible_WH       ;2
    nop                ;1  23
    nop                ;1  24
    movlw _YELLOW      ;1  25
    movwf PORT_RGB     ;1  26 
    ; 87+26=113 cycles up to here

;yellow stripe
    movlw .7          ;1  1   (26 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
TK90XVisible_YE:
    decfsz Temp,f              ;1  (3*7-1) 20-> 22
    goto TK90XVisible_YE       ;2
    nop                ;1  23
    nop                ;1  24
    movlw _GREEN       ;1  25
    movwf PORT_RGB     ;1  26  Write Border color again
    ; 113+26=139 cycles up to here

;green stripe
    movlw .7          ;1  1   (26 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
TK90XVisible_GR:
    decfsz Temp,f              ;1  (3*7-1) 20-> 22
    goto TK90XVisible_GR       ;2
    nop                ;1  23
    nop                ;1  24
    movlw _CYAN        ;1  25
    movwf PORT_RGB     ;1  26
    ; 139+26=165 cycles up to here

;cyan stripe
    movlw .7          ;1  1   (26 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
TK90XVisible_CY:
    decfsz Temp,f              ;1  (3*7-1) 20-> 22
    goto TK90XVisible_CY       ;2
    nop                ;1  23
    nop                ;1  24
    movlw _MAGENTA     ;1  25
    movwf PORT_RGB     ;1  26
    ; 165+26=191 cycles up to here

;magenta stripe
    movlw .7          ;1  1   (26 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
TK90XVisible_MG:
    decfsz Temp,f              ;1  (3*7-1) 20-> 22
    goto TK90XVisible_MG       ;2
    nop                ;1  23
    nop                ;1  24
    movlw _RED         ;1  25
    movwf PORT_RGB     ;1  26
    ; 191+26=217 cycles up to here

;red stripe
    movlw .7          ;1  1   (26 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
TK90XVisible_RD:
    decfsz Temp,f              ;1  (3*7-1) 20-> 22
    goto TK90XVisible_RD       ;2
    nop                ;1  23
    nop                ;1  24
    movlw _BLUE       ;1  25
    movwf PORT_RGB     ;1  26
    ; 217+26=243 cycles up to here

;blue stripe
    movlw .7          ;1  1   (26 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
TK90XVisible_BL:
    decfsz Temp,f              ;1  (3*7-1) 20-> 22
    goto TK90XVisible_BL       ;2
    nop                ;1  23
    nop                ;1  24
    movf RGB_BORDCLR,w ;1  25
    movwf PORT_RGB     ;1  26
    ; 243+26=269 cycles up to here, 41 to the end


    movlw .8          ;1  1   (29 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
TK90XVisible_5:
    decfsz Temp,f       ;1  (3*8-1) 23-> 25
    goto TK90XVisible_5   ;2
    nop                ;1  26
    nop                ;1  27
    movf RGB_SHELF,w     ;1  28
    movwf PORT_RGB     ;1  29  Write Border color again
    ; 269 + 29 =  298 cycles up to here, 12 to the end

    movlw .3          ;1  1
    movwf Temp        ;1  2
TK90XVisible_6:
    decfsz Temp,f       ;1  (3*3-1) 8-> 10
    goto TK90XVisible_6   ;2
    nop                ;1  11
    nop                ;1  12
    return ; already taken into account




;**********************************************************************
; Generate a TK90X Border line RGB_BORDCLR
;**********************************************************************
TK90X_White_line:
TK90X_Border_line:
    ; drop Vsync      ;cy acumulado
    movf RGB_HSYNC,w  ;1
    movwf PORT_RGB    ;1
    movlw .6          ;1  1  (22 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
TK90XBorder_1:
    decfsz Temp,f        ;1  (3*6 -1) 17 -> 19
    goto  TK90XBorder_1   ;2
    nop                ;1  20
    movf RGB_SHELF,w  ;1  21
    movwf PORT_RGB     ;1  22
    ; 24 cycles up to here

    movlw .10         ;1  1  (34 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
TK90XBorder_2:
    decfsz Temp,f         ;1  (3*10 -1) 29 -> 31
    goto  TK90XBorder_2    ;2
    nop                ;1  32
    movf RGB_BORDCLR,w ;1  33
    movwf PORT_RGB     ;1  34  Write Border color
    ; 24 + 34 = 58 cycles up to here


    movlw .79         ;1  1   (240 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
TK90XBorder_3:
    decfsz Temp,f       ;1  (3*79-1) 236-> 230
    goto TK90XBorder_3   ;2
    movf RGB_SHELF,w     ;1  239
    movwf PORT_RGB     ;1  240  Write Border color again
    ; 240 + 58 =  298 cycles up to here, 12 to the end

    movlw .3          ;1  1
    movwf Temp        ;1  2
TK90XBorder_4:
    decfsz Temp,f       ;1  (3*3-1) 8-> 10
    goto TK90XBorder_4   ;2
    nop                ;1  11
    nop                ;1  12
    return ; already taken into account


;**********************************************************************
; Generate a TK90X Last line RGB_BORDCLR
;**********************************************************************
TK90X_Last_line: ;318
    ; drop Vsync      ;cy acumulado
    movf RGB_HSYNC,w  ;1
    movwf PORT_RGB    ;1
    movlw .6          ;1  1  (22 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
TK90XLast_1:
    decfsz Temp,f        ;1  (3*6 -1) 17 -> 19
    goto  TK90XLast_1   ;2
    nop                ;1  20
    movf RGB_SHELF,w   ;1  21
    movwf PORT_RGB     ;1  22
    ; 24 cycles up to here

    movlw .10         ;1  1  (34 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
TK90XLast_2:
    decfsz Temp,f         ;1  (3*10 -1) 29 -> 31
    goto  TK90XLast_2    ;2
    nop                ;1  32
    movf RGB_BORDCLR,w ;1  33
    movwf PORT_RGB     ;1  34  Write border color
    ; 24 + 34 = 58 cycles up to here

    movlw .79         ;1  1   (240 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
TK90XLast_3:
    decfsz Temp,f       ;1  (3*79-1) 236-> 230
    goto TK90XLast_3   ;2
    movf RGB_SHELF,w     ;1  239
    movwf PORT_RGB     ;1  240
    ; 240 + 58 =  298 cycles up to here, 12 to the end


    ; Check for Auto Power-Off
    incf SLPTIMERH,f   ;1  1       ; increment timeout timer
    incfsz SLPTIMERL,f ;1  2
    decf SLPTIMERH,f   ;1  3


    movf SLPTIMERH,w  ;1   4
    xorwf SLP_TOUT,W  ;1   5  ; overflowed?
;    xorlw 0fh        ;1   6
    btfss STATUS,Z    ;1   7
    goto TK90XLast_4  ;2   9     ; no, continue

    goto PutToSleep   ; yes, go to sleep

TK90XLast_4:  
    ; 306 cycles up to here, 4 to the end 
    nop                ;1  10
    nop                ;1  11
    nop                ;1  12
    nop;
    return ; already taken into account


;**********************************************************************
; Generate a TK90X Graphics line with BLACK/RGB_BORDCLR
;**********************************************************************
TK90X_Graphics_line:
    ; drop Vsync      ;cy acumulado
    movf RGB_HSYNC,w  ;1
    movwf PORT_RGB    ;1
    movlw .6          ;1  1  (22 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2

    decfsz Temp,f        ;1  (3*6 -1) 17 -> 19
    goto  $-1            ;2
    nop                ;1  20
    movf RGB_SHELF,w   ;1  21
    movwf PORT_RGB     ;1  22
    ; 24 cycles up to here

    movlw .10         ;1  1  (34 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2

    decfsz Temp,f         ;1  (3*10 -1) 29 -> 31
    goto  $-1             ;2
    nop                ;1  32
    movf RGB_BORDCLR,w ;1  33
    movwf PORT_RGB     ;1  34  Write Border color
    ; 24 + 34 = 58 cycles up to here

    movlw .8          ;1  1  (29 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2
 
    decfsz Temp,f        ;1  (3*8 -1) 23 -> 25
    goto  $-1           ;2
    movf RGB_BGCOLOR,w ; 1  26
    nop               ; 1  27   waste 1 cycle zeroing GRaPhics line COUNTer
    nop               ; 1  28   it is necessary for graphics conditional calls
    movwf PORT_RGB     ;1  29
    ; 58 + 29 = 87 cycles up to here, 223 to the end
    ; 182 cycles until next write to PORT_RGB
    

    ; 6 cycles until start of graphics
    goto $+1          ;2  2
    goto $+1          ;2  4
    goto $+1          ;2  6
    ; 87+6 = 93 cycles up to here, 217 to the end


    pagesel Make_Graphics  ;1    1       7
    call Make_Graphics     ;158  159     165
    pagesel main           ;1    160     166
    ;93+160=253 cycles up to here, 57 to the end

    movlw .4           ;1  1  167
    movwf Temp         ;1  2  168
    decfsz Temp,f      ;1  (3*4-1) 11-> 13  179
    goto $-1           ;2
    nop                ;1  14  180
    movf RGB_BORDCLR,w ;1  15  181
    movwf PORT_RGB     ;1  16  182  Write Border color again
    ; 87+182 = 269 cycles up to here, 41 to the end
    ; 253 + 16 =  269 cycles up to here,

    movlw .8          ;1  1   (29 cycles until next write to PORT_RGB)
    movwf Temp        ;1  2

    decfsz Temp,f       ;1  (3*8-1) 23-> 25
    goto $-1            ;2
    nop                ;1  26
    nop                ;1  27
    movf RGB_SHELF,w     ;1  28
    movwf PORT_RGB     ;1  29  Write Border color again
    ; 269 + 29 =  298 cycles up to here, 12 to the end

    movlw .3          ;1  1
    movwf Temp        ;1  2

    decfsz Temp,f       ;1  (3*3-1) 8-> 10
    goto $-1            ;2
    nop                ;1  11
    nop                ;1  12
    return ; already taken into account







LAST_INSTRUCTION:

org 0x800
#include graphics.asm

;**********************************************************************
;  ___ ___ ___ ___  ___  __  __    ___         _           _      
; | __| __| _ \ _ \/ _ \|  \/  |  / __|___ _ _| |_ ___ _ _| |_ ___
; | _|| _||  _/   / (_) | |\/| | | (__/ _ \ ' \  _/ -_) ' \  _(_-<
; |___|___|_| |_|_\\___/|_|  |_|  \___\___/_||_\__\___|_||_\__/__/
;
;**********************************************************************                                                                 


	ORG	0x2100			 ; data EEPROM location
	DT "Danjovic 2015"   ; Signature


	END                       ; directive 'end of program'

; ASCII by http://patorjk.com/software/taag/


