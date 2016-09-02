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
		
; freespace
ORG $20FF78
jsl_controller:
		JSL update_controllers
		RTS

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

ORG $20A2D0
	;	JSL _ENTRY
	;	JML $0080DE