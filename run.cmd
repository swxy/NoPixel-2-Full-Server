@echo off
powershell "C:\Users\admin\Desktop\Server\NoPixel\FXServer.exe +exec resources.cfg +exec server.cfg +set onesync on | tee console_$(Get-Date -f yyyy-MM-dd-HHmm).log

