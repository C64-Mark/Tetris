;*******************************************************************************
; GAME MEMORY
;*******************************************************************************

;-------------------------------------------------------------------------------
; Zero Page $0000-$00FF
;-------------------------------------------------------------------------------

; $00-$01       Reserved for IO
; $03-$8F       Reserved for BASIC

scnPtr          = $03 ;FB
scnPtrHi        = $04 ;FC
scnPtr2         = $05 ;FD
scnPtr2Hi       = $06 ;FE

zpLow           = $BB
zpHigh          = $BC
  
KEY_PRESSED     = $CB
              
; $90-$FA       Reserved for Kernal

; FC/FD used by sidplayer

; $FF           Reserved for Kernal

;-------------------------------------------------------------------------------
; Stack $0100-$01FF
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; RAM $0200-$9FFF
;-------------------------------------------------------------------------------

HW_IRQ_REG      = $0314 ;Vector: Hardware IRQ Interrupt (inc $0315)

SCREENRAM       = $0400 ;Default screen ram
SPRPTR0         = $07F8 ;Sprite pointers

SID_INIT        = $1000
SID_PLAY        = $1003
*=$1000
                incbin "sndTetris.sid", $7E

;character set
CHARRAM         = 14
*=$3800
                incbin "charsTetris.cst", 0, 255

;screen data
SCN_TITLE       = $4000 ;to $41B9 (21x21)
*=$4000
                incbin "scnTetrisTitle.bin"

SCN_CREDITS     = $41D0 ;to $4379 (21x21)
*=$41D0
                incbin "scnTetrisCredits.bin"

SCN_KEYS        = $4390 ;to $4539 (21x21)
*=$4390
                incbin "scnTetrisKeys.bin"

SCN_LEVEL       = $4550 ;to $46F9 (21x21)
*=$4550
                incbin "scnTetrisLevel.bin"

SCN_MAIN        = $4710 ;to $48B9 (21x21)
*=$4710
                incbin "scnTetrisMain.bin"

SCN_PAUSED      = $48D0 ;to $4988 (10x20)
*=$48D0
                incbin "scnTetrisPaused.bin"

SCN_GAMEOVER    = $49A0 ;to $4A58 (10x20)
*=$49A0
                incbin "scnTetrisGameOver.bin"

SCN_BUFFER      = $4A70


;-------------------------------------------------------------------------------
; BASIC ROM $A000-$BFFF
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; RAM $C000-$CFFF
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; IO $D000-$DFFF
;-------------------------------------------------------------------------------

;*** VIC ***
SPRX0           = $D000 ;Sprite 0 x-position
SPRY0           = $D001 ;Sprite 0 y-position
SPRX1           = $D002 ;Sprite 1 x-position
SPRY1           = $D003 ;Sprite 1 y-position
SPRX2           = $D004
SPRY2           = $D005
SPRX3           = $D006
SPRY3           = $D007
SPRX4           = $D008
SPRY4           = $D009
SPRX5           = $D00A
SPRY5           = $D00B
SPRXMSB         = $D010 ;Sprite x most significant bit
VCR1            = $D011 ;VIC Control Register 1
RASTER          = $D012 ;Raster
LPX             = $D013 ;Light-pen x-position
LPY             = $D014 ;Light-pen y-position
SPREN           = $D015 ;Sprite display enable
VCR2            = $D016 ;VIC Control Register 2
SPRYEX          = $D017 ;Sprite Y vertical expand
VMCR            = $D018 ;VIC Memory Control Register
VICINT          = $D019 ;VIC Interrupt Flag Register
IRQMR           = $D01A ;IRQ Mask Register
SPRDP           = $D01B ;Sprite/data priority
SPRMCS          = $D01C ;Sprite multi-colour select
SPRXEX          = $D01D ;Sprite X horizontal expand
SPRCSP          = $D01E ;Sprite to sprite collision
SPRCBG          = $D01F ;Sprite to background collision
BDCOL           = $D020 ;Screen border colour
BGCOL0          = $D021 ;Screen background colour 1
BGCOL1          = $D022 ;Screen background colour 2
BGCOL2          = $D023 ;Screen background colour 3
BGCOL3          = $D024 ;Screen background colour 4
SPRMC0          = $D025 ;Sprite multi-colour register 1
SPRMC1          = $D026 ;Sprite multi-colour register 2
SPRCOL0         = $D027 ;Sprite 0 colour

;*** SID ***
FREL1           = $D400 ;V1 frequency low-byte
FREH1           = $D401 ;V1 frequency high-byte
PWL1            = $D402 ;V1 pulse waveform low-byte
PWH1            = $D403 ;V1 pulse waveform high-byte
VCREG1          = $D404 ;V1 control register
ATDCY1          = $D405 ;V1 attack/decay
SUREL1          = $D406 ;V1 sustain/release
FREL2           = $D407 ;V2 frequency low-byte
FREH2           = $D408 ;V2 frequency high-byte
PWL2            = $D409 ;V2 pulse waveform low-byte
PWH2            = $D40A ;V2 pulse waveform high-byte
VCREG2          = $D40B ;V2 control register
ATDCY2          = $D40C ;V2 attack/decay
SUREL2          = $D40D ;V2 sustain/release
FREL3           = $D40E ;V3 frequency low-byte
FREH3           = $D40F ;V3 frequency high-byte
PWL3            = $D410 ;V3 pulse waveform low-byte
PWH3            = $D411 ;V3 pulse waveform high-byte
VCREG3          = $D412 ;V3 control register
ATDCY3          = $D413 ;V3 attack/decay
SUREL3          = $D414 ;V3 sustain/release
SIDVOL          = $D418 ;Volume
SIDRAND         = $D41B ;Oscillator 3 random number generator
      
COLOURRAM       = $D800 ;start of default colour RAM
CIAPRA          = $DC00 ;CIA port A
CIAPRB          = $DC01 ;CIA port B
DDRA            = $DC02 ;Data direction register port A
DDRB            = $DC03 ;Data direction register port B
CIAICR1         = $DC0D ;CIA interrupt control register #1           

;-------------------------------------------------------------------------------
; KERNAL ROM $E000-$FFFF
;-------------------------------------------------------------------------------

krnIRQ          = $EA31

krnCHROUT       = $FFD2
krnGETIN        = $FFE4
krnPLOT         = $FFF0