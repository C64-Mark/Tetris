;-------------------------------------------------------------------------------
; gameScore Variables
;-------------------------------------------------------------------------------

score           byte 00, 00, 00
addition        byte 00, 00, 00

lineScore1      byte $00, $00, $00, $00
linescore2      byte $00, $01, $03, $12
lineScore3      byte $40, $00, $00, $00

;-------------------------------------------------------------------------------
; gameScore Subroutines
;-------------------------------------------------------------------------------


; >>> gscAddLineScore <<<
; Calculate score for number of lines cleared
gscAddLineScore
        ldy linesMade
        dey
        lda lineScore1,y
        sta addition
        lda lineScore2,y
        sta addition+1
        lda lineScore3,y
        sta addition+2

        ldx currentLevel
@loop
        LIBMATHS_BCD_ADD_24BIT_AAA score, addition, score
        dex
        bpl @loop
        rts