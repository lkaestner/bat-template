@echo off

:: this is a comment
rem this is also a comment

:: clear the screen
cls

:: set a variable for the current session (case-insensitive)
set myvar=world

:: write text to the console (no quotes required)
echo hello %myvar%

:: write newline to console
echo:

:: redirect stdout to null
echo test >nul

:: redirect all output to null
echo test >nul 2>&1

:: inline error handling
echo thismayfail && echo ok fine || echo screwed up
call :dashes

:: call local function
call :my_function myParam1 myParam2
call :dashes

:: call some other functions
call :string_contains yabadabadu
call :dashes

call :get_current_dir
call :dashes

call :get_date
call :dashes

call :file_exists %windir%
call :dashes

call :files_flat
call :dashes

call :files_recurse
call :dashes

call :filename_decompose
call :dashes

:: wait for keystroke to continue
pause

:: exit the program here (exit code zero)
exit /b 0

:: declare a function
:my_function
    echo calling my_function
    
    :: use local variables
    echo %myvar% is good
    
    :: access function parameters by index
    echo "%~1" and "%~2"
    
    :: access function all parameters
    echo %*
        
exit /b 0

:: print a line of dashes
:dashes
    echo:
    echo ----------------------------------------------------------------------
exit /b 0

:: check if test-string contains match-keyword
:string_contains
    set test=%~1
    set match=bad
    echo "%test%" | findstr /r "%match%" >nul && (
        echo %test% contains %match%
    )
exit /b 0

:: get current working dir and location of bat-file
:get_current_dir
    echo Working directory: %cd%
    set script_dir=%~dp0
    set script_dir=%script_dir:~0,-1%
    echo Script directory:  %script_dir%
exit /b 0

:: check if file exists
:file_exists
    if exist "%~1" (
        echo file found: %~1
    ) else (
        echo file not found: %~1
    )
exit /b 0

:: iterate over hidden subfolders within homepath
:files_flat
    for /f "delims=" %%i in ('dir /b /a:dh "%homepath%"') do (
        echo %%i
    )
    :: /a:d only folders     /a-d no folders
    :: /a:h only hidden      /a-h no hidden
    :: /a:dh only hidden folders
exit /b 0

:: iterate over all *.tmp files in homepath (recursive)
:files_recurse
    for /f "tokens=* delims=" %%i in ('dir /b /s "%homepath%\*.tmp" ') do (
        echo %%i
    )
exit /b 0

:: decompose a path into directory, filename and extension components
:filename_decompose
    set cmd_path=%COMSPEC%
    for %%A in ("%cmd_path%") do (
        set cmd_dir=%%~dpA
        set cmd_name=%%~nxA
        set cmd_ext=%%~xA
    )
    echo CMD path: %cmd_path%
    echo CMD dir:  %cmd_dir%
    echo CMD name: %cmd_name%
    echo CMD ext:  %cmd_ext%
exit /b 0

:: print current date
:get_date
    for /f "delims=" %%a in ('wmic OS Get localdatetime  ^| find "."') do set "dt=%%a"
    set "YYYY=%dt:~0,4%"
    set "MM=%dt:~4,2%"
    set "DD=%dt:~6,2%"
    set "HH=%dt:~8,2%"
    set "Min=%dt:~10,2%"
    set "Sec=%dt:~12,2%"

    set timestamp=%YYYY%-%MM%-%DD%_%HH%-%Min%-%Sec%
    echo Timestamp: "%timestamp%"
exit /b 0

:: set a permanent system variable (this function is not being called)
:set_system_variable
    :: set a permanent system variable (HKLM) - requires admin rights
    setx /m MYSYSVAR "my value"
exit /b 0