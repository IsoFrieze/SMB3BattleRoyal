ORG $118000

dma_player_graphics:
		PHP
		REP #$10
		
		LDA #$80
		STA $2115
		LDA #$3D
		STA $4304
		LDX #$1801
		STX $4300
		LDX #$0006
		LDA #$01
	.loop:
		REP #$20
		TXA
		XBA
		LSR A
		CLC
		ADC #$7400
		TAY
		SEP #$20
		LDA #$01
		STY $2116
		
		LDY !player_tiles,X
		STY $4302
		LDY #$0040
		STY $4305
		STA $420B
		
		LDY !player_tiles+$10,X
		STY $4302
		LDY #$0040
		STY $4305
		STA $420B
		
		LDY !player_tiles+$20,X
		STY $4302
		LDY #$0040
		STY $4305
		STA $420B
		
		LDY !player_tiles+$30,X
		STY $4302
		LDY #$0040
		STY $4305
		STA $420B	
	
		DEX
		DEX
		BPL .loop
		
		LDX #$0001
		PLP
		RTL

update_controllers:
		STZ $4016 ; i/o bit
		LDX #$03
		LDY #$06
	.loop:
		LDA !controller_axlr_hold,X
		AND $4218,Y
		EOR $4218,Y
		STA !controller_axlr_frame,X
		LDA $4218,Y
		STA !controller_axlr_hold,X
		
		LDA !controller_byetudlr_hold,X
		AND $4219,Y
		EOR $4219,Y
		STA !controller_byetudlr_frame,X
		LDA $4219,Y
		STA !controller_byetudlr_hold,X
		
		DEY
		DEY
		DEX
		BPL .loop
		RTL

load_player_pose:
		REP #$30
		LDA #$F82E
		STA $04
		LDA #$1000
		STA $00
		
		LDX #$0003
	.loop:
		LDA !player_animation_frame,X
		AND #$00FF
		TAY
		PHX
		TXA
		ASL #4
		TAX
		
		LDA ($04),Y
		CLC
		ADC $00
		STA !player_tiles,X
		INY
		INY
		LDA ($04),Y
		CLC
		ADC $00
		STA !player_tiles+2,X
		INY
		INY
		LDA ($04),Y
		CLC
		ADC $00
		STA !player_tiles+4,X
		INY
		INY
		LDA ($04),Y
		CLC
		ADC $00
		STA !player_tiles+6,X
		
		LDA $00
		EOR #$1000
		STA $00
		
		PLX
		DEX
		BPL .loop
		
		SEP #$30
		RTL

; given X = player 0-3
draw_players:
		LDA !player_y_position_high,X
		BPL .check_zero
		LDA !player_y_position_low,X
		CMP #$E0
		BCS .flash
		RTL
	.check_zero:
		BEQ .flash
		RTL
	.flash:
		LDA !player_invinsible,X
		BEQ .draw
		LDA $15
		AND #$02
		BEQ .draw
		RTL
	.draw:
		
		TXA
		ASL #4
		TAY
		LDA !player_x_position,X
		STA $0900,Y
		STA $0904,Y
		STA $0908,Y
		STA $090C,Y
		LDA !player_y_position_low,X
		STA $0901,Y
		STA $0909,Y
		CLC
		ADC #$10
		STA $0905,Y
		STA $090D,Y
		TXA
		ASL A
		CLC
		ADC #$40
		STA $0902,Y
		STA $090A,Y
		CLC
		ADC #$20
		STA $0906,Y
		STA $090E,Y
		TXA
		ASL #2
		EOR #$0F
		STA $00
		LDA !player_direction,X
		AND #$01
		CLC
		ROR #3
		ORA $00
		ORA #$20
		STA $00
		STA $0903,Y
		STA $0907,Y
		STA $090B,Y
		STA $090F,Y
		
		TXA
		ASL #2
		TAY
		LDA #$02
		STA $0A60,Y
		STA $0A61,Y
		LDA #$03
		STA $0A62,Y
		STA $0A63,Y
		
		LDA !player_animation_frame,X
		CMP #$30
		BNE .done
		
		TXA
		ASL #3
		TAY
		LDA !player_y_position_low,X
		CLC
		ADC #$10
		STA $0941,Y
		CLC
		ADC #$08
		STA $0945,Y
		LDA #$8E
		STA $0942,Y
		LDA #$8F
		STA $0946,Y
		LDA $00
		AND #$FE
		STA $0943,Y
		STA $0947,Y
		LDA !player_direction,X
		AND #$01
		BEQ .flip_foot
		LDA !player_x_position,X
		CLC
		ADC #$10
		BRA .foot_merge
	.flip_foot:
		LDA !player_x_position,X
		SEC
		SBC #$08
	.foot_merge:
		STA $0940,Y
		STA $0944,Y
		
		TXA
		ASL #2
		TAY
		LDA #$00
		STA $0A70,Y
		STA $0A71,Y
		
	.done:
		RTL

