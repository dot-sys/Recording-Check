#MIT License
#Copyright (c) 2024 dot-sys


$runascheck = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $runascheck.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Output "Aborting Script - Powershell is not started as Administrator"
    return
}


$ErrorActionPreference = "SilentlyContinue" 
Clear-Host
Write-Host "`n`n`n-------------------------------"-ForegroundColor yellow
Write-Host "|  Checking VPN + Recording   |" -ForegroundColor yellow
Write-Host "|         Please Wait         |" -ForegroundColor yellow
Write-Host "-------------------------------`n"-ForegroundColor yellow
Write-Host "     This takes 30 Seconds`n`n`n"-ForegroundColor yellow

$processNames = @(
    "action", "amdrsserv", "apowersoftfreescreenrecorder", "bandicamlauncher", "bdcam", 
    "camtasia", "captura", "d3dgear", "dxtory", "fraps", "gadwinprintscreen", "geforce"
    "gtk-recordmydesktop", "icecreamscreenrecorder", "jupyter-notebook", "kazam", 
    "lightstream", "loiloilgamerecorder", "mirillis", "movavi.screen.recorder", 
    "nchexpressions", "nvsphelper64", "obs", "obs64", "openbroadcastsoftware", "playclaw", 
    "pycharm64", "recordmydesktop", "screenkey", "screenstudio", "simple.screen.recorder", 
    "smartpixel", "screencast", "streamlabs", "vokoscreenNG", "webrtcvad", "wmcap", "xsplit"
)

$processMap = @{
    "action" = "Action"
    "amdrsserv" = "AMD Radeon Recording"
    "apowersoftfreescreenrecorder" = "Apowersoft Free Screen Recorder"
    "bandicamlauncher" = "Bandicam"
    "bdcam" = "Bandicam"
    "camtasia" = "Camtasia"
    "captura" = "Captura"
    "d3dgear" = "D3DGear"
    "dxtory" = "Dxtory"
    "fraps" = "Fraps"
    "gadwinprintscreen" = "Gadwin PrintScreen"
    "gamebar" = "Windows-Xbox Gamebar"
    "geforce" = "GeForce Experience"
    "gtk-recordmydesktop" = "GTK RecordMyDesktop"
    "icecreamscreenrecorder" = "Icecream Screen Recorder"
    "jupyter-notebook" = "Jupyter Notebook"
    "kazam" = "Kazam"
    "lightstream" = "Lightstream"
    "loiloilgamerecorder" = "LoiLo Game Recorder"
    "mirillis" = "Mirillis"
    "movavi.screen.recorder" = "Movavi Screen Recorder"
    "nchexpressions" = "NCH Expressions"
    "nvsphelper64" = "GeForce Experience"
    "obs" = "OBS Studio"
    "obs64" = "OBS Studio"
    "openbroadcastsoftware" = "Open Broadcaster Software"
    "playclaw" = "PlayClaw"
    "pycharm64" = "PyCharm"
    "recordmydesktop" = "RecordMyDesktop"
    "screenkey" = "Screenkey"
    "screenstudio" = "ScreenStudio"
    "simple.screen.recorder" = "Simple Screen Recorder"
    "smartpixel" = "SmartPixel"
    "screencast" = "Screencast"
    "streamlabs" = "Streamlabs"
    "vokoscreenNG" = "VokoscreenNG"
    "webrtcvad" = "WebRTC VAD"
    "wmcap" = "WMCap"
    "xsplit" = "XSplit"
}

$vpnNames = @(
    "CyberGhost", "ExpressVPN", "HSSCP", "IpVanish", "NordVPN", "ProtonVPN", "ProtonVPNService", "pia-client", "pia-tray", "SurfShark", "TunnelBear", "VyprVPN", "WindScribe"
)

$interval = 1
$duration = 20
$processData = @{}
$deltaProcesses = @{}

for ($i = 0; $i -lt $duration; $i++) {
    $currentProcesses = Get-Process | Where-Object { $processNames -contains $_.Name.ToLower() }
    
    foreach ($process in $currentProcesses) {
        $processName = $process.Name.ToLower()
        if ($processMap.ContainsKey($processName)) {
            $displayName = $processMap[$processName]
            $privateBytes = $process.PrivateMemorySize64
            
            if (-not $processData.ContainsKey($displayName)) {
                $processData[$displayName] = @()
            }
            
            $processData[$displayName] += [pscustomobject]@{
                Time = (Get-Date).ToString("HH:mm:ss")
                PrivateBytes = $privateBytes
            }
        }
    }
    
    Start-Sleep -Seconds $interval
}

foreach ($process in $processData.Keys) {
    $data = $processData[$process]
    if ($data.Count -gt 1) {
        $initial = $data[0].PrivateBytes
        $final = $data[-1].PrivateBytes
        $delta = $final - $initial
        
        if ($delta -ne 0) {
            $deltaProcesses[$process] = [pscustomobject]@{
                InitialBytes = $initial
                FinalBytes = $final
                DeltaBytes = $delta
            }
        }
    }
}

$vpnRunning = $false
foreach ($vpnName in $vpnNames) {
    if (Get-Process -Name $vpnName -ErrorAction SilentlyContinue) {
        $vpnRunning = $true
        break
    }
}

Clear-Host
Write-Host "`n`n`n"
if ($vpnRunning) {
    Write-Output "VPN Running"
} else {
    if ($deltaProcesses.Count -gt 0) {
        Write-Output "Recording Process found:"
        foreach ($process in $processData.Keys) {
            if ($deltaProcesses.ContainsKey($process)) {
                Write-Output "$process (likely recording)"
            } else {
                Write-Output $process
            }
        }
    } else {
        Write-Output "No Screen Recording Process running."
    }
}


Remove-Item "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt" | Out-Null

Set-Clipboard -Value $null
cd\

Write-Host "`n`n`nDone!`n`n`n"
