;-------------------------------------------------------------------------------
; gameSounds Variables
;-------------------------------------------------------------------------------

soundDelayCounter       byte 00
soundDelay              byte 10, 10, 10, 35, 35, 25, 25, 10, 0, 0
SND_MOVE_BLOCK          = 0
SND_ROTATE_BLOCK        = 1
SND_DROP_BLOCK          = 2
SND_LINE                = 3
SND_TETRIS              = 4
SND_PAUSE_ON            = 5
SND_PAUSE_OFF           = 6
SND_OPTION              = 7
SND_MUSIC_GAMEOVER      = 8
SND_MUSIC_TITLE         = 9

;-------------------------------------------------------------------------------
; gameSounds Subroutines
;-------------------------------------------------------------------------------
; >>> gSnd_PlaySound <<<
; Play the current sound (load accumulator with desired sound constant)
gSnd_PlaySound
        ldx soundDelayCounter
        bne skip_soundplay
        tax
        lda soundDelay,x
        sta soundDelayCounter
        txa
        jsr SID_INIT
        jsr SID_PLAY
skip_soundplay
        rts

