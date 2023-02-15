function Test-RegistryValue {
    param (

     [parameter(Mandatory=$true)]
     [ValidateNotNullOrEmpty()]$Path,

    [parameter(Mandatory=$true)]
     [ValidateNotNullOrEmpty()]$Value
    )

    try {
        Get-ItemProperty -Path $Path | Select-Object -ExpandProperty $Value -ErrorAction Stop | Out-Null
        return $true
    }
    catch {
        return $false
    }
}





$apps = @(
"7zip.7zip",
"balena.etcher",
"Bitwarden.Bitwarden",
"BraveSoftware.BraveBrowser",
"greenshot.greenshot",
"logmein.lastpass",
"microsoft.windowsterminal",
"Microsoft.VisualStudioCode",
"Microsoft.BingWallpaper",
"valve.steam",
"slacktechnologies.slack",
"Spotify.Spotify",
"notepad++.notepad++",
"Git.Git",
"Github.Desktop",
"Logitech.UnifyingSoftware",
"Ultimaker.Cura"
)

foreach($app in $apps) {

write-host "Installing: $app"
& winget install $app

}


# Check if computer part of domain
[bool]$DomainConnected = [bool](Get-WmiObject -Class Win32_ComputerSystem).PartOfDomain

# Check if computer is on workgroup
[bool]$WorkgroupConnected = [bool](Get-WmiObject -Class Win32_ComputerSystem).Workgroup

if($DomainConnected -and !$WorkgroupConnected) {
    $DomainName = $env:USERDNSDOMAIN

    write-host "Connected to $DomainName" -BackgroundColor Green -ForegroundColor Black


    # Check reg key value to avoid WSUS error
    $registryPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Servicing"
    $registryValueName = "RepairContentServerSource"
    $registryValueData = '2'
    $registryType = "DWORD"

    if(!(Test-Path $registryPath)) {
        New-Item -Path $registryPath
    }

    if(Test-Path $registryPath) {
        if(Test-RegistryValue -Path $registryPath -Value $registryValueName) {
            write-host "Setting registry value"
            Set-ItemProperty -Path $registryPath -Name $registryValueName -Value $registryValueData -Force
        }
        else {
            write-host "creating registry value"
            New-ItemProperty -Path $registryPath -Name $registryValueName -Value $registryValueData -PropertyType $registryType -Force
        }
    }

    # Check reg key value to avoid WSUS error
    $registryPath = "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU"
    $registryValueName = "UseWUServer"
    $registryValueData = '1'
    $registryType = "DWORD"

    if(Test-Path $registryPath) {
        if(Test-RegistryValue -Path $registryPath -Value $registryValueName) {
            if((Get-ItemPropertyValue -Path $registryPath -Name $registryValueName) -eq $registryValueData) {
                $UseWUServer = $true
                Set-ItemProperty -Path $registryPath -Name $registryValueName -Value "0" -Force
                Get-Service wuauserv | Restart-Service
            }
        }
    }

    write-host "Install RSAT" -BackgroundColor Green -ForegroundColor Black
    Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability -Online

    if($UseWUServer) {
        Set-ItemProperty -Path $registryPath -Name $registryValueName -Value $registryValueData -Force
        Get-Service wuauserv | Restart-Service   
    }
}