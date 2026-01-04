# Swiss-Knife 運用マニュアル（Docker＋CLI＋GitHub／Windows PowerShell想定）

本書は、実際の作業履歴（WindowsにPython実体なし → Dockerで実行、`/work=swiss-knife`、`/data=Downloads`、2行ヘッダーCSVを `awk` で結合）を前提に、迷子になりにくい形で手順を固定化するための運用マニュアルです。

---

## 1. 目的とスコープ

### 目的

* WindowsローカルにPythonをインストールできない（権限・社内制約等）前提で、Dockerコンテナ上で `swissknife` CLI を運用する。
* Downloads 配下のCSVを、ヘッダー（2行）を保持したまま結合して成果物を生成する。
* 運用手順（本書）と必要に応じて成果物（結合済みCSV）をGitHubに保存し、再現可能にする。

### スコープ外

* Windowsローカルの venv 運用（本環境では Python 実体がないため）。
* PPTX統合の品質保証（MVPであり崩れ得るため、現時点では注意運用＝ベストエフォート）。

---

## 2. 変数（あなたの環境の固定値）

### Windows（ホスト）

* `WORKDIR_WIN`：`C:\Users\Morikawa.Tatsuyuki\swiss-knife`
* `DOWNLOADS_WIN`：`C:\Users\Morikawa.Tatsuyuki\Downloads`

### Docker（コンテナ内）

* `WORKDIR_DOCKER`：`/work`（`WORKDIR_WIN` をマウント）
* `DATA_DOCKER`：`/data`（`DOWNLOADS_WIN` をマウント）

> 注：`/work` と `/data` は「自動で常に存在する」わけではありません。
> `docker run` で `-v <WindowsPath>:/work` / `-v <WindowsPath>:/data` を指定して起動した**そのコンテナの中**でのみ、マウントポイントとして意味を持ちます。

---

## 3. 前提（Prerequisites）

* Docker Desktop が起動済み
* `WORKDIR_WIN` に `swiss-knife` リポジトリ（コード一式）が存在する
* `DOWNLOADS_WIN` に結合対象CSVが存在する
* ローカルPCの Python は Microsoft Store stub 等で実体が無く、venv運用は行わない

---

## 4. 重要ルール（迷子防止）

* `docker run ...` は **必ず Windows PowerShell（ホスト）** で実行する
* `awk` / `pip install` / `swissknife ...` は **必ず コンテナ内（bash）** で実行する
* プロンプトが `root@...` のときは Linux側。コンテナ内で `docker` は通常使えない

---

## 5. Quick Start（最短）

1. Windows PowerShellでコンテナ起動（`/work` と `/data` を同時マウント）
2. コンテナ内で `pip install -e /work`（CLI導入）
3. 2行ヘッダー維持の `awk` で結合（出力は Downloads に生成）

---

## 6. コンテナ起動と起動確認（swiss-knife と Downloads を同時に使う）

### 6.1 コンテナ起動（Windows PowerShell＝ホスト側で実行）

注意：このブロックは **Windows PowerShell（ホスト側）** で実行します。
コンテナに入った後（`root@...` 表示）に `docker run` を打つと失敗します。

```powershell
docker run -it --rm `
  -v C:\Users\Morikawa.Tatsuyuki\swiss-knife:/work `
  -v C:\Users\Morikawa.Tatsuyuki\Downloads:/data `
  -w /data `
  python:3.11 bash
```

### 6.2 起動確認（Sanity check：任意だが推奨／ここからはコンテナ内 bash）

目的：`/work` と `/data` のマウントが意図通りか（＝作業コードとデータが見えるか）を最初に確実に確認します。

```bash
pwd
ls -la /work
ls -la /data | head
```

期待する状態（目安）：

* `pwd` が `/data`（`-w /data` 指定のため）
* `/work` に `README.md` / `pyproject.toml` / `swissknife/` 等が見える
* `/data` に Downloads 配下の対象ファイル（例：`fy-*.csv`）が見える

---

## 7. CLI 導入（初回／更新時）

ここからは **コンテナ内（bash）** で実行します。

```bash
pip install -e /work
swissknife --help
```

---

## 8. 2行ヘッダーCSVを“マトリックス構造のまま”結合する（例）

前提：先頭2行がヘッダー（カテゴリ行＋列名行）で、3行目以降がデータ。

「先頭2行は最初のファイルだけ残し、以降のファイルは3行目以降だけを足す」ことで、形式を壊さずに結合します。

```bash
awk 'FNR>2 || NR==FNR{print}' /data/fy-balance-sheet_*.csv > /data/fy-balance-sheet_2016-2025.csv
head -n 5 /data/fy-balance-sheet_2016-2025.csv
```

---

## 9. 補足：`swiss_knife.egg-info` とは（GitHubに残さないのが基本）

`pip install -e /work` 等を実行すると、Pythonパッケージのメタデータとして `*.egg-info` が生成されることがあります（ビルド成果物の一種）。
通常は **コミット対象ではない**ため、必要なら `.gitignore` に追加してください。

例：

```gitignore
*.egg-info/
```

---
