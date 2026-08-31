---
name: self-critique
description: Trigger at phase completion for quality verification. Use when "self critique", "SC-3R", "quality check", "phase review", "自己批評" is requested.
allowed-tools: Read, Glob, Grep, Bash, Agent
---

# 自己批評フレームワーク

複数フェーズタスクの品質管理のための自己批評パターン。

## 大規模タスク実行時の自己批評

複数フェーズにわたるタスクでは、各フェーズ完了後に自己批評チェックポイントを設ける：

1. 期待値と実際の結果を表形式で比較
2. 差異があれば理由を明記
3. PASS/FAIL を判定してから次フェーズへ進む

**行番号・参照の検証**: レポート内で `file:line` 形式の引用を行う場合、実際のファイル行数を確認し、存在しない行番号を記載しないこと。

### テンプレート

```markdown
## Phase N 自己批評チェックポイント

| 項目 | 期待値 | 実績 | 判定 |
|------|--------|------|------|
| [項目1] | [期待] | [実際] | PASS/FAIL |

### 発見事項
- [発見1]

### 判定: PASS / FAIL
```

## Self-Critique 3ラウンド (SC-3R)

| Round | 対象 | 検証項目 |
|-------|------|---------|
| **1** | 構造検証 | CLAUDE.md 標準準拠、フォルダ命名、必須ファイル存在 |
| **2** | 整合性検証 | order↔report 対応、参照パス整合性、plan.md との一致 |
| **3** | 最終検証 | 研究品質、ユーザー要件、見落としチェック |

**重要**: FAIL が出た場合は修正後に再検証してから次へ進む。

### R3 audit rigor floor: hostile-claim 5+ mandate (cross-audit meta-rule)

R3 audit phase では **hostile reviewer 視点で hostile claim を 5 件以上構築**、 各 claim に対して 「rebut」 (反駁) または 「ack」 (受容) を明記する。 数不足時は 「R3 rigor floor 不充足、 再 audit」 verdict、 SC-3R triple 完了不可。 Cross-source: Phase 27 BG3 + BG6 multi-epoch、 MEMORY `feedback_sc3r_r3_hostile_5plus`、 `claude-shared/rules/skill-discipline.md` (subagent reload context での R3 適用)。

**Rationale**: R1 (構造) + R2 (整合性) + R3 (最終検証) のみでは self-confirmation bias で reviewer-perspective blind spot 残る。 hostile-claim 5+ mandate は意図的 devil's advocate 強制で audit rigor 確保。 外部 hostile audit (Codex iterative R3 等) と相補的に使用。

**Tier system** (rigor 強度の使い分け):

- **LIGHT (3+ hostile claims)**: 通常 SC-3R (phase 完了確認、 trivial change verify)。 過剰負荷を避けるため最低 3 件で許容。
- **HEAVY (5+ hostile claims)**: high-rigor R3 / cross-audit / hostile review / publication-ready check / external delegation gate / phase boundary commit。 self-confirmation bias リスクが高い場面では 5+ 必須。

**Tier 判定 explicit table** (LIGHT vs HEAVY: 観測可能 trigger で 1-axis 判定。各行は boolean truth condition で書く — qualitative 修飾子 (`軽微` / `単純` 等) は executor 解釈幅を再導入するため使わない):

| 観測指標 | LIGHT 該当 (boolean) | HEAVY 該当 (boolean) |
|---------|---------------------|---------------------|
| 外部露出 (publication / external reviewer / 外部 audit) | 全て false (no publication AND no external reviewer AND no external audit) | いずれか true (any one) |
| 変更 scope | touched-module 数 = 1 (同一 module 内の code + colocated test の pair は 1 module 扱い) AND touched-file 数 ≤ 3 | touched-module 数 ≥ 2、 または architecture / public API / cross-cutting 変更を含む |
| reviewer 介入 | self-only (true) | external 介入 true (Codex / collaborator / PC のいずれか) |
| 改訂後 ship 直前判定 | false (後段に追加 phase / smoke test / review が残る) | true (本 verdict 後に ship される) |

**判定 rule**:
1. HEAVY 行のいずれか 1 つでも該当 → **HEAVY**
2. 全行 LIGHT 列に該当 → **LIGHT**
3. 同一事象が両 tier 例に登場した場合 (例: "phase boundary commit") は **外部露出の有無で 1-axis 上に展開**: 外部露出あり = HEAVY、なし = LIGHT

**HEAVY → LIGHT 降格 (downgrade) 条件** (対称規定。以下のいずれかが成立する場合のみ許容):

- artifact 未渡し / R2 source ファイル不在 → R2 を `external implementer に委任` 扱いとし、HEAVY 維持の上で R2 を PARTIAL 申告 (downgrade ではなく **honest partial**)
- 直近 N round 以内に外部 hostile audit が APPROVE 済み (e.g., Codex iterative R3 が APPROVE) かつ 変更が text-only minor revision
- 過去 SC-3R triple が 2 連続 PASS でかつ 当該 phase が同種反復 (publication 露出変化なし)

降格時は **降格根拠を verdict に明記** (例: `Tier: HEAVY → LIGHT (grounds: text-only revision + Codex R3 APPROVE @ STEP-N)`)。 grounds 不在の silent downgrade は禁止 (self-confirmation bias の典型)。

