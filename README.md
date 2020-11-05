# J(atari)Cart(256)kB J(atari)Cart1MB

This software is for use with my super simple flash cartridge (look into eagle catalog; no gals, only 3 74xx elements and some caps and resistors). Top side is that without elements.

The cartridge is driven by addresses D500-D580; write to D500 sets the first bank - this is default boot bank. Write to D501 sets second bank etc. The max bank is set by write to D57F; write to D580 switches off the cartridge. The banks will overlap if there are less them than 128 (128 for 1MB cartridge)

Current Atari-programmable flashes are from family 39SF0x0; For 256 KB JatariCart 39SF010 will act as 128KB cartridge, 39SF020 and 39SF040 will act as 256kB cartridge. Memories used are Flash/PROM families.
For Jataricart1MB there are a lot more possibilities, because of two memory chip sockets. In first socket you can place 27c0x0 prom for read only memory (there is no possibility to program it by Atari machine, you must use external prom programmer) or flash for read-write memory. Also, in second socket you can place either flash or prom read only memory. Or nothing. The first memory can be hardware write-protected, when you want to have rom functionality in first half, but use flash memories. There is no such feature for second memory chip (always possible read/write when flash chip used).

However and ever, you can sit two 39SF040 flash chips to have 1 MB of flash memory, almost fully compatible with Atari MaxFlash Cartridges (Space Harrier fully supported!), always first boot bank, remember?

So, in summary:
- first chip can be hardware write-protected even if flash installed,
- second nope;
- both chips can be totally different.
- most 28x, 29x, 39x family work, but for now flashing software is prepared to work with 39sf0x0 memories, 28sf0x0 is in progress.

The internal construction of JatariCart256kB allows utilize max 256kB of flash memory (32 banks) or of course PROM/EPROM memory.
The memory package is plcc32. It is better to use 39sf020 memory, because sectors are 4096 bytes long, so it is easier to manage writing data (instead of four 64kB sectors)

Flash memory can be programmed/flashed from Atari platform by flasher application, which you can find in "flashwriteexample" catalog.
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

after each access. This will let the system think as cartridge never was switched/removed/inserted. Of course it is better (more convenient) that there is no display list, video memory and no interrupts in the area a000-bfff, which can lead to problems when bank swapping.

## Files and descriptions:

flashwritelib.asx - 6502 code library for formatting flash/formatting sector and write byte.

flashwrite.asx - 6502 code for generate flasher (when compiled, it contains either flash routines and cartridge image itself)

crc16_v2.asm - crc16 library for fast checking every sector (when flash is damaged, sometimes it happens that write sector damages another)

Compile (mads needed, http://mads.atari8.info):

mads flashwrite.asx -o:flashwrite.xex

__Warning: flasher works properly on stock Atari. There were reports that Ultimate 1MB makes problems, so may not other extensions/SO roms. This will change in the near future.__
