@echo off
rem SET PATH=%PATH%;C:\rgbds



IF EXIST .\dr_mario_dx.gb del .\dr_mario_dx.gb

:begin
set assemble=1
echo assembling...
rgbasm -o"dr_mario_dx.obj" src_dr_mario_dx/dr_mario_dx.asm
if errorlevel 1 goto error
echo linking...
REM -n generates a sym file with subroutines name and offsets for debugger
rgblink -o./dr_mario_dx.gb -O./src_dr_mario_dx/dr_mario.gb -n./dr_mario_dx.sym dr_mario_dx.obj 
if errorlevel 1 goto error
echo fixing...
rgbfix -p0 -v ./dr_mario_dx.gb
del dr_mario_dx.obj
goto end
:error
pause
:end
