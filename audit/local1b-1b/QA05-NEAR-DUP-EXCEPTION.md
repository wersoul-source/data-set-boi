# QA05 Near-Duplicate Exception — Paired-Example Documentation (2026-10-11)

## วิธีตรวจ
- สแกน train.jsonl 300k แถวแรก, จับกลุ่มตาม (pattern_id, structural_signature),
  เทียบ Jaccard บน pythainlp word_tokenize, เกณฑ์ 0.55 ≤ J < 1.0
- Exact duplicates = 0 (ถูก dedup ออกที่ seal stage-1 แล้ว)

## 3 pairs ที่พบ → ทั้งหมดเป็น template siblings (by design, ไม่ใช่ contamination)

| # | J | pattern / signature | A | B | ต่างกันที่ |
|---|---|---|---|---|---|
| 1 | 0.56 | t-shop-yesno-32#x / formal/confirm/yesno_q | กระผมก็สัปดาห์หน้าเจ้าหน้าที่นัดรับหมอเพจร้านเอ่ยไหมครับ | กระผมก็สัปดาห์หน้าเจ้าหน้าที่วางมัดจำแอดมินร้านโรงเรียนเอ่ยไหมครับ | slot OBJ (`นัดรับหมอเพจร้าน` vs `วางมัดจำแอดมินร้านโรงเรียน`) |
| 2 | 0.60 | t-feel-whqf-26#x / casual/ask_wh/wh_q_front | ทำไมผมถ้าเควินวิดีโอคอลครับ | ทำไมผมถ้าเควินง้อครับ | slot TAIL (`วิดีโอคอล` vs `ง้อ`) |
| 3 | 0.57 | t-feel-whqf-26#x / casual/ask_wh/wh_q_front | ใครกับลุงโกรธครับ | ใครบ้างกับลุงรักครับ | slot (`ใคร/โกรธ` vs `ใครบ้าง/รัก`) |

## คำตัดสิน (exception)
- **KEEP ทั้ง 6 records** — ความต่างอยู่ที่ slot หลัก (verb/object) ซึ่งเปลี่ยนความหมายประโยค
  ไม่ใช่การ copy พร้อม paraphrase หลอกๆ
- คู่แบบนี้คือ **paired example ตามธรรมชาติของ template compiler** (minimal pair ต่างกัน 1 slot)
  มีคุณค่าต่อการเทรน (contrastive signal) ไม่ใช่ contamination
- QA05 จึง = **PASS with documented exception** (ไม่ใช่ PASS เปล่าๆ อีกต่อไป)

## หลักการที่ใช้ซ้ำได้ (root case)
- near-dup ที่ต่างกันที่ **content slot** (verb/object/person) = minimal pair → เก็บ
- near-dup ที่ต่างกันแค่ **function word / prefix สุภาพ** (`ครับ/ค่ะ`, `กระผม/ผม`) = template noise → ตัด
