TRIGGER_FORMAT_28SF	equ $30
C_FORMAT_28SF		equ $30
C_BYTE_PROG_28SF	equ $10
flashoppreamble
	pha
	lda #C_BYTE_PROG_28SF
	scc
	lda #C_FORMAT_28SF ; only if c set
flashoppreamble_acc ; 28SF0x0
	sta $d500,x ; can be any address
	sta $a000; command: FORMAT/ID_MODE/BYTE_PROG, any address
	rts
flash_unlockchip
	sta $D500,x
	; read from 1823H, 1820H, 1822H, 0418H, 041BH, 0419H, 041AH
	lda $B823
	lda $B820
	lda $B822
	lda $A418
	lda $A41B
	lda $A419
	lda $A41A
	rts
