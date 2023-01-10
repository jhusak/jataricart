TRIGGER_FORMAT_29SF	equ $10
C_FORMAT_29SF		equ $80
C_BYTE_PROG_29SF	equ $a0
flashoppreamble_29SF
	pha
	lda #C_BYTE_PROG_29SF
	scc
	lda #C_FORMAT_29SF ; only if c set
	sta command_ZP
	pla
	.byte {bit.w}
flashoppreamble_acc_29SF ; 29sf040
	sta command_ZP
	txa
	pha
	; when write byte x must be set to either 0 or 40 temporarily
	and #$40
	tax
	sta $d500,x
	mva #$aa $a555 ; $555<$aa
	mva #$55 $a2aa ; $2aa<$55
	; $555<command
	mva command_ZPff $a555; will become command: FORMAT/ID_MODE/BYTE_PROG
	cmp #C_FORMAT_29SF
	bne @+ ; if not FORMAT, procedure finishes
	; FORMAT part, more to write
	mva #$aa $a555 ; $555<$aa
	mva #$55 $a2aa ; $2aa<$55
	; PREPARE FOR SECTOR TO ERASE
@	pla
	tax
flash_unlockchip_29SF
	rts
