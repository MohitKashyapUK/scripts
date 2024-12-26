@echo off

:: To begin with this. You need to download the Windows ISO image, and then extract 'install.wim' file from the image. And paste that file to Downloads folder.
:: Now, you are done. Start this script and wait. :) *Make sure the terminal is running with administrator privileges*

:: Set variables
set "WIM_PATH=C:\Users\%USERNAME%\Downloads\install.wim"
set "MOUNT_DIR=C:\mount"
set "WINRE_DIR=C:\Recovery\WindowsRE"

:: Check if install.wim exists
if not exist "%WIM_PATH%" (
    echo ERROR: install.wim not found at %WIM_PATH%
    pause
    exit /b
)

:: Create mount directory if it doesn't exist
if not exist "%MOUNT_DIR%" mkdir "%MOUNT_DIR%"

:: Mount the WIM file
echo Mounting install.wim...
dism /mount-image /imagefile:"%WIM_PATH%" /index:1 /mountdir:"%MOUNT_DIR%"
if errorlevel 1 (
    echo ERROR: Failed to mount install.wim
    pause
    exit /b
)

:: Check if winre.wim exists in the mounted image
if not exist "%MOUNT_DIR%\Windows\System32\Recovery\winre.wim" (
    echo ERROR: winre.wim not found in the mounted image.
    dism /unmount-image /mountdir:"%MOUNT_DIR%" /discard
    pause
    exit /b
)

:: Create Recovery\WindowsRE directory if it doesn't exist
if not exist "%WINRE_DIR%" mkdir "%WINRE_DIR%"

:: Copy winre.wim to the target directory
echo Copying winre.wim to %WINRE_DIR%...
copy "%MOUNT_DIR%\Windows\System32\Recovery\winre.wim" "%WINRE_DIR%"
if errorlevel 1 (
    echo ERROR: Failed to copy winre.wim
    dism /unmount-image /mountdir:"%MOUNT_DIR%" /discard
    pause
    exit /b
)

:: Unmount the image
echo Unmounting the image...
dism /unmount-image /mountdir:"%MOUNT_DIR%" /discard
if errorlevel 1 (
    echo ERROR: Failed to unmount image
    pause
    exit /b
)

:: Delete the mount folder
echo Deleting the mount folder...
rmdir /s /q "%MOUNT_DIR%"
if errorlevel 1 (
    echo ERROR: Failed to delete the mount folder
    pause
    exit /b
)

:: Set the recovery image path
echo Setting recovery image path...
reagentc /setreimage /path "%WINRE_DIR%"
if errorlevel 1 (
    echo ERROR: Failed to set recovery image path
    pause
    exit /b
)

:: Enable Windows Recovery Environment
echo Enabling Windows Recovery Environment...
reagentc /enable
if errorlevel 1 (
    echo ERROR: Failed to enable Windows Recovery Environment
    pause
    exit /b
)

:: Confirm setup
echo Confirming setup...
reagentc /info
if errorlevel 1 (
    echo ERROR: Failed to retrieve recovery information
    pause
    exit /b
)

echo.
echo Setup completed successfully!
pause
