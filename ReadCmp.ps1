$Computers = Get-Content -Path ".\Computers.txt"

foreach ($Computer in $Computers) {
    try {
        $PingResult = Test-NetConnection -ComputerName $Computer -Port 80 -ErrorAction Stop -WarningAction SilentlyContinue  Out-Null|
        if ($PingResult.TcpTestSucceeded) {
            $Computerstatus = "Up"
        }
        else {
            $Computerstatus = "Down"
        }
        
        
    }
    catch {
        $Computerstatus = "Down"
    }
    finally {
        Write-Host "$Computer is $Computerstatus"

    }
}
    
    
    