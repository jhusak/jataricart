Umieść plik z wybranego katalogu na dysku, w pliku atr lub po prostu skopiuj i uruchom z sio2sd lub innego urządzenia, które pozwala na uruchomienie plików wykonywalnych. Uruchom komputer z wciśniętym OPTION. Wtedy albo:
1. komputer się uruchomi i pozwoli wczytać flasher,
albo
2. uruchomi się kartridż.
W drugim przypadku, należy trzymając OPTION po kilka-kilkanaście razy kilka razy na sekundę wciskać klawisz RESET, aż zadziała tzw. błąd resetu i komputer zbootuje się na zimno i pozwoli wczytać flasher. Jeśli na kartridżu jest coś nagrane, to w zależności co, można:
* jeśli masz system QMEG, to możesz pominąć inicjalizację kartridża przez RESET-SELECT.
* jeśli jest nagrane coś, co wyłącza kartridż, należy poczekać do tego momentu, następnie wcisnąć reset lub wykorzystać błąd reset.
* kartridże z językami programowania pozwalają systemowi bootować się, więc nie ma problemu
* jeśli jest nagrane coś, co kartridża nie wyłącza, należy próbować wykorzystać błąd reset, a w ostateczności, jak nijak nie idzie, włożyć dokładnie i poziomo stanowczym ruchem włożyć kartridż po uruchomieniu flashera, gdy prosi on o włożenie kartridża.  Jednak grozi to uszkodzeniem komputera (mała szansa ale jednak). JatariCart ma najbardziej wystający pin masy i wsunięty pin 5V, więc przy równym wsuwaniu kartridża najpierw łączy masa, potem wszystkie piny z wyjątkiem zasilania, a na końcu zasilanie.
* wykorzystać przejściówkę - rozgałęziacz kartridży, np. ten od toriego na 4 sztuki.

Gdy wszystko pójdzie dobrze, pojawi się menu:

	Press:
	START  - format cart and programm
	OPTION - verify only

Wybierz START.

Po kilku(nastu,dziesięciu) popikiwaniach i przerwach flasher kończy pracę:

	Finished.
	
__NIE PRZERYWAJ PRACY PODCZAS FLASHOWANIA!!! (tzn. gdy flasher nie odczytuje z dysku, a zapisuje do kartridża)__
Można to zrobić podczas czytania danych z pliku.

Aby wygenerować flasher (plik .xex) należy wejść do wybranego katalogu i wykonać ../makeflashwrite.sh lub z katalogu various_flashers wywołać ./makeflashwrite.sh <katalog>


--------------------------------------------------------------------------------------------------------------------- 

EN:

Please put the file from chosen catalog on some disk, atr file or simply copy and run from sio2sd or another device which allows running executables.
Turn on your Atari with OPTION. Then one of two cases will occur:
1. computer boots up from device and runs flasher,
2. the cartridge will run.
In the second case, holding OPTION press several times in series (a few presses per second) RESET key untill so-called reset bug will occur and computer will boot up and let run the flasher. If there is something recorded on the cartridge, depending on what, you can:
* if there is something recorded that disables the cartridge, wait until then, then press reset or use the reset error.
* if there is something recorded, that does not disable the cartridge, try to use the reset error, and as a last resort, if nothing works, insert the cartridge firmly, horizontally in one move, when the flasher asks you to insert the cartridge (however, you risk in computer damage, a little, but...). The pins in JatariCart are arranged in the way that the mass pin is the longest and VCC 5V pin is the shortest, so first the ground is connected, then all pins but 5V, and the 5V at the very end.
* Use an adapter - cartridge splitter, for example the one from tori for 4 pieces.

When all is ok, the menu will appear:

	Press:
	START  - format cart and programm
	OPTION - verify only

Choose your option (START will be good)

After some beeps and pauses the flasher finishes it's job:

	Finished.

__DO NOT BREAK THE JOB DURING FLASHING!!! (ie when flasher does not read from the disk, but writes to it)__
You are free to do it during read from device.

To generate flasher (.xex file) go to chosen catalog and run: ../makeflashwrite.sh or from various_flashers catalog ./makeflashwrite.sh <thecatalog>
