# This script starts the VM by specifying the ISO file on first boot, changing the boot order to DVD.
#
# "hostname" specifies an existing VM name.
$hostname = "hoge"
# The location of the ISO file. Specify the path of a local or network drive.
$isoFile = "C:\DirectoryPath\fuga.iso"
Add-VMDvdDrive -VMName $hostname -Path $isoFile
$dvd = Get-VMDvdDrive -VMName $hostname

Set-VMFirmware -VMName $hostname -FirstBootDevice $dvd

Start-VM $hostname