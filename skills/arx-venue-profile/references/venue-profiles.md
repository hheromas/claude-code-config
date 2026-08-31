# Venue Profiles

## SenSys

```yaml
venue: SenSys
full_name: "ACM Conference on Embedded Networked Sensor Systems"
type: systems_embedded
emphasis:
  - Embedded realism and sensing constraints
  - Deployment assumptions and field validation
  - Energy consumption and power measurement methodology
  - Hardware detail (board, firmware, peripherals)
  - Duty-cycling and resource-constrained operation
weight_modifiers:
  problem_significance: 1.0
  novelty_contribution: 1.0
  technical_soundness: 1.0
  evaluation_quality: 1.1   # Stricter on real-world evaluation
  reproducibility: 1.2      # High artifact expectation
  clarity_organization: 1.0
  fit_impact: 1.0
artifact_expectation: HIGH
  # Board-level artifact, firmware, power measurement setup expected.
  # Simulation-only results are weak without field deployment justification.
theory_system_balance: system_heavy
  # Novel systems contribution valued over theoretical analysis.
  # Formal guarantees welcome but not required.
prior_scores:
  problem_significance: 55
  novelty: 50
  technical_soundness: 50
  evaluation_quality: 45
  reproducibility: 35  # embedded HW is hard to reproduce
  clarity: 55
  fit_impact: 55
fatal_flaw_emphasis:
  - Missing energy/power measurement methodology
  - Unrealistic deployment assumptions for sensor networks
  - No real hardware validation
related_venues: [mobisys, rtcsa, ewsn]
review_notes: >
  SenSys reviewers expect concrete embedded systems contributions.
  Papers must demonstrate awareness of real-world deployment constraints.
  Artifact evaluation is strongly encouraged; board-level reproducibility
  is a significant positive signal.
```

## MobiSys

```yaml
venue: MobiSys
full_name: "ACM International Conference on Mobile Systems, Applications, and Services"
type: systems_embedded
emphasis:
  - Mobile deployment realism and human/device context
  - System impact beyond lab setting
  - User study methodology (if applicable)
  - App-level artifact and deployment evidence
  - Battery, bandwidth, and latency trade-offs
weight_modifiers:
  problem_significance: 1.0
  novelty_contribution: 1.0
  technical_soundness: 1.0
  evaluation_quality: 1.1
  reproducibility: 1.2
  clarity_organization: 1.0
  fit_impact: 1.1   # Community impact matters
artifact_expectation: HIGH
  # App, deployment evidence, user study data expected.
theory_system_balance: system_heavy
prior_scores:
  problem_significance: 55
  novelty: 50
  technical_soundness: 50
  evaluation_quality: 45
  reproducibility: 40
  clarity: 55
  fit_impact: 55
fatal_flaw_emphasis:
  - Missing deployment/user study when claiming mobile applicability
  - Ignoring battery/bandwidth constraints
  - Lab-only evaluation for deployment claims
related_venues: [sensys, eurosys]
review_notes: >
  MobiSys values end-to-end system demonstrations.
  Papers claiming mobile applicability must address real deployment conditions.
  SIGMOBILE artifact guidelines apply.
```

## EuroSys

```yaml
venue: EuroSys
full_name: "European Conference on Computer Systems"
type: systems
emphasis:
  - Systems contribution and implementation maturity
  - Baseline fairness and comparison methodology
  - Broad systems relevance beyond niche
  - Implementation completeness (what is/isn't implemented)
  - Artifact evaluation (AE process with 3-4 evaluators)
weight_modifiers:
  problem_significance: 1.0
  novelty_contribution: 1.0
  technical_soundness: 1.1
  evaluation_quality: 1.1
  reproducibility: 1.3   # Very high AE expectation
  clarity_organization: 1.0
  fit_impact: 1.0
artifact_expectation: VERY_HIGH
  # Full AE process: completeness, documentation, buildability, main claims reproduction.
theory_system_balance: system_heavy
prior_scores:
  problem_significance: 50
  novelty: 45  # very competitive
  technical_soundness: 50
  evaluation_quality: 50
  reproducibility: 45  # AE process expected
  clarity: 55
  fit_impact: 50
fatal_flaw_emphasis:
  - Unfair baselines or missing state-of-the-art comparison
  - Implementation status unclear
  - Artifact does not support main claims
related_venues: [sensys, mobisys, rtcsa]
review_notes: >
  EuroSys has a rigorous artifact evaluation process.
  Paper reviewers should indicate which claims AE evaluators should reproduce.
  Implementation maturity is a key differentiator.
```

