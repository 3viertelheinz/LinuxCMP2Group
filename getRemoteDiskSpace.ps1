$Computers = Get-Content -Path ".\Computers.txt"

foreach ($Computer in $Computers) {
    try {
        $PingResult = Test-NetConnection -ComputerName $Computer -Port 80 -ErrorAction Stop -WarningAction SilentlyContinue | Out-Null
        if ($PingResult.TcpTestSucceeded) {
            $Computerstatus = "Up"
            try {
                $Disks = Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName $Computer -Filter "DriveType=3"
                foreach ($Disk in $Disks) {
                    $TotalSize = [math]::round($Disk.Size / 1GB, 2)
                    $FreeSpace = [math]::round($Disk.FreeSpace / 1GB, 2)
                    $FreeSpacePercent = [math]::round(($Disk.FreeSpace / $Disk.Size) * 100, 2)
                    Write-Host "Computer: $Computer, Drive: $($Disk.DeviceID), Total Size: ${TotalSize}GB, Free Space: ${FreeSpace}GB (${FreeSpacePercent}%)"
                }
            } catch {
                Write-Host "Failed to retrieve disk information for $Computer."
            }
        } else {
            $Computerstatus = "Down"
        }
    } catch {
        $Computerstatus = "Down"
    } finally {
        Write-Host "$Computer is $Computerstatus"
    }
}