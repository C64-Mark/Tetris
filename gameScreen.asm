;-------------------------------------------------------------------------------
; gameScreen Variables
;-------------------------------------------------------------------------------

pauseYPos               byte 00
playAreaErase           byte 00

;-------------------------------------------------------------------------------
; gameScreen Subroutines
;-------------------------------------------------------------------------------

; >>> gsSetScreenPointer <<<
; Sets screen memory position from X and Y registers
gsSetScreenPointer
        stx scnPtr
        lda #4
        sta scnPtrHi
        cpy #0
        beq @exit
        txa
@loop
        clc
        adc #40
        bcc @skip
        inc scnPtrHi
@skip
        dey
        bne @loop
        sta scnPtr
@exit
        rts
        

; >>> gsSavePlayArea <<<
; Copy the current screen to the buffer to save state during pause
gsSavePlayArea
        LIBSCREEN_SET_POINTER_VV 12, 0

        ldx #0
        stx currentRow

@loop
        lda (scnPtr),y
        sta SCN_BUFFER,x
        lda playAreaErase
        beq @skip
        lda #SPACE
        sta (scnPtr),y
@skip
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


gsClearLine
        lda drawCharacter
        ldy #0
@loop
        sta (scnPtr),y
        iny
        cpy #10
        bne @loop
        LIBMATHS_SUBTRACT_16BIT_AVVA scnPtr, 40, 0, scnPtr
        rts


; >>> glvPrintLevel <<<
; Display the current level on the screen
gsPrintLevel

        LIBSCREEN_SET_POINTER_VV 26, 8
        ldy #0
        lda gameLevel+1
        and #15
        clc
        adc #$30
        sta (scnPtr),y
        iny

        lda gameLevel
        pha
        lsr
        lsr
        lsr
        lsr
        clc
        adc #$30
        sta (scnPtr),y
        iny
        pla
        and #15
        clc
        adc #$30
        sta (scnPtr),y
        rts


; >>> gsPrintLines <<<
; Display the current lines total on the screen
gsPrintLines

        LIBSCREEN_SET_POINTER_VV 26, 12
        ldy #0
        lda linesTotal+1
        and #15
        clc
        adc #$30
        sta (scnPtr),y
        iny

        lda linesTotal
        pha
        lsr
        lsr
        lsr
        lsr
        clc
        adc #$30
        sta (scnPtr),y
        iny
        pla
        and #15
        clc
        adc #$30
        sta (scnPtr),y
        rts

; >>> gsPrintScore <<<
; Display score on the screen
gsPrintScore

        LIBSCREEN_SET_POINTER_VV 24, 4

        ldx #0
        ldy #0
@loop
        lda score,x
        pha
        lsr
        lsr
        lsr
        lsr
        clc
        adc #$30
        sta (scnPtr),y
        iny
        pla
        and #15
        clc
        adc #$30
        sta (scnPtr),y
        iny
        inx
        cpx #3
        bne @loop
        rts