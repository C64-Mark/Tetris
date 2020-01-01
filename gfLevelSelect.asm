;-------------------------------------------------------------------------------
; gfLevelSelect Variables
;-------------------------------------------------------------------------------

currentLevel            byte 00
previousLevel           byte 00
levelDisplayFlag        byte 00
levelFlashDelay         byte 00
gfLevelSelectInit       byte 00

gfLevelSelect_XPos      byte 16, 18, 20, 22, 24, 16, 18, 20, 22, 24
gfLevelSelect_YPos      byte 07, 07, 07, 07, 07, 09, 09, 09, 09, 09

;-------------------------------------------------------------------------------
; gfLevelSelect Subroutines
;-------------------------------------------------------------------------------

gfLevelSelect_Update
        lda gfLevelSelectInit
        bne @skip_init
        jsr gfLevelSelect_Initialise
@skip_init
        jsr gfLevelSelect_CheckInput
        dec levelFlashDelay
        bne @done
        lda #FLASH_DELAY
        sta levelFlashDelay

        ldx currentLevel
        lda gfLevelSelect_YPos,x
        pha
        lda gfLevelSelect_XPos,x
        tay
        pla
        tax
        clc
        jsr krnPLOT

        lda levelDisplayFlag
        eor #1
        sta levelDisplayFlag        
        beq @clear
        lda currentLevel
        adc #$30
        jmp @skip
@clear
        lda #SPACE
@skip
        jsr krnCHROUT
@done
        rts

gfLevelSelect_Initialise
        LIBSCREEN_DISPLAY_SCREEN_AAVV SCN_LEVEL, $040A, 21, 20
        inc gfLevelSelectInit
        lda #0
        sta currentLevel
        sta previousLevel
        sta levelDisplayFlag
        lda #FLASH_DELAY
        sta levelFlashDelay
        rts

gfLevelSelect_CheckInput
        jsr giGetInput
        lda inputResult
        cmp #KEY_DOWN
        beq @startgame
        cmp #KEY_TURN_CLOCK
        beq @startgame
        cmp #KEY_LEFT
        bne @checkright
        lda currentLevel
        beq @exit
        sta previousLevel
        dec currentLevel
        jmp @showpreviouslevel
@checkright
        cmp #KEY_RIGHT
        bne @exit
        lda currentLevel
        cmp #9
        beq @exit
        sta previousLevel
        inc currentLevel
@showpreviouslevel
        ldx previousLevel
        lda gfLevelSelect_YPos,x
        pha
        lda gfLevelSelect_XPos,x
        tay
        pla
        tax
        clc
        jsr krnPLOT
        lda previousLevel
        adc #$30
        jsr krnCHROUT
@exit
        rts
@startgame
        lda #0
        sta gfLevelSelectInit
        lda #GAMEFLOW_PLAY
        sta gameStatus
        rts
        



