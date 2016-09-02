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