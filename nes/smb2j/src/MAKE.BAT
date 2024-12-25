asm6 -l bank0
asm6 -l bank1
asm6 -l bank2
asm6 -l bank3
asm6 -l 6000
asm6 -l e000
copy /b hdr+bank0.bin+bank1.bin+bank2.bin+bank3.bin+6000.bin+e000.bin+chr0+chr1 temp.nes
split temp.nes
copy /b temp.4+temp.6+temp.0+temp.1+temp.2+temp.3+temp.5+temp.7 temp.prg
copy /b temp.hdr+temp.prg+temp.chr smb2j.nes
rem del temp.*
