@echo off
setlocal enabledelayedexpansion

echo Installing the quick-switch script...

rem Set the target installation directory
set "INSTALL_DIR=%USERPROFILE%\bin"

rem Create the installation directory if it doesn't exist
if not exist "%INSTALL_DIR%" (
    mkdir "%INSTALL_DIR%"
)

rem Copy the quick-switch.bat file to the installation directory
copy /Y "quick-switch.bat" "%INSTALL_DIR%\quick-switch.bat"

rem Check if the installation directory is in the system PATH
echo %PATH% | find /i "%INSTALL_DIR%" >nul
if errorlevel 1 (
    echo Adding %INSTALL_DIR% to system PATH...
    setx PATH "%PATH%;%INSTALL_DIR%"
) else (
    echo %INSTALL_DIR% is already in the system PATH.
)

rem Check if fzf is installed
where fzf >nul 2>&1
if errorlevel 1 (
    echo fzf not found.
    echo Please install fzf using the following command:
    echo winget install fzf

    echo If that doesn't work you can install it manually.
    echo Checkout https://github.com/junegunn/fzf for detailed guide on installation of fzf.
) else (
    echo fzf is already installed.
)

echo Installation complete! You can now use the quick-switch command from any directory.
pause

