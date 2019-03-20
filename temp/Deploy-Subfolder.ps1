# Setting the base directory - MUST be Absolute path - and you'd better be sure !
$root = "c:\Code\GitHub\ps-mol\test"

#region build environment
# Create x folders for testing, suffix of $i value and a check to prevent attempts to create pre-existing folders
foreach ($i in (1..10)) {
    if (!(Test-Path -Path "$root\folder$i")) {
        $newfolder = New-Item -ItemType Directory -Path "$root\folder$i"
        $newfolder = ($newfolder | Select-Object -ExpandProperty FullName)
        $newfolder = $newfolder.PadRight(100, '.')
        Write-Host $newfolder -NoNewline -ForegroundColor White
        Write-Host "created successfully" -ForegroundColor Green
    } else {
        $message = "$root\folder$i"
        $message = $message.PadRight(100, '.')
        Write-Host $message -NoNewline -ForegroundColor White
        Write-Host "already exists - skipping" -ForegroundColor Blue
    }
}
#endregion buildenvironment


#region clean up environment
# Clean up the test environment
foreach ($i in (1..10)) {
    Remove-Item -Path "$root\folder$i" -Recurse -Force -Confirm:$false -ErrorAction Ignore
}
#endregion clean up environment


#region basic script
# Getting all subfolders and running a process for each which IS a Container
# and reporting results in helpful colours
ForEach ($dir in (Get-ChildItem -Path $root\* | Where-Object {$_.PSIsContainer})) {

    If (!( Test-Path -Path "$dir\ID" )) {
        $message = ($dir | Select-Object -ExpandProperty FullName)
        $message = $message.PadRight(100, '.')
        Write-Host "$message" -NoNewline
        Write-Host "ID Subfolder not present, adding..." -ForegroundColor Blue -NoNewline
        New-Item -Path "$dir" -Name 'ID' -ItemType Directory | Out-Null
        If (Test-Path -Path "$dir\ID") {
            Write-Host "SUCCESS!" -ForegroundColor Green
        } else {
            Write-Host "FAILED!" -ForegroundColor Red
        }
    }

    else {
        $message = ($dir | Select-Object -ExpandProperty FullName)
        $message = $message.PadRight(100, '.')
        Write-Host "$message" -NoNewline
        Write-Host "ID Subfolder present" -ForegroundColor Green
    }

}
#endregion basic script


#region advanced script
# Getting all subfolders and running a process for each which IS a Container
# and reporting results in helpful colours
ForEach ($dir in (Get-ChildItem -Path $root\* | Where-Object {$_.PSIsContainer})) {

    If (!( Test-Path -Path "$dir\Pension" )) {
        $message = ($dir | Select-Object -ExpandProperty FullName)
        $message = $message.PadRight(100, '.')
        Write-Host "$message" -NoNewline
        Write-Host "Pension folder not present. Skipping." -ForegroundColor Green
    }

    else {
        $message = ($dir | Select-Object -ExpandProperty FullName)
        $message = $message.PadRight(100, '.')
        Write-Host "$message" -NoNewline

        If (!(Test-Path -Path "$dir\Pension\Trust Documentation")) {
            Write-Host "Pension folder found. Adding Trust Documentation..." -ForegroundColor Blue -NoNewline
            New-Item -Path "$dir\Pension" -Name 'Trust Documentation' -ItemType Directory | Out-Null
            If (Test-Path -Path "$dir\Pension\Trust Documentation") {
                Write-Host "SUCCESS!" -ForegroundColor Green
            } else {
                Write-Host "FAILED!" -ForegroundColor Red
            }
        } else {
            Write-Host "Trust Documentation exists. Skipping." -ForegroundColor Green
        }
    }

}
#endregion advanced script

