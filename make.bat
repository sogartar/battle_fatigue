@echo off

SET SCRIPT_DIR=%~dp0
SET WORKING_DIR=%cd%

cd "%SCRIPT_DIR%"
7z a "%WORKING_DIR%\mod_battle_fatigue0.5.0.zip" scripts gfx || goto error
exit 0

:error
echo Failed with error #%errorlevel%.
exit /b %errorlevel%
