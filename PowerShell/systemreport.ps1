


		
		

function Get-Hardware{
	# Get the system hardware description
	$computersystem = Get-WmiObject -Class Win32_ComputerSystem
	$manufacturer = $computersystem.Manufacturer
	$model = $computersystem.Model
	$serialnumber = $computersystem.SerialNumber
	Write-Host "# Get the system hardware description"
	Write-Host "computersystem: $computersystem"
	Write-Host "manufacturer: $manufacturer"
	Write-Host "model: $model"
	Write-Host "serialnumber: $serialnumber"
}




function Get-OS{
# Get the operating system name and version number
$operatingsystem = Get-WmiObject -Class Win32_OperatingSystem
$name = $operatingsystem.Caption
$version = $operatingsystem.Version
Write-Host "Get the operating system name and version number"
Write-Host "name: $name"
Write-Host "version: $version"
}

function Get-CPU{
# Get the processor description with speed, number of cores, and sizes of the L1, L2, and L3 caches
$processor = Get-WmiObject -Class Win32_Processor
$description = $processor.Name
$speed = $processor.MaxClockSpeed
$cores = $processor.NumberOfCores
$l1cache = $processor.L1CacheSize
$l2cache = $processor.L2CacheSize
$l3cache = $processor.L3CacheSize

Write-Host "Get the processor description with speed, number of cores, and sizes of the L1, L2, and L3 caches"
Write-Host "processor.Name: $description"
Write-Host "processor.speed: $speed"
Write-Host "processor.cores: $cores"
Write-Host "processor.L1: $l1cache"
Write-Host "processor.L2: $l2cache"
Write-Host "processor.L3: $l3cache"
}

function Get-RAM{
# Get a summary of the RAM installed
$memory = Get-WmiObject -Class Win32_PhysicalMemory
$table = $memory | Select-Object Manufacturer, PartNumber, Capacity, MemoryType, BankLabel, DeviceLocator
$totalram = ($memory.Capacity | Measure-Object -Sum).Sum / 1GB

# Print the RAM summary table and total RAM
Write-Host "RAM installed:" -ForegroundColor Yellow
$table | Format-Table -AutoSize
Write-Host "Total RAM installed: $totalram GB" -ForegroundColor Yellow
}

function Get-Disk{
# Get a summary of the physical disk drives and logical disks on them

Write-Host  "Include a summary of the physical disk drives with their vendor, model, size, and space usage (size, free space, and percentage free) of the logical disks on them as a single table with one logical disk per output line (win32_diskdrive, win32_diskpartition, win32_logicaldisk). You will need to use a nested foreach something like this:"
$diskDrives = Get-CimInstance CIM_DiskDrive

foreach ($diskDrive in $diskDrives) {
    $partitions = Get-CimAssociatedInstance -InputObject $diskDrive -ResultClassName CIM_DiskPartition

    foreach ($partition in $partitions) {
        $logicalDisks = Get-CimAssociatedInstance -InputObject $partition -ResultClassName CIM_LogicalDisk

        foreach ($logicalDisk in $logicalDisks) {
            $driveLetter = $logicalDisk.DeviceID
            $freeSpacePercent = [Math]::Round(($logicalDisk.FreeSpace / $logicalDisk.Size) * 100, 2)

            [PSCustomObject]@{
                "Drive Letter" = $driveLetter
                "Vendor" = $diskDrive.Manufacturer
                "Model" = $diskDrive.Model
                "Size (GB)" = [Math]::Round(($diskDrive.Size / 1GB), 2)
                "Free Space (GB)" = [Math]::Round(($logicalDisk.FreeSpace / 1GB), 2)
                "Used Space (GB)" = [Math]::Round((($logicalDisk.Size - $logicalDisk.FreeSpace) / 1GB), 2)
                "Free Space (%)" = $freeSpacePercent
            }
        }
    }
}


# Print the disk drive summary table
Write-Host "Physical disk drives:" -ForegroundColor Yellow
$table | Format-Table -AutoSize
}

function Get-Network{
Write-Host "Include your network adapter configuration report from lab 3"
Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled -eq $true} | Format-Table Description, Index, IPAddress, IPSubnet, DNSDomain, DNSHostName, DNSServerSearchOrder -AutoSize
}
function Get-Video{
Write-Host "Include the video card vendor, description, and current screen resolution in this format: horizontalpixels x verticalpixels (win32_videocontroller)"
Get-CimInstance Win32_VideoController | Format-Table AdapterCompatibility, Description, CurrentHorizontalResolution, CurrentVerticalResolution -AutoSize
}


function systemreport {

		param(
    [switch]$System,
    [switch]$Disks,
    [switch]$Network 
		)
		
if ($System){
			Get-CPU
			Get-OS
			Get-RAM
			Get-Video
			
		} 
		elseif  ($Disks){
			Get-Disk
		}
		elseif  ($Network){
			Get-Network
		}
		else {
			Get-Hardware
			Get-CPU
			Get-OS
			Get-RAM
			Get-Video
			Get-Disk
			Get-Network
		}


}
