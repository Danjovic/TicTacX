;**********************************************************************
;  __  __      _        ___               _    _       
; |  \/  |__ _| |_____ / __|_ _ __ _ _ __| |_ (_)__ ___
; | |\/| / _` | / / -_) (_ | '_/ _` | '_ \ ' \| / _(_-<
; |_|  |_\__,_|_\_\___|\___|_| \__,_| .__/_||_|_\__/__/
;                                   |_|   
;**********************************************************************
Make_Graphics:        ; 2 
    call GRP_Machine  ; 61 58 54
    call GRP_Sync     ; 50 47 46
    call GRP_Freq     ; 42 39 38

    incf GRPCOUNT,f   ; 1


    return            ; 2



;**********************************************************************
;  ___                 ___               _    _
; / __|_  _ _ _  __   / __|_ _ __ _ _ __| |_ (_)__ ___
; \__ \ || | ' \/ _| | (_ | '_/ _` | '_ \ ' \| / _(_-<
; |___/\_, |_||_\__|  \___|_| \__,_| .__/_||_|_\__/__/
;      |__/                        |_|
;**********************************************************************
GRP_Sync:                             ; 2 from call
    movlw  high(SYNC_TABLE_START)     ; 1 3
    movwf  PCLATH                     ; 1 4
    movf SYNCMODE,w                   ; 1 5
    andlw b'00000011'                 ; 1 6
    addlw  SYNC_TABLE_START           ; 1 7
    skpnc                             ; 1 8
    incf  PCLATH,f                    ; 1 9
    movwf  PCL                        ; 1 10
SYNC_TABLE_START:                     ; 2 more 12
    goto GRP_CS                       ;
    goto GRP_HV                       ;
    goto GRP_SOG                      ;
    goto GRP_SOG                      ; just in case


;**********************************************************************
; Sync on Green graphics line handler
;**********************************************************************
GRP_SOG:
    movlw  high(SOG_GRP_START)        ; 1  13
    movwf  PCLATH                     ; 1  14
    movf GRPCOUNT,w                   ; 1  15
    andlw b'00000111'                 ; 1  16
    addlw  SOG_GRP_START              ; 1  17
    skpnc                             ; 1  18
    incf  PCLATH,f                    ; 1  19
    movwf  PCL                        ; 1  20
SOG_GRP_START:
    goto GRP_SOG_Line_1                ; total: 20 + 2 + 22 + 2 = 46
    goto GRP_SOG_Line_2                ;
    goto GRP_SOG_Line_3                ;
    goto GRP_SOG_Line_4                ;
    goto GRP_SOG_Line_5                ;
    goto GRP_SOG_Line_6                ;
    goto GRP_SOG_Line_1                ; just in case
    goto GRP_SOG_Line_2                ; just in case
    goto GRP_SOG_Line_3                ; just in case


;**********************************************************************
; Separate Sync graphics line handler
;**********************************************************************
GRP_HV:
    movlw  high(HV_GRP_START)         ; 1  13
    movwf  PCLATH                     ; 1  14
    movf GRPCOUNT,w                   ; 1  15
    andlw b'00000111'                 ; 1  16
    addlw  HV_GRP_START               ; 1  17
    skpnc                             ; 1  18
    incf  PCLATH,f                    ; 1  19
    movwf  PCL                        ; 1  20
HV_GRP_START:
    goto GRP_HV_Line_1                ; total: 20 + 2 + 22 + 2 = 46
    goto GRP_HV_Line_2                ;
    goto GRP_HV_Line_3                ;
    goto GRP_HV_Line_4                ;
    goto GRP_HV_Line_5                ;
    goto GRP_HV_Line_6                ;
    goto GRP_HV_Line_1                ; just in case
    goto GRP_HV_Line_2                ; just in case
    goto GRP_HV_Line_3                ; just in case

;**********************************************************************
; Composite Sync graphics line handler
;**********************************************************************
GRP_CS:
    movlw  high(CS_GRP_START)         ; 1  13
    movwf  PCLATH                     ; 1  14
    movf GRPCOUNT,w                   ; 1  15
    andlw b'00000111'                 ; 1  16
    addlw  CS_GRP_START               ; 1  17
    skpnc                             ; 1  18
    incf  PCLATH,f                    ; 1  19
    movwf  PCL                        ; 1  20
CS_GRP_START:
    goto GRP_CS_Line_1                ; total: 20 + 2 + 22 + 2 = 46
    goto GRP_CS_Line_2                ;
    goto GRP_CS_Line_3                ;
    goto GRP_CS_Line_4                ;
    goto GRP_CS_Line_5                ;
    goto GRP_CS_Line_6                ;
    goto GRP_CS_Line_1                ; just in case
    goto GRP_CS_Line_2                ; just in case
    goto GRP_CS_Line_3                ; just in case



;**********************************************************************
;  ___  __   ____  __  _  _       ___               _    _
; | __|/  \ / / / /  \| || |___  / __|_ _ __ _ _ __| |_ (_)__ ___
; |__ \ () / / _ \ () | __ |_ / | (_ | '_/ _` | '_ \ ' \| / _(_-<
; |___/\__/_/\___/\__/|_||_/__|  \___|_| \__,_| .__/_||_|_\__/__/
;                                             |_|
;**********************************************************************
GRP_Freq:                             ; 2 from call
    movlw  high(FREQ_TABLE_START)     ; 1 3
    movwf  PCLATH                     ; 1 4
    movf FREQ,w                       ; 1 5
    andlw b'00000001'                 ; 1 6
    addlw  FREQ_TABLE_START           ; 1 7
    skpnc                             ; 1 8
    incf  PCLATH,f                    ; 1 9
    movwf  PCL                        ; 1 10
FREQ_TABLE_START:                     ; 2 more 12
    goto GRP_60                       ;
    goto GRP_50                       ;

;**********************************************************************
; 60 Hz graphics line handler
;**********************************************************************
GRP_60:
    movlw  high(FREQ60_GRP_START)     ; 1  13
    movwf  PCLATH                     ; 1  14
    movf GRPCOUNT,w                   ; 1  15
    andlw b'00000111'                 ; 1  16
    addlw  FREQ60_GRP_START           ; 1  17
    skpnc                             ; 1  18
    incf  PCLATH,f                    ; 1  19
    movwf  PCL                        ; 1  20
FREQ60_GRP_START:
    goto GRP_60_Line_1                ; total: 20 + 2 + 14 + 2 = 38
    goto GRP_60_Line_2                ;
    goto GRP_60_Line_3                ;
    goto GRP_60_Line_4                ;
    goto GRP_60_Line_5                ;
    goto GRP_60_Line_6                ;
    goto GRP_60_Line_1                ; just in case
    goto GRP_60_Line_2                ; just in case
    goto GRP_60_Line_3                ; just in case

;**********************************************************************
; 50 Hz graphics line handler
;**********************************************************************
GRP_50:
    movlw  high(FREQ50_GRP_START)     ; 1  13
    movwf  PCLATH                     ; 1  14
    movf GRPCOUNT,w                   ; 1  15
    andlw b'00000111'                 ; 1  16
    addlw  FREQ50_GRP_START           ; 1  17
    skpnc                             ; 1  18
    incf  PCLATH,f                    ; 1  19
    movwf  PCL                        ; 1  20
FREQ50_GRP_START:
    goto GRP_50_Line_1                ; total: 20 + 2 + 14 + 2 = 38
    goto GRP_50_Line_2                ;
    goto GRP_50_Line_3                ;
    goto GRP_50_Line_4                ;
    goto GRP_50_Line_5                ;
    goto GRP_50_Line_6                ;
    goto GRP_50_Line_1                ; just in case
    goto GRP_50_Line_2                ; just in case
    goto GRP_50_Line_3                ; just in case



;**********************************************************************
;  __  __         _    _             ___               _    _
; |  \/  |__ _ __| |_ (_)_ _  ___   / __|_ _ __ _ _ __| |_ (_)__ ___
; | |\/| / _` / _| ' \| | ' \/ -_) | (_ | '_/ _` | '_ \ ' \| / _(_-<
; |_|  |_\__,_\__|_||_|_|_||_\___|  \___|_| \__,_| .__/_||_|_\__/__/
;                                                |_|
;**********************************************************************
GRP_Machine:                          ; 2 from call
    movlw  high(MACHINE_TABLE_START)  ; 1 3
    movwf  PCLATH                     ; 1 4
    movf MACHINE,w                    ; 1 5
    andlw b'00000011'                 ; 1 6
    addlw  MACHINE_TABLE_START        ; 1 7
    skpnc                             ; 1 8
    incf  PCLATH,f                    ; 1 9
    movwf  PCL                        ; 1 10
MACHINE_TABLE_START:                  ; 2 more 12
    goto GRP_TK90                     ;
    goto GRP_MSX1                     ;
    goto GRP_MSX2                     ;
    goto GRP_MSX2 ; just in case      ;

;**********************************************************************
; TK90X graphics line handler
;**********************************************************************
GRP_TK90:
    movlw  high(TK90_GRP_START)       ; 1  13
    movwf  PCLATH                     ; 1  14
    movf GRPCOUNT,w                   ; 1  15
    andlw b'00000111'                 ; 1  16
    addlw  TK90_GRP_START             ; 1  17
    skpnc                             ; 1  18
    incf  PCLATH,f                    ; 1  19
    movwf  PCL                        ; 1  20

TK90_GRP_START:                       ; 2 more + 32 from line + 2 from return
    goto GRP_TK90_Line_1              ; total: 20 + 2 + 32 + 2 = 54
    goto GRP_TK90_Line_2              ;
    goto GRP_TK90_Line_3              ;
    goto GRP_TK90_Line_4              ;
    goto GRP_TK90_Line_5              ;
    goto GRP_TK90_Line_6              ;
    goto GRP_TK90_Line_1   ; just in case
    goto GRP_TK90_Line_2   ; just in case
    goto GRP_TK90_Line_3   ; just in case

;**********************************************************************
; MSX 1 graphics line handler
;**********************************************************************
GRP_MSX1:
    movlw  high(MSX1_GRP_START)       ; 1  13
    movwf  PCLATH                     ; 1  14
    movf GRPCOUNT,w                   ; 1  15
    andlw b'00000111'                 ; 1  16
    addlw  MSX1_GRP_START             ; 1  17
    skpnc                             ; 1  18
    incf  PCLATH,f                    ; 1  19
    movwf  PCL                        ; 1  20

MSX1_GRP_START:                       ; 2 more + 32 from line + 2 from return
    goto GRP_MSX1_Line_1              ; total: 20 + 2 + 32 + 2 = 54
    goto GRP_MSX1_Line_2              ;
    goto GRP_MSX1_Line_3              ;
    goto GRP_MSX1_Line_4              ;
    goto GRP_MSX1_Line_5              ;
    goto GRP_MSX1_Line_6              ;
    goto GRP_MSX1_Line_1   ; just in case
    goto GRP_MSX1_Line_2   ; just in case
    goto GRP_MSX1_Line_3   ; just in case

;**********************************************************************
; MSX 2 graphics line handler
;**********************************************************************
GRP_MSX2:
    movlw  high(MSX2_GRP_START)       ; 1  13
    movwf  PCLATH                     ; 1  14
    movf GRPCOUNT,w                   ; 1  15
    andlw b'00000111'                 ; 1  16
    addlw  MSX2_GRP_START             ; 1  17
    skpnc                             ; 1  18
    incf  PCLATH,f                    ; 1  19
    movwf  PCL                        ; 1  20

MSX2_GRP_START:                       ; 2 more + 32 from line + 2 from return
    goto GRP_MSX2_Line_1              ; total: 20 + 2 + 32 + 2 = 54
    goto GRP_MSX2_Line_2              ;
    goto GRP_MSX2_Line_3              ;
    goto GRP_MSX2_Line_4              ;
    goto GRP_MSX2_Line_5              ;
    goto GRP_MSX2_Line_6              ;
    goto GRP_MSX2_Line_1   ; just in case
    goto GRP_MSX2_Line_2   ; just in case
    goto GRP_MSX2_Line_3   ; just in case


;**********************************************************************
;  _____ _  _____  ____  __   ___               _    _
; |_   _| |/ / _ \/  \ \/ /  / __|_ _ __ _ _ __| |_ (_)__ ___
;   | | | ' <\_, / () >  <  | (_ | '_/ _` | '_ \ ' \| / _(_-<
;   |_| |_|\_\/_/ \__/_/\_\  \___|_| \__,_| .__/_||_|_\__/__/
;                                         |_|
;**********************************************************************


GRP_TK90_Line_1:
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

GRP_TK90_Line_2:
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

GRP_TK90_Line_3:
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

GRP_TK90_Line_4:
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

GRP_TK90_Line_5:
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

GRP_TK90_Line_6:
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return


;**********************************************************************
;  __  __ _____  __  _    ___               _    _
; |  \/  / __\ \/ / / |  / __|_ _ __ _ _ __| |_ (_)__ ___
; | |\/| \__ \>  <  | | | (_ | '_/ _` | '_ \ ' \| / _(_-<
; |_|  |_|___/_/\_\ |_|  \___|_| \__,_| .__/_||_|_\__/__/
;                                     |_|
;**********************************************************************
GRP_MSX1_Line_1:
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

GRP_MSX1_Line_2:
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

GRP_MSX1_Line_3:
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

GRP_MSX1_Line_4:
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

GRP_MSX1_Line_5:
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

GRP_MSX1_Line_6:
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return


;**********************************************************************
;  __  __ _____  __  ___    ___               _    _
; |  \/  / __\ \/ / |_  )  / __|_ _ __ _ _ __| |_ (_)__ ___
; | |\/| \__ \>  <   / /  | (_ | '_/ _` | '_ \ ' \| / _(_-<
; |_|  |_|___/_/\_\ /___|  \___|_| \__,_| .__/_||_|_\__/__/
;                                       |_|
;**********************************************************************


GRP_MSX2_Line_1:
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

GRP_MSX2_Line_2:
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

GRP_MSX2_Line_3:
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

GRP_MSX2_Line_4:
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

GRP_MSX2_Line_5:
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

GRP_MSX2_Line_6:
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

;**********************************************************************
;   __  __  _  _       ___               _    _
;  / / /  \| || |___  / __|_ _ __ _ _ __| |_ (_)__ ___
; / _ \ () | __ |_ / | (_ | '_/ _` | '_ \ ' \| / _(_-<
; \___/\__/|_||_/__|  \___|_| \__,_| .__/_||_|_\__/__/
;                                  |_|
;**********************************************************************
GRP_60_Line_1:
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

GRP_60_Line_2:
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

GRP_60_Line_3:
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

GRP_60_Line_4:
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

GRP_60_Line_5:
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

GRP_60_Line_6:
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

;**********************************************************************
;  ___  __  _  _       ___               _    _
; | __|/  \| || |___  / __|_ _ __ _ _ __| |_ (_)__ ___
; |__ \ () | __ |_ / | (_ | '_/ _` | '_ \ ' \| / _(_-<
; |___/\__/|_||_/__|  \___|_| \__,_| .__/_||_|_\__/__/
;                                  |_|
;**********************************************************************
GRP_50_Line_1:
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

GRP_50_Line_2:
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

GRP_50_Line_3:
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

GRP_50_Line_4:
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

GRP_50_Line_5:
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

GRP_50_Line_6:
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

;**********************************************************************
;  ___       ___    ___               _    _
; / __| ___ / __|  / __|_ _ __ _ _ __| |_ (_)__ ___
; \__ \/ _ \ (_ | | (_ | '_/ _` | '_ \ ' \| / _(_-<
; |___/\___/\___|  \___|_| \__,_| .__/_||_|_\__/__/
;                               |_|
;**********************************************************************
GRP_SOG_Line_1:
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

GRP_SOG_Line_2:
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

GRP_SOG_Line_3:
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

GRP_SOG_Line_4:
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

GRP_SOG_Line_5:
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

GRP_SOG_Line_6:
     movf RGB_FGCOLOR,w
     movwf PORT_RGB
     movf RGB_FGCOLOR,w
     movwf PORT_RGB
     movf RGB_FGCOLOR,w
     movwf PORT_RGB
     movf RGB_BGCOLOR,w
     movwf PORT_RGB
     movf RGB_FGCOLOR,w
     movwf PORT_RGB
     movf RGB_FGCOLOR,w
     movwf PORT_RGB
     movf RGB_FGCOLOR,w
     movwf PORT_RGB
     movf RGB_BGCOLOR,w
     movwf PORT_RGB
     movf RGB_FGCOLOR,w
     movwf PORT_RGB
     movf RGB_FGCOLOR,w
     movwf PORT_RGB
     movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
     return
 
 
;**********************************************************************
;  _  ___   __   ___               _    _
; | || \ \ / /  / __|_ _ __ _ _ __| |_ (_)__ ___
; | __ |\ V /  | (_ | '_/ _` | '_ \ ' \| / _(_-<
; |_||_| \_/    \___|_| \__,_| .__/_||_|_\__/__/
;                            |_|
;**********************************************************************
GRP_HV_Line_1:
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

GRP_HV_Line_2:
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

GRP_HV_Line_3:
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

GRP_HV_Line_4:
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

GRP_HV_Line_5:
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

GRP_HV_Line_6:
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

;**********************************************************************
;   ___ ___    ___               _    _
;  / __/ __|  / __|_ _ __ _ _ __| |_ (_)__ ___
; | (__\__ \ | (_ | '_/ _` | '_ \ ' \| / _(_-<
;  \___|___/  \___|_| \__,_| .__/_||_|_\__/__/
;                          |_|
;**********************************************************************
GRP_CS_Line_1:
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

GRP_CS_Line_2:
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

GRP_CS_Line_3:
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

GRP_CS_Line_4:
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

GRP_CS_Line_5:
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return

GRP_CS_Line_6:
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_FGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB
    movf RGB_BGCOLOR,w
    movwf PORT_RGB      ; last pixel blank
    return


