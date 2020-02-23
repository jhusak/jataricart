# JatariCart

This software is for use with my super simple flash cartridge (no gals, only 3 74xx elements and some caps and resistors). Top side is that without elements.

The cartridge is driven by addresses D500-D580; write to D500 sets the first bank - this is boot bank. Write to D501 sets second bank etc. The max usable number with cart on is set by write to D51F; write to D580 switches off the cartridge.

The internal construction of JatariCart allows utilise max 256kB of flash memory (32 banks)

Remember to fool the Operating System not to hang up by cart on/off, by:

carton (x - bank to switch) 
        pha 
        sta $D580,x
        sta wsync ; needed for ntsc, no big difference in speed 
        sta wsync ; needed for ntsc 
        lda trig3 
        sta gintlk 
        pla 
        rts  



flashwritelib.asx - 6502 code library for formatting flash/formatting sector and write byte.

flashsrite.asx - 6502 code for generate flasher (when compiled, it contains either flash routines and cartridge image itself)

crc16_v2.asm - crc16 library for fast checking every sector (when flash is damaged, it happens that write sector damages another)

Compile (mads needed, http://mads.atari8.info):

mads flashwrite.asx -o:flashwrite.xex
