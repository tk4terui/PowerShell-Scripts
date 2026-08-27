<#
.SYNOPSIS
    コピー元のフォルダ構造だけをコピーします。
    ファイルはコピーせず、空フォルダを含むディレクトリ構造のみを再作成します。

.DESCRIPTION
    このスクリプトは、指定したコピー元フォルダ配下のディレクトリ構造を再現します。
    そのため、ファイル本体はコピーせず、フォルダだけをコピー先へ作成します。
    ルートのフォルダ自体も含めて再作成されます。

    例:
      元: C:\Data\A\B\C
      先: D:\Backup
      -> D:\Backup\A\B\C が作成される

.PARAMETER Source
    コピー元フォルダのパス。必須。

.PARAMETER Destination
    コピー先フォルダのパス。必須。

.PARAMETER PreserveTimestamps
    ディレクトリの作成時刻・更新時刻・アクセス時刻を元の値に揃えます。

.PARAMETER Force
    既存ディレクトリがあってもエラーにせず、必要なら作成します。

.PARAMETER WhatIf
    実際には作成せず、どのディレクトリが作成されるかを表示します。

.EXAMPLE
    .\copyFolderStructure.ps1 -Source "C:\Data" -Destination "D:\Backup"

    コピー元の全ディレクトリ構造を、コピー先に再作成します。
    ルート自体も含め、空フォルダも作成されます。

.EXAMPLE
    .\copyFolderStructure.ps1 -Source "C:\Data" -Destination "D:\Backup" -WhatIf

    実際には作成せず、作成予定のフォルダを表示します。

.EXAMPLE
    .\copyFolderStructure.ps1 -Source "C:\Data" -Destination "D:\Backup" -PreserveTimestamps -Force

    フォルダ構造をコピーし、時刻も保持し、既存フォルダがあっても作成を続行します。

.NOTES
    - ファイルはコピーしません
    - 空フォルダも含めてコピーされます
    - コピー先の親フォルダは自動で作成されます
    - 既存フォルダがある場合は -Force で上書き/再利用できます
#>
param(
    [Parameter(Mandatory=$true)][string]$Source,
    [Parameter(Mandatory=$true)][string]$Destination,
    [switch]$PreserveTimestamps,
    [switch]$Force,
    [switch]$WhatIf
)

# 1) コピー元が存在するか確認し、絶対パスに変換
try {
    $srcFull = (Resolve-Path -LiteralPath $Source -ErrorAction Stop).ProviderPath
} catch {
    Write-Error "コピー元が見つかりません: $Source"
    exit 1
}

# 2) コピー先の親フォルダを確認して、Destination を安全に解決
#    例:
#      Destination = "D:\Backup"
#      -> D:\ が存在するなら D:\Backup を使う
#      Destination = "D:\new\folder"
#      -> D:\new が存在しない場合でも、必要に応じて作成可能にする
$destFull = (Resolve-Path -LiteralPath (Split-Path -Path $Destination -Parent) -ErrorAction SilentlyContinue)
if (-not $destFull) {
    # 親フォルダが存在しない場合は、Destination をそのまま使う
    $destFull = $Destination
} else {
    $destFull = $destFull.ProviderPath
    if ($Destination -notlike "*\*") {
        $destFull = Join-Path $destFull (Split-Path -Leaf $Destination)
    }
}

# 3) コピー先のルートディレクトリを作成
#    WhatIf の場合は実際には作成せず、確認だけ行う
if ($WhatIf) {
    Write-Verbose "WhatIf: ルートディレクトリを確認: $destFull"
} else {
    New-Item -ItemType Directory -Path $destFull -Force:$Force > $null
}

# 4) コピー元のすべてのサブディレクトリを取得
#    ルート自身も含めて処理対象にする
$dirs = Get-ChildItem -LiteralPath $srcFull -Directory -Recurse -Force -ErrorAction Stop
$rootItem = Get-Item -LiteralPath $srcFull -ErrorAction Stop
$allDirs = ,$rootItem + $dirs

# 5) フォルダごとに相対パスを計算し、同じ構造をコピー先に作成
foreach ($dir in $allDirs) {
    # コピー元のルートからの相対パスを作る
    $rel = $dir.FullName.Substring($srcFull.Length).TrimStart('\', '/')
    $target = if ($rel) { Join-Path $destFull $rel } else { $destFull }

    if ($WhatIf) {
        Write-Output "WhatIf: New-Item -ItemType Directory -Path '$target'"
        if ($PreserveTimestamps) {
            Write-Output "WhatIf: preserve timestamps for '$target' from '$($dir.FullName)'"
        }
    } else {
        # 既存ディレクトリがある場合の処理
        if ($Force) {
            New-Item -ItemType Directory -Path $target -Force | Out-Null
        } else {
            if (-not (Test-Path -LiteralPath $target)) {
                New-Item -ItemType Directory -Path $target | Out-Null
            }
        }

        # タイムスタンプを維持したい場合
        if ($PreserveTimestamps) {
            try {
                $srcInfo = Get-Item -LiteralPath $dir.FullName
                $tgtInfo = Get-Item -LiteralPath $target
                $tgtInfo.CreationTime = $srcInfo.CreationTime
                $tgtInfo.LastWriteTime = $srcInfo.LastWriteTime
                $tgtInfo.LastAccessTime = $srcInfo.LastAccessTime
            } catch {
                Write-Verbose "タイムスタンプの設定に失敗: $target ($($_.Exception.Message))"
            }
        }
    }
}