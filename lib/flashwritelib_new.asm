; flash eeprom library
; by JHusak , 04.01.2020
; free to use.

	icl "lib_28sf0x0.asm"
	icl "lib_29f0x0.asm"
	icl "lib_29sf0x0.asm"
	icl "lib_39sf0x0.asm"

; CONSTANTS
m_offsets
	softid_entry	=	0
	softid_exit	=	3
	flashoppreamble	=	6
	flash_lockchip	=	9
	flash_unlockchip	=	12

; rw section, may be moved to ZP if needed
M_VECTOR	.word 0
tmpa		.byte 0
m_vendor	.byte 0
m_kind		.byte 0
m_iter		.byte 0

; ro section again

M_CHECK_VECS	.word M_VECTORS_28SF, M_VECTORS_29F, M_VECTORS_29SF, M_VECTORS_39SF
;Problems with writing:
; - check flash presence
; - flash protocol
; - size of flash 1,2
; - size of sector in some cases
; - number of flashes (easy, they do not overlap)
; All can be read by erasing memory, writing several bytes and reading them
; For flash recognition
; - format,
; - write 128 kbytes, read more -> if not ff, flash is 128k
; - write additional 128KB, read more ->if not ff flash is 256kB, else is 512kb
; 
; First detection is to read raw memory and id and compare results. Some issues may occur when no memory inserted.

;flash_detect_protocol:
;	lda #ID_MODE
;	jsr flashoppreamble_5555_2aaa

; c parameter as format/writebyte
; for compatibility, 5555_2aaa only

; --------------------------
; PROCEDURE
; x = 0 or 0x40 - flash chip address.
; stores proper vector table pointer if worked
; this fails only when somebody stores vendor and product bytes
; at the proper cells.
;
; then in the code we call lda #offset/jsr jsrtoproc
check_type
	ldy #0-2
?again
	; store default values
	sta $d500,x
	lda $a000
	sta m_vendor
	lda $a001
	sta m_kind
	
	iny
	iny
	sty m_iter

	jsr jsrtosoftidentry

	sta $d500,x
	lda $a000 ; vendor
	cmp m_vendor
	bne OK
	lda $a001 ; id
	cmp m_kind
	bne ?OK

	ldy	m_iter
	cpy	#$6
	bne	?again
	; error
	sec
	rts
?OK
	lda	M_CHECK_VECS+1,y
	sta	M_VECTORS+1
	lda	M_CHECK_VECS,y
	sta	M_VECTORS

	lda	#softid_exit
	jsr	jsrtoproc
	clc
	rts

jsrtosoftidentry
	lda M_CHECK_VECS+1,y ; first is softid entry
	pha
	lda M_CHECK_VECS,y ; first is softid entry
	pha
	php
	rti ; jsr to tabled func
; PROCEDURE
; performs jump to vector table at offset in A provided
; y passed to the procedure called
jsrtoproc
	php ; preserve C
	clc
	adc	M_VECTORS
	sta	tmpa
	lda	M_VECTORS+1
	adc	#0
	plp ; restore C
	pha
	lda	tmpa
	pha
	php
	rti

; --------------------------
flashformatchip2
	ldx #$40
	dta { bit.w }
flashformatchip1
	ldx #$0
; --------------------------
; PROCEDURE
; x = 0 or 0x40 - flash chip address.
flashformatchip

	sei
	stx store_x
	lda #C_FORMAT
	jsr flashoppreamble_acc ; does not touch A
	sta $d502,x
	; !!!!!!!!!!!!!!!!!!! CHECK THIS !!!!!!!!!!!!!!!!!!!!
	lda #TRIGGER_FORMAT
	sta $b555 ; FORMAT HERE TRIGGERED!
	; not needed to mva $ff flashcmp
	jsr wait4flashcheckresult ; waits for format finished
	; then check number of banks for FFs
	lda #$3f ; this depends on flash size, $0f, $1f, $3f
	sta flashformatcounter
flashbankloop	sei
	ldx store_x
flashformatcounter equ*+1
	sta $d5FF,x ; set chip (x) and bank
	; set pages count
	ldy #$20
	; reset address
	lda #$a0
	sta flashformataddrcheck + 2
	; check whole sector against 0xff
	jsr flashchecksectorformatted_bare ; destroys x
	bcs flashformatexit ; format error if c set
	dec flashformatcounter
	bpl flashbankloop
