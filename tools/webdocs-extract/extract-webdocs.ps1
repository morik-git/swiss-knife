<#
.SYNOPSIS
  Extracts web docs from a CSV (url column) and merges into a single text file.
.DESCRIPTION
  - Reads CSV with column: url
  - Downloads each page
  - Extracts <article> or <main>
  - Converts HTML to plain text
  - Appends into one TXT
  - Supports resume via state file
#>

[CmdletBinding()]
param(
  # 必須：入力CSV（url列）
  [string]$InputCsv,

  # 任意：出力ベース名（拡張子なし）。省略時はInputCsv（OutputTxt指定時はOutputTxt）のファイル名を使用
  [string]$OutputBaseName,

  # 任意：出力TXT（省略時はInputCsvと同じフォルダに自動生成）
  [string]$OutputTxt,

  # 任意：エラーログ（省略時はOutputTxtの名前から自動生成）
  [string]$ErrorLog,

  # 任意：再開用ステート（省略時はOutputTxtの名前から自動生成）
  [string]$StateFile,

  # 任意：タイムアウト秒
  [int]$TimeoutSec = 20,

  # 任意：リクエスト間の待ち（ms）
  [int]$SleepMinMs = 600,
  [int]$SleepMaxMs = 1600
)

# --- パスの既定値を組み立て ---
if (-not $InputCsv -or $InputCsv.Trim() -eq "") {
  $InputCsv = Read-Host "Input CSV path (e.g., C:\path\file.csv)"
  $InputCsv = $InputCsv.Trim().Trim('"')
}
if (-not $InputCsv -or $InputCsv.Trim() -eq "") {
  throw "InputCsv is required."
}

try {
  $InputCsv = (Resolve-Path -Path $InputCsv -ErrorAction Stop).Path
} catch {
  throw "InputCsv not found: $InputCsv"
}

$OutputBaseName = Read-Host "Output base name (e.g., ignition_docs_8.3)"
if (-not $OutputBaseName -or $OutputBaseName.Trim() -eq "") {
  throw "OutputBaseName is required."
}

if (-not $OutputTxt -or $OutputTxt.Trim() -eq "") {
  $dir  = Split-Path $InputCsv -Parent
  $OutputTxt = Join-Path $dir ($OutputBaseName + "_all.txt")
}

if (-not $ErrorLog -or $ErrorLog.Trim() -eq "") {
  $dir  = Split-Path $OutputTxt -Parent
  $ErrorLog = Join-Path $dir ($OutputBaseName + "_errors.txt")
}

if (-not $StateFile -or $StateFile.Trim() -eq "") {
  $dir  = Split-Path $OutputTxt -Parent
  $StateFile = Join-Path $dir ($OutputBaseName + "_state.txt")
}

# --- 続きから再開（stateがなければ1から） ---
$startIndex = 1
if (Test-Path $StateFile) {
  $raw = (Get-Content $StateFile -Raw).Trim()
  if ($raw -match '^\d+$') {
    $startIndex = [int]$raw
    if ($startIndex -lt 1) { $startIndex = 1 }
  }
}

$rows  = Import-Csv $InputCsv
$total = $rows.Count

# 初回だけ消す（再開時は消さない）
if ($startIndex -le 1) {
  Remove-Item $OutputTxt -ErrorAction SilentlyContinue
  Remove-Item $ErrorLog  -ErrorAction SilentlyContinue
}

# TLS設定（環境によって必要）
try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 } catch {}

for ($i = $startIndex; $i -le $total; $i++) {
  $url = $rows[$i-1].url
  Write-Host ("[{0}/{1}] {2}" -f $i, $total, $url)

  try {
    $resp = Invoke-WebRequest -Uri $url -TimeoutSec $TimeoutSec -UseBasicParsing
    $html = $resp.Content

    # article優先、なければmain
    if ($html -match '(?is)<article.*?>(.*?)</article>') {
      $body = $matches[1]
    } elseif ($html -match '(?is)<main.*?>(.*?)</main>') {
      $body = $matches[1]
    } else {
      throw "article/main tag not found"
    }

    # HTML→テキスト
    $text = $body
    $text = $text -replace '(?is)<script.*?</script>', ''
    $text = $text -replace '(?is)<style.*?</style>', ''
    $text = $text -replace '(?is)<noscript.*?</noscript>', ''
    $text = $text -replace '(?is)<pre.*?</pre>', "`n[CODE BLOCK]`n"
    $text = $text -replace '(?is)<code.*?</code>', ''
    $text = $text -replace '(?is)<h[1-6].*?>', "`n## "
    $text = $text -replace '(?is)</h[1-6]>', "`n"
    $text = $text -replace '(?is)<li.*?>', "`n- "
    $text = $text -replace '(?is)</li>', ''
    $text = $text -replace '(?is)<p.*?>', "`n"
    $text = $text -replace '(?is)</p>', "`n"
    $text = $text -replace '(?is)<br\s*/?>', "`n"
    $text = $text -replace '(?is)<[^>]+>', ' '

    $text = $text -replace '&nbsp;',' '
    $text = $text -replace '&amp;','&'
    $text = $text -replace '&lt;','<'
    $text = $text -replace '&gt;','>'
    $text = $text -replace '&#39;',"'"
    $text = $text -replace '&quot;','"'
    $text = $text -replace '\s{2,}',' '
    $text = $text.Trim()

    Add-Content -Path $OutputTxt -Encoding UTF8 -Value @"
===== $("{0:D4}" -f $i) / $total =====
URL: $url
-----
$text

"@

    # 進捗保存（次回は次の番号から）
    Set-Content -Path $StateFile -Value ($i + 1) -Encoding ASCII

    # 負荷軽減
    Start-Sleep -Milliseconds (Get-Random -Minimum $SleepMinMs -Maximum $SleepMaxMs)

  } catch {
    Add-Content -Path $ErrorLog -Encoding UTF8 -Value ("{0:D4}`t{1}`t{2}" -f $i, $url, $_.Exception.Message)
    Set-Content -Path $StateFile -Value ($i + 1) -Encoding ASCII
  }
}

Write-Host "Done."
Write-Host "Input : $InputCsv"
Write-Host "Output: $OutputTxt"
if (Test-Path $ErrorLog) { Write-Host "Errors: $ErrorLog" }
Write-Host "State : $StateFile"

