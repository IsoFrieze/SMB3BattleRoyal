;========================
; 4 Player SMB3 Battle Mode
; Version 0.1
; Created by Dotsarecool
;========================

incsrc "definitions.asm"
incsrc "NMI.asm"

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

; hijacks
ORG $20F000
		JSL _NMI
		RTL

ORG $20F304
		JSL _IRQ
		RTL

ORG $20A2D0
	;	JSL _ENTRY
	;	JML $0080DE