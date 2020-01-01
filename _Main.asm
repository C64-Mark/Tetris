*=$0801

        byte    $0E, $08, $0A, $00, $9E, $20, $28  
        byte    $32, $30, $36, $34, $29, $00, $00, $00

Initialise
        jsr InitialiseGame
        
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
