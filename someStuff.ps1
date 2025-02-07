# Define the name to check
$NameToCheck = "www.google.ch"

# Check A Record
try {
    $ARecord = Resolve-DnsName -Type A -Name $NameToCheck -ErrorAction Stop
    Write-Output "A Record:"
    $ARecord
    $IPAddress = $ARecord.IPAddress
} catch {
    Write-Output "Failed to resolve A record for $NameToCheck."
    $IPAddress = $null
}

# Check PTR Record if A record was resolved
if ($IPAddress) {
    try {
        $PTRRecord = Resolve-DnsName -Type PTR -Name $IPAddress -ErrorAction Stop
        Write-Output "PTR Record:"
        $PTRRecord
        $PTRHostname = $PTRRecord.NameHost
    } catch {
        Write-Output "Failed to resolve PTR record for IP $IPAddress."
        $PTRHostname = $null
    }

    # Verify if the hostname matches the original name
    if ($PTRHostname -eq $NameToCheck) {
        Write-Output "The name and IP address match."
    } else {
        Write-Output "The name and IP address do not match."
    }
} else {
    Write-Output "Skipping PTR record check due to failed A record resolution."
}