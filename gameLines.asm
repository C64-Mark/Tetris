;-------------------------------------------------------------------------------
; gameLines Variables
;-------------------------------------------------------------------------------

linesMade               byte 00
linesTotal              byte 00, 00
currentRow              byte 00
lineRowNumbers          byte 00, 00, 00, 00, 00
madeLinesData           byte 00, 00, 00, 00, 00, 00, 00, 00, 00, 00
                        byte 00, 00, 00, 00, 00, 00, 00, 00, 00, 00
                        byte 00, 00, 00, 00, 00, 00, 00, 00, 00, 00
                        byte 00, 00, 00, 00, 00, 00, 00, 00, 00, 00

currentFlashDelay       byte FLASH_DELAY
lineFlashFlag           byte 00
totalFlashDelay         byte 00
currentLineIndex        byte 00

gameLevel               byte 00, 00
levelLinesCounter       byte 00

;-------------------------------------------------------------------------------
; gameLines Subroutines
;-------------------------------------------------------------------------------

; >>> glCheckLines <<<
; Check for a complete line
glCheckLines
        lda #0
        sta linesMade
        sta currentRow

        ldx #12
        ldy #0
        jsr gsSetScreenPointer

        ldx #0
readStart
        ldy #0
@loop
        lda (scnPtr),y
        cmp #SPACE
        beq nextRow
        iny
        cpy #10
        bne @loop

        ldy linesMade
        lda currentRow
        sta lineRowNumbers,y

        ldy #0
@loop2
        lda (scnPtr),y
        sta madeLinesData,x
        inx
        iny
        cpy #10
        bne @loop2

        inc linesMade
        lda linesMade
        cmp #4
        beq readDone
nextRow
        inc currentRow
        lda currentRow
        cmp #20
        beq readDone
        LIBMATHS_ADD_16BIT_AVVA scnPtr, 40, 0, scnPtr
        jmp readStart
readDone
        lda linesMade
        beq @skip

        lda #FLASH_TIME
        sta totalFlashDelay
@skip
        rts


; >>> glFlashLines <<<
; FLash completed lines
glFlashLines
        dec totalFlashDelay
        dec currentFlashDelay
        beq @skip
        rts
@skip
        lda #FLASH_DELAY
        sta currentFlashDelay
        lda #0
        sta currentLineIndex
        lda lineFlashFlag
        eor #1
        sta lineFlashFlag

        ldx #0
updateLine
        txa
        pha

        ldy currentLineIndex
        lda lineRowNumbers,y
        tay
        ldx #12
        jsr gsSetScreenPointer
        
        pla
        tax

        ldy #0
        lda lineFlashFlag
        bne hide
; this show/hide bit can probably be combined
show
        lda madeLinesData,x
        sta (scnPtr),y
        inx
        iny
        cpy #10
        bne show
        jmp gotoNextLine
hide
        lda #SPACE
        sta (scnPtr),y
        iny
        cpy #10
        bne hide

gotoNextLine
        inc currentLineIndex
        lda currentLineIndex
        cmp linesMade
        beq exitFlashLines
        jmp updateLine
exitFlashLines
        rts


; >>> glRemoveLines <<<
; Delete completed lines
glRemoveLines
        lda #0
        sta currentLineIndex

setPointers
        ldx currentLineIndex
        lda lineRowNumbers,x
        tay
        jsr glSetLinePointers
        jsr glMoveLineData

        inc currentLineIndex
        lda currentLineIndex
        cmp linesMade
        bne setPointers
        rts


; >>> glSetLinePointers <<<
; Get pointers to lines to remove
glSetLinePointers
        ldx #12
        dey
        jsr gsSetScreenPointer
        lda scnPtr
        sta scnPtr2
        lda scnPtrHi
        sta scnPtr2Hi
        LIBMATHS_ADD_16BIT_AVVA scnPtr, 40, 0, scnPtr
        rts


; >>> glMoveLineData <<<
; Move lines down into space deleted
glMoveLineData
        ldy currentLineIndex
        lda lineRowNumbers,y
        tax

@startloop
        ldy #0
@loop
        lda (scnPtr2),y
        sta (scnPtr),y
        iny
        cpy #10
        bne @loop

        dex
        beq @skip
        txa
        tay

        pha

        jsr glSetLinePointers

        pla
        tax

        jmp @startloop
@skip
        ldx #12
        ldy #0
        jsr gsSetScreenPointer
        
        ldy #0
        lda #SPACE
@loop2
        sta (scnPtr),y
        iny
        cpy #10
        bne @loop2
@exit
        rts


; >>> glAddLinesTotal <<<
; Increment the on-screen line counter
glAddLinesTotal
        sed
        clc
        lda linesTotal
        adc linesMade
        sta linesTotal
        lda linesTotal+1
        adc #0
        sta linesTotal+1
        cld
        rts


glProcessLinesMade
        jsr glFlashLines
        lda totalFlashDelay
        beq @continue
        rts
@continue
        jsr gscAddLineScore
        jsr glRemoveLines

        lda levelLinesCounter
        clc
        adc linesMade
        sta levelLinesCounter
        jsr glAddLinesTotal

        lda #0
        sta linesMade

        lda levelLinesCounter
        cmp #LINES_PER_LEVEL
        bcc nolevelinc
        jsr glIncreaseLevel
nolevelinc
        jsr gbNewBlock
        rts


glIncreaseLevel
        inc currentLevel
        
        sed
        clc
        lda gameLevel
        adc #1
        sta gameLevel
        lda gameLevel+1
        adc #0
        sta gameLevel+1
        cld

        lda #0
        sta levelLinesCounter

        lda fallDelay
        sec
        sbc #DROP_DELAY_CHANGE
        cmp #DROP_DELAY_CHANGE
        bpl @skip
        lda #DROP_DELAY_CHANGE
@skip
        sta fallDelay
        sta fallDelayTimer
        rts