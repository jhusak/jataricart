TRIGGER_FORMAT_29F equ $10
C_FORMAT_29F	equ $80
C_BYTE_PROG_29F	equ $a0
M_SSIZE_29F	equ $10000 ; sector size; MAXFlash
command_ZP_29F	=	$f0

M_VECTORS_29F
	jmp softid_entry_29F
	jmp softid_exit_29F
	jmp flashoppreamble_29F
	jmp flash_lockchip_29F
	jmp flash_unlockchip_29F
	jmp flash_wait_unit_29F
	dta c'29F0x0',0

flashoppreamble_29F
	pha
	lda #C_BYTE_PROG_29F
	scc
	lda #C_FORMAT_29F ; only if c set
	sta command_ZP_29F
	pla
	.byte {bit.w}
flashoppreamble_acc_29F ; 29F040
	sta command_ZP_29F
	txa
	pha
	; when write byte x must be set to either 0 or 40 temporarily
	and #$40
	tax
	sta $d500,x
	mva #$aa $a555 ; $555<$aa
	mva #$55 $a2aa ; $2aa<$55
	; $555<$80 or $A0
	mva command_ZP_29F $a555; will become command: FORMAT/ID_MODE/BYTE_PROG
	cmp #C_FORMAT_29F
	bne @+ ; if not FORMAT, procedure finishes
	; FORMAT part, more to write
	mva #$aa $a555 ; $555<$aa
	mva #$55 $a2aa ; $2aa<$55
	mva #TRIGGER_FORMAT_29F $a555 ; $555<$10
@	pla
	tax
flash_lockchip_29F
flash_unlockchip_29F
	rts

flash_wait_unit_29F
	bit VCOUNT
	bmi *-3
	bit VCOUNT
	bpl *-3
	bit VCOUNT
	bmi *-3
	bit VCOUNT
	bpl *-3
	rts

;read_manufacturer_29F
;	sta $D500,x ; x=0 or $40 else will read wrong
;	lda $a000
;	rts

;read_product_29F
;	sta $D500,x ; x=0 or $40 else will read wrong
;	lda $a001
;	rts


softid_exit_29F
	sta $D500,x ; x=0 or $40 else will read wrong
	lda #$f0
	sta $a000
	rts

softid_entry_29F
	lda #$90
	bne flashoppreamble_acc_29F

