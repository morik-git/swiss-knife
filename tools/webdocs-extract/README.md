# Web Docs 抽出 - PowerShell（Web Docs Extraction - PowerShell）

CSVに列挙したWebドキュメントURLから、本文（article / main）を抽出して  
1つのTXTファイルに統合するPowerShellツールです。  
途中再開（stateファイル）とエラーログ出力に対応しており、  
大量ページ・長時間処理でも運用しやすい構成になっています。

This PowerShell tool extracts main content (article / main) from web documentation
pages listed in a CSV file and merges them into a single TXT file.
It supports resume via a state file and outputs an error log, making it suitable
for large-scale and long-running executions.

---

## 入力（Input）
- CSVファイル  
  - 列名：`url`
  - 1行につき1URL

## 出力（Output）
- 統合TXTファイル（抽出した本文を全件まとめて出力）
- エラーログファイル（取得・解析に失敗したURL）
- stateファイル（途中再開用）

※ 出力先はスクリプト先頭の変数で指定します。

---

## 使い方（Usage）

PowerShellで以下を実行します。

```powershell
.\tools\webdocs-extract\powershell\extract-webdocs.ps1