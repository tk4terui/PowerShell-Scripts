param($Source, $Destination)
$src=(Resolve-Path $Source).ProviderPath
$dst=(Resolve-Path -LiteralPath (Split-Path $Destination -Parent) -ErrorAction SilentlyContinue)
if(-not $dst){ $dst=$Destination } else { $dst=Join-Path $dst (Split-Path -Leaf $Destination) }
Get-ChildItem -Path $src -Directory -Recurse -Force | ForEach-Object {
  $rel = $_.FullName.Substring($src.Length).TrimStart('\')
  New-Item -ItemType Directory -Path (Join-Path $dst $rel) -Force | Out-Null
}

# ワンライナーで手早く：xcopy "C:\src" "C:\dest" /T /E（簡単・高速）
# 上の最小 PS1 を使う場合：powershell -File "copyFolderStructure.ps1" -Source "C:\src" -Destination "C:\dest"