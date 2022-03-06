#Mostrar el usuario actual:
Write-Output User
$PCName = @{
	Name = "Computer name"
	Expression = {$_.Name}
}
$Domain = @{
	Name = "Domain"
	Expression = {$_.Domain}
}
$UserName = @{
	Name = "User Name"
	Expression = {$_.UserName}
}
(Get-CimInstance –ClassName CIM_ComputerSystem | Select-Object -Property $PCName, $Domain, $UserName | Format-Table | Out-String).Trim()

#Mostrar los usuarios locales:
Write-Output "`nLocal Users"
(Get-LocalUser | Out-String).Trim()

#Mostrar los grupos AD que pertenece:
Write-Output "`nGroup Membership"
Get-ADPrincipalGroupMembership $env:USERNAME | Select-Object -Property Name

#Info del S.O:
Write-Output "`nOperating System"
$ProductName = @{
	Name = "Product Name"
	Expression = {$_.Caption}
}
$InstallDate = @{
	Name = "Install Date"
	Expression=  {$_.InstallDate.Tostring().Split("")[0]}
}
$Arch = @{
	Name = "Architecture"
	Expression = {$_.OSArchitecture}
}
$a = Get-CimInstance -ClassName CIM_OperatingSystem | Select-Object -Property $ProductName, $InstallDate, $Arch
$Build = @{
	Name = "Build"
	Expression = {"$($_.CurrentMajorVersionNumber).$($_.CurrentMinorVersionNumber).$($_.CurrentBuild).$($_.UBR)"}
}
$b = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows nt\CurrentVersion" | Select-Object -Property $Build
([PSCustomObject] @{
	"Product Name" = $a."Product Name"
	Build = $b.Build
	"Install Date" = $a."Install Date"
	Architecture = $a.Architecture
} | Out-String).Trim()

#Mostrar los programas instalados en el equipo:
Write-Output "`nRegistered apps"
(Get-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*,HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*).DisplayName | Sort-Object
#endregion Registered apps

#Actualizaciones del sistema operativo, mediante CBS (herramienta de análisis y manteniendo de Windows):
Write-Output "`nInstalled updates supplied by CBS"
$HotFixID = @{
	Name = "KB ID"
	Expression = {$_.HotFixID}
}
$InstalledOn = @{
	Name = "Installed on"
	Expression = {$_.InstalledOn.Tostring().Split("")[0]}
}
(Get-HotFix | Select-Object -Property $HotFixID, $InstalledOn -Unique | Format-Table | Out-String).Trim()

#Actualizaciones del sistema operativo, mediante MSI:
Write-Output "`nInstalled updates supplied by MSI/WU"
$Session = New-Object -ComObject "Microsoft.Update.Session"
$Searcher = $Session.CreateUpdateSearcher()
$historyCount = $Searcher.GetTotalHistoryCount()
$KB = @{
	Name = "KB ID"
	Expression = {[regex]::Match($_.Title,"(KB[0-9]{6,7})").Value}
}
$Date = @{
	Name = "Installed on"
	Expression = {$_.Date.Tostring().Split("")[0]}
}
($Searcher.QueryHistory(0, $historyCount) | Where-Object -FilterScript {$_.Title -like "*KB*" -and $_.ResultCode -eq 2} | Select-Object $KB, $Date | Format-Table | Out-String).Trim()

#Mostrar discos, volumenes, o unidades flash actuales:
Write-Output "`nLogical drives"
$Name = @{
	Name = "Name"
	Expression = {$_.DeviceID}
}
enum DriveType
{
	RemovableDrive	=	2
	HardDrive	=	3
}
$Type = @{
	Name = "Drive Type"
	Expression = {[System.Enum]::GetName([DriveType],$_.DriveType)}
}
$Size = @{
	Name = "Size, GB"
	Expression = {[math]::round($_.Size/1GB, 2)}
}
$FreeSpace = @{
	Name = "FreeSpace, GB"
	Expression = {[math]::round($_.FreeSpace/1GB, 2)}
}
(Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object -FilterScript {$_.DriveType -ne 4} | Select-Object -Property $Name, $Type, $Size, $FreeSpace | Format-Table | Out-String).Trim()