load_level:
		PHB
		PHK
		PLB
		PHP
		
		REP #$10
		LDX #$00EF
	.loop_level:
		LDA custom_level,X
		STA $7E2000,X
		DEX
		BPL .loop_level
		
		LDX #$0009
	.loop_scoreboard:
		LDA scoreboard,X
		STA $7E2003,X
		LDA scoreboard+$0A,X
		STA $7E2013,X
		DEX
		BPL .loop_scoreboard
		
		PLP
		PLB
		RTL
		
scoreboard:
		db $20,$21,$22,$23,$24,$25,$26,$27,$28,$29
		db $40,$41,$42,$43,$44,$45,$46,$47,$48,$49
normal_level:
		db $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
		db $81,$80,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$80,$81
		db $83,$82,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$82,$83
		db $C1,$C1,$C1,$C1,$C1,$C1,$02,$02,$02,$02,$C1,$C1,$C1,$C1,$C1,$C1
		db $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
		db $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
		db $02,$02,$02,$02,$C1,$C1,$C1,$C1,$C1,$C1,$C1,$C1,$02,$02,$02,$02
		db $C1,$C1,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$C1,$C1
		db $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
		db $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
		db $C1,$C1,$C1,$C1,$C1,$C1,$02,$02,$02,$02,$C1,$C1,$C1,$C1,$C1,$C1
		db $81,$80,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$80,$81
		db $83,$82,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$82,$83
		db $50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50
		db $50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50
custom_level:
		db $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
		db $81,$80,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$80,$81
		db $83,$82,$02,$02,$02,$02,$02,$C1,$C1,$02,$02,$02,$02,$02,$82,$83
		db $C1,$C1,$C1,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$C1,$C1,$C1
		db $02,$C0,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$C0,$02
		db $02,$C0,$02,$C1,$C1,$C1,$C1,$02,$02,$C1,$C1,$C1,$C1,$02,$C0,$02
		db $02,$C0,$02,$C1,$C1,$C1,$C1,$C1,$C1,$C1,$C1,$C1,$C1,$02,$C0,$02
		db $02,$C0,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$C0,$02
		db $C1,$C1,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$C1,$C1
		db $02,$02,$02,$02,$02,$02,$C1,$C1,$C1,$C1,$02,$02,$02,$02,$02,$02
		db $02,$02,$02,$02,$02,$C1,$C1,$02,$02,$C1,$C1,$02,$02,$02,$02,$02
		db $C1,$C1,$C1,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$C1,$C1,$C1
		db $81,$80,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$80,$81
		db $83,$82,$02,$02,$02,$02,$02,$50,$50,$02,$02,$02,$02,$02,$82,$83
		db $50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50

initial_player_direction:
		db $02,$01,$02,$03
initial_player_x_position:
		db $50,$A0,$20,$D0
initial_player_y_position:
		db $80,$80,$90,$90

initialize_player_position:
		PHB
		PHK
		PLB
		
		TXA
		TAY
		LDA initial_player_direction,Y
		STA !player_direction,X
		LDA initial_player_x_position,Y
		STA !player_x_position,X
		LDA initial_player_y_position,Y
		STA !player_y_position_low,X
		
		PLB
		RTL
	
clear_scoreboards:
		PHP
		
		REP #$20
		LDA #$4900
		STA $1602
		LDA #$4E00
		STA $1608
		LDA #$5300
		STA $160E
		LDA #$5800
		STA $1614
		LDA #$0100
		STA $1604
		STA $160A
		STA $1610
		STA $1616
		LDA #$191A
		STA $1606
		LDA #$1D1A
		STA $160C
		LDA #$192A
		STA $1612
		LDA #$193A
		STA $1618
		
		LDA #$FFFF
		STA $161A
		
		PLP
		RTL

