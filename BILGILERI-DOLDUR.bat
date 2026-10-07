@echo off
rem Web sitesi bilgilerini doldurma araci - cift tiklayarak calistirin.
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -STA -File "%~dp0bilgileri-doldur.ps1"
if errorlevel 1 pause
