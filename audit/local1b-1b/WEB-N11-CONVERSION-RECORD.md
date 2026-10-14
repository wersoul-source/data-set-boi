# WEB-N11 Conversion Record (2026-10-11)

## ปัญหาที่เจอ + แก้แล้ว
- **ROOT CAUSE: checker บั๊ก** — `check_thanthakhat` เดิมบังคับว่า `์` ต้องตามหลัง
 พยัญชนะเท่านั้น → ตัดคำถูกต้องทิ้งผิดๆ (`สิทธิ์/โพธิ์/พันธุ์` = `ิ+์` / `ุ+์` ถูกหลักภาษา)
 รอบแรก hard_fail 46,248 (romanization โดนผิด 41,748)
- **FIX:** `engines/thai_quality.py` — อนุญาต `์` หลังพยัญชนะ **หรือสระบน/ล่าง**
 (`ัิีึืุู็`); เพิ่มกันวรรณยุกต์หลังนิคหิต (`ํ+่` = ผิดจริง)
- **ผลหลังแก้:** kept **669,384 → 715,178 (+45,794)**, hard_fail เหลือ **455**
- hard_fail ที่เหลือ = ของเสียจริง (สุ่มตรวจแล้ว): `ได้่` (ไม้โทซ้อน, openthaigpt 213),
 วรรณยุกต์บนนิคหิต (wangchan), โครงสร้างสระผิด (han)

## ผลแปลง (10 sources → X1-SRC-0019..0028)
| key | read | kept | hard_fail | norm(ํ→ำ) | split | cat |
|---|---|---|---|---|---|---|
| kobkrit_test_intent | 16175 | 16172 | 3 | 1 | train | 04_service |
| tokenine_catareeya | 2000 | 2000 | 0 | 0 | validation | 04_service |
| thaiaqa_v1 | 12668 | 12667 | 1 | 761 | train | 06_ethics |
| openthaigpt_qa_multiturn | 11982 | 11769 | 213 | 314 | train | 02_spoken |
| pythainlp_oasst2_thai | 306 | 304 | 2 | 7 | train | 02_spoken |
| mt_bench_thai | 146 | 146 | 0 | 35 | train | 01_written |
| thai_romanization | 647352 | 647288 | 64 | 3 | train | 03_translit |
| seadialogues | 4000 | 3999 | 1 | 1471 | train | 09_identity |
| han_instruction | 15989 | 15972 | 17 | 3358 | train | 01_written |
| wangchan_multiturn | 5014 | 4861 | 153 | 2616 | train | 02_spoken |
| **รวม** | **713632** | **715178** | **455** | **~8.5k** | — | — |

(kept รวม 715,178: read 713,632 + catareeya แยก user→assistant pairs ได้เกิน read;
นิยาม read = source rows, kept = N11 records)

## Verify
- **Schema 17 fields: PASS 715,178/715,178** (required/enum/pattern/content_sha256/const)
- license_status ถูกต้อง: SA(roman+seadlg+han+wangchan ≈ 672k) = `verified_training_allowed`;
  Apache/CC-BY (≈ 43k) = `verified_training_and_distribution_allowed`
- causal_text format: QA/dialogue = `ผู้ใช้:/ผู้ช่วย:`, intent = `+เจตนา:`, roman = `คำ:/คำอ่าน:`
- seal projection (`*.seal.jsonl`: text+provenance, compiler=mafb-03-web, synthetic flag) พร้อมป้อน seal pipeline

## เรื่องค้างให้ Bro ตัดสิน (3 ข้อ)
1. **split concentration** — 9/10 families ลง train, มีแค่ catareeya ลง validation,
 test = 0 (เป็นไปตามกฎ N15 deterministic ไม่ใช่บั๊ก; แต่ val/test จะไม่มีข้อมูล web)
 → ถ้าต้องการ web ใน val/test ต้องแตก split_family_id ให้ละเอียดกว่านี้ (เช่น ต่อท้าย domain/topic)
2. **synthetic-data** — thaiaqa (nemotron), wangchan (WangchanThaiInstruct), seadialogues
 (gpt4omini/gemini/aya/llama31) เป็น output จาก LLM ตัวอื่น มี flag `provenance.synthetic=true`
 ไว้กรองแล้ว → จะเก็บไว้หรือตัดออกก่อน seal?
3. **ขั้นตอนถัดไป** — seal ไฟล์ `*.seal.jsonl` เข้า phase3-sealed ต่อเลยไหม
 (ต้องแก้ seal_phase3.py ให้อ่าน input ใหม่ + dedup กับ sealed pools เดิม)