## USENIX ATC

```yaml
venue: USENIX_ATC
full_name: "USENIX Annual Technical Conference"
type: systems
emphasis:
  - Significant problem with practical solution
  - Sound experimental and statistical evaluation
  - Clear statement of what is and isn't implemented
  - Prior work differentiation
  - Over-claim suppression
weight_modifiers:
  problem_significance: 1.1
  novelty_contribution: 1.0
  technical_soundness: 1.0
  evaluation_quality: 1.2   # Sound evaluation is paramount
  reproducibility: 1.2
  clarity_organization: 1.0
  fit_impact: 1.0
artifact_expectation: VERY_HIGH
theory_system_balance: system_heavy
prior_scores:
  problem_significance: 50
  novelty: 45  # very competitive
  technical_soundness: 50
  evaluation_quality: 50
  reproducibility: 45  # AE process expected
  clarity: 55
  fit_impact: 50
fatal_flaw_emphasis:
  - Weak or missing baselines
  - Cherry-picked evaluation scenarios
  - Overclaiming beyond implemented scope
related_venues: [sensys, mobisys, rtcsa]
review_notes: >
  USENIX ATC values practical significance and sound evaluation.
  "What is and isn't implemented" must be explicit.
  Statistical rigor in experiments is expected.
```

## OSDI

```yaml
venue: OSDI
full_name: "USENIX Symposium on Operating Systems Design and Implementation"
type: systems
emphasis:
  - Computer systems research relevance
  - Community impact and broad applicability
  - Implementation depth and engineering quality
  - Evaluation at realistic scale
weight_modifiers:
  problem_significance: 1.1
  novelty_contribution: 1.1
  technical_soundness: 1.1
  evaluation_quality: 1.2
  reproducibility: 1.2
  clarity_organization: 1.0
  fit_impact: 1.1
artifact_expectation: VERY_HIGH
theory_system_balance: system_heavy
prior_scores:
  problem_significance: 50
  novelty: 45  # very competitive
  technical_soundness: 50
  evaluation_quality: 50
  reproducibility: 45  # AE process expected
  clarity: 55
  fit_impact: 50
fatal_flaw_emphasis:
  - Toy-scale evaluation for systems-scale claims
  - Missing comparison with deployed systems
  - Unclear engineering contribution vs research contribution
related_venues: [sensys, mobisys, rtcsa]
review_notes: >
  OSDI expects systems papers with clear research contributions.
  Distinguish engineering effort from research novelty.
  Evaluation should demonstrate scalability.
```

## RTCSA

```yaml
venue: RTCSA
full_name: "IEEE International Conference on Real-Time Computing Systems and Applications"
type: systems_embedded
emphasis:
  - Real-time constraints and scheduling guarantees
  - Worst-case analysis (WCET, deadline miss bounds)
  - Embedded ML integration with timing guarantees
  - Formal or semi-formal timing analysis
  - Trade-off between ML accuracy and real-time compliance
weight_modifiers:
  problem_significance: 1.0
  novelty_contribution: 1.0
  technical_soundness: 1.1   # Formal rigor expected for RT claims
  evaluation_quality: 1.0
  reproducibility: 1.0       # Simulation acceptable
  clarity_organization: 1.0
  fit_impact: 1.0
artifact_expectation: MEDIUM
  # Simulation-based evaluation is acceptable.
  # Hardware prototype is a positive signal but not required.
theory_system_balance: balanced
  # Both theoretical analysis and system implementation valued.
  # Papers spanning theory and practice are particularly welcome.
prior_scores:
  problem_significance: 55
  novelty: 50
  technical_soundness: 50
  evaluation_quality: 45
  reproducibility: 40
  clarity: 60
  fit_impact: 55
fatal_flaw_emphasis:
  - Real-time claims without worst-case or probabilistic analysis
  - Missing deadline miss characterization
  - Scheduler evaluation without adversarial or stress-test workloads
related_venues: [sensys, eurosys, algorithms_scheduling]
review_notes: >
  RTCSA bridges real-time theory and embedded systems practice.
  Track 1 (Real-Time ML) expects timing-aware ML system design.
  Track 3 (Embedded ML) expects practical embedded deployment evidence.
  IEEE format: IEEEtran.cls, 10pt, two-column, letter, 10+2 pages.
```

