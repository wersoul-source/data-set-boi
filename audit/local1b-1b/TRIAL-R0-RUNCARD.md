# Trial-Train R0 Run Card (Bro order 2026-10-13: original plan, conversation first)

## Code (verified this VM)
- Repo: `wersoul-source/BOI-X-1` @ `a7f8acf` (PR #2 merged ✓)
- `load_checkpoint` accepts weights-only blobs ✓ (no KeyError)
- `preflight_train.py` + `train_bootstrap01_v0.py` present ✓
- Tokenizer lock `911cf502…` == dataset lock ✓

## Data (conversation 1B trial)
- Source: `wersoul/RM-DataSet-BOI` → `sealed/phase3-sealed/` + `sealed/packs/pack-06..12/`
  (also local: `apps/mafb-02-tsdc/output/{phase3-sealed,packs/pack-*}/`)
- Size: 1,077,064,999 tokens / 24,682,666 records (train/val/test splits inside each pack)
- Format: `<split>-shard-NNN/{tokens.bin (uint16 LE), loss_mask.bin, provenance.jsonl}`
- Gate D audit: `audit/dataset_audit.json` — exact 0 ✅, near-dup ~0 ✅,
  template-prefix + EN-format MISSED (documented, Bro waived for R0 trial)

## Init weights
- `kaggle-ckpt-round2-repeat/best_model.pt` (L2.4186, sha `af567845…0c6096`, weights-only)

## Suggested R0 (short look, not full run)
1. Preflight first (must exit 0).
2. Conversation data only (Bro's original plan; knowledge replay comes in full run).
3. bootstrap01 recipe (lr 3e-4, cosine, seed 42), fp16 on T4 allowed.
4. Run a bounded session (e.g. one 12h Kaggle session), eval probes each N updates.
5. STOP on: NaN / val-up-x3 / grad-blowup-x3 (directive §5).
6. Report back: loss curves + 14 probes before/after → Bro gives direction.

## Push
- Branch `train/x1-fe-2b-r1`, PR to master with handoff + gate JSONs (directive §7).
