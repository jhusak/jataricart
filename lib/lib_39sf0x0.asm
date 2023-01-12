TRIGGER_FORMAT_39SF equ $10
C_FORMAT_39SF	equ $80
C_BYTE_PROG_39SF	equ $a0
M_SSIZE_39SF	equ $1000 ; sector size
command_ZP_39SF	=	$f0

M_VECTORS_39SF
	jmp softid_entry_39SF
	jmp softid_exit_39SF
	jmp flashoppreamble_39SF
	jmp flash_lockchip_39SF
	jmp flash_unlockchip_39SF
	dta c'39SF0x0',0

flashoppreamble_39SF
	pha
	lda #C_BYTE_PROG_39SF
	scc
	lda #C_FORMAT_39SF ; only if c set
	sta command_ZP_39SF
	pla
	.byte {bit.w}
flashoppreamble_acc_39SF ; 39sf0x0, 29F040
	sta command_ZP_39SF
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
	mva command_ZP_39SF $b555; will become command: FORMAT/ID_MODE/BYTE_PROG
	cmp #C_FORMAT_39SF
	bne @+ ; if not FORMAT, procedure finishes
	; FORMAT part, more to write
	sta $d502,x
	mva #$aa $b555 ; $5555<$aa
	sta $d501,x
	mva #$55 $aaaa ; $2aaa<$55
	sta $d502,x
	mva #$10 $b555 ; $5555<$10
@	pla
	tax
flash_lockchip_39SF
flash_unlockchip_39SF
	rts

;read_manufacturer_39SF
;	sta $D500,x ; x=0 or $40 else will read wrong
;	lda $a000
;	rts

;read_product_39SF
;	sta $D500,x ; x=0 or $40 else will read wrong
;	lda $a001
;	rts

softid_exit_39SF
	sta $D500,x ; x=0 or $40 else will read wrong
	lda #$f0
	sta $a000
	rts


softid_entry_39SF
	lda #$90
	bne flashoppreamble_acc_39SF

