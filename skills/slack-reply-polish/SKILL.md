---
name: slack-reply-polish
description: |
  Slack/Discord/メール等の chat 系 msg への返信 draft を、 受信者との関係性に応じた tone で生成し、 user 反復推敲で「必要十分」 まで polish するスキル。 ワンショット出力ではなく、 v1 → 修正反映 → v2 → ... の polish loop が前提。 **業務メール (就活/インターン受入/顧客対応 等 formal context)** は Business mail 特化 section の追加 procedure を併用。
  Use when: "返信を考えて" / "Slack に返信" / "msg の draft" / "返信 polish" / "返信推敲" / "メッセージ作って" / "polite に返したい" / "polish reply" / "業務メール返信" / "就活メール返信" / "採用担当への返信".
argument-hint: "<受信 msg verbatim と受信者の関係性> [tone hint] [--business-mail]"
allowed-tools: Read, Write, Edit, Bash, Agent
---

# Slack Reply Polish

chat 系 msg の返信 draft を「いい感じ」 に整える skill。 単発出力ではなく、 **user 反復推敲を前提**に、 tone / abstractness / 削り方を回す。

## Workflow

### Step 1: 受信 msg verbatim 記録 + 関係性確認

- 受信 msg は **そのまま引用** (= paraphrase 禁止、 意図弱化を防ぐ)
- **verbatim 引用範囲**:
  - **default**: msg 全文 (= 短い場合) または **最後の question 文を含む連続ブロック** (= 長い場合の抜粋、 ただし intent を弱化させない範囲)
  - draft 冒頭で `>` 引用 block で示す (= Slack/Discord syntax)
  - thread が context 明白な場合は「件名的 reference」 (= 「ご依頼の X について、」) も許容、 ただし scenario が context 持たない時は引用 block 推奨
- 受信者役割 = 「先生 / 同僚 / 業者 / 学生 / 外部依頼者」 のいずれかを確定 (= `references/tone-matrix.md` 参照)
- 不明なら user に 1 行確認 (= 「これは誰宛?」)

### Step 2: 要点 enumerate (= working list)

返信に含める要素を bullet で列挙 (= **working list、 全候補出す**)。 ここでは絞らない:

- 完了報告 (= 何が done、 具体的に)
- 推奨 / 選択肢提示 (= 複数 option 並列、 推奨明示)
- 質問への回答 (= 直接)
- forwarding (= 「@担当者 に」)
- 環境注意 (= 受信者環境前提、 `references/connectivity-cheatsheet.md` 参照)
- 余談 / 提案 (= 強制感ゼロ表現、 `references/polish-patterns.md` 参照)

**Step 2 と Step 3 の境界**:

- Step 2 (= 本 step) = working list、 削る前の全候補列挙
- Step 3 (= 次 step) で **受信者視点 first-pass 選択**: 受信者が判断するために要る要素のみ draft v1 に採用、 不要 / 冗長候補は除外
- 迷ったら **v1 で含めて、 Step 4 で「削り option」 として列挙** が default (= user 反復推敲で判断委ねる)

### Step 3: draft v1 生成

`references/tone-matrix.md` の関係性 × tone レベルから default 選択。 構造:

- **開頭**: 関係性に応じた挨拶 + mention (= `@username` 形式、 username 不明なら `<@担当者>` placeholder)
- **本文**: Step 2 の要点を 1 要素 1 段落、 ただし **受信者視点 first-pass 選択** (= 上記 Step 2-3 境界)
- **閉じ**: tone レベルに応じた閉じ句

code block で出して user がコピペ可能な状態にする。

**user tone hint override rule**: user が argument-hint or 別途明示 (= 「polite で」「もう少し堅く」 等) で tone hint を提示した場合、 **user hint 優先** (= tone-matrix default を override)。 ただし tone shift は 1 段ずらしルール (= Step 5 + Gotchas 参照) 遵守。

**mention 要否判断** (= `tone-matrix.md` の「mention 要否」 列参照):

- 1-on-1 reply / DM = mention 不要 (= context 明白、 mention redundant)
- channel 内 (= 複数 audience) = mention 必要 (= 誰宛か明示)
- forwarding 先 = `@担当者` 形式必須