tally_point:
		LDA !winner_of_game
		DEC A
		TAX
		LDA #$01
		STA $1203
		INC !number_won_games,X
		LDA !number_won_games,X
		CMP #$05
		BCC .done
		INC !number_won_matches,X
		LDA #$05
		STA $1203
	.done:
		RTL

load_all_players_byetudlr:
		LDA !controller_byetudlr_frame
		ORA !controller_byetudlr_frame+1
		ORA !controller_byetudlr_frame+2
		ORA !controller_byetudlr_frame+3
		RTL
		
load_all_players_axlr:
		LDA !controller_axlr_frame
		ORA !controller_axlr_frame+1
		ORA !controller_axlr_frame+2
		ORA !controller_axlr_frame+3
		RTL
		
make_all_players_big:
		LDA #$01
		STA !player_size
		STA !player_size+1
		STA !player_size+2
		STA !player_size+3
		RTL

flash_scoreboard:
		PHB
		PHK
		PLB
		
		LDA $078C
		DEC A
		AND #$03
		TAX
		LDA !player_coin_count,X
		CMP #$05
		BNE .done
		LDA $2143
		BNE .no_sound
		LDA #$05
		STA $1203
	.no_sound:
		LDA $15
		AND #$04
		BEQ .erase_tile
	.draw_tile:
		LDA number_5_properties,X
		STA $1607
		LDA number_5_tiles,X
		BRA .merge
	.erase_tile:
		LDA #$10
		STA $1607
		LDA #$FF
	.merge:
		STA $1606
		LDA #$FF
		STA $1608
		STZ $1602
		LDA number_5_locations,X
		STA $1603
		STZ $1604
		LDA #$01
		STA $1605
		
	.done:
		PLB
		RTL

number_5_locations:
		db $49,$4E,$53,$58
number_5_tiles:
		db $1F,$1F,$2F,$3F
number_5_properties:
		db $19,$1D,$19,$19
		
merge_controls:
		LDX #$03
	.loop:
		LDA !controller_axlr_hold,X
		AND #$C0
		ORA !controller_byetudlr_hold,X
		STA !controller_byetudlr_hold,X
		LDA !controller_axlr_frame,X
		AND #$C0
		ORA !controller_byetudlr_frame,X
		STA !controller_byetudlr_frame,X
		
	.check_lr:
		LDA !controller_byetudlr_hold,X
		AND #$03
		CMP #$03
		BNE .check_ud
		LDA !controller_byetudlr_hold,X
		AND #$FE
		STA !controller_byetudlr_hold,X
	.check_ud:
		LDA !controller_byetudlr_hold,X
		AND #$0C
		CMP #$0C
		BNE .continue
		LDA !controller_byetudlr_hold,X
		AND #$F7
		STA !controller_byetudlr_hold,X
	
	.continue:
		DEX
		BPL .loop
		RTL

disable_controls:
		LDX #$0F
	.loop:
		STZ !controller_byetudlr_hold,X
		DEX
		BPL .loop
		RTL

decrement_death_timers:
		STZ !player_y_offset,X
		LDA $76
		BNE .done
		LDA !player_death_timer_a,X
		BEQ .check_b
		DEC !player_death_timer_a,X
	.check_b:
		LDA !player_death_timer_b,X
		BEQ .done
		DEC !player_death_timer_b,X
	.done:
		RTL

activate_question_mushroom:
		LDA !player_size
		ORA !player_size+1
		ORA !player_size+2
		ORA !player_size+3
		CMP !player_size
		BEQ .swap_positions
	.swap_sizes:
		LDA !player_size
		PHA
		LDA !player_size+1
		STA !player_size
		LDA !player_size+2
		STA !player_size+1
		LDA !player_size+3
		STA !player_size+2
		PLA
		STA !player_size+3
		BRA .done
	.swap_positions:
		LDA !player_x_position
		PHA
		LDA !player_x_position+1
		STA !player_x_position
		LDA !player_x_position+2
		STA !player_x_position+1
		LDA !player_x_position+3
		STA !player_x_position+2
		PLA
		STA !player_x_position+3
		
		LDA !player_y_position_low
		PHA
		LDA !player_y_position_low+1
		STA !player_y_position_low
		LDA !player_y_position_low+2
		STA !player_y_position_low+1
		LDA !player_y_position_low+3
		STA !player_y_position_low+2
		PLA
		STA !player_y_position_low+3
		
		LDA !player_y_position_high
		PHA
		LDA !player_y_position_high+1
		STA !player_y_position_high
		LDA !player_y_position_high+2
		STA !player_y_position_high+1
		LDA !player_y_position_high+3
		STA !player_y_position_high+2
		PLA
		STA !player_y_position_high+3
		
	.done:
		RTL

