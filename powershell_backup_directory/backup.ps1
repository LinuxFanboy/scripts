param(
    # Source path for the folder to be compressed
    [string]$sourceFolder = "<path-to-your-source-folder>", # Example: C:\Users\User\Documents\Database\

    # Destination path for the ZIP files
    [string]$destinationPath = "<path-to-your-destination-folder>", # Example: D:\Backups\Backup\

    # Backup filename for the ZIP
    [string]$backupName = "<backup-name>" # Example" backup_20240824_105713.zip 
)

# Separation line for better console visualization
$separationLine = "-------------------------------------------------------------"

# Generating the ZIP file name including current date and time
$dateTime = Get-Date -Format "yyyyMMdd_HHmmss"
$destinationZip = "$destinationPath\${backupName}_$dateTime.zip" 

# Loading necessary libraries for file compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

# Function for folder compression
function Compress-Folder {
    param(
        [string]$sourceFolder,
        [string]$destinationZip,
        [string]$compressionLevel = 'Optimal'
    )
    
    # Deleting existing ZIP file, if it already exists
    if (Test-Path $destinationZip) {
        Remove-Item $destinationZip
    }

    # Getting files to compress
    $files = Get-ChildItem -Path $sourceFolder -Recurse -File
    $totalFiles = $files.Count
    $processedFiles = 0

    # Initializing progress bar
    $progressBar = {
        $percentComplete = ($processedFiles / $totalFiles) * 100
        Write-Progress -Activity "Compressing files..." -Status "$processedFiles of $totalFiles files compressed" -PercentComplete $percentComplete
    }

    # Creating ZIP archive
    $zipArchive = [System.IO.Compression.ZipFile]::Open($destinationZip, 'Create')
    foreach ($file in $files) {
        $relativePath = $file.FullName.Substring($sourceFolder.Length + 1)
        [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zipArchive, $file.FullName, $relativePath, [System.IO.Compression.CompressionLevel]::$compressionLevel) | Out-Null
        $processedFiles++
        & $progressBar
    }
    $zipArchive.Dispose()
    Write-Host "Compression completed" -ForegroundColor Green
    Write-Host $separationLine
}

# Function for managing the number of stored backups
function Manage-Backups {
    param(
        [string]$backupFolder,
        [int]$maxBackups = 5
    )
    
    # Listing backups and sorting by modification date
    $backups = Get-ChildItem -Path $backupFolder -Filter "${backupName}_*.zip" | Sort-Object LastWriteTime -Descending
    
    # Deleting oldest backups if the limit is exceeded
    if ($backups.Count -ge $maxBackups) {
        Write-Host "Deleting oldest backup: $($backups[-1].Name)" -ForegroundColor Yellow
        Write-Host $separationLine
        Remove-Item $backups[-1].FullName -Force
    }
}

# Managing backups
Manage-Backups -backupFolder $destinationPath

# Compressing the folder
Compress-Folder -sourceFolder $sourceFolder -destinationZip $destinationZip -compressionLevel 'Optimal'

# Final message with the ZIP file location
Write-Host "File is located at: $destinationZip" -ForegroundColor DarkYellow
