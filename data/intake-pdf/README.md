# Intake PDF — ชุดโหลดง่าย (2026-09-12)

**VM:** `/tmp/opencode/` → GitHub `data/intake-pdf/` (small files pushed, large via manifest)

## โครงสร้าง
- `sawasdee/` — สวัสดี 1-8 (MFA) 1.19GB 20 ไฟล์ — ใหญ่เกิน GitHub 100MB/ไฟล์ → เก็บ manifest + download.sh + curriculum 251K (ดู s/curriculum_s1-6.pdf)
- `thai-corpora/` — Vajirayana TLC/TNHC + พจนานุกรม (13M)
- `thai-easy/` — ไวยากรณ์/วรรณคดีไทย (8M: finearts 3M, thai_grammar 1.8M, udru 3.3M)
- `thai basic.pdf` etc (ถ้ามี) — เดิม 7 เล่ม 70M ยังอยู่

## วิธีดูดสวัสดีเต็มชุด
```bash
pip install gdown
bash data/intake-pdf/sawasdee/download.sh
# หรือดูที่ https://thaiconsulatela.thaiembassy.org/th/page/book (20 Drive links)
```

ผลิตด้วย: `tesseract tha+eng`, `pdftotext`, `tokenizers` vocab 4096
