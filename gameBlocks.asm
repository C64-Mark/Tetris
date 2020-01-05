;-------------------------------------------------------------------------------
; gameBlocks Variables
;-------------------------------------------------------------------------------

blockXPos               byte 00
blockYPos               byte 00
currentBlockID          byte 00
currentFrame            byte 00
firstFrame              byte 00
lastFrame               byte 00
fallDelay               byte 00
fallDelayTimer          byte 00
nextBlockID             byte 00
blockEraseFlag          byte 00

blockFrameStart         byte 0, 4, 8, 12, 14, 16, 18
blockFrameEnd           byte 3, 7, 11, 13, 15, 17, 18

frameArrayLo            byte <frame00, <frame01, <frame02, <frame03     ; block 0
                        byte <frame04, <frame05, <frame06, <frame07     ; block 1
                        byte <frame08, <frame09, <frame10, <frame11     ; block 2
                        byte <frame12, <frame13                         ; block 3
                        byte <frame14, <frame15                         ; block 4
                        byte <frame16, <frame17                         ; block 5
                        byte <frame18                                   ; block 6

frameArrayHi            byte >frame00, >frame01, >frame02, >frame03     ; block 0
                        byte >frame04, >frame05, >frame06, >frame07     ; block 1
                        byte >frame08, >frame09, >frame10, >frame11     ; block 2
                        byte >frame12, >frame13                         ; block 3
                        byte >frame14, >frame15                         ; block 4
                        byte >frame16, >frame17                         ; block 5
                        byte >frame18                                   ; block 6

; Block 0 (4 frames)
frame00                 text " hh "
                        text "  h "
                        text "  h "
                        text "    "

frame01                 text "   h"
                        text " hhh"
                        text "    "
                        text "    "

frame02                 text "  h "
                        text "  h "
                        text "  hh"
                        text "    "

frame03                 text "    "
                        text " hhh"
                        text " h  "
                        text "    "

; Block 1 (4 frames)
frame04                 text "  g "
                        text " gg "
                        text "  g "
                        text "    "

frame05                 text "  g "
                        text " ggg"
                        text "    "
                        text "    "

frame06                 text "  g "
                        text "  gg"
                        text "  g "
                        text "    "

frame07                 text "    "
                        text " ggg"
                        text "  g "
                        text "    "

; Block 2 (4 frames)
frame08                 text " hh "
                        text " h  "
                        text " h  "
                        text "    "

frame09                 text "    "
                        text "hhh "
                        text "  h "
                        text "    "

frame10                 text " h  "
                        text " h  "
                        text "hh  "
                        text "    "

frame11                 text "h   "
                        text "hhh "
                        text "    "
                        text "    "

; Block 3 (2 frames)
frame12                 text " x  "
                        text " xx "
                        text "  x "
                        text "    "

frame13                 text " xx "
                        text "xx  "
                        text "    "
                        text "    "

; Block 4 (2 frames)
frame14                 text "  h "
                        text " hh "
                        text " h  "
                        text "    "

frame15                 text "hh  "
                        text " hh "
                        text "    "
                        text "    "

; Block 5 (2 frames)   ; was K
frame16                 byte 32, 92, 32, 32
                        byte 32, 93, 32, 32
                        byte 32, 93, 32, 32
                        byte 32, 94, 32, 32

frame17                 text "    "
                        byte 89, 90, 90, 91
                        text "    "
                        text "    "

; Block 6 (1 frame)
frame18                 text "    "
                        text " jj "
                        text " jj "
                        text "    "


;-------------------------------------------------------------------------------
; gameBlocks Subroutines
;-------------------------------------------------------------------------------

; >>> gbPrintBlock <<<
; Prints the current block to the screen
gbPrintBlock
        lda blockEraseFlag
        eor #1
        sta blockEraseFlag
        LIBSCREEN_SET_POINTER_AAA blockXPos, blockYPos, scnPtr

        ldx currentFrame
        lda frameArrayLo,x
        sta @printloop+1
        lda frameArrayHi,x
        sta @printloop+2

        ldx #0
        ldy #0
@printloop
        lda $1010,x
        cmp #SPACE
        beq @skip
        pha
        lda blockEraseFlag
        bne @erase
        pla
        jmp @print
@erase
        pla
        lda #SPACE
@print
        sta (scnPtr),y
@skip
        inx
        cpx #16
        bne @skip2
        rts
@skip2
        iny
        cpy #4
        bne @printloop
        LIBMATHS_ADD_16BIT_AVVA scnPtr, 40, 0, scnPtr
        ldy #0
        jmp @printloop


; >>> gbSelectBlock <<<
; Selects the current block
gbSelectBlock
        sta currentBlockID
        tax
        lda blockFrameStart,x
        sta currentFrame
        sta firstFrame
        lda blockFrameEnd,x
        sta lastFrame
        rts


