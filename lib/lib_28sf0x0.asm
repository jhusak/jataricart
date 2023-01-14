C_FORMAT_28SF		equ $30
C_BYTE_PROG_28SF	equ $10
M_SSIZE_28SF	equ $0100 ; sector size
;
M_VECTORS_28SF
	jmp softid_entry_28SF
	jmp softid_exit_28SF
	jmp flashoppreamble_28SF
	jmp flash_lockchip_28SF
	jmp flash_unlockchip_28SF
	jmp flash_wait_unit_28SF
	dta c'28SF0x0',0

flashoppreamble_28SF
	lda #C_BYTE_PROG_28SF
	bcc flashoppreamble_acc_28SF
	jsr flash_unlockchip_28SF
	lda #C_FORMAT_28SF ; only if c set
	sta $d500,x ; can be any address
	sta $a000; command select: FORMAT/ID_MODE/BYTE_PROG, any address
	sta $a000; command commit: FORMAT/ID_MODE/BYTE_PROG, any address
	rts
flashoppreamble_acc_28SF ; 28SF0x0
	sta $d500,x
	sta $a000
flash_wait_unit_28SF
	rts
;read_manufacturer_28SF
;	sta $D500,x ; x=0 or $40 else will read wrong
;	lda $a000
;	rts
;read_product_28SF
;	sta $D500,x ; x=0 or $40 else will read wrong
;	lda $a001
;	rts

flash_unlockchip_28SF
	sta $D500,x ; x =0 or $40, else will not unlock
	; read from 1823H, 1820H, 1822H, 0418H, 041BH, 0419H, 041AH
	jsr flash_lock_preamb_28SF
	lda	$A41A
	rts

softid_entry_28SF
	lda #$90
	sta $a000
	rts

softid_exit_28SF
	lda #$ff
	sta $a000
	rts
	
flash_lockchip_28SF
	sta $D500,x ; x =0 or $40, else will not unlock
	jsr flash_lock_preamb_28SF
	lda	$a40A
	rts

flash_lock_preamb_28SF
	lda $B823
	lda $B820
	lda $B822
	lda $A418
	lda $A41B
	lda $A419
	rts
