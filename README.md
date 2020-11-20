# J(atari)Cart256(kB) J(atari)Cart1024(kB)

__The cartridge projest is on heavy development state. Please expect frequent changes.__

This software is for use with my super simple flash cartridge (look into eagle catalog; no gals, only 3 74xx elements and some caps and resistors). Top side is that without elements. The purpose is wide-use, especially for commercially published games, because of tiny price.

The banking scheme was chosen because it is very simple to handle with 3 raw TTL chips (and two double diodes acting as triple "or" gate in version 1MB). There is probably no simplier scheme, either in application or in handling by 6502 (only one instruction needed to change bank)

The cartridge is driven by addresses D500-D580; write to D500 sets the first bank - this is default boot bank. Write to D501 sets second bank etc. The max bank is set by write to D57F; write to D580 switches off the cartridge. The banks will overlap if there are less of them than 128.

Current Atari-programmable flashes are from family 39SF0x0; For 256 KB JatariCart 39SF010 memory chip will act as 128KB cartridge, 39SF020 and 39SF040 will act as 256kB cartridge. Memories used are Flash/PROM families.
For Jataricart1MB there are a lot more possibilities, because of two memory chip sockets available. In first socket you can place 27c0x0 prom for read only memory (then there is no possibility to program it by Atari machine, you must use external prom programmer) or flash for read-write memory. In second socket you can place either flash or prom read only memory as well. Or nothing. The first (boot) memory can be hardware write-protected, when you want to have rom functionality in first half, but wnat to use flash memories. There is no such feature for second memory chip (always possible read/write when flash chip used).

However and ever, you can sit two 39SF040 flash chips to have 1 MB of flash memory, (almost: old MaxFlash booting from last bank) fully (Maxflash newer, boot bank 0) compatible with Atari MaxFlash Cartridges (Space Harrier fully supported!), always first boot bank, remember?

Summary:
- first chip can be hardware write-protected even if flash installed (JCart1024)
- second has no hardware write protection (JCart1024)
- both chips can be totally different (JCart1024)
- most 28x, 29x, 39x family work, but for now flashing software is prepared to work with 39sf0x0 memories, 28sf0x0 is in progress.

The internal construction of JatariCart256kB allows utilize max 256kB of flash memory (32 banks) of PROM/EPROM memory.
The internal construction of JatariCart1MB allows utilize max 1MB of flash memory (128 banks) of PROM/EPROM memory.
The memory package is plcc32. It is better to use "xxSFxxx" memory, because sectors are <=4096 bytes long, so it is easier to manage writing data (instead of 64kB sectors when xxFxxx memory used)

Flash memory can be programmed/flashed from Atari platform by flasher application, which you can find in "flashwriteexample" catalog.
The flasher must be (for now) assembled using mads assembler with proper rom file provded/included in source.

If you want to write your own cartridge access, remember to fool the Operating System not to hang up by cart on/off, by:

```
carton (x - bank to switch) 
        pha 
	sei
        sta $D500,x
        sta wsync ; needed for some TV systems, no big difference in speed, may be skipped
        sta wsync ; needed for some TV systems, no big difference in speed, may be skipped
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

__The JCart256/1024 is compatible with Atari MaxFlash 8megabits cartridge regarding banking scheme, but MaxFlash flashing software does not recognize the JCart256/1024 cartidge.__

__Warning: flasher works properly on stock Atari. There were reports that Ultimate 1MB makes problems, so may not other extensions/SO roms. This will change in the near future.__

