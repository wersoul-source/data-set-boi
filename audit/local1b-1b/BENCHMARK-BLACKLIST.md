# BENCHMARK BLACKLIST (N14 enforcement, Bro order 2026-10-13)

## Rule (standing)
Named evaluation benchmarks MUST NOT enter any seal input — train, val, or test.
Rationale: a model that trained on the exam invalidates every eval built on it.
This is an N14 release blocker ("benchmark contamination without explicit
approved exception"); no exception is approved for any item below.

## Blacklisted (with evidence)
1. **mt-bench-thai** (ThaiLLM-Leaderboard, 146 N11 recs X1-SRC-0024) — external
   benchmark Q&A, was sealed in pack-06 (2026-10-11). REMOVED in pack-06v2
   (2026-10-13). N11 files retained on disk/HF marked excluded.
2. **Future named benchmarks** (MMLU/MMMLU/ARC/HellaSwag/BBQ/ThaiExam etc.) —
   screen every new source's upstream: if derived from a benchmark, refuse intake.

## Allowed (narrowed per Dang 2026-10-13: default REJECT, prove per case)
- ~~Source's own test split~~ REVERSED: public datasets' test splits are DEFAULT
  REJECTED (benchmarks harvest them). kobkrit `mari_test.csv` REMOVED from seal
  2026-10-13 (pack-06v2); re-admit only with per-case proof it is not benchmarked.
- Our N15 splits (romanization/oasst2 "test" = our hash assignment, not the
  source's) remain allowed: no external benchmark can target our private split.
- Content screening (13-gram vs known benchmark texts) runs at every seal
  regardless of source name; cross-split extreme-hash gate enforces 0.

## Our val/test hygiene (for the "don't guess the exam" order)
- Splits assigned by split_family hash (N15), verified: one lineage in exactly
  one split (check in every PACK-MANIFEST, all PASS).
- Known residual risk (documented, accepted): near-duplicate texts from different
  families can land in different splits (template siblings). Mitigation: global
  exact-dedup + QA05 paired-exception rule. No action beyond documentation.
