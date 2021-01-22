@echo off
powershell "C:\Users\admin\Desktop\Server\NoPixel\FXServer.exe +exec resources.cfg +exec server.cfg +set sv_enforceGameBuild 2060 | tee console_$(Get-Date -f yyyy-MM-dd-HHmm).log

