@echo off

setlocal

rem ****************************************************************
rem ********************** PREPARING ENVIRONMENT *******************
rem ****************************************************************

set MDrive=%~d0
set MDrive=%MDrive:~0,1%
set MPath=/%MDrive%%~p0devkit
set MPath=%MPath:\=/%

%~d0
cd %~dp0
set DEVKITARM=%MPath%/devkitARM
set DEVKITPRO=%MPath%
path %~dp0DevKit\msys\bin;%~dp0\fb25;%~dp0DevKit\devkitARM\bin;%path%

rem **************************** STEP 1 ****************************
rem ******  COMPILING WITH FREEBASIC ONLY TO RESOLVE MACROS ********
rem ****************************************************************

fbc -target linux -d __fb_NDS__=1 -pp -nodeflibs -i %~dp0 -i %~dp0fbhead -gen gcc "%1"
if errorlevel 1 goto DoneError

rem **************************** STEP 2 ****************************
rem ****** CALLING PREPROCESSOR TO RESOLVE INLINE ASM ISSUES *******
rem ****************************************************************

Preprocessor "%~dpn1.pp.bas"
if exist "%~dpn1.pp.bas" del "%~dpn1.pp.bas"

rem ***************************** STEP 3 ***************************
rem *********** NOW GENERATING A main.c FILE WITH -GEN GCC *********
rem ****************************************************************

fbc -target linux -r -nodeflibs -i %~dp0 -i %~dp0fbhead -gen gcc main.bas
if exist main.bas del main.bas

rem echo before processor
rem pause > nul

rem ***************************** STEP 4 ***************************
rem ** CALLING C PROCESSOR FOR COMPATIBILITY AND INLINE FUNCTIONS **
rem ****************************************************************
cprocessor "main.c"

rem echo after processor
rem pause > nul

rem ***************************** STEP 5 ***************************
rem ***** COPYING FILES TO SOURCE AND GENERATE FBGFX FONT FILE *****
rem *** THEN EXECUTING THE DEVKITPRO MAKEFILE TO CREATE THE .NDS ***

md source >nul 2>&1
move "main.c" source\main.c
md data >nul 2>&1
copy modules\*.tex data\ >nul 2>&1
rem pause >nul
make --quiet -j

if errorlevel 1 goto DoneError

call :DoRename . "%~n1.nds"
if exist "%~n1.elf" del "%~n1.elf" >nul

rem ****************************************************************
rem ******************** STEP 6 - CLEAN UP OR ERROR ****************
rem ****************************************************************

make clean
rem del /s /q source >nul
rem rd source >nul
echo done.
goto Done

:DoRename
if "%~n1.nds"==%2 goto :Eof
echo Renaming
if exist %2 del %2 >nul
rename "%~n1.nds" %2
goto :eof

:DoneError
del "%~n1.pp.bas" >nul
rem if exist "%~n1.c" del "%~n1.c" >nul
:Done
pause >nul

endlocal

