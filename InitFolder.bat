@echo off
rem --- change this to the correct root folder of the framework in your computer ---
rem --- yeah the folder where this InitFolder.bas is originally ---
rem --- NO SPACES PLEASE! ---
set FrameWorkFolder=G:\fbc\freebasicNDSi
rem -------------------------

if not exist %FrameWorkFolder%\Makefile (
  echo Must edit this file to set FrameWorkFolder to the correct framework folder  
  goto :done
)

cd /d %~dp0

if exist Cprocessor.bas (
  echo Copy this InitFolder.bat to an empty folder and run launch it there create a new project.
  echo But please make sure the path wont have spaces on along it!
  goto :done
)  
if exist Makefile (
  echo Folder is already ready? 
  goto :done
)

mklink Cprocessor.exe %FrameWorkFolder%\Cprocessor.exe >nul
if errorlevel 1 (
  echo cannot create folder links... ^(not running elevated maybe?^)
  goto :done
)

attrib /L +h +s Cprocessor.exe
mklink Preprocessor.exe %FrameWorkFolder%\Preprocessor.exe >nul
attrib /L +h +s Preprocessor.exe
mklink Makefile %FrameWorkFolder%\Makefile >nul
attrib /L +h +s Makefile
copy %FrameWorkFolder%\Drag_Bas_Here_To_Compile.bat .\ >nul
mklink /d Data %FrameWorkFolder%\Data >nul
attrib /L +h +s Data 
mklink /d DevKit %FrameWorkFolder%\DevKit >nul
attrib /L +h +s DevKit
mklink /d Modules %FrameWorkFolder%\Modules >nul
attrib /L +h +s Modules
mklink /d fbhead %FrameWorkFolder%\fbhead >nul
attrib /L +h +s fbhead
mklink /d fb25 %FrameWorkFolder%\fb25 >nul
attrib /L +h +s fb25
mkdir Source
attrib /L +h +s Source
mkdir NitroFiles
echo.>NitroFiles\PutYourFilesHere
copy %FrameWorkFolder%\CrossExample.bas .\ >nul
copy %FrameWorkFolder%\CrossConfig.bi .\ >nul
echo Folder is ready for a project now...


del InitFolder.bat

:done
pause >nul

