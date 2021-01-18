PRODUCTION  set 0                           ; set to 0 for GENS compatibility (for debugging) and 1 when ready
CHEAT       set 0                           ; set to 1 for cheat enabled

; RAM Locations
CurrentSoundID  EQU $C086                   ; ID of current Sound


; I/O
HW_version      EQU $A10001                 ; hardware version in low nibble
                                            ; bit 6 is PAL (50Hz) if set, NTSC (60Hz) if clear
                                            ; region flags in bits 7 and 6:
                                            ;         USA NTSC = $80
                                            ;         Asia PAL = $C0
                                            ;         Japan NTSC = $00
                                            ;         Europe PAL = $C0
                                            
; MSU-MD vars
MCD_STAT        EQU $A12020                 ; 0-ready, 1-init, 2-cmd busy
MCD_CMD         EQU $A12010
MCD_ARG         EQU $A12011
MCD_CMD_CK      EQU $A1201F


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        
        org $4
        dc.l    $110000                         ; custom entry point for redirecting
        
        org     $100
        dc.b    'SEGA MEGASD     '              ; Make it compatible with MegaSD and GenesisPlusGX
        
        org     $1A4                            ; ROM_END
        dc.l    $001FFFFF                       ; Overwrite with 16 MBIT size
                
        org     $206                            ; original entry point, after reset-checks ($200 present in the header)
Game
            
        ;org    $354                            ; branch if checksum mismatch
        ;nop 
        ;nop 
        org     $32C                            ; bypass checksum checks
        jmp     $358
        
        org     $458                            ; mute music
        nop
        nop
        nop
        nop
        
        org     $7A6
        nop
        jsr     CustomPlaySound
        rts
        
        ifne    CHEAT
        
        org     $1A04                           ; CHEAT, unl.Energy 
        dc.w    $0000
        
        endif
        

        org     $100000
MSUDRV
        incbin	"msu-drv.bin"
        
        
        org     $100750
CustomPlaySound
        move.b  d0,($C086).w                ; sfx?
        move.b  d0,($C087).w                ; music?
ready
        tst.b   MCD_STAT
        bne.s   ready                       ; Wait for Driver ready to receive cmd
        jsr     find_track
        rts                                 ; Return to regular game code

find_track
        cmp.b   #$05,d0                     ; Main Theme
        beq     play_track_1
        cmp.b   #$06,d0                     ; Round 1
        beq     play_track_2
        cmp.b   #$07,d0                     ; Round 2
        beq     play_track_3
        cmp.b   #$08,d0                     ; Round 3
        beq     play_track_4
        cmp.b   #$0A,d0                     ; Round 4-1
        beq     play_track_5
        cmp.b   #$0B,d0                     ; Round 4-2
        beq     play_track_6
        cmp.b   #$0C,d0                     ; Round 4-3
        beq     play_track_7
        cmp.b   #$0D,d0                     ; Round 4-4
        beq     play_track_8
        cmp.b   #$0E,d0                     ; Round 4-5
        beq     play_track_9
        cmp.b   #$0F,d0                     ; Round 5-1
        beq     play_track_10
        cmp.b   #$10,d0                     ; Round 5-2
        beq     play_track_11
        cmp.b   #$11,d0                     ; Boss Theme
        beq     play_track_12
        cmp.b   #$13,d0                     ; Last Boss
        beq     play_track_13
        cmp.b   #$1D,d0                     ; Jingle 1
        beq     play_track_14
        cmp.b   #$16,d0                     ; Secret Door
        beq     play_track_15
        cmp.b   #$15,d0                     ; Game Over
        beq     play_track_16
        cmp.b   #$04,d0                     ; Round  Select
        beq     play_track_17
        cmp.b   #$14,d0                     ; Bonus Stage
        beq     play_track_18
        cmp.b   #$1E,d0                     ; Perfect Fanfare
        beq     play_track_19
        cmp.b   #$12,d0                     ; Gods Them
        beq     play_track_20
        cmp.b   #$19,d0                     ; Round Clear
        beq     play_track_21
        cmp.b   #$09,d0                     ; Dragon Blue Eyes
        beq     play_track_22
        cmp.b   #$1C,d0                     ; Jingle 2
        beq     play_track_23
        cmp.b   #$17,d0                     ; Ranking
        beq     play_track_24
        cmp.b   #$18,d0                     ; MD Tune
        beq     play_track_25
        cmp.b   #$1A,d0                     ; Ending 1
        beq     play_track_26
        cmp.b   #$1B,d0                     ; Staff Roll
        beq     play_track_27
        cmp.b   #$1F,d0                     ; Ending 2
        beq     play_track_28
        cmp.b   #$FF,d0                     ; Fade Track
        beq     fade_track