#Mostrar hardware (info de la BIOS, modelo placa base, CPU, RAM, discos fisicos y la grafica):
#BIOS
Write-Output "`nBIOS"
$Version = @{
	Name = "Version"
	Expression = {$_.Name}
}
(Get-CimInstance -ClassName CIM_BIOSElement | Select-Object -Property Manufacturer, $Version | Format-Table | Out-String).Trim()

#Placa base:
Write-Output "`nMotherboard"
(Get-CimInstance -ClassName Win32_BaseBoard | Select-Object -Property Manufacturer, Product | Format-Table | Out-String).Trim()

#CPU
Write-Output "`nCPU"
$Cores = @{
	Name = "Cores"
	Expression = {$_.NumberOfCores}
}
$L3CacheSize = @{
	Name = "L3, MB"
	Expression = {$_.L3CacheSize / 1024}
}
$Threads = @{
	Name = "Threads"
	Expression = {$_.NumberOfLogicalProcessors}
}
(Get-CimInstance -ClassName CIM_Processor | Select-Object -Property Name, $Cores, $L3CacheSize, $Threads | Format-Table | Out-String).Trim()

#RAM
Write-Output "`nRAM"
$Speed = @{
	Name = "Speed, MHz"
	Expression = {$_.ConfiguredClockSpeed}
}
$Capacity = @{
	Name = "Capacity, GB"
	Expression = {$_.Capacity / 1GB}
}
(Get-CimInstance -ClassName CIM_PhysicalMemory | Select-Object -Property Manufacturer, PartNumber, $Speed, $Capacity | Format-Table | Out-String).Trim()

#Discos fisicos
Write-Output "`nPhysical disks"
$Model = @{
	Name = "Model"
	Expression = {$_.FriendlyName}
}
$MediaType = @{
	Name = "Drive type"
	Expression = {$_.MediaType}
}
$Size = @{
	Name = "Size, GB"
	Expression = {[math]::round($_.Size/1GB, 2)}
}
$BusType = @{
	Name = "Bus type"
	Expression = {$_.BusType}
}
(Get-PhysicalDisk | Select-Object -Property $Model, $MediaType, $BusType, $Size | Format-Table | Out-String).Trim()

#En caso de que la grafica sea integrada
IF ((Get-CimInstance -ClassName CIM_VideoController | Where-Object -FilterScript {$_.AdapterDACType -eq "Internal"}))
{
	$Caption = @{
		Name = "Model"
		Expression = {$_.Caption}
	}
	$VRAM = @{
		Name = "VRAM, GB"
		Expression = {[math]::round($_.AdapterRAM/1GB)}
	}
	Get-CimInstance -ClassName CIM_VideoController | Where-Object -FilterScript {$_.AdapterDACType -eq "Internal"} | Select-Object -Property $Caption, $VRAM
}

#En caso de que la grafica sea externa
IF ((Get-CimInstance -ClassName CIM_VideoController | Where-Object -FilterScript {$_.AdapterDACType -ne "Internal"}))
{
	$qwMemorySize = Get-ItemPropertyValue -Path "HKLM:\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0*" -Name HardwareInformation.qwMemorySize
	$VRAM = [math]::round($qwMemorySize/1GB)
	Get-CimInstance -ClassName CIM_VideoController | Where-Object -FilterScript {$_.AdapterDACType -ne "Internal"} | ForEach-Object -Process {
		[PSCustomObject] @{
			Model = $_.Caption
			"VRAM, GB" = $VRAM
		}
	}
}

#Mostrar impresoras instaladas:
Write-Output "`nPrinters"
Get-CimInstance -ClassName CIM_Printer | Select-Object -Property Name, Default, PortName, DriverName, ShareName | Format-Table

#Mostrar IPs de cada targeta de red:
Write-Output "`nMy IP"
Write-Output "-----"
(Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration).IPAddress
