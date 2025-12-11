1..254 | % {
  $ip = "192.168.137.$_"
  if (ping -n 1 -w 500 $ip | Select-String 'TTL=') { $ip }
}