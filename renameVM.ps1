# PowerShell script to rename a VMware VM and update .vmdk descriptor files, with VM selection by number

# Function to update .vmdk descriptor files
function Update-VMDKDescriptor {
    param (
        [string]$filePath,
        [string]$oldName,
        [string]$newName
    )
    (Get-Content $filePath) -replace [regex]::Escape($oldName), $newName | Set-Content $filePath
}

# Ask for the path to the VMware VMs directory
$vmwareDirectory = Read-Host "Enter the path to the VMware VMs directory"

# List directories that contain .vmx files
Write-Host "Scanning for VMs in the directory..."
$vmxFiles = Get-ChildItem -Path $vmwareDirectory -Recurse | Where-Object { -not $_.PSIsContainer -and $_.Name -like "*.vmx" }
$vmDirectories = $vmxFiles | Select-Object -Unique DirectoryName

# Display VM directories with index for selection
$index = 1
$indexedDirectories = @{}
$vmDirectories | ForEach-Object {
    Write-Host "${index}: $($_.DirectoryName)"
    $indexedDirectories.Add($index, $_.DirectoryName)
    $index++
}

# User selects VM by number
$selectedVMIndex = Read-Host "Enter the number of the VM to rename"
$selectedVMIndex = [int]$selectedVMIndex  # Cast to integer
$selectedVMDir = $indexedDirectories[$selectedVMIndex]

# Validate if the directory exists
if (-not $selectedVMDir) {
    Write-Host "Invalid selection."
    exit
}

# Ask for the new VM name
$newVMName = Read-Host "Enter the new name for the VM"

# List all .vmdk files and highlight descriptor files in red
Write-Host "Listing .vmdk files..."
$vmdkFiles = Get-ChildItem -Path $selectedVMDir -Recurse | Where-Object { $_.Extension -eq ".vmdk" }
foreach ($file in $vmdkFiles) {
    if ($file.Length -lt 5KB) {
        Write-Host $file.FullName -ForegroundColor Red
    } else {
        Write-Host $file.FullName
    }
}

# Confirm modification of .vmdk descriptor files
$confirmation = Read-Host "Do you want to modify the highlighted .vmdk descriptor files? (y/n)"
if ($confirmation -ne 'y') {
    Write-Host "Modification cancelled."
    exit
}

# Continue with renaming and updating files
$oldVMName = Split-Path $selectedVMDir -Leaf
$newVMDir = Join-Path (Split-Path $selectedVMDir -Parent) $newVMName

# Check if new directory name is different
if ($selectedVMDir -ne $newVMDir) {
    Rename-Item $selectedVMDir $newVMDir

    Get-ChildItem -Path $newVMDir -Recurse | ForEach-Object {
        $newFilePath = Join-Path (Split-Path $_.FullName -Parent) ($_.Name -replace [regex]::Escape($oldVMName), $newVMName)
        if ($_.FullName -ne $newFilePath) {
            Rename-Item $_.FullName $newFilePath
            if ($_.Extension -eq ".vmx" -or ($_.Extension -eq ".vmdk" -and $_.Length -lt 5KB)) {
                Update-VMDKDescriptor -filePath $newFilePath -oldName $oldVMName -newName $newVMName
            }
        }
    }
} else {
    Write-Host "The new VM name is the same as the old one. No changes made."
}

Write-Host "VM and associated files have been renamed successfully."
