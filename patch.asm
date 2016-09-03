;========================
; 4 Player SMB3 Battle Mode
; Version 0.1
; Created by Dotsarecool
;========================

incsrc "definitions.asm"
incsrc "codes.asm"

; start with smb3 menu
ORG $009BC0
		JSR $8A8E
		LDA #$08
		STA $7FFF00
		JML $208000

; remove arrow object
ORG $20B826
		LDA #$F0
		NOP #2

; remove arrow sound
ORG $20B7D1
		NOP #3

; always select battle mode
ORG $20B8E4
		LDA #$03
		STA $072B
		NOP
		
; clear out more memory
ORG $26CC2D
		LDY #$0300
		LDA #$0000
		STA $1700,Y
		
; freespace
ORG $20FF78
jsl_controller:
		JSL update_controllers
		RTS
		
; graphics
ORG $35E000
		incbin "scoreboard_tiles.bin"
; map16
ORG $219C79
		incbin "scoreboard_map16.bin"
ORG $21A179
		db $0E,$19,$0E,$19,$0F,$19,$0F,$19

; hijacks
ORG $20F65C
		JSL dma_player_graphics
		JMP $F703
ORG $20F0B0
	;	JSR jsl_controller ; temp disable
ORG $25F8CE
		PHB
		PHK
		PLB
		JSL load_player_pose
		PLB
		RTL
ORG $26D800
		JSL draw_players
		RTS
ORG $20A346
		JSL load_level
ORG $20A3CE
		JSL clear_scoreboards
		JMP $A420
ORG $20A39C
		JSL tally_point
		JMP $A3BA
ORG $26CBB8
		JSL load_all_players_byetudlr
ORG $26CC75
		JSL make_all_players_big
		LDA #$01
		NOP #2
ORG $26F688
		JSL flash_scoreboard
		RTS
ORG $26CEAC
		JSL merge_controls
ORG $26CEB8
		JSL disable_controls
	;	LDX #$01
ORG $26CEC1
		JSL decrement_death_timers
		JMP $CEEE

		
ORG $26D217
	;	RTS