# swiss-knife

日常業務や技術検証で頻出する「ちょっとした処理」を、  
再利用可能な最小ツール（MVP）として集約した ToolBox リポジトリです。

This repository is a toolbox of small, reusable MVP tools designed to solve
common day-to-day data processing and technical tasks.

---

## できること（What it does）

### CSV（MVP）
複数CSVの結合（縦連結）や、2つのCSVの結合（join）を行います。  
日常業務で発生するデータ加工を、スクリプトとして再現可能な形で素早く実行できます。

Concatenate multiple CSV files and join two CSVs.  
Designed to make day-to-day data processing quick and reproducible via scripts.

---

### Web Docs 抽出 - PowerShell（Web Docs Extraction - PowerShell）
CSVに列挙したWebドキュメントURLから、本文（article / main）を自動抽出し、  
1つのTXTファイルに統合します。  
途中再開（stateファイル）とエラーログ出力に対応しており、  
大量ページ・長時間処理でも安定して運用できる設計です。

Extracts main content (article / main) from web documentation pages listed in a CSV
and merges them into a single TXT file.  
Supports resume via a state file and outputs an error log, making it suitable for
large-scale and long-running extraction tasks.

---

## 対象ユーザー（Who is this for）
- 日常的にCSVやテキストデータを扱うエンジニア
- 技術ドキュメントを一括取得・整理したい人
- 検証用データを素早く再現可能な形で用意したい人

- Engineers who frequently work with CSV and text data
- Anyone who needs to bulk-extract and organize technical documentation
- Users who want reproducible data preparation for experiments and validation

---

## 方針（Design policy）
- 小さく、単機能で、再利用しやすい
- 手動操作を減らし、スクリプトで再現可能にする
- 「とりあえず動く」ではなく「運用できる」MVPを目指す

- Small, single-purpose, and reusable
- Reduce manual work and ensure reproducibility via scripts
- Focus on operational MVPs, not one-off throwaway scripts

---

## ツール一覧（Tools）
- CSV（MVP）
- Web Docs 抽出 - PowerShell

See each tool directory for details and usage instructions.

---

## ライセンス（License）
MIT License
