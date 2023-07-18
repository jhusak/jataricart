TRIGGER_CHIPFORMAT_29F equ $10
TRIGGER_SECTORFORMAT_29F equ $30
C_FORMAT_29F	equ $80
C_BYTE_PROG_29F	equ $a0
M_SSIZE_29F	equ <$100 ; sector size; MAXFlash

M_VECTORS_29F
	jmp softid_entry_29F
	jmp softid_exit_29F
	jmp flash_formatchip_29F
	jmp flash_formatsector_29F
	jmp flash_writebytepreamble_29F
	jmp flash_lockchip_29F
	jmp flash_unlockchip_29F
	jmp flash_wait_unit_29F
	dta M_SSIZE_29F
	dta c'29F0x0',0

flash_writebytepreamble_29F
	lda #C_BYTE_PROG_29F
	bne flashoppreamble_acc_29F

flash_formatsector_29F
	lda #TRIGGER_SECTORFORMAT_29F
	dta {bit.w} ; skip next 2 bytes

; main entry
; c set ->format (either chip or sector)
; c cleared ->byte write
flash_formatchip_29F
	lda #TRIGGER_CHIPFORMAT_29F
	sta flash_fmcommand_29F
	lda #C_FORMAT_29F
; entry for command in A, mainly for sector format
flashoppreamble_acc_29F ; 29F040
	sta command_29F
	stx flash_format_storex_29F
	txa
	; when write byte x must be set to either 0 or 40 temporarily
	and #$40
	tax
	sta $d500,x
	mva #$aa $a555 ; $555<$aa
	mva #$55 $a2aa ; $2aa<$55
	; $555<$80 or $A0
	mva command_29F:#0 $a555; will become command: FORMAT/ID_MODE/BYTE_PROG
	cmp #C_FORMAT_29F
	bne flash_format_exit_29F ; if not FORMAT, procedure finishes
	; FORMAT part, more to write
	mva #$aa $a555 ; $555<$aa
	mva #$55 $a2aa ; $2aa<$55
	lda flash_fmcommand_29F:#TRIGGER_CHIPFORMAT_29F
	cmp #TRIGGER_CHIPFORMAT_29F
	sne
	sta $a555 ; $555<$10
flash_format_exit_29F
	ldx flash_format_storex_29F:#0
	sta $d500,x
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

