@echo off
setlocal enabledelayedexpansion

rem Check if an argument is provided
if "%~1"=="" (
    rem Use dir to list top-level directories in D:\Projects and D:\Practice, then pipe to fzf for selection
    for /f "delims=" %%i in ('dir /b /ad "D:\Projects" "D:\Practice" ^| fzf') do (
        set "selected=D:\Projects\%%i"
        if not exist "!selected!" set "selected=D:\Practice\%%i"
    )
) else (
    set "selected=%~1"
)

rem Exit if no directory was selected
if "%selected%"=="" (
    exit /b 0
)

rem Get the selected directory name
for %%i in ("%selected%") do set "selected_name=%%~nxi"
set "selected_name=%selected_name:.=_%"

rem Check if a Command Prompt window for this session already exists
wmic path Win32_Process where "CommandLine like '%%cmd.exe%%' and Caption='cmd.exe' and CommandLine like '%%%selected_name%%%'" get ProcessId /value 2>nul | findstr /i /c:"ProcessId=" >nul
if errorlevel 1 (
    rem Start a new Command Prompt window with the specified directory and title
    start "Command Prompt - %selected_name%" cmd.exe /K "cd /d %selected%"
) else (
    rem Focus on the existing Command Prompt window with the specified title
    echo Command Prompt session with the name %selected_name% already exists.
)

