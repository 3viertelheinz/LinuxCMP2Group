# Define variables
$ComputerName = "NewComputer"
$ComputerOU = "OU=Computers,DC=example,DC=com"
$GroupName = "ComputersGroup"
$GroupOU = "OU=Groups,DC=example,DC=com"

# Import the Active Directory module
Import-Module ActiveDirectory

# Create the new computer object
New-ADComputer -Name $ComputerName -SamAccountName $ComputerName -Path $ComputerOU -Enabled $true
Write-Host "Computer $ComputerName created in OU $ComputerOU."

# Check if the group exists
$Group = Get-ADGroup -Filter { Name -eq $GroupName } -SearchBase $GroupOU -ErrorAction SilentlyContinue

if ($Group) {
    Write-Host "Group $GroupName already exists in OU $GroupOU."
} else {
    # Create the group if it does not exist
    New-ADGroup -Name $GroupName -GroupScope Global -Path $GroupOU
    Write-Host "Group $GroupName created in OU $GroupOU."
}

# Add the computer to the group
Add-ADGroupMember -Identity $GroupName -Members $ComputerName
Write-Host "Computer $ComputerName added to group $GroupName."