play_track_1                                ; Main Theme
        move.w  #($1100|1),MCD_CMD          ; send cmd: play track #1, no loop
        addq.b  #1,MCD_CMD_CK               ; Increment command clock
        rts
play_track_2                                ; Round 1
        move.w  #($1200|2),MCD_CMD          ; send cmd: play track #2, loop
        addq.b  #1,MCD_CMD_CK               ; Increment command clock
        rts
play_track_3                                ; Round 2
        move.w  #($1200|3),MCD_CMD          ; send cmd: play track #3, loop
        addq.b  #1,MCD_CMD_CK               ; Increment command clock
        rts
play_track_4                                ; Round 3
        move.w  #($1200|4),MCD_CMD          ; send cmd: play track #4, loop
        addq.b  #1,MCD_CMD_CK               ; Increment command clock
        rts
play_track_5                                ; Round 4-1
        move.w  #($1200|5),MCD_CMD          ; send cmd: play track #5, loop
        addq.b  #1,MCD_CMD_CK               ; Increment command clock
        rts
play_track_6                                ; Round 4-2
        move.w  #($1200|6),MCD_CMD          ; send cmd: play track #6, loop
        addq.b  #1,MCD_CMD_CK               ; Increment command clock
        rts
play_track_7                                ; Round 4-3
        move.w  #($1200|7),MCD_CMD          ; send cmd: play track #7, loop
        addq.b  #1,MCD_CMD_CK               ; Increment command clock
        rts
play_track_8                                ; Round 4-4
        move.w  #($1200|8),MCD_CMD          ; send cmd: play track #8, loop
        addq.b  #1,MCD_CMD_CK               ; Increment command clock
        rts
play_track_9                                ; Round 4-5
        move.w  #($1200|9),MCD_CMD          ; send cmd: play track #9, loop
        addq.b  #1,MCD_CMD_CK               ; Increment command clock
        rts
play_track_10                               ; Round 5-1
        move.w  #($1200|10),MCD_CMD         ; send cmd: play track #10, loop
        addq.b  #1,MCD_CMD_CK               ; Increment command clock
        rts
play_track_11                               ; Round 5-2
        move.w  #($1200|11),MCD_CMD         ; send cmd: play track #11, loop
        addq.b  #1,MCD_CMD_CK               ; Increment command clock
        rts
play_track_12                               ; Boss
        move.w  #($1200|12),MCD_CMD         ; send cmd: play track #12, loop
        addq.b  #1,MCD_CMD_CK               ; Increment command clock
        rts
play_track_13                               ; Last Boss
        move.w  #($1200|13),MCD_CMD         ; send cmd: play track #13, loop
        addq.b  #1,MCD_CMD_CK               ; Increment command clock
        rts
play_track_14                               ; Jingle 1
        move.w  #($1100|14),MCD_CMD         ; send cmd: play track #14, no-loop
        addq.b  #1,MCD_CMD_CK               ; Increment command clock
        rts
play_track_15                               ; Secret Door
        move.w  #($1100|15),MCD_CMD         ; send cmd: play track #15, no-loop
        addq.b  #1,MCD_CMD_CK               ; Increment command clock
        rts
play_track_16                               ; Game Over
        move.w  #($1100|16),MCD_CMD         ; send cmd: play track #16, no-loop
        addq.b  #1,MCD_CMD_CK               ; Increment command clock
        rts
play_track_17                               ; Round Select
        move.w  #($1200|17),MCD_CMD         ; send cmd: play track #17, loop
        addq.b  #1,MCD_CMD_CK               ; Increment command clock
        rts
