# Tone Matrix

返信 draft 時の関係性 × tone レベルから default を選ぶ参考表。

## 関係性 × tone レベル

| 関係性 | default tone | 開頭例 | 閉じ例 |
|---|---|---|---|
| 先生 / 教員 / 上司 | **polite** | お疲れさまです。 | よろしくお願いいたします。 |
| 業者 / 外部依頼者 / ITC 等 | **formal** | お世話になっております。 | 何卒よろしくお願いいたします。 |
| 同僚 / RA / 同じプロジェクト | **neutral** | お疲れさまです。 | よろしくお願いします。 |
| 学生 / 後輩 | **casual / neutral** | お疲れさまです。 / おつかれー | よろしくお願いします。 / よろしく〜 |
| 雑談 / 進捗共有 (= jn-ops 内 etc.) | **casual** | (なし or「お疲れさまです〜」) | (なし or「よろしく〜」) |

## tone level の判断軸

| 軸 | formal | polite | neutral | casual |
|---|---|---|---|---|
| 文末 | 「いたします」「ございます」 | 「いたします」「お願いいたします」 | 「します」「お願いします」 | 「するね」「お願い」 |
| 一人称 | (なし、 jn ops 等の集団主語) | (なし or「こちら」) | (なし or「こちら」) | (なし or「自分」) |
| 二人称 | 「貴社」「先生方」 | 「先生」「ご担当者様」 | (省略 or「@username」) | (省略 or「@username」) |
| 絵文字 | 不使用 | 不使用 | 1-2 個まで (= 🙏 等) | 自由 |
| 補足の括弧 | 抑制 (= 本文に統合) | 補助のみ | 自由 | 自由 |
| **推奨 / 提案の強度** | 「〜を推奨いたします」 / 「ご検討いただければ」 | 「〜が楽かなと思います」 / 「個人的には〜推奨です」 | 「〜がおすすめ」 / 「〜の方がいいかも」 | 「〜がいいかも」 / 「〜でいい」 |
| **mention 要否** | thread top で必須 (= 「貴社の」 等明示) | channel 内 = `@username さん` / 1-on-1 = 不要 | channel 内 = `@username` / 1-on-1 = 不要 | DM = 不要 / channel = 軽 mention (= `@xx` 等) |

## tone shift 規則

user 修正で tone shift する時、 **1 段ずらしを default**:

- formal ↔ polite (= 1 段)
- polite ↔ neutral (= 1 段)
- neutral ↔ casual (= 1 段)
- formal → casual の 2 段以上は **user 明示 mandate なし限り NG** (= 受信者側の認識ズレ risk)

## 関係性が不明な時

最初の draft では **1 段堅め** を default にする (= 「neutral か polite か迷ったら polite」)。 後で user 修正で casual 寄せる方が、 逆 (= casual → polite を user 修正) より安全。

## jn-ops 文脈での具体例 (= 参考)

- `@slash` / `@aokiti` / `@jnroot-operators` 等の **Slack mention** で外部から依頼 → **業者 / 外部依頼者** tone (formal-polite)
- 大越教授 / 中澤先生 等への返信 → **先生** tone (polite)
- jnroot 内 (= 同 RA / 同管理者) → **同僚** tone (neutral)
- slack-zakki 投稿 → **雑談** tone (casual)

## Anti-patterns

- 1 文中で tone level が混在 (= 「お疲れさまです〜 ... よろしくお願いいたします」 = 開頭 casual + 閉じ formal は不整合)
- 関係性が「先生」 で casual tone (= 失礼 risk、 NG)
- 関係性が「学生 / 後輩」 で formal tone (= 距離感過剰、 過度に他人行儀)
