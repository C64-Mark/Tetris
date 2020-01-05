*=$0801

        byte    $0E, $08, $0A, $00, $9E, $20, $28, $34
        byte    $39, $31, $35, $32, $29, $00, $00, $00

*=$C000

Initialise
        jsr InitialiseGame
        lda #SND_MUSIC_TITLE
        jsr SID_INIT
        jsr InitialiseInterrupt

GameLoop
        LIBSCREEN_WAIT_V 255
        jsr gfUpdate
        jmp GameLoop


InitialiseGame
        LIBSCREEN_SETCOLOURS_VV GRAY1, GRAY1
        LIBSCREEN_SET1000_AV COLOURRAM, LIGHTGREEN
        LIBSCREEN_SETVIC_AVV VMCR, 240, CHARRAM
        lda #153
        jsr krnCHROUT
        lda #$89
        stx rndseed
        dex
        stx rndseed+1
        lda #0
        sta gameStatus
        rts

InitialiseInterrupt
        sei
        lda #$7F
        sta CIAICR1
        and VCR1
        sta VCR1
        lda #$80
        sta RASTER
        lda #<InterruptMusic
        sta HW_IRQ_REG
        lda #>InterruptMusic
        sta HW_IRQ_REG+1
        lda #1
        sta IRQMR
        cli
        rts

InterruptMusic
        jsr SID_PLAY
        asl VICINT
        jmp krnIRQ

