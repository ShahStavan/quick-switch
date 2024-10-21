@echo off
setlocal

rem Set the target installation directory
set "INSTALL_DIR=%USERPROFILE%\bin"

rem Remove the quick-switch.bat file if it exists
if exist "%INSTALL_DIR%\quick-switch.bat" (
    del "%INSTALL_DIR%\quick-switch.bat"
    echo quick-switch.bat has been uninstalled.
) else (
    echo quick-switch.bat not found. It may not be installed.
)

rem Check if the INSTALL_DIR is empty
if exist "%INSTALL_DIR%\*" (
    echo The installation directory is not empty. Keeping the directory.
) else (
    rmdir "%INSTALL_DIR%"
    echo The installation directory has been removed.
)

echo Uninstallation complete!
pause