; >>> gbAnimateBlock <<<
; Move block either clockwise (A -> #0) or counter-clockwise (A -> #1)
gbAnimateBlock
        cmp #1
        beq doBackward
doForward
        lda currentFrame
        cmp lastFrame
        beq @skip
        inc currentFrame
        rts
@skip
        lda firstFrame
        sta currentFrame
        rts
doBackward
        lda currentFrame
        cmp firstFrame
        beq @skip2
        dec currentFrame
        rts
@skip2
        lda lastFrame
        sta currentFrame
        rts


; >>> gbCheckBlockSpace <<<
; Ensure there is sufficient space to place the block
gbCheckBlockSpace
        LIBSCREEN_SET_POINTER_AAA blockXPos, blockYPos, scnPtr

        ldx currentFrame
        lda frameArrayLo,x
        sta spaceLoop+1
        lda frameArrayHi,x
        sta spaceLoop+2

        ldx #0
        ldy #0
spaceLoop
        lda $1010,x
        cmp #SPACE
        beq @skip

        lda (scnPtr),y
        cmp #SPACE
        beq @skip
        
        lda #1
        rts
@skip
        inx
        cpx #16
        bne @skip2
        lda #0
        rts
@skip2
        iny
        cpy #4
        bne spaceLoop
        LIBMATHS_ADD_16BIT_AVVA scnPtr, 40, 0, scnPtr
        ldy #0
        jmp spaceLoop


; >>> gbDropBlock <<<
; Move the block down the screen
gbDropBlock
        dec fallDelayTimer
        beq @skip
        lda #0
        rts
@skip
        lda fallDelay
        sta fallDelayTimer
        jsr gbPrintBlock
        inc blockYPos
        jsr gbCheckBlockSpace
        bne @skip2
        jsr gbPrintBlock
        lda #1
        rts
@skip2
        dec blockYPos
        jsr gbPrintBlock
        lda #2
        rts


; >>> gbNewBlock <<<
; Add a new block to the screen
gbNewBlock
        lda fallDelay
        sta fallDelayTimer

        ldx #25                                
        ldy #15
        stx blockXPos            
        sty blockYPos
        
        lda nextBlockID
        pha
        jsr gbSelectBlock                 
        jsr gbPrintBlock
        jsr GetRandom
        sta nextBlockID  
        jsr gbSelectBlock
        jsr gbPrintBlock   

        ldx #15                      
        ldy #00
        stx blockXPos
        sty blockYPos

        lda #TRUE
        sta blockEraseFlag
        pla                                 
        sta currentBlockID
        jsr gbSelectBlock          
        jsr gbCheckBlockSpace  
        bne @skip
        jsr gbPrintBlock  
        lda #0
        rts
@skip
        jsr gbPrintBlock 
        lda #1   
        rts


; >>> gbMoveBlock <<<
; Reposition block based on user input
gbMoveBlock
        lda inputResult
        cmp #NOINPUT
        bne eraseBlock
        rts
eraseBlock
        pha
        jsr gbPrintBlock
        pla
moveBlockLeft
        cmp #KEY_LEFT
        bne moveBlockRight
        dec blockXPos
        jsr gbCheckBlockSpace
        beq @leftok
        inc blockXPos
@leftok
        lda #SND_MOVE_BLOCK
        jsr gSnd_PlaySound
        jsr gbPrintBlock
        rts
moveBlockRight
        cmp #KEY_RIGHT
        bne moveBlockDown
        inc blockXPos
        jsr gbCheckBlockSpace
        beq @rightok
        dec blockXPos
@rightok
        lda #SND_MOVE_BLOCK
        jsr gSnd_PlaySound
        jsr gbPrintBlock
moveBlockDown
        cmp #KEY_DOWN
        bne moveBlockCW
        inc blockYPos
        jsr gbCheckBlockSpace
        beq @downok
        dec blockYPos
        jsr gbPrintBlock
        lda #1 
        sta fallDelayTimer
        rts
@downok
        lda #SND_MOVE_BLOCK
        jsr gSnd_PlaySound
        jsr gbPrintBlock
        lda #1
        sta addition+2
        lda #0
        sta addition+1
        sta addition
        LIBMATHS_BCD_ADD_24BIT_AAA score, addition, score
        rts
moveBlockCW
        cmp #KEY_TURN_CLOCK
        bne moveBlockCCW
        lda #0
        jsr gbAnimateBlock
        jsr gbCheckBlockSpace
        beq @cwok
        lda #1
        jsr gbAnimateBlock
@cwok
        lda #SND_ROTATE_BLOCK
        jsr gSnd_PlaySound
        jsr gbPrintBlock
        rts
moveBlockCCW
        cmp #KEY_TURN_COUNTER
        bne @exit
        lda #1
        jsr gbAnimateBlock
        jsr gbCheckBlockSpace
        beq @ccwok
        lda #0
        jsr gbAnimateBlock
@ccwok
        lda #SND_ROTATE_BLOCK
        jsr gSnd_PlaySound
        jsr gbPrintBlock
@exit
        rts