is_anyone_growing_or_shrinking:
		LDA !player_changing_size
		ORA !player_changing_size+1
		ORA !player_changing_size+2
		ORA !player_changing_size+3
		RTL

did_this_player_win:
		TXA
		INC A
		CMP $078C
		RTL

is_anyone_sprite_locked:
		LDA !player_sprite_lock
		ORA !player_sprite_lock+1
		ORA !player_sprite_lock+2
		ORA !player_sprite_lock+3
		RTL

sprite_block_interaction:
		CPX #$04
		BCC .player
	.sprite:
		TXA
		DEC #2
		TAX
		STZ $1895,X
		STZ $18F8,X
		STZ $190F,X
		LDA #$01
		RTL
	.player:
		STZ !player_direction_interaction,X
		STZ !player_walking_on_tile,X
		STZ !player_below_tile,X
		
		; ... ; $26D4F6 but with remapped tables
	.jsr_26D4F6:
		LDY #$05
	.j_26D4F8:
		STY $0F
		LDA !player_y_position_low,X
		CLC
		ADC $ECF3,Y
		AND #$F0
		STA $00
		LDA !player_size,X
		BEQ .b_26D525
		LDA !player_ducking,X
		BEQ .b_26D52E
	.b_26D525:
		LDA $00
		CLC
		ADC #$10
		STA $00
		BRA .b_26D539
	.b_26D52E:
		LDA !player_y_position_low,X
		CLC
		ADC $ECF9,Y
		AND #$F0
		STA $00
	.b_26D539:
		LDA !player_x_position,X
		CLC
		ADC $ECE7,Y
		STA $01
		JSR .jsr_26D7C0
		LDY $0F
		BCS .b_26D54C
		JMP .j_26D670
	.b_26D54C:
		CPY #$02
		BCC .b_26D553
		JMP .j_26D5F5
	.b_26D553:
		LDA !player_y_position_low,X
		CMP #$D0
		BCC .b_26D55D
		JMP .j_26D5F2
	.b_26D55D:
		LDA !player_size,X
		BEQ .b_26D573
		LDA !player_ducking,X
		BEQ .b_26D573
		LDA !player_y_position_low,X
		CLC
		ADC #$05
		BRA .b_26D576
	.b_26D573:
		LDA !player_y_position_low,X
	.b_26D576:
		AND #$0F
		CMP #$09
		BCS .b_26D57F
		JMP .j_26D670
	.b_26D57F:
		LDA !player_x_speed,X
		BPL .b_26D5F2
		LDA $180F,X
		BNE .b_26D5F2
		LDA #$00
		STA $2E
		LDA #$20
		STA $2F
		LDA #$7E
		STA $30
		LDY $02
		LDA #$C2
		STA [$2E],Y
		TYA
		STA $1908,X
		LDA !player_y_position_low,X
		STA $0000
		LDA !player_size,X
		BEQ .b_26D5BC
		LDA !player_ducking,X
		BNE .b_26D5BC
		LDA $0000
		CLC
		ADC #$05
		STA $0000
	.b_26D5BC:
		LDA $0000
		AND #$F0
		STA $1820,X
		LDA !player_size,X
		BEQ .b_26D5CE
		LDA !player_ducking,X
		BEQ .b_26D5D7
	.b_26D5CE:
		LDA $1820,X
		CLC
		ADC #$10
		STA $1820,X
	.b_26D5D7:
		LDA !player_x_position,X
		CLC
		ADC #$08
		AND #$F0
		STA $1831,X
		LDA #$0E
		STA $180F,X
		LDA #$E0
		STA $1842,X
		JSR .jsr_26D6A1
		JSR .jsr_26D74B
	.j_26D5F2:
	.b_26D5F2:
		JMP .j_26D631
	
	.j_26D5F5:
		CPY #$04
		BCC .b_26D5FC
		JMP .j_26D5FF
	.b_26D5FC:
		JMP .j_26D631
		
	.j_26D5FF:
		LDA !player_y_position_low,X
		AND #$0F
		CMP #$06
		BCS .b_26D670
		LDA !player_y_speed,X
		BMI .b_26D670
		LDY $02
		LDA !player_walking_on_tile,X
		CMP #$C2
		BEQ .b_26D631
		LDA #$00
		STA $2E
		LDA #$20
		STA $2F
		LDA #$7E
		STA $30
		LDA [$2E],Y
		CMP #$FE
		BCC .b_26D62E
		AND #$01
		TAY
		LDA $EC57,Y
	.b_26D62E:
		STA !player_walking_on_tile,X
	.j_26D631:
	.b_26D631:
		LDY $0F
		LDA !player_direction_interaction,X
		ORA $ECFF,Y
		STA !player_direction_interaction,X
		LDY $02
		LDA #$00
		STA $2E
		LDA #$20
		STA $2F
		LDA #$7E
		STA $30
		LDA [$2E],Y
		CMP #$FE
		BCC .b_26D661
		AND #$01
		TAY
		LDA $EC57,Y
	.b_26D661:
		LDY $0F
		CMP #$C2
		BNE .b_26D670
		LDA !player_direction_interaction,X
		ORA $ED05,Y
		STA !player_direction_interaction,X
	.j_26D670:
	.b_26D670:
		CPY #$02
		BCS .b_26D698
		LDY $02
		LDA !player_below_tile,X
		CMP #$C0
		BEQ .b_26D698
		LDA #$00
		STA $2E
		LDA #$20
		STA $2F
		LDA #$7E
		STA $30
		LDA [$2E],Y
		CMP #$FE
		BCC .b_26D695
		AND #$01
		TAY
		LDA $EC57,Y
	.b_26D695:
		STA !player_below_tile,X
	.b_26D698:
		LDY $0F
		DEY
		BMI .b_26D6A0
		JMP .j_26D4F8
	.b_26D6A0:
		RTL
		
	.jsr_26D6A1:
		LDA $1A2F
		BEQ .b_26D6A7
		RTS
	.b_26D6A7:
		LDY #$00
		LDA $19B7
		CMP $1831,X
		BEQ .b_26D6B4
		JMP .j_26D74A
	.b_26D6B4:
		LDA $19B9
		CMP $1820,X
		BEQ .b_26D6BF
		JMP .j_26D74A
	.b_26D6BF:
		LDA !player_x_speed,X
		STA $00
		PHX
		LDA $1A31
		STA $0002
		PHY
		LDX #$07
		JSR .jsr_26DDCB
		PLY
		TXA
		BMI .b_26D749
		LDA $0002
		STA $1A31
		DEC $18CA
		CPX #$07
		BCS .b_26D6E5
		JMP .j_26ED2A
	.b_26D6E5:
		LDA #$10
		STA $1846,X
		LDA $00
		BMI .b_26D6F3
		LDA #$F0
		STA $1846,X
	.b_26D6F3:
		INC $1A2F
		LDA $19B7,Y
		STA $1824,X
		LDA $19B9,Y
		SEC
		SBC #$08
		STA $1813,X
		LDA #$D8
		STA $1835,X
		STZ $18A6,X
		LDA #$00
		STA $19B7,Y
		LDA #$F0
		STA $19B9,Y
		STZ $191E,X
		LDA #$10
		STA $18BB,X
		LDA $1A30
		BNE .b_26D73E
		JSL $25F805
		AND #$1F
		CMP $1A3F
		BCS .b_26D73E
		INC $1A30
		LDA #$11
		STA $18BB,X
		LDA #$01
		STA $1A3F
		BRA .b_26D73E
	.b_26D73E:
		INC $1A3F
		LDA #$03
		STA $1200
		INC $19BD
	.b_26D749:
		PLX
	.j_26D74A:
		RTS
	.j_26ED2A:
		STZ $1802,X
		RTS
		
	.jsr_26D74B:
		LDA $1A36
		CMP $1831,X
		BNE .b_26D76A
		LDA $1A37
		CMP $1820,X
		BNE .b_26D76A
		LDA #$0A
		STA $1200
		LDA #$18
		STA $1A35
		LDA #$FF
		STA $1A37
	.b_26D76A:
		RTS
	
	.jsr_26D7C0:
		LDA $01
		LSR #4
		ORA $00
		TAY
		STY $02
		LDA #$00
		STA $2E
		LDA #$20
		STA $2F
		LDA #$7E
		STA $30
		LDA [$2E],Y
		CMP #$FE
		BCC .b_26D7E3
		AND #$01
		TAY
		LDA $EC57,Y
	.b_26D7E3:
		PHA
		ASL A
		ROL $0E
		ASL A
		ROL $0E
		LDA $0E
		AND #$03
		TAY
		PLA
		CMP $1E9A,Y
		RTS
	
	
	.jsr_26DDCB:
	.b_26DDCB:
		LDA $1802,X
		BEQ .b_26DDD4
		DEX
		BPL .b_26DDCB
		RTS
	.b_26DDD4:
		INC $18CA
		INC $1A31
		LDA $1A31
		CMP #$06
		BNE .b_26DDE4
		STZ $1A31
	.b_26DDE4:
		LDA #$01
		STA $1802,X
		LDA #$20
		STA $1813,X
		STZ $1835,X
		LDA #$00
		STA $18BB,X
		JSR .jsr_26DD0B
		LDA #$30
		STA $191E,X
		REP #$30
		LDY #$0000
		LDA $1A3A
		CMP $1A3C
		BCS .b_26DE11
		INY
		STZ $1A3C
		BRA .b_26DE14
	.b_26DE11:
		STZ $1A3A
	.b_26DE14:
		SEP #$30
		LDA $ED32,Y
		STA $1824,X
		LDA $ED34,Y
		STA $1846,X
		RTS
	
	.jsr_26DD0B:
		STZ $1944,X
		STZ $18A6,X
		STZ $18FA,X
		STZ $1931,X
		STZ $1953,X
		STZ $191E,X
		STZ $18CD,X
		STZ $18DA,X
		STZ $197C,X
		STZ $18E9,X
		STZ $196F,X
		STZ $1A40,X
		STZ $1A5A,X
		RTS
		
		; ...
		
		LDA #$00
		RTL

