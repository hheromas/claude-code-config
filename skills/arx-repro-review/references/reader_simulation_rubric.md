# Reader-Simulation Rubric (10-axis, mode: tech-article)

> Adapted from `mizchi/skills/tech-article-reproducibility` (SKILL.md).
> Used by `arx-repro-review` when invoked with `mode: tech-article` for
> technical blog posts / hands-on / tutorial articles.
> **Independent axis** from prose-style evaluation (`mizchi-blog-style`)
> and from logical/argumentative evaluation. Premise: the most important
> property of a technical article is whether a first-time reader can
> reproduce it on their own machine.

## When to use

- Final pre-publication check on a technical article draft
- Hands-on / tutorial articles
- Tool introduction / setup articles
- Verifying an article that claims "it worked"

When NOT to use:
- Conceptual explainer articles (nothing to reproduce)
- Poems / opinion pieces
- Self-contained small tidbits

## 10-axis rubric

Score each axis on a 0-2 scale, 20 points total. Convert to a 10-point scale
by dividing by 2 if a unified score is needed.

| # | Axis | 0 (NG) | 1 (partial) | 2 (OK) |
|---|---|---|---|---|
| 1 | Environment prerequisites stated | No OS / version / required tools listed | Partially listed | Everything listed (OS, lang version, CLI tools) |
| 2 | Code completeness | Fragments only, imports/setup omitted | Only the main part | Full, copy-pasteable form that runs |
| 3 | Command accuracy | Placeholders left as-is (`<your-token>` etc. without explanation) | Some placeholders | Runnable as-is |
| 4 | Version dependency stated | No mention | Partial | Explicit, e.g. "works on v3.x", "v2 or earlier behaves as X" |
| 5 | Full config files included | Excerpts only | Main keys only | Full minimal working config |
| 6 | Expected output shown | None | Explained in prose | Actual output / screenshot |
| 7 | Handling of errors | Not mentioned | One case touched on | Several major errors + how to handle them |
| 8 | Project prerequisites stated | Author-environment assumptions are implicit | Partially stated | Paths / repo structure / existing config all stated |
| 9 | Link health | Links broken or require auth | Some require auth | All accessible publicly |
| 10 | Author-specific knowledge stated | Helpers / dotfiles assumed implicitly | Partially stated | Fully stated or not required |

## Evaluation workflow

The subagent plays the role of **"a first-time reader trying to reproduce
the work"** rather than "an executor."

1. Fix the target article (path)
2. Subagent dispatch (prompt template below)
3. Extract reproduction sticking points from the returned evaluation
4. Add / fix text in the article to address those sticking points
5. If needed, re-evaluate with a fresh subagent

No external script is required. This is a **prompt-based** mode driven by
the dispatch template below via the Task tool (general-purpose subagent).

## Subagent dispatch prompt template

```
You are a reader interested in <the article's subject area> but new to
<the tech stack>. You are going to read this article and try to reproduce
the same thing in your local environment.

## Target article
<path to the article file>

## Evaluation axes (10 reproducibility axes)
Score each axis 0-2. Refer to the rubric in
`claude-shared/skills/arx-repro-review/references/reader_simulation_rubric.md`.

1. Environment prerequisites stated
2. Code completeness
3. Command accuracy
4. Version dependency stated
5. Full config files included
6. Expected output shown
7. Handling of errors
8. Project prerequisites stated
9. Link health (actually verify with WebFetch)
10. Author-specific knowledge stated

## Tasks
1. While reading the article, imagine "where would I get stuck if I
   reproduced this on my own machine?"
2. Score each axis 0-2 with quoted evidence.
3. List the top 5 sticking points with line numbers.

## Report structure
- Reproducibility score: X/20 (breakdown table)
- Top 5 sticking points: <line number> <quote> -> <why it sticks>
- Missing information: list of things that should be added to the article
- Overall verdict: what percentage chance (subjective) do you have of
  reproducing this after reading the article
```

## Score interpretation

- **18-20**: Publishable as a hands-on piece; almost no additional information needed
- **14-17**: Some googling required, but reproducible; okay to publish
- **10-13**: Information outside the article is required to reproduce; revisions recommended
- **9 or below**: Hard to reproduce; rethink the article's premise or
  position it as something other than a hands-on piece

## Pitfalls

- **Evaluator's background knowledge too high**: if you don't explicitly
  tell the subagent to play a "first-time reader" role, it will judge
  "enough information" from an expert's viewpoint. Emphasize "first-time
  reader" in the prompt.
- **Ignoring link health**: links alive at publication time can break a
  year later. Separately check whether reproduction is possible using only
  **live** links.
- **Inlining all sample code**: reproducibility goes up, but the article
  bloats. A hybrid approach (inline code + repository link) is realistic.
- **Reproducibility != prose quality**: an article can be highly
  reproducible yet hard to read. Combine with `mizchi-blog-style` and
  similar to measure both axes.

## Related

- `mizchi-blog-style` -- prose-style axis (independent from this rubric)
- `arx-repro-review` SKILL.md (default `mode: paper`) -- academic 15-point schema
