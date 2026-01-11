# Tools（ToolBox）

このディレクトリは、`swiss-knife` リポジトリ内の各種ツールの  
**人間向けの入口（使い方・導線）**をまとめたものです。

This directory provides human-friendly entry points and usage guides  
for tools included in the `swiss-knife` repository.

---

## 利用可能なツール（Available tools）

### Web Docs 抽出（Web Docs Extraction）
CSVに列挙したWebドキュメントURLから、本文（article / main）を抽出し、  
1つのテキストファイルに統合します。

Extracts main content (article / main) from web documentation URLs  
listed in a CSV file and merges them into a single text file.

- 📂 `tools/webdocs-extract/`
- 📄 README に使い方を記載

---

### CSV（MVP）
複数CSVの縦連結（concat）と、2つのCSVの結合（join）を行います。  
日常的なデータ加工を、再現可能な形で実行できます。

Provides CSV concatenation (vertical merge) and joining two CSV files  
for reproducible day-to-day data processing.

- 📂 `tools/csv/`
- 📄 README に使い方を記載

### 2CSVの結合（Join two CSVs）
```powershell
python -m swissknife csv join `
  --left  "C:\path\to\left.csv" `
  --right "C:\path\to\right.csv" `
  --on "id" `
  --how "inner" `
  --output "C:\path\to\joined.csv"
```   
サンプルCSVは `tools/csv/samples/join/` に配置しています。