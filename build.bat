@echo off
asm68k /o op+ /o os+ /o ow+ /o oz+ /o oaq+ /o osq+ /o omq+ /p /o ae- sonic1.asm, s1built.bin, sonic1.sym, sonic1.lst
convsym sonic1.sym sonic1.symcmp
copy /B s1built.bin+sonic1.symcmp s1built.bin /Y
del sonic1.symcmp
pause

"_Assembly Tools\AS\asl.exe" -q -cpu Z80 -gnuerrors -c -A -L -xx "Dual PCM\Z80.asm"
"_Assembly Tools\AS\p2bin.exe" "Dual PCM\Z80.p" "Dual PCM\Z80.bin" -r 0x-0x

"_Assembly Tools\ListEqu.exe" AS z80 "Dual PCM\Z80.lst" asm68k 68k "Equz80.asm"
DEL "Dual PCM\Z80.lst"

IF NOT EXIST "Dual PCM\Z80.p" goto Error
CLS
DEL "Dual PCM\Z80.p"
DEL "Dual PCM\Z80.h"

"_Assembly Tools\Asm68k.exe" /o op+ /o os+ /o ow+ /o oz+ /o oaq+ /o osq+ /o omq+ /q /p /o ae- "sonic1.asm", "s1built.bin"
"_Assembly Tools\CheckFix.exe" "s1built.bin"

:Error