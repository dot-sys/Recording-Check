# Checking Script
# For safe and local quick-dumping of System logs and files
#
# Author:
# Created by dot-sys under MIT license
# This script is not related to any external Project.
#
# Usage:
# Use with Powershell 5.1 and NET 4.0 or higher.
# Running PC Checking Programs, including this script, outside of PC Checks may have impact on the outcome.
# It is advised not to use this on your own.
#
# Version 2.0
# 27 - November - 2024

$ErrorActionPreference = "SilentlyContinue" 
Clear-Host
Write-Host "`n`n`n-------------------------------"-ForegroundColor yellow
Write-Host "|  Checking VPN + Recording   |" -ForegroundColor yellow
Write-Host "|         Please Wait         |" -ForegroundColor yellow
Write-Host "-------------------------------`n"-ForegroundColor yellow
Write-Host "     This takes 30 Seconds`n`n`n"-ForegroundColor yellow

$processNames = @(
    "action", "amdrsserv", "apowersoft", "bandicam", "bdcam", 
    "camtasia", "captura", "d3dgear", "dxtory", "fraps", "gadwinprintscreen", "geforce"
    "gtk-recordmydesktop", "icecreamscreenrecorder", "jupyter-notebook", "kazam", 
    "lightstream", "loiloilgamerecorder", "mirillis", "movavi.screen.recorder", 
    "nchexpressions", "nvsphelper64", "obs", "obs64", "openbroadcastsoftware", "playclaw", 
    "pycharm64", "recordmydesktop", "screenkey", "screenstudio", "simple.screen.recorder", 
    "smartpixel", "screencast", "streamlabs", "vokoscreenNG", "webrtcvad", "wmcap", "xsplit", 
    "medal", "Medal-Encoder", "obs-ffmpeg-mux", "Overwolf", "Overwolf-Helper", "AMDRSSrcExt"
)

$processMap = @{
    "action" = "Action"
    "AMDRSSrcExt"  = "AMD Radeon Recording"
    "amdrsserv" = "AMD Radeon Recording"
    "apowersoft" = "Apowersoft Free Screen Recorder"
    "bandicam" = "Bandicam"
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
    "medal" = "Medal Recorder"
    "Medal-Encoder" = "Medal Recorder"
    "mirillis" = "Mirillis"
    "movavi.screen.recorder" = "Movavi Screen Recorder"
    "nchexpressions" = "NCH Expressions"
    "nvsphelper64" = "GeForce Experience"
    "obs" = "OBS Studio"
    "obs64" = "OBS Studio"
    "obs-ffmpeg-mux" = "OBS Studio"
    "openbroadcastsoftware" = "Open Broadcaster Software"
    "overwolf" = "Overwolf"
    "overwolf-helper" = "Overwolf"
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
    "360Total", "1Password", "AccessVPN", "AirVPN", "AmigoVPN", "Anonymizer", 
    "Astrill", "Avira", "Boleh", "BoxPN", "Buffered", "Celo", "Cinder", "Cisco",
    "Cloak", "Cryptostorm", "Crypt", "DotVPN", "DuckDuckGo", 
    "Froot", "FrontlineVPN", "Green", "Hide.me", "HideMyAss", "IPPredator", "IVPN", 
    "Kaspersky", "LeVPN", "Logic", "AirVPN", "Atlas", "Avast SecureLine", "AvastSecureLine", 
    "Bitdefender", "CactusVPN", "CyberGhost", "ExpressVPN", "GooseVPN", "HMA", "HotspotShield", 
    "Hotspot Shield", "IPVanish", "KeepSolid VPN", "KeepSolidVPN", "Mullvad", "Norton", "Norton Secure",
    "Nord", "NordVPN", "Panda", "Perimeter81", "Perimeter 81", "PIA", 
    "PrivateVPN", "Proton", "PureVPN", "SaferVPN", "StrongVPN", 
    "Surfshark", "TorGuard", "TunnelBear", "UltraVPN", "VyprVPN", "Windscribe"
)

$moduleNames = @(
    "dxgi.dll", "d3d11.dll", "d3d12.dll", "webrtc.dll", "libjingle.dll", 
    "rtmp.dll", "vulkan-1.dll", "opengl32.dll", "gdi32.dll", 
    "windows.ui.dll", "windows.graphics.capture.dll", "nvfbc.dll", 
    "amfrt64.dll", "amfrt32.dll", "mf.dll", "avcapture.dll", "mfplat.dll",
    "x264vfw.dll", "nvEncodeAPI64.dll", "ffmpeg.dll", "nvencenc.dll",
    "vce_hw_encode.dll", "libx264.dll", "avcodec-58.dll", "avformat-58.dll"
)

