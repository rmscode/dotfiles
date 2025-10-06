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

# Find Path MTU
function Find-PathMTU {
    param (
        [Parameter(Mandatory=$true)]
        [string]$TargetHost
    )

    function Test-MTU {
        param (
            [int]$Size
        )
        $result = ping $TargetHost -f -l $Size -n 1
        if ($result -match "Packet needs to be fragmented but DF set.") {
            Write-Host "Trying MTU size $Size...Too large. Packet needs to be fragmented but DF set." -ForegroundColor Yellow
            return $false
        } elseif ($result -match "Reply from") {
            Write-Host "Trying MTU size $Size...Success."
            return $true
        } else {
            Write-Verbose "Unexpected ping result for size $Size"
            return $false
        }
    }

    Write-Host "Starting Path MTU Discovery to $TargetHost..."

    $mtu = 1500
    $max = 2000

    # Step 1: Increase by 100
    while ($mtu -le $max) {
        if (Test-MTU -Size $mtu) {
            $mtu += 100
        } else {
            $mtu -= 100
            break
        }
    }

    # Step 2: Increase by 10
    while ($true) {
        if (Test-MTU -Size $mtu) {
            $mtu += 10
        } else {
            $mtu -= 10
            break
        }
    }

    # Step 3: Increase by 1
    while ($true) {
        if (Test-MTU -Size $mtu) {
            $mtu += 1
        } else {
            $mtu -= 1
            break
        }
    }

    Write-Host "Final check at MTU size $mtu..."
    if (Test-MTU -Size $mtu) {
        Write-Host "Path MTU to $TargetHost is $mtu bytes."
    } else {
        Write-Host "Path MTU to $TargetHost is $($mtu - 1) bytes."
    }
}