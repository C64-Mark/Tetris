;*******************************************************************************
; Constants
;*******************************************************************************

FLASH_DELAY             = 15
FLASH_TIME              = FLASH_DELAY * 6
LINES_PER_LEVEL         = 2     ;for testing, is 10 for actual game
DROP_DELAY_CHANGE       = 10
DEFAULT_DROP_DELAY      = 70
DELAY                   = 10
INPUT_DELAY             = 7

KEY_LEFT                = 47
KEY_RIGHT               = 44
KEY_TURN_COUNTER        = 10
KEY_TURN_CLOCK          = 13
KEY_DOWN                = 1
KEY_PAUSE               = 41
KEY_RESET               = 4
NOKEY                   = 64
NOINPUT                 = 253

JOY_UP                  = %00000001
JOY_DOWN                = %00000010
JOY_LEFT                = %00000100
JOY_RIGHT               = %00001000
JOY_FIRE                = %00010000
JOY_NONE                = %00000000

BLACK                   = #$00
WHITE                   = #$01
RED                     = #$02
CYAN                    = #$03
PURPLE                  = #$04
GREEN                   = #$05
BLUE                    = #$06
YELLOW                  = #$07
ORANGE                  = #$08
BROWN                   = #$09
LIGHTRED                = #$0A
GRAY1                   = #$0B
GRAY2                   = #$0C
LIGHTGREEN              = #$0D
LIGHTBLUE               = #$0E
GRAY3                   = #$0F

SPACE                   = #$20
TRUE                    = #$01
FALSE                   = #$00

