C_CHIPFORMAT_28SF		equ $30
C_SECTORFORMAT_28SF		equ $D0
C_BYTE_PROG_28SF	equ $10
M_SSIZE_28SF	equ $01 ; sector size
;
M_VECTORS_28SF
	jmp softid_entry_28SF
	jmp softid_exit_28SF
	jmp flash_formatchip_28SF
	jmp flash_formatsector_28SF
	jmp flash_writebytepreamble_28SF
	jmp flash_lockchip_28SF
	jmp flash_unlockchip_28SF
	jmp flash_wait_unit_28SF
	dta M_SSIZE_28SF
	dta c'28SF0x0',0

; entry for command in A, mainly for sector format
flash_formatsector_28SF ; 28SF0x0
	jsr flash_unlockchip_28SF
	sta $d500,x ; can be any address
	lda #$20
	sta $a000; command select: FORMATSECTOR/ID_MODE, any address
	lda #C_SECTORFORMAT_28SF
	; sta in proper address done level up
	; only address in range a000-bfff,calculated by $80 bytesize page number 0-3f
	rts

flash_writebytepreamble_28SF
	; chip should be unlocked to work;
	; it is done during format
	; or manually
	lda #C_BYTE_PROG_28SF
	sta $d500,x
	sta $a000
flash_wait_unit_28SF
	rts

; main entry
; c set ->format (either chip or sector)
; c cleared ->byte write
flash_formatchip_28SF
	jsr flash_unlockchip_28SF ; x is 0 or $40, else does not unlock
	lda #C_CHIPFORMAT_28SF ; only if c set
	sta $d500,x ; can be any addres, in any bank
	sta $a000; command select: FORMAT/ID_MODE/BYTE_PROG, any address
	sta $a000; command commit: FORMAT/ID_MODE/BYTE_PROG, any address
	rts
; entry for command in A, mainly for sector format
flashoppreamble_accnotunlock_28SF ; 28SF0x0
;read_manufacturer_28SF
;	sta $D500,x ; x=0 or $40 else will read wrong
;	lda $a000
;	rts
;read_product_28SF
;	sta $D500,x ; x=0 or $40 else will read wrong
;	lda $a001
;	rts

flash_unlockchip_28SF
	txa
	pha
	and #$40
	tax
	sta $D500,x ; x =0 or $40, else will not unlock
	; read from 1823H, 1820H, 1822H, 0418H, 041BH, 0419H, 041AH
	jsr flash_lock_preamb_28SF
	lda	$A41A
	pla
	tax
	rts

softid_entry_28SF
	lda #$90
	dta {bit.w}

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
