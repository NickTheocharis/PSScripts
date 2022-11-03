connect-azaccount
## Create resource group
New-AzResourceGroup -Name 'rg-dev-we-001' -Location 'WestEurope'
## Create Linux VM
$Credential = Get-Credential -Credential linuxadmin
New-AzVm `
    -ResourceGroupName 'rg-dev-we-001' `
    -Name 'vmlinux001' `
    -Location 'WestEurope' `
    -Image Debian `
    -size Standard_B2s `
    -PublicIpAddressName pip-dev-001 `
    -OpenPorts 80 `
    -Credential $Credential
   ## Create web server
   Invoke-AzVMRunCommand `
   -ResourceGroupName 'rg-dev-we-001' `
   -Name 'vmlinux001' `
   -CommandId 'RunShellScript' `
   -ScriptString 'sudo apt-get update && sudo apt-get install -y nginx'