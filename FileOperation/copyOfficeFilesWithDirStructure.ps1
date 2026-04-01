<#
.SYNOPSIS
  Copy Office/PDF files only while preserving folder structure.

.DESCRIPTION
  Recursively scans $Source and copies only Office documents and PDF to $Destination.
  Folder structure is preserved. Destination folders are created automatically.
  Designed for scheduled execution (Power Automate, Task Scheduler).

.PARAMETER Source
  Copy source root folder.

.PARAMETER Destination
  Copy destination root folder.

.PARAMETER LogPath
  Optional log file path. If omitted, a log file is created under Destination.

.PARAMETER UpdateOnly
  If specified, skip copy when destination file exists and is newer or same timestamp/size.

.PARAMETER WhatIf
  Dry-run (no actual copy).

.NOTES
  Recommended to save as UTF-8 with BOM for Japanese comments/messages.
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param(
  [Parameter(Mandatory = $true)]
  [ValidateNotNullOrEmpty()]
  [string]$Source,

  [Parameter(Mandatory = $true)]
  [ValidateNotNullOrEmpty()]
  [string]$Destination,

  [Parameter(Mandatory = $false)]
  [string]$LogPath,

  [switch]$UpdateOnly
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# --- Normalize paths (full path) ---
$Source = (Resolve-Path -LiteralPath $Source).Path
if (-not (Test-Path -LiteralPath $Destination)) {
  New-Item -ItemType Directory -Path $Destination -Force | Out-Null
}
$Destination = (Resolve-Path -LiteralPath $Destination).Path

# Ensure trailing backslash for substring relative path
if (-not $Source.EndsWith('\')) { $Source += '\' }
if (-not $Destination.EndsWith('\')) { $Destination += '\' }

# --- Prepare log ---
if ([string]::IsNullOrWhiteSpace($LogPath)) {
  $stamp = Get-Date -Format "yyyyMMdd_HHmmss"
  $LogPath = Join-Path -Path $Destination -ChildPath "CopyOfficePdf_$stamp.log"
} else {
  $logDir = Split-Path -Parent $LogPath
  if ($logDir -and -not (Test-Path -LiteralPath $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
  }
}

Start-Transcript -Path $LogPath -Append | Out-Null

# --- Extensions to include (Office + PDF) ---
# Office: Word / Excel / PowerPoint / Visio / Project (必要に応じて増減OK)
$includeExt = @(
  ".pdf", ".docx", ".xlsx", ".pptx", ".txt", ".md"
#  ".doc", ".docx", ".docm",
#  ".xls", ".xlsx", ".xlsm", ".xlsb",
#  ".ppt", ".pptx", ".pptm",
#  ".vsd", ".vsdx", ".vsdm",
#  ".mpp",
#  ".pdf"
) | ForEach-Object { $_.ToLowerInvariant() }

# Skip common temp files like "~$xxxx.docx"
$tempPrefix = "~$"

# --- Counters ---
[int]$copied = 0
[int]$skipped = 0
[int]$failed = 0

try {
  Write-Host "Source      : $Source"
  Write-Host "Destination : $Destination"
  Write-Host "LogPath     : $LogPath"
  Write-Host "UpdateOnly  : $UpdateOnly"
  Write-Host "-----"

  $files = Get-ChildItem -LiteralPath $Source -File -Recurse -Force |
           Where-Object {
             $includeExt -contains $_.Extension.ToLowerInvariant() -and
             $_.Name -notlike "$tempPrefix*"
           }

  foreach ($f in $files) {
    # Relative path from Source root
    $rel = $f.FullName.Substring($Source.Length).TrimStart('\')
    $destFile = Join-Path -Path $Destination -ChildPath $rel
    $destDir  = Split-Path -Parent $destFile

    if (-not (Test-Path -LiteralPath $destDir)) {
      if ($PSCmdlet.ShouldProcess($destDir, "Create directory")) {
        New-Item -ItemType Directory -Path $destDir -Force | Out-Null
      }
    }

    if ($UpdateOnly -and (Test-Path -LiteralPath $destFile)) {
      $d = Get-Item -LiteralPath $destFile
      # Skip if destination is newer/same and size is same
      if (($d.LastWriteTimeUtc -ge $f.LastWriteTimeUtc) -and ($d.Length -eq $f.Length)) {
        Write-Host "[SKIP] $rel"
        $skipped++
        continue
      }
    }

    if ($PSCmdlet.ShouldProcess($destFile, "Copy file")) {
      Copy-Item -LiteralPath $f.FullName -Destination $destFile -Force
      Write-Host "[COPY] $rel"
      $copied++
    }
  }

  Write-Host "-----"
  Write-Host ("Copied : {0}" -f $copied)
  Write-Host ("Skipped: {0}" -f $skipped)
  Write-Host ("Failed : {0}" -f $failed)
}
catch {
  $failed++
  Write-Error $_
}
finally {
  Stop-Transcript | Out-Null
}

# Exit code for automation
if ($failed -gt 0) { exit 1 } else { exit 0 }
``