get-vm | where {$_.Notes -match 'test'}  | stop-vm
get-vm | where {$_.Notes -match 'production'}  | stop-vm