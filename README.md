# Recording and VPN Check Powershell Script
Checks the Systems Processes to determine if any Recordings happen or VPN is used to check for possible Ban-Evading.

### Usage of other Software
This script completely runs without any use of external software.

### Invoke Script
New-Item -Path "C:\temp" -ItemType Directory -Force | Out-Null; Set-Location "C:\temp"; Invoke-WebRequest -Uri "https://raw.githubusercontent.com/dot-sys/Recording-Check/master/Recording-VPN-Check.ps1" -OutFile "rec_vpn_check.ps1"; Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force; Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy RemoteSigned -Force; .\rec_vpn_check.ps1
