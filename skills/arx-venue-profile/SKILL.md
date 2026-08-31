---
name: arx-venue-profile
description: Venue weight loader (called by arx-paper-review).
allowed-tools: Read, Bash
---

# Venue Profile Loader

Load venue-specific review configuration for the arx- academic review system. This skill is invoked at Stage 0 of the `/arx-paper-review` orchestrator and provides context to all downstream review skills.

## Input

- `$ARGUMENTS`: Venue name string (case-insensitive). One of: `sensys`, `mobisys`, `eurosys`, `rtcsa`, `rtss`, `ewsn`, `usenix-atc`, `osdi`, `algorithms`

## Output

Print the venue profile to stdout as a structured YAML block. The orchestrator captures this and passes it to all review skills.

## Venue Profiles

See `references/venue-profiles.md` for the full YAML profiles of all supported venues.

**Supported venues**: SenSys, MobiSys, EuroSys, USENIX ATC, OSDI, RTCSA, RTSS, EWSN, Algorithms/Scheduling

Each profile includes: `emphasis`, `weight_modifiers`, `artifact_expectation`, `theory_system_balance`, `prior_scores`, `fatal_flaw_emphasis`, `related_venues`, and `review_notes`.

### Prior Scores

Each venue profile includes `prior_scores` -- initial score estimates before any review data.
Used by arx-meta-review with the memory=0.7 update rule:
- First iteration: `score = prior * 0.7 + observed * 0.3`
- Subsequent: `score = previous * 0.7 + observed * 0.3`

Priors reflect venue-typical paper characteristics (e.g., embedded venues have lower reproducibility priors).

## Related Venues

When a venue has `related_venues`, the reviewer receives the related venues' emphasis lists as "also consider" reference information. This does NOT change scores -- it only ensures domain-adjacent concerns are visible to the reviewer.

**How it works**: At Stage 0, the orchestrator loads the primary venue profile and its `related_venues` list. For each related venue, the `emphasis` items are collected and passed to downstream review skills as supplementary context labeled "Related venue emphasis (informational only)". The `weight_modifiers` from related venues are NOT applied -- only the primary venue's weights affect scoring.

**Example**: When reviewing for RTCSA (related: sensys, eurosys, algorithms_scheduling), the reviewer sees:
- RTCSA emphasis (primary, weights applied): real-time constraints, worst-case analysis, embedded ML, timing analysis, ML/RT trade-offs
- SenSys emphasis (reference only): embedded realism, deployment assumptions, energy measurement, hardware detail, duty-cycling
- EuroSys emphasis (reference only): systems contribution, baseline fairness, broad relevance, implementation completeness, artifact evaluation
- Algorithms emphasis (reference only): formal assumptions, correctness guarantees, adversarial analysis, complexity, theory-practice gap

This helps reviewers consider concerns that adjacent communities would raise, without distorting the target venue's scoring model.

### Related Venue Mapping

| Venue | Related Venues |
|-------|---------------|
| RTCSA | sensys, eurosys, algorithms_scheduling |
| RTSS | rtcsa, eurosys, sensys, algorithms_scheduling |
| SenSys | mobisys, rtcsa, ewsn |
| MobiSys | sensys, eurosys |
| EuroSys | sensys, mobisys, rtcsa |
| USENIX ATC | sensys, mobisys, rtcsa |
| OSDI | sensys, mobisys, rtcsa |
| EWSN | sensys, mobisys |
| Algorithms | rtcsa |

## Usage

When invoked, this skill:

1. Matches `$ARGUMENTS` to a venue name (case-insensitive, partial match OK)
2. Outputs the full venue profile as a YAML block
3. If `related_venues` is present, also outputs each related venue's `emphasis` list (labeled as reference info)
4. If no match, lists available venues and asks for clarification

The venue profile is consumed by all downstream arx- skills as the `venue_profile` parameter.
