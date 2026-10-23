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
    [pscustomobject]@{id="nirsoft.bluescreenview";use="all";name="Nirsoft BluescreenView"},
    [pscustomobject]@{id="Bitwarden.Bitwarden";use="all";name="Bitwarden"},
    [pscustomobject]@{id="Brave.Brave";use="all";name="Brave Browser"},
    [pscustomobject]@{id="EpicGames.EpicGamesLauncher";use="home";name="Epic Games Launcher"},
    [pscustomobject]@{id="gog.galaxy";use="home";name="GOG Galaxy"},
    [pscustomobject]@{id="greenshot.greenshot";use="all";name="Greenshot"},
    [pscustomobject]@{id="IrfanSkiljan.IrfanView";use="all";name="IrfanView"},
#    [pscustomobject]@{id="logmein.lastpass";use="all";name="Lastpass"},
    [pscustomobject]@{id="microsoft.PowerToys";use="all";name="Microsoft Power Toys"},
    [pscustomobject]@{id="microsoft.windowsterminal";use="all";name="Microsoft Windows Terminal"},
    [pscustomobject]@{id="Microsoft.VisualStudioCode";use="all";name="Microsoft VSCode"},
    [pscustomobject]@{id="Microsoft.BingWallpaper";use="all";name="Microsoft Bing Wallpaper"},
    [pscustomobject]@{id="Mozilla.Firefox";use="all";name="Mozilla Firefox"},
    [pscustomobject]@{id="valve.steam";use="home";name="Valve Steam"},
    [pscustomobject]@{id="slacktechnologies.slack";use="all";name="Slack"},
    [pscustomobject]@{id="Spotify.Spotify";use="all";name="Spotify"},
    [pscustomobject]@{id="notepad++.notepad++";use="all";name="Notepad++"},
    [pscustomobject]@{id="Git.Git";use="all";name="Git"},
    [pscustomobject]@{id="GitHub.GitHubDesktop";use="all";name="Github Desktop"},
#    [pscustomobject]@{id="Logitech.UnifyingSoftware";use="all";name="Logitech Unifying Software"},
    [pscustomobject]@{id="Ultimaker.Cura";use="home";name="Ultimaker Cura"}
)

$RSATapps = @(
    [pscustomobject]@{displayname="RSAT: Active Directory Domain Services and Lightweight Directory Services Tools"; name="Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0"},
    #[pscustomobject]@{displayname="RSAT: PowerShell module for Azure Stack HCI"; name="Rsat.AzureStack.HCI.Management.Tools~~~~0.0.1.0"},
    [pscustomobject]@{displayname="RSAT: BitLocker Drive Encryption Administration Utilities"; name="Rsat.BitLocker.Recovery.Tools~~~~0.0.1.0"},
    #[pscustomobject]@{displayname="RSAT: Active Directory Certificate Services Tools"; name="Rsat.CertificateServices.Tools~~~~0.0.1.0"},
    #[pscustomobject]@{displayname="RSAT: DHCP Server Tools"; name="Rsat.DHCP.Tools~~~~0.0.1.0"},
    #[pscustomobject]@{displayname="RSAT: DNS Server Tools"; name="Rsat.Dns.Tools~~~~0.0.1.0"},
    #[pscustomobject]@{displayname="RSAT: Failover Clustering Tools"; name="Rsat.FailoverCluster.Management.Tools~~~~0.0.1.0"},
    #[pscustomobject]@{displayname="RSAT: File Services Tools"; name="Rsat.FileServices.Tools~~~~0.0.1.0"},
    [pscustomobject]@{displayname="RSAT: Group Policy Management Tools"; name="Rsat.GroupPolicy.Management.Tools~~~~0.0.1.0"},
    #[pscustomobject]@{displayname="RSAT: IP Address Management (IPAM) Client"; name="Rsat.IPAM.Client.Tools~~~~0.0.1.0"},
    #[pscustomobject]@{displayname="RSAT: Data Center Bridging LLDP Tools"; name="Rsat.LLDP.Tools~~~~0.0.1.0"},
    #[pscustomobject]@{displayname="RSAT: Network Controller Management Tools"; name="Rsat.NetworkController.Tools~~~~0.0.1.0"},
    #[pscustomobject]@{displayname="RSAT: Network Load Balancing Tools"; name="Rsat.NetworkLoadBalancing.Tools~~~~0.0.1.0"},
    #[pscustomobject]@{displayname="RSAT: Remote Access Management Tools"; name="Rsat.RemoteAccess.Management.Tools~~~~0.0.1.0"},
    #[pscustomobject]@{displayname="RSAT: Remote Desktop Services Tools"; name="Rsat.RemoteDesktop.Services.Tools~~~~0.0.1.0"},
    #[pscustomobject]@{displayname="RSAT: Server Manager"; name="Rsat.ServerManager.Tools~~~~0.0.1.0"},
    #[pscustomobject]@{displayname="RSAT: Storage Migration Service Management Tools"; name="Rsat.StorageMigrationService.Management.Tools~~~~0.0.1.0"},
    #[pscustomobject]@{displayname="RSAT: Storage Replica Module for Windows PowerShell"; name="Rsat.StorageReplica.Tools~~~~0.0.1.0"},
    #[pscustomobject]@{displayname="RSAT: System Insights Module for Windows PowerShell"; name="Rsat.SystemInsights.Management.Tools~~~~0.0.1.0"},
    #[pscustomobject]@{displayname="RSAT: Volume Activation Tools"; name="Rsat.VolumeActivation.Tools~~~~0.0.1.0"},
    [pscustomobject]@{displayname="RSAT: Windows Server Update Services Tools"; name="Rsat.WSUS.Tools~~~~0.0.1.0"}
)

# Install common apps
Write-Host "Installing apps for use everywhere"
foreach($app in $apps | where {$_.use -eq "all"}) {
    write-host "Installing: $($app.name)"
    & winget install $($app.id) --accept-source-agreements --accept-package-agreements
}

# Check if computer part of domain
[bool]$DomainConnected = [bool](Get-WmiObject -Class Win32_ComputerSystem).PartOfDomain

# Check if computer is on workgroup
[bool]$WorkgroupConnected = [bool](Get-WmiObject -Class Win32_ComputerSystem).Workgroup

[bool]$EntraConnected = [bool](Test-Path "HKLM:\SYSTEM\CurrentControlSet\Control\CloudDomainJoin\TenantInfo")

if($DomainConnected -or $EntraConnected) {
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
                Get-Service wuauserv | Stop-Service
                start-sleep 5
                Get-Service wuauserv | Start-Service
            }
        }
    }

    write-host "Install RSAT" -BackgroundColor Green -ForegroundColor Black
    #Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability -Online
    foreach($RSATapp in $RSATapps) {
        if(!(Get-WindowsCapability -Name $RSATapp.name -Online | Where-Object {$_.State -eq "Installed"})) {
            write-host "Installing: $($RSATapp.displayname)"
            Add-WindowsCapability -Name $RSATapp.name -Online
        }
        else {
            write-host "$($RSATapp.displayname) already installed"
        }
    }

    if($UseWUServer) {
        Set-ItemProperty -Path $registryPath -Name $registryValueName -Value $registryValueData -Force
        Get-Service wuauserv | Restart-Service   
    }
}
else {
    # Install home apps
    Write-Host "Installing apps for home use"
    foreach($app in $apps | where {$_.use -eq "home"}) {
        write-host "Installing: $($app.name)"
        & winget install $($app.id)
    }
}
