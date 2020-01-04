;-------------------------------------------------------------------------------
; gameScreen Variables
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; gameScreen Subroutines
;-------------------------------------------------------------------------------

; >>> gsSavePlayArea <<<
; Copy the current screen to the buffer to save state during pause
gsSavePlayArea
        LIBSCREEN_SET_POINTER_VVA 12, 0, scnPtr
        ldx #0
        stx currentRow
@loop
        lda (scnPtr),y
        sta SCN_BUFFER,x
        iny
        inx
        cpy #10
        bne @loop
        inc currentRow
        lda currentRow
        cmp #20
        beq @done
        LIBMATHS_ADD_16BIT_AVVA scnPtr, 40, 0, scnPtr
        ldy #0
        jmp @loop
@done
        rts


; >>> gsPrintLine <<<
; Print a line of a single character to the game screen
gsPrintLine
        lda drawCharacter
        ldy #0
@loop
        sta (scnPtr),y
        iny
        cpy #10
        bne @loop
        LIBMATHS_SUBTRACT_16BIT_AVVA scnPtr, 40, 0, scnPtr
        rts


; >>> gsPrintLevel <<<
; Display the current level on the screen
gsPrintLevel
        LIBSCREEN_SET_POINTER_VVA 26, 8, scnPtr
        LIBSCREEN_PRINT_BCD_1DIGIT_AA gameLevel+1, scnPtr
        LIBSCREEN_PRINT_BCD_2DIGIT_AAV gameLevel, scnPtr, 1
        rts


; >>> gsPrintLines <<<
; Display the current lines total on the screen
gsPrintLines
        LIBSCREEN_SET_POINTER_VVA 26, 12, scnPtr
        LIBSCREEN_PRINT_BCD_1DIGIT_AA linesTotal+1, scnPtr
        LIBSCREEN_PRINT_BCD_2DIGIT_AAV linesTotal, scnPtr, 1
        rts

; >>> gsPrintScore <<<
; Display score on the screen
gsPrintScore
        LIBSCREEN_SET_POINTER_VVA 24, 4, scnPtr
        LIBSCREEN_PRINT_BCD_2DIGIT_AAV score, scnPtr, 0
        LIBSCREEN_PRINT_BCD_2DIGIT_AAV score+1, scnPtr, 2
        LIBSCREEN_PRINT_BCD_2DIGIT_AAV score+2, scnPtr, 4
        rts