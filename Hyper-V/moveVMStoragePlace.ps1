# the location of configured files for vm tagged test moves to new place. 
$arrayVM = get-vm | where {$_.Notes -match 'test'}
foreach ($vm in $arrayVM.Name) {
    Write-Output $vm
    Move-VMStorage $vm -DestinationStoragePath "C:\ClusterStorage\TargetVolume\Hyper-V\$vm"
}