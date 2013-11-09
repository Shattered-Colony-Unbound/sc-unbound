@echo off

REM make-text.bat
mkdir tmp
mkdir tmp\as3
haxe compile.hxml
REM copy text\Boot.as tmp\as3\flash\Boot.as

pause
