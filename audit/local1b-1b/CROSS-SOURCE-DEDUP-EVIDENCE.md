# Cross-Source Duplicate Evidence (Bro order 2026-10-11: check remaining vs remaining, with proof)

## Method
URL equality (same article) + normalized-title equality + blake2b content-hash
on overlapping titles. Measured on full files, not samples.

## Findings (numbers, not estimates)
1. **ThaiSum-sub (22k) vs TR-TPBS: 13,342 same URLs (60.7% of ThaiSum)** —
   test/val splits were drawn from the same outlet pool. PROOF: url sets intersect.
2. **thairath-222 ⊆ tr-tpbs 100%** (222,553/222,553 urls) — the file is fully
   contained. thaipbs-111 ∩ tr-tpbs = 72,782/92,856 (78%).
   thairath ∩ thaipbs = 0 (different outlets, sane).
3. **thaisum ∩ thwiki titles = 9** — negligible, independent.
4. **chain_unique ∩ thwiki titles = 2,226 but identical-text = 0** — same headword,
   different content (guide vs encyclopedia). Both keepable; seal exact-dedup is
   the final net for byte-identical cases.
5. **simplewiki ∩ gutenberg-kids titles = 13** (book-about-book articles, e.g.
   Cinderella) — different genres/texts; seal dedup covers identicals.

## Decision executed (news pool)
- DROP thairath-222 file (100% contained in tr-tpbs).
- Intake order with URL-dedup (first-seen wins):
  tr-tpbs.csv → thaipbs-111_final.csv → ThaiSum test/val (skip seen urls).
- Expected unique news articles ≈ 310,926 + ~20,074 + ~8,658 ≈ **~340k**.

## Standing rule (reusable)
- "dup 0 vs sealed" ≠ "dup 0 overall". Every new source must be checked
  against remaining unsealed sources (URL/title/hash) BEFORE its pack,
  with numbers recorded here.
