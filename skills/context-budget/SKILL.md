---
name: context-budget
description: >
  Trigger when analyzing context window usage. Use when "context budget",
  "token usage", "how much context", "コンテキスト分析" is requested.
argument-hint: "[--verbose] [--component rules|skills|mcp]"
allowed-tools: Read, Glob, Grep, Bash
---

# Context Budget Analyzer

rules/, skills/, MCP server instructions がコンテキストウィンドウをどれだけ消費しているか推定する。

## Workflow

1. **Inventory**: Glob で以下のソースを列挙
   - `~/.claude/CLAUDE.md` (global instructions)
   - `~/.claude/rules/**/*.md` (global rules)
   - Project-level `CLAUDE.md` files (recursive)
   - `rules/**/*.md` (project rules)
   - `skills/*/SKILL.md` (all skills -- loaded on trigger, not at startup)
   - MCP server instructions (from system-reminder blocks)
2. **Measure**: 各ファイルの文字数を取得し、トークン数を推定 (chars / 3.5 for Japanese-heavy, chars / 4 for English)
3. **Classify**: always-loaded vs on-demand に分類
   - Always-loaded: CLAUDE.md, rules/, MCP instructions
   - On-demand: skills/ (triggered only), agent tools
4. **Report**: コンポーネント別のトークン消費テーブルを出力

## Output Format

```markdown
## Context Budget Report

### Always Loaded
| Component | Files | Est. Tokens | % of 200k |
|-----------|-------|-------------|-----------|
| Global CLAUDE.md | 1 | 850 | 0.4% |
| Global rules | 5 | 3,200 | 1.6% |
| Project CLAUDE.md | 3 | 1,500 | 0.8% |
| Project rules | 4 | 2,800 | 1.4% |
| MCP instructions | 2 | 1,200 | 0.6% |
| **Subtotal** | **15** | **9,550** | **4.8%** |

### On-Demand (per invocation)
| Skill | Est. Tokens |
|-------|-------------|
| /task-init | 1,100 |
| /self-critique | 650 |

**Total always-loaded**: ~9,550 tokens (4.8% of 200k)
**Largest component**: Global rules (3,200 tokens)
**Recommendation**: [optimization suggestions if > 15%]
```

## Gotchas

- Token estimation is approximate. Japanese text averages ~3.5 chars/token; English ~4 chars/token. Mixed content uses a blended ratio.
- MCP server instructions are injected by the runtime and not stored as files. The skill reads them from system-reminder patterns in conversation, which may not be available outside an active session.
- Skills are on-demand but their frontmatter `description` is always loaded in the skill index. Only the full body is deferred.
- Nested CLAUDE.md files (e.g., `order/CLAUDE.md`, task-level CLAUDE.md) are all loaded when working in that directory. The total depends on cwd.
- The 200k baseline assumes the standard context window. Adjust if using a different model or extended context.
