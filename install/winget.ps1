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
    [pscustomobject]@{id="7zip.7zip";use="all";name="7zip"},
    [pscustomobject]@{id="balena.etcher";use="all";name="Balena Etcher"},
    [pscustomobject]@{id="Bitwarden.Bitwarden";use="all";name="Bitwarden"},
    [pscustomobject]@{id="Brave.Brave";use="all";name="Brave Browser"},
    [pscustomobject]@{id="EpicGames.EpicGamesLauncher";use="home";name="Epic Games Launcher"},
    [pscustomobject]@{id="gog.galaxy";use="home";name="GOG Galaxy"},
    [pscustomobject]@{id="greenshot.greenshot";use="all";name="Greenshot"},
    [pscustomobject]@{id="logmein.lastpass";use="all";name="Lastpass"},
    [pscustomobject]@{id="microsoft.windowsterminal";use="all";name="Microsoft Windows Terminal"},
    [pscustomobject]@{id="Microsoft.VisualStudioCode";use="all";name="Microsoft VSCode"},
    [pscustomobject]@{id="Microsoft.BingWallpaper";use="all";name="Microsoft Bing Wallpaper"},
    [pscustomobject]@{id="Mozilla.Firefox";use="all";name="Mozilla Firefox"},
    [pscustomobject]@{id="valve.steam";use="home";name="Valve Steam"},
    [pscustomobject]@{id="slacktechnologies.slack";use="all";name="Slack"},
    [pscustomobject]@{id="Spotify.Spotify";use="all";name="Spotify"},
    [pscustomobject]@{id="notepad++.notepad++";use="all";name="Notepad++"},
    [pscustomobject]@{id="Git.Git";use="all";name="Git"},
    [pscustomobject]@{id="Github.Desktop";use="all";name="Github Desktop"},
    [pscustomobject]@{id="Logitech.UnifyingSoftware";use="all";name="Logitech Unifying Software"},
    [pscustomobject]@{id="Ultimaker.Cura";use="home";name="Ultimaker Cura"}
)


$commonapps = @(
    "7zip.7zip",
    "balena.etcher",
    "Bitwarden.Bitwarden",
    "Brave.Brave",
    "EpicGames.EpicGamesLauncher",
    "greenshot.greenshot",
    "logmein.lastpass",
    "microsoft.windowsterminal",
    "Microsoft.VisualStudioCode",
    "Microsoft.BingWallpaper",
    "Mozilla.Firefox",
    "valve.steam",
    "slacktechnologies.slack",
    "Spotify.Spotify",
    "notepad++.notepad++",
    "Git.Git",
    "Github.Desktop",
    "Logitech.UnifyingSoftware",
    "Ultimaker.Cura"
)

# Install common apps
foreach($app in $apps | where {$_.use -eq "all"}) {
    write-host "Installing: $($app.name)"
    #& winget install $($app.id)
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
else {
    # Install home apps
    foreach($app in $apps | where {$_.use -eq "home"}) {
        write-host "Installing: $($app.name)"
        & winget install $($app.id)
    }
}