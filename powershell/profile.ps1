# Starship
#Invoke-Expression (&starship init powershell)

# Oh-My-Posh
oh-my-posh --init --shell pwsh --config ~/night-owl.omp.json | Invoke-Expression

# Update MkDocs
function Update-MyDocs {
    $currentDir = Get-Location
    $targetDir = "C:\Users\rsaull\Repositories\MyDocs\"

    if ($currentDir -ne $targetDir) {
        Set-Location -Path $targetDir
    }

    mkdocs build
    Robocopy "C:\Users\rsaull\Repositories\MyDocs\site\" "\\nep001\Common\Superior\Ricky\MyDocs\site\" /mir

    # Change back to the original directory
    Set-Location -Path $currentDir
}

# nano in pwsh
function nano {
    C:\Progra~1\Git\usr\bin\nano.exe --ignorercfiles $args
}

# activate python virtual environment
function pyv {
    try {
        $venvPath = Get-Location | Join-Path -ChildPath ".\venv\Scripts\activate.ps1"
        if (Test-Path $venvPath) {
            & $venvPath
        } else {
            Write-Host "No Python virtual environment found at $venvPath"
        }
    } catch {
        Write-Host "Error activating virtual environment: $_"
    }
}
