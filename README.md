# J(atari)Cart(256)

This software is for use with my super simple flash cartridge (look into eagle catalog; no gals, only 3 74xx elements and some caps and resistors). Top side is that without elements.

The cartridge is driven by addresses D500-D580; write to D500 sets the first bank - this is default boot bank. Write to D501 sets second bank etc. The max usable number with cart on is set by write to D51F; write to D580 switches off the cartridge.

The internal construction of JatariCart allows utilise max 256kB of flash memory (32 banks) or of course PROM/EPROM memory.
The memory package is plcc32. It is better to use 39sf020 memory, because sectors are 4096 bytes long, so it is easier to manage writing data (instead of four 64kB sectors)

Flash memory can be programmed/flashed from Atari platform by flasher application, wchich you can find in "flashwriteexample" catalog.
The flasher must be (for now) preassembled using mads assembler with proper rom file included bank by bank (the flasher source does it by itself).

If you want to write your own cartridge access, remember to fool the Operating System not to hang up by cart on/off, by:

```
carton (x - bank to switch) 
        pha 
	sei
        sta $D500,x
        sta wsync ; needed for ntsc, no big difference in speed 
        sta wsync ; needed for ntsc 
        lda trig3 
        sta gintlk 
	cli
        pla 
        rts  
```

after each access. This will let the system think as cartridge never was switched/removed/inserted. Of course it is better (much better, obligue) that there is no display list, video memory and no interrupts in the area a000-bfff, which can be anything when bank swapping.

## Files and descriptions:

flashwritelib.asx - 6502 code library for formatting flash/formatting sector and write byte.

flashwrite.asx - 6502 code for generate flasher (when compiled, it contains either flash routines and cartridge image itself)

crc16_v2.asm - crc16 library for fast checking every sector (when flash is damaged, sometimes it happens that write sector damages another)

Compile (mads needed, http://mads.atari8.info):

mads flashwrite.asx -o:flashwrite.xex

__Warning: flasher works properly on stock Atari. There were reports that Ultimate 1MB makes problems, so may not other extensions/SO roms. This will change in the near future.__

