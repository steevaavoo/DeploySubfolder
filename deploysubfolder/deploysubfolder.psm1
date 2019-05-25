# Module to Deploy Subfolders based on inputs from user

# Script-level var to ensure clean removal of folders - defaults to null to prevent unexpected deletions
# $script:testenvfolders = 'null'
# Script-level var to target correct location - set to '' to prevent accidental deletions
# $script:rootfolder = ''

Write-Host 'Importing Deploy Subfolder Module.'
Write-Host 'Use Get-Help for further information.'
# Write-Host "Test Environment Folder Number set to: [$script:testenvfolders]"
# Write-Host "Root Folder set to: [$script:rootfolder]"

#region create test environment
# Create a bunch of Folders to use as a test environment - don't deploy this function
function New-TestEnvironment {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateScript( {Test-Path $_})]
        [String]
        $RootFolder,
        [Parameter(Mandatory = $true)]
        [Int]
        $NumberOfFolders
    )

    if ($RootFolder -like '*:\') {
        throw "Avoid system root drives."
    }


    foreach ($i in (1..$NumberOfFolders)) {
        if (!(Test-Path -Path "$RootFolder\folder$i")) {
            $newfolder = New-Item -ItemType Directory -Path "$RootFolder\folder$i"
            $newfolder = ($newfolder | Select-Object -ExpandProperty FullName)
            $newfolder = $newfolder.PadRight(100, '.')
            Write-Host $newfolder -NoNewline -ForegroundColor White
            Write-Host "created successfully" -ForegroundColor Green
        }
        else {
            $message = "$RootFolder\folder$i"
            $message = $message.PadRight(100, '.')
            Write-Host $message -NoNewline -ForegroundColor White
            Write-Host "already exists - skipping" -ForegroundColor Blue
        }
    }

    $script:testenvfolders = $NumberOfFolders
    $script:rootfolder = $RootFolder
    # Testing Script Level Vars - comment out for production
    Write-Host "Test Environment Folder Number [$script:testenvfolders]"
    Write-Host "Root Folder [$script:rootfolder]"
}
#endregion create test environment


#region clean up test environment
# Clean up the test environment -  don't deploy this function
function Remove-TestEnvironment {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateScript( {Test-Path $_})]
        [String]
        $RootFolder,
        [Parameter(Mandatory = $true)]
        [Int]
        $NumberOfFolders
    )

    # Testing Script Level Vars - comment out for production
    # Write-Host "Test Environment Folder Number [$script:testenvfolders]"
    # Write-Host "Root Folder [$script:rootfolder]"

    if ($RootFolder -like '*:\') {
        throw "Avoid system root drives."
    }

    foreach ($i in (1..$NumberOfFolders)) {
        Remove-Item -Path "$RootFolder\folder$i" -Recurse -Force -Confirm:$false -ErrorAction Ignore
    }
}
#endregion clean up test environment


#region add deployed subfolder
function Add-DeployedSubfolder {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateScript( {Test-Path $_})]
        [String]
        $RootFolder,
        [Parameter(Mandatory = $true)]
        [String]
        $NewFolderName
    )

    ForEach ($dir in (Get-ChildItem -Path $RootFolder\* | Where-Object {$_.PSIsContainer})) {

        if (!( Test-Path -Path "$dir\$NewFolderName" )) {
            $message = ($dir | Select-Object -ExpandProperty FullName)
            $message = $message.PadRight(100, '.')
            Write-Host "$message" -NoNewline
            Write-Host "$NewFolderName Subfolder not present, adding..." -ForegroundColor Blue -NoNewline
            New-Item -Path "$dir" -Name "$NewFolderName" -ItemType Directory | Out-Null
            if (Test-Path -Path "$dir\$NewFolderName") {
                Write-Host "SUCCESS!" -ForegroundColor Green
            }
            else {
                Write-Host "FAILED!" -ForegroundColor Red
            }
        }

        else {
            $message = ($dir | Select-Object -ExpandProperty FullName)
            $message = $message.PadRight(100, '.')
            Write-Host "$message" -NoNewline
            Write-Host "$NewFolderName Subfolder present - nothing to do :)" -ForegroundColor Green
        }

    }


}
#endregion add deployed subfolder


#region add companion folder
# Create a subfolder of a specified subfolder, skip if specified folder doesn't exist
function Add-CompanionFolder {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateScript( {Test-Path $_})]
        [String]
        $RootFolder,
        [Parameter(Mandatory = $true)] # Add some validation here
        [String]
        $SubFolderName,
        [Parameter(Mandatory = $true)] # Add some validation here too
        [String]
        $CompanionFolderName
    )
    ForEach ($dir in (Get-ChildItem -Path $RootFolder\* | Where-Object {$_.PSIsContainer})) {

        If (!( Test-Path -Path "$dir\$SubFolderName" )) {
            $message = ($dir | Select-Object -ExpandProperty FullName)
            $message = $message.PadRight(100, '.')
            Write-Host "$message" -NoNewline
            Write-Host "$SubFolderName folder not present. Skipping." -ForegroundColor Green
        }

        else {
            $message = ($dir | Select-Object -ExpandProperty FullName)
            $message = $message.PadRight(100, '.')
            Write-Host "$message" -NoNewline

            If (!(Test-Path -Path "$dir\$SubFolderName\$CompanionFolderName")) {
                Write-Host "$SubFolderName folder found. Adding $CompanionFolderName..." -ForegroundColor Blue -NoNewline
                New-Item -Path "$dir\$SubFolderName" -Name "$CompanionFolderName" -ItemType Directory | Out-Null
                If (Test-Path -Path "$dir\$SubFolderName\$CompanionFolderName") {
                    Write-Host "SUCCESS!" -ForegroundColor Green
                }
                else {
                    Write-Host "FAILED!" -ForegroundColor Red
                }
            }
            else {
                Write-Host "$CompanionFolderName exists. Skipping." -ForegroundColor Green
            }
        }

    }

}
#endregion add companion folder
