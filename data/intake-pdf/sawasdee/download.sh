#!/bin/bash
# Download สวัสดี 1-8 via gdown (handles Drive confirm token)
set -e
mkdir -p sawasdee
# Example IDs extracted from thaiconsulatela page (20 files) - add full list here after re-scrape
# gdown https://drive.google.com/uc?id=FILE_ID -O sawasdee/s1-textbook.pdf
echo "Run: pip install gdown"
echo "Then gdown each Drive link from https://thaiconsulatela.thaiembassy.org/th/page/book"
# Curriculum direct (small, already in repo as curriculum_s1-6.pdf if fetched)
curl -L -o sawasdee/curriculum_s1-6.pdf "https://image.mfa.go.th/mfa/0/z7yQ.../หลักสูตรหนังสือเรียนภาษาไทยสวัสดี_1-6.pdf" 2>/dev/null || echo "curriculum fetch needs manual URL"
