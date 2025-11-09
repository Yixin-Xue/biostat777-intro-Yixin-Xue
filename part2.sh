#!/usr/bin/env bash
set -euo pipefail

echo "== Project 1 — Part 2 =="
echo "[working dir] $(pwd)"
echo

# 1) Download the file
RAW_URL="https://raw.githubusercontent.com/stephaniehicks/jhustatprogramming2025/main/projects/01-project/students.csv"

echo "---- 1) Ensure students.csv exists (download or create) ----"
if [ ! -f "students.csv" ]; then
  echo "[info] students.csv not found. Trying to download from course repo..."
  if command -v curl >/dev/null 2>&1; then
    curl -fsSLo students.csv "$RAW_URL" || true
  elif command -v wget >/dev/null 2>&1; then
    wget -q -O students.csv "$RAW_URL" || true
  else
    echo "[warn] Neither curl nor wget found."
  fi
fi

# If download failed or tools missing, create from assignment text
if [ ! -s "students.csv" ]; then
  echo "[fallback] Creating students.csv from assignment contents..."
  cat <<'EOF' > students.csv
ID,Name,Age,Gender,Grade,Subject
1,Alice,20,F,88,Math
2,Bob,22,M,76,History
3,Charlie,23,M,90,Math
4,Diana,21,F,85,Science
5,Eve,20,F,92,Math
6,Frank,22,M,72,History
7,Grace,23,F,78,Science
8,Heidi,21,F,88,Math
9,Ivan,20,M,85,Science
10,Judy,22,F,79,History
EOF
fi
echo "[ok] students.csv ready."
echo

# 2) Display the contents of students.csv
echo "---- 2) cat students.csv ----"
cat students.csv
echo

# 3) First 5 lines
echo "---- 3) head -n 5 students.csv ----"
head -n 5 students.csv
echo

# 4) Last 3 lines
echo "---- 4) tail -n 3 students.csv ----"
tail -n 3 students.csv
echo


# 5) Count lines
echo "---- 5) wc -l students.csv ----"
wc -l < students.csv
echo


# 6) Students taking Math
echo '---- 6) grep ",Math$" students.csv ----'
grep ",Math$" students.csv || true
echo

# 7) Female students
echo "---- 7) Female students (Gender == F) ----"
# Using awk for strict column match (skip header)
awk -F, 'NR>1 && $4=="F" {print}' students.csv
echo

# 8) Sort by Age ascending (keep header)
echo "---- 8) Sort by Age ascending ----"
head -n 1 students.csv
tail -n +2 students.csv | sort -t',' -k3,3n
echo


# 9) Unique subjects
echo "---- 9) Unique subjects ----"
cut -d, -f6 students.csv | tail -n +2 | sort | uniq
echo

# 10) Average grade
echo "---- 10) Average Grade ----"
awk -F, 'NR>1 {sum+=$5; n++} END {if(n>0) printf("%.2f\n", sum/n); else print "NA"}' students.csv  

# 11) Replace Math with Mathematics
echo "---- 11) Replace Math -> Mathematics ----"
sed 's/,Math$/,Mathematics/' students.csv
echo
