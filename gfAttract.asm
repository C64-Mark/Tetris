;-------------------------------------------------------------------------------
; gfAttract Variables
;-------------------------------------------------------------------------------

gameAttractScreenLo             byte <gfAttract_Initialise
                                byte <gfAttract_Title
                                byte <gfAttract_Credits
                                byte <gfAttract_Keys

gameAttractScreenHi             byte >gfAttract_Initialise
                                byte >gfAttract_Title
                                byte >gfAttract_Credits
                                byte >gfAttract_Keys

gameAttractStatus               byte 00
gameAttractDelay                byte 00

ATTRACT_DELAY                   = 255
ATTRACT_INIT                    = 0
ATTRACT_TITLE                   = 1
ATTRACT_CREDITS                 = 2
ATTRACT_KEYS                    = 3

;-------------------------------------------------------------------------------
; gfAttract Subroutines
;-------------------------------------------------------------------------------

gfAttract_Update
        lda gameAttractDelay
        beq @changescreen
        dec gameAttractDelay
        jsr gfAttract_CheckInput
        rts
@changescreen
        ldx gameAttractStatus
        lda gameAttractScreenLo,x
        sta zpLow
        lda gameAttractScreenHi,x
        sta zpHigh
        jmp (zpLow)

gfAttract_Initialise
        LIBSCREEN_SET1000_AV SCREENRAM, space
        lda #ATTRACT_TITLE
        sta gameAttractStatus
        rts

gfAttract_Title
        LIBSCREEN_DISPLAY_SCREEN_AAVV SCN_TITLE, $040A, 21, 20
        lda #ATTRACT_DELAY
        sta gameAttractDelay
        lda #ATTRACT_CREDITS
        sta gameAttractStatus
        rts

gfAttract_Credits
        LIBSCREEN_DISPLAY_SCREEN_AAVV SCN_CREDITS, $040A, 21, 20
        lda #ATTRACT_DELAY
        sta gameAttractDelay
        lda #ATTRACT_KEYS
        sta gameAttractStatus
        rts

gfAttract_Keys
        LIBSCREEN_DISPLAY_SCREEN_AAVV SCN_KEYS, $040A, 21, 20
        lda #ATTRACT_DELAY
        sta gameAttractDelay
        lda #ATTRACT_TITLE
        sta gameAttractStatus
        rts

gfAttract_CheckInput
        jsr giGetInput
        lda inputResult
        cmp #KEY_DOWN
        beq @levelselect
        cmp #KEY_TURN_CLOCK
        beq @levelselect
        rts
@levelselect
        lda #ATTRACT_INIT
        sta gameAttractStatus
        lda #0
        sta gameAttractDelay
        lda #GAMEFLOW_LEVELSELECT
        sta gameStatus
        rts
