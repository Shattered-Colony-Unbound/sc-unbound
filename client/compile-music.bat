@echo off

REM make-text.bat
haxe compile-music.hxml
copy text\Boot.as zomlog\flash\Boot.as

pause