## EWSN

```yaml
venue: EWSN
full_name: "International Conference on Embedded Wireless Systems and Networks"
type: systems_embedded
emphasis:
  - Sensor network protocols and low-power operation
  - Deployment scale and testbed validation
  - Protocol efficiency and network-level evaluation
  - Real-world wireless conditions
weight_modifiers:
  problem_significance: 1.0
  novelty_contribution: 1.0
  technical_soundness: 1.0
  evaluation_quality: 1.1
  reproducibility: 1.2
  clarity_organization: 1.0
  fit_impact: 1.0
artifact_expectation: HIGH
  # Testbed or mote deployment evidence expected.
theory_system_balance: system_heavy
prior_scores:
  problem_significance: 55
  novelty: 50
  technical_soundness: 50
  evaluation_quality: 45
  reproducibility: 40
  clarity: 55
  fit_impact: 55
fatal_flaw_emphasis:
  - Simulation-only for protocol claims
  - Ignoring real-world wireless interference
  - Missing deployment scale justification
related_venues: [sensys, mobisys]
review_notes: >
  EWSN values real-world sensor network deployments.
  Testbed results significantly strengthen submissions.
```

## RTSS

```yaml
venue: RTSS
full_name: "IEEE Real-Time Systems Symposium"
type: systems_embedded
emphasis:
  - Real-time scheduling theory and schedulability analysis
  - Timing guarantees (deadline miss, WCDFP, response-time bounds)
  - AI/ML for real-time systems and real-time AI inference (5y award trend 2020-2025)
  - GPU scheduling and heterogeneous accelerator timing
  - Probabilistic / stochastic real-time analysis
  - Memory hierarchy (DRAM/cache/coherence) timing predictability
  - Distributed RT, fault-tolerance, mixed-criticality
weight_modifiers:
  problem_significance: 1.0
  novelty_contribution: 1.0
  technical_soundness: 1.2   # Formal rigor required for RT claims (NP-hard / WCDFP / Monte Carlo lineage)
  evaluation_quality: 1.1    # Adversarial / stress-test workloads expected
  reproducibility: 1.0       # Simulation acceptable; AE optional, not enforced like EuroSys
  clarity_organization: 1.0
  fit_impact: 1.0
  imrad_compliance: 1.0      # NEW axis 8 (mmedici 7-section apply matrix); calibrated 2026-05-10 from 13 RTSS Best Paper blind scoring
artifact_expectation: MEDIUM
  # Simulation-based evaluation acceptable. Hardware prototype or AE is a positive signal but not required.
  # AWS / cloud reproducibility increasingly cited (2023-2025 best paper trend).
theory_system_balance: balanced
  # RTSS bridges scheduling theory (formal proofs, complexity bounds) and embedded/edge systems practice.
  # Best Paper 10-yr distribution (2016-2025): scheduling theory ~12, AI/ML & GPU 6, memory 5,
  # probabilistic 4, edge 3, safety/FT 4, robotics 3, WCET 3.
prior_scores:
  problem_significance: 55
  novelty: 50
  technical_soundness: 50
  evaluation_quality: 45
  reproducibility: 40
  clarity: 60
  fit_impact: 55
  imrad_compliance: 50       # NEW axis 8 prior; venue-typical (not Best-Paper-typical)
# Observed Best-Paper-typical scores (n=13, 2016-2025 Best/Outstanding/Student blind scored 2026-05-10):
# These are TARGET REFERENCES (upper-tail), NOT priors. Do NOT use as venue mean baseline.
#   PS≈92  NV≈91  TS≈89  EV≈89  RP≈77  CL≈91  FI≈95  IM≈83  (all on 0-100 scale, /5×100)
# Best Paper raw level mean (1-5): PS=4.62 NV=4.54 TS=4.46 EV=4.46 RP=3.85 CL=4.54 FI=4.77 IM=4.15
# Reproducibility (RP) shows highest spread (std=0.77, range 3-5) -- single discriminator axis
# at Best-Paper tier; consistent with MEDIUM artifact expectation (no AE enforcement).
fatal_flaw_emphasis:
  - Real-time claims without worst-case or probabilistic timing bound (NP-hard / WCDFP / Monte Carlo lineage)
  - Missing deadline-miss / queue-overflow characterization under adversarial workload
  - ML/AI scheduling claims without timing certificate or schedulability witness
  - Cherry-picked workload (fails on Per/Tran/MERGED diversity expected at RTSS)
  - Overclaiming GPU/edge speedup without hardware-detail or rental reproducibility
related_venues: [rtcsa, eurosys, sensys, algorithms_scheduling]
review_notes: >
  RTSS is the flagship IEEE real-time systems venue. CFP Track 1 (Foundations) covers
  scheduling theory + AI-for-RT; Track 2 (Design+Apps) covers CPS + RT-for-AI + HW-SW + IoT.
  Submission rule: 11 pages technical + unlimited bibliography (camera-ready 12 pages).
  IEEEtran v1.8b conference template required (IEEE generic, no RTSS-specific sample.tex).
  Double-anonymous review per TCRTS policy (https://cmte.ieee.org/tcrts/double-anonymous-submission-requirements/);
  references must NOT be anonymized (third-person self-cite + full reference visible).
  Best Paper trend 2020-2025: AI/ML inference + RT scheduling won 5 consecutive years
  (Liu 2020 priority inversion in ML pipelines, Jellyfish 2022 SLO+DL adaptation,
  Progressive Neural Compression 2023 best student, LeMix 2025 LLM multi-GPU outstanding).
  Reviewers expect: schedulability witness, formal timing bound, adversarial workload coverage,
  and (for AI/ML papers) certificate-style guarantee not just empirical recall.
  Calibrated 2026-05-10 against 13 RTSS Best/Outstanding/Student Paper Awards 2016-2025 blind
  scoring (P006 STEP47b, BG-A/B/C/D + synthesis): typical Best Paper attains >=4 on tech_soundness
  / evaluation_quality / clarity / fit_impact in 12+/13 cases; reproducibility is the single
  discriminator (3-5 range, std=0.77) consistent with MEDIUM artifact expectation; IMRaD
  compliance (NEW axis 8, mmedici 7-section apply matrix) attains >=4 in 11/13 cases (mean=4.15,
  std=0.66, weight=10, modifier=1.0). Priors retained as venue-typical estimates (not Best-tier
  laundering); observed Best-Paper means recorded as upper-tail reference only.
```

