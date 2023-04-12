# Enable VM Replication for all VMs.
Enable-VMReplication  * replicationHostFQDN 80 Kerberos -ReplicationFrequencySec 900 
# Start a initial replication for each group.
get-vm | where {$_.Notes -match 'test'}  | Start-VMInitialReplication