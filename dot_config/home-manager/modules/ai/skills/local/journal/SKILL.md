---
name: journal
description: |
  作業・検討の記録（journal）をObsidian vaultに書く。
  ユーザーが「journalを書いて」「日誌を書いて」「記録しておいて」「journal更新して」と求めた時に使用します。
---

## Instructions

journalを `~/Documents/Obsidian Vault/journals/` に、vaultの規約に従って書きます。
規約の本体はvaultの `journals/README.md` にあります。このスキルには手順だけを書き、規約は複製しません（二重管理を避けるため）。

## Workflow

### Step 1 - 規約とテンプレートを読む

以下を読みます。

- `~/Documents/Obsidian Vault/journals/README.md`（置き場所・書き方）
- 内容に合ったテンプレート
  - 検討・方針決め: `journals/template.md`
  - 実装ログ: `journals/template-impl.md`

### Step 2 - 置き場所と書き方を決める

- 置き場所は `journals/github.com/<owner>/<repo>/YYYY-MM-DD-slug.md` です。
  GitHubにないローカルのプロジェクトは `journals/local/<project>/` に置かれている例があります。
- 対象リポジトリのディレクトリに `CLAUDE.md` があれば、それに従います（例: `infrastructure` は `YYYYMMDD-slug.md`）。
- 1ファイル1トピックです。複数のテーマがあれば分けます。
- 同じ日・同じトピックの既存ファイルがないか確認します（`ls` か、qmd MCPの検索）。あれば、新規作成ではなく更新します。

### Step 3 - 書く

- 会話の中で実際に確認できた事実と、未確認のことを分けて書きます。推測を事実として書きません。
- frontmatter（`repo` / `date` / `tags` / `status`）を付けます。日付は、実行時点の今日の日付です。
- 本文中のパスは `owner/repo:path/to/file` の形で書きます。
- 関連するjournalがあれば、`[[ファイル名]]` でリンクします。
- 「次にやること」（実装ログでは「未対応・保留」）には、未実施のものを、未チェックの `- [ ]` で書きます。

### Step 4 - 索引に反映する

書いたあと、qmdの索引に反映します（MCPには更新ツールがありません）。

```bash
qmd update
qmd embed
```

### Step 5 - 報告する

書いた（更新した）ファイルのパスだけを、ユーザーに報告します。
書いた内容の要約・要点は述べません。ユーザーは今の会話の当事者なので、会話した内容を繰り返されても意味がありません。
例外として、`repo` の判断や `status` の選択など、ユーザーが判断を覆したくなりうる点だけは、一言で添えます。
