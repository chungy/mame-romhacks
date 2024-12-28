Dr. Mario DX Hack
by Marc Robledo (Twitter: @marc_robledo) 2019-2020


About
-----
This is my first ASM hack ever done.
It colorizes one of the very first Game Boy games, enjoy :-)

It's been a nightmare, mostly because it's a 32kb non-MBC game, which means I had to add a MBC
in order to have enough space for the new subroutines. However, I also had to add a lot of bank
switching because there is almost no free space in the ROM.
An important part of the vblank interrupt code resides now in RAM, because it was the easiest
way I found to lengthen it without having to mess with bank switching.

Sourcecode is included just in case someone wants to take a look.


ROM needed
----------
Dr. Mario (World) (Rev 1).gb
CRC32: f0225dd0
MD5: 921bdff008475aa2c5344e1a0d110910


Credits
-------
Thanks to Da_GPer for the graphics edits!




How to compile
--------------
You need RGBDS: https://github.com/rednex/rgbds/
Place your Dr. Mario (World) (Rev 1).gb ROM in src_dr_mario_dx as dr_mario.gb
and run assemble_dr_mario_dx.bat if you are in Windows.