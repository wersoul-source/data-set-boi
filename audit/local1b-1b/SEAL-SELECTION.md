# SEAL SELECTION (Bro 2026-10-11: distribute into 100M packs, select only qualifying)

## EXCLUDED from all future seals (never intake/never pack)
- synthetic-3: thaiaqa_v1 (X1-SRC-0021), wangchan_multiturn (X1-SRC-0028),
  seadialogues (X1-SRC-0026) — Bro CUT order. N11 files stay on disk + HF archive
  (marked excluded), provenance.synthetic=true preserved for audit.
- chain thwiki-articles (01-raw/wiki/thwiki-articles.jsonl): 85% duplicate of
  books-text/thwiki (already E1+intake+N11). Use books-text version only.
- TH-knowledge (NSTDA HOLD — dangerous, do not touch).
- prachathai-67k (LFS unreachable + BY-NC conflict), chatterbotthai (unknown license).

## INCLUDED (qualifying) — 100M pack plan
- pack-06: web-N11 minus synthetic (kobkrit, catareeya, openthaigpt, oasst2,
  mtbench, romanization, han) + groupC-regen ≈ 100M
- pack-07: SimpleWiki N11 (X1-SRC-0029, SA BRO-0002) ≈ 147M -> trim/select to ~100M
  (overflow to pack-10 if needed)
- pack-08: thwiki N11 (X1-SRC-0030, SA BRO-0002) ≈ 172M -> select ~100M
- pack-09: ThaiSum-sub + TR-TPBS slice + Gutenberg-kids slice (MIT/PD) ≈ 100M
- pack-10: MAFB-02 top-up generation (03/06/08 + 09 identity room) ≈ 55-100M

## PENDING Bro approval (staged, not in packs yet)
- chain-unique ~20M (wikisource/wikibooks/wikiquote/wiktionary, SA -> needs BRO-0003)
- phase4-raw 50M already generated -> goes to pack-06 overflow or pack-10

## Rules carried into every pack
- N15 split rule unchanged (family-bucketed) + global exact-dedup state carried
  across packs (sealed_hashes incl. phase3-sealed pools).
- 100M nominal per pack; master manifest at the end.
