# Simple Backup Scripts

## Introduction

This repository contains two scripts (`runner.bat` and `backup.ps1`) designed to facilitate the backup process for folders on your Windows system. Below you'll find instructions on how to configure and run these scripts.

## Prerequisites

- **Windows OS**: These scripts are designed to run on Windows operating systems.
- **PowerShell**: Ensure PowerShell is installed on your system.
- **Basic Understanding**: Familiarity with running scripts in a Windows environment.

## Script: runner.bat

`runner.bat` is a batch file that executes the PowerShell script (`backup.ps1`) to create a backup. Before running `runner.bat`, make sure you have properly configured environment variables.

### Configuration

Before the first use of `runner.bat`, configure the following environment variables:

- `SOURCE_FOLDER`: Path to the folder you want to backup.
- `DESTINATION_PATH`: Path to the folder where you want to save the backup.

### Running the Script

After configuring the environment variables, run `runner.bat`. This script will automatically change the PowerShell execution policy to "Unrestricted" for the duration of the script execution. This change is necessary to allow the execution of `backup.ps1`, which may require elevated permissions to run properly. Once the script execution is complete, the policy will be restored to its original value.

## Script: backup.ps1

`backup.ps1` is a PowerShell script that creates a ZIP archive containing a backup of the specified folder. You can run it independently, but it's typically invoked by `runner.bat`.

### Parameters

- `-sourceFolder`: Path to the folder you want to backup.
- `-destinationPath`: Path to the folder where you want to save the backup.

### Running the Script

You can run `backup.ps1` directly from PowerShell, passing the appropriate parameters. For example:

```powershell
.\backup.ps1 -sourceFolder "C:\Users\User\Documents\Database\" -destinationPath "D:\Backups\Backup\"
```

This script automatically compresses the selected folder into a ZIP archive, naming it according to the current date and time.

## General Instructions

- **Run as Administrator:** It's recommended to run both scripts (`runner.bat` and `backup.ps1`) with administrator privileges. This ensures that the scripts have the necessary permissions to perform backup operations and modify execution policies.
- **Change Path Values:** Replace placeholder path values ("<path-to-your-source-folder>", "<path-to-your-destination-folder>") with actual paths.
- **Customize Backup Name:** Modify the backup name ("<backup-name>") in `backup.ps1` to suit your preferences.
- **Change Script Path:** If `backup.ps1` is located in a different directory, ensure to update the path accordingly in `runner.bat`.
- **Requirements:** Ensure you have the necessary permissions and dependencies to run these scripts effectively.

Feel free to contribute to the improvement of these scripts. Happy backing up!