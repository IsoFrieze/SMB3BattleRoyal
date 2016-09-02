; NMI.asm
; Run on NMI, also includes IRQ

; todo get rid of this
ORG $20f9c3
		RTL
ORG $20FBC4
		RTL

ORG $118000
_IRQ:
		RTL
_NMI:
		LDA $4210 ; NMI flag
		LDA $02
		PHA
		
		LDA #$80
		STA $2100 ; force blank
		STA $420C ; clear HDMA
		
		LDA #$03
		STA $2101 ; objsel
		
		JSL dma_player_graphics
		JSL dma_stripe_image
		JSL copy_hardware_regs
		
		LDA #$81
		STA $4200 ; enable interrupts & auto joypad
		
		CLI
		
		LDA !freeze_entire_game
		BEQ .forward
		
		JSL update_controllers
		JSL update_RNG_buffer
		DEC !lag_flag
		
	.forward:
		INC !frame_counter
		LDA !brightness
		STA $2100 ; brightness
		LDA !hdma_enable
		STA $420C ; HDMA enable
		
		JSL copy_apu_regs
		
		PLA
		STA $02
		
		RTL

dma_player_graphics:
		JSL $20F650
		RTL

dma_stripe_image:
		LDA !lag_flag
		BNE .done
		
		JSL $29E8AB
		JSL $29EA69
		
		STZ !stripe_image_index
		STZ !stripe_image_index+1
		LDA #$FF
		STA !stripe_image_index+2
		STA !stripe_image_index+3
		STZ $28
		
	.done:
		RTL

copy_hardware_regs:
		LDA !w12sel
		STA $2123
		LDA !w34sel
		STA $2124
		LDA !wobjsel
		STA $2125
		LDA !cgswel
		STA $2130
		LDA !cgadsub
		STA $2131
		LDA !coldata_r
		STA $2132
		LDA !coldata_g
		STA $2132
		LDA !coldata_b
		STA $2132
		LDA !tm
		STA $212C
		LDA !ts
		STA $212D
		LDA !tmw
		STA $212E
		LDA !tsw
		STA $212F
		LDA !bgmode
		STA $2105
		LDA !mosaic
		STA $2106
		
		LDA !bg1hofs
		STA $210D
		LDA !bg1hofs+1
		STA $210D
		LDA !bg1vofs
		STA $210E
		LDA !bg1vofs+1
		STA $210E
		LDA !bg2hofs
		STA $210F
		LDA !bg2hofs+1
		STA $210F
		LDA !bg2vofs
		STA $2110
		LDA !bg2vofs+1
		STA $2110
		LDA !bg3hofs
		STA $2111
		LDA !bg3hofs+1
		STA $2111
		LDA !bg3vofs
		STA $2112
		LDA !bg3vofs+1
		STA $2112
		RTL

update_controllers:
		JSL $20FB5E
		RTL
		; temp
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

update_RNG_buffer:
		JSL $22E103
		RTL

copy_apu_regs:
		JSL $22E677
		RTL