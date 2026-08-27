# 実行
.\copyFolderStructure.ps1 -Source "C:\Data" -Destination "D:\Backup"

# 実行予定だけ確認
.\copyFolderStructure.ps1 -Source "C:\Data" -Destination "D:\Backup" -WhatIf

# 既存フォルダ上書き + 時刻維持
.\copyFolderStructure.ps1 -Source "C:\Data" -Destination "D:\Backup" -Force -PreserveTimestamps