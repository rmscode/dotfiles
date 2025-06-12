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

# activate or create and activate python virtual environment
# create python virtual environment
function pve {
    try {
        $currentDir = Get-Location
        $venvDotPath = Join-Path $currentDir ".venv"
        $venvPath = Join-Path $currentDir "venv"
		$venvDotActivate = Join-Path $venvDotPath "\Scripts\activate.ps1"
		$venvActivate = Join-Path $venvPath "\Scripts\activate.ps1"

        if (Test-Path $venvDotPath) {
            Write-Host "The following Python virtual environment was found:`n`n$venvDotPath. `n`nActivating..."
			& $venvDotActivate
        } elseif (Test-Path $venvPath) {
            $response = Read-Host "The following Python virtual environment was found:`n`n$venvPath `n`nWould you like to rename it to .venv before activating? [y/n]"
            if ($response -eq 'y') {
                Rename-Item -Path $venvPath -NewName ".venv"
                Write-Host "Changes made. Activating..."
				& $venvDotActivate
            } else {
                Write-Host "No changes made. Activating..."
				& $venvActivate
            }
        } else {
            Write-Host "No Python virtual environment was found. Creating..."
            python -m venv .venv
            Write-Host "`nThe following Python virtual environment has been created:`n`n$venvDotPath `n`nActivating..."
			& $venvDotActivate
        }
    } catch {
        Write-Host "Error creating virtual environment: $_"
    }
}

# deactivate python virtual environment
function pvd {
	deactivate
	Write-Host "Python virtual environment deactivated"
}