**判定 4-state 拡張** (PASS / FAIL の 2 値では grey case が押し出されるため、以下 4 値を許容)。

**重要**: 4 値は 2 つの異なる vocabulary を含む — `scope` 列を見て round-verdict 用と claim-tag 用を取り違えないこと。 scope を逸脱した使用は ill-formed (例: rebut-qualified を R1 の round verdict として使う / PARTIAL を hostile claim tag として使う):

| 値 | scope | 意味 | escalation rule |
|---|------|------|----------------|
| PASS (○) | round verdict / phase verdict (R1/R2/R3 共用) | 期待値↔実績一致、致命なし | 次 round / 次 phase へ |
| FAIL (×) | round verdict / phase verdict (R1/R2/R3 共用) | [critical] 違反 / floor 不充足 / 致命的乖離 | 修正後再検証必須 (line 44) |
| PARTIAL | round verdict 専用 (claim には適用不可) | 片寄り / 部分達成 / source 不在による検証不能 | 次 round の hostile claim へ escalate、 最終 round 時点で残留 PARTIAL なし → overall PASS |
| rebut-qualified | R3 hostile claim tag 専用 (round verdict 不可) | hostile claim 中で「claim re-scope により原指摘を吸収」(完全 rebut でも完全 ack でもない中間) | claim を狭めて吸収する mitigation を伴う場合は **ack 扱い** に再分類; その他の中間状態は明示 grounds 必須 |

(参考: rebut / ack 単純 2 値も R3 hostile claim tag 専用。 rebut-qualified はこの 2 値の中間状態を扱う 3 値目。)

PARTIAL / rebut-qualified を round 内で運用する場合は **escalation 経路を verdict に明記** (silent 二値変換は禁止)。

**Apply pattern** (HEAVY 適用時):

1. R3 で hostile reviewer mode 強制 (devil's advocate / PC-chair perspective)
2. hostile claim を **5 件以上** 列挙 (具体性: 何が overclaim / 何が evidence weak / 何が dependency 不整合 等)
3. 各 claim に対して `rebut` (反駁 + 根拠) または `ack` (受容 + mitigation 計画) を明記。 中間状態は `rebut-qualified` (4-state 拡張参照) で扱う
4. floor 不充足時は FAIL — 詳細 rule は R3 rigor floor mandate (line 48: HEAVY 5+ / LIGHT 3+) と 4-state escalation rule (line 88: silent 二値変換禁止) に従う (重複記述を避けるため cross-reference 化)

domain-specific な追加 verification (build-time check / venue compliance / 用語一貫性 等) は各上位 skill が specialization として追加してよいが、 本 hostile-claim 5+ floor は **domain-agnostic な base rigor floor** として常に適用する。

### 抽象↔具体 alternation per round (cross-audit policy)

SC-3R triple は 各 round で **抽象↔具体 alternation** を強制する。 single-scale 持続禁止：

- **R1 (構造)** = 抽象 layer (file 構造 / heading hierarchy / SoT registry / フォルダ命名)
- **R2 (整合性)** = 具体 layer (`file:line` 引用 / cross-file diff / 数値 trace)
- **R3 (hostile)** = 抽象 layer (reviewer 視点 / story 整合性 / claim framing / venue fit)

**Why**: 抽象だけ → over-generalization で micro-detail leakage、 具体だけ → missed-systemic-issue で macro-arc blind-spot。 alternation で両 trap を 同時 回避する。 macro-scale 再構成 lane の運用 (per wave / phase boundary) は `paper-review-roundflow/references/seidoku.md` の "Macro lane" section を参照。

## 証拠の強さの二軸評価

研究上の主張（claim）の強さを記述する際は、以下の 2 軸を明確に分離すること:

- **Empirical evidence** (実験データによる裏付け): "Strong" / "Moderate" / "Weak"
- **Mechanistic explanation** (理論的メカニズムの説明): "Resolved" / "Unresolved" / "Hypothetical"

例: `Strong (empirical) / Unresolved (mechanism)` のように併記する。単に "Strong" とだけ書くと overclaiming として reviewer に指摘される。

## 過去の知見に対する誠実さ

- 実際に読んでいないファイルの内容を推測で語らない
- 過去の Phase を正確に把握できていない場合は、素直に「未確認」と申告し精読ステップを提案する
- 新しい実験や分析を提案する前に、同等の実験が過去に実施済みでないか work/ の記録を検索する

## 歴史的調査タスクのスコープ拡大判断

複数 Phase にまたがる調査では、以下の構造を採用:

1. 既知の範囲を精読 + 逐次 dump
2. **スコープ拡大判断**: さらに遡る必要があるか、他に読むべきファイル/リポジトリがあるかを判断
3. 必要なら追加精読 + dump
4. 横断統合・考察

## 残タスク棚卸し時の DUMP 参照義務

残タスクの棚卸しや次セッションの引き継ぎを行う際は、work/ の過去ダンプファイルを必ず参照すること。記憶や推測ではなく、ファイルに記録された事実に基づいて判断する。

## Meta-TODO パターン（自走セッション用）

自走セッションでは「TODO を追加する TODO」を含め、問題解決まで自律的に継続する。各ステップで次にやるべきことを TODO として追加し、空になるまで回す。