flashformatexit	jmp flashcartoff ; preserves C
store_x	dta 0
	
; --------------------------
; PROCEDURE
flashformatsector
; x - bank number 00 - 7f (even sector>>1)
; a - erase 4KB from $B000 if A=$B0, FROM $A000 IF A=$A0
; format 4kb evensector 
; strange form - easily maps to cartridge banks
; to format bank, must format sector (x<<1) and (x<<1) +1
; IT IS LONG because it has to be save, ie not format if formatted etc.

	; first check if all ff
	; this is to avoid wear
	stx flashformatstorex
	sta flashformatstorea
	sei
	sta $d500,x
	; store #$a0 or #$b0
	sta flashformataddrcheck + 2
	jsr flashchecksectorformatted	
	bcc flashsectorformatgood
	sei
flashformatstorex	equ * + 1
	ldx #0 ; filled before
; check least sector bit

	lda #C_FORMAT
	jsr flashoppreamble_acc ; does not touch A,X
	sta $D500,x
	; A must be either $A0 or $B0
flashformatstorea	equ * + 1
	lda #0 ; filled before
	sta flashtmpaddr+1
	sta flashformataddrcheck + 2

	lda #$30
flashtmpaddr	equ	*+1
	sta $a000 ; SECTOR FORMAT INVOKED HERE!
	jsr wait4flashcheckresult ;
	sei

	lda flashformatstorea
	sta flashformataddrcheck+2
	
	ldx flashformatstorex
	sta $d500,x

	; check if all data in sector is $ff
flashchecksectorformatted
	ldy #$10
flashchecksectorformatted_bare
	lda #$ff
	ldx #0
flashformataddrcheck
	cmp $a000,x
	bne flashsectorformaterror
	inx
	bne flashformataddrcheck
	inc flashformataddrcheck + 2
	dey
	bne flashformataddrcheck
	 
flashsectorformatgood
	jsr flashcartoff
	clc
	rts
	
flashsectorformaterror
	jsr flashcartoff
	sec
	rts


; ---------------------
; PROCEDURE

flashwritebyte

; a - byte to write
; x - 8kb bank to switch, $00 to $7f, also chip select
; flashaddr - addres in flash - must be a000-offset
	; do not programm byte if already good
	sei	
	sta $D500,x ; select bank, chip
	ldy #{ cmp.w }
	jsr flashprocessbyte
	bne byte_differs
	sta $D580
	cli
	clc
	rts
byte_differs
	sta flashcmp
	sei
	pha
	lda #C_BYTE_PROG
	jsr flashoppreamble_acc ; preserves A,X
	pla
	; set right bank
	sta $D500,x
	ldy #{ sta.w }
	jsr flashprocessbyte ; WRITE BYTE INVOKED !

wait4flashcheckresult ; sei mode
	mva #0 flashcnt
	ldy #1 ; first time wait short first turn to speed up byte write.
	bne @+

flashwaitfordone
	; approx 100ms in overall for chip erase:
	; as many cycles needed, as 256*cycles >100ms * (1+epsilon)
	; 100 ms is 180000 cycles
	; so max 256 rough loops must last longer
	; 180000 / 256 = 703
	; 700 cycles by 6 cycles loop lasts = 116.
	; so flipipng values, and adding margin,
	; we count 128*6 cycles in inner loop.
	; max sector erase by datasheet: 25 ms
	; max chip erase by datasheet: 100 ms
	ldy#250
@	dey
	nop
	bne @-
	
@	ldy #{ lda.w }
	jsr flashprocessbyte
	sta flashval
	ldy #{ eor.w }
	jsr flashprocessbyte
	inc flashcnt
	bne @+
		sta $d580
		lda #$ff ; status
		rts
@
	and #$40
	bne flashwaitfordone
	sta $d580
flashval	equ *+1
	lda #0
flashcmp	equ *+1
	cmp #0
; when byte compare non zero = error
	rts

flashcnt
	dta 0
; ----------------------
; PROCEDURE

flashprocessbyte

; y - byteop for cpu to do with byte 
; flashaddr - stored address
	sty flashbyteop
flashaddr	equ *+1
flashbyteop
	sta $aaaa
	rts

flashincaddr
	inw flashaddr
	rts

flashsetaddr
	stx flashaddr
	sty flashaddr+1
	rts

flashcartoff
	pha
	sta $d580
	lda $d013
	sta $3fa
	cli
	pla
	rts

