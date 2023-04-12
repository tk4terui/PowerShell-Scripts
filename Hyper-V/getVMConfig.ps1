$vmname = 'hoge'
mkdir $vmname
cd $vmname

Get-VMNetworkAdapter $vmname | convertto-json > network.json
Get-VMFirmware $vmname | convertto-json > firmware.json
Get-VM -name $vmname | convertto-json > vm.json

cd ..