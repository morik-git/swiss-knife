# CSV（MVP）

日常業務で発生するCSV加工を、再現可能な形で素早く実行するためのツールです。  
複数CSVの縦連結（concat）と、2つのCSVの結合（join）を提供します。

A small toolset for reproducible day-to-day CSV processing.  
Provides CSV concatenation (vertical merge) and joining two CSV files.

---

## 前提（Prerequisites）
入力CSVファイルはローカルPC上に配置してください。  
ファイルパスはフルパス／相対パスのどちらでも指定できます。

Place input CSV files on your local PC.  
You can specify file paths as absolute or relative paths.

---

## 実行方法（How to run）
CSV処理は `swissknife` のCLIとして実装されています。  
tools配下は「使い方の入口」です。

The CSV features are implemented as part of the `swissknife` CLI.  
This directory acts as a usage entry point.

---

## 実行例（Examples）

### 複数CSVの縦連結（Concatenate CSVs）
```powershell
python -m swissknife csv concat `
  "C:\path\to\input_1.csv" `
  "C:\path\to\input_2.csv" `
  --output "C:\path\to\merged.csv"
```

---

## 次にやること（Git）
README を保存したら、以下を実行してください。

```powershell
git add tools/csv/README.md
git commit -m "Add minimal CSV tool README"
git push
```
