# Swiss-Knife 運用マニュアル（Docker＋CLI＋GitHub／Windows PowerShell想定）

本書は、実際の作業履歴（WindowsにPython実体なし → Dockerで実行、`/work=swiss-knife`、`/data=Downloads`、2行ヘッダーCSVを `awk` で結合）を前提に、迷子になりにくい形で手順を固定化するための運用マニュアルです。

---

## 1. 目的とスコープ

### 目的
- WindowsローカルにPythonをインストールできない（権限・社内制約等）前提で、Dockerコンテナ上で `swissknife` CLI を運用する。
- Downloads 配下のCSVを、ヘッダー（2行）を保持したまま結合して成果物を生成する。
- 運用手順（本書）と必要に応じて成果物（結合済みCSV）をGitHubに保存し、再現可能にする。

### スコープ外
- Windowsローカルの venv 運用（本環境では Python 実体がないため）。
- PPTX統合の品質保証（MVPであり崩れ得るため、現時点では注意運用＝ベストエフォート）。

---

## 2. 変数（あなたの環境の固定値）

### Windows（ホスト）
- `WORKDIR_WIN`：`C:\Users\Morikawa.Tatsuyuki\swiss-knife`
- `DOWNLOADS_WIN`：`C:\Users\Morikawa.Tatsuyuki\Downloads`

### Docker（コンテナ内）
- `WORKDIR_DOCKER`：`/work`（`WORKDIR_WIN` をマウント）
- `DATA_DOCKER`：`/data`（`DOWNLOADS_WIN` をマウント）

> 注：`/work` と `/data` は「自動で常に存在する」わけではありません。  
> `docker run` の `-v <WindowsPath>:/work` / `-v <WindowsPath>:/data` を付けて起動した「そのコンテナの中」でのみ、マウントポイントとして意味を持ちます。

---

## 3. 前提（Prerequisites）

- Docker Desktop が起動済み
- `WORKDIR_WIN` に `swiss-knife` リポジトリ（コード一式）が存在する
- `DOWNLOADS_WIN` に結合対象CSVが存在する
- ローカルPCの Python は Microsoft Store stub 等で実体が無く、venv運用は行わない

---

## 4. 重要ルール（迷子防止）

- `docker run ...` は **必ず Windows PowerShell（ホスト）** で実行する
- `awk` / `pip install` / `swissknife ...` は **必ず コンテナ内（bash）** で実行する
- プロンプトが `root@...` のときは Linux側。コンテナ内で `docker` は通常使えない

---

## 5. Quick Start（最短）

1) Windows PowerShellでコンテナ起動（`/work` と `/data` を同時マウント）  
2) コンテナ内で `pip install -e /work`（CLI導入）  
3) 2行ヘッダー維持の `awk` で結合（出力は Downloads に生成）

---

## 6. 1) コンテナ起動（swiss-knife と Downloads を同時に使う）

### Windows PowerShell（ホスト）で実行
```powershell
docker run -it --rm `
  -v C:\Users\Morikawa.Tatsuyuki\swiss-knife:/work `
  -v C:\Users\Morikawa.Tatsuyuki\Downloads:/data `
  -w /data `
  python:3.11 bash