$streamingDLLs = @(
    "webrtc.dll", "rtmp.dll", "dxgi.dll", "opengl32.dll", "vulkan-1.dll", 
    "gdi32.dll", "windows.ui.dll", "windows.graphics.capture.dll", "libcef.dll", "v8.dll"
)

$runningProcesses = Get-Process | ForEach-Object {
    $process = $_
    $process.Modules | ForEach-Object {
        [PSCustomObject]@{
            ProcessName = $process.ProcessName
            ModuleName  = $_.ModuleName
        }
    }
}

$runningPrograms = $runningProcesses | Where-Object {
    $processName = $_.ProcessName
    $processNames | Where-Object { $processName -like "*$_*" }
} | Select-Object -ExpandProperty ProcessName -Unique

$loadedDLLs = $runningProcesses | Where-Object {
    ($moduleNames -contains $_.ModuleName) -and
    ($processNames -contains $_.ProcessName)
} | Select-Object -ExpandProperty ProcessName -Unique

$runningPrograms += $loadedDLLs

$runningPrograms = $runningprograms | Select-Object -Unique

$runningStreams = $runningProcesses | Where-Object {
    ($streamingDLLs -contains $_.ModuleName) -and
    ($processNames -contains $_.ProcessName)
} | Select-Object -ExpandProperty ProcessName -Unique

$installedPrograms = @()
$installedPrograms += Get-WmiObject -Class Win32_Product | Select-Object -ExpandProperty Name
$installedPrograms += Get-CimInstance -ClassName Win32_Product | Select-Object -ExpandProperty Name
$installedPrograms += (winget list --accept-source-agreements | ForEach-Object { $_.Name })
$installedPrograms += (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object -ExpandProperty DisplayName)
$installedPrograms += (Get-ItemProperty HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object -ExpandProperty DisplayName)
$installedPrograms += (Get-Package | Select-Object -ExpandProperty Name)
$installedPrograms += $runningprograms

$foundRecorders = $processNames | ForEach-Object {
    if ($installedPrograms -contains $_) {
        if ($processMap[$_] -ne $null) {
            $processMap[$_]
        } else {
            $_
        }
    }
}

$foundVPNs = $vpnNames | Where-Object { $installedPrograms -contains $_ } | Select-Object -Unique

Clear-Host
Write-Host "`n`n`n"

$foundVPNs = $installedPrograms | Where-Object {
    $program = $_
    $vpnNames | Where-Object { $program -like "*$_*" }  | Select-Object -Unique
}

if ($foundVPNs) {
    Write-Output "`nPossible VPN Software installed:"
    $foundVPNs | Select-Object -Unique | ForEach-Object { Write-Output $_ }
}

$foundRecorders = $installedPrograms | Where-Object {
    $program = $_
    $processNames | Sort-Object -Unique | Where-Object { $program -like "*$_*" }
}

if ($foundRecorders) {
    Write-Output "`nPossible Recording Software installed:"
    $foundRecorders | Select-Object -Unique | ForEach-Object { Write-Output $_ }
}

if ($runningStreams) {
    Write-Output "`nPossible Streams running:"
    $runningStreams | Select-Object -Unique  | ForEach-Object { Write-Output $_ }
}

if ($runningPrograms) {
    Write-Output "`nRecording Software running:"
    $runningPrograms | Select-Object -Unique | ForEach-Object { Write-Output $_ }
}

if ($runningPrograms -or $runningStreams) {
    do {
        $userChoice = Read-Host "`n`nDo you want to open Task Manager to manage these programs or streams? (Y/N)"
        if ($userChoice -eq 'Y') {
            Start-Process -FilePath "taskmgr.exe"
            Write-Host "`tTask Manger opened.`n"
            Write-Host "`tReturning to Menu in " -NoNewline
            Write-Host "3 " -NoNewline -ForegroundColor Magenta
            Write-Host "Seconds`n`n`n" -NoNewline
            Start-Sleep 3
            break
        } elseif ($userChoice -eq 'N') {
            Write-Host "`n`n`n`tUser chose No" -ForegroundColor Red
            Write-Host "`tReturning to Menu in " -NoNewline
            Write-Host "3 " -NoNewline -ForegroundColor Magenta
            Write-Host "Seconds`n`n`n" -NoNewline
            Start-Sleep 3
            break
        } else {
            Write-Host "`tInvalid choice. Please respond with 'Y' or 'N'." -ForegroundColor Red
        }
    } while ($true)
} else {
    Write-Output "`tNo running recording software or streams found." -ForegroundColor Yellow
    Write-Output "`tReturning to Menu." -ForegroundColor Yellow
    Start-Sleep 3
    break
}

Clear-Host
& "C:\Temp\Scripts\Menu.ps1"