### Step 4: 削り方の方針 を user に提示

draft v1 提示の同 turn 末尾で、 polish 方向の選択肢を列挙 (= 反復推敲 promote):

- a. **必要十分まで削る**: 受信者視点での到達点を明示
- b. **専門用語 abstractness 調整**: 実装 detail (= `certbot / acme.sh 組み合わせ` 等) を削って「Caddy / nginx」 程度に
- c. **detail 削除**: 数値 (= 自動更新サイクル、 行数、 期間) は受信者の判断材料でないなら削る
- d. **括弧の中身**: `(= xxx)` 形式の補足は冗長になりがち、 main statement に統合 or 削除
- e. **必須感緩和**: 「もし docker で構築されているなら」 等の if 節は前提条件に見えがち、 「docker / 直接 host のどちらでも」 等で明示

### Step 5: 反復推敲

user 修正点を反映 + 関連 cleanup:

- 「短く」 → 段落減 + 不要 detail 削除
- 「もっと polite に / casual に」 → tone shift 1 段 (= 同僚 → 業者 の遠飛びは避ける)
- 「専門用語減らして」 → abstract レベル↑
- 「forwarding 入れて」 → 「@担当者 に聞いていただくのも」 1 行追加
- 「暗示にして」 → 婉曲表現置換 (= 「ネット上に事例豊富」 等)
- 「不要」「いらない」 → 該当箇所削除

反復のたびに自動 cleanup:
- 文法重複 (= 「が...が」 等) 削除
- 余白 / 改行整理
- mention / link / placeholder の valid 性確認

### Step 6: 暗示 / forwarding / 余談線 の patterns

直接表現を避けたい / 強制感を出したくない時の polish pattern (= `references/polish-patterns.md` 参照):

- **「自分で調べて」 → 暗示**: 「ネット上に事例も豊富なので参考になるかと思います」
- **「他に聞いて」 → forwarding**: 「具体的な構成事例は @担当者 さんに聞いていただくのが早いかもしれません」
- **「やってほしい」 → 余談線**: 「(余談ですが、 ... できて便利かもしれません。 温度感で。)」
- **「事前に読んで」 → link 提示**: 「内部 wiki に詳しい手順あります: <URL>」 で「読んで」 を直接言わない

## Output format

各 iteration の output:

1. **draft 全文** (= code block 内、 コピペ可)
2. **主な変更点** (= 直前 iter からの diff sumary 2-3 行、 v1 では「初版」 と明示)
3. **次の polish 候補** (= 1-2 options、 反復推敲を促す、 optional)

## Hard rules

- 受信 msg verbatim は **冒頭で引用** (= paraphrase 禁止)
- 関係性不明なら **draft 前に user 確認**
- draft 提示後、 **user 修正待ち** (= 無断で final 確定しない)
- 反復推敲時、 user 修正点を全反映 + 関連 cleanup を **自動実施**
- 暗示 / 余談線は **強制感ゼロ表現限定** (= 「すべき」「お願いします」 NG、 「かもしれません」「温度感で」 推奨)
- placeholder (= `<URL>`「<@担当者>」 等) が残っている場合は output 末尾で **user fill in 必要箇所として明示**

## Stop condition

user が「OK」「これで」「送った」「ありがとう」 等の **明示的 close 言葉** を出すまで polish 継続。 1 iter で勝手に終わらない。

## Gotchas

- **tone 1 段ずらしルール**: 「もっと polite に」 mandate でも元 tone から 1 段ずらすに留める (= 「同僚 → 業者」 の遠飛び禁止)
- **mention placeholder**: `@username` 不明なら `<@担当者>` で残す + user 確認
- **link 切れ**: URL placeholder `<wiki URL を入れてください>` 等は user 記入箇所として明示
- **環境前提仮定禁止**: 「nc 使ってください」 等の限定指定は NG、 Mac/Linux/Windows 併記が default
- **diagnostics info の preemptive 提示**: 疎通確認 cheatsheet / debug 手順等の diagnostics info は受信者から request がない場合 **default 省略**。 ただし HTTPS 化 / firewall 変更等の関連 work で受信者が確認する必要があるケースは Step 6「主依頼 + 関連 work 事前通知」 pattern で含めて OK。 v1 で diagnostics info を含めたら **必ず Step 4 削り option に明示** (= user 判断で削れるように)

