$hostname = "hoge"
$vhdpath = "C:\ClusterStorage\StorageVolumeName\Hyper-V"
$jeosFile = "\\NetworkDrivePath\JeOSImage.vhdx"
$vhdPath = "$vhdpath\$hostname\Virtual Hard Disks\"
$vhdFile = "$vhdpath\os.vhdx"

New-Item $vhdPath -ItemType Directory
Copy-Item $jeosFile -Destination $vhdFile

$getVMjson = Get-Content vm.json -raw | convertfrom-json
$getVMFirmwarejson = Get-Content firmware.json -raw | convertfrom-json
$getVMNetworkAdapterjson = Get-Content network.json -raw | convertfrom-json

New-VM `
  -Name $getVMjson.vmname `
  -MemoryStartupBytes $getVMjson.MemoryStartup `
  -Generation $getVMjson.Generation `
  -SwitchName $getVMjson.NetworkAdapters.SwitchName `
  -VHDPath '$getVMjson.ConfigurationLocation + '\os.vhdx'' `
  -Path $getVMjson.ConfigurationLocation `

Set-VMFirmware -VMName $getVMjson.VMName -EnableSecureBoot On -SecureBootTemplate $getVMFirmwarejson.SecureBootTemplate
Set-VMMemory -VMName $getVMjson.VMName -DynamicMemoryEnabled $getVMjson.DynamicMemoryEnabled
Set-VMProcessor -VMName $getVMjson.VMName -Count $getVMjson.ProcessorCount
Set-VMNetworkAdapterVlan -VMName $getVMjson.VMName -Access -VlanId $getVMNetworkAdapterjson.VlanSetting.AccessVlanId

