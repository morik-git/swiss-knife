# Web Docs 抽出 - PowerShell（Web Docs Extraction - PowerShell）

CSVに列挙したWebドキュメントURLから、本文（article / main）を抽出して  
1つのTXTファイルに統合するPowerShellツールです。  
実行時に入力CSVのフルパスと出力ファイル名を対話的に指定でき、  
途中再開（stateファイル）とエラーログ出力に対応しています。

This PowerShell tool extracts main content (article / main) from web documentation
pages listed in a CSV file and merges them into a single TXT file.
It interactively asks for the input CSV full path and the output file name at runtime,
and supports resume via a state file with error logging.

---

## 入力（Input）
- ローカルPC上に配置したCSVファイル  
  - 列名：`url`
  - 1行につき1URL

実行時に、CSVファイル名を含む**フルパス**の入力を求められます。  
エクスプローラーからパスをコピーして、そのまま貼り付けてください。

- A CSV file stored on the local PC
  - Required column: `url`
  - One URL per row

At runtime, the script prompts for the **full path** of the CSV file.
You can copy and paste the path directly from the file explorer.

---

## 出力（Output）
- 統合TXTファイル（抽出した本文を全件まとめて出力）
- エラーログファイル（取得・解析に失敗したURL）
- stateファイル（途中再開用）

出力ファイル名は、実行時に指定します。

- Combined TXT file containing all extracted text
- Error log file for failed pages
- State file used for resume

The output file name is specified interactively during execution.

---

## 使い方（Usage）

PowerShellで以下を実行します。

```powershell
.\tools\webdocs-extract\extract-webdocs.ps1
