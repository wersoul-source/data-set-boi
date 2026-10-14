# Sealed Pack File Format (for Gate D automation — Dang)

All packs under `sealed/<pack>/` in `wersoul/RM-DataSet-BOI` (+ local
`apps/mafb-02-tsdc/output/packs/<pack>/`, `output/phase3-sealed/`).

## Layout per pack
- `<split>-shard-<NNN>/tokens.bin` — uint16 little-endian token IDs, concatenated.
  One record = ids + EOS(1). Shards flush at ≥10M tokens (shards may exceed cap;
  records never straddle a shard boundary).
- `<split>-shard-<NNN>/loss_mask.bin` — 1 byte per token: 1 = train, 0 = PAD tail.
- `<split>-shard-<NNN>/provenance.jsonl` — one JSON per record:
  `record_id` (X1-REC-...), `lineage_family_id`, `split`, `start`, `end`
  (token offsets into that shard's tokens.bin, end EXCLUSIVE, last id = EOS).
- `PACK-MANIFEST.json` (phase3: `SEAL-MANIFEST.json`) — splits{records,tokens,
  eos,pad,unknown}, shards[{split,shard,tokens,padding,records,tokens_sha256,
  loss_mask_sha256}], qa{...}, approvals.
- `kept_hashes.txt` — blake2b-16 of normalized text per kept record
  (for cross-pack dedup state; packs 06+).
- `MASTER-MANIFEST.json` (audit/) — all packs + totals (1,077,064,999 tokens).

## Invariants (verified per pack, verify_fails=[] in every manifest)
- ids in 0..4095, no BOS anywhere (tokenizer has none; never injected).
- exactly one EOS per record (last token of [start:end)).
- padding tail-only, mask consistent.
- record_id globally unique; one lineage_family_id lives in exactly one split.
- unknown (id 3) rate ≤ 2% per split.
- content_sha256 in N11 source records = sha256(causal_text UTF-8).

## Text reconstruction (for Gate D text-level metrics)
`text = tokenizer.decode(ids[start:end-1])` (drop EOS; PAD never inside range).
Tokenizer lock sha256 `911cf502…cae40d`, `configs/first-edition/tokenizer.json`.
N11 source texts: `apps/mafb-03-btds/output/n11-web/*.n11.jsonl` (`causal_text`).

## Tokenizer fertility (measured, X1 tok/1k chars)
TH ≈ 611 · EN ≈ 328 · code ≈ 379 · mixed ≈ 628.
