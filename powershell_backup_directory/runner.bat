@echo off
rem Setting the source path for the folder to be backed up
rem Example: C:\Users\User\Documents\Database\
set SOURCE_FOLDER=<path-to-your-source-folder>

rem Setting the destination path for the backup file
rem Example: D:\Backups\Backup\
set DESTINATION_PATH=<path-to-your-destination-folder>

rem Backup filename for the ZIP
set BACKUP_NAME=<backup-name>

rem Separation line for better console visualization
set SEP_LINE=-------------------------------------------------------------

rem Displaying separation line in the console
echo %SEP_LINE%

rem Saving the current execution policy
for /f "delims=" %%a in ('PowerShell -Command "Get-ExecutionPolicy"') do set "CURRENT_POLICY=%%a"

rem Displaying the current execution policy
PowerShell -Command "$currentPolicy = '%CURRENT_POLICY%'; Write-Host 'Current execution policy: ' -NoNewline; Write-Host $currentPolicy -ForegroundColor Red -NoNewline; Write-Host ''"
echo %SEP_LINE%

rem Changing execution policy to Unrestricted if it is Restricted
if "%CURRENT_POLICY%"=="Restricted" (
    rem Changing to Unrestricted execution policy for the duration of the script
	PowerShell -Command "$unrestricted = 'Unrestricted'; Write-Host 'Changing execution policy to: ' -NoNewline; Write-Host $unrestricted -ForegroundColor Red -NoNewline; Write-Host ''"
	echo %SEP_LINE%
    PowerShell -Command "Set-ExecutionPolicy Unrestricted -Scope CurrentUser"
    set CHANGED_POLICY=1
)

rem Running the PowerShell script to create a backup with appropriate permissions
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '.\backup.ps1' -sourceFolder '%SOURCE_FOLDER%' -destinationPath '%DESTINATION_PATH%' -backupName '%BACKUP_NAME%'"

rem Restoring to Restricted policy
PowerShell -Command "Set-ExecutionPolicy Restricted -Scope CurrentUser"

rem Displaying information about restoring the policy
echo %SEP_LINE%
PowerShell -Command "$restricted = 'Restricted'; Write-Host 'Execution policy has been restored to: ' -NoNewline; Write-Host $restricted -ForegroundColor Red -NoNewline; Write-Host ''"

rem Informing the user to press any key to end the process
echo %SEP_LINE%
PowerShell -Command "Write-Host 'Press any key to exit...'"

rem The pause command stops the console window, waiting for a key press, redirection > nul hides the "Press any key to continue..." message
pause > nul
