@echo off
setlocal enabledelayedexpansion

if "%~1"=="" (
    for /f "delims=" %%i in ('dir /b /ad "D:\*" ^| fzf') do (
        set "selected=D:\%%i"
    )
) else (
    set "selected=%~1"
)

if "%selected%"=="" (
    exit /b 0
)

for %%i in ("%selected%") do set "selected_name=%%~nxi"
set "selected_name=%selected_name:.=_%"

set "is_python=0"
set "is_node=0"
set "is_react=0"
set "is_next=0"
set "is_git=0"
set "has_venv=0"
set "has_docker=0"
set "has_db=0"
set "has_env_file=0"
set "running_on_port=0"
set "venv_path="
set "venv_activate="

rem Project type detection
if exist "%selected%\package.json" (
    set "is_node=1"
    findstr /m "\"react\"" "%selected%\package.json" >nul
    if !errorlevel! equ 0 set "is_react=1"
    findstr /m "\"next\"" "%selected%\package.json" >nul
    if !errorlevel! equ 0 set "is_next=1"
)

if exist "%selected%\requirements.txt" set "is_python=1"
if exist "%selected%\setup.py" set "is_python=1"
if exist "%selected%\pyproject.toml" set "is_python=1"

rem Git detection
if exist "%selected%\.git" set "is_git=1"

rem Docker detection
if exist "%selected%\docker-compose.yml" set "has_docker=1"
if exist "%selected%\Dockerfile" set "has_docker=1"

rem Database detection
if exist "%selected%\*.sql" set "has_db=1"
if exist "%selected%\migrations" set "has_db=1"
if exist "%selected%\db.sqlite3" set "has_db=1"

rem Environment file detection
if exist "%selected%\.env" set "has_env_file=1"
if exist "%selected%\.env.local" set "has_env_file=1"
if exist "%selected%\.env.development" set "has_env_file=1"

rem Check for Python virtual environment
for %%i in (env venv .env .venv) do (
    if exist "%selected%\%%i\Scripts\activate.bat" (
        set "has_venv=1"
        set "venv_path=%selected%\%%i"
        set "venv_activate=%%i\Scripts\activate.bat"
    )
)

set "cmd_commands=cd /d %selected%"

rem Git status and branch info
if "%is_git%"=="1" (
    set "cmd_commands=%cmd_commands% && echo. && echo Git Status: && git status --short && echo. && echo Current Branch: && git branch --show-current && echo. && echo Recent Commits: && git log --oneline -5"
)

rem Python environment activation
if "%has_venv%"=="1" (
    set "cmd_commands=%cmd_commands% && echo. && echo Activating Python virtual environment from %venv_activate% && call %venv_activate%"
)

rem Node.js project setup
if "%is_node%"=="1" (
    set "cmd_commands=%cmd_commands% && echo. && echo Node.js project detected"
    if "%is_next%"=="1" (
        set "cmd_commands=%cmd_commands% && echo Next.js project detected && echo Available commands: && echo npm run dev - Start development server && echo npm run build - Build for production && echo npm start - Start production server"
    ) else if "%is_react%"=="1" (
        set "cmd_commands=%cmd_commands% && echo React project detected && echo Available commands: && echo npm start - Start development server && echo npm run build - Build for production"
    ) else (
        set "cmd_commands=%cmd_commands% && echo Available commands: && echo npm start - Start the application && echo npm test - Run tests"
    )
    
    rem Check for outdated packages
    set "cmd_commands=%cmd_commands% && echo. && echo Checking for outdated packages... && npm outdated"
    
    if not exist "%selected%\node_modules" (
        set "cmd_commands=%cmd_commands% && echo. && echo node_modules not found, you may need to run 'npm install'"
    )
)

rem Python project setup
if "%is_python%"=="1" (
    if "%has_venv%"=="0" (
        set "cmd_commands=%cmd_commands% && echo. && echo Python project detected but no virtual environment found && echo To create one, use: && echo python -m venv env"
    )
    
    rem Check for outdated packages if requirements.txt exists
    if exist "%selected%\requirements.txt" (
        set "cmd_commands=%cmd_commands% && echo. && echo Checking for outdated Python packages... && pip list --outdated"
    )
)

rem Docker status
if "%has_docker%"=="1" (
    set "cmd_commands=%cmd_commands% && echo. && echo Docker containers status: && docker ps | findstr /i "%selected_name%""
)

rem Port usage check for common development ports
set "cmd_commands=%cmd_commands% && echo. && echo Checking port usage..."
set "cmd_commands=%cmd_commands% && echo Development ports status:"
set "cmd_commands=%cmd_commands% && netstat -ano | findstr /i "3000 3001 5000 5001 8000 8080" || echo No development ports in use"

rem Environment file check
if "%has_env_file%"=="1" (
    set "cmd_commands=%cmd_commands% && echo. && echo Environment files found: && dir /b .env* 2>nul"
)

rem Database check
if "%has_db%"=="1" (
    set "cmd_commands=%cmd_commands% && echo. && echo Database files detected. Remember to check migrations status."
)

rem Memory usage
set "cmd_commands=%cmd_commands% && echo. && echo System Memory Status: && wmic OS get FreePhysicalMemory,TotalVisibleMemorySize /Value"

rem Set window title with project info
set "window_title=DEV - %selected_name%"
if "%is_next%"=="1" set "window_title=%window_title% (Next.js)"
if "%is_react%"=="1" set "window_title=%window_title% (React)"
if "%is_node%"=="1" set "window_title=%window_title% (Node.js)"
if "%is_python%"=="1" set "window_title=%window_title% (Python)"
if "%has_venv%"=="1" set "window_title=%window_title% [venv]"
if "%is_git%"=="1" set "window_title=%window_title% [git]"
if "%has_docker%"=="1" set "window_title=%window_title% [docker]"

rem Add quick help
set "cmd_commands=%cmd_commands% && echo. && echo Quick Commands:"
set "cmd_commands=%cmd_commands% && echo - git status: Show git status"
set "cmd_commands=%cmd_commands% && echo - docker ps: List running containers"
set "cmd_commands=%cmd_commands% && echo - npm outdated: Check for outdated packages"
set "cmd_commands=%cmd_commands% && echo - netstat -ano: Check port usage"

rem Check for existing window and launch
wmic path Win32_Process where "CommandLine like '%%cmd.exe%%' and Caption='cmd.exe' and CommandLine like '%%%selected_name%%%'" get ProcessId /value 2>nul | findstr /i /c:"ProcessId=" >nul
if errorlevel 1 (
    start "%window_title%" cmd.exe /K "%cmd_commands%"
) else (
    echo Command Prompt session with the name %selected_name% already exists.
)

endlocal