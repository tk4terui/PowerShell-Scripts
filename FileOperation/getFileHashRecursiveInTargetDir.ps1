$targetDir = ""C:\Users\terui.takeshi\Downloads\ISO""
$files = Get-ChildItem $targetDir -File

foreach ($file in $files){
    Write-Host "$($file): $((Get-FileHash $file.FullName -Algorithm md5).Hash.toLower())"
}