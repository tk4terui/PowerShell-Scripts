$hostname = "hoge"
$vhdpath = "C:\ClusterStorage\StorageVolumeName\Hyper-V"
$jeosFile = "\\NetworkDrivePath\JeOSImage.vhdx"
$vhdPath = "$vhdpath\$hostname\Virtual Hard Disks\"
$vhdFile = "$vhdpath\os.vhdx"

New-Item $vhdPath -ItemType Directory
Copy-Item $jeosFile -Destination $vhdFile

$VMName = $hostname
$MemoryStartup = 2GB
$Generation = 2
$SwitchName = "LACP"
$ConfigurationLocation = "C:\ClusterStorage\StorageVolumeName\Hyper-V"
$ProcessorCount = 1
$AccessVlanId = 10

New-VM `
  -Name $VMname `
  -MemoryStartupBytes $MemoryStartup `
  -Generation $Generation `
  -SwitchName $SwitchName `
  -VHDPath $vhdFile `
  -Path $ConfigurationLocation `

Set-VMFirmware -VMName $VMName -EnableSecureBoot On -SecureBootTemplate MicrosoftUEFICertificateAuthority
Set-VMMemory -VMName $VMName -DynamicMemoryEnabled $True
Set-VMProcessor -VMName $VMName -Count $ProcessorCount
Set-VMNetworkAdapterVlan -VMName $VMName -Access -VlanId $AccessVlanId