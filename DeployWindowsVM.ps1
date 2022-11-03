Connect-AzAccount

$Location = 'WestEurope'
New-AzResourceGroup -Name 'rg-prod-we-001' -Location $Location
$RG = "rg-prod-we-001"
## Create Vnet 
$vnet = @{
    Name = 'vnet-prod-we-001'
    ResourceGroupName = $RG
    Location = $Location
    AddressPrefix = '10.1.0.0/16'    
}
$Vnet = New-AzVirtualNetwork @vnet

## Create subnet
$subnet = @{
    Name = 'snet-prod-we-001'
    VirtualNetwork = $vnet
    AddressPrefix = '10.1.0.0/24'
}
$subnetConfig = Add-AzVirtualNetworkSubnetConfig @subnet

## Associate subnet to Vnet

$vnet | Set-AzVirtualNetwork

## Get OS Images

Get-AzVMImageSku `
   -Location $Location `
   -PublisherName "MicrosoftWindowsServer" `
   -Offer "WindowsServer"
Get-AzVMImageOffer `
   -Location $Location `
   -PublisherName "MicrosoftWindowsServer"

New-AzVm `
    -ResourceGroupName $RG `
    -Name 'vm-win-we-001' `
    -Location $Location `
    -VirtualNetworkName $Vnet `
    -SubnetName $subnet `
    -SecurityGroupName 'nsg-prod-we-001' `
    -PublicIpAddressName 'pip-prod-we-001' `
    -ImageName  "MicrosoftWindowsServer:WindowsServer:2022-datacenter-g2:latest" `
    -OpenPorts 80,3389
    
    