## Business mail (formal) 特化 (business context)

**発動条件 (どれか1つ true で 本 section の 追加 procedure を実施)**:
- 受信者役割 = 「採用担当 / 受入担当 / 顧客 / 取引先 / 教員 (formal context)」 (= tone-matrix の formal 系)
- 受信 msg が 業務メール format (= 署名 block あり / 敬語 / 「株式会社」 等 会社名冒頭)
- user argument-hint = `--business-mail` 明示
- 用途 = 就活 / インターン受入 / 顧客対応 / 業務連絡 (chat/DM でない)

該当時、 Step 1-6 の base workflow に **以下 5 procedure を追加**:

### B-1: SC-3R dump 先行 (context固定 + 事前 hostile 列挙)

draft v1 生成 **前** に SC-3R (Self-Critique 3 Rounds) dump を作る (= 業務メールは 一発通しで送るリスク高、 draft前に hostile列挙で失敗パターン洗い出し):

- **R1 構造**: 受信 msg の 要求項目 全 enumerate (「返信必須」 明示 phrase / 期限 / 参加日 / 希望聴取 / 別途連絡待ちの承知 等)、 各項目への 応答枠を確認
- **R2 整合性**: 過去 narrative (= 面接発言 / ES提出内容 / 前送信メール) との齟齬 check、 verbatim source 参照 (「同じ table に 2系統数値混在」 「別実験帰属を単一 label で回収」 等の 混同禁止)
- **R3 Hostile (H1-H8 目安)**: 「間延び」 「情緒過剰」 「二重お礼」 「弱点 pin-point (悪目立ち)」 「排他 tone (『〜ようでしたら』 で 他方向 拒否印象)」 「曜日基準 wording (週跨ぎ齟齬)」 「wording ぎこちなさ (『受入担当のご連絡』 等)」 「compact評価対象への配慮不足」 を hostile として 事前列挙

dump は `work/` (task context) or scratchpad に保存、 draft 参照可能に。

### B-2: fable subagent への dispatch (compact draft + hostile review)

軽微 (= 1-2 line 修正、 phrasing微調整) は Manager 直接 Edit で可、 但し **初回 draft と大幅修正 (3+ line変更 or 論理再構成) は fable subagent 経由推奨**:

```
Agent({
  subagent_type: "general-purpose", model: "fable",
  run_in_background: true,
  prompt: "業務メール返信 compact draft + hostile review。
    input: SC-3R dump path + narrative source verbatim (Slide/ES/前mail).
    output: 案A (mid, 14-18行) + 案B (short, 10-13行) 両方 + fable自身の hostile review 5+ findings + 推奨案 + self-admission."
})
```

target 行数:
- **案A (mid)**: 本文 12-18行 (全項目応答型、 期間項目 placeholder付)
- **案B (short)**: 本文 9-13行 (skip可能項目 [アンケート回答済等] を skip)

### B-3: 反復修正 loop (user directive 1件ずつ verbatim反映 + rev tracking)

user修正 1件 = 1 rev、 各 rev で dump commit (= git履歴で 変更 traceable)。 典型 user directive types:

| 修正 type | 例 | 対応 pattern |
|----------|-----|-------------|
| narrative追加 | 「面接で出た話も入れて」 | 該当 sentence を 相手発言引用形式で 差し込む (「面談でお伺いした〜が印象に残っております」) |
| narrative削除 | 「これ書きすぎ」 | 該当 line 削除 + 前後 flow修正 |
| tone調整 (排他→open) | 「『〜ようでしたら関わりたい』 だと他だと嫌みたい」 | 「例えば〜まず思い浮かびました。 もちろん、 他にも重要な取り組みがございましたら〜」 open形に |
| 汎化 (pin-point→抽象) | 「『FEM未経験』 は 悪目立ちする、 『全体的に浅学』 に」 | 弱点具体名を pin-point しない、 抽象汎化 (悪目立ち回避) |
| 曜日中立化 | 「金曜受信・月曜返信、 『来週』 は齟齬」 | 「詳細のご連絡お待ちしております」 曜日非依存 wording |
| phrasing自然化 | 「『受入担当のご連絡』 不自然」 | 冗長修飾を落として natural化 (「ご連絡いただき」) |
| 署名調整 | 「順序 名前top」 「所属追加/削除」 | user preference verbatim反映 |
| scope配慮追加 | 「2週間には思い付きが大きい」 | 「もっとも、 2週間の実習ですので着手範囲は絞られると理解しており」 現実感表明 |

