;*******************************************************************************
; GAME LIBRARIES
;*******************************************************************************

;-------------------------------------------------------------------------------
; LIBSCREEN LIBRARIES
;-------------------------------------------------------------------------------

; Display a single digit BCD number to the screen (indirect addressing)
defm    LIBSCREEN_PRINT_BCD_1DIGIT_AA ;BCD address, screen address (indirect)
        ldy #0
        lda /1
        and #15
        clc
        adc #$30
        sta (/2),y
        endm

; Display a two digit BCD number to the screen (indirect addressing)
defm    LIBSCREEN_PRINT_BCD_2DIGIT_AAV ;BCD address, screen address (indirect), offset
        ldy #/3
        lda /1
        pha
        lsr
        lsr
        lsr
        lsr
        clc
        adc #$30
        sta (/2),y
        pla
        and #15
        clc
        adc #$30
        iny
        sta (/2),y
        endm

; Set the current screen location for printing. Needs X and Y loaded into registers
defm    LIBSCREEN_SET_POINTER_A ;address of screen pointer
        stx /1
        lda #4
        sta /1+1
        cpy #0
        beq @exit
        txa
@loop
        clc
        adc #40
        bcc @skip
        inc /1+1
@skip
        dey
        bne @loop
        sta /1
@exit
        endm

; Set the current screen location for printing
defm    LIBSCREEN_SET_POINTER_VVA ;X position, Y position, address of screen pointer
        ldx #/1
        stx /3
        lda #4
        sta /3+1
        ldy #/2
        cpy #0
        beq @exit
        txa
@loop
        clc
        adc #40
        bcc @skip
        inc /3+1
@skip
        dey
        bne @loop
        sta /3
@exit
        endm

; Set the current screen location for printing (address version)
defm    LIBSCREEN_SET_POINTER_AAA ;X address, Y address, address of screen pointer
        ldx /1
        stx /3
        lda #4
        sta /3+1
        ldy /2
        cpy #0
        beq @exit
        txa
@loop
        clc
        adc #40
        bcc @skip
        inc /3+1
@skip
        dey
        bne @loop
        sta /3
@exit
        endm

; Copy screen from memory to screen ram location
defm    LIBSCREEN_DISPLAY_SCREEN_AAVV ;screen source, screen destination, width, height
        lda #</1
        sta @screenread+1
        lda #>/1
        sta @screenread+2
        
        lda #</2
        sta @screenwrite+1
        lda #>/2
        sta @screenwrite+2

        ldx #/4
        ldy #0
@screenread
        lda $1010
@screenwrite
        sta $1010,y
        inc @screenread+1
        bne @skip
        inc @screenread+2
@skip
        iny
        cpy #/3
        bne @screenread
        ldy #0
        lda @screenwrite+1
        clc
        adc #40
        bcc @here
        inc @screenwrite+2
@here
        sta @screenwrite+1
        dex
        bne @screenread
        endm

; Set 1000 consecutive bytes to a character code
defm    LIBSCREEN_SET1000_AV ;Start Address, Character Code
        lda #/2
        ldx #250
@loop   dex
        sta /1,x
        sta /1+250,x
        sta /1+500,x
        sta /1+750,x
        bne @loop
        endm

; Set screen border and background colour
defm    LIBSCREEN_SETCOLOURS_VV ;Border, Background0
        lda #/1
        sta BDCOL
        lda #/2
        sta BGCOL0
        endm

; Set VIC video modes
defm    LIBSCREEN_SETVIC_AVV ;VICRegister, Clear, Set
        lda /1
        and #/2
        ora #/3
        sta /1
        endm

; Wait for raster line
defm    LIBSCREEN_WAIT_V ;Line number
@loop   lda #/1
        cmp RASTER
        bne @loop
        endm


;-------------------------------------------------------------------------------
; LIBMATHS LIBRARIES
;-------------------------------------------------------------------------------

; 16-bit addition between address and value
defm    LIBMATHS_ADD_16BIT_AVVA ;Source, Low Byte, High Byte, Target
        clc
        lda /1
        adc #/2
        sta /4
        lda /1 + 1
        adc #/3
        sta /4 + 1
        endm

; 16-bit subtraction between an address and a value
defm    LIBMATHS_SUBTRACT_16BIT_AVVA ;Source 1, Low byte, high byte, Target
        sec
        lda /1
        sbc #/2
        sta /4
        lda /1 + 1
        sbc #/3
        sta /4 + 1
        endm

; 24-bit binary coded decimal addition
defm    LIBMATHS_BCD_ADD_24BIT_AAA ;source 1, source 2, destination
        sed
        clc
        lda /1+2
        adc /2+2
        sta /3+2
        lda /1+1
        adc /2+1
        sta /3+1
        lda /1
        adc /2
        sta /3
        cld
        endm

;-------------------------------------------------------------------------------
; LIBINPUT LIBRARIES
;-------------------------------------------------------------------------------

; Get input for joystick in port 2
defm    LIBINPUT_GETJOY_V ; JoystickDirection
        lda CIAPRA
        and #/1
        endm ; test with bne on return


;-------------------------------------------------------------------------------