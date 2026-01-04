# swiss-knife

EN: A practical CLI toolbox to batch-process business files (CSV, PPTX, …) reproducibly.  
JP: 業務ファイル（CSV / PPTX など）を再現可能な形で一括処理するための CLI ツール集です。

---

## What it does / できること

### CSV (MVP)
EN: Concatenate multiple CSVs, join two CSVs.  
JP: 複数CSVの結合（縦連結）、2つのCSVの結合（join）

### PPTX (MVP)
EN: Merge multiple PPTX files (with limitations).  
JP: 複数PPTXの統合（制約あり：崩れる可能性があるため注意）

---

## Roadmap (short) / ロードマップ（簡易）

- EN: v0.1 CSV merge/join for day-to-day data work (done)  
  JP: v0.1 日常業務向けの CSV 結合／join（完了）

- EN: v0.2 PPTX merge with clearer constraints and safer defaults  
  JP: v0.2 PPTX 統合の制約整理と安全なデフォルトの導入

- EN: v0.x Add more “swiss-knife” utilities (PDF merge, normalization, validation, etc.)  
  JP: v0.x 便利ツールを順次追加（PDF結合、正規化、検証など）

---

## Testing / テスト方針（最小）

EN:
- Tests are organized per tool under `tests/<tool>/` and run with `pytest`.
- For small scale, we run the full test suite on CI (no diff-based selection).
- CSV concat tests validate that **output data row count** equals the **sum of input data rows** (excluding header lines).

JP:
- テストはツール単位で `tests/<tool>/` に配置し、`pytest` で実行します。
- 小規模プロジェクトのため、CIでは差分判定をせず毎回フル実行します。
- CSV結合は、ヘッダー行を除外した **データ行数** が「入力合計＝出力」と一致することをテストします。

EN: See `docs/TESTING.md` for details.  
JP: 詳細は `docs/TESTING.md` を参照してください。

---

## Quick start (Docker on Windows) / クイックスタート（Windows＋Docker）

EN: This project is designed to work even when local Python installation is constrained.  
JP: ローカルPCに Python 実体を入れにくい環境でも動かせる運用を前提にしています。

EN: We mount: repo → `/work`, Windows Downloads → `/data`  
JP: マウント対応：リポジトリ → `/work`、Windows Downloads → `/data`

### 1) Start container / コンテナ起動（Windows PowerShell）
```powershell
docker run -it --rm `
  -v C:\Users\Morikawa.Tatsuyuki\swiss-knife:/work `
  -v C:\Users\Morikawa.Tatsuyuki\Downloads:/data `
  -w /data `
  python:3.11 bash
