;-------------------------------------------------------------------------------
; gfPlay Variables
;-------------------------------------------------------------------------------

gfPlayInit              byte 00
delayCounter            byte 10
rndseed                 byte 00, 00
rndtemp                 byte 00

;-------------------------------------------------------------------------------
; gfPlay Subroutines
;-------------------------------------------------------------------------------
; >>> gfPlay_UpdatePlayMode <<<
; Updates the current game
gfPlay_Update
        lda gfPlayInit
        bne @skip_init
        jsr gfPlay_Initialise
@skip_init
        jsr gsPrintLevel
        jsr gsPrintLines
        jsr gsPrintScore

        lda soundDelayCounter
        beq @skip_sounddelay
        dec soundDelayCounter
@skip_sounddelay
        jsr UpdateRandom
        lda linesMade
        beq nolinesmade
        jsr glProcessLinesMade
        rts
nolinesmade
        jsr giGetInput
        lda inputResult
        cmp #KEY_PAUSE
        bne @skip_pause
        lda #GAMEFLOW_PAUSED
        sta gameStatus
        rts
@skip_pause
        jsr gbMoveBlock
        jsr gbDropBlock
        cmp #2
        bne gfexit
        lda #SND_DROP_BLOCK
        jsr gSnd_PlaySound
        jsr glCheckLines
        lda linesMade
        bne gfexit

        jsr gbNewBlock
        beq gfexit
        lda #GAMEFLOW_GAMEOVER
        sta gameStatus
gfexit
        rts

gfPlay_Initialise
        LIBSCREEN_SET1000_AV SCREENRAM, space
        LIBSCREEN_DISPLAY_SCREEN_AAVV SCN_MAIN, $040A, 21, 21

        lda #SND_TETRIS
        jsr gSnd_PlaySound

        lda #1
        sta gfPlayInit
        sta blockEraseFlag

        lda #0
        sta linesTotal
        sta linesTotal+1
        sta gfPausedInit
        sta score
        sta score+1
        sta score+2
        sta soundDelayCounter
        
        lda #DEFAULT_DROP_DELAY
        ldx currentLevel
        stx gameLevel
@loop
        beq @done
        sec
        sbc #DROP_DELAY_CHANGE
        dex
        jmp @loop
@done
        sta fallDelay
        sta fallDelayTimer


        jsr GetRandom
        jsr UpdateRandom

        lda #0
        jsr gbSelectBlock
        lda #15
        sta blockXPos
        lda #1
        sta blockYPos
        LIBSCREEN_SET_POINTER_AAA blockXPos, blockYPos, scnPtr
        jsr gbPrintBlock

        rts

GetRandom
        lda rndseed
        and #7
        cmp #7
        bne @skip
        jsr UpdateRandom
        jmp GetRandom
@skip
        rts

UpdateRandom
        lda rndseed
        and #2
        sta rndtemp
        lda rndseed+1
        and #2
        eor rndtemp
        clc
        beq @skip
        sec
@skip
        ror rndseed
        ror rndseed+1
        rts