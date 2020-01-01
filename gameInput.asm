;-------------------------------------------------------------------------------
; gameInput Variables
;-------------------------------------------------------------------------------

inputResult             byte 00
previousKey             byte 00
previousJoy             byte 00
keyDelayCounter         byte 07
joyDelayCounter         byte 07

;-------------------------------------------------------------------------------
; gameInput Subroutines
;-------------------------------------------------------------------------------

; >>> giGetInput <<<
; Test keyboard first and if no result test joystick
giGetInput
        jsr giGetKeyInput
        lda inputResult
        cmp #NOINPUT
        bne @exit
        jsr giGetJoyInput
@exit
        rts

; >>> giGetKeyInput <<<
; Read keyboard input
giGetKeyInput
        lda KEY_PRESSED
        cmp previousKey
        bne diffKey
doDelay
        dec keyDelayCounter
        beq diffKey
        lda #NOINPUT
        sta inputResult
        rts
diffKey
        ldx #INPUT_DELAY        
        stx keyDelayCounter
        sta previousKey
        cmp #NOKEY
        bne keyDown
        lda #NOINPUT
        sta inputResult
        rts
keyDown
        cmp #KEY_DOWN
        bne inputexit
        ldx #4
        stx keyDelayCounter
inputexit
        sta inputResult
        rts


; >>> giGetJoyInput <<<
; Read joystick input
giGetJoyInput
        lda CIAPRA
        cmp previousJoy
        bne @skip

        dec joyDelayCounter
        beq @skip
        lda #NOINPUT
        sta inputResult
        rts
@skip
        ldx #INPUT_DELAY
        stx joyDelayCounter
        sta previousJoy
joyUp
        LIBJOY_GETJOY_V JOY_UP
        bne joyDown
        lda #KEY_TURN_COUNTER
        sta inputResult
        rts
joyDown
        LIBJOY_GETJOY_V JOY_DOWN
        bne joyLeft
        lda #KEY_DOWN
        sta inputResult
        ldx #4
        stx joyDelayCounter
        rts
joyLeft
        LIBJOY_GETJOY_V JOY_LEFT
        bne joyRight
        lda #KEY_LEFT
        sta inputResult
        rts
joyRight
        LIBJOY_GETJOY_V JOY_RIGHT
        bne joyFire
        lda #KEY_RIGHT
        sta inputResult
        rts
joyFire
        LIBJOY_GETJOY_V JOY_FIRE
        bne @exit
        lda #KEY_TURN_CLOCK
        sta inputResult
        rts
@exit
        lda #NOINPUT
        sta inputResult
        rts