play_track_18                               ; Bonus Stage
        move.w  #($1200|18),MCD_CMD         ; send cmd: play track #18, loop
        addq.b  #1,MCD_CMD_CK               ; Increment command clock
        rts
play_track_19                               ; Perfect Fanfare
        move.w  #($1100|19),MCD_CMD         ; send cmd: play track #19, no-loop
        addq.b  #1,MCD_CMD_CK               ; Increment command clock
        rts
play_track_20                               ; Gods Theme
        move.w  #($1100|20),MCD_CMD         ; send cmd: play track #20, no-loop
        addq.b  #1,MCD_CMD_CK               ; Increment command clock
        rts
play_track_21                               ; Round Clear
        move.w  #($1100|21),MCD_CMD         ; send cmd: play track #21, no-loop
        addq.b  #1,MCD_CMD_CK               ; Increment command clock
        rts
play_track_22                               ; Dragon Blue Eyes
        move.w  #($1100|22),MCD_CMD         ; send cmd: play track #22, no-loop
        addq.b  #1,MCD_CMD_CK               ; Increment command clock
        rts
play_track_23                               ; Jingle 2
        move.w  #($1100|23),MCD_CMD         ; send cmd: play track #23, no-loop
        addq.b  #1,MCD_CMD_CK               ; Increment command clock
        rts
play_track_24                               ; Ranking
        move.w  #($1200|24),MCD_CMD         ; send cmd: play track #24, loop
        addq.b  #1,MCD_CMD_CK               ; Increment command clock
        rts
play_track_25                               ; MD Tune
        move.w  #($1100|25),MCD_CMD         ; send cmd: play track #25, no-loop
        addq.b  #1,MCD_CMD_CK               ; Increment command clock
        rts
play_track_26                               ; Ending 1
        move.w  #($1100|26),MCD_CMD         ; send cmd: play track #26, no-loop
        addq.b  #1,MCD_CMD_CK               ; Increment command clock
        rts
play_track_27                               ; Staff Roll
        move.w  #($1100|27),MCD_CMD         ; send cmd: play track #27, no-loop
        addq.b  #1,MCD_CMD_CK               ; Increment command clock
        rts
play_track_28                               ; Ending 2
        move.w  #($1100|28),MCD_CMD         ; send cmd: play track #28, no-loop
        addq.b  #1,MCD_CMD_CK               ; Increment command clock
        rts
        
fade_track
        move.w  #($1300|75),MCD_CMD         ; send cmd: pause track
        addq.b  #1,MCD_CMD_CK               ; Increment command clock
        rts
        
audio_init
        jsr     MSUDRV
        nop
        nop
        nop
        
        if PRODUCTION
        
        tst.b   d0                          ; if 1: no CD Hardware found
        bne     audio_init_fail             ; Return without setting CD enabled
        
        endif
        
        move.w  #($1500|255),MCD_CMD        ; Set CD Volume to MAX
        addq.b  #1,MCD_CMD_CK               ; Increment command clock
        rts
audio_init_fail
        jmp     lockout
        
        org     $110000
ENTRY_POINT
        tst.w   $00A10008                   ; Test mystery reset (expansion port reset?)
        bne Main                            ; Branch if Not Equal (to zero) - to Main
        tst.w   $00A1000C                   ; Test reset button
        bne Main                            ; Branch if Not Equal (to zero) - to Main
Main
        move.b  $00A10001,d0                ; Move Megadrive hardware version to d0
        andi.b  #$0F,d0                     ; The version is stored in last four bits, so mask it with 0F
        beq     Skip                        ; If version is equal to 0, skip TMSS signature
        move.l  #'SEGA',$00A14000           ; Move the string "SEGA" to 0xA14000
Skip
        btst    #$6,(HW_version).l          ; Check for PAL or NTSC, 0=60Hz, 1=50Hz
        bne     jump_lockout                ; branch if != 0
        jsr     audio_init
        jmp     Game
jump_lockout
        jmp     lockout
        
        
        org     $120000                     ; insert GFX and code for lockout screen
lockout
        incbin	"msuLockout.bin"        

end: