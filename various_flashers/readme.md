Please put those file on disk, or on atr file or simply copy and run from sio2sd or another device which allows running executables.
Run flasher _WITH_ BASIC enabled (there is a need to run with MEMTOP set as $A000)
When program says:

	Insert Cartridge

put the cartridge into cart slot gently.

When all is ok, the menu will appear:

	Press:
	START  - format cart and programm
	SELECT - verify; repair bad blocks.
	OPTION - verify only

Choose your option (START will be good)

After some beeps and pauses the flasher finishes it's job.

	Finished.

__Warning: for now action and mac65 flashers do write some ! (that means bad compare) - please ignore it for skipped banks; the important ones are 0,3 and 4 banks (this will be cleared in the future)__