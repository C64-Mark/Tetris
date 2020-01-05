;-------------------------------------------------------------------------------
; gfPaused Variables
;-------------------------------------------------------------------------------

gfPausedInit            byte 00

;-------------------------------------------------------------------------------
; gfPaused Subroutines
;-------------------------------------------------------------------------------

gfPaused_Update
        lda gfPausedInit
        bne skip_pauseinit
        jsr gsSavePlayArea
        LIBSCREEN_DISPLAY_SCREEN_AAVV SCN_PAUSED, $040C, 10, 20
        lda #SND_PAUSE_ON
        jsr gSnd_PlaySound
        inc gfPausedInit
        rts
skip_pauseinit
        jsr giGetInput
        lda inputResult
        cmp #KEY_PAUSE
        bne pauseexit
        lda #SND_PAUSE_OFF
        jsr gSnd_PlaySound
        LIBSCREEN_DISPLAY_SCREEN_AAVV SCN_BUFFER, $040C, 10, 20
        dec gfPausedInit
        lda #GAMEFLOW_PLAY
        sta gameStatus
pauseexit
        rts
