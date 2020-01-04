;-------------------------------------------------------------------------------
; gfGameOver Variables
;-------------------------------------------------------------------------------

gameOverJumpTableLo             byte <GameOverInitialise
                                byte <GameOverFillWell
                                byte <GameOverClearWell
                                byte <GameOverDisplayText
                                byte <GameOverWaitUser

gameOverJumpTableHi             byte >GameOverInitialise
                                byte >GameOverFillWell
                                byte >GameOverClearWell
                                byte >GameOverDisplayText
                                byte >GameOverWaitUser

gameOverStatus                  byte 00
drawCharacter                   byte 00
linesLeft                       byte 00

GAMEOVER_INIT                   = 0
GAMEOVER_FILLWELL               = 1
GAMEOVER_CLEARWELL              = 2
GAMEOVER_DISPLAYTEXT            = 3
GAMEOVER_WAITUSER               = 4

;-------------------------------------------------------------------------------
; gfGameOver Subroutines
;-------------------------------------------------------------------------------

; >>> gfGameOver_Update <<<
; Update the current game over status
gfGameOver_Update
        ldx gameOverStatus
        lda gameOverJumpTableLo,x
        sta zpLow
        lda gameOverJumpTableHi,x
        sta zpHigh
        jmp (zpLow)

GameOverInitialise
        lda #88
        sta drawCharacter
        lda #20
        sta linesLeft
        LIBSCREEN_SET_POINTER_VVA 12, 19, scnPtr
        lda #GAMEOVER_FILLWELL
        sta gameOverStatus
        rts

GameOverFillWell
        jsr gsPrintLine
        dec linesLeft
        beq @skip
        rts
@skip
        lda #$20
        sta drawCharacter
        lda #20
        sta linesLeft
        LIBSCREEN_SET_POINTER_VVA 12, 19, scnPtr
        lda #GAMEOVER_CLEARWELL
        sta gameOverStatus
        rts

GameOverClearWell
        jsr gsPrintLine
        dec linesLeft
        beq @skip
        rts
@skip
        lda #GAMEOVER_DISPLAYTEXT
        sta gameOverStatus
        rts

GameOverDisplayText
        LIBSCREEN_DISPLAY_SCREEN_AAVV SCN_GAMEOVER, $040C, 10, 20
        lda #GAMEOVER_WAITUSER
        sta gameOverStatus
        rts

GameOverWaitUser
        jsr giGetInput
        lda inputResult
        cmp #KEY_DOWN
        beq @startgame
        cmp #KEY_TURN_CLOCK
        beq @startgame
        rts
@startgame
        lda #GAMEOVER_INIT
        sta gameOverStatus
        lda #false
        sta gfPlayInit
        lda #GAMEFLOW_ATTRACT
        sta gameStatus
        rts