各 rev で dump 更新 + git commit (`dump(xxx): mail draft revN (user 修正内容)`)。

### B-4: 送信前 blocker checklist (5件 標準)

送信 or 予約設定 直前に user 目視確認要 (subagent 側で 判定不能な 領域):

1. **typo確認**: email address / 電話番号 / 氏名漢字 / 相手先社名/氏名
2. **二重お礼リスク**: 面談直後お礼メール 既送信か → 既送信なら 冒頭お礼 短一言 or 削除
3. **skip項目の前提**: 「アンケート回答済なら 期間項目返信不要」 等の skip 前提が 実際に true か
4. **narrative paraphrase の 実面談との一致**: 「面談で伺った 〜という方向性」 等の 引用形式 wording が 実際の面談発言と 合っているか (subagent 非同席のため user目視必須)
5. **相手発言と 自分能力 claim の 分離**: 相手側の話 は 「面談で伺った」 引用形式で 帰属させ、 自分の能力 claim にしない (overclaim 回避)

### B-5: 予約送信 タイミング recommendation

business mail 送信タイミング (recipient受信tray 心理 + 業界慣習):

| 判定 | 推奨タイミング | 理由 |
|-----|-------------|------|
| **default** | **月曜 (or 週初 平日) 9:00** | 業務開始直後 tray natural、 週初処理 rhythm と合致 |
| 相手が 業務時間 明確 (例: 事務担当) | 業務開始 30分後 (9:30-10:00) | tray整理直後 に読める |
| 昼休み明け tray狙い | 13:00-14:00 | 会議終わり tray整理 tail |
| **回避**: 早朝 (5-8時) | — | 「深夜・早朝仕事」 印象 |
| **回避**: 金曜夕方 | — | 「金曜夕に対応漏れ」 印象、 週跨ぎ pending |

### Business mail 用 追加 Hard rules

- draft 段階で 数値 verbatim 反映 (数値は ES / 提出資料 と一致する SoT 参照)、 subagent の 独自具体化 (「入力条件、 モデルversion、 評価指標、 実測との差」 等) は user承認 verbatim base のみ許可 (= OF-03 manager overreach禁止 準拠)
- 業務メール 署名 = 「氏名 + 所属 + Tel + E-mail」 が business standard (user preference で 順序 変更可)
- 情緒装飾 (「楽しみにしております」 等) は default 削除、 compact 評価対象を意識
- 「〜させていただきます」 の 過剰使用禁止 (敬語過剰 = 若い印象、 「〜いたします」 の方が formal でスッキリ)

## Anti-Patterns

| Don't | Do |
|-------|-----|
| 1 turn で final 確定 | 反復推敲前提で v1 提示 + 修正待ち |
| 受信 msg を paraphrase で要約 | verbatim 引用 |
| 関係性曖昧なまま draft | 1 行確認 |
| 「絶対送るべき」 等 prescriptive 文言 | 「温度感で」「かもしれません」 等柔軟表現 |
| 受信者環境を仮定 (= 「nc で」) | Mac/Linux/Windows 併記 |
| `(= 補足)` を多用して冗長化 | 必要箇所のみ、 main statement に統合検討 |

## Related

- `references/tone-matrix.md` — 関係性 × tone レベル + default 開頭 / 閉じ集
- `references/connectivity-cheatsheet.md` — Mac/Linux/Windows 別動作確認 cheatsheet
- `references/polish-patterns.md` — polish technique 集 (= 削る / 暗示 / forwarding / 余談線、 before/after 例)
