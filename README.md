# PowerShell Script for VMware VM Renaming and Descriptor File Management

## Description
This PowerShell script provides a robust solution for managing VMware virtual machines, focusing on renaming VMs and updating their associated `.vmdk` descriptor files. The script facilitates an efficient, user-friendly approach to manage and maintain VMware environments.

### Key Features
- **Automated VM Detection**: Scans specified directories for VMware virtual machines.
- **Interactive VM Selection**: Users can select a VM for renaming through a numerical choice.
- **Comprehensive `.vmdk` File Handling**: Lists and highlights descriptor files for easy identification.
- **Safe Update Mechanism**: Prompts for user confirmation before modifying any `.vmdk` descriptor files.
- **Renaming and Updating**: Renames the VM directory and updates all relevant files, ensuring consistency.
- **Compatibility**: Designed to work seamlessly in VMware environments, streamlining VM management tasks.

- ### How to Use

1. **Open PowerShell**: Start PowerShell on your system. You may need to run it as an administrator depending on your system's configuration.

2. **Navigate to the Script Location**: Use the `cd` command to navigate to the directory where the `renameVM.ps1` script is located.

3. **Execute the Script**: Run the script by entering `.\renameVM.ps1`. 

4. **Enter Required Information**:
    - When prompted, enter the path to the directory containing your VMware VMs.
    - Choose a VM to rename by entering the corresponding number from the list.
    - Enter the new name for the selected VM.

5. **Confirm Modifications**: The script will list `.vmdk` files and highlight the descriptor files in red. Confirm the modifications when prompted.

The script will then proceed to rename the selected VM and update the associated descriptor files.

**Note**: Ensure that you have the necessary permissions to modify the VM files and always have backups before making changes.

