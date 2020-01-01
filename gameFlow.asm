;-------------------------------------------------------------------------------
; gameFlow Variables
;-------------------------------------------------------------------------------

gfStatusJumpTableLo             byte <GameFlowStatusAttract
                                byte <GameFlowStatusSelectLevel
                                byte <GameFlowStatusPlay
                                byte <GameFlowStatusPaused
                                byte <GameFlowStatusGameOver
                                byte <GameFlowStatusEnterName

gfStatusJumpTableHi             byte >GameFlowStatusAttract
                                byte >GameFlowStatusSelectLevel
                                byte >GameFlowStatusPlay
                                byte >GameFlowStatusPaused
                                byte >GameFlowStatusGameOver
                                byte >GameFlowStatusEnterName

gameStatus                      byte 00

GAMEFLOW_ATTRACT                = 0
GAMEFLOW_LEVELSELECT            = 1
GAMEFLOW_PLAY                   = 2
GAMEFLOW_PAUSED                 = 3
GAMEFLOW_GAMEOVER               = 4
GAMEFLOW_ENTERNAME              = 5

;-------------------------------------------------------------------------------
; gameFlow Subroutines
;-------------------------------------------------------------------------------

; >>> gfUpdate <<<
; Update the current game status
gfUpdate
        ldx gameStatus
        lda gfStatusJumpTableLo,x
        sta zpLow
        lda gfStatusJumpTableHi,x
        sta zpHigh
        jmp (zpLow)

GameFlowStatusAttract
        jsr gfAttract_Update
        rts

GameFlowStatusSelectLevel
        jsr gfLevelSelect_Update
        rts

GameFlowStatusPlay
        jsr gfPlay_Update
        rts

GameFlowStatusPaused
        jsr gfPaused_Update
        rts

GameFlowStatusGameOver
        jsr gfGameOver_Update
        rts

GameFlowStatusEnterName
        ;not yet implemented
        rts