;========================
; 4 Player SMB3 Battle Mode
; Version 0.1
; Created by Dotsarecool
;========================

incsrc "definitions.asm"
incsrc "codes.asm"
incsrc "remaps.asm"

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

; disable level cards
ORG $26CD8E
		NOP #6

; get start button on title/results screen
ORG $20B540
		JSL get_byetudlr_frame
ORG $20B875
		JSL get_byetudlr_frame
ORG $25F39F
		JSL get_byetudlr_frame
ORG $25F3AB
		JSL get_byetudlr_frame
		
; freespace
ORG $20FF78
jsl_controller:
		JSL update_controllers
		RTS
get_byetudlr_frame:
		LDA !controller_byetudlr_frame
		ORA !controller_byetudlr_frame+1
		ORA !controller_byetudlr_frame+2
		ORA !controller_byetudlr_frame+3
		RTL
		
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
		JSR jsl_controller ; temp disable
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
		LDX #$03
ORG $26CEBE
a_player_loop:
		STX $190E
		JSL decrement_death_timers
		JSR $CF04
		STZ !player_y_offset,X
		LDA $0076
		BNE .skip_interaction
		JSR $D9E9
	.skip_interaction:
		DEX
		BPL a_player_loop
		JMP $CEFF		
	
ORG $26CF38
		JSL activate_question_mushroom
		JMP $CF7A
ORG $26CF80
		JSL is_anyone_growing_or_shrinking
		NOP #2
ORG $26D21C
		JSL did_this_player_win
		NOP #2
ORG $26D272
		JSL is_anyone_sprite_locked
		NOP #2
ORG $26D297
		JSL is_anyone_growing_or_shrinking
		NOP #2
ORG $26D4E3
		PHX
		JSL sprite_block_interaction
		BEQ .exit
		JSR $D4F6
	.exit:
		PLX
		RTS
ORG $26CC26
		JSL init_player_poses
		NOP #3
ORG $26CFF1
		LDY !player_death_timer_a,X
ORG $26D000
		STZ !player_x_speed,X
		STZ !player_y_speed,X
ORG $26D008
		STA !player_status,X
		JSL initialize_player_position
		RTS
ORG $26F621
		JSL update_bounce_sprite_y
		RTS
ORG $26F627
		JSL update_enemy_sprite_x
		RTS
ORG $26F62D
		JSL update_enemy_sprite_y
		RTS
ORG $26F639
		JSL update_player_x
		RTS
ORG $26F645
		JSL update_player_y
		RTS
ORG $26D913
		JSL is_everyone_alive
		JMP $E927
ORG $26E407
		JSL is_anyone_growing_or_shrinking
		ORA $18CD,X
		ORA $197C,X
		ORA $19C0
		ORA $1930
		NOP #2