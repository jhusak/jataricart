TRIGGER_FORMAT_39SF equ $10
C_FORMAT_39SF	equ $80
C_BYTE_PROG_39SF	equ $a0
flashoppreamble_39SF
	pha
	lda #C_BYTE_PROG_39SF
	scc
	lda #C_FORMAT_39SF ; only if c set
	sta command_ZP
	pla
	.byte {bit.w}
flashoppreamble_acc_39SF ; 39sf0x0, 29F040
	sta command_ZP
	txa
	pha
	; when write byte x must be set to either 0 or 40 temporarily
	and #$40
	tax
	sta $d502,x
	mva #$aa $b555 ; $5555<$aa
	sta $d501,x
	mva #$55 $aaaa ; $2aaa<$55
	; $5555<$80
	sta $d502,x
	mva command_ZP $b555; will become command: FORMAT/ID_MODE/BYTE_PROG
	cmp #C_FORMAT_39SF
	bne @+ ; if not FORMAT, procedure finishes
	; FORMAT part, more to write
	sta $d502,x
	mva #$aa $b555 ; $5555<$aa
	sta $d501,x
	mva #$55 $aaaa ; $2aaa<$55
@	pla
	tax
flash_unlockchip_39SF
	rts