init_player_poses:
		LDA #$1010
		STA !player_animation_frame
		STA !player_animation_frame+2
		STZ $8E ; $8F = 0
		RTL

update_player_y:
		LDA !player_y_speed,X
		ASL #4
		CLC
		ADC !player_y_speed_subpixel,X
		STA !player_y_speed_subpixel,X
		PHP
		LDY #$00
		LDA !player_y_speed,X
		LSR #4
		CMP #$08
		BCC .less
		ORA #$F0
		DEY
	.less:
		PLP
		ADC !player_y_position_low,X
		STA !player_y_position_low,X
		TYA
		ADC !player_y_position_high,X
		STA !player_y_position_high,X
		RTL
		
update_player_x:
		LDA !player_x_speed,X
		ASL #4
		CLC
		ADC !player_x_speed_subpixel,X
		STA !player_x_speed_subpixel,X
		PHP
		LDY #$00
		LDA !player_x_speed,X
		LSR #4
		CMP #$08
		BCC .less
		ORA #$F0
		DEY
	.less:
		PLP
		ADC !player_x_position,X
		STA !player_x_position,X
		RTL
		
update_enemy_sprite_y:
		LDA $1835,X
		ASL #4
		CLC
		ADC $1875,X
		STA $1875,X
		PHP
		LDY #$00
		LDA $1835,X
		LSR #4
		CMP #$08
		BCC .less
		ORA #$F0
		DEY
	.less:
		PLP
		ADC $1813,X
		STA $1813,X
		TYA
		ADC $1944,X
		STA $1944,X
		RTL
		
update_enemy_sprite_x:
		LDA $1846,X
		ASL #4
		CLC
		ADC $1886,X
		STA $1886,X
		PHP
		LDY #$00
		LDA $1846,X
		LSR #4
		CMP #$08
		BCC .less
		ORA #$F0
		DEY
	.less:
		PLP
		ADC $1824,X
		STA $1824,X
		RTL
		
update_bounce_sprite_y:
		LDA $1842,X
		ASL #4
		CLC
		ADC $1882,X
		STA $1882,X
		PHP
		LDY #$00
		LDA $1842,X
		LSR #4
		CMP #$08
		BCC .less
		ORA #$F0
		DEY
	.less:
		PLP
		ADC $1820,X
		STA $1820,X
		TYA
		ADC $1951,X
		STA $1951,X
		RTL

is_everyone_alive:
		LDA !player_status
		BEQ .no
		CMP #$02
		BEQ .no
		LDA !player_status+1
		BEQ .no
		CMP #$02
		BEQ .no
		LDA !player_status+2
		BEQ .no
		CMP #$02
		BEQ .no
		LDA !player_status+3
		BEQ .no
		CMP #$02
		BEQ .no
	
	.yes:
		LDA #$00
		RTL
	.no:
		LDA #$01
		RTL