$url = "https://db-in1.nies.go.jp/xbbs/backend.php"
$response = Invoke-WebRequest -Uri $url
$filePath = "C:\Users\terui.takeshi\OneDrive - 国立環境研究所\アプリ\PowerShell\intra_rss.xml"
$response.Content | Out-File -FilePath $filePath