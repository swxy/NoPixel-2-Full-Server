rem Written by adoggman@github

echo off
setlocal enableDelayedExpansion

rem Check if we already have a filter set up
findstr /m "server-config-filter" %~dp0\.git\config

rem THIS IS SO STUPID but it works - make sure there's a tab after the =
set TAB=	

if %errorLevel%==0  (
	rem We found an existing filter
	echo on
	echo "Already ran this script."
	echo "Go into the .git/config text file and make changes there."
) else (
	rem Get input for server.cfg
	set /p steamAPIKey="Enter your steam web API key: "
	set /p steamID="Enter your (hex) steam ID: "
	set /p licenseKey="Enter your FiveM server license key (from keymaster.fivem.net): "
	
	rem Add the filter for server.cfg
	echo. >> %~dp0\.git\config
	echo [filter "server-config-filter"] >> %~dp0\.git\config
	echo %TAB%smudge = "wsl sed -e 's/your_steam_web_api_key/!steamAPIKey!/' -e 's/your_steam_id/!steamID!/' -e 's/your_license_key/!licenseKey!/'" >> %~dp0\.git\config
	echo %TAB%clean = "wsl sed -e 's/!steamAPIKey!/your_steam_web_api_key/' -e 's/!steamID!/your_steam_id/' -e 's/!licenseKey!/your_license_key/'" >> %~dp0\.git\config
		
	rem Get input for database config
	echo.
	set /p dbUser="Enter your database user: "
	set /p dbPassword="Database user password: "
	
	rem Add the filter for the database config
	echo [filter "sql-config-filter"] >> %~dp0\.git\config
	echo %TAB%smudge = "wsl sed -e 's/your_db_password/!dbPassword!/' -e 's/your_db_user/!dbUser!/'" >> %~dp0\.git\config
	echo %TAB%clean = "wsl sed -e 's/!dbPassword!/your_db_password/' -e 's/!dbUser!/your_db_user/'" >> %~dp0\.git\config
	
	rem Now add the values to the actual files
	wsl cp server.cfg server.cfg.clean
	wsl sed -e 's/your_steam_web_api_key/!steamAPIKey!/' -e 's/your_steam_id/!steamID!/' -e 's/your_license_key/!licenseKey!/' server.cfg > server.cfg.smudge
	wsl mv server.cfg.smudge server.cfg

	wsl cp resources/ghmattimysql/config.json resources/ghmattimysql/config.json.clean
	wsl sed -e 's/your_db_password/!dbPassword!/' -e 's/your_db_user/!dbUser!/' resources/ghmattimysql/config.json > resources/ghmattimysql/config.json.smudge
	wsl mv resources/ghmattimysql/config.json.smudge resources/ghmattimysql/config.json
	
	echo on
	echo.
	echo Done!
)
pause