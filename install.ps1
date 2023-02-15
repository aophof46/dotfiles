
function Verify-Elevated {
    # Get the ID and security principal of the current user account
    $myIdentity=[System.Security.Principal.WindowsIdentity]::GetCurrent()
    $myPrincipal=new-object System.Security.Principal.WindowsPrincipal($myIdentity)
    # Check to see if we are currently running "as Administrator"
    return $myPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}


# Check to see if we are currently running "as Administrator"
if (!(Verify-Elevated)) {
   $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
   $newProcess.Arguments = $myInvocation.MyCommand.Definition;
   $newProcess.Verb = "runas";
   [System.Diagnostics.Process]::Start($newProcess);

   exit
}

# PowerShell v2
$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition

### Power settings
# Power: Disable Hibernation
powercfg /hibernate off

# Disable sleep/monitor timeout:
powercfg /X standby-timeout-ac 0
powercfg /X monitor-timeout-ac 0

# Set power slider to "Best Performance"
$PowerStatus = Get-CimInstance -Namespace root\wmi -ClassName BatteryStatus

#Returns TRUE (AC attached), FALSE (otherwise)
#$PowerStatus.PowerOnline

#If($PowerStatus.PowerOnline)
If($PowerStatus)
{
    #overlay_scheme_none == "Recommended"
    #overlay_scheme_high == "Better Performance"
    #overlay_scheme_max == "Best Performance"
    "powercfg.exe /overlaysetactive overlay_scheme_max"
}


# Explorer settings


# Prerequisite: Ensure necessary registry paths
if (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer")) {New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Type Folder | Out-Null}
if (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState")) {New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" -Type Folder | Out-Null}
if (!(Test-Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Search")) {New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Search" -Type Folder | Out-Null}

# Explorer: Show file extensions by default: Hide: 1, Show: 0
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideFileExt" 0

# Explorer: Disable creating Thumbs.db files on network volumes: Enable: 0, Disable: 1
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "DisableThumbnailsOnNetworkFolders" 1

# Explorer: Show path in title bar: Hide: 0, Show: 1
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" "FullPath" 1



# Install packages
if($PSScriptRoot) {
& $($PSScriptRoot + "\install\winget.ps1")
} 