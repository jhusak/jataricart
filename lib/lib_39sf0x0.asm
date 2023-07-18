TRIGGER_CHIPFORMAT_39SF equ $10
TRIGGER_SECTORFORMAT_39SF equ $30
C_FORMAT_39SF	equ $80
C_BYTE_PROG_39SF	equ $a0
M_SSIZE_39SF	equ $10 ; sector size

M_VECTORS_39SF
	jmp softid_entry_39SF
	jmp softid_exit_39SF
	jmp flash_formatchip_39SF
	jmp flash_formatsector_39SF
	jmp flash_writebytepreamble_39SF
	jmp flash_lockchip_39SF
	jmp flash_unlockchip_39SF
	jmp flash_wait_unit_39SF
	dta M_SSIZE_39SF
	dta c'39SF0x0',0

flash_writebytepreamble_39SF
	lda #C_BYTE_PROG_39SF
	bne flashoppreamble_acc_39SF

flash_formatsector_39SF
	lda #TRIGGER_SECTORFORMAT_39SF
	dta {bit.w} ; skip next 2 bytes

; main entry
; c set ->format (either chip or sector)
; c cleared ->byte write
flash_formatchip_39SF ; preserves X
	lda #TRIGGER_CHIPFORMAT_39SF
	sta flash_fmcommand_39SF
	lda #C_FORMAT_39SF ; only if c set
; entry for command in A, mainly for sector format
flashoppreamble_acc_39SF ; 39sf0x0, 29F040
	sta command_39SF
	stx flash_format_storex_39SF
	txa
	; when write byte x must be set to either 0 or 40 temporarily
	and #$40
	tax
	sta $d502,x
	mva #$aa $b555 ; $5555<$aa
	sta $d501,x
	mva #$55 $aaaa ; $2aaa<$55
	; $5555<$80
	sta $d502,x
	mva command_39SF:#0 $b555; will become command: FORMAT/ID_MODE/BYTE_PROG
	cmp #C_FORMAT_39SF
	bne flash_format_39SF_exit ; if not FORMAT, procedure finishes
	; FORMAT part, more to write
	sta $d502,x
	mva #$aa $b555 ; $5555<$aa
	sta $d501,x
	mva #$55 $aaaa ; $2aaa<$55
	sta $d502,x
	lda flash_fmcommand_39SF:#TRIGGER_CHIPFORMAT_39SF
	cmp #TRIGGER_CHIPFORMAT_39SF
	sne
	sta $b555 ; $5555<$10
flash_format_39SF_exit
	ldx flash_format_storex_39SF:#0
	sta $d500,x
flash_lockchip_39SF
flash_unlockchip_39SF
flash_wait_unit_39SF
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