## Algorithms / Scheduling (Theory-heavy venues)

```yaml
venue: algorithms_scheduling
full_name: "Theory-heavy scheduling and algorithms venues"
type: theory
emphasis:
  - Formal assumptions and problem definition clarity
  - Correctness guarantees and proofs
  - Adversarial case analysis
  - Computational complexity characterization
  - Gap between theoretical model and practical deployment
weight_modifiers:
  problem_significance: 1.0
  novelty_contribution: 1.2   # Novelty is primary criterion
  technical_soundness: 1.3    # Proof correctness is critical
  evaluation_quality: 0.8     # Empirical evaluation less central
  reproducibility: 0.7        # Proofs are the primary artifact
  clarity_organization: 1.1   # Clear notation and exposition matter
  fit_impact: 1.0
artifact_expectation: LOW
  # Proofs are the primary artifact. Code is a bonus.
theory_system_balance: theory_heavy
prior_scores:
  problem_significance: 50
  novelty: 50
  technical_soundness: 55  # proofs expected
  evaluation_quality: 45
  reproducibility: 50  # algorithms are reproducible
  clarity: 50
  fit_impact: 50
fatal_flaw_emphasis:
  - Incorrect or incomplete proofs
  - Unrealistic assumptions not acknowledged
  - Mismatch between theorem conditions and evaluation setup
related_venues: [rtcsa]
review_notes: >
  For theory-heavy venues, proof correctness is paramount.
  Evaluate whether assumptions match the claimed application domain.
  Empirical evaluation should match theorem conditions.
```
