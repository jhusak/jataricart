C_FORMAT_29SF		equ $80
C_BYTE_PROG_29SF	equ $a0
M_SSIZE_29SF	equ $0080 ; sector size
command_ZP	=	$f0

M_VECTORS_29SF
	jmp softid_entry_29SF
	jmp softid_exit_29SF
	jmp flashoppreamble_29SF
	jmp flash_lockchip_29SF
	jmp flash_unlockchip_29SF
	.byte "29SF0x0",0

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

;read_manufacturer_29SF
;	sta D500,x ; x=0 or $40 else will read wrong
;	lda $a000
;	rts

;read_product_29SF
;	sta D500,x ; x=0 or $40 else will read wrong
;	lda $a001
;	rts

softid_exit_29SF
	sta D500,x ; x=0 or $40 else will read wrong
	lda #$f0
	sta $a000
	rts


softid_entry_29SF
	lda #$90
	bne flashoppreamble_acc_29SF